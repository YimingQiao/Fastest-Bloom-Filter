000000000003f030 <void inline_single_kernel<true, bloom_filters::FastPatternBF, unsigned long>(bloom_filters::FastPatternBF const&, unsigned long, unsigned long const*, unsigned int*)>:
   3f030:	test   %rsi,%rsi
   3f033:	je     3f0ec <void inline_single_kernel<true, bloom_filters::FastPatternBF, unsigned long>(bloom_filters::FastPatternBF const&, unsigned long, unsigned long const*, unsigned int*)+0xbc>
   3f039:	push   %rbp
   3f03a:	push   %r14
   3f03c:	push   %rbx
   3f03d:	mov    %rcx,%rax
   3f040:	movabs $0xd6e8feb86659fd93,%r8
   3f04a:	xor    %r9d,%r9d
   3f04d:	nopl   (%rax)
   3f050:	mov    (%rdx,%r9,8),%rcx
   3f054:	mov    %rcx,%r11
   3f057:	shr    $0x20,%r11
   3f05b:	xor    %rcx,%r11
   3f05e:	imul   %r8,%r11
   3f062:	mov    %r11,%r10
   3f065:	shr    $0x20,%r10
   3f069:	xor    %r11,%r10
   3f06c:	imul   %r8,%r10
   3f070:	mov    %r10,%r11
   3f073:	shr    $0x20,%r11
   3f077:	xor    %r11d,%r10d
   3f07a:	and    0x8(%rdi),%r11d
   3f07e:	mov    %r10d,%ecx
   3f081:	and    $0x1f,%ecx
   3f084:	mov    (%rdi),%r14
   3f087:	mov    0x10(%rdi),%rbx
   3f08b:	mov    (%r14,%rcx,4),%ebp
   3f08f:	mov    %r10d,%ecx
   3f092:	shr    $0x5,%ecx
   3f095:	rol    %cl,%ebp
   3f097:	mov    %r10d,%ecx
   3f09a:	shr    $0x8,%ecx
   3f09d:	and    $0x7c,%ecx
   3f0a0:	mov    (%r14,%rcx,1),%r14d
   3f0a4:	mov    %r10d,%ecx
   3f0a7:	shr    $0xf,%ecx
   3f0aa:	rol    %cl,%r14d
   3f0ad:	mov    (%rbx,%r11,4),%ecx
   3f0b1:	andn   %ebp,%ecx,%ecx
   3f0b6:	shr    $0x14,%r10d
   3f0ba:	and    $0x7,%r10d
   3f0be:	or     $0x8,%r10d
   3f0c2:	xor    %r11d,%r10d
   3f0c5:	mov    (%rbx,%r10,4),%r10d
   3f0c9:	andn   %r14d,%r10d,%r10d
   3f0ce:	xor    %r11d,%r11d
   3f0d1:	or     %ecx,%r10d
   3f0d4:	sete   %r11b
   3f0d8:	mov    %r11d,(%rax,%r9,4)
   3f0dc:	inc    %r9
   3f0df:	cmp    %r9,%rsi
   3f0e2:	jne    3f050 <void inline_single_kernel<true, bloom_filters::FastPatternBF, unsigned long>(bloom_filters::FastPatternBF const&, unsigned long, unsigned long const*, unsigned int*)+0x20>
   3f0e8:	pop    %rbx
   3f0e9:	pop    %r14
   3f0eb:	pop    %rbp
   3f0ec:	ret
   3f0ed:	int3
   3f0ee:	int3
   3f0ef:	int3

