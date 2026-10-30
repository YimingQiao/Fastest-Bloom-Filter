000000000008e580 <void inline_single_kernel<true, external_bloom::Classical<6, true, false>, unsigned long>(external_bloom::Classical<6, true, false> const&, unsigned long, unsigned long const*, unsigned int*)>:
   8e580:	test   %rsi,%rsi
   8e583:	je     8e6a6 <void inline_single_kernel<true, external_bloom::Classical<6, true, false>, unsigned long>(external_bloom::Classical<6, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x126>
   8e589:	push   %rbp
   8e58a:	push   %r15
   8e58c:	push   %r14
   8e58e:	push   %r13
   8e590:	push   %r12
   8e592:	push   %rbx
   8e593:	mov    %rdx,%rax
   8e596:	movabs $0xd6e8feb86659fd93,%rbx
   8e5a0:	xor    %r14d,%r14d
   8e5a3:	jmp    8e5c0 <void inline_single_kernel<true, external_bloom::Classical<6, true, false>, unsigned long>(external_bloom::Classical<6, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
   8e5a5:	data16 cs nopw 0x0(%rax,%rax,1)
   8e5b0:	mov    %edx,(%rcx,%r14,4)
   8e5b4:	inc    %r14
   8e5b7:	cmp    %r14,%rsi
   8e5ba:	je     8e69c <void inline_single_kernel<true, external_bloom::Classical<6, true, false>, unsigned long>(external_bloom::Classical<6, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x11c>
   8e5c0:	mov    (%rax,%r14,8),%rdx
   8e5c4:	mov    %rdx,%r8
   8e5c7:	shr    $0x20,%r8
   8e5cb:	xor    %rdx,%r8
   8e5ce:	imul   %rbx,%r8
   8e5d2:	mov    %r8,%rdx
   8e5d5:	shr    $0x20,%rdx
   8e5d9:	xor    %r8,%rdx
   8e5dc:	imul   %rbx,%rdx
   8e5e0:	mov    %rdx,%r8
   8e5e3:	shr    $0x20,%r8
   8e5e7:	xor    %rdx,%r8
   8e5ea:	rorx   $0x20,%r8,%r9
   8e5f0:	mov    (%rdi),%r12
   8e5f3:	mov    0x10(%rdi),%r10
   8e5f7:	mov    %r10,%rdx
   8e5fa:	mulx   %r9,%rdx,%rdx
   8e5ff:	shrx   %r9,(%r12,%rdx,8),%r11
   8e605:	add    %r8,%r9
   8e608:	mov    %r10,%rdx
   8e60b:	mulx   %r9,%rdx,%rdx
   8e610:	shrx   %r9,(%r12,%rdx,8),%r13
   8e616:	add    %r8,%r9
   8e619:	mov    %r9,%rdx
   8e61c:	mulx   %r10,%rdx,%rdx
   8e621:	shrx   %r9,(%r12,%rdx,8),%r15
   8e627:	and    %r11d,%r13d
   8e62a:	and    %r13d,%r15d
   8e62d:	add    %r8,%r9
   8e630:	lea    (%r9,%r8,1),%r11
   8e634:	add    %r11,%r8
   8e637:	mov    %r11,%rdx
   8e63a:	mulx   %r10,%rbp,%rbp
   8e63f:	mov    %r8,%rdx
   8e642:	mulx   %r10,%r13,%r13
   8e647:	mov    $0x0,%edx
   8e64c:	test   $0x1,%r15b
   8e650:	je     8e5b0 <void inline_single_kernel<true, external_bloom::Classical<6, true, false>, unsigned long>(external_bloom::Classical<6, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   8e656:	mov    %r9,%rdx
   8e659:	mulx   %r10,%rdx,%rdx
   8e65e:	mov    (%r12,%rdx,8),%rdx
   8e662:	bt     %r9,%rdx
   8e666:	mov    $0x0,%edx
   8e66b:	jae    8e5b0 <void inline_single_kernel<true, external_bloom::Classical<6, true, false>, unsigned long>(external_bloom::Classical<6, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   8e671:	mov    $0x1,%edx
   8e676:	shlx   %r11,%rdx,%r9
   8e67b:	mov    $0x0,%edx
   8e680:	test   %r9,(%r12,%rbp,8)
   8e684:	je     8e5b0 <void inline_single_kernel<true, external_bloom::Classical<6, true, false>, unsigned long>(external_bloom::Classical<6, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   8e68a:	and    $0x3f,%r8d
   8e68e:	shrx   %r8,(%r12,%r13,8),%rdx
   8e694:	and    $0x1,%edx
   8e697:	jmp    8e5b0 <void inline_single_kernel<true, external_bloom::Classical<6, true, false>, unsigned long>(external_bloom::Classical<6, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   8e69c:	pop    %rbx
   8e69d:	pop    %r12
   8e69f:	pop    %r13
   8e6a1:	pop    %r14
   8e6a3:	pop    %r15
   8e6a5:	pop    %rbp
   8e6a6:	ret
   8e6a7:	int3
   8e6a8:	int3
   8e6a9:	int3
   8e6aa:	int3
   8e6ab:	int3
   8e6ac:	int3
   8e6ad:	int3
   8e6ae:	int3
   8e6af:	int3

