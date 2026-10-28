00000000001189e0 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 6ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 6ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
  1189e0:	test   %rsi,%rsi
  1189e3:	je     118ace <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 6ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 6ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0xee>
  1189e9:	push   %rbx
  1189ea:	mov    %rdx,%rax
  1189ed:	xor    %r8d,%r8d
  1189f0:	movabs $0xf1357aea2e62a9c5,%r9
  1189fa:	vmovdqa -0x114182(%rip),%ymm0        # 4880 <typeinfo name for main::$_60+0xb0>
  118a02:	vpbroadcastq -0x11562b(%rip),%ymm1        # 33e0 <_IO_stdin_used+0x12c>
  118a0b:	vmovdqa -0x114053(%rip),%ymm2        # 49c0 <typeinfo name for main::$_60+0x1f0>
  118a13:	vpbroadcastq -0x11567c(%rip),%ymm3        # 33a0 <_IO_stdin_used+0xec>
  118a1c:	nopl   0x0(%rax)
  118a20:	mov    (%rax,%r8,8),%rdx
  118a24:	or     $0x1,%rdx
  118a28:	mov    0x20(%rdi),%r11
  118a2c:	mulx   0x10(%rdi),%rbx,%rbx
  118a32:	shl    $0x6,%rbx
  118a36:	lea    (%r11,%rbx,1),%r10
  118a3a:	prefetcht0 (%r11,%rbx,1)
  118a3f:	imul   %r9,%rdx
  118a43:	vpbroadcastq %rdx,%ymm4
  118a49:	vpsrlvq %ymm0,%ymm4,%ymm5
  118a4e:	vpand  %ymm1,%ymm5,%ymm5
  118a52:	kxnorw %k0,%k0,%k1
  118a56:	vpxor  %xmm6,%xmm6,%xmm6
  118a5a:	vpgatherqq (%r10,%ymm5,8),%ymm6{%k1}
  118a61:	vpsrlvq %ymm2,%ymm4,%ymm4
  118a66:	mov    %rdx,%r11
  118a69:	shr    $0x2d,%r11
  118a6d:	and    $0x7,%r11d
  118a71:	mov    %rdx,%rbx
  118a74:	shr    $0x30,%rbx
  118a78:	shrx   %rbx,(%r10,%r11,8),%r11
  118a7e:	vpand  %ymm3,%ymm4,%ymm4
  118a82:	mov    %rdx,%rbx
  118a85:	shr    $0x36,%rbx
  118a89:	and    $0x7,%ebx
  118a8c:	shr    $0x39,%rdx
  118a90:	shrx   %rdx,(%r10,%rbx,8),%rdx
  118a96:	vpsrlvq %ymm4,%ymm6,%ymm4
  118a9b:	vextracti128 $0x1,%ymm4,%xmm5
  118aa1:	vpand  %xmm5,%xmm4,%xmm4
  118aa5:	vpshufd $0xee,%xmm4,%xmm5
  118aaa:	vpand  %xmm4,%xmm5,%xmm4
  118aae:	vmovd  %xmm4,%r10d
  118ab3:	and    %edx,%r11d
  118ab6:	and    %r10d,%r11d
  118ab9:	and    $0x1,%r11d
  118abd:	mov    %r11d,(%rcx,%r8,4)
  118ac1:	inc    %r8
  118ac4:	cmp    %r8,%rsi
  118ac7:	jne    118a20 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 6ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 6ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
  118acd:	pop    %rbx
  118ace:	vzeroupper
  118ad1:	ret
  118ad2:	int3
  118ad3:	int3
  118ad4:	int3
  118ad5:	int3
  118ad6:	int3
  118ad7:	int3
  118ad8:	int3
  118ad9:	int3
  118ada:	int3
  118adb:	int3
  118adc:	int3
  118add:	int3
  118ade:	int3
  118adf:	int3

