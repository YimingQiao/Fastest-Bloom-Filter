0000000000099570 <void inline_single_kernel<false, external_bloom::Classical<22, true, false>, unsigned long>(external_bloom::Classical<22, true, false> const&, unsigned long, unsigned long const*, unsigned int*)>:
   99570:	test   %rsi,%rsi
   99573:	je     995d3 <void inline_single_kernel<false, external_bloom::Classical<22, true, false>, unsigned long>(external_bloom::Classical<22, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x63>
   99575:	push   %rbp
   99576:	push   %r15
   99578:	push   %r14
   9957a:	push   %r13
   9957c:	push   %r12
   9957e:	push   %rbx
   9957f:	push   %rax
   99580:	mov    %rcx,%rbx
   99583:	mov    %rdx,%r14
   99586:	mov    %rsi,%r15
   99589:	mov    %rdi,%r12
   9958c:	xor    %ebp,%ebp
   9958e:	mov    %rsp,%r13
   99591:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   995a0:	mov    (%r14,%rbp,8),%rax
   995a4:	mov    %rax,(%rsp)
   995a8:	mov    %r12,%rdi
   995ab:	mov    %r13,%rsi
   995ae:	call   99bb0 <bloomfilter::BloomFilter<unsigned long, 8ul, true, external_bloom::IdentityHash, 22>::Contain(unsigned long const&) const>
   995b3:	xor    %ecx,%ecx
   995b5:	test   %eax,%eax
   995b7:	sete   %cl
   995ba:	mov    %ecx,(%rbx,%rbp,4)
   995bd:	inc    %rbp
   995c0:	cmp    %rbp,%r15
   995c3:	jne    995a0 <void inline_single_kernel<false, external_bloom::Classical<22, true, false>, unsigned long>(external_bloom::Classical<22, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   995c5:	add    $0x8,%rsp
   995c9:	pop    %rbx
   995ca:	pop    %r12
   995cc:	pop    %r13
   995ce:	pop    %r14
   995d0:	pop    %r15
   995d2:	pop    %rbp
   995d3:	ret
   995d4:	int3
   995d5:	int3
   995d6:	int3
   995d7:	int3
   995d8:	int3
   995d9:	int3
   995da:	int3
   995db:	int3
   995dc:	int3
   995dd:	int3
   995de:	int3
   995df:	int3

