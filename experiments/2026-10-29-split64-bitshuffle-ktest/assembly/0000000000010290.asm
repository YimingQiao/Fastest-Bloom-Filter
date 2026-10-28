0000000000010290 <bloom_filters::FastPatternBF::Lookup(unsigned int, unsigned long const*, unsigned int*) const>:
   10290:	push   %rbp
   10291:	push   %r15
   10293:	push   %r14
   10295:	push   %r12
   10297:	push   %rbx
   10298:	mov    %rcx,%r8
   1029b:	mov    %esi,%eax
   1029d:	cmp    $0x3,%esi
   102a0:	ja     103ee <bloom_filters::FastPatternBF::Lookup(unsigned int, unsigned long const*, unsigned int*) const+0x15e>
   102a6:	test   %eax,%eax
   102a8:	je     10943 <bloom_filters::FastPatternBF::Lookup(unsigned int, unsigned long const*, unsigned int*) const+0x6b3>
   102ae:	mov    (%rdx),%rsi
   102b1:	mov    %rsi,%r9
   102b4:	shr    $0x20,%r9
   102b8:	and    0x8(%rdi),%r9d
   102bc:	mov    %esi,%ecx
   102be:	and    $0x1f,%ecx
   102c1:	mov    (%rdi),%r11
   102c4:	mov    0x10(%rdi),%r10
   102c8:	mov    (%r11,%rcx,4),%ebx
   102cc:	mov    %esi,%ecx
   102ce:	shr    $0x5,%ecx
   102d1:	rol    %cl,%ebx
   102d3:	mov    %esi,%ecx
   102d5:	shr    $0x8,%ecx
   102d8:	and    $0x7c,%ecx
   102db:	mov    (%r11,%rcx,1),%r11d
   102df:	mov    %esi,%ecx
   102e1:	shr    $0xf,%ecx
   102e4:	rol    %cl,%r11d
   102e7:	mov    (%r10,%r9,4),%ecx
   102eb:	andn   %ebx,%ecx,%ecx
   102f0:	shr    $0x14,%esi
   102f3:	and    $0x7,%esi
   102f6:	or     $0x8,%esi
   102f9:	xor    %r9d,%esi
   102fc:	mov    (%r10,%rsi,4),%esi
   10300:	andn   %r11d,%esi,%esi
   10305:	xor    %r9d,%r9d
   10308:	or     %ecx,%esi
   1030a:	sete   %r9b
   1030e:	mov    %r9d,(%r8)
   10311:	cmp    $0x1,%eax
   10314:	je     10943 <bloom_filters::FastPatternBF::Lookup(unsigned int, unsigned long const*, unsigned int*) const+0x6b3>
   1031a:	mov    0x8(%rdx),%rsi
   1031e:	mov    %rsi,%r9
   10321:	shr    $0x20,%r9
   10325:	and    0x8(%rdi),%r9d
   10329:	mov    %esi,%ecx
   1032b:	and    $0x1f,%ecx
   1032e:	mov    (%rdi),%r11
   10331:	mov    0x10(%rdi),%r10
   10335:	mov    (%r11,%rcx,4),%ebx
   10339:	mov    %esi,%ecx
   1033b:	shr    $0x5,%ecx
   1033e:	rol    %cl,%ebx
   10340:	mov    %esi,%ecx
   10342:	shr    $0x8,%ecx
   10345:	and    $0x7c,%ecx
   10348:	mov    (%r11,%rcx,1),%r11d
   1034c:	mov    %esi,%ecx
   1034e:	shr    $0xf,%ecx
   10351:	rol    %cl,%r11d
   10354:	mov    (%r10,%r9,4),%ecx
   10358:	andn   %ebx,%ecx,%ecx
   1035d:	shr    $0x14,%esi
   10360:	and    $0x7,%esi
   10363:	or     $0x8,%esi
   10366:	xor    %r9d,%esi
   10369:	mov    (%r10,%rsi,4),%esi
   1036d:	andn   %r11d,%esi,%esi
   10372:	xor    %r9d,%r9d
   10375:	or     %ecx,%esi
   10377:	sete   %r9b
   1037b:	mov    %r9d,0x4(%r8)
   1037f:	cmp    $0x2,%eax
   10382:	je     10943 <bloom_filters::FastPatternBF::Lookup(unsigned int, unsigned long const*, unsigned int*) const+0x6b3>
   10388:	mov    0x10(%rdx),%rdx
   1038c:	mov    %rdx,%rsi
   1038f:	shr    $0x20,%rsi
   10393:	and    0x8(%rdi),%esi
   10396:	mov    %edx,%ecx
   10398:	and    $0x1f,%ecx
   1039b:	mov    (%rdi),%r9
   1039e:	mov    0x10(%rdi),%rdi
   103a2:	mov    (%r9,%rcx,4),%r10d
   103a6:	mov    %edx,%ecx
   103a8:	shr    $0x5,%ecx
   103ab:	rol    %cl,%r10d
   103ae:	mov    %edx,%ecx
   103b0:	shr    $0x8,%ecx
   103b3:	and    $0x7c,%ecx
   103b6:	mov    (%r9,%rcx,1),%r9d
   103ba:	mov    %edx,%ecx
   103bc:	shr    $0xf,%ecx
   103bf:	rol    %cl,%r9d
   103c2:	mov    (%rdi,%rsi,4),%ecx
   103c5:	andn   %r10d,%ecx,%ecx
   103ca:	shr    $0x14,%edx
   103cd:	and    $0x7,%edx
   103d0:	or     $0x8,%edx
   103d3:	xor    %esi,%edx
   103d5:	mov    (%rdi,%rdx,4),%edx
   103d8:	andn   %r9d,%edx,%edx
   103dd:	xor    %esi,%esi
   103df:	or     %ecx,%edx
   103e1:	sete   %sil
   103e5:	mov    %esi,0x8(%r8)
   103e9:	jmp    10943 <bloom_filters::FastPatternBF::Lookup(unsigned int, unsigned long const*, unsigned int*) const+0x6b3>
   103ee:	mov    0x10(%rdi),%rsi
   103f2:	mov    0x18(%rdi),%rcx
   103f6:	sub    %rsi,%rcx
   103f9:	cmp    $0x200001,%rcx
   10400:	jb     10415 <bloom_filters::FastPatternBF::Lookup(unsigned int, unsigned long const*, unsigned int*) const+0x185>
   10402:	mov    %eax,%ebx
   10404:	mov    %eax,%esi
   10406:	mov    %r8,%rcx
   10409:	call   10950 <void bloom_filters::FastPatternBF::LookupImpl<true>(unsigned int, unsigned long const*, unsigned int*) const>
   1040e:	mov    %ebx,%eax
   10410:	jmp    10943 <bloom_filters::FastPatternBF::Lookup(unsigned int, unsigned long const*, unsigned int*) const+0x6b3>
   10415:	mov    (%rdi),%r9
   10418:	vmovdqu64 (%r9),%zmm0
   1041e:	vmovdqu64 0x40(%r9),%zmm1
   10425:	mov    %eax,%r10d
   10428:	cmp    $0x10,%eax
   1042b:	jae    10442 <bloom_filters::FastPatternBF::Lookup(unsigned int, unsigned long const*, unsigned int*) const+0x1b2>
   1042d:	xor    %r14d,%r14d
   10430:	lea    0x8(%r14),%r15
   10434:	cmp    %r10,%r15
   10437:	ja     10638 <bloom_filters::FastPatternBF::Lookup(unsigned int, unsigned long const*, unsigned int*) const+0x3a8>
   1043d:	jmp    10732 <bloom_filters::FastPatternBF::Lookup(unsigned int, unsigned long const*, unsigned int*) const+0x4a2>
   10442:	vpbroadcastd 0x8(%rdi),%zmm2
   10449:	mov    0x10(%rdi),%r11
   1044d:	lea    -0x10(%r10),%rbx
   10451:	mov    %rbx,%r14
   10454:	shr    $0x4,%r14
   10458:	je     1064c <bloom_filters::FastPatternBF::Lookup(unsigned int, unsigned long const*, unsigned int*) const+0x3bc>
   1045e:	inc    %r14
   10461:	and    $0xfffffffffffffffe,%r14
   10465:	mov    $0x10,%ecx
   1046a:	vmovdqa64 -0xe0f4(%rip),%zmm3        # 2380 <_IO_stdin_used+0x338>
   10474:	vmovdqa64 -0xe0be(%rip),%zmm4        # 23c0 <_IO_stdin_used+0x378>
   1047e:	vpbroadcastd -0xe448(%rip),%zmm5        # 2040 <__abi_tag+0x1d7c>
   10488:	vpbroadcastd -0xe44e(%rip),%zmm6        # 2044 <__abi_tag+0x1d80>
   10492:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   104a0:	vmovdqu64 -0x80(%rdx,%rcx,8),%zmm7
   104a8:	vmovdqu64 -0x40(%rdx,%rcx,8),%zmm8
   104b0:	vmovdqa64 %zmm7,%zmm9
   104b6:	vpermt2d %zmm8,%zmm3,%zmm9
   104bc:	vpermt2d %zmm8,%zmm4,%zmm7
   104c2:	vpandd %zmm2,%zmm7,%zmm7
   104c8:	kxnorw %k0,%k0,%k1
   104cc:	vpxor  %xmm8,%xmm8,%xmm8
   104d1:	vpgatherdd (%r11,%zmm7,4),%zmm8{%k1}
   104d8:	vpsrld $0x14,%zmm9,%zmm10
   104df:	vpandd %zmm5,%zmm10,%zmm10
   104e5:	vpternlogd $0x36,%zmm6,%zmm7,%zmm10
   104ec:	kxnorw %k0,%k0,%k1
   104f0:	vpxor  %xmm7,%xmm7,%xmm7
   104f4:	vpgatherdd (%r11,%zmm10,4),%zmm7{%k1}
   104fb:	vmovdqa64 %zmm0,%zmm10
   10501:	vpermt2d %zmm1,%zmm9,%zmm10
   10507:	vpsrld $0x5,%zmm9,%zmm11
   1050e:	vprolvd %zmm11,%zmm10,%zmm10
   10514:	vpsrld $0xa,%zmm9,%zmm11
   1051b:	vpermi2d %zmm1,%zmm0,%zmm11
   10521:	vpsrld $0xf,%zmm9,%zmm9
   10528:	vprolvd %zmm9,%zmm11,%zmm9
   1052e:	vpandd %zmm10,%zmm8,%zmm8
   10534:	vpcmpeqd %zmm10,%zmm8,%k1
   1053a:	vpandd %zmm9,%zmm7,%zmm7
   10540:	vpcmpeqd %zmm9,%zmm7,%k0{%k1}
   10546:	vpmovm2d %k0,%zmm7
   1054c:	vpsrld $0x1f,%zmm7,%zmm7
   10553:	vmovdqu64 %zmm7,-0x40(%r8,%rcx,4)
   1055b:	vmovdqu64 (%rdx,%rcx,8),%zmm7
   10562:	vmovdqu64 0x40(%rdx,%rcx,8),%zmm8
   1056a:	vmovdqa64 %zmm7,%zmm9
   10570:	vpermt2d %zmm8,%zmm3,%zmm9
   10576:	vpermt2d %zmm8,%zmm4,%zmm7
   1057c:	vpandd %zmm2,%zmm7,%zmm7
   10582:	kxnorw %k0,%k0,%k1
   10586:	vpxor  %xmm8,%xmm8,%xmm8
   1058b:	vpgatherdd (%r11,%zmm7,4),%zmm8{%k1}
   10592:	vpsrld $0x14,%zmm9,%zmm10
   10599:	vpandd %zmm5,%zmm10,%zmm10
   1059f:	vpternlogd $0x36,%zmm6,%zmm7,%zmm10
   105a6:	kxnorw %k0,%k0,%k1
   105aa:	vpxor  %xmm7,%xmm7,%xmm7
   105ae:	vpgatherdd (%r11,%zmm10,4),%zmm7{%k1}
   105b5:	vmovdqa64 %zmm0,%zmm10
   105bb:	vpermt2d %zmm1,%zmm9,%zmm10
   105c1:	vpsrld $0x5,%zmm9,%zmm11
   105c8:	vprolvd %zmm11,%zmm10,%zmm10
   105ce:	vpsrld $0xa,%zmm9,%zmm11
   105d5:	vpermi2d %zmm1,%zmm0,%zmm11
   105db:	vpsrld $0xf,%zmm9,%zmm9
   105e2:	vprolvd %zmm9,%zmm11,%zmm9
   105e8:	vpandd %zmm10,%zmm8,%zmm8
   105ee:	vpcmpeqd %zmm10,%zmm8,%k1
   105f4:	vpandd %zmm9,%zmm7,%zmm7
   105fa:	vpcmpeqd %zmm9,%zmm7,%k0{%k1}
   10600:	vpmovm2d %k0,%zmm7
   10606:	vpsrld $0x1f,%zmm7,%zmm7
   1060d:	vmovdqu64 %zmm7,(%r8,%rcx,4)
   10614:	add    $0x20,%rcx
   10618:	add    $0xfffffffffffffffe,%r14
   1061c:	jne    104a0 <bloom_filters::FastPatternBF::Lookup(unsigned int, unsigned long const*, unsigned int*) const+0x210>
   10622:	lea    -0x10(%rcx),%r14
   10626:	test   $0x10,%bl
   10629:	je     10654 <bloom_filters::FastPatternBF::Lookup(unsigned int, unsigned long const*, unsigned int*) const+0x3c4>
   1062b:	lea    0x8(%r14),%r15
   1062f:	cmp    %r10,%r15
   10632:	jbe    10732 <bloom_filters::FastPatternBF::Lookup(unsigned int, unsigned long const*, unsigned int*) const+0x4a2>
   10638:	mov    %r14,%r15
   1063b:	mov    %r10,%rcx
   1063e:	sub    %r15,%rcx
   10641:	ja     107c7 <bloom_filters::FastPatternBF::Lookup(unsigned int, unsigned long const*, unsigned int*) const+0x537>
   10647:	jmp    10943 <bloom_filters::FastPatternBF::Lookup(unsigned int, unsigned long const*, unsigned int*) const+0x6b3>
   1064c:	mov    $0x10,%ecx
   10651:	xor    %r14d,%r14d
   10654:	vmovdqu64 (%rdx,%r14,8),%zmm3
   1065b:	vmovdqu64 0x40(%rdx,%r14,8),%zmm4
   10663:	vmovdqa64 -0xe2ed(%rip),%zmm5        # 2380 <_IO_stdin_used+0x338>
   1066d:	vpermi2d %zmm4,%zmm3,%zmm5
   10673:	vmovdqa64 -0xe2bd(%rip),%zmm6        # 23c0 <_IO_stdin_used+0x378>
   1067d:	vpermi2d %zmm4,%zmm3,%zmm6
   10683:	vpandd %zmm2,%zmm6,%zmm2
   10689:	vpsrld $0x14,%zmm5,%zmm3
   10690:	vmovdqa64 %zmm0,%zmm4
   10696:	vpermt2d %zmm1,%zmm5,%zmm4
   1069c:	vpsrld $0x5,%zmm5,%zmm6
   106a3:	vprolvd %zmm6,%zmm4,%zmm4
   106a9:	kxnorw %k0,%k0,%k1
   106ad:	kxnorw %k0,%k0,%k2
   106b1:	vpxor  %xmm6,%xmm6,%xmm6
   106b5:	vpgatherdd (%r11,%zmm2,4),%zmm6{%k2}
   106bc:	vpxor  %xmm7,%xmm7,%xmm7
   106c0:	vpandd -0xe68a(%rip){1to16},%zmm3,%zmm3        # 2040 <__abi_tag+0x1d7c>
   106ca:	vpternlogd $0x36,-0xe691(%rip){1to16},%zmm2,%zmm3        # 2044 <__abi_tag+0x1d80>
   106d5:	vpgatherdd (%r11,%zmm3,4),%zmm7{%k1}
   106dc:	vpsrld $0xa,%zmm5,%zmm2
   106e3:	vpermi2d %zmm1,%zmm0,%zmm2
   106e9:	vpsrld $0xf,%zmm5,%zmm3
   106f0:	vprolvd %zmm3,%zmm2,%zmm2
   106f6:	vpandd %zmm4,%zmm6,%zmm3
   106fc:	vpcmpeqd %zmm4,%zmm3,%k1
   10702:	vpandd %zmm2,%zmm7,%zmm3
   10708:	vpcmpeqd %zmm2,%zmm3,%k0{%k1}
   1070e:	vpmovm2d %k0,%zmm2
   10714:	vpsrld $0x1f,%zmm2,%zmm2
   1071b:	vmovdqu64 %zmm2,(%r8,%r14,4)
   10722:	mov    %rcx,%r14
   10725:	lea    0x8(%r14),%r15
   10729:	cmp    %r10,%r15
   1072c:	ja     10638 <bloom_filters::FastPatternBF::Lookup(unsigned int, unsigned long const*, unsigned int*) const+0x3a8>
   10732:	vmovdqu64 (%rdx,%r14,8),%zmm2
   10739:	vpshufd $0xf5,%zmm2,%zmm3
   10740:	vpsllq $0xc,%zmm2,%zmm4
   10747:	vpshufd $0xa0,%zmm2,%zmm2
   1074e:	vpsrlvd -0xe358(%rip),%zmm2,%zmm5        # 2400 <_IO_stdin_used+0x3b8>
   10758:	vpermt2d %zmm1,%zmm5,%zmm0
   1075e:	vpsrlvd -0xe328(%rip),%zmm2,%zmm1        # 2440 <_IO_stdin_used+0x3f8>
   10768:	vprolvd %zmm1,%zmm0,%zmm0
   1076e:	vpbroadcastq -0xe678(%rip),%zmm1        # 2100 <_IO_stdin_used+0xb8>
   10778:	vpternlogq $0xf8,-0xe6bb(%rip){1to8},%zmm4,%zmm1        # 20c8 <_IO_stdin_used+0x80>
   10783:	mov    0x10(%rdi),%rcx
   10787:	vpternlogd $0x78,0x8(%rdi){1to16},%zmm3,%zmm1
   1078f:	kxnorw %k0,%k0,%k1
   10793:	vpxor  %xmm2,%xmm2,%xmm2
   10797:	vpgatherdd (%rcx,%zmm1,4),%zmm2{%k1}
   1079e:	vpandd %zmm2,%zmm0,%zmm1
   107a4:	vpcmpeqq %zmm0,%zmm1,%k0
   107aa:	vpmovm2d %k0,%zmm0
   107b0:	vpsrld $0x1f,%ymm0,%ymm0
   107b5:	vmovdqu %ymm0,(%r8,%r14,4)
   107bb:	mov    %r10,%rcx
   107be:	sub    %r15,%rcx
   107c1:	jbe    10943 <bloom_filters::FastPatternBF::Lookup(unsigned int, unsigned long const*, unsigned int*) const+0x6b3>
   107c7:	mov    0x8(%rdi),%edi
   107ca:	cmp    $0x4,%rcx
   107ce:	jae    107d8 <bloom_filters::FastPatternBF::Lookup(unsigned int, unsigned long const*, unsigned int*) const+0x548>
   107d0:	mov    %r15,%r11
   107d3:	jmp    108e0 <bloom_filters::FastPatternBF::Lookup(unsigned int, unsigned long const*, unsigned int*) const+0x650>
   107d8:	mov    %ecx,%ebx
   107da:	and    $0xfffffffc,%ebx
   107dd:	lea    (%r15,%rbx,1),%r11
   107e1:	vpbroadcastd %edi,%xmm0
   107e7:	lea    (%r8,%r15,4),%r14
   107eb:	lea    (%rdx,%r15,8),%r15
   107ef:	xor    %r12d,%r12d
   107f2:	vpbroadcastq -0xe703(%rip),%ymm1        # 20f8 <_IO_stdin_used+0xb0>
   107fb:	vpbroadcastd -0xe7c4(%rip),%xmm2        # 2040 <__abi_tag+0x1d7c>
   10804:	vpbroadcastd -0xe7c9(%rip),%xmm3        # 2044 <__abi_tag+0x1d80>
   1080d:	nopl   (%rax)
   10810:	vmovdqu (%r15,%r12,8),%ymm4
   10816:	vpand  %ymm1,%ymm4,%ymm5
   1081a:	kxnorw %k0,%k0,%k1
   1081e:	vpxor  %xmm6,%xmm6,%xmm6
   10822:	vpgatherqd (%r9,%ymm5,4),%xmm6{%k1}
   10829:	vpsrlq $0x20,%ymm4,%ymm5
   1082e:	vpsrlq $0xa,%ymm4,%ymm7
   10833:	vpand  %ymm1,%ymm7,%ymm7
   10837:	kxnorw %k0,%k0,%k1
   1083b:	vpxor  %xmm8,%xmm8,%xmm8
   10840:	vpgatherqd (%r9,%ymm7,4),%xmm8{%k1}
   10847:	vpmovqd %ymm5,%xmm5
   1084d:	vpand  %xmm5,%xmm0,%xmm5
   10851:	vpmovzxdq %xmm5,%ymm7
   10856:	kxnorw %k0,%k0,%k1
   1085a:	vpxor  %xmm9,%xmm9,%xmm9
   1085f:	vpgatherqd (%rsi,%ymm7,4),%xmm9{%k1}
   10866:	vpmovqd %ymm4,%xmm4
   1086c:	vpsrld $0x5,%xmm4,%xmm7
   10871:	vprolvd %xmm7,%xmm6,%xmm6
   10877:	vpsrld $0x14,%xmm4,%xmm7
   1087c:	vpand  %xmm2,%xmm7,%xmm7
   10880:	vpternlogd $0x36,%xmm3,%xmm5,%xmm7
   10887:	vpmovzxdq %xmm7,%ymm5
   1088c:	kxnorw %k0,%k0,%k1
   10890:	vpxor  %xmm7,%xmm7,%xmm7
   10894:	vpgatherqd (%rsi,%ymm5,4),%xmm7{%k1}
   1089b:	vpsrld $0xf,%xmm4,%xmm4
   108a0:	vprolvd %xmm4,%xmm8,%xmm4
   108a6:	vpand  %xmm6,%xmm9,%xmm5
   108aa:	vpcmpeqd %xmm6,%xmm5,%k1
   108b0:	vpand  %xmm4,%xmm7,%xmm5
   108b4:	vpcmpeqd %xmm4,%xmm5,%k0{%k1}
   108ba:	vpmovm2d %k0,%xmm4
   108c0:	vpsrld $0x1f,%xmm4,%xmm4
   108c5:	vmovdqu %xmm4,(%r14,%r12,4)
   108cb:	add    $0x4,%r12
   108cf:	cmp    %r12,%rbx
   108d2:	jne    10810 <bloom_filters::FastPatternBF::Lookup(unsigned int, unsigned long const*, unsigned int*) const+0x580>
   108d8:	cmp    %ebx,%ecx
   108da:	je     10943 <bloom_filters::FastPatternBF::Lookup(unsigned int, unsigned long const*, unsigned int*) const+0x6b3>
   108dc:	nopl   0x0(%rax)
   108e0:	mov    (%rdx,%r11,8),%rbx
   108e4:	mov    %rbx,%r14
   108e7:	shr    $0x20,%r14
   108eb:	and    %edi,%r14d
   108ee:	mov    %ebx,%ecx
   108f0:	and    $0x1f,%ecx
   108f3:	mov    (%r9,%rcx,4),%ebp
   108f7:	mov    %ebx,%ecx
   108f9:	shr    $0x5,%ecx
   108fc:	rol    %cl,%ebp
   108fe:	mov    %ebx,%ecx
   10900:	shr    $0x8,%ecx
   10903:	and    $0x7c,%ecx
   10906:	mov    (%r9,%rcx,1),%r15d
   1090a:	mov    %ebx,%ecx
   1090c:	shr    $0xf,%ecx
   1090f:	rol    %cl,%r15d
   10912:	mov    (%rsi,%r14,4),%ecx
   10916:	andn   %ebp,%ecx,%ecx
   1091b:	shr    $0x14,%ebx
   1091e:	and    $0x7,%ebx
   10921:	or     $0x8,%ebx
   10924:	xor    %r14d,%ebx
   10927:	mov    (%rsi,%rbx,4),%ebx
   1092a:	andn   %r15d,%ebx,%ebx
   1092f:	xor    %ebp,%ebp
   10931:	or     %ecx,%ebx
   10933:	sete   %bpl
   10937:	mov    %ebp,(%r8,%r11,4)
   1093b:	inc    %r11
   1093e:	cmp    %r11,%r10
   10941:	jne    108e0 <bloom_filters::FastPatternBF::Lookup(unsigned int, unsigned long const*, unsigned int*) const+0x650>
   10943:	pop    %rbx
   10944:	pop    %r12
   10946:	pop    %r14
   10948:	pop    %r15
   1094a:	pop    %rbp
   1094b:	vzeroupper
   1094e:	ret
   1094f:	int3

