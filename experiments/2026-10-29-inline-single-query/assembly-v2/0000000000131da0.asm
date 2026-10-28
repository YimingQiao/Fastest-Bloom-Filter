0000000000131da0 <void inline_single_kernel<false, boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
  131da0:	test   %rsi,%rsi
  131da3:	je     131de1 <void inline_single_kernel<false, boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x41>
  131da5:	push   %r15
  131da7:	push   %r14
  131da9:	push   %r13
  131dab:	push   %r12
  131dad:	push   %rbx
  131dae:	mov    %rcx,%rbx
  131db1:	mov    %rdx,%r14
  131db4:	mov    %rsi,%r15
  131db7:	mov    %rdi,%r12
  131dba:	xor    %r13d,%r13d
  131dbd:	nopl   (%rax)
  131dc0:	mov    (%r14,%r13,8),%rsi
  131dc4:	mov    %r12,%rdi
  131dc7:	call   1341a0 <boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>::ScalarContains(unsigned long) const>
  131dcc:	mov    %eax,(%rbx,%r13,4)
  131dd0:	inc    %r13
  131dd3:	cmp    %r13,%r15
  131dd6:	jne    131dc0 <void inline_single_kernel<false, boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x20>
  131dd8:	pop    %rbx
  131dd9:	pop    %r12
  131ddb:	pop    %r13
  131ddd:	pop    %r14
  131ddf:	pop    %r15
  131de1:	ret
  131de2:	int3
  131de3:	int3
  131de4:	int3
  131de5:	int3
  131de6:	int3
  131de7:	int3
  131de8:	int3
  131de9:	int3
  131dea:	int3
  131deb:	int3
  131dec:	int3
  131ded:	int3
  131dee:	int3
  131def:	int3

