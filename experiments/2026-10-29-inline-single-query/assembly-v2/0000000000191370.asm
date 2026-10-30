0000000000191370 <void inline_single_kernel<false, direct_split_experiment::SingleShortcut<direct_split_experiment::IndependentSplit32>, unsigned long>(direct_split_experiment::SingleShortcut<direct_split_experiment::IndependentSplit32> const&, unsigned long, unsigned long const*, unsigned int*)>:
  191370:	test   %rsi,%rsi
  191373:	je     191582 <void inline_single_kernel<false, direct_split_experiment::SingleShortcut<direct_split_experiment::IndependentSplit32>, unsigned long>(direct_split_experiment::SingleShortcut<direct_split_experiment::IndependentSplit32> const&, unsigned long, unsigned long const*, unsigned int*)+0x212>
  191379:	mov    %esi,%eax
  19137b:	and    $0x3,%eax
  19137e:	cmp    $0x4,%rsi
  191382:	jae    19138c <void inline_single_kernel<false, direct_split_experiment::SingleShortcut<direct_split_experiment::IndependentSplit32>, unsigned long>(direct_split_experiment::SingleShortcut<direct_split_experiment::IndependentSplit32> const&, unsigned long, unsigned long const*, unsigned int*)+0x1c>
  191384:	xor    %r8d,%r8d
  191387:	jmp    1914fe <void inline_single_kernel<false, direct_split_experiment::SingleShortcut<direct_split_experiment::IndependentSplit32>, unsigned long>(direct_split_experiment::SingleShortcut<direct_split_experiment::IndependentSplit32> const&, unsigned long, unsigned long const*, unsigned int*)+0x18e>
  19138c:	and    $0xfffffffffffffffc,%rsi
  191390:	xor    %r8d,%r8d
  191393:	vmovdqa -0x18c87b(%rip),%ymm0        # 4b20 <typeinfo name for main::$_60+0x350>
  19139b:	vpbroadcastq -0x18df94(%rip),%ymm1        # 3410 <_IO_stdin_used+0x15c>
  1913a4:	vpbroadcastd -0x18e109(%rip),%ymm2        # 32a4 <__abi_tag+0x2fe0>
  1913ad:	vpbroadcastd -0x18e10e(%rip),%ymm3        # 32a8 <__abi_tag+0x2fe4>
  1913b6:	cs nopw 0x0(%rax,%rax,1)
  1913c0:	mov    (%rdx,%r8,8),%r9
  1913c4:	mov    %r9,%r10
  1913c7:	shr    $0x29,%r10
  1913cb:	and    0x18(%rdi),%r10d
  1913cf:	vpbroadcastq %r9,%ymm4
  1913d5:	mov    (%rdi),%r9
  1913d8:	shl    $0x5,%r10d
  1913dc:	vmovdqa (%r9,%r10,1),%ymm5
  1913e2:	vpsrlvq %ymm0,%ymm4,%ymm4
  1913e7:	vpshufd $0xa0,%ymm4,%ymm4
  1913ec:	vpsrlvd %ymm1,%ymm4,%ymm4
  1913f1:	vpand  %ymm2,%ymm4,%ymm4
  1913f5:	vpsllvd %ymm4,%ymm3,%ymm4
  1913fa:	xor    %r9d,%r9d
  1913fd:	vptest %ymm4,%ymm5
  191402:	setb   %r9b
  191406:	mov    %r9d,(%rcx,%r8,4)
  19140a:	mov    0x8(%rdx,%r8,8),%r9
  19140f:	vpbroadcastq %r9,%ymm4
  191415:	shr    $0x29,%r9
  191419:	and    0x18(%rdi),%r9d
  19141d:	mov    (%rdi),%r10
  191420:	shl    $0x5,%r9d
  191424:	vmovdqa (%r10,%r9,1),%ymm5
  19142a:	vpsrlvq %ymm0,%ymm4,%ymm4
  19142f:	vpshufd $0xa0,%ymm4,%ymm4
  191434:	vpsrlvd %ymm1,%ymm4,%ymm4
  191439:	vpand  %ymm2,%ymm4,%ymm4
  19143d:	vpsllvd %ymm4,%ymm3,%ymm4
  191442:	xor    %r9d,%r9d
  191445:	vptest %ymm4,%ymm5
  19144a:	setb   %r9b
  19144e:	mov    %r9d,0x4(%rcx,%r8,4)
  191453:	mov    0x10(%rdx,%r8,8),%r9
  191458:	vpbroadcastq %r9,%ymm4
  19145e:	shr    $0x29,%r9
  191462:	and    0x18(%rdi),%r9d
  191466:	mov    (%rdi),%r10
  191469:	shl    $0x5,%r9d
  19146d:	vmovdqa (%r10,%r9,1),%ymm5
  191473:	vpsrlvq %ymm0,%ymm4,%ymm4
  191478:	vpshufd $0xa0,%ymm4,%ymm4
  19147d:	vpsrlvd %ymm1,%ymm4,%ymm4
  191482:	vpand  %ymm2,%ymm4,%ymm4
  191486:	vpsllvd %ymm4,%ymm3,%ymm4
  19148b:	xor    %r9d,%r9d
  19148e:	vptest %ymm4,%ymm5
  191493:	setb   %r9b
  191497:	mov    %r9d,0x8(%rcx,%r8,4)
  19149c:	mov    0x18(%rdx,%r8,8),%r9
  1914a1:	mov    %r9,%r10
  1914a4:	shr    $0x29,%r10
  1914a8:	and    0x18(%rdi),%r10d
  1914ac:	vpbroadcastq %r9,%ymm4
  1914b2:	mov    (%rdi),%r9
  1914b5:	shl    $0x5,%r10d
  1914b9:	vmovdqa (%r9,%r10,1),%ymm5
  1914bf:	vpsrlvq %ymm0,%ymm4,%ymm4
  1914c4:	vpshufd $0xa0,%ymm4,%ymm4
  1914c9:	vpsrlvd %ymm1,%ymm4,%ymm4
  1914ce:	vpand  %ymm2,%ymm4,%ymm4
  1914d2:	vpsllvd %ymm4,%ymm3,%ymm4
  1914d7:	xor    %r9d,%r9d
  1914da:	vptest %ymm4,%ymm5
  1914df:	setb   %r9b
  1914e3:	mov    %r9d,0xc(%rcx,%r8,4)
  1914e8:	add    $0x4,%r8
  1914ec:	cmp    %r8,%rsi
  1914ef:	jne    1913c0 <void inline_single_kernel<false, direct_split_experiment::SingleShortcut<direct_split_experiment::IndependentSplit32>, unsigned long>(direct_split_experiment::SingleShortcut<direct_split_experiment::IndependentSplit32> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  1914f5:	test   %rax,%rax
  1914f8:	je     191582 <void inline_single_kernel<false, direct_split_experiment::SingleShortcut<direct_split_experiment::IndependentSplit32>, unsigned long>(direct_split_experiment::SingleShortcut<direct_split_experiment::IndependentSplit32> const&, unsigned long, unsigned long const*, unsigned int*)+0x212>
  1914fe:	lea    (%rcx,%r8,4),%rcx
  191502:	lea    (%rdx,%r8,8),%rdx
  191506:	xor    %esi,%esi
  191508:	vmovdqa -0x18c9f0(%rip),%ymm0        # 4b20 <typeinfo name for main::$_60+0x350>
  191510:	vpbroadcastq -0x18e109(%rip),%ymm1        # 3410 <_IO_stdin_used+0x15c>
  191519:	vpbroadcastd -0x18e27e(%rip),%ymm2        # 32a4 <__abi_tag+0x2fe0>
  191522:	vpbroadcastd -0x18e283(%rip),%ymm3        # 32a8 <__abi_tag+0x2fe4>
  19152b:	nopl   0x0(%rax,%rax,1)
  191530:	mov    (%rdx,%rsi,8),%r8
  191534:	mov    %r8,%r9
  191537:	shr    $0x29,%r9
  19153b:	and    0x18(%rdi),%r9d
  19153f:	vpbroadcastq %r8,%ymm4
  191545:	mov    (%rdi),%r8
  191548:	shl    $0x5,%r9d
  19154c:	vmovdqa (%r8,%r9,1),%ymm5
  191552:	vpsrlvq %ymm0,%ymm4,%ymm4
  191557:	vpshufd $0xa0,%ymm4,%ymm4
  19155c:	vpsrlvd %ymm1,%ymm4,%ymm4
  191561:	vpand  %ymm2,%ymm4,%ymm4
  191565:	vpsllvd %ymm4,%ymm3,%ymm4
  19156a:	xor    %r8d,%r8d
  19156d:	vptest %ymm4,%ymm5
  191572:	setb   %r8b
  191576:	mov    %r8d,(%rcx,%rsi,4)
  19157a:	inc    %rsi
  19157d:	cmp    %rsi,%rax
  191580:	jne    191530 <void inline_single_kernel<false, direct_split_experiment::SingleShortcut<direct_split_experiment::IndependentSplit32>, unsigned long>(direct_split_experiment::SingleShortcut<direct_split_experiment::IndependentSplit32> const&, unsigned long, unsigned long const*, unsigned int*)+0x1c0>
  191582:	vzeroupper
  191585:	ret
  191586:	int3
  191587:	int3
  191588:	int3
  191589:	int3
  19158a:	int3
  19158b:	int3
  19158c:	int3
  19158d:	int3
  19158e:	int3
  19158f:	int3

