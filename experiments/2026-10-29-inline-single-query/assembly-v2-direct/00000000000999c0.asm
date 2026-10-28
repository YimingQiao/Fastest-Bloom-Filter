00000000000999c0 <void inline_single_kernel<true, external_bloom::Classical<22, true, false>, unsigned long>(external_bloom::Classical<22, true, false> const&, unsigned long, unsigned long const*, unsigned int*)>:
   999c0:	test   %rsi,%rsi
   999c3:	je     99a4a <void inline_single_kernel<true, external_bloom::Classical<22, true, false>, unsigned long>(external_bloom::Classical<22, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x8a>
   999c9:	push   %rbp
   999ca:	push   %r15
   999cc:	push   %r14
   999ce:	push   %r13
   999d0:	push   %r12
   999d2:	push   %rbx
   999d3:	push   %rax
   999d4:	mov    %rcx,%rbx
   999d7:	mov    %rdx,%r14
   999da:	mov    %rsi,%r15
   999dd:	mov    %rdi,%r12
   999e0:	movabs $0xd6e8feb86659fd93,%rbp
   999ea:	xor    %r13d,%r13d
   999ed:	nopl   (%rax)
   999f0:	mov    (%r14,%r13,8),%rax
   999f4:	mov    %rax,%rcx
   999f7:	shr    $0x20,%rcx
   999fb:	xor    %rax,%rcx
   999fe:	imul   %rbp,%rcx
   99a02:	mov    %rcx,%rax
   99a05:	shr    $0x20,%rax
   99a09:	xor    %rcx,%rax
   99a0c:	imul   %rbp,%rax
   99a10:	mov    %rax,%rcx
   99a13:	shr    $0x20,%rcx
   99a17:	xor    %rax,%rcx
   99a1a:	mov    %rcx,(%rsp)
   99a1e:	mov    %r12,%rdi
   99a21:	mov    %rsp,%rsi
   99a24:	call   99bb0 <bloomfilter::BloomFilter<unsigned long, 8ul, true, external_bloom::IdentityHash, 22>::Contain(unsigned long const&) const>
   99a29:	xor    %ecx,%ecx
   99a2b:	test   %eax,%eax
   99a2d:	sete   %cl
   99a30:	mov    %ecx,(%rbx,%r13,4)
   99a34:	inc    %r13
   99a37:	cmp    %r13,%r15
   99a3a:	jne    999f0 <void inline_single_kernel<true, external_bloom::Classical<22, true, false>, unsigned long>(external_bloom::Classical<22, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   99a3c:	add    $0x8,%rsp
   99a40:	pop    %rbx
   99a41:	pop    %r12
   99a43:	pop    %r13
   99a45:	pop    %r14
   99a47:	pop    %r15
   99a49:	pop    %rbp
   99a4a:	ret
   99a4b:	int3
   99a4c:	int3
   99a4d:	int3
   99a4e:	int3
   99a4f:	int3

