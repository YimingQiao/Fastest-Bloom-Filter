
/home/yiming/projects/fastest-bf-lab/build/vldb-nearby-raw32-v1/native/nearby_raw32:     file format elf64-x86-64


Disassembly of section .text:

00000000003866f0 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > >(raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
  3866f0:	push   %rbp
  3866f1:	mov    %rsp,%rbp
  3866f4:	push   %r15
  3866f6:	push   %r14
  3866f8:	push   %r13
  3866fa:	push   %r12
  3866fc:	mov    %rdx,%r12
  3866ff:	push   %rbx
  386700:	mov    %rdi,%rbx
  386703:	and    $0xffffffffffffffc0,%rsp
  386707:	sub    $0x40,%rsp
  38670b:	mov    %rcx,0x38(%rsp)
  386710:	mov    %r8,0x30(%rsp)
  386715:	test   %esi,%esi
  386717:	je     386790 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > >(raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0xa0>
  386719:	cmp    $0x1,%esi
  38671c:	mov    $0x1000,%r15d
  386722:	mov    $0x1,%eax
  386727:	cmove  %rax,%r15
  38672b:	test   %rdx,%rdx
  38672e:	je     386779 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > >(raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x89>
  386730:	mov    %rdx,%r14
  386733:	xor    %r13d,%r13d
  386736:	cs nopw 0x0(%rax,%rax,1)
  386740:	mov    0x30(%rsp),%rax
  386745:	lea    0x0(,%r13,4),%rdx
  38674d:	lea    (%rax,%rdx,1),%rcx
  386751:	mov    0x38(%rsp),%rax
  386756:	mov    %rbx,%rdi
  386759:	add    %rax,%rdx
  38675c:	cmp    %r15,%r14
  38675f:	mov    %r15,%rax
  386762:	cmovbe %r14,%rax
  386766:	add    %r15,%r13
  386769:	mov    %rax,%rsi
  38676c:	call   386490 <void vldb_stage2::DenseCall<raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > >(raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > const&, unsigned int, unsigned int const*, unsigned int*)>
  386771:	sub    %r15,%r14
  386774:	cmp    %r12,%r13
  386777:	jb     386740 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > >(raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x50>
  386779:	lea    -0x28(%rbp),%rsp
  38677d:	pop    %rbx
  38677e:	pop    %r12
  386780:	pop    %r13
  386782:	pop    %r14
  386784:	pop    %r15
  386786:	pop    %rbp
  386787:	ret
  386788:	nopl   0x0(%rax,%rax,1)
  386790:	test   %rdx,%rdx
  386793:	je     386779 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > >(raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x89>
  386795:	mov    $0x1,%eax
  38679a:	vmovdqa -0x30d2c2(%rip),%ymm3        # 794e0 <bloom_filters::FastPatternBF::sparse_patterns_+0x80>
  3867a2:	xor    %edx,%edx
  3867a4:	movabs $0xd6e8feb86659fd93,%rcx
  3867ae:	vpbroadcastq %rax,%zmm2
  3867b4:	nopl   0x0(%rax)
  3867b8:	mov    0x38(%rsp),%rax
  3867bd:	mov    0x30(%rsp),%rdi
  3867c2:	mov    (%rax,%rdx,4),%eax
  3867c5:	imul   %rcx,%rax
  3867c9:	mov    %rax,%rsi
  3867cc:	shr    $0x20,%rsi
  3867d0:	xor    %rsi,%rax
  3867d3:	imul   %rcx,%rax
  3867d7:	mov    %rax,%rsi
  3867da:	shr    $0x20,%rsi
  3867de:	xor    %rsi,%rax
  3867e1:	vpbroadcastd %eax,%ymm0
  3867e7:	vpmulld %ymm3,%ymm0,%ymm0
  3867ec:	shr    $0x20,%rax
  3867f0:	and    0x18(%rbx),%eax
  3867f3:	shl    $0x6,%rax
  3867f7:	add    (%rbx),%rax
  3867fa:	vpsrld $0x1a,%ymm0,%ymm0
  3867ff:	vpmovzxdq %ymm0,%zmm0
  386805:	vmovdqa64 (%rax),%zmm1
  38680b:	vpsllvq %zmm0,%zmm2,%zmm0
  386811:	xor    %eax,%eax
  386813:	vptestnmq %zmm0,%zmm1,%k0
  386819:	kortestb %k0,%k0
  38681d:	sete   %al
  386820:	mov    %eax,(%rdi,%rdx,4)
  386823:	inc    %rdx
  386826:	cmp    %rdx,%r12
  386829:	jne    3867b8 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > >(raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0xc8>
  38682b:	vzeroupper
  38682e:	lea    -0x28(%rbp),%rsp
  386832:	pop    %rbx
  386833:	pop    %r12
  386835:	pop    %r13
  386837:	pop    %r14
  386839:	pop    %r15
  38683b:	pop    %rbp
  38683c:	ret
