00000000000aa680 <void inline_single_kernel<false, external_bloom::Classical<22, false, true>, unsigned long>(external_bloom::Classical<22, false, true> const&, unsigned long, unsigned long const*, unsigned int*)>:
   aa680:	test   %rsi,%rsi
   aa683:	je     aa6e3 <void inline_single_kernel<false, external_bloom::Classical<22, false, true>, unsigned long>(external_bloom::Classical<22, false, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x63>
   aa685:	push   %rbp
   aa686:	push   %r15
   aa688:	push   %r14
   aa68a:	push   %r13
   aa68c:	push   %r12
   aa68e:	push   %rbx
   aa68f:	push   %rax
   aa690:	mov    %rcx,%rbx
   aa693:	mov    %rdx,%r14
   aa696:	mov    %rsi,%r15
   aa699:	mov    %rdi,%r12
   aa69c:	xor    %ebp,%ebp
   aa69e:	mov    %rsp,%r13
   aa6a1:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   aa6b0:	mov    (%r14,%rbp,8),%rax
   aa6b4:	mov    %rax,(%rsp)
   aa6b8:	mov    %r12,%rdi
   aa6bb:	mov    %r13,%rsi
   aa6be:	call   89020 <bloomfilter::BloomFilter<unsigned long, 8ul, false, external_bloom::IdentityHash, 22>::Contain(unsigned long const&) const>
   aa6c3:	xor    %ecx,%ecx
   aa6c5:	test   %eax,%eax
   aa6c7:	sete   %cl
   aa6ca:	mov    %ecx,(%rbx,%rbp,4)
   aa6cd:	inc    %rbp
   aa6d0:	cmp    %rbp,%r15
   aa6d3:	jne    aa6b0 <void inline_single_kernel<false, external_bloom::Classical<22, false, true>, unsigned long>(external_bloom::Classical<22, false, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   aa6d5:	add    $0x8,%rsp
   aa6d9:	pop    %rbx
   aa6da:	pop    %r12
   aa6dc:	pop    %r13
   aa6de:	pop    %r14
   aa6e0:	pop    %r15
   aa6e2:	pop    %rbp
   aa6e3:	ret
   aa6e4:	int3
   aa6e5:	int3
   aa6e6:	int3
   aa6e7:	int3
   aa6e8:	int3
   aa6e9:	int3
   aa6ea:	int3
   aa6eb:	int3
   aa6ec:	int3
   aa6ed:	int3
   aa6ee:	int3
   aa6ef:	int3

