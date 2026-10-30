00000000000bbe70 <void inline_single_kernel<true, external_bloom::Page<4u, true>, unsigned long>(external_bloom::Page<4u, true> const&, unsigned long, unsigned long const*, unsigned int*)>:
   bbe70:	test   %rsi,%rsi
   bbe73:	je     bc041 <void inline_single_kernel<true, external_bloom::Page<4u, true>, unsigned long>(external_bloom::Page<4u, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x1d1>
   bbe79:	push   %rbp
   bbe7a:	push   %r15
   bbe7c:	push   %r14
   bbe7e:	push   %r13
   bbe80:	push   %r12
   bbe82:	push   %rbx
   bbe83:	mov    %rdx,%rax
   bbe86:	xor    %r8d,%r8d
   bbe89:	movabs $0xdeadbeefdeadbeef,%r9
   bbe93:	movabs $0xe6adbeefdeadbeef,%r10
   bbe9d:	mov    $0xffffffff,%r11d
   bbea3:	mov    $0x1,%ebx
   bbea8:	jmp    bbec0 <void inline_single_kernel<true, external_bloom::Page<4u, true>, unsigned long>(external_bloom::Page<4u, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
   bbeaa:	nopw   0x0(%rax,%rax,1)
   bbeb0:	mov    %ebp,(%rcx,%r8,4)
   bbeb4:	inc    %r8
   bbeb7:	cmp    %r8,%rsi
   bbeba:	je     bc037 <void inline_single_kernel<true, external_bloom::Page<4u, true>, unsigned long>(external_bloom::Page<4u, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x1c7>
   bbec0:	mov    (%rax,%r8,8),%rdx
   bbec4:	add    %r9,%rdx
   bbec7:	rorx   $0x31,%rdx,%r14
   bbecd:	xor    %r10,%rdx
   bbed0:	add    %r14,%rdx
   bbed3:	rorx   $0xc,%rdx,%r15
   bbed9:	add    %r15,%rdx
   bbedc:	rorx   $0x26,%rdx,%r12
   bbee2:	add    %r12,%rdx
   bbee5:	xor    %rdx,%r14
   bbee8:	rorx   $0xd,%rdx,%rdx
   bbeee:	add    %rdx,%r14
   bbef1:	xor    %r14,%r15
   bbef4:	rorx   $0x24,%r14,%r14
   bbefa:	add    %r14,%r15
   bbefd:	xor    %r15,%r12
   bbf00:	rorx   $0x37,%r15,%r15
   bbf06:	add    %r15,%r12
   bbf09:	xor    %r12,%rdx
   bbf0c:	rorx   $0x11,%r12,%r12
   bbf12:	add    %r12,%rdx
   bbf15:	xor    %rdx,%r14
   bbf18:	rorx   $0xa,%rdx,%rdx
   bbf1e:	add    %rdx,%r14
   bbf21:	xor    %r14,%r15
   bbf24:	rorx   $0x20,%r14,%r14
   bbf2a:	add    %r15,%r14
   bbf2d:	xor    %r14,%r12
   bbf30:	rorx   $0x27,%r14,%r14
   bbf36:	add    %r12,%r14
   bbf39:	xor    %r14,%rdx
   bbf3c:	rorx   $0x1,%r14,%r14
   bbf42:	add    %r14,%rdx
   bbf45:	mov    %r14,%r12
   bbf48:	shr    $0x20,%r12
   bbf4c:	mov    %edx,%ebp
   bbf4e:	shr    $0x20,%rdx
   bbf52:	rorx   $0x18,%r14d,%r15d
   bbf58:	rorx   $0x1a,%r12d,%r13d
   bbf5e:	xor    %r15d,%r13d
   bbf61:	rorx   $0x1c,%ebp,%ebp
   bbf67:	xor    %r13d,%ebp
   bbf6a:	rorx   $0x1e,%edx,%edx
   bbf70:	xor    %ebp,%edx
   bbf72:	mov    0x8(%rdi),%r15d
   bbf76:	imul   0x10(%rdi),%rdx
   bbf7b:	mulx   %r15,%rdx,%rdx
   bbf80:	movzbl (%rdi),%r15d
   bbf84:	shlx   %r15,%rdx,%rdx
   bbf89:	add    0x20(%rdi),%rdx
   bbf8d:	add    $0x3,%r15b
   bbf91:	bzhi   %r15d,%r14d,%ebp
   bbf96:	movzwl %bp,%r13d
   bbf9a:	shr    $0x3,%r13d
   bbf9e:	movzbl 0x0(%r13,%rdx,1),%r13d
   bbfa4:	and    $0x7,%ebp
   bbfa7:	bt     %ebp,%r13d
   bbfab:	mov    $0x0,%ebp
   bbfb0:	jae    bbeb0 <void inline_single_kernel<true, external_bloom::Page<4u, true>, unsigned long>(external_bloom::Page<4u, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
   bbfb6:	shlx   %r15d,%r11d,%ebp
   bbfbb:	mov    %r14d,%r13d
   bbfbe:	shr    $0x10,%r13d
   bbfc2:	andn   %r13d,%ebp,%ebp
   bbfc7:	mov    %ebp,%r13d
   bbfca:	shr    $0x3,%r13d
   bbfce:	movzbl (%rdx,%r13,1),%r13d
   bbfd3:	and    $0x7,%ebp
   bbfd6:	bt     %ebp,%r13d
   bbfda:	mov    $0x0,%ebp
   bbfdf:	jae    bbeb0 <void inline_single_kernel<true, external_bloom::Page<4u, true>, unsigned long>(external_bloom::Page<4u, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
   bbfe5:	bzhi   %r15d,%r12d,%ebp
   bbfea:	movzwl %bp,%r12d
   bbfee:	and    $0x7,%bpl
   bbff2:	shr    $0x3,%r12d
   bbff6:	shlx   %ebp,%ebx,%ebp
   bbffb:	movzbl (%rdx,%r12,1),%r12d
   bc000:	movzwl %bp,%r13d
   bc004:	mov    $0x0,%ebp
   bc009:	test   %r12d,%r13d
   bc00c:	je     bbeb0 <void inline_single_kernel<true, external_bloom::Page<4u, true>, unsigned long>(external_bloom::Page<4u, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
   bc012:	shr    $0x30,%r14
   bc016:	bzhi   %r15d,%r14d,%r14d
   bc01b:	mov    %r14d,%ebp
   bc01e:	and    $0x7,%ebp
   bc021:	shr    $0x3,%r14d
   bc025:	movzbl (%rdx,%r14,1),%edx
   bc02a:	shrx   %ebp,%edx,%ebp
   bc02f:	and    $0x1,%ebp
   bc032:	jmp    bbeb0 <void inline_single_kernel<true, external_bloom::Page<4u, true>, unsigned long>(external_bloom::Page<4u, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
   bc037:	pop    %rbx
   bc038:	pop    %r12
   bc03a:	pop    %r13
   bc03c:	pop    %r14
   bc03e:	pop    %r15
   bc040:	pop    %rbp
   bc041:	ret
   bc042:	int3
   bc043:	int3
   bc044:	int3
   bc045:	int3
   bc046:	int3
   bc047:	int3
   bc048:	int3
   bc049:	int3
   bc04a:	int3
   bc04b:	int3
   bc04c:	int3
   bc04d:	int3
   bc04e:	int3
   bc04f:	int3

