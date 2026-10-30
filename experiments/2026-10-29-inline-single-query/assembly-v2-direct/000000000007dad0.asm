000000000007dad0 <void inline_single_kernel<false, external_bloom::Classical<11, false, false>, unsigned long>(external_bloom::Classical<11, false, false> const&, unsigned long, unsigned long const*, unsigned int*)>:
   7dad0:	test   %rsi,%rsi
   7dad3:	je     7db33 <void inline_single_kernel<false, external_bloom::Classical<11, false, false>, unsigned long>(external_bloom::Classical<11, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x63>
   7dad5:	push   %rbp
   7dad6:	push   %r15
   7dad8:	push   %r14
   7dada:	push   %r13
   7dadc:	push   %r12
   7dade:	push   %rbx
   7dadf:	push   %rax
   7dae0:	mov    %rcx,%rbx
   7dae3:	mov    %rdx,%r14
   7dae6:	mov    %rsi,%r15
   7dae9:	mov    %rdi,%r12
   7daec:	xor    %ebp,%ebp
   7daee:	mov    %rsp,%r13
   7daf1:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   7db00:	mov    (%r14,%rbp,8),%rax
   7db04:	mov    %rax,(%rsp)
   7db08:	mov    %r12,%rdi
   7db0b:	mov    %r13,%rsi
   7db0e:	call   7e210 <bloomfilter::BloomFilter<unsigned long, 8ul, false, external_bloom::IdentityHash, 11>::Contain(unsigned long const&) const>
   7db13:	xor    %ecx,%ecx
   7db15:	test   %eax,%eax
   7db17:	sete   %cl
   7db1a:	mov    %ecx,(%rbx,%rbp,4)
   7db1d:	inc    %rbp
   7db20:	cmp    %rbp,%r15
   7db23:	jne    7db00 <void inline_single_kernel<false, external_bloom::Classical<11, false, false>, unsigned long>(external_bloom::Classical<11, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   7db25:	add    $0x8,%rsp
   7db29:	pop    %rbx
   7db2a:	pop    %r12
   7db2c:	pop    %r13
   7db2e:	pop    %r14
   7db30:	pop    %r15
   7db32:	pop    %rbp
   7db33:	ret
   7db34:	int3
   7db35:	int3
   7db36:	int3
   7db37:	int3
   7db38:	int3
   7db39:	int3
   7db3a:	int3
   7db3b:	int3
   7db3c:	int3
   7db3d:	int3
   7db3e:	int3
   7db3f:	int3

