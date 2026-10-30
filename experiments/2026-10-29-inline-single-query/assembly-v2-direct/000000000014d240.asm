000000000014d240 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<8, false>, unsigned long>(rocksdb_external::FastLocalBloom64<8, false> const&, unsigned long, unsigned long const*, unsigned int*)>:
  14d240:	test   %rsi,%rsi
  14d243:	je     14d3e2 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<8, false>, unsigned long>(rocksdb_external::FastLocalBloom64<8, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x1a2>
  14d249:	push   %rbx
  14d24a:	cmp    $0x1,%rsi
  14d24e:	jne    14d257 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<8, false>, unsigned long>(rocksdb_external::FastLocalBloom64<8, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x17>
  14d250:	xor    %eax,%eax
  14d252:	jmp    14d369 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<8, false>, unsigned long>(rocksdb_external::FastLocalBloom64<8, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x129>
  14d257:	mov    %rsi,%r8
  14d25a:	and    $0xfffffffffffffffe,%r8
  14d25e:	xor    %eax,%eax
  14d260:	vmovdqa -0x148788(%rip),%ymm0        # 4ae0 <typeinfo name for main::$_60+0x310>
  14d268:	vmovdqa -0x1488f0(%rip),%ymm1        # 4980 <typeinfo name for main::$_60+0x1b0>
  14d270:	vpbroadcastd -0x149fd1(%rip),%ymm2        # 32a8 <__abi_tag+0x2fe4>
  14d279:	nopl   0x0(%rax)
  14d280:	mov    (%rdx,%rax,8),%r9
  14d284:	mov    (%rdi),%r10
  14d287:	mov    %r9d,%r11d
  14d28a:	mov    0x18(%rdi),%ebx
  14d28d:	shr    $0x6,%ebx
  14d290:	imul   %r11,%rbx
  14d294:	shr    $0x1a,%rbx
  14d298:	and    $0xffffffc0,%ebx
  14d29b:	shr    $0x20,%r9
  14d29f:	vpbroadcastd %r9d,%ymm3
  14d2a5:	vpmulld %ymm0,%ymm3,%ymm4
  14d2aa:	vpsrld $0x1c,%ymm4,%ymm5
  14d2af:	vxorps %xmm6,%xmm6,%xmm6
  14d2b3:	vpermd (%r10,%rbx,1),%ymm5,%ymm6
  14d2b9:	vpermd 0x20(%r10,%rbx,1),%ymm5,%ymm5
  14d2c0:	vpsrad $0x1f,%ymm4,%ymm4
  14d2c5:	vpblendvb %ymm4,%ymm5,%ymm6,%ymm4
  14d2cb:	vpmulld %ymm1,%ymm3,%ymm3
  14d2d0:	vpsrld $0x1b,%ymm3,%ymm3
  14d2d5:	vpsllvd %ymm3,%ymm2,%ymm3
  14d2da:	xor    %r9d,%r9d
  14d2dd:	vptest %ymm3,%ymm4
  14d2e2:	setb   %r9b
  14d2e6:	mov    %r9d,(%rcx,%rax,4)
  14d2ea:	mov    0x8(%rdx,%rax,8),%r9
  14d2ef:	mov    (%rdi),%r10
  14d2f2:	mov    %r9d,%r11d
  14d2f5:	mov    0x18(%rdi),%ebx
  14d2f8:	shr    $0x6,%ebx
  14d2fb:	imul   %r11,%rbx
  14d2ff:	shr    $0x1a,%rbx
  14d303:	shr    $0x20,%r9
  14d307:	vpbroadcastd %r9d,%ymm3
  14d30d:	vpmulld %ymm0,%ymm3,%ymm4
  14d312:	and    $0xffffffc0,%ebx
  14d315:	vpsrld $0x1c,%ymm4,%ymm5
  14d31a:	vxorps %xmm6,%xmm6,%xmm6
  14d31e:	vpermd (%r10,%rbx,1),%ymm5,%ymm6
  14d324:	vpermd 0x20(%r10,%rbx,1),%ymm5,%ymm5
  14d32b:	vpsrad $0x1f,%ymm4,%ymm4
  14d330:	vpblendvb %ymm4,%ymm5,%ymm6,%ymm4
  14d336:	vpmulld %ymm1,%ymm3,%ymm3
  14d33b:	vpsrld $0x1b,%ymm3,%ymm3
  14d340:	vpsllvd %ymm3,%ymm2,%ymm3
  14d345:	xor    %r9d,%r9d
  14d348:	vptest %ymm3,%ymm4
  14d34d:	setb   %r9b
  14d351:	mov    %r9d,0x4(%rcx,%rax,4)
  14d356:	add    $0x2,%rax
  14d35a:	cmp    %rax,%r8
  14d35d:	jne    14d280 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<8, false>, unsigned long>(rocksdb_external::FastLocalBloom64<8, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
  14d363:	test   $0x1,%sil
  14d367:	je     14d3e1 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<8, false>, unsigned long>(rocksdb_external::FastLocalBloom64<8, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x1a1>
  14d369:	mov    (%rdx,%rax,8),%rdx
  14d36d:	mov    (%rdi),%rsi
  14d370:	mov    %edx,%r8d
  14d373:	mov    0x18(%rdi),%edi
  14d376:	shr    $0x6,%edi
  14d379:	imul   %r8,%rdi
  14d37d:	shr    $0x1a,%rdi
  14d381:	and    $0xffffffc0,%edi
  14d384:	shr    $0x20,%rdx
  14d388:	vpbroadcastd %edx,%ymm0
  14d38e:	vpmulld -0x1488b7(%rip),%ymm0,%ymm1        # 4ae0 <typeinfo name for main::$_60+0x310>
  14d397:	vpsrld $0x1c,%ymm1,%ymm2
  14d39c:	vxorps %xmm3,%xmm3,%xmm3
  14d3a0:	vpermd (%rsi,%rdi,1),%ymm2,%ymm3
  14d3a6:	vpermd 0x20(%rsi,%rdi,1),%ymm2,%ymm2
  14d3ad:	vpsrad $0x1f,%ymm1,%ymm1
  14d3b2:	vpblendvb %ymm1,%ymm2,%ymm3,%ymm1
  14d3b8:	vpmulld -0x148a41(%rip),%ymm0,%ymm0        # 4980 <typeinfo name for main::$_60+0x1b0>
  14d3c1:	vpsrld $0x1b,%ymm0,%ymm0
  14d3c6:	vpbroadcastd -0x14a127(%rip),%ymm2        # 32a8 <__abi_tag+0x2fe4>
  14d3cf:	vpsllvd %ymm0,%ymm2,%ymm0
  14d3d4:	xor    %edx,%edx
  14d3d6:	vptest %ymm0,%ymm1
  14d3db:	setb   %dl
  14d3de:	mov    %edx,(%rcx,%rax,4)
  14d3e1:	pop    %rbx
  14d3e2:	vzeroupper
  14d3e5:	ret
  14d3e6:	int3
  14d3e7:	int3
  14d3e8:	int3
  14d3e9:	int3
  14d3ea:	int3
  14d3eb:	int3
  14d3ec:	int3
  14d3ed:	int3
  14d3ee:	int3
  14d3ef:	int3

