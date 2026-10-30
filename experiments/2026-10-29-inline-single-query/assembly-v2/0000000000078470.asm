0000000000078470 <void inline_single_kernel<true, external_bloom::Classical<8, false, false>, unsigned long>(external_bloom::Classical<8, false, false> const&, unsigned long, unsigned long const*, unsigned int*)>:
   78470:	push   %rbp
   78471:	push   %r15
   78473:	push   %r14
   78475:	push   %r13
   78477:	push   %r12
   78479:	push   %rbx
   7847a:	mov    %rcx,-0x10(%rsp)
   7847f:	mov    %rdx,-0x18(%rsp)
   78484:	mov    %rdi,-0x28(%rsp)
   78489:	mov    %rsi,-0x20(%rsp)
   7848e:	test   %rsi,%rsi
   78491:	je     7862e <void inline_single_kernel<true, external_bloom::Classical<8, false, false>, unsigned long>(external_bloom::Classical<8, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x1be>
   78497:	xor    %r13d,%r13d
   7849a:	jmp    784b7 <void inline_single_kernel<true, external_bloom::Classical<8, false, false>, unsigned long>(external_bloom::Classical<8, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x47>
   7849c:	nopl   0x0(%rax)
   784a0:	mov    -0x10(%rsp),%rax
   784a5:	mov    %edx,(%rax,%r13,4)
   784a9:	inc    %r13
   784ac:	cmp    %r13,-0x20(%rsp)
   784b1:	je     7862e <void inline_single_kernel<true, external_bloom::Classical<8, false, false>, unsigned long>(external_bloom::Classical<8, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x1be>
   784b7:	mov    -0x18(%rsp),%rax
   784bc:	mov    (%rax,%r13,8),%rax
   784c0:	mov    %rax,%rcx
   784c3:	shr    $0x20,%rcx
   784c7:	xor    %rax,%rcx
   784ca:	movabs $0xd6e8feb86659fd93,%rdx
   784d4:	imul   %rdx,%rcx
   784d8:	mov    %rcx,%rax
   784db:	shr    $0x20,%rax
   784df:	xor    %rcx,%rax
   784e2:	imul   %rdx,%rax
   784e6:	mov    %rax,%r8
   784e9:	shr    $0x20,%r8
   784ed:	xor    %rax,%r8
   784f0:	rorx   $0x20,%r8,%rax
   784f6:	mov    -0x28(%rsp),%rcx
   784fb:	mov    (%rcx),%rbp
   784fe:	mov    0x10(%rcx),%r15
   78502:	mov    %r15,%rdx
   78505:	mulx   %rax,%rcx,%rcx
   7850a:	mov    0x0(%rbp,%rcx,8),%rdx
   7850f:	lea    (%rax,%r8,1),%rcx
   78513:	lea    (%rcx,%r8,1),%r14
   78517:	lea    (%r14,%r8,1),%rbx
   7851b:	lea    (%rbx,%r8,1),%r11
   7851f:	lea    (%r11,%r8,1),%r10
   78523:	lea    (%r10,%r8,1),%r9
   78527:	add    %r9,%r8
   7852a:	bt     %rax,%rdx
   7852e:	mov    %r14,%rdx
   78531:	mulx   %r15,%rdi,%rdi
   78536:	mov    %rbx,%rdx
   78539:	mulx   %r15,%rsi,%rsi
   7853e:	mov    %r11,%rdx
   78541:	mulx   %r15,%rax,%rax
   78546:	mov    %r10,%rdx
   78549:	mulx   %r15,%r12,%r12
   7854e:	mov    %r9,%rdx
   78551:	mulx   %r15,%rdx,%rdx
   78556:	mov    %rdx,-0x8(%rsp)
   7855b:	mov    %r8,%rdx
   7855e:	mulx   %r15,%rdx,%rdx
   78563:	mov    %rdx,-0x30(%rsp)
   78568:	mov    $0x0,%edx
   7856d:	jae    784a0 <void inline_single_kernel<true, external_bloom::Classical<8, false, false>, unsigned long>(external_bloom::Classical<8, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   78573:	mov    %r15,%rdx
   78576:	mulx   %rcx,%rdx,%rdx
   7857b:	mov    0x0(%rbp,%rdx,8),%rdx
   78580:	bt     %rcx,%rdx
   78584:	mov    $0x0,%edx
   78589:	jae    784a0 <void inline_single_kernel<true, external_bloom::Classical<8, false, false>, unsigned long>(external_bloom::Classical<8, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   7858f:	mov    $0x1,%ecx
   78594:	shlx   %r14,%rcx,%rcx
   78599:	mov    $0x0,%edx
   7859e:	test   %rcx,0x0(%rbp,%rdi,8)
   785a3:	je     784a0 <void inline_single_kernel<true, external_bloom::Classical<8, false, false>, unsigned long>(external_bloom::Classical<8, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   785a9:	mov    $0x1,%ecx
   785ae:	shlx   %rbx,%rcx,%rcx
   785b3:	mov    $0x0,%edx
   785b8:	test   %rcx,0x0(%rbp,%rsi,8)
   785bd:	je     784a0 <void inline_single_kernel<true, external_bloom::Classical<8, false, false>, unsigned long>(external_bloom::Classical<8, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   785c3:	mov    $0x1,%ecx
   785c8:	shlx   %r11,%rcx,%rcx
   785cd:	mov    $0x0,%edx
   785d2:	test   %rcx,0x0(%rbp,%rax,8)
   785d7:	je     784a0 <void inline_single_kernel<true, external_bloom::Classical<8, false, false>, unsigned long>(external_bloom::Classical<8, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   785dd:	mov    $0x1,%eax
   785e2:	shlx   %r10,%rax,%rax
   785e7:	mov    $0x0,%edx
   785ec:	test   %rax,0x0(%rbp,%r12,8)
   785f1:	je     784a0 <void inline_single_kernel<true, external_bloom::Classical<8, false, false>, unsigned long>(external_bloom::Classical<8, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   785f7:	mov    $0x1,%eax
   785fc:	shlx   %r9,%rax,%rax
   78601:	mov    $0x0,%edx
   78606:	mov    -0x8(%rsp),%rcx
   7860b:	test   %rax,0x0(%rbp,%rcx,8)
   78610:	je     784a0 <void inline_single_kernel<true, external_bloom::Classical<8, false, false>, unsigned long>(external_bloom::Classical<8, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   78616:	and    $0x3f,%r8d
   7861a:	mov    -0x30(%rsp),%rax
   7861f:	shrx   %r8,0x0(%rbp,%rax,8),%rdx
   78626:	and    $0x1,%edx
   78629:	jmp    784a0 <void inline_single_kernel<true, external_bloom::Classical<8, false, false>, unsigned long>(external_bloom::Classical<8, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   7862e:	pop    %rbx
   7862f:	pop    %r12
   78631:	pop    %r13
   78633:	pop    %r14
   78635:	pop    %r15
   78637:	pop    %rbp
   78638:	ret
   78639:	int3
   7863a:	int3
   7863b:	int3
   7863c:	int3
   7863d:	int3
   7863e:	int3
   7863f:	int3

