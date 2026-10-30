0000000000146dc0 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<0, true>, unsigned long>(rocksdb_external::FastLocalBloom64<0, true> const&, unsigned long, unsigned long const*, unsigned int*)>:
  146dc0:	test   %rsi,%rsi
  146dc3:	je     146ee5 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<0, true>, unsigned long>(rocksdb_external::FastLocalBloom64<0, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x125>
  146dc9:	push   %rbx
  146dca:	movabs $0xd6e8feb86659fd93,%rax
  146dd4:	xor    %r8d,%r8d
  146dd7:	vmovdqa -0x1422ff(%rip),%ymm0        # 4ae0 <typeinfo name for main::$_60+0x310>
  146ddf:	vmovdqa -0x142527(%rip),%ymm1        # 48c0 <typeinfo name for main::$_60+0xf0>
  146de7:	vmovdqa -0x14246f(%rip),%ymm2        # 4980 <typeinfo name for main::$_60+0x1b0>
  146def:	jmp    146e10 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<0, true>, unsigned long>(rocksdb_external::FastLocalBloom64<0, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  146df1:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  146e00:	mov    %r11d,(%rcx,%r8,4)
  146e04:	inc    %r8
  146e07:	cmp    %rsi,%r8
  146e0a:	je     146ee4 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<0, true>, unsigned long>(rocksdb_external::FastLocalBloom64<0, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x124>
  146e10:	mov    (%rdx,%r8,8),%r9
  146e14:	mov    %r9,%r10
  146e17:	shr    $0x20,%r10
  146e1b:	xor    %r9,%r10
  146e1e:	imul   %rax,%r10
  146e22:	mov    %r10,%r9
  146e25:	shr    $0x20,%r9
  146e29:	xor    %r10,%r9
  146e2c:	imul   %rax,%r9
  146e30:	mov    %r9d,%r11d
  146e33:	shr    $0x20,%r9
  146e37:	mov    0x18(%rdi),%r10d
  146e3b:	mov    (%rdi),%rbx
  146e3e:	shr    $0x6,%r10d
  146e42:	xor    %r9,%r11
  146e45:	imul   %r10,%r11
  146e49:	shr    $0x1a,%r11
  146e4d:	and    $0xffffffc0,%r11d
  146e51:	prefetcht2 (%rbx,%r11,1)
  146e56:	prefetcht2 0x3f(%rbx,%r11,1)
  146e5c:	mov    0x1c(%rdi),%r10d
  146e60:	vmovdqu (%rbx,%r11,1),%ymm3
  146e66:	vmovdqu 0x20(%rbx,%r11,1),%ymm4
  146e6d:	nopl   (%rax)
  146e70:	vpbroadcastd %r9d,%ymm5
  146e76:	vpmulld %ymm0,%ymm5,%ymm6
  146e7b:	vpsrld $0x1c,%ymm6,%ymm7
  146e80:	vxorps %xmm8,%xmm8,%xmm8
  146e85:	vpermd %ymm3,%ymm7,%ymm8
  146e8a:	vpermd %ymm4,%ymm7,%ymm7
  146e8f:	vpsrad $0x1f,%ymm6,%ymm6
  146e94:	vpblendvb %ymm6,%ymm7,%ymm8,%ymm6
  146e9a:	vpbroadcastd %r10d,%ymm7
  146ea0:	vpsubd %ymm7,%ymm1,%ymm7
  146ea4:	vpsrld $0x1f,%ymm7,%ymm7
  146ea9:	vpmulld %ymm2,%ymm5,%ymm5
  146eae:	vpsrld $0x1b,%ymm5,%ymm5
  146eb3:	vpsllvd %ymm5,%ymm7,%ymm5
  146eb8:	xor    %r11d,%r11d
  146ebb:	vptest %ymm5,%ymm6
  146ec0:	setb   %r11b
  146ec4:	cmp    $0x9,%r10d
  146ec8:	jl     146e00 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<0, true>, unsigned long>(rocksdb_external::FastLocalBloom64<0, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
  146ece:	test   %r11d,%r11d
  146ed1:	je     146e00 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<0, true>, unsigned long>(rocksdb_external::FastLocalBloom64<0, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
  146ed7:	imul   $0xab25f4c1,%r9d,%r9d
  146ede:	add    $0xfffffff8,%r10d
  146ee2:	jmp    146e70 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<0, true>, unsigned long>(rocksdb_external::FastLocalBloom64<0, true> const&, unsigned long, unsigned long const*, unsigned int*)+0xb0>
  146ee4:	pop    %rbx
  146ee5:	vzeroupper
  146ee8:	ret
  146ee9:	int3
  146eea:	int3
  146eeb:	int3
  146eec:	int3
  146eed:	int3
  146eee:	int3
  146eef:	int3

