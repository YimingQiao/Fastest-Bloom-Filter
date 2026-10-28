0000000000106de0 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 4ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 4ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
  106de0:	test   %rsi,%rsi
  106de3:	je     106eac <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 4ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 4ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0xcc>
  106de9:	push   %rbx
  106dea:	mov    %rdx,%rax
  106ded:	movabs $0xd6e8feb86659fd93,%r8
  106df7:	xor    %r9d,%r9d
  106dfa:	movabs $0xf1357aea2e62a9c5,%r10
  106e04:	vmovdqa -0x1025ec(%rip),%ymm0        # 4820 <typeinfo name for main::$_60+0x50>
  106e0c:	vpbroadcastq -0x103a75(%rip),%ymm1        # 33a0 <_IO_stdin_used+0xec>
  106e15:	vpbroadcastq -0x103ac6(%rip),%ymm2        # 3358 <_IO_stdin_used+0xa4>
  106e1e:	xchg   %ax,%ax
  106e20:	mov    (%rax,%r9,8),%rdx
  106e24:	mov    %rdx,%r11
  106e27:	shr    $0x20,%r11
  106e2b:	xor    %rdx,%r11
  106e2e:	imul   %r8,%r11
  106e32:	mov    %r11,%rbx
  106e35:	shr    $0x20,%rbx
  106e39:	xor    %r11,%rbx
  106e3c:	imul   %r8,%rbx
  106e40:	mov    %rbx,%rdx
  106e43:	shr    $0x20,%rdx
  106e47:	xor    %rbx,%rdx
  106e4a:	or     $0x1,%rdx
  106e4e:	mov    0x20(%rdi),%r11
  106e52:	mulx   0x10(%rdi),%rbx,%rbx
  106e58:	prefetcht0 (%r11,%rbx,8)
  106e5d:	imul   %r10,%rdx
  106e61:	vpbroadcastq %rdx,%ymm3
  106e67:	vpsrlvq %ymm0,%ymm3,%ymm3
  106e6c:	vpand  %ymm1,%ymm3,%ymm3
  106e70:	vpsllvq %ymm3,%ymm2,%ymm3
  106e75:	vextracti128 $0x1,%ymm3,%xmm4
  106e7b:	vpor   %xmm4,%xmm3,%xmm3
  106e7f:	vpshufd $0xee,%xmm3,%xmm4
  106e84:	vpor   %xmm4,%xmm3,%xmm3
  106e88:	vmovq  %xmm3,%rdx
  106e8d:	mov    (%r11,%rbx,8),%r11
  106e91:	xor    %ebx,%ebx
  106e93:	andn   %rdx,%r11,%rdx
  106e98:	sete   %bl
  106e9b:	mov    %ebx,(%rcx,%r9,4)
  106e9f:	inc    %r9
  106ea2:	cmp    %r9,%rsi
  106ea5:	jne    106e20 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 4ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 4ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
  106eab:	pop    %rbx
  106eac:	vzeroupper
  106eaf:	ret

