
/home/yiming/projects/fastest-bf-lab/build/vldb-nearby-raw32-v1/native/nearby_raw32:     file format elf64-x86-64


Disassembly of section .text:

0000000000387870 <void vldb_stage2::Query<raw32_stage3::VisibleRawHash<nearby_raw32::RangePublic, nearby_raw32::ExactNativePolicy<nearby_raw32::RangePublic, false> > >(raw32_stage3::VisibleRawHash<nearby_raw32::RangePublic, nearby_raw32::ExactNativePolicy<nearby_raw32::RangePublic, false> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
  387870:	push   %rbp
  387871:	mov    %rsp,%rbp
  387874:	push   %r15
  387876:	push   %r14
  387878:	push   %r13
  38787a:	push   %r12
  38787c:	mov    %rdx,%r12
  38787f:	push   %rbx
  387880:	mov    %rdi,%rbx
  387883:	and    $0xffffffffffffffc0,%rsp
  387887:	sub    $0x40,%rsp
  38788b:	mov    %rcx,0x38(%rsp)
  387890:	mov    %r8,0x30(%rsp)
  387895:	test   %esi,%esi
  387897:	je     387910 <void vldb_stage2::Query<raw32_stage3::VisibleRawHash<nearby_raw32::RangePublic, nearby_raw32::ExactNativePolicy<nearby_raw32::RangePublic, false> > >(raw32_stage3::VisibleRawHash<nearby_raw32::RangePublic, nearby_raw32::ExactNativePolicy<nearby_raw32::RangePublic, false> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0xa0>
  387899:	cmp    $0x1,%esi
  38789c:	mov    $0x1000,%r15d
  3878a2:	mov    $0x1,%eax
  3878a7:	cmove  %rax,%r15
  3878ab:	test   %rdx,%rdx
  3878ae:	je     3878f9 <void vldb_stage2::Query<raw32_stage3::VisibleRawHash<nearby_raw32::RangePublic, nearby_raw32::ExactNativePolicy<nearby_raw32::RangePublic, false> > >(raw32_stage3::VisibleRawHash<nearby_raw32::RangePublic, nearby_raw32::ExactNativePolicy<nearby_raw32::RangePublic, false> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x89>
  3878b0:	mov    %rdx,%r14
  3878b3:	xor    %r13d,%r13d
  3878b6:	cs nopw 0x0(%rax,%rax,1)
  3878c0:	mov    0x30(%rsp),%rax
  3878c5:	lea    0x0(,%r13,4),%rdx
  3878cd:	lea    (%rax,%rdx,1),%rcx
  3878d1:	mov    0x38(%rsp),%rax
  3878d6:	mov    %rbx,%rdi
  3878d9:	add    %rax,%rdx
  3878dc:	cmp    %r14,%r15
  3878df:	mov    %r14,%rax
  3878e2:	cmovbe %r15,%rax
  3878e6:	add    %r15,%r13
  3878e9:	mov    %rax,%rsi
  3878ec:	call   3875f0 <void vldb_stage2::DenseCall<raw32_stage3::VisibleRawHash<nearby_raw32::RangePublic, nearby_raw32::ExactNativePolicy<nearby_raw32::RangePublic, false> > >(raw32_stage3::VisibleRawHash<nearby_raw32::RangePublic, nearby_raw32::ExactNativePolicy<nearby_raw32::RangePublic, false> > const&, unsigned int, unsigned int const*, unsigned int*)>
  3878f1:	sub    %r15,%r14
  3878f4:	cmp    %r12,%r13
  3878f7:	jb     3878c0 <void vldb_stage2::Query<raw32_stage3::VisibleRawHash<nearby_raw32::RangePublic, nearby_raw32::ExactNativePolicy<nearby_raw32::RangePublic, false> > >(raw32_stage3::VisibleRawHash<nearby_raw32::RangePublic, nearby_raw32::ExactNativePolicy<nearby_raw32::RangePublic, false> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x50>
  3878f9:	lea    -0x28(%rbp),%rsp
  3878fd:	pop    %rbx
  3878fe:	pop    %r12
  387900:	pop    %r13
  387902:	pop    %r14
  387904:	pop    %r15
  387906:	pop    %rbp
  387907:	ret
  387908:	nopl   0x0(%rax,%rax,1)
  387910:	test   %rdx,%rdx
  387913:	je     3878f9 <void vldb_stage2::Query<raw32_stage3::VisibleRawHash<nearby_raw32::RangePublic, nearby_raw32::ExactNativePolicy<nearby_raw32::RangePublic, false> > >(raw32_stage3::VisibleRawHash<nearby_raw32::RangePublic, nearby_raw32::ExactNativePolicy<nearby_raw32::RangePublic, false> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x89>
  387915:	mov    $0x1,%eax
  38791a:	vmovdqa -0x30e442(%rip),%ymm3        # 794e0 <bloom_filters::FastPatternBF::sparse_patterns_+0x80>
  387922:	xor    %edx,%edx
  387924:	movabs $0xd6e8feb86659fd93,%rcx
  38792e:	vpbroadcastq %rax,%zmm2
  387934:	nopl   0x0(%rax)
  387938:	mov    0x38(%rsp),%rax
  38793d:	mov    0x30(%rsp),%rdi
  387942:	mov    (%rax,%rdx,4),%eax
  387945:	imul   %rcx,%rax
  387949:	mov    %rax,%rsi
  38794c:	shr    $0x20,%rsi
  387950:	xor    %rsi,%rax
  387953:	imul   %rcx,%rax
  387957:	mov    %rax,%rsi
  38795a:	shr    $0x20,%rsi
  38795e:	xor    %rsi,%rax
  387961:	vpbroadcastd %eax,%ymm0
  387967:	mov    0x18(%rbx),%esi
  38796a:	shr    $0x20,%rax
  38796e:	vpmulld %ymm3,%ymm0,%ymm0
  387973:	imul   %rsi,%rax
  387977:	shr    $0x20,%rax
  38797b:	shl    $0x6,%rax
  38797f:	vpsrld $0x1a,%ymm0,%ymm0
  387984:	add    (%rbx),%rax
  387987:	vpmovzxdq %ymm0,%zmm0
  38798d:	vmovdqa64 (%rax),%zmm1
  387993:	vpsllvq %zmm0,%zmm2,%zmm0
  387999:	xor    %eax,%eax
  38799b:	vptestnmq %zmm0,%zmm1,%k0
  3879a1:	kortestb %k0,%k0
  3879a5:	sete   %al
  3879a8:	mov    %eax,(%rdi,%rdx,4)
  3879ab:	inc    %rdx
  3879ae:	cmp    %rdx,%r12
  3879b1:	jne    387938 <void vldb_stage2::Query<raw32_stage3::VisibleRawHash<nearby_raw32::RangePublic, nearby_raw32::ExactNativePolicy<nearby_raw32::RangePublic, false> > >(raw32_stage3::VisibleRawHash<nearby_raw32::RangePublic, nearby_raw32::ExactNativePolicy<nearby_raw32::RangePublic, false> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0xc8>
  3879b3:	vzeroupper
  3879b6:	lea    -0x28(%rbp),%rsp
  3879ba:	pop    %rbx
  3879bb:	pop    %r12
  3879bd:	pop    %r13
  3879bf:	pop    %r14
  3879c1:	pop    %r15
  3879c3:	pop    %rbp
  3879c4:	ret
