0000000000125250 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 10ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 10ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
  125250:	test   %rsi,%rsi
  125253:	je     1252cb <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 10ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 10ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x7b>
  125255:	push   %rbp
  125256:	push   %r15
  125258:	push   %r14
  12525a:	push   %r13
  12525c:	push   %r12
  12525e:	push   %rbx
  12525f:	push   %rax
  125260:	mov    %rcx,%rbx
  125263:	mov    %rdx,%r14
  125266:	mov    %rsi,%r15
  125269:	mov    %rdi,%r12
  12526c:	movabs $0xd6e8feb86659fd93,%r13
  125276:	xor    %ebp,%ebp
  125278:	nopl   0x0(%rax,%rax,1)
  125280:	mov    (%r14,%rbp,8),%rax
  125284:	mov    %rax,%rcx
  125287:	shr    $0x20,%rcx
  12528b:	xor    %rax,%rcx
  12528e:	imul   %r13,%rcx
  125292:	mov    %rcx,%rax
  125295:	shr    $0x20,%rax
  125299:	xor    %rcx,%rax
  12529c:	imul   %r13,%rax
  1252a0:	mov    %rax,%rsi
  1252a3:	shr    $0x20,%rsi
  1252a7:	xor    %rax,%rsi
  1252aa:	mov    %r12,%rdi
  1252ad:	call   126180 <boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 10ul>, 0ul>::ScalarContains(unsigned long) const>
  1252b2:	mov    %eax,(%rbx,%rbp,4)
  1252b5:	inc    %rbp
  1252b8:	cmp    %rbp,%r15
  1252bb:	jne    125280 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 10ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 10ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
  1252bd:	add    $0x8,%rsp
  1252c1:	pop    %rbx
  1252c2:	pop    %r12
  1252c4:	pop    %r13
  1252c6:	pop    %r14
  1252c8:	pop    %r15
  1252ca:	pop    %rbp
  1252cb:	ret
  1252cc:	int3
  1252cd:	int3
  1252ce:	int3
  1252cf:	int3

