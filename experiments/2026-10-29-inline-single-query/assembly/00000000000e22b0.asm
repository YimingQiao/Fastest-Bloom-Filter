00000000000e22b0 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
   e22b0:	48 85 f6             	test   %rsi,%rsi
   e22b3:	0f 84 30 01 00 00    	je     e23e9 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x139>
   e22b9:	53                   	push   %rbx
   e22ba:	48 89 d0             	mov    %rdx,%rax
   e22bd:	49 b9 c5 a9 62 2e ea 	movabs $0xf1357aea2e62a9c5,%r9
   e22c4:	7a 35 f1
   e22c7:	48 83 fe 01          	cmp    $0x1,%rsi
   e22cb:	75 08                	jne    e22d5 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x25>
   e22cd:	45 31 c0             	xor    %r8d,%r8d
   e22d0:	e9 c0 00 00 00       	jmp    e2395 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0xe5>
   e22d5:	49 89 f2             	mov    %rsi,%r10
   e22d8:	49 83 e2 fe          	and    $0xfffffffffffffffe,%r10
   e22dc:	45 31 c0             	xor    %r8d,%r8d
   e22df:	c5 fd 6f 05 59 28 f2 	vmovdqa -0xdd7a7(%rip),%ymm0        # 4b40 <typeinfo name for main::$_60+0x370>
   e22e6:	ff
   e22e7:	c4 e2 7d 58 0d b8 0f 	vpbroadcastd -0xdf048(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
   e22ee:	f2 ff
   e22f0:	4a 8b 14 c0          	mov    (%rax,%r8,8),%rdx
   e22f4:	48 83 ca 01          	or     $0x1,%rdx
   e22f8:	4c 8b 5f 20          	mov    0x20(%rdi),%r11
   e22fc:	c4 e2 e3 f6 5f 10    	mulx   0x10(%rdi),%rbx,%rbx
   e2302:	49 0f af d1          	imul   %r9,%rdx
   e2306:	48 c1 e3 05          	shl    $0x5,%rbx
   e230a:	41 0f 18 0c 1b       	prefetcht0 (%r11,%rbx,1)
   e230f:	c4 c1 7d 6f 14 1b    	vmovdqa (%r11,%rbx,1),%ymm2
   e2315:	62 f2 fd 28 7c da    	vpbroadcastq %rdx,%ymm3
   e231b:	c4 e2 e5 47 d8       	vpsllvq %ymm0,%ymm3,%ymm3
   e2320:	c5 e5 72 d3 1b       	vpsrld $0x1b,%ymm3,%ymm3
   e2325:	c4 e2 75 47 db       	vpsllvd %ymm3,%ymm1,%ymm3
   e232a:	31 d2                	xor    %edx,%edx
   e232c:	c4 e2 7d 17 d3       	vptest %ymm3,%ymm2
   e2331:	0f 92 c2             	setb   %dl
   e2334:	42 89 14 81          	mov    %edx,(%rcx,%r8,4)
   e2338:	4a 8b 54 c0 08       	mov    0x8(%rax,%r8,8),%rdx
   e233d:	48 83 ca 01          	or     $0x1,%rdx
   e2341:	4c 8b 5f 20          	mov    0x20(%rdi),%r11
   e2345:	c4 e2 e3 f6 5f 10    	mulx   0x10(%rdi),%rbx,%rbx
   e234b:	49 0f af d1          	imul   %r9,%rdx
   e234f:	48 c1 e3 05          	shl    $0x5,%rbx
   e2353:	41 0f 18 0c 1b       	prefetcht0 (%r11,%rbx,1)
   e2358:	c4 c1 7d 6f 14 1b    	vmovdqa (%r11,%rbx,1),%ymm2
   e235e:	62 f2 fd 28 7c da    	vpbroadcastq %rdx,%ymm3
   e2364:	c4 e2 e5 47 d8       	vpsllvq %ymm0,%ymm3,%ymm3
   e2369:	c5 e5 72 d3 1b       	vpsrld $0x1b,%ymm3,%ymm3
   e236e:	c4 e2 75 47 db       	vpsllvd %ymm3,%ymm1,%ymm3
   e2373:	31 d2                	xor    %edx,%edx
   e2375:	c4 e2 7d 17 d3       	vptest %ymm3,%ymm2
   e237a:	0f 92 c2             	setb   %dl
   e237d:	42 89 54 81 04       	mov    %edx,0x4(%rcx,%r8,4)
   e2382:	49 83 c0 02          	add    $0x2,%r8
   e2386:	4d 39 c2             	cmp    %r8,%r10
   e2389:	0f 85 61 ff ff ff    	jne    e22f0 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
   e238f:	40 f6 c6 01          	test   $0x1,%sil
   e2393:	74 53                	je     e23e8 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x138>
   e2395:	4a 8b 14 c0          	mov    (%rax,%r8,8),%rdx
   e2399:	48 83 ca 01          	or     $0x1,%rdx
   e239d:	48 8b 47 20          	mov    0x20(%rdi),%rax
   e23a1:	c4 e2 cb f6 77 10    	mulx   0x10(%rdi),%rsi,%rsi
   e23a7:	49 0f af d1          	imul   %r9,%rdx
   e23ab:	48 c1 e6 05          	shl    $0x5,%rsi
   e23af:	0f 18 0c 30          	prefetcht0 (%rax,%rsi,1)
   e23b3:	c5 fd 6f 04 30       	vmovdqa (%rax,%rsi,1),%ymm0
   e23b8:	62 f2 fd 28 7c ca    	vpbroadcastq %rdx,%ymm1
   e23be:	c4 e2 f5 47 0d 79 27 	vpsllvq -0xdd887(%rip),%ymm1,%ymm1        # 4b40 <typeinfo name for main::$_60+0x370>
   e23c5:	f2 ff
   e23c7:	c5 f5 72 d1 1b       	vpsrld $0x1b,%ymm1,%ymm1
   e23cc:	c4 e2 7d 58 15 d3 0e 	vpbroadcastd -0xdf12d(%rip),%ymm2        # 32a8 <__abi_tag+0x2fe4>
   e23d3:	f2 ff
   e23d5:	c4 e2 6d 47 c9       	vpsllvd %ymm1,%ymm2,%ymm1
   e23da:	31 c0                	xor    %eax,%eax
   e23dc:	c4 e2 7d 17 c1       	vptest %ymm1,%ymm0
   e23e1:	0f 92 c0             	setb   %al
   e23e4:	42 89 04 81          	mov    %eax,(%rcx,%r8,4)
   e23e8:	5b                   	pop    %rbx
   e23e9:	c5 f8 77             	vzeroupper
   e23ec:	c3                   	ret
   e23ed:	cc                   	int3
   e23ee:	cc                   	int3
   e23ef:	cc                   	int3
