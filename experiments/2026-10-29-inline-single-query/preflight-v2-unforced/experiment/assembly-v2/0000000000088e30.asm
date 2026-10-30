0000000000088e30 <void inline_single_kernel<true, external_bloom::Classical<22, false, false>, unsigned long>(external_bloom::Classical<22, false, false> const&, unsigned long, unsigned long const*, unsigned int*)>:
   88e30:	test   %rsi,%rsi
   88e33:	je     88eba <void inline_single_kernel<true, external_bloom::Classical<22, false, false>, unsigned long>(external_bloom::Classical<22, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x8a>
   88e39:	push   %rbp
   88e3a:	push   %r15
   88e3c:	push   %r14
   88e3e:	push   %r13
   88e40:	push   %r12
   88e42:	push   %rbx
   88e43:	push   %rax
   88e44:	mov    %rcx,%rbx
   88e47:	mov    %rdx,%r14
   88e4a:	mov    %rsi,%r15
   88e4d:	mov    %rdi,%r12
   88e50:	movabs $0xd6e8feb86659fd93,%rbp
   88e5a:	xor    %r13d,%r13d
   88e5d:	nopl   (%rax)
   88e60:	mov    (%r14,%r13,8),%rax
   88e64:	mov    %rax,%rcx
   88e67:	shr    $0x20,%rcx
   88e6b:	xor    %rax,%rcx
   88e6e:	imul   %rbp,%rcx
   88e72:	mov    %rcx,%rax
   88e75:	shr    $0x20,%rax
   88e79:	xor    %rcx,%rax
   88e7c:	imul   %rbp,%rax
   88e80:	mov    %rax,%rcx
   88e83:	shr    $0x20,%rcx
   88e87:	xor    %rax,%rcx
   88e8a:	mov    %rcx,(%rsp)
   88e8e:	mov    %r12,%rdi
   88e91:	mov    %rsp,%rsi
   88e94:	call   89020 <bloomfilter::BloomFilter<unsigned long, 8ul, false, external_bloom::IdentityHash, 22>::Contain(unsigned long const&) const>
   88e99:	xor    %ecx,%ecx
   88e9b:	test   %eax,%eax
   88e9d:	sete   %cl
   88ea0:	mov    %ecx,(%rbx,%r13,4)
   88ea4:	inc    %r13
   88ea7:	cmp    %r13,%r15
   88eaa:	jne    88e60 <void inline_single_kernel<true, external_bloom::Classical<22, false, false>, unsigned long>(external_bloom::Classical<22, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   88eac:	add    $0x8,%rsp
   88eb0:	pop    %rbx
   88eb1:	pop    %r12
   88eb3:	pop    %r13
   88eb5:	pop    %r14
   88eb7:	pop    %r15
   88eb9:	pop    %rbp
   88eba:	ret
   88ebb:	int3
   88ebc:	int3
   88ebd:	int3
   88ebe:	int3
   88ebf:	int3

