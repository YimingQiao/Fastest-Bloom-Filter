0000000000185c30 <void inline_single_kernel<false, direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32>, unsigned long>(direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32> const&, unsigned long, unsigned long const*, unsigned int*)>:
  185c30:	48 85 f6             	test   %rsi,%rsi
  185c33:	0f 84 bf 01 00 00    	je     185df8 <void inline_single_kernel<false, direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32>, unsigned long>(direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32> const&, unsigned long, unsigned long const*, unsigned int*)+0x1c8>
  185c39:	89 f0                	mov    %esi,%eax
  185c3b:	83 e0 03             	and    $0x3,%eax
  185c3e:	48 83 fe 04          	cmp    $0x4,%rsi
  185c42:	73 08                	jae    185c4c <void inline_single_kernel<false, direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32>, unsigned long>(direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32> const&, unsigned long, unsigned long const*, unsigned int*)+0x1c>
  185c44:	45 31 c0             	xor    %r8d,%r8d
  185c47:	e9 3c 01 00 00       	jmp    185d88 <void inline_single_kernel<false, direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32>, unsigned long>(direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32> const&, unsigned long, unsigned long const*, unsigned int*)+0x158>
  185c4c:	48 83 e6 fc          	and    $0xfffffffffffffffc,%rsi
  185c50:	45 31 c0             	xor    %r8d,%r8d
  185c53:	c4 e2 79 59 05 9c d6 	vpbroadcastq -0x182964(%rip),%xmm0        # 32f8 <_IO_stdin_used+0x44>
  185c5a:	e7 ff
  185c5c:	c4 e2 7d 58 0d 43 d6 	vpbroadcastd -0x1829bd(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
  185c63:	e7 ff
  185c65:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  185c6c:	00 00 00 00
  185c70:	4e 8b 0c c2          	mov    (%rdx,%r8,8),%r9
  185c74:	62 d2 fd 08 7c d1    	vpbroadcastq %r9,%xmm2
  185c7a:	49 c1 e9 29          	shr    $0x29,%r9
  185c7e:	44 23 4f 18          	and    0x18(%rdi),%r9d
  185c82:	4c 8b 17             	mov    (%rdi),%r10
  185c85:	41 c1 e1 05          	shl    $0x5,%r9d
  185c89:	c4 81 7d 6f 1c 0a    	vmovdqa (%r10,%r9,1),%ymm3
  185c8f:	62 f2 fd 08 83 d2    	vpmultishiftqb %xmm2,%xmm0,%xmm2
  185c95:	c4 e2 7d 31 d2       	vpmovzxbd %xmm2,%ymm2
  185c9a:	62 f2 75 28 15 d2    	vprolvd %ymm2,%ymm1,%ymm2
  185ca0:	45 31 c9             	xor    %r9d,%r9d
  185ca3:	c4 e2 7d 17 da       	vptest %ymm2,%ymm3
  185ca8:	41 0f 92 c1          	setb   %r9b
  185cac:	46 89 0c 81          	mov    %r9d,(%rcx,%r8,4)
  185cb0:	4e 8b 4c c2 08       	mov    0x8(%rdx,%r8,8),%r9
  185cb5:	62 d2 fd 08 7c d1    	vpbroadcastq %r9,%xmm2
  185cbb:	49 c1 e9 29          	shr    $0x29,%r9
  185cbf:	44 23 4f 18          	and    0x18(%rdi),%r9d
  185cc3:	4c 8b 17             	mov    (%rdi),%r10
  185cc6:	41 c1 e1 05          	shl    $0x5,%r9d
  185cca:	c4 81 7d 6f 1c 0a    	vmovdqa (%r10,%r9,1),%ymm3
  185cd0:	62 f2 fd 08 83 d2    	vpmultishiftqb %xmm2,%xmm0,%xmm2
  185cd6:	c4 e2 7d 31 d2       	vpmovzxbd %xmm2,%ymm2
  185cdb:	62 f2 75 28 15 d2    	vprolvd %ymm2,%ymm1,%ymm2
  185ce1:	45 31 c9             	xor    %r9d,%r9d
  185ce4:	c4 e2 7d 17 da       	vptest %ymm2,%ymm3
  185ce9:	41 0f 92 c1          	setb   %r9b
  185ced:	46 89 4c 81 04       	mov    %r9d,0x4(%rcx,%r8,4)
  185cf2:	4e 8b 4c c2 10       	mov    0x10(%rdx,%r8,8),%r9
  185cf7:	62 d2 fd 08 7c d1    	vpbroadcastq %r9,%xmm2
  185cfd:	49 c1 e9 29          	shr    $0x29,%r9
  185d01:	44 23 4f 18          	and    0x18(%rdi),%r9d
  185d05:	4c 8b 17             	mov    (%rdi),%r10
  185d08:	41 c1 e1 05          	shl    $0x5,%r9d
  185d0c:	c4 81 7d 6f 1c 0a    	vmovdqa (%r10,%r9,1),%ymm3
  185d12:	62 f2 fd 08 83 d2    	vpmultishiftqb %xmm2,%xmm0,%xmm2
  185d18:	c4 e2 7d 31 d2       	vpmovzxbd %xmm2,%ymm2
  185d1d:	62 f2 75 28 15 d2    	vprolvd %ymm2,%ymm1,%ymm2
  185d23:	45 31 c9             	xor    %r9d,%r9d
  185d26:	c4 e2 7d 17 da       	vptest %ymm2,%ymm3
  185d2b:	41 0f 92 c1          	setb   %r9b
  185d2f:	46 89 4c 81 08       	mov    %r9d,0x8(%rcx,%r8,4)
  185d34:	4e 8b 4c c2 18       	mov    0x18(%rdx,%r8,8),%r9
  185d39:	62 d2 fd 08 7c d1    	vpbroadcastq %r9,%xmm2
  185d3f:	49 c1 e9 29          	shr    $0x29,%r9
  185d43:	44 23 4f 18          	and    0x18(%rdi),%r9d
  185d47:	4c 8b 17             	mov    (%rdi),%r10
  185d4a:	41 c1 e1 05          	shl    $0x5,%r9d
  185d4e:	c4 81 7d 6f 1c 0a    	vmovdqa (%r10,%r9,1),%ymm3
  185d54:	62 f2 fd 08 83 d2    	vpmultishiftqb %xmm2,%xmm0,%xmm2
  185d5a:	c4 e2 7d 31 d2       	vpmovzxbd %xmm2,%ymm2
  185d5f:	62 f2 75 28 15 d2    	vprolvd %ymm2,%ymm1,%ymm2
  185d65:	45 31 c9             	xor    %r9d,%r9d
  185d68:	c4 e2 7d 17 da       	vptest %ymm2,%ymm3
  185d6d:	41 0f 92 c1          	setb   %r9b
  185d71:	46 89 4c 81 0c       	mov    %r9d,0xc(%rcx,%r8,4)
  185d76:	49 83 c0 04          	add    $0x4,%r8
  185d7a:	4c 39 c6             	cmp    %r8,%rsi
  185d7d:	0f 85 ed fe ff ff    	jne    185c70 <void inline_single_kernel<false, direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32>, unsigned long>(direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
  185d83:	48 85 c0             	test   %rax,%rax
  185d86:	74 70                	je     185df8 <void inline_single_kernel<false, direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32>, unsigned long>(direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32> const&, unsigned long, unsigned long const*, unsigned int*)+0x1c8>
  185d88:	4a 8d 0c 81          	lea    (%rcx,%r8,4),%rcx
  185d8c:	4a 8d 14 c2          	lea    (%rdx,%r8,8),%rdx
  185d90:	31 f6                	xor    %esi,%esi
  185d92:	c4 e2 79 59 05 5d d5 	vpbroadcastq -0x182aa3(%rip),%xmm0        # 32f8 <_IO_stdin_used+0x44>
  185d99:	e7 ff
  185d9b:	c4 e2 7d 58 0d 04 d5 	vpbroadcastd -0x182afc(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
  185da2:	e7 ff
  185da4:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  185dab:	00 00 00 00 00
  185db0:	4c 8b 04 f2          	mov    (%rdx,%rsi,8),%r8
  185db4:	62 d2 fd 08 7c d0    	vpbroadcastq %r8,%xmm2
  185dba:	49 c1 e8 29          	shr    $0x29,%r8
  185dbe:	44 23 47 18          	and    0x18(%rdi),%r8d
  185dc2:	4c 8b 0f             	mov    (%rdi),%r9
  185dc5:	41 c1 e0 05          	shl    $0x5,%r8d
  185dc9:	c4 81 7d 6f 1c 01    	vmovdqa (%r9,%r8,1),%ymm3
  185dcf:	62 f2 fd 08 83 d2    	vpmultishiftqb %xmm2,%xmm0,%xmm2
  185dd5:	c4 e2 7d 31 d2       	vpmovzxbd %xmm2,%ymm2
  185dda:	62 f2 75 28 15 d2    	vprolvd %ymm2,%ymm1,%ymm2
  185de0:	45 31 c0             	xor    %r8d,%r8d
  185de3:	c4 e2 7d 17 da       	vptest %ymm2,%ymm3
  185de8:	41 0f 92 c0          	setb   %r8b
  185dec:	44 89 04 b1          	mov    %r8d,(%rcx,%rsi,4)
  185df0:	48 ff c6             	inc    %rsi
  185df3:	48 39 f0             	cmp    %rsi,%rax
  185df6:	75 b8                	jne    185db0 <void inline_single_kernel<false, direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32>, unsigned long>(direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32> const&, unsigned long, unsigned long const*, unsigned int*)+0x180>
  185df8:	c5 f8 77             	vzeroupper
  185dfb:	c3                   	ret
  185dfc:	cc                   	int3
  185dfd:	cc                   	int3
  185dfe:	cc                   	int3
  185dff:	cc                   	int3
