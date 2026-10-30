00000000000889e0 <void inline_single_kernel<false, external_bloom::Classical<22, false, false>, unsigned long>(external_bloom::Classical<22, false, false> const&, unsigned long, unsigned long const*, unsigned int*)>:
   889e0:	test   %rsi,%rsi
   889e3:	je     88a43 <void inline_single_kernel<false, external_bloom::Classical<22, false, false>, unsigned long>(external_bloom::Classical<22, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x63>
   889e5:	push   %rbp
   889e6:	push   %r15
   889e8:	push   %r14
   889ea:	push   %r13
   889ec:	push   %r12
   889ee:	push   %rbx
   889ef:	push   %rax
   889f0:	mov    %rcx,%rbx
   889f3:	mov    %rdx,%r14
   889f6:	mov    %rsi,%r15
   889f9:	mov    %rdi,%r12
   889fc:	xor    %ebp,%ebp
   889fe:	mov    %rsp,%r13
   88a01:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   88a10:	mov    (%r14,%rbp,8),%rax
   88a14:	mov    %rax,(%rsp)
   88a18:	mov    %r12,%rdi
   88a1b:	mov    %r13,%rsi
   88a1e:	call   89020 <bloomfilter::BloomFilter<unsigned long, 8ul, false, external_bloom::IdentityHash, 22>::Contain(unsigned long const&) const>
   88a23:	xor    %ecx,%ecx
   88a25:	test   %eax,%eax
   88a27:	sete   %cl
   88a2a:	mov    %ecx,(%rbx,%rbp,4)
   88a2d:	inc    %rbp
   88a30:	cmp    %rbp,%r15
   88a33:	jne    88a10 <void inline_single_kernel<false, external_bloom::Classical<22, false, false>, unsigned long>(external_bloom::Classical<22, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   88a35:	add    $0x8,%rsp
   88a39:	pop    %rbx
   88a3a:	pop    %r12
   88a3c:	pop    %r13
   88a3e:	pop    %r14
   88a40:	pop    %r15
   88a42:	pop    %rbp
   88a43:	ret
   88a44:	int3
   88a45:	int3
   88a46:	int3
   88a47:	int3
   88a48:	int3
   88a49:	int3
   88a4a:	int3
   88a4b:	int3
   88a4c:	int3
   88a4d:	int3
   88a4e:	int3
   88a4f:	int3

