000000000012b420 <void inline_single_kernel<false, boost_baseline::Adapter<6ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<6ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
  12b420:	test   %rsi,%rsi
  12b423:	je     12b5be <void inline_single_kernel<false, boost_baseline::Adapter<6ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<6ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x19e>
  12b429:	push   %rbp
  12b42a:	push   %r15
  12b42c:	push   %r14
  12b42e:	push   %r13
  12b430:	push   %r12
  12b432:	push   %rbx
  12b433:	mov    %rdx,%rax
  12b436:	xor    %r9d,%r9d
  12b439:	movabs $0xf1357aea2e62a9c5,%r10
  12b443:	movabs $0x1427bb2d3769b199,%r11
  12b44d:	movabs $0x57545799e525abbd,%rbx
  12b457:	movabs $0xf53a8bbce8b6ed71,%r14
  12b461:	jmp    12b480 <void inline_single_kernel<false, boost_baseline::Adapter<6ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<6ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x60>
  12b463:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  12b470:	mov    %edx,(%rcx,%r9,4)
  12b474:	inc    %r9
  12b477:	cmp    %r9,%rsi
  12b47a:	je     12b5b4 <void inline_single_kernel<false, boost_baseline::Adapter<6ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<6ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x194>
  12b480:	mov    (%rax,%r9,8),%r12
  12b484:	or     $0x1,%r12
  12b488:	mov    0x10(%rdi),%r8
  12b48c:	mov    0x20(%rdi),%r13
  12b490:	mov    %r8,%rdx
  12b493:	mulx   %r12,%r15,%r15
  12b498:	prefetcht0 0x0(%r13,%r15,1)
  12b49e:	mov    %r12,%rdx
  12b4a1:	imul   %r10,%rdx
  12b4a5:	mulx   %r8,%rbp,%rbp
  12b4aa:	prefetcht0 0x0(%r13,%rbp,1)
  12b4b0:	shr    $0x3,%dl
  12b4b3:	movzbl 0x0(%r13,%r15,1),%r15d
  12b4b9:	movzbl %dl,%edx
  12b4bc:	and    $0x7,%edx
  12b4bf:	bt     %edx,%r15d
  12b4c3:	mov    $0x0,%edx
  12b4c8:	jae    12b470 <void inline_single_kernel<false, boost_baseline::Adapter<6ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<6ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  12b4ca:	add    %r13,%rbp
  12b4cd:	mov    %r12,%rdx
  12b4d0:	imul   %r11,%rdx
  12b4d4:	mulx   %r8,%r15,%r15
  12b4d9:	prefetcht0 0x0(%r13,%r15,1)
  12b4df:	shr    $0x3,%dl
  12b4e2:	movzbl %dl,%edx
  12b4e5:	and    $0x7,%edx
  12b4e8:	movzbl 0x0(%rbp),%ebp
  12b4ec:	bt     %edx,%ebp
  12b4ef:	mov    $0x0,%edx
  12b4f4:	jae    12b470 <void inline_single_kernel<false, boost_baseline::Adapter<6ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<6ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  12b4fa:	add    %r13,%r15
  12b4fd:	mov    %r12,%rdx
  12b500:	imul   %rbx,%rdx
  12b504:	mulx   %r8,%rbp,%rbp
  12b509:	prefetcht0 0x0(%r13,%rbp,1)
  12b50f:	shr    $0x3,%dl
  12b512:	movzbl %dl,%edx
  12b515:	and    $0x7,%edx
  12b518:	movzbl (%r15),%r15d
  12b51c:	bt     %edx,%r15d
  12b520:	mov    $0x0,%edx
  12b525:	jae    12b470 <void inline_single_kernel<false, boost_baseline::Adapter<6ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<6ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  12b52b:	add    %r13,%rbp
  12b52e:	mov    %r12,%rdx
  12b531:	imul   %r14,%rdx
  12b535:	mulx   %r8,%r15,%r15
  12b53a:	prefetcht0 0x0(%r13,%r15,1)
  12b540:	shr    $0x3,%dl
  12b543:	movzbl %dl,%edx
  12b546:	and    $0x7,%edx
  12b549:	movzbl 0x0(%rbp),%ebp
  12b54d:	bt     %edx,%ebp
  12b550:	mov    $0x0,%edx
  12b555:	jae    12b470 <void inline_single_kernel<false, boost_baseline::Adapter<6ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<6ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  12b55b:	add    %r13,%r15
  12b55e:	mov    %r12,%rdx
  12b561:	movabs $0x3a3115fb0ac650f5,%rbp
  12b56b:	imul   %rbp,%rdx
  12b56f:	mulx   %r8,%r8,%r8
  12b574:	prefetcht0 0x0(%r13,%r8,1)
  12b57a:	shr    $0x3,%dl
  12b57d:	movzbl %dl,%edx
  12b580:	and    $0x7,%edx
  12b583:	movzbl (%r15),%ebp
  12b587:	bt     %edx,%ebp
  12b58a:	mov    $0x0,%edx
  12b58f:	jae    12b470 <void inline_single_kernel<false, boost_baseline::Adapter<6ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<6ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  12b595:	add    %r8,%r13
  12b598:	lea    (%r12,%r12,8),%edx
  12b59c:	movzbl 0x0(%r13),%r8d
  12b5a1:	shr    $0x3,%dl
  12b5a4:	and    $0x7,%dl
  12b5a7:	shrx   %edx,%r8d,%edx
  12b5ac:	and    $0x1,%edx
  12b5af:	jmp    12b470 <void inline_single_kernel<false, boost_baseline::Adapter<6ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<6ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  12b5b4:	pop    %rbx
  12b5b5:	pop    %r12
  12b5b7:	pop    %r13
  12b5b9:	pop    %r14
  12b5bb:	pop    %r15
  12b5bd:	pop    %rbp
  12b5be:	ret
  12b5bf:	int3

