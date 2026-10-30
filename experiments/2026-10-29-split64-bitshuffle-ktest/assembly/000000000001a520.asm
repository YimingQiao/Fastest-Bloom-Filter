000000000001a520 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<0>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<0>&, unsigned long, unsigned long const*, unsigned int*)>:
   1a520:	push   %rbp
   1a521:	push   %r15
   1a523:	push   %r14
   1a525:	push   %rbx
   1a526:	cmp    $0x1,%esi
   1a529:	jne    1a58a <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<0>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<0>&, unsigned long, unsigned long const*, unsigned int*)+0x6a>
   1a52b:	mov    (%rdx),%rax
   1a52e:	vpbroadcastd %eax,%ymm0
   1a534:	shr    $0x20,%rax
   1a538:	and    0x18(%rdi),%eax
   1a53b:	mov    (%rdi),%rdx
   1a53e:	shl    $0x6,%rax
   1a542:	vpmulld -0x184eb(%rip),%ymm0,%ymm0        # 2060 <_IO_stdin_used+0x18>
   1a54b:	vpsrld $0x1a,%ymm0,%ymm0
   1a550:	vpmovzxdq %ymm0,%zmm0
   1a556:	vmovdqa64 (%rdx,%rax,1),%zmm1
   1a55d:	vpshufbitqmb %zmm0,%zmm1,%k0
   1a563:	kmovq  %k0,%rax
   1a568:	movabs $0x101010101010101,%rdx
   1a572:	and    %rdx,%rax
   1a575:	xor    %esi,%esi
   1a577:	cmp    %rdx,%rax
   1a57a:	sete   %sil
   1a57e:	mov    %esi,(%rcx)
   1a580:	pop    %rbx
   1a581:	pop    %r14
   1a583:	pop    %r15
   1a585:	pop    %rbp
   1a586:	vzeroupper
   1a589:	ret
   1a58a:	mov    %esi,%eax
   1a58c:	cmp    $0x10,%esi
   1a58f:	jae    1a5ab <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<0>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<0>&, unsigned long, unsigned long const*, unsigned int*)+0x8b>
   1a591:	test   %esi,%esi
   1a593:	je     1a580 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<0>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<0>&, unsigned long, unsigned long const*, unsigned int*)+0x60>
   1a595:	movabs $0x101010101010101,%r8
   1a59f:	cmp    $0x1,%eax
   1a5a2:	jne    1a5d8 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<0>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<0>&, unsigned long, unsigned long const*, unsigned int*)+0xb8>
   1a5a4:	xor    %eax,%eax
   1a5a6:	jmp    1a6a1 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<0>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<0>&, unsigned long, unsigned long const*, unsigned int*)+0x181>
   1a5ab:	movabs $0x101010101010101,%r8
   1a5b5:	cmp    $0x21,%esi
   1a5b8:	jb     1a5d0 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<0>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<0>&, unsigned long, unsigned long const*, unsigned int*)+0xb0>
   1a5ba:	lea    -0x20(%rax),%r9
   1a5be:	cmp    $0x21,%rax
   1a5c2:	jne    1a6f5 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<0>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<0>&, unsigned long, unsigned long const*, unsigned int*)+0x1d5>
   1a5c8:	xor    %r10d,%r10d
   1a5cb:	jmp    1a7e5 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<0>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<0>&, unsigned long, unsigned long const*, unsigned int*)+0x2c5>
   1a5d0:	xor    %r9d,%r9d
   1a5d3:	jmp    1a84b <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<0>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<0>&, unsigned long, unsigned long const*, unsigned int*)+0x32b>
   1a5d8:	mov    %esi,%r9d
   1a5db:	and    $0xe,%r9d
   1a5df:	xor    %eax,%eax
   1a5e1:	vmovdqa64 -0x17eab(%rip),%zmm0        # 2740 <_IO_stdin_used+0x6f8>
   1a5eb:	nopl   0x0(%rax,%rax,1)
   1a5f0:	mov    (%rdx,%rax,8),%r10
   1a5f4:	mov    %r10d,%r11d
   1a5f7:	shr    $0x20,%r10
   1a5fb:	and    0x18(%rdi),%r10d
   1a5ff:	mov    (%rdi),%rbx
   1a602:	vpbroadcastq %r11,%zmm1
   1a608:	vpmulld %zmm0,%zmm1,%zmm1
   1a60e:	shl    $0x6,%r10
   1a612:	vpsrlq $0x1a,%zmm1,%zmm1
   1a619:	vmovaps (%rbx,%r10,1),%zmm2
   1a620:	vpshufbitqmb %zmm1,%zmm2,%k0
   1a626:	kmovq  %k0,%r10
   1a62b:	and    %r8,%r10
   1a62e:	xor    %r11d,%r11d
   1a631:	cmp    %r8,%r10
   1a634:	sete   %r11b
   1a638:	mov    %r11d,(%rcx,%rax,4)
   1a63c:	mov    0x8(%rdx,%rax,8),%r10
   1a641:	mov    %r10d,%r11d
   1a644:	shr    $0x20,%r10
   1a648:	and    0x18(%rdi),%r10d
   1a64c:	mov    (%rdi),%rbx
   1a64f:	shl    $0x6,%r10
   1a653:	vpbroadcastq %r11,%zmm1
   1a659:	vpmulld %zmm0,%zmm1,%zmm1
   1a65f:	vpsrlq $0x1a,%zmm1,%zmm1
   1a666:	vmovaps (%rbx,%r10,1),%zmm2
   1a66d:	vpshufbitqmb %zmm1,%zmm2,%k0
   1a673:	kmovq  %k0,%r10
   1a678:	and    %r8,%r10
   1a67b:	xor    %r11d,%r11d
   1a67e:	cmp    %r8,%r10
   1a681:	sete   %r11b
   1a685:	mov    %r11d,0x4(%rcx,%rax,4)
   1a68a:	add    $0x2,%rax
   1a68e:	cmp    %rax,%r9
   1a691:	jne    1a5f0 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<0>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<0>&, unsigned long, unsigned long const*, unsigned int*)+0xd0>
   1a697:	test   $0x1,%sil
   1a69b:	je     1a580 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<0>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<0>&, unsigned long, unsigned long const*, unsigned int*)+0x60>
   1a6a1:	mov    (%rdx,%rax,8),%rdx
   1a6a5:	mov    %rdx,%rsi
   1a6a8:	shr    $0x20,%rsi
   1a6ac:	and    0x18(%rdi),%esi
   1a6af:	mov    %edx,%edx
   1a6b1:	mov    (%rdi),%rdi
   1a6b4:	vpbroadcastq %rdx,%zmm0
   1a6ba:	vpmulld -0x17f84(%rip),%zmm0,%zmm0        # 2740 <_IO_stdin_used+0x6f8>
   1a6c4:	shl    $0x6,%rsi
   1a6c8:	vpsrlq $0x1a,%zmm0,%zmm0
   1a6cf:	vmovdqa64 (%rdi,%rsi,1),%zmm1
   1a6d6:	vpshufbitqmb %zmm0,%zmm1,%k0
   1a6dc:	kmovq  %k0,%rdx
   1a6e1:	and    %r8,%rdx
   1a6e4:	xor    %esi,%esi
   1a6e6:	cmp    %r8,%rdx
   1a6e9:	sete   %sil
   1a6ed:	mov    %esi,(%rcx,%rax,4)
   1a6f0:	jmp    1a580 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<0>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<0>&, unsigned long, unsigned long const*, unsigned int*)+0x60>
   1a6f5:	and    $0x1,%esi
   1a6f8:	mov    %r9,%r11
   1a6fb:	sub    %rsi,%r11
   1a6fe:	xor    %r10d,%r10d
   1a701:	vmovdqa -0x186a9(%rip),%ymm0        # 2060 <_IO_stdin_used+0x18>
   1a709:	nopl   0x0(%rax)
   1a710:	mov    0x18(%rdi),%ebp
   1a713:	mov    0x104(%rdx,%r10,8),%ebx
   1a71b:	and    %ebp,%ebx
   1a71d:	mov    (%rdi),%r14
   1a720:	mov    (%rdx,%r10,8),%r15
   1a724:	vpbroadcastd %r15d,%ymm1
   1a72a:	shr    $0x20,%r15
   1a72e:	and    %ebp,%r15d
   1a731:	vpmulld %ymm0,%ymm1,%ymm1
   1a736:	shl    $0x6,%r15
   1a73a:	vpsrld $0x1a,%ymm1,%ymm1
   1a73f:	vpmovzxdq %ymm1,%zmm1
   1a745:	vmovaps (%r14,%r15,1),%zmm2
   1a74c:	vpshufbitqmb %zmm1,%zmm2,%k0
   1a752:	shl    $0x6,%rbx
   1a756:	kmovq  %k0,%r15
   1a75b:	and    %r8,%r15
   1a75e:	xor    %ebp,%ebp
   1a760:	cmp    %r8,%r15
   1a763:	sete   %bpl
   1a767:	prefetcht0 (%r14,%rbx,1)
   1a76c:	mov    %ebp,(%rcx,%r10,4)
   1a770:	mov    0x18(%rdi),%ebx
   1a773:	mov    0x10c(%rdx,%r10,8),%r14d
   1a77b:	and    %ebx,%r14d
   1a77e:	mov    (%rdi),%r15
   1a781:	shl    $0x6,%r14
   1a785:	prefetcht0 (%r15,%r14,1)
   1a78a:	mov    0x8(%rdx,%r10,8),%r14
   1a78f:	vpbroadcastd %r14d,%ymm1
   1a795:	shr    $0x20,%r14
   1a799:	and    %ebx,%r14d
   1a79c:	shl    $0x6,%r14
   1a7a0:	vpmulld %ymm0,%ymm1,%ymm1
   1a7a5:	vpsrld $0x1a,%ymm1,%ymm1
   1a7aa:	vpmovzxdq %ymm1,%zmm1
   1a7b0:	vmovaps (%r15,%r14,1),%zmm2
   1a7b7:	vpshufbitqmb %zmm1,%zmm2,%k0
   1a7bd:	kmovq  %k0,%rbx
   1a7c2:	and    %r8,%rbx
   1a7c5:	xor    %ebp,%ebp
   1a7c7:	cmp    %r8,%rbx
   1a7ca:	sete   %bpl
   1a7ce:	mov    %ebp,0x4(%rcx,%r10,4)
   1a7d3:	add    $0x2,%r10
   1a7d7:	cmp    %r10,%r11
   1a7da:	jne    1a710 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<0>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<0>&, unsigned long, unsigned long const*, unsigned int*)+0x1f0>
   1a7e0:	test   %rsi,%rsi
   1a7e3:	je     1a84b <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<0>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<0>&, unsigned long, unsigned long const*, unsigned int*)+0x32b>
   1a7e5:	mov    0x18(%rdi),%esi
   1a7e8:	mov    0x104(%rdx,%r10,8),%r11d
   1a7f0:	and    %esi,%r11d
   1a7f3:	mov    (%rdi),%rbx
   1a7f6:	shl    $0x6,%r11
   1a7fa:	prefetcht0 (%rbx,%r11,1)
   1a7ff:	mov    (%rdx,%r10,8),%r11
   1a803:	vpbroadcastd %r11d,%ymm0
   1a809:	shr    $0x20,%r11
   1a80d:	and    %esi,%r11d
   1a810:	shl    $0x6,%r11
   1a814:	vpmulld -0x187bd(%rip),%ymm0,%ymm0        # 2060 <_IO_stdin_used+0x18>
   1a81d:	vpsrld $0x1a,%ymm0,%ymm0
   1a822:	vpmovzxdq %ymm0,%zmm0
   1a828:	vmovdqa64 (%rbx,%r11,1),%zmm1
   1a82f:	vpshufbitqmb %zmm0,%zmm1,%k0
   1a835:	kmovq  %k0,%rsi
   1a83a:	and    %r8,%rsi
   1a83d:	xor    %r11d,%r11d
   1a840:	cmp    %r8,%rsi
   1a843:	sete   %r11b
   1a847:	mov    %r11d,(%rcx,%r10,4)
   1a84b:	cmp    %rax,%r9
   1a84e:	jae    1a580 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<0>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<0>&, unsigned long, unsigned long const*, unsigned int*)+0x60>
   1a854:	vmovdqa -0x187fc(%rip),%ymm0        # 2060 <_IO_stdin_used+0x18>
   1a85c:	nopl   0x0(%rax)
   1a860:	mov    (%rdx,%r9,8),%rsi
   1a864:	mov    %rsi,%r10
   1a867:	shr    $0x20,%r10
   1a86b:	and    0x18(%rdi),%r10d
   1a86f:	vpbroadcastd %esi,%ymm1
   1a875:	mov    (%rdi),%rsi
   1a878:	shl    $0x6,%r10
   1a87c:	vpmulld %ymm0,%ymm1,%ymm1
   1a881:	vpsrld $0x1a,%ymm1,%ymm1
   1a886:	vpmovzxdq %ymm1,%zmm1
   1a88c:	vmovaps (%rsi,%r10,1),%zmm2
   1a893:	vpshufbitqmb %zmm1,%zmm2,%k0
   1a899:	kmovq  %k0,%rsi
   1a89e:	and    %r8,%rsi
   1a8a1:	xor    %r10d,%r10d
   1a8a4:	cmp    %r8,%rsi
   1a8a7:	sete   %r10b
   1a8ab:	mov    %r10d,(%rcx,%r9,4)
   1a8af:	inc    %r9
   1a8b2:	cmp    %r9,%rax
   1a8b5:	jne    1a860 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<0>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<0>&, unsigned long, unsigned long const*, unsigned int*)+0x340>
   1a8b7:	jmp    1a580 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<0>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<0>&, unsigned long, unsigned long const*, unsigned int*)+0x60>
   1a8bc:	int3
   1a8bd:	int3
   1a8be:	int3
   1a8bf:	int3

