000000000010c960 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 6ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 6ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
  10c960:	test   %rsi,%rsi
  10c963:	je     10ca19 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 6ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 6ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0xb9>
  10c969:	push   %r14
  10c96b:	push   %rbx
  10c96c:	mov    %rdx,%rax
  10c96f:	xor    %r8d,%r8d
  10c972:	movabs $0xf1357aea2e62a9c5,%r9
  10c97c:	vmovdqa -0x108164(%rip),%ymm0        # 4820 <typeinfo name for main::$_60+0x50>
  10c984:	vpbroadcastq -0x1095ed(%rip),%ymm1        # 33a0 <_IO_stdin_used+0xec>
  10c98d:	vpbroadcastq -0x10963e(%rip),%ymm2        # 3358 <_IO_stdin_used+0xa4>
  10c996:	cs nopw 0x0(%rax,%rax,1)
  10c9a0:	mov    (%rax,%r8,8),%rdx
  10c9a4:	or     $0x1,%rdx
  10c9a8:	mov    0x20(%rdi),%r10
  10c9ac:	mulx   0x10(%rdi),%r11,%r11
  10c9b2:	imul   %r9,%rdx
  10c9b6:	prefetcht0 (%r10,%r11,8)
  10c9bb:	vpbroadcastq %rdx,%ymm3
  10c9c1:	vpsrlvq %ymm0,%ymm3,%ymm3
  10c9c6:	vpand  %ymm1,%ymm3,%ymm3
  10c9ca:	vpsllvq %ymm3,%ymm2,%ymm3
  10c9cf:	mov    %rdx,%rbx
  10c9d2:	shr    $0x1e,%rbx
  10c9d6:	shr    $0x24,%rdx
  10c9da:	vextracti128 $0x1,%ymm3,%xmm4
  10c9e0:	vpor   %xmm4,%xmm3,%xmm3
  10c9e4:	vpshufd $0xee,%xmm3,%xmm4
  10c9e9:	vpor   %xmm4,%xmm3,%xmm3
  10c9ed:	vmovq  %xmm3,%r14
  10c9f2:	bts    %rbx,%r14
  10c9f6:	bts    %rdx,%r14
  10c9fa:	mov    (%r10,%r11,8),%rdx
  10c9fe:	xor    %r10d,%r10d
  10ca01:	andn   %r14,%rdx,%rdx
  10ca06:	sete   %r10b
  10ca0a:	mov    %r10d,(%rcx,%r8,4)
  10ca0e:	inc    %r8
  10ca11:	cmp    %r8,%rsi
  10ca14:	jne    10c9a0 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 6ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 6ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
  10ca16:	pop    %rbx
  10ca17:	pop    %r14
  10ca19:	vzeroupper
  10ca1c:	ret
  10ca1d:	int3
  10ca1e:	int3
  10ca1f:	int3

