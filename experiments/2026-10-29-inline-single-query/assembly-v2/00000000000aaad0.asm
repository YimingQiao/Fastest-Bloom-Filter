00000000000aaad0 <void inline_single_kernel<true, external_bloom::Classical<22, false, true>, unsigned long>(external_bloom::Classical<22, false, true> const&, unsigned long, unsigned long const*, unsigned int*)>:
   aaad0:	test   %rsi,%rsi
   aaad3:	je     aab5a <void inline_single_kernel<true, external_bloom::Classical<22, false, true>, unsigned long>(external_bloom::Classical<22, false, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x8a>
   aaad9:	push   %rbp
   aaada:	push   %r15
   aaadc:	push   %r14
   aaade:	push   %r13
   aaae0:	push   %r12
   aaae2:	push   %rbx
   aaae3:	push   %rax
   aaae4:	mov    %rcx,%rbx
   aaae7:	mov    %rdx,%r14
   aaaea:	mov    %rsi,%r15
   aaaed:	mov    %rdi,%r12
   aaaf0:	movabs $0xd6e8feb86659fd93,%rbp
   aaafa:	xor    %r13d,%r13d
   aaafd:	nopl   (%rax)
   aab00:	mov    (%r14,%r13,8),%rax
   aab04:	mov    %rax,%rcx
   aab07:	shr    $0x20,%rcx
   aab0b:	xor    %rax,%rcx
   aab0e:	imul   %rbp,%rcx
   aab12:	mov    %rcx,%rax
   aab15:	shr    $0x20,%rax
   aab19:	xor    %rcx,%rax
   aab1c:	imul   %rbp,%rax
   aab20:	mov    %rax,%rcx
   aab23:	shr    $0x20,%rcx
   aab27:	xor    %rax,%rcx
   aab2a:	mov    %rcx,(%rsp)
   aab2e:	mov    %r12,%rdi
   aab31:	mov    %rsp,%rsi
   aab34:	call   89020 <bloomfilter::BloomFilter<unsigned long, 8ul, false, external_bloom::IdentityHash, 22>::Contain(unsigned long const&) const>
   aab39:	xor    %ecx,%ecx
   aab3b:	test   %eax,%eax
   aab3d:	sete   %cl
   aab40:	mov    %ecx,(%rbx,%r13,4)
   aab44:	inc    %r13
   aab47:	cmp    %r13,%r15
   aab4a:	jne    aab00 <void inline_single_kernel<true, external_bloom::Classical<22, false, true>, unsigned long>(external_bloom::Classical<22, false, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   aab4c:	add    $0x8,%rsp
   aab50:	pop    %rbx
   aab51:	pop    %r12
   aab53:	pop    %r13
   aab55:	pop    %r14
   aab57:	pop    %r15
   aab59:	pop    %rbp
   aab5a:	ret
   aab5b:	int3
   aab5c:	int3
   aab5d:	int3
   aab5e:	int3
   aab5f:	int3

