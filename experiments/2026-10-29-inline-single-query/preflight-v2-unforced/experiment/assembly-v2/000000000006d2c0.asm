000000000006d2c0 <void inline_single_kernel<true, external_bloom::Classical<4, false, false>, unsigned long>(external_bloom::Classical<4, false, false> const&, unsigned long, unsigned long const*, unsigned int*)>:
   6d2c0:	test   %rsi,%rsi
   6d2c3:	je     6d3b4 <void inline_single_kernel<true, external_bloom::Classical<4, false, false>, unsigned long>(external_bloom::Classical<4, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0xf4>
   6d2c9:	push   %rbp
   6d2ca:	push   %r15
   6d2cc:	push   %r14
   6d2ce:	push   %r13
   6d2d0:	push   %r12
   6d2d2:	push   %rbx
   6d2d3:	mov    %rdx,%rax
   6d2d6:	movabs $0xd6e8feb86659fd93,%r11
   6d2e0:	xor    %ebx,%ebx
   6d2e2:	mov    $0x1,%r14d
   6d2e8:	jmp    6d2ff <void inline_single_kernel<true, external_bloom::Classical<4, false, false>, unsigned long>(external_bloom::Classical<4, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x3f>
   6d2ea:	nopw   0x0(%rax,%rax,1)
   6d2f0:	mov    %edx,(%rcx,%rbx,4)
   6d2f3:	inc    %rbx
   6d2f6:	cmp    %rbx,%rsi
   6d2f9:	je     6d3aa <void inline_single_kernel<true, external_bloom::Classical<4, false, false>, unsigned long>(external_bloom::Classical<4, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0xea>
   6d2ff:	mov    (%rax,%rbx,8),%rdx
   6d303:	mov    %rdx,%r8
   6d306:	shr    $0x20,%r8
   6d30a:	xor    %rdx,%r8
   6d30d:	imul   %r11,%r8
   6d311:	mov    %r8,%rdx
   6d314:	shr    $0x20,%rdx
   6d318:	xor    %r8,%rdx
   6d31b:	imul   %r11,%rdx
   6d31f:	mov    %rdx,%r8
   6d322:	shr    $0x20,%r8
   6d326:	xor    %rdx,%r8
   6d329:	rorx   $0x20,%r8,%r12
   6d32f:	mov    (%rdi),%r15
   6d332:	mov    0x10(%rdi),%r10
   6d336:	mov    %r10,%rdx
   6d339:	mulx   %r12,%rdx,%rdx
   6d33e:	mov    (%r15,%rdx,8),%rdx
   6d342:	lea    (%r12,%r8,1),%rbp
   6d346:	lea    0x0(%rbp,%r8,1),%r9
   6d34b:	add    %r9,%r8
   6d34e:	bt     %r12,%rdx
   6d352:	mov    %r9,%rdx
   6d355:	mulx   %r10,%r13,%r13
   6d35a:	mov    %r8,%rdx
   6d35d:	mulx   %r10,%r12,%r12
   6d362:	mov    $0x0,%edx
   6d367:	jae    6d2f0 <void inline_single_kernel<true, external_bloom::Classical<4, false, false>, unsigned long>(external_bloom::Classical<4, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   6d369:	mov    %r10,%rdx
   6d36c:	mulx   %rbp,%rdx,%rdx
   6d371:	mov    (%r15,%rdx,8),%rdx
   6d375:	bt     %rbp,%rdx
   6d379:	mov    $0x0,%edx
   6d37e:	jae    6d2f0 <void inline_single_kernel<true, external_bloom::Classical<4, false, false>, unsigned long>(external_bloom::Classical<4, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   6d384:	shlx   %r9,%r14,%r9
   6d389:	mov    $0x0,%edx
   6d38e:	test   %r9,(%r15,%r13,8)
   6d392:	je     6d2f0 <void inline_single_kernel<true, external_bloom::Classical<4, false, false>, unsigned long>(external_bloom::Classical<4, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   6d398:	and    $0x3f,%r8d
   6d39c:	shrx   %r8,(%r15,%r12,8),%rdx
   6d3a2:	and    $0x1,%edx
   6d3a5:	jmp    6d2f0 <void inline_single_kernel<true, external_bloom::Classical<4, false, false>, unsigned long>(external_bloom::Classical<4, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   6d3aa:	pop    %rbx
   6d3ab:	pop    %r12
   6d3ad:	pop    %r13
   6d3af:	pop    %r14
   6d3b1:	pop    %r15
   6d3b3:	pop    %rbp
   6d3b4:	ret
   6d3b5:	int3
   6d3b6:	int3
   6d3b7:	int3
   6d3b8:	int3
   6d3b9:	int3
   6d3ba:	int3
   6d3bb:	int3
   6d3bc:	int3
   6d3bd:	int3
   6d3be:	int3
   6d3bf:	int3

