000000000007dfa0 <void inline_single_kernel<true, external_bloom::Classical<11, false, false>, unsigned long>(external_bloom::Classical<11, false, false> const&, unsigned long, unsigned long const*, unsigned int*)>:
   7dfa0:	test   %rsi,%rsi
   7dfa3:	je     7e02a <void inline_single_kernel<true, external_bloom::Classical<11, false, false>, unsigned long>(external_bloom::Classical<11, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x8a>
   7dfa9:	push   %rbp
   7dfaa:	push   %r15
   7dfac:	push   %r14
   7dfae:	push   %r13
   7dfb0:	push   %r12
   7dfb2:	push   %rbx
   7dfb3:	push   %rax
   7dfb4:	mov    %rcx,%rbx
   7dfb7:	mov    %rdx,%r14
   7dfba:	mov    %rsi,%r15
   7dfbd:	mov    %rdi,%r12
   7dfc0:	movabs $0xd6e8feb86659fd93,%rbp
   7dfca:	xor    %r13d,%r13d
   7dfcd:	nopl   (%rax)
   7dfd0:	mov    (%r14,%r13,8),%rax
   7dfd4:	mov    %rax,%rcx
   7dfd7:	shr    $0x20,%rcx
   7dfdb:	xor    %rax,%rcx
   7dfde:	imul   %rbp,%rcx
   7dfe2:	mov    %rcx,%rax
   7dfe5:	shr    $0x20,%rax
   7dfe9:	xor    %rcx,%rax
   7dfec:	imul   %rbp,%rax
   7dff0:	mov    %rax,%rcx
   7dff3:	shr    $0x20,%rcx
   7dff7:	xor    %rax,%rcx
   7dffa:	mov    %rcx,(%rsp)
   7dffe:	mov    %r12,%rdi
   7e001:	mov    %rsp,%rsi
   7e004:	call   7e290 <bloomfilter::BloomFilter<unsigned long, 8ul, false, external_bloom::IdentityHash, 11>::Contain(unsigned long const&) const>
   7e009:	xor    %ecx,%ecx
   7e00b:	test   %eax,%eax
   7e00d:	sete   %cl
   7e010:	mov    %ecx,(%rbx,%r13,4)
   7e014:	inc    %r13
   7e017:	cmp    %r13,%r15
   7e01a:	jne    7dfd0 <void inline_single_kernel<true, external_bloom::Classical<11, false, false>, unsigned long>(external_bloom::Classical<11, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   7e01c:	add    $0x8,%rsp
   7e020:	pop    %rbx
   7e021:	pop    %r12
   7e023:	pop    %r13
   7e025:	pop    %r14
   7e027:	pop    %r15
   7e029:	pop    %rbp
   7e02a:	ret
   7e02b:	int3
   7e02c:	int3
   7e02d:	int3
   7e02e:	int3
   7e02f:	int3

