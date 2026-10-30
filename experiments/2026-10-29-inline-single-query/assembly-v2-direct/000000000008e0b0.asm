000000000008e0b0 <void inline_single_kernel<false, external_bloom::Classical<6, true, false>, unsigned long>(external_bloom::Classical<6, true, false> const&, unsigned long, unsigned long const*, unsigned int*)>:
   8e0b0:	test   %rsi,%rsi
   8e0b3:	je     8e196 <void inline_single_kernel<false, external_bloom::Classical<6, true, false>, unsigned long>(external_bloom::Classical<6, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0xe6>
   8e0b9:	push   %rbp
   8e0ba:	push   %r15
   8e0bc:	push   %r14
   8e0be:	push   %r13
   8e0c0:	push   %r12
   8e0c2:	push   %rbx
   8e0c3:	mov    %rdx,%rax
   8e0c6:	xor    %ebx,%ebx
   8e0c8:	mov    $0x1,%r14d
   8e0ce:	jmp    8e0df <void inline_single_kernel<false, external_bloom::Classical<6, true, false>, unsigned long>(external_bloom::Classical<6, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x2f>
   8e0d0:	mov    %edx,(%rcx,%rbx,4)
   8e0d3:	inc    %rbx
   8e0d6:	cmp    %rbx,%rsi
   8e0d9:	je     8e18c <void inline_single_kernel<false, external_bloom::Classical<6, true, false>, unsigned long>(external_bloom::Classical<6, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0xdc>
   8e0df:	mov    (%rax,%rbx,8),%r8
   8e0e3:	rorx   $0x20,%r8,%r9
   8e0e9:	mov    (%rdi),%r15
   8e0ec:	mov    0x10(%rdi),%r10
   8e0f0:	mov    %r10,%rdx
   8e0f3:	mulx   %r9,%rdx,%rdx
   8e0f8:	shrx   %r9,(%r15,%rdx,8),%r11
   8e0fe:	add    %r8,%r9
   8e101:	mov    %r10,%rdx
   8e104:	mulx   %r9,%rdx,%rdx
   8e109:	shrx   %r9,(%r15,%rdx,8),%r12
   8e10f:	add    %r8,%r9
   8e112:	mov    %r9,%rdx
   8e115:	mulx   %r10,%rdx,%rdx
   8e11a:	shrx   %r9,(%r15,%rdx,8),%rbp
   8e120:	and    %r11d,%r12d
   8e123:	and    %r12d,%ebp
   8e126:	add    %r8,%r9
   8e129:	lea    (%r9,%r8,1),%r11
   8e12d:	add    %r11,%r8
   8e130:	mov    %r11,%rdx
   8e133:	mulx   %r10,%r13,%r13
   8e138:	mov    %r8,%rdx
   8e13b:	mulx   %r10,%r12,%r12
   8e140:	mov    $0x0,%edx
   8e145:	test   $0x1,%bpl
   8e149:	je     8e0d0 <void inline_single_kernel<false, external_bloom::Classical<6, true, false>, unsigned long>(external_bloom::Classical<6, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x20>
   8e14b:	mov    %r9,%rdx
   8e14e:	mulx   %r10,%rdx,%rdx
   8e153:	mov    (%r15,%rdx,8),%rdx
   8e157:	bt     %r9,%rdx
   8e15b:	mov    $0x0,%edx
   8e160:	jae    8e0d0 <void inline_single_kernel<false, external_bloom::Classical<6, true, false>, unsigned long>(external_bloom::Classical<6, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x20>
   8e166:	shlx   %r11,%r14,%r9
   8e16b:	mov    $0x0,%edx
   8e170:	test   %r9,(%r15,%r13,8)
   8e174:	je     8e0d0 <void inline_single_kernel<false, external_bloom::Classical<6, true, false>, unsigned long>(external_bloom::Classical<6, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x20>
   8e17a:	and    $0x3f,%r8d
   8e17e:	shrx   %r8,(%r15,%r12,8),%rdx
   8e184:	and    $0x1,%edx
   8e187:	jmp    8e0d0 <void inline_single_kernel<false, external_bloom::Classical<6, true, false>, unsigned long>(external_bloom::Classical<6, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x20>
   8e18c:	pop    %rbx
   8e18d:	pop    %r12
   8e18f:	pop    %r13
   8e191:	pop    %r14
   8e193:	pop    %r15
   8e195:	pop    %rbp
   8e196:	ret
   8e197:	int3
   8e198:	int3
   8e199:	int3
   8e19a:	int3
   8e19b:	int3
   8e19c:	int3
   8e19d:	int3
   8e19e:	int3
   8e19f:	int3

