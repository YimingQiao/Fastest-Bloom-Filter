00000000001812a0 <void inline_single_kernel<false, independent_vbmi_experiment::IndependentVbmi32, unsigned long>(independent_vbmi_experiment::IndependentVbmi32 const&, unsigned long, unsigned long const*, unsigned int*)>:
  1812a0:	test   %rsi,%rsi
  1812a3:	je     181468 <void inline_single_kernel<false, independent_vbmi_experiment::IndependentVbmi32, unsigned long>(independent_vbmi_experiment::IndependentVbmi32 const&, unsigned long, unsigned long const*, unsigned int*)+0x1c8>
  1812a9:	mov    %esi,%eax
  1812ab:	and    $0x3,%eax
  1812ae:	cmp    $0x4,%rsi
  1812b2:	jae    1812bc <void inline_single_kernel<false, independent_vbmi_experiment::IndependentVbmi32, unsigned long>(independent_vbmi_experiment::IndependentVbmi32 const&, unsigned long, unsigned long const*, unsigned int*)+0x1c>
  1812b4:	xor    %r8d,%r8d
  1812b7:	jmp    1813f8 <void inline_single_kernel<false, independent_vbmi_experiment::IndependentVbmi32, unsigned long>(independent_vbmi_experiment::IndependentVbmi32 const&, unsigned long, unsigned long const*, unsigned int*)+0x158>
  1812bc:	and    $0xfffffffffffffffc,%rsi
  1812c0:	xor    %r8d,%r8d
  1812c3:	vpbroadcastq -0x17dfd4(%rip),%xmm0        # 32f8 <_IO_stdin_used+0x44>
  1812cc:	vpbroadcastd -0x17e02d(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
  1812d5:	data16 cs nopw 0x0(%rax,%rax,1)
  1812e0:	mov    (%rdx,%r8,8),%r9
  1812e4:	vpbroadcastq %r9,%xmm2
  1812ea:	shr    $0x29,%r9
  1812ee:	and    0x18(%rdi),%r9d
  1812f2:	mov    (%rdi),%r10
  1812f5:	shl    $0x5,%r9d
  1812f9:	vmovdqa (%r10,%r9,1),%ymm3
  1812ff:	vpmultishiftqb %xmm2,%xmm0,%xmm2
  181305:	vpmovzxbd %xmm2,%ymm2
  18130a:	vprolvd %ymm2,%ymm1,%ymm2
  181310:	xor    %r9d,%r9d
  181313:	vptest %ymm2,%ymm3
  181318:	setb   %r9b
  18131c:	mov    %r9d,(%rcx,%r8,4)
  181320:	mov    0x8(%rdx,%r8,8),%r9
  181325:	vpbroadcastq %r9,%xmm2
  18132b:	shr    $0x29,%r9
  18132f:	and    0x18(%rdi),%r9d
  181333:	mov    (%rdi),%r10
  181336:	shl    $0x5,%r9d
  18133a:	vmovdqa (%r10,%r9,1),%ymm3
  181340:	vpmultishiftqb %xmm2,%xmm0,%xmm2
  181346:	vpmovzxbd %xmm2,%ymm2
  18134b:	vprolvd %ymm2,%ymm1,%ymm2
  181351:	xor    %r9d,%r9d
  181354:	vptest %ymm2,%ymm3
  181359:	setb   %r9b
  18135d:	mov    %r9d,0x4(%rcx,%r8,4)
  181362:	mov    0x10(%rdx,%r8,8),%r9
  181367:	vpbroadcastq %r9,%xmm2
  18136d:	shr    $0x29,%r9
  181371:	and    0x18(%rdi),%r9d
  181375:	mov    (%rdi),%r10
  181378:	shl    $0x5,%r9d
  18137c:	vmovdqa (%r10,%r9,1),%ymm3
  181382:	vpmultishiftqb %xmm2,%xmm0,%xmm2
  181388:	vpmovzxbd %xmm2,%ymm2
  18138d:	vprolvd %ymm2,%ymm1,%ymm2
  181393:	xor    %r9d,%r9d
  181396:	vptest %ymm2,%ymm3
  18139b:	setb   %r9b
  18139f:	mov    %r9d,0x8(%rcx,%r8,4)
  1813a4:	mov    0x18(%rdx,%r8,8),%r9
  1813a9:	vpbroadcastq %r9,%xmm2
  1813af:	shr    $0x29,%r9
  1813b3:	and    0x18(%rdi),%r9d
  1813b7:	mov    (%rdi),%r10
  1813ba:	shl    $0x5,%r9d
  1813be:	vmovdqa (%r10,%r9,1),%ymm3
  1813c4:	vpmultishiftqb %xmm2,%xmm0,%xmm2
  1813ca:	vpmovzxbd %xmm2,%ymm2
  1813cf:	vprolvd %ymm2,%ymm1,%ymm2
  1813d5:	xor    %r9d,%r9d
  1813d8:	vptest %ymm2,%ymm3
  1813dd:	setb   %r9b
  1813e1:	mov    %r9d,0xc(%rcx,%r8,4)
  1813e6:	add    $0x4,%r8
  1813ea:	cmp    %r8,%rsi
  1813ed:	jne    1812e0 <void inline_single_kernel<false, independent_vbmi_experiment::IndependentVbmi32, unsigned long>(independent_vbmi_experiment::IndependentVbmi32 const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
  1813f3:	test   %rax,%rax
  1813f6:	je     181468 <void inline_single_kernel<false, independent_vbmi_experiment::IndependentVbmi32, unsigned long>(independent_vbmi_experiment::IndependentVbmi32 const&, unsigned long, unsigned long const*, unsigned int*)+0x1c8>
  1813f8:	lea    (%rcx,%r8,4),%rcx
  1813fc:	lea    (%rdx,%r8,8),%rdx
  181400:	xor    %esi,%esi
  181402:	vpbroadcastq -0x17e113(%rip),%xmm0        # 32f8 <_IO_stdin_used+0x44>
  18140b:	vpbroadcastd -0x17e16c(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
  181414:	data16 data16 cs nopw 0x0(%rax,%rax,1)
  181420:	mov    (%rdx,%rsi,8),%r8
  181424:	vpbroadcastq %r8,%xmm2
  18142a:	shr    $0x29,%r8
  18142e:	and    0x18(%rdi),%r8d
  181432:	mov    (%rdi),%r9
  181435:	shl    $0x5,%r8d
  181439:	vmovdqa (%r9,%r8,1),%ymm3
  18143f:	vpmultishiftqb %xmm2,%xmm0,%xmm2
  181445:	vpmovzxbd %xmm2,%ymm2
  18144a:	vprolvd %ymm2,%ymm1,%ymm2
  181450:	xor    %r8d,%r8d
  181453:	vptest %ymm2,%ymm3
  181458:	setb   %r8b
  18145c:	mov    %r8d,(%rcx,%rsi,4)
  181460:	inc    %rsi
  181463:	cmp    %rsi,%rax
  181466:	jne    181420 <void inline_single_kernel<false, independent_vbmi_experiment::IndependentVbmi32, unsigned long>(independent_vbmi_experiment::IndependentVbmi32 const&, unsigned long, unsigned long const*, unsigned int*)+0x180>
  181468:	vzeroupper
  18146b:	ret
  18146c:	int3
  18146d:	int3
  18146e:	int3
  18146f:	int3

