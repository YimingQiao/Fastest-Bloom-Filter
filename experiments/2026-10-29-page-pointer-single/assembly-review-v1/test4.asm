
/home/yiming/projects/fastest-bf-lab/build/page-pointer-preflight-v1/native/worker/page_pointer_control:     file format elf64-x86-64


Disassembly of section .text:

0000000000013430 <pbf::PageBloomFilter<8u>::test(unsigned char const*, unsigned int) const>:
   13430:	push   %rbp
   13431:	mov    %rsp,%rbp
   13434:	push   %rbx
   13435:	mov    %rdi,%rbx
   13438:	mov    %rsi,%rdi
   1343b:	and    $0xffffffffffffffe0,%rsp
   1343f:	sub    $0x20,%rsp
   13443:	mov    %edx,%esi
   13445:	test   %rdi,%rdi
   13448:	je     13520 <pbf::PageBloomFilter<8u>::test(unsigned char const*, unsigned int) const+0xf0>
   1344e:	call   bb60 <pbf::Hash(unsigned char const*, unsigned int)>
   13453:	mov    (%rbx),%esi
   13455:	mov    %rax,0x10(%rsp)
   1345a:	mov    $0x1,%ecx
   1345f:	lea    0x3(%rsi),%eax
   13462:	shlx   %eax,%ecx,%eax
   13467:	dec    %eax
   13469:	vpbroadcastd %eax,%ymm1
   1346f:	mov    0x10(%rsp),%rax
   13474:	mov    %rdx,0x18(%rsp)
   13479:	shr    $0x20,%rax
   1347d:	rorx   $0x1a,%eax,%eax
   13483:	rorx   $0x18,0x10(%rsp),%edx
   1348b:	xor    %eax,%edx
   1348d:	rorx   $0x1c,0x18(%rsp),%eax
   13495:	xor    %eax,%edx
   13497:	mov    0x18(%rsp),%rax
   1349c:	mov    0x8(%rbx),%edi
   1349f:	shr    $0x20,%rax
   134a3:	rorx   $0x1e,%eax,%eax
   134a9:	xor    %eax,%edx
   134ab:	imul   0x10(%rbx),%rdx
   134b0:	{evex} vpsrld $0x10,0x10(%rsp),%xmm0
   134b9:	vmovdqa 0x10(%rsp),%xmm4
   134bf:	mov    %rdx,%rax
   134c2:	mul    %rdi
   134c5:	vinserti128 $0x1,%xmm0,%ymm4,%ymm0
   134cb:	vpand  %ymm1,%ymm0,%ymm0
   134cf:	vpsrld $0x5,%ymm0,%ymm3
   134d4:	vpcmpeqd %ymm1,%ymm1,%ymm1
   134d8:	movabs $0x1f0000001f,%rax
   134e2:	shlx   %rsi,%rdx,%rdx
   134e7:	add    0x20(%rbx),%rdx
   134eb:	vpgatherdd %ymm1,(%rdx,%ymm3,4),%ymm2
   134f1:	vpbroadcastq %rax,%ymm1
   134f7:	vpand  %ymm1,%ymm0,%ymm0
   134fb:	vpbroadcastd %ecx,%ymm1
   13501:	vpsllvd %ymm0,%ymm1,%ymm0
   13506:	vpandn %ymm0,%ymm2,%ymm2
   1350a:	vptest %ymm0,%ymm2
   1350f:	sete   %al
   13512:	vzeroupper
   13515:	mov    -0x8(%rbp),%rbx
   13519:	leave
   1351a:	ret
   1351b:	nopl   0x0(%rax,%rax,1)
   13520:	xor    %eax,%eax
   13522:	test   %edx,%edx
   13524:	jne    13515 <pbf::PageBloomFilter<8u>::test(unsigned char const*, unsigned int) const+0xe5>
   13526:	lea    -0xf54f(%rip),%rdi        # 3fde <pbf::PageBloomFilter<8u>::test(unsigned char const*, unsigned int) const::empty_key>
   1352d:	jmp    1344e <pbf::PageBloomFilter<8u>::test(unsigned char const*, unsigned int) const+0x1e>
