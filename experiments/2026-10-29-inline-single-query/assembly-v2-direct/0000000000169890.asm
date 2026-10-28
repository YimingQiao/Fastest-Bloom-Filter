0000000000169890 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<14, true>, unsigned long>(rocksdb_external::FastLocalBloom64<14, true> const&, unsigned long, unsigned long const*, unsigned int*)>:
  169890:	test   %rsi,%rsi
  169893:	je     16999e <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<14, true>, unsigned long>(rocksdb_external::FastLocalBloom64<14, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x10e>
  169899:	xor    %eax,%eax
  16989b:	vmovdqa -0x164dc3(%rip),%ymm0        # 4ae0 <typeinfo name for main::$_60+0x310>
  1698a3:	vmovdqa -0x164f2b(%rip),%ymm1        # 4980 <typeinfo name for main::$_60+0x1b0>
  1698ab:	vpbroadcastd -0x16660c(%rip),%ymm2        # 32a8 <__abi_tag+0x2fe4>
  1698b4:	vmovdqa -0x16505c(%rip),%ymm3        # 4860 <typeinfo name for main::$_60+0x90>
  1698bc:	jmp    169918 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<14, true>, unsigned long>(rocksdb_external::FastLocalBloom64<14, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x88>
  1698be:	xchg   %ax,%ax
  1698c0:	imul   $0xab25f4c1,%r8d,%r8d
  1698c7:	vpbroadcastd %r8d,%ymm6
  1698cd:	vpmulld %ymm0,%ymm6,%ymm7
  1698d2:	vpsrld $0x1c,%ymm7,%ymm8
  1698d7:	vpermd %ymm4,%ymm8,%ymm4
  1698dc:	vpermd %ymm5,%ymm8,%ymm5
  1698e1:	vpsrad $0x1f,%ymm7,%ymm7
  1698e6:	vpblendvb %ymm7,%ymm5,%ymm4,%ymm4
  1698ec:	vpmulld %ymm1,%ymm6,%ymm5
  1698f1:	vpsrld $0x1b,%ymm5,%ymm5
  1698f6:	vpsllvd %ymm5,%ymm3,%ymm5
  1698fb:	vptest %ymm5,%ymm4
  169900:	setb   %r8b
  169904:	movzbl %r8b,%r8d
  169908:	mov    %r8d,(%rcx,%rax,4)
  16990c:	inc    %rax
  16990f:	cmp    %rax,%rsi
  169912:	je     16999e <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<14, true>, unsigned long>(rocksdb_external::FastLocalBloom64<14, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x10e>
  169918:	mov    (%rdx,%rax,8),%r8
  16991c:	mov    0x18(%rdi),%r9d
  169920:	mov    (%rdi),%r10
  169923:	shr    $0x6,%r9d
  169927:	mov    %r8d,%r11d
  16992a:	imul   %r9,%r11
  16992e:	shr    $0x1a,%r11
  169932:	and    $0xffffffc0,%r11d
  169936:	shr    $0x20,%r8
  16993a:	prefetcht2 (%r10,%r11,1)
  16993f:	prefetcht2 0x3f(%r10,%r11,1)
  169945:	vmovdqu (%r10,%r11,1),%ymm4
  16994b:	vmovdqu 0x20(%r10,%r11,1),%ymm5
  169952:	vpbroadcastd %r8d,%ymm6
  169958:	vpmulld %ymm0,%ymm6,%ymm7
  16995d:	vpsrld $0x1c,%ymm7,%ymm8
  169962:	vxorps %xmm9,%xmm9,%xmm9
  169967:	vpermd %ymm4,%ymm8,%ymm9
  16996c:	vpermd %ymm5,%ymm8,%ymm8
  169971:	vpsrad $0x1f,%ymm7,%ymm7
  169976:	vpblendvb %ymm7,%ymm8,%ymm9,%ymm7
  16997c:	vpmulld %ymm1,%ymm6,%ymm6
  169981:	vpsrld $0x1b,%ymm6,%ymm6
  169986:	vpsllvd %ymm6,%ymm2,%ymm6
  16998b:	vptest %ymm6,%ymm7
  169990:	jb     1698c0 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<14, true>, unsigned long>(rocksdb_external::FastLocalBloom64<14, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
  169996:	xor    %r8d,%r8d
  169999:	jmp    169904 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<14, true>, unsigned long>(rocksdb_external::FastLocalBloom64<14, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x74>
  16999e:	vzeroupper
  1699a1:	ret
  1699a2:	int3
  1699a3:	int3
  1699a4:	int3
  1699a5:	int3
  1699a6:	int3
  1699a7:	int3
  1699a8:	int3
  1699a9:	int3
  1699aa:	int3
  1699ab:	int3
  1699ac:	int3
  1699ad:	int3
  1699ae:	int3
  1699af:	int3

