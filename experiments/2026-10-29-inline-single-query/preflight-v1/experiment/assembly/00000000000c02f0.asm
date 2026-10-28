00000000000c02f0 <void inline_single_kernel<true, external_bloom::Page<6u, true>, unsigned long>(external_bloom::Page<6u, true> const&, unsigned long, unsigned long const*, unsigned int*)>:
   c02f0:	48 85 f6             	test   %rsi,%rsi
   c02f3:	0f 84 78 01 00 00    	je     c0471 <void inline_single_kernel<true, external_bloom::Page<6u, true>, unsigned long>(external_bloom::Page<6u, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x181>
   c02f9:	55                   	push   %rbp
   c02fa:	41 57                	push   %r15
   c02fc:	41 56                	push   %r14
   c02fe:	53                   	push   %rbx
   c02ff:	48 89 d0             	mov    %rdx,%rax
   c0302:	45 31 c0             	xor    %r8d,%r8d
   c0305:	49 b9 ef be ad de ef 	movabs $0xdeadbeefdeadbeef,%r9
   c030c:	be ad de
   c030f:	49 ba ef be ad de ef 	movabs $0xe6adbeefdeadbeef,%r10
   c0316:	be ad e6
   c0319:	41 bb ff ff ff ff    	mov    $0xffffffff,%r11d
   c031f:	c4 e2 7d 5a 05 c8 48 	vbroadcasti128 -0xbb738(%rip),%ymm0        # 4bf0 <typeinfo name for main::$_60+0x420>
   c0326:	f4 ff
   c0328:	c4 e2 7d 58 0d 73 2f 	vpbroadcastd -0xbd08d(%rip),%ymm1        # 32a4 <__abi_tag+0x2fe0>
   c032f:	f4 ff
   c0331:	c4 e2 7d 58 15 6e 2f 	vpbroadcastd -0xbd092(%rip),%ymm2        # 32a8 <__abi_tag+0x2fe4>
   c0338:	f4 ff
   c033a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
   c0340:	4a 8b 14 c0          	mov    (%rax,%r8,8),%rdx
   c0344:	4c 01 ca             	add    %r9,%rdx
   c0347:	c4 e3 fb f0 da 31    	rorx   $0x31,%rdx,%rbx
   c034d:	4c 31 d2             	xor    %r10,%rdx
   c0350:	48 01 da             	add    %rbx,%rdx
   c0353:	c4 63 fb f0 f2 0c    	rorx   $0xc,%rdx,%r14
   c0359:	4c 01 f2             	add    %r14,%rdx
   c035c:	c4 63 fb f0 fa 26    	rorx   $0x26,%rdx,%r15
   c0362:	4c 01 fa             	add    %r15,%rdx
   c0365:	48 31 d3             	xor    %rdx,%rbx
   c0368:	c4 e3 fb f0 d2 0d    	rorx   $0xd,%rdx,%rdx
   c036e:	48 01 d3             	add    %rdx,%rbx
   c0371:	49 31 de             	xor    %rbx,%r14
   c0374:	c4 e3 fb f0 db 24    	rorx   $0x24,%rbx,%rbx
   c037a:	49 01 de             	add    %rbx,%r14
   c037d:	4d 31 f7             	xor    %r14,%r15
   c0380:	c4 43 fb f0 f6 37    	rorx   $0x37,%r14,%r14
   c0386:	4d 01 f7             	add    %r14,%r15
   c0389:	4c 31 fa             	xor    %r15,%rdx
   c038c:	c4 43 fb f0 ff 11    	rorx   $0x11,%r15,%r15
   c0392:	4c 01 fa             	add    %r15,%rdx
   c0395:	48 31 d3             	xor    %rdx,%rbx
   c0398:	c4 e3 fb f0 d2 0a    	rorx   $0xa,%rdx,%rdx
   c039e:	48 01 d3             	add    %rdx,%rbx
   c03a1:	49 31 de             	xor    %rbx,%r14
   c03a4:	c4 e3 fb f0 db 20    	rorx   $0x20,%rbx,%rbx
   c03aa:	4c 01 f3             	add    %r14,%rbx
   c03ad:	49 31 df             	xor    %rbx,%r15
   c03b0:	c4 e3 fb f0 db 27    	rorx   $0x27,%rbx,%rbx
   c03b6:	4c 01 fb             	add    %r15,%rbx
   c03b9:	48 31 da             	xor    %rbx,%rdx
   c03bc:	c4 e3 fb f0 db 01    	rorx   $0x1,%rbx,%rbx
   c03c2:	48 01 da             	add    %rbx,%rdx
   c03c5:	c4 e3 7b f0 eb 18    	rorx   $0x18,%ebx,%ebp
   c03cb:	c4 e1 f9 6e db       	vmovq  %rbx,%xmm3
   c03d0:	48 c1 eb 20          	shr    $0x20,%rbx
   c03d4:	c4 63 7b f0 f2 1c    	rorx   $0x1c,%edx,%r14d
   c03da:	c4 e1 f9 6e e2       	vmovq  %rdx,%xmm4
   c03df:	48 c1 ea 20          	shr    $0x20,%rdx
   c03e3:	c4 e3 7b f0 db 1a    	rorx   $0x1a,%ebx,%ebx
   c03e9:	31 eb                	xor    %ebp,%ebx
   c03eb:	41 31 de             	xor    %ebx,%r14d
   c03ee:	c4 e3 7b f0 d2 1e    	rorx   $0x1e,%edx,%edx
   c03f4:	44 31 f2             	xor    %r14d,%edx
   c03f7:	8b 5f 08             	mov    0x8(%rdi),%ebx
   c03fa:	48 0f af 57 10       	imul   0x10(%rdi),%rdx
   c03ff:	c4 e2 eb f6 d3       	mulx   %rbx,%rdx,%rdx
   c0404:	0f b6 1f             	movzbl (%rdi),%ebx
   c0407:	c4 e2 e1 f7 d2       	shlx   %rbx,%rdx,%rdx
   c040c:	48 03 57 20          	add    0x20(%rdi),%rdx
   c0410:	c5 e1 6c dc          	vpunpcklqdq %xmm4,%xmm3,%xmm3
   c0414:	80 c3 03             	add    $0x3,%bl
   c0417:	c4 c2 61 f7 db       	shlx   %ebx,%r11d,%ebx
   c041c:	62 f2 7d 28 7c e3    	vpbroadcastd %ebx,%ymm4
   c0422:	c5 d1 72 d3 10       	vpsrld $0x10,%xmm3,%xmm5
   c0427:	c4 e3 65 38 dd 01    	vinserti128 $0x1,%xmm5,%ymm3,%ymm3
   c042d:	c5 dd df db          	vpandn %ymm3,%ymm4,%ymm3
   c0431:	c5 dd 72 d3 05       	vpsrld $0x5,%ymm3,%ymm4
   c0436:	c5 fd 6f e8          	vmovdqa %ymm0,%ymm5
   c043a:	c5 cd 76 f6          	vpcmpeqd %ymm6,%ymm6,%ymm6
   c043e:	c4 e2 55 90 34 a2    	vpgatherdd %ymm5,(%rdx,%ymm4,4),%ymm6
   c0444:	c5 e5 db d9          	vpand  %ymm1,%ymm3,%ymm3
   c0448:	c4 e2 6d 47 db       	vpsllvd %ymm3,%ymm2,%ymm3
   c044d:	c5 cd df e3          	vpandn %ymm3,%ymm6,%ymm4
   c0451:	31 d2                	xor    %edx,%edx
   c0453:	c4 e2 7d 17 e3       	vptest %ymm3,%ymm4
   c0458:	0f 94 c2             	sete   %dl
   c045b:	42 89 14 81          	mov    %edx,(%rcx,%r8,4)
   c045f:	49 ff c0             	inc    %r8
   c0462:	4c 39 c6             	cmp    %r8,%rsi
   c0465:	0f 85 d5 fe ff ff    	jne    c0340 <void inline_single_kernel<true, external_bloom::Page<6u, true>, unsigned long>(external_bloom::Page<6u, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
   c046b:	5b                   	pop    %rbx
   c046c:	41 5e                	pop    %r14
   c046e:	41 5f                	pop    %r15
   c0470:	5d                   	pop    %rbp
   c0471:	c5 f8 77             	vzeroupper
   c0474:	c3                   	ret
   c0475:	cc                   	int3
   c0476:	cc                   	int3
   c0477:	cc                   	int3
   c0478:	cc                   	int3
   c0479:	cc                   	int3
   c047a:	cc                   	int3
   c047b:	cc                   	int3
   c047c:	cc                   	int3
   c047d:	cc                   	int3
   c047e:	cc                   	int3
   c047f:	cc                   	int3
