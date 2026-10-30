00000000000468d0 <void inline_single_kernel<true, external_bloom::SimdBlock, unsigned long>(external_bloom::SimdBlock const&, unsigned long, unsigned long const*, unsigned int*)>:
   468d0:	48 85 f6             	test   %rsi,%rsi
   468d3:	0f 84 99 01 00 00    	je     46a72 <void inline_single_kernel<true, external_bloom::SimdBlock, unsigned long>(external_bloom::SimdBlock const&, unsigned long, unsigned long const*, unsigned int*)+0x1a2>
   468d9:	53                   	push   %rbx
   468da:	49 b8 93 fd 59 66 b8 	movabs $0xd6e8feb86659fd93,%r8
   468e1:	fe e8 d6
   468e4:	48 83 fe 01          	cmp    $0x1,%rsi
   468e8:	75 07                	jne    468f1 <void inline_single_kernel<true, external_bloom::SimdBlock, unsigned long>(external_bloom::SimdBlock const&, unsigned long, unsigned long const*, unsigned int*)+0x21>
   468ea:	31 c0                	xor    %eax,%eax
   468ec:	e9 0c 01 00 00       	jmp    469fd <void inline_single_kernel<true, external_bloom::SimdBlock, unsigned long>(external_bloom::SimdBlock const&, unsigned long, unsigned long const*, unsigned int*)+0x12d>
   468f1:	49 89 f1             	mov    %rsi,%r9
   468f4:	49 83 e1 fe          	and    $0xfffffffffffffffe,%r9
   468f8:	31 c0                	xor    %eax,%eax
   468fa:	c5 fd 6f 05 1e e0 fb 	vmovdqa -0x41fe2(%rip),%ymm0        # 4920 <typeinfo name for main::$_60+0x150>
   46901:	ff
   46902:	c4 e2 7d 58 0d 9d c9 	vpbroadcastd -0x43663(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
   46909:	fb ff
   4690b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
   46910:	4c 8b 14 c2          	mov    (%rdx,%rax,8),%r10
   46914:	4d 89 d3             	mov    %r10,%r11
   46917:	49 c1 eb 20          	shr    $0x20,%r11
   4691b:	4d 31 d3             	xor    %r10,%r11
   4691e:	4d 0f af d8          	imul   %r8,%r11
   46922:	4d 89 da             	mov    %r11,%r10
   46925:	49 c1 ea 20          	shr    $0x20,%r10
   46929:	4d 31 da             	xor    %r11,%r10
   4692c:	4d 0f af d0          	imul   %r8,%r10
   46930:	4d 89 d3             	mov    %r10,%r11
   46933:	49 c1 eb 20          	shr    $0x20,%r11
   46937:	4d 31 d3             	xor    %r10,%r11
   4693a:	44 8b 57 04          	mov    0x4(%rdi),%r10d
   4693e:	45 21 da             	and    %r11d,%r10d
   46941:	0f b6 1f             	movzbl (%rdi),%ebx
   46944:	c4 42 e3 f7 db       	shrx   %rbx,%r11,%r11
   46949:	62 d2 7d 28 7c d3    	vpbroadcastd %r11d,%ymm2
   4694f:	c4 e2 6d 40 d0       	vpmulld %ymm0,%ymm2,%ymm2
   46954:	c5 ed 72 d2 1b       	vpsrld $0x1b,%ymm2,%ymm2
   46959:	c4 e2 75 47 d2       	vpsllvd %ymm2,%ymm1,%ymm2
   4695e:	4c 8b 5f 08          	mov    0x8(%rdi),%r11
   46962:	49 c1 e2 05          	shl    $0x5,%r10
   46966:	c4 81 7d 6f 1c 13    	vmovdqa (%r11,%r10,1),%ymm3
   4696c:	45 31 d2             	xor    %r10d,%r10d
   4696f:	c4 e2 7d 17 da       	vptest %ymm2,%ymm3
   46974:	41 0f 92 c2          	setb   %r10b
   46978:	44 89 14 81          	mov    %r10d,(%rcx,%rax,4)
   4697c:	4c 8b 54 c2 08       	mov    0x8(%rdx,%rax,8),%r10
   46981:	4d 89 d3             	mov    %r10,%r11
   46984:	49 c1 eb 20          	shr    $0x20,%r11
   46988:	4d 31 d3             	xor    %r10,%r11
   4698b:	4d 0f af d8          	imul   %r8,%r11
   4698f:	4d 89 da             	mov    %r11,%r10
   46992:	49 c1 ea 20          	shr    $0x20,%r10
   46996:	4d 31 da             	xor    %r11,%r10
   46999:	4d 0f af d0          	imul   %r8,%r10
   4699d:	4d 89 d3             	mov    %r10,%r11
   469a0:	49 c1 eb 20          	shr    $0x20,%r11
   469a4:	4d 31 d3             	xor    %r10,%r11
   469a7:	44 8b 57 04          	mov    0x4(%rdi),%r10d
   469ab:	45 21 da             	and    %r11d,%r10d
   469ae:	0f b6 1f             	movzbl (%rdi),%ebx
   469b1:	c4 42 e3 f7 db       	shrx   %rbx,%r11,%r11
   469b6:	62 d2 7d 28 7c d3    	vpbroadcastd %r11d,%ymm2
   469bc:	c4 e2 6d 40 d0       	vpmulld %ymm0,%ymm2,%ymm2
   469c1:	c5 ed 72 d2 1b       	vpsrld $0x1b,%ymm2,%ymm2
   469c6:	c4 e2 75 47 d2       	vpsllvd %ymm2,%ymm1,%ymm2
   469cb:	4c 8b 5f 08          	mov    0x8(%rdi),%r11
   469cf:	49 c1 e2 05          	shl    $0x5,%r10
   469d3:	c4 81 7d 6f 1c 13    	vmovdqa (%r11,%r10,1),%ymm3
   469d9:	45 31 d2             	xor    %r10d,%r10d
   469dc:	c4 e2 7d 17 da       	vptest %ymm2,%ymm3
   469e1:	41 0f 92 c2          	setb   %r10b
   469e5:	44 89 54 81 04       	mov    %r10d,0x4(%rcx,%rax,4)
   469ea:	48 83 c0 02          	add    $0x2,%rax
   469ee:	49 39 c1             	cmp    %rax,%r9
   469f1:	0f 85 19 ff ff ff    	jne    46910 <void inline_single_kernel<true, external_bloom::SimdBlock, unsigned long>(external_bloom::SimdBlock const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
   469f7:	40 f6 c6 01          	test   $0x1,%sil
   469fb:	74 74                	je     46a71 <void inline_single_kernel<true, external_bloom::SimdBlock, unsigned long>(external_bloom::SimdBlock const&, unsigned long, unsigned long const*, unsigned int*)+0x1a1>
   469fd:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
   46a01:	48 89 d6             	mov    %rdx,%rsi
   46a04:	48 c1 ee 20          	shr    $0x20,%rsi
   46a08:	48 31 d6             	xor    %rdx,%rsi
   46a0b:	49 0f af f0          	imul   %r8,%rsi
   46a0f:	48 89 f2             	mov    %rsi,%rdx
   46a12:	48 c1 ea 20          	shr    $0x20,%rdx
   46a16:	48 31 f2             	xor    %rsi,%rdx
   46a19:	49 0f af d0          	imul   %r8,%rdx
   46a1d:	48 89 d6             	mov    %rdx,%rsi
   46a20:	48 c1 ee 20          	shr    $0x20,%rsi
   46a24:	48 31 d6             	xor    %rdx,%rsi
   46a27:	8b 57 04             	mov    0x4(%rdi),%edx
   46a2a:	21 f2                	and    %esi,%edx
   46a2c:	44 0f b6 07          	movzbl (%rdi),%r8d
   46a30:	c4 e2 bb f7 f6       	shrx   %r8,%rsi,%rsi
   46a35:	62 f2 7d 28 7c c6    	vpbroadcastd %esi,%ymm0
   46a3b:	c4 e2 7d 40 05 dc de 	vpmulld -0x42124(%rip),%ymm0,%ymm0        # 4920 <typeinfo name for main::$_60+0x150>
   46a42:	fb ff
   46a44:	c5 fd 72 d0 1b       	vpsrld $0x1b,%ymm0,%ymm0
   46a49:	c4 e2 7d 58 0d 56 c8 	vpbroadcastd -0x437aa(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
   46a50:	fb ff
   46a52:	c4 e2 75 47 c0       	vpsllvd %ymm0,%ymm1,%ymm0
   46a57:	48 8b 77 08          	mov    0x8(%rdi),%rsi
   46a5b:	48 c1 e2 05          	shl    $0x5,%rdx
   46a5f:	c5 fd 6f 0c 16       	vmovdqa (%rsi,%rdx,1),%ymm1
   46a64:	31 d2                	xor    %edx,%edx
   46a66:	c4 e2 7d 17 c8       	vptest %ymm0,%ymm1
   46a6b:	0f 92 c2             	setb   %dl
   46a6e:	89 14 81             	mov    %edx,(%rcx,%rax,4)
   46a71:	5b                   	pop    %rbx
   46a72:	c5 f8 77             	vzeroupper
   46a75:	c3                   	ret
   46a76:	cc                   	int3
   46a77:	cc                   	int3
   46a78:	cc                   	int3
   46a79:	cc                   	int3
   46a7a:	cc                   	int3
   46a7b:	cc                   	int3
   46a7c:	cc                   	int3
   46a7d:	cc                   	int3
   46a7e:	cc                   	int3
   46a7f:	cc                   	int3
