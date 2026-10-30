00000000000a4ed0 <void inline_single_kernel<false, external_bloom::Classical<11, false, true>, unsigned long>(external_bloom::Classical<11, false, true> const&, unsigned long, unsigned long const*, unsigned int*)>:
   a4ed0:	test   %rsi,%rsi
   a4ed3:	je     a4f33 <void inline_single_kernel<false, external_bloom::Classical<11, false, true>, unsigned long>(external_bloom::Classical<11, false, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x63>
   a4ed5:	push   %rbp
   a4ed6:	push   %r15
   a4ed8:	push   %r14
   a4eda:	push   %r13
   a4edc:	push   %r12
   a4ede:	push   %rbx
   a4edf:	push   %rax
   a4ee0:	mov    %rcx,%rbx
   a4ee3:	mov    %rdx,%r14
   a4ee6:	mov    %rsi,%r15
   a4ee9:	mov    %rdi,%r12
   a4eec:	xor    %ebp,%ebp
   a4eee:	mov    %rsp,%r13
   a4ef1:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   a4f00:	mov    (%r14,%rbp,8),%rax
   a4f04:	mov    %rax,(%rsp)
   a4f08:	mov    %r12,%rdi
   a4f0b:	mov    %r13,%rsi
   a4f0e:	call   7e210 <bloomfilter::BloomFilter<unsigned long, 8ul, false, external_bloom::IdentityHash, 11>::Contain(unsigned long const&) const>
   a4f13:	xor    %ecx,%ecx
   a4f15:	test   %eax,%eax
   a4f17:	sete   %cl
   a4f1a:	mov    %ecx,(%rbx,%rbp,4)
   a4f1d:	inc    %rbp
   a4f20:	cmp    %rbp,%r15
   a4f23:	jne    a4f00 <void inline_single_kernel<false, external_bloom::Classical<11, false, true>, unsigned long>(external_bloom::Classical<11, false, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   a4f25:	add    $0x8,%rsp
   a4f29:	pop    %rbx
   a4f2a:	pop    %r12
   a4f2c:	pop    %r13
   a4f2e:	pop    %r14
   a4f30:	pop    %r15
   a4f32:	pop    %rbp
   a4f33:	ret
   a4f34:	int3
   a4f35:	int3
   a4f36:	int3
   a4f37:	int3
   a4f38:	int3
   a4f39:	int3
   a4f3a:	int3
   a4f3b:	int3
   a4f3c:	int3
   a4f3d:	int3
   a4f3e:	int3
   a4f3f:	int3

