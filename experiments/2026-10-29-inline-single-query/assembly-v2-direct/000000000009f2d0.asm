000000000009f2d0 <void inline_single_kernel<true, external_bloom::Classical<6, false, true>, unsigned long>(external_bloom::Classical<6, false, true> const&, unsigned long, unsigned long const*, unsigned int*)>:
   9f2d0:	push   %rbp
   9f2d1:	push   %r15
   9f2d3:	push   %r14
   9f2d5:	push   %r13
   9f2d7:	push   %r12
   9f2d9:	push   %rbx
   9f2da:	mov    %rcx,-0x8(%rsp)
   9f2df:	mov    %rdx,-0x10(%rsp)
   9f2e4:	test   %rsi,%rsi
   9f2e7:	je     9f427 <void inline_single_kernel<true, external_bloom::Classical<6, false, true>, unsigned long>(external_bloom::Classical<6, false, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x157>
   9f2ed:	xor    %r15d,%r15d
   9f2f0:	jmp    9f315 <void inline_single_kernel<true, external_bloom::Classical<6, false, true>, unsigned long>(external_bloom::Classical<6, false, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x45>
   9f2f2:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   9f300:	mov    -0x8(%rsp),%rax
   9f305:	mov    %edx,(%rax,%r15,4)
   9f309:	inc    %r15
   9f30c:	cmp    %r15,%rsi
   9f30f:	je     9f427 <void inline_single_kernel<true, external_bloom::Classical<6, false, true>, unsigned long>(external_bloom::Classical<6, false, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x157>
   9f315:	mov    -0x10(%rsp),%rax
   9f31a:	mov    (%rax,%r15,8),%rax
   9f31e:	mov    %rax,%rcx
   9f321:	shr    $0x20,%rcx
   9f325:	xor    %rax,%rcx
   9f328:	movabs $0xd6e8feb86659fd93,%rdx
   9f332:	imul   %rdx,%rcx
   9f336:	mov    %rcx,%rax
   9f339:	shr    $0x20,%rax
   9f33d:	xor    %rcx,%rax
   9f340:	imul   %rdx,%rax
   9f344:	mov    %rax,%r8
   9f347:	shr    $0x20,%r8
   9f34b:	xor    %rax,%r8
   9f34e:	rorx   $0x20,%r8,%rax
   9f354:	mov    (%rdi),%r13
   9f357:	mov    0x10(%rdi),%rbx
   9f35b:	mov    %rbx,%rdx
   9f35e:	mulx   %rax,%rcx,%rcx
   9f363:	mov    0x0(%r13,%rcx,8),%rcx
   9f368:	lea    (%rax,%r8,1),%r14
   9f36c:	lea    (%r14,%r8,1),%r11
   9f370:	lea    (%r11,%r8,1),%r10
   9f374:	lea    (%r10,%r8,1),%r9
   9f378:	add    %r9,%r8
   9f37b:	bt     %rax,%rcx
   9f37f:	mov    %r11,%rdx
   9f382:	mulx   %rbx,%rcx,%rcx
   9f387:	mov    %r10,%rdx
   9f38a:	mulx   %rbx,%rax,%rax
   9f38f:	mov    %r9,%rdx
   9f392:	mulx   %rbx,%r12,%r12
   9f397:	mov    %r8,%rdx
   9f39a:	mulx   %rbx,%rbp,%rbp
   9f39f:	mov    $0x0,%edx
   9f3a4:	jae    9f300 <void inline_single_kernel<true, external_bloom::Classical<6, false, true>, unsigned long>(external_bloom::Classical<6, false, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   9f3aa:	mov    %rbx,%rdx
   9f3ad:	mulx   %r14,%rdx,%rdx
   9f3b2:	mov    0x0(%r13,%rdx,8),%rdx
   9f3b7:	bt     %r14,%rdx
   9f3bb:	mov    $0x0,%edx
   9f3c0:	jae    9f300 <void inline_single_kernel<true, external_bloom::Classical<6, false, true>, unsigned long>(external_bloom::Classical<6, false, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   9f3c6:	mov    $0x1,%edx
   9f3cb:	shlx   %r11,%rdx,%r11
   9f3d0:	mov    $0x0,%edx
   9f3d5:	test   %r11,0x0(%r13,%rcx,8)
   9f3da:	je     9f300 <void inline_single_kernel<true, external_bloom::Classical<6, false, true>, unsigned long>(external_bloom::Classical<6, false, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   9f3e0:	mov    $0x1,%ecx
   9f3e5:	shlx   %r10,%rcx,%rcx
   9f3ea:	mov    $0x0,%edx
   9f3ef:	test   %rcx,0x0(%r13,%rax,8)
   9f3f4:	je     9f300 <void inline_single_kernel<true, external_bloom::Classical<6, false, true>, unsigned long>(external_bloom::Classical<6, false, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   9f3fa:	mov    $0x1,%eax
   9f3ff:	shlx   %r9,%rax,%rax
   9f404:	mov    $0x0,%edx
   9f409:	test   %rax,0x0(%r13,%r12,8)
   9f40e:	je     9f300 <void inline_single_kernel<true, external_bloom::Classical<6, false, true>, unsigned long>(external_bloom::Classical<6, false, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   9f414:	and    $0x3f,%r8d
   9f418:	shrx   %r8,0x0(%r13,%rbp,8),%rdx
   9f41f:	and    $0x1,%edx
   9f422:	jmp    9f300 <void inline_single_kernel<true, external_bloom::Classical<6, false, true>, unsigned long>(external_bloom::Classical<6, false, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   9f427:	pop    %rbx
   9f428:	pop    %r12
   9f42a:	pop    %r13
   9f42c:	pop    %r14
   9f42e:	pop    %r15
   9f430:	pop    %rbp
   9f431:	ret
   9f432:	int3
   9f433:	int3
   9f434:	int3
   9f435:	int3
   9f436:	int3
   9f437:	int3
   9f438:	int3
   9f439:	int3
   9f43a:	int3
   9f43b:	int3
   9f43c:	int3
   9f43d:	int3
   9f43e:	int3
   9f43f:	int3

