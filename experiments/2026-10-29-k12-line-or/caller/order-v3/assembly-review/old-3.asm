   14fd0:	cmp    $0x4,%esi
   14fd3:	jae    14fe4 <void bloom_filters::K12LineOrCandidate::InsertVector<true>(unsigned int, unsigned long const*)+0x14>
   14fd5:	xor    %r9d,%r9d
   14fd8:	sub    %r9d,%esi
   14fdb:	lea    (%rdx,%r9,8),%rdx
   14fdf:	jmp    15650 <bloom_filters::K12LineOrCandidate::InsertScalar(unsigned int, unsigned long const*)>
   14fe4:	push   %rbx
   14fe5:	mov    %esi,%eax
   14fe7:	xor    %ecx,%ecx
   14fe9:	vmovdqa64 -0x125b3(%rip),%zmm0        # 2a40 <_IO_stdin_used+0x9a4>
   14ff3:	vmovdqa64 -0x1257d(%rip),%zmm1        # 2a80 <_IO_stdin_used+0x9e4>
   14ffd:	vbroadcasti32x4 -0x11d97(%rip),%zmm2        # 3270 <typeinfo name for main::$_2+0x24>
   15007:	vmovdqa64 -0x12511(%rip),%zmm3        # 2b00 <_IO_stdin_used+0xa64>
   15011:	vbroadcasti32x4 -0x11dbb(%rip),%zmm4        # 3260 <typeinfo name for main::$_2+0x14>
   1501b:	vbroadcasti32x4 -0x11da5(%rip),%zmm5        # 3280 <typeinfo name for main::$_2+0x34>
   15025:	vmovdqa64 -0x1246f(%rip),%zmm6        # 2bc0 <_IO_stdin_used+0xb24>
   1502f:	vpbroadcastd -0x12fa9(%rip),%zmm7        # 2090 <__abi_tag+0x1dcc>
   15039:	vbroadcasti32x4 -0x11db3(%rip),%zmm8        # 3290 <typeinfo name for main::$_2+0x44>
   15043:	vpbroadcastd -0x12fc4(%rip),%xmm9        # 2088 <__abi_tag+0x1dc4>
   1504c:	vpbroadcastd -0x12fc1(%rip),%xmm10        # 2094 <__abi_tag+0x1dd0>
   15055:	movabs $0x3ffffffc0,%r8
   1505f:	jmp    1529e <void bloom_filters::K12LineOrCandidate::InsertVector<true>(unsigned int, unsigned long const*)+0x2ce>
   15064:	data16 data16 cs nopw 0x0(%rax,%rax,1)
   15070:	vmovdqu (%rdx,%rcx,8),%ymm11
   15075:	vpxor  %xmm12,%xmm12,%xmm12
   1507a:	vpermd %zmm11,%zmm0,%zmm12
   15080:	vprorvd %zmm2,%zmm12,%zmm13
   15086:	vpxor  %xmm12,%xmm12,%xmm12
   1508b:	vpermd %zmm11,%zmm1,%zmm12
   15091:	vpxor  %xmm11,%xmm11,%xmm11
   15096:	vpermd %zmm3,%zmm13,%zmm11
   1509c:	vpsrld $0x4,%zmm13,%zmm13
   150a3:	vprolvd %zmm13,%zmm11,%zmm11
   150a9:	vpsrlvd %zmm4,%zmm12,%zmm13
   150af:	vpandd %zmm5,%zmm13,%zmm14
   150b5:	vpsrld $0x8,%zmm12,%zmm13
   150bc:	vpbroadcastd %r10d,%zmm15
   150c2:	vpmuludq %zmm13,%zmm15,%zmm13
   150c8:	vpsrlq $0x18,%zmm13,%zmm13
   150cf:	vpsrlq $0x28,%zmm12,%zmm16
   150d6:	vpmuludq %zmm16,%zmm15,%zmm15
   150dc:	vpshufb %zmm6,%zmm15,%zmm15
   150e2:	vpord  %zmm13,%zmm15,%zmm13
   150e8:	vpslld $0x4,%zmm13,%zmm13
   150ef:	vpternlogd $0xec,%zmm7,%zmm13,%zmm12
   150f6:	vpternlogd $0x1e,%zmm8,%zmm14,%zmm12
   150fd:	vmovd  %xmm13,%r10d
   15102:	vpand  %xmm9,%xmm12,%xmm14
   15107:	vpsllvd %xmm14,%xmm10,%xmm14
   1510c:	vpshufd $0xee,%xmm14,%xmm15
   15112:	vpor   %xmm15,%xmm14,%xmm14
   15117:	vpshufd $0x55,%xmm14,%xmm15
   1511d:	vpor   %xmm15,%xmm14,%xmm14
   15122:	vmovw  %xmm14,%r11d
   15128:	vinserti128 $0x1,%xmm0,%ymm11,%ymm14
   1512e:	vinserti64x4 $0x1,%ymm0,%zmm14,%zmm14
   15135:	kmovd  %r11d,%k1
   1513a:	vpexpandd %zmm14,%zmm14{%k1}{z}
   15140:	vporq  (%r9,%r10,4),%zmm14,%zmm14
   15147:	vmovdqa64 %zmm14,(%r9,%r10,4)
   1514e:	vextracti128 $0x1,%ymm13,%xmm14
   15154:	vmovd  %xmm14,%r9d
   15159:	vextracti128 $0x1,%ymm12,%xmm14
   1515f:	vpand  %xmm9,%xmm14,%xmm14
   15164:	vpsllvd %xmm14,%xmm10,%xmm14
   15169:	vpshufd $0xee,%xmm14,%xmm15
   1516f:	vpor   %xmm15,%xmm14,%xmm14
   15174:	vpshufd $0x55,%xmm14,%xmm15
   1517a:	vpor   %xmm15,%xmm14,%xmm14
   1517f:	vmovw  %xmm14,%r10d
   15185:	vextracti128 $0x1,%ymm11,%xmm14
   1518b:	vinserti128 $0x1,%xmm0,%ymm14,%ymm14
   15191:	vinserti64x4 $0x1,%ymm0,%zmm14,%zmm14
   15198:	kmovd  %r10d,%k1
   1519d:	vpexpandd %zmm14,%zmm14{%k1}{z}
   151a3:	mov    (%rdi),%r10
   151a6:	vporq  (%r10,%r9,4),%zmm14,%zmm14
   151ad:	vmovdqa64 %zmm14,(%r10,%r9,4)
   151b4:	vextracti32x4 $0x2,%zmm13,%xmm14
   151bb:	vextracti32x4 $0x2,%zmm12,%xmm15
   151c2:	vpand  %xmm9,%xmm15,%xmm15
   151c7:	vpsllvd %xmm15,%xmm10,%xmm15
   151cc:	vpshufd $0xee,%xmm15,%xmm16
   151d3:	vpord  %xmm16,%xmm15,%xmm15
   151d9:	vpshufd $0x55,%xmm15,%xmm16
   151e0:	vpord  %xmm16,%xmm15,%xmm15
   151e6:	vmovw  %xmm15,%r9d
   151ec:	vextracti32x4 $0x2,%zmm11,%xmm15
   151f3:	vinserti128 $0x1,%xmm0,%ymm15,%ymm15
   151f9:	vinserti64x4 $0x1,%ymm0,%zmm15,%zmm15
   15200:	kmovd  %r9d,%k1
   15205:	vpexpandd %zmm15,%zmm15{%k1}{z}
   1520b:	vmovd  %xmm14,%r9d
   15210:	mov    (%rdi),%r10
   15213:	vporq  (%r10,%r9,4),%zmm15,%zmm14
   1521a:	vmovdqa64 %zmm14,(%r10,%r9,4)
   15221:	vextracti32x4 $0x3,%zmm13,%xmm13
   15228:	vmovd  %xmm13,%r9d
   1522d:	vextracti32x4 $0x3,%zmm12,%xmm12
   15234:	vpand  %xmm9,%xmm12,%xmm12
   15239:	vpsllvd %xmm12,%xmm10,%xmm12
   1523e:	vpshufd $0xee,%xmm12,%xmm13
   15244:	vpor   %xmm13,%xmm12,%xmm12
   15249:	vpshufd $0x55,%xmm12,%xmm13
   1524f:	vpor   %xmm13,%xmm12,%xmm12
   15254:	vmovw  %xmm12,%r10d
   1525a:	vextracti32x4 $0x3,%zmm11,%xmm11
   15261:	vinserti128 $0x1,%xmm0,%ymm11,%ymm11
   15267:	vinserti64x4 $0x1,%ymm0,%zmm11,%zmm11
   1526e:	kmovd  %r10d,%k1
   15273:	vpexpandd %zmm11,%zmm11{%k1}{z}
   15279:	mov    (%rdi),%r10
   1527c:	vporq  (%r10,%r9,4),%zmm11,%zmm11
   15283:	vmovdqa64 %zmm11,(%r10,%r9,4)
   1528a:	lea    0x4(%rcx),%r9
   1528e:	add    $0x8,%rcx
   15292:	cmp    %rax,%rcx
   15295:	mov    %r9,%rcx
   15298:	ja     1535b <void bloom_filters::K12LineOrCandidate::InsertVector<true>(unsigned int, unsigned long const*)+0x38b>
   1529e:	lea    0x44(%rcx),%r11
   152a2:	mov    0x18(%rdi),%r10d
   152a6:	mov    (%rdi),%r9
   152a9:	cmp    %rax,%r11
   152ac:	ja     15070 <void bloom_filters::K12LineOrCandidate::InsertVector<true>(unsigned int, unsigned long const*)+0xa0>
   152b2:	mov    0x200(%rdx,%rcx,8),%r11
   152ba:	mov    %r11,%rbx
   152bd:	shr    $0x20,%rbx
   152c1:	shr    $0x28,%r11
   152c5:	imul   %r10,%r11
   152c9:	and    $0x3,%ebx
   152cc:	shr    $0x12,%r11
   152d0:	and    %r8,%r11
   152d3:	add    %r9,%r11
   152d6:	prefetchw (%r11,%rbx,4)
   152db:	mov    0x208(%rdx,%rcx,8),%r11
   152e3:	mov    %r11,%rbx
   152e6:	shr    $0x20,%rbx
   152ea:	shr    $0x28,%r11
   152ee:	imul   %r10,%r11
   152f2:	and    $0x3,%ebx
   152f5:	shr    $0x12,%r11
   152f9:	and    %r8,%r11
   152fc:	add    %r9,%r11
   152ff:	prefetchw (%r11,%rbx,4)
   15304:	mov    0x210(%rdx,%rcx,8),%r11
   1530c:	mov    %r11,%rbx
   1530f:	shr    $0x20,%rbx
   15313:	shr    $0x28,%r11
   15317:	imul   %r10,%r11
   1531b:	and    $0x3,%ebx
   1531e:	shr    $0x12,%r11
   15322:	and    %r8,%r11
   15325:	add    %r9,%r11
   15328:	prefetchw (%r11,%rbx,4)
   1532d:	mov    0x218(%rdx,%rcx,8),%r11
   15335:	mov    %r11,%rbx
   15338:	shr    $0x20,%rbx
   1533c:	shr    $0x28,%r11
   15340:	imul   %r10,%r11
   15344:	and    $0x3,%ebx
   15347:	shr    $0x12,%r11
   1534b:	and    %r8,%r11
   1534e:	add    %r9,%r11
   15351:	prefetchw (%r11,%rbx,4)
   15356:	jmp    15070 <void bloom_filters::K12LineOrCandidate::InsertVector<true>(unsigned int, unsigned long const*)+0xa0>
   1535b:	pop    %rbx
   1535c:	sub    %r9d,%esi
   1535f:	lea    (%rdx,%r9,8),%rdx
   15363:	vzeroupper
   15366:	jmp    15650 <bloom_filters::K12LineOrCandidate::InsertScalar(unsigned int, unsigned long const*)>
