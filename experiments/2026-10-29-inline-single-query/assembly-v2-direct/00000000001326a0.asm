00000000001326a0 <void inline_single_kernel<false, boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
  1326a0:	test   %rsi,%rsi
  1326a3:	je     132977 <void inline_single_kernel<false, boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x2d7>
  1326a9:	push   %rbp
  1326aa:	push   %r15
  1326ac:	push   %r14
  1326ae:	push   %r13
  1326b0:	push   %r12
  1326b2:	push   %rbx
  1326b3:	mov    %rdx,%rax
  1326b6:	xor    %r9d,%r9d
  1326b9:	movabs $0xf1357aea2e62a9c5,%r10
  1326c3:	movabs $0x1427bb2d3769b199,%r11
  1326cd:	movabs $0x57545799e525abbd,%rbx
  1326d7:	movabs $0xf53a8bbce8b6ed71,%r14
  1326e1:	jmp    132700 <void inline_single_kernel<false, boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x60>
  1326e3:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  1326f0:	mov    %edx,(%rcx,%r9,4)
  1326f4:	inc    %r9
  1326f7:	cmp    %r9,%rsi
  1326fa:	je     13296d <void inline_single_kernel<false, boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x2cd>
  132700:	mov    (%rax,%r9,8),%r13
  132704:	or     $0x1,%r13
  132708:	mov    0x10(%rdi),%r8
  13270c:	mov    0x20(%rdi),%rbp
  132710:	mov    %r8,%rdx
  132713:	mulx   %r13,%r15,%r15
  132718:	prefetcht0 0x0(%rbp,%r15,1)
  13271e:	mov    %r13,%rdx
  132721:	imul   %r10,%rdx
  132725:	mulx   %r8,%r12,%r12
  13272a:	prefetcht0 0x0(%rbp,%r12,1)
  132730:	shr    $0x3,%dl
  132733:	movzbl 0x0(%rbp,%r15,1),%r15d
  132739:	movzbl %dl,%edx
  13273c:	and    $0x7,%edx
  13273f:	bt     %edx,%r15d
  132743:	mov    $0x0,%edx
  132748:	jae    1326f0 <void inline_single_kernel<false, boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  13274a:	add    %rbp,%r12
  13274d:	mov    %r13,%rdx
  132750:	imul   %r11,%rdx
  132754:	mulx   %r8,%r15,%r15
  132759:	prefetcht0 0x0(%rbp,%r15,1)
  13275f:	shr    $0x3,%dl
  132762:	movzbl %dl,%edx
  132765:	and    $0x7,%edx
  132768:	movzbl (%r12),%r12d
  13276d:	bt     %edx,%r12d
  132771:	mov    $0x0,%edx
  132776:	jae    1326f0 <void inline_single_kernel<false, boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  13277c:	add    %rbp,%r15
  13277f:	mov    %r13,%rdx
  132782:	imul   %rbx,%rdx
  132786:	mulx   %r8,%r12,%r12
  13278b:	prefetcht0 0x0(%rbp,%r12,1)
  132791:	shr    $0x3,%dl
  132794:	movzbl %dl,%edx
  132797:	and    $0x7,%edx
  13279a:	movzbl (%r15),%r15d
  13279e:	bt     %edx,%r15d
  1327a2:	mov    $0x0,%edx
  1327a7:	jae    1326f0 <void inline_single_kernel<false, boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  1327ad:	add    %rbp,%r12
  1327b0:	mov    %r13,%rdx
  1327b3:	imul   %r14,%rdx
  1327b7:	mulx   %r8,%r15,%r15
  1327bc:	prefetcht0 0x0(%rbp,%r15,1)
  1327c2:	shr    $0x3,%dl
  1327c5:	movzbl %dl,%edx
  1327c8:	and    $0x7,%edx
  1327cb:	movzbl (%r12),%r12d
  1327d0:	bt     %edx,%r12d
  1327d4:	mov    $0x0,%edx
  1327d9:	jae    1326f0 <void inline_single_kernel<false, boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  1327df:	add    %rbp,%r15
  1327e2:	mov    %r13,%rdx
  1327e5:	movabs $0x3a3115fb0ac650f5,%r12
  1327ef:	imul   %r12,%rdx
  1327f3:	mulx   %r8,%r12,%r12
  1327f8:	prefetcht0 0x0(%rbp,%r12,1)
  1327fe:	shr    $0x3,%dl
  132801:	movzbl %dl,%edx
  132804:	and    $0x7,%edx
  132807:	movzbl (%r15),%r15d
  13280b:	bt     %edx,%r15d
  13280f:	mov    $0x0,%edx
  132814:	jae    1326f0 <void inline_single_kernel<false, boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  13281a:	add    %rbp,%r12
  13281d:	mov    %r13,%rdx
  132820:	movabs $0x78e628b539d80989,%r15
  13282a:	imul   %r15,%rdx
  13282e:	mulx   %r8,%r15,%r15
  132833:	prefetcht0 0x0(%rbp,%r15,1)
  132839:	shr    $0x3,%dl
  13283c:	movzbl %dl,%edx
  13283f:	and    $0x7,%edx
  132842:	movzbl (%r12),%r12d
  132847:	bt     %edx,%r12d
  13284b:	mov    $0x0,%edx
  132850:	jae    1326f0 <void inline_single_kernel<false, boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  132856:	add    %rbp,%r15
  132859:	mov    %r13,%rdx
  13285c:	movabs $0xe622ee4965fcc76d,%r12
  132866:	imul   %r12,%rdx
  13286a:	mulx   %r8,%r12,%r12
  13286f:	prefetcht0 0x0(%rbp,%r12,1)
  132875:	shr    $0x3,%dl
  132878:	movzbl %dl,%edx
  13287b:	and    $0x7,%edx
  13287e:	movzbl (%r15),%r15d
  132882:	bt     %edx,%r15d
  132886:	mov    $0x0,%edx
  13288b:	jae    1326f0 <void inline_single_kernel<false, boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  132891:	add    %rbp,%r12
  132894:	mov    %r13,%rdx
  132897:	movabs $0x2745850b48e66be1,%r15
  1328a1:	imul   %r15,%rdx
  1328a5:	mulx   %r8,%r15,%r15
  1328aa:	prefetcht0 0x0(%rbp,%r15,1)
  1328b0:	shr    $0x3,%dl
  1328b3:	movzbl %dl,%edx
  1328b6:	and    $0x7,%edx
  1328b9:	movzbl (%r12),%r12d
  1328be:	bt     %edx,%r12d
  1328c2:	mov    $0x0,%edx
  1328c7:	jae    1326f0 <void inline_single_kernel<false, boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  1328cd:	add    %rbp,%r15
  1328d0:	mov    %r13,%rdx
  1328d3:	movabs $0xab5bfa10f0aa8d25,%r12
  1328dd:	imul   %r12,%rdx
  1328e1:	mulx   %r8,%r12,%r12
  1328e6:	prefetcht0 0x0(%rbp,%r12,1)
  1328ec:	shr    $0x3,%dl
  1328ef:	movzbl %dl,%edx
  1328f2:	and    $0x7,%edx
  1328f5:	movzbl (%r15),%r15d
  1328f9:	bt     %edx,%r15d
  1328fd:	mov    $0x0,%edx
  132902:	jae    1326f0 <void inline_single_kernel<false, boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  132908:	add    %rbp,%r12
  13290b:	mov    %r13,%rdx
  13290e:	movabs $0xac690a6278960a79,%r15
  132918:	imul   %r15,%rdx
  13291c:	mulx   %r8,%r8,%r8
  132921:	prefetcht0 0x0(%rbp,%r8,1)
  132927:	shr    $0x3,%dl
  13292a:	movzbl %dl,%edx
  13292d:	and    $0x7,%edx
  132930:	movzbl (%r12),%r15d
  132935:	bt     %edx,%r15d
  132939:	mov    $0x0,%edx
  13293e:	jae    1326f0 <void inline_single_kernel<false, boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  132944:	add    %r8,%rbp
  132947:	lea    0x0(%r13,%r13,8),%edx
  13294c:	lea    (%rdx,%rdx,2),%edx
  13294f:	add    %r13d,%edx
  132952:	add    %r13d,%edx
  132955:	movzbl 0x0(%rbp),%r8d
  13295a:	shr    $0x3,%dl
  13295d:	and    $0x7,%dl
  132960:	shrx   %edx,%r8d,%edx
  132965:	and    $0x1,%edx
  132968:	jmp    1326f0 <void inline_single_kernel<false, boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  13296d:	pop    %rbx
  13296e:	pop    %r12
  132970:	pop    %r13
  132972:	pop    %r14
  132974:	pop    %r15
  132976:	pop    %rbp
  132977:	ret
  132978:	int3
  132979:	int3
  13297a:	int3
  13297b:	int3
  13297c:	int3
  13297d:	int3
  13297e:	int3
  13297f:	int3

