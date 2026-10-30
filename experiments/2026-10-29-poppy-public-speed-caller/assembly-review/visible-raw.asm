00000000000344f0 <compare_benchmark::visible_lookup::<compare_benchmark::PoppyPublic<0>, true>>:
   344f0:	push   %rbp
   344f1:	push   %r15
   344f3:	push   %r14
   344f5:	push   %r13
   344f7:	push   %r12
   344f9:	push   %rbx
   344fa:	sub    $0x48,%rsp
   344fe:	mov    %rdx,0x8(%rsp)
   34503:	mov    %r8,0x10(%rsp)
   34508:	cmp    %r8,%rdx
   3450b:	jne    3457e <compare_benchmark::visible_lookup::<compare_benchmark::PoppyPublic<0>, true>+0x8e>
   3450d:	mov    %rcx,%r15
   34510:	mov    %rdx,%r13
   34513:	mov    %rsi,%r12
   34516:	mov    %rdi,%r14
   34519:	xor    %ebp,%ebp
   3451b:	nopl   0x0(%rax,%rax,1)
   34520:	lea    0x1(%rbp),%rbx
   34524:	mov    (%r12,%rbp,8),%rax
   34528:	mov    %rax,%rcx
   3452b:	shr    $0x20,%rcx
   3452f:	xor    %rax,%rcx
   34532:	movabs $0xd6e8feb86659fd93,%r8
   3453c:	imul   %r8,%rcx
   34540:	mov    %rcx,%rax
   34543:	shr    $0x20,%rax
   34547:	xor    %rcx,%rax
   3454a:	imul   %r8,%rax
   3454e:	mov    %rax,%rsi
   34551:	shr    $0x20,%rsi
   34555:	xor    %rax,%rsi
   34558:	mov    %r14,%rdi
   3455b:	call   ff3a0 <<poppy_filters::bloom::v2::BloomFilter>::contains_bytes::<[u8; 8]>>
   34560:	movzbl %al,%eax
   34563:	mov    %eax,(%r15,%rbp,4)
   34567:	mov    %rbx,%rbp
   3456a:	cmp    %rbx,%r13
   3456d:	jne    34520 <compare_benchmark::visible_lookup::<compare_benchmark::PoppyPublic<0>, true>+0x30>
   3456f:	add    $0x48,%rsp
   34573:	pop    %rbx
   34574:	pop    %r12
   34576:	pop    %r13
   34578:	pop    %r14
   3457a:	pop    %r15
   3457c:	pop    %rbp
   3457d:	ret
   3457e:	lea    0x19c91b(%rip),%rax        # 1d0ea0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.52.llvm.3671060894988460240+0xb0>
   34585:	mov    %rax,0x18(%rsp)
   3458a:	movq   $0x1,0x20(%rsp)
   34593:	movq   $0x8,0x28(%rsp)
   3459c:	vxorps %xmm0,%xmm0,%xmm0
   345a0:	vmovups %xmm0,0x30(%rsp)
   345a6:	lea    0x19c903(%rip),%r8        # 1d0eb0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.52.llvm.3671060894988460240+0xc0>
   345ad:	lea    0x8(%rsp),%rsi
   345b2:	lea    0x10(%rsp),%rdx
   345b7:	lea    0x18(%rsp),%rcx
   345bc:	xor    %edi,%edi
   345be:	call   *0x1a1b34(%rip)        # 1d60f8 <_DYNAMIC+0x2f8>
   345c4:	int3
   345c5:	int3
   345c6:	int3
   345c7:	int3
   345c8:	int3
   345c9:	int3
   345ca:	int3
   345cb:	int3
   345cc:	int3
   345cd:	int3
   345ce:	int3
   345cf:	int3

