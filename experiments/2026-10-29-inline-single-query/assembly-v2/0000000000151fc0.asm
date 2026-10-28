0000000000151fc0 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<9, false>, unsigned long>(rocksdb_external::FastLocalBloom64<9, false> const&, unsigned long, unsigned long const*, unsigned int*)>:
  151fc0:	test   %rsi,%rsi
  151fc3:	je     1520c5 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<9, false>, unsigned long>(rocksdb_external::FastLocalBloom64<9, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x105>
  151fc9:	xor    %eax,%eax
  151fcb:	vmovdqa -0x14d4f3(%rip),%ymm0        # 4ae0 <typeinfo name for main::$_60+0x310>
  151fd3:	vmovdqa -0x14d65b(%rip),%ymm1        # 4980 <typeinfo name for main::$_60+0x1b0>
  151fdb:	vpbroadcastd -0x14ed3c(%rip),%ymm2        # 32a8 <__abi_tag+0x2fe4>
  151fe4:	vmovd  -0x14ed44(%rip),%xmm3        # 32a8 <__abi_tag+0x2fe4>
  151fec:	jmp    152000 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<9, false>, unsigned long>(rocksdb_external::FastLocalBloom64<9, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
  151fee:	xchg   %ax,%ax
  151ff0:	mov    %r9d,(%rcx,%rax,4)
  151ff4:	inc    %rax
  151ff7:	cmp    %rax,%rsi
  151ffa:	je     1520c5 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<9, false>, unsigned long>(rocksdb_external::FastLocalBloom64<9, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x105>
  152000:	mov    (%rdx,%rax,8),%r8
  152004:	mov    %r8d,%r9d
  152007:	shr    $0x20,%r8
  15200b:	mov    0x18(%rdi),%r10d
  15200f:	mov    (%rdi),%r11
  152012:	shr    $0x6,%r10d
  152016:	imul   %r10,%r9
  15201a:	shr    $0x1a,%r9
  15201e:	and    $0xffffffc0,%r9d
  152022:	vmovdqu (%r11,%r9,1),%ymm4
  152028:	vmovdqu 0x20(%r11,%r9,1),%ymm5
  15202f:	vpbroadcastd %r8d,%ymm6
  152035:	vpmulld %ymm0,%ymm6,%ymm7
  15203a:	vpsrld $0x1c,%ymm7,%ymm8
  15203f:	vxorps %xmm9,%xmm9,%xmm9
  152044:	vpermd %ymm4,%ymm8,%ymm9
  152049:	vpermd %ymm5,%ymm8,%ymm8
  15204e:	vpsrad $0x1f,%ymm7,%ymm7
  152053:	vpblendvb %ymm7,%ymm8,%ymm9,%ymm7
  152059:	vpmulld %ymm1,%ymm6,%ymm6
  15205e:	vpsrld $0x1b,%ymm6,%ymm6
  152063:	vpsllvd %ymm6,%ymm2,%ymm6
  152068:	vptest %ymm6,%ymm7
  15206d:	mov    $0x0,%r9d
  152073:	jae    151ff0 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<9, false>, unsigned long>(rocksdb_external::FastLocalBloom64<9, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
  152079:	imul   $0xab25f4c1,%r8d,%r8d
  152080:	vpbroadcastd %r8d,%ymm6
  152086:	vpmulld %ymm0,%ymm6,%ymm7
  15208b:	vpsrld $0x1c,%ymm7,%ymm8
  152090:	vpermd %ymm4,%ymm8,%ymm4
  152095:	vpermd %ymm5,%ymm8,%ymm5
  15209a:	vpsrad $0x1f,%ymm7,%ymm7
  15209f:	vpblendvb %ymm7,%ymm5,%ymm4,%ymm4
  1520a5:	vpmulld %ymm1,%ymm6,%ymm5
  1520aa:	vpsrld $0x1b,%ymm5,%ymm5
  1520af:	vpsllvd %ymm5,%ymm3,%ymm5
  1520b4:	xor    %r9d,%r9d
  1520b7:	vptest %ymm5,%ymm4
  1520bc:	setb   %r9b
  1520c0:	jmp    151ff0 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<9, false>, unsigned long>(rocksdb_external::FastLocalBloom64<9, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
  1520c5:	vzeroupper
  1520c8:	ret
  1520c9:	int3
  1520ca:	int3
  1520cb:	int3
  1520cc:	int3
  1520cd:	int3
  1520ce:	int3
  1520cf:	int3

