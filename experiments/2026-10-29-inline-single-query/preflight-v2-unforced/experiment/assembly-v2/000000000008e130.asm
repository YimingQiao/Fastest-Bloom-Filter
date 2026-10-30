000000000008e130 <void inline_single_kernel<false, external_bloom::Classical<6, true, false>, unsigned long>(external_bloom::Classical<6, true, false> const&, unsigned long, unsigned long const*, unsigned int*)>:
   8e130:	test   %rsi,%rsi
   8e133:	je     8e216 <void inline_single_kernel<false, external_bloom::Classical<6, true, false>, unsigned long>(external_bloom::Classical<6, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0xe6>
   8e139:	push   %rbp
   8e13a:	push   %r15
   8e13c:	push   %r14
   8e13e:	push   %r13
   8e140:	push   %r12
   8e142:	push   %rbx
   8e143:	mov    %rdx,%rax
   8e146:	xor    %ebx,%ebx
   8e148:	mov    $0x1,%r14d
   8e14e:	jmp    8e15f <void inline_single_kernel<false, external_bloom::Classical<6, true, false>, unsigned long>(external_bloom::Classical<6, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x2f>
   8e150:	mov    %edx,(%rcx,%rbx,4)
   8e153:	inc    %rbx
   8e156:	cmp    %rbx,%rsi
   8e159:	je     8e20c <void inline_single_kernel<false, external_bloom::Classical<6, true, false>, unsigned long>(external_bloom::Classical<6, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0xdc>
   8e15f:	mov    (%rax,%rbx,8),%r8
   8e163:	rorx   $0x20,%r8,%r9
   8e169:	mov    (%rdi),%r15
   8e16c:	mov    0x10(%rdi),%r10
   8e170:	mov    %r10,%rdx
   8e173:	mulx   %r9,%rdx,%rdx
   8e178:	shrx   %r9,(%r15,%rdx,8),%r11
   8e17e:	add    %r8,%r9
   8e181:	mov    %r10,%rdx
   8e184:	mulx   %r9,%rdx,%rdx
   8e189:	shrx   %r9,(%r15,%rdx,8),%r12
   8e18f:	add    %r8,%r9
   8e192:	mov    %r9,%rdx
   8e195:	mulx   %r10,%rdx,%rdx
   8e19a:	shrx   %r9,(%r15,%rdx,8),%rbp
   8e1a0:	and    %r11d,%r12d
   8e1a3:	and    %r12d,%ebp
   8e1a6:	add    %r8,%r9
   8e1a9:	lea    (%r9,%r8,1),%r11
   8e1ad:	add    %r11,%r8
   8e1b0:	mov    %r11,%rdx
   8e1b3:	mulx   %r10,%r13,%r13
   8e1b8:	mov    %r8,%rdx
   8e1bb:	mulx   %r10,%r12,%r12
   8e1c0:	mov    $0x0,%edx
   8e1c5:	test   $0x1,%bpl
   8e1c9:	je     8e150 <void inline_single_kernel<false, external_bloom::Classical<6, true, false>, unsigned long>(external_bloom::Classical<6, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x20>
   8e1cb:	mov    %r9,%rdx
   8e1ce:	mulx   %r10,%rdx,%rdx
   8e1d3:	mov    (%r15,%rdx,8),%rdx
   8e1d7:	bt     %r9,%rdx
   8e1db:	mov    $0x0,%edx
   8e1e0:	jae    8e150 <void inline_single_kernel<false, external_bloom::Classical<6, true, false>, unsigned long>(external_bloom::Classical<6, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x20>
   8e1e6:	shlx   %r11,%r14,%r9
   8e1eb:	mov    $0x0,%edx
   8e1f0:	test   %r9,(%r15,%r13,8)
   8e1f4:	je     8e150 <void inline_single_kernel<false, external_bloom::Classical<6, true, false>, unsigned long>(external_bloom::Classical<6, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x20>
   8e1fa:	and    $0x3f,%r8d
   8e1fe:	shrx   %r8,(%r15,%r12,8),%rdx
   8e204:	and    $0x1,%edx
   8e207:	jmp    8e150 <void inline_single_kernel<false, external_bloom::Classical<6, true, false>, unsigned long>(external_bloom::Classical<6, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x20>
   8e20c:	pop    %rbx
   8e20d:	pop    %r12
   8e20f:	pop    %r13
   8e211:	pop    %r14
   8e213:	pop    %r15
   8e215:	pop    %rbp
   8e216:	ret
   8e217:	int3
   8e218:	int3
   8e219:	int3
   8e21a:	int3
   8e21b:	int3
   8e21c:	int3
   8e21d:	int3
   8e21e:	int3
   8e21f:	int3

