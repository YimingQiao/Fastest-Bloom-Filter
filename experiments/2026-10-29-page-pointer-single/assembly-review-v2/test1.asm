
/home/yiming/projects/fastest-bf-lab/build/page-pointer-preflight-v1/native/worker/page_pointer_control:     file format elf64-x86-64


Disassembly of section .text:

000000000000a1c0 <pbf::PageBloomFilter<6u>::test(unsigned char const*, unsigned int) const [clone .constprop.0]>:
    a1c0:	test   %rsi,%rsi
    a1c3:	je     a2b8 <pbf::PageBloomFilter<6u>::test(unsigned char const*, unsigned int) const [clone .constprop.0]+0xf8>
    a1c9:	push   %rbp
    a1ca:	mov    %rdi,%r8
    a1cd:	mov    %rsi,%rdi
    a1d0:	mov    %rsp,%rbp
    a1d3:	and    $0xffffffffffffffe0,%rsp
    a1d7:	sub    $0x20,%rsp
    a1db:	call   a020 <pbf::Hash(unsigned char const*, unsigned int) [clone .constprop.0]>
    a1e0:	mov    (%r8),%esi
    a1e3:	mov    %rax,0x10(%rsp)
    a1e8:	mov    $0x1,%ecx
    a1ed:	lea    0x3(%rsi),%eax
    a1f0:	shlx   %eax,%ecx,%eax
    a1f5:	dec    %eax
    a1f7:	vpbroadcastd %eax,%ymm1
    a1fd:	mov    0x10(%rsp),%rax
    a202:	mov    %rdx,0x18(%rsp)
    a207:	shr    $0x20,%rax
    a20b:	rorx   $0x18,0x10(%rsp),%edx
    a213:	rorx   $0x1a,%eax,%eax
    a219:	xor    %eax,%edx
    a21b:	rorx   $0x1c,0x18(%rsp),%eax
    a223:	xor    %eax,%edx
    a225:	mov    0x18(%rsp),%rax
    a22a:	mov    0x8(%r8),%edi
    a22e:	shr    $0x20,%rax
    a232:	rorx   $0x1e,%eax,%eax
    a238:	xor    %eax,%edx
    a23a:	imul   0x10(%r8),%rdx
    a23f:	{evex} vpsrld $0x10,0x10(%rsp),%xmm0
    a248:	vmovdqa 0x10(%rsp),%xmm4
    a24e:	mov    %rdx,%rax
    a251:	mul    %rdi
    a254:	vinserti128 $0x1,%xmm0,%ymm4,%ymm0
    a25a:	vmovdqa -0x5ea2(%rip),%ymm2        # 43c0 <bloom_filters::FastPatternBF::sparse_patterns_+0xe0>
    a262:	vpand  %ymm1,%ymm0,%ymm0
    a266:	vpsrld $0x5,%ymm0,%ymm3
    a26b:	vpcmpeqd %ymm1,%ymm1,%ymm1
    a26f:	shlx   %rsi,%rdx,%rdx
    a274:	add    0x20(%r8),%rdx
    a278:	vpgatherdd %ymm2,(%rdx,%ymm3,4),%ymm1
    a27e:	movabs $0x1f0000001f,%rax
    a288:	vmovdqa %ymm1,%ymm2
    a28c:	vpbroadcastq %rax,%ymm1
    a292:	vpand  %ymm1,%ymm0,%ymm0
    a296:	vpbroadcastd %ecx,%ymm1
    a29c:	vpsllvd %ymm0,%ymm1,%ymm0
    a2a1:	vpandn %ymm0,%ymm2,%ymm2
    a2a5:	vptest %ymm0,%ymm2
    a2aa:	sete   %al
    a2ad:	vzeroupper
    a2b0:	leave
    a2b1:	ret
    a2b2:	nopw   0x0(%rax,%rax,1)
    a2b8:	xor    %eax,%eax
    a2ba:	ret
