000000000010c9e0 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 6ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 6ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
  10c9e0:	test   %rsi,%rsi
  10c9e3:	je     10ca99 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 6ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 6ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0xb9>
  10c9e9:	push   %r14
  10c9eb:	push   %rbx
  10c9ec:	mov    %rdx,%rax
  10c9ef:	xor    %r8d,%r8d
  10c9f2:	movabs $0xf1357aea2e62a9c5,%r9
  10c9fc:	vmovdqa -0x1081e4(%rip),%ymm0        # 4820 <typeinfo name for main::$_60+0x50>
  10ca04:	vpbroadcastq -0x10966d(%rip),%ymm1        # 33a0 <_IO_stdin_used+0xec>
  10ca0d:	vpbroadcastq -0x1096be(%rip),%ymm2        # 3358 <_IO_stdin_used+0xa4>
  10ca16:	cs nopw 0x0(%rax,%rax,1)
  10ca20:	mov    (%rax,%r8,8),%rdx
  10ca24:	or     $0x1,%rdx
  10ca28:	mov    0x20(%rdi),%r10
  10ca2c:	mulx   0x10(%rdi),%r11,%r11
  10ca32:	prefetcht0 (%r10,%r11,8)
  10ca37:	imul   %r9,%rdx
  10ca3b:	vpbroadcastq %rdx,%ymm3
  10ca41:	vpsrlvq %ymm0,%ymm3,%ymm3
  10ca46:	vpand  %ymm1,%ymm3,%ymm3
  10ca4a:	vpsllvq %ymm3,%ymm2,%ymm3
  10ca4f:	mov    %rdx,%rbx
  10ca52:	shr    $0x1e,%rbx
  10ca56:	shr    $0x24,%rdx
  10ca5a:	vextracti128 $0x1,%ymm3,%xmm4
  10ca60:	vpor   %xmm4,%xmm3,%xmm3
  10ca64:	vpshufd $0xee,%xmm3,%xmm4
  10ca69:	vpor   %xmm4,%xmm3,%xmm3
  10ca6d:	vmovq  %xmm3,%r14
  10ca72:	bts    %rbx,%r14
  10ca76:	bts    %rdx,%r14
  10ca7a:	mov    (%r10,%r11,8),%rdx
  10ca7e:	xor    %r10d,%r10d
  10ca81:	andn   %r14,%rdx,%rdx
  10ca86:	sete   %r10b
  10ca8a:	mov    %r10d,(%rcx,%r8,4)
  10ca8e:	inc    %r8
  10ca91:	cmp    %r8,%rsi
  10ca94:	jne    10ca20 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 6ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 6ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
  10ca96:	pop    %rbx
  10ca97:	pop    %r14
  10ca99:	vzeroupper
  10ca9c:	ret
  10ca9d:	int3
  10ca9e:	int3
  10ca9f:	int3

