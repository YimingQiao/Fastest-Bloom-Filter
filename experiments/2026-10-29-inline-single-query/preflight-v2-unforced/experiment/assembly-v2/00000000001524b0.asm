00000000001524b0 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<9, false>, unsigned long>(rocksdb_external::FastLocalBloom64<9, false> const&, unsigned long, unsigned long const*, unsigned int*)>:
  1524b0:	test   %rsi,%rsi
  1524b3:	je     1525e5 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<9, false>, unsigned long>(rocksdb_external::FastLocalBloom64<9, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x135>
  1524b9:	push   %rbx
  1524ba:	movabs $0xd6e8feb86659fd93,%rax
  1524c4:	xor    %r8d,%r8d
  1524c7:	vmovdqa -0x14d9ef(%rip),%ymm0        # 4ae0 <typeinfo name for main::$_60+0x310>
  1524cf:	vmovdqa -0x14db57(%rip),%ymm1        # 4980 <typeinfo name for main::$_60+0x1b0>
  1524d7:	vpbroadcastd -0x14f238(%rip),%ymm2        # 32a8 <__abi_tag+0x2fe4>
  1524e0:	vmovd  -0x14f240(%rip),%xmm3        # 32a8 <__abi_tag+0x2fe4>
  1524e8:	jmp    152500 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<9, false>, unsigned long>(rocksdb_external::FastLocalBloom64<9, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  1524ea:	nopw   0x0(%rax,%rax,1)
  1524f0:	mov    %r10d,(%rcx,%r8,4)
  1524f4:	inc    %r8
  1524f7:	cmp    %r8,%rsi
  1524fa:	je     1525e4 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<9, false>, unsigned long>(rocksdb_external::FastLocalBloom64<9, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x134>
  152500:	mov    (%rdx,%r8,8),%r9
  152504:	mov    %r9,%r10
  152507:	shr    $0x20,%r10
  15250b:	xor    %r9,%r10
  15250e:	imul   %rax,%r10
  152512:	mov    %r10,%r9
  152515:	shr    $0x20,%r9
  152519:	xor    %r10,%r9
  15251c:	imul   %rax,%r9
  152520:	mov    %r9d,%r10d
  152523:	shr    $0x20,%r9
  152527:	mov    0x18(%rdi),%r11d
  15252b:	mov    (%rdi),%rbx
  15252e:	shr    $0x6,%r11d
  152532:	xor    %r9,%r10
  152535:	imul   %r11,%r10
  152539:	shr    $0x1a,%r10
  15253d:	and    $0xffffffc0,%r10d
  152541:	vmovdqu (%rbx,%r10,1),%ymm4
  152547:	vmovdqu 0x20(%rbx,%r10,1),%ymm5
  15254e:	vpbroadcastd %r9d,%ymm6
  152554:	vpmulld %ymm0,%ymm6,%ymm7
  152559:	vpsrld $0x1c,%ymm7,%ymm8
  15255e:	vxorps %xmm9,%xmm9,%xmm9
  152563:	vpermd %ymm4,%ymm8,%ymm9
  152568:	vpermd %ymm5,%ymm8,%ymm8
  15256d:	vpsrad $0x1f,%ymm7,%ymm7
  152572:	vpblendvb %ymm7,%ymm8,%ymm9,%ymm7
  152578:	vpmulld %ymm1,%ymm6,%ymm6
  15257d:	vpsrld $0x1b,%ymm6,%ymm6
  152582:	vpsllvd %ymm6,%ymm2,%ymm6
  152587:	vptest %ymm6,%ymm7
  15258c:	mov    $0x0,%r10d
  152592:	jae    1524f0 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<9, false>, unsigned long>(rocksdb_external::FastLocalBloom64<9, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
  152598:	imul   $0xab25f4c1,%r9d,%r9d
  15259f:	vpbroadcastd %r9d,%ymm6
  1525a5:	vpmulld %ymm0,%ymm6,%ymm7
  1525aa:	vpsrld $0x1c,%ymm7,%ymm8
  1525af:	vpermd %ymm4,%ymm8,%ymm4
  1525b4:	vpermd %ymm5,%ymm8,%ymm5
  1525b9:	vpsrad $0x1f,%ymm7,%ymm7
  1525be:	vpblendvb %ymm7,%ymm5,%ymm4,%ymm4
  1525c4:	vpmulld %ymm1,%ymm6,%ymm5
  1525c9:	vpsrld $0x1b,%ymm5,%ymm5
  1525ce:	vpsllvd %ymm5,%ymm3,%ymm5
  1525d3:	xor    %r10d,%r10d
  1525d6:	vptest %ymm5,%ymm4
  1525db:	setb   %r10b
  1525df:	jmp    1524f0 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<9, false>, unsigned long>(rocksdb_external::FastLocalBloom64<9, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
  1525e4:	pop    %rbx
  1525e5:	vzeroupper
  1525e8:	ret
  1525e9:	int3
  1525ea:	int3
  1525eb:	int3
  1525ec:	int3
  1525ed:	int3
  1525ee:	int3
  1525ef:	int3

