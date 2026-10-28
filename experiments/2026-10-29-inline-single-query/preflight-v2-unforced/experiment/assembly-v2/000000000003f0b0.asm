000000000003f0b0 <void inline_single_kernel<true, bloom_filters::FastPatternBF, unsigned long>(bloom_filters::FastPatternBF const&, unsigned long, unsigned long const*, unsigned int*)>:
   3f0b0:	test   %rsi,%rsi
   3f0b3:	je     3f16c <void inline_single_kernel<true, bloom_filters::FastPatternBF, unsigned long>(bloom_filters::FastPatternBF const&, unsigned long, unsigned long const*, unsigned int*)+0xbc>
   3f0b9:	push   %rbp
   3f0ba:	push   %r14
   3f0bc:	push   %rbx
   3f0bd:	mov    %rcx,%rax
   3f0c0:	movabs $0xd6e8feb86659fd93,%r8
   3f0ca:	xor    %r9d,%r9d
   3f0cd:	nopl   (%rax)
   3f0d0:	mov    (%rdx,%r9,8),%rcx
   3f0d4:	mov    %rcx,%r11
   3f0d7:	shr    $0x20,%r11
   3f0db:	xor    %rcx,%r11
   3f0de:	imul   %r8,%r11
   3f0e2:	mov    %r11,%r10
   3f0e5:	shr    $0x20,%r10
   3f0e9:	xor    %r11,%r10
   3f0ec:	imul   %r8,%r10
   3f0f0:	mov    %r10,%r11
   3f0f3:	shr    $0x20,%r11
   3f0f7:	xor    %r11d,%r10d
   3f0fa:	and    0x8(%rdi),%r11d
   3f0fe:	mov    %r10d,%ecx
   3f101:	and    $0x1f,%ecx
   3f104:	mov    (%rdi),%r14
   3f107:	mov    0x10(%rdi),%rbx
   3f10b:	mov    (%r14,%rcx,4),%ebp
   3f10f:	mov    %r10d,%ecx
   3f112:	shr    $0x5,%ecx
   3f115:	rol    %cl,%ebp
   3f117:	mov    %r10d,%ecx
   3f11a:	shr    $0x8,%ecx
   3f11d:	and    $0x7c,%ecx
   3f120:	mov    (%r14,%rcx,1),%r14d
   3f124:	mov    %r10d,%ecx
   3f127:	shr    $0xf,%ecx
   3f12a:	rol    %cl,%r14d
   3f12d:	mov    (%rbx,%r11,4),%ecx
   3f131:	andn   %ebp,%ecx,%ecx
   3f136:	shr    $0x14,%r10d
   3f13a:	and    $0x7,%r10d
   3f13e:	or     $0x8,%r10d
   3f142:	xor    %r11d,%r10d
   3f145:	mov    (%rbx,%r10,4),%r10d
   3f149:	andn   %r14d,%r10d,%r10d
   3f14e:	xor    %r11d,%r11d
   3f151:	or     %ecx,%r10d
   3f154:	sete   %r11b
   3f158:	mov    %r11d,(%rax,%r9,4)
   3f15c:	inc    %r9
   3f15f:	cmp    %r9,%rsi
   3f162:	jne    3f0d0 <void inline_single_kernel<true, bloom_filters::FastPatternBF, unsigned long>(bloom_filters::FastPatternBF const&, unsigned long, unsigned long const*, unsigned int*)+0x20>
   3f168:	pop    %rbx
   3f169:	pop    %r14
   3f16b:	pop    %rbp
   3f16c:	ret
   3f16d:	int3
   3f16e:	int3
   3f16f:	int3

