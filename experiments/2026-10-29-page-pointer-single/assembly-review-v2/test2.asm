
/home/yiming/projects/fastest-bf-lab/build/page-pointer-preflight-v1/native/worker/page_pointer_control:     file format elf64-x86-64


Disassembly of section .text:

000000000000a2c0 <pbf::PageBloomFilter<8u>::test(unsigned char const*, unsigned int) const [clone .constprop.0]>:
    a2c0:	test   %rsi,%rsi
    a2c3:	je     a3b0 <pbf::PageBloomFilter<8u>::test(unsigned char const*, unsigned int) const [clone .constprop.0]+0xf0>
    a2c9:	push   %rbp
    a2ca:	mov    %rdi,%r8
    a2cd:	mov    %rsi,%rdi
    a2d0:	mov    %rsp,%rbp
    a2d3:	and    $0xffffffffffffffe0,%rsp
    a2d7:	sub    $0x20,%rsp
    a2db:	call   a020 <pbf::Hash(unsigned char const*, unsigned int) [clone .constprop.0]>
    a2e0:	mov    (%r8),%esi
    a2e3:	mov    %rax,0x10(%rsp)
    a2e8:	mov    $0x1,%ecx
    a2ed:	lea    0x3(%rsi),%eax
    a2f0:	shlx   %eax,%ecx,%eax
    a2f5:	dec    %eax
    a2f7:	vpbroadcastd %eax,%ymm1
    a2fd:	mov    0x10(%rsp),%rax
    a302:	mov    %rdx,0x18(%rsp)
    a307:	shr    $0x20,%rax
    a30b:	rorx   $0x18,0x10(%rsp),%edx
    a313:	rorx   $0x1a,%eax,%eax
    a319:	xor    %eax,%edx
    a31b:	rorx   $0x1c,0x18(%rsp),%eax
    a323:	xor    %eax,%edx
    a325:	mov    0x18(%rsp),%rax
    a32a:	mov    0x8(%r8),%edi
    a32e:	shr    $0x20,%rax
    a332:	rorx   $0x1e,%eax,%eax
    a338:	xor    %eax,%edx
    a33a:	imul   0x10(%r8),%rdx
    a33f:	{evex} vpsrld $0x10,0x10(%rsp),%xmm0
    a348:	vmovdqa 0x10(%rsp),%xmm4
    a34e:	mov    %rdx,%rax
    a351:	mul    %rdi
    a354:	vinserti128 $0x1,%xmm0,%ymm4,%ymm0
    a35a:	vpand  %ymm1,%ymm0,%ymm0
    a35e:	vpsrld $0x5,%ymm0,%ymm3
    a363:	vpcmpeqd %ymm1,%ymm1,%ymm1
    a367:	movabs $0x1f0000001f,%rax
    a371:	shlx   %rsi,%rdx,%rdx
    a376:	add    0x20(%r8),%rdx
    a37a:	vpgatherdd %ymm1,(%rdx,%ymm3,4),%ymm2
    a380:	vpbroadcastq %rax,%ymm1
    a386:	vpand  %ymm1,%ymm0,%ymm0
    a38a:	vpbroadcastd %ecx,%ymm1
    a390:	vpsllvd %ymm0,%ymm1,%ymm0
    a395:	vpandn %ymm0,%ymm2,%ymm2
    a399:	vptest %ymm0,%ymm2
    a39e:	sete   %al
    a3a1:	vzeroupper
    a3a4:	leave
    a3a5:	ret
    a3a6:	cs nopw 0x0(%rax,%rax,1)
    a3b0:	xor    %eax,%eax
    a3b2:	ret
