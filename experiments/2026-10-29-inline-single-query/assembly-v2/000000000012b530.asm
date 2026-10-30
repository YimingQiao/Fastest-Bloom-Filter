000000000012b530 <void inline_single_kernel<true, boost_baseline::Adapter<6ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<6ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
  12b530:	test   %rsi,%rsi
  12b533:	je     12b5ab <void inline_single_kernel<true, boost_baseline::Adapter<6ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<6ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x7b>
  12b535:	push   %rbp
  12b536:	push   %r15
  12b538:	push   %r14
  12b53a:	push   %r13
  12b53c:	push   %r12
  12b53e:	push   %rbx
  12b53f:	push   %rax
  12b540:	mov    %rcx,%rbx
  12b543:	mov    %rdx,%r14
  12b546:	mov    %rsi,%r15
  12b549:	mov    %rdi,%r12
  12b54c:	movabs $0xd6e8feb86659fd93,%r13
  12b556:	xor    %ebp,%ebp
  12b558:	nopl   0x0(%rax,%rax,1)
  12b560:	mov    (%r14,%rbp,8),%rax
  12b564:	mov    %rax,%rcx
  12b567:	shr    $0x20,%rcx
  12b56b:	xor    %rax,%rcx
  12b56e:	imul   %r13,%rcx
  12b572:	mov    %rcx,%rax
  12b575:	shr    $0x20,%rax
  12b579:	xor    %rcx,%rax
  12b57c:	imul   %r13,%rax
  12b580:	mov    %rax,%rsi
  12b583:	shr    $0x20,%rsi
  12b587:	xor    %rax,%rsi
  12b58a:	mov    %r12,%rdi
  12b58d:	call   12cec0 <boost_baseline::Adapter<6ul, boost::bloom::block<unsigned char, 1ul>, 0ul>::ScalarContains(unsigned long) const>
  12b592:	mov    %eax,(%rbx,%rbp,4)
  12b595:	inc    %rbp
  12b598:	cmp    %rbp,%r15
  12b59b:	jne    12b560 <void inline_single_kernel<true, boost_baseline::Adapter<6ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<6ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
  12b59d:	add    $0x8,%rsp
  12b5a1:	pop    %rbx
  12b5a2:	pop    %r12
  12b5a4:	pop    %r13
  12b5a6:	pop    %r14
  12b5a8:	pop    %r15
  12b5aa:	pop    %rbp
  12b5ab:	ret
  12b5ac:	int3
  12b5ad:	int3
  12b5ae:	int3
  12b5af:	int3

