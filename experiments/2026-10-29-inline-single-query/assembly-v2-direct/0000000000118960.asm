0000000000118960 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 6ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 6ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
  118960:	test   %rsi,%rsi
  118963:	je     118a4e <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 6ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 6ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0xee>
  118969:	push   %rbx
  11896a:	mov    %rdx,%rax
  11896d:	xor    %r8d,%r8d
  118970:	movabs $0xf1357aea2e62a9c5,%r9
  11897a:	vmovdqa -0x114102(%rip),%ymm0        # 4880 <typeinfo name for main::$_60+0xb0>
  118982:	vpbroadcastq -0x1155ab(%rip),%ymm1        # 33e0 <_IO_stdin_used+0x12c>
  11898b:	vmovdqa -0x113fd3(%rip),%ymm2        # 49c0 <typeinfo name for main::$_60+0x1f0>
  118993:	vpbroadcastq -0x1155fc(%rip),%ymm3        # 33a0 <_IO_stdin_used+0xec>
  11899c:	nopl   0x0(%rax)
  1189a0:	mov    (%rax,%r8,8),%rdx
  1189a4:	or     $0x1,%rdx
  1189a8:	mov    0x20(%rdi),%r11
  1189ac:	mulx   0x10(%rdi),%rbx,%rbx
  1189b2:	imul   %r9,%rdx
  1189b6:	shl    $0x6,%rbx
  1189ba:	lea    (%r11,%rbx,1),%r10
  1189be:	prefetcht0 (%r11,%rbx,1)
  1189c3:	vpbroadcastq %rdx,%ymm4
  1189c9:	vpsrlvq %ymm0,%ymm4,%ymm5
  1189ce:	vpand  %ymm1,%ymm5,%ymm5
  1189d2:	kxnorw %k0,%k0,%k1
  1189d6:	vpxor  %xmm6,%xmm6,%xmm6
  1189da:	vpgatherqq (%r10,%ymm5,8),%ymm6{%k1}
  1189e1:	vpsrlvq %ymm2,%ymm4,%ymm4
  1189e6:	mov    %rdx,%r11
  1189e9:	shr    $0x2d,%r11
  1189ed:	and    $0x7,%r11d
  1189f1:	mov    %rdx,%rbx
  1189f4:	shr    $0x30,%rbx
  1189f8:	shrx   %rbx,(%r10,%r11,8),%r11
  1189fe:	vpand  %ymm3,%ymm4,%ymm4
  118a02:	mov    %rdx,%rbx
  118a05:	shr    $0x36,%rbx
  118a09:	and    $0x7,%ebx
  118a0c:	shr    $0x39,%rdx
  118a10:	shrx   %rdx,(%r10,%rbx,8),%rdx
  118a16:	vpsrlvq %ymm4,%ymm6,%ymm4
  118a1b:	vextracti128 $0x1,%ymm4,%xmm5
  118a21:	vpand  %xmm5,%xmm4,%xmm4
  118a25:	vpshufd $0xee,%xmm4,%xmm5
  118a2a:	vpand  %xmm4,%xmm5,%xmm4
  118a2e:	vmovd  %xmm4,%r10d
  118a33:	and    %edx,%r11d
  118a36:	and    %r10d,%r11d
  118a39:	and    $0x1,%r11d
  118a3d:	mov    %r11d,(%rcx,%r8,4)
  118a41:	inc    %r8
  118a44:	cmp    %r8,%rsi
  118a47:	jne    1189a0 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 6ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 6ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
  118a4d:	pop    %rbx
  118a4e:	vzeroupper
  118a51:	ret
  118a52:	int3
  118a53:	int3
  118a54:	int3
  118a55:	int3
  118a56:	int3
  118a57:	int3
  118a58:	int3
  118a59:	int3
  118a5a:	int3
  118a5b:	int3
  118a5c:	int3
  118a5d:	int3
  118a5e:	int3
  118a5f:	int3

