00000000000724e0 <void inline_single_kernel<false, external_bloom::Classical<6, false, false>, unsigned long>(external_bloom::Classical<6, false, false> const&, unsigned long, unsigned long const*, unsigned int*)>:
   724e0:	push   %rbp
   724e1:	push   %r15
   724e3:	push   %r14
   724e5:	push   %r13
   724e7:	push   %r12
   724e9:	push   %rbx
   724ea:	mov    %rcx,-0x8(%rsp)
   724ef:	mov    %rdx,-0x10(%rsp)
   724f4:	test   %rsi,%rsi
   724f7:	je     725fd <void inline_single_kernel<false, external_bloom::Classical<6, false, false>, unsigned long>(external_bloom::Classical<6, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x11d>
   724fd:	xor    %r14d,%r14d
   72500:	jmp    72525 <void inline_single_kernel<false, external_bloom::Classical<6, false, false>, unsigned long>(external_bloom::Classical<6, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x45>
   72502:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   72510:	mov    -0x8(%rsp),%rax
   72515:	mov    %edx,(%rax,%r14,4)
   72519:	inc    %r14
   7251c:	cmp    %r14,%rsi
   7251f:	je     725fd <void inline_single_kernel<false, external_bloom::Classical<6, false, false>, unsigned long>(external_bloom::Classical<6, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x11d>
   72525:	mov    -0x10(%rsp),%rax
   7252a:	mov    (%rax,%r14,8),%r8
   7252e:	rorx   $0x20,%r8,%rax
   72534:	mov    (%rdi),%r12
   72537:	mov    0x10(%rdi),%rbx
   7253b:	mov    %rbx,%rdx
   7253e:	mulx   %rax,%rcx,%rcx
   72543:	mov    (%r12,%rcx,8),%rdx
   72547:	lea    (%rax,%r8,1),%rcx
   7254b:	lea    (%rcx,%r8,1),%r11
   7254f:	lea    (%r11,%r8,1),%r10
   72553:	lea    (%r10,%r8,1),%r9
   72557:	add    %r9,%r8
   7255a:	bt     %rax,%rdx
   7255e:	mov    %r11,%rdx
   72561:	mulx   %rbx,%rax,%rax
   72566:	mov    %r10,%rdx
   72569:	mulx   %rbx,%r15,%r15
   7256e:	mov    %r9,%rdx
   72571:	mulx   %rbx,%rbp,%rbp
   72576:	mov    %r8,%rdx
   72579:	mulx   %rbx,%r13,%r13
   7257e:	mov    $0x0,%edx
   72583:	jae    72510 <void inline_single_kernel<false, external_bloom::Classical<6, false, false>, unsigned long>(external_bloom::Classical<6, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   72585:	mov    %rbx,%rdx
   72588:	mulx   %rcx,%rdx,%rdx
   7258d:	mov    (%r12,%rdx,8),%rdx
   72591:	bt     %rcx,%rdx
   72595:	mov    $0x0,%edx
   7259a:	jae    72510 <void inline_single_kernel<false, external_bloom::Classical<6, false, false>, unsigned long>(external_bloom::Classical<6, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   725a0:	mov    $0x1,%ecx
   725a5:	shlx   %r11,%rcx,%rcx
   725aa:	mov    $0x0,%edx
   725af:	test   %rcx,(%r12,%rax,8)
   725b3:	je     72510 <void inline_single_kernel<false, external_bloom::Classical<6, false, false>, unsigned long>(external_bloom::Classical<6, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   725b9:	mov    $0x1,%eax
   725be:	shlx   %r10,%rax,%rax
   725c3:	mov    $0x0,%edx
   725c8:	test   %rax,(%r12,%r15,8)
   725cc:	je     72510 <void inline_single_kernel<false, external_bloom::Classical<6, false, false>, unsigned long>(external_bloom::Classical<6, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   725d2:	mov    $0x1,%eax
   725d7:	shlx   %r9,%rax,%rax
   725dc:	mov    $0x0,%edx
   725e1:	test   %rax,(%r12,%rbp,8)
   725e5:	je     72510 <void inline_single_kernel<false, external_bloom::Classical<6, false, false>, unsigned long>(external_bloom::Classical<6, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   725eb:	and    $0x3f,%r8d
   725ef:	shrx   %r8,(%r12,%r13,8),%rdx
   725f5:	and    $0x1,%edx
   725f8:	jmp    72510 <void inline_single_kernel<false, external_bloom::Classical<6, false, false>, unsigned long>(external_bloom::Classical<6, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   725fd:	pop    %rbx
   725fe:	pop    %r12
   72600:	pop    %r13
   72602:	pop    %r14
   72604:	pop    %r15
   72606:	pop    %rbp
   72607:	ret
   72608:	int3
   72609:	int3
   7260a:	int3
   7260b:	int3
   7260c:	int3
   7260d:	int3
   7260e:	int3
   7260f:	int3

