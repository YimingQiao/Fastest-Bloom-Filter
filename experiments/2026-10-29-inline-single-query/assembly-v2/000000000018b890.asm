000000000018b890 <void inline_single_kernel<false, direct_split_experiment::IndependentSplit32, unsigned long>(direct_split_experiment::IndependentSplit32 const&, unsigned long, unsigned long const*, unsigned int*)>:
  18b890:	test   %rsi,%rsi
  18b893:	je     18baa2 <void inline_single_kernel<false, direct_split_experiment::IndependentSplit32, unsigned long>(direct_split_experiment::IndependentSplit32 const&, unsigned long, unsigned long const*, unsigned int*)+0x212>
  18b899:	mov    %esi,%eax
  18b89b:	and    $0x3,%eax
  18b89e:	cmp    $0x4,%rsi
  18b8a2:	jae    18b8ac <void inline_single_kernel<false, direct_split_experiment::IndependentSplit32, unsigned long>(direct_split_experiment::IndependentSplit32 const&, unsigned long, unsigned long const*, unsigned int*)+0x1c>
  18b8a4:	xor    %r8d,%r8d
  18b8a7:	jmp    18ba1e <void inline_single_kernel<false, direct_split_experiment::IndependentSplit32, unsigned long>(direct_split_experiment::IndependentSplit32 const&, unsigned long, unsigned long const*, unsigned int*)+0x18e>
  18b8ac:	and    $0xfffffffffffffffc,%rsi
  18b8b0:	xor    %r8d,%r8d
  18b8b3:	vmovdqa -0x186d9b(%rip),%ymm0        # 4b20 <typeinfo name for main::$_60+0x350>
  18b8bb:	vpbroadcastq -0x1884b4(%rip),%ymm1        # 3410 <_IO_stdin_used+0x15c>
  18b8c4:	vpbroadcastd -0x188629(%rip),%ymm2        # 32a4 <__abi_tag+0x2fe0>
  18b8cd:	vpbroadcastd -0x18862e(%rip),%ymm3        # 32a8 <__abi_tag+0x2fe4>
  18b8d6:	cs nopw 0x0(%rax,%rax,1)
  18b8e0:	mov    (%rdx,%r8,8),%r9
  18b8e4:	mov    %r9,%r10
  18b8e7:	shr    $0x29,%r10
  18b8eb:	and    0x18(%rdi),%r10d
  18b8ef:	vpbroadcastq %r9,%ymm4
  18b8f5:	mov    (%rdi),%r9
  18b8f8:	shl    $0x5,%r10d
  18b8fc:	vmovdqa (%r9,%r10,1),%ymm5
  18b902:	vpsrlvq %ymm0,%ymm4,%ymm4
  18b907:	vpshufd $0xa0,%ymm4,%ymm4
  18b90c:	vpsrlvd %ymm1,%ymm4,%ymm4
  18b911:	vpand  %ymm2,%ymm4,%ymm4
  18b915:	vpsllvd %ymm4,%ymm3,%ymm4
  18b91a:	xor    %r9d,%r9d
  18b91d:	vptest %ymm4,%ymm5
  18b922:	setb   %r9b
  18b926:	mov    %r9d,(%rcx,%r8,4)
  18b92a:	mov    0x8(%rdx,%r8,8),%r9
  18b92f:	vpbroadcastq %r9,%ymm4
  18b935:	shr    $0x29,%r9
  18b939:	and    0x18(%rdi),%r9d
  18b93d:	mov    (%rdi),%r10
  18b940:	shl    $0x5,%r9d
  18b944:	vmovdqa (%r10,%r9,1),%ymm5
  18b94a:	vpsrlvq %ymm0,%ymm4,%ymm4
  18b94f:	vpshufd $0xa0,%ymm4,%ymm4
  18b954:	vpsrlvd %ymm1,%ymm4,%ymm4
  18b959:	vpand  %ymm2,%ymm4,%ymm4
  18b95d:	vpsllvd %ymm4,%ymm3,%ymm4
  18b962:	xor    %r9d,%r9d
  18b965:	vptest %ymm4,%ymm5
  18b96a:	setb   %r9b
  18b96e:	mov    %r9d,0x4(%rcx,%r8,4)
  18b973:	mov    0x10(%rdx,%r8,8),%r9
  18b978:	vpbroadcastq %r9,%ymm4
  18b97e:	shr    $0x29,%r9
  18b982:	and    0x18(%rdi),%r9d
  18b986:	mov    (%rdi),%r10
  18b989:	shl    $0x5,%r9d
  18b98d:	vmovdqa (%r10,%r9,1),%ymm5
  18b993:	vpsrlvq %ymm0,%ymm4,%ymm4
  18b998:	vpshufd $0xa0,%ymm4,%ymm4
  18b99d:	vpsrlvd %ymm1,%ymm4,%ymm4
  18b9a2:	vpand  %ymm2,%ymm4,%ymm4
  18b9a6:	vpsllvd %ymm4,%ymm3,%ymm4
  18b9ab:	xor    %r9d,%r9d
  18b9ae:	vptest %ymm4,%ymm5
  18b9b3:	setb   %r9b
  18b9b7:	mov    %r9d,0x8(%rcx,%r8,4)
  18b9bc:	mov    0x18(%rdx,%r8,8),%r9
  18b9c1:	mov    %r9,%r10
  18b9c4:	shr    $0x29,%r10
  18b9c8:	and    0x18(%rdi),%r10d
  18b9cc:	vpbroadcastq %r9,%ymm4
  18b9d2:	mov    (%rdi),%r9
  18b9d5:	shl    $0x5,%r10d
  18b9d9:	vmovdqa (%r9,%r10,1),%ymm5
  18b9df:	vpsrlvq %ymm0,%ymm4,%ymm4
  18b9e4:	vpshufd $0xa0,%ymm4,%ymm4
  18b9e9:	vpsrlvd %ymm1,%ymm4,%ymm4
  18b9ee:	vpand  %ymm2,%ymm4,%ymm4
  18b9f2:	vpsllvd %ymm4,%ymm3,%ymm4
  18b9f7:	xor    %r9d,%r9d
  18b9fa:	vptest %ymm4,%ymm5
  18b9ff:	setb   %r9b
  18ba03:	mov    %r9d,0xc(%rcx,%r8,4)
  18ba08:	add    $0x4,%r8
  18ba0c:	cmp    %r8,%rsi
  18ba0f:	jne    18b8e0 <void inline_single_kernel<false, direct_split_experiment::IndependentSplit32, unsigned long>(direct_split_experiment::IndependentSplit32 const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  18ba15:	test   %rax,%rax
  18ba18:	je     18baa2 <void inline_single_kernel<false, direct_split_experiment::IndependentSplit32, unsigned long>(direct_split_experiment::IndependentSplit32 const&, unsigned long, unsigned long const*, unsigned int*)+0x212>
  18ba1e:	lea    (%rcx,%r8,4),%rcx
  18ba22:	lea    (%rdx,%r8,8),%rdx
  18ba26:	xor    %esi,%esi
  18ba28:	vmovdqa -0x186f10(%rip),%ymm0        # 4b20 <typeinfo name for main::$_60+0x350>
  18ba30:	vpbroadcastq -0x188629(%rip),%ymm1        # 3410 <_IO_stdin_used+0x15c>
  18ba39:	vpbroadcastd -0x18879e(%rip),%ymm2        # 32a4 <__abi_tag+0x2fe0>
  18ba42:	vpbroadcastd -0x1887a3(%rip),%ymm3        # 32a8 <__abi_tag+0x2fe4>
  18ba4b:	nopl   0x0(%rax,%rax,1)
  18ba50:	mov    (%rdx,%rsi,8),%r8
  18ba54:	mov    %r8,%r9
  18ba57:	shr    $0x29,%r9
  18ba5b:	and    0x18(%rdi),%r9d
  18ba5f:	vpbroadcastq %r8,%ymm4
  18ba65:	mov    (%rdi),%r8
  18ba68:	shl    $0x5,%r9d
  18ba6c:	vmovdqa (%r8,%r9,1),%ymm5
  18ba72:	vpsrlvq %ymm0,%ymm4,%ymm4
  18ba77:	vpshufd $0xa0,%ymm4,%ymm4
  18ba7c:	vpsrlvd %ymm1,%ymm4,%ymm4
  18ba81:	vpand  %ymm2,%ymm4,%ymm4
  18ba85:	vpsllvd %ymm4,%ymm3,%ymm4
  18ba8a:	xor    %r8d,%r8d
  18ba8d:	vptest %ymm4,%ymm5
  18ba92:	setb   %r8b
  18ba96:	mov    %r8d,(%rcx,%rsi,4)
  18ba9a:	inc    %rsi
  18ba9d:	cmp    %rsi,%rax
  18baa0:	jne    18ba50 <void inline_single_kernel<false, direct_split_experiment::IndependentSplit32, unsigned long>(direct_split_experiment::IndependentSplit32 const&, unsigned long, unsigned long const*, unsigned int*)+0x1c0>
  18baa2:	vzeroupper
  18baa5:	ret
  18baa6:	int3
  18baa7:	int3
  18baa8:	int3
  18baa9:	int3
  18baaa:	int3
  18baab:	int3
  18baac:	int3
  18baad:	int3
  18baae:	int3
  18baaf:	int3

