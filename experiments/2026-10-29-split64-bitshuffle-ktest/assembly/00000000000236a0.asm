00000000000236a0 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<2>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<2>&, unsigned long, unsigned long const*, unsigned int*)>:
   236a0:	push   %rbp
   236a1:	push   %r15
   236a3:	push   %r14
   236a5:	push   %r12
   236a7:	push   %rbx
   236a8:	cmp    $0x1,%esi
   236ab:	jne    2370d <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<2>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<2>&, unsigned long, unsigned long const*, unsigned int*)+0x6d>
   236ad:	mov    (%rdx),%rax
   236b0:	mov    %eax,%edx
   236b2:	shr    $0x20,%rax
   236b6:	and    0x18(%rdi),%eax
   236b9:	mov    (%rdi),%rsi
   236bc:	shl    $0x6,%rax
   236c0:	vpbroadcastq %rdx,%zmm0
   236c6:	vpmulld -0x20f10(%rip),%zmm0,%zmm0        # 27c0 <_IO_stdin_used+0x778>
   236d0:	vpsrlq $0x1a,%zmm0,%zmm0
   236d7:	vmovdqa64 (%rsi,%rax,1),%zmm1
   236de:	vpshufbitqmb %zmm0,%zmm1,%k0
   236e4:	kmovq  %k0,%rax
   236e9:	movabs $0x101010101010101,%rdx
   236f3:	and    %rdx,%rax
   236f6:	xor    %esi,%esi
   236f8:	cmp    %rdx,%rax
   236fb:	sete   %sil
   236ff:	mov    %esi,(%rcx)
   23701:	pop    %rbx
   23702:	pop    %r12
   23704:	pop    %r14
   23706:	pop    %r15
   23708:	pop    %rbp
   23709:	vzeroupper
   2370c:	ret
   2370d:	mov    %esi,%eax
   2370f:	cmp    $0x10,%esi
   23712:	jae    2372e <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<2>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<2>&, unsigned long, unsigned long const*, unsigned int*)+0x8e>
   23714:	test   %esi,%esi
   23716:	je     23701 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<2>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<2>&, unsigned long, unsigned long const*, unsigned int*)+0x61>
   23718:	movabs $0x101010101010101,%r8
   23722:	cmp    $0x1,%eax
   23725:	jne    2375b <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<2>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<2>&, unsigned long, unsigned long const*, unsigned int*)+0xbb>
   23727:	xor    %eax,%eax
   23729:	jmp    23821 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<2>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<2>&, unsigned long, unsigned long const*, unsigned int*)+0x181>
   2372e:	movabs $0x101010101010101,%r8
   23738:	cmp    $0x21,%esi
   2373b:	jb     23753 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<2>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<2>&, unsigned long, unsigned long const*, unsigned int*)+0xb3>
   2373d:	lea    -0x20(%rax),%r9
   23741:	cmp    $0x21,%rax
   23745:	jne    23875 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<2>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<2>&, unsigned long, unsigned long const*, unsigned int*)+0x1d5>
   2374b:	xor    %r10d,%r10d
   2374e:	jmp    23965 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<2>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<2>&, unsigned long, unsigned long const*, unsigned int*)+0x2c5>
   23753:	xor    %r9d,%r9d
   23756:	jmp    239cb <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<2>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<2>&, unsigned long, unsigned long const*, unsigned int*)+0x32b>
   2375b:	mov    %esi,%r9d
   2375e:	and    $0xe,%r9d
   23762:	xor    %eax,%eax
   23764:	vmovdqa64 -0x20fae(%rip),%zmm0        # 27c0 <_IO_stdin_used+0x778>
   2376e:	xchg   %ax,%ax
   23770:	mov    (%rdx,%rax,8),%r10
   23774:	mov    %r10d,%r11d
   23777:	shr    $0x20,%r10
   2377b:	and    0x18(%rdi),%r10d
   2377f:	mov    (%rdi),%rbx
   23782:	vpbroadcastq %r11,%zmm1
   23788:	vpmulld %zmm0,%zmm1,%zmm1
   2378e:	shl    $0x6,%r10
   23792:	vpsrlq $0x1a,%zmm1,%zmm1
   23799:	vmovaps (%rbx,%r10,1),%zmm2
   237a0:	vpshufbitqmb %zmm1,%zmm2,%k0
   237a6:	kmovq  %k0,%r10
   237ab:	and    %r8,%r10
   237ae:	xor    %r11d,%r11d
   237b1:	cmp    %r8,%r10
   237b4:	sete   %r11b
   237b8:	mov    %r11d,(%rcx,%rax,4)
   237bc:	mov    0x8(%rdx,%rax,8),%r10
   237c1:	mov    %r10d,%r11d
   237c4:	shr    $0x20,%r10
   237c8:	and    0x18(%rdi),%r10d
   237cc:	mov    (%rdi),%rbx
   237cf:	shl    $0x6,%r10
   237d3:	vpbroadcastq %r11,%zmm1
   237d9:	vpmulld %zmm0,%zmm1,%zmm1
   237df:	vpsrlq $0x1a,%zmm1,%zmm1
   237e6:	vmovaps (%rbx,%r10,1),%zmm2
   237ed:	vpshufbitqmb %zmm1,%zmm2,%k0
   237f3:	kmovq  %k0,%r10
   237f8:	and    %r8,%r10
   237fb:	xor    %r11d,%r11d
   237fe:	cmp    %r8,%r10
   23801:	sete   %r11b
   23805:	mov    %r11d,0x4(%rcx,%rax,4)
   2380a:	add    $0x2,%rax
   2380e:	cmp    %rax,%r9
   23811:	jne    23770 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<2>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<2>&, unsigned long, unsigned long const*, unsigned int*)+0xd0>
   23817:	test   $0x1,%sil
   2381b:	je     23701 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<2>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<2>&, unsigned long, unsigned long const*, unsigned int*)+0x61>
   23821:	mov    (%rdx,%rax,8),%rdx
   23825:	mov    %rdx,%rsi
   23828:	shr    $0x20,%rsi
   2382c:	and    0x18(%rdi),%esi
   2382f:	mov    %edx,%edx
   23831:	mov    (%rdi),%rdi
   23834:	vpbroadcastq %rdx,%zmm0
   2383a:	vpmulld -0x21084(%rip),%zmm0,%zmm0        # 27c0 <_IO_stdin_used+0x778>
   23844:	shl    $0x6,%rsi
   23848:	vpsrlq $0x1a,%zmm0,%zmm0
   2384f:	vmovdqa64 (%rdi,%rsi,1),%zmm1
   23856:	vpshufbitqmb %zmm0,%zmm1,%k0
   2385c:	kmovq  %k0,%rdx
   23861:	and    %r8,%rdx
   23864:	xor    %esi,%esi
   23866:	cmp    %r8,%rdx
   23869:	sete   %sil
   2386d:	mov    %esi,(%rcx,%rax,4)
   23870:	jmp    23701 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<2>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<2>&, unsigned long, unsigned long const*, unsigned int*)+0x61>
   23875:	and    $0x1,%esi
   23878:	mov    %r9,%r11
   2387b:	sub    %rsi,%r11
   2387e:	xor    %r10d,%r10d
   23881:	vmovdqa64 -0x210cb(%rip),%zmm0        # 27c0 <_IO_stdin_used+0x778>
   2388b:	nopl   0x0(%rax,%rax,1)
   23890:	mov    0x18(%rdi),%ebp
   23893:	mov    0x104(%rdx,%r10,8),%ebx
   2389b:	and    %ebp,%ebx
   2389d:	mov    (%rdx,%r10,8),%r14
   238a1:	mov    %r14d,%r15d
   238a4:	shr    $0x20,%r14
   238a8:	and    %ebp,%r14d
   238ab:	mov    (%rdi),%r12
   238ae:	shl    $0x6,%r14
   238b2:	vpbroadcastq %r15,%zmm1
   238b8:	vpmulld %zmm0,%zmm1,%zmm1
   238be:	vpsrlq $0x1a,%zmm1,%zmm1
   238c5:	vmovaps (%r12,%r14,1),%zmm2
   238cc:	vpshufbitqmb %zmm1,%zmm2,%k0
   238d2:	shl    $0x6,%rbx
   238d6:	kmovq  %k0,%r14
   238db:	and    %r8,%r14
   238de:	xor    %ebp,%ebp
   238e0:	cmp    %r8,%r14
   238e3:	sete   %bpl
   238e7:	prefetcht0 (%r12,%rbx,1)
   238ec:	mov    %ebp,(%rcx,%r10,4)
   238f0:	mov    0x18(%rdi),%ebx
   238f3:	mov    0x10c(%rdx,%r10,8),%r14d
   238fb:	and    %ebx,%r14d
   238fe:	mov    (%rdi),%r15
   23901:	shl    $0x6,%r14
   23905:	prefetcht0 (%r15,%r14,1)
   2390a:	mov    0x8(%rdx,%r10,8),%r14
   2390f:	mov    %r14d,%r12d
   23912:	shr    $0x20,%r14
   23916:	and    %ebx,%r14d
   23919:	shl    $0x6,%r14
   2391d:	vpbroadcastq %r12,%zmm1
   23923:	vpmulld %zmm0,%zmm1,%zmm1
   23929:	vpsrlq $0x1a,%zmm1,%zmm1
   23930:	vmovaps (%r15,%r14,1),%zmm2
   23937:	vpshufbitqmb %zmm1,%zmm2,%k0
   2393d:	kmovq  %k0,%rbx
   23942:	and    %r8,%rbx
   23945:	xor    %ebp,%ebp
   23947:	cmp    %r8,%rbx
   2394a:	sete   %bpl
   2394e:	mov    %ebp,0x4(%rcx,%r10,4)
   23953:	add    $0x2,%r10
   23957:	cmp    %r10,%r11
   2395a:	jne    23890 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<2>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<2>&, unsigned long, unsigned long const*, unsigned int*)+0x1f0>
   23960:	test   %rsi,%rsi
   23963:	je     239cb <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<2>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<2>&, unsigned long, unsigned long const*, unsigned int*)+0x32b>
   23965:	mov    0x18(%rdi),%esi
   23968:	mov    0x104(%rdx,%r10,8),%r11d
   23970:	and    %esi,%r11d
   23973:	mov    (%rdi),%rbx
   23976:	shl    $0x6,%r11
   2397a:	prefetcht0 (%rbx,%r11,1)
   2397f:	mov    (%rdx,%r10,8),%r11
   23983:	mov    %r11d,%r14d
   23986:	shr    $0x20,%r11
   2398a:	and    %esi,%r11d
   2398d:	vpbroadcastq %r14,%zmm0
   23993:	vpmulld -0x211dd(%rip),%zmm0,%zmm0        # 27c0 <_IO_stdin_used+0x778>
   2399d:	shl    $0x6,%r11
   239a1:	vpsrlq $0x1a,%zmm0,%zmm0
   239a8:	vmovdqa64 (%rbx,%r11,1),%zmm1
   239af:	vpshufbitqmb %zmm0,%zmm1,%k0
   239b5:	kmovq  %k0,%rsi
   239ba:	and    %r8,%rsi
   239bd:	xor    %r11d,%r11d
   239c0:	cmp    %r8,%rsi
   239c3:	sete   %r11b
   239c7:	mov    %r11d,(%rcx,%r10,4)
   239cb:	cmp    %rax,%r9
   239ce:	jae    23701 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<2>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<2>&, unsigned long, unsigned long const*, unsigned int*)+0x61>
   239d4:	vmovdqa64 -0x2121e(%rip),%zmm0        # 27c0 <_IO_stdin_used+0x778>
   239de:	xchg   %ax,%ax
   239e0:	mov    (%rdx,%r9,8),%rsi
   239e4:	mov    %rsi,%r10
   239e7:	shr    $0x20,%r10
   239eb:	and    0x18(%rdi),%r10d
   239ef:	mov    %esi,%esi
   239f1:	mov    (%rdi),%r11
   239f4:	shl    $0x6,%r10
   239f8:	vpbroadcastq %rsi,%zmm1
   239fe:	vpmulld %zmm0,%zmm1,%zmm1
   23a04:	vpsrlq $0x1a,%zmm1,%zmm1
   23a0b:	vmovaps (%r11,%r10,1),%zmm2
   23a12:	vpshufbitqmb %zmm1,%zmm2,%k0
   23a18:	kmovq  %k0,%rsi
   23a1d:	and    %r8,%rsi
   23a20:	xor    %r10d,%r10d
   23a23:	cmp    %r8,%rsi
   23a26:	sete   %r10b
   23a2a:	mov    %r10d,(%rcx,%r9,4)
   23a2e:	inc    %r9
   23a31:	cmp    %r9,%rax
   23a34:	jne    239e0 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<2>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<2>&, unsigned long, unsigned long const*, unsigned int*)+0x340>
   23a36:	jmp    23701 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<2>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<2>&, unsigned long, unsigned long const*, unsigned int*)+0x61>
   23a3b:	int3
   23a3c:	int3
   23a3d:	int3
   23a3e:	int3
   23a3f:	int3

