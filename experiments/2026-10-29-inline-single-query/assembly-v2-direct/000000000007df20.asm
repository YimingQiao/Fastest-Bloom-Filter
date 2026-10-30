000000000007df20 <void inline_single_kernel<true, external_bloom::Classical<11, false, false>, unsigned long>(external_bloom::Classical<11, false, false> const&, unsigned long, unsigned long const*, unsigned int*)>:
   7df20:	test   %rsi,%rsi
   7df23:	je     7dfaa <void inline_single_kernel<true, external_bloom::Classical<11, false, false>, unsigned long>(external_bloom::Classical<11, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x8a>
   7df29:	push   %rbp
   7df2a:	push   %r15
   7df2c:	push   %r14
   7df2e:	push   %r13
   7df30:	push   %r12
   7df32:	push   %rbx
   7df33:	push   %rax
   7df34:	mov    %rcx,%rbx
   7df37:	mov    %rdx,%r14
   7df3a:	mov    %rsi,%r15
   7df3d:	mov    %rdi,%r12
   7df40:	movabs $0xd6e8feb86659fd93,%rbp
   7df4a:	xor    %r13d,%r13d
   7df4d:	nopl   (%rax)
   7df50:	mov    (%r14,%r13,8),%rax
   7df54:	mov    %rax,%rcx
   7df57:	shr    $0x20,%rcx
   7df5b:	xor    %rax,%rcx
   7df5e:	imul   %rbp,%rcx
   7df62:	mov    %rcx,%rax
   7df65:	shr    $0x20,%rax
   7df69:	xor    %rcx,%rax
   7df6c:	imul   %rbp,%rax
   7df70:	mov    %rax,%rcx
   7df73:	shr    $0x20,%rcx
   7df77:	xor    %rax,%rcx
   7df7a:	mov    %rcx,(%rsp)
   7df7e:	mov    %r12,%rdi
   7df81:	mov    %rsp,%rsi
   7df84:	call   7e210 <bloomfilter::BloomFilter<unsigned long, 8ul, false, external_bloom::IdentityHash, 11>::Contain(unsigned long const&) const>
   7df89:	xor    %ecx,%ecx
   7df8b:	test   %eax,%eax
   7df8d:	sete   %cl
   7df90:	mov    %ecx,(%rbx,%r13,4)
   7df94:	inc    %r13
   7df97:	cmp    %r13,%r15
   7df9a:	jne    7df50 <void inline_single_kernel<true, external_bloom::Classical<11, false, false>, unsigned long>(external_bloom::Classical<11, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   7df9c:	add    $0x8,%rsp
   7dfa0:	pop    %rbx
   7dfa1:	pop    %r12
   7dfa3:	pop    %r13
   7dfa5:	pop    %r14
   7dfa7:	pop    %r15
   7dfa9:	pop    %rbp
   7dfaa:	ret
   7dfab:	int3
   7dfac:	int3
   7dfad:	int3
   7dfae:	int3
   7dfaf:	int3

