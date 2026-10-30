
/home/yiming/projects/fastest-bf-lab/build/vldb-raw32-stage3-v2/native/modern:     file format elf64-x86-64


Disassembly of section .text:

000000000002f800 <void vldb_stage2::Query<raw32_stage3::RawHash<external_bloom::Fixed32<false>, raw32_stage3::ModernPolicy<external_bloom::Fixed32<false> > > >(raw32_stage3::RawHash<external_bloom::Fixed32<false>, raw32_stage3::ModernPolicy<external_bloom::Fixed32<false> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
   2f800:	push   %rbp
   2f801:	mov    %rsp,%rbp
   2f804:	push   %r15
   2f806:	push   %r14
   2f808:	push   %r13
   2f80a:	push   %r12
   2f80c:	mov    %rdx,%r12
   2f80f:	push   %rbx
   2f810:	mov    %rdi,%rbx
   2f813:	and    $0xffffffffffffffe0,%rsp
   2f817:	sub    $0x20,%rsp
   2f81b:	mov    %rcx,0x18(%rsp)
   2f820:	mov    %r8,0x10(%rsp)
   2f825:	test   %esi,%esi
   2f827:	je     2f8a0 <void vldb_stage2::Query<raw32_stage3::RawHash<external_bloom::Fixed32<false>, raw32_stage3::ModernPolicy<external_bloom::Fixed32<false> > > >(raw32_stage3::RawHash<external_bloom::Fixed32<false>, raw32_stage3::ModernPolicy<external_bloom::Fixed32<false> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0xa0>
   2f829:	cmp    $0x1,%esi
   2f82c:	mov    $0x1000,%r15d
   2f832:	mov    $0x1,%eax
   2f837:	cmove  %rax,%r15
   2f83b:	test   %rdx,%rdx
   2f83e:	je     2f889 <void vldb_stage2::Query<raw32_stage3::RawHash<external_bloom::Fixed32<false>, raw32_stage3::ModernPolicy<external_bloom::Fixed32<false> > > >(raw32_stage3::RawHash<external_bloom::Fixed32<false>, raw32_stage3::ModernPolicy<external_bloom::Fixed32<false> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x89>
   2f840:	mov    %rdx,%r14
   2f843:	xor    %r13d,%r13d
   2f846:	cs nopw 0x0(%rax,%rax,1)
   2f850:	mov    0x10(%rsp),%rax
   2f855:	lea    0x0(,%r13,4),%rdx
   2f85d:	lea    (%rax,%rdx,1),%rcx
   2f861:	mov    0x18(%rsp),%rax
   2f866:	mov    %rbx,%rdi
   2f869:	add    %rax,%rdx
   2f86c:	cmp    %r14,%r15
   2f86f:	mov    %r14,%rax
   2f872:	cmovbe %r15,%rax
   2f876:	add    %r15,%r13
   2f879:	mov    %rax,%rsi
   2f87c:	call   2f730 <void vldb_stage2::DenseCall<raw32_stage3::RawHash<external_bloom::Fixed32<false>, raw32_stage3::ModernPolicy<external_bloom::Fixed32<false> > > >(raw32_stage3::RawHash<external_bloom::Fixed32<false>, raw32_stage3::ModernPolicy<external_bloom::Fixed32<false> > > const&, unsigned int, unsigned int const*, unsigned int*)>
   2f881:	sub    %r15,%r14
   2f884:	cmp    %r12,%r13
   2f887:	jb     2f850 <void vldb_stage2::Query<raw32_stage3::RawHash<external_bloom::Fixed32<false>, raw32_stage3::ModernPolicy<external_bloom::Fixed32<false> > > >(raw32_stage3::RawHash<external_bloom::Fixed32<false>, raw32_stage3::ModernPolicy<external_bloom::Fixed32<false> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x50>
   2f889:	lea    -0x28(%rbp),%rsp
   2f88d:	pop    %rbx
   2f88e:	pop    %r12
   2f890:	pop    %r13
   2f892:	pop    %r14
   2f894:	pop    %r15
   2f896:	pop    %rbp
   2f897:	ret
   2f898:	nopl   0x0(%rax,%rax,1)
   2f8a0:	test   %rdx,%rdx
   2f8a3:	je     2f889 <void vldb_stage2::Query<raw32_stage3::RawHash<external_bloom::Fixed32<false>, raw32_stage3::ModernPolicy<external_bloom::Fixed32<false> > > >(raw32_stage3::RawHash<external_bloom::Fixed32<false>, raw32_stage3::ModernPolicy<external_bloom::Fixed32<false> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x89>
   2f8a5:	mov    $0x1,%eax
   2f8aa:	vmovdqa -0x2b252(%rip),%ymm3        # 4660 <bloom_filters::FastPatternBF::sparse_patterns_+0xc0>
   2f8b2:	xor    %edx,%edx
   2f8b4:	movabs $0xd6e8feb86659fd93,%rcx
   2f8be:	vpbroadcastd %eax,%ymm2
   2f8c4:	nopl   0x0(%rax)
   2f8c8:	mov    0x18(%rsp),%rax
   2f8cd:	mov    0x10(%rsp),%rdi
   2f8d2:	mov    (%rax,%rdx,4),%eax
   2f8d5:	imul   %rcx,%rax
   2f8d9:	mov    %rax,%rsi
   2f8dc:	shr    $0x20,%rsi
   2f8e0:	xor    %rsi,%rax
   2f8e3:	imul   %rcx,%rax
   2f8e7:	mov    %rax,%rsi
   2f8ea:	shr    $0x20,%rsi
   2f8ee:	xor    %rsi,%rax
   2f8f1:	mov    (%rbx),%esi
   2f8f3:	vpbroadcastd %eax,%ymm0
   2f8f9:	shr    $0x20,%rax
   2f8fd:	imul   %rsi,%rax
   2f901:	vpmulld %ymm3,%ymm0,%ymm0
   2f906:	shr    $0x20,%rax
   2f90a:	shl    $0x5,%rax
   2f90e:	add    0x8(%rbx),%rax
   2f912:	vpsrld $0x1b,%ymm0,%ymm0
   2f917:	vmovdqa (%rax),%ymm1
   2f91b:	vpsllvd %ymm0,%ymm2,%ymm0
   2f920:	xor    %eax,%eax
   2f922:	vptest %ymm0,%ymm1
   2f927:	setb   %al
   2f92a:	mov    %eax,(%rdi,%rdx,4)
   2f92d:	inc    %rdx
   2f930:	cmp    %rdx,%r12
   2f933:	jne    2f8c8 <void vldb_stage2::Query<raw32_stage3::RawHash<external_bloom::Fixed32<false>, raw32_stage3::ModernPolicy<external_bloom::Fixed32<false> > > >(raw32_stage3::RawHash<external_bloom::Fixed32<false>, raw32_stage3::ModernPolicy<external_bloom::Fixed32<false> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0xc8>
   2f935:	vzeroupper
   2f938:	lea    -0x28(%rbp),%rsp
   2f93c:	pop    %rbx
   2f93d:	pop    %r12
   2f93f:	pop    %r13
   2f941:	pop    %r14
   2f943:	pop    %r15
   2f945:	pop    %rbp
   2f946:	ret
