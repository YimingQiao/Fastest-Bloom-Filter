0000000000106d60 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 4ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 4ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
  106d60:	test   %rsi,%rsi
  106d63:	je     106e2c <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 4ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 4ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0xcc>
  106d69:	push   %rbx
  106d6a:	mov    %rdx,%rax
  106d6d:	movabs $0xd6e8feb86659fd93,%r8
  106d77:	xor    %r9d,%r9d
  106d7a:	movabs $0xf1357aea2e62a9c5,%r10
  106d84:	vmovdqa -0x10256c(%rip),%ymm0        # 4820 <typeinfo name for main::$_60+0x50>
  106d8c:	vpbroadcastq -0x1039f5(%rip),%ymm1        # 33a0 <_IO_stdin_used+0xec>
  106d95:	vpbroadcastq -0x103a46(%rip),%ymm2        # 3358 <_IO_stdin_used+0xa4>
  106d9e:	xchg   %ax,%ax
  106da0:	mov    (%rax,%r9,8),%rdx
  106da4:	mov    %rdx,%r11
  106da7:	shr    $0x20,%r11
  106dab:	xor    %rdx,%r11
  106dae:	imul   %r8,%r11
  106db2:	mov    %r11,%rbx
  106db5:	shr    $0x20,%rbx
  106db9:	xor    %r11,%rbx
  106dbc:	imul   %r8,%rbx
  106dc0:	mov    %rbx,%rdx
  106dc3:	shr    $0x20,%rdx
  106dc7:	xor    %rbx,%rdx
  106dca:	or     $0x1,%rdx
  106dce:	mov    0x20(%rdi),%r11
  106dd2:	mulx   0x10(%rdi),%rbx,%rbx
  106dd8:	imul   %r10,%rdx
  106ddc:	prefetcht0 (%r11,%rbx,8)
  106de1:	vpbroadcastq %rdx,%ymm3
  106de7:	vpsrlvq %ymm0,%ymm3,%ymm3
  106dec:	vpand  %ymm1,%ymm3,%ymm3
  106df0:	vpsllvq %ymm3,%ymm2,%ymm3
  106df5:	vextracti128 $0x1,%ymm3,%xmm4
  106dfb:	vpor   %xmm4,%xmm3,%xmm3
  106dff:	vpshufd $0xee,%xmm3,%xmm4
  106e04:	vpor   %xmm4,%xmm3,%xmm3
  106e08:	vmovq  %xmm3,%rdx
  106e0d:	mov    (%r11,%rbx,8),%r11
  106e11:	xor    %ebx,%ebx
  106e13:	andn   %rdx,%r11,%rdx
  106e18:	sete   %bl
  106e1b:	mov    %ebx,(%rcx,%r9,4)
  106e1f:	inc    %r9
  106e22:	cmp    %r9,%rsi
  106e25:	jne    106da0 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 4ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 4ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
  106e2b:	pop    %rbx
  106e2c:	vzeroupper
  106e2f:	ret

