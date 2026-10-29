
/home/yiming/projects/fastest-bf-lab/build/vldb-nearby-raw32-v1/native/nearby_raw32:     file format elf64-x86-64


Disassembly of section .text:

00000000003875f0 <void vldb_stage2::DenseCall<raw32_stage3::VisibleRawHash<nearby_raw32::RangePublic, nearby_raw32::ExactNativePolicy<nearby_raw32::RangePublic, false> > >(raw32_stage3::VisibleRawHash<nearby_raw32::RangePublic, nearby_raw32::ExactNativePolicy<nearby_raw32::RangePublic, false> > const&, unsigned int, unsigned int const*, unsigned int*)>:
  3875f0:	mov    %esi,%r9d
  3875f3:	mov    %rcx,%rsi
  3875f6:	mov    %r9d,%ecx
  3875f9:	test   %rcx,%rcx
  3875fc:	je     387860 <void vldb_stage2::DenseCall<raw32_stage3::VisibleRawHash<nearby_raw32::RangePublic, nearby_raw32::ExactNativePolicy<nearby_raw32::RangePublic, false> > >(raw32_stage3::VisibleRawHash<nearby_raw32::RangePublic, nearby_raw32::ExactNativePolicy<nearby_raw32::RangePublic, false> > const&, unsigned int, unsigned int const*, unsigned int*)+0x270>
  387602:	push   %rbp
  387603:	mov    %rdx,%r11
  387606:	movabs $0xd6e8feb86659fd93,%r8
  387610:	mov    %rsp,%rbp
  387613:	push   %rbx
  387614:	xor    %edx,%edx
  387616:	cs nopw 0x0(%rax,%rax,1)
  387620:	mov    (%r11,%rdx,4),%eax
  387624:	imul   %r8,%rax
  387628:	mov    %rax,%r10
  38762b:	shr    $0x20,%r10
  38762f:	xor    %r10,%rax
  387632:	imul   %r8,%rax
  387636:	mov    0x120(%rdi),%r10
  38763d:	mov    %rax,%rbx
  387640:	shr    $0x20,%rbx
  387644:	xor    %rbx,%rax
  387647:	mov    %rax,(%r10,%rdx,8)
  38764b:	inc    %rdx
  38764e:	cmp    %rcx,%rdx
  387651:	jne    387620 <void vldb_stage2::DenseCall<raw32_stage3::VisibleRawHash<nearby_raw32::RangePublic, nearby_raw32::ExactNativePolicy<nearby_raw32::RangePublic, false> > >(raw32_stage3::VisibleRawHash<nearby_raw32::RangePublic, nearby_raw32::ExactNativePolicy<nearby_raw32::RangePublic, false> > const&, unsigned int, unsigned int const*, unsigned int*)+0x30>
  387653:	mov    0x120(%rdi),%r8
  38765a:	cmp    $0x1,%r9d
  38765e:	je     387770 <void vldb_stage2::DenseCall<raw32_stage3::VisibleRawHash<nearby_raw32::RangePublic, nearby_raw32::ExactNativePolicy<nearby_raw32::RangePublic, false> > >(raw32_stage3::VisibleRawHash<nearby_raw32::RangePublic, nearby_raw32::ExactNativePolicy<nearby_raw32::RangePublic, false> > const&, unsigned int, unsigned int const*, unsigned int*)+0x180>
  387664:	cmp    $0xf,%r9d
  387668:	jbe    3877e8 <void vldb_stage2::DenseCall<raw32_stage3::VisibleRawHash<nearby_raw32::RangePublic, nearby_raw32::ExactNativePolicy<nearby_raw32::RangePublic, false> > >(raw32_stage3::VisibleRawHash<nearby_raw32::RangePublic, nearby_raw32::ExactNativePolicy<nearby_raw32::RangePublic, false> > const&, unsigned int, unsigned int const*, unsigned int*)+0x1f8>
  38766e:	cmp    $0x20,%rcx
  387672:	jbe    3877d3 <void vldb_stage2::DenseCall<raw32_stage3::VisibleRawHash<nearby_raw32::RangePublic, nearby_raw32::ExactNativePolicy<nearby_raw32::RangePublic, false> > >(raw32_stage3::VisibleRawHash<nearby_raw32::RangePublic, nearby_raw32::ExactNativePolicy<nearby_raw32::RangePublic, false> > const&, unsigned int, unsigned int const*, unsigned int*)+0x1e3>
  387678:	mov    $0x1,%eax
  38767d:	vmovdqa -0x30e1a5(%rip),%ymm1        # 794e0 <bloom_filters::FastPatternBF::sparse_patterns_+0x80>
  387685:	lea    -0x20(%rcx),%rdx
  387689:	xor    %r9d,%r9d
  38768c:	vpbroadcastq %rax,%zmm3
  387692:	nopw   0x0(%rax,%rax,1)
  387698:	mov    0x18(%rdi),%r11d
  38769c:	mov    0x104(%r8,%r9,8),%eax
  3876a4:	mov    (%rdi),%r10
  3876a7:	imul   %r11,%rax
  3876ab:	vpmulld (%r8,%r9,8){1to8},%ymm1,%ymm0
  3876b2:	shr    $0x20,%rax
  3876b6:	shl    $0x6,%rax
  3876ba:	prefetcht0 (%r10,%rax,1)
  3876bf:	mov    0x4(%r8,%r9,8),%eax
  3876c4:	vpsrld $0x1a,%ymm0,%ymm0
  3876c9:	imul   %r11,%rax
  3876cd:	vpmovzxdq %ymm0,%zmm0
  3876d3:	vpsllvq %zmm0,%zmm3,%zmm0
  3876d9:	shr    $0x20,%rax
  3876dd:	shl    $0x6,%rax
  3876e1:	vmovdqa64 (%r10,%rax,1),%zmm2
  3876e8:	xor    %eax,%eax
  3876ea:	vptestnmq %zmm0,%zmm2,%k0
  3876f0:	kortestb %k0,%k0
  3876f4:	sete   %al
  3876f7:	mov    %eax,(%rsi,%r9,4)
  3876fb:	inc    %r9
  3876fe:	cmp    %rdx,%r9
  387701:	jne    387698 <void vldb_stage2::DenseCall<raw32_stage3::VisibleRawHash<nearby_raw32::RangePublic, nearby_raw32::ExactNativePolicy<nearby_raw32::RangePublic, false> > >(raw32_stage3::VisibleRawHash<nearby_raw32::RangePublic, nearby_raw32::ExactNativePolicy<nearby_raw32::RangePublic, false> > const&, unsigned int, unsigned int const*, unsigned int*)+0xa8>
  387703:	mov    $0x1,%eax
  387708:	vpbroadcastq %rax,%zmm3
  38770e:	xchg   %ax,%ax
  387710:	mov    0x4(%r8,%rdx,8),%eax
  387715:	mov    0x18(%rdi),%r9d
  387719:	vpmulld (%r8,%rdx,8){1to8},%ymm1,%ymm0
  387720:	imul   %r9,%rax
  387724:	shr    $0x20,%rax
  387728:	shl    $0x6,%rax
  38772c:	vpsrld $0x1a,%ymm0,%ymm0
  387731:	add    (%rdi),%rax
  387734:	vpmovzxdq %ymm0,%zmm0
  38773a:	vmovdqa64 (%rax),%zmm2
  387740:	vpsllvq %zmm0,%zmm3,%zmm0
  387746:	xor    %eax,%eax
  387748:	vptestnmq %zmm0,%zmm2,%k0
  38774e:	kortestb %k0,%k0
  387752:	sete   %al
  387755:	mov    %eax,(%rsi,%rdx,4)
  387758:	inc    %rdx
  38775b:	cmp    %rcx,%rdx
  38775e:	jne    387710 <void vldb_stage2::DenseCall<raw32_stage3::VisibleRawHash<nearby_raw32::RangePublic, nearby_raw32::ExactNativePolicy<nearby_raw32::RangePublic, false> > >(raw32_stage3::VisibleRawHash<nearby_raw32::RangePublic, nearby_raw32::ExactNativePolicy<nearby_raw32::RangePublic, false> > const&, unsigned int, unsigned int const*, unsigned int*)+0x120>
  387760:	vzeroupper
  387763:	mov    -0x8(%rbp),%rbx
  387767:	leave
  387768:	ret
  387769:	nopl   0x0(%rax)
  387770:	mov    (%r8),%rax
  387773:	vmovdqa -0x30e29b(%rip),%ymm0        # 794e0 <bloom_filters::FastPatternBF::sparse_patterns_+0x80>
  38777b:	mov    $0x1,%edx
  387780:	vpbroadcastq %rdx,%zmm1
  387786:	mov    0x18(%rdi),%edx
  387789:	vpmulld (%r8){1to8},%ymm0,%ymm0
  38778f:	shr    $0x20,%rax
  387793:	imul   %rdx,%rax
  387797:	shr    $0x20,%rax
  38779b:	shl    $0x6,%rax
  38779f:	vpsrld $0x1a,%ymm0,%ymm0
  3877a4:	add    (%rdi),%rax
  3877a7:	vpmovzxdq %ymm0,%zmm0
  3877ad:	vpsllvq %zmm0,%zmm1,%zmm0
  3877b3:	vmovdqa64 (%rax),%zmm1
  3877b9:	xor    %eax,%eax
  3877bb:	vptestnmq %zmm0,%zmm1,%k0
  3877c1:	kortestb %k0,%k0
  3877c5:	sete   %al
  3877c8:	mov    %eax,(%rsi)
  3877ca:	vzeroupper
  3877cd:	mov    -0x8(%rbp),%rbx
  3877d1:	leave
  3877d2:	ret
  3877d3:	vmovdqa -0x30e2fb(%rip),%ymm1        # 794e0 <bloom_filters::FastPatternBF::sparse_patterns_+0x80>
  3877db:	xor    %edx,%edx
  3877dd:	jmp    387703 <void vldb_stage2::DenseCall<raw32_stage3::VisibleRawHash<nearby_raw32::RangePublic, nearby_raw32::ExactNativePolicy<nearby_raw32::RangePublic, false> > >(raw32_stage3::VisibleRawHash<nearby_raw32::RangePublic, nearby_raw32::ExactNativePolicy<nearby_raw32::RangePublic, false> > const&, unsigned int, unsigned int const*, unsigned int*)+0x113>
  3877e2:	nopw   0x0(%rax,%rax,1)
  3877e8:	mov    $0x1,%eax
  3877ed:	vmovdqa32 -0x30e277(%rip),%zmm3        # 79580 <bloom_filters::FastPatternBF::sparse_patterns_+0x120>
  3877f7:	xor    %edx,%edx
  3877f9:	vpbroadcastq %rax,%zmm2
  3877ff:	nop
  387800:	mov    (%r8,%rdx,8),%rax
  387804:	mov    0x18(%rdi),%r9d
  387808:	vmovd  %eax,%xmm0
  38780c:	vpbroadcastq %xmm0,%zmm0
  387812:	shr    $0x20,%rax
  387816:	imul   %r9,%rax
  38781a:	vpmulld %zmm0,%zmm3,%zmm0
  387820:	shr    $0x20,%rax
  387824:	shl    $0x6,%rax
  387828:	add    (%rdi),%rax
  38782b:	vpsrlq $0x1a,%zmm0,%zmm0
  387832:	vmovdqa64 (%rax),%zmm1
  387838:	vpsllvq %zmm0,%zmm2,%zmm0
  38783e:	xor    %eax,%eax
  387840:	vptestnmq %zmm0,%zmm1,%k0
  387846:	kortestb %k0,%k0
  38784a:	sete   %al
  38784d:	mov    %eax,(%rsi,%rdx,4)
  387850:	inc    %rdx
  387853:	cmp    %rcx,%rdx
  387856:	jne    387800 <void vldb_stage2::DenseCall<raw32_stage3::VisibleRawHash<nearby_raw32::RangePublic, nearby_raw32::ExactNativePolicy<nearby_raw32::RangePublic, false> > >(raw32_stage3::VisibleRawHash<nearby_raw32::RangePublic, nearby_raw32::ExactNativePolicy<nearby_raw32::RangePublic, false> > const&, unsigned int, unsigned int const*, unsigned int*)+0x210>
  387858:	jmp    387760 <void vldb_stage2::DenseCall<raw32_stage3::VisibleRawHash<nearby_raw32::RangePublic, nearby_raw32::ExactNativePolicy<nearby_raw32::RangePublic, false> > >(raw32_stage3::VisibleRawHash<nearby_raw32::RangePublic, nearby_raw32::ExactNativePolicy<nearby_raw32::RangePublic, false> > const&, unsigned int, unsigned int const*, unsigned int*)+0x170>
  38785d:	nopl   (%rax)
  387860:	ret
