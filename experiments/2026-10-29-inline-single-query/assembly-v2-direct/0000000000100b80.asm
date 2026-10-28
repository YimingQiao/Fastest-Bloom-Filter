0000000000100b80 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
  100b80:	test   %rsi,%rsi
  100b83:	je     100c66 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0xe6>
  100b89:	push   %rbx
  100b8a:	mov    %rdx,%rax
  100b8d:	movabs $0xd6e8feb86659fd93,%r8
  100b97:	xor    %r9d,%r9d
  100b9a:	movabs $0xf1357aea2e62a9c5,%r10
  100ba4:	vmovdqa -0xfc12c(%rip),%ymm0        # 4a80 <typeinfo name for main::$_60+0x2b0>
  100bac:	vpbroadcastq -0xfd85d(%rip),%ymm1        # 3358 <_IO_stdin_used+0xa4>
  100bb5:	data16 cs nopw 0x0(%rax,%rax,1)
  100bc0:	mov    (%rax,%r9,8),%rdx
  100bc4:	mov    %rdx,%r11
  100bc7:	shr    $0x20,%r11
  100bcb:	xor    %rdx,%r11
  100bce:	imul   %r8,%r11
  100bd2:	mov    %r11,%rbx
  100bd5:	shr    $0x20,%rbx
  100bd9:	xor    %r11,%rbx
  100bdc:	imul   %r8,%rbx
  100be0:	mov    %rbx,%rdx
  100be3:	shr    $0x20,%rdx
  100be7:	xor    %rbx,%rdx
  100bea:	or     $0x1,%rdx
  100bee:	mov    0x20(%rdi),%r11
  100bf2:	mulx   0x10(%rdi),%rbx,%rbx
  100bf8:	imul   %r10,%rdx
  100bfc:	shl    $0x6,%rbx
  100c00:	prefetcht0 (%r11,%rbx,1)
  100c05:	vmovdqa (%r11,%rbx,1),%ymm2
  100c0b:	vmovdqa 0x20(%r11,%rbx,1),%ymm3
  100c12:	vpbroadcastq %rdx,%ymm4
  100c18:	vpsllvq %ymm0,%ymm4,%ymm4
  100c1d:	vpsrld $0x1a,%ymm4,%ymm4
  100c22:	vpmovzxdq %xmm4,%ymm5
  100c27:	vpsllvq %ymm5,%ymm1,%ymm5
  100c2c:	vextracti128 $0x1,%ymm4,%xmm4
  100c32:	vpmovzxdq %xmm4,%ymm4
  100c37:	vptest %ymm5,%ymm2
  100c3c:	setb   %dl
  100c3f:	vpsllvq %ymm4,%ymm1,%ymm2
  100c44:	vptest %ymm2,%ymm3
  100c49:	setb   %r11b
  100c4d:	xor    %ebx,%ebx
  100c4f:	test   %dl,%r11b
  100c52:	setne  %bl
  100c55:	mov    %ebx,(%rcx,%r9,4)
  100c59:	inc    %r9
  100c5c:	cmp    %r9,%rsi
  100c5f:	jne    100bc0 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
  100c65:	pop    %rbx
  100c66:	vzeroupper
  100c69:	ret
  100c6a:	int3
  100c6b:	int3
  100c6c:	int3
  100c6d:	int3
  100c6e:	int3
  100c6f:	int3

