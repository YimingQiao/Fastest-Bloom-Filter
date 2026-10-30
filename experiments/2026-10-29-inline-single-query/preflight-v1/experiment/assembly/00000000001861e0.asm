00000000001861e0 <void inline_single_kernel<true, direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32>, unsigned long>(direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32> const&, unsigned long, unsigned long const*, unsigned int*)>:
  1861e0:	48 85 f6             	test   %rsi,%rsi
  1861e3:	0f 84 8b 01 00 00    	je     186374 <void inline_single_kernel<true, direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32>, unsigned long>(direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32> const&, unsigned long, unsigned long const*, unsigned int*)+0x194>
  1861e9:	53                   	push   %rbx
  1861ea:	49 b8 93 fd 59 66 b8 	movabs $0xd6e8feb86659fd93,%r8
  1861f1:	fe e8 d6
  1861f4:	48 83 fe 01          	cmp    $0x1,%rsi
  1861f8:	75 07                	jne    186201 <void inline_single_kernel<true, direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32>, unsigned long>(direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32> const&, unsigned long, unsigned long const*, unsigned int*)+0x21>
  1861fa:	31 c0                	xor    %eax,%eax
  1861fc:	e9 00 01 00 00       	jmp    186301 <void inline_single_kernel<true, direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32>, unsigned long>(direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32> const&, unsigned long, unsigned long const*, unsigned int*)+0x121>
  186201:	49 89 f1             	mov    %rsi,%r9
  186204:	49 83 e1 fe          	and    $0xfffffffffffffffe,%r9
  186208:	31 c0                	xor    %eax,%eax
  18620a:	c4 e2 79 59 05 e5 d0 	vpbroadcastq -0x182f1b(%rip),%xmm0        # 32f8 <_IO_stdin_used+0x44>
  186211:	e7 ff
  186213:	c4 e2 7d 58 0d 8c d0 	vpbroadcastd -0x182f74(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
  18621a:	e7 ff
  18621c:	0f 1f 40 00          	nopl   0x0(%rax)
  186220:	4c 8b 14 c2          	mov    (%rdx,%rax,8),%r10
  186224:	4d 89 d3             	mov    %r10,%r11
  186227:	49 c1 eb 20          	shr    $0x20,%r11
  18622b:	4d 31 d3             	xor    %r10,%r11
  18622e:	4d 0f af d8          	imul   %r8,%r11
  186232:	4d 89 da             	mov    %r11,%r10
  186235:	49 c1 ea 20          	shr    $0x20,%r10
  186239:	4d 31 da             	xor    %r11,%r10
  18623c:	4d 0f af d0          	imul   %r8,%r10
  186240:	4d 89 d3             	mov    %r10,%r11
  186243:	49 c1 eb 20          	shr    $0x20,%r11
  186247:	4d 31 d3             	xor    %r10,%r11
  18624a:	49 c1 ea 29          	shr    $0x29,%r10
  18624e:	44 23 57 18          	and    0x18(%rdi),%r10d
  186252:	48 8b 1f             	mov    (%rdi),%rbx
  186255:	41 c1 e2 05          	shl    $0x5,%r10d
  186259:	c4 a1 7d 6f 14 13    	vmovdqa (%rbx,%r10,1),%ymm2
  18625f:	62 d2 fd 08 7c db    	vpbroadcastq %r11,%xmm3
  186265:	62 f2 fd 08 83 db    	vpmultishiftqb %xmm3,%xmm0,%xmm3
  18626b:	c4 e2 7d 31 db       	vpmovzxbd %xmm3,%ymm3
  186270:	62 f2 75 28 15 db    	vprolvd %ymm3,%ymm1,%ymm3
  186276:	45 31 d2             	xor    %r10d,%r10d
  186279:	c4 e2 7d 17 d3       	vptest %ymm3,%ymm2
  18627e:	41 0f 92 c2          	setb   %r10b
  186282:	44 89 14 81          	mov    %r10d,(%rcx,%rax,4)
  186286:	4c 8b 54 c2 08       	mov    0x8(%rdx,%rax,8),%r10
  18628b:	4d 89 d3             	mov    %r10,%r11
  18628e:	49 c1 eb 20          	shr    $0x20,%r11
  186292:	4d 31 d3             	xor    %r10,%r11
  186295:	4d 0f af d8          	imul   %r8,%r11
  186299:	4d 89 da             	mov    %r11,%r10
  18629c:	49 c1 ea 20          	shr    $0x20,%r10
  1862a0:	4d 31 da             	xor    %r11,%r10
  1862a3:	4d 0f af d0          	imul   %r8,%r10
  1862a7:	4d 89 d3             	mov    %r10,%r11
  1862aa:	49 c1 eb 20          	shr    $0x20,%r11
  1862ae:	4d 31 d3             	xor    %r10,%r11
  1862b1:	49 c1 ea 29          	shr    $0x29,%r10
  1862b5:	44 23 57 18          	and    0x18(%rdi),%r10d
  1862b9:	48 8b 1f             	mov    (%rdi),%rbx
  1862bc:	41 c1 e2 05          	shl    $0x5,%r10d
  1862c0:	c4 a1 7d 6f 14 13    	vmovdqa (%rbx,%r10,1),%ymm2
  1862c6:	62 d2 fd 08 7c db    	vpbroadcastq %r11,%xmm3
  1862cc:	62 f2 fd 08 83 db    	vpmultishiftqb %xmm3,%xmm0,%xmm3
  1862d2:	c4 e2 7d 31 db       	vpmovzxbd %xmm3,%ymm3
  1862d7:	62 f2 75 28 15 db    	vprolvd %ymm3,%ymm1,%ymm3
  1862dd:	45 31 d2             	xor    %r10d,%r10d
  1862e0:	c4 e2 7d 17 d3       	vptest %ymm3,%ymm2
  1862e5:	41 0f 92 c2          	setb   %r10b
  1862e9:	44 89 54 81 04       	mov    %r10d,0x4(%rcx,%rax,4)
  1862ee:	48 83 c0 02          	add    $0x2,%rax
  1862f2:	49 39 c1             	cmp    %rax,%r9
  1862f5:	0f 85 25 ff ff ff    	jne    186220 <void inline_single_kernel<true, direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32>, unsigned long>(direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
  1862fb:	40 f6 c6 01          	test   $0x1,%sil
  1862ff:	74 72                	je     186373 <void inline_single_kernel<true, direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32>, unsigned long>(direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32> const&, unsigned long, unsigned long const*, unsigned int*)+0x193>
  186301:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  186305:	48 89 d6             	mov    %rdx,%rsi
  186308:	48 c1 ee 20          	shr    $0x20,%rsi
  18630c:	48 31 d6             	xor    %rdx,%rsi
  18630f:	49 0f af f0          	imul   %r8,%rsi
  186313:	48 89 f2             	mov    %rsi,%rdx
  186316:	48 c1 ea 20          	shr    $0x20,%rdx
  18631a:	48 31 f2             	xor    %rsi,%rdx
  18631d:	49 0f af d0          	imul   %r8,%rdx
  186321:	48 89 d6             	mov    %rdx,%rsi
  186324:	48 c1 ee 20          	shr    $0x20,%rsi
  186328:	48 31 d6             	xor    %rdx,%rsi
  18632b:	48 c1 ea 29          	shr    $0x29,%rdx
  18632f:	23 57 18             	and    0x18(%rdi),%edx
  186332:	48 8b 3f             	mov    (%rdi),%rdi
  186335:	c1 e2 05             	shl    $0x5,%edx
  186338:	c5 fd 6f 04 17       	vmovdqa (%rdi,%rdx,1),%ymm0
  18633d:	62 f2 fd 08 7c ce    	vpbroadcastq %rsi,%xmm1
  186343:	c4 e2 79 59 15 ac cf 	vpbroadcastq -0x183054(%rip),%xmm2        # 32f8 <_IO_stdin_used+0x44>
  18634a:	e7 ff
  18634c:	62 f2 ed 08 83 c9    	vpmultishiftqb %xmm1,%xmm2,%xmm1
  186352:	c4 e2 7d 31 c9       	vpmovzxbd %xmm1,%ymm1
  186357:	c4 e2 7d 58 15 48 cf 	vpbroadcastd -0x1830b8(%rip),%ymm2        # 32a8 <__abi_tag+0x2fe4>
  18635e:	e7 ff
  186360:	62 f2 6d 28 15 c9    	vprolvd %ymm1,%ymm2,%ymm1
  186366:	31 d2                	xor    %edx,%edx
  186368:	c4 e2 7d 17 c1       	vptest %ymm1,%ymm0
  18636d:	0f 92 c2             	setb   %dl
  186370:	89 14 81             	mov    %edx,(%rcx,%rax,4)
  186373:	5b                   	pop    %rbx
  186374:	c5 f8 77             	vzeroupper
  186377:	c3                   	ret
  186378:	cc                   	int3
  186379:	cc                   	int3
  18637a:	cc                   	int3
  18637b:	cc                   	int3
  18637c:	cc                   	int3
  18637d:	cc                   	int3
  18637e:	cc                   	int3
  18637f:	cc                   	int3
