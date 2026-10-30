    f310:	cmp    $0x4,%esi
    f313:	jae    f324 <void bloom_filters::K12ScalarOrControl::InsertVector<true>(unsigned int, unsigned long const*)+0x14>
    f315:	xor    %r9d,%r9d
    f318:	sub    %r9d,%esi
    f31b:	lea    (%rdx,%r9,8),%rdx
    f31f:	jmp    f8f0 <bloom_filters::K12ScalarOrControl::InsertScalar(unsigned int, unsigned long const*)>
    f324:	push   %rbx
    f325:	mov    %esi,%eax
    f327:	xor    %ecx,%ecx
    f329:	vmovdqa64 -0xd0b3(%rip),%zmm0        # 2280 <_IO_stdin_used+0x1a4>
    f333:	vmovdqa64 -0xd07d(%rip),%zmm1        # 22c0 <_IO_stdin_used+0x1e4>
    f33d:	vbroadcasti32x4 -0xbfc7(%rip),%zmm2        # 3380 <typeinfo name for main::$_3+0x28>
    f347:	vmovdqa64 -0xd011(%rip),%zmm3        # 2340 <_IO_stdin_used+0x264>
    f351:	vbroadcasti32x4 -0xbfeb(%rip),%zmm4        # 3370 <typeinfo name for main::$_3+0x18>
    f35b:	vbroadcasti32x4 -0xbfd5(%rip),%zmm5        # 3390 <typeinfo name for main::$_3+0x38>
    f365:	vmovdqa64 -0xcf6f(%rip),%zmm6        # 2400 <_IO_stdin_used+0x324>
    f36f:	vpbroadcastd -0xd2a9(%rip),%zmm7        # 20d0 <__abi_tag+0x1e0c>
    f379:	vbroadcasti32x4 -0xbfe3(%rip),%zmm8        # 33a0 <typeinfo name for main::$_3+0x48>
    f383:	movabs $0x3ffffffc0,%r8
    f38d:	jmp    f58e <void bloom_filters::K12ScalarOrControl::InsertVector<true>(unsigned int, unsigned long const*)+0x27e>
    f392:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
    f3a0:	vmovdqu (%rdx,%rcx,8),%ymm9
    f3a5:	vpxor  %xmm10,%xmm10,%xmm10
    f3aa:	vpermd %zmm9,%zmm0,%zmm10
    f3b0:	vprorvd %zmm2,%zmm10,%zmm10
    f3b6:	vpxor  %xmm11,%xmm11,%xmm11
    f3bb:	vpermd %zmm9,%zmm1,%zmm11
    f3c1:	vpxor  %xmm9,%xmm9,%xmm9
    f3c6:	vpermd %zmm3,%zmm10,%zmm9
    f3cc:	vpsrld $0x4,%zmm10,%zmm10
    f3d3:	vprolvd %zmm10,%zmm9,%zmm9
    f3d9:	vpsrlvd %zmm4,%zmm11,%zmm10
    f3df:	vpandd %zmm5,%zmm10,%zmm12
    f3e5:	vpsrld $0x8,%zmm11,%zmm10
    f3ec:	vpbroadcastd %r10d,%zmm13
    f3f2:	vpmuludq %zmm10,%zmm13,%zmm10
    f3f8:	vpsrlq $0x18,%zmm10,%zmm10
    f3ff:	vpsrlq $0x28,%zmm11,%zmm14
    f406:	vpmuludq %zmm14,%zmm13,%zmm13
    f40c:	vpshufb %zmm6,%zmm13,%zmm13
    f412:	vpord  %zmm10,%zmm13,%zmm10
    f418:	vpslld $0x4,%zmm10,%zmm10
    f41f:	vpternlogd $0xf8,%zmm7,%zmm11,%zmm10
    f426:	vpternlogd $0x1e,%zmm8,%zmm12,%zmm10
    f42d:	vmovd  %xmm9,%r10d
    f432:	vmovd  %xmm10,%r11d
    f437:	or     %r10d,(%r9,%r11,4)
    f43b:	vpextrd $0x1,%xmm9,%r9d
    f441:	vpextrd $0x1,%xmm10,%r10d
    f447:	mov    (%rdi),%r11
    f44a:	or     %r9d,(%r11,%r10,4)
    f44e:	vpextrd $0x2,%xmm9,%r9d
    f454:	vpextrd $0x2,%xmm10,%r10d
    f45a:	mov    (%rdi),%r11
    f45d:	or     %r9d,(%r11,%r10,4)
    f461:	vpextrd $0x3,%xmm9,%r9d
    f467:	vpextrd $0x3,%xmm10,%r10d
    f46d:	mov    (%rdi),%r11
    f470:	or     %r9d,(%r11,%r10,4)
    f474:	vextracti128 $0x1,%ymm9,%xmm11
    f47a:	vmovd  %xmm11,%r9d
    f47f:	vextracti128 $0x1,%ymm10,%xmm12
    f485:	vmovd  %xmm12,%r10d
    f48a:	mov    (%rdi),%r11
    f48d:	or     %r9d,(%r11,%r10,4)
    f491:	vpextrd $0x1,%xmm11,%r9d
    f497:	vpextrd $0x1,%xmm12,%r10d
    f49d:	mov    (%rdi),%r11
    f4a0:	or     %r9d,(%r11,%r10,4)
    f4a4:	vpextrd $0x2,%xmm11,%r9d
    f4aa:	vpextrd $0x2,%xmm12,%r10d
    f4b0:	mov    (%rdi),%r11
    f4b3:	or     %r9d,(%r11,%r10,4)
    f4b7:	vpextrd $0x3,%xmm11,%r9d
    f4bd:	vpextrd $0x3,%xmm12,%r10d
    f4c3:	mov    (%rdi),%r11
    f4c6:	or     %r9d,(%r11,%r10,4)
    f4ca:	vextracti32x4 $0x2,%zmm9,%xmm11
    f4d1:	vmovd  %xmm11,%r9d
    f4d6:	vextracti32x4 $0x2,%zmm10,%xmm12
    f4dd:	vmovd  %xmm12,%r10d
    f4e2:	mov    (%rdi),%r11
    f4e5:	or     %r9d,(%r11,%r10,4)
    f4e9:	vpextrd $0x1,%xmm11,%r9d
    f4ef:	vpextrd $0x1,%xmm12,%r10d
    f4f5:	mov    (%rdi),%r11
    f4f8:	or     %r9d,(%r11,%r10,4)
    f4fc:	vpextrd $0x2,%xmm11,%r9d
    f502:	vpextrd $0x2,%xmm12,%r10d
    f508:	mov    (%rdi),%r11
    f50b:	or     %r9d,(%r11,%r10,4)
    f50f:	vpextrd $0x3,%xmm11,%r9d
    f515:	vpextrd $0x3,%xmm12,%r10d
    f51b:	mov    (%rdi),%r11
    f51e:	or     %r9d,(%r11,%r10,4)
    f522:	vextracti32x4 $0x3,%zmm9,%xmm9
    f529:	vmovd  %xmm9,%r9d
    f52e:	vextracti32x4 $0x3,%zmm10,%xmm10
    f535:	vmovd  %xmm10,%r10d
    f53a:	mov    (%rdi),%r11
    f53d:	or     %r9d,(%r11,%r10,4)
    f541:	vpextrd $0x1,%xmm9,%r9d
    f547:	vpextrd $0x1,%xmm10,%r10d
    f54d:	mov    (%rdi),%r11
    f550:	or     %r9d,(%r11,%r10,4)
    f554:	vpextrd $0x2,%xmm9,%r9d
    f55a:	vpextrd $0x2,%xmm10,%r10d
    f560:	mov    (%rdi),%r11
    f563:	or     %r9d,(%r11,%r10,4)
    f567:	vpextrd $0x3,%xmm9,%r9d
    f56d:	vpextrd $0x3,%xmm10,%r10d
    f573:	mov    (%rdi),%r11
    f576:	or     %r9d,(%r11,%r10,4)
    f57a:	lea    0x4(%rcx),%r9
    f57e:	add    $0x8,%rcx
    f582:	cmp    %rax,%rcx
    f585:	mov    %r9,%rcx
    f588:	ja     f64b <void bloom_filters::K12ScalarOrControl::InsertVector<true>(unsigned int, unsigned long const*)+0x33b>
    f58e:	lea    0x44(%rcx),%r11
    f592:	mov    0x18(%rdi),%r10d
    f596:	mov    (%rdi),%r9
    f599:	cmp    %rax,%r11
    f59c:	ja     f3a0 <void bloom_filters::K12ScalarOrControl::InsertVector<true>(unsigned int, unsigned long const*)+0x90>
    f5a2:	mov    0x200(%rdx,%rcx,8),%r11
    f5aa:	mov    %r11,%rbx
    f5ad:	shr    $0x20,%rbx
    f5b1:	shr    $0x28,%r11
    f5b5:	imul   %r10,%r11
    f5b9:	and    $0x3,%ebx
    f5bc:	shr    $0x12,%r11
    f5c0:	and    %r8,%r11
    f5c3:	add    %r9,%r11
    f5c6:	prefetchw (%r11,%rbx,4)
    f5cb:	mov    0x208(%rdx,%rcx,8),%r11
    f5d3:	mov    %r11,%rbx
    f5d6:	shr    $0x20,%rbx
    f5da:	shr    $0x28,%r11
    f5de:	imul   %r10,%r11
    f5e2:	and    $0x3,%ebx
    f5e5:	shr    $0x12,%r11
    f5e9:	and    %r8,%r11
    f5ec:	add    %r9,%r11
    f5ef:	prefetchw (%r11,%rbx,4)
    f5f4:	mov    0x210(%rdx,%rcx,8),%r11
    f5fc:	mov    %r11,%rbx
    f5ff:	shr    $0x20,%rbx
    f603:	shr    $0x28,%r11
    f607:	imul   %r10,%r11
    f60b:	and    $0x3,%ebx
    f60e:	shr    $0x12,%r11
    f612:	and    %r8,%r11
    f615:	add    %r9,%r11
    f618:	prefetchw (%r11,%rbx,4)
    f61d:	mov    0x218(%rdx,%rcx,8),%r11
    f625:	mov    %r11,%rbx
    f628:	shr    $0x20,%rbx
    f62c:	shr    $0x28,%r11
    f630:	imul   %r10,%r11
    f634:	and    $0x3,%ebx
    f637:	shr    $0x12,%r11
    f63b:	and    %r8,%r11
    f63e:	add    %r9,%r11
    f641:	prefetchw (%r11,%rbx,4)
    f646:	jmp    f3a0 <void bloom_filters::K12ScalarOrControl::InsertVector<true>(unsigned int, unsigned long const*)+0x90>
    f64b:	pop    %rbx
    f64c:	sub    %r9d,%esi
    f64f:	lea    (%rdx,%r9,8),%rdx
    f653:	vzeroupper
    f656:	jmp    f8f0 <bloom_filters::K12ScalarOrControl::InsertScalar(unsigned int, unsigned long const*)>
