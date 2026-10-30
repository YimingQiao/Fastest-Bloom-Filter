00000000000463c0 <void inline_single_kernel<false, external_bloom::SimdBlock, unsigned long>(external_bloom::SimdBlock const&, unsigned long, unsigned long const*, unsigned int*)>:
   463c0:	48 85 f6             	test   %rsi,%rsi
   463c3:	0f 84 18 01 00 00    	je     464e1 <void inline_single_kernel<false, external_bloom::SimdBlock, unsigned long>(external_bloom::SimdBlock const&, unsigned long, unsigned long const*, unsigned int*)+0x121>
   463c9:	48 83 fe 01          	cmp    $0x1,%rsi
   463cd:	75 07                	jne    463d6 <void inline_single_kernel<false, external_bloom::SimdBlock, unsigned long>(external_bloom::SimdBlock const&, unsigned long, unsigned long const*, unsigned int*)+0x16>
   463cf:	31 c0                	xor    %eax,%eax
   463d1:	e9 bd 00 00 00       	jmp    46493 <void inline_single_kernel<false, external_bloom::SimdBlock, unsigned long>(external_bloom::SimdBlock const&, unsigned long, unsigned long const*, unsigned int*)+0xd3>
   463d6:	49 89 f0             	mov    %rsi,%r8
   463d9:	49 83 e0 fe          	and    $0xfffffffffffffffe,%r8
   463dd:	31 c0                	xor    %eax,%eax
   463df:	c5 fd 6f 05 39 e5 fb 	vmovdqa -0x41ac7(%rip),%ymm0        # 4920 <typeinfo name for main::$_60+0x150>
   463e6:	ff
   463e7:	c4 e2 7d 58 0d b8 ce 	vpbroadcastd -0x43148(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
   463ee:	fb ff
   463f0:	4c 8b 0c c2          	mov    (%rdx,%rax,8),%r9
   463f4:	44 8b 57 04          	mov    0x4(%rdi),%r10d
   463f8:	45 21 ca             	and    %r9d,%r10d
   463fb:	44 0f b6 1f          	movzbl (%rdi),%r11d
   463ff:	c4 42 a3 f7 c9       	shrx   %r11,%r9,%r9
   46404:	62 d2 7d 28 7c d1    	vpbroadcastd %r9d,%ymm2
   4640a:	c4 e2 6d 40 d0       	vpmulld %ymm0,%ymm2,%ymm2
   4640f:	c5 ed 72 d2 1b       	vpsrld $0x1b,%ymm2,%ymm2
   46414:	c4 e2 75 47 d2       	vpsllvd %ymm2,%ymm1,%ymm2
   46419:	4c 8b 4f 08          	mov    0x8(%rdi),%r9
   4641d:	49 c1 e2 05          	shl    $0x5,%r10
   46421:	c4 81 7d 6f 1c 11    	vmovdqa (%r9,%r10,1),%ymm3
   46427:	45 31 c9             	xor    %r9d,%r9d
   4642a:	c4 e2 7d 17 da       	vptest %ymm2,%ymm3
   4642f:	41 0f 92 c1          	setb   %r9b
   46433:	44 89 0c 81          	mov    %r9d,(%rcx,%rax,4)
   46437:	4c 8b 4c c2 08       	mov    0x8(%rdx,%rax,8),%r9
   4643c:	44 8b 57 04          	mov    0x4(%rdi),%r10d
   46440:	45 21 ca             	and    %r9d,%r10d
   46443:	44 0f b6 1f          	movzbl (%rdi),%r11d
   46447:	c4 42 a3 f7 c9       	shrx   %r11,%r9,%r9
   4644c:	62 d2 7d 28 7c d1    	vpbroadcastd %r9d,%ymm2
   46452:	c4 e2 6d 40 d0       	vpmulld %ymm0,%ymm2,%ymm2
   46457:	c5 ed 72 d2 1b       	vpsrld $0x1b,%ymm2,%ymm2
   4645c:	c4 e2 75 47 d2       	vpsllvd %ymm2,%ymm1,%ymm2
   46461:	4c 8b 4f 08          	mov    0x8(%rdi),%r9
   46465:	49 c1 e2 05          	shl    $0x5,%r10
   46469:	c4 81 7d 6f 1c 11    	vmovdqa (%r9,%r10,1),%ymm3
   4646f:	45 31 c9             	xor    %r9d,%r9d
   46472:	c4 e2 7d 17 da       	vptest %ymm2,%ymm3
   46477:	41 0f 92 c1          	setb   %r9b
   4647b:	44 89 4c 81 04       	mov    %r9d,0x4(%rcx,%rax,4)
   46480:	48 83 c0 02          	add    $0x2,%rax
   46484:	49 39 c0             	cmp    %rax,%r8
   46487:	0f 85 63 ff ff ff    	jne    463f0 <void inline_single_kernel<false, external_bloom::SimdBlock, unsigned long>(external_bloom::SimdBlock const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   4648d:	40 f6 c6 01          	test   $0x1,%sil
   46491:	74 4e                	je     464e1 <void inline_single_kernel<false, external_bloom::SimdBlock, unsigned long>(external_bloom::SimdBlock const&, unsigned long, unsigned long const*, unsigned int*)+0x121>
   46493:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
   46497:	8b 77 04             	mov    0x4(%rdi),%esi
   4649a:	21 d6                	and    %edx,%esi
   4649c:	44 0f b6 07          	movzbl (%rdi),%r8d
   464a0:	c4 e2 bb f7 d2       	shrx   %r8,%rdx,%rdx
   464a5:	62 f2 7d 28 7c c2    	vpbroadcastd %edx,%ymm0
   464ab:	c4 e2 7d 40 05 6c e4 	vpmulld -0x41b94(%rip),%ymm0,%ymm0        # 4920 <typeinfo name for main::$_60+0x150>
   464b2:	fb ff
   464b4:	c5 fd 72 d0 1b       	vpsrld $0x1b,%ymm0,%ymm0
   464b9:	c4 e2 7d 58 0d e6 cd 	vpbroadcastd -0x4321a(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
   464c0:	fb ff
   464c2:	c4 e2 75 47 c0       	vpsllvd %ymm0,%ymm1,%ymm0
   464c7:	48 8b 57 08          	mov    0x8(%rdi),%rdx
   464cb:	48 c1 e6 05          	shl    $0x5,%rsi
   464cf:	c5 fd 6f 0c 32       	vmovdqa (%rdx,%rsi,1),%ymm1
   464d4:	31 d2                	xor    %edx,%edx
   464d6:	c4 e2 7d 17 c8       	vptest %ymm0,%ymm1
   464db:	0f 92 c2             	setb   %dl
   464de:	89 14 81             	mov    %edx,(%rcx,%rax,4)
   464e1:	c5 f8 77             	vzeroupper
   464e4:	c3                   	ret
   464e5:	cc                   	int3
   464e6:	cc                   	int3
   464e7:	cc                   	int3
   464e8:	cc                   	int3
   464e9:	cc                   	int3
   464ea:	cc                   	int3
   464eb:	cc                   	int3
   464ec:	cc                   	int3
   464ed:	cc                   	int3
   464ee:	cc                   	int3
   464ef:	cc                   	int3
