0000000000072460 <void inline_single_kernel<false, external_bloom::Classical<6, false, false>, unsigned long>(external_bloom::Classical<6, false, false> const&, unsigned long, unsigned long const*, unsigned int*)>:
   72460:	push   %rbp
   72461:	push   %r15
   72463:	push   %r14
   72465:	push   %r13
   72467:	push   %r12
   72469:	push   %rbx
   7246a:	mov    %rcx,-0x8(%rsp)
   7246f:	mov    %rdx,-0x10(%rsp)
   72474:	test   %rsi,%rsi
   72477:	je     7257d <void inline_single_kernel<false, external_bloom::Classical<6, false, false>, unsigned long>(external_bloom::Classical<6, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x11d>
   7247d:	xor    %r14d,%r14d
   72480:	jmp    724a5 <void inline_single_kernel<false, external_bloom::Classical<6, false, false>, unsigned long>(external_bloom::Classical<6, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x45>
   72482:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   72490:	mov    -0x8(%rsp),%rax
   72495:	mov    %edx,(%rax,%r14,4)
   72499:	inc    %r14
   7249c:	cmp    %r14,%rsi
   7249f:	je     7257d <void inline_single_kernel<false, external_bloom::Classical<6, false, false>, unsigned long>(external_bloom::Classical<6, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x11d>
   724a5:	mov    -0x10(%rsp),%rax
   724aa:	mov    (%rax,%r14,8),%r8
   724ae:	rorx   $0x20,%r8,%rax
   724b4:	mov    (%rdi),%r12
   724b7:	mov    0x10(%rdi),%rbx
   724bb:	mov    %rbx,%rdx
   724be:	mulx   %rax,%rcx,%rcx
   724c3:	mov    (%r12,%rcx,8),%rdx
   724c7:	lea    (%rax,%r8,1),%rcx
   724cb:	lea    (%rcx,%r8,1),%r11
   724cf:	lea    (%r11,%r8,1),%r10
   724d3:	lea    (%r10,%r8,1),%r9
   724d7:	add    %r9,%r8
   724da:	bt     %rax,%rdx
   724de:	mov    %r11,%rdx
   724e1:	mulx   %rbx,%rax,%rax
   724e6:	mov    %r10,%rdx
   724e9:	mulx   %rbx,%r15,%r15
   724ee:	mov    %r9,%rdx
   724f1:	mulx   %rbx,%rbp,%rbp
   724f6:	mov    %r8,%rdx
   724f9:	mulx   %rbx,%r13,%r13
   724fe:	mov    $0x0,%edx
   72503:	jae    72490 <void inline_single_kernel<false, external_bloom::Classical<6, false, false>, unsigned long>(external_bloom::Classical<6, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   72505:	mov    %rbx,%rdx
   72508:	mulx   %rcx,%rdx,%rdx
   7250d:	mov    (%r12,%rdx,8),%rdx
   72511:	bt     %rcx,%rdx
   72515:	mov    $0x0,%edx
   7251a:	jae    72490 <void inline_single_kernel<false, external_bloom::Classical<6, false, false>, unsigned long>(external_bloom::Classical<6, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   72520:	mov    $0x1,%ecx
   72525:	shlx   %r11,%rcx,%rcx
   7252a:	mov    $0x0,%edx
   7252f:	test   %rcx,(%r12,%rax,8)
   72533:	je     72490 <void inline_single_kernel<false, external_bloom::Classical<6, false, false>, unsigned long>(external_bloom::Classical<6, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   72539:	mov    $0x1,%eax
   7253e:	shlx   %r10,%rax,%rax
   72543:	mov    $0x0,%edx
   72548:	test   %rax,(%r12,%r15,8)
   7254c:	je     72490 <void inline_single_kernel<false, external_bloom::Classical<6, false, false>, unsigned long>(external_bloom::Classical<6, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   72552:	mov    $0x1,%eax
   72557:	shlx   %r9,%rax,%rax
   7255c:	mov    $0x0,%edx
   72561:	test   %rax,(%r12,%rbp,8)
   72565:	je     72490 <void inline_single_kernel<false, external_bloom::Classical<6, false, false>, unsigned long>(external_bloom::Classical<6, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   7256b:	and    $0x3f,%r8d
   7256f:	shrx   %r8,(%r12,%r13,8),%rdx
   72575:	and    $0x1,%edx
   72578:	jmp    72490 <void inline_single_kernel<false, external_bloom::Classical<6, false, false>, unsigned long>(external_bloom::Classical<6, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   7257d:	pop    %rbx
   7257e:	pop    %r12
   72580:	pop    %r13
   72582:	pop    %r14
   72584:	pop    %r15
   72586:	pop    %rbp
   72587:	ret
   72588:	int3
   72589:	int3
   7258a:	int3
   7258b:	int3
   7258c:	int3
   7258d:	int3
   7258e:	int3
   7258f:	int3

