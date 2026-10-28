0000000000186c30 <void inline_single_kernel<false, direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32>, unsigned long>(direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32> const&, unsigned long, unsigned long const*, unsigned int*)>:
  186c30:	test   %rsi,%rsi
  186c33:	je     186df8 <void inline_single_kernel<false, direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32>, unsigned long>(direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32> const&, unsigned long, unsigned long const*, unsigned int*)+0x1c8>
  186c39:	mov    %esi,%eax
  186c3b:	and    $0x3,%eax
  186c3e:	cmp    $0x4,%rsi
  186c42:	jae    186c4c <void inline_single_kernel<false, direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32>, unsigned long>(direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32> const&, unsigned long, unsigned long const*, unsigned int*)+0x1c>
  186c44:	xor    %r8d,%r8d
  186c47:	jmp    186d88 <void inline_single_kernel<false, direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32>, unsigned long>(direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32> const&, unsigned long, unsigned long const*, unsigned int*)+0x158>
  186c4c:	and    $0xfffffffffffffffc,%rsi
  186c50:	xor    %r8d,%r8d
  186c53:	vpbroadcastq -0x183964(%rip),%xmm0        # 32f8 <_IO_stdin_used+0x44>
  186c5c:	vpbroadcastd -0x1839bd(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
  186c65:	data16 cs nopw 0x0(%rax,%rax,1)
  186c70:	mov    (%rdx,%r8,8),%r9
  186c74:	vpbroadcastq %r9,%xmm2
  186c7a:	shr    $0x29,%r9
  186c7e:	and    0x18(%rdi),%r9d
  186c82:	mov    (%rdi),%r10
  186c85:	shl    $0x5,%r9d
  186c89:	vmovdqa (%r10,%r9,1),%ymm3
  186c8f:	vpmultishiftqb %xmm2,%xmm0,%xmm2
  186c95:	vpmovzxbd %xmm2,%ymm2
  186c9a:	vprolvd %ymm2,%ymm1,%ymm2
  186ca0:	xor    %r9d,%r9d
  186ca3:	vptest %ymm2,%ymm3
  186ca8:	setb   %r9b
  186cac:	mov    %r9d,(%rcx,%r8,4)
  186cb0:	mov    0x8(%rdx,%r8,8),%r9
  186cb5:	vpbroadcastq %r9,%xmm2
  186cbb:	shr    $0x29,%r9
  186cbf:	and    0x18(%rdi),%r9d
  186cc3:	mov    (%rdi),%r10
  186cc6:	shl    $0x5,%r9d
  186cca:	vmovdqa (%r10,%r9,1),%ymm3
  186cd0:	vpmultishiftqb %xmm2,%xmm0,%xmm2
  186cd6:	vpmovzxbd %xmm2,%ymm2
  186cdb:	vprolvd %ymm2,%ymm1,%ymm2
  186ce1:	xor    %r9d,%r9d
  186ce4:	vptest %ymm2,%ymm3
  186ce9:	setb   %r9b
  186ced:	mov    %r9d,0x4(%rcx,%r8,4)
  186cf2:	mov    0x10(%rdx,%r8,8),%r9
  186cf7:	vpbroadcastq %r9,%xmm2
  186cfd:	shr    $0x29,%r9
  186d01:	and    0x18(%rdi),%r9d
  186d05:	mov    (%rdi),%r10
  186d08:	shl    $0x5,%r9d
  186d0c:	vmovdqa (%r10,%r9,1),%ymm3
  186d12:	vpmultishiftqb %xmm2,%xmm0,%xmm2
  186d18:	vpmovzxbd %xmm2,%ymm2
  186d1d:	vprolvd %ymm2,%ymm1,%ymm2
  186d23:	xor    %r9d,%r9d
  186d26:	vptest %ymm2,%ymm3
  186d2b:	setb   %r9b
  186d2f:	mov    %r9d,0x8(%rcx,%r8,4)
  186d34:	mov    0x18(%rdx,%r8,8),%r9
  186d39:	vpbroadcastq %r9,%xmm2
  186d3f:	shr    $0x29,%r9
  186d43:	and    0x18(%rdi),%r9d
  186d47:	mov    (%rdi),%r10
  186d4a:	shl    $0x5,%r9d
  186d4e:	vmovdqa (%r10,%r9,1),%ymm3
  186d54:	vpmultishiftqb %xmm2,%xmm0,%xmm2
  186d5a:	vpmovzxbd %xmm2,%ymm2
  186d5f:	vprolvd %ymm2,%ymm1,%ymm2
  186d65:	xor    %r9d,%r9d
  186d68:	vptest %ymm2,%ymm3
  186d6d:	setb   %r9b
  186d71:	mov    %r9d,0xc(%rcx,%r8,4)
  186d76:	add    $0x4,%r8
  186d7a:	cmp    %r8,%rsi
  186d7d:	jne    186c70 <void inline_single_kernel<false, direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32>, unsigned long>(direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
  186d83:	test   %rax,%rax
  186d86:	je     186df8 <void inline_single_kernel<false, direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32>, unsigned long>(direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32> const&, unsigned long, unsigned long const*, unsigned int*)+0x1c8>
  186d88:	lea    (%rcx,%r8,4),%rcx
  186d8c:	lea    (%rdx,%r8,8),%rdx
  186d90:	xor    %esi,%esi
  186d92:	vpbroadcastq -0x183aa3(%rip),%xmm0        # 32f8 <_IO_stdin_used+0x44>
  186d9b:	vpbroadcastd -0x183afc(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
  186da4:	data16 data16 cs nopw 0x0(%rax,%rax,1)
  186db0:	mov    (%rdx,%rsi,8),%r8
  186db4:	vpbroadcastq %r8,%xmm2
  186dba:	shr    $0x29,%r8
  186dbe:	and    0x18(%rdi),%r8d
  186dc2:	mov    (%rdi),%r9
  186dc5:	shl    $0x5,%r8d
  186dc9:	vmovdqa (%r9,%r8,1),%ymm3
  186dcf:	vpmultishiftqb %xmm2,%xmm0,%xmm2
  186dd5:	vpmovzxbd %xmm2,%ymm2
  186dda:	vprolvd %ymm2,%ymm1,%ymm2
  186de0:	xor    %r8d,%r8d
  186de3:	vptest %ymm2,%ymm3
  186de8:	setb   %r8b
  186dec:	mov    %r8d,(%rcx,%rsi,4)
  186df0:	inc    %rsi
  186df3:	cmp    %rsi,%rax
  186df6:	jne    186db0 <void inline_single_kernel<false, direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32>, unsigned long>(direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32> const&, unsigned long, unsigned long const*, unsigned int*)+0x180>
  186df8:	vzeroupper
  186dfb:	ret
  186dfc:	int3
  186dfd:	int3
  186dfe:	int3
  186dff:	int3

