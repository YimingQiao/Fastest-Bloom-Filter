000000000018be90 <void inline_single_kernel<true, direct_split_experiment::IndependentSplit32, unsigned long>(direct_split_experiment::IndependentSplit32 const&, unsigned long, unsigned long const*, unsigned int*)>:
  18be90:	test   %rsi,%rsi
  18be93:	je     18c04e <void inline_single_kernel<true, direct_split_experiment::IndependentSplit32, unsigned long>(direct_split_experiment::IndependentSplit32 const&, unsigned long, unsigned long const*, unsigned int*)+0x1be>
  18be99:	push   %rbx
  18be9a:	movabs $0xd6e8feb86659fd93,%r8
  18bea4:	cmp    $0x1,%rsi
  18bea8:	jne    18beb1 <void inline_single_kernel<true, direct_split_experiment::IndependentSplit32, unsigned long>(direct_split_experiment::IndependentSplit32 const&, unsigned long, unsigned long const*, unsigned int*)+0x21>
  18beaa:	xor    %eax,%eax
  18beac:	jmp    18bfcf <void inline_single_kernel<true, direct_split_experiment::IndependentSplit32, unsigned long>(direct_split_experiment::IndependentSplit32 const&, unsigned long, unsigned long const*, unsigned int*)+0x13f>
  18beb1:	mov    %rsi,%r9
  18beb4:	and    $0xfffffffffffffffe,%r9
  18beb8:	xor    %eax,%eax
  18beba:	vmovdqa -0x1873a2(%rip),%ymm0        # 4b20 <typeinfo name for main::$_60+0x350>
  18bec2:	vpbroadcastq -0x188abb(%rip),%ymm1        # 3410 <_IO_stdin_used+0x15c>
  18becb:	vpbroadcastd -0x188c30(%rip),%ymm2        # 32a4 <__abi_tag+0x2fe0>
  18bed4:	vpbroadcastd -0x188c35(%rip),%ymm3        # 32a8 <__abi_tag+0x2fe4>
  18bedd:	nopl   (%rax)
  18bee0:	mov    (%rdx,%rax,8),%r10
  18bee4:	mov    %r10,%r11
  18bee7:	shr    $0x20,%r11
  18beeb:	xor    %r10,%r11
  18beee:	imul   %r8,%r11
  18bef2:	mov    %r11,%r10
  18bef5:	shr    $0x20,%r10
  18bef9:	xor    %r11,%r10
  18befc:	imul   %r8,%r10
  18bf00:	mov    %r10,%r11
  18bf03:	shr    $0x20,%r11
  18bf07:	xor    %r10,%r11
  18bf0a:	shr    $0x29,%r10
  18bf0e:	and    0x18(%rdi),%r10d
  18bf12:	mov    (%rdi),%rbx
  18bf15:	shl    $0x5,%r10d
  18bf19:	vmovdqa (%rbx,%r10,1),%ymm4
  18bf1f:	vpbroadcastq %r11,%ymm5
  18bf25:	vpsrlvq %ymm0,%ymm5,%ymm5
  18bf2a:	vpshufd $0xa0,%ymm5,%ymm5
  18bf2f:	vpsrlvd %ymm1,%ymm5,%ymm5
  18bf34:	vpand  %ymm2,%ymm5,%ymm5
  18bf38:	vpsllvd %ymm5,%ymm3,%ymm5
  18bf3d:	xor    %r10d,%r10d
  18bf40:	vptest %ymm5,%ymm4
  18bf45:	setb   %r10b
  18bf49:	mov    %r10d,(%rcx,%rax,4)
  18bf4d:	mov    0x8(%rdx,%rax,8),%r10
  18bf52:	mov    %r10,%r11
  18bf55:	shr    $0x20,%r11
  18bf59:	xor    %r10,%r11
  18bf5c:	imul   %r8,%r11
  18bf60:	mov    %r11,%r10
  18bf63:	shr    $0x20,%r10
  18bf67:	xor    %r11,%r10
  18bf6a:	imul   %r8,%r10
  18bf6e:	mov    %r10,%r11
  18bf71:	shr    $0x20,%r11
  18bf75:	xor    %r10,%r11
  18bf78:	shr    $0x29,%r10
  18bf7c:	and    0x18(%rdi),%r10d
  18bf80:	mov    (%rdi),%rbx
  18bf83:	shl    $0x5,%r10d
  18bf87:	vmovdqa (%rbx,%r10,1),%ymm4
  18bf8d:	vpbroadcastq %r11,%ymm5
  18bf93:	vpsrlvq %ymm0,%ymm5,%ymm5
  18bf98:	vpshufd $0xa0,%ymm5,%ymm5
  18bf9d:	vpsrlvd %ymm1,%ymm5,%ymm5
  18bfa2:	vpand  %ymm2,%ymm5,%ymm5
  18bfa6:	vpsllvd %ymm5,%ymm3,%ymm5
  18bfab:	xor    %r10d,%r10d
  18bfae:	vptest %ymm5,%ymm4
  18bfb3:	setb   %r10b
  18bfb7:	mov    %r10d,0x4(%rcx,%rax,4)
  18bfbc:	add    $0x2,%rax
  18bfc0:	cmp    %rax,%r9
  18bfc3:	jne    18bee0 <void inline_single_kernel<true, direct_split_experiment::IndependentSplit32, unsigned long>(direct_split_experiment::IndependentSplit32 const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  18bfc9:	test   $0x1,%sil
  18bfcd:	je     18c04d <void inline_single_kernel<true, direct_split_experiment::IndependentSplit32, unsigned long>(direct_split_experiment::IndependentSplit32 const&, unsigned long, unsigned long const*, unsigned int*)+0x1bd>
  18bfcf:	mov    (%rdx,%rax,8),%rdx
  18bfd3:	mov    %rdx,%rsi
  18bfd6:	shr    $0x20,%rsi
  18bfda:	xor    %rdx,%rsi
  18bfdd:	imul   %r8,%rsi
  18bfe1:	mov    %rsi,%rdx
  18bfe4:	shr    $0x20,%rdx
  18bfe8:	xor    %rsi,%rdx
  18bfeb:	imul   %r8,%rdx
  18bfef:	mov    %rdx,%rsi
  18bff2:	shr    $0x20,%rsi
  18bff6:	xor    %rdx,%rsi
  18bff9:	shr    $0x29,%rdx
  18bffd:	and    0x18(%rdi),%edx
  18c000:	mov    (%rdi),%rdi
  18c003:	shl    $0x5,%edx
  18c006:	vpbroadcastq %rsi,%ymm0
  18c00c:	vpsrlvq -0x1874f5(%rip),%ymm0,%ymm0        # 4b20 <typeinfo name for main::$_60+0x350>
  18c015:	vpshufd $0xa0,%ymm0,%ymm0
  18c01a:	vpsrlvd -0x187583(%rip),%ymm0,%ymm0        # 4aa0 <typeinfo name for main::$_60+0x2d0>
  18c023:	vmovdqa (%rdi,%rdx,1),%ymm1
  18c028:	vpandd -0x188d8e(%rip){1to8},%ymm0,%ymm0        # 32a4 <__abi_tag+0x2fe0>
  18c032:	vpbroadcastd -0x188d93(%rip),%ymm2        # 32a8 <__abi_tag+0x2fe4>
  18c03b:	vpsllvd %ymm0,%ymm2,%ymm0
  18c040:	xor    %edx,%edx
  18c042:	vptest %ymm0,%ymm1
  18c047:	setb   %dl
  18c04a:	mov    %edx,(%rcx,%rax,4)
  18c04d:	pop    %rbx
  18c04e:	vzeroupper
  18c051:	ret
  18c052:	int3
  18c053:	int3
  18c054:	int3
  18c055:	int3
  18c056:	int3
  18c057:	int3
  18c058:	int3
  18c059:	int3
  18c05a:	int3
  18c05b:	int3
  18c05c:	int3
  18c05d:	int3
  18c05e:	int3
  18c05f:	int3

