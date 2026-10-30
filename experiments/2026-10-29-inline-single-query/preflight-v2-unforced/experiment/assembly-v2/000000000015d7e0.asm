000000000015d7e0 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<8, true>, unsigned long>(rocksdb_external::FastLocalBloom64<8, true> const&, unsigned long, unsigned long const*, unsigned int*)>:
  15d7e0:	test   %rsi,%rsi
  15d7e3:	je     15d8b4 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<8, true>, unsigned long>(rocksdb_external::FastLocalBloom64<8, true> const&, unsigned long, unsigned long const*, unsigned int*)+0xd4>
  15d7e9:	push   %rbx
  15d7ea:	movabs $0xd6e8feb86659fd93,%rax
  15d7f4:	xor    %r8d,%r8d
  15d7f7:	vmovdqa -0x158d1f(%rip),%ymm0        # 4ae0 <typeinfo name for main::$_60+0x310>
  15d7ff:	vmovdqa -0x158e87(%rip),%ymm1        # 4980 <typeinfo name for main::$_60+0x1b0>
  15d807:	vpbroadcastd -0x15a568(%rip),%ymm2        # 32a8 <__abi_tag+0x2fe4>
  15d810:	mov    (%rdx,%r8,8),%r9
  15d814:	mov    %r9,%r10
  15d817:	shr    $0x20,%r10
  15d81b:	xor    %r9,%r10
  15d81e:	imul   %rax,%r10
  15d822:	mov    %r10,%r11
  15d825:	shr    $0x20,%r11
  15d829:	xor    %r10,%r11
  15d82c:	imul   %rax,%r11
  15d830:	mov    %r11d,%r9d
  15d833:	shr    $0x20,%r11
  15d837:	mov    0x18(%rdi),%r10d
  15d83b:	mov    (%rdi),%rbx
  15d83e:	shr    $0x6,%r10d
  15d842:	xor    %r11,%r9
  15d845:	imul   %r10,%r9
  15d849:	shr    $0x1a,%r9
  15d84d:	vpbroadcastd %r11d,%ymm3
  15d853:	vpmulld %ymm0,%ymm3,%ymm4
  15d858:	and    $0xffffffc0,%r9d
  15d85c:	vpsrld $0x1c,%ymm4,%ymm5
  15d861:	vxorps %xmm6,%xmm6,%xmm6
  15d865:	vpermd (%rbx,%r9,1),%ymm5,%ymm6
  15d86b:	vpermd 0x20(%rbx,%r9,1),%ymm5,%ymm5
  15d872:	vpsrad $0x1f,%ymm4,%ymm4
  15d877:	vpblendvb %ymm4,%ymm5,%ymm6,%ymm4
  15d87d:	vpmulld %ymm1,%ymm3,%ymm3
  15d882:	prefetcht2 (%rbx,%r9,1)
  15d887:	vpsrld $0x1b,%ymm3,%ymm3
  15d88c:	vpsllvd %ymm3,%ymm2,%ymm3
  15d891:	xor    %r10d,%r10d
  15d894:	vptest %ymm3,%ymm4
  15d899:	prefetcht2 0x3f(%rbx,%r9,1)
  15d89f:	setb   %r10b
  15d8a3:	mov    %r10d,(%rcx,%r8,4)
  15d8a7:	inc    %r8
  15d8aa:	cmp    %r8,%rsi
  15d8ad:	jne    15d810 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<8, true>, unsigned long>(rocksdb_external::FastLocalBloom64<8, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
  15d8b3:	pop    %rbx
  15d8b4:	vzeroupper
  15d8b7:	ret
  15d8b8:	int3
  15d8b9:	int3
  15d8ba:	int3
  15d8bb:	int3
  15d8bc:	int3
  15d8bd:	int3
  15d8be:	int3
  15d8bf:	int3

