00000000000aa600 <void inline_single_kernel<false, external_bloom::Classical<22, false, true>, unsigned long>(external_bloom::Classical<22, false, true> const&, unsigned long, unsigned long const*, unsigned int*)>:
   aa600:	test   %rsi,%rsi
   aa603:	je     aa663 <void inline_single_kernel<false, external_bloom::Classical<22, false, true>, unsigned long>(external_bloom::Classical<22, false, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x63>
   aa605:	push   %rbp
   aa606:	push   %r15
   aa608:	push   %r14
   aa60a:	push   %r13
   aa60c:	push   %r12
   aa60e:	push   %rbx
   aa60f:	push   %rax
   aa610:	mov    %rcx,%rbx
   aa613:	mov    %rdx,%r14
   aa616:	mov    %rsi,%r15
   aa619:	mov    %rdi,%r12
   aa61c:	xor    %ebp,%ebp
   aa61e:	mov    %rsp,%r13
   aa621:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   aa630:	mov    (%r14,%rbp,8),%rax
   aa634:	mov    %rax,(%rsp)
   aa638:	mov    %r12,%rdi
   aa63b:	mov    %r13,%rsi
   aa63e:	call   88fa0 <bloomfilter::BloomFilter<unsigned long, 8ul, false, external_bloom::IdentityHash, 22>::Contain(unsigned long const&) const>
   aa643:	xor    %ecx,%ecx
   aa645:	test   %eax,%eax
   aa647:	sete   %cl
   aa64a:	mov    %ecx,(%rbx,%rbp,4)
   aa64d:	inc    %rbp
   aa650:	cmp    %rbp,%r15
   aa653:	jne    aa630 <void inline_single_kernel<false, external_bloom::Classical<22, false, true>, unsigned long>(external_bloom::Classical<22, false, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   aa655:	add    $0x8,%rsp
   aa659:	pop    %rbx
   aa65a:	pop    %r12
   aa65c:	pop    %r13
   aa65e:	pop    %r14
   aa660:	pop    %r15
   aa662:	pop    %rbp
   aa663:	ret
   aa664:	int3
   aa665:	int3
   aa666:	int3
   aa667:	int3
   aa668:	int3
   aa669:	int3
   aa66a:	int3
   aa66b:	int3
   aa66c:	int3
   aa66d:	int3
   aa66e:	int3
   aa66f:	int3

