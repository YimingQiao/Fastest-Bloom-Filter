0000000000162f70 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<9, true>, unsigned long>(rocksdb_external::FastLocalBloom64<9, true> const&, unsigned long, unsigned long const*, unsigned int*)>:
  162f70:	test   %rsi,%rsi
  162f73:	je     163080 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<9, true>, unsigned long>(rocksdb_external::FastLocalBloom64<9, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x110>
  162f79:	xor    %eax,%eax
  162f7b:	vmovdqa -0x15e4a3(%rip),%ymm0        # 4ae0 <typeinfo name for main::$_60+0x310>
  162f83:	vmovdqa -0x15e60b(%rip),%ymm1        # 4980 <typeinfo name for main::$_60+0x1b0>
  162f8b:	vpbroadcastd -0x15fcec(%rip),%ymm2        # 32a8 <__abi_tag+0x2fe4>
  162f94:	vmovd  -0x15fcf4(%rip),%xmm3        # 32a8 <__abi_tag+0x2fe4>
  162f9c:	jmp    162fb0 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<9, true>, unsigned long>(rocksdb_external::FastLocalBloom64<9, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
  162f9e:	xchg   %ax,%ax
  162fa0:	mov    %r9d,(%rcx,%rax,4)
  162fa4:	inc    %rax
  162fa7:	cmp    %rax,%rsi
  162faa:	je     163080 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<9, true>, unsigned long>(rocksdb_external::FastLocalBloom64<9, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x110>
  162fb0:	mov    (%rdx,%rax,8),%r8
  162fb4:	mov    0x18(%rdi),%r9d
  162fb8:	mov    (%rdi),%r10
  162fbb:	shr    $0x6,%r9d
  162fbf:	mov    %r8d,%r11d
  162fc2:	imul   %r9,%r11
  162fc6:	shr    $0x1a,%r11
  162fca:	and    $0xffffffc0,%r11d
  162fce:	shr    $0x20,%r8
  162fd2:	prefetcht2 (%r10,%r11,1)
  162fd7:	vmovdqu (%r10,%r11,1),%ymm4
  162fdd:	vmovdqu 0x20(%r10,%r11,1),%ymm5
  162fe4:	vpbroadcastd %r8d,%ymm6
  162fea:	vpmulld %ymm0,%ymm6,%ymm7
  162fef:	vpsrld $0x1c,%ymm7,%ymm8
  162ff4:	vxorps %xmm9,%xmm9,%xmm9
  162ff9:	vpermd %ymm4,%ymm8,%ymm9
  162ffe:	vpermd %ymm5,%ymm8,%ymm8
  163003:	vpsrad $0x1f,%ymm7,%ymm7
  163008:	vpblendvb %ymm7,%ymm8,%ymm9,%ymm7
  16300e:	vpmulld %ymm1,%ymm6,%ymm6
  163013:	prefetcht2 0x3f(%r10,%r11,1)
  163019:	vpsrld $0x1b,%ymm6,%ymm6
  16301e:	vpsllvd %ymm6,%ymm2,%ymm6
  163023:	vptest %ymm6,%ymm7
  163028:	mov    $0x0,%r9d
  16302e:	jae    162fa0 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<9, true>, unsigned long>(rocksdb_external::FastLocalBloom64<9, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
  163034:	imul   $0xab25f4c1,%r8d,%r8d
  16303b:	vpbroadcastd %r8d,%ymm6
  163041:	vpmulld %ymm0,%ymm6,%ymm7
  163046:	vpsrld $0x1c,%ymm7,%ymm8
  16304b:	vpermd %ymm4,%ymm8,%ymm4
  163050:	vpermd %ymm5,%ymm8,%ymm5
  163055:	vpsrad $0x1f,%ymm7,%ymm7
  16305a:	vpblendvb %ymm7,%ymm5,%ymm4,%ymm4
  163060:	vpmulld %ymm1,%ymm6,%ymm5
  163065:	vpsrld $0x1b,%ymm5,%ymm5
  16306a:	vpsllvd %ymm5,%ymm3,%ymm5
  16306f:	xor    %r9d,%r9d
  163072:	vptest %ymm5,%ymm4
  163077:	setb   %r9b
  16307b:	jmp    162fa0 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<9, true>, unsigned long>(rocksdb_external::FastLocalBloom64<9, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
  163080:	vzeroupper
  163083:	ret
  163084:	int3
  163085:	int3
  163086:	int3
  163087:	int3
  163088:	int3
  163089:	int3
  16308a:	int3
  16308b:	int3
  16308c:	int3
  16308d:	int3
  16308e:	int3
  16308f:	int3

