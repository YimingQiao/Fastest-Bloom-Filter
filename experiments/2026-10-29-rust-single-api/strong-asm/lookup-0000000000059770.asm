0000000000059770 <compare_benchmark::lookup>:
   59770:	55                   	push   %rbp
   59771:	41 57                	push   %r15
   59773:	41 56                	push   %r14
   59775:	41 55                	push   %r13
   59777:	41 54                	push   %r12
   59779:	53                   	push   %rbx
   5977a:	48 83 ec 48          	sub    $0x48,%rsp
   5977e:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
   59783:	4c 89 44 24 10       	mov    %r8,0x10(%rsp)
   59788:	4c 39 c2             	cmp    %r8,%rdx
   5978b:	0f 85 8d 01 00 00    	jne    5991e <compare_benchmark::lookup+0x1ae>
   59791:	48 89 cb             	mov    %rcx,%rbx
   59794:	49 89 d7             	mov    %rdx,%r15
   59797:	49 89 f6             	mov    %rsi,%r14
   5979a:	49 89 fc             	mov    %rdi,%r12
   5979d:	48 83 fa 01          	cmp    $0x1,%rdx
   597a1:	75 52                	jne    597f5 <compare_benchmark::lookup+0x85>
   597a3:	49 8b 36             	mov    (%r14),%rsi
   597a6:	41 80 7c 24 1c 00    	cmpb   $0x0,0x1c(%r12)
   597ac:	0f 84 24 01 00 00    	je     598d6 <compare_benchmark::lookup+0x166>
   597b2:	48 89 f0             	mov    %rsi,%rax
   597b5:	48 c1 e8 20          	shr    $0x20,%rax
   597b9:	41 23 44 24 18       	and    0x18(%r12),%eax
   597be:	49 8b 4c 24 08       	mov    0x8(%r12),%rcx
   597c3:	48 c1 e0 04          	shl    $0x4,%rax
   597c7:	c5 f9 6f 04 01       	vmovdqa (%rcx,%rax,1),%xmm0
   597cc:	62 f2 7d 08 7c ce    	vpbroadcastd %esi,%xmm1
   597d2:	c5 f1 e5 0d c6 f4 fa 	vpmulhw -0x50b3a(%rip),%xmm1,%xmm1        # 8ca0 <anon.35274091df3394f4211c680a8c77ed4a.34.llvm.9036914972901821666+0x1b0>
   597d9:	ff 
   597da:	c4 e2 79 59 15 e5 ed 	vpbroadcastq -0x5121b(%rip),%xmm2        # 85c8 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x24c>
   597e1:	fa ff 
   597e3:	c4 e2 69 00 c9       	vpshufb %xmm1,%xmm2,%xmm1
   597e8:	c4 e2 79 17 c1       	vptest %xmm1,%xmm0
   597ed:	0f 92 c0             	setb   %al
   597f0:	e9 e9 00 00 00       	jmp    598de <compare_benchmark::lookup+0x16e>
   597f5:	41 80 7c 24 1c 00    	cmpb   $0x0,0x1c(%r12)
   597fb:	0f 84 e4 00 00 00    	je     598e5 <compare_benchmark::lookup+0x175>
   59801:	4d 85 ff             	test   %r15,%r15
   59804:	0f 84 05 01 00 00    	je     5990f <compare_benchmark::lookup+0x19f>
   5980a:	41 8b 44 24 18       	mov    0x18(%r12),%eax
   5980f:	49 8b 4c 24 08       	mov    0x8(%r12),%rcx
   59814:	4c 89 fa             	mov    %r15,%rdx
   59817:	48 83 e2 fe          	and    $0xfffffffffffffffe,%rdx
   5981b:	31 f6                	xor    %esi,%esi
   5981d:	c5 f9 6f 0d 7b f4 fa 	vmovdqa -0x50b85(%rip),%xmm1        # 8ca0 <anon.35274091df3394f4211c680a8c77ed4a.34.llvm.9036914972901821666+0x1b0>
   59824:	ff 
   59825:	c4 e2 79 59 05 9a ed 	vpbroadcastq -0x51266(%rip),%xmm0        # 85c8 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x24c>
   5982c:	fa ff 
   5982e:	66 90                	xchg   %ax,%ax
   59830:	49 8b 3c f6          	mov    (%r14,%rsi,8),%rdi
   59834:	62 f2 7d 08 7c d7    	vpbroadcastd %edi,%xmm2
   5983a:	48 c1 ef 20          	shr    $0x20,%rdi
   5983e:	21 c7                	and    %eax,%edi
   59840:	48 c1 e7 04          	shl    $0x4,%rdi
   59844:	c5 f9 6f 1c 39       	vmovdqa (%rcx,%rdi,1),%xmm3
   59849:	c5 e9 e5 d1          	vpmulhw %xmm1,%xmm2,%xmm2
   5984d:	c4 e2 79 00 d2       	vpshufb %xmm2,%xmm0,%xmm2
   59852:	31 ff                	xor    %edi,%edi
   59854:	c4 e2 79 17 da       	vptest %xmm2,%xmm3
   59859:	40 0f 92 c7          	setb   %dil
   5985d:	89 3c b3             	mov    %edi,(%rbx,%rsi,4)
   59860:	49 8b 7c f6 08       	mov    0x8(%r14,%rsi,8),%rdi
   59865:	62 f2 7d 08 7c d7    	vpbroadcastd %edi,%xmm2
   5986b:	48 c1 ef 20          	shr    $0x20,%rdi
   5986f:	21 c7                	and    %eax,%edi
   59871:	48 c1 e7 04          	shl    $0x4,%rdi
   59875:	c5 f9 6f 1c 39       	vmovdqa (%rcx,%rdi,1),%xmm3
   5987a:	c5 e9 e5 d1          	vpmulhw %xmm1,%xmm2,%xmm2
   5987e:	c4 e2 79 00 d2       	vpshufb %xmm2,%xmm0,%xmm2
   59883:	31 ff                	xor    %edi,%edi
   59885:	c4 e2 79 17 da       	vptest %xmm2,%xmm3
   5988a:	40 0f 92 c7          	setb   %dil
   5988e:	89 7c b3 04          	mov    %edi,0x4(%rbx,%rsi,4)
   59892:	48 83 c6 02          	add    $0x2,%rsi
   59896:	48 39 f2             	cmp    %rsi,%rdx
   59899:	75 95                	jne    59830 <compare_benchmark::lookup+0xc0>
   5989b:	41 f6 c7 01          	test   $0x1,%r15b
   5989f:	74 6e                	je     5990f <compare_benchmark::lookup+0x19f>
   598a1:	49 8b 14 f6          	mov    (%r14,%rsi,8),%rdx
   598a5:	62 f2 7d 08 7c ca    	vpbroadcastd %edx,%xmm1
   598ab:	48 c1 ea 20          	shr    $0x20,%rdx
   598af:	21 d0                	and    %edx,%eax
   598b1:	48 c1 e0 04          	shl    $0x4,%rax
   598b5:	c5 f9 6f 14 01       	vmovdqa (%rcx,%rax,1),%xmm2
   598ba:	c5 f1 e5 0d de f3 fa 	vpmulhw -0x50c22(%rip),%xmm1,%xmm1        # 8ca0 <anon.35274091df3394f4211c680a8c77ed4a.34.llvm.9036914972901821666+0x1b0>
   598c1:	ff 
   598c2:	c4 e2 79 00 c1       	vpshufb %xmm1,%xmm0,%xmm0
   598c7:	31 c0                	xor    %eax,%eax
   598c9:	c4 e2 79 17 d0       	vptest %xmm0,%xmm2
   598ce:	0f 92 c0             	setb   %al
   598d1:	89 04 b3             	mov    %eax,(%rbx,%rsi,4)
   598d4:	eb 39                	jmp    5990f <compare_benchmark::lookup+0x19f>
   598d6:	4c 89 e7             	mov    %r12,%rdi
   598d9:	e8 32 1d 00 00       	call   5b610 <fastest_bloom_filter_inline::byte_split::ByteSplitBloomFilter::contains_scalar>
   598de:	0f b6 c0             	movzbl %al,%eax
   598e1:	89 03                	mov    %eax,(%rbx)
   598e3:	eb 2a                	jmp    5990f <compare_benchmark::lookup+0x19f>
   598e5:	4d 85 ff             	test   %r15,%r15
   598e8:	74 25                	je     5990f <compare_benchmark::lookup+0x19f>
   598ea:	45 31 ed             	xor    %r13d,%r13d
   598ed:	0f 1f 00             	nopl   (%rax)
   598f0:	49 8d 6d 01          	lea    0x1(%r13),%rbp
   598f4:	4b 8b 34 ee          	mov    (%r14,%r13,8),%rsi
   598f8:	4c 89 e7             	mov    %r12,%rdi
   598fb:	e8 10 1d 00 00       	call   5b610 <fastest_bloom_filter_inline::byte_split::ByteSplitBloomFilter::contains_scalar>
   59900:	0f b6 c0             	movzbl %al,%eax
   59903:	42 89 04 ab          	mov    %eax,(%rbx,%r13,4)
   59907:	49 89 ed             	mov    %rbp,%r13
   5990a:	49 39 ef             	cmp    %rbp,%r15
   5990d:	75 e1                	jne    598f0 <compare_benchmark::lookup+0x180>
   5990f:	48 83 c4 48          	add    $0x48,%rsp
   59913:	5b                   	pop    %rbx
   59914:	41 5c                	pop    %r12
   59916:	41 5d                	pop    %r13
   59918:	41 5e                	pop    %r14
   5991a:	41 5f                	pop    %r15
   5991c:	5d                   	pop    %rbp
   5991d:	c3                   	ret
   5991e:	48 8d 05 fb 1f 05 00 	lea    0x51ffb(%rip),%rax        # ab920 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0x1f0>
   59925:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
   5992a:	48 c7 44 24 20 01 00 	movq   $0x1,0x20(%rsp)
   59931:	00 00 
   59933:	48 c7 44 24 28 08 00 	movq   $0x8,0x28(%rsp)
   5993a:	00 00 
   5993c:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
   59940:	c5 f8 11 44 24 30    	vmovups %xmm0,0x30(%rsp)
   59946:	4c 8d 05 03 29 05 00 	lea    0x52903(%rip),%r8        # ac250 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0xb20>
   5994d:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
   59952:	48 8d 54 24 10       	lea    0x10(%rsp),%rdx
   59957:	48 8d 4c 24 18       	lea    0x18(%rsp),%rcx
   5995c:	31 ff                	xor    %edi,%edi
   5995e:	ff 15 d4 5b 05 00    	call   *0x55bd4(%rip)        # af538 <_DYNAMIC+0x3a8>
   59964:	cc                   	int3
   59965:	cc                   	int3
   59966:	cc                   	int3
   59967:	cc                   	int3
   59968:	cc                   	int3
   59969:	cc                   	int3
   5996a:	cc                   	int3
   5996b:	cc                   	int3
   5996c:	cc                   	int3
   5996d:	cc                   	int3
   5996e:	cc                   	int3
   5996f:	cc                   	int3

