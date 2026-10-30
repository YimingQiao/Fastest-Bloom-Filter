000000000013a8d0 <void inline_single_kernel<true, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
  13a8d0:	test   %rsi,%rsi
  13a8d3:	je     13ae5b <void inline_single_kernel<true, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x58b>
  13a8d9:	push   %rbp
  13a8da:	push   %r15
  13a8dc:	push   %r14
  13a8de:	push   %r13
  13a8e0:	push   %r12
  13a8e2:	push   %rbx
  13a8e3:	mov    %rdx,%rax
  13a8e6:	movabs $0xd6e8feb86659fd93,%r9
  13a8f0:	xor    %r10d,%r10d
  13a8f3:	movabs $0xf1357aea2e62a9c5,%r11
  13a8fd:	movabs $0x1427bb2d3769b199,%rbx
  13a907:	movabs $0x57545799e525abbd,%r14
  13a911:	jmp    13a930 <void inline_single_kernel<true, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x60>
  13a913:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  13a920:	mov    %edx,(%rcx,%r10,4)
  13a924:	inc    %r10
  13a927:	cmp    %r10,%rsi
  13a92a:	je     13ae51 <void inline_single_kernel<true, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x581>
  13a930:	mov    (%rax,%r10,8),%rdx
  13a934:	mov    %rdx,%r8
  13a937:	shr    $0x20,%r8
  13a93b:	xor    %rdx,%r8
  13a93e:	imul   %r9,%r8
  13a942:	mov    %r8,%rdx
  13a945:	shr    $0x20,%rdx
  13a949:	xor    %r8,%rdx
  13a94c:	imul   %r9,%rdx
  13a950:	mov    %rdx,%rbp
  13a953:	shr    $0x20,%rbp
  13a957:	xor    %rdx,%rbp
  13a95a:	or     $0x1,%rbp
  13a95e:	mov    0x10(%rdi),%r8
  13a962:	mov    0x20(%rdi),%r13
  13a966:	mov    %r8,%rdx
  13a969:	mulx   %rbp,%r15,%r15
  13a96e:	prefetcht0 0x0(%r13,%r15,1)
  13a974:	mov    %rbp,%rdx
  13a977:	imul   %r11,%rdx
  13a97b:	mulx   %r8,%r12,%r12
  13a980:	prefetcht0 0x0(%r13,%r12,1)
  13a986:	shr    $0x3,%dl
  13a989:	movzbl 0x0(%r13,%r15,1),%r15d
  13a98f:	movzbl %dl,%edx
  13a992:	and    $0x7,%edx
  13a995:	bt     %edx,%r15d
  13a999:	mov    $0x0,%edx
  13a99e:	jae    13a920 <void inline_single_kernel<true, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  13a9a0:	add    %r13,%r12
  13a9a3:	mov    %rbp,%rdx
  13a9a6:	imul   %rbx,%rdx
  13a9aa:	mulx   %r8,%r15,%r15
  13a9af:	prefetcht0 0x0(%r13,%r15,1)
  13a9b5:	shr    $0x3,%dl
  13a9b8:	movzbl %dl,%edx
  13a9bb:	and    $0x7,%edx
  13a9be:	movzbl (%r12),%r12d
  13a9c3:	bt     %edx,%r12d
  13a9c7:	mov    $0x0,%edx
  13a9cc:	jae    13a920 <void inline_single_kernel<true, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  13a9d2:	add    %r13,%r15
  13a9d5:	mov    %rbp,%rdx
  13a9d8:	imul   %r14,%rdx
  13a9dc:	mulx   %r8,%r12,%r12
  13a9e1:	prefetcht0 0x0(%r13,%r12,1)
  13a9e7:	shr    $0x3,%dl
  13a9ea:	movzbl %dl,%edx
  13a9ed:	and    $0x7,%edx
  13a9f0:	movzbl (%r15),%r15d
  13a9f4:	bt     %edx,%r15d
  13a9f8:	mov    $0x0,%edx
  13a9fd:	jae    13a920 <void inline_single_kernel<true, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  13aa03:	add    %r13,%r12
  13aa06:	mov    %rbp,%rdx
  13aa09:	movabs $0xf53a8bbce8b6ed71,%r15
  13aa13:	imul   %r15,%rdx
  13aa17:	mulx   %r8,%r15,%r15
  13aa1c:	prefetcht0 0x0(%r13,%r15,1)
  13aa22:	shr    $0x3,%dl
  13aa25:	movzbl %dl,%edx
  13aa28:	and    $0x7,%edx
  13aa2b:	movzbl (%r12),%r12d
  13aa30:	bt     %edx,%r12d
  13aa34:	mov    $0x0,%edx
  13aa39:	jae    13a920 <void inline_single_kernel<true, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  13aa3f:	add    %r13,%r15
  13aa42:	mov    %rbp,%rdx
  13aa45:	movabs $0x3a3115fb0ac650f5,%r12
  13aa4f:	imul   %r12,%rdx
  13aa53:	mulx   %r8,%r12,%r12
  13aa58:	prefetcht0 0x0(%r13,%r12,1)
  13aa5e:	shr    $0x3,%dl
  13aa61:	movzbl %dl,%edx
  13aa64:	and    $0x7,%edx
  13aa67:	movzbl (%r15),%r15d
  13aa6b:	bt     %edx,%r15d
  13aa6f:	mov    $0x0,%edx
  13aa74:	jae    13a920 <void inline_single_kernel<true, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  13aa7a:	add    %r13,%r12
  13aa7d:	mov    %rbp,%rdx
  13aa80:	movabs $0x78e628b539d80989,%r15
  13aa8a:	imul   %r15,%rdx
  13aa8e:	mulx   %r8,%r15,%r15
  13aa93:	prefetcht0 0x0(%r13,%r15,1)
  13aa99:	shr    $0x3,%dl
  13aa9c:	movzbl %dl,%edx
  13aa9f:	and    $0x7,%edx
  13aaa2:	movzbl (%r12),%r12d
  13aaa7:	bt     %edx,%r12d
  13aaab:	mov    $0x0,%edx
  13aab0:	jae    13a920 <void inline_single_kernel<true, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  13aab6:	add    %r13,%r15
  13aab9:	mov    %rbp,%rdx
  13aabc:	movabs $0xe622ee4965fcc76d,%r12
  13aac6:	imul   %r12,%rdx
  13aaca:	mulx   %r8,%r12,%r12
  13aacf:	prefetcht0 0x0(%r13,%r12,1)
  13aad5:	shr    $0x3,%dl
  13aad8:	movzbl %dl,%edx
  13aadb:	and    $0x7,%edx
  13aade:	movzbl (%r15),%r15d
  13aae2:	bt     %edx,%r15d
  13aae6:	mov    $0x0,%edx
  13aaeb:	jae    13a920 <void inline_single_kernel<true, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  13aaf1:	add    %r13,%r12
  13aaf4:	mov    %rbp,%rdx
  13aaf7:	movabs $0x2745850b48e66be1,%r15
  13ab01:	imul   %r15,%rdx
  13ab05:	mulx   %r8,%r15,%r15
  13ab0a:	prefetcht0 0x0(%r13,%r15,1)
  13ab10:	shr    $0x3,%dl
  13ab13:	movzbl %dl,%edx
  13ab16:	and    $0x7,%edx
  13ab19:	movzbl (%r12),%r12d
  13ab1e:	bt     %edx,%r12d
  13ab22:	mov    $0x0,%edx
  13ab27:	jae    13a920 <void inline_single_kernel<true, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  13ab2d:	add    %r13,%r15
  13ab30:	mov    %rbp,%rdx
  13ab33:	movabs $0xab5bfa10f0aa8d25,%r12
  13ab3d:	imul   %r12,%rdx
  13ab41:	mulx   %r8,%r12,%r12
  13ab46:	prefetcht0 0x0(%r13,%r12,1)
  13ab4c:	shr    $0x3,%dl
  13ab4f:	movzbl %dl,%edx
  13ab52:	and    $0x7,%edx
  13ab55:	movzbl (%r15),%r15d
  13ab59:	bt     %edx,%r15d
  13ab5d:	mov    $0x0,%edx
  13ab62:	jae    13a920 <void inline_single_kernel<true, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  13ab68:	add    %r13,%r12
  13ab6b:	mov    %rbp,%rdx
  13ab6e:	movabs $0xac690a6278960a79,%r15
  13ab78:	imul   %r15,%rdx
  13ab7c:	mulx   %r8,%r15,%r15
  13ab81:	prefetcht0 0x0(%r13,%r15,1)
  13ab87:	shr    $0x3,%dl
  13ab8a:	movzbl %dl,%edx
  13ab8d:	and    $0x7,%edx
  13ab90:	movzbl (%r12),%r12d
  13ab95:	bt     %edx,%r12d
  13ab99:	mov    $0x0,%edx
  13ab9e:	jae    13a920 <void inline_single_kernel<true, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  13aba4:	add    %r13,%r15
  13aba7:	mov    %rbp,%rdx
  13abaa:	movabs $0x7e3d5b4d98b1f01d,%r12
  13abb4:	imul   %r12,%rdx
  13abb8:	mulx   %r8,%r12,%r12
  13abbd:	prefetcht0 0x0(%r13,%r12,1)
  13abc3:	shr    $0x3,%dl
  13abc6:	movzbl %dl,%edx
  13abc9:	and    $0x7,%edx
  13abcc:	movzbl (%r15),%r15d
  13abd0:	bt     %edx,%r15d
  13abd4:	mov    $0x0,%edx
  13abd9:	jae    13a920 <void inline_single_kernel<true, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  13abdf:	add    %r13,%r12
  13abe2:	mov    %rbp,%rdx
  13abe5:	movabs $0xedb63649198aeb51,%r15
  13abef:	imul   %r15,%rdx
  13abf3:	mulx   %r8,%r15,%r15
  13abf8:	prefetcht0 0x0(%r13,%r15,1)
  13abfe:	shr    $0x3,%dl
  13ac01:	movzbl %dl,%edx
  13ac04:	and    $0x7,%edx
  13ac07:	movzbl (%r12),%r12d
  13ac0c:	bt     %edx,%r12d
  13ac10:	mov    $0x0,%edx
  13ac15:	jae    13a920 <void inline_single_kernel<true, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  13ac1b:	add    %r13,%r15
  13ac1e:	mov    %rbp,%rdx
  13ac21:	movabs $0xa785779e00418e55,%r12
  13ac2b:	imul   %r12,%rdx
  13ac2f:	mulx   %r8,%r12,%r12
  13ac34:	prefetcht0 0x0(%r13,%r12,1)
  13ac3a:	shr    $0x3,%dl
  13ac3d:	movzbl %dl,%edx
  13ac40:	and    $0x7,%edx
  13ac43:	movzbl (%r15),%r15d
  13ac47:	bt     %edx,%r15d
  13ac4b:	mov    $0x0,%edx
  13ac50:	jae    13a920 <void inline_single_kernel<true, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  13ac56:	add    %r13,%r12
  13ac59:	mov    %rbp,%rdx
  13ac5c:	movabs $0x2a8dd71f3bf2a469,%r15
  13ac66:	imul   %r15,%rdx
  13ac6a:	mulx   %r8,%r15,%r15
  13ac6f:	prefetcht0 0x0(%r13,%r15,1)
  13ac75:	shr    $0x3,%dl
  13ac78:	movzbl %dl,%edx
  13ac7b:	and    $0x7,%edx
  13ac7e:	movzbl (%r12),%r12d
  13ac83:	bt     %edx,%r12d
  13ac87:	mov    $0x0,%edx
  13ac8c:	jae    13a920 <void inline_single_kernel<true, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  13ac92:	add    %r13,%r15
  13ac95:	mov    %rbp,%rdx
  13ac98:	movabs $0xa9c608041e73d5cd,%r12
  13aca2:	imul   %r12,%rdx
  13aca6:	mulx   %r8,%r12,%r12
  13acab:	prefetcht0 0x0(%r13,%r12,1)
  13acb1:	shr    $0x3,%dl
  13acb4:	movzbl %dl,%edx
  13acb7:	and    $0x7,%edx
  13acba:	movzbl (%r15),%r15d
  13acbe:	bt     %edx,%r15d
  13acc2:	mov    $0x0,%edx
  13acc7:	jae    13a920 <void inline_single_kernel<true, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  13accd:	add    %r13,%r12
  13acd0:	mov    %rbp,%rdx
  13acd3:	movabs $0x79f17b6a95c1dbc1,%r15
  13acdd:	imul   %r15,%rdx
  13ace1:	mulx   %r8,%r15,%r15
  13ace6:	prefetcht0 0x0(%r13,%r15,1)
  13acec:	shr    $0x3,%dl
  13acef:	movzbl %dl,%edx
  13acf2:	and    $0x7,%edx
  13acf5:	movzbl (%r12),%r12d
  13acfa:	bt     %edx,%r12d
  13acfe:	mov    $0x0,%edx
  13ad03:	jae    13a920 <void inline_single_kernel<true, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  13ad09:	add    %r13,%r15
  13ad0c:	mov    %rbp,%rdx
  13ad0f:	movabs $0x1ce557ff06228485,%r12
  13ad19:	imul   %r12,%rdx
  13ad1d:	mulx   %r8,%r12,%r12
  13ad22:	prefetcht0 0x0(%r13,%r12,1)
  13ad28:	shr    $0x3,%dl
  13ad2b:	movzbl %dl,%edx
  13ad2e:	and    $0x7,%edx
  13ad31:	movzbl (%r15),%r15d
  13ad35:	bt     %edx,%r15d
  13ad39:	mov    $0x0,%edx
  13ad3e:	jae    13a920 <void inline_single_kernel<true, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  13ad44:	add    %r13,%r12
  13ad47:	mov    %rbp,%rdx
  13ad4a:	movabs $0xd98c22e522f5c759,%r15
  13ad54:	imul   %r15,%rdx
  13ad58:	mulx   %r8,%r15,%r15
  13ad5d:	prefetcht0 0x0(%r13,%r15,1)
  13ad63:	shr    $0x3,%dl
  13ad66:	movzbl %dl,%edx
  13ad69:	and    $0x7,%edx
  13ad6c:	movzbl (%r12),%r12d
  13ad71:	bt     %edx,%r12d
  13ad75:	mov    $0x0,%edx
  13ad7a:	jae    13a920 <void inline_single_kernel<true, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  13ad80:	add    %r13,%r15
  13ad83:	mov    %rbp,%rdx
  13ad86:	movabs $0x97f54baa75ce287d,%r12
  13ad90:	imul   %r12,%rdx
  13ad94:	mulx   %r8,%r12,%r12
  13ad99:	prefetcht0 0x0(%r13,%r12,1)
  13ad9f:	shr    $0x3,%dl
  13ada2:	movzbl %dl,%edx
  13ada5:	and    $0x7,%edx
  13ada8:	movzbl (%r15),%r15d
  13adac:	bt     %edx,%r15d
  13adb0:	mov    $0x0,%edx
  13adb5:	jae    13a920 <void inline_single_kernel<true, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  13adbb:	add    %r13,%r12
  13adbe:	mov    %rbp,%rdx
  13adc1:	movabs $0x73c07a65b639ad31,%r15
  13adcb:	imul   %r15,%rdx
  13adcf:	mulx   %r8,%r15,%r15
  13add4:	prefetcht0 0x0(%r13,%r15,1)
  13adda:	shr    $0x3,%dl
  13addd:	movzbl %dl,%edx
  13ade0:	and    $0x7,%edx
  13ade3:	movzbl (%r12),%r12d
  13ade8:	bt     %edx,%r12d
  13adec:	mov    $0x0,%edx
  13adf1:	jae    13a920 <void inline_single_kernel<true, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  13adf7:	add    %r13,%r15
  13adfa:	mov    %rbp,%rdx
  13adfd:	movabs $0x4f001d8e68799fb5,%r12
  13ae07:	imul   %r12,%rdx
  13ae0b:	mulx   %r8,%r8,%r8
  13ae10:	prefetcht0 0x0(%r13,%r8,1)
  13ae16:	shr    $0x3,%dl
  13ae19:	movzbl %dl,%edx
  13ae1c:	and    $0x7,%edx
  13ae1f:	movzbl (%r15),%r15d
  13ae23:	bt     %edx,%r15d
  13ae27:	mov    $0x0,%edx
  13ae2c:	jae    13a920 <void inline_single_kernel<true, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  13ae32:	add    %r8,%r13
  13ae35:	lea    0x0(%rbp,%rbp,8),%edx
  13ae39:	movzbl 0x0(%r13),%r8d
  13ae3e:	shr    $0x3,%dl
  13ae41:	and    $0x7,%dl
  13ae44:	shrx   %edx,%r8d,%edx
  13ae49:	and    $0x1,%edx
  13ae4c:	jmp    13a920 <void inline_single_kernel<true, boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<22ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  13ae51:	pop    %rbx
  13ae52:	pop    %r12
  13ae54:	pop    %r13
  13ae56:	pop    %r14
  13ae58:	pop    %r15
  13ae5a:	pop    %rbp
  13ae5b:	ret
  13ae5c:	int3
  13ae5d:	int3
  13ae5e:	int3
  13ae5f:	int3

