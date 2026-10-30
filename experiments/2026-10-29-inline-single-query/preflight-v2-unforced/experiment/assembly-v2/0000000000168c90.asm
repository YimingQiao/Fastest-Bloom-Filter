0000000000168c90 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<14, true>, unsigned long>(rocksdb_external::FastLocalBloom64<14, true> const&, unsigned long, unsigned long const*, unsigned int*)>:
  168c90:	test   %rsi,%rsi
  168c93:	je     168d9e <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<14, true>, unsigned long>(rocksdb_external::FastLocalBloom64<14, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x10e>
  168c99:	xor    %eax,%eax
  168c9b:	vmovdqa -0x1641c3(%rip),%ymm0        # 4ae0 <typeinfo name for main::$_60+0x310>
  168ca3:	vmovdqa -0x16432b(%rip),%ymm1        # 4980 <typeinfo name for main::$_60+0x1b0>
  168cab:	vpbroadcastd -0x165a0c(%rip),%ymm2        # 32a8 <__abi_tag+0x2fe4>
  168cb4:	vmovdqa -0x16445c(%rip),%ymm3        # 4860 <typeinfo name for main::$_60+0x90>
  168cbc:	jmp    168d18 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<14, true>, unsigned long>(rocksdb_external::FastLocalBloom64<14, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x88>
  168cbe:	xchg   %ax,%ax
  168cc0:	imul   $0xab25f4c1,%r8d,%r8d
  168cc7:	vpbroadcastd %r8d,%ymm6
  168ccd:	vpmulld %ymm0,%ymm6,%ymm7
  168cd2:	vpsrld $0x1c,%ymm7,%ymm8
  168cd7:	vpermd %ymm4,%ymm8,%ymm4
  168cdc:	vpermd %ymm5,%ymm8,%ymm5
  168ce1:	vpsrad $0x1f,%ymm7,%ymm7
  168ce6:	vpblendvb %ymm7,%ymm5,%ymm4,%ymm4
  168cec:	vpmulld %ymm1,%ymm6,%ymm5
  168cf1:	vpsrld $0x1b,%ymm5,%ymm5
  168cf6:	vpsllvd %ymm5,%ymm3,%ymm5
  168cfb:	vptest %ymm5,%ymm4
  168d00:	setb   %r8b
  168d04:	movzbl %r8b,%r8d
  168d08:	mov    %r8d,(%rcx,%rax,4)
  168d0c:	inc    %rax
  168d0f:	cmp    %rax,%rsi
  168d12:	je     168d9e <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<14, true>, unsigned long>(rocksdb_external::FastLocalBloom64<14, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x10e>
  168d18:	mov    (%rdx,%rax,8),%r8
  168d1c:	mov    0x18(%rdi),%r9d
  168d20:	mov    (%rdi),%r10
  168d23:	shr    $0x6,%r9d
  168d27:	mov    %r8d,%r11d
  168d2a:	imul   %r9,%r11
  168d2e:	shr    $0x1a,%r11
  168d32:	and    $0xffffffc0,%r11d
  168d36:	shr    $0x20,%r8
  168d3a:	prefetcht2 (%r10,%r11,1)
  168d3f:	prefetcht2 0x3f(%r10,%r11,1)
  168d45:	vmovdqu (%r10,%r11,1),%ymm4
  168d4b:	vmovdqu 0x20(%r10,%r11,1),%ymm5
  168d52:	vpbroadcastd %r8d,%ymm6
  168d58:	vpmulld %ymm0,%ymm6,%ymm7
  168d5d:	vpsrld $0x1c,%ymm7,%ymm8
  168d62:	vxorps %xmm9,%xmm9,%xmm9
  168d67:	vpermd %ymm4,%ymm8,%ymm9
  168d6c:	vpermd %ymm5,%ymm8,%ymm8
  168d71:	vpsrad $0x1f,%ymm7,%ymm7
  168d76:	vpblendvb %ymm7,%ymm8,%ymm9,%ymm7
  168d7c:	vpmulld %ymm1,%ymm6,%ymm6
  168d81:	vpsrld $0x1b,%ymm6,%ymm6
  168d86:	vpsllvd %ymm6,%ymm2,%ymm6
  168d8b:	vptest %ymm6,%ymm7
  168d90:	jb     168cc0 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<14, true>, unsigned long>(rocksdb_external::FastLocalBloom64<14, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
  168d96:	xor    %r8d,%r8d
  168d99:	jmp    168d04 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<14, true>, unsigned long>(rocksdb_external::FastLocalBloom64<14, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x74>
  168d9e:	vzeroupper
  168da1:	ret
  168da2:	int3
  168da3:	int3
  168da4:	int3
  168da5:	int3
  168da6:	int3
  168da7:	int3
  168da8:	int3
  168da9:	int3
  168daa:	int3
  168dab:	int3
  168dac:	int3
  168dad:	int3
  168dae:	int3
  168daf:	int3

