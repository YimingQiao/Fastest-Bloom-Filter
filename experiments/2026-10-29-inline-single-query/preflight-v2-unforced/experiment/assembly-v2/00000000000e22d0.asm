00000000000e22d0 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
   e22d0:	test   %rsi,%rsi
   e22d3:	je     e2409 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x139>
   e22d9:	push   %rbx
   e22da:	mov    %rdx,%rax
   e22dd:	movabs $0xf1357aea2e62a9c5,%r9
   e22e7:	cmp    $0x1,%rsi
   e22eb:	jne    e22f5 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x25>
   e22ed:	xor    %r8d,%r8d
   e22f0:	jmp    e23b5 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0xe5>
   e22f5:	mov    %rsi,%r10
   e22f8:	and    $0xfffffffffffffffe,%r10
   e22fc:	xor    %r8d,%r8d
   e22ff:	vmovdqa -0xdd7c7(%rip),%ymm0        # 4b40 <typeinfo name for main::$_60+0x370>
   e2307:	vpbroadcastd -0xdf068(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
   e2310:	mov    (%rax,%r8,8),%rdx
   e2314:	or     $0x1,%rdx
   e2318:	mov    0x20(%rdi),%r11
   e231c:	mulx   0x10(%rdi),%rbx,%rbx
   e2322:	imul   %r9,%rdx
   e2326:	shl    $0x5,%rbx
   e232a:	prefetcht0 (%r11,%rbx,1)
   e232f:	vmovdqa (%r11,%rbx,1),%ymm2
   e2335:	vpbroadcastq %rdx,%ymm3
   e233b:	vpsllvq %ymm0,%ymm3,%ymm3
   e2340:	vpsrld $0x1b,%ymm3,%ymm3
   e2345:	vpsllvd %ymm3,%ymm1,%ymm3
   e234a:	xor    %edx,%edx
   e234c:	vptest %ymm3,%ymm2
   e2351:	setb   %dl
   e2354:	mov    %edx,(%rcx,%r8,4)
   e2358:	mov    0x8(%rax,%r8,8),%rdx
   e235d:	or     $0x1,%rdx
   e2361:	mov    0x20(%rdi),%r11
   e2365:	mulx   0x10(%rdi),%rbx,%rbx
   e236b:	imul   %r9,%rdx
   e236f:	shl    $0x5,%rbx
   e2373:	prefetcht0 (%r11,%rbx,1)
   e2378:	vmovdqa (%r11,%rbx,1),%ymm2
   e237e:	vpbroadcastq %rdx,%ymm3
   e2384:	vpsllvq %ymm0,%ymm3,%ymm3
   e2389:	vpsrld $0x1b,%ymm3,%ymm3
   e238e:	vpsllvd %ymm3,%ymm1,%ymm3
   e2393:	xor    %edx,%edx
   e2395:	vptest %ymm3,%ymm2
   e239a:	setb   %dl
   e239d:	mov    %edx,0x4(%rcx,%r8,4)
   e23a2:	add    $0x2,%r8
   e23a6:	cmp    %r8,%r10
   e23a9:	jne    e2310 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
   e23af:	test   $0x1,%sil
   e23b3:	je     e2408 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x138>
   e23b5:	mov    (%rax,%r8,8),%rdx
   e23b9:	or     $0x1,%rdx
   e23bd:	mov    0x20(%rdi),%rax
   e23c1:	mulx   0x10(%rdi),%rsi,%rsi
   e23c7:	imul   %r9,%rdx
   e23cb:	shl    $0x5,%rsi
   e23cf:	prefetcht0 (%rax,%rsi,1)
   e23d3:	vmovdqa (%rax,%rsi,1),%ymm0
   e23d8:	vpbroadcastq %rdx,%ymm1
   e23de:	vpsllvq -0xdd8a7(%rip),%ymm1,%ymm1        # 4b40 <typeinfo name for main::$_60+0x370>
   e23e7:	vpsrld $0x1b,%ymm1,%ymm1
   e23ec:	vpbroadcastd -0xdf14d(%rip),%ymm2        # 32a8 <__abi_tag+0x2fe4>
   e23f5:	vpsllvd %ymm1,%ymm2,%ymm1
   e23fa:	xor    %eax,%eax
   e23fc:	vptest %ymm1,%ymm0
   e2401:	setb   %al
   e2404:	mov    %eax,(%rcx,%r8,4)
   e2408:	pop    %rbx
   e2409:	vzeroupper
   e240c:	ret
   e240d:	int3
   e240e:	int3
   e240f:	int3

