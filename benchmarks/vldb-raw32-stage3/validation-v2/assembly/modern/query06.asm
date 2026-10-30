
/home/yiming/projects/fastest-bf-lab/build/vldb-raw32-stage3-v2/native/modern:     file format elf64-x86-64


Disassembly of section .text:

000000000002eea0 <void vldb_stage2::Query<raw32_stage3::RawHash<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul> > > >(raw32_stage3::RawHash<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
   2eea0:	push   %rbp
   2eea1:	mov    %rsp,%rbp
   2eea4:	push   %r15
   2eea6:	push   %r14
   2eea8:	push   %r13
   2eeaa:	push   %r12
   2eeac:	mov    %rdx,%r12
   2eeaf:	push   %rbx
   2eeb0:	mov    %rdi,%rbx
   2eeb3:	and    $0xffffffffffffffe0,%rsp
   2eeb7:	sub    $0x20,%rsp
   2eebb:	mov    %rcx,0x18(%rsp)
   2eec0:	mov    %r8,0x10(%rsp)
   2eec5:	test   %esi,%esi
   2eec7:	je     2ef40 <void vldb_stage2::Query<raw32_stage3::RawHash<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul> > > >(raw32_stage3::RawHash<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0xa0>
   2eec9:	cmp    $0x1,%esi
   2eecc:	mov    $0x1000,%r15d
   2eed2:	mov    $0x1,%eax
   2eed7:	cmove  %rax,%r15
   2eedb:	test   %rdx,%rdx
   2eede:	je     2ef29 <void vldb_stage2::Query<raw32_stage3::RawHash<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul> > > >(raw32_stage3::RawHash<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x89>
   2eee0:	mov    %rdx,%r14
   2eee3:	xor    %r13d,%r13d
   2eee6:	cs nopw 0x0(%rax,%rax,1)
   2eef0:	mov    0x10(%rsp),%rax
   2eef5:	lea    0x0(,%r13,4),%rdx
   2eefd:	lea    (%rax,%rdx,1),%rcx
   2ef01:	mov    0x18(%rsp),%rax
   2ef06:	mov    %rbx,%rdi
   2ef09:	add    %rax,%rdx
   2ef0c:	cmp    %r14,%r15
   2ef0f:	mov    %r14,%rax
   2ef12:	cmovbe %r15,%rax
   2ef16:	add    %r15,%r13
   2ef19:	mov    %rax,%rsi
   2ef1c:	call   2eda0 <void vldb_stage2::DenseCall<raw32_stage3::RawHash<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul> > > >(raw32_stage3::RawHash<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul> > > const&, unsigned int, unsigned int const*, unsigned int*)>
   2ef21:	sub    %r15,%r14
   2ef24:	cmp    %r12,%r13
   2ef27:	jb     2eef0 <void vldb_stage2::Query<raw32_stage3::RawHash<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul> > > >(raw32_stage3::RawHash<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x50>
   2ef29:	lea    -0x28(%rbp),%rsp
   2ef2d:	pop    %rbx
   2ef2e:	pop    %r12
   2ef30:	pop    %r13
   2ef32:	pop    %r14
   2ef34:	pop    %r15
   2ef36:	pop    %rbp
   2ef37:	ret
   2ef38:	nopl   0x0(%rax,%rax,1)
   2ef40:	test   %rdx,%rdx
   2ef43:	je     2ef29 <void vldb_stage2::Query<raw32_stage3::RawHash<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul> > > >(raw32_stage3::RawHash<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x89>
   2ef45:	mov    $0x1,%eax
   2ef4a:	vmovdqa -0x2a7f2(%rip),%ymm3        # 4760 <bloom_filters::FastPatternBF::sparse_patterns_+0x1c0>
   2ef52:	xor    %esi,%esi
   2ef54:	movabs $0xd6e8feb86659fd93,%rdi
   2ef5e:	movabs $0xf1357aea2e62a9c5,%r8
   2ef68:	vpbroadcastd %eax,%ymm2
   2ef6e:	xchg   %ax,%ax
   2ef70:	mov    0x18(%rsp),%rax
   2ef75:	mov    (%rax,%rsi,4),%ecx
   2ef78:	imul   %rdi,%rcx
   2ef7c:	mov    %rcx,%rax
   2ef7f:	shr    $0x20,%rax
   2ef83:	xor    %rax,%rcx
   2ef86:	imul   %rdi,%rcx
   2ef8a:	mov    %rcx,%rax
   2ef8d:	shr    $0x20,%rax
   2ef91:	xor    %rax,%rcx
   2ef94:	or     $0x1,%rcx
   2ef98:	mov    %rcx,%rax
   2ef9b:	imul   %r8,%rcx
   2ef9f:	mulq   0x10(%rbx)
   2efa3:	xor    %eax,%eax
   2efa5:	vpbroadcastq %rcx,%ymm0
   2efab:	vpsllvq %ymm3,%ymm0,%ymm0
   2efb0:	shl    $0x5,%rdx
   2efb4:	add    0x20(%rbx),%rdx
   2efb8:	vpsrld $0x1b,%ymm0,%ymm0
   2efbd:	vmovdqa (%rdx),%ymm1
   2efc1:	vpsllvd %ymm0,%ymm2,%ymm0
   2efc6:	prefetcht0 (%rdx)
   2efc9:	vptest %ymm0,%ymm1
   2efce:	mov    0x10(%rsp),%rdx
   2efd3:	setb   %al
   2efd6:	mov    %eax,(%rdx,%rsi,4)
   2efd9:	inc    %rsi
   2efdc:	cmp    %rsi,%r12
   2efdf:	jne    2ef70 <void vldb_stage2::Query<raw32_stage3::RawHash<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul> > > >(raw32_stage3::RawHash<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<8ul>, 0ul> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0xd0>
   2efe1:	vzeroupper
   2efe4:	lea    -0x28(%rbp),%rsp
   2efe8:	pop    %rbx
   2efe9:	pop    %r12
   2efeb:	pop    %r13
   2efed:	pop    %r14
   2efef:	pop    %r15
   2eff1:	pop    %rbp
   2eff2:	ret
