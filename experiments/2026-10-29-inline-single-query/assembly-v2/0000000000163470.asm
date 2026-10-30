0000000000163470 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<9, true>, unsigned long>(rocksdb_external::FastLocalBloom64<9, true> const&, unsigned long, unsigned long const*, unsigned int*)>:
  163470:	test   %rsi,%rsi
  163473:	je     1635b0 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<9, true>, unsigned long>(rocksdb_external::FastLocalBloom64<9, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x140>
  163479:	push   %rbx
  16347a:	movabs $0xd6e8feb86659fd93,%rax
  163484:	xor    %r8d,%r8d
  163487:	vmovdqa -0x15e9af(%rip),%ymm0        # 4ae0 <typeinfo name for main::$_60+0x310>
  16348f:	vmovdqa -0x15eb17(%rip),%ymm1        # 4980 <typeinfo name for main::$_60+0x1b0>
  163497:	vpbroadcastd -0x1601f8(%rip),%ymm2        # 32a8 <__abi_tag+0x2fe4>
  1634a0:	vmovd  -0x160200(%rip),%xmm3        # 32a8 <__abi_tag+0x2fe4>
  1634a8:	jmp    1634c0 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<9, true>, unsigned long>(rocksdb_external::FastLocalBloom64<9, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  1634aa:	nopw   0x0(%rax,%rax,1)
  1634b0:	mov    %r10d,(%rcx,%r8,4)
  1634b4:	inc    %r8
  1634b7:	cmp    %r8,%rsi
  1634ba:	je     1635af <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<9, true>, unsigned long>(rocksdb_external::FastLocalBloom64<9, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x13f>
  1634c0:	mov    (%rdx,%r8,8),%r9
  1634c4:	mov    %r9,%r10
  1634c7:	shr    $0x20,%r10
  1634cb:	xor    %r9,%r10
  1634ce:	imul   %rax,%r10
  1634d2:	mov    %r10,%r9
  1634d5:	shr    $0x20,%r9
  1634d9:	xor    %r10,%r9
  1634dc:	imul   %rax,%r9
  1634e0:	mov    %r9d,%r10d
  1634e3:	shr    $0x20,%r9
  1634e7:	mov    0x18(%rdi),%r11d
  1634eb:	mov    (%rdi),%rbx
  1634ee:	shr    $0x6,%r11d
  1634f2:	xor    %r9,%r10
  1634f5:	imul   %r11,%r10
  1634f9:	shr    $0x1a,%r10
  1634fd:	and    $0xffffffc0,%r10d
  163501:	prefetcht2 (%rbx,%r10,1)
  163506:	vmovdqu (%rbx,%r10,1),%ymm4
  16350c:	vmovdqu 0x20(%rbx,%r10,1),%ymm5
  163513:	vpbroadcastd %r9d,%ymm6
  163519:	vpmulld %ymm0,%ymm6,%ymm7
  16351e:	vpsrld $0x1c,%ymm7,%ymm8
  163523:	vxorps %xmm9,%xmm9,%xmm9
  163528:	vpermd %ymm4,%ymm8,%ymm9
  16352d:	vpermd %ymm5,%ymm8,%ymm8
  163532:	vpsrad $0x1f,%ymm7,%ymm7
  163537:	vpblendvb %ymm7,%ymm8,%ymm9,%ymm7
  16353d:	vpmulld %ymm1,%ymm6,%ymm6
  163542:	prefetcht2 0x3f(%rbx,%r10,1)
  163548:	vpsrld $0x1b,%ymm6,%ymm6
  16354d:	vpsllvd %ymm6,%ymm2,%ymm6
  163552:	vptest %ymm6,%ymm7
  163557:	mov    $0x0,%r10d
  16355d:	jae    1634b0 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<9, true>, unsigned long>(rocksdb_external::FastLocalBloom64<9, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
  163563:	imul   $0xab25f4c1,%r9d,%r9d
  16356a:	vpbroadcastd %r9d,%ymm6
  163570:	vpmulld %ymm0,%ymm6,%ymm7
  163575:	vpsrld $0x1c,%ymm7,%ymm8
  16357a:	vpermd %ymm4,%ymm8,%ymm4
  16357f:	vpermd %ymm5,%ymm8,%ymm5
  163584:	vpsrad $0x1f,%ymm7,%ymm7
  163589:	vpblendvb %ymm7,%ymm5,%ymm4,%ymm4
  16358f:	vpmulld %ymm1,%ymm6,%ymm5
  163594:	vpsrld $0x1b,%ymm5,%ymm5
  163599:	vpsllvd %ymm5,%ymm3,%ymm5
  16359e:	xor    %r10d,%r10d
  1635a1:	vptest %ymm5,%ymm4
  1635a6:	setb   %r10b
  1635aa:	jmp    1634b0 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<9, true>, unsigned long>(rocksdb_external::FastLocalBloom64<9, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
  1635af:	pop    %rbx
  1635b0:	vzeroupper
  1635b3:	ret
  1635b4:	int3
  1635b5:	int3
  1635b6:	int3
  1635b7:	int3
  1635b8:	int3
  1635b9:	int3
  1635ba:	int3
  1635bb:	int3
  1635bc:	int3
  1635bd:	int3
  1635be:	int3
  1635bf:	int3

