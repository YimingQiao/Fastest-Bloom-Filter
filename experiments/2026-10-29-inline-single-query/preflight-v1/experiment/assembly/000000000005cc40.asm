000000000005cc40 <void inline_single_kernel<true, external_bloom::Fixed16, unsigned long>(external_bloom::Fixed16 const&, unsigned long, unsigned long const*, unsigned int*)>:
   5cc40:	48 85 f6             	test   %rsi,%rsi
   5cc43:	0f 84 7a 01 00 00    	je     5cdc3 <void inline_single_kernel<true, external_bloom::Fixed16, unsigned long>(external_bloom::Fixed16 const&, unsigned long, unsigned long const*, unsigned int*)+0x183>
   5cc49:	53                   	push   %rbx
   5cc4a:	49 b8 93 fd 59 66 b8 	movabs $0xd6e8feb86659fd93,%r8
   5cc51:	fe e8 d6
   5cc54:	48 83 fe 01          	cmp    $0x1,%rsi
   5cc58:	75 07                	jne    5cc61 <void inline_single_kernel<true, external_bloom::Fixed16, unsigned long>(external_bloom::Fixed16 const&, unsigned long, unsigned long const*, unsigned int*)+0x21>
   5cc5a:	31 c0                	xor    %eax,%eax
   5cc5c:	e9 f6 00 00 00       	jmp    5cd57 <void inline_single_kernel<true, external_bloom::Fixed16, unsigned long>(external_bloom::Fixed16 const&, unsigned long, unsigned long const*, unsigned int*)+0x117>
   5cc61:	49 89 f1             	mov    %rsi,%r9
   5cc64:	49 83 e1 fe          	and    $0xfffffffffffffffe,%r9
   5cc68:	31 c0                	xor    %eax,%eax
   5cc6a:	c5 f9 6f 05 ce 7f fa 	vmovdqa -0x58032(%rip),%xmm0        # 4c40 <typeinfo name for main::$_60+0x470>
   5cc71:	ff
   5cc72:	c4 e2 79 59 0d 75 66 	vpbroadcastq -0x5998b(%rip),%xmm1        # 32f0 <_IO_stdin_used+0x3c>
   5cc79:	fa ff
   5cc7b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
   5cc80:	4c 8b 14 c2          	mov    (%rdx,%rax,8),%r10
   5cc84:	4d 89 d3             	mov    %r10,%r11
   5cc87:	49 c1 eb 20          	shr    $0x20,%r11
   5cc8b:	4d 31 d3             	xor    %r10,%r11
   5cc8e:	4d 0f af d8          	imul   %r8,%r11
   5cc92:	4d 89 da             	mov    %r11,%r10
   5cc95:	49 c1 ea 20          	shr    $0x20,%r10
   5cc99:	4d 31 da             	xor    %r11,%r10
   5cc9c:	4d 0f af d0          	imul   %r8,%r10
   5cca0:	4d 89 d3             	mov    %r10,%r11
   5cca3:	49 c1 eb 20          	shr    $0x20,%r11
   5cca7:	45 31 da             	xor    %r11d,%r10d
   5ccaa:	8b 1f                	mov    (%rdi),%ebx
   5ccac:	49 0f af db          	imul   %r11,%rbx
   5ccb0:	62 d2 7d 08 7c d2    	vpbroadcastd %r10d,%xmm2
   5ccb6:	c5 e9 e5 d0          	vpmulhw %xmm0,%xmm2,%xmm2
   5ccba:	c4 e2 71 00 d2       	vpshufb %xmm2,%xmm1,%xmm2
   5ccbf:	4c 8b 57 08          	mov    0x8(%rdi),%r10
   5ccc3:	48 c1 eb 1c          	shr    $0x1c,%rbx
   5ccc7:	48 83 e3 f0          	and    $0xfffffffffffffff0,%rbx
   5cccb:	c4 c1 7a 6f 1c 1a    	vmovdqu (%r10,%rbx,1),%xmm3
   5ccd1:	45 31 d2             	xor    %r10d,%r10d
   5ccd4:	c4 e2 79 17 da       	vptest %xmm2,%xmm3
   5ccd9:	41 0f 92 c2          	setb   %r10b
   5ccdd:	44 89 14 81          	mov    %r10d,(%rcx,%rax,4)
   5cce1:	4c 8b 54 c2 08       	mov    0x8(%rdx,%rax,8),%r10
   5cce6:	4d 89 d3             	mov    %r10,%r11
   5cce9:	49 c1 eb 20          	shr    $0x20,%r11
   5cced:	4d 31 d3             	xor    %r10,%r11
   5ccf0:	4d 0f af d8          	imul   %r8,%r11
   5ccf4:	4d 89 da             	mov    %r11,%r10
   5ccf7:	49 c1 ea 20          	shr    $0x20,%r10
   5ccfb:	4d 31 da             	xor    %r11,%r10
   5ccfe:	4d 0f af d0          	imul   %r8,%r10
   5cd02:	4d 89 d3             	mov    %r10,%r11
   5cd05:	49 c1 eb 20          	shr    $0x20,%r11
   5cd09:	45 31 da             	xor    %r11d,%r10d
   5cd0c:	8b 1f                	mov    (%rdi),%ebx
   5cd0e:	49 0f af db          	imul   %r11,%rbx
   5cd12:	62 d2 7d 08 7c d2    	vpbroadcastd %r10d,%xmm2
   5cd18:	c5 e9 e5 d0          	vpmulhw %xmm0,%xmm2,%xmm2
   5cd1c:	c4 e2 71 00 d2       	vpshufb %xmm2,%xmm1,%xmm2
   5cd21:	4c 8b 57 08          	mov    0x8(%rdi),%r10
   5cd25:	48 c1 eb 1c          	shr    $0x1c,%rbx
   5cd29:	48 83 e3 f0          	and    $0xfffffffffffffff0,%rbx
   5cd2d:	c4 c1 7a 6f 1c 1a    	vmovdqu (%r10,%rbx,1),%xmm3
   5cd33:	45 31 d2             	xor    %r10d,%r10d
   5cd36:	c4 e2 79 17 da       	vptest %xmm2,%xmm3
   5cd3b:	41 0f 92 c2          	setb   %r10b
   5cd3f:	44 89 54 81 04       	mov    %r10d,0x4(%rcx,%rax,4)
   5cd44:	48 83 c0 02          	add    $0x2,%rax
   5cd48:	49 39 c1             	cmp    %rax,%r9
   5cd4b:	0f 85 2f ff ff ff    	jne    5cc80 <void inline_single_kernel<true, external_bloom::Fixed16, unsigned long>(external_bloom::Fixed16 const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
   5cd51:	40 f6 c6 01          	test   $0x1,%sil
   5cd55:	74 6b                	je     5cdc2 <void inline_single_kernel<true, external_bloom::Fixed16, unsigned long>(external_bloom::Fixed16 const&, unsigned long, unsigned long const*, unsigned int*)+0x182>
   5cd57:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
   5cd5b:	48 89 d6             	mov    %rdx,%rsi
   5cd5e:	48 c1 ee 20          	shr    $0x20,%rsi
   5cd62:	48 31 d6             	xor    %rdx,%rsi
   5cd65:	49 0f af f0          	imul   %r8,%rsi
   5cd69:	48 89 f2             	mov    %rsi,%rdx
   5cd6c:	48 c1 ea 20          	shr    $0x20,%rdx
   5cd70:	48 31 f2             	xor    %rsi,%rdx
   5cd73:	49 0f af d0          	imul   %r8,%rdx
   5cd77:	48 89 d6             	mov    %rdx,%rsi
   5cd7a:	48 c1 ee 20          	shr    $0x20,%rsi
   5cd7e:	31 f2                	xor    %esi,%edx
   5cd80:	44 8b 07             	mov    (%rdi),%r8d
   5cd83:	4c 0f af c6          	imul   %rsi,%r8
   5cd87:	62 f2 7d 08 7c c2    	vpbroadcastd %edx,%xmm0
   5cd8d:	c5 f9 e5 05 ab 7e fa 	vpmulhw -0x58155(%rip),%xmm0,%xmm0        # 4c40 <typeinfo name for main::$_60+0x470>
   5cd94:	ff
   5cd95:	c4 e2 79 59 0d 52 65 	vpbroadcastq -0x59aae(%rip),%xmm1        # 32f0 <_IO_stdin_used+0x3c>
   5cd9c:	fa ff
   5cd9e:	c4 e2 71 00 c0       	vpshufb %xmm0,%xmm1,%xmm0
   5cda3:	48 8b 57 08          	mov    0x8(%rdi),%rdx
   5cda7:	49 c1 e8 1c          	shr    $0x1c,%r8
   5cdab:	49 83 e0 f0          	and    $0xfffffffffffffff0,%r8
   5cdaf:	c4 a1 7a 6f 0c 02    	vmovdqu (%rdx,%r8,1),%xmm1
   5cdb5:	31 d2                	xor    %edx,%edx
   5cdb7:	c4 e2 79 17 c8       	vptest %xmm0,%xmm1
   5cdbc:	0f 92 c2             	setb   %dl
   5cdbf:	89 14 81             	mov    %edx,(%rcx,%rax,4)
   5cdc2:	5b                   	pop    %rbx
   5cdc3:	c3                   	ret
   5cdc4:	cc                   	int3
   5cdc5:	cc                   	int3
   5cdc6:	cc                   	int3
   5cdc7:	cc                   	int3
   5cdc8:	cc                   	int3
   5cdc9:	cc                   	int3
   5cdca:	cc                   	int3
   5cdcb:	cc                   	int3
   5cdcc:	cc                   	int3
   5cdcd:	cc                   	int3
   5cdce:	cc                   	int3
   5cdcf:	cc                   	int3
