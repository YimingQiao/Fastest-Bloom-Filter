00000000001583d0 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<14, false>, unsigned long>(rocksdb_external::FastLocalBloom64<14, false> const&, unsigned long, unsigned long const*, unsigned int*)>:
  1583d0:	test   %rsi,%rsi
  1583d3:	je     1584cf <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<14, false>, unsigned long>(rocksdb_external::FastLocalBloom64<14, false> const&, unsigned long, unsigned long const*, unsigned int*)+0xff>
  1583d9:	xor    %eax,%eax
  1583db:	vmovdqa -0x153903(%rip),%ymm0        # 4ae0 <typeinfo name for main::$_60+0x310>
  1583e3:	vmovdqa -0x153a6b(%rip),%ymm1        # 4980 <typeinfo name for main::$_60+0x1b0>
  1583eb:	vpbroadcastd -0x15514c(%rip),%ymm2        # 32a8 <__abi_tag+0x2fe4>
  1583f4:	vmovdqa -0x153b9c(%rip),%ymm3        # 4860 <typeinfo name for main::$_60+0x90>
  1583fc:	jmp    158454 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<14, false>, unsigned long>(rocksdb_external::FastLocalBloom64<14, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x84>
  1583fe:	xchg   %ax,%ax
  158400:	imul   $0xab25f4c1,%r8d,%r8d
  158407:	vpbroadcastd %r8d,%ymm6
  15840d:	vpmulld %ymm0,%ymm6,%ymm7
  158412:	vpsrld $0x1c,%ymm7,%ymm8
  158417:	vpermd %ymm4,%ymm8,%ymm4
  15841c:	vpermd %ymm5,%ymm8,%ymm5
  158421:	vpsrad $0x1f,%ymm7,%ymm7
  158426:	vpblendvb %ymm7,%ymm5,%ymm4,%ymm4
  15842c:	vpmulld %ymm1,%ymm6,%ymm5
  158431:	vpsrld $0x1b,%ymm5,%ymm5
  158436:	vpsllvd %ymm5,%ymm3,%ymm5
  15843b:	vptest %ymm5,%ymm4
  158440:	setb   %r8b
  158444:	movzbl %r8b,%r8d
  158448:	mov    %r8d,(%rcx,%rax,4)
  15844c:	inc    %rax
  15844f:	cmp    %rax,%rsi
  158452:	je     1584cf <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<14, false>, unsigned long>(rocksdb_external::FastLocalBloom64<14, false> const&, unsigned long, unsigned long const*, unsigned int*)+0xff>
  158454:	mov    (%rdx,%rax,8),%r8
  158458:	mov    %r8d,%r9d
  15845b:	shr    $0x20,%r8
  15845f:	mov    0x18(%rdi),%r10d
  158463:	mov    (%rdi),%r11
  158466:	shr    $0x6,%r10d
  15846a:	imul   %r10,%r9
  15846e:	shr    $0x1a,%r9
  158472:	and    $0xffffffc0,%r9d
  158476:	vmovdqu (%r11,%r9,1),%ymm4
  15847c:	vmovdqu 0x20(%r11,%r9,1),%ymm5
  158483:	vpbroadcastd %r8d,%ymm6
  158489:	vpmulld %ymm0,%ymm6,%ymm7
  15848e:	vpsrld $0x1c,%ymm7,%ymm8
  158493:	vxorps %xmm9,%xmm9,%xmm9
  158498:	vpermd %ymm4,%ymm8,%ymm9
  15849d:	vpermd %ymm5,%ymm8,%ymm8
  1584a2:	vpsrad $0x1f,%ymm7,%ymm7
  1584a7:	vpblendvb %ymm7,%ymm8,%ymm9,%ymm7
  1584ad:	vpmulld %ymm1,%ymm6,%ymm6
  1584b2:	vpsrld $0x1b,%ymm6,%ymm6
  1584b7:	vpsllvd %ymm6,%ymm2,%ymm6
  1584bc:	vptest %ymm6,%ymm7
  1584c1:	jb     158400 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<14, false>, unsigned long>(rocksdb_external::FastLocalBloom64<14, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
  1584c7:	xor    %r8d,%r8d
  1584ca:	jmp    158444 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<14, false>, unsigned long>(rocksdb_external::FastLocalBloom64<14, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x74>
  1584cf:	vzeroupper
  1584d2:	ret
  1584d3:	int3
  1584d4:	int3
  1584d5:	int3
  1584d6:	int3
  1584d7:	int3
  1584d8:	int3
  1584d9:	int3
  1584da:	int3
  1584db:	int3
  1584dc:	int3
  1584dd:	int3
  1584de:	int3
  1584df:	int3

