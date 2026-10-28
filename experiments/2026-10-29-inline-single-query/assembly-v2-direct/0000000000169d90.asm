0000000000169d90 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<14, true>, unsigned long>(rocksdb_external::FastLocalBloom64<14, true> const&, unsigned long, unsigned long const*, unsigned int*)>:
  169d90:	test   %rsi,%rsi
  169d93:	je     169ece <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<14, true>, unsigned long>(rocksdb_external::FastLocalBloom64<14, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x13e>
  169d99:	push   %rbx
  169d9a:	movabs $0xd6e8feb86659fd93,%rax
  169da4:	xor    %r8d,%r8d
  169da7:	vmovdqa -0x1652cf(%rip),%ymm0        # 4ae0 <typeinfo name for main::$_60+0x310>
  169daf:	vmovdqa -0x165437(%rip),%ymm1        # 4980 <typeinfo name for main::$_60+0x1b0>
  169db7:	vpbroadcastd -0x166b18(%rip),%ymm2        # 32a8 <__abi_tag+0x2fe4>
  169dc0:	vmovdqa -0x165568(%rip),%ymm3        # 4860 <typeinfo name for main::$_60+0x90>
  169dc8:	jmp    169e28 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<14, true>, unsigned long>(rocksdb_external::FastLocalBloom64<14, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x98>
  169dca:	nopw   0x0(%rax,%rax,1)
  169dd0:	imul   $0xab25f4c1,%r9d,%r9d
  169dd7:	vpbroadcastd %r9d,%ymm6
  169ddd:	vpmulld %ymm0,%ymm6,%ymm7
  169de2:	vpsrld $0x1c,%ymm7,%ymm8
  169de7:	vpermd %ymm4,%ymm8,%ymm4
  169dec:	vpermd %ymm5,%ymm8,%ymm5
  169df1:	vpsrad $0x1f,%ymm7,%ymm7
  169df6:	vpblendvb %ymm7,%ymm5,%ymm4,%ymm4
  169dfc:	vpmulld %ymm1,%ymm6,%ymm5
  169e01:	vpsrld $0x1b,%ymm5,%ymm5
  169e06:	vpsllvd %ymm5,%ymm3,%ymm5
  169e0b:	vptest %ymm5,%ymm4
  169e10:	setb   %r9b
  169e14:	movzbl %r9b,%r9d
  169e18:	mov    %r9d,(%rcx,%r8,4)
  169e1c:	inc    %r8
  169e1f:	cmp    %r8,%rsi
  169e22:	je     169ecd <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<14, true>, unsigned long>(rocksdb_external::FastLocalBloom64<14, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x13d>
  169e28:	mov    (%rdx,%r8,8),%r9
  169e2c:	mov    %r9,%r10
  169e2f:	shr    $0x20,%r10
  169e33:	xor    %r9,%r10
  169e36:	imul   %rax,%r10
  169e3a:	mov    %r10,%r9
  169e3d:	shr    $0x20,%r9
  169e41:	xor    %r10,%r9
  169e44:	imul   %rax,%r9
  169e48:	mov    %r9d,%r10d
  169e4b:	shr    $0x20,%r9
  169e4f:	mov    0x18(%rdi),%r11d
  169e53:	mov    (%rdi),%rbx
  169e56:	shr    $0x6,%r11d
  169e5a:	xor    %r9,%r10
  169e5d:	imul   %r11,%r10
  169e61:	shr    $0x1a,%r10
  169e65:	and    $0xffffffc0,%r10d
  169e69:	prefetcht2 (%rbx,%r10,1)
  169e6e:	prefetcht2 0x3f(%rbx,%r10,1)
  169e74:	vmovdqu (%rbx,%r10,1),%ymm4
  169e7a:	vmovdqu 0x20(%rbx,%r10,1),%ymm5
  169e81:	vpbroadcastd %r9d,%ymm6
  169e87:	vpmulld %ymm0,%ymm6,%ymm7
  169e8c:	vpsrld $0x1c,%ymm7,%ymm8
  169e91:	vxorps %xmm9,%xmm9,%xmm9
  169e96:	vpermd %ymm4,%ymm8,%ymm9
  169e9b:	vpermd %ymm5,%ymm8,%ymm8
  169ea0:	vpsrad $0x1f,%ymm7,%ymm7
  169ea5:	vpblendvb %ymm7,%ymm8,%ymm9,%ymm7
  169eab:	vpmulld %ymm1,%ymm6,%ymm6
  169eb0:	vpsrld $0x1b,%ymm6,%ymm6
  169eb5:	vpsllvd %ymm6,%ymm2,%ymm6
  169eba:	vptest %ymm6,%ymm7
  169ebf:	jb     169dd0 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<14, true>, unsigned long>(rocksdb_external::FastLocalBloom64<14, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
  169ec5:	xor    %r9d,%r9d
  169ec8:	jmp    169e14 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<14, true>, unsigned long>(rocksdb_external::FastLocalBloom64<14, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x84>
  169ecd:	pop    %rbx
  169ece:	vzeroupper
  169ed1:	ret
  169ed2:	int3
  169ed3:	int3
  169ed4:	int3
  169ed5:	int3
  169ed6:	int3
  169ed7:	int3
  169ed8:	int3
  169ed9:	int3
  169eda:	int3
  169edb:	int3
  169edc:	int3
  169edd:	int3
  169ede:	int3
  169edf:	int3

