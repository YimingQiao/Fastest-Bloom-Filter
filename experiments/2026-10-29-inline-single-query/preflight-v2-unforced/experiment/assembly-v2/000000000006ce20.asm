000000000006ce20 <void inline_single_kernel<false, external_bloom::Classical<4, false, false>, unsigned long>(external_bloom::Classical<4, false, false> const&, unsigned long, unsigned long const*, unsigned int*)>:
   6ce20:	test   %rsi,%rsi
   6ce23:	je     6ced2 <void inline_single_kernel<false, external_bloom::Classical<4, false, false>, unsigned long>(external_bloom::Classical<4, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0xb2>
   6ce29:	push   %r15
   6ce2b:	push   %r14
   6ce2d:	push   %r13
   6ce2f:	push   %r12
   6ce31:	push   %rbx
   6ce32:	mov    %rdx,%rax
   6ce35:	xor    %r11d,%r11d
   6ce38:	mov    $0x1,%ebx
   6ce3d:	jmp    6ce4c <void inline_single_kernel<false, external_bloom::Classical<4, false, false>, unsigned long>(external_bloom::Classical<4, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x2c>
   6ce3f:	nop
   6ce40:	mov    %edx,(%rcx,%r11,4)
   6ce44:	inc    %r11
   6ce47:	cmp    %r11,%rsi
   6ce4a:	je     6cec9 <void inline_single_kernel<false, external_bloom::Classical<4, false, false>, unsigned long>(external_bloom::Classical<4, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0xa9>
   6ce4c:	mov    (%rax,%r11,8),%r8
   6ce50:	rorx   $0x20,%r8,%r15
   6ce56:	mov    (%rdi),%r14
   6ce59:	mov    0x10(%rdi),%r10
   6ce5d:	mov    %r10,%rdx
   6ce60:	mulx   %r15,%rdx,%rdx
   6ce65:	mov    (%r14,%rdx,8),%rdx
   6ce69:	lea    (%r15,%r8,1),%r13
   6ce6d:	lea    0x0(%r13,%r8,1),%r9
   6ce72:	add    %r9,%r8
   6ce75:	bt     %r15,%rdx
   6ce79:	mov    %r9,%rdx
   6ce7c:	mulx   %r10,%r12,%r12
   6ce81:	mov    %r8,%rdx
   6ce84:	mulx   %r10,%r15,%r15
   6ce89:	mov    $0x0,%edx
   6ce8e:	jae    6ce40 <void inline_single_kernel<false, external_bloom::Classical<4, false, false>, unsigned long>(external_bloom::Classical<4, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x20>
   6ce90:	mov    %r10,%rdx
   6ce93:	mulx   %r13,%rdx,%rdx
   6ce98:	mov    (%r14,%rdx,8),%rdx
   6ce9c:	bt     %r13,%rdx
   6cea0:	mov    $0x0,%edx
   6cea5:	jae    6ce40 <void inline_single_kernel<false, external_bloom::Classical<4, false, false>, unsigned long>(external_bloom::Classical<4, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x20>
   6cea7:	shlx   %r9,%rbx,%r9
   6ceac:	mov    $0x0,%edx
   6ceb1:	test   %r9,(%r14,%r12,8)
   6ceb5:	je     6ce40 <void inline_single_kernel<false, external_bloom::Classical<4, false, false>, unsigned long>(external_bloom::Classical<4, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x20>
   6ceb7:	and    $0x3f,%r8d
   6cebb:	shrx   %r8,(%r14,%r15,8),%rdx
   6cec1:	and    $0x1,%edx
   6cec4:	jmp    6ce40 <void inline_single_kernel<false, external_bloom::Classical<4, false, false>, unsigned long>(external_bloom::Classical<4, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x20>
   6cec9:	pop    %rbx
   6ceca:	pop    %r12
   6cecc:	pop    %r13
   6cece:	pop    %r14
   6ced0:	pop    %r15
   6ced2:	ret
   6ced3:	int3
   6ced4:	int3
   6ced5:	int3
   6ced6:	int3
   6ced7:	int3
   6ced8:	int3
   6ced9:	int3
   6ceda:	int3
   6cedb:	int3
   6cedc:	int3
   6cedd:	int3
   6cede:	int3
   6cedf:	int3

