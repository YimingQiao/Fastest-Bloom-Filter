0000000000180850 <void inline_single_kernel<true, independent_vbmi_experiment::IndependentVbmi32, unsigned long>(independent_vbmi_experiment::IndependentVbmi32 const&, unsigned long, unsigned long const*, unsigned int*)>:
  180850:	48 85 f6             	test   %rsi,%rsi
  180853:	0f 84 8b 01 00 00    	je     1809e4 <void inline_single_kernel<true, independent_vbmi_experiment::IndependentVbmi32, unsigned long>(independent_vbmi_experiment::IndependentVbmi32 const&, unsigned long, unsigned long const*, unsigned int*)+0x194>
  180859:	53                   	push   %rbx
  18085a:	49 b8 93 fd 59 66 b8 	movabs $0xd6e8feb86659fd93,%r8
  180861:	fe e8 d6
  180864:	48 83 fe 01          	cmp    $0x1,%rsi
  180868:	75 07                	jne    180871 <void inline_single_kernel<true, independent_vbmi_experiment::IndependentVbmi32, unsigned long>(independent_vbmi_experiment::IndependentVbmi32 const&, unsigned long, unsigned long const*, unsigned int*)+0x21>
  18086a:	31 c0                	xor    %eax,%eax
  18086c:	e9 00 01 00 00       	jmp    180971 <void inline_single_kernel<true, independent_vbmi_experiment::IndependentVbmi32, unsigned long>(independent_vbmi_experiment::IndependentVbmi32 const&, unsigned long, unsigned long const*, unsigned int*)+0x121>
  180871:	49 89 f1             	mov    %rsi,%r9
  180874:	49 83 e1 fe          	and    $0xfffffffffffffffe,%r9
  180878:	31 c0                	xor    %eax,%eax
  18087a:	c4 e2 79 59 05 75 2a 	vpbroadcastq -0x17d58b(%rip),%xmm0        # 32f8 <_IO_stdin_used+0x44>
  180881:	e8 ff
  180883:	c4 e2 7d 58 0d 1c 2a 	vpbroadcastd -0x17d5e4(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
  18088a:	e8 ff
  18088c:	0f 1f 40 00          	nopl   0x0(%rax)
  180890:	4c 8b 14 c2          	mov    (%rdx,%rax,8),%r10
  180894:	4d 89 d3             	mov    %r10,%r11
  180897:	49 c1 eb 20          	shr    $0x20,%r11
  18089b:	4d 31 d3             	xor    %r10,%r11
  18089e:	4d 0f af d8          	imul   %r8,%r11
  1808a2:	4d 89 da             	mov    %r11,%r10
  1808a5:	49 c1 ea 20          	shr    $0x20,%r10
  1808a9:	4d 31 da             	xor    %r11,%r10
  1808ac:	4d 0f af d0          	imul   %r8,%r10
  1808b0:	4d 89 d3             	mov    %r10,%r11
  1808b3:	49 c1 eb 20          	shr    $0x20,%r11
  1808b7:	4d 31 d3             	xor    %r10,%r11
  1808ba:	49 c1 ea 29          	shr    $0x29,%r10
  1808be:	44 23 57 18          	and    0x18(%rdi),%r10d
  1808c2:	48 8b 1f             	mov    (%rdi),%rbx
  1808c5:	41 c1 e2 05          	shl    $0x5,%r10d
  1808c9:	c4 a1 7d 6f 14 13    	vmovdqa (%rbx,%r10,1),%ymm2
  1808cf:	62 d2 fd 08 7c db    	vpbroadcastq %r11,%xmm3
  1808d5:	62 f2 fd 08 83 db    	vpmultishiftqb %xmm3,%xmm0,%xmm3
  1808db:	c4 e2 7d 31 db       	vpmovzxbd %xmm3,%ymm3
  1808e0:	62 f2 75 28 15 db    	vprolvd %ymm3,%ymm1,%ymm3
  1808e6:	45 31 d2             	xor    %r10d,%r10d
  1808e9:	c4 e2 7d 17 d3       	vptest %ymm3,%ymm2
  1808ee:	41 0f 92 c2          	setb   %r10b
  1808f2:	44 89 14 81          	mov    %r10d,(%rcx,%rax,4)
  1808f6:	4c 8b 54 c2 08       	mov    0x8(%rdx,%rax,8),%r10
  1808fb:	4d 89 d3             	mov    %r10,%r11
  1808fe:	49 c1 eb 20          	shr    $0x20,%r11
  180902:	4d 31 d3             	xor    %r10,%r11
  180905:	4d 0f af d8          	imul   %r8,%r11
  180909:	4d 89 da             	mov    %r11,%r10
  18090c:	49 c1 ea 20          	shr    $0x20,%r10
  180910:	4d 31 da             	xor    %r11,%r10
  180913:	4d 0f af d0          	imul   %r8,%r10
  180917:	4d 89 d3             	mov    %r10,%r11
  18091a:	49 c1 eb 20          	shr    $0x20,%r11
  18091e:	4d 31 d3             	xor    %r10,%r11
  180921:	49 c1 ea 29          	shr    $0x29,%r10
  180925:	44 23 57 18          	and    0x18(%rdi),%r10d
  180929:	48 8b 1f             	mov    (%rdi),%rbx
  18092c:	41 c1 e2 05          	shl    $0x5,%r10d
  180930:	c4 a1 7d 6f 14 13    	vmovdqa (%rbx,%r10,1),%ymm2
  180936:	62 d2 fd 08 7c db    	vpbroadcastq %r11,%xmm3
  18093c:	62 f2 fd 08 83 db    	vpmultishiftqb %xmm3,%xmm0,%xmm3
  180942:	c4 e2 7d 31 db       	vpmovzxbd %xmm3,%ymm3
  180947:	62 f2 75 28 15 db    	vprolvd %ymm3,%ymm1,%ymm3
  18094d:	45 31 d2             	xor    %r10d,%r10d
  180950:	c4 e2 7d 17 d3       	vptest %ymm3,%ymm2
  180955:	41 0f 92 c2          	setb   %r10b
  180959:	44 89 54 81 04       	mov    %r10d,0x4(%rcx,%rax,4)
  18095e:	48 83 c0 02          	add    $0x2,%rax
  180962:	49 39 c1             	cmp    %rax,%r9
  180965:	0f 85 25 ff ff ff    	jne    180890 <void inline_single_kernel<true, independent_vbmi_experiment::IndependentVbmi32, unsigned long>(independent_vbmi_experiment::IndependentVbmi32 const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
  18096b:	40 f6 c6 01          	test   $0x1,%sil
  18096f:	74 72                	je     1809e3 <void inline_single_kernel<true, independent_vbmi_experiment::IndependentVbmi32, unsigned long>(independent_vbmi_experiment::IndependentVbmi32 const&, unsigned long, unsigned long const*, unsigned int*)+0x193>
  180971:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  180975:	48 89 d6             	mov    %rdx,%rsi
  180978:	48 c1 ee 20          	shr    $0x20,%rsi
  18097c:	48 31 d6             	xor    %rdx,%rsi
  18097f:	49 0f af f0          	imul   %r8,%rsi
  180983:	48 89 f2             	mov    %rsi,%rdx
  180986:	48 c1 ea 20          	shr    $0x20,%rdx
  18098a:	48 31 f2             	xor    %rsi,%rdx
  18098d:	49 0f af d0          	imul   %r8,%rdx
  180991:	48 89 d6             	mov    %rdx,%rsi
  180994:	48 c1 ee 20          	shr    $0x20,%rsi
  180998:	48 31 d6             	xor    %rdx,%rsi
  18099b:	48 c1 ea 29          	shr    $0x29,%rdx
  18099f:	23 57 18             	and    0x18(%rdi),%edx
  1809a2:	48 8b 3f             	mov    (%rdi),%rdi
  1809a5:	c1 e2 05             	shl    $0x5,%edx
  1809a8:	c5 fd 6f 04 17       	vmovdqa (%rdi,%rdx,1),%ymm0
  1809ad:	62 f2 fd 08 7c ce    	vpbroadcastq %rsi,%xmm1
  1809b3:	c4 e2 79 59 15 3c 29 	vpbroadcastq -0x17d6c4(%rip),%xmm2        # 32f8 <_IO_stdin_used+0x44>
  1809ba:	e8 ff
  1809bc:	62 f2 ed 08 83 c9    	vpmultishiftqb %xmm1,%xmm2,%xmm1
  1809c2:	c4 e2 7d 31 c9       	vpmovzxbd %xmm1,%ymm1
  1809c7:	c4 e2 7d 58 15 d8 28 	vpbroadcastd -0x17d728(%rip),%ymm2        # 32a8 <__abi_tag+0x2fe4>
  1809ce:	e8 ff
  1809d0:	62 f2 6d 28 15 c9    	vprolvd %ymm1,%ymm2,%ymm1
  1809d6:	31 d2                	xor    %edx,%edx
  1809d8:	c4 e2 7d 17 c1       	vptest %ymm1,%ymm0
  1809dd:	0f 92 c2             	setb   %dl
  1809e0:	89 14 81             	mov    %edx,(%rcx,%rax,4)
  1809e3:	5b                   	pop    %rbx
  1809e4:	c5 f8 77             	vzeroupper
  1809e7:	c3                   	ret
  1809e8:	cc                   	int3
  1809e9:	cc                   	int3
  1809ea:	cc                   	int3
  1809eb:	cc                   	int3
  1809ec:	cc                   	int3
  1809ed:	cc                   	int3
  1809ee:	cc                   	int3
  1809ef:	cc                   	int3
