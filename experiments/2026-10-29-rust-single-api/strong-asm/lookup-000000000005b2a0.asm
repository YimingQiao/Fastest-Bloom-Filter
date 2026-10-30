000000000005b2a0 <compare_benchmark::lookup>:
   5b2a0:	41 56                	push   %r14
   5b2a2:	53                   	push   %rbx
   5b2a3:	48 83 ec 48          	sub    $0x48,%rsp
   5b2a7:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
   5b2ac:	4c 89 44 24 10       	mov    %r8,0x10(%rsp)
   5b2b1:	4c 39 c2             	cmp    %r8,%rdx
   5b2b4:	0f 85 c2 00 00 00    	jne    5b37c <compare_benchmark::lookup+0xdc>
   5b2ba:	48 83 fa 01          	cmp    $0x1,%rdx
   5b2be:	0f 85 90 00 00 00    	jne    5b354 <compare_benchmark::lookup+0xb4>
   5b2c4:	48 8b 06             	mov    (%rsi),%rax
   5b2c7:	48 8b 77 08          	mov    0x8(%rdi),%rsi
   5b2cb:	49 89 f0             	mov    %rsi,%r8
   5b2ce:	49 c1 e0 06          	shl    $0x6,%r8
   5b2d2:	4c 89 c2             	mov    %r8,%rdx
   5b2d5:	c4 e2 eb f6 d0       	mulx   %rax,%rdx,%rdx
   5b2da:	49 89 d1             	mov    %rdx,%r9
   5b2dd:	49 c1 e9 06          	shr    $0x6,%r9
   5b2e1:	49 39 f1             	cmp    %rsi,%r9
   5b2e4:	0f 83 e5 00 00 00    	jae    5b3cf <compare_benchmark::lookup+0x12f>
   5b2ea:	4c 8b 17             	mov    (%rdi),%r10
   5b2ed:	4f 8b 0c ca          	mov    (%r10,%r9,8),%r9
   5b2f1:	49 0f a3 d1          	bt     %rdx,%r9
   5b2f5:	73 6c                	jae    5b363 <compare_benchmark::lookup+0xc3>
   5b2f7:	49 bb 95 0a 22 27 b7 	movabs $0x517cc1b727220a95,%r11
   5b2fe:	c1 7c 51 
   5b301:	4c 0f af d8          	imul   %rax,%r11
   5b305:	44 8b 4f 58          	mov    0x58(%rdi),%r9d
   5b309:	45 89 ce             	mov    %r9d,%r14d
   5b30c:	41 f7 de             	neg    %r14d
   5b30f:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
   5b314:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
   5b31b:	00 00 00 00 00 
   5b320:	41 8d 14 1e          	lea    (%r14,%rbx,1),%edx
   5b324:	83 fa ff             	cmp    $0xffffffff,%edx
   5b327:	74 3e                	je     5b367 <compare_benchmark::lookup+0xc7>
   5b329:	c4 e3 fb f0 c0 3b    	rorx   $0x3b,%rax,%rax
   5b32f:	4c 01 d8             	add    %r11,%rax
   5b332:	48 89 c2             	mov    %rax,%rdx
   5b335:	c4 c2 eb f6 d0       	mulx   %r8,%rdx,%rdx
   5b33a:	48 89 d7             	mov    %rdx,%rdi
   5b33d:	48 c1 ef 06          	shr    $0x6,%rdi
   5b341:	48 39 f7             	cmp    %rsi,%rdi
   5b344:	73 7c                	jae    5b3c2 <compare_benchmark::lookup+0x122>
   5b346:	49 8b 3c fa          	mov    (%r10,%rdi,8),%rdi
   5b34a:	ff c3                	inc    %ebx
   5b34c:	48 0f a3 d7          	bt     %rdx,%rdi
   5b350:	72 ce                	jb     5b320 <compare_benchmark::lookup+0x80>
   5b352:	eb 16                	jmp    5b36a <compare_benchmark::lookup+0xca>
   5b354:	49 89 d0             	mov    %rdx,%r8
   5b357:	48 83 c4 48          	add    $0x48,%rsp
   5b35b:	5b                   	pop    %rbx
   5b35c:	41 5e                	pop    %r14
   5b35e:	e9 4d 30 00 00       	jmp    5e3b0 <<compare_benchmark::Fastbloom017 as compare_benchmark::Filter>::lookup_hashes>
   5b363:	31 c0                	xor    %eax,%eax
   5b365:	eb 0b                	jmp    5b372 <compare_benchmark::lookup+0xd2>
   5b367:	44 89 cb             	mov    %r9d,%ebx
   5b36a:	31 c0                	xor    %eax,%eax
   5b36c:	44 39 cb             	cmp    %r9d,%ebx
   5b36f:	0f 93 c0             	setae  %al
   5b372:	89 01                	mov    %eax,(%rcx)
   5b374:	48 83 c4 48          	add    $0x48,%rsp
   5b378:	5b                   	pop    %rbx
   5b379:	41 5e                	pop    %r14
   5b37b:	c3                   	ret
   5b37c:	48 8d 05 9d 05 05 00 	lea    0x5059d(%rip),%rax        # ab920 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0x1f0>
   5b383:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
   5b388:	48 c7 44 24 20 01 00 	movq   $0x1,0x20(%rsp)
   5b38f:	00 00 
   5b391:	48 c7 44 24 28 08 00 	movq   $0x8,0x28(%rsp)
   5b398:	00 00 
   5b39a:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
   5b39e:	c5 f8 11 44 24 30    	vmovups %xmm0,0x30(%rsp)
   5b3a4:	4c 8d 05 0d 11 05 00 	lea    0x5110d(%rip),%r8        # ac4b8 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0xd88>
   5b3ab:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
   5b3b0:	48 8d 54 24 10       	lea    0x10(%rsp),%rdx
   5b3b5:	48 8d 4c 24 18       	lea    0x18(%rsp),%rcx
   5b3ba:	31 ff                	xor    %edi,%edi
   5b3bc:	ff 15 76 41 05 00    	call   *0x54176(%rip)        # af538 <_DYNAMIC+0x3a8>
   5b3c2:	48 8d 15 97 11 05 00 	lea    0x51197(%rip),%rdx        # ac560 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0xe30>
   5b3c9:	ff 15 f1 3f 05 00    	call   *0x53ff1(%rip)        # af3c0 <_DYNAMIC+0x230>
   5b3cf:	48 8d 15 8a 11 05 00 	lea    0x5118a(%rip),%rdx        # ac560 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0xe30>
   5b3d6:	4c 89 cf             	mov    %r9,%rdi
   5b3d9:	ff 15 e1 3f 05 00    	call   *0x53fe1(%rip)        # af3c0 <_DYNAMIC+0x230>
   5b3df:	cc                   	int3

