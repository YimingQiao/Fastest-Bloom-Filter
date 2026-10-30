00000000000aead0 <void inline_single_kernel<false, external_bloom::Page<4u, false>, unsigned long>(external_bloom::Page<4u, false> const&, unsigned long, unsigned long const*, unsigned int*)>:
   aead0:	test   %rsi,%rsi
   aead3:	je     aeca1 <void inline_single_kernel<false, external_bloom::Page<4u, false>, unsigned long>(external_bloom::Page<4u, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x1d1>
   aead9:	push   %rbp
   aeada:	push   %r15
   aeadc:	push   %r14
   aeade:	push   %r13
   aeae0:	push   %r12
   aeae2:	push   %rbx
   aeae3:	mov    %rdx,%rax
   aeae6:	xor    %r8d,%r8d
   aeae9:	movabs $0xdeadbeefdeadbeef,%r9
   aeaf3:	movabs $0xe6adbeefdeadbeef,%r10
   aeafd:	mov    $0xffffffff,%r11d
   aeb03:	mov    $0x1,%ebx
   aeb08:	jmp    aeb20 <void inline_single_kernel<false, external_bloom::Page<4u, false>, unsigned long>(external_bloom::Page<4u, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
   aeb0a:	nopw   0x0(%rax,%rax,1)
   aeb10:	mov    %ebp,(%rcx,%r8,4)
   aeb14:	inc    %r8
   aeb17:	cmp    %r8,%rsi
   aeb1a:	je     aec97 <void inline_single_kernel<false, external_bloom::Page<4u, false>, unsigned long>(external_bloom::Page<4u, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x1c7>
   aeb20:	mov    (%rax,%r8,8),%rdx
   aeb24:	add    %r9,%rdx
   aeb27:	rorx   $0x31,%rdx,%r14
   aeb2d:	xor    %r10,%rdx
   aeb30:	add    %r14,%rdx
   aeb33:	rorx   $0xc,%rdx,%r15
   aeb39:	add    %r15,%rdx
   aeb3c:	rorx   $0x26,%rdx,%r12
   aeb42:	add    %r12,%rdx
   aeb45:	xor    %rdx,%r14
   aeb48:	rorx   $0xd,%rdx,%rdx
   aeb4e:	add    %rdx,%r14
   aeb51:	xor    %r14,%r15
   aeb54:	rorx   $0x24,%r14,%r14
   aeb5a:	add    %r14,%r15
   aeb5d:	xor    %r15,%r12
   aeb60:	rorx   $0x37,%r15,%r15
   aeb66:	add    %r15,%r12
   aeb69:	xor    %r12,%rdx
   aeb6c:	rorx   $0x11,%r12,%r12
   aeb72:	add    %r12,%rdx
   aeb75:	xor    %rdx,%r14
   aeb78:	rorx   $0xa,%rdx,%rdx
   aeb7e:	add    %rdx,%r14
   aeb81:	xor    %r14,%r15
   aeb84:	rorx   $0x20,%r14,%r14
   aeb8a:	add    %r15,%r14
   aeb8d:	xor    %r14,%r12
   aeb90:	rorx   $0x27,%r14,%r14
   aeb96:	add    %r12,%r14
   aeb99:	xor    %r14,%rdx
   aeb9c:	rorx   $0x1,%r14,%r14
   aeba2:	add    %r14,%rdx
   aeba5:	mov    %r14,%r12
   aeba8:	shr    $0x20,%r12
   aebac:	mov    %edx,%ebp
   aebae:	shr    $0x20,%rdx
   aebb2:	rorx   $0x18,%r14d,%r15d
   aebb8:	rorx   $0x1a,%r12d,%r13d
   aebbe:	xor    %r15d,%r13d
   aebc1:	rorx   $0x1c,%ebp,%ebp
   aebc7:	xor    %r13d,%ebp
   aebca:	rorx   $0x1e,%edx,%edx
   aebd0:	xor    %ebp,%edx
   aebd2:	mov    0x8(%rdi),%r15d
   aebd6:	imul   0x10(%rdi),%rdx
   aebdb:	mulx   %r15,%rdx,%rdx
   aebe0:	movzbl (%rdi),%r15d
   aebe4:	shlx   %r15,%rdx,%rdx
   aebe9:	add    0x20(%rdi),%rdx
   aebed:	add    $0x3,%r15b
   aebf1:	bzhi   %r15d,%r14d,%ebp
   aebf6:	movzwl %bp,%r13d
   aebfa:	shr    $0x3,%r13d
   aebfe:	movzbl 0x0(%r13,%rdx,1),%r13d
   aec04:	and    $0x7,%ebp
   aec07:	bt     %ebp,%r13d
   aec0b:	mov    $0x0,%ebp
   aec10:	jae    aeb10 <void inline_single_kernel<false, external_bloom::Page<4u, false>, unsigned long>(external_bloom::Page<4u, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
   aec16:	shlx   %r15d,%r11d,%ebp
   aec1b:	mov    %r14d,%r13d
   aec1e:	shr    $0x10,%r13d
   aec22:	andn   %r13d,%ebp,%ebp
   aec27:	mov    %ebp,%r13d
   aec2a:	shr    $0x3,%r13d
   aec2e:	movzbl (%rdx,%r13,1),%r13d
   aec33:	and    $0x7,%ebp
   aec36:	bt     %ebp,%r13d
   aec3a:	mov    $0x0,%ebp
   aec3f:	jae    aeb10 <void inline_single_kernel<false, external_bloom::Page<4u, false>, unsigned long>(external_bloom::Page<4u, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
   aec45:	bzhi   %r15d,%r12d,%ebp
   aec4a:	movzwl %bp,%r12d
   aec4e:	and    $0x7,%bpl
   aec52:	shr    $0x3,%r12d
   aec56:	shlx   %ebp,%ebx,%ebp
   aec5b:	movzbl (%rdx,%r12,1),%r12d
   aec60:	movzwl %bp,%r13d
   aec64:	mov    $0x0,%ebp
   aec69:	test   %r12d,%r13d
   aec6c:	je     aeb10 <void inline_single_kernel<false, external_bloom::Page<4u, false>, unsigned long>(external_bloom::Page<4u, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
   aec72:	shr    $0x30,%r14
   aec76:	bzhi   %r15d,%r14d,%r14d
   aec7b:	mov    %r14d,%ebp
   aec7e:	and    $0x7,%ebp
   aec81:	shr    $0x3,%r14d
   aec85:	movzbl (%rdx,%r14,1),%edx
   aec8a:	shrx   %ebp,%edx,%ebp
   aec8f:	and    $0x1,%ebp
   aec92:	jmp    aeb10 <void inline_single_kernel<false, external_bloom::Page<4u, false>, unsigned long>(external_bloom::Page<4u, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
   aec97:	pop    %rbx
   aec98:	pop    %r12
   aec9a:	pop    %r13
   aec9c:	pop    %r14
   aec9e:	pop    %r15
   aeca0:	pop    %rbp
   aeca1:	ret
   aeca2:	int3
   aeca3:	int3
   aeca4:	int3
   aeca5:	int3
   aeca6:	int3
   aeca7:	int3
   aeca8:	int3
   aeca9:	int3
   aecaa:	int3
   aecab:	int3
   aecac:	int3
   aecad:	int3
   aecae:	int3
   aecaf:	int3

