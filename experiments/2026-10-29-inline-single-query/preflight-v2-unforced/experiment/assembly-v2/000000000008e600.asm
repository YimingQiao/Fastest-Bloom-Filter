000000000008e600 <void inline_single_kernel<true, external_bloom::Classical<6, true, false>, unsigned long>(external_bloom::Classical<6, true, false> const&, unsigned long, unsigned long const*, unsigned int*)>:
   8e600:	test   %rsi,%rsi
   8e603:	je     8e726 <void inline_single_kernel<true, external_bloom::Classical<6, true, false>, unsigned long>(external_bloom::Classical<6, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x126>
   8e609:	push   %rbp
   8e60a:	push   %r15
   8e60c:	push   %r14
   8e60e:	push   %r13
   8e610:	push   %r12
   8e612:	push   %rbx
   8e613:	mov    %rdx,%rax
   8e616:	movabs $0xd6e8feb86659fd93,%rbx
   8e620:	xor    %r14d,%r14d
   8e623:	jmp    8e640 <void inline_single_kernel<true, external_bloom::Classical<6, true, false>, unsigned long>(external_bloom::Classical<6, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
   8e625:	data16 cs nopw 0x0(%rax,%rax,1)
   8e630:	mov    %edx,(%rcx,%r14,4)
   8e634:	inc    %r14
   8e637:	cmp    %r14,%rsi
   8e63a:	je     8e71c <void inline_single_kernel<true, external_bloom::Classical<6, true, false>, unsigned long>(external_bloom::Classical<6, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x11c>
   8e640:	mov    (%rax,%r14,8),%rdx
   8e644:	mov    %rdx,%r8
   8e647:	shr    $0x20,%r8
   8e64b:	xor    %rdx,%r8
   8e64e:	imul   %rbx,%r8
   8e652:	mov    %r8,%rdx
   8e655:	shr    $0x20,%rdx
   8e659:	xor    %r8,%rdx
   8e65c:	imul   %rbx,%rdx
   8e660:	mov    %rdx,%r8
   8e663:	shr    $0x20,%r8
   8e667:	xor    %rdx,%r8
   8e66a:	rorx   $0x20,%r8,%r9
   8e670:	mov    (%rdi),%r12
   8e673:	mov    0x10(%rdi),%r10
   8e677:	mov    %r10,%rdx
   8e67a:	mulx   %r9,%rdx,%rdx
   8e67f:	shrx   %r9,(%r12,%rdx,8),%r11
   8e685:	add    %r8,%r9
   8e688:	mov    %r10,%rdx
   8e68b:	mulx   %r9,%rdx,%rdx
   8e690:	shrx   %r9,(%r12,%rdx,8),%r13
   8e696:	add    %r8,%r9
   8e699:	mov    %r9,%rdx
   8e69c:	mulx   %r10,%rdx,%rdx
   8e6a1:	shrx   %r9,(%r12,%rdx,8),%r15
   8e6a7:	and    %r11d,%r13d
   8e6aa:	and    %r13d,%r15d
   8e6ad:	add    %r8,%r9
   8e6b0:	lea    (%r9,%r8,1),%r11
   8e6b4:	add    %r11,%r8
   8e6b7:	mov    %r11,%rdx
   8e6ba:	mulx   %r10,%rbp,%rbp
   8e6bf:	mov    %r8,%rdx
   8e6c2:	mulx   %r10,%r13,%r13
   8e6c7:	mov    $0x0,%edx
   8e6cc:	test   $0x1,%r15b
   8e6d0:	je     8e630 <void inline_single_kernel<true, external_bloom::Classical<6, true, false>, unsigned long>(external_bloom::Classical<6, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   8e6d6:	mov    %r9,%rdx
   8e6d9:	mulx   %r10,%rdx,%rdx
   8e6de:	mov    (%r12,%rdx,8),%rdx
   8e6e2:	bt     %r9,%rdx
   8e6e6:	mov    $0x0,%edx
   8e6eb:	jae    8e630 <void inline_single_kernel<true, external_bloom::Classical<6, true, false>, unsigned long>(external_bloom::Classical<6, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   8e6f1:	mov    $0x1,%edx
   8e6f6:	shlx   %r11,%rdx,%r9
   8e6fb:	mov    $0x0,%edx
   8e700:	test   %r9,(%r12,%rbp,8)
   8e704:	je     8e630 <void inline_single_kernel<true, external_bloom::Classical<6, true, false>, unsigned long>(external_bloom::Classical<6, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   8e70a:	and    $0x3f,%r8d
   8e70e:	shrx   %r8,(%r12,%r13,8),%rdx
   8e714:	and    $0x1,%edx
   8e717:	jmp    8e630 <void inline_single_kernel<true, external_bloom::Classical<6, true, false>, unsigned long>(external_bloom::Classical<6, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   8e71c:	pop    %rbx
   8e71d:	pop    %r12
   8e71f:	pop    %r13
   8e721:	pop    %r14
   8e723:	pop    %r15
   8e725:	pop    %rbp
   8e726:	ret
   8e727:	int3
   8e728:	int3
   8e729:	int3
   8e72a:	int3
   8e72b:	int3
   8e72c:	int3
   8e72d:	int3
   8e72e:	int3
   8e72f:	int3

