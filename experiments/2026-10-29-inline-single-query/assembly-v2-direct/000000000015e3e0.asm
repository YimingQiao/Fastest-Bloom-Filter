000000000015e3e0 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<8, true>, unsigned long>(rocksdb_external::FastLocalBloom64<8, true> const&, unsigned long, unsigned long const*, unsigned int*)>:
  15e3e0:	test   %rsi,%rsi
  15e3e3:	je     15e4b4 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<8, true>, unsigned long>(rocksdb_external::FastLocalBloom64<8, true> const&, unsigned long, unsigned long const*, unsigned int*)+0xd4>
  15e3e9:	push   %rbx
  15e3ea:	movabs $0xd6e8feb86659fd93,%rax
  15e3f4:	xor    %r8d,%r8d
  15e3f7:	vmovdqa -0x15991f(%rip),%ymm0        # 4ae0 <typeinfo name for main::$_60+0x310>
  15e3ff:	vmovdqa -0x159a87(%rip),%ymm1        # 4980 <typeinfo name for main::$_60+0x1b0>
  15e407:	vpbroadcastd -0x15b168(%rip),%ymm2        # 32a8 <__abi_tag+0x2fe4>
  15e410:	mov    (%rdx,%r8,8),%r9
  15e414:	mov    %r9,%r10
  15e417:	shr    $0x20,%r10
  15e41b:	xor    %r9,%r10
  15e41e:	imul   %rax,%r10
  15e422:	mov    %r10,%r11
  15e425:	shr    $0x20,%r11
  15e429:	xor    %r10,%r11
  15e42c:	imul   %rax,%r11
  15e430:	mov    %r11d,%r9d
  15e433:	shr    $0x20,%r11
  15e437:	mov    0x18(%rdi),%r10d
  15e43b:	mov    (%rdi),%rbx
  15e43e:	shr    $0x6,%r10d
  15e442:	xor    %r11,%r9
  15e445:	imul   %r10,%r9
  15e449:	shr    $0x1a,%r9
  15e44d:	vpbroadcastd %r11d,%ymm3
  15e453:	vpmulld %ymm0,%ymm3,%ymm4
  15e458:	and    $0xffffffc0,%r9d
  15e45c:	vpsrld $0x1c,%ymm4,%ymm5
  15e461:	vxorps %xmm6,%xmm6,%xmm6
  15e465:	vpermd (%rbx,%r9,1),%ymm5,%ymm6
  15e46b:	vpermd 0x20(%rbx,%r9,1),%ymm5,%ymm5
  15e472:	vpsrad $0x1f,%ymm4,%ymm4
  15e477:	vpblendvb %ymm4,%ymm5,%ymm6,%ymm4
  15e47d:	vpmulld %ymm1,%ymm3,%ymm3
  15e482:	prefetcht2 (%rbx,%r9,1)
  15e487:	vpsrld $0x1b,%ymm3,%ymm3
  15e48c:	vpsllvd %ymm3,%ymm2,%ymm3
  15e491:	xor    %r10d,%r10d
  15e494:	vptest %ymm3,%ymm4
  15e499:	prefetcht2 0x3f(%rbx,%r9,1)
  15e49f:	setb   %r10b
  15e4a3:	mov    %r10d,(%rcx,%r8,4)
  15e4a7:	inc    %r8
  15e4aa:	cmp    %r8,%rsi
  15e4ad:	jne    15e410 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<8, true>, unsigned long>(rocksdb_external::FastLocalBloom64<8, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
  15e4b3:	pop    %rbx
  15e4b4:	vzeroupper
  15e4b7:	ret
  15e4b8:	int3
  15e4b9:	int3
  15e4ba:	int3
  15e4bb:	int3
  15e4bc:	int3
  15e4bd:	int3
  15e4be:	int3
  15e4bf:	int3

