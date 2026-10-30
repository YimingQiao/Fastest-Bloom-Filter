000000000018ca90 <void inline_single_kernel<true, direct_split_experiment::IndependentSplit32, unsigned long>(direct_split_experiment::IndependentSplit32 const&, unsigned long, unsigned long const*, unsigned int*)>:
  18ca90:	test   %rsi,%rsi
  18ca93:	je     18cc4e <void inline_single_kernel<true, direct_split_experiment::IndependentSplit32, unsigned long>(direct_split_experiment::IndependentSplit32 const&, unsigned long, unsigned long const*, unsigned int*)+0x1be>
  18ca99:	push   %rbx
  18ca9a:	movabs $0xd6e8feb86659fd93,%r8
  18caa4:	cmp    $0x1,%rsi
  18caa8:	jne    18cab1 <void inline_single_kernel<true, direct_split_experiment::IndependentSplit32, unsigned long>(direct_split_experiment::IndependentSplit32 const&, unsigned long, unsigned long const*, unsigned int*)+0x21>
  18caaa:	xor    %eax,%eax
  18caac:	jmp    18cbcf <void inline_single_kernel<true, direct_split_experiment::IndependentSplit32, unsigned long>(direct_split_experiment::IndependentSplit32 const&, unsigned long, unsigned long const*, unsigned int*)+0x13f>
  18cab1:	mov    %rsi,%r9
  18cab4:	and    $0xfffffffffffffffe,%r9
  18cab8:	xor    %eax,%eax
  18caba:	vmovdqa -0x187fa2(%rip),%ymm0        # 4b20 <typeinfo name for main::$_60+0x350>
  18cac2:	vpbroadcastq -0x1896bb(%rip),%ymm1        # 3410 <_IO_stdin_used+0x15c>
  18cacb:	vpbroadcastd -0x189830(%rip),%ymm2        # 32a4 <__abi_tag+0x2fe0>
  18cad4:	vpbroadcastd -0x189835(%rip),%ymm3        # 32a8 <__abi_tag+0x2fe4>
  18cadd:	nopl   (%rax)
  18cae0:	mov    (%rdx,%rax,8),%r10
  18cae4:	mov    %r10,%r11
  18cae7:	shr    $0x20,%r11
  18caeb:	xor    %r10,%r11
  18caee:	imul   %r8,%r11
  18caf2:	mov    %r11,%r10
  18caf5:	shr    $0x20,%r10
  18caf9:	xor    %r11,%r10
  18cafc:	imul   %r8,%r10
  18cb00:	mov    %r10,%r11
  18cb03:	shr    $0x20,%r11
  18cb07:	xor    %r10,%r11
  18cb0a:	shr    $0x29,%r10
  18cb0e:	and    0x18(%rdi),%r10d
  18cb12:	mov    (%rdi),%rbx
  18cb15:	shl    $0x5,%r10d
  18cb19:	vmovdqa (%rbx,%r10,1),%ymm4
  18cb1f:	vpbroadcastq %r11,%ymm5
  18cb25:	vpsrlvq %ymm0,%ymm5,%ymm5
  18cb2a:	vpshufd $0xa0,%ymm5,%ymm5
  18cb2f:	vpsrlvd %ymm1,%ymm5,%ymm5
  18cb34:	vpand  %ymm2,%ymm5,%ymm5
  18cb38:	vpsllvd %ymm5,%ymm3,%ymm5
  18cb3d:	xor    %r10d,%r10d
  18cb40:	vptest %ymm5,%ymm4
  18cb45:	setb   %r10b
  18cb49:	mov    %r10d,(%rcx,%rax,4)
  18cb4d:	mov    0x8(%rdx,%rax,8),%r10
  18cb52:	mov    %r10,%r11
  18cb55:	shr    $0x20,%r11
  18cb59:	xor    %r10,%r11
  18cb5c:	imul   %r8,%r11
  18cb60:	mov    %r11,%r10
  18cb63:	shr    $0x20,%r10
  18cb67:	xor    %r11,%r10
  18cb6a:	imul   %r8,%r10
  18cb6e:	mov    %r10,%r11
  18cb71:	shr    $0x20,%r11
  18cb75:	xor    %r10,%r11
  18cb78:	shr    $0x29,%r10
  18cb7c:	and    0x18(%rdi),%r10d
  18cb80:	mov    (%rdi),%rbx
  18cb83:	shl    $0x5,%r10d
  18cb87:	vmovdqa (%rbx,%r10,1),%ymm4
  18cb8d:	vpbroadcastq %r11,%ymm5
  18cb93:	vpsrlvq %ymm0,%ymm5,%ymm5
  18cb98:	vpshufd $0xa0,%ymm5,%ymm5
  18cb9d:	vpsrlvd %ymm1,%ymm5,%ymm5
  18cba2:	vpand  %ymm2,%ymm5,%ymm5
  18cba6:	vpsllvd %ymm5,%ymm3,%ymm5
  18cbab:	xor    %r10d,%r10d
  18cbae:	vptest %ymm5,%ymm4
  18cbb3:	setb   %r10b
  18cbb7:	mov    %r10d,0x4(%rcx,%rax,4)
  18cbbc:	add    $0x2,%rax
  18cbc0:	cmp    %rax,%r9
  18cbc3:	jne    18cae0 <void inline_single_kernel<true, direct_split_experiment::IndependentSplit32, unsigned long>(direct_split_experiment::IndependentSplit32 const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  18cbc9:	test   $0x1,%sil
  18cbcd:	je     18cc4d <void inline_single_kernel<true, direct_split_experiment::IndependentSplit32, unsigned long>(direct_split_experiment::IndependentSplit32 const&, unsigned long, unsigned long const*, unsigned int*)+0x1bd>
  18cbcf:	mov    (%rdx,%rax,8),%rdx
  18cbd3:	mov    %rdx,%rsi
  18cbd6:	shr    $0x20,%rsi
  18cbda:	xor    %rdx,%rsi
  18cbdd:	imul   %r8,%rsi
  18cbe1:	mov    %rsi,%rdx
  18cbe4:	shr    $0x20,%rdx
  18cbe8:	xor    %rsi,%rdx
  18cbeb:	imul   %r8,%rdx
  18cbef:	mov    %rdx,%rsi
  18cbf2:	shr    $0x20,%rsi
  18cbf6:	xor    %rdx,%rsi
  18cbf9:	shr    $0x29,%rdx
  18cbfd:	and    0x18(%rdi),%edx
  18cc00:	mov    (%rdi),%rdi
  18cc03:	shl    $0x5,%edx
  18cc06:	vpbroadcastq %rsi,%ymm0
  18cc0c:	vpsrlvq -0x1880f5(%rip),%ymm0,%ymm0        # 4b20 <typeinfo name for main::$_60+0x350>
  18cc15:	vpshufd $0xa0,%ymm0,%ymm0
  18cc1a:	vpsrlvd -0x188183(%rip),%ymm0,%ymm0        # 4aa0 <typeinfo name for main::$_60+0x2d0>
  18cc23:	vmovdqa (%rdi,%rdx,1),%ymm1
  18cc28:	vpandd -0x18998e(%rip){1to8},%ymm0,%ymm0        # 32a4 <__abi_tag+0x2fe0>
  18cc32:	vpbroadcastd -0x189993(%rip),%ymm2        # 32a8 <__abi_tag+0x2fe4>
  18cc3b:	vpsllvd %ymm0,%ymm2,%ymm0
  18cc40:	xor    %edx,%edx
  18cc42:	vptest %ymm0,%ymm1
  18cc47:	setb   %dl
  18cc4a:	mov    %edx,(%rcx,%rax,4)
  18cc4d:	pop    %rbx
  18cc4e:	vzeroupper
  18cc51:	ret
  18cc52:	int3
  18cc53:	int3
  18cc54:	int3
  18cc55:	int3
  18cc56:	int3
  18cc57:	int3
  18cc58:	int3
  18cc59:	int3
  18cc5a:	int3
  18cc5b:	int3
  18cc5c:	int3
  18cc5d:	int3
  18cc5e:	int3
  18cc5f:	int3

