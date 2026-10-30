0000000000124e20 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 10ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 10ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
  124e20:	test   %rsi,%rsi
  124e23:	je     124e61 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 10ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 10ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x41>
  124e25:	push   %r15
  124e27:	push   %r14
  124e29:	push   %r13
  124e2b:	push   %r12
  124e2d:	push   %rbx
  124e2e:	mov    %rcx,%rbx
  124e31:	mov    %rdx,%r14
  124e34:	mov    %rsi,%r15
  124e37:	mov    %rdi,%r12
  124e3a:	xor    %r13d,%r13d
  124e3d:	nopl   (%rax)
  124e40:	mov    (%r14,%r13,8),%rsi
  124e44:	mov    %r12,%rdi
  124e47:	call   126180 <boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 10ul>, 0ul>::ScalarContains(unsigned long) const>
  124e4c:	mov    %eax,(%rbx,%r13,4)
  124e50:	inc    %r13
  124e53:	cmp    %r13,%r15
  124e56:	jne    124e40 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 10ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 10ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x20>
  124e58:	pop    %rbx
  124e59:	pop    %r12
  124e5b:	pop    %r13
  124e5d:	pop    %r14
  124e5f:	pop    %r15
  124e61:	ret
  124e62:	int3
  124e63:	int3
  124e64:	int3
  124e65:	int3
  124e66:	int3
  124e67:	int3
  124e68:	int3
  124e69:	int3
  124e6a:	int3
  124e6b:	int3
  124e6c:	int3
  124e6d:	int3
  124e6e:	int3
  124e6f:	int3

