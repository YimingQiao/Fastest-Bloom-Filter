00000000000a53a0 <void inline_single_kernel<true, external_bloom::Classical<11, false, true>, unsigned long>(external_bloom::Classical<11, false, true> const&, unsigned long, unsigned long const*, unsigned int*)>:
   a53a0:	test   %rsi,%rsi
   a53a3:	je     a542a <void inline_single_kernel<true, external_bloom::Classical<11, false, true>, unsigned long>(external_bloom::Classical<11, false, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x8a>
   a53a9:	push   %rbp
   a53aa:	push   %r15
   a53ac:	push   %r14
   a53ae:	push   %r13
   a53b0:	push   %r12
   a53b2:	push   %rbx
   a53b3:	push   %rax
   a53b4:	mov    %rcx,%rbx
   a53b7:	mov    %rdx,%r14
   a53ba:	mov    %rsi,%r15
   a53bd:	mov    %rdi,%r12
   a53c0:	movabs $0xd6e8feb86659fd93,%rbp
   a53ca:	xor    %r13d,%r13d
   a53cd:	nopl   (%rax)
   a53d0:	mov    (%r14,%r13,8),%rax
   a53d4:	mov    %rax,%rcx
   a53d7:	shr    $0x20,%rcx
   a53db:	xor    %rax,%rcx
   a53de:	imul   %rbp,%rcx
   a53e2:	mov    %rcx,%rax
   a53e5:	shr    $0x20,%rax
   a53e9:	xor    %rcx,%rax
   a53ec:	imul   %rbp,%rax
   a53f0:	mov    %rax,%rcx
   a53f3:	shr    $0x20,%rcx
   a53f7:	xor    %rax,%rcx
   a53fa:	mov    %rcx,(%rsp)
   a53fe:	mov    %r12,%rdi
   a5401:	mov    %rsp,%rsi
   a5404:	call   7e290 <bloomfilter::BloomFilter<unsigned long, 8ul, false, external_bloom::IdentityHash, 11>::Contain(unsigned long const&) const>
   a5409:	xor    %ecx,%ecx
   a540b:	test   %eax,%eax
   a540d:	sete   %cl
   a5410:	mov    %ecx,(%rbx,%r13,4)
   a5414:	inc    %r13
   a5417:	cmp    %r13,%r15
   a541a:	jne    a53d0 <void inline_single_kernel<true, external_bloom::Classical<11, false, true>, unsigned long>(external_bloom::Classical<11, false, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   a541c:	add    $0x8,%rsp
   a5420:	pop    %rbx
   a5421:	pop    %r12
   a5423:	pop    %r13
   a5425:	pop    %r14
   a5427:	pop    %r15
   a5429:	pop    %rbp
   a542a:	ret
   a542b:	int3
   a542c:	int3
   a542d:	int3
   a542e:	int3
   a542f:	int3

