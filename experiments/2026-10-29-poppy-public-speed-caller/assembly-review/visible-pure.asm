0000000000034430 <compare_benchmark::visible_lookup::<compare_benchmark::PoppyPublic<0>, false>>:
   34430:	push   %rbp
   34431:	push   %r15
   34433:	push   %r14
   34435:	push   %r13
   34437:	push   %r12
   34439:	push   %rbx
   3443a:	sub    $0x48,%rsp
   3443e:	mov    %rdx,0x8(%rsp)
   34443:	mov    %r8,0x10(%rsp)
   34448:	cmp    %r8,%rdx
   3444b:	jne    3449e <compare_benchmark::visible_lookup::<compare_benchmark::PoppyPublic<0>, false>+0x6e>
   3444d:	mov    %rdx,%r14
   34450:	test   %rdx,%rdx
   34453:	je     3448f <compare_benchmark::visible_lookup::<compare_benchmark::PoppyPublic<0>, false>+0x5f>
   34455:	mov    %rcx,%rbx
   34458:	mov    %rsi,%r15
   3445b:	mov    %rdi,%r12
   3445e:	xor    %r13d,%r13d
   34461:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   34470:	lea    0x1(%r13),%rbp
   34474:	mov    (%r15,%r13,8),%rsi
   34478:	mov    %r12,%rdi
   3447b:	call   ff3a0 <<poppy_filters::bloom::v2::BloomFilter>::contains_bytes::<[u8; 8]>>
   34480:	movzbl %al,%eax
   34483:	mov    %eax,(%rbx,%r13,4)
   34487:	mov    %rbp,%r13
   3448a:	cmp    %rbp,%r14
   3448d:	jne    34470 <compare_benchmark::visible_lookup::<compare_benchmark::PoppyPublic<0>, false>+0x40>
   3448f:	add    $0x48,%rsp
   34493:	pop    %rbx
   34494:	pop    %r12
   34496:	pop    %r13
   34498:	pop    %r14
   3449a:	pop    %r15
   3449c:	pop    %rbp
   3449d:	ret
   3449e:	lea    0x19c9fb(%rip),%rax        # 1d0ea0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.52.llvm.3671060894988460240+0xb0>
   344a5:	mov    %rax,0x18(%rsp)
   344aa:	movq   $0x1,0x20(%rsp)
   344b3:	movq   $0x8,0x28(%rsp)
   344bc:	vxorps %xmm0,%xmm0,%xmm0
   344c0:	vmovups %xmm0,0x30(%rsp)
   344c6:	lea    0x19c9e3(%rip),%r8        # 1d0eb0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.52.llvm.3671060894988460240+0xc0>
   344cd:	lea    0x8(%rsp),%rsi
   344d2:	lea    0x10(%rsp),%rdx
   344d7:	lea    0x18(%rsp),%rcx
   344dc:	xor    %edi,%edi
   344de:	call   *0x1a1c14(%rip)        # 1d60f8 <_DYNAMIC+0x2f8>
   344e4:	int3
   344e5:	int3
   344e6:	int3
   344e7:	int3
   344e8:	int3
   344e9:	int3
   344ea:	int3
   344eb:	int3
   344ec:	int3
   344ed:	int3
   344ee:	int3
   344ef:	int3

