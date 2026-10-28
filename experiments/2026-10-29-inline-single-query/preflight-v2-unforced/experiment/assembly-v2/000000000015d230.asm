000000000015d230 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<8, true>, unsigned long>(rocksdb_external::FastLocalBloom64<8, true> const&, unsigned long, unsigned long const*, unsigned int*)>:
  15d230:	test   %rsi,%rsi
  15d233:	je     15d3fc <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<8, true>, unsigned long>(rocksdb_external::FastLocalBloom64<8, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x1cc>
  15d239:	push   %rbx
  15d23a:	cmp    $0x1,%rsi
  15d23e:	jne    15d247 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<8, true>, unsigned long>(rocksdb_external::FastLocalBloom64<8, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x17>
  15d240:	xor    %eax,%eax
  15d242:	jmp    15d377 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<8, true>, unsigned long>(rocksdb_external::FastLocalBloom64<8, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x147>
  15d247:	mov    %rsi,%r8
  15d24a:	and    $0xfffffffffffffffe,%r8
  15d24e:	xor    %eax,%eax
  15d250:	vmovdqa -0x158778(%rip),%ymm0        # 4ae0 <typeinfo name for main::$_60+0x310>
  15d258:	vmovdqa -0x1588e0(%rip),%ymm1        # 4980 <typeinfo name for main::$_60+0x1b0>
  15d260:	vpbroadcastd -0x159fc1(%rip),%ymm2        # 32a8 <__abi_tag+0x2fe4>
  15d269:	nopl   0x0(%rax)
  15d270:	mov    (%rdx,%rax,8),%r9
  15d274:	mov    0x18(%rdi),%r10d
  15d278:	mov    (%rdi),%r11
  15d27b:	shr    $0x6,%r10d
  15d27f:	mov    %r9d,%ebx
  15d282:	imul   %r10,%rbx
  15d286:	shr    $0x1a,%rbx
  15d28a:	and    $0xffffffc0,%ebx
  15d28d:	shr    $0x20,%r9
  15d291:	prefetcht2 (%r11,%rbx,1)
  15d296:	vpbroadcastd %r9d,%ymm3
  15d29c:	vpmulld %ymm0,%ymm3,%ymm4
  15d2a1:	vpsrld $0x1c,%ymm4,%ymm5
  15d2a6:	vxorps %xmm6,%xmm6,%xmm6
  15d2aa:	vpermd (%r11,%rbx,1),%ymm5,%ymm6
  15d2b0:	vpermd 0x20(%r11,%rbx,1),%ymm5,%ymm5
  15d2b7:	vpsrad $0x1f,%ymm4,%ymm4
  15d2bc:	vpblendvb %ymm4,%ymm5,%ymm6,%ymm4
  15d2c2:	prefetcht2 0x3f(%r11,%rbx,1)
  15d2c8:	vpmulld %ymm1,%ymm3,%ymm3
  15d2cd:	vpsrld $0x1b,%ymm3,%ymm3
  15d2d2:	vpsllvd %ymm3,%ymm2,%ymm3
  15d2d7:	xor    %r9d,%r9d
  15d2da:	vptest %ymm3,%ymm4
  15d2df:	setb   %r9b
  15d2e3:	mov    %r9d,(%rcx,%rax,4)
  15d2e7:	mov    0x8(%rdx,%rax,8),%r9
  15d2ec:	mov    0x18(%rdi),%r10d
  15d2f0:	mov    (%rdi),%r11
  15d2f3:	shr    $0x6,%r10d
  15d2f7:	mov    %r9d,%ebx
  15d2fa:	imul   %r10,%rbx
  15d2fe:	shr    $0x1a,%rbx
  15d302:	and    $0xffffffc0,%ebx
  15d305:	shr    $0x20,%r9
  15d309:	vpbroadcastd %r9d,%ymm3
  15d30f:	vpmulld %ymm0,%ymm3,%ymm4
  15d314:	prefetcht2 (%r11,%rbx,1)
  15d319:	vpsrld $0x1c,%ymm4,%ymm5
  15d31e:	vxorps %xmm6,%xmm6,%xmm6
  15d322:	vpermd (%r11,%rbx,1),%ymm5,%ymm6
  15d328:	vpermd 0x20(%r11,%rbx,1),%ymm5,%ymm5
  15d32f:	vpsrad $0x1f,%ymm4,%ymm4
  15d334:	vpblendvb %ymm4,%ymm5,%ymm6,%ymm4
  15d33a:	vpmulld %ymm1,%ymm3,%ymm3
  15d33f:	prefetcht2 0x3f(%r11,%rbx,1)
  15d345:	vpsrld $0x1b,%ymm3,%ymm3
  15d34a:	vpsllvd %ymm3,%ymm2,%ymm3
  15d34f:	xor    %r9d,%r9d
  15d352:	vptest %ymm3,%ymm4
  15d357:	setb   %r9b
  15d35b:	mov    %r9d,0x4(%rcx,%rax,4)
  15d360:	add    $0x2,%rax
  15d364:	cmp    %rax,%r8
  15d367:	jne    15d270 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<8, true>, unsigned long>(rocksdb_external::FastLocalBloom64<8, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
  15d36d:	test   $0x1,%sil
  15d371:	je     15d3fb <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<8, true>, unsigned long>(rocksdb_external::FastLocalBloom64<8, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x1cb>
  15d377:	mov    (%rdx,%rax,8),%rdx
  15d37b:	mov    0x18(%rdi),%esi
  15d37e:	mov    (%rdi),%rdi
  15d381:	shr    $0x6,%esi
  15d384:	mov    %edx,%r8d
  15d387:	imul   %rsi,%r8
  15d38b:	shr    $0x1a,%r8
  15d38f:	and    $0xffffffc0,%r8d
  15d393:	shr    $0x20,%rdx
  15d397:	vpbroadcastd %edx,%ymm0
  15d39d:	vpmulld -0x1588c6(%rip),%ymm0,%ymm1        # 4ae0 <typeinfo name for main::$_60+0x310>
  15d3a6:	vpsrld $0x1c,%ymm1,%ymm2
  15d3ab:	vxorps %xmm3,%xmm3,%xmm3
  15d3af:	vpermd (%rdi,%r8,1),%ymm2,%ymm3
  15d3b5:	vpermd 0x20(%rdi,%r8,1),%ymm2,%ymm2
  15d3bc:	vpsrad $0x1f,%ymm1,%ymm1
  15d3c1:	vpblendvb %ymm1,%ymm2,%ymm3,%ymm1
  15d3c7:	vpmulld -0x158a50(%rip),%ymm0,%ymm0        # 4980 <typeinfo name for main::$_60+0x1b0>
  15d3d0:	prefetcht2 (%rdi,%r8,1)
  15d3d5:	prefetcht2 0x3f(%rdi,%r8,1)
  15d3db:	vpsrld $0x1b,%ymm0,%ymm0
  15d3e0:	vpbroadcastd -0x15a141(%rip),%ymm2        # 32a8 <__abi_tag+0x2fe4>
  15d3e9:	vpsllvd %ymm0,%ymm2,%ymm0
  15d3ee:	xor    %edx,%edx
  15d3f0:	vptest %ymm0,%ymm1
  15d3f5:	setb   %dl
  15d3f8:	mov    %edx,(%rcx,%rax,4)
  15d3fb:	pop    %rbx
  15d3fc:	vzeroupper
  15d3ff:	ret

