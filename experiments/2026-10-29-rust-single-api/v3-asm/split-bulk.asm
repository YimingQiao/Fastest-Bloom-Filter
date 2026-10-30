0000000000076650 <fastest_bloom_filter_short_v3::split64::Split64BloomFilter::lookup_hashes_bulk>:
   76650:	55                   	push   %rbp
   76651:	41 57                	push   %r15
   76653:	41 56                	push   %r14
   76655:	53                   	push   %rbx
   76656:	50                   	push   %rax
   76657:	80 7f 1c 00          	cmpb   $0x0,0x1c(%rdi)
   7665b:	74 33                	je     76690 <fastest_bloom_filter_short_v3::split64::Split64BloomFilter::lookup_hashes_bulk+0x40>
   7665d:	48 83 fa 10          	cmp    $0x10,%rdx
   76661:	0f 83 3c 01 00 00    	jae    767a3 <fastest_bloom_filter_short_v3::split64::Split64BloomFilter::lookup_hashes_bulk+0x153>
   76667:	49 39 d0             	cmp    %rdx,%r8
   7666a:	49 0f 42 d0          	cmovb  %r8,%rdx
   7666e:	48 85 d2             	test   %rdx,%rdx
   76671:	0f 84 be 06 00 00    	je     76d35 <fastest_bloom_filter_short_v3::split64::Split64BloomFilter::lookup_hashes_bulk+0x6e5>
   76677:	48 8b 47 08          	mov    0x8(%rdi),%rax
   7667b:	8b 7f 18             	mov    0x18(%rdi),%edi
   7667e:	48 83 fa 01          	cmp    $0x1,%rdx
   76682:	0f 85 b0 02 00 00    	jne    76938 <fastest_bloom_filter_short_v3::split64::Split64BloomFilter::lookup_hashes_bulk+0x2e8>
   76688:	45 31 c9             	xor    %r9d,%r9d
   7668b:	e9 70 03 00 00       	jmp    76a00 <fastest_bloom_filter_short_v3::split64::Split64BloomFilter::lookup_hashes_bulk+0x3b0>
   76690:	80 7f 1d 00          	cmpb   $0x0,0x1d(%rdi)
   76694:	0f 84 f8 01 00 00    	je     76892 <fastest_bloom_filter_short_v3::split64::Split64BloomFilter::lookup_hashes_bulk+0x242>
   7669a:	31 c0                	xor    %eax,%eax
   7669c:	49 89 d1             	mov    %rdx,%r9
   7669f:	49 83 e9 20          	sub    $0x20,%r9
   766a3:	49 0f 43 c1          	cmovae %r9,%rax
   766a7:	4d 89 c1             	mov    %r8,%r9
   766aa:	49 29 c1             	sub    %rax,%r9
   766ad:	0f 82 90 06 00 00    	jb     76d43 <fastest_bloom_filter_short_v3::split64::Split64BloomFilter::lookup_hashes_bulk+0x6f3>
   766b3:	48 83 fa 21          	cmp    $0x21,%rdx
   766b7:	0f 82 b7 00 00 00    	jb     76774 <fastest_bloom_filter_short_v3::split64::Split64BloomFilter::lookup_hashes_bulk+0x124>
   766bd:	4c 8b 57 08          	mov    0x8(%rdi),%r10
   766c1:	44 8b 5f 18          	mov    0x18(%rdi),%r11d
   766c5:	41 b8 20 00 00 00    	mov    $0x20,%r8d
   766cb:	c5 fd 6f 05 0d 24 f9 	vmovdqa -0x6dbf3(%rip),%ymm0        # 8ae0 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x110>
   766d2:	ff 
   766d3:	c4 e2 7d 59 0d c4 22 	vpbroadcastq -0x6dd3c(%rip),%ymm1        # 89a0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x28b>
   766da:	f9 ff 
   766dc:	0f 1f 40 00          	nopl   0x0(%rax)
   766e0:	4c 39 c2             	cmp    %r8,%rdx
   766e3:	0f 84 97 06 00 00    	je     76d80 <fastest_bloom_filter_short_v3::split64::Split64BloomFilter::lookup_hashes_bulk+0x730>
   766e9:	4a 8b 9c c6 00 ff ff 	mov    -0x100(%rsi,%r8,8),%rbx
   766f0:	ff 
   766f1:	46 8b 74 c6 04       	mov    0x4(%rsi,%r8,8),%r14d
   766f6:	45 21 de             	and    %r11d,%r14d
   766f9:	49 c1 e6 06          	shl    $0x6,%r14
   766fd:	43 0f 18 0c 32       	prefetcht0 (%r10,%r14,1)
   76702:	62 f2 7d 28 7c d3    	vpbroadcastd %ebx,%ymm2
   76708:	48 c1 eb 20          	shr    $0x20,%rbx
   7670c:	44 21 db             	and    %r11d,%ebx
   7670f:	c4 e2 6d 40 d0       	vpmulld %ymm0,%ymm2,%ymm2
   76714:	48 c1 e3 06          	shl    $0x6,%rbx
   76718:	c5 ed 72 d2 1a       	vpsrld $0x1a,%ymm2,%ymm2
   7671d:	c4 e2 7d 35 da       	vpmovzxdq %xmm2,%ymm3
   76722:	c4 e2 f5 47 db       	vpsllvq %ymm3,%ymm1,%ymm3
   76727:	c4 e3 7d 39 d2 01    	vextracti128 $0x1,%ymm2,%xmm2
   7672d:	c4 e2 7d 35 d2       	vpmovzxdq %xmm2,%ymm2
   76732:	c4 e2 f5 47 d2       	vpsllvq %ymm2,%ymm1,%ymm2
   76737:	c4 c1 7d 6f 24 1a    	vmovdqa (%r10,%rbx,1),%ymm4
   7673d:	c4 e2 7d 17 e3       	vptest %ymm3,%ymm4
   76742:	40 0f 92 c5          	setb   %bpl
   76746:	c4 c1 7d 6f 5c 1a 20 	vmovdqa 0x20(%r10,%rbx,1),%ymm3
   7674d:	c4 e2 7d 17 da       	vptest %ymm2,%ymm3
   76752:	0f 92 c3             	setb   %bl
   76755:	40 20 eb             	and    %bpl,%bl
   76758:	0f b6 db             	movzbl %bl,%ebx
   7675b:	42 89 5c 81 80       	mov    %ebx,-0x80(%rcx,%r8,4)
   76760:	49 8d 58 01          	lea    0x1(%r8),%rbx
   76764:	49 83 c0 e1          	add    $0xffffffffffffffe1,%r8
   76768:	49 39 c0             	cmp    %rax,%r8
   7676b:	49 89 d8             	mov    %rbx,%r8
   7676e:	0f 82 6c ff ff ff    	jb     766e0 <fastest_bloom_filter_short_v3::split64::Split64BloomFilter::lookup_hashes_bulk+0x90>
   76774:	48 89 d3             	mov    %rdx,%rbx
   76777:	48 29 c3             	sub    %rax,%rbx
   7677a:	49 39 d9             	cmp    %rbx,%r9
   7677d:	4c 0f 43 cb          	cmovae %rbx,%r9
   76781:	4d 85 c9             	test   %r9,%r9
   76784:	0f 84 ab 05 00 00    	je     76d35 <fastest_bloom_filter_short_v3::split64::Split64BloomFilter::lookup_hashes_bulk+0x6e5>
   7678a:	4c 8b 47 08          	mov    0x8(%rdi),%r8
   7678e:	8b 7f 18             	mov    0x18(%rdi),%edi
   76791:	49 83 f9 01          	cmp    $0x1,%r9
   76795:	0f 85 be 02 00 00    	jne    76a59 <fastest_bloom_filter_short_v3::split64::Split64BloomFilter::lookup_hashes_bulk+0x409>
   7679b:	45 31 f6             	xor    %r14d,%r14d
   7679e:	e9 d3 03 00 00       	jmp    76b76 <fastest_bloom_filter_short_v3::split64::Split64BloomFilter::lookup_hashes_bulk+0x526>
   767a3:	31 c0                	xor    %eax,%eax
   767a5:	49 89 d1             	mov    %rdx,%r9
   767a8:	49 83 e9 20          	sub    $0x20,%r9
   767ac:	49 0f 43 c1          	cmovae %r9,%rax
   767b0:	4d 89 c1             	mov    %r8,%r9
   767b3:	49 29 c1             	sub    %rax,%r9
   767b6:	0f 82 9c 05 00 00    	jb     76d58 <fastest_bloom_filter_short_v3::split64::Split64BloomFilter::lookup_hashes_bulk+0x708>
   767bc:	48 83 fa 21          	cmp    $0x21,%rdx
   767c0:	0f 82 9e 00 00 00    	jb     76864 <fastest_bloom_filter_short_v3::split64::Split64BloomFilter::lookup_hashes_bulk+0x214>
   767c6:	4c 8b 57 08          	mov    0x8(%rdi),%r10
   767ca:	44 8b 5f 18          	mov    0x18(%rdi),%r11d
   767ce:	41 b8 20 00 00 00    	mov    $0x20,%r8d
   767d4:	c5 fd 6f 05 04 23 f9 	vmovdqa -0x6dcfc(%rip),%ymm0        # 8ae0 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x110>
   767db:	ff 
   767dc:	62 f2 fd 48 59 0d ba 	vpbroadcastq -0x6de46(%rip),%zmm1        # 89a0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x28b>
   767e3:	21 f9 ff 
   767e6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
   767ed:	00 00 00 
   767f0:	4c 39 c2             	cmp    %r8,%rdx
   767f3:	0f 84 a0 05 00 00    	je     76d99 <fastest_bloom_filter_short_v3::split64::Split64BloomFilter::lookup_hashes_bulk+0x749>
   767f9:	4a 8b 9c c6 00 ff ff 	mov    -0x100(%rsi,%r8,8),%rbx
   76800:	ff 
   76801:	46 8b 74 c6 04       	mov    0x4(%rsi,%r8,8),%r14d
   76806:	45 21 de             	and    %r11d,%r14d
   76809:	49 c1 e6 06          	shl    $0x6,%r14
   7680d:	43 0f 18 0c 32       	prefetcht0 (%r10,%r14,1)
   76812:	62 f2 7d 28 7c d3    	vpbroadcastd %ebx,%ymm2
   76818:	48 c1 eb 20          	shr    $0x20,%rbx
   7681c:	44 21 db             	and    %r11d,%ebx
   7681f:	48 c1 e3 06          	shl    $0x6,%rbx
   76823:	62 d1 fd 48 6f 1c 1a 	vmovdqa64 (%r10,%rbx,1),%zmm3
   7682a:	c4 e2 6d 40 d0       	vpmulld %ymm0,%ymm2,%ymm2
   7682f:	c5 ed 72 d2 1a       	vpsrld $0x1a,%ymm2,%ymm2
   76834:	62 f2 7d 48 35 d2    	vpmovzxdq %ymm2,%zmm2
   7683a:	62 f2 e5 48 45 d2    	vpsrlvq %zmm2,%zmm3,%zmm2
   76840:	62 f2 ee 48 27 c1    	vptestnmq %zmm1,%zmm2,%k0
   76846:	31 db                	xor    %ebx,%ebx
   76848:	c5 f9 98 c0          	kortestb %k0,%k0
   7684c:	0f 94 c3             	sete   %bl
   7684f:	42 89 5c 81 80       	mov    %ebx,-0x80(%rcx,%r8,4)
   76854:	49 8d 58 01          	lea    0x1(%r8),%rbx
   76858:	49 83 c0 e1          	add    $0xffffffffffffffe1,%r8
   7685c:	49 39 c0             	cmp    %rax,%r8
   7685f:	49 89 d8             	mov    %rbx,%r8
   76862:	72 8c                	jb     767f0 <fastest_bloom_filter_short_v3::split64::Split64BloomFilter::lookup_hashes_bulk+0x1a0>
   76864:	48 89 d3             	mov    %rdx,%rbx
   76867:	48 29 c3             	sub    %rax,%rbx
   7686a:	49 39 d9             	cmp    %rbx,%r9
   7686d:	4c 0f 43 cb          	cmovae %rbx,%r9
   76871:	4d 85 c9             	test   %r9,%r9
   76874:	0f 84 bb 04 00 00    	je     76d35 <fastest_bloom_filter_short_v3::split64::Split64BloomFilter::lookup_hashes_bulk+0x6e5>
   7687a:	4c 8b 47 08          	mov    0x8(%rdi),%r8
   7687e:	8b 7f 18             	mov    0x18(%rdi),%edi
   76881:	49 83 f9 01          	cmp    $0x1,%r9
   76885:	0f 85 6d 03 00 00    	jne    76bf8 <fastest_bloom_filter_short_v3::split64::Split64BloomFilter::lookup_hashes_bulk+0x5a8>
   7688b:	31 db                	xor    %ebx,%ebx
   7688d:	e9 4a 04 00 00       	jmp    76cdc <fastest_bloom_filter_short_v3::split64::Split64BloomFilter::lookup_hashes_bulk+0x68c>
   76892:	49 39 d0             	cmp    %rdx,%r8
   76895:	49 0f 42 d0          	cmovb  %r8,%rdx
   76899:	48 85 d2             	test   %rdx,%rdx
   7689c:	0f 84 93 04 00 00    	je     76d35 <fastest_bloom_filter_short_v3::split64::Split64BloomFilter::lookup_hashes_bulk+0x6e5>
   768a2:	44 8b 47 18          	mov    0x18(%rdi),%r8d
   768a6:	4c 8b 4f 08          	mov    0x8(%rdi),%r9
   768aa:	48 8b 47 10          	mov    0x10(%rdi),%rax
   768ae:	45 31 d2             	xor    %r10d,%r10d
   768b1:	62 f1 fd 48 6f 05 c5 	vmovdqa64 -0x6a53b(%rip),%zmm0        # c380 <anon.b245d78d28829f835f48a10d63243492.0.llvm.14563942429929576898+0x970>
   768b8:	5a f9 ff 
   768bb:	62 f2 fd 48 59 0d 4b 	vpbroadcastq -0x6deb5(%rip),%zmm1        # 8a10 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x40>
   768c2:	21 f9 ff 
   768c5:	62 f2 fd 48 59 15 d1 	vpbroadcastq -0x6df2f(%rip),%zmm2        # 89a0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x28b>
   768cc:	20 f9 ff 
   768cf:	90                   	nop
   768d0:	4e 8b 1c d6          	mov    (%rsi,%r10,8),%r11
   768d4:	4c 89 df             	mov    %r11,%rdi
   768d7:	48 c1 ef 20          	shr    $0x20,%rdi
   768db:	44 21 c7             	and    %r8d,%edi
   768de:	48 39 f8             	cmp    %rdi,%rax
   768e1:	0f 86 86 04 00 00    	jbe    76d6d <fastest_bloom_filter_short_v3::split64::Split64BloomFilter::lookup_hashes_bulk+0x71d>
   768e7:	62 d2 fd 48 7c db    	vpbroadcastq %r11,%zmm3
   768ed:	62 f2 e5 48 40 d8    	vpmullq %zmm0,%zmm3,%zmm3
   768f3:	48 c1 e7 06          	shl    $0x6,%rdi
   768f7:	62 f1 e5 48 73 d3 1a 	vpsrlq $0x1a,%zmm3,%zmm3
   768fe:	62 f1 e5 48 db d9    	vpandq %zmm1,%zmm3,%zmm3
   76904:	62 f2 ed 48 47 db    	vpsllvq %zmm3,%zmm2,%zmm3
   7690a:	62 d1 fe 48 6f 24 39 	vmovdqu64 (%r9,%rdi,1),%zmm4
   76911:	62 f1 dd 48 df db    	vpandnq %zmm3,%zmm4,%zmm3
   76917:	62 f2 65 48 27 c3    	vptestmd %zmm3,%zmm3,%k0
   7691d:	31 ff                	xor    %edi,%edi
   7691f:	c5 f8 98 c0          	kortestw %k0,%k0
   76923:	40 0f 94 c7          	sete   %dil
   76927:	42 89 3c 91          	mov    %edi,(%rcx,%r10,4)
   7692b:	49 ff c2             	inc    %r10
   7692e:	4c 39 d2             	cmp    %r10,%rdx
   76931:	75 9d                	jne    768d0 <fastest_bloom_filter_short_v3::split64::Split64BloomFilter::lookup_hashes_bulk+0x280>
   76933:	e9 fd 03 00 00       	jmp    76d35 <fastest_bloom_filter_short_v3::split64::Split64BloomFilter::lookup_hashes_bulk+0x6e5>
   76938:	41 89 d0             	mov    %edx,%r8d
   7693b:	41 83 e0 0e          	and    $0xe,%r8d
   7693f:	45 31 d2             	xor    %r10d,%r10d
   76942:	62 f1 fd 48 6f 05 34 	vmovdqa64 -0x6a5cc(%rip),%zmm0        # c380 <anon.b245d78d28829f835f48a10d63243492.0.llvm.14563942429929576898+0x970>
   76949:	5a f9 ff 
   7694c:	62 f2 fd 48 59 0d 4a 	vpbroadcastq -0x6dfb6(%rip),%zmm1        # 89a0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x28b>
   76953:	20 f9 ff 
   76956:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
   7695d:	00 00 00 
   76960:	4e 8b 0c d6          	mov    (%rsi,%r10,8),%r9
   76964:	45 89 cb             	mov    %r9d,%r11d
   76967:	49 c1 e9 20          	shr    $0x20,%r9
   7696b:	41 21 f9             	and    %edi,%r9d
   7696e:	49 c1 e1 06          	shl    $0x6,%r9
   76972:	62 d2 fd 48 7c d3    	vpbroadcastq %r11,%zmm2
   76978:	62 f2 6d 48 40 d0    	vpmulld %zmm0,%zmm2,%zmm2
   7697e:	62 b1 fd 48 6f 1c 08 	vmovdqa64 (%rax,%r9,1),%zmm3
   76985:	62 f1 ed 48 73 d2 1a 	vpsrlq $0x1a,%zmm2,%zmm2
   7698c:	62 f2 e5 48 45 d2    	vpsrlvq %zmm2,%zmm3,%zmm2
   76992:	62 f2 ee 48 27 c1    	vptestnmq %zmm1,%zmm2,%k0
   76998:	45 31 c9             	xor    %r9d,%r9d
   7699b:	c5 f9 98 c0          	kortestb %k0,%k0
   7699f:	41 0f 94 c1          	sete   %r9b
   769a3:	46 89 0c 91          	mov    %r9d,(%rcx,%r10,4)
   769a7:	4d 8d 4a 02          	lea    0x2(%r10),%r9
   769ab:	4e 8b 5c d6 08       	mov    0x8(%rsi,%r10,8),%r11
   769b0:	44 89 db             	mov    %r11d,%ebx
   769b3:	49 c1 eb 20          	shr    $0x20,%r11
   769b7:	41 21 fb             	and    %edi,%r11d
   769ba:	49 c1 e3 06          	shl    $0x6,%r11
   769be:	62 b1 fd 48 6f 14 18 	vmovdqa64 (%rax,%r11,1),%zmm2
   769c5:	62 f2 fd 48 7c db    	vpbroadcastq %rbx,%zmm3
   769cb:	62 f2 65 48 40 d8    	vpmulld %zmm0,%zmm3,%zmm3
   769d1:	62 f1 e5 48 73 d3 1a 	vpsrlq $0x1a,%zmm3,%zmm3
   769d8:	62 f2 ed 48 45 d3    	vpsrlvq %zmm3,%zmm2,%zmm2
   769de:	62 f2 ee 48 27 c1    	vptestnmq %zmm1,%zmm2,%k0
   769e4:	45 31 db             	xor    %r11d,%r11d
   769e7:	c5 f9 98 c0          	kortestb %k0,%k0
   769eb:	41 0f 94 c3          	sete   %r11b
   769ef:	46 89 5c 91 04       	mov    %r11d,0x4(%rcx,%r10,4)
   769f4:	4d 89 ca             	mov    %r9,%r10
   769f7:	4d 39 c8             	cmp    %r9,%r8
   769fa:	0f 85 60 ff ff ff    	jne    76960 <fastest_bloom_filter_short_v3::split64::Split64BloomFilter::lookup_hashes_bulk+0x310>
   76a00:	f6 c2 01             	test   $0x1,%dl
   76a03:	0f 84 2c 03 00 00    	je     76d35 <fastest_bloom_filter_short_v3::split64::Split64BloomFilter::lookup_hashes_bulk+0x6e5>
   76a09:	4a 8b 14 ce          	mov    (%rsi,%r9,8),%rdx
   76a0d:	89 d6                	mov    %edx,%esi
   76a0f:	48 c1 ea 20          	shr    $0x20,%rdx
   76a13:	21 d7                	and    %edx,%edi
   76a15:	62 f2 fd 48 7c c6    	vpbroadcastq %rsi,%zmm0
   76a1b:	62 f2 7d 48 40 05 5b 	vpmulld -0x6a6a5(%rip),%zmm0,%zmm0        # c380 <anon.b245d78d28829f835f48a10d63243492.0.llvm.14563942429929576898+0x970>
   76a22:	59 f9 ff 
   76a25:	48 c1 e7 06          	shl    $0x6,%rdi
   76a29:	62 f1 fd 48 6f 0c 38 	vmovdqa64 (%rax,%rdi,1),%zmm1
   76a30:	62 f1 fd 48 73 d0 1a 	vpsrlq $0x1a,%zmm0,%zmm0
   76a37:	62 f2 f5 48 45 c0    	vpsrlvq %zmm0,%zmm1,%zmm0
   76a3d:	62 f2 fe 58 27 05 59 	vptestnmq -0x6e0a7(%rip){1to8},%zmm0,%k0        # 89a0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x28b>
   76a44:	1f f9 ff 
   76a47:	31 c0                	xor    %eax,%eax
   76a49:	c5 f9 98 c0          	kortestb %k0,%k0
   76a4d:	0f 94 c0             	sete   %al
   76a50:	42 89 04 89          	mov    %eax,(%rcx,%r9,4)
   76a54:	e9 dc 02 00 00       	jmp    76d35 <fastest_bloom_filter_short_v3::split64::Split64BloomFilter::lookup_hashes_bulk+0x6e5>
   76a59:	4d 89 ca             	mov    %r9,%r10
   76a5c:	49 83 e2 fe          	and    $0xfffffffffffffffe,%r10
   76a60:	4c 8d 34 dd 00 00 00 	lea    0x0(,%rbx,8),%r14
   76a67:	00 
   76a68:	4c 8d 1c d6          	lea    (%rsi,%rdx,8),%r11
   76a6c:	4d 29 f3             	sub    %r14,%r11
   76a6f:	49 83 c3 08          	add    $0x8,%r11
   76a73:	48 c1 e3 02          	shl    $0x2,%rbx
   76a77:	48 8d 14 91          	lea    (%rcx,%rdx,4),%rdx
   76a7b:	48 29 da             	sub    %rbx,%rdx
   76a7e:	48 83 c2 04          	add    $0x4,%rdx
   76a82:	31 db                	xor    %ebx,%ebx
   76a84:	c5 fd 6f 05 54 20 f9 	vmovdqa -0x6dfac(%rip),%ymm0        # 8ae0 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x110>
   76a8b:	ff 
   76a8c:	c4 e2 7d 59 0d 0b 1f 	vpbroadcastq -0x6e0f5(%rip),%ymm1        # 89a0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x28b>
   76a93:	f9 ff 
   76a95:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
   76a9c:	00 00 00 00 
   76aa0:	4d 8b 74 db f8       	mov    -0x8(%r11,%rbx,8),%r14
   76aa5:	62 d2 7d 28 7c d6    	vpbroadcastd %r14d,%ymm2
   76aab:	49 c1 ee 20          	shr    $0x20,%r14
   76aaf:	41 21 fe             	and    %edi,%r14d
   76ab2:	49 c1 e6 06          	shl    $0x6,%r14
   76ab6:	c4 e2 6d 40 d0       	vpmulld %ymm0,%ymm2,%ymm2
   76abb:	c5 ed 72 d2 1a       	vpsrld $0x1a,%ymm2,%ymm2
   76ac0:	c4 e2 7d 35 da       	vpmovzxdq %xmm2,%ymm3
   76ac5:	c4 e2 f5 47 db       	vpsllvq %ymm3,%ymm1,%ymm3
   76aca:	c4 e3 7d 39 d2 01    	vextracti128 $0x1,%ymm2,%xmm2
   76ad0:	c4 e2 7d 35 d2       	vpmovzxdq %xmm2,%ymm2
   76ad5:	c4 e2 f5 47 d2       	vpsllvq %ymm2,%ymm1,%ymm2
   76ada:	c4 81 7d 6f 24 30    	vmovdqa (%r8,%r14,1),%ymm4
   76ae0:	c4 81 7d 6f 6c 30 20 	vmovdqa 0x20(%r8,%r14,1),%ymm5
   76ae7:	c4 e2 7d 17 e3       	vptest %ymm3,%ymm4
   76aec:	40 0f 92 c5          	setb   %bpl
   76af0:	c4 e2 7d 17 ea       	vptest %ymm2,%ymm5
   76af5:	41 0f 92 c6          	setb   %r14b
   76af9:	41 20 ee             	and    %bpl,%r14b
   76afc:	41 0f b6 ee          	movzbl %r14b,%ebp
   76b00:	89 6c 9a fc          	mov    %ebp,-0x4(%rdx,%rbx,4)
   76b04:	4d 8b 34 db          	mov    (%r11,%rbx,8),%r14
   76b08:	62 d2 7d 28 7c d6    	vpbroadcastd %r14d,%ymm2
   76b0e:	49 c1 ee 20          	shr    $0x20,%r14
   76b12:	41 21 fe             	and    %edi,%r14d
   76b15:	49 c1 e6 06          	shl    $0x6,%r14
   76b19:	c4 e2 6d 40 d0       	vpmulld %ymm0,%ymm2,%ymm2
   76b1e:	c5 ed 72 d2 1a       	vpsrld $0x1a,%ymm2,%ymm2
   76b23:	c4 e2 7d 35 da       	vpmovzxdq %xmm2,%ymm3
   76b28:	c4 e2 f5 47 db       	vpsllvq %ymm3,%ymm1,%ymm3
   76b2d:	c4 e3 7d 39 d2 01    	vextracti128 $0x1,%ymm2,%xmm2
   76b33:	c4 e2 7d 35 d2       	vpmovzxdq %xmm2,%ymm2
   76b38:	c4 e2 f5 47 d2       	vpsllvq %ymm2,%ymm1,%ymm2
   76b3d:	c4 81 7d 6f 24 30    	vmovdqa (%r8,%r14,1),%ymm4
   76b43:	c4 81 7d 6f 6c 30 20 	vmovdqa 0x20(%r8,%r14,1),%ymm5
   76b4a:	c4 e2 7d 17 e3       	vptest %ymm3,%ymm4
   76b4f:	40 0f 92 c5          	setb   %bpl
   76b53:	c4 e2 7d 17 ea       	vptest %ymm2,%ymm5
   76b58:	41 0f 92 c7          	setb   %r15b
   76b5c:	4c 8d 73 02          	lea    0x2(%rbx),%r14
   76b60:	41 20 ef             	and    %bpl,%r15b
   76b63:	41 0f b6 ef          	movzbl %r15b,%ebp
   76b67:	89 2c 9a             	mov    %ebp,(%rdx,%rbx,4)
   76b6a:	4c 89 f3             	mov    %r14,%rbx
   76b6d:	4d 39 f2             	cmp    %r14,%r10
   76b70:	0f 85 2a ff ff ff    	jne    76aa0 <fastest_bloom_filter_short_v3::split64::Split64BloomFilter::lookup_hashes_bulk+0x450>
   76b76:	41 f6 c1 01          	test   $0x1,%r9b
   76b7a:	0f 84 b5 01 00 00    	je     76d35 <fastest_bloom_filter_short_v3::split64::Split64BloomFilter::lookup_hashes_bulk+0x6e5>
   76b80:	48 8d 14 c6          	lea    (%rsi,%rax,8),%rdx
   76b84:	48 8d 04 81          	lea    (%rcx,%rax,4),%rax
   76b88:	4a 8b 0c f2          	mov    (%rdx,%r14,8),%rcx
   76b8c:	62 f2 7d 28 7c c1    	vpbroadcastd %ecx,%ymm0
   76b92:	48 c1 e9 20          	shr    $0x20,%rcx
   76b96:	21 cf                	and    %ecx,%edi
   76b98:	48 c1 e7 06          	shl    $0x6,%rdi
   76b9c:	c4 e2 7d 40 05 3b 1f 	vpmulld -0x6e0c5(%rip),%ymm0,%ymm0        # 8ae0 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x110>
   76ba3:	f9 ff 
   76ba5:	c5 fd 72 d0 1a       	vpsrld $0x1a,%ymm0,%ymm0
   76baa:	c4 e2 7d 35 c8       	vpmovzxdq %xmm0,%ymm1
   76baf:	c4 e2 7d 59 15 e8 1d 	vpbroadcastq -0x6e218(%rip),%ymm2        # 89a0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x28b>
   76bb6:	f9 ff 
   76bb8:	c4 e2 ed 47 c9       	vpsllvq %ymm1,%ymm2,%ymm1
   76bbd:	c4 e3 7d 39 c0 01    	vextracti128 $0x1,%ymm0,%xmm0
   76bc3:	c4 e2 7d 35 c0       	vpmovzxdq %xmm0,%ymm0
   76bc8:	c4 e2 ed 47 c0       	vpsllvq %ymm0,%ymm2,%ymm0
   76bcd:	c4 c1 7d 6f 14 38    	vmovdqa (%r8,%rdi,1),%ymm2
   76bd3:	c4 c1 7d 6f 5c 38 20 	vmovdqa 0x20(%r8,%rdi,1),%ymm3
   76bda:	c4 e2 7d 17 d1       	vptest %ymm1,%ymm2
   76bdf:	0f 92 c1             	setb   %cl
   76be2:	c4 e2 7d 17 d8       	vptest %ymm0,%ymm3
   76be7:	0f 92 c2             	setb   %dl
   76bea:	20 ca                	and    %cl,%dl
   76bec:	0f b6 ca             	movzbl %dl,%ecx
   76bef:	42 89 0c b0          	mov    %ecx,(%rax,%r14,4)
   76bf3:	e9 3d 01 00 00       	jmp    76d35 <fastest_bloom_filter_short_v3::split64::Split64BloomFilter::lookup_hashes_bulk+0x6e5>
   76bf8:	4d 89 ca             	mov    %r9,%r10
   76bfb:	49 83 e2 fe          	and    $0xfffffffffffffffe,%r10
   76bff:	4c 8d 34 dd 00 00 00 	lea    0x0(,%rbx,8),%r14
   76c06:	00 
   76c07:	4c 8d 1c d6          	lea    (%rsi,%rdx,8),%r11
   76c0b:	4d 29 f3             	sub    %r14,%r11
   76c0e:	49 83 c3 08          	add    $0x8,%r11
   76c12:	48 c1 e3 02          	shl    $0x2,%rbx
   76c16:	48 8d 14 91          	lea    (%rcx,%rdx,4),%rdx
   76c1a:	48 29 da             	sub    %rbx,%rdx
   76c1d:	48 83 c2 04          	add    $0x4,%rdx
   76c21:	45 31 f6             	xor    %r14d,%r14d
   76c24:	c5 fd 6f 05 b4 1e f9 	vmovdqa -0x6e14c(%rip),%ymm0        # 8ae0 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x110>
   76c2b:	ff 
   76c2c:	62 f2 fd 48 59 0d 6a 	vpbroadcastq -0x6e296(%rip),%zmm1        # 89a0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x28b>
   76c33:	1d f9 ff 
   76c36:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
   76c3d:	00 00 00 
   76c40:	4b 8b 5c f3 f8       	mov    -0x8(%r11,%r14,8),%rbx
   76c45:	62 f2 7d 28 7c d3    	vpbroadcastd %ebx,%ymm2
   76c4b:	48 c1 eb 20          	shr    $0x20,%rbx
   76c4f:	21 fb                	and    %edi,%ebx
   76c51:	48 c1 e3 06          	shl    $0x6,%rbx
   76c55:	62 d1 fd 48 6f 1c 18 	vmovdqa64 (%r8,%rbx,1),%zmm3
   76c5c:	c4 e2 6d 40 d0       	vpmulld %ymm0,%ymm2,%ymm2
   76c61:	c5 ed 72 d2 1a       	vpsrld $0x1a,%ymm2,%ymm2
   76c66:	62 f2 7d 48 35 d2    	vpmovzxdq %ymm2,%zmm2
   76c6c:	62 f2 e5 48 45 d2    	vpsrlvq %zmm2,%zmm3,%zmm2
   76c72:	62 f2 ee 48 27 c1    	vptestnmq %zmm1,%zmm2,%k0
   76c78:	31 db                	xor    %ebx,%ebx
   76c7a:	c5 f9 98 c0          	kortestb %k0,%k0
   76c7e:	0f 94 c3             	sete   %bl
   76c81:	42 89 5c b2 fc       	mov    %ebx,-0x4(%rdx,%r14,4)
   76c86:	49 8d 5e 02          	lea    0x2(%r14),%rbx
   76c8a:	4f 8b 3c f3          	mov    (%r11,%r14,8),%r15
   76c8e:	62 d2 7d 28 7c d7    	vpbroadcastd %r15d,%ymm2
   76c94:	49 c1 ef 20          	shr    $0x20,%r15
   76c98:	41 21 ff             	and    %edi,%r15d
   76c9b:	49 c1 e7 06          	shl    $0x6,%r15
   76c9f:	c4 e2 6d 40 d0       	vpmulld %ymm0,%ymm2,%ymm2
   76ca4:	62 91 fd 48 6f 1c 38 	vmovdqa64 (%r8,%r15,1),%zmm3
   76cab:	c5 ed 72 d2 1a       	vpsrld $0x1a,%ymm2,%ymm2
   76cb0:	62 f2 7d 48 35 d2    	vpmovzxdq %ymm2,%zmm2
   76cb6:	62 f2 e5 48 45 d2    	vpsrlvq %zmm2,%zmm3,%zmm2
   76cbc:	62 f2 ee 48 27 c1    	vptestnmq %zmm1,%zmm2,%k0
   76cc2:	31 ed                	xor    %ebp,%ebp
   76cc4:	c5 f9 98 c0          	kortestb %k0,%k0
   76cc8:	40 0f 94 c5          	sete   %bpl
   76ccc:	42 89 2c b2          	mov    %ebp,(%rdx,%r14,4)
   76cd0:	49 89 de             	mov    %rbx,%r14
   76cd3:	49 39 da             	cmp    %rbx,%r10
   76cd6:	0f 85 64 ff ff ff    	jne    76c40 <fastest_bloom_filter_short_v3::split64::Split64BloomFilter::lookup_hashes_bulk+0x5f0>
   76cdc:	41 f6 c1 01          	test   $0x1,%r9b
   76ce0:	74 53                	je     76d35 <fastest_bloom_filter_short_v3::split64::Split64BloomFilter::lookup_hashes_bulk+0x6e5>
   76ce2:	48 8d 14 c6          	lea    (%rsi,%rax,8),%rdx
   76ce6:	48 8d 04 81          	lea    (%rcx,%rax,4),%rax
   76cea:	48 8b 0c da          	mov    (%rdx,%rbx,8),%rcx
   76cee:	62 f2 7d 28 7c c1    	vpbroadcastd %ecx,%ymm0
   76cf4:	48 c1 e9 20          	shr    $0x20,%rcx
   76cf8:	21 cf                	and    %ecx,%edi
   76cfa:	48 c1 e7 06          	shl    $0x6,%rdi
   76cfe:	c4 e2 7d 40 05 d9 1d 	vpmulld -0x6e227(%rip),%ymm0,%ymm0        # 8ae0 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x110>
   76d05:	f9 ff 
   76d07:	62 d1 fd 48 6f 0c 38 	vmovdqa64 (%r8,%rdi,1),%zmm1
   76d0e:	c5 fd 72 d0 1a       	vpsrld $0x1a,%ymm0,%ymm0
   76d13:	62 f2 7d 48 35 c0    	vpmovzxdq %ymm0,%zmm0
   76d19:	62 f2 f5 48 45 c0    	vpsrlvq %zmm0,%zmm1,%zmm0
   76d1f:	62 f2 fe 58 27 05 77 	vptestnmq -0x6e389(%rip){1to8},%zmm0,%k0        # 89a0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x28b>
   76d26:	1c f9 ff 
   76d29:	31 c9                	xor    %ecx,%ecx
   76d2b:	c5 f9 98 c0          	kortestb %k0,%k0
   76d2f:	0f 94 c1             	sete   %cl
   76d32:	89 0c 98             	mov    %ecx,(%rax,%rbx,4)
   76d35:	48 83 c4 08          	add    $0x8,%rsp
   76d39:	5b                   	pop    %rbx
   76d3a:	41 5e                	pop    %r14
   76d3c:	41 5f                	pop    %r15
   76d3e:	5d                   	pop    %rbp
   76d3f:	c5 f8 77             	vzeroupper
   76d42:	c3                   	ret
   76d43:	48 8d 0d 56 f6 03 00 	lea    0x3f656(%rip),%rcx        # b63a0 <anon.abf104a84019cbc1bb0d904df564a1ce.60.llvm.13157284832119116749+0x178>
   76d4a:	31 ff                	xor    %edi,%edi
   76d4c:	48 89 c6             	mov    %rax,%rsi
   76d4f:	4c 89 c2             	mov    %r8,%rdx
   76d52:	ff 15 b0 19 04 00    	call   *0x419b0(%rip)        # b8708 <_DYNAMIC+0x2f0>
   76d58:	48 8d 0d 89 f6 03 00 	lea    0x3f689(%rip),%rcx        # b63e8 <anon.abf104a84019cbc1bb0d904df564a1ce.60.llvm.13157284832119116749+0x1c0>
   76d5f:	31 ff                	xor    %edi,%edi
   76d61:	48 89 c6             	mov    %rax,%rsi
   76d64:	4c 89 c2             	mov    %r8,%rdx
   76d67:	ff 15 9b 19 04 00    	call   *0x4199b(%rip)        # b8708 <_DYNAMIC+0x2f0>
   76d6d:	48 8d 15 a4 f6 03 00 	lea    0x3f6a4(%rip),%rdx        # b6418 <anon.abf104a84019cbc1bb0d904df564a1ce.60.llvm.13157284832119116749+0x1f0>
   76d74:	48 89 c6             	mov    %rax,%rsi
   76d77:	c5 f8 77             	vzeroupper
   76d7a:	ff 15 f8 18 04 00    	call   *0x418f8(%rip)        # b8678 <_DYNAMIC+0x260>
   76d80:	48 8d 05 31 f6 03 00 	lea    0x3f631(%rip),%rax        # b63b8 <anon.abf104a84019cbc1bb0d904df564a1ce.60.llvm.13157284832119116749+0x190>
   76d87:	4c 89 c7             	mov    %r8,%rdi
   76d8a:	48 89 d6             	mov    %rdx,%rsi
   76d8d:	48 89 c2             	mov    %rax,%rdx
   76d90:	c5 f8 77             	vzeroupper
   76d93:	ff 15 df 18 04 00    	call   *0x418df(%rip)        # b8678 <_DYNAMIC+0x260>
   76d99:	48 8d 05 60 f6 03 00 	lea    0x3f660(%rip),%rax        # b6400 <anon.abf104a84019cbc1bb0d904df564a1ce.60.llvm.13157284832119116749+0x1d8>
   76da0:	4c 89 c7             	mov    %r8,%rdi
   76da3:	48 89 d6             	mov    %rdx,%rsi
   76da6:	48 89 c2             	mov    %rax,%rdx
   76da9:	c5 f8 77             	vzeroupper
   76dac:	ff 15 c6 18 04 00    	call   *0x418c6(%rip)        # b8678 <_DYNAMIC+0x260>
   76db2:	cc                   	int3
   76db3:	cc                   	int3
   76db4:	cc                   	int3
   76db5:	cc                   	int3
   76db6:	cc                   	int3
   76db7:	cc                   	int3
   76db8:	cc                   	int3
   76db9:	cc                   	int3
   76dba:	cc                   	int3
   76dbb:	cc                   	int3
   76dbc:	cc                   	int3
   76dbd:	cc                   	int3
   76dbe:	cc                   	int3
   76dbf:	cc                   	int3

