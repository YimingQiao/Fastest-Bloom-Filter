000000000007db50 <void inline_single_kernel<false, external_bloom::Classical<11, false, false>, unsigned long>(external_bloom::Classical<11, false, false> const&, unsigned long, unsigned long const*, unsigned int*)>:
   7db50:	test   %rsi,%rsi
   7db53:	je     7dbb3 <void inline_single_kernel<false, external_bloom::Classical<11, false, false>, unsigned long>(external_bloom::Classical<11, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x63>
   7db55:	push   %rbp
   7db56:	push   %r15
   7db58:	push   %r14
   7db5a:	push   %r13
   7db5c:	push   %r12
   7db5e:	push   %rbx
   7db5f:	push   %rax
   7db60:	mov    %rcx,%rbx
   7db63:	mov    %rdx,%r14
   7db66:	mov    %rsi,%r15
   7db69:	mov    %rdi,%r12
   7db6c:	xor    %ebp,%ebp
   7db6e:	mov    %rsp,%r13
   7db71:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   7db80:	mov    (%r14,%rbp,8),%rax
   7db84:	mov    %rax,(%rsp)
   7db88:	mov    %r12,%rdi
   7db8b:	mov    %r13,%rsi
   7db8e:	call   7e290 <bloomfilter::BloomFilter<unsigned long, 8ul, false, external_bloom::IdentityHash, 11>::Contain(unsigned long const&) const>
   7db93:	xor    %ecx,%ecx
   7db95:	test   %eax,%eax
   7db97:	sete   %cl
   7db9a:	mov    %ecx,(%rbx,%rbp,4)
   7db9d:	inc    %rbp
   7dba0:	cmp    %rbp,%r15
   7dba3:	jne    7db80 <void inline_single_kernel<false, external_bloom::Classical<11, false, false>, unsigned long>(external_bloom::Classical<11, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   7dba5:	add    $0x8,%rsp
   7dba9:	pop    %rbx
   7dbaa:	pop    %r12
   7dbac:	pop    %r13
   7dbae:	pop    %r14
   7dbb0:	pop    %r15
   7dbb2:	pop    %rbp
   7dbb3:	ret
   7dbb4:	int3
   7dbb5:	int3
   7dbb6:	int3
   7dbb7:	int3
   7dbb8:	int3
   7dbb9:	int3
   7dbba:	int3
   7dbbb:	int3
   7dbbc:	int3
   7dbbd:	int3
   7dbbe:	int3
   7dbbf:	int3

