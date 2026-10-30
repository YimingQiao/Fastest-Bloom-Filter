0000000000132d60 <void inline_single_kernel<true, boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
  132d60:	test   %rsi,%rsi
  132d63:	je     133064 <void inline_single_kernel<true, boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x304>
  132d69:	push   %rbp
  132d6a:	push   %r15
  132d6c:	push   %r14
  132d6e:	push   %r13
  132d70:	push   %r12
  132d72:	push   %rbx
  132d73:	mov    %rdx,%rax
  132d76:	movabs $0xd6e8feb86659fd93,%r9
  132d80:	xor    %r10d,%r10d
  132d83:	movabs $0xf1357aea2e62a9c5,%r11
  132d8d:	movabs $0x1427bb2d3769b199,%rbx
  132d97:	movabs $0x57545799e525abbd,%r14
  132da1:	jmp    132dc0 <void inline_single_kernel<true, boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x60>
  132da3:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  132db0:	mov    %edx,(%rcx,%r10,4)
  132db4:	inc    %r10
  132db7:	cmp    %r10,%rsi
  132dba:	je     13305a <void inline_single_kernel<true, boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x2fa>
  132dc0:	mov    (%rax,%r10,8),%rdx
  132dc4:	mov    %rdx,%r8
  132dc7:	shr    $0x20,%r8
  132dcb:	xor    %rdx,%r8
  132dce:	imul   %r9,%r8
  132dd2:	mov    %r8,%rdx
  132dd5:	shr    $0x20,%rdx
  132dd9:	xor    %r8,%rdx
  132ddc:	imul   %r9,%rdx
  132de0:	mov    %rdx,%rbp
  132de3:	shr    $0x20,%rbp
  132de7:	xor    %rdx,%rbp
  132dea:	or     $0x1,%rbp
  132dee:	mov    0x10(%rdi),%r8
  132df2:	mov    0x20(%rdi),%r13
  132df6:	mov    %r8,%rdx
  132df9:	mulx   %rbp,%r15,%r15
  132dfe:	prefetcht0 0x0(%r13,%r15,1)
  132e04:	mov    %rbp,%rdx
  132e07:	imul   %r11,%rdx
  132e0b:	mulx   %r8,%r12,%r12
  132e10:	prefetcht0 0x0(%r13,%r12,1)
  132e16:	shr    $0x3,%dl
  132e19:	movzbl 0x0(%r13,%r15,1),%r15d
  132e1f:	movzbl %dl,%edx
  132e22:	and    $0x7,%edx
  132e25:	bt     %edx,%r15d
  132e29:	mov    $0x0,%edx
  132e2e:	jae    132db0 <void inline_single_kernel<true, boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  132e30:	add    %r13,%r12
  132e33:	mov    %rbp,%rdx
  132e36:	imul   %rbx,%rdx
  132e3a:	mulx   %r8,%r15,%r15
  132e3f:	prefetcht0 0x0(%r13,%r15,1)
  132e45:	shr    $0x3,%dl
  132e48:	movzbl %dl,%edx
  132e4b:	and    $0x7,%edx
  132e4e:	movzbl (%r12),%r12d
  132e53:	bt     %edx,%r12d
  132e57:	mov    $0x0,%edx
  132e5c:	jae    132db0 <void inline_single_kernel<true, boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  132e62:	add    %r13,%r15
  132e65:	mov    %rbp,%rdx
  132e68:	imul   %r14,%rdx
  132e6c:	mulx   %r8,%r12,%r12
  132e71:	prefetcht0 0x0(%r13,%r12,1)
  132e77:	shr    $0x3,%dl
  132e7a:	movzbl %dl,%edx
  132e7d:	and    $0x7,%edx
  132e80:	movzbl (%r15),%r15d
  132e84:	bt     %edx,%r15d
  132e88:	mov    $0x0,%edx
  132e8d:	jae    132db0 <void inline_single_kernel<true, boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  132e93:	add    %r13,%r12
  132e96:	mov    %rbp,%rdx
  132e99:	movabs $0xf53a8bbce8b6ed71,%r15
  132ea3:	imul   %r15,%rdx
  132ea7:	mulx   %r8,%r15,%r15
  132eac:	prefetcht0 0x0(%r13,%r15,1)
  132eb2:	shr    $0x3,%dl
  132eb5:	movzbl %dl,%edx
  132eb8:	and    $0x7,%edx
  132ebb:	movzbl (%r12),%r12d
  132ec0:	bt     %edx,%r12d
  132ec4:	mov    $0x0,%edx
  132ec9:	jae    132db0 <void inline_single_kernel<true, boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  132ecf:	add    %r13,%r15
  132ed2:	mov    %rbp,%rdx
  132ed5:	movabs $0x3a3115fb0ac650f5,%r12
  132edf:	imul   %r12,%rdx
  132ee3:	mulx   %r8,%r12,%r12
  132ee8:	prefetcht0 0x0(%r13,%r12,1)
  132eee:	shr    $0x3,%dl
  132ef1:	movzbl %dl,%edx
  132ef4:	and    $0x7,%edx
  132ef7:	movzbl (%r15),%r15d
  132efb:	bt     %edx,%r15d
  132eff:	mov    $0x0,%edx
  132f04:	jae    132db0 <void inline_single_kernel<true, boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  132f0a:	add    %r13,%r12
  132f0d:	mov    %rbp,%rdx
  132f10:	movabs $0x78e628b539d80989,%r15
  132f1a:	imul   %r15,%rdx
  132f1e:	mulx   %r8,%r15,%r15
  132f23:	prefetcht0 0x0(%r13,%r15,1)
  132f29:	shr    $0x3,%dl
  132f2c:	movzbl %dl,%edx
  132f2f:	and    $0x7,%edx
  132f32:	movzbl (%r12),%r12d
  132f37:	bt     %edx,%r12d
  132f3b:	mov    $0x0,%edx
  132f40:	jae    132db0 <void inline_single_kernel<true, boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  132f46:	add    %r13,%r15
  132f49:	mov    %rbp,%rdx
  132f4c:	movabs $0xe622ee4965fcc76d,%r12
  132f56:	imul   %r12,%rdx
  132f5a:	mulx   %r8,%r12,%r12
  132f5f:	prefetcht0 0x0(%r13,%r12,1)
  132f65:	shr    $0x3,%dl
  132f68:	movzbl %dl,%edx
  132f6b:	and    $0x7,%edx
  132f6e:	movzbl (%r15),%r15d
  132f72:	bt     %edx,%r15d
  132f76:	mov    $0x0,%edx
  132f7b:	jae    132db0 <void inline_single_kernel<true, boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  132f81:	add    %r13,%r12
  132f84:	mov    %rbp,%rdx
  132f87:	movabs $0x2745850b48e66be1,%r15
  132f91:	imul   %r15,%rdx
  132f95:	mulx   %r8,%r15,%r15
  132f9a:	prefetcht0 0x0(%r13,%r15,1)
  132fa0:	shr    $0x3,%dl
  132fa3:	movzbl %dl,%edx
  132fa6:	and    $0x7,%edx
  132fa9:	movzbl (%r12),%r12d
  132fae:	bt     %edx,%r12d
  132fb2:	mov    $0x0,%edx
  132fb7:	jae    132db0 <void inline_single_kernel<true, boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  132fbd:	add    %r13,%r15
  132fc0:	mov    %rbp,%rdx
  132fc3:	movabs $0xab5bfa10f0aa8d25,%r12
  132fcd:	imul   %r12,%rdx
  132fd1:	mulx   %r8,%r12,%r12
  132fd6:	prefetcht0 0x0(%r13,%r12,1)
  132fdc:	shr    $0x3,%dl
  132fdf:	movzbl %dl,%edx
  132fe2:	and    $0x7,%edx
  132fe5:	movzbl (%r15),%r15d
  132fe9:	bt     %edx,%r15d
  132fed:	mov    $0x0,%edx
  132ff2:	jae    132db0 <void inline_single_kernel<true, boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  132ff8:	add    %r13,%r12
  132ffb:	mov    %rbp,%rdx
  132ffe:	movabs $0xac690a6278960a79,%r15
  133008:	imul   %r15,%rdx
  13300c:	mulx   %r8,%r8,%r8
  133011:	prefetcht0 0x0(%r13,%r8,1)
  133017:	shr    $0x3,%dl
  13301a:	movzbl %dl,%edx
  13301d:	and    $0x7,%edx
  133020:	movzbl (%r12),%r15d
  133025:	bt     %edx,%r15d
  133029:	mov    $0x0,%edx
  13302e:	jae    132db0 <void inline_single_kernel<true, boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  133034:	add    %r8,%r13
  133037:	lea    0x0(%rbp,%rbp,8),%edx
  13303b:	lea    (%rdx,%rdx,2),%edx
  13303e:	add    %ebp,%edx
  133040:	add    %ebp,%edx
  133042:	movzbl 0x0(%r13),%r8d
  133047:	shr    $0x3,%dl
  13304a:	and    $0x7,%dl
  13304d:	shrx   %edx,%r8d,%edx
  133052:	and    $0x1,%edx
  133055:	jmp    132db0 <void inline_single_kernel<true, boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  13305a:	pop    %rbx
  13305b:	pop    %r12
  13305d:	pop    %r13
  13305f:	pop    %r14
  133061:	pop    %r15
  133063:	pop    %rbp
  133064:	ret
  133065:	int3
  133066:	int3
  133067:	int3
  133068:	int3
  133069:	int3
  13306a:	int3
  13306b:	int3
  13306c:	int3
  13306d:	int3
  13306e:	int3
  13306f:	int3

