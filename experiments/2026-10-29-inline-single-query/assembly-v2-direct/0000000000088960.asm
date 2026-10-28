0000000000088960 <void inline_single_kernel<false, external_bloom::Classical<22, false, false>, unsigned long>(external_bloom::Classical<22, false, false> const&, unsigned long, unsigned long const*, unsigned int*)>:
   88960:	test   %rsi,%rsi
   88963:	je     889c3 <void inline_single_kernel<false, external_bloom::Classical<22, false, false>, unsigned long>(external_bloom::Classical<22, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x63>
   88965:	push   %rbp
   88966:	push   %r15
   88968:	push   %r14
   8896a:	push   %r13
   8896c:	push   %r12
   8896e:	push   %rbx
   8896f:	push   %rax
   88970:	mov    %rcx,%rbx
   88973:	mov    %rdx,%r14
   88976:	mov    %rsi,%r15
   88979:	mov    %rdi,%r12
   8897c:	xor    %ebp,%ebp
   8897e:	mov    %rsp,%r13
   88981:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   88990:	mov    (%r14,%rbp,8),%rax
   88994:	mov    %rax,(%rsp)
   88998:	mov    %r12,%rdi
   8899b:	mov    %r13,%rsi
   8899e:	call   88fa0 <bloomfilter::BloomFilter<unsigned long, 8ul, false, external_bloom::IdentityHash, 22>::Contain(unsigned long const&) const>
   889a3:	xor    %ecx,%ecx
   889a5:	test   %eax,%eax
   889a7:	sete   %cl
   889aa:	mov    %ecx,(%rbx,%rbp,4)
   889ad:	inc    %rbp
   889b0:	cmp    %rbp,%r15
   889b3:	jne    88990 <void inline_single_kernel<false, external_bloom::Classical<22, false, false>, unsigned long>(external_bloom::Classical<22, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   889b5:	add    $0x8,%rsp
   889b9:	pop    %rbx
   889ba:	pop    %r12
   889bc:	pop    %r13
   889be:	pop    %r14
   889c0:	pop    %r15
   889c2:	pop    %rbp
   889c3:	ret
   889c4:	int3
   889c5:	int3
   889c6:	int3
   889c7:	int3
   889c8:	int3
   889c9:	int3
   889ca:	int3
   889cb:	int3
   889cc:	int3
   889cd:	int3
   889ce:	int3
   889cf:	int3

