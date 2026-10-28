00000000000aaa50 <void inline_single_kernel<true, external_bloom::Classical<22, false, true>, unsigned long>(external_bloom::Classical<22, false, true> const&, unsigned long, unsigned long const*, unsigned int*)>:
   aaa50:	test   %rsi,%rsi
   aaa53:	je     aaada <void inline_single_kernel<true, external_bloom::Classical<22, false, true>, unsigned long>(external_bloom::Classical<22, false, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x8a>
   aaa59:	push   %rbp
   aaa5a:	push   %r15
   aaa5c:	push   %r14
   aaa5e:	push   %r13
   aaa60:	push   %r12
   aaa62:	push   %rbx
   aaa63:	push   %rax
   aaa64:	mov    %rcx,%rbx
   aaa67:	mov    %rdx,%r14
   aaa6a:	mov    %rsi,%r15
   aaa6d:	mov    %rdi,%r12
   aaa70:	movabs $0xd6e8feb86659fd93,%rbp
   aaa7a:	xor    %r13d,%r13d
   aaa7d:	nopl   (%rax)
   aaa80:	mov    (%r14,%r13,8),%rax
   aaa84:	mov    %rax,%rcx
   aaa87:	shr    $0x20,%rcx
   aaa8b:	xor    %rax,%rcx
   aaa8e:	imul   %rbp,%rcx
   aaa92:	mov    %rcx,%rax
   aaa95:	shr    $0x20,%rax
   aaa99:	xor    %rcx,%rax
   aaa9c:	imul   %rbp,%rax
   aaaa0:	mov    %rax,%rcx
   aaaa3:	shr    $0x20,%rcx
   aaaa7:	xor    %rax,%rcx
   aaaaa:	mov    %rcx,(%rsp)
   aaaae:	mov    %r12,%rdi
   aaab1:	mov    %rsp,%rsi
   aaab4:	call   88fa0 <bloomfilter::BloomFilter<unsigned long, 8ul, false, external_bloom::IdentityHash, 22>::Contain(unsigned long const&) const>
   aaab9:	xor    %ecx,%ecx
   aaabb:	test   %eax,%eax
   aaabd:	sete   %cl
   aaac0:	mov    %ecx,(%rbx,%r13,4)
   aaac4:	inc    %r13
   aaac7:	cmp    %r13,%r15
   aaaca:	jne    aaa80 <void inline_single_kernel<true, external_bloom::Classical<22, false, true>, unsigned long>(external_bloom::Classical<22, false, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   aaacc:	add    $0x8,%rsp
   aaad0:	pop    %rbx
   aaad1:	pop    %r12
   aaad3:	pop    %r13
   aaad5:	pop    %r14
   aaad7:	pop    %r15
   aaad9:	pop    %rbp
   aaada:	ret
   aaadb:	int3
   aaadc:	int3
   aaadd:	int3
   aaade:	int3
   aaadf:	int3

