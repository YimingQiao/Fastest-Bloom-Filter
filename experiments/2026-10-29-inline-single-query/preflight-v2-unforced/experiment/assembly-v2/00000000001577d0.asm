00000000001577d0 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<14, false>, unsigned long>(rocksdb_external::FastLocalBloom64<14, false> const&, unsigned long, unsigned long const*, unsigned int*)>:
  1577d0:	test   %rsi,%rsi
  1577d3:	je     1578cf <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<14, false>, unsigned long>(rocksdb_external::FastLocalBloom64<14, false> const&, unsigned long, unsigned long const*, unsigned int*)+0xff>
  1577d9:	xor    %eax,%eax
  1577db:	vmovdqa -0x152d03(%rip),%ymm0        # 4ae0 <typeinfo name for main::$_60+0x310>
  1577e3:	vmovdqa -0x152e6b(%rip),%ymm1        # 4980 <typeinfo name for main::$_60+0x1b0>
  1577eb:	vpbroadcastd -0x15454c(%rip),%ymm2        # 32a8 <__abi_tag+0x2fe4>
  1577f4:	vmovdqa -0x152f9c(%rip),%ymm3        # 4860 <typeinfo name for main::$_60+0x90>
  1577fc:	jmp    157854 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<14, false>, unsigned long>(rocksdb_external::FastLocalBloom64<14, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x84>
  1577fe:	xchg   %ax,%ax
  157800:	imul   $0xab25f4c1,%r8d,%r8d
  157807:	vpbroadcastd %r8d,%ymm6
  15780d:	vpmulld %ymm0,%ymm6,%ymm7
  157812:	vpsrld $0x1c,%ymm7,%ymm8
  157817:	vpermd %ymm4,%ymm8,%ymm4
  15781c:	vpermd %ymm5,%ymm8,%ymm5
  157821:	vpsrad $0x1f,%ymm7,%ymm7
  157826:	vpblendvb %ymm7,%ymm5,%ymm4,%ymm4
  15782c:	vpmulld %ymm1,%ymm6,%ymm5
  157831:	vpsrld $0x1b,%ymm5,%ymm5
  157836:	vpsllvd %ymm5,%ymm3,%ymm5
  15783b:	vptest %ymm5,%ymm4
  157840:	setb   %r8b
  157844:	movzbl %r8b,%r8d
  157848:	mov    %r8d,(%rcx,%rax,4)
  15784c:	inc    %rax
  15784f:	cmp    %rax,%rsi
  157852:	je     1578cf <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<14, false>, unsigned long>(rocksdb_external::FastLocalBloom64<14, false> const&, unsigned long, unsigned long const*, unsigned int*)+0xff>
  157854:	mov    (%rdx,%rax,8),%r8
  157858:	mov    %r8d,%r9d
  15785b:	shr    $0x20,%r8
  15785f:	mov    0x18(%rdi),%r10d
  157863:	mov    (%rdi),%r11
  157866:	shr    $0x6,%r10d
  15786a:	imul   %r10,%r9
  15786e:	shr    $0x1a,%r9
  157872:	and    $0xffffffc0,%r9d
  157876:	vmovdqu (%r11,%r9,1),%ymm4
  15787c:	vmovdqu 0x20(%r11,%r9,1),%ymm5
  157883:	vpbroadcastd %r8d,%ymm6
  157889:	vpmulld %ymm0,%ymm6,%ymm7
  15788e:	vpsrld $0x1c,%ymm7,%ymm8
  157893:	vxorps %xmm9,%xmm9,%xmm9
  157898:	vpermd %ymm4,%ymm8,%ymm9
  15789d:	vpermd %ymm5,%ymm8,%ymm8
  1578a2:	vpsrad $0x1f,%ymm7,%ymm7
  1578a7:	vpblendvb %ymm7,%ymm8,%ymm9,%ymm7
  1578ad:	vpmulld %ymm1,%ymm6,%ymm6
  1578b2:	vpsrld $0x1b,%ymm6,%ymm6
  1578b7:	vpsllvd %ymm6,%ymm2,%ymm6
  1578bc:	vptest %ymm6,%ymm7
  1578c1:	jb     157800 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<14, false>, unsigned long>(rocksdb_external::FastLocalBloom64<14, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
  1578c7:	xor    %r8d,%r8d
  1578ca:	jmp    157844 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<14, false>, unsigned long>(rocksdb_external::FastLocalBloom64<14, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x74>
  1578cf:	vzeroupper
  1578d2:	ret
  1578d3:	int3
  1578d4:	int3
  1578d5:	int3
  1578d6:	int3
  1578d7:	int3
  1578d8:	int3
  1578d9:	int3
  1578da:	int3
  1578db:	int3
  1578dc:	int3
  1578dd:	int3
  1578de:	int3
  1578df:	int3

