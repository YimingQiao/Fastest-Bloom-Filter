000000000013ab90 <void inline_single_kernel<false, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
  13ab90:	test   %rsi,%rsi
  13ab93:	je     13b0eb <void inline_single_kernel<false, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x55b>
  13ab99:	push   %rbp
  13ab9a:	push   %r15
  13ab9c:	push   %r14
  13ab9e:	push   %r13
  13aba0:	push   %r12
  13aba2:	push   %rbx
  13aba3:	mov    %rdx,%rax
  13aba6:	xor    %r9d,%r9d
  13aba9:	movabs $0xf1357aea2e62a9c5,%r10
  13abb3:	movabs $0x1427bb2d3769b199,%r11
  13abbd:	movabs $0x57545799e525abbd,%rbx
  13abc7:	movabs $0xf53a8bbce8b6ed71,%r14
  13abd1:	jmp    13abf0 <void inline_single_kernel<false, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x60>
  13abd3:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  13abe0:	mov    %edx,(%rcx,%r9,4)
  13abe4:	inc    %r9
  13abe7:	cmp    %r9,%rsi
  13abea:	je     13b0e1 <void inline_single_kernel<false, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x551>
  13abf0:	mov    (%rax,%r9,8),%rbp
  13abf4:	or     $0x1,%rbp
  13abf8:	mov    0x10(%rdi),%r8
  13abfc:	mov    0x20(%rdi),%r13
  13ac00:	mov    %r8,%rdx
  13ac03:	mulx   %rbp,%r15,%r15
  13ac08:	prefetcht0 0x0(%r13,%r15,1)
  13ac0e:	mov    %rbp,%rdx
  13ac11:	imul   %r10,%rdx
  13ac15:	mulx   %r8,%r12,%r12
  13ac1a:	prefetcht0 0x0(%r13,%r12,1)
  13ac20:	shr    $0x3,%dl
  13ac23:	movzbl 0x0(%r13,%r15,1),%r15d
  13ac29:	movzbl %dl,%edx
  13ac2c:	and    $0x7,%edx
  13ac2f:	bt     %edx,%r15d
  13ac33:	mov    $0x0,%edx
  13ac38:	jae    13abe0 <void inline_single_kernel<false, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  13ac3a:	add    %r13,%r12
  13ac3d:	mov    %rbp,%rdx
  13ac40:	imul   %r11,%rdx
  13ac44:	mulx   %r8,%r15,%r15
  13ac49:	prefetcht0 0x0(%r13,%r15,1)
  13ac4f:	shr    $0x3,%dl
  13ac52:	movzbl %dl,%edx
  13ac55:	and    $0x7,%edx
  13ac58:	movzbl (%r12),%r12d
  13ac5d:	bt     %edx,%r12d
  13ac61:	mov    $0x0,%edx
  13ac66:	jae    13abe0 <void inline_single_kernel<false, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  13ac6c:	add    %r13,%r15
  13ac6f:	mov    %rbp,%rdx
  13ac72:	imul   %rbx,%rdx
  13ac76:	mulx   %r8,%r12,%r12
  13ac7b:	prefetcht0 0x0(%r13,%r12,1)
  13ac81:	shr    $0x3,%dl
  13ac84:	movzbl %dl,%edx
  13ac87:	and    $0x7,%edx
  13ac8a:	movzbl (%r15),%r15d
  13ac8e:	bt     %edx,%r15d
  13ac92:	mov    $0x0,%edx
  13ac97:	jae    13abe0 <void inline_single_kernel<false, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  13ac9d:	add    %r13,%r12
  13aca0:	mov    %rbp,%rdx
  13aca3:	imul   %r14,%rdx
  13aca7:	mulx   %r8,%r15,%r15
  13acac:	prefetcht0 0x0(%r13,%r15,1)
  13acb2:	shr    $0x3,%dl
  13acb5:	movzbl %dl,%edx
  13acb8:	and    $0x7,%edx
  13acbb:	movzbl (%r12),%r12d
  13acc0:	bt     %edx,%r12d
  13acc4:	mov    $0x0,%edx
  13acc9:	jae    13abe0 <void inline_single_kernel<false, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  13accf:	add    %r13,%r15
  13acd2:	mov    %rbp,%rdx
  13acd5:	movabs $0x3a3115fb0ac650f5,%r12
  13acdf:	imul   %r12,%rdx
  13ace3:	mulx   %r8,%r12,%r12
  13ace8:	prefetcht0 0x0(%r13,%r12,1)
  13acee:	shr    $0x3,%dl
  13acf1:	movzbl %dl,%edx
  13acf4:	and    $0x7,%edx
  13acf7:	movzbl (%r15),%r15d
  13acfb:	bt     %edx,%r15d
  13acff:	mov    $0x0,%edx
  13ad04:	jae    13abe0 <void inline_single_kernel<false, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  13ad0a:	add    %r13,%r12
  13ad0d:	mov    %rbp,%rdx
  13ad10:	movabs $0x78e628b539d80989,%r15
  13ad1a:	imul   %r15,%rdx
  13ad1e:	mulx   %r8,%r15,%r15
  13ad23:	prefetcht0 0x0(%r13,%r15,1)
  13ad29:	shr    $0x3,%dl
  13ad2c:	movzbl %dl,%edx
  13ad2f:	and    $0x7,%edx
  13ad32:	movzbl (%r12),%r12d
  13ad37:	bt     %edx,%r12d
  13ad3b:	mov    $0x0,%edx
  13ad40:	jae    13abe0 <void inline_single_kernel<false, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  13ad46:	add    %r13,%r15
  13ad49:	mov    %rbp,%rdx
  13ad4c:	movabs $0xe622ee4965fcc76d,%r12
  13ad56:	imul   %r12,%rdx
  13ad5a:	mulx   %r8,%r12,%r12
  13ad5f:	prefetcht0 0x0(%r13,%r12,1)
  13ad65:	shr    $0x3,%dl
  13ad68:	movzbl %dl,%edx
  13ad6b:	and    $0x7,%edx
  13ad6e:	movzbl (%r15),%r15d
  13ad72:	bt     %edx,%r15d
  13ad76:	mov    $0x0,%edx
  13ad7b:	jae    13abe0 <void inline_single_kernel<false, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  13ad81:	add    %r13,%r12
  13ad84:	mov    %rbp,%rdx
  13ad87:	movabs $0x2745850b48e66be1,%r15
  13ad91:	imul   %r15,%rdx
  13ad95:	mulx   %r8,%r15,%r15
  13ad9a:	prefetcht0 0x0(%r13,%r15,1)
  13ada0:	shr    $0x3,%dl
  13ada3:	movzbl %dl,%edx
  13ada6:	and    $0x7,%edx
  13ada9:	movzbl (%r12),%r12d
  13adae:	bt     %edx,%r12d
  13adb2:	mov    $0x0,%edx
  13adb7:	jae    13abe0 <void inline_single_kernel<false, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  13adbd:	add    %r13,%r15
  13adc0:	mov    %rbp,%rdx
  13adc3:	movabs $0xab5bfa10f0aa8d25,%r12
  13adcd:	imul   %r12,%rdx
  13add1:	mulx   %r8,%r12,%r12
  13add6:	prefetcht0 0x0(%r13,%r12,1)
  13addc:	shr    $0x3,%dl
  13addf:	movzbl %dl,%edx
  13ade2:	and    $0x7,%edx
  13ade5:	movzbl (%r15),%r15d
  13ade9:	bt     %edx,%r15d
  13aded:	mov    $0x0,%edx
  13adf2:	jae    13abe0 <void inline_single_kernel<false, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  13adf8:	add    %r13,%r12
  13adfb:	mov    %rbp,%rdx
  13adfe:	movabs $0xac690a6278960a79,%r15
  13ae08:	imul   %r15,%rdx
  13ae0c:	mulx   %r8,%r15,%r15
  13ae11:	prefetcht0 0x0(%r13,%r15,1)
  13ae17:	shr    $0x3,%dl
  13ae1a:	movzbl %dl,%edx
  13ae1d:	and    $0x7,%edx
  13ae20:	movzbl (%r12),%r12d
  13ae25:	bt     %edx,%r12d
  13ae29:	mov    $0x0,%edx
  13ae2e:	jae    13abe0 <void inline_single_kernel<false, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  13ae34:	add    %r13,%r15
  13ae37:	mov    %rbp,%rdx
  13ae3a:	movabs $0x7e3d5b4d98b1f01d,%r12
  13ae44:	imul   %r12,%rdx
  13ae48:	mulx   %r8,%r12,%r12
  13ae4d:	prefetcht0 0x0(%r13,%r12,1)
  13ae53:	shr    $0x3,%dl
  13ae56:	movzbl %dl,%edx
  13ae59:	and    $0x7,%edx
  13ae5c:	movzbl (%r15),%r15d
  13ae60:	bt     %edx,%r15d
  13ae64:	mov    $0x0,%edx
  13ae69:	jae    13abe0 <void inline_single_kernel<false, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  13ae6f:	add    %r13,%r12
  13ae72:	mov    %rbp,%rdx
  13ae75:	movabs $0xedb63649198aeb51,%r15
  13ae7f:	imul   %r15,%rdx
  13ae83:	mulx   %r8,%r15,%r15
  13ae88:	prefetcht0 0x0(%r13,%r15,1)
  13ae8e:	shr    $0x3,%dl
  13ae91:	movzbl %dl,%edx
  13ae94:	and    $0x7,%edx
  13ae97:	movzbl (%r12),%r12d
  13ae9c:	bt     %edx,%r12d
  13aea0:	mov    $0x0,%edx
  13aea5:	jae    13abe0 <void inline_single_kernel<false, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  13aeab:	add    %r13,%r15
  13aeae:	mov    %rbp,%rdx
  13aeb1:	movabs $0xa785779e00418e55,%r12
  13aebb:	imul   %r12,%rdx
  13aebf:	mulx   %r8,%r12,%r12
  13aec4:	prefetcht0 0x0(%r13,%r12,1)
  13aeca:	shr    $0x3,%dl
  13aecd:	movzbl %dl,%edx
  13aed0:	and    $0x7,%edx
  13aed3:	movzbl (%r15),%r15d
  13aed7:	bt     %edx,%r15d
  13aedb:	mov    $0x0,%edx
  13aee0:	jae    13abe0 <void inline_single_kernel<false, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  13aee6:	add    %r13,%r12
  13aee9:	mov    %rbp,%rdx
  13aeec:	movabs $0x2a8dd71f3bf2a469,%r15
  13aef6:	imul   %r15,%rdx
  13aefa:	mulx   %r8,%r15,%r15
  13aeff:	prefetcht0 0x0(%r13,%r15,1)
  13af05:	shr    $0x3,%dl
  13af08:	movzbl %dl,%edx
  13af0b:	and    $0x7,%edx
  13af0e:	movzbl (%r12),%r12d
  13af13:	bt     %edx,%r12d
  13af17:	mov    $0x0,%edx
  13af1c:	jae    13abe0 <void inline_single_kernel<false, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  13af22:	add    %r13,%r15
  13af25:	mov    %rbp,%rdx
  13af28:	movabs $0xa9c608041e73d5cd,%r12
  13af32:	imul   %r12,%rdx
  13af36:	mulx   %r8,%r12,%r12
  13af3b:	prefetcht0 0x0(%r13,%r12,1)
  13af41:	shr    $0x3,%dl
  13af44:	movzbl %dl,%edx
  13af47:	and    $0x7,%edx
  13af4a:	movzbl (%r15),%r15d
  13af4e:	bt     %edx,%r15d
  13af52:	mov    $0x0,%edx
  13af57:	jae    13abe0 <void inline_single_kernel<false, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  13af5d:	add    %r13,%r12
  13af60:	mov    %rbp,%rdx
  13af63:	movabs $0x79f17b6a95c1dbc1,%r15
  13af6d:	imul   %r15,%rdx
  13af71:	mulx   %r8,%r15,%r15
  13af76:	prefetcht0 0x0(%r13,%r15,1)
  13af7c:	shr    $0x3,%dl
  13af7f:	movzbl %dl,%edx
  13af82:	and    $0x7,%edx
  13af85:	movzbl (%r12),%r12d
  13af8a:	bt     %edx,%r12d
  13af8e:	mov    $0x0,%edx
  13af93:	jae    13abe0 <void inline_single_kernel<false, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  13af99:	add    %r13,%r15
  13af9c:	mov    %rbp,%rdx
  13af9f:	movabs $0x1ce557ff06228485,%r12
  13afa9:	imul   %r12,%rdx
  13afad:	mulx   %r8,%r12,%r12
  13afb2:	prefetcht0 0x0(%r13,%r12,1)
  13afb8:	shr    $0x3,%dl
  13afbb:	movzbl %dl,%edx
  13afbe:	and    $0x7,%edx
  13afc1:	movzbl (%r15),%r15d
  13afc5:	bt     %edx,%r15d
  13afc9:	mov    $0x0,%edx
  13afce:	jae    13abe0 <void inline_single_kernel<false, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  13afd4:	add    %r13,%r12
  13afd7:	mov    %rbp,%rdx
  13afda:	movabs $0xd98c22e522f5c759,%r15
  13afe4:	imul   %r15,%rdx
  13afe8:	mulx   %r8,%r15,%r15
  13afed:	prefetcht0 0x0(%r13,%r15,1)
  13aff3:	shr    $0x3,%dl
  13aff6:	movzbl %dl,%edx
  13aff9:	and    $0x7,%edx
  13affc:	movzbl (%r12),%r12d
  13b001:	bt     %edx,%r12d
  13b005:	mov    $0x0,%edx
  13b00a:	jae    13abe0 <void inline_single_kernel<false, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  13b010:	add    %r13,%r15
  13b013:	mov    %rbp,%rdx
  13b016:	movabs $0x97f54baa75ce287d,%r12
  13b020:	imul   %r12,%rdx
  13b024:	mulx   %r8,%r12,%r12
  13b029:	prefetcht0 0x0(%r13,%r12,1)
  13b02f:	shr    $0x3,%dl
  13b032:	movzbl %dl,%edx
  13b035:	and    $0x7,%edx
  13b038:	movzbl (%r15),%r15d
  13b03c:	bt     %edx,%r15d
  13b040:	mov    $0x0,%edx
  13b045:	jae    13abe0 <void inline_single_kernel<false, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  13b04b:	add    %r13,%r12
  13b04e:	mov    %rbp,%rdx
  13b051:	movabs $0x73c07a65b639ad31,%r15
  13b05b:	imul   %r15,%rdx
  13b05f:	mulx   %r8,%r15,%r15
  13b064:	prefetcht0 0x0(%r13,%r15,1)
  13b06a:	shr    $0x3,%dl
  13b06d:	movzbl %dl,%edx
  13b070:	and    $0x7,%edx
  13b073:	movzbl (%r12),%r12d
  13b078:	bt     %edx,%r12d
  13b07c:	mov    $0x0,%edx
  13b081:	jae    13abe0 <void inline_single_kernel<false, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  13b087:	add    %r13,%r15
  13b08a:	mov    %rbp,%rdx
  13b08d:	movabs $0x4f001d8e68799fb5,%r12
  13b097:	imul   %r12,%rdx
  13b09b:	mulx   %r8,%r8,%r8
  13b0a0:	prefetcht0 0x0(%r13,%r8,1)
  13b0a6:	shr    $0x3,%dl
  13b0a9:	movzbl %dl,%edx
  13b0ac:	and    $0x7,%edx
  13b0af:	movzbl (%r15),%r15d
  13b0b3:	bt     %edx,%r15d
  13b0b7:	mov    $0x0,%edx
  13b0bc:	jae    13abe0 <void inline_single_kernel<false, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  13b0c2:	add    %r8,%r13
  13b0c5:	lea    0x0(%rbp,%rbp,8),%edx
  13b0c9:	movzbl 0x0(%r13),%r8d
  13b0ce:	shr    $0x3,%dl
  13b0d1:	and    $0x7,%dl
  13b0d4:	shrx   %edx,%r8d,%edx
  13b0d9:	and    $0x1,%edx
  13b0dc:	jmp    13abe0 <void inline_single_kernel<false, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  13b0e1:	pop    %rbx
  13b0e2:	pop    %r12
  13b0e4:	pop    %r13
  13b0e6:	pop    %r14
  13b0e8:	pop    %r15
  13b0ea:	pop    %rbp
  13b0eb:	ret
  13b0ec:	int3
  13b0ed:	int3
  13b0ee:	int3
  13b0ef:	int3

