00000000001806a0 <void inline_single_kernel<false, independent_vbmi_experiment::IndependentVbmi32, unsigned long>(independent_vbmi_experiment::IndependentVbmi32 const&, unsigned long, unsigned long const*, unsigned int*)>:
  1806a0:	test   %rsi,%rsi
  1806a3:	je     180868 <void inline_single_kernel<false, independent_vbmi_experiment::IndependentVbmi32, unsigned long>(independent_vbmi_experiment::IndependentVbmi32 const&, unsigned long, unsigned long const*, unsigned int*)+0x1c8>
  1806a9:	mov    %esi,%eax
  1806ab:	and    $0x3,%eax
  1806ae:	cmp    $0x4,%rsi
  1806b2:	jae    1806bc <void inline_single_kernel<false, independent_vbmi_experiment::IndependentVbmi32, unsigned long>(independent_vbmi_experiment::IndependentVbmi32 const&, unsigned long, unsigned long const*, unsigned int*)+0x1c>
  1806b4:	xor    %r8d,%r8d
  1806b7:	jmp    1807f8 <void inline_single_kernel<false, independent_vbmi_experiment::IndependentVbmi32, unsigned long>(independent_vbmi_experiment::IndependentVbmi32 const&, unsigned long, unsigned long const*, unsigned int*)+0x158>
  1806bc:	and    $0xfffffffffffffffc,%rsi
  1806c0:	xor    %r8d,%r8d
  1806c3:	vpbroadcastq -0x17d3d4(%rip),%xmm0        # 32f8 <_IO_stdin_used+0x44>
  1806cc:	vpbroadcastd -0x17d42d(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
  1806d5:	data16 cs nopw 0x0(%rax,%rax,1)
  1806e0:	mov    (%rdx,%r8,8),%r9
  1806e4:	vpbroadcastq %r9,%xmm2
  1806ea:	shr    $0x29,%r9
  1806ee:	and    0x18(%rdi),%r9d
  1806f2:	mov    (%rdi),%r10
  1806f5:	shl    $0x5,%r9d
  1806f9:	vmovdqa (%r10,%r9,1),%ymm3
  1806ff:	vpmultishiftqb %xmm2,%xmm0,%xmm2
  180705:	vpmovzxbd %xmm2,%ymm2
  18070a:	vprolvd %ymm2,%ymm1,%ymm2
  180710:	xor    %r9d,%r9d
  180713:	vptest %ymm2,%ymm3
  180718:	setb   %r9b
  18071c:	mov    %r9d,(%rcx,%r8,4)
  180720:	mov    0x8(%rdx,%r8,8),%r9
  180725:	vpbroadcastq %r9,%xmm2
  18072b:	shr    $0x29,%r9
  18072f:	and    0x18(%rdi),%r9d
  180733:	mov    (%rdi),%r10
  180736:	shl    $0x5,%r9d
  18073a:	vmovdqa (%r10,%r9,1),%ymm3
  180740:	vpmultishiftqb %xmm2,%xmm0,%xmm2
  180746:	vpmovzxbd %xmm2,%ymm2
  18074b:	vprolvd %ymm2,%ymm1,%ymm2
  180751:	xor    %r9d,%r9d
  180754:	vptest %ymm2,%ymm3
  180759:	setb   %r9b
  18075d:	mov    %r9d,0x4(%rcx,%r8,4)
  180762:	mov    0x10(%rdx,%r8,8),%r9
  180767:	vpbroadcastq %r9,%xmm2
  18076d:	shr    $0x29,%r9
  180771:	and    0x18(%rdi),%r9d
  180775:	mov    (%rdi),%r10
  180778:	shl    $0x5,%r9d
  18077c:	vmovdqa (%r10,%r9,1),%ymm3
  180782:	vpmultishiftqb %xmm2,%xmm0,%xmm2
  180788:	vpmovzxbd %xmm2,%ymm2
  18078d:	vprolvd %ymm2,%ymm1,%ymm2
  180793:	xor    %r9d,%r9d
  180796:	vptest %ymm2,%ymm3
  18079b:	setb   %r9b
  18079f:	mov    %r9d,0x8(%rcx,%r8,4)
  1807a4:	mov    0x18(%rdx,%r8,8),%r9
  1807a9:	vpbroadcastq %r9,%xmm2
  1807af:	shr    $0x29,%r9
  1807b3:	and    0x18(%rdi),%r9d
  1807b7:	mov    (%rdi),%r10
  1807ba:	shl    $0x5,%r9d
  1807be:	vmovdqa (%r10,%r9,1),%ymm3
  1807c4:	vpmultishiftqb %xmm2,%xmm0,%xmm2
  1807ca:	vpmovzxbd %xmm2,%ymm2
  1807cf:	vprolvd %ymm2,%ymm1,%ymm2
  1807d5:	xor    %r9d,%r9d
  1807d8:	vptest %ymm2,%ymm3
  1807dd:	setb   %r9b
  1807e1:	mov    %r9d,0xc(%rcx,%r8,4)
  1807e6:	add    $0x4,%r8
  1807ea:	cmp    %r8,%rsi
  1807ed:	jne    1806e0 <void inline_single_kernel<false, independent_vbmi_experiment::IndependentVbmi32, unsigned long>(independent_vbmi_experiment::IndependentVbmi32 const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
  1807f3:	test   %rax,%rax
  1807f6:	je     180868 <void inline_single_kernel<false, independent_vbmi_experiment::IndependentVbmi32, unsigned long>(independent_vbmi_experiment::IndependentVbmi32 const&, unsigned long, unsigned long const*, unsigned int*)+0x1c8>
  1807f8:	lea    (%rcx,%r8,4),%rcx
  1807fc:	lea    (%rdx,%r8,8),%rdx
  180800:	xor    %esi,%esi
  180802:	vpbroadcastq -0x17d513(%rip),%xmm0        # 32f8 <_IO_stdin_used+0x44>
  18080b:	vpbroadcastd -0x17d56c(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
  180814:	data16 data16 cs nopw 0x0(%rax,%rax,1)
  180820:	mov    (%rdx,%rsi,8),%r8
  180824:	vpbroadcastq %r8,%xmm2
  18082a:	shr    $0x29,%r8
  18082e:	and    0x18(%rdi),%r8d
  180832:	mov    (%rdi),%r9
  180835:	shl    $0x5,%r8d
  180839:	vmovdqa (%r9,%r8,1),%ymm3
  18083f:	vpmultishiftqb %xmm2,%xmm0,%xmm2
  180845:	vpmovzxbd %xmm2,%ymm2
  18084a:	vprolvd %ymm2,%ymm1,%ymm2
  180850:	xor    %r8d,%r8d
  180853:	vptest %ymm2,%ymm3
  180858:	setb   %r8b
  18085c:	mov    %r8d,(%rcx,%rsi,4)
  180860:	inc    %rsi
  180863:	cmp    %rsi,%rax
  180866:	jne    180820 <void inline_single_kernel<false, independent_vbmi_experiment::IndependentVbmi32, unsigned long>(independent_vbmi_experiment::IndependentVbmi32 const&, unsigned long, unsigned long const*, unsigned int*)+0x180>
  180868:	vzeroupper
  18086b:	ret
  18086c:	int3
  18086d:	int3
  18086e:	int3
  18086f:	int3

