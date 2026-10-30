000000000018c490 <void inline_single_kernel<false, direct_split_experiment::IndependentSplit32, unsigned long>(direct_split_experiment::IndependentSplit32 const&, unsigned long, unsigned long const*, unsigned int*)>:
  18c490:	test   %rsi,%rsi
  18c493:	je     18c6a2 <void inline_single_kernel<false, direct_split_experiment::IndependentSplit32, unsigned long>(direct_split_experiment::IndependentSplit32 const&, unsigned long, unsigned long const*, unsigned int*)+0x212>
  18c499:	mov    %esi,%eax
  18c49b:	and    $0x3,%eax
  18c49e:	cmp    $0x4,%rsi
  18c4a2:	jae    18c4ac <void inline_single_kernel<false, direct_split_experiment::IndependentSplit32, unsigned long>(direct_split_experiment::IndependentSplit32 const&, unsigned long, unsigned long const*, unsigned int*)+0x1c>
  18c4a4:	xor    %r8d,%r8d
  18c4a7:	jmp    18c61e <void inline_single_kernel<false, direct_split_experiment::IndependentSplit32, unsigned long>(direct_split_experiment::IndependentSplit32 const&, unsigned long, unsigned long const*, unsigned int*)+0x18e>
  18c4ac:	and    $0xfffffffffffffffc,%rsi
  18c4b0:	xor    %r8d,%r8d
  18c4b3:	vmovdqa -0x18799b(%rip),%ymm0        # 4b20 <typeinfo name for main::$_60+0x350>
  18c4bb:	vpbroadcastq -0x1890b4(%rip),%ymm1        # 3410 <_IO_stdin_used+0x15c>
  18c4c4:	vpbroadcastd -0x189229(%rip),%ymm2        # 32a4 <__abi_tag+0x2fe0>
  18c4cd:	vpbroadcastd -0x18922e(%rip),%ymm3        # 32a8 <__abi_tag+0x2fe4>
  18c4d6:	cs nopw 0x0(%rax,%rax,1)
  18c4e0:	mov    (%rdx,%r8,8),%r9
  18c4e4:	mov    %r9,%r10
  18c4e7:	shr    $0x29,%r10
  18c4eb:	and    0x18(%rdi),%r10d
  18c4ef:	vpbroadcastq %r9,%ymm4
  18c4f5:	mov    (%rdi),%r9
  18c4f8:	shl    $0x5,%r10d
  18c4fc:	vmovdqa (%r9,%r10,1),%ymm5
  18c502:	vpsrlvq %ymm0,%ymm4,%ymm4
  18c507:	vpshufd $0xa0,%ymm4,%ymm4
  18c50c:	vpsrlvd %ymm1,%ymm4,%ymm4
  18c511:	vpand  %ymm2,%ymm4,%ymm4
  18c515:	vpsllvd %ymm4,%ymm3,%ymm4
  18c51a:	xor    %r9d,%r9d
  18c51d:	vptest %ymm4,%ymm5
  18c522:	setb   %r9b
  18c526:	mov    %r9d,(%rcx,%r8,4)
  18c52a:	mov    0x8(%rdx,%r8,8),%r9
  18c52f:	vpbroadcastq %r9,%ymm4
  18c535:	shr    $0x29,%r9
  18c539:	and    0x18(%rdi),%r9d
  18c53d:	mov    (%rdi),%r10
  18c540:	shl    $0x5,%r9d
  18c544:	vmovdqa (%r10,%r9,1),%ymm5
  18c54a:	vpsrlvq %ymm0,%ymm4,%ymm4
  18c54f:	vpshufd $0xa0,%ymm4,%ymm4
  18c554:	vpsrlvd %ymm1,%ymm4,%ymm4
  18c559:	vpand  %ymm2,%ymm4,%ymm4
  18c55d:	vpsllvd %ymm4,%ymm3,%ymm4
  18c562:	xor    %r9d,%r9d
  18c565:	vptest %ymm4,%ymm5
  18c56a:	setb   %r9b
  18c56e:	mov    %r9d,0x4(%rcx,%r8,4)
  18c573:	mov    0x10(%rdx,%r8,8),%r9
  18c578:	vpbroadcastq %r9,%ymm4
  18c57e:	shr    $0x29,%r9
  18c582:	and    0x18(%rdi),%r9d
  18c586:	mov    (%rdi),%r10
  18c589:	shl    $0x5,%r9d
  18c58d:	vmovdqa (%r10,%r9,1),%ymm5
  18c593:	vpsrlvq %ymm0,%ymm4,%ymm4
  18c598:	vpshufd $0xa0,%ymm4,%ymm4
  18c59d:	vpsrlvd %ymm1,%ymm4,%ymm4
  18c5a2:	vpand  %ymm2,%ymm4,%ymm4
  18c5a6:	vpsllvd %ymm4,%ymm3,%ymm4
  18c5ab:	xor    %r9d,%r9d
  18c5ae:	vptest %ymm4,%ymm5
  18c5b3:	setb   %r9b
  18c5b7:	mov    %r9d,0x8(%rcx,%r8,4)
  18c5bc:	mov    0x18(%rdx,%r8,8),%r9
  18c5c1:	mov    %r9,%r10
  18c5c4:	shr    $0x29,%r10
  18c5c8:	and    0x18(%rdi),%r10d
  18c5cc:	vpbroadcastq %r9,%ymm4
  18c5d2:	mov    (%rdi),%r9
  18c5d5:	shl    $0x5,%r10d
  18c5d9:	vmovdqa (%r9,%r10,1),%ymm5
  18c5df:	vpsrlvq %ymm0,%ymm4,%ymm4
  18c5e4:	vpshufd $0xa0,%ymm4,%ymm4
  18c5e9:	vpsrlvd %ymm1,%ymm4,%ymm4
  18c5ee:	vpand  %ymm2,%ymm4,%ymm4
  18c5f2:	vpsllvd %ymm4,%ymm3,%ymm4
  18c5f7:	xor    %r9d,%r9d
  18c5fa:	vptest %ymm4,%ymm5
  18c5ff:	setb   %r9b
  18c603:	mov    %r9d,0xc(%rcx,%r8,4)
  18c608:	add    $0x4,%r8
  18c60c:	cmp    %r8,%rsi
  18c60f:	jne    18c4e0 <void inline_single_kernel<false, direct_split_experiment::IndependentSplit32, unsigned long>(direct_split_experiment::IndependentSplit32 const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  18c615:	test   %rax,%rax
  18c618:	je     18c6a2 <void inline_single_kernel<false, direct_split_experiment::IndependentSplit32, unsigned long>(direct_split_experiment::IndependentSplit32 const&, unsigned long, unsigned long const*, unsigned int*)+0x212>
  18c61e:	lea    (%rcx,%r8,4),%rcx
  18c622:	lea    (%rdx,%r8,8),%rdx
  18c626:	xor    %esi,%esi
  18c628:	vmovdqa -0x187b10(%rip),%ymm0        # 4b20 <typeinfo name for main::$_60+0x350>
  18c630:	vpbroadcastq -0x189229(%rip),%ymm1        # 3410 <_IO_stdin_used+0x15c>
  18c639:	vpbroadcastd -0x18939e(%rip),%ymm2        # 32a4 <__abi_tag+0x2fe0>
  18c642:	vpbroadcastd -0x1893a3(%rip),%ymm3        # 32a8 <__abi_tag+0x2fe4>
  18c64b:	nopl   0x0(%rax,%rax,1)
  18c650:	mov    (%rdx,%rsi,8),%r8
  18c654:	mov    %r8,%r9
  18c657:	shr    $0x29,%r9
  18c65b:	and    0x18(%rdi),%r9d
  18c65f:	vpbroadcastq %r8,%ymm4
  18c665:	mov    (%rdi),%r8
  18c668:	shl    $0x5,%r9d
  18c66c:	vmovdqa (%r8,%r9,1),%ymm5
  18c672:	vpsrlvq %ymm0,%ymm4,%ymm4
  18c677:	vpshufd $0xa0,%ymm4,%ymm4
  18c67c:	vpsrlvd %ymm1,%ymm4,%ymm4
  18c681:	vpand  %ymm2,%ymm4,%ymm4
  18c685:	vpsllvd %ymm4,%ymm3,%ymm4
  18c68a:	xor    %r8d,%r8d
  18c68d:	vptest %ymm4,%ymm5
  18c692:	setb   %r8b
  18c696:	mov    %r8d,(%rcx,%rsi,4)
  18c69a:	inc    %rsi
  18c69d:	cmp    %rsi,%rax
  18c6a0:	jne    18c650 <void inline_single_kernel<false, direct_split_experiment::IndependentSplit32, unsigned long>(direct_split_experiment::IndependentSplit32 const&, unsigned long, unsigned long const*, unsigned int*)+0x1c0>
  18c6a2:	vzeroupper
  18c6a5:	ret
  18c6a6:	int3
  18c6a7:	int3
  18c6a8:	int3
  18c6a9:	int3
  18c6aa:	int3
  18c6ab:	int3
  18c6ac:	int3
  18c6ad:	int3
  18c6ae:	int3
  18c6af:	int3

