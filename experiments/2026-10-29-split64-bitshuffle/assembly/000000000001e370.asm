000000000001e370 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<1>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<1>&, unsigned long, unsigned long const*, unsigned int*)>:
   1e370:	push   %rbp
   1e371:	push   %r15
   1e373:	push   %r14
   1e375:	push   %rbx
   1e376:	cmp    $0x1,%esi
   1e379:	jne    1e3da <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<1>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<1>&, unsigned long, unsigned long const*, unsigned int*)+0x6a>
   1e37b:	mov    (%rdx),%rax
   1e37e:	vpbroadcastd %eax,%ymm0
   1e384:	shr    $0x20,%rax
   1e388:	and    0x18(%rdi),%eax
   1e38b:	mov    (%rdi),%rdx
   1e38e:	shl    $0x6,%rax
   1e392:	vpmulld -0x1c37b(%rip),%ymm0,%ymm0        # 2020 <_IO_stdin_used+0x18>
   1e39b:	vpsrld $0x1a,%ymm0,%ymm0
   1e3a0:	vpmovzxdq %ymm0,%zmm0
   1e3a6:	vmovdqa64 (%rdx,%rax,1),%zmm1
   1e3ad:	vpshufbitqmb %zmm0,%zmm1,%k0
   1e3b3:	kmovq  %k0,%rax
   1e3b8:	movabs $0x101010101010101,%rdx
   1e3c2:	and    %rdx,%rax
   1e3c5:	xor    %esi,%esi
   1e3c7:	cmp    %rdx,%rax
   1e3ca:	sete   %sil
   1e3ce:	mov    %esi,(%rcx)
   1e3d0:	pop    %rbx
   1e3d1:	pop    %r14
   1e3d3:	pop    %r15
   1e3d5:	pop    %rbp
   1e3d6:	vzeroupper
   1e3d9:	ret
   1e3da:	mov    %esi,%eax
   1e3dc:	cmp    $0x10,%esi
   1e3df:	jae    1e3fb <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<1>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<1>&, unsigned long, unsigned long const*, unsigned int*)+0x8b>
   1e3e1:	test   %esi,%esi
   1e3e3:	je     1e3d0 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<1>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<1>&, unsigned long, unsigned long const*, unsigned int*)+0x60>
   1e3e5:	movabs $0x101010101010101,%r8
   1e3ef:	cmp    $0x1,%eax
   1e3f2:	jne    1e428 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<1>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<1>&, unsigned long, unsigned long const*, unsigned int*)+0xb8>
   1e3f4:	xor    %eax,%eax
   1e3f6:	jmp    1e4f1 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<1>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<1>&, unsigned long, unsigned long const*, unsigned int*)+0x181>
   1e3fb:	movabs $0x101010101010101,%r8
   1e405:	cmp    $0x21,%esi
   1e408:	jb     1e420 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<1>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<1>&, unsigned long, unsigned long const*, unsigned int*)+0xb0>
   1e40a:	lea    -0x20(%rax),%r9
   1e40e:	cmp    $0x21,%rax
   1e412:	jne    1e546 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<1>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<1>&, unsigned long, unsigned long const*, unsigned int*)+0x1d6>
   1e418:	xor    %r10d,%r10d
   1e41b:	jmp    1e635 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<1>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<1>&, unsigned long, unsigned long const*, unsigned int*)+0x2c5>
   1e420:	xor    %r9d,%r9d
   1e423:	jmp    1e69b <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<1>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<1>&, unsigned long, unsigned long const*, unsigned int*)+0x32b>
   1e428:	mov    %esi,%r9d
   1e42b:	and    $0xe,%r9d
   1e42f:	xor    %eax,%eax
   1e431:	vmovdqa -0x1c419(%rip),%ymm0        # 2020 <_IO_stdin_used+0x18>
   1e439:	nopl   0x0(%rax)
   1e440:	mov    (%rdx,%rax,8),%r10
   1e444:	vpbroadcastd %r10d,%ymm1
   1e44a:	shr    $0x20,%r10
   1e44e:	and    0x18(%rdi),%r10d
   1e452:	mov    (%rdi),%r11
   1e455:	shl    $0x6,%r10
   1e459:	vpmulld %ymm0,%ymm1,%ymm1
   1e45e:	vpsrld $0x1a,%ymm1,%ymm1
   1e463:	vpmovzxdq %ymm1,%zmm1
   1e469:	vmovaps (%r11,%r10,1),%zmm2
   1e470:	vpshufbitqmb %zmm1,%zmm2,%k0
   1e476:	kmovq  %k0,%r10
   1e47b:	and    %r8,%r10
   1e47e:	xor    %r11d,%r11d
   1e481:	cmp    %r8,%r10
   1e484:	sete   %r11b
   1e488:	mov    %r11d,(%rcx,%rax,4)
   1e48c:	mov    0x8(%rdx,%rax,8),%r10
   1e491:	vpbroadcastd %r10d,%ymm1
   1e497:	shr    $0x20,%r10
   1e49b:	and    0x18(%rdi),%r10d
   1e49f:	mov    (%rdi),%r11
   1e4a2:	shl    $0x6,%r10
   1e4a6:	vpmulld %ymm0,%ymm1,%ymm1
   1e4ab:	vpsrld $0x1a,%ymm1,%ymm1
   1e4b0:	vpmovzxdq %ymm1,%zmm1
   1e4b6:	vmovaps (%r11,%r10,1),%zmm2
   1e4bd:	vpshufbitqmb %zmm1,%zmm2,%k0
   1e4c3:	kmovq  %k0,%r10
   1e4c8:	and    %r8,%r10
   1e4cb:	xor    %r11d,%r11d
   1e4ce:	cmp    %r8,%r10
   1e4d1:	sete   %r11b
   1e4d5:	mov    %r11d,0x4(%rcx,%rax,4)
   1e4da:	add    $0x2,%rax
   1e4de:	cmp    %rax,%r9
   1e4e1:	jne    1e440 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<1>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<1>&, unsigned long, unsigned long const*, unsigned int*)+0xd0>
   1e4e7:	test   $0x1,%sil
   1e4eb:	je     1e3d0 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<1>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<1>&, unsigned long, unsigned long const*, unsigned int*)+0x60>
   1e4f1:	mov    (%rdx,%rax,8),%rdx
   1e4f5:	mov    %rdx,%rsi
   1e4f8:	shr    $0x20,%rsi
   1e4fc:	and    0x18(%rdi),%esi
   1e4ff:	vpbroadcastd %edx,%ymm0
   1e505:	mov    (%rdi),%rdx
   1e508:	shl    $0x6,%rsi
   1e50c:	vpmulld -0x1c4f5(%rip),%ymm0,%ymm0        # 2020 <_IO_stdin_used+0x18>
   1e515:	vpsrld $0x1a,%ymm0,%ymm0
   1e51a:	vpmovzxdq %ymm0,%zmm0
   1e520:	vmovdqa64 (%rdx,%rsi,1),%zmm1
   1e527:	vpshufbitqmb %zmm0,%zmm1,%k0
   1e52d:	kmovq  %k0,%rdx
   1e532:	and    %r8,%rdx
   1e535:	xor    %esi,%esi
   1e537:	cmp    %r8,%rdx
   1e53a:	sete   %sil
   1e53e:	mov    %esi,(%rcx,%rax,4)
   1e541:	jmp    1e3d0 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<1>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<1>&, unsigned long, unsigned long const*, unsigned int*)+0x60>
   1e546:	and    $0x1,%esi
   1e549:	mov    %r9,%r11
   1e54c:	sub    %rsi,%r11
   1e54f:	xor    %r10d,%r10d
   1e552:	vmovdqa -0x1c53a(%rip),%ymm0        # 2020 <_IO_stdin_used+0x18>
   1e55a:	nopw   0x0(%rax,%rax,1)
   1e560:	mov    0x18(%rdi),%ebp
   1e563:	mov    0x104(%rdx,%r10,8),%ebx
   1e56b:	and    %ebp,%ebx
   1e56d:	mov    (%rdi),%r14
   1e570:	mov    (%rdx,%r10,8),%r15
   1e574:	vpbroadcastd %r15d,%ymm1
   1e57a:	shr    $0x20,%r15
   1e57e:	and    %ebp,%r15d
   1e581:	vpmulld %ymm0,%ymm1,%ymm1
   1e586:	shl    $0x6,%r15
   1e58a:	vpsrld $0x1a,%ymm1,%ymm1
   1e58f:	vpmovzxdq %ymm1,%zmm1
   1e595:	vmovaps (%r14,%r15,1),%zmm2
   1e59c:	vpshufbitqmb %zmm1,%zmm2,%k0
   1e5a2:	shl    $0x6,%rbx
   1e5a6:	kmovq  %k0,%r15
   1e5ab:	and    %r8,%r15
   1e5ae:	xor    %ebp,%ebp
   1e5b0:	cmp    %r8,%r15
   1e5b3:	sete   %bpl
   1e5b7:	prefetcht0 (%r14,%rbx,1)
   1e5bc:	mov    %ebp,(%rcx,%r10,4)
   1e5c0:	mov    0x18(%rdi),%ebx
   1e5c3:	mov    0x10c(%rdx,%r10,8),%r14d
   1e5cb:	and    %ebx,%r14d
   1e5ce:	mov    (%rdi),%r15
   1e5d1:	shl    $0x6,%r14
   1e5d5:	prefetcht0 (%r15,%r14,1)
   1e5da:	mov    0x8(%rdx,%r10,8),%r14
   1e5df:	vpbroadcastd %r14d,%ymm1
   1e5e5:	shr    $0x20,%r14
   1e5e9:	and    %ebx,%r14d
   1e5ec:	shl    $0x6,%r14
   1e5f0:	vpmulld %ymm0,%ymm1,%ymm1
   1e5f5:	vpsrld $0x1a,%ymm1,%ymm1
   1e5fa:	vpmovzxdq %ymm1,%zmm1
   1e600:	vmovaps (%r15,%r14,1),%zmm2
   1e607:	vpshufbitqmb %zmm1,%zmm2,%k0
   1e60d:	kmovq  %k0,%rbx
   1e612:	and    %r8,%rbx
   1e615:	xor    %ebp,%ebp
   1e617:	cmp    %r8,%rbx
   1e61a:	sete   %bpl
   1e61e:	mov    %ebp,0x4(%rcx,%r10,4)
   1e623:	add    $0x2,%r10
   1e627:	cmp    %r10,%r11
   1e62a:	jne    1e560 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<1>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<1>&, unsigned long, unsigned long const*, unsigned int*)+0x1f0>
   1e630:	test   %rsi,%rsi
   1e633:	je     1e69b <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<1>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<1>&, unsigned long, unsigned long const*, unsigned int*)+0x32b>
   1e635:	mov    0x18(%rdi),%esi
   1e638:	mov    0x104(%rdx,%r10,8),%r11d
   1e640:	and    %esi,%r11d
   1e643:	mov    (%rdi),%rbx
   1e646:	shl    $0x6,%r11
   1e64a:	prefetcht0 (%rbx,%r11,1)
   1e64f:	mov    (%rdx,%r10,8),%r11
   1e653:	vpbroadcastd %r11d,%ymm0
   1e659:	shr    $0x20,%r11
   1e65d:	and    %esi,%r11d
   1e660:	shl    $0x6,%r11
   1e664:	vpmulld -0x1c64d(%rip),%ymm0,%ymm0        # 2020 <_IO_stdin_used+0x18>
   1e66d:	vpsrld $0x1a,%ymm0,%ymm0
   1e672:	vpmovzxdq %ymm0,%zmm0
   1e678:	vmovdqa64 (%rbx,%r11,1),%zmm1
   1e67f:	vpshufbitqmb %zmm0,%zmm1,%k0
   1e685:	kmovq  %k0,%rsi
   1e68a:	and    %r8,%rsi
   1e68d:	xor    %r11d,%r11d
   1e690:	cmp    %r8,%rsi
   1e693:	sete   %r11b
   1e697:	mov    %r11d,(%rcx,%r10,4)
   1e69b:	cmp    %rax,%r9
   1e69e:	jae    1e3d0 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<1>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<1>&, unsigned long, unsigned long const*, unsigned int*)+0x60>
   1e6a4:	vmovdqa -0x1c68c(%rip),%ymm0        # 2020 <_IO_stdin_used+0x18>
   1e6ac:	nopl   0x0(%rax)
   1e6b0:	mov    (%rdx,%r9,8),%rsi
   1e6b4:	mov    %rsi,%r10
   1e6b7:	shr    $0x20,%r10
   1e6bb:	and    0x18(%rdi),%r10d
   1e6bf:	vpbroadcastd %esi,%ymm1
   1e6c5:	mov    (%rdi),%rsi
   1e6c8:	shl    $0x6,%r10
   1e6cc:	vpmulld %ymm0,%ymm1,%ymm1
   1e6d1:	vpsrld $0x1a,%ymm1,%ymm1
   1e6d6:	vpmovzxdq %ymm1,%zmm1
   1e6dc:	vmovaps (%rsi,%r10,1),%zmm2
   1e6e3:	vpshufbitqmb %zmm1,%zmm2,%k0
   1e6e9:	kmovq  %k0,%rsi
   1e6ee:	and    %r8,%rsi
   1e6f1:	xor    %r10d,%r10d
   1e6f4:	cmp    %r8,%rsi
   1e6f7:	sete   %r10b
   1e6fb:	mov    %r10d,(%rcx,%r9,4)
   1e6ff:	inc    %r9
   1e702:	cmp    %r9,%rax
   1e705:	jne    1e6b0 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<1>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<1>&, unsigned long, unsigned long const*, unsigned int*)+0x340>
   1e707:	jmp    1e3d0 <void lookup_kernel<bloom_filters::Split64BitShuffleCandidate<1>, unsigned long>(bloom_filters::Split64BitShuffleCandidate<1>&, unsigned long, unsigned long const*, unsigned int*)+0x60>
   1e70c:	int3
   1e70d:	int3
   1e70e:	int3
   1e70f:	int3

