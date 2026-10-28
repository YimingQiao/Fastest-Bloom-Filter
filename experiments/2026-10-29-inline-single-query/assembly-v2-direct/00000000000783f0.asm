00000000000783f0 <void inline_single_kernel<true, external_bloom::Classical<8, false, false>, unsigned long>(external_bloom::Classical<8, false, false> const&, unsigned long, unsigned long const*, unsigned int*)>:
   783f0:	push   %rbp
   783f1:	push   %r15
   783f3:	push   %r14
   783f5:	push   %r13
   783f7:	push   %r12
   783f9:	push   %rbx
   783fa:	mov    %rcx,-0x10(%rsp)
   783ff:	mov    %rdx,-0x18(%rsp)
   78404:	mov    %rdi,-0x28(%rsp)
   78409:	mov    %rsi,-0x20(%rsp)
   7840e:	test   %rsi,%rsi
   78411:	je     785ae <void inline_single_kernel<true, external_bloom::Classical<8, false, false>, unsigned long>(external_bloom::Classical<8, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x1be>
   78417:	xor    %r13d,%r13d
   7841a:	jmp    78437 <void inline_single_kernel<true, external_bloom::Classical<8, false, false>, unsigned long>(external_bloom::Classical<8, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x47>
   7841c:	nopl   0x0(%rax)
   78420:	mov    -0x10(%rsp),%rax
   78425:	mov    %edx,(%rax,%r13,4)
   78429:	inc    %r13
   7842c:	cmp    %r13,-0x20(%rsp)
   78431:	je     785ae <void inline_single_kernel<true, external_bloom::Classical<8, false, false>, unsigned long>(external_bloom::Classical<8, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x1be>
   78437:	mov    -0x18(%rsp),%rax
   7843c:	mov    (%rax,%r13,8),%rax
   78440:	mov    %rax,%rcx
   78443:	shr    $0x20,%rcx
   78447:	xor    %rax,%rcx
   7844a:	movabs $0xd6e8feb86659fd93,%rdx
   78454:	imul   %rdx,%rcx
   78458:	mov    %rcx,%rax
   7845b:	shr    $0x20,%rax
   7845f:	xor    %rcx,%rax
   78462:	imul   %rdx,%rax
   78466:	mov    %rax,%r8
   78469:	shr    $0x20,%r8
   7846d:	xor    %rax,%r8
   78470:	rorx   $0x20,%r8,%rax
   78476:	mov    -0x28(%rsp),%rcx
   7847b:	mov    (%rcx),%rbp
   7847e:	mov    0x10(%rcx),%r15
   78482:	mov    %r15,%rdx
   78485:	mulx   %rax,%rcx,%rcx
   7848a:	mov    0x0(%rbp,%rcx,8),%rdx
   7848f:	lea    (%rax,%r8,1),%rcx
   78493:	lea    (%rcx,%r8,1),%r14
   78497:	lea    (%r14,%r8,1),%rbx
   7849b:	lea    (%rbx,%r8,1),%r11
   7849f:	lea    (%r11,%r8,1),%r10
   784a3:	lea    (%r10,%r8,1),%r9
   784a7:	add    %r9,%r8
   784aa:	bt     %rax,%rdx
   784ae:	mov    %r14,%rdx
   784b1:	mulx   %r15,%rdi,%rdi
   784b6:	mov    %rbx,%rdx
   784b9:	mulx   %r15,%rsi,%rsi
   784be:	mov    %r11,%rdx
   784c1:	mulx   %r15,%rax,%rax
   784c6:	mov    %r10,%rdx
   784c9:	mulx   %r15,%r12,%r12
   784ce:	mov    %r9,%rdx
   784d1:	mulx   %r15,%rdx,%rdx
   784d6:	mov    %rdx,-0x8(%rsp)
   784db:	mov    %r8,%rdx
   784de:	mulx   %r15,%rdx,%rdx
   784e3:	mov    %rdx,-0x30(%rsp)
   784e8:	mov    $0x0,%edx
   784ed:	jae    78420 <void inline_single_kernel<true, external_bloom::Classical<8, false, false>, unsigned long>(external_bloom::Classical<8, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   784f3:	mov    %r15,%rdx
   784f6:	mulx   %rcx,%rdx,%rdx
   784fb:	mov    0x0(%rbp,%rdx,8),%rdx
   78500:	bt     %rcx,%rdx
   78504:	mov    $0x0,%edx
   78509:	jae    78420 <void inline_single_kernel<true, external_bloom::Classical<8, false, false>, unsigned long>(external_bloom::Classical<8, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   7850f:	mov    $0x1,%ecx
   78514:	shlx   %r14,%rcx,%rcx
   78519:	mov    $0x0,%edx
   7851e:	test   %rcx,0x0(%rbp,%rdi,8)
   78523:	je     78420 <void inline_single_kernel<true, external_bloom::Classical<8, false, false>, unsigned long>(external_bloom::Classical<8, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   78529:	mov    $0x1,%ecx
   7852e:	shlx   %rbx,%rcx,%rcx
   78533:	mov    $0x0,%edx
   78538:	test   %rcx,0x0(%rbp,%rsi,8)
   7853d:	je     78420 <void inline_single_kernel<true, external_bloom::Classical<8, false, false>, unsigned long>(external_bloom::Classical<8, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   78543:	mov    $0x1,%ecx
   78548:	shlx   %r11,%rcx,%rcx
   7854d:	mov    $0x0,%edx
   78552:	test   %rcx,0x0(%rbp,%rax,8)
   78557:	je     78420 <void inline_single_kernel<true, external_bloom::Classical<8, false, false>, unsigned long>(external_bloom::Classical<8, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   7855d:	mov    $0x1,%eax
   78562:	shlx   %r10,%rax,%rax
   78567:	mov    $0x0,%edx
   7856c:	test   %rax,0x0(%rbp,%r12,8)
   78571:	je     78420 <void inline_single_kernel<true, external_bloom::Classical<8, false, false>, unsigned long>(external_bloom::Classical<8, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   78577:	mov    $0x1,%eax
   7857c:	shlx   %r9,%rax,%rax
   78581:	mov    $0x0,%edx
   78586:	mov    -0x8(%rsp),%rcx
   7858b:	test   %rax,0x0(%rbp,%rcx,8)
   78590:	je     78420 <void inline_single_kernel<true, external_bloom::Classical<8, false, false>, unsigned long>(external_bloom::Classical<8, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   78596:	and    $0x3f,%r8d
   7859a:	mov    -0x30(%rsp),%rax
   7859f:	shrx   %r8,0x0(%rbp,%rax,8),%rdx
   785a6:	and    $0x1,%edx
   785a9:	jmp    78420 <void inline_single_kernel<true, external_bloom::Classical<8, false, false>, unsigned long>(external_bloom::Classical<8, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   785ae:	pop    %rbx
   785af:	pop    %r12
   785b1:	pop    %r13
   785b3:	pop    %r14
   785b5:	pop    %r15
   785b7:	pop    %rbp
   785b8:	ret
   785b9:	int3
   785ba:	int3
   785bb:	int3
   785bc:	int3
   785bd:	int3
   785be:	int3
   785bf:	int3

