0000000000175110 <void inline_single_kernel<false, bloom_filters::Split64BloomFilter, unsigned long>(bloom_filters::Split64BloomFilter const&, unsigned long, unsigned long const*, unsigned int*)>:
  175110:	48 85 f6             	test   %rsi,%rsi
  175113:	0f 84 37 01 00 00    	je     175250 <void inline_single_kernel<false, bloom_filters::Split64BloomFilter, unsigned long>(bloom_filters::Split64BloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x140>
  175119:	48 83 fe 01          	cmp    $0x1,%rsi
  17511d:	75 07                	jne    175126 <void inline_single_kernel<false, bloom_filters::Split64BloomFilter, unsigned long>(bloom_filters::Split64BloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x16>
  17511f:	31 c0                	xor    %eax,%eax
  175121:	e9 d8 00 00 00       	jmp    1751fe <void inline_single_kernel<false, bloom_filters::Split64BloomFilter, unsigned long>(bloom_filters::Split64BloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0xee>
  175126:	49 89 f0             	mov    %rsi,%r8
  175129:	49 83 e0 fe          	and    $0xfffffffffffffffe,%r8
  17512d:	31 c0                	xor    %eax,%eax
  17512f:	c5 fd 6f 05 e9 f7 e8 	vmovdqa -0x170817(%rip),%ymm0        # 4920 <typeinfo name for main::$_60+0x150>
  175136:	ff
  175137:	62 f2 fd 48 59 0d 17 	vpbroadcastq -0x171de9(%rip),%zmm1        # 3358 <_IO_stdin_used+0xa4>
  17513e:	e2 e8 ff
  175141:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  175148:	0f 1f 84 00 00 00 00
  17514f:	00
  175150:	4c 8b 0c c2          	mov    (%rdx,%rax,8),%r9
  175154:	62 d2 7d 28 7c d1    	vpbroadcastd %r9d,%ymm2
  17515a:	49 c1 e9 20          	shr    $0x20,%r9
  17515e:	44 23 4f 18          	and    0x18(%rdi),%r9d
  175162:	4c 8b 17             	mov    (%rdi),%r10
  175165:	49 c1 e1 06          	shl    $0x6,%r9
  175169:	62 91 fd 48 6f 1c 0a 	vmovdqa64 (%r10,%r9,1),%zmm3
  175170:	c4 e2 6d 40 d0       	vpmulld %ymm0,%ymm2,%ymm2
  175175:	c5 ed 72 d2 1a       	vpsrld $0x1a,%ymm2,%ymm2
  17517a:	62 f2 7d 48 35 d2    	vpmovzxdq %ymm2,%zmm2
  175180:	62 f2 e5 48 45 d2    	vpsrlvq %zmm2,%zmm3,%zmm2
  175186:	62 f2 ee 48 27 c1    	vptestnmq %zmm1,%zmm2,%k0
  17518c:	45 31 c9             	xor    %r9d,%r9d
  17518f:	c5 f9 98 c0          	kortestb %k0,%k0
  175193:	41 0f 94 c1          	sete   %r9b
  175197:	44 89 0c 81          	mov    %r9d,(%rcx,%rax,4)
  17519b:	4c 8b 4c c2 08       	mov    0x8(%rdx,%rax,8),%r9
  1751a0:	4d 89 ca             	mov    %r9,%r10
  1751a3:	49 c1 ea 20          	shr    $0x20,%r10
  1751a7:	44 23 57 18          	and    0x18(%rdi),%r10d
  1751ab:	62 d2 7d 28 7c d1    	vpbroadcastd %r9d,%ymm2
  1751b1:	4c 8b 0f             	mov    (%rdi),%r9
  1751b4:	49 c1 e2 06          	shl    $0x6,%r10
  1751b8:	62 91 fd 48 6f 1c 11 	vmovdqa64 (%r9,%r10,1),%zmm3
  1751bf:	c4 e2 6d 40 d0       	vpmulld %ymm0,%ymm2,%ymm2
  1751c4:	c5 ed 72 d2 1a       	vpsrld $0x1a,%ymm2,%ymm2
  1751c9:	62 f2 7d 48 35 d2    	vpmovzxdq %ymm2,%zmm2
  1751cf:	62 f2 e5 48 45 d2    	vpsrlvq %zmm2,%zmm3,%zmm2
  1751d5:	62 f2 ee 48 27 c1    	vptestnmq %zmm1,%zmm2,%k0
  1751db:	45 31 c9             	xor    %r9d,%r9d
  1751de:	c5 f9 98 c0          	kortestb %k0,%k0
  1751e2:	41 0f 94 c1          	sete   %r9b
  1751e6:	44 89 4c 81 04       	mov    %r9d,0x4(%rcx,%rax,4)
  1751eb:	48 83 c0 02          	add    $0x2,%rax
  1751ef:	49 39 c0             	cmp    %rax,%r8
  1751f2:	0f 85 58 ff ff ff    	jne    175150 <void inline_single_kernel<false, bloom_filters::Split64BloomFilter, unsigned long>(bloom_filters::Split64BloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
  1751f8:	40 f6 c6 01          	test   $0x1,%sil
  1751fc:	74 52                	je     175250 <void inline_single_kernel<false, bloom_filters::Split64BloomFilter, unsigned long>(bloom_filters::Split64BloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x140>
  1751fe:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  175202:	48 89 d6             	mov    %rdx,%rsi
  175205:	48 c1 ee 20          	shr    $0x20,%rsi
  175209:	23 77 18             	and    0x18(%rdi),%esi
  17520c:	62 f2 7d 28 7c c2    	vpbroadcastd %edx,%ymm0
  175212:	48 8b 17             	mov    (%rdi),%rdx
  175215:	48 c1 e6 06          	shl    $0x6,%rsi
  175219:	c4 e2 7d 40 05 fe f6 	vpmulld -0x170902(%rip),%ymm0,%ymm0        # 4920 <typeinfo name for main::$_60+0x150>
  175220:	e8 ff
  175222:	62 f1 fd 48 6f 0c 32 	vmovdqa64 (%rdx,%rsi,1),%zmm1
  175229:	c5 fd 72 d0 1a       	vpsrld $0x1a,%ymm0,%ymm0
  17522e:	62 f2 7d 48 35 c0    	vpmovzxdq %ymm0,%zmm0
  175234:	62 f2 f5 48 45 c0    	vpsrlvq %zmm0,%zmm1,%zmm0
  17523a:	62 f2 fe 58 27 05 14 	vptestnmq -0x171eec(%rip){1to8},%zmm0,%k0        # 3358 <_IO_stdin_used+0xa4>
  175241:	e1 e8 ff
  175244:	31 d2                	xor    %edx,%edx
  175246:	c5 f9 98 c0          	kortestb %k0,%k0
  17524a:	0f 94 c2             	sete   %dl
  17524d:	89 14 81             	mov    %edx,(%rcx,%rax,4)
  175250:	c5 f8 77             	vzeroupper
  175253:	c3                   	ret
  175254:	cc                   	int3
  175255:	cc                   	int3
  175256:	cc                   	int3
  175257:	cc                   	int3
  175258:	cc                   	int3
  175259:	cc                   	int3
  17525a:	cc                   	int3
  17525b:	cc                   	int3
  17525c:	cc                   	int3
  17525d:	cc                   	int3
  17525e:	cc                   	int3
  17525f:	cc                   	int3
