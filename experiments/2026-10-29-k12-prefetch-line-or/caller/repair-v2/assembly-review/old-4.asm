    e1c0:	cmp    $0x4,%esi
    e1c3:	jae    e1d4 <void bloom_filters::K12ScalarOrControl::InsertVector<true>(unsigned int, unsigned long const*)+0x14>
    e1c5:	xor    %r9d,%r9d
    e1c8:	sub    %r9d,%esi
    e1cb:	lea    (%rdx,%r9,8),%rdx
    e1cf:	jmp    e7a0 <bloom_filters::K12ScalarOrControl::InsertScalar(unsigned int, unsigned long const*)>
    e1d4:	push   %rbx
    e1d5:	mov    %esi,%eax
    e1d7:	xor    %ecx,%ecx
    e1d9:	vmovdqa64 -0xbfe3(%rip),%zmm0        # 2200 <_IO_stdin_used+0x164>
    e1e3:	vmovdqa64 -0xbfad(%rip),%zmm1        # 2240 <_IO_stdin_used+0x1a4>
    e1ed:	vbroadcasti32x4 -0xaf87(%rip),%zmm2        # 3270 <typeinfo name for main::$_2+0x24>
    e1f7:	vmovdqa64 -0xbf41(%rip),%zmm3        # 22c0 <_IO_stdin_used+0x224>
    e201:	vbroadcasti32x4 -0xafab(%rip),%zmm4        # 3260 <typeinfo name for main::$_2+0x14>
    e20b:	vbroadcasti32x4 -0xaf95(%rip),%zmm5        # 3280 <typeinfo name for main::$_2+0x34>
    e215:	vmovdqa64 -0xbe9f(%rip),%zmm6        # 2380 <_IO_stdin_used+0x2e4>
    e21f:	vpbroadcastd -0xc199(%rip),%zmm7        # 2090 <__abi_tag+0x1dcc>
    e229:	vbroadcasti32x4 -0xafa3(%rip),%zmm8        # 3290 <typeinfo name for main::$_2+0x44>
    e233:	movabs $0x3ffffffc0,%r8
    e23d:	jmp    e43e <void bloom_filters::K12ScalarOrControl::InsertVector<true>(unsigned int, unsigned long const*)+0x27e>
    e242:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
    e250:	vmovdqu (%rdx,%rcx,8),%ymm9
    e255:	vpxor  %xmm10,%xmm10,%xmm10
    e25a:	vpermd %zmm9,%zmm0,%zmm10
    e260:	vprorvd %zmm2,%zmm10,%zmm10
    e266:	vpxor  %xmm11,%xmm11,%xmm11
    e26b:	vpermd %zmm9,%zmm1,%zmm11
    e271:	vpxor  %xmm9,%xmm9,%xmm9
    e276:	vpermd %zmm3,%zmm10,%zmm9
    e27c:	vpsrld $0x4,%zmm10,%zmm10
    e283:	vprolvd %zmm10,%zmm9,%zmm9
    e289:	vpsrlvd %zmm4,%zmm11,%zmm10
    e28f:	vpandd %zmm5,%zmm10,%zmm12
    e295:	vpsrld $0x8,%zmm11,%zmm10
    e29c:	vpbroadcastd %r10d,%zmm13
    e2a2:	vpmuludq %zmm10,%zmm13,%zmm10
    e2a8:	vpsrlq $0x18,%zmm10,%zmm10
    e2af:	vpsrlq $0x28,%zmm11,%zmm14
    e2b6:	vpmuludq %zmm14,%zmm13,%zmm13
    e2bc:	vpshufb %zmm6,%zmm13,%zmm13
    e2c2:	vpord  %zmm10,%zmm13,%zmm10
    e2c8:	vpslld $0x4,%zmm10,%zmm10
    e2cf:	vpternlogd $0xf8,%zmm7,%zmm11,%zmm10
    e2d6:	vpternlogd $0x1e,%zmm8,%zmm12,%zmm10
    e2dd:	vmovd  %xmm9,%r10d
    e2e2:	vmovd  %xmm10,%r11d
    e2e7:	or     %r10d,(%r9,%r11,4)
    e2eb:	vpextrd $0x1,%xmm9,%r9d
    e2f1:	vpextrd $0x1,%xmm10,%r10d
    e2f7:	mov    (%rdi),%r11
    e2fa:	or     %r9d,(%r11,%r10,4)
    e2fe:	vpextrd $0x2,%xmm9,%r9d
    e304:	vpextrd $0x2,%xmm10,%r10d
    e30a:	mov    (%rdi),%r11
    e30d:	or     %r9d,(%r11,%r10,4)
    e311:	vpextrd $0x3,%xmm9,%r9d
    e317:	vpextrd $0x3,%xmm10,%r10d
    e31d:	mov    (%rdi),%r11
    e320:	or     %r9d,(%r11,%r10,4)
    e324:	vextracti128 $0x1,%ymm9,%xmm11
    e32a:	vmovd  %xmm11,%r9d
    e32f:	vextracti128 $0x1,%ymm10,%xmm12
    e335:	vmovd  %xmm12,%r10d
    e33a:	mov    (%rdi),%r11
    e33d:	or     %r9d,(%r11,%r10,4)
    e341:	vpextrd $0x1,%xmm11,%r9d
    e347:	vpextrd $0x1,%xmm12,%r10d
    e34d:	mov    (%rdi),%r11
    e350:	or     %r9d,(%r11,%r10,4)
    e354:	vpextrd $0x2,%xmm11,%r9d
    e35a:	vpextrd $0x2,%xmm12,%r10d
    e360:	mov    (%rdi),%r11
    e363:	or     %r9d,(%r11,%r10,4)
    e367:	vpextrd $0x3,%xmm11,%r9d
    e36d:	vpextrd $0x3,%xmm12,%r10d
    e373:	mov    (%rdi),%r11
    e376:	or     %r9d,(%r11,%r10,4)
    e37a:	vextracti32x4 $0x2,%zmm9,%xmm11
    e381:	vmovd  %xmm11,%r9d
    e386:	vextracti32x4 $0x2,%zmm10,%xmm12
    e38d:	vmovd  %xmm12,%r10d
    e392:	mov    (%rdi),%r11
    e395:	or     %r9d,(%r11,%r10,4)
    e399:	vpextrd $0x1,%xmm11,%r9d
    e39f:	vpextrd $0x1,%xmm12,%r10d
    e3a5:	mov    (%rdi),%r11
    e3a8:	or     %r9d,(%r11,%r10,4)
    e3ac:	vpextrd $0x2,%xmm11,%r9d
    e3b2:	vpextrd $0x2,%xmm12,%r10d
    e3b8:	mov    (%rdi),%r11
    e3bb:	or     %r9d,(%r11,%r10,4)
    e3bf:	vpextrd $0x3,%xmm11,%r9d
    e3c5:	vpextrd $0x3,%xmm12,%r10d
    e3cb:	mov    (%rdi),%r11
    e3ce:	or     %r9d,(%r11,%r10,4)
    e3d2:	vextracti32x4 $0x3,%zmm9,%xmm9
    e3d9:	vmovd  %xmm9,%r9d
    e3de:	vextracti32x4 $0x3,%zmm10,%xmm10
    e3e5:	vmovd  %xmm10,%r10d
    e3ea:	mov    (%rdi),%r11
    e3ed:	or     %r9d,(%r11,%r10,4)
    e3f1:	vpextrd $0x1,%xmm9,%r9d
    e3f7:	vpextrd $0x1,%xmm10,%r10d
    e3fd:	mov    (%rdi),%r11
    e400:	or     %r9d,(%r11,%r10,4)
    e404:	vpextrd $0x2,%xmm9,%r9d
    e40a:	vpextrd $0x2,%xmm10,%r10d
    e410:	mov    (%rdi),%r11
    e413:	or     %r9d,(%r11,%r10,4)
    e417:	vpextrd $0x3,%xmm9,%r9d
    e41d:	vpextrd $0x3,%xmm10,%r10d
    e423:	mov    (%rdi),%r11
    e426:	or     %r9d,(%r11,%r10,4)
    e42a:	lea    0x4(%rcx),%r9
    e42e:	add    $0x8,%rcx
    e432:	cmp    %rax,%rcx
    e435:	mov    %r9,%rcx
    e438:	ja     e4fb <void bloom_filters::K12ScalarOrControl::InsertVector<true>(unsigned int, unsigned long const*)+0x33b>
    e43e:	lea    0x44(%rcx),%r11
    e442:	mov    0x18(%rdi),%r10d
    e446:	mov    (%rdi),%r9
    e449:	cmp    %rax,%r11
    e44c:	ja     e250 <void bloom_filters::K12ScalarOrControl::InsertVector<true>(unsigned int, unsigned long const*)+0x90>
    e452:	mov    0x200(%rdx,%rcx,8),%r11
    e45a:	mov    %r11,%rbx
    e45d:	shr    $0x20,%rbx
    e461:	shr    $0x28,%r11
    e465:	imul   %r10,%r11
    e469:	and    $0x3,%ebx
    e46c:	shr    $0x12,%r11
    e470:	and    %r8,%r11
    e473:	add    %r9,%r11
    e476:	prefetchw (%r11,%rbx,4)
    e47b:	mov    0x208(%rdx,%rcx,8),%r11
    e483:	mov    %r11,%rbx
    e486:	shr    $0x20,%rbx
    e48a:	shr    $0x28,%r11
    e48e:	imul   %r10,%r11
    e492:	and    $0x3,%ebx
    e495:	shr    $0x12,%r11
    e499:	and    %r8,%r11
    e49c:	add    %r9,%r11
    e49f:	prefetchw (%r11,%rbx,4)
    e4a4:	mov    0x210(%rdx,%rcx,8),%r11
    e4ac:	mov    %r11,%rbx
    e4af:	shr    $0x20,%rbx
    e4b3:	shr    $0x28,%r11
    e4b7:	imul   %r10,%r11
    e4bb:	and    $0x3,%ebx
    e4be:	shr    $0x12,%r11
    e4c2:	and    %r8,%r11
    e4c5:	add    %r9,%r11
    e4c8:	prefetchw (%r11,%rbx,4)
    e4cd:	mov    0x218(%rdx,%rcx,8),%r11
    e4d5:	mov    %r11,%rbx
    e4d8:	shr    $0x20,%rbx
    e4dc:	shr    $0x28,%r11
    e4e0:	imul   %r10,%r11
    e4e4:	and    $0x3,%ebx
    e4e7:	shr    $0x12,%r11
    e4eb:	and    %r8,%r11
    e4ee:	add    %r9,%r11
    e4f1:	prefetchw (%r11,%rbx,4)
    e4f6:	jmp    e250 <void bloom_filters::K12ScalarOrControl::InsertVector<true>(unsigned int, unsigned long const*)+0x90>
    e4fb:	pop    %rbx
    e4fc:	sub    %r9d,%esi
    e4ff:	lea    (%rdx,%r9,8),%rdx
    e503:	vzeroupper
    e506:	jmp    e7a0 <bloom_filters::K12ScalarOrControl::InsertScalar(unsigned int, unsigned long const*)>
