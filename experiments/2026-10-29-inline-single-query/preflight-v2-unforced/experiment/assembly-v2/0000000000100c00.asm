0000000000100c00 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
  100c00:	test   %rsi,%rsi
  100c03:	je     100ce6 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0xe6>
  100c09:	push   %rbx
  100c0a:	mov    %rdx,%rax
  100c0d:	movabs $0xd6e8feb86659fd93,%r8
  100c17:	xor    %r9d,%r9d
  100c1a:	movabs $0xf1357aea2e62a9c5,%r10
  100c24:	vmovdqa -0xfc1ac(%rip),%ymm0        # 4a80 <typeinfo name for main::$_60+0x2b0>
  100c2c:	vpbroadcastq -0xfd8dd(%rip),%ymm1        # 3358 <_IO_stdin_used+0xa4>
  100c35:	data16 cs nopw 0x0(%rax,%rax,1)
  100c40:	mov    (%rax,%r9,8),%rdx
  100c44:	mov    %rdx,%r11
  100c47:	shr    $0x20,%r11
  100c4b:	xor    %rdx,%r11
  100c4e:	imul   %r8,%r11
  100c52:	mov    %r11,%rbx
  100c55:	shr    $0x20,%rbx
  100c59:	xor    %r11,%rbx
  100c5c:	imul   %r8,%rbx
  100c60:	mov    %rbx,%rdx
  100c63:	shr    $0x20,%rdx
  100c67:	xor    %rbx,%rdx
  100c6a:	or     $0x1,%rdx
  100c6e:	mov    0x20(%rdi),%r11
  100c72:	mulx   0x10(%rdi),%rbx,%rbx
  100c78:	imul   %r10,%rdx
  100c7c:	shl    $0x6,%rbx
  100c80:	prefetcht0 (%r11,%rbx,1)
  100c85:	vmovdqa (%r11,%rbx,1),%ymm2
  100c8b:	vmovdqa 0x20(%r11,%rbx,1),%ymm3
  100c92:	vpbroadcastq %rdx,%ymm4
  100c98:	vpsllvq %ymm0,%ymm4,%ymm4
  100c9d:	vpsrld $0x1a,%ymm4,%ymm4
  100ca2:	vpmovzxdq %xmm4,%ymm5
  100ca7:	vpsllvq %ymm5,%ymm1,%ymm5
  100cac:	vextracti128 $0x1,%ymm4,%xmm4
  100cb2:	vpmovzxdq %xmm4,%ymm4
  100cb7:	vptest %ymm5,%ymm2
  100cbc:	setb   %dl
  100cbf:	vpsllvq %ymm4,%ymm1,%ymm2
  100cc4:	vptest %ymm2,%ymm3
  100cc9:	setb   %r11b
  100ccd:	xor    %ebx,%ebx
  100ccf:	test   %dl,%r11b
  100cd2:	setne  %bl
  100cd5:	mov    %ebx,(%rcx,%r9,4)
  100cd9:	inc    %r9
  100cdc:	cmp    %r9,%rsi
  100cdf:	jne    100c40 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
  100ce5:	pop    %rbx
  100ce6:	vzeroupper
  100ce9:	ret
  100cea:	int3
  100ceb:	int3
  100cec:	int3
  100ced:	int3
  100cee:	int3
  100cef:	int3

