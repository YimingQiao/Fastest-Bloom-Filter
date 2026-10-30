0000000000191970 <void inline_single_kernel<true, direct_split_experiment::SingleShortcut<direct_split_experiment::IndependentSplit32>, unsigned long>(direct_split_experiment::SingleShortcut<direct_split_experiment::IndependentSplit32> const&, unsigned long, unsigned long const*, unsigned int*)>:
  191970:	test   %rsi,%rsi
  191973:	je     191b2e <void inline_single_kernel<true, direct_split_experiment::SingleShortcut<direct_split_experiment::IndependentSplit32>, unsigned long>(direct_split_experiment::SingleShortcut<direct_split_experiment::IndependentSplit32> const&, unsigned long, unsigned long const*, unsigned int*)+0x1be>
  191979:	push   %rbx
  19197a:	movabs $0xd6e8feb86659fd93,%r8
  191984:	cmp    $0x1,%rsi
  191988:	jne    191991 <void inline_single_kernel<true, direct_split_experiment::SingleShortcut<direct_split_experiment::IndependentSplit32>, unsigned long>(direct_split_experiment::SingleShortcut<direct_split_experiment::IndependentSplit32> const&, unsigned long, unsigned long const*, unsigned int*)+0x21>
  19198a:	xor    %eax,%eax
  19198c:	jmp    191aaf <void inline_single_kernel<true, direct_split_experiment::SingleShortcut<direct_split_experiment::IndependentSplit32>, unsigned long>(direct_split_experiment::SingleShortcut<direct_split_experiment::IndependentSplit32> const&, unsigned long, unsigned long const*, unsigned int*)+0x13f>
  191991:	mov    %rsi,%r9
  191994:	and    $0xfffffffffffffffe,%r9
  191998:	xor    %eax,%eax
  19199a:	vmovdqa -0x18ce82(%rip),%ymm0        # 4b20 <typeinfo name for main::$_60+0x350>
  1919a2:	vpbroadcastq -0x18e59b(%rip),%ymm1        # 3410 <_IO_stdin_used+0x15c>
  1919ab:	vpbroadcastd -0x18e710(%rip),%ymm2        # 32a4 <__abi_tag+0x2fe0>
  1919b4:	vpbroadcastd -0x18e715(%rip),%ymm3        # 32a8 <__abi_tag+0x2fe4>
  1919bd:	nopl   (%rax)
  1919c0:	mov    (%rdx,%rax,8),%r10
  1919c4:	mov    %r10,%r11
  1919c7:	shr    $0x20,%r11
  1919cb:	xor    %r10,%r11
  1919ce:	imul   %r8,%r11
  1919d2:	mov    %r11,%r10
  1919d5:	shr    $0x20,%r10
  1919d9:	xor    %r11,%r10
  1919dc:	imul   %r8,%r10
  1919e0:	mov    %r10,%r11
  1919e3:	shr    $0x20,%r11
  1919e7:	xor    %r10,%r11
  1919ea:	shr    $0x29,%r10
  1919ee:	and    0x18(%rdi),%r10d
  1919f2:	mov    (%rdi),%rbx
  1919f5:	shl    $0x5,%r10d
  1919f9:	vmovdqa (%rbx,%r10,1),%ymm4
  1919ff:	vpbroadcastq %r11,%ymm5
  191a05:	vpsrlvq %ymm0,%ymm5,%ymm5
  191a0a:	vpshufd $0xa0,%ymm5,%ymm5
  191a0f:	vpsrlvd %ymm1,%ymm5,%ymm5
  191a14:	vpand  %ymm2,%ymm5,%ymm5
  191a18:	vpsllvd %ymm5,%ymm3,%ymm5
  191a1d:	xor    %r10d,%r10d
  191a20:	vptest %ymm5,%ymm4
  191a25:	setb   %r10b
  191a29:	mov    %r10d,(%rcx,%rax,4)
  191a2d:	mov    0x8(%rdx,%rax,8),%r10
  191a32:	mov    %r10,%r11
  191a35:	shr    $0x20,%r11
  191a39:	xor    %r10,%r11
  191a3c:	imul   %r8,%r11
  191a40:	mov    %r11,%r10
  191a43:	shr    $0x20,%r10
  191a47:	xor    %r11,%r10
  191a4a:	imul   %r8,%r10
  191a4e:	mov    %r10,%r11
  191a51:	shr    $0x20,%r11
  191a55:	xor    %r10,%r11
  191a58:	shr    $0x29,%r10
  191a5c:	and    0x18(%rdi),%r10d
  191a60:	mov    (%rdi),%rbx
  191a63:	shl    $0x5,%r10d
  191a67:	vmovdqa (%rbx,%r10,1),%ymm4
  191a6d:	vpbroadcastq %r11,%ymm5
  191a73:	vpsrlvq %ymm0,%ymm5,%ymm5
  191a78:	vpshufd $0xa0,%ymm5,%ymm5
  191a7d:	vpsrlvd %ymm1,%ymm5,%ymm5
  191a82:	vpand  %ymm2,%ymm5,%ymm5
  191a86:	vpsllvd %ymm5,%ymm3,%ymm5
  191a8b:	xor    %r10d,%r10d
  191a8e:	vptest %ymm5,%ymm4
  191a93:	setb   %r10b
  191a97:	mov    %r10d,0x4(%rcx,%rax,4)
  191a9c:	add    $0x2,%rax
  191aa0:	cmp    %rax,%r9
  191aa3:	jne    1919c0 <void inline_single_kernel<true, direct_split_experiment::SingleShortcut<direct_split_experiment::IndependentSplit32>, unsigned long>(direct_split_experiment::SingleShortcut<direct_split_experiment::IndependentSplit32> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  191aa9:	test   $0x1,%sil
  191aad:	je     191b2d <void inline_single_kernel<true, direct_split_experiment::SingleShortcut<direct_split_experiment::IndependentSplit32>, unsigned long>(direct_split_experiment::SingleShortcut<direct_split_experiment::IndependentSplit32> const&, unsigned long, unsigned long const*, unsigned int*)+0x1bd>
  191aaf:	mov    (%rdx,%rax,8),%rdx
  191ab3:	mov    %rdx,%rsi
  191ab6:	shr    $0x20,%rsi
  191aba:	xor    %rdx,%rsi
  191abd:	imul   %r8,%rsi
  191ac1:	mov    %rsi,%rdx
  191ac4:	shr    $0x20,%rdx
  191ac8:	xor    %rsi,%rdx
  191acb:	imul   %r8,%rdx
  191acf:	mov    %rdx,%rsi
  191ad2:	shr    $0x20,%rsi
  191ad6:	xor    %rdx,%rsi
  191ad9:	shr    $0x29,%rdx
  191add:	and    0x18(%rdi),%edx
  191ae0:	mov    (%rdi),%rdi
  191ae3:	shl    $0x5,%edx
  191ae6:	vpbroadcastq %rsi,%ymm0
  191aec:	vpsrlvq -0x18cfd5(%rip),%ymm0,%ymm0        # 4b20 <typeinfo name for main::$_60+0x350>
  191af5:	vpshufd $0xa0,%ymm0,%ymm0
  191afa:	vpsrlvd -0x18d063(%rip),%ymm0,%ymm0        # 4aa0 <typeinfo name for main::$_60+0x2d0>
  191b03:	vmovdqa (%rdi,%rdx,1),%ymm1
  191b08:	vpandd -0x18e86e(%rip){1to8},%ymm0,%ymm0        # 32a4 <__abi_tag+0x2fe0>
  191b12:	vpbroadcastd -0x18e873(%rip),%ymm2        # 32a8 <__abi_tag+0x2fe4>
  191b1b:	vpsllvd %ymm0,%ymm2,%ymm0
  191b20:	xor    %edx,%edx
  191b22:	vptest %ymm0,%ymm1
  191b27:	setb   %dl
  191b2a:	mov    %edx,(%rcx,%rax,4)
  191b2d:	pop    %rbx
  191b2e:	vzeroupper
  191b31:	ret
  191b32:	int3
  191b33:	int3
  191b34:	int3
  191b35:	int3
  191b36:	int3
  191b37:	int3
  191b38:	int3
  191b39:	int3
  191b3a:	int3
  191b3b:	int3
  191b3c:	int3
  191b3d:	int3
  191b3e:	int3
  191b3f:	int3

