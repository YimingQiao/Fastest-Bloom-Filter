000000000013b4d0 <void inline_single_kernel<true, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
  13b4d0:	test   %rsi,%rsi
  13b4d3:	je     13ba5b <void inline_single_kernel<true, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x58b>
  13b4d9:	push   %rbp
  13b4da:	push   %r15
  13b4dc:	push   %r14
  13b4de:	push   %r13
  13b4e0:	push   %r12
  13b4e2:	push   %rbx
  13b4e3:	mov    %rdx,%rax
  13b4e6:	movabs $0xd6e8feb86659fd93,%r9
  13b4f0:	xor    %r10d,%r10d
  13b4f3:	movabs $0xf1357aea2e62a9c5,%r11
  13b4fd:	movabs $0x1427bb2d3769b199,%rbx
  13b507:	movabs $0x57545799e525abbd,%r14
  13b511:	jmp    13b530 <void inline_single_kernel<true, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x60>
  13b513:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  13b520:	mov    %edx,(%rcx,%r10,4)
  13b524:	inc    %r10
  13b527:	cmp    %r10,%rsi
  13b52a:	je     13ba51 <void inline_single_kernel<true, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x581>
  13b530:	mov    (%rax,%r10,8),%rdx
  13b534:	mov    %rdx,%r8
  13b537:	shr    $0x20,%r8
  13b53b:	xor    %rdx,%r8
  13b53e:	imul   %r9,%r8
  13b542:	mov    %r8,%rdx
  13b545:	shr    $0x20,%rdx
  13b549:	xor    %r8,%rdx
  13b54c:	imul   %r9,%rdx
  13b550:	mov    %rdx,%rbp
  13b553:	shr    $0x20,%rbp
  13b557:	xor    %rdx,%rbp
  13b55a:	or     $0x1,%rbp
  13b55e:	mov    0x10(%rdi),%r8
  13b562:	mov    0x20(%rdi),%r13
  13b566:	mov    %r8,%rdx
  13b569:	mulx   %rbp,%r15,%r15
  13b56e:	prefetcht0 0x0(%r13,%r15,1)
  13b574:	mov    %rbp,%rdx
  13b577:	imul   %r11,%rdx
  13b57b:	mulx   %r8,%r12,%r12
  13b580:	prefetcht0 0x0(%r13,%r12,1)
  13b586:	shr    $0x3,%dl
  13b589:	movzbl 0x0(%r13,%r15,1),%r15d
  13b58f:	movzbl %dl,%edx
  13b592:	and    $0x7,%edx
  13b595:	bt     %edx,%r15d
  13b599:	mov    $0x0,%edx
  13b59e:	jae    13b520 <void inline_single_kernel<true, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  13b5a0:	add    %r13,%r12
  13b5a3:	mov    %rbp,%rdx
  13b5a6:	imul   %rbx,%rdx
  13b5aa:	mulx   %r8,%r15,%r15
  13b5af:	prefetcht0 0x0(%r13,%r15,1)
  13b5b5:	shr    $0x3,%dl
  13b5b8:	movzbl %dl,%edx
  13b5bb:	and    $0x7,%edx
  13b5be:	movzbl (%r12),%r12d
  13b5c3:	bt     %edx,%r12d
  13b5c7:	mov    $0x0,%edx
  13b5cc:	jae    13b520 <void inline_single_kernel<true, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  13b5d2:	add    %r13,%r15
  13b5d5:	mov    %rbp,%rdx
  13b5d8:	imul   %r14,%rdx
  13b5dc:	mulx   %r8,%r12,%r12
  13b5e1:	prefetcht0 0x0(%r13,%r12,1)
  13b5e7:	shr    $0x3,%dl
  13b5ea:	movzbl %dl,%edx
  13b5ed:	and    $0x7,%edx
  13b5f0:	movzbl (%r15),%r15d
  13b5f4:	bt     %edx,%r15d
  13b5f8:	mov    $0x0,%edx
  13b5fd:	jae    13b520 <void inline_single_kernel<true, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  13b603:	add    %r13,%r12
  13b606:	mov    %rbp,%rdx
  13b609:	movabs $0xf53a8bbce8b6ed71,%r15
  13b613:	imul   %r15,%rdx
  13b617:	mulx   %r8,%r15,%r15
  13b61c:	prefetcht0 0x0(%r13,%r15,1)
  13b622:	shr    $0x3,%dl
  13b625:	movzbl %dl,%edx
  13b628:	and    $0x7,%edx
  13b62b:	movzbl (%r12),%r12d
  13b630:	bt     %edx,%r12d
  13b634:	mov    $0x0,%edx
  13b639:	jae    13b520 <void inline_single_kernel<true, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  13b63f:	add    %r13,%r15
  13b642:	mov    %rbp,%rdx
  13b645:	movabs $0x3a3115fb0ac650f5,%r12
  13b64f:	imul   %r12,%rdx
  13b653:	mulx   %r8,%r12,%r12
  13b658:	prefetcht0 0x0(%r13,%r12,1)
  13b65e:	shr    $0x3,%dl
  13b661:	movzbl %dl,%edx
  13b664:	and    $0x7,%edx
  13b667:	movzbl (%r15),%r15d
  13b66b:	bt     %edx,%r15d
  13b66f:	mov    $0x0,%edx
  13b674:	jae    13b520 <void inline_single_kernel<true, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  13b67a:	add    %r13,%r12
  13b67d:	mov    %rbp,%rdx
  13b680:	movabs $0x78e628b539d80989,%r15
  13b68a:	imul   %r15,%rdx
  13b68e:	mulx   %r8,%r15,%r15
  13b693:	prefetcht0 0x0(%r13,%r15,1)
  13b699:	shr    $0x3,%dl
  13b69c:	movzbl %dl,%edx
  13b69f:	and    $0x7,%edx
  13b6a2:	movzbl (%r12),%r12d
  13b6a7:	bt     %edx,%r12d
  13b6ab:	mov    $0x0,%edx
  13b6b0:	jae    13b520 <void inline_single_kernel<true, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  13b6b6:	add    %r13,%r15
  13b6b9:	mov    %rbp,%rdx
  13b6bc:	movabs $0xe622ee4965fcc76d,%r12
  13b6c6:	imul   %r12,%rdx
  13b6ca:	mulx   %r8,%r12,%r12
  13b6cf:	prefetcht0 0x0(%r13,%r12,1)
  13b6d5:	shr    $0x3,%dl
  13b6d8:	movzbl %dl,%edx
  13b6db:	and    $0x7,%edx
  13b6de:	movzbl (%r15),%r15d
  13b6e2:	bt     %edx,%r15d
  13b6e6:	mov    $0x0,%edx
  13b6eb:	jae    13b520 <void inline_single_kernel<true, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  13b6f1:	add    %r13,%r12
  13b6f4:	mov    %rbp,%rdx
  13b6f7:	movabs $0x2745850b48e66be1,%r15
  13b701:	imul   %r15,%rdx
  13b705:	mulx   %r8,%r15,%r15
  13b70a:	prefetcht0 0x0(%r13,%r15,1)
  13b710:	shr    $0x3,%dl
  13b713:	movzbl %dl,%edx
  13b716:	and    $0x7,%edx
  13b719:	movzbl (%r12),%r12d
  13b71e:	bt     %edx,%r12d
  13b722:	mov    $0x0,%edx
  13b727:	jae    13b520 <void inline_single_kernel<true, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  13b72d:	add    %r13,%r15
  13b730:	mov    %rbp,%rdx
  13b733:	movabs $0xab5bfa10f0aa8d25,%r12
  13b73d:	imul   %r12,%rdx
  13b741:	mulx   %r8,%r12,%r12
  13b746:	prefetcht0 0x0(%r13,%r12,1)
  13b74c:	shr    $0x3,%dl
  13b74f:	movzbl %dl,%edx
  13b752:	and    $0x7,%edx
  13b755:	movzbl (%r15),%r15d
  13b759:	bt     %edx,%r15d
  13b75d:	mov    $0x0,%edx
  13b762:	jae    13b520 <void inline_single_kernel<true, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  13b768:	add    %r13,%r12
  13b76b:	mov    %rbp,%rdx
  13b76e:	movabs $0xac690a6278960a79,%r15
  13b778:	imul   %r15,%rdx
  13b77c:	mulx   %r8,%r15,%r15
  13b781:	prefetcht0 0x0(%r13,%r15,1)
  13b787:	shr    $0x3,%dl
  13b78a:	movzbl %dl,%edx
  13b78d:	and    $0x7,%edx
  13b790:	movzbl (%r12),%r12d
  13b795:	bt     %edx,%r12d
  13b799:	mov    $0x0,%edx
  13b79e:	jae    13b520 <void inline_single_kernel<true, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  13b7a4:	add    %r13,%r15
  13b7a7:	mov    %rbp,%rdx
  13b7aa:	movabs $0x7e3d5b4d98b1f01d,%r12
  13b7b4:	imul   %r12,%rdx
  13b7b8:	mulx   %r8,%r12,%r12
  13b7bd:	prefetcht0 0x0(%r13,%r12,1)
  13b7c3:	shr    $0x3,%dl
  13b7c6:	movzbl %dl,%edx
  13b7c9:	and    $0x7,%edx
  13b7cc:	movzbl (%r15),%r15d
  13b7d0:	bt     %edx,%r15d
  13b7d4:	mov    $0x0,%edx
  13b7d9:	jae    13b520 <void inline_single_kernel<true, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  13b7df:	add    %r13,%r12
  13b7e2:	mov    %rbp,%rdx
  13b7e5:	movabs $0xedb63649198aeb51,%r15
  13b7ef:	imul   %r15,%rdx
  13b7f3:	mulx   %r8,%r15,%r15
  13b7f8:	prefetcht0 0x0(%r13,%r15,1)
  13b7fe:	shr    $0x3,%dl
  13b801:	movzbl %dl,%edx
  13b804:	and    $0x7,%edx
  13b807:	movzbl (%r12),%r12d
  13b80c:	bt     %edx,%r12d
  13b810:	mov    $0x0,%edx
  13b815:	jae    13b520 <void inline_single_kernel<true, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  13b81b:	add    %r13,%r15
  13b81e:	mov    %rbp,%rdx
  13b821:	movabs $0xa785779e00418e55,%r12
  13b82b:	imul   %r12,%rdx
  13b82f:	mulx   %r8,%r12,%r12
  13b834:	prefetcht0 0x0(%r13,%r12,1)
  13b83a:	shr    $0x3,%dl
  13b83d:	movzbl %dl,%edx
  13b840:	and    $0x7,%edx
  13b843:	movzbl (%r15),%r15d
  13b847:	bt     %edx,%r15d
  13b84b:	mov    $0x0,%edx
  13b850:	jae    13b520 <void inline_single_kernel<true, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  13b856:	add    %r13,%r12
  13b859:	mov    %rbp,%rdx
  13b85c:	movabs $0x2a8dd71f3bf2a469,%r15
  13b866:	imul   %r15,%rdx
  13b86a:	mulx   %r8,%r15,%r15
  13b86f:	prefetcht0 0x0(%r13,%r15,1)
  13b875:	shr    $0x3,%dl
  13b878:	movzbl %dl,%edx
  13b87b:	and    $0x7,%edx
  13b87e:	movzbl (%r12),%r12d
  13b883:	bt     %edx,%r12d
  13b887:	mov    $0x0,%edx
  13b88c:	jae    13b520 <void inline_single_kernel<true, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  13b892:	add    %r13,%r15
  13b895:	mov    %rbp,%rdx
  13b898:	movabs $0xa9c608041e73d5cd,%r12
  13b8a2:	imul   %r12,%rdx
  13b8a6:	mulx   %r8,%r12,%r12
  13b8ab:	prefetcht0 0x0(%r13,%r12,1)
  13b8b1:	shr    $0x3,%dl
  13b8b4:	movzbl %dl,%edx
  13b8b7:	and    $0x7,%edx
  13b8ba:	movzbl (%r15),%r15d
  13b8be:	bt     %edx,%r15d
  13b8c2:	mov    $0x0,%edx
  13b8c7:	jae    13b520 <void inline_single_kernel<true, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  13b8cd:	add    %r13,%r12
  13b8d0:	mov    %rbp,%rdx
  13b8d3:	movabs $0x79f17b6a95c1dbc1,%r15
  13b8dd:	imul   %r15,%rdx
  13b8e1:	mulx   %r8,%r15,%r15
  13b8e6:	prefetcht0 0x0(%r13,%r15,1)
  13b8ec:	shr    $0x3,%dl
  13b8ef:	movzbl %dl,%edx
  13b8f2:	and    $0x7,%edx
  13b8f5:	movzbl (%r12),%r12d
  13b8fa:	bt     %edx,%r12d
  13b8fe:	mov    $0x0,%edx
  13b903:	jae    13b520 <void inline_single_kernel<true, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  13b909:	add    %r13,%r15
  13b90c:	mov    %rbp,%rdx
  13b90f:	movabs $0x1ce557ff06228485,%r12
  13b919:	imul   %r12,%rdx
  13b91d:	mulx   %r8,%r12,%r12
  13b922:	prefetcht0 0x0(%r13,%r12,1)
  13b928:	shr    $0x3,%dl
  13b92b:	movzbl %dl,%edx
  13b92e:	and    $0x7,%edx
  13b931:	movzbl (%r15),%r15d
  13b935:	bt     %edx,%r15d
  13b939:	mov    $0x0,%edx
  13b93e:	jae    13b520 <void inline_single_kernel<true, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  13b944:	add    %r13,%r12
  13b947:	mov    %rbp,%rdx
  13b94a:	movabs $0xd98c22e522f5c759,%r15
  13b954:	imul   %r15,%rdx
  13b958:	mulx   %r8,%r15,%r15
  13b95d:	prefetcht0 0x0(%r13,%r15,1)
  13b963:	shr    $0x3,%dl
  13b966:	movzbl %dl,%edx
  13b969:	and    $0x7,%edx
  13b96c:	movzbl (%r12),%r12d
  13b971:	bt     %edx,%r12d
  13b975:	mov    $0x0,%edx
  13b97a:	jae    13b520 <void inline_single_kernel<true, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  13b980:	add    %r13,%r15
  13b983:	mov    %rbp,%rdx
  13b986:	movabs $0x97f54baa75ce287d,%r12
  13b990:	imul   %r12,%rdx
  13b994:	mulx   %r8,%r12,%r12
  13b999:	prefetcht0 0x0(%r13,%r12,1)
  13b99f:	shr    $0x3,%dl
  13b9a2:	movzbl %dl,%edx
  13b9a5:	and    $0x7,%edx
  13b9a8:	movzbl (%r15),%r15d
  13b9ac:	bt     %edx,%r15d
  13b9b0:	mov    $0x0,%edx
  13b9b5:	jae    13b520 <void inline_single_kernel<true, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  13b9bb:	add    %r13,%r12
  13b9be:	mov    %rbp,%rdx
  13b9c1:	movabs $0x73c07a65b639ad31,%r15
  13b9cb:	imul   %r15,%rdx
  13b9cf:	mulx   %r8,%r15,%r15
  13b9d4:	prefetcht0 0x0(%r13,%r15,1)
  13b9da:	shr    $0x3,%dl
  13b9dd:	movzbl %dl,%edx
  13b9e0:	and    $0x7,%edx
  13b9e3:	movzbl (%r12),%r12d
  13b9e8:	bt     %edx,%r12d
  13b9ec:	mov    $0x0,%edx
  13b9f1:	jae    13b520 <void inline_single_kernel<true, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  13b9f7:	add    %r13,%r15
  13b9fa:	mov    %rbp,%rdx
  13b9fd:	movabs $0x4f001d8e68799fb5,%r12
  13ba07:	imul   %r12,%rdx
  13ba0b:	mulx   %r8,%r8,%r8
  13ba10:	prefetcht0 0x0(%r13,%r8,1)
  13ba16:	shr    $0x3,%dl
  13ba19:	movzbl %dl,%edx
  13ba1c:	and    $0x7,%edx
  13ba1f:	movzbl (%r15),%r15d
  13ba23:	bt     %edx,%r15d
  13ba27:	mov    $0x0,%edx
  13ba2c:	jae    13b520 <void inline_single_kernel<true, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  13ba32:	add    %r8,%r13
  13ba35:	lea    0x0(%rbp,%rbp,8),%edx
  13ba39:	movzbl 0x0(%r13),%r8d
  13ba3e:	shr    $0x3,%dl
  13ba41:	and    $0x7,%dl
  13ba44:	shrx   %edx,%r8d,%edx
  13ba49:	and    $0x1,%edx
  13ba4c:	jmp    13b520 <void inline_single_kernel<true, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  13ba51:	pop    %rbx
  13ba52:	pop    %r12
  13ba54:	pop    %r13
  13ba56:	pop    %r14
  13ba58:	pop    %r15
  13ba5a:	pop    %rbp
  13ba5b:	ret
  13ba5c:	int3
  13ba5d:	int3
  13ba5e:	int3
  13ba5f:	int3

