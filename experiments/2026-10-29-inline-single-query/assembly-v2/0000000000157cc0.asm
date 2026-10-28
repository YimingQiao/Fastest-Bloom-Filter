0000000000157cc0 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<14, false>, unsigned long>(rocksdb_external::FastLocalBloom64<14, false> const&, unsigned long, unsigned long const*, unsigned int*)>:
  157cc0:	test   %rsi,%rsi
  157cc3:	je     157df3 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<14, false>, unsigned long>(rocksdb_external::FastLocalBloom64<14, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x133>
  157cc9:	push   %rbx
  157cca:	movabs $0xd6e8feb86659fd93,%rax
  157cd4:	xor    %r8d,%r8d
  157cd7:	vmovdqa -0x1531ff(%rip),%ymm0        # 4ae0 <typeinfo name for main::$_60+0x310>
  157cdf:	vmovdqa -0x153367(%rip),%ymm1        # 4980 <typeinfo name for main::$_60+0x1b0>
  157ce7:	vpbroadcastd -0x154a48(%rip),%ymm2        # 32a8 <__abi_tag+0x2fe4>
  157cf0:	vmovdqa -0x153498(%rip),%ymm3        # 4860 <typeinfo name for main::$_60+0x90>
  157cf8:	jmp    157d58 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<14, false>, unsigned long>(rocksdb_external::FastLocalBloom64<14, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x98>
  157cfa:	nopw   0x0(%rax,%rax,1)
  157d00:	imul   $0xab25f4c1,%r9d,%r9d
  157d07:	vpbroadcastd %r9d,%ymm6
  157d0d:	vpmulld %ymm0,%ymm6,%ymm7
  157d12:	vpsrld $0x1c,%ymm7,%ymm8
  157d17:	vpermd %ymm4,%ymm8,%ymm4
  157d1c:	vpermd %ymm5,%ymm8,%ymm5
  157d21:	vpsrad $0x1f,%ymm7,%ymm7
  157d26:	vpblendvb %ymm7,%ymm5,%ymm4,%ymm4
  157d2c:	vpmulld %ymm1,%ymm6,%ymm5
  157d31:	vpsrld $0x1b,%ymm5,%ymm5
  157d36:	vpsllvd %ymm5,%ymm3,%ymm5
  157d3b:	vptest %ymm5,%ymm4
  157d40:	setb   %r9b
  157d44:	movzbl %r9b,%r9d
  157d48:	mov    %r9d,(%rcx,%r8,4)
  157d4c:	inc    %r8
  157d4f:	cmp    %r8,%rsi
  157d52:	je     157df2 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<14, false>, unsigned long>(rocksdb_external::FastLocalBloom64<14, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x132>
  157d58:	mov    (%rdx,%r8,8),%r9
  157d5c:	mov    %r9,%r10
  157d5f:	shr    $0x20,%r10
  157d63:	xor    %r9,%r10
  157d66:	imul   %rax,%r10
  157d6a:	mov    %r10,%r9
  157d6d:	shr    $0x20,%r9
  157d71:	xor    %r10,%r9
  157d74:	imul   %rax,%r9
  157d78:	mov    %r9d,%r10d
  157d7b:	shr    $0x20,%r9
  157d7f:	mov    0x18(%rdi),%r11d
  157d83:	mov    (%rdi),%rbx
  157d86:	shr    $0x6,%r11d
  157d8a:	xor    %r9,%r10
  157d8d:	imul   %r11,%r10
  157d91:	shr    $0x1a,%r10
  157d95:	and    $0xffffffc0,%r10d
  157d99:	vmovdqu (%rbx,%r10,1),%ymm4
  157d9f:	vmovdqu 0x20(%rbx,%r10,1),%ymm5
  157da6:	vpbroadcastd %r9d,%ymm6
  157dac:	vpmulld %ymm0,%ymm6,%ymm7
  157db1:	vpsrld $0x1c,%ymm7,%ymm8
  157db6:	vxorps %xmm9,%xmm9,%xmm9
  157dbb:	vpermd %ymm4,%ymm8,%ymm9
  157dc0:	vpermd %ymm5,%ymm8,%ymm8
  157dc5:	vpsrad $0x1f,%ymm7,%ymm7
  157dca:	vpblendvb %ymm7,%ymm8,%ymm9,%ymm7
  157dd0:	vpmulld %ymm1,%ymm6,%ymm6
  157dd5:	vpsrld $0x1b,%ymm6,%ymm6
  157dda:	vpsllvd %ymm6,%ymm2,%ymm6
  157ddf:	vptest %ymm6,%ymm7
  157de4:	jb     157d00 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<14, false>, unsigned long>(rocksdb_external::FastLocalBloom64<14, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
  157dea:	xor    %r9d,%r9d
  157ded:	jmp    157d44 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<14, false>, unsigned long>(rocksdb_external::FastLocalBloom64<14, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x84>
  157df2:	pop    %rbx
  157df3:	vzeroupper
  157df6:	ret
  157df7:	int3
  157df8:	int3
  157df9:	int3
  157dfa:	int3
  157dfb:	int3
  157dfc:	int3
  157dfd:	int3
  157dfe:	int3
  157dff:	int3

