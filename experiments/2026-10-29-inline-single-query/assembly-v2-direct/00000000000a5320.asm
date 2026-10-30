00000000000a5320 <void inline_single_kernel<true, external_bloom::Classical<11, false, true>, unsigned long>(external_bloom::Classical<11, false, true> const&, unsigned long, unsigned long const*, unsigned int*)>:
   a5320:	test   %rsi,%rsi
   a5323:	je     a53aa <void inline_single_kernel<true, external_bloom::Classical<11, false, true>, unsigned long>(external_bloom::Classical<11, false, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x8a>
   a5329:	push   %rbp
   a532a:	push   %r15
   a532c:	push   %r14
   a532e:	push   %r13
   a5330:	push   %r12
   a5332:	push   %rbx
   a5333:	push   %rax
   a5334:	mov    %rcx,%rbx
   a5337:	mov    %rdx,%r14
   a533a:	mov    %rsi,%r15
   a533d:	mov    %rdi,%r12
   a5340:	movabs $0xd6e8feb86659fd93,%rbp
   a534a:	xor    %r13d,%r13d
   a534d:	nopl   (%rax)
   a5350:	mov    (%r14,%r13,8),%rax
   a5354:	mov    %rax,%rcx
   a5357:	shr    $0x20,%rcx
   a535b:	xor    %rax,%rcx
   a535e:	imul   %rbp,%rcx
   a5362:	mov    %rcx,%rax
   a5365:	shr    $0x20,%rax
   a5369:	xor    %rcx,%rax
   a536c:	imul   %rbp,%rax
   a5370:	mov    %rax,%rcx
   a5373:	shr    $0x20,%rcx
   a5377:	xor    %rax,%rcx
   a537a:	mov    %rcx,(%rsp)
   a537e:	mov    %r12,%rdi
   a5381:	mov    %rsp,%rsi
   a5384:	call   7e210 <bloomfilter::BloomFilter<unsigned long, 8ul, false, external_bloom::IdentityHash, 11>::Contain(unsigned long const&) const>
   a5389:	xor    %ecx,%ecx
   a538b:	test   %eax,%eax
   a538d:	sete   %cl
   a5390:	mov    %ecx,(%rbx,%r13,4)
   a5394:	inc    %r13
   a5397:	cmp    %r13,%r15
   a539a:	jne    a5350 <void inline_single_kernel<true, external_bloom::Classical<11, false, true>, unsigned long>(external_bloom::Classical<11, false, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   a539c:	add    $0x8,%rsp
   a53a0:	pop    %rbx
   a53a1:	pop    %r12
   a53a3:	pop    %r13
   a53a5:	pop    %r14
   a53a7:	pop    %r15
   a53a9:	pop    %rbp
   a53aa:	ret
   a53ab:	int3
   a53ac:	int3
   a53ad:	int3
   a53ae:	int3
   a53af:	int3

