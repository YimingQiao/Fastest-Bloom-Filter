000000000009f350 <void inline_single_kernel<true, external_bloom::Classical<6, false, true>, unsigned long>(external_bloom::Classical<6, false, true> const&, unsigned long, unsigned long const*, unsigned int*)>:
   9f350:	push   %rbp
   9f351:	push   %r15
   9f353:	push   %r14
   9f355:	push   %r13
   9f357:	push   %r12
   9f359:	push   %rbx
   9f35a:	mov    %rcx,-0x8(%rsp)
   9f35f:	mov    %rdx,-0x10(%rsp)
   9f364:	test   %rsi,%rsi
   9f367:	je     9f4a7 <void inline_single_kernel<true, external_bloom::Classical<6, false, true>, unsigned long>(external_bloom::Classical<6, false, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x157>
   9f36d:	xor    %r15d,%r15d
   9f370:	jmp    9f395 <void inline_single_kernel<true, external_bloom::Classical<6, false, true>, unsigned long>(external_bloom::Classical<6, false, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x45>
   9f372:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   9f380:	mov    -0x8(%rsp),%rax
   9f385:	mov    %edx,(%rax,%r15,4)
   9f389:	inc    %r15
   9f38c:	cmp    %r15,%rsi
   9f38f:	je     9f4a7 <void inline_single_kernel<true, external_bloom::Classical<6, false, true>, unsigned long>(external_bloom::Classical<6, false, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x157>
   9f395:	mov    -0x10(%rsp),%rax
   9f39a:	mov    (%rax,%r15,8),%rax
   9f39e:	mov    %rax,%rcx
   9f3a1:	shr    $0x20,%rcx
   9f3a5:	xor    %rax,%rcx
   9f3a8:	movabs $0xd6e8feb86659fd93,%rdx
   9f3b2:	imul   %rdx,%rcx
   9f3b6:	mov    %rcx,%rax
   9f3b9:	shr    $0x20,%rax
   9f3bd:	xor    %rcx,%rax
   9f3c0:	imul   %rdx,%rax
   9f3c4:	mov    %rax,%r8
   9f3c7:	shr    $0x20,%r8
   9f3cb:	xor    %rax,%r8
   9f3ce:	rorx   $0x20,%r8,%rax
   9f3d4:	mov    (%rdi),%r13
   9f3d7:	mov    0x10(%rdi),%rbx
   9f3db:	mov    %rbx,%rdx
   9f3de:	mulx   %rax,%rcx,%rcx
   9f3e3:	mov    0x0(%r13,%rcx,8),%rcx
   9f3e8:	lea    (%rax,%r8,1),%r14
   9f3ec:	lea    (%r14,%r8,1),%r11
   9f3f0:	lea    (%r11,%r8,1),%r10
   9f3f4:	lea    (%r10,%r8,1),%r9
   9f3f8:	add    %r9,%r8
   9f3fb:	bt     %rax,%rcx
   9f3ff:	mov    %r11,%rdx
   9f402:	mulx   %rbx,%rcx,%rcx
   9f407:	mov    %r10,%rdx
   9f40a:	mulx   %rbx,%rax,%rax
   9f40f:	mov    %r9,%rdx
   9f412:	mulx   %rbx,%r12,%r12
   9f417:	mov    %r8,%rdx
   9f41a:	mulx   %rbx,%rbp,%rbp
   9f41f:	mov    $0x0,%edx
   9f424:	jae    9f380 <void inline_single_kernel<true, external_bloom::Classical<6, false, true>, unsigned long>(external_bloom::Classical<6, false, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   9f42a:	mov    %rbx,%rdx
   9f42d:	mulx   %r14,%rdx,%rdx
   9f432:	mov    0x0(%r13,%rdx,8),%rdx
   9f437:	bt     %r14,%rdx
   9f43b:	mov    $0x0,%edx
   9f440:	jae    9f380 <void inline_single_kernel<true, external_bloom::Classical<6, false, true>, unsigned long>(external_bloom::Classical<6, false, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   9f446:	mov    $0x1,%edx
   9f44b:	shlx   %r11,%rdx,%r11
   9f450:	mov    $0x0,%edx
   9f455:	test   %r11,0x0(%r13,%rcx,8)
   9f45a:	je     9f380 <void inline_single_kernel<true, external_bloom::Classical<6, false, true>, unsigned long>(external_bloom::Classical<6, false, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   9f460:	mov    $0x1,%ecx
   9f465:	shlx   %r10,%rcx,%rcx
   9f46a:	mov    $0x0,%edx
   9f46f:	test   %rcx,0x0(%r13,%rax,8)
   9f474:	je     9f380 <void inline_single_kernel<true, external_bloom::Classical<6, false, true>, unsigned long>(external_bloom::Classical<6, false, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   9f47a:	mov    $0x1,%eax
   9f47f:	shlx   %r9,%rax,%rax
   9f484:	mov    $0x0,%edx
   9f489:	test   %rax,0x0(%r13,%r12,8)
   9f48e:	je     9f380 <void inline_single_kernel<true, external_bloom::Classical<6, false, true>, unsigned long>(external_bloom::Classical<6, false, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   9f494:	and    $0x3f,%r8d
   9f498:	shrx   %r8,0x0(%r13,%rbp,8),%rdx
   9f49f:	and    $0x1,%edx
   9f4a2:	jmp    9f380 <void inline_single_kernel<true, external_bloom::Classical<6, false, true>, unsigned long>(external_bloom::Classical<6, false, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   9f4a7:	pop    %rbx
   9f4a8:	pop    %r12
   9f4aa:	pop    %r13
   9f4ac:	pop    %r14
   9f4ae:	pop    %r15
   9f4b0:	pop    %rbp
   9f4b1:	ret
   9f4b2:	int3
   9f4b3:	int3
   9f4b4:	int3
   9f4b5:	int3
   9f4b6:	int3
   9f4b7:	int3
   9f4b8:	int3
   9f4b9:	int3
   9f4ba:	int3
   9f4bb:	int3
   9f4bc:	int3
   9f4bd:	int3
   9f4be:	int3
   9f4bf:	int3

