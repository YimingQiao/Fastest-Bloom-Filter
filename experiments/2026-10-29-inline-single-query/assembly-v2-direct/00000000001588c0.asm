00000000001588c0 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<14, false>, unsigned long>(rocksdb_external::FastLocalBloom64<14, false> const&, unsigned long, unsigned long const*, unsigned int*)>:
  1588c0:	test   %rsi,%rsi
  1588c3:	je     1589f3 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<14, false>, unsigned long>(rocksdb_external::FastLocalBloom64<14, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x133>
  1588c9:	push   %rbx
  1588ca:	movabs $0xd6e8feb86659fd93,%rax
  1588d4:	xor    %r8d,%r8d
  1588d7:	vmovdqa -0x153dff(%rip),%ymm0        # 4ae0 <typeinfo name for main::$_60+0x310>
  1588df:	vmovdqa -0x153f67(%rip),%ymm1        # 4980 <typeinfo name for main::$_60+0x1b0>
  1588e7:	vpbroadcastd -0x155648(%rip),%ymm2        # 32a8 <__abi_tag+0x2fe4>
  1588f0:	vmovdqa -0x154098(%rip),%ymm3        # 4860 <typeinfo name for main::$_60+0x90>
  1588f8:	jmp    158958 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<14, false>, unsigned long>(rocksdb_external::FastLocalBloom64<14, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x98>
  1588fa:	nopw   0x0(%rax,%rax,1)
  158900:	imul   $0xab25f4c1,%r9d,%r9d
  158907:	vpbroadcastd %r9d,%ymm6
  15890d:	vpmulld %ymm0,%ymm6,%ymm7
  158912:	vpsrld $0x1c,%ymm7,%ymm8
  158917:	vpermd %ymm4,%ymm8,%ymm4
  15891c:	vpermd %ymm5,%ymm8,%ymm5
  158921:	vpsrad $0x1f,%ymm7,%ymm7
  158926:	vpblendvb %ymm7,%ymm5,%ymm4,%ymm4
  15892c:	vpmulld %ymm1,%ymm6,%ymm5
  158931:	vpsrld $0x1b,%ymm5,%ymm5
  158936:	vpsllvd %ymm5,%ymm3,%ymm5
  15893b:	vptest %ymm5,%ymm4
  158940:	setb   %r9b
  158944:	movzbl %r9b,%r9d
  158948:	mov    %r9d,(%rcx,%r8,4)
  15894c:	inc    %r8
  15894f:	cmp    %r8,%rsi
  158952:	je     1589f2 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<14, false>, unsigned long>(rocksdb_external::FastLocalBloom64<14, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x132>
  158958:	mov    (%rdx,%r8,8),%r9
  15895c:	mov    %r9,%r10
  15895f:	shr    $0x20,%r10
  158963:	xor    %r9,%r10
  158966:	imul   %rax,%r10
  15896a:	mov    %r10,%r9
  15896d:	shr    $0x20,%r9
  158971:	xor    %r10,%r9
  158974:	imul   %rax,%r9
  158978:	mov    %r9d,%r10d
  15897b:	shr    $0x20,%r9
  15897f:	mov    0x18(%rdi),%r11d
  158983:	mov    (%rdi),%rbx
  158986:	shr    $0x6,%r11d
  15898a:	xor    %r9,%r10
  15898d:	imul   %r11,%r10
  158991:	shr    $0x1a,%r10
  158995:	and    $0xffffffc0,%r10d
  158999:	vmovdqu (%rbx,%r10,1),%ymm4
  15899f:	vmovdqu 0x20(%rbx,%r10,1),%ymm5
  1589a6:	vpbroadcastd %r9d,%ymm6
  1589ac:	vpmulld %ymm0,%ymm6,%ymm7
  1589b1:	vpsrld $0x1c,%ymm7,%ymm8
  1589b6:	vxorps %xmm9,%xmm9,%xmm9
  1589bb:	vpermd %ymm4,%ymm8,%ymm9
  1589c0:	vpermd %ymm5,%ymm8,%ymm8
  1589c5:	vpsrad $0x1f,%ymm7,%ymm7
  1589ca:	vpblendvb %ymm7,%ymm8,%ymm9,%ymm7
  1589d0:	vpmulld %ymm1,%ymm6,%ymm6
  1589d5:	vpsrld $0x1b,%ymm6,%ymm6
  1589da:	vpsllvd %ymm6,%ymm2,%ymm6
  1589df:	vptest %ymm6,%ymm7
  1589e4:	jb     158900 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<14, false>, unsigned long>(rocksdb_external::FastLocalBloom64<14, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
  1589ea:	xor    %r9d,%r9d
  1589ed:	jmp    158944 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<14, false>, unsigned long>(rocksdb_external::FastLocalBloom64<14, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x84>
  1589f2:	pop    %rbx
  1589f3:	vzeroupper
  1589f6:	ret
  1589f7:	int3
  1589f8:	int3
  1589f9:	int3
  1589fa:	int3
  1589fb:	int3
  1589fc:	int3
  1589fd:	int3
  1589fe:	int3
  1589ff:	int3

