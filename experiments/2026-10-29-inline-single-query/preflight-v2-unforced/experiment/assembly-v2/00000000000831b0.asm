00000000000831b0 <void inline_single_kernel<false, external_bloom::Classical<16, false, false>, unsigned long>(external_bloom::Classical<16, false, false> const&, unsigned long, unsigned long const*, unsigned int*)>:
   831b0:	test   %rsi,%rsi
   831b3:	je     83213 <void inline_single_kernel<false, external_bloom::Classical<16, false, false>, unsigned long>(external_bloom::Classical<16, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x63>
   831b5:	push   %rbp
   831b6:	push   %r15
   831b8:	push   %r14
   831ba:	push   %r13
   831bc:	push   %r12
   831be:	push   %rbx
   831bf:	push   %rax
   831c0:	mov    %rcx,%rbx
   831c3:	mov    %rdx,%r14
   831c6:	mov    %rsi,%r15
   831c9:	mov    %rdi,%r12
   831cc:	xor    %ebp,%ebp
   831ce:	mov    %rsp,%r13
   831d1:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   831e0:	mov    (%r14,%rbp,8),%rax
   831e4:	mov    %rax,(%rsp)
   831e8:	mov    %r12,%rdi
   831eb:	mov    %r13,%rsi
   831ee:	call   83950 <bloomfilter::BloomFilter<unsigned long, 8ul, false, external_bloom::IdentityHash, 16>::Contain(unsigned long const&) const>
   831f3:	xor    %ecx,%ecx
   831f5:	test   %eax,%eax
   831f7:	sete   %cl
   831fa:	mov    %ecx,(%rbx,%rbp,4)
   831fd:	inc    %rbp
   83200:	cmp    %rbp,%r15
   83203:	jne    831e0 <void inline_single_kernel<false, external_bloom::Classical<16, false, false>, unsigned long>(external_bloom::Classical<16, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   83205:	add    $0x8,%rsp
   83209:	pop    %rbx
   8320a:	pop    %r12
   8320c:	pop    %r13
   8320e:	pop    %r14
   83210:	pop    %r15
   83212:	pop    %rbp
   83213:	ret
   83214:	int3
   83215:	int3
   83216:	int3
   83217:	int3
   83218:	int3
   83219:	int3
   8321a:	int3
   8321b:	int3
   8321c:	int3
   8321d:	int3
   8321e:	int3
   8321f:	int3

