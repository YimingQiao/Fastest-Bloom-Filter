0000000000169190 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<14, true>, unsigned long>(rocksdb_external::FastLocalBloom64<14, true> const&, unsigned long, unsigned long const*, unsigned int*)>:
  169190:	test   %rsi,%rsi
  169193:	je     1692ce <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<14, true>, unsigned long>(rocksdb_external::FastLocalBloom64<14, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x13e>
  169199:	push   %rbx
  16919a:	movabs $0xd6e8feb86659fd93,%rax
  1691a4:	xor    %r8d,%r8d
  1691a7:	vmovdqa -0x1646cf(%rip),%ymm0        # 4ae0 <typeinfo name for main::$_60+0x310>
  1691af:	vmovdqa -0x164837(%rip),%ymm1        # 4980 <typeinfo name for main::$_60+0x1b0>
  1691b7:	vpbroadcastd -0x165f18(%rip),%ymm2        # 32a8 <__abi_tag+0x2fe4>
  1691c0:	vmovdqa -0x164968(%rip),%ymm3        # 4860 <typeinfo name for main::$_60+0x90>
  1691c8:	jmp    169228 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<14, true>, unsigned long>(rocksdb_external::FastLocalBloom64<14, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x98>
  1691ca:	nopw   0x0(%rax,%rax,1)
  1691d0:	imul   $0xab25f4c1,%r9d,%r9d
  1691d7:	vpbroadcastd %r9d,%ymm6
  1691dd:	vpmulld %ymm0,%ymm6,%ymm7
  1691e2:	vpsrld $0x1c,%ymm7,%ymm8
  1691e7:	vpermd %ymm4,%ymm8,%ymm4
  1691ec:	vpermd %ymm5,%ymm8,%ymm5
  1691f1:	vpsrad $0x1f,%ymm7,%ymm7
  1691f6:	vpblendvb %ymm7,%ymm5,%ymm4,%ymm4
  1691fc:	vpmulld %ymm1,%ymm6,%ymm5
  169201:	vpsrld $0x1b,%ymm5,%ymm5
  169206:	vpsllvd %ymm5,%ymm3,%ymm5
  16920b:	vptest %ymm5,%ymm4
  169210:	setb   %r9b
  169214:	movzbl %r9b,%r9d
  169218:	mov    %r9d,(%rcx,%r8,4)
  16921c:	inc    %r8
  16921f:	cmp    %r8,%rsi
  169222:	je     1692cd <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<14, true>, unsigned long>(rocksdb_external::FastLocalBloom64<14, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x13d>
  169228:	mov    (%rdx,%r8,8),%r9
  16922c:	mov    %r9,%r10
  16922f:	shr    $0x20,%r10
  169233:	xor    %r9,%r10
  169236:	imul   %rax,%r10
  16923a:	mov    %r10,%r9
  16923d:	shr    $0x20,%r9
  169241:	xor    %r10,%r9
  169244:	imul   %rax,%r9
  169248:	mov    %r9d,%r10d
  16924b:	shr    $0x20,%r9
  16924f:	mov    0x18(%rdi),%r11d
  169253:	mov    (%rdi),%rbx
  169256:	shr    $0x6,%r11d
  16925a:	xor    %r9,%r10
  16925d:	imul   %r11,%r10
  169261:	shr    $0x1a,%r10
  169265:	and    $0xffffffc0,%r10d
  169269:	prefetcht2 (%rbx,%r10,1)
  16926e:	prefetcht2 0x3f(%rbx,%r10,1)
  169274:	vmovdqu (%rbx,%r10,1),%ymm4
  16927a:	vmovdqu 0x20(%rbx,%r10,1),%ymm5
  169281:	vpbroadcastd %r9d,%ymm6
  169287:	vpmulld %ymm0,%ymm6,%ymm7
  16928c:	vpsrld $0x1c,%ymm7,%ymm8
  169291:	vxorps %xmm9,%xmm9,%xmm9
  169296:	vpermd %ymm4,%ymm8,%ymm9
  16929b:	vpermd %ymm5,%ymm8,%ymm8
  1692a0:	vpsrad $0x1f,%ymm7,%ymm7
  1692a5:	vpblendvb %ymm7,%ymm8,%ymm9,%ymm7
  1692ab:	vpmulld %ymm1,%ymm6,%ymm6
  1692b0:	vpsrld $0x1b,%ymm6,%ymm6
  1692b5:	vpsllvd %ymm6,%ymm2,%ymm6
  1692ba:	vptest %ymm6,%ymm7
  1692bf:	jb     1691d0 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<14, true>, unsigned long>(rocksdb_external::FastLocalBloom64<14, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
  1692c5:	xor    %r9d,%r9d
  1692c8:	jmp    169214 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<14, true>, unsigned long>(rocksdb_external::FastLocalBloom64<14, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x84>
  1692cd:	pop    %rbx
  1692ce:	vzeroupper
  1692d1:	ret
  1692d2:	int3
  1692d3:	int3
  1692d4:	int3
  1692d5:	int3
  1692d6:	int3
  1692d7:	int3
  1692d8:	int3
  1692d9:	int3
  1692da:	int3
  1692db:	int3
  1692dc:	int3
  1692dd:	int3
  1692de:	int3
  1692df:	int3

