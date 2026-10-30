"""Independent integer/bitmap oracle for the pinned BlowChoc public API.

This is validation code, never the timed baseline. It implements the documented
hash strings, distinct-position insertion and cost tie-breaking explicitly.
"""
MASK=(1<<64)-1
def common_hash(value):
    value=int(value);value^=value>>32;value=value*0xd6e8feb86659fd93&MASK
    value^=value>>32;value=value*0xd6e8feb86659fd93&MASK;value^=value>>32
    return value

def bucket(name,value,modulus):
    if name.startswith('linear'):a,b=int(name[6:]),0
    elif name.startswith('affine'):a,b=map(int,name[6:].split('-'))
    else:raise ValueError('unknown upstream hash string')
    value=int(value);swapped=((value<<32)^(value>>32))&MASK
    hashed=(a*(swapped^b))&MASK
    if modulus&(modulus-1)==0:
        bits=modulus.bit_length()-1
        return (hashed>>(64-bits))&(modulus-1)
    if modulus%2==0:hashed^=hashed>>32
    # Pinned upstream passes an int64 modulus to uint64 % int64. Numba0.61
    # selects signed i64 remainder and adjusts negatives to Python's modulo.
    # Match the actual public API, including hashes with bit63 set, rather than
    # silently substituting the mathematical unsigned-modulo interpretation.
    signed=hashed if hashed<(1<<63) else hashed-(1<<64)
    return signed%modulus

def positions(spec,value):
    k=spec['nbits'];version=spec['bitversion'];names=spec['bit_hashfuncs_str']
    if version=='random':return [bucket(name,value,512) for name in names]
    if version=='double':
        pos=bucket(names[0],value,512);step=2*bucket(names[1],value,256)+1
        return [(pos+i*step)%512 for i in range(k)]
    if version!='distinct':raise ValueError('unknown bit version')
    out=[]
    for i,name in enumerate(names):
        pos=bucket(name,value,512-i);at=0
        while at<len(out) and pos>=out[at]:pos+=1;at+=1
        out.insert(at,pos)
    return out

def blocks(spec,value):
    sf=bucket(spec['subfilter_hashfuncs_str'][0],value,spec['nsubfilters'])
    count=spec['nblocks_per_subfilter']
    return [sf*count+bucket(name,value,count) for name in spec['bucket_hashfuncs_str']]

def lookup(bitmap,spec,value):
    bits=positions(spec,value)
    return int(any(all((int(bitmap[block*8+bit//64])>>(bit%64))&1 for bit in bits) for block in blocks(spec,value)))

def insert(bitmap,spec,value):
    bits=positions(spec,value);options=blocks(spec,value)
    if len(options)==1:chosen=options[0]
    else:
        chosen=0;best=float('inf')
        for block in options:
            set_count=sum(int(bitmap[block*8+j]).bit_count() for j in range(8))
            # The original random-position method counts repeated positions
            # repeatedly; preserve that behavior rather than deduplicating.
            present=sum((int(bitmap[block*8+bit//64])>>(bit%64))&1 for bit in bits)
            new=spec['nbits']-present
            if new==0:chosen=block;break
            cost=spec['beta']**((new+set_count)/128.0)+spec['mu']*(new/spec['nbits'])
            if cost<best:best=cost;chosen=block
    for bit in bits:
        index=chosen*8+bit//64
        bitmap[index]=int(bitmap[index])|(1<<(bit%64))

def payload_budget(keys,requested_bpk):
    if keys<0 or requested_bpk<=0:raise ValueError('invalid sizing')
    bits=max(512,keys*requested_bpk)
    if bits>=1<<31:raise ValueError('capacity exceeds common native contract')
    size=128
    while size<=bits//8:size*=2
    return size

def fitting_blocks(budget):
    # Exact pinned allocator: 56 extra u64 elements, not 56 bytes.
    blocks=(budget-448)//64
    if blocks<1:raise ValueError('budget cannot hold BlowChoc backing allocation')
    if blocks%2==0:blocks-=1
    if blocks<1 or blocks*64+448>budget:raise ValueError('no fitting odd block count')
    return blocks
