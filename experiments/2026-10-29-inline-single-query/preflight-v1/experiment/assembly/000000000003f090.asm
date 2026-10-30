000000000003f090 <void inline_single_kernel<true, bloom_filters::FastPatternBF, unsigned long>(bloom_filters::FastPatternBF const&, unsigned long, unsigned long const*, unsigned int*)>:
   3f090:	48 85 f6             	test   %rsi,%rsi
   3f093:	0f 84 b3 00 00 00    	je     3f14c <void inline_single_kernel<true, bloom_filters::FastPatternBF, unsigned long>(bloom_filters::FastPatternBF const&, unsigned long, unsigned long const*, unsigned int*)+0xbc>
   3f099:	55                   	push   %rbp
   3f09a:	41 56                	push   %r14
   3f09c:	53                   	push   %rbx
   3f09d:	48 89 c8             	mov    %rcx,%rax
   3f0a0:	49 b8 93 fd 59 66 b8 	movabs $0xd6e8feb86659fd93,%r8
   3f0a7:	fe e8 d6
   3f0aa:	45 31 c9             	xor    %r9d,%r9d
   3f0ad:	0f 1f 00             	nopl   (%rax)
   3f0b0:	4a 8b 0c ca          	mov    (%rdx,%r9,8),%rcx
   3f0b4:	49 89 cb             	mov    %rcx,%r11
   3f0b7:	49 c1 eb 20          	shr    $0x20,%r11
   3f0bb:	49 31 cb             	xor    %rcx,%r11
   3f0be:	4d 0f af d8          	imul   %r8,%r11
   3f0c2:	4d 89 da             	mov    %r11,%r10
   3f0c5:	49 c1 ea 20          	shr    $0x20,%r10
   3f0c9:	4d 31 da             	xor    %r11,%r10
   3f0cc:	4d 0f af d0          	imul   %r8,%r10
   3f0d0:	4d 89 d3             	mov    %r10,%r11
   3f0d3:	49 c1 eb 20          	shr    $0x20,%r11
   3f0d7:	45 31 da             	xor    %r11d,%r10d
   3f0da:	44 23 5f 08          	and    0x8(%rdi),%r11d
   3f0de:	44 89 d1             	mov    %r10d,%ecx
   3f0e1:	83 e1 1f             	and    $0x1f,%ecx
   3f0e4:	4c 8b 37             	mov    (%rdi),%r14
   3f0e7:	48 8b 5f 10          	mov    0x10(%rdi),%rbx
   3f0eb:	41 8b 2c 8e          	mov    (%r14,%rcx,4),%ebp
   3f0ef:	44 89 d1             	mov    %r10d,%ecx
   3f0f2:	c1 e9 05             	shr    $0x5,%ecx
   3f0f5:	d3 c5                	rol    %cl,%ebp
   3f0f7:	44 89 d1             	mov    %r10d,%ecx
   3f0fa:	c1 e9 08             	shr    $0x8,%ecx
   3f0fd:	83 e1 7c             	and    $0x7c,%ecx
   3f100:	45 8b 34 0e          	mov    (%r14,%rcx,1),%r14d
   3f104:	44 89 d1             	mov    %r10d,%ecx
   3f107:	c1 e9 0f             	shr    $0xf,%ecx
   3f10a:	41 d3 c6             	rol    %cl,%r14d
   3f10d:	42 8b 0c 9b          	mov    (%rbx,%r11,4),%ecx
   3f111:	c4 e2 70 f2 cd       	andn   %ebp,%ecx,%ecx
   3f116:	41 c1 ea 14          	shr    $0x14,%r10d
   3f11a:	41 83 e2 07          	and    $0x7,%r10d
   3f11e:	41 83 ca 08          	or     $0x8,%r10d
   3f122:	45 31 da             	xor    %r11d,%r10d
   3f125:	46 8b 14 93          	mov    (%rbx,%r10,4),%r10d
   3f129:	c4 42 28 f2 d6       	andn   %r14d,%r10d,%r10d
   3f12e:	45 31 db             	xor    %r11d,%r11d
   3f131:	41 09 ca             	or     %ecx,%r10d
   3f134:	41 0f 94 c3          	sete   %r11b
   3f138:	46 89 1c 88          	mov    %r11d,(%rax,%r9,4)
   3f13c:	49 ff c1             	inc    %r9
   3f13f:	4c 39 ce             	cmp    %r9,%rsi
   3f142:	0f 85 68 ff ff ff    	jne    3f0b0 <void inline_single_kernel<true, bloom_filters::FastPatternBF, unsigned long>(bloom_filters::FastPatternBF const&, unsigned long, unsigned long const*, unsigned int*)+0x20>
   3f148:	5b                   	pop    %rbx
   3f149:	41 5e                	pop    %r14
   3f14b:	5d                   	pop    %rbp
   3f14c:	c3                   	ret
   3f14d:	cc                   	int3
   3f14e:	cc                   	int3
   3f14f:	cc                   	int3
