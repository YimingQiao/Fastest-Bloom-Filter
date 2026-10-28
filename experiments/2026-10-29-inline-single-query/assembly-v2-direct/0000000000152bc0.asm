0000000000152bc0 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<9, false>, unsigned long>(rocksdb_external::FastLocalBloom64<9, false> const&, unsigned long, unsigned long const*, unsigned int*)>:
  152bc0:	test   %rsi,%rsi
  152bc3:	je     152cc5 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<9, false>, unsigned long>(rocksdb_external::FastLocalBloom64<9, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x105>
  152bc9:	xor    %eax,%eax
  152bcb:	vmovdqa -0x14e0f3(%rip),%ymm0        # 4ae0 <typeinfo name for main::$_60+0x310>
  152bd3:	vmovdqa -0x14e25b(%rip),%ymm1        # 4980 <typeinfo name for main::$_60+0x1b0>
  152bdb:	vpbroadcastd -0x14f93c(%rip),%ymm2        # 32a8 <__abi_tag+0x2fe4>
  152be4:	vmovd  -0x14f944(%rip),%xmm3        # 32a8 <__abi_tag+0x2fe4>
  152bec:	jmp    152c00 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<9, false>, unsigned long>(rocksdb_external::FastLocalBloom64<9, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
  152bee:	xchg   %ax,%ax
  152bf0:	mov    %r9d,(%rcx,%rax,4)
  152bf4:	inc    %rax
  152bf7:	cmp    %rax,%rsi
  152bfa:	je     152cc5 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<9, false>, unsigned long>(rocksdb_external::FastLocalBloom64<9, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x105>
  152c00:	mov    (%rdx,%rax,8),%r8
  152c04:	mov    %r8d,%r9d
  152c07:	shr    $0x20,%r8
  152c0b:	mov    0x18(%rdi),%r10d
  152c0f:	mov    (%rdi),%r11
  152c12:	shr    $0x6,%r10d
  152c16:	imul   %r10,%r9
  152c1a:	shr    $0x1a,%r9
  152c1e:	and    $0xffffffc0,%r9d
  152c22:	vmovdqu (%r11,%r9,1),%ymm4
  152c28:	vmovdqu 0x20(%r11,%r9,1),%ymm5
  152c2f:	vpbroadcastd %r8d,%ymm6
  152c35:	vpmulld %ymm0,%ymm6,%ymm7
  152c3a:	vpsrld $0x1c,%ymm7,%ymm8
  152c3f:	vxorps %xmm9,%xmm9,%xmm9
  152c44:	vpermd %ymm4,%ymm8,%ymm9
  152c49:	vpermd %ymm5,%ymm8,%ymm8
  152c4e:	vpsrad $0x1f,%ymm7,%ymm7
  152c53:	vpblendvb %ymm7,%ymm8,%ymm9,%ymm7
  152c59:	vpmulld %ymm1,%ymm6,%ymm6
  152c5e:	vpsrld $0x1b,%ymm6,%ymm6
  152c63:	vpsllvd %ymm6,%ymm2,%ymm6
  152c68:	vptest %ymm6,%ymm7
  152c6d:	mov    $0x0,%r9d
  152c73:	jae    152bf0 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<9, false>, unsigned long>(rocksdb_external::FastLocalBloom64<9, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
  152c79:	imul   $0xab25f4c1,%r8d,%r8d
  152c80:	vpbroadcastd %r8d,%ymm6
  152c86:	vpmulld %ymm0,%ymm6,%ymm7
  152c8b:	vpsrld $0x1c,%ymm7,%ymm8
  152c90:	vpermd %ymm4,%ymm8,%ymm4
  152c95:	vpermd %ymm5,%ymm8,%ymm5
  152c9a:	vpsrad $0x1f,%ymm7,%ymm7
  152c9f:	vpblendvb %ymm7,%ymm5,%ymm4,%ymm4
  152ca5:	vpmulld %ymm1,%ymm6,%ymm5
  152caa:	vpsrld $0x1b,%ymm5,%ymm5
  152caf:	vpsllvd %ymm5,%ymm3,%ymm5
  152cb4:	xor    %r9d,%r9d
  152cb7:	vptest %ymm5,%ymm4
  152cbc:	setb   %r9b
  152cc0:	jmp    152bf0 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<9, false>, unsigned long>(rocksdb_external::FastLocalBloom64<9, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
  152cc5:	vzeroupper
  152cc8:	ret
  152cc9:	int3
  152cca:	int3
  152ccb:	int3
  152ccc:	int3
  152ccd:	int3
  152cce:	int3
  152ccf:	int3

