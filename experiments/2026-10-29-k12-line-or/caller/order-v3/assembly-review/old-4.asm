    e210:	cmp    $0x4,%esi
    e213:	jae    e224 <void bloom_filters::K12ScalarOrControl::InsertVector<false>(unsigned int, unsigned long const*)+0x14>
    e215:	xor    %r8d,%r8d
    e218:	sub    %r8d,%esi
    e21b:	lea    (%rdx,%r8,8),%rdx
    e21f:	jmp    e4a0 <bloom_filters::K12ScalarOrControl::InsertScalar(unsigned int, unsigned long const*)>
    e224:	mov    %esi,%eax
    e226:	xor    %ecx,%ecx
    e228:	vmovdqa64 -0xbe32(%rip),%zmm0        # 2400 <_IO_stdin_used+0x364>
    e232:	vmovdqa64 -0xbdfc(%rip),%zmm1        # 2440 <_IO_stdin_used+0x3a4>
    e23c:	vbroadcasti32x4 -0xafd6(%rip),%zmm2        # 3270 <typeinfo name for main::$_2+0x24>
    e246:	vmovdqa64 -0xbd90(%rip),%zmm3        # 24c0 <_IO_stdin_used+0x424>
    e250:	vbroadcasti32x4 -0xaffa(%rip),%zmm4        # 3260 <typeinfo name for main::$_2+0x14>
    e25a:	vbroadcasti32x4 -0xafe4(%rip),%zmm5        # 3280 <typeinfo name for main::$_2+0x34>
    e264:	vmovdqa64 -0xbcee(%rip),%zmm6        # 2580 <_IO_stdin_used+0x4e4>
    e26e:	vpbroadcastd -0xc1e8(%rip),%zmm7        # 2090 <__abi_tag+0x1dcc>
    e278:	vbroadcasti32x4 -0xaff2(%rip),%zmm8        # 3290 <typeinfo name for main::$_2+0x44>
    e282:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
    e290:	vmovdqu (%rdx,%rcx,8),%ymm9
    e295:	vpxor  %xmm10,%xmm10,%xmm10
    e29a:	vpermd %zmm9,%zmm0,%zmm10
    e2a0:	vprorvd %zmm2,%zmm10,%zmm10
    e2a6:	vpxor  %xmm11,%xmm11,%xmm11
    e2ab:	vpermd %zmm9,%zmm1,%zmm11
    e2b1:	vpxor  %xmm9,%xmm9,%xmm9
    e2b6:	vpermd %zmm3,%zmm10,%zmm9
    e2bc:	vpsrld $0x4,%zmm10,%zmm10
    e2c3:	vprolvd %zmm10,%zmm9,%zmm9
    e2c9:	vpsrlvd %zmm4,%zmm11,%zmm10
    e2cf:	vpandd %zmm5,%zmm10,%zmm12
    e2d5:	vpsrld $0x8,%zmm11,%zmm10
    e2dc:	vpbroadcastd 0x18(%rdi),%zmm13
    e2e3:	vpmuludq %zmm10,%zmm13,%zmm10
    e2e9:	vpsrlq $0x18,%zmm10,%zmm10
    e2f0:	vpsrlq $0x28,%zmm11,%zmm14
    e2f7:	vpmuludq %zmm14,%zmm13,%zmm13
    e2fd:	vpshufb %zmm6,%zmm13,%zmm13
    e303:	vpord  %zmm10,%zmm13,%zmm10
    e309:	vpslld $0x4,%zmm10,%zmm10
    e310:	vpternlogd $0xf8,%zmm7,%zmm11,%zmm10
    e317:	vpternlogd $0x1e,%zmm8,%zmm12,%zmm10
    e31e:	vmovd  %xmm9,%r8d
    e323:	vmovd  %xmm10,%r9d
    e328:	mov    (%rdi),%r10
    e32b:	or     %r8d,(%r10,%r9,4)
    e32f:	vpextrd $0x1,%xmm9,%r8d
    e335:	vpextrd $0x1,%xmm10,%r9d
    e33b:	mov    (%rdi),%r10
    e33e:	or     %r8d,(%r10,%r9,4)
    e342:	vpextrd $0x2,%xmm9,%r8d
    e348:	vpextrd $0x2,%xmm10,%r9d
    e34e:	mov    (%rdi),%r10
    e351:	or     %r8d,(%r10,%r9,4)
    e355:	vpextrd $0x3,%xmm9,%r8d
    e35b:	vpextrd $0x3,%xmm10,%r9d
    e361:	mov    (%rdi),%r10
    e364:	or     %r8d,(%r10,%r9,4)
    e368:	vextracti128 $0x1,%ymm9,%xmm11
    e36e:	vmovd  %xmm11,%r8d
    e373:	vextracti128 $0x1,%ymm10,%xmm12
    e379:	vmovd  %xmm12,%r9d
    e37e:	mov    (%rdi),%r10
    e381:	or     %r8d,(%r10,%r9,4)
    e385:	vpextrd $0x1,%xmm11,%r8d
    e38b:	vpextrd $0x1,%xmm12,%r9d
    e391:	mov    (%rdi),%r10
    e394:	or     %r8d,(%r10,%r9,4)
    e398:	vpextrd $0x2,%xmm11,%r8d
    e39e:	vpextrd $0x2,%xmm12,%r9d
    e3a4:	mov    (%rdi),%r10
    e3a7:	or     %r8d,(%r10,%r9,4)
    e3ab:	vpextrd $0x3,%xmm11,%r8d
    e3b1:	vpextrd $0x3,%xmm12,%r9d
    e3b7:	mov    (%rdi),%r10
    e3ba:	or     %r8d,(%r10,%r9,4)
    e3be:	vextracti32x4 $0x2,%zmm9,%xmm11
    e3c5:	vmovd  %xmm11,%r8d
    e3ca:	vextracti32x4 $0x2,%zmm10,%xmm12
    e3d1:	vmovd  %xmm12,%r9d
    e3d6:	mov    (%rdi),%r10
    e3d9:	or     %r8d,(%r10,%r9,4)
    e3dd:	vpextrd $0x1,%xmm11,%r8d
    e3e3:	vpextrd $0x1,%xmm12,%r9d
    e3e9:	mov    (%rdi),%r10
    e3ec:	or     %r8d,(%r10,%r9,4)
    e3f0:	vpextrd $0x2,%xmm11,%r8d
    e3f6:	vpextrd $0x2,%xmm12,%r9d
    e3fc:	mov    (%rdi),%r10
    e3ff:	or     %r8d,(%r10,%r9,4)
    e403:	vpextrd $0x3,%xmm11,%r8d
    e409:	vpextrd $0x3,%xmm12,%r9d
    e40f:	mov    (%rdi),%r10
    e412:	or     %r8d,(%r10,%r9,4)
    e416:	vextracti32x4 $0x3,%zmm9,%xmm9
    e41d:	vmovd  %xmm9,%r8d
    e422:	vextracti32x4 $0x3,%zmm10,%xmm10
    e429:	vmovd  %xmm10,%r9d
    e42e:	mov    (%rdi),%r10
    e431:	or     %r8d,(%r10,%r9,4)
    e435:	vpextrd $0x1,%xmm9,%r8d
    e43b:	vpextrd $0x1,%xmm10,%r9d
    e441:	mov    (%rdi),%r10
    e444:	or     %r8d,(%r10,%r9,4)
    e448:	vpextrd $0x2,%xmm9,%r8d
    e44e:	vpextrd $0x2,%xmm10,%r9d
    e454:	mov    (%rdi),%r10
    e457:	or     %r8d,(%r10,%r9,4)
    e45b:	vpextrd $0x3,%xmm9,%r8d
    e461:	vpextrd $0x3,%xmm10,%r9d
    e467:	mov    (%rdi),%r10
    e46a:	or     %r8d,(%r10,%r9,4)
    e46e:	lea    0x4(%rcx),%r8
    e472:	add    $0x8,%rcx
    e476:	cmp    %rax,%rcx
    e479:	mov    %r8,%rcx
    e47c:	jbe    e290 <void bloom_filters::K12ScalarOrControl::InsertVector<false>(unsigned int, unsigned long const*)+0x80>
    e482:	sub    %r8d,%esi
    e485:	lea    (%rdx,%r8,8),%rdx
    e489:	vzeroupper
    e48c:	jmp    e4a0 <bloom_filters::K12ScalarOrControl::InsertScalar(unsigned int, unsigned long const*)>
