
/home/yiming/projects/fastest-bf-lab/build/page-pointer-preflight-v1/native/worker/page_pointer_control:     file format elf64-x86-64


Disassembly of section .text:

0000000000012d60 <pbf::PageBloomFilter<6u>::test(unsigned char const*, unsigned int) const>:
   12d60:	push   %rbp
   12d61:	mov    %rsp,%rbp
   12d64:	push   %rbx
   12d65:	mov    %rdi,%rbx
   12d68:	mov    %rsi,%rdi
   12d6b:	and    $0xffffffffffffffe0,%rsp
   12d6f:	sub    $0x20,%rsp
   12d73:	mov    %edx,%esi
   12d75:	test   %rdi,%rdi
   12d78:	je     12e60 <pbf::PageBloomFilter<6u>::test(unsigned char const*, unsigned int) const+0x100>
   12d7e:	call   bb60 <pbf::Hash(unsigned char const*, unsigned int)>
   12d83:	mov    (%rbx),%esi
   12d85:	mov    %rax,0x10(%rsp)
   12d8a:	mov    $0x1,%ecx
   12d8f:	lea    0x3(%rsi),%eax
   12d92:	shlx   %eax,%ecx,%eax
   12d97:	dec    %eax
   12d99:	vpbroadcastd %eax,%ymm1
   12d9f:	mov    0x10(%rsp),%rax
   12da4:	mov    %rdx,0x18(%rsp)
   12da9:	shr    $0x20,%rax
   12dad:	rorx   $0x1a,%eax,%eax
   12db3:	rorx   $0x18,0x10(%rsp),%edx
   12dbb:	xor    %eax,%edx
   12dbd:	rorx   $0x1c,0x18(%rsp),%eax
   12dc5:	xor    %eax,%edx
   12dc7:	mov    0x18(%rsp),%rax
   12dcc:	mov    0x8(%rbx),%edi
   12dcf:	shr    $0x20,%rax
   12dd3:	rorx   $0x1e,%eax,%eax
   12dd9:	xor    %eax,%edx
   12ddb:	imul   0x10(%rbx),%rdx
   12de0:	{evex} vpsrld $0x10,0x10(%rsp),%xmm0
   12de9:	vmovdqa 0x10(%rsp),%xmm4
   12def:	mov    %rdx,%rax
   12df2:	mul    %rdi
   12df5:	vinserti128 $0x1,%xmm0,%ymm4,%ymm0
   12dfb:	vpand  %ymm1,%ymm0,%ymm0
   12dff:	vmovdqa -0xea47(%rip),%ymm2        # 43c0 <bloom_filters::FastPatternBF::sparse_patterns_+0xe0>
   12e07:	vpsrld $0x5,%ymm0,%ymm3
   12e0c:	vpcmpeqd %ymm1,%ymm1,%ymm1
   12e10:	shlx   %rsi,%rdx,%rdx
   12e15:	add    0x20(%rbx),%rdx
   12e19:	vpgatherdd %ymm2,(%rdx,%ymm3,4),%ymm1
   12e1f:	movabs $0x1f0000001f,%rax
   12e29:	vmovdqa %ymm1,%ymm2
   12e2d:	vpbroadcastq %rax,%ymm1
   12e33:	vpand  %ymm1,%ymm0,%ymm0
   12e37:	vpbroadcastd %ecx,%ymm1
   12e3d:	vpsllvd %ymm0,%ymm1,%ymm0
   12e42:	vpandn %ymm0,%ymm2,%ymm2
   12e46:	vptest %ymm0,%ymm2
   12e4b:	sete   %al
   12e4e:	vzeroupper
   12e51:	mov    -0x8(%rbp),%rbx
   12e55:	leave
   12e56:	ret
   12e57:	nopw   0x0(%rax,%rax,1)
   12e60:	xor    %eax,%eax
   12e62:	test   %edx,%edx
   12e64:	jne    12e51 <pbf::PageBloomFilter<6u>::test(unsigned char const*, unsigned int) const+0xf1>
   12e66:	lea    -0xee8b(%rip),%rdi        # 3fe2 <pbf::PageBloomFilter<6u>::test(unsigned char const*, unsigned int) const::empty_key>
   12e6d:	jmp    12d7e <pbf::PageBloomFilter<6u>::test(unsigned char const*, unsigned int) const+0x1e>
