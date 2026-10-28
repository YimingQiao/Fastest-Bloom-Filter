00000000001802a0 <void inline_single_kernel<false, independent_vbmi_experiment::IndependentVbmi32, unsigned long>(independent_vbmi_experiment::IndependentVbmi32 const&, unsigned long, unsigned long const*, unsigned int*)>:
  1802a0:	48 85 f6             	test   %rsi,%rsi
  1802a3:	0f 84 bf 01 00 00    	je     180468 <void inline_single_kernel<false, independent_vbmi_experiment::IndependentVbmi32, unsigned long>(independent_vbmi_experiment::IndependentVbmi32 const&, unsigned long, unsigned long const*, unsigned int*)+0x1c8>
  1802a9:	89 f0                	mov    %esi,%eax
  1802ab:	83 e0 03             	and    $0x3,%eax
  1802ae:	48 83 fe 04          	cmp    $0x4,%rsi
  1802b2:	73 08                	jae    1802bc <void inline_single_kernel<false, independent_vbmi_experiment::IndependentVbmi32, unsigned long>(independent_vbmi_experiment::IndependentVbmi32 const&, unsigned long, unsigned long const*, unsigned int*)+0x1c>
  1802b4:	45 31 c0             	xor    %r8d,%r8d
  1802b7:	e9 3c 01 00 00       	jmp    1803f8 <void inline_single_kernel<false, independent_vbmi_experiment::IndependentVbmi32, unsigned long>(independent_vbmi_experiment::IndependentVbmi32 const&, unsigned long, unsigned long const*, unsigned int*)+0x158>
  1802bc:	48 83 e6 fc          	and    $0xfffffffffffffffc,%rsi
  1802c0:	45 31 c0             	xor    %r8d,%r8d
  1802c3:	c4 e2 79 59 05 2c 30 	vpbroadcastq -0x17cfd4(%rip),%xmm0        # 32f8 <_IO_stdin_used+0x44>
  1802ca:	e8 ff
  1802cc:	c4 e2 7d 58 0d d3 2f 	vpbroadcastd -0x17d02d(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
  1802d3:	e8 ff
  1802d5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  1802dc:	00 00 00 00
  1802e0:	4e 8b 0c c2          	mov    (%rdx,%r8,8),%r9
  1802e4:	62 d2 fd 08 7c d1    	vpbroadcastq %r9,%xmm2
  1802ea:	49 c1 e9 29          	shr    $0x29,%r9
  1802ee:	44 23 4f 18          	and    0x18(%rdi),%r9d
  1802f2:	4c 8b 17             	mov    (%rdi),%r10
  1802f5:	41 c1 e1 05          	shl    $0x5,%r9d
  1802f9:	c4 81 7d 6f 1c 0a    	vmovdqa (%r10,%r9,1),%ymm3
  1802ff:	62 f2 fd 08 83 d2    	vpmultishiftqb %xmm2,%xmm0,%xmm2
  180305:	c4 e2 7d 31 d2       	vpmovzxbd %xmm2,%ymm2
  18030a:	62 f2 75 28 15 d2    	vprolvd %ymm2,%ymm1,%ymm2
  180310:	45 31 c9             	xor    %r9d,%r9d
  180313:	c4 e2 7d 17 da       	vptest %ymm2,%ymm3
  180318:	41 0f 92 c1          	setb   %r9b
  18031c:	46 89 0c 81          	mov    %r9d,(%rcx,%r8,4)
  180320:	4e 8b 4c c2 08       	mov    0x8(%rdx,%r8,8),%r9
  180325:	62 d2 fd 08 7c d1    	vpbroadcastq %r9,%xmm2
  18032b:	49 c1 e9 29          	shr    $0x29,%r9
  18032f:	44 23 4f 18          	and    0x18(%rdi),%r9d
  180333:	4c 8b 17             	mov    (%rdi),%r10
  180336:	41 c1 e1 05          	shl    $0x5,%r9d
  18033a:	c4 81 7d 6f 1c 0a    	vmovdqa (%r10,%r9,1),%ymm3
  180340:	62 f2 fd 08 83 d2    	vpmultishiftqb %xmm2,%xmm0,%xmm2
  180346:	c4 e2 7d 31 d2       	vpmovzxbd %xmm2,%ymm2
  18034b:	62 f2 75 28 15 d2    	vprolvd %ymm2,%ymm1,%ymm2
  180351:	45 31 c9             	xor    %r9d,%r9d
  180354:	c4 e2 7d 17 da       	vptest %ymm2,%ymm3
  180359:	41 0f 92 c1          	setb   %r9b
  18035d:	46 89 4c 81 04       	mov    %r9d,0x4(%rcx,%r8,4)
  180362:	4e 8b 4c c2 10       	mov    0x10(%rdx,%r8,8),%r9
  180367:	62 d2 fd 08 7c d1    	vpbroadcastq %r9,%xmm2
  18036d:	49 c1 e9 29          	shr    $0x29,%r9
  180371:	44 23 4f 18          	and    0x18(%rdi),%r9d
  180375:	4c 8b 17             	mov    (%rdi),%r10
  180378:	41 c1 e1 05          	shl    $0x5,%r9d
  18037c:	c4 81 7d 6f 1c 0a    	vmovdqa (%r10,%r9,1),%ymm3
  180382:	62 f2 fd 08 83 d2    	vpmultishiftqb %xmm2,%xmm0,%xmm2
  180388:	c4 e2 7d 31 d2       	vpmovzxbd %xmm2,%ymm2
  18038d:	62 f2 75 28 15 d2    	vprolvd %ymm2,%ymm1,%ymm2
  180393:	45 31 c9             	xor    %r9d,%r9d
  180396:	c4 e2 7d 17 da       	vptest %ymm2,%ymm3
  18039b:	41 0f 92 c1          	setb   %r9b
  18039f:	46 89 4c 81 08       	mov    %r9d,0x8(%rcx,%r8,4)
  1803a4:	4e 8b 4c c2 18       	mov    0x18(%rdx,%r8,8),%r9
  1803a9:	62 d2 fd 08 7c d1    	vpbroadcastq %r9,%xmm2
  1803af:	49 c1 e9 29          	shr    $0x29,%r9
  1803b3:	44 23 4f 18          	and    0x18(%rdi),%r9d
  1803b7:	4c 8b 17             	mov    (%rdi),%r10
  1803ba:	41 c1 e1 05          	shl    $0x5,%r9d
  1803be:	c4 81 7d 6f 1c 0a    	vmovdqa (%r10,%r9,1),%ymm3
  1803c4:	62 f2 fd 08 83 d2    	vpmultishiftqb %xmm2,%xmm0,%xmm2
  1803ca:	c4 e2 7d 31 d2       	vpmovzxbd %xmm2,%ymm2
  1803cf:	62 f2 75 28 15 d2    	vprolvd %ymm2,%ymm1,%ymm2
  1803d5:	45 31 c9             	xor    %r9d,%r9d
  1803d8:	c4 e2 7d 17 da       	vptest %ymm2,%ymm3
  1803dd:	41 0f 92 c1          	setb   %r9b
  1803e1:	46 89 4c 81 0c       	mov    %r9d,0xc(%rcx,%r8,4)
  1803e6:	49 83 c0 04          	add    $0x4,%r8
  1803ea:	4c 39 c6             	cmp    %r8,%rsi
  1803ed:	0f 85 ed fe ff ff    	jne    1802e0 <void inline_single_kernel<false, independent_vbmi_experiment::IndependentVbmi32, unsigned long>(independent_vbmi_experiment::IndependentVbmi32 const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
  1803f3:	48 85 c0             	test   %rax,%rax
  1803f6:	74 70                	je     180468 <void inline_single_kernel<false, independent_vbmi_experiment::IndependentVbmi32, unsigned long>(independent_vbmi_experiment::IndependentVbmi32 const&, unsigned long, unsigned long const*, unsigned int*)+0x1c8>
  1803f8:	4a 8d 0c 81          	lea    (%rcx,%r8,4),%rcx
  1803fc:	4a 8d 14 c2          	lea    (%rdx,%r8,8),%rdx
  180400:	31 f6                	xor    %esi,%esi
  180402:	c4 e2 79 59 05 ed 2e 	vpbroadcastq -0x17d113(%rip),%xmm0        # 32f8 <_IO_stdin_used+0x44>
  180409:	e8 ff
  18040b:	c4 e2 7d 58 0d 94 2e 	vpbroadcastd -0x17d16c(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
  180412:	e8 ff
  180414:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  18041b:	00 00 00 00 00
  180420:	4c 8b 04 f2          	mov    (%rdx,%rsi,8),%r8
  180424:	62 d2 fd 08 7c d0    	vpbroadcastq %r8,%xmm2
  18042a:	49 c1 e8 29          	shr    $0x29,%r8
  18042e:	44 23 47 18          	and    0x18(%rdi),%r8d
  180432:	4c 8b 0f             	mov    (%rdi),%r9
  180435:	41 c1 e0 05          	shl    $0x5,%r8d
  180439:	c4 81 7d 6f 1c 01    	vmovdqa (%r9,%r8,1),%ymm3
  18043f:	62 f2 fd 08 83 d2    	vpmultishiftqb %xmm2,%xmm0,%xmm2
  180445:	c4 e2 7d 31 d2       	vpmovzxbd %xmm2,%ymm2
  18044a:	62 f2 75 28 15 d2    	vprolvd %ymm2,%ymm1,%ymm2
  180450:	45 31 c0             	xor    %r8d,%r8d
  180453:	c4 e2 7d 17 da       	vptest %ymm2,%ymm3
  180458:	41 0f 92 c0          	setb   %r8b
  18045c:	44 89 04 b1          	mov    %r8d,(%rcx,%rsi,4)
  180460:	48 ff c6             	inc    %rsi
  180463:	48 39 f0             	cmp    %rsi,%rax
  180466:	75 b8                	jne    180420 <void inline_single_kernel<false, independent_vbmi_experiment::IndependentVbmi32, unsigned long>(independent_vbmi_experiment::IndependentVbmi32 const&, unsigned long, unsigned long const*, unsigned int*)+0x180>
  180468:	c5 f8 77             	vzeroupper
  18046b:	c3                   	ret
  18046c:	cc                   	int3
  18046d:	cc                   	int3
  18046e:	cc                   	int3
  18046f:	cc                   	int3
