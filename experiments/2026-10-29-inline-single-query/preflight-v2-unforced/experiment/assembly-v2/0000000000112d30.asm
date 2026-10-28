0000000000112d30 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
  112d30:	test   %rsi,%rsi
  112d33:	je     112e1e <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0xee>
  112d39:	push   %rbx
  112d3a:	mov    %rdx,%rax
  112d3d:	movabs $0xd6e8feb86659fd93,%r8
  112d47:	xor    %r9d,%r9d
  112d4a:	movabs $0xf1357aea2e62a9c5,%r10
  112d54:	vmovdqa -0x10e47c(%rip),%ymm0        # 48e0 <typeinfo name for main::$_60+0x110>
  112d5c:	vmovdqa -0x10e544(%rip),%ymm1        # 4820 <typeinfo name for main::$_60+0x50>
  112d64:	vpbroadcastq -0x10f9cd(%rip),%ymm2        # 33a0 <_IO_stdin_used+0xec>
  112d6d:	vpbroadcastq -0x10fa1e(%rip),%ymm3        # 3358 <_IO_stdin_used+0xa4>
  112d76:	cs nopw 0x0(%rax,%rax,1)
  112d80:	mov    (%rax,%r9,8),%rdx
  112d84:	mov    %rdx,%r11
  112d87:	shr    $0x20,%r11
  112d8b:	xor    %rdx,%r11
  112d8e:	imul   %r8,%r11
  112d92:	mov    %r11,%rbx
  112d95:	shr    $0x20,%rbx
  112d99:	xor    %r11,%rbx
  112d9c:	imul   %r8,%rbx
  112da0:	mov    %rbx,%rdx
  112da3:	shr    $0x20,%rdx
  112da7:	xor    %rbx,%rdx
  112daa:	or     $0x1,%rdx
  112dae:	mov    0x20(%rdi),%r11
  112db2:	mulx   0x10(%rdi),%rbx,%rbx
  112db8:	prefetcht0 (%r11,%rbx,8)
  112dbd:	imul   %r10,%rdx
  112dc1:	vpbroadcastq %rdx,%ymm4
  112dc7:	vpsrlvq %ymm0,%ymm4,%ymm5
  112dcc:	vpsrlvq %ymm1,%ymm4,%ymm4
  112dd1:	vpand  %ymm2,%ymm4,%ymm4
  112dd5:	vpand  %ymm2,%ymm5,%ymm5
  112dd9:	vpsllvq %ymm5,%ymm3,%ymm5
  112dde:	vpsllvq %ymm4,%ymm3,%ymm4
  112de3:	vpor   %ymm5,%ymm4,%ymm4
  112de7:	vextracti128 $0x1,%ymm4,%xmm5
  112ded:	vpor   %xmm5,%xmm4,%xmm4
  112df1:	vpshufd $0xee,%xmm4,%xmm5
  112df6:	vpor   %xmm5,%xmm4,%xmm4
  112dfa:	vmovq  %xmm4,%rdx
  112dff:	mov    (%r11,%rbx,8),%r11
  112e03:	xor    %ebx,%ebx
  112e05:	andn   %rdx,%r11,%rdx
  112e0a:	sete   %bl
  112e0d:	mov    %ebx,(%rcx,%r9,4)
  112e11:	inc    %r9
  112e14:	cmp    %r9,%rsi
  112e17:	jne    112d80 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  112e1d:	pop    %rbx
  112e1e:	vzeroupper
  112e21:	ret
  112e22:	int3
  112e23:	int3
  112e24:	int3
  112e25:	int3
  112e26:	int3
  112e27:	int3
  112e28:	int3
  112e29:	int3
  112e2a:	int3
  112e2b:	int3
  112e2c:	int3
  112e2d:	int3
  112e2e:	int3
  112e2f:	int3

