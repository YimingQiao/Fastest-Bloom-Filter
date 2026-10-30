00000000001321d0 <void inline_single_kernel<true, boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
  1321d0:	test   %rsi,%rsi
  1321d3:	je     13224b <void inline_single_kernel<true, boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x7b>
  1321d5:	push   %rbp
  1321d6:	push   %r15
  1321d8:	push   %r14
  1321da:	push   %r13
  1321dc:	push   %r12
  1321de:	push   %rbx
  1321df:	push   %rax
  1321e0:	mov    %rcx,%rbx
  1321e3:	mov    %rdx,%r14
  1321e6:	mov    %rsi,%r15
  1321e9:	mov    %rdi,%r12
  1321ec:	movabs $0xd6e8feb86659fd93,%r13
  1321f6:	xor    %ebp,%ebp
  1321f8:	nopl   0x0(%rax,%rax,1)
  132200:	mov    (%r14,%rbp,8),%rax
  132204:	mov    %rax,%rcx
  132207:	shr    $0x20,%rcx
  13220b:	xor    %rax,%rcx
  13220e:	imul   %r13,%rcx
  132212:	mov    %rcx,%rax
  132215:	shr    $0x20,%rax
  132219:	xor    %rcx,%rax
  13221c:	imul   %r13,%rax
  132220:	mov    %rax,%rsi
  132223:	shr    $0x20,%rsi
  132227:	xor    %rax,%rsi
  13222a:	mov    %r12,%rdi
  13222d:	call   1341a0 <boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>::ScalarContains(unsigned long) const>
  132232:	mov    %eax,(%rbx,%rbp,4)
  132235:	inc    %rbp
  132238:	cmp    %rbp,%r15
  13223b:	jne    132200 <void inline_single_kernel<true, boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
  13223d:	add    $0x8,%rsp
  132241:	pop    %rbx
  132242:	pop    %r12
  132244:	pop    %r13
  132246:	pop    %r14
  132248:	pop    %r15
  13224a:	pop    %rbp
  13224b:	ret
  13224c:	int3
  13224d:	int3
  13224e:	int3
  13224f:	int3

