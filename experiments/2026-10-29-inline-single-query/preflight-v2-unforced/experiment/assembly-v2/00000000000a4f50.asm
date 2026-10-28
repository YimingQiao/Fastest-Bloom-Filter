00000000000a4f50 <void inline_single_kernel<false, external_bloom::Classical<11, false, true>, unsigned long>(external_bloom::Classical<11, false, true> const&, unsigned long, unsigned long const*, unsigned int*)>:
   a4f50:	test   %rsi,%rsi
   a4f53:	je     a4fb3 <void inline_single_kernel<false, external_bloom::Classical<11, false, true>, unsigned long>(external_bloom::Classical<11, false, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x63>
   a4f55:	push   %rbp
   a4f56:	push   %r15
   a4f58:	push   %r14
   a4f5a:	push   %r13
   a4f5c:	push   %r12
   a4f5e:	push   %rbx
   a4f5f:	push   %rax
   a4f60:	mov    %rcx,%rbx
   a4f63:	mov    %rdx,%r14
   a4f66:	mov    %rsi,%r15
   a4f69:	mov    %rdi,%r12
   a4f6c:	xor    %ebp,%ebp
   a4f6e:	mov    %rsp,%r13
   a4f71:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   a4f80:	mov    (%r14,%rbp,8),%rax
   a4f84:	mov    %rax,(%rsp)
   a4f88:	mov    %r12,%rdi
   a4f8b:	mov    %r13,%rsi
   a4f8e:	call   7e290 <bloomfilter::BloomFilter<unsigned long, 8ul, false, external_bloom::IdentityHash, 11>::Contain(unsigned long const&) const>
   a4f93:	xor    %ecx,%ecx
   a4f95:	test   %eax,%eax
   a4f97:	sete   %cl
   a4f9a:	mov    %ecx,(%rbx,%rbp,4)
   a4f9d:	inc    %rbp
   a4fa0:	cmp    %rbp,%r15
   a4fa3:	jne    a4f80 <void inline_single_kernel<false, external_bloom::Classical<11, false, true>, unsigned long>(external_bloom::Classical<11, false, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   a4fa5:	add    $0x8,%rsp
   a4fa9:	pop    %rbx
   a4faa:	pop    %r12
   a4fac:	pop    %r13
   a4fae:	pop    %r14
   a4fb0:	pop    %r15
   a4fb2:	pop    %rbp
   a4fb3:	ret
   a4fb4:	int3
   a4fb5:	int3
   a4fb6:	int3
   a4fb7:	int3
   a4fb8:	int3
   a4fb9:	int3
   a4fba:	int3
   a4fbb:	int3
   a4fbc:	int3
   a4fbd:	int3
   a4fbe:	int3
   a4fbf:	int3

