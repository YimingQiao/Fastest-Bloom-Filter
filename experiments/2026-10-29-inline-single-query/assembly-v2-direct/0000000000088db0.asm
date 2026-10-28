0000000000088db0 <void inline_single_kernel<true, external_bloom::Classical<22, false, false>, unsigned long>(external_bloom::Classical<22, false, false> const&, unsigned long, unsigned long const*, unsigned int*)>:
   88db0:	test   %rsi,%rsi
   88db3:	je     88e3a <void inline_single_kernel<true, external_bloom::Classical<22, false, false>, unsigned long>(external_bloom::Classical<22, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x8a>
   88db9:	push   %rbp
   88dba:	push   %r15
   88dbc:	push   %r14
   88dbe:	push   %r13
   88dc0:	push   %r12
   88dc2:	push   %rbx
   88dc3:	push   %rax
   88dc4:	mov    %rcx,%rbx
   88dc7:	mov    %rdx,%r14
   88dca:	mov    %rsi,%r15
   88dcd:	mov    %rdi,%r12
   88dd0:	movabs $0xd6e8feb86659fd93,%rbp
   88dda:	xor    %r13d,%r13d
   88ddd:	nopl   (%rax)
   88de0:	mov    (%r14,%r13,8),%rax
   88de4:	mov    %rax,%rcx
   88de7:	shr    $0x20,%rcx
   88deb:	xor    %rax,%rcx
   88dee:	imul   %rbp,%rcx
   88df2:	mov    %rcx,%rax
   88df5:	shr    $0x20,%rax
   88df9:	xor    %rcx,%rax
   88dfc:	imul   %rbp,%rax
   88e00:	mov    %rax,%rcx
   88e03:	shr    $0x20,%rcx
   88e07:	xor    %rax,%rcx
   88e0a:	mov    %rcx,(%rsp)
   88e0e:	mov    %r12,%rdi
   88e11:	mov    %rsp,%rsi
   88e14:	call   88fa0 <bloomfilter::BloomFilter<unsigned long, 8ul, false, external_bloom::IdentityHash, 22>::Contain(unsigned long const&) const>
   88e19:	xor    %ecx,%ecx
   88e1b:	test   %eax,%eax
   88e1d:	sete   %cl
   88e20:	mov    %ecx,(%rbx,%r13,4)
   88e24:	inc    %r13
   88e27:	cmp    %r13,%r15
   88e2a:	jne    88de0 <void inline_single_kernel<true, external_bloom::Classical<22, false, false>, unsigned long>(external_bloom::Classical<22, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   88e2c:	add    $0x8,%rsp
   88e30:	pop    %rbx
   88e31:	pop    %r12
   88e33:	pop    %r13
   88e35:	pop    %r14
   88e37:	pop    %r15
   88e39:	pop    %rbp
   88e3a:	ret
   88e3b:	int3
   88e3c:	int3
   88e3d:	int3
   88e3e:	int3
   88e3f:	int3

