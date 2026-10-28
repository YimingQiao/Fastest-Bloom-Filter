0000000000192570 <void inline_single_kernel<true, direct_split_experiment::SingleShortcut<direct_split_experiment::IndependentSplit32>, unsigned long>(direct_split_experiment::SingleShortcut<direct_split_experiment::IndependentSplit32> const&, unsigned long, unsigned long const*, unsigned int*)>:
  192570:	test   %rsi,%rsi
  192573:	je     19272e <void inline_single_kernel<true, direct_split_experiment::SingleShortcut<direct_split_experiment::IndependentSplit32>, unsigned long>(direct_split_experiment::SingleShortcut<direct_split_experiment::IndependentSplit32> const&, unsigned long, unsigned long const*, unsigned int*)+0x1be>
  192579:	push   %rbx
  19257a:	movabs $0xd6e8feb86659fd93,%r8
  192584:	cmp    $0x1,%rsi
  192588:	jne    192591 <void inline_single_kernel<true, direct_split_experiment::SingleShortcut<direct_split_experiment::IndependentSplit32>, unsigned long>(direct_split_experiment::SingleShortcut<direct_split_experiment::IndependentSplit32> const&, unsigned long, unsigned long const*, unsigned int*)+0x21>
  19258a:	xor    %eax,%eax
  19258c:	jmp    1926af <void inline_single_kernel<true, direct_split_experiment::SingleShortcut<direct_split_experiment::IndependentSplit32>, unsigned long>(direct_split_experiment::SingleShortcut<direct_split_experiment::IndependentSplit32> const&, unsigned long, unsigned long const*, unsigned int*)+0x13f>
  192591:	mov    %rsi,%r9
  192594:	and    $0xfffffffffffffffe,%r9
  192598:	xor    %eax,%eax
  19259a:	vmovdqa -0x18da82(%rip),%ymm0        # 4b20 <typeinfo name for main::$_60+0x350>
  1925a2:	vpbroadcastq -0x18f19b(%rip),%ymm1        # 3410 <_IO_stdin_used+0x15c>
  1925ab:	vpbroadcastd -0x18f310(%rip),%ymm2        # 32a4 <__abi_tag+0x2fe0>
  1925b4:	vpbroadcastd -0x18f315(%rip),%ymm3        # 32a8 <__abi_tag+0x2fe4>
  1925bd:	nopl   (%rax)
  1925c0:	mov    (%rdx,%rax,8),%r10
  1925c4:	mov    %r10,%r11
  1925c7:	shr    $0x20,%r11
  1925cb:	xor    %r10,%r11
  1925ce:	imul   %r8,%r11
  1925d2:	mov    %r11,%r10
  1925d5:	shr    $0x20,%r10
  1925d9:	xor    %r11,%r10
  1925dc:	imul   %r8,%r10
  1925e0:	mov    %r10,%r11
  1925e3:	shr    $0x20,%r11
  1925e7:	xor    %r10,%r11
  1925ea:	shr    $0x29,%r10
  1925ee:	and    0x18(%rdi),%r10d
  1925f2:	mov    (%rdi),%rbx
  1925f5:	shl    $0x5,%r10d
  1925f9:	vmovdqa (%rbx,%r10,1),%ymm4
  1925ff:	vpbroadcastq %r11,%ymm5
  192605:	vpsrlvq %ymm0,%ymm5,%ymm5
  19260a:	vpshufd $0xa0,%ymm5,%ymm5
  19260f:	vpsrlvd %ymm1,%ymm5,%ymm5
  192614:	vpand  %ymm2,%ymm5,%ymm5
  192618:	vpsllvd %ymm5,%ymm3,%ymm5
  19261d:	xor    %r10d,%r10d
  192620:	vptest %ymm5,%ymm4
  192625:	setb   %r10b
  192629:	mov    %r10d,(%rcx,%rax,4)
  19262d:	mov    0x8(%rdx,%rax,8),%r10
  192632:	mov    %r10,%r11
  192635:	shr    $0x20,%r11
  192639:	xor    %r10,%r11
  19263c:	imul   %r8,%r11
  192640:	mov    %r11,%r10
  192643:	shr    $0x20,%r10
  192647:	xor    %r11,%r10
  19264a:	imul   %r8,%r10
  19264e:	mov    %r10,%r11
  192651:	shr    $0x20,%r11
  192655:	xor    %r10,%r11
  192658:	shr    $0x29,%r10
  19265c:	and    0x18(%rdi),%r10d
  192660:	mov    (%rdi),%rbx
  192663:	shl    $0x5,%r10d
  192667:	vmovdqa (%rbx,%r10,1),%ymm4
  19266d:	vpbroadcastq %r11,%ymm5
  192673:	vpsrlvq %ymm0,%ymm5,%ymm5
  192678:	vpshufd $0xa0,%ymm5,%ymm5
  19267d:	vpsrlvd %ymm1,%ymm5,%ymm5
  192682:	vpand  %ymm2,%ymm5,%ymm5
  192686:	vpsllvd %ymm5,%ymm3,%ymm5
  19268b:	xor    %r10d,%r10d
  19268e:	vptest %ymm5,%ymm4
  192693:	setb   %r10b
  192697:	mov    %r10d,0x4(%rcx,%rax,4)
  19269c:	add    $0x2,%rax
  1926a0:	cmp    %rax,%r9
  1926a3:	jne    1925c0 <void inline_single_kernel<true, direct_split_experiment::SingleShortcut<direct_split_experiment::IndependentSplit32>, unsigned long>(direct_split_experiment::SingleShortcut<direct_split_experiment::IndependentSplit32> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  1926a9:	test   $0x1,%sil
  1926ad:	je     19272d <void inline_single_kernel<true, direct_split_experiment::SingleShortcut<direct_split_experiment::IndependentSplit32>, unsigned long>(direct_split_experiment::SingleShortcut<direct_split_experiment::IndependentSplit32> const&, unsigned long, unsigned long const*, unsigned int*)+0x1bd>
  1926af:	mov    (%rdx,%rax,8),%rdx
  1926b3:	mov    %rdx,%rsi
  1926b6:	shr    $0x20,%rsi
  1926ba:	xor    %rdx,%rsi
  1926bd:	imul   %r8,%rsi
  1926c1:	mov    %rsi,%rdx
  1926c4:	shr    $0x20,%rdx
  1926c8:	xor    %rsi,%rdx
  1926cb:	imul   %r8,%rdx
  1926cf:	mov    %rdx,%rsi
  1926d2:	shr    $0x20,%rsi
  1926d6:	xor    %rdx,%rsi
  1926d9:	shr    $0x29,%rdx
  1926dd:	and    0x18(%rdi),%edx
  1926e0:	mov    (%rdi),%rdi
  1926e3:	shl    $0x5,%edx
  1926e6:	vpbroadcastq %rsi,%ymm0
  1926ec:	vpsrlvq -0x18dbd5(%rip),%ymm0,%ymm0        # 4b20 <typeinfo name for main::$_60+0x350>
  1926f5:	vpshufd $0xa0,%ymm0,%ymm0
  1926fa:	vpsrlvd -0x18dc63(%rip),%ymm0,%ymm0        # 4aa0 <typeinfo name for main::$_60+0x2d0>
  192703:	vmovdqa (%rdi,%rdx,1),%ymm1
  192708:	vpandd -0x18f46e(%rip){1to8},%ymm0,%ymm0        # 32a4 <__abi_tag+0x2fe0>
  192712:	vpbroadcastd -0x18f473(%rip),%ymm2        # 32a8 <__abi_tag+0x2fe4>
  19271b:	vpsllvd %ymm0,%ymm2,%ymm0
  192720:	xor    %edx,%edx
  192722:	vptest %ymm0,%ymm1
  192727:	setb   %dl
  19272a:	mov    %edx,(%rcx,%rax,4)
  19272d:	pop    %rbx
  19272e:	vzeroupper
  192731:	ret
  192732:	int3
  192733:	int3
  192734:	int3
  192735:	int3
  192736:	int3
  192737:	int3
  192738:	int3
  192739:	int3
  19273a:	int3
  19273b:	int3
  19273c:	int3
  19273d:	int3
  19273e:	int3
  19273f:	int3

