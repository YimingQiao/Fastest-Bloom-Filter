0000000000083600 <void inline_single_kernel<true, external_bloom::Classical<16, false, false>, unsigned long>(external_bloom::Classical<16, false, false> const&, unsigned long, unsigned long const*, unsigned int*)>:
   83600:	test   %rsi,%rsi
   83603:	je     8368a <void inline_single_kernel<true, external_bloom::Classical<16, false, false>, unsigned long>(external_bloom::Classical<16, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x8a>
   83609:	push   %rbp
   8360a:	push   %r15
   8360c:	push   %r14
   8360e:	push   %r13
   83610:	push   %r12
   83612:	push   %rbx
   83613:	push   %rax
   83614:	mov    %rcx,%rbx
   83617:	mov    %rdx,%r14
   8361a:	mov    %rsi,%r15
   8361d:	mov    %rdi,%r12
   83620:	movabs $0xd6e8feb86659fd93,%rbp
   8362a:	xor    %r13d,%r13d
   8362d:	nopl   (%rax)
   83630:	mov    (%r14,%r13,8),%rax
   83634:	mov    %rax,%rcx
   83637:	shr    $0x20,%rcx
   8363b:	xor    %rax,%rcx
   8363e:	imul   %rbp,%rcx
   83642:	mov    %rcx,%rax
   83645:	shr    $0x20,%rax
   83649:	xor    %rcx,%rax
   8364c:	imul   %rbp,%rax
   83650:	mov    %rax,%rcx
   83653:	shr    $0x20,%rcx
   83657:	xor    %rax,%rcx
   8365a:	mov    %rcx,(%rsp)
   8365e:	mov    %r12,%rdi
   83661:	mov    %rsp,%rsi
   83664:	call   83950 <bloomfilter::BloomFilter<unsigned long, 8ul, false, external_bloom::IdentityHash, 16>::Contain(unsigned long const&) const>
   83669:	xor    %ecx,%ecx
   8366b:	test   %eax,%eax
   8366d:	sete   %cl
   83670:	mov    %ecx,(%rbx,%r13,4)
   83674:	inc    %r13
   83677:	cmp    %r13,%r15
   8367a:	jne    83630 <void inline_single_kernel<true, external_bloom::Classical<16, false, false>, unsigned long>(external_bloom::Classical<16, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   8367c:	add    $0x8,%rsp
   83680:	pop    %rbx
   83681:	pop    %r12
   83683:	pop    %r13
   83685:	pop    %r14
   83687:	pop    %r15
   83689:	pop    %rbp
   8368a:	ret
   8368b:	int3
   8368c:	int3
   8368d:	int3
   8368e:	int3
   8368f:	int3

