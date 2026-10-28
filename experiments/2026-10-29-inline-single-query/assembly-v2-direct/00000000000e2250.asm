00000000000e2250 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
   e2250:	test   %rsi,%rsi
   e2253:	je     e2389 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x139>
   e2259:	push   %rbx
   e225a:	mov    %rdx,%rax
   e225d:	movabs $0xf1357aea2e62a9c5,%r9
   e2267:	cmp    $0x1,%rsi
   e226b:	jne    e2275 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x25>
   e226d:	xor    %r8d,%r8d
   e2270:	jmp    e2335 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0xe5>
   e2275:	mov    %rsi,%r10
   e2278:	and    $0xfffffffffffffffe,%r10
   e227c:	xor    %r8d,%r8d
   e227f:	vmovdqa -0xdd747(%rip),%ymm0        # 4b40 <typeinfo name for main::$_60+0x370>
   e2287:	vpbroadcastd -0xdefe8(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
   e2290:	mov    (%rax,%r8,8),%rdx
   e2294:	or     $0x1,%rdx
   e2298:	mov    0x20(%rdi),%r11
   e229c:	mulx   0x10(%rdi),%rbx,%rbx
   e22a2:	imul   %r9,%rdx
   e22a6:	shl    $0x5,%rbx
   e22aa:	prefetcht0 (%r11,%rbx,1)
   e22af:	vmovdqa (%r11,%rbx,1),%ymm2
   e22b5:	vpbroadcastq %rdx,%ymm3
   e22bb:	vpsllvq %ymm0,%ymm3,%ymm3
   e22c0:	vpsrld $0x1b,%ymm3,%ymm3
   e22c5:	vpsllvd %ymm3,%ymm1,%ymm3
   e22ca:	xor    %edx,%edx
   e22cc:	vptest %ymm3,%ymm2
   e22d1:	setb   %dl
   e22d4:	mov    %edx,(%rcx,%r8,4)
   e22d8:	mov    0x8(%rax,%r8,8),%rdx
   e22dd:	or     $0x1,%rdx
   e22e1:	mov    0x20(%rdi),%r11
   e22e5:	mulx   0x10(%rdi),%rbx,%rbx
   e22eb:	imul   %r9,%rdx
   e22ef:	shl    $0x5,%rbx
   e22f3:	prefetcht0 (%r11,%rbx,1)
   e22f8:	vmovdqa (%r11,%rbx,1),%ymm2
   e22fe:	vpbroadcastq %rdx,%ymm3
   e2304:	vpsllvq %ymm0,%ymm3,%ymm3
   e2309:	vpsrld $0x1b,%ymm3,%ymm3
   e230e:	vpsllvd %ymm3,%ymm1,%ymm3
   e2313:	xor    %edx,%edx
   e2315:	vptest %ymm3,%ymm2
   e231a:	setb   %dl
   e231d:	mov    %edx,0x4(%rcx,%r8,4)
   e2322:	add    $0x2,%r8
   e2326:	cmp    %r8,%r10
   e2329:	jne    e2290 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
   e232f:	test   $0x1,%sil
   e2333:	je     e2388 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x138>
   e2335:	mov    (%rax,%r8,8),%rdx
   e2339:	or     $0x1,%rdx
   e233d:	mov    0x20(%rdi),%rax
   e2341:	mulx   0x10(%rdi),%rsi,%rsi
   e2347:	imul   %r9,%rdx
   e234b:	shl    $0x5,%rsi
   e234f:	prefetcht0 (%rax,%rsi,1)
   e2353:	vmovdqa (%rax,%rsi,1),%ymm0
   e2358:	vpbroadcastq %rdx,%ymm1
   e235e:	vpsllvq -0xdd827(%rip),%ymm1,%ymm1        # 4b40 <typeinfo name for main::$_60+0x370>
   e2367:	vpsrld $0x1b,%ymm1,%ymm1
   e236c:	vpbroadcastd -0xdf0cd(%rip),%ymm2        # 32a8 <__abi_tag+0x2fe4>
   e2375:	vpsllvd %ymm1,%ymm2,%ymm1
   e237a:	xor    %eax,%eax
   e237c:	vptest %ymm1,%ymm0
   e2381:	setb   %al
   e2384:	mov    %eax,(%rcx,%r8,4)
   e2388:	pop    %rbx
   e2389:	vzeroupper
   e238c:	ret
   e238d:	int3
   e238e:	int3
   e238f:	int3

