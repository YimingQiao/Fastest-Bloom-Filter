00000000000aeb50 <void inline_single_kernel<false, external_bloom::Page<4u, false>, unsigned long>(external_bloom::Page<4u, false> const&, unsigned long, unsigned long const*, unsigned int*)>:
   aeb50:	test   %rsi,%rsi
   aeb53:	je     aed21 <void inline_single_kernel<false, external_bloom::Page<4u, false>, unsigned long>(external_bloom::Page<4u, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x1d1>
   aeb59:	push   %rbp
   aeb5a:	push   %r15
   aeb5c:	push   %r14
   aeb5e:	push   %r13
   aeb60:	push   %r12
   aeb62:	push   %rbx
   aeb63:	mov    %rdx,%rax
   aeb66:	xor    %r8d,%r8d
   aeb69:	movabs $0xdeadbeefdeadbeef,%r9
   aeb73:	movabs $0xe6adbeefdeadbeef,%r10
   aeb7d:	mov    $0xffffffff,%r11d
   aeb83:	mov    $0x1,%ebx
   aeb88:	jmp    aeba0 <void inline_single_kernel<false, external_bloom::Page<4u, false>, unsigned long>(external_bloom::Page<4u, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
   aeb8a:	nopw   0x0(%rax,%rax,1)
   aeb90:	mov    %ebp,(%rcx,%r8,4)
   aeb94:	inc    %r8
   aeb97:	cmp    %r8,%rsi
   aeb9a:	je     aed17 <void inline_single_kernel<false, external_bloom::Page<4u, false>, unsigned long>(external_bloom::Page<4u, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x1c7>
   aeba0:	mov    (%rax,%r8,8),%rdx
   aeba4:	add    %r9,%rdx
   aeba7:	rorx   $0x31,%rdx,%r14
   aebad:	xor    %r10,%rdx
   aebb0:	add    %r14,%rdx
   aebb3:	rorx   $0xc,%rdx,%r15
   aebb9:	add    %r15,%rdx
   aebbc:	rorx   $0x26,%rdx,%r12
   aebc2:	add    %r12,%rdx
   aebc5:	xor    %rdx,%r14
   aebc8:	rorx   $0xd,%rdx,%rdx
   aebce:	add    %rdx,%r14
   aebd1:	xor    %r14,%r15
   aebd4:	rorx   $0x24,%r14,%r14
   aebda:	add    %r14,%r15
   aebdd:	xor    %r15,%r12
   aebe0:	rorx   $0x37,%r15,%r15
   aebe6:	add    %r15,%r12
   aebe9:	xor    %r12,%rdx
   aebec:	rorx   $0x11,%r12,%r12
   aebf2:	add    %r12,%rdx
   aebf5:	xor    %rdx,%r14
   aebf8:	rorx   $0xa,%rdx,%rdx
   aebfe:	add    %rdx,%r14
   aec01:	xor    %r14,%r15
   aec04:	rorx   $0x20,%r14,%r14
   aec0a:	add    %r15,%r14
   aec0d:	xor    %r14,%r12
   aec10:	rorx   $0x27,%r14,%r14
   aec16:	add    %r12,%r14
   aec19:	xor    %r14,%rdx
   aec1c:	rorx   $0x1,%r14,%r14
   aec22:	add    %r14,%rdx
   aec25:	mov    %r14,%r12
   aec28:	shr    $0x20,%r12
   aec2c:	mov    %edx,%ebp
   aec2e:	shr    $0x20,%rdx
   aec32:	rorx   $0x18,%r14d,%r15d
   aec38:	rorx   $0x1a,%r12d,%r13d
   aec3e:	xor    %r15d,%r13d
   aec41:	rorx   $0x1c,%ebp,%ebp
   aec47:	xor    %r13d,%ebp
   aec4a:	rorx   $0x1e,%edx,%edx
   aec50:	xor    %ebp,%edx
   aec52:	mov    0x8(%rdi),%r15d
   aec56:	imul   0x10(%rdi),%rdx
   aec5b:	mulx   %r15,%rdx,%rdx
   aec60:	movzbl (%rdi),%r15d
   aec64:	shlx   %r15,%rdx,%rdx
   aec69:	add    0x20(%rdi),%rdx
   aec6d:	add    $0x3,%r15b
   aec71:	bzhi   %r15d,%r14d,%ebp
   aec76:	movzwl %bp,%r13d
   aec7a:	shr    $0x3,%r13d
   aec7e:	movzbl 0x0(%r13,%rdx,1),%r13d
   aec84:	and    $0x7,%ebp
   aec87:	bt     %ebp,%r13d
   aec8b:	mov    $0x0,%ebp
   aec90:	jae    aeb90 <void inline_single_kernel<false, external_bloom::Page<4u, false>, unsigned long>(external_bloom::Page<4u, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
   aec96:	shlx   %r15d,%r11d,%ebp
   aec9b:	mov    %r14d,%r13d
   aec9e:	shr    $0x10,%r13d
   aeca2:	andn   %r13d,%ebp,%ebp
   aeca7:	mov    %ebp,%r13d
   aecaa:	shr    $0x3,%r13d
   aecae:	movzbl (%rdx,%r13,1),%r13d
   aecb3:	and    $0x7,%ebp
   aecb6:	bt     %ebp,%r13d
   aecba:	mov    $0x0,%ebp
   aecbf:	jae    aeb90 <void inline_single_kernel<false, external_bloom::Page<4u, false>, unsigned long>(external_bloom::Page<4u, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
   aecc5:	bzhi   %r15d,%r12d,%ebp
   aecca:	movzwl %bp,%r12d
   aecce:	and    $0x7,%bpl
   aecd2:	shr    $0x3,%r12d
   aecd6:	shlx   %ebp,%ebx,%ebp
   aecdb:	movzbl (%rdx,%r12,1),%r12d
   aece0:	movzwl %bp,%r13d
   aece4:	mov    $0x0,%ebp
   aece9:	test   %r12d,%r13d
   aecec:	je     aeb90 <void inline_single_kernel<false, external_bloom::Page<4u, false>, unsigned long>(external_bloom::Page<4u, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
   aecf2:	shr    $0x30,%r14
   aecf6:	bzhi   %r15d,%r14d,%r14d
   aecfb:	mov    %r14d,%ebp
   aecfe:	and    $0x7,%ebp
   aed01:	shr    $0x3,%r14d
   aed05:	movzbl (%rdx,%r14,1),%edx
   aed0a:	shrx   %ebp,%edx,%ebp
   aed0f:	and    $0x1,%ebp
   aed12:	jmp    aeb90 <void inline_single_kernel<false, external_bloom::Page<4u, false>, unsigned long>(external_bloom::Page<4u, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
   aed17:	pop    %rbx
   aed18:	pop    %r12
   aed1a:	pop    %r13
   aed1c:	pop    %r14
   aed1e:	pop    %r15
   aed20:	pop    %rbp
   aed21:	ret
   aed22:	int3
   aed23:	int3
   aed24:	int3
   aed25:	int3
   aed26:	int3
   aed27:	int3
   aed28:	int3
   aed29:	int3
   aed2a:	int3
   aed2b:	int3
   aed2c:	int3
   aed2d:	int3
   aed2e:	int3
   aed2f:	int3

