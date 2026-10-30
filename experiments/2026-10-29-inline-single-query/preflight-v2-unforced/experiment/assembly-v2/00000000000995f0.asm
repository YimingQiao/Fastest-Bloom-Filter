00000000000995f0 <void inline_single_kernel<false, external_bloom::Classical<22, true, false>, unsigned long>(external_bloom::Classical<22, true, false> const&, unsigned long, unsigned long const*, unsigned int*)>:
   995f0:	test   %rsi,%rsi
   995f3:	je     99653 <void inline_single_kernel<false, external_bloom::Classical<22, true, false>, unsigned long>(external_bloom::Classical<22, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x63>
   995f5:	push   %rbp
   995f6:	push   %r15
   995f8:	push   %r14
   995fa:	push   %r13
   995fc:	push   %r12
   995fe:	push   %rbx
   995ff:	push   %rax
   99600:	mov    %rcx,%rbx
   99603:	mov    %rdx,%r14
   99606:	mov    %rsi,%r15
   99609:	mov    %rdi,%r12
   9960c:	xor    %ebp,%ebp
   9960e:	mov    %rsp,%r13
   99611:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   99620:	mov    (%r14,%rbp,8),%rax
   99624:	mov    %rax,(%rsp)
   99628:	mov    %r12,%rdi
   9962b:	mov    %r13,%rsi
   9962e:	call   99c30 <bloomfilter::BloomFilter<unsigned long, 8ul, true, external_bloom::IdentityHash, 22>::Contain(unsigned long const&) const>
   99633:	xor    %ecx,%ecx
   99635:	test   %eax,%eax
   99637:	sete   %cl
   9963a:	mov    %ecx,(%rbx,%rbp,4)
   9963d:	inc    %rbp
   99640:	cmp    %rbp,%r15
   99643:	jne    99620 <void inline_single_kernel<false, external_bloom::Classical<22, true, false>, unsigned long>(external_bloom::Classical<22, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   99645:	add    $0x8,%rsp
   99649:	pop    %rbx
   9964a:	pop    %r12
   9964c:	pop    %r13
   9964e:	pop    %r14
   99650:	pop    %r15
   99652:	pop    %rbp
   99653:	ret
   99654:	int3
   99655:	int3
   99656:	int3
   99657:	int3
   99658:	int3
   99659:	int3
   9965a:	int3
   9965b:	int3
   9965c:	int3
   9965d:	int3
   9965e:	int3
   9965f:	int3

