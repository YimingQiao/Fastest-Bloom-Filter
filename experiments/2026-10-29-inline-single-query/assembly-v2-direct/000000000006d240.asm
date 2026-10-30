000000000006d240 <void inline_single_kernel<true, external_bloom::Classical<4, false, false>, unsigned long>(external_bloom::Classical<4, false, false> const&, unsigned long, unsigned long const*, unsigned int*)>:
   6d240:	test   %rsi,%rsi
   6d243:	je     6d334 <void inline_single_kernel<true, external_bloom::Classical<4, false, false>, unsigned long>(external_bloom::Classical<4, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0xf4>
   6d249:	push   %rbp
   6d24a:	push   %r15
   6d24c:	push   %r14
   6d24e:	push   %r13
   6d250:	push   %r12
   6d252:	push   %rbx
   6d253:	mov    %rdx,%rax
   6d256:	movabs $0xd6e8feb86659fd93,%r11
   6d260:	xor    %ebx,%ebx
   6d262:	mov    $0x1,%r14d
   6d268:	jmp    6d27f <void inline_single_kernel<true, external_bloom::Classical<4, false, false>, unsigned long>(external_bloom::Classical<4, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x3f>
   6d26a:	nopw   0x0(%rax,%rax,1)
   6d270:	mov    %edx,(%rcx,%rbx,4)
   6d273:	inc    %rbx
   6d276:	cmp    %rbx,%rsi
   6d279:	je     6d32a <void inline_single_kernel<true, external_bloom::Classical<4, false, false>, unsigned long>(external_bloom::Classical<4, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0xea>
   6d27f:	mov    (%rax,%rbx,8),%rdx
   6d283:	mov    %rdx,%r8
   6d286:	shr    $0x20,%r8
   6d28a:	xor    %rdx,%r8
   6d28d:	imul   %r11,%r8
   6d291:	mov    %r8,%rdx
   6d294:	shr    $0x20,%rdx
   6d298:	xor    %r8,%rdx
   6d29b:	imul   %r11,%rdx
   6d29f:	mov    %rdx,%r8
   6d2a2:	shr    $0x20,%r8
   6d2a6:	xor    %rdx,%r8
   6d2a9:	rorx   $0x20,%r8,%r12
   6d2af:	mov    (%rdi),%r15
   6d2b2:	mov    0x10(%rdi),%r10
   6d2b6:	mov    %r10,%rdx
   6d2b9:	mulx   %r12,%rdx,%rdx
   6d2be:	mov    (%r15,%rdx,8),%rdx
   6d2c2:	lea    (%r12,%r8,1),%rbp
   6d2c6:	lea    0x0(%rbp,%r8,1),%r9
   6d2cb:	add    %r9,%r8
   6d2ce:	bt     %r12,%rdx
   6d2d2:	mov    %r9,%rdx
   6d2d5:	mulx   %r10,%r13,%r13
   6d2da:	mov    %r8,%rdx
   6d2dd:	mulx   %r10,%r12,%r12
   6d2e2:	mov    $0x0,%edx
   6d2e7:	jae    6d270 <void inline_single_kernel<true, external_bloom::Classical<4, false, false>, unsigned long>(external_bloom::Classical<4, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   6d2e9:	mov    %r10,%rdx
   6d2ec:	mulx   %rbp,%rdx,%rdx
   6d2f1:	mov    (%r15,%rdx,8),%rdx
   6d2f5:	bt     %rbp,%rdx
   6d2f9:	mov    $0x0,%edx
   6d2fe:	jae    6d270 <void inline_single_kernel<true, external_bloom::Classical<4, false, false>, unsigned long>(external_bloom::Classical<4, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   6d304:	shlx   %r9,%r14,%r9
   6d309:	mov    $0x0,%edx
   6d30e:	test   %r9,(%r15,%r13,8)
   6d312:	je     6d270 <void inline_single_kernel<true, external_bloom::Classical<4, false, false>, unsigned long>(external_bloom::Classical<4, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   6d318:	and    $0x3f,%r8d
   6d31c:	shrx   %r8,(%r15,%r12,8),%rdx
   6d322:	and    $0x1,%edx
   6d325:	jmp    6d270 <void inline_single_kernel<true, external_bloom::Classical<4, false, false>, unsigned long>(external_bloom::Classical<4, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   6d32a:	pop    %rbx
   6d32b:	pop    %r12
   6d32d:	pop    %r13
   6d32f:	pop    %r14
   6d331:	pop    %r15
   6d333:	pop    %rbp
   6d334:	ret
   6d335:	int3
   6d336:	int3
   6d337:	int3
   6d338:	int3
   6d339:	int3
   6d33a:	int3
   6d33b:	int3
   6d33c:	int3
   6d33d:	int3
   6d33e:	int3
   6d33f:	int3

