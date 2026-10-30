0000000000163b70 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<9, true>, unsigned long>(rocksdb_external::FastLocalBloom64<9, true> const&, unsigned long, unsigned long const*, unsigned int*)>:
  163b70:	test   %rsi,%rsi
  163b73:	je     163c80 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<9, true>, unsigned long>(rocksdb_external::FastLocalBloom64<9, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x110>
  163b79:	xor    %eax,%eax
  163b7b:	vmovdqa -0x15f0a3(%rip),%ymm0        # 4ae0 <typeinfo name for main::$_60+0x310>
  163b83:	vmovdqa -0x15f20b(%rip),%ymm1        # 4980 <typeinfo name for main::$_60+0x1b0>
  163b8b:	vpbroadcastd -0x1608ec(%rip),%ymm2        # 32a8 <__abi_tag+0x2fe4>
  163b94:	vmovd  -0x1608f4(%rip),%xmm3        # 32a8 <__abi_tag+0x2fe4>
  163b9c:	jmp    163bb0 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<9, true>, unsigned long>(rocksdb_external::FastLocalBloom64<9, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
  163b9e:	xchg   %ax,%ax
  163ba0:	mov    %r9d,(%rcx,%rax,4)
  163ba4:	inc    %rax
  163ba7:	cmp    %rax,%rsi
  163baa:	je     163c80 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<9, true>, unsigned long>(rocksdb_external::FastLocalBloom64<9, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x110>
  163bb0:	mov    (%rdx,%rax,8),%r8
  163bb4:	mov    0x18(%rdi),%r9d
  163bb8:	mov    (%rdi),%r10
  163bbb:	shr    $0x6,%r9d
  163bbf:	mov    %r8d,%r11d
  163bc2:	imul   %r9,%r11
  163bc6:	shr    $0x1a,%r11
  163bca:	and    $0xffffffc0,%r11d
  163bce:	shr    $0x20,%r8
  163bd2:	prefetcht2 (%r10,%r11,1)
  163bd7:	vmovdqu (%r10,%r11,1),%ymm4
  163bdd:	vmovdqu 0x20(%r10,%r11,1),%ymm5
  163be4:	vpbroadcastd %r8d,%ymm6
  163bea:	vpmulld %ymm0,%ymm6,%ymm7
  163bef:	vpsrld $0x1c,%ymm7,%ymm8
  163bf4:	vxorps %xmm9,%xmm9,%xmm9
  163bf9:	vpermd %ymm4,%ymm8,%ymm9
  163bfe:	vpermd %ymm5,%ymm8,%ymm8
  163c03:	vpsrad $0x1f,%ymm7,%ymm7
  163c08:	vpblendvb %ymm7,%ymm8,%ymm9,%ymm7
  163c0e:	vpmulld %ymm1,%ymm6,%ymm6
  163c13:	prefetcht2 0x3f(%r10,%r11,1)
  163c19:	vpsrld $0x1b,%ymm6,%ymm6
  163c1e:	vpsllvd %ymm6,%ymm2,%ymm6
  163c23:	vptest %ymm6,%ymm7
  163c28:	mov    $0x0,%r9d
  163c2e:	jae    163ba0 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<9, true>, unsigned long>(rocksdb_external::FastLocalBloom64<9, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
  163c34:	imul   $0xab25f4c1,%r8d,%r8d
  163c3b:	vpbroadcastd %r8d,%ymm6
  163c41:	vpmulld %ymm0,%ymm6,%ymm7
  163c46:	vpsrld $0x1c,%ymm7,%ymm8
  163c4b:	vpermd %ymm4,%ymm8,%ymm4
  163c50:	vpermd %ymm5,%ymm8,%ymm5
  163c55:	vpsrad $0x1f,%ymm7,%ymm7
  163c5a:	vpblendvb %ymm7,%ymm5,%ymm4,%ymm4
  163c60:	vpmulld %ymm1,%ymm6,%ymm5
  163c65:	vpsrld $0x1b,%ymm5,%ymm5
  163c6a:	vpsllvd %ymm5,%ymm3,%ymm5
  163c6f:	xor    %r9d,%r9d
  163c72:	vptest %ymm5,%ymm4
  163c77:	setb   %r9b
  163c7b:	jmp    163ba0 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<9, true>, unsigned long>(rocksdb_external::FastLocalBloom64<9, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
  163c80:	vzeroupper
  163c83:	ret
  163c84:	int3
  163c85:	int3
  163c86:	int3
  163c87:	int3
  163c88:	int3
  163c89:	int3
  163c8a:	int3
  163c8b:	int3
  163c8c:	int3
  163c8d:	int3
  163c8e:	int3
  163c8f:	int3

