000000000012b9a0 <void inline_single_kernel<true, boost_baseline::Adapter<6ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<6ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
  12b9a0:	test   %rsi,%rsi
  12b9a3:	je     12bb74 <void inline_single_kernel<true, boost_baseline::Adapter<6ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<6ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x1d4>
  12b9a9:	push   %rbp
  12b9aa:	push   %r15
  12b9ac:	push   %r14
  12b9ae:	push   %r13
  12b9b0:	push   %r12
  12b9b2:	push   %rbx
  12b9b3:	mov    %rdx,%rax
  12b9b6:	movabs $0xd6e8feb86659fd93,%r9
  12b9c0:	xor    %r10d,%r10d
  12b9c3:	movabs $0xf1357aea2e62a9c5,%r11
  12b9cd:	movabs $0x1427bb2d3769b199,%rbx
  12b9d7:	movabs $0x57545799e525abbd,%r14
  12b9e1:	jmp    12ba00 <void inline_single_kernel<true, boost_baseline::Adapter<6ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<6ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x60>
  12b9e3:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  12b9f0:	mov    %edx,(%rcx,%r10,4)
  12b9f4:	inc    %r10
  12b9f7:	cmp    %r10,%rsi
  12b9fa:	je     12bb6a <void inline_single_kernel<true, boost_baseline::Adapter<6ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<6ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x1ca>
  12ba00:	mov    (%rax,%r10,8),%rdx
  12ba04:	mov    %rdx,%r8
  12ba07:	shr    $0x20,%r8
  12ba0b:	xor    %rdx,%r8
  12ba0e:	imul   %r9,%r8
  12ba12:	mov    %r8,%rdx
  12ba15:	shr    $0x20,%rdx
  12ba19:	xor    %r8,%rdx
  12ba1c:	imul   %r9,%rdx
  12ba20:	mov    %rdx,%r13
  12ba23:	shr    $0x20,%r13
  12ba27:	xor    %rdx,%r13
  12ba2a:	or     $0x1,%r13
  12ba2e:	mov    0x10(%rdi),%r8
  12ba32:	mov    0x20(%rdi),%rbp
  12ba36:	mov    %r8,%rdx
  12ba39:	mulx   %r13,%r15,%r15
  12ba3e:	prefetcht0 0x0(%rbp,%r15,1)
  12ba44:	mov    %r13,%rdx
  12ba47:	imul   %r11,%rdx
  12ba4b:	mulx   %r8,%r12,%r12
  12ba50:	prefetcht0 0x0(%rbp,%r12,1)
  12ba56:	shr    $0x3,%dl
  12ba59:	movzbl 0x0(%rbp,%r15,1),%r15d
  12ba5f:	movzbl %dl,%edx
  12ba62:	and    $0x7,%edx
  12ba65:	bt     %edx,%r15d
  12ba69:	mov    $0x0,%edx
  12ba6e:	jae    12b9f0 <void inline_single_kernel<true, boost_baseline::Adapter<6ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<6ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  12ba70:	add    %rbp,%r12
  12ba73:	mov    %r13,%rdx
  12ba76:	imul   %rbx,%rdx
  12ba7a:	mulx   %r8,%r15,%r15
  12ba7f:	prefetcht0 0x0(%rbp,%r15,1)
  12ba85:	shr    $0x3,%dl
  12ba88:	movzbl %dl,%edx
  12ba8b:	and    $0x7,%edx
  12ba8e:	movzbl (%r12),%r12d
  12ba93:	bt     %edx,%r12d
  12ba97:	mov    $0x0,%edx
  12ba9c:	jae    12b9f0 <void inline_single_kernel<true, boost_baseline::Adapter<6ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<6ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  12baa2:	add    %rbp,%r15
  12baa5:	mov    %r13,%rdx
  12baa8:	imul   %r14,%rdx
  12baac:	mulx   %r8,%r12,%r12
  12bab1:	prefetcht0 0x0(%rbp,%r12,1)
  12bab7:	shr    $0x3,%dl
  12baba:	movzbl %dl,%edx
  12babd:	and    $0x7,%edx
  12bac0:	movzbl (%r15),%r15d
  12bac4:	bt     %edx,%r15d
  12bac8:	mov    $0x0,%edx
  12bacd:	jae    12b9f0 <void inline_single_kernel<true, boost_baseline::Adapter<6ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<6ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  12bad3:	add    %rbp,%r12
  12bad6:	mov    %r13,%rdx
  12bad9:	movabs $0xf53a8bbce8b6ed71,%r15
  12bae3:	imul   %r15,%rdx
  12bae7:	mulx   %r8,%r15,%r15
  12baec:	prefetcht0 0x0(%rbp,%r15,1)
  12baf2:	shr    $0x3,%dl
  12baf5:	movzbl %dl,%edx
  12baf8:	and    $0x7,%edx
  12bafb:	movzbl (%r12),%r12d
  12bb00:	bt     %edx,%r12d
  12bb04:	mov    $0x0,%edx
  12bb09:	jae    12b9f0 <void inline_single_kernel<true, boost_baseline::Adapter<6ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<6ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  12bb0f:	add    %rbp,%r15
  12bb12:	mov    %r13,%rdx
  12bb15:	movabs $0x3a3115fb0ac650f5,%r12
  12bb1f:	imul   %r12,%rdx
  12bb23:	mulx   %r8,%r8,%r8
  12bb28:	prefetcht0 0x0(%rbp,%r8,1)
  12bb2e:	shr    $0x3,%dl
  12bb31:	movzbl %dl,%edx
  12bb34:	and    $0x7,%edx
  12bb37:	movzbl (%r15),%r15d
  12bb3b:	bt     %edx,%r15d
  12bb3f:	mov    $0x0,%edx
  12bb44:	jae    12b9f0 <void inline_single_kernel<true, boost_baseline::Adapter<6ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<6ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  12bb4a:	add    %r8,%rbp
  12bb4d:	lea    0x0(%r13,%r13,8),%edx
  12bb52:	movzbl 0x0(%rbp),%r8d
  12bb57:	shr    $0x3,%dl
  12bb5a:	and    $0x7,%dl
  12bb5d:	shrx   %edx,%r8d,%edx
  12bb62:	and    $0x1,%edx
  12bb65:	jmp    12b9f0 <void inline_single_kernel<true, boost_baseline::Adapter<6ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<6ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  12bb6a:	pop    %rbx
  12bb6b:	pop    %r12
  12bb6d:	pop    %r13
  12bb6f:	pop    %r14
  12bb71:	pop    %r15
  12bb73:	pop    %rbp
  12bb74:	ret
  12bb75:	int3
  12bb76:	int3
  12bb77:	int3
  12bb78:	int3
  12bb79:	int3
  12bb7a:	int3
  12bb7b:	int3
  12bb7c:	int3
  12bb7d:	int3
  12bb7e:	int3
  12bb7f:	int3

