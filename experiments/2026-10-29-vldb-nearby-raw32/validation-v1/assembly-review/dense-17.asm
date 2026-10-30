
/home/yiming/projects/fastest-bf-lab/build/vldb-nearby-raw32-v1/native/nearby_raw32:     file format elf64-x86-64


Disassembly of section .text:

0000000000386490 <void vldb_stage2::DenseCall<raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > >(raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > const&, unsigned int, unsigned int const*, unsigned int*)>:
  386490:	mov    %esi,%r10d
  386493:	mov    %rcx,%rsi
  386496:	mov    %r10d,%ecx
  386499:	test   %rcx,%rcx
  38649c:	je     3866e8 <void vldb_stage2::DenseCall<raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > >(raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > const&, unsigned int, unsigned int const*, unsigned int*)+0x258>
  3864a2:	push   %rbp
  3864a3:	mov    %rdx,%r11
  3864a6:	movabs $0xd6e8feb86659fd93,%r8
  3864b0:	mov    %rsp,%rbp
  3864b3:	push   %rbx
  3864b4:	xor    %edx,%edx
  3864b6:	cs nopw 0x0(%rax,%rax,1)
  3864c0:	mov    (%r11,%rdx,4),%eax
  3864c4:	imul   %r8,%rax
  3864c8:	mov    %rax,%r9
  3864cb:	shr    $0x20,%r9
  3864cf:	xor    %r9,%rax
  3864d2:	imul   %r8,%rax
  3864d6:	mov    0x120(%rdi),%r9
  3864dd:	mov    %rax,%rbx
  3864e0:	shr    $0x20,%rbx
  3864e4:	xor    %rbx,%rax
  3864e7:	mov    %rax,(%r9,%rdx,8)
  3864eb:	inc    %rdx
  3864ee:	cmp    %rcx,%rdx
  3864f1:	jne    3864c0 <void vldb_stage2::DenseCall<raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > >(raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > const&, unsigned int, unsigned int const*, unsigned int*)+0x30>
  3864f3:	mov    0x120(%rdi),%r9
  3864fa:	cmp    $0x1,%r10d
  3864fe:	je     386600 <void vldb_stage2::DenseCall<raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > >(raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > const&, unsigned int, unsigned int const*, unsigned int*)+0x170>
  386504:	cmp    $0xf,%r10d
  386508:	jbe    386670 <void vldb_stage2::DenseCall<raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > >(raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > const&, unsigned int, unsigned int const*, unsigned int*)+0x1e0>
  38650e:	cmp    $0x20,%rcx
  386512:	jbe    386658 <void vldb_stage2::DenseCall<raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > >(raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > const&, unsigned int, unsigned int const*, unsigned int*)+0x1c8>
  386518:	mov    $0x1,%r8d
  38651e:	vmovdqa -0x30d046(%rip),%ymm1        # 794e0 <bloom_filters::FastPatternBF::sparse_patterns_+0x80>
  386526:	lea    -0x20(%rcx),%rdx
  38652a:	xor    %eax,%eax
  38652c:	vpbroadcastq %r8,%zmm3
  386532:	nopw   0x0(%rax,%rax,1)
  386538:	vpmulld (%r9,%rax,8){1to8},%ymm1,%ymm0
  38653f:	mov    0x18(%rdi),%r8d
  386543:	mov    (%rdi),%r11
  386546:	mov    %r8d,%r10d
  386549:	and    0x4(%r9,%rax,8),%r8d
  38654e:	vpsrld $0x1a,%ymm0,%ymm0
  386553:	shl    $0x6,%r8
  386557:	vpmovzxdq %ymm0,%zmm0
  38655d:	vmovdqa64 (%r11,%r8,1),%zmm2
  386564:	vpsllvq %zmm0,%zmm3,%zmm0
  38656a:	and    0x104(%r9,%rax,8),%r10d
  386572:	vptestnmq %zmm0,%zmm2,%k0
  386578:	xor    %r8d,%r8d
  38657b:	shl    $0x6,%r10
  38657f:	prefetcht0 (%r11,%r10,1)
  386584:	kortestb %k0,%k0
  386588:	sete   %r8b
  38658c:	mov    %r8d,(%rsi,%rax,4)
  386590:	inc    %rax
  386593:	cmp    %rdx,%rax
  386596:	jne    386538 <void vldb_stage2::DenseCall<raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > >(raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > const&, unsigned int, unsigned int const*, unsigned int*)+0xa8>
  386598:	mov    $0x1,%eax
  38659d:	vpbroadcastq %rax,%zmm3
  3865a3:	nopl   0x0(%rax,%rax,1)
  3865a8:	vpmulld (%r9,%rdx,8){1to8},%ymm1,%ymm0
  3865af:	mov    0x4(%r9,%rdx,8),%eax
  3865b4:	and    0x18(%rdi),%eax
  3865b7:	shl    $0x6,%rax
  3865bb:	vpsrld $0x1a,%ymm0,%ymm0
  3865c0:	add    (%rdi),%rax
  3865c3:	vpmovzxdq %ymm0,%zmm0
  3865c9:	vmovdqa64 (%rax),%zmm2
  3865cf:	vpsllvq %zmm0,%zmm3,%zmm0
  3865d5:	xor    %eax,%eax
  3865d7:	vptestnmq %zmm0,%zmm2,%k0
  3865dd:	kortestb %k0,%k0
  3865e1:	sete   %al
  3865e4:	mov    %eax,(%rsi,%rdx,4)
  3865e7:	inc    %rdx
  3865ea:	cmp    %rcx,%rdx
  3865ed:	jne    3865a8 <void vldb_stage2::DenseCall<raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > >(raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > const&, unsigned int, unsigned int const*, unsigned int*)+0x118>
  3865ef:	vzeroupper
  3865f2:	mov    -0x8(%rbp),%rbx
  3865f6:	leave
  3865f7:	ret
  3865f8:	nopl   0x0(%rax,%rax,1)
  386600:	vmovdqa -0x30d128(%rip),%ymm0        # 794e0 <bloom_filters::FastPatternBF::sparse_patterns_+0x80>
  386608:	mov    $0x1,%eax
  38660d:	vpmulld (%r9){1to8},%ymm0,%ymm0
  386613:	vpbroadcastq %rax,%zmm1
  386619:	mov    0x4(%r9),%eax
  38661d:	and    0x18(%rdi),%eax
  386620:	shl    $0x6,%rax
  386624:	vpsrld $0x1a,%ymm0,%ymm0
  386629:	add    (%rdi),%rax
  38662c:	vpmovzxdq %ymm0,%zmm0
  386632:	vpsllvq %zmm0,%zmm1,%zmm0
  386638:	vmovdqa64 (%rax),%zmm1
  38663e:	xor    %eax,%eax
  386640:	vptestnmq %zmm0,%zmm1,%k0
  386646:	kortestb %k0,%k0
  38664a:	sete   %al
  38664d:	mov    %eax,(%rsi)
  38664f:	vzeroupper
  386652:	mov    -0x8(%rbp),%rbx
  386656:	leave
  386657:	ret
  386658:	vmovdqa -0x30d180(%rip),%ymm1        # 794e0 <bloom_filters::FastPatternBF::sparse_patterns_+0x80>
  386660:	xor    %edx,%edx
  386662:	jmp    386598 <void vldb_stage2::DenseCall<raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > >(raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > const&, unsigned int, unsigned int const*, unsigned int*)+0x108>
  386667:	nopw   0x0(%rax,%rax,1)
  386670:	mov    $0x1,%eax
  386675:	vmovdqa32 -0x30d0ff(%rip),%zmm3        # 79580 <bloom_filters::FastPatternBF::sparse_patterns_+0x120>
  38667f:	xor    %edx,%edx
  386681:	vpbroadcastq %rax,%zmm2
  386687:	nopw   0x0(%rax,%rax,1)
  386690:	mov    (%r9,%rdx,8),%rax
  386694:	vmovd  %eax,%xmm0
  386698:	vpbroadcastq %xmm0,%zmm0
  38669e:	vpmulld %zmm0,%zmm3,%zmm0
  3866a4:	shr    $0x20,%rax
  3866a8:	and    0x18(%rdi),%eax
  3866ab:	shl    $0x6,%rax
  3866af:	add    (%rdi),%rax
  3866b2:	vpsrlq $0x1a,%zmm0,%zmm0
  3866b9:	vmovdqa64 (%rax),%zmm1
  3866bf:	vpsllvq %zmm0,%zmm2,%zmm0
  3866c5:	xor    %eax,%eax
  3866c7:	vptestnmq %zmm0,%zmm1,%k0
  3866cd:	kortestb %k0,%k0
  3866d1:	sete   %al
  3866d4:	mov    %eax,(%rsi,%rdx,4)
  3866d7:	inc    %rdx
  3866da:	cmp    %rcx,%rdx
  3866dd:	jne    386690 <void vldb_stage2::DenseCall<raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > >(raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > const&, unsigned int, unsigned int const*, unsigned int*)+0x200>
  3866df:	jmp    3865ef <void vldb_stage2::DenseCall<raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > >(raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > const&, unsigned int, unsigned int const*, unsigned int*)+0x15f>
  3866e4:	nopl   0x0(%rax)
  3866e8:	ret
