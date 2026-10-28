0000000000099a40 <void inline_single_kernel<true, external_bloom::Classical<22, true, false>, unsigned long>(external_bloom::Classical<22, true, false> const&, unsigned long, unsigned long const*, unsigned int*)>:
   99a40:	test   %rsi,%rsi
   99a43:	je     99aca <void inline_single_kernel<true, external_bloom::Classical<22, true, false>, unsigned long>(external_bloom::Classical<22, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x8a>
   99a49:	push   %rbp
   99a4a:	push   %r15
   99a4c:	push   %r14
   99a4e:	push   %r13
   99a50:	push   %r12
   99a52:	push   %rbx
   99a53:	push   %rax
   99a54:	mov    %rcx,%rbx
   99a57:	mov    %rdx,%r14
   99a5a:	mov    %rsi,%r15
   99a5d:	mov    %rdi,%r12
   99a60:	movabs $0xd6e8feb86659fd93,%rbp
   99a6a:	xor    %r13d,%r13d
   99a6d:	nopl   (%rax)
   99a70:	mov    (%r14,%r13,8),%rax
   99a74:	mov    %rax,%rcx
   99a77:	shr    $0x20,%rcx
   99a7b:	xor    %rax,%rcx
   99a7e:	imul   %rbp,%rcx
   99a82:	mov    %rcx,%rax
   99a85:	shr    $0x20,%rax
   99a89:	xor    %rcx,%rax
   99a8c:	imul   %rbp,%rax
   99a90:	mov    %rax,%rcx
   99a93:	shr    $0x20,%rcx
   99a97:	xor    %rax,%rcx
   99a9a:	mov    %rcx,(%rsp)
   99a9e:	mov    %r12,%rdi
   99aa1:	mov    %rsp,%rsi
   99aa4:	call   99c30 <bloomfilter::BloomFilter<unsigned long, 8ul, true, external_bloom::IdentityHash, 22>::Contain(unsigned long const&) const>
   99aa9:	xor    %ecx,%ecx
   99aab:	test   %eax,%eax
   99aad:	sete   %cl
   99ab0:	mov    %ecx,(%rbx,%r13,4)
   99ab4:	inc    %r13
   99ab7:	cmp    %r13,%r15
   99aba:	jne    99a70 <void inline_single_kernel<true, external_bloom::Classical<22, true, false>, unsigned long>(external_bloom::Classical<22, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   99abc:	add    $0x8,%rsp
   99ac0:	pop    %rbx
   99ac1:	pop    %r12
   99ac3:	pop    %r13
   99ac5:	pop    %r14
   99ac7:	pop    %r15
   99ac9:	pop    %rbp
   99aca:	ret
   99acb:	int3
   99acc:	int3
   99acd:	int3
   99ace:	int3
   99acf:	int3

