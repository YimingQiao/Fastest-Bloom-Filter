0000000000083580 <void inline_single_kernel<true, external_bloom::Classical<16, false, false>, unsigned long>(external_bloom::Classical<16, false, false> const&, unsigned long, unsigned long const*, unsigned int*)>:
   83580:	test   %rsi,%rsi
   83583:	je     8360a <void inline_single_kernel<true, external_bloom::Classical<16, false, false>, unsigned long>(external_bloom::Classical<16, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x8a>
   83589:	push   %rbp
   8358a:	push   %r15
   8358c:	push   %r14
   8358e:	push   %r13
   83590:	push   %r12
   83592:	push   %rbx
   83593:	push   %rax
   83594:	mov    %rcx,%rbx
   83597:	mov    %rdx,%r14
   8359a:	mov    %rsi,%r15
   8359d:	mov    %rdi,%r12
   835a0:	movabs $0xd6e8feb86659fd93,%rbp
   835aa:	xor    %r13d,%r13d
   835ad:	nopl   (%rax)
   835b0:	mov    (%r14,%r13,8),%rax
   835b4:	mov    %rax,%rcx
   835b7:	shr    $0x20,%rcx
   835bb:	xor    %rax,%rcx
   835be:	imul   %rbp,%rcx
   835c2:	mov    %rcx,%rax
   835c5:	shr    $0x20,%rax
   835c9:	xor    %rcx,%rax
   835cc:	imul   %rbp,%rax
   835d0:	mov    %rax,%rcx
   835d3:	shr    $0x20,%rcx
   835d7:	xor    %rax,%rcx
   835da:	mov    %rcx,(%rsp)
   835de:	mov    %r12,%rdi
   835e1:	mov    %rsp,%rsi
   835e4:	call   838d0 <bloomfilter::BloomFilter<unsigned long, 8ul, false, external_bloom::IdentityHash, 16>::Contain(unsigned long const&) const>
   835e9:	xor    %ecx,%ecx
   835eb:	test   %eax,%eax
   835ed:	sete   %cl
   835f0:	mov    %ecx,(%rbx,%r13,4)
   835f4:	inc    %r13
   835f7:	cmp    %r13,%r15
   835fa:	jne    835b0 <void inline_single_kernel<true, external_bloom::Classical<16, false, false>, unsigned long>(external_bloom::Classical<16, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   835fc:	add    $0x8,%rsp
   83600:	pop    %rbx
   83601:	pop    %r12
   83603:	pop    %r13
   83605:	pop    %r14
   83607:	pop    %r15
   83609:	pop    %rbp
   8360a:	ret
   8360b:	int3
   8360c:	int3
   8360d:	int3
   8360e:	int3
   8360f:	int3

