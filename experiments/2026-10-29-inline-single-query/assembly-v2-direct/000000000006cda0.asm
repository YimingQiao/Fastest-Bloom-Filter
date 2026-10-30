000000000006cda0 <void inline_single_kernel<false, external_bloom::Classical<4, false, false>, unsigned long>(external_bloom::Classical<4, false, false> const&, unsigned long, unsigned long const*, unsigned int*)>:
   6cda0:	test   %rsi,%rsi
   6cda3:	je     6ce52 <void inline_single_kernel<false, external_bloom::Classical<4, false, false>, unsigned long>(external_bloom::Classical<4, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0xb2>
   6cda9:	push   %r15
   6cdab:	push   %r14
   6cdad:	push   %r13
   6cdaf:	push   %r12
   6cdb1:	push   %rbx
   6cdb2:	mov    %rdx,%rax
   6cdb5:	xor    %r11d,%r11d
   6cdb8:	mov    $0x1,%ebx
   6cdbd:	jmp    6cdcc <void inline_single_kernel<false, external_bloom::Classical<4, false, false>, unsigned long>(external_bloom::Classical<4, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x2c>
   6cdbf:	nop
   6cdc0:	mov    %edx,(%rcx,%r11,4)
   6cdc4:	inc    %r11
   6cdc7:	cmp    %r11,%rsi
   6cdca:	je     6ce49 <void inline_single_kernel<false, external_bloom::Classical<4, false, false>, unsigned long>(external_bloom::Classical<4, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0xa9>
   6cdcc:	mov    (%rax,%r11,8),%r8
   6cdd0:	rorx   $0x20,%r8,%r15
   6cdd6:	mov    (%rdi),%r14
   6cdd9:	mov    0x10(%rdi),%r10
   6cddd:	mov    %r10,%rdx
   6cde0:	mulx   %r15,%rdx,%rdx
   6cde5:	mov    (%r14,%rdx,8),%rdx
   6cde9:	lea    (%r15,%r8,1),%r13
   6cded:	lea    0x0(%r13,%r8,1),%r9
   6cdf2:	add    %r9,%r8
   6cdf5:	bt     %r15,%rdx
   6cdf9:	mov    %r9,%rdx
   6cdfc:	mulx   %r10,%r12,%r12
   6ce01:	mov    %r8,%rdx
   6ce04:	mulx   %r10,%r15,%r15
   6ce09:	mov    $0x0,%edx
   6ce0e:	jae    6cdc0 <void inline_single_kernel<false, external_bloom::Classical<4, false, false>, unsigned long>(external_bloom::Classical<4, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x20>
   6ce10:	mov    %r10,%rdx
   6ce13:	mulx   %r13,%rdx,%rdx
   6ce18:	mov    (%r14,%rdx,8),%rdx
   6ce1c:	bt     %r13,%rdx
   6ce20:	mov    $0x0,%edx
   6ce25:	jae    6cdc0 <void inline_single_kernel<false, external_bloom::Classical<4, false, false>, unsigned long>(external_bloom::Classical<4, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x20>
   6ce27:	shlx   %r9,%rbx,%r9
   6ce2c:	mov    $0x0,%edx
   6ce31:	test   %r9,(%r14,%r12,8)
   6ce35:	je     6cdc0 <void inline_single_kernel<false, external_bloom::Classical<4, false, false>, unsigned long>(external_bloom::Classical<4, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x20>
   6ce37:	and    $0x3f,%r8d
   6ce3b:	shrx   %r8,(%r14,%r15,8),%rdx
   6ce41:	and    $0x1,%edx
   6ce44:	jmp    6cdc0 <void inline_single_kernel<false, external_bloom::Classical<4, false, false>, unsigned long>(external_bloom::Classical<4, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x20>
   6ce49:	pop    %rbx
   6ce4a:	pop    %r12
   6ce4c:	pop    %r13
   6ce4e:	pop    %r14
   6ce50:	pop    %r15
   6ce52:	ret
   6ce53:	int3
   6ce54:	int3
   6ce55:	int3
   6ce56:	int3
   6ce57:	int3
   6ce58:	int3
   6ce59:	int3
   6ce5a:	int3
   6ce5b:	int3
   6ce5c:	int3
   6ce5d:	int3
   6ce5e:	int3
   6ce5f:	int3

