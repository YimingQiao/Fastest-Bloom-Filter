00000000000677b0 <void inline_single_kernel<false, external_bloom::SingleShortcutV1<external_bloom::SimdBlock>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::SimdBlock> const&, unsigned long, unsigned long const*, unsigned int*)>:
   677b0:	48 85 f6             	test   %rsi,%rsi
   677b3:	0f 84 18 01 00 00    	je     678d1 <void inline_single_kernel<false, external_bloom::SingleShortcutV1<external_bloom::SimdBlock>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::SimdBlock> const&, unsigned long, unsigned long const*, unsigned int*)+0x121>
   677b9:	48 83 fe 01          	cmp    $0x1,%rsi
   677bd:	75 07                	jne    677c6 <void inline_single_kernel<false, external_bloom::SingleShortcutV1<external_bloom::SimdBlock>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::SimdBlock> const&, unsigned long, unsigned long const*, unsigned int*)+0x16>
   677bf:	31 c0                	xor    %eax,%eax
   677c1:	e9 bd 00 00 00       	jmp    67883 <void inline_single_kernel<false, external_bloom::SingleShortcutV1<external_bloom::SimdBlock>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::SimdBlock> const&, unsigned long, unsigned long const*, unsigned int*)+0xd3>
   677c6:	49 89 f0             	mov    %rsi,%r8
   677c9:	49 83 e0 fe          	and    $0xfffffffffffffffe,%r8
   677cd:	31 c0                	xor    %eax,%eax
   677cf:	c5 fd 6f 05 49 d1 f9 	vmovdqa -0x62eb7(%rip),%ymm0        # 4920 <typeinfo name for main::$_60+0x150>
   677d6:	ff
   677d7:	c4 e2 7d 58 0d c8 ba 	vpbroadcastd -0x64538(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
   677de:	f9 ff
   677e0:	4c 8b 0c c2          	mov    (%rdx,%rax,8),%r9
   677e4:	44 8b 57 04          	mov    0x4(%rdi),%r10d
   677e8:	45 21 ca             	and    %r9d,%r10d
   677eb:	44 0f b6 1f          	movzbl (%rdi),%r11d
   677ef:	c4 42 a3 f7 c9       	shrx   %r11,%r9,%r9
   677f4:	62 d2 7d 28 7c d1    	vpbroadcastd %r9d,%ymm2
   677fa:	c4 e2 6d 40 d0       	vpmulld %ymm0,%ymm2,%ymm2
   677ff:	c5 ed 72 d2 1b       	vpsrld $0x1b,%ymm2,%ymm2
   67804:	c4 e2 75 47 d2       	vpsllvd %ymm2,%ymm1,%ymm2
   67809:	4c 8b 4f 08          	mov    0x8(%rdi),%r9
   6780d:	49 c1 e2 05          	shl    $0x5,%r10
   67811:	c4 81 7d 6f 1c 11    	vmovdqa (%r9,%r10,1),%ymm3
   67817:	45 31 c9             	xor    %r9d,%r9d
   6781a:	c4 e2 7d 17 da       	vptest %ymm2,%ymm3
   6781f:	41 0f 92 c1          	setb   %r9b
   67823:	44 89 0c 81          	mov    %r9d,(%rcx,%rax,4)
   67827:	4c 8b 4c c2 08       	mov    0x8(%rdx,%rax,8),%r9
   6782c:	44 8b 57 04          	mov    0x4(%rdi),%r10d
   67830:	45 21 ca             	and    %r9d,%r10d
   67833:	44 0f b6 1f          	movzbl (%rdi),%r11d
   67837:	c4 42 a3 f7 c9       	shrx   %r11,%r9,%r9
   6783c:	62 d2 7d 28 7c d1    	vpbroadcastd %r9d,%ymm2
   67842:	c4 e2 6d 40 d0       	vpmulld %ymm0,%ymm2,%ymm2
   67847:	c5 ed 72 d2 1b       	vpsrld $0x1b,%ymm2,%ymm2
   6784c:	c4 e2 75 47 d2       	vpsllvd %ymm2,%ymm1,%ymm2
   67851:	4c 8b 4f 08          	mov    0x8(%rdi),%r9
   67855:	49 c1 e2 05          	shl    $0x5,%r10
   67859:	c4 81 7d 6f 1c 11    	vmovdqa (%r9,%r10,1),%ymm3
   6785f:	45 31 c9             	xor    %r9d,%r9d
   67862:	c4 e2 7d 17 da       	vptest %ymm2,%ymm3
   67867:	41 0f 92 c1          	setb   %r9b
   6786b:	44 89 4c 81 04       	mov    %r9d,0x4(%rcx,%rax,4)
   67870:	48 83 c0 02          	add    $0x2,%rax
   67874:	49 39 c0             	cmp    %rax,%r8
   67877:	0f 85 63 ff ff ff    	jne    677e0 <void inline_single_kernel<false, external_bloom::SingleShortcutV1<external_bloom::SimdBlock>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::SimdBlock> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   6787d:	40 f6 c6 01          	test   $0x1,%sil
   67881:	74 4e                	je     678d1 <void inline_single_kernel<false, external_bloom::SingleShortcutV1<external_bloom::SimdBlock>, unsigned long>(external_bloom::SingleShortcutV1<external_bloom::SimdBlock> const&, unsigned long, unsigned long const*, unsigned int*)+0x121>
   67883:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
   67887:	8b 77 04             	mov    0x4(%rdi),%esi
   6788a:	21 d6                	and    %edx,%esi
   6788c:	44 0f b6 07          	movzbl (%rdi),%r8d
   67890:	c4 e2 bb f7 d2       	shrx   %r8,%rdx,%rdx
   67895:	62 f2 7d 28 7c c2    	vpbroadcastd %edx,%ymm0
   6789b:	c4 e2 7d 40 05 7c d0 	vpmulld -0x62f84(%rip),%ymm0,%ymm0        # 4920 <typeinfo name for main::$_60+0x150>
   678a2:	f9 ff
   678a4:	c5 fd 72 d0 1b       	vpsrld $0x1b,%ymm0,%ymm0
   678a9:	c4 e2 7d 58 0d f6 b9 	vpbroadcastd -0x6460a(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
   678b0:	f9 ff
   678b2:	c4 e2 75 47 c0       	vpsllvd %ymm0,%ymm1,%ymm0
   678b7:	48 8b 57 08          	mov    0x8(%rdi),%rdx
   678bb:	48 c1 e6 05          	shl    $0x5,%rsi
   678bf:	c5 fd 6f 0c 32       	vmovdqa (%rdx,%rsi,1),%ymm1
   678c4:	31 d2                	xor    %edx,%edx
   678c6:	c4 e2 7d 17 c8       	vptest %ymm0,%ymm1
   678cb:	0f 92 c2             	setb   %dl
   678ce:	89 14 81             	mov    %edx,(%rcx,%rax,4)
   678d1:	c5 f8 77             	vzeroupper
   678d4:	c3                   	ret
   678d5:	cc                   	int3
   678d6:	cc                   	int3
   678d7:	cc                   	int3
   678d8:	cc                   	int3
   678d9:	cc                   	int3
   678da:	cc                   	int3
   678db:	cc                   	int3
   678dc:	cc                   	int3
   678dd:	cc                   	int3
   678de:	cc                   	int3
   678df:	cc                   	int3
