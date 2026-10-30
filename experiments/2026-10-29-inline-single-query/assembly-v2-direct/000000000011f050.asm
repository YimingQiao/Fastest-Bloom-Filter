000000000011f050 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
  11f050:	test   %rsi,%rsi
  11f053:	je     11f1b2 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x162>
  11f059:	push   %r15
  11f05b:	push   %r14
  11f05d:	push   %r12
  11f05f:	push   %rbx
  11f060:	mov    %rdx,%rax
  11f063:	movabs $0xd6e8feb86659fd93,%r8
  11f06d:	xor    %r9d,%r9d
  11f070:	movabs $0xf1357aea2e62a9c5,%r10
  11f07a:	movabs $0x9e3779b97f4a7c15,%r11
  11f084:	vmovdqa -0x11a6ac(%rip),%ymm0        # 49e0 <typeinfo name for main::$_60+0x210>
  11f08c:	vmovdqa -0x11a814(%rip),%ymm1        # 4880 <typeinfo name for main::$_60+0xb0>
  11f094:	vpbroadcastd -0x11be19(%rip),%xmm2        # 3284 <__abi_tag+0x2fc0>
  11f09d:	vmovdqa -0x11a7a5(%rip),%ymm3        # 4900 <typeinfo name for main::$_60+0x130>
  11f0a5:	vmovdqa -0x11a6ed(%rip),%ymm4        # 49c0 <typeinfo name for main::$_60+0x1f0>
  11f0ad:	vpbroadcastq -0x11bd16(%rip),%ymm5        # 33a0 <_IO_stdin_used+0xec>
  11f0b6:	cs nopw 0x0(%rax,%rax,1)
  11f0c0:	mov    (%rax,%r9,8),%rdx
  11f0c4:	mov    %rdx,%rbx
  11f0c7:	shr    $0x20,%rbx
  11f0cb:	xor    %rdx,%rbx
  11f0ce:	imul   %r8,%rbx
  11f0d2:	mov    %rbx,%r14
  11f0d5:	shr    $0x20,%r14
  11f0d9:	xor    %rbx,%r14
  11f0dc:	imul   %r8,%r14
  11f0e0:	mov    %r14,%rdx
  11f0e3:	shr    $0x20,%rdx
  11f0e7:	xor    %r14,%rdx
  11f0ea:	or     $0x1,%rdx
  11f0ee:	mov    0x20(%rdi),%rbx
  11f0f2:	mulx   0x10(%rdi),%r14,%r14
  11f0f8:	imul   %r10,%rdx
  11f0fc:	mulx   %r11,%r15,%r12
  11f101:	xor    %r15,%r12
  11f104:	shl    $0x6,%r14
  11f108:	vpbroadcastq %rdx,%ymm6
  11f10e:	lea    (%rbx,%r14,1),%rdx
  11f112:	vpbroadcastq %r12,%xmm7
  11f118:	vinserti128 $0x1,%xmm7,%ymm6,%ymm7
  11f11e:	vpsrlvq %ymm1,%ymm6,%ymm8
  11f123:	vpmovqd %ymm8,%xmm8
  11f129:	vpand  %xmm2,%xmm8,%xmm8
  11f12d:	kxnorw %k0,%k0,%k1
  11f131:	vpxor  %xmm9,%xmm9,%xmm9
  11f136:	vpgatherdq (%rdx,%xmm8,8),%ymm9{%k1}
  11f13d:	vpsrlvq %ymm0,%ymm7,%ymm8
  11f142:	vpmovqd %ymm8,%xmm8
  11f148:	vpand  %xmm2,%xmm8,%xmm8
  11f14c:	kxnorw %k0,%k0,%k1
  11f150:	vpxor  %xmm10,%xmm10,%xmm10
  11f155:	vpgatherdq (%rdx,%xmm8,8),%ymm10{%k1}
  11f15c:	prefetcht0 (%rbx,%r14,1)
  11f161:	vpsrlvq %ymm3,%ymm7,%ymm7
  11f166:	vpsrlvq %ymm4,%ymm6,%ymm6
  11f16b:	vpand  %ymm5,%ymm7,%ymm7
  11f16f:	vpsrlvq %ymm7,%ymm10,%ymm7
  11f174:	vpand  %ymm5,%ymm6,%ymm6
  11f178:	vpsrlvq %ymm6,%ymm9,%ymm6
  11f17d:	vpand  %ymm7,%ymm6,%ymm6
  11f181:	vextracti128 $0x1,%ymm6,%xmm7
  11f187:	vpand  %xmm7,%xmm6,%xmm6
  11f18b:	vpshufd $0xee,%xmm6,%xmm7
  11f190:	vpand  %xmm6,%xmm7,%xmm6
  11f194:	vmovd  %xmm6,%edx
  11f198:	and    $0x1,%edx
  11f19b:	mov    %edx,(%rcx,%r9,4)
  11f19f:	inc    %r9
  11f1a2:	cmp    %r9,%rsi
  11f1a5:	jne    11f0c0 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x70>
  11f1ab:	pop    %rbx
  11f1ac:	pop    %r12
  11f1ae:	pop    %r14
  11f1b0:	pop    %r15
  11f1b2:	vzeroupper
  11f1b5:	ret
  11f1b6:	int3
  11f1b7:	int3
  11f1b8:	int3
  11f1b9:	int3
  11f1ba:	int3
  11f1bb:	int3
  11f1bc:	int3
  11f1bd:	int3
  11f1be:	int3
  11f1bf:	int3

