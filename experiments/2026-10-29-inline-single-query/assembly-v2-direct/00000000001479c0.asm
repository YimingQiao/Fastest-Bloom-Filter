00000000001479c0 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<0, true>, unsigned long>(rocksdb_external::FastLocalBloom64<0, true> const&, unsigned long, unsigned long const*, unsigned int*)>:
  1479c0:	test   %rsi,%rsi
  1479c3:	je     147ae5 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<0, true>, unsigned long>(rocksdb_external::FastLocalBloom64<0, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x125>
  1479c9:	push   %rbx
  1479ca:	movabs $0xd6e8feb86659fd93,%rax
  1479d4:	xor    %r8d,%r8d
  1479d7:	vmovdqa -0x142eff(%rip),%ymm0        # 4ae0 <typeinfo name for main::$_60+0x310>
  1479df:	vmovdqa -0x143127(%rip),%ymm1        # 48c0 <typeinfo name for main::$_60+0xf0>
  1479e7:	vmovdqa -0x14306f(%rip),%ymm2        # 4980 <typeinfo name for main::$_60+0x1b0>
  1479ef:	jmp    147a10 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<0, true>, unsigned long>(rocksdb_external::FastLocalBloom64<0, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  1479f1:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  147a00:	mov    %r11d,(%rcx,%r8,4)
  147a04:	inc    %r8
  147a07:	cmp    %rsi,%r8
  147a0a:	je     147ae4 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<0, true>, unsigned long>(rocksdb_external::FastLocalBloom64<0, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x124>
  147a10:	mov    (%rdx,%r8,8),%r9
  147a14:	mov    %r9,%r10
  147a17:	shr    $0x20,%r10
  147a1b:	xor    %r9,%r10
  147a1e:	imul   %rax,%r10
  147a22:	mov    %r10,%r9
  147a25:	shr    $0x20,%r9
  147a29:	xor    %r10,%r9
  147a2c:	imul   %rax,%r9
  147a30:	mov    %r9d,%r11d
  147a33:	shr    $0x20,%r9
  147a37:	mov    0x18(%rdi),%r10d
  147a3b:	mov    (%rdi),%rbx
  147a3e:	shr    $0x6,%r10d
  147a42:	xor    %r9,%r11
  147a45:	imul   %r10,%r11
  147a49:	shr    $0x1a,%r11
  147a4d:	and    $0xffffffc0,%r11d
  147a51:	prefetcht2 (%rbx,%r11,1)
  147a56:	prefetcht2 0x3f(%rbx,%r11,1)
  147a5c:	mov    0x1c(%rdi),%r10d
  147a60:	vmovdqu (%rbx,%r11,1),%ymm3
  147a66:	vmovdqu 0x20(%rbx,%r11,1),%ymm4
  147a6d:	nopl   (%rax)
  147a70:	vpbroadcastd %r9d,%ymm5
  147a76:	vpmulld %ymm0,%ymm5,%ymm6
  147a7b:	vpsrld $0x1c,%ymm6,%ymm7
  147a80:	vxorps %xmm8,%xmm8,%xmm8
  147a85:	vpermd %ymm3,%ymm7,%ymm8
  147a8a:	vpermd %ymm4,%ymm7,%ymm7
  147a8f:	vpsrad $0x1f,%ymm6,%ymm6
  147a94:	vpblendvb %ymm6,%ymm7,%ymm8,%ymm6
  147a9a:	vpbroadcastd %r10d,%ymm7
  147aa0:	vpsubd %ymm7,%ymm1,%ymm7
  147aa4:	vpsrld $0x1f,%ymm7,%ymm7
  147aa9:	vpmulld %ymm2,%ymm5,%ymm5
  147aae:	vpsrld $0x1b,%ymm5,%ymm5
  147ab3:	vpsllvd %ymm5,%ymm7,%ymm5
  147ab8:	xor    %r11d,%r11d
  147abb:	vptest %ymm5,%ymm6
  147ac0:	setb   %r11b
  147ac4:	cmp    $0x9,%r10d
  147ac8:	jl     147a00 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<0, true>, unsigned long>(rocksdb_external::FastLocalBloom64<0, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
  147ace:	test   %r11d,%r11d
  147ad1:	je     147a00 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<0, true>, unsigned long>(rocksdb_external::FastLocalBloom64<0, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
  147ad7:	imul   $0xab25f4c1,%r9d,%r9d
  147ade:	add    $0xfffffff8,%r10d
  147ae2:	jmp    147a70 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<0, true>, unsigned long>(rocksdb_external::FastLocalBloom64<0, true> const&, unsigned long, unsigned long const*, unsigned int*)+0xb0>
  147ae4:	pop    %rbx
  147ae5:	vzeroupper
  147ae8:	ret
  147ae9:	int3
  147aea:	int3
  147aeb:	int3
  147aec:	int3
  147aed:	int3
  147aee:	int3
  147aef:	int3

