00000000000bbef0 <void inline_single_kernel<true, external_bloom::Page<4u, true>, unsigned long>(external_bloom::Page<4u, true> const&, unsigned long, unsigned long const*, unsigned int*)>:
   bbef0:	test   %rsi,%rsi
   bbef3:	je     bc0c1 <void inline_single_kernel<true, external_bloom::Page<4u, true>, unsigned long>(external_bloom::Page<4u, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x1d1>
   bbef9:	push   %rbp
   bbefa:	push   %r15
   bbefc:	push   %r14
   bbefe:	push   %r13
   bbf00:	push   %r12
   bbf02:	push   %rbx
   bbf03:	mov    %rdx,%rax
   bbf06:	xor    %r8d,%r8d
   bbf09:	movabs $0xdeadbeefdeadbeef,%r9
   bbf13:	movabs $0xe6adbeefdeadbeef,%r10
   bbf1d:	mov    $0xffffffff,%r11d
   bbf23:	mov    $0x1,%ebx
   bbf28:	jmp    bbf40 <void inline_single_kernel<true, external_bloom::Page<4u, true>, unsigned long>(external_bloom::Page<4u, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
   bbf2a:	nopw   0x0(%rax,%rax,1)
   bbf30:	mov    %ebp,(%rcx,%r8,4)
   bbf34:	inc    %r8
   bbf37:	cmp    %r8,%rsi
   bbf3a:	je     bc0b7 <void inline_single_kernel<true, external_bloom::Page<4u, true>, unsigned long>(external_bloom::Page<4u, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x1c7>
   bbf40:	mov    (%rax,%r8,8),%rdx
   bbf44:	add    %r9,%rdx
   bbf47:	rorx   $0x31,%rdx,%r14
   bbf4d:	xor    %r10,%rdx
   bbf50:	add    %r14,%rdx
   bbf53:	rorx   $0xc,%rdx,%r15
   bbf59:	add    %r15,%rdx
   bbf5c:	rorx   $0x26,%rdx,%r12
   bbf62:	add    %r12,%rdx
   bbf65:	xor    %rdx,%r14
   bbf68:	rorx   $0xd,%rdx,%rdx
   bbf6e:	add    %rdx,%r14
   bbf71:	xor    %r14,%r15
   bbf74:	rorx   $0x24,%r14,%r14
   bbf7a:	add    %r14,%r15
   bbf7d:	xor    %r15,%r12
   bbf80:	rorx   $0x37,%r15,%r15
   bbf86:	add    %r15,%r12
   bbf89:	xor    %r12,%rdx
   bbf8c:	rorx   $0x11,%r12,%r12
   bbf92:	add    %r12,%rdx
   bbf95:	xor    %rdx,%r14
   bbf98:	rorx   $0xa,%rdx,%rdx
   bbf9e:	add    %rdx,%r14
   bbfa1:	xor    %r14,%r15
   bbfa4:	rorx   $0x20,%r14,%r14
   bbfaa:	add    %r15,%r14
   bbfad:	xor    %r14,%r12
   bbfb0:	rorx   $0x27,%r14,%r14
   bbfb6:	add    %r12,%r14
   bbfb9:	xor    %r14,%rdx
   bbfbc:	rorx   $0x1,%r14,%r14
   bbfc2:	add    %r14,%rdx
   bbfc5:	mov    %r14,%r12
   bbfc8:	shr    $0x20,%r12
   bbfcc:	mov    %edx,%ebp
   bbfce:	shr    $0x20,%rdx
   bbfd2:	rorx   $0x18,%r14d,%r15d
   bbfd8:	rorx   $0x1a,%r12d,%r13d
   bbfde:	xor    %r15d,%r13d
   bbfe1:	rorx   $0x1c,%ebp,%ebp
   bbfe7:	xor    %r13d,%ebp
   bbfea:	rorx   $0x1e,%edx,%edx
   bbff0:	xor    %ebp,%edx
   bbff2:	mov    0x8(%rdi),%r15d
   bbff6:	imul   0x10(%rdi),%rdx
   bbffb:	mulx   %r15,%rdx,%rdx
   bc000:	movzbl (%rdi),%r15d
   bc004:	shlx   %r15,%rdx,%rdx
   bc009:	add    0x20(%rdi),%rdx
   bc00d:	add    $0x3,%r15b
   bc011:	bzhi   %r15d,%r14d,%ebp
   bc016:	movzwl %bp,%r13d
   bc01a:	shr    $0x3,%r13d
   bc01e:	movzbl 0x0(%r13,%rdx,1),%r13d
   bc024:	and    $0x7,%ebp
   bc027:	bt     %ebp,%r13d
   bc02b:	mov    $0x0,%ebp
   bc030:	jae    bbf30 <void inline_single_kernel<true, external_bloom::Page<4u, true>, unsigned long>(external_bloom::Page<4u, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
   bc036:	shlx   %r15d,%r11d,%ebp
   bc03b:	mov    %r14d,%r13d
   bc03e:	shr    $0x10,%r13d
   bc042:	andn   %r13d,%ebp,%ebp
   bc047:	mov    %ebp,%r13d
   bc04a:	shr    $0x3,%r13d
   bc04e:	movzbl (%rdx,%r13,1),%r13d
   bc053:	and    $0x7,%ebp
   bc056:	bt     %ebp,%r13d
   bc05a:	mov    $0x0,%ebp
   bc05f:	jae    bbf30 <void inline_single_kernel<true, external_bloom::Page<4u, true>, unsigned long>(external_bloom::Page<4u, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
   bc065:	bzhi   %r15d,%r12d,%ebp
   bc06a:	movzwl %bp,%r12d
   bc06e:	and    $0x7,%bpl
   bc072:	shr    $0x3,%r12d
   bc076:	shlx   %ebp,%ebx,%ebp
   bc07b:	movzbl (%rdx,%r12,1),%r12d
   bc080:	movzwl %bp,%r13d
   bc084:	mov    $0x0,%ebp
   bc089:	test   %r12d,%r13d
   bc08c:	je     bbf30 <void inline_single_kernel<true, external_bloom::Page<4u, true>, unsigned long>(external_bloom::Page<4u, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
   bc092:	shr    $0x30,%r14
   bc096:	bzhi   %r15d,%r14d,%r14d
   bc09b:	mov    %r14d,%ebp
   bc09e:	and    $0x7,%ebp
   bc0a1:	shr    $0x3,%r14d
   bc0a5:	movzbl (%rdx,%r14,1),%edx
   bc0aa:	shrx   %ebp,%edx,%ebp
   bc0af:	and    $0x1,%ebp
   bc0b2:	jmp    bbf30 <void inline_single_kernel<true, external_bloom::Page<4u, true>, unsigned long>(external_bloom::Page<4u, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
   bc0b7:	pop    %rbx
   bc0b8:	pop    %r12
   bc0ba:	pop    %r13
   bc0bc:	pop    %r14
   bc0be:	pop    %r15
   bc0c0:	pop    %rbp
   bc0c1:	ret
   bc0c2:	int3
   bc0c3:	int3
   bc0c4:	int3
   bc0c5:	int3
   bc0c6:	int3
   bc0c7:	int3
   bc0c8:	int3
   bc0c9:	int3
   bc0ca:	int3
   bc0cb:	int3
   bc0cc:	int3
   bc0cd:	int3
   bc0ce:	int3
   bc0cf:	int3

