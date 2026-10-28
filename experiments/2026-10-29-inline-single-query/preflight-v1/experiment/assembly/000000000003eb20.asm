000000000003eb20 <void inline_single_kernel<false, bloom_filters::FastPatternBF, unsigned long>(bloom_filters::FastPatternBF const&, unsigned long, unsigned long const*, unsigned int*)>:
   3eb20:	48 85 f6             	test   %rsi,%rsi
   3eb23:	0f 84 7b 01 00 00    	je     3eca4 <void inline_single_kernel<false, bloom_filters::FastPatternBF, unsigned long>(bloom_filters::FastPatternBF const&, unsigned long, unsigned long const*, unsigned int*)+0x184>
   3eb29:	55                   	push   %rbp
   3eb2a:	41 56                	push   %r14
   3eb2c:	53                   	push   %rbx
   3eb2d:	48 89 c8             	mov    %rcx,%rax
   3eb30:	48 83 fe 01          	cmp    $0x1,%rsi
   3eb34:	75 08                	jne    3eb3e <void inline_single_kernel<false, bloom_filters::FastPatternBF, unsigned long>(bloom_filters::FastPatternBF const&, unsigned long, unsigned long const*, unsigned int*)+0x1e>
   3eb36:	45 31 c0             	xor    %r8d,%r8d
   3eb39:	e9 01 01 00 00       	jmp    3ec3f <void inline_single_kernel<false, bloom_filters::FastPatternBF, unsigned long>(bloom_filters::FastPatternBF const&, unsigned long, unsigned long const*, unsigned int*)+0x11f>
   3eb3e:	49 89 f1             	mov    %rsi,%r9
   3eb41:	49 83 e1 fe          	and    $0xfffffffffffffffe,%r9
   3eb45:	45 31 c0             	xor    %r8d,%r8d
   3eb48:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
   3eb4f:	00
   3eb50:	4e 8b 14 c2          	mov    (%rdx,%r8,8),%r10
   3eb54:	4d 89 d3             	mov    %r10,%r11
   3eb57:	49 c1 eb 20          	shr    $0x20,%r11
   3eb5b:	44 23 5f 08          	and    0x8(%rdi),%r11d
   3eb5f:	44 89 d1             	mov    %r10d,%ecx
   3eb62:	83 e1 1f             	and    $0x1f,%ecx
   3eb65:	4c 8b 37             	mov    (%rdi),%r14
   3eb68:	48 8b 5f 10          	mov    0x10(%rdi),%rbx
   3eb6c:	41 8b 2c 8e          	mov    (%r14,%rcx,4),%ebp
   3eb70:	44 89 d1             	mov    %r10d,%ecx
   3eb73:	c1 e9 05             	shr    $0x5,%ecx
   3eb76:	d3 c5                	rol    %cl,%ebp
   3eb78:	44 89 d1             	mov    %r10d,%ecx
   3eb7b:	c1 e9 08             	shr    $0x8,%ecx
   3eb7e:	83 e1 7c             	and    $0x7c,%ecx
   3eb81:	45 8b 34 0e          	mov    (%r14,%rcx,1),%r14d
   3eb85:	44 89 d1             	mov    %r10d,%ecx
   3eb88:	c1 e9 0f             	shr    $0xf,%ecx
   3eb8b:	41 d3 c6             	rol    %cl,%r14d
   3eb8e:	42 8b 0c 9b          	mov    (%rbx,%r11,4),%ecx
   3eb92:	c4 e2 70 f2 cd       	andn   %ebp,%ecx,%ecx
   3eb97:	41 c1 ea 14          	shr    $0x14,%r10d
   3eb9b:	41 83 e2 07          	and    $0x7,%r10d
   3eb9f:	41 83 ca 08          	or     $0x8,%r10d
   3eba3:	45 31 da             	xor    %r11d,%r10d
   3eba6:	46 8b 14 93          	mov    (%rbx,%r10,4),%r10d
   3ebaa:	c4 42 28 f2 d6       	andn   %r14d,%r10d,%r10d
   3ebaf:	45 31 db             	xor    %r11d,%r11d
   3ebb2:	41 09 ca             	or     %ecx,%r10d
   3ebb5:	41 0f 94 c3          	sete   %r11b
   3ebb9:	46 89 1c 80          	mov    %r11d,(%rax,%r8,4)
   3ebbd:	4e 8b 54 c2 08       	mov    0x8(%rdx,%r8,8),%r10
   3ebc2:	4d 89 d3             	mov    %r10,%r11
   3ebc5:	49 c1 eb 20          	shr    $0x20,%r11
   3ebc9:	44 23 5f 08          	and    0x8(%rdi),%r11d
   3ebcd:	44 89 d1             	mov    %r10d,%ecx
   3ebd0:	83 e1 1f             	and    $0x1f,%ecx
   3ebd3:	4c 8b 37             	mov    (%rdi),%r14
   3ebd6:	48 8b 5f 10          	mov    0x10(%rdi),%rbx
   3ebda:	41 8b 2c 8e          	mov    (%r14,%rcx,4),%ebp
   3ebde:	44 89 d1             	mov    %r10d,%ecx
   3ebe1:	c1 e9 05             	shr    $0x5,%ecx
   3ebe4:	d3 c5                	rol    %cl,%ebp
   3ebe6:	44 89 d1             	mov    %r10d,%ecx
   3ebe9:	c1 e9 08             	shr    $0x8,%ecx
   3ebec:	83 e1 7c             	and    $0x7c,%ecx
   3ebef:	45 8b 34 0e          	mov    (%r14,%rcx,1),%r14d
   3ebf3:	44 89 d1             	mov    %r10d,%ecx
   3ebf6:	c1 e9 0f             	shr    $0xf,%ecx
   3ebf9:	41 d3 c6             	rol    %cl,%r14d
   3ebfc:	42 8b 0c 9b          	mov    (%rbx,%r11,4),%ecx
   3ec00:	c4 e2 70 f2 cd       	andn   %ebp,%ecx,%ecx
   3ec05:	41 c1 ea 14          	shr    $0x14,%r10d
   3ec09:	41 83 e2 07          	and    $0x7,%r10d
   3ec0d:	41 83 ca 08          	or     $0x8,%r10d
   3ec11:	45 31 da             	xor    %r11d,%r10d
   3ec14:	46 8b 14 93          	mov    (%rbx,%r10,4),%r10d
   3ec18:	c4 42 28 f2 d6       	andn   %r14d,%r10d,%r10d
   3ec1d:	45 31 db             	xor    %r11d,%r11d
   3ec20:	41 09 ca             	or     %ecx,%r10d
   3ec23:	41 0f 94 c3          	sete   %r11b
   3ec27:	46 89 5c 80 04       	mov    %r11d,0x4(%rax,%r8,4)
   3ec2c:	49 83 c0 02          	add    $0x2,%r8
   3ec30:	4d 39 c1             	cmp    %r8,%r9
   3ec33:	0f 85 17 ff ff ff    	jne    3eb50 <void inline_single_kernel<false, bloom_filters::FastPatternBF, unsigned long>(bloom_filters::FastPatternBF const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   3ec39:	40 f6 c6 01          	test   $0x1,%sil
   3ec3d:	74 61                	je     3eca0 <void inline_single_kernel<false, bloom_filters::FastPatternBF, unsigned long>(bloom_filters::FastPatternBF const&, unsigned long, unsigned long const*, unsigned int*)+0x180>
   3ec3f:	4a 8b 14 c2          	mov    (%rdx,%r8,8),%rdx
   3ec43:	48 89 d6             	mov    %rdx,%rsi
   3ec46:	48 c1 ee 20          	shr    $0x20,%rsi
   3ec4a:	23 77 08             	and    0x8(%rdi),%esi
   3ec4d:	89 d1                	mov    %edx,%ecx
   3ec4f:	83 e1 1f             	and    $0x1f,%ecx
   3ec52:	4c 8b 0f             	mov    (%rdi),%r9
   3ec55:	48 8b 7f 10          	mov    0x10(%rdi),%rdi
   3ec59:	45 8b 14 89          	mov    (%r9,%rcx,4),%r10d
   3ec5d:	89 d1                	mov    %edx,%ecx
   3ec5f:	c1 e9 05             	shr    $0x5,%ecx
   3ec62:	41 d3 c2             	rol    %cl,%r10d
   3ec65:	89 d1                	mov    %edx,%ecx
   3ec67:	c1 e9 08             	shr    $0x8,%ecx
   3ec6a:	83 e1 7c             	and    $0x7c,%ecx
   3ec6d:	45 8b 0c 09          	mov    (%r9,%rcx,1),%r9d
   3ec71:	89 d1                	mov    %edx,%ecx
   3ec73:	c1 e9 0f             	shr    $0xf,%ecx
   3ec76:	41 d3 c1             	rol    %cl,%r9d
   3ec79:	8b 0c b7             	mov    (%rdi,%rsi,4),%ecx
   3ec7c:	c4 c2 70 f2 ca       	andn   %r10d,%ecx,%ecx
   3ec81:	c1 ea 14             	shr    $0x14,%edx
   3ec84:	83 e2 07             	and    $0x7,%edx
   3ec87:	83 ca 08             	or     $0x8,%edx
   3ec8a:	31 f2                	xor    %esi,%edx
   3ec8c:	8b 14 97             	mov    (%rdi,%rdx,4),%edx
   3ec8f:	c4 c2 68 f2 d1       	andn   %r9d,%edx,%edx
   3ec94:	31 f6                	xor    %esi,%esi
   3ec96:	09 ca                	or     %ecx,%edx
   3ec98:	40 0f 94 c6          	sete   %sil
   3ec9c:	42 89 34 80          	mov    %esi,(%rax,%r8,4)
   3eca0:	5b                   	pop    %rbx
   3eca1:	41 5e                	pop    %r14
   3eca3:	5d                   	pop    %rbp
   3eca4:	c3                   	ret
   3eca5:	cc                   	int3
   3eca6:	cc                   	int3
   3eca7:	cc                   	int3
   3eca8:	cc                   	int3
   3eca9:	cc                   	int3
   3ecaa:	cc                   	int3
   3ecab:	cc                   	int3
   3ecac:	cc                   	int3
   3ecad:	cc                   	int3
   3ecae:	cc                   	int3
   3ecaf:	cc                   	int3
