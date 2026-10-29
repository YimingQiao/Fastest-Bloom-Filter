   18476:	add    $0x8,%r8
   1847a:	cmp    %r8,%r9
   1847d:	jne    18470 <_Z3RunIN13bloom_filters20ByteSplitBloomFilterEEvRK5PointRK4CaseRK5Input+0x1970>
   1847f:	cmp    %r9,%rdi
   18482:	je     1849f <_Z3RunIN13bloom_filters20ByteSplitBloomFilterEEvRK5PointRK4CaseRK5Input+0x199f>
   18484:	lea    0x40(%rcx,%rax,4),%rax
   18489:	nopl   0x0(%rax)
   18490:	movl   $0x2,(%rsi)
   18496:	add    $0x4,%rsi
   1849a:	cmp    %rax,%rsi
   1849d:	jne    18490 <_Z3RunIN13bloom_filters20ByteSplitBloomFilterEEvRK5PointRK4CaseRK5Input+0x1990>
   1849f:	vzeroupper
   184a2:	call   2eab0 <_ZNSt6chrono3_V212steady_clock3nowEv@plt>
   184a7:	mov    %rax,0xc0(%rsp)
   184af:	mov    %r13,%r12
   184b2:	cmp    $0x3,%r13d
   184b6:	ja     18900 <_Z3RunIN13bloom_filters20ByteSplitBloomFilterEEvRK5PointRK4CaseRK5Input+0x1e00>
   184bc:	mov    %r12d,%eax
   184bf:	lea    -0x16976(%rip),%rcx        # 1b50 <_IO_stdin_used+0x470>
   184c6:	movslq (%rcx,%rax,4),%rax
   184ca:	add    %rcx,%rax
   184cd:	jmp    *%rax
   184cf:	mov    0x58(%rsp),%rax
   184d4:	cmp    %rax,0x60(%rsp)
   184d9:	mov    0x90(%rsp),%rbp
   184e1:	je     18900 <_Z3RunIN13bloom_filters20ByteSplitBloomFilterEEvRK5PointRK4CaseRK5Input+0x1e00>
   184e7:	mov    0x8(%rsp),%rax
   184ec:	mov    0xc(%rax),%eax
   184ef:	xor    %r13d,%r13d
   184f2:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   18500:	mov    %eax,%eax
   18502:	mov    %rbp,%rsi
   18505:	sub    %r13,%rsi
   18508:	cmp    %rax,%rsi
   1850b:	cmovae %rax,%rsi
   1850f:	lea    0x0(,%r13,8),%rdx
   18517:	mov    0x10(%rsp),%rax
   1851c:	add    0x48(%rax),%rdx
   18520:	mov    0x30(%rsp),%rax
   18525:	lea    0x40(%rax,%r13,4),%rcx
   1852a:	mov    %rbx,%rdi
   1852d:	call   2b4b0 <_Z13lookup_kernelIN13bloom_filters20ByteSplitBloomFilterEmEvRT_mPKT0_Pj>
   18532:	mov    0x8(%rsp),%rax
   18537:	mov    0xc(%rax),%eax
   1853a:	add    %rax,%r13
   1853d:	cmp    %rbp,%r13
   18540:	jb     18500 <_Z3RunIN13bloom_filters20ByteSplitBloomFilterEEvRK5PointRK4CaseRK5Input+0x1a00>
   18542:	jmp    18900 <_Z3RunIN13bloom_filters20ByteSplitBloomFilterEEvRK5PointRK4CaseRK5Input+0x1e00>
   18547:	mov    0x10(%rsp),%rax
   1854c:	mov    0x48(%rax),%rdx
   18550:	mov    0x30(%rsp),%rcx
   18555:	add    $0x40,%rcx
   18559:	mov    %rbx,%rdi
   1855c:	mov    0x90(%rsp),%rsi
   18564:	call   2b6a0 <_Z20inline_single_kernelILb0EN13bloom_filters20ByteSplitBloomFilterEmEvRKT0_mPKmPj>
   18569:	jmp    18900 <_Z3RunIN13bloom_filters20ByteSplitBloomFilterEEvRK5PointRK4CaseRK5Input+0x1e00>
   1856e:	mov    0x10(%rsp),%rax
   18573:	mov    0x18(%rax),%rdx
   18577:	mov    0x30(%rsp),%rcx
   1857c:	add    $0x40,%rcx
   18580:	mov    %rbx,%rdi
   18583:	mov    0x90(%rsp),%rsi
   1858b:	call   2b850 <_Z20inline_single_kernelILb1EN13bloom_filters20ByteSplitBloomFilterEmEvRKT0_mPKmPj>
   18590:	jmp    18900 <_Z3RunIN13bloom_filters20ByteSplitBloomFilterEEvRK5PointRK4CaseRK5Input+0x1e00>
   18595:	mov    0x58(%rsp),%rax
   1859a:	cmp    %rax,0x60(%rsp)
   1859f:	mov    0x90(%rsp),%rsi
   185a7:	je     18900 <_Z3RunIN13bloom_filters20ByteSplitBloomFilterEEvRK5PointRK4CaseRK5Input+0x1e00>
   185ad:	mov    0x8(%rsp),%rax
   185b2:	mov    0xc(%rax),%eax
   185b5:	xor    %ebp,%ebp
   185b7:	nopw   0x0(%rax,%rax,1)
   185c0:	mov    %eax,%eax
   185c2:	sub    %rbp,%rsi
   185c5:	cmp    %rax,%rsi
   185c8:	cmovae %rax,%rsi
   185cc:	test   %rsi,%rsi
   185cf:	je     1872b <_Z3RunIN13bloom_filters20ByteSplitBloomFilterEEvRK5PointRK4CaseRK5Input+0x1c2b>
   185d5:	mov    0x10(%rsp),%rax
   185da:	mov    0x18(%rax),%rax
   185de:	lea    (%rax,%rbp,8),%rcx
   185e2:	cmp    $0x4,%rsi
   185e6:	jb     185fb <_Z3RunIN13bloom_filters20ByteSplitBloomFilterEEvRK5PointRK4CaseRK5Input+0x1afb>
   185e8:	mov    %r14,%rdx
   185eb:	sub    %rcx,%rdx
   185ee:	cmp    $0x80,%rdx
   185f5:	jae    18764 <_Z3RunIN13bloom_filters20ByteSplitBloomFilterEEvRK5PointRK4CaseRK5Input+0x1c64>
   185fb:	xor    %edx,%edx
   185fd:	mov    %rsi,%r8
   18600:	mov    %rdx,%rdi
   18603:	and    $0x3,%r8
   18607:	je     18646 <_Z3RunIN13bloom_filters20ByteSplitBloomFilterEEvRK5PointRK4CaseRK5Input+0x1b46>
   18609:	mov    %rdx,%rdi
   1860c:	nopl   0x0(%rax)
   18610:	mov    (%rcx,%rdi,8),%r9
   18614:	mov    %r9,%r10
   18617:	shr    $0x20,%r10
   1861b:	xor    %r9,%r10
   1861e:	imul   %r15,%r10
   18622:	mov    %r10,%r9
   18625:	shr    $0x20,%r9
   18629:	xor    %r10,%r9
   1862c:	imul   %r15,%r9
   18630:	mov    %r9,%r10
   18633:	shr    $0x20,%r10
   18637:	xor    %r9,%r10
   1863a:	mov    %r10,(%r14,%rdi,8)
   1863e:	inc    %rdi
   18641:	dec    %r8
   18644:	jne    18610 <_Z3RunIN13bloom_filters20ByteSplitBloomFilterEEvRK5PointRK4CaseRK5Input+0x1b10>
   18646:	sub    %rsi,%rdx
   18649:	cmp    $0xfffffffffffffffc,%rdx
   1864d:	ja     1872b <_Z3RunIN13bloom_filters20ByteSplitBloomFilterEEvRK5PointRK4CaseRK5Input+0x1c2b>
   18653:	lea    0x18(%rax,%rbp,8),%rax
   18658:	nopl   0x0(%rax,%rax,1)
   18660:	mov    -0x18(%rax,%rdi,8),%rcx
   18665:	mov    %rcx,%rdx
   18668:	shr    $0x20,%rdx
   1866c:	xor    %rcx,%rdx
   1866f:	imul   %r15,%rdx
   18673:	mov    %rdx,%rcx
   18676:	shr    $0x20,%rcx
   1867a:	xor    %rdx,%rcx
   1867d:	imul   %r15,%rcx
   18681:	mov    %rcx,%rdx
   18684:	shr    $0x20,%rdx
   18688:	xor    %rcx,%rdx
   1868b:	mov    %rdx,(%r14,%rdi,8)
   1868f:	mov    -0x10(%rax,%rdi,8),%rcx
   18694:	mov    %rcx,%rdx
   18697:	shr    $0x20,%rdx
   1869b:	xor    %rcx,%rdx
   1869e:	imul   %r15,%rdx
   186a2:	mov    %rdx,%rcx
   186a5:	shr    $0x20,%rcx
   186a9:	xor    %rdx,%rcx
   186ac:	imul   %r15,%rcx
   186b0:	mov    %rcx,%rdx
   186b3:	shr    $0x20,%rdx
   186b7:	xor    %rcx,%rdx
   186ba:	mov    %rdx,0x8(%r14,%rdi,8)
   186bf:	mov    -0x8(%rax,%rdi,8),%rcx
   186c4:	mov    %rcx,%rdx
   186c7:	shr    $0x20,%rdx
   186cb:	xor    %rcx,%rdx
   186ce:	imul   %r15,%rdx
   186d2:	mov    %rdx,%rcx
   186d5:	shr    $0x20,%rcx
   186d9:	xor    %rdx,%rcx
   186dc:	imul   %r15,%rcx
   186e0:	mov    %rcx,%rdx
   186e3:	shr    $0x20,%rdx
   186e7:	xor    %rcx,%rdx
   186ea:	mov    %rdx,0x10(%r14,%rdi,8)
   186ef:	mov    (%rax,%rdi,8),%rcx
   186f3:	mov    %rcx,%rdx
   186f6:	shr    $0x20,%rdx
   186fa:	xor    %rcx,%rdx
   186fd:	imul   %r15,%rdx
   18701:	mov    %rdx,%rcx
   18704:	shr    $0x20,%rcx
   18708:	xor    %rdx,%rcx
   1870b:	imul   %r15,%rcx
   1870f:	mov    %rcx,%rdx
   18712:	shr    $0x20,%rdx
   18716:	xor    %rcx,%rdx
   18719:	mov    %rdx,0x18(%r14,%rdi,8)
   1871e:	add    $0x4,%rdi
   18722:	cmp    %rdi,%rsi
   18725:	jne    18660 <_Z3RunIN13bloom_filters20ByteSplitBloomFilterEEvRK5PointRK4CaseRK5Input+0x1b60>
   1872b:	mov    0x30(%rsp),%rax
   18730:	lea    0x40(%rax,%rbp,4),%rcx
   18735:	mov    %rbx,%rdi
   18738:	mov    %r14,%rdx
   1873b:	vzeroupper
   1873e:	call   2b4b0 <_Z13lookup_kernelIN13bloom_filters20ByteSplitBloomFilterEmEvRT_mPKT0_Pj>
   18743:	mov    0x8(%rsp),%rax
   18748:	mov    0xc(%rax),%eax
   1874b:	add    %rax,%rbp
   1874e:	mov    0x90(%rsp),%rsi
   18756:	cmp    %rsi,%rbp
   18759:	jb     185c0 <_Z3RunIN13bloom_filters20ByteSplitBloomFilterEEvRK5PointRK4CaseRK5Input+0x1ac0>
   1875f:	jmp    18900 <_Z3RunIN13bloom_filters20ByteSplitBloomFilterEEvRK5PointRK4CaseRK5Input+0x1e00>
   18764:	cmp    $0x10,%rsi
   18768:	jae    18771 <_Z3RunIN13bloom_filters20ByteSplitBloomFilterEEvRK5PointRK4CaseRK5Input+0x1c71>
   1876a:	xor    %edx,%edx
   1876c:	jmp    18892 <_Z3RunIN13bloom_filters20ByteSplitBloomFilterEEvRK5PointRK4CaseRK5Input+0x1d92>
   18771:	lea    0x0(,%rbp,8),%r8
   18779:	mov    %esi,%edx
   1877b:	and    $0xfffffff0,%edx
   1877e:	lea    0x0(,%rsi,8),%rdi
   18786:	and    $0xffffffffffffff80,%rdi
   1878a:	lea    0x60(%rax,%r8,1),%r8
   1878f:	xor    %r9d,%r9d
   18792:	vpbroadcastq -0x16dcb(%rip),%ymm8        # 19d0 <_IO_stdin_used+0x2f0>
   1879b:	nopl   0x0(%rax,%rax,1)
   187a0:	vmovdqu -0x60(%r8,%r9,1),%ymm0
   187a7:	vmovdqu -0x40(%r8,%r9,1),%ymm1
   187ae:	vmovdqu -0x20(%r8,%r9,1),%ymm2
   187b5:	vmovdqu (%r8,%r9,1),%ymm3
   187bb:	vpsrlq $0x20,%ymm0,%ymm4
   187c0:	vpsrlq $0x20,%ymm1,%ymm5
   187c5:	vpsrlq $0x20,%ymm2,%ymm6
   187ca:	vpsrlq $0x20,%ymm3,%ymm7
   187cf:	vpxor  %ymm0,%ymm4,%ymm0
   187d3:	vpxor  %ymm1,%ymm5,%ymm1
   187d7:	vpxor  %ymm2,%ymm6,%ymm2
   187db:	vpmullq %ymm8,%ymm0,%ymm0
   187e1:	vpmullq %ymm8,%ymm1,%ymm1
   187e7:	vpmullq %ymm8,%ymm2,%ymm2
   187ed:	vpxor  %ymm3,%ymm7,%ymm3
   187f1:	vpmullq %ymm8,%ymm3,%ymm3
   187f7:	vpsrlq $0x20,%ymm0,%ymm4
   187fc:	vpsrlq $0x20,%ymm1,%ymm5
   18801:	vpsrlq $0x20,%ymm2,%ymm6
   18806:	vpsrlq $0x20,%ymm3,%ymm7
   1880b:	vpxor  %ymm0,%ymm4,%ymm0
   1880f:	vpxor  %ymm1,%ymm5,%ymm1
   18813:	vpxor  %ymm2,%ymm6,%ymm2
   18817:	vpxor  %ymm3,%ymm7,%ymm3
   1881b:	vpmullq %ymm8,%ymm0,%ymm0
   18821:	vpmullq %ymm8,%ymm1,%ymm1
   18827:	vpmullq %ymm8,%ymm2,%ymm2
   1882d:	vpmullq %ymm8,%ymm3,%ymm3
   18833:	vpsrlq $0x20,%ymm0,%ymm4
   18838:	vpsrlq $0x20,%ymm1,%ymm5
   1883d:	vpsrlq $0x20,%ymm2,%ymm6
   18842:	vpsrlq $0x20,%ymm3,%ymm7
   18847:	vpxor  %ymm0,%ymm4,%ymm0
   1884b:	vpxor  %ymm1,%ymm5,%ymm1
   1884f:	vpxor  %ymm2,%ymm6,%ymm2
   18853:	vpxor  %ymm3,%ymm7,%ymm3
   18857:	vmovdqu %ymm0,(%r14,%r9,1)
   1885d:	vmovdqu %ymm1,0x20(%r14,%r9,1)
   18864:	vmovdqu %ymm2,0x40(%r14,%r9,1)
   1886b:	vmovdqu %ymm3,0x60(%r14,%r9,1)
   18872:	sub    $0xffffffffffffff80,%r9
   18876:	cmp    %r9,%rdi
   18879:	jne    187a0 <_Z3RunIN13bloom_filters20ByteSplitBloomFilterEEvRK5PointRK4CaseRK5Input+0x1ca0>
   1887f:	cmp    %rdx,%rsi
   18882:	je     1872b <_Z3RunIN13bloom_filters20ByteSplitBloomFilterEEvRK5PointRK4CaseRK5Input+0x1c2b>
   18888:	test   $0xc,%sil
   1888c:	je     185fd <_Z3RunIN13bloom_filters20ByteSplitBloomFilterEEvRK5PointRK4CaseRK5Input+0x1afd>
   18892:	mov    %rdx,%rdi
   18895:	mov    %esi,%edx
   18897:	and    $0xfffffffc,%edx
   1889a:	vpbroadcastq -0x16ed3(%rip),%ymm2        # 19d0 <_IO_stdin_used+0x2f0>
   188a3:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   188b0:	vmovdqu (%rcx,%rdi,8),%ymm0
   188b5:	vpsrlq $0x20,%ymm0,%ymm1
   188ba:	vpxor  %ymm0,%ymm1,%ymm0
   188be:	vpmullq %ymm2,%ymm0,%ymm0
   188c4:	vpsrlq $0x20,%ymm0,%ymm1
   188c9:	vpxor  %ymm0,%ymm1,%ymm0
   188cd:	vpmullq %ymm2,%ymm0,%ymm0
   188d3:	vpsrlq $0x20,%ymm0,%ymm1
   188d8:	vpxor  %ymm0,%ymm1,%ymm0
   188dc:	vmovdqu %ymm0,(%r14,%rdi,8)
   188e2:	add    $0x4,%rdi
   188e6:	cmp    %rdi,%rdx
   188e9:	jne    188b0 <_Z3RunIN13bloom_filters20ByteSplitBloomFilterEEvRK5PointRK4CaseRK5Input+0x1db0>
   188eb:	cmp    %rdx,%rsi
   188ee:	je     1872b <_Z3RunIN13bloom_filters20ByteSplitBloomFilterEEvRK5PointRK4CaseRK5Input+0x1c2b>
   188f4:	jmp    185fd <_Z3RunIN13bloom_filters20ByteSplitBloomFilterEEvRK5PointRK4CaseRK5Input+0x1afd>
   188f9:	nopl   0x0(%rax)
   18900:	call   2eab0 <_ZNSt6chrono3_V212steady_clock3nowEv@plt>
   18905:	sub    0xc0(%rsp),%rax
   1890d:	vcvtsi2sd %rax,%xmm15,%xmm0
   18912:	vdivsd 0x148(%rsp),%xmm0,%xmm0
   1891b:	vmovq  %xmm0,%rax
   18920:	mov    $0x3f,%cl
   18922:	bzhi   %rcx,%rax,%rcx
   18927:	movabs $0xfff0000000000000,%rdx
   18931:	add    %rdx,%rcx
   18934:	shr    $0x35,%rcx
   18938:	cmp    $0x3ff,%ecx
   1893e:	setb   %cl
   18941:	test   %rax,%rax
   18944:	setns  %dl
   18947:	and    %cl,%dl
   18949:	dec    %rax
   1894c:	movabs $0xfffffffffffff,%rcx
   18956:	cmp    %rcx,%rax
   18959:	setb   %al
   1895c:	or     %dl,%al
   1895e:	je     19779 <_Z3RunIN13bloom_filters20ByteSplitBloomFilterEEvRK5PointRK4CaseRK5Input+0x2c79>
   18964:	lea    (%r12,%r12,2),%rax
   18968:	lea    0x160(%rsp,%rax,8),%rcx
   18970:	mov    0x168(%rsp,%rax,8),%r12
   18978:	cmp    0x170(%rsp,%rax,8),%r12
   18980:	je     189a0 <_Z3RunIN13bloom_filters20ByteSplitBloomFilterEEvRK5PointRK4CaseRK5Input+0x1ea0>
   18982:	vmovsd %xmm0,(%r12)
   18988:	add    $0x8,%r12
   1898c:	mov    %r12,0x8(%rcx)
   18990:	jmp    18a58 <_Z3RunIN13bloom_filters20ByteSplitBloomFilterEEvRK5PointRK4CaseRK5Input+0x1f58>
   18995:	data16 cs nopw 0x0(%rax,%rax,1)
   189a0:	mov    (%rcx),%r13
   189a3:	sub    %r13,%r12
   189a6:	movabs $0x7ffffffffffffff8,%rax
   189b0:	cmp    %rax,%r12
   189b3:	je     197bf <_Z3RunIN13bloom_filters20ByteSplitBloomFilterEEvRK5PointRK4CaseRK5Input+0x2cbf>
   189b9:	mov    %rcx,0x138(%rsp)
   189c1:	vmovsd %xmm0,0xc0(%rsp)
   189ca:	mov    %r12,%rax
   189cd:	sar    $0x3,%rax
   189d1:	cmp    $0x1,%rax
   189d5:	mov    %rax,%rcx
   189d8:	adc    $0x0,%rcx
   189dc:	lea    (%rcx,%rax,1),%rbp
   189e0:	movabs $0xfffffffffffffff,%rdx
   189ea:	cmp    %rdx,%rbp
   189ed:	cmovae %rdx,%rbp
   189f1:	add    %rax,%rcx
   189f4:	cmovb  %rdx,%rbp
   189f8:	lea    0x0(,%rbp,8),%rdi
   18a00:	call   2ea50 <_Znwm@plt>
   18a05:	mov    %rax,%rbx
   18a08:	vmovsd 0xc0(%rsp),%xmm0
   18a11:	vmovsd %xmm0,(%rax,%r12,1)
   18a17:	test   %r12,%r12
   18a1a:	jle    18a2a <_Z3RunIN13bloom_filters20ByteSplitBloomFilterEEvRK5PointRK4CaseRK5Input+0x1f2a>
   18a1c:	mov    %rbx,%rdi
   18a1f:	mov    %r13,%rsi
   18a22:	mov    %r12,%rdx
   18a25:	call   2ea70 <memmove@plt>
   18a2a:	test   %r13,%r13
   18a2d:	je     18a3a <_Z3RunIN13bloom_filters20ByteSplitBloomFilterEEvRK5PointRK4CaseRK5Input+0x1f3a>
   18a2f:	mov    %r13,%rdi
   18a32:	mov    %r12,%rsi
   18a35:	call   2ea60 <_ZdlPvm@plt>
   18a3a:	add    %rbx,%r12
   18a3d:	mov    0x138(%rsp),%rcx
   18a45:	mov    %rbx,(%rcx)
   18a48:	add    $0x8,%r12
   18a4c:	mov    %r12,0x8(%rcx)
   18a50:	lea    (%rbx,%rbp,8),%rax
   18a54:	mov    %rax,0x10(%rcx)
   18a58:	lea    0x30(%rsp),%rdi
   18a5d:	lea    0xa0(%rsp),%rsi
   18a65:	call   26830 <_ZN6Output5CheckERKSt6vectorIjSaIjEE>
   18a6a:	mov    0x20(%rsp),%rax
   18a6f:	add    $0x4,%rax
