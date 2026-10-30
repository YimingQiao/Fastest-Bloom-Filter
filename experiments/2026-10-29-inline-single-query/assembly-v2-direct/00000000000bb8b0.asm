00000000000bb8b0 <void inline_single_kernel<false, external_bloom::Page<4u, true>, unsigned long>(external_bloom::Page<4u, true> const&, unsigned long, unsigned long const*, unsigned int*)>:
   bb8b0:	test   %rsi,%rsi
   bb8b3:	je     bba81 <void inline_single_kernel<false, external_bloom::Page<4u, true>, unsigned long>(external_bloom::Page<4u, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x1d1>
   bb8b9:	push   %rbp
   bb8ba:	push   %r15
   bb8bc:	push   %r14
   bb8be:	push   %r13
   bb8c0:	push   %r12
   bb8c2:	push   %rbx
   bb8c3:	mov    %rdx,%rax
   bb8c6:	xor    %r8d,%r8d
   bb8c9:	movabs $0xdeadbeefdeadbeef,%r9
   bb8d3:	movabs $0xe6adbeefdeadbeef,%r10
   bb8dd:	mov    $0xffffffff,%r11d
   bb8e3:	mov    $0x1,%ebx
   bb8e8:	jmp    bb900 <void inline_single_kernel<false, external_bloom::Page<4u, true>, unsigned long>(external_bloom::Page<4u, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
   bb8ea:	nopw   0x0(%rax,%rax,1)
   bb8f0:	mov    %ebp,(%rcx,%r8,4)
   bb8f4:	inc    %r8
   bb8f7:	cmp    %r8,%rsi
   bb8fa:	je     bba77 <void inline_single_kernel<false, external_bloom::Page<4u, true>, unsigned long>(external_bloom::Page<4u, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x1c7>
   bb900:	mov    (%rax,%r8,8),%rdx
   bb904:	add    %r9,%rdx
   bb907:	rorx   $0x31,%rdx,%r14
   bb90d:	xor    %r10,%rdx
   bb910:	add    %r14,%rdx
   bb913:	rorx   $0xc,%rdx,%r15
   bb919:	add    %r15,%rdx
   bb91c:	rorx   $0x26,%rdx,%r12
   bb922:	add    %r12,%rdx
   bb925:	xor    %rdx,%r14
   bb928:	rorx   $0xd,%rdx,%rdx
   bb92e:	add    %rdx,%r14
   bb931:	xor    %r14,%r15
   bb934:	rorx   $0x24,%r14,%r14
   bb93a:	add    %r14,%r15
   bb93d:	xor    %r15,%r12
   bb940:	rorx   $0x37,%r15,%r15
   bb946:	add    %r15,%r12
   bb949:	xor    %r12,%rdx
   bb94c:	rorx   $0x11,%r12,%r12
   bb952:	add    %r12,%rdx
   bb955:	xor    %rdx,%r14
   bb958:	rorx   $0xa,%rdx,%rdx
   bb95e:	add    %rdx,%r14
   bb961:	xor    %r14,%r15
   bb964:	rorx   $0x20,%r14,%r14
   bb96a:	add    %r15,%r14
   bb96d:	xor    %r14,%r12
   bb970:	rorx   $0x27,%r14,%r14
   bb976:	add    %r12,%r14
   bb979:	xor    %r14,%rdx
   bb97c:	rorx   $0x1,%r14,%r14
   bb982:	add    %r14,%rdx
   bb985:	mov    %r14,%r12
   bb988:	shr    $0x20,%r12
   bb98c:	mov    %edx,%ebp
   bb98e:	shr    $0x20,%rdx
   bb992:	rorx   $0x18,%r14d,%r15d
   bb998:	rorx   $0x1a,%r12d,%r13d
   bb99e:	xor    %r15d,%r13d
   bb9a1:	rorx   $0x1c,%ebp,%ebp
   bb9a7:	xor    %r13d,%ebp
   bb9aa:	rorx   $0x1e,%edx,%edx
   bb9b0:	xor    %ebp,%edx
   bb9b2:	mov    0x8(%rdi),%r15d
   bb9b6:	imul   0x10(%rdi),%rdx
   bb9bb:	mulx   %r15,%rdx,%rdx
   bb9c0:	movzbl (%rdi),%r15d
   bb9c4:	shlx   %r15,%rdx,%rdx
   bb9c9:	add    0x20(%rdi),%rdx
   bb9cd:	add    $0x3,%r15b
   bb9d1:	bzhi   %r15d,%r14d,%ebp
   bb9d6:	movzwl %bp,%r13d
   bb9da:	shr    $0x3,%r13d
   bb9de:	movzbl 0x0(%r13,%rdx,1),%r13d
   bb9e4:	and    $0x7,%ebp
   bb9e7:	bt     %ebp,%r13d
   bb9eb:	mov    $0x0,%ebp
   bb9f0:	jae    bb8f0 <void inline_single_kernel<false, external_bloom::Page<4u, true>, unsigned long>(external_bloom::Page<4u, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
   bb9f6:	shlx   %r15d,%r11d,%ebp
   bb9fb:	mov    %r14d,%r13d
   bb9fe:	shr    $0x10,%r13d
   bba02:	andn   %r13d,%ebp,%ebp
   bba07:	mov    %ebp,%r13d
   bba0a:	shr    $0x3,%r13d
   bba0e:	movzbl (%rdx,%r13,1),%r13d
   bba13:	and    $0x7,%ebp
   bba16:	bt     %ebp,%r13d
   bba1a:	mov    $0x0,%ebp
   bba1f:	jae    bb8f0 <void inline_single_kernel<false, external_bloom::Page<4u, true>, unsigned long>(external_bloom::Page<4u, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
   bba25:	bzhi   %r15d,%r12d,%ebp
   bba2a:	movzwl %bp,%r12d
   bba2e:	and    $0x7,%bpl
   bba32:	shr    $0x3,%r12d
   bba36:	shlx   %ebp,%ebx,%ebp
   bba3b:	movzbl (%rdx,%r12,1),%r12d
   bba40:	movzwl %bp,%r13d
   bba44:	mov    $0x0,%ebp
   bba49:	test   %r12d,%r13d
   bba4c:	je     bb8f0 <void inline_single_kernel<false, external_bloom::Page<4u, true>, unsigned long>(external_bloom::Page<4u, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
   bba52:	shr    $0x30,%r14
   bba56:	bzhi   %r15d,%r14d,%r14d
   bba5b:	mov    %r14d,%ebp
   bba5e:	and    $0x7,%ebp
   bba61:	shr    $0x3,%r14d
   bba65:	movzbl (%rdx,%r14,1),%edx
   bba6a:	shrx   %ebp,%edx,%ebp
   bba6f:	and    $0x1,%ebp
   bba72:	jmp    bb8f0 <void inline_single_kernel<false, external_bloom::Page<4u, true>, unsigned long>(external_bloom::Page<4u, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
   bba77:	pop    %rbx
   bba78:	pop    %r12
   bba7a:	pop    %r13
   bba7c:	pop    %r14
   bba7e:	pop    %r15
   bba80:	pop    %rbp
   bba81:	ret
   bba82:	int3
   bba83:	int3
   bba84:	int3
   bba85:	int3
   bba86:	int3
   bba87:	int3
   bba88:	int3
   bba89:	int3
   bba8a:	int3
   bba8b:	int3
   bba8c:	int3
   bba8d:	int3
   bba8e:	int3
   bba8f:	int3

