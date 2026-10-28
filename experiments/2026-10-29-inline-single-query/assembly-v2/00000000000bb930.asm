00000000000bb930 <void inline_single_kernel<false, external_bloom::Page<4u, true>, unsigned long>(external_bloom::Page<4u, true> const&, unsigned long, unsigned long const*, unsigned int*)>:
   bb930:	test   %rsi,%rsi
   bb933:	je     bbb01 <void inline_single_kernel<false, external_bloom::Page<4u, true>, unsigned long>(external_bloom::Page<4u, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x1d1>
   bb939:	push   %rbp
   bb93a:	push   %r15
   bb93c:	push   %r14
   bb93e:	push   %r13
   bb940:	push   %r12
   bb942:	push   %rbx
   bb943:	mov    %rdx,%rax
   bb946:	xor    %r8d,%r8d
   bb949:	movabs $0xdeadbeefdeadbeef,%r9
   bb953:	movabs $0xe6adbeefdeadbeef,%r10
   bb95d:	mov    $0xffffffff,%r11d
   bb963:	mov    $0x1,%ebx
   bb968:	jmp    bb980 <void inline_single_kernel<false, external_bloom::Page<4u, true>, unsigned long>(external_bloom::Page<4u, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
   bb96a:	nopw   0x0(%rax,%rax,1)
   bb970:	mov    %ebp,(%rcx,%r8,4)
   bb974:	inc    %r8
   bb977:	cmp    %r8,%rsi
   bb97a:	je     bbaf7 <void inline_single_kernel<false, external_bloom::Page<4u, true>, unsigned long>(external_bloom::Page<4u, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x1c7>
   bb980:	mov    (%rax,%r8,8),%rdx
   bb984:	add    %r9,%rdx
   bb987:	rorx   $0x31,%rdx,%r14
   bb98d:	xor    %r10,%rdx
   bb990:	add    %r14,%rdx
   bb993:	rorx   $0xc,%rdx,%r15
   bb999:	add    %r15,%rdx
   bb99c:	rorx   $0x26,%rdx,%r12
   bb9a2:	add    %r12,%rdx
   bb9a5:	xor    %rdx,%r14
   bb9a8:	rorx   $0xd,%rdx,%rdx
   bb9ae:	add    %rdx,%r14
   bb9b1:	xor    %r14,%r15
   bb9b4:	rorx   $0x24,%r14,%r14
   bb9ba:	add    %r14,%r15
   bb9bd:	xor    %r15,%r12
   bb9c0:	rorx   $0x37,%r15,%r15
   bb9c6:	add    %r15,%r12
   bb9c9:	xor    %r12,%rdx
   bb9cc:	rorx   $0x11,%r12,%r12
   bb9d2:	add    %r12,%rdx
   bb9d5:	xor    %rdx,%r14
   bb9d8:	rorx   $0xa,%rdx,%rdx
   bb9de:	add    %rdx,%r14
   bb9e1:	xor    %r14,%r15
   bb9e4:	rorx   $0x20,%r14,%r14
   bb9ea:	add    %r15,%r14
   bb9ed:	xor    %r14,%r12
   bb9f0:	rorx   $0x27,%r14,%r14
   bb9f6:	add    %r12,%r14
   bb9f9:	xor    %r14,%rdx
   bb9fc:	rorx   $0x1,%r14,%r14
   bba02:	add    %r14,%rdx
   bba05:	mov    %r14,%r12
   bba08:	shr    $0x20,%r12
   bba0c:	mov    %edx,%ebp
   bba0e:	shr    $0x20,%rdx
   bba12:	rorx   $0x18,%r14d,%r15d
   bba18:	rorx   $0x1a,%r12d,%r13d
   bba1e:	xor    %r15d,%r13d
   bba21:	rorx   $0x1c,%ebp,%ebp
   bba27:	xor    %r13d,%ebp
   bba2a:	rorx   $0x1e,%edx,%edx
   bba30:	xor    %ebp,%edx
   bba32:	mov    0x8(%rdi),%r15d
   bba36:	imul   0x10(%rdi),%rdx
   bba3b:	mulx   %r15,%rdx,%rdx
   bba40:	movzbl (%rdi),%r15d
   bba44:	shlx   %r15,%rdx,%rdx
   bba49:	add    0x20(%rdi),%rdx
   bba4d:	add    $0x3,%r15b
   bba51:	bzhi   %r15d,%r14d,%ebp
   bba56:	movzwl %bp,%r13d
   bba5a:	shr    $0x3,%r13d
   bba5e:	movzbl 0x0(%r13,%rdx,1),%r13d
   bba64:	and    $0x7,%ebp
   bba67:	bt     %ebp,%r13d
   bba6b:	mov    $0x0,%ebp
   bba70:	jae    bb970 <void inline_single_kernel<false, external_bloom::Page<4u, true>, unsigned long>(external_bloom::Page<4u, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
   bba76:	shlx   %r15d,%r11d,%ebp
   bba7b:	mov    %r14d,%r13d
   bba7e:	shr    $0x10,%r13d
   bba82:	andn   %r13d,%ebp,%ebp
   bba87:	mov    %ebp,%r13d
   bba8a:	shr    $0x3,%r13d
   bba8e:	movzbl (%rdx,%r13,1),%r13d
   bba93:	and    $0x7,%ebp
   bba96:	bt     %ebp,%r13d
   bba9a:	mov    $0x0,%ebp
   bba9f:	jae    bb970 <void inline_single_kernel<false, external_bloom::Page<4u, true>, unsigned long>(external_bloom::Page<4u, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
   bbaa5:	bzhi   %r15d,%r12d,%ebp
   bbaaa:	movzwl %bp,%r12d
   bbaae:	and    $0x7,%bpl
   bbab2:	shr    $0x3,%r12d
   bbab6:	shlx   %ebp,%ebx,%ebp
   bbabb:	movzbl (%rdx,%r12,1),%r12d
   bbac0:	movzwl %bp,%r13d
   bbac4:	mov    $0x0,%ebp
   bbac9:	test   %r12d,%r13d
   bbacc:	je     bb970 <void inline_single_kernel<false, external_bloom::Page<4u, true>, unsigned long>(external_bloom::Page<4u, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
   bbad2:	shr    $0x30,%r14
   bbad6:	bzhi   %r15d,%r14d,%r14d
   bbadb:	mov    %r14d,%ebp
   bbade:	and    $0x7,%ebp
   bbae1:	shr    $0x3,%r14d
   bbae5:	movzbl (%rdx,%r14,1),%edx
   bbaea:	shrx   %ebp,%edx,%ebp
   bbaef:	and    $0x1,%ebp
   bbaf2:	jmp    bb970 <void inline_single_kernel<false, external_bloom::Page<4u, true>, unsigned long>(external_bloom::Page<4u, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
   bbaf7:	pop    %rbx
   bbaf8:	pop    %r12
   bbafa:	pop    %r13
   bbafc:	pop    %r14
   bbafe:	pop    %r15
   bbb00:	pop    %rbp
   bbb01:	ret
   bbb02:	int3
   bbb03:	int3
   bbb04:	int3
   bbb05:	int3
   bbb06:	int3
   bbb07:	int3
   bbb08:	int3
   bbb09:	int3
   bbb0a:	int3
   bbb0b:	int3
   bbb0c:	int3
   bbb0d:	int3
   bbb0e:	int3
   bbb0f:	int3

