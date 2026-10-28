000000000011f0d0 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
  11f0d0:	test   %rsi,%rsi
  11f0d3:	je     11f232 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x162>
  11f0d9:	push   %r15
  11f0db:	push   %r14
  11f0dd:	push   %r12
  11f0df:	push   %rbx
  11f0e0:	mov    %rdx,%rax
  11f0e3:	movabs $0xd6e8feb86659fd93,%r8
  11f0ed:	xor    %r9d,%r9d
  11f0f0:	movabs $0xf1357aea2e62a9c5,%r10
  11f0fa:	movabs $0x9e3779b97f4a7c15,%r11
  11f104:	vmovdqa -0x11a72c(%rip),%ymm0        # 49e0 <typeinfo name for main::$_60+0x210>
  11f10c:	vmovdqa -0x11a894(%rip),%ymm1        # 4880 <typeinfo name for main::$_60+0xb0>
  11f114:	vpbroadcastd -0x11be99(%rip),%xmm2        # 3284 <__abi_tag+0x2fc0>
  11f11d:	vmovdqa -0x11a825(%rip),%ymm3        # 4900 <typeinfo name for main::$_60+0x130>
  11f125:	vmovdqa -0x11a76d(%rip),%ymm4        # 49c0 <typeinfo name for main::$_60+0x1f0>
  11f12d:	vpbroadcastq -0x11bd96(%rip),%ymm5        # 33a0 <_IO_stdin_used+0xec>
  11f136:	cs nopw 0x0(%rax,%rax,1)
  11f140:	mov    (%rax,%r9,8),%rdx
  11f144:	mov    %rdx,%rbx
  11f147:	shr    $0x20,%rbx
  11f14b:	xor    %rdx,%rbx
  11f14e:	imul   %r8,%rbx
  11f152:	mov    %rbx,%r14
  11f155:	shr    $0x20,%r14
  11f159:	xor    %rbx,%r14
  11f15c:	imul   %r8,%r14
  11f160:	mov    %r14,%rdx
  11f163:	shr    $0x20,%rdx
  11f167:	xor    %r14,%rdx
  11f16a:	or     $0x1,%rdx
  11f16e:	mov    0x20(%rdi),%rbx
  11f172:	mulx   0x10(%rdi),%r14,%r14
  11f178:	imul   %r10,%rdx
  11f17c:	mulx   %r11,%r15,%r12
  11f181:	xor    %r15,%r12
  11f184:	shl    $0x6,%r14
  11f188:	vpbroadcastq %rdx,%ymm6
  11f18e:	lea    (%rbx,%r14,1),%rdx
  11f192:	vpbroadcastq %r12,%xmm7
  11f198:	vinserti128 $0x1,%xmm7,%ymm6,%ymm7
  11f19e:	vpsrlvq %ymm1,%ymm6,%ymm8
  11f1a3:	vpmovqd %ymm8,%xmm8
  11f1a9:	vpand  %xmm2,%xmm8,%xmm8
  11f1ad:	kxnorw %k0,%k0,%k1
  11f1b1:	vpxor  %xmm9,%xmm9,%xmm9
  11f1b6:	vpgatherdq (%rdx,%xmm8,8),%ymm9{%k1}
  11f1bd:	vpsrlvq %ymm0,%ymm7,%ymm8
  11f1c2:	vpmovqd %ymm8,%xmm8
  11f1c8:	vpand  %xmm2,%xmm8,%xmm8
  11f1cc:	kxnorw %k0,%k0,%k1
  11f1d0:	vpxor  %xmm10,%xmm10,%xmm10
  11f1d5:	vpgatherdq (%rdx,%xmm8,8),%ymm10{%k1}
  11f1dc:	prefetcht0 (%rbx,%r14,1)
  11f1e1:	vpsrlvq %ymm3,%ymm7,%ymm7
  11f1e6:	vpsrlvq %ymm4,%ymm6,%ymm6
  11f1eb:	vpand  %ymm5,%ymm7,%ymm7
  11f1ef:	vpsrlvq %ymm7,%ymm10,%ymm7
  11f1f4:	vpand  %ymm5,%ymm6,%ymm6
  11f1f8:	vpsrlvq %ymm6,%ymm9,%ymm6
  11f1fd:	vpand  %ymm7,%ymm6,%ymm6
  11f201:	vextracti128 $0x1,%ymm6,%xmm7
  11f207:	vpand  %xmm7,%xmm6,%xmm6
  11f20b:	vpshufd $0xee,%xmm6,%xmm7
  11f210:	vpand  %xmm6,%xmm7,%xmm6
  11f214:	vmovd  %xmm6,%edx
  11f218:	and    $0x1,%edx
  11f21b:	mov    %edx,(%rcx,%r9,4)
  11f21f:	inc    %r9
  11f222:	cmp    %r9,%rsi
  11f225:	jne    11f140 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x70>
  11f22b:	pop    %rbx
  11f22c:	pop    %r12
  11f22e:	pop    %r14
  11f230:	pop    %r15
  11f232:	vzeroupper
  11f235:	ret
  11f236:	int3
  11f237:	int3
  11f238:	int3
  11f239:	int3
  11f23a:	int3
  11f23b:	int3
  11f23c:	int3
  11f23d:	int3
  11f23e:	int3
  11f23f:	int3

