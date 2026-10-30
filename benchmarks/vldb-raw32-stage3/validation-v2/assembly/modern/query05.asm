
/home/yiming/projects/fastest-bf-lab/build/vldb-raw32-stage3-v2/native/modern:     file format elf64-x86-64


Disassembly of section .text:

000000000002ec30 <void vldb_stage2::Query<raw32_stage3::RawHash<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul> > > >(raw32_stage3::RawHash<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
   2ec30:	push   %rbp
   2ec31:	mov    %rsp,%rbp
   2ec34:	push   %r15
   2ec36:	push   %r14
   2ec38:	push   %r13
   2ec3a:	push   %r12
   2ec3c:	mov    %rdx,%r12
   2ec3f:	push   %rbx
   2ec40:	mov    %rdi,%rbx
   2ec43:	and    $0xffffffffffffffe0,%rsp
   2ec47:	sub    $0x20,%rsp
   2ec4b:	mov    %rcx,0x18(%rsp)
   2ec50:	mov    %r8,0x10(%rsp)
   2ec55:	test   %esi,%esi
   2ec57:	je     2ecd0 <void vldb_stage2::Query<raw32_stage3::RawHash<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul> > > >(raw32_stage3::RawHash<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0xa0>
   2ec59:	cmp    $0x1,%esi
   2ec5c:	mov    $0x1000,%r15d
   2ec62:	mov    $0x1,%eax
   2ec67:	cmove  %rax,%r15
   2ec6b:	test   %rdx,%rdx
   2ec6e:	je     2ecb9 <void vldb_stage2::Query<raw32_stage3::RawHash<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul> > > >(raw32_stage3::RawHash<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x89>
   2ec70:	mov    %rdx,%r14
   2ec73:	xor    %r13d,%r13d
   2ec76:	cs nopw 0x0(%rax,%rax,1)
   2ec80:	mov    0x10(%rsp),%rax
   2ec85:	lea    0x0(,%r13,4),%rdx
   2ec8d:	lea    (%rax,%rdx,1),%rcx
   2ec91:	mov    0x18(%rsp),%rax
   2ec96:	mov    %rbx,%rdi
   2ec99:	add    %rax,%rdx
   2ec9c:	cmp    %r14,%r15
   2ec9f:	mov    %r14,%rax
   2eca2:	cmovbe %r15,%rax
   2eca6:	add    %r15,%r13
   2eca9:	mov    %rax,%rsi
   2ecac:	call   2eb30 <void vldb_stage2::DenseCall<raw32_stage3::RawHash<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul> > > >(raw32_stage3::RawHash<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul> > > const&, unsigned int, unsigned int const*, unsigned int*)>
   2ecb1:	sub    %r15,%r14
   2ecb4:	cmp    %r12,%r13
   2ecb7:	jb     2ec80 <void vldb_stage2::Query<raw32_stage3::RawHash<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul> > > >(raw32_stage3::RawHash<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x50>
   2ecb9:	lea    -0x28(%rbp),%rsp
   2ecbd:	pop    %rbx
   2ecbe:	pop    %r12
   2ecc0:	pop    %r13
   2ecc2:	pop    %r14
   2ecc4:	pop    %r15
   2ecc6:	pop    %rbp
   2ecc7:	ret
   2ecc8:	nopl   0x0(%rax,%rax,1)
   2ecd0:	test   %rdx,%rdx
   2ecd3:	je     2ecb9 <void vldb_stage2::Query<raw32_stage3::RawHash<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul> > > >(raw32_stage3::RawHash<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x89>
   2ecd5:	vmovdqa -0x2a57d(%rip),%ymm3        # 4760 <bloom_filters::FastPatternBF::sparse_patterns_+0x1c0>
   2ecdd:	vmovdqa -0x2a625(%rip),%ymm2        # 46c0 <bloom_filters::FastPatternBF::sparse_patterns_+0x120>
   2ece5:	xor    %esi,%esi
   2ece7:	movabs $0xd6e8feb86659fd93,%rdi
   2ecf1:	movabs $0xf1357aea2e62a9c5,%r8
   2ecfb:	nopl   0x0(%rax,%rax,1)
   2ed00:	mov    0x18(%rsp),%rax
   2ed05:	mov    (%rax,%rsi,4),%ecx
   2ed08:	imul   %rdi,%rcx
   2ed0c:	mov    %rcx,%rax
   2ed0f:	shr    $0x20,%rax
   2ed13:	xor    %rax,%rcx
   2ed16:	imul   %rdi,%rcx
   2ed1a:	mov    %rcx,%rax
   2ed1d:	shr    $0x20,%rax
   2ed21:	xor    %rax,%rcx
   2ed24:	or     $0x1,%rcx
   2ed28:	mov    %rcx,%rax
   2ed2b:	imul   %r8,%rcx
   2ed2f:	mulq   0x10(%rbx)
   2ed33:	xor    %eax,%eax
   2ed35:	vpbroadcastq %rcx,%ymm0
   2ed3b:	vpsllvq %ymm3,%ymm0,%ymm0
   2ed40:	shl    $0x4,%rdx
   2ed44:	add    0x20(%rbx),%rdx
   2ed48:	vpsrld $0x1b,%ymm0,%ymm0
   2ed4d:	vmovdqu (%rdx),%ymm1
   2ed51:	vpsllvd %ymm0,%ymm2,%ymm0
   2ed56:	prefetcht0 (%rdx)
   2ed59:	vptest %ymm0,%ymm1
   2ed5e:	prefetcht0 0x40(%rdx)
   2ed62:	mov    0x10(%rsp),%rdx
   2ed67:	setb   %al
   2ed6a:	mov    %eax,(%rdx,%rsi,4)
   2ed6d:	inc    %rsi
   2ed70:	cmp    %rsi,%r12
   2ed73:	jne    2ed00 <void vldb_stage2::Query<raw32_stage3::RawHash<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul> > > >(raw32_stage3::RawHash<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0xd0>
   2ed75:	vzeroupper
   2ed78:	lea    -0x28(%rbp),%rsp
   2ed7c:	pop    %rbx
   2ed7d:	pop    %r12
   2ed7f:	pop    %r13
   2ed81:	pop    %r14
   2ed83:	pop    %r15
   2ed85:	pop    %rbp
   2ed86:	ret
