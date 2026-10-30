
/home/yiming/projects/fastest-bf-lab/build/vldb-raw32-stage3-v2/native/modern:     file format elf64-x86-64


Disassembly of section .text:

000000000002f140 <void vldb_stage2::Query<raw32_stage3::RawHash<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<8ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<8ul>, 0ul> > > >(raw32_stage3::RawHash<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<8ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<8ul>, 0ul> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
   2f140:	push   %rbp
   2f141:	mov    %rsp,%rbp
   2f144:	push   %r15
   2f146:	push   %r14
   2f148:	push   %r13
   2f14a:	push   %r12
   2f14c:	mov    %rdx,%r12
   2f14f:	push   %rbx
   2f150:	mov    %rdi,%rbx
   2f153:	and    $0xffffffffffffffe0,%rsp
   2f157:	sub    $0x20,%rsp
   2f15b:	mov    %rcx,0x18(%rsp)
   2f160:	mov    %r8,0x10(%rsp)
   2f165:	test   %esi,%esi
   2f167:	je     2f1e0 <void vldb_stage2::Query<raw32_stage3::RawHash<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<8ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<8ul>, 0ul> > > >(raw32_stage3::RawHash<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<8ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<8ul>, 0ul> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0xa0>
   2f169:	cmp    $0x1,%esi
   2f16c:	mov    $0x1000,%r15d
   2f172:	mov    $0x1,%eax
   2f177:	cmove  %rax,%r15
   2f17b:	test   %rdx,%rdx
   2f17e:	je     2f1c9 <void vldb_stage2::Query<raw32_stage3::RawHash<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<8ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<8ul>, 0ul> > > >(raw32_stage3::RawHash<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<8ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<8ul>, 0ul> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x89>
   2f180:	mov    %rdx,%r14
   2f183:	xor    %r13d,%r13d
   2f186:	cs nopw 0x0(%rax,%rax,1)
   2f190:	mov    0x10(%rsp),%rax
   2f195:	lea    0x0(,%r13,4),%rdx
   2f19d:	lea    (%rax,%rdx,1),%rcx
   2f1a1:	mov    0x18(%rsp),%rax
   2f1a6:	mov    %rbx,%rdi
   2f1a9:	add    %rax,%rdx
   2f1ac:	cmp    %r14,%r15
   2f1af:	mov    %r14,%rax
   2f1b2:	cmovbe %r15,%rax
   2f1b6:	add    %r15,%r13
   2f1b9:	mov    %rax,%rsi
   2f1bc:	call   2f010 <void vldb_stage2::DenseCall<raw32_stage3::RawHash<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<8ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<8ul>, 0ul> > > >(raw32_stage3::RawHash<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<8ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<8ul>, 0ul> > > const&, unsigned int, unsigned int const*, unsigned int*)>
   2f1c1:	sub    %r15,%r14
   2f1c4:	cmp    %r12,%r13
   2f1c7:	jb     2f190 <void vldb_stage2::Query<raw32_stage3::RawHash<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<8ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<8ul>, 0ul> > > >(raw32_stage3::RawHash<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<8ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<8ul>, 0ul> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x50>
   2f1c9:	lea    -0x28(%rbp),%rsp
   2f1cd:	pop    %rbx
   2f1ce:	pop    %r12
   2f1d0:	pop    %r13
   2f1d2:	pop    %r14
   2f1d4:	pop    %r15
   2f1d6:	pop    %rbp
   2f1d7:	ret
   2f1d8:	nopl   0x0(%rax,%rax,1)
   2f1e0:	test   %rdx,%rdx
   2f1e3:	je     2f1c9 <void vldb_stage2::Query<raw32_stage3::RawHash<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<8ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<8ul>, 0ul> > > >(raw32_stage3::RawHash<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<8ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<8ul>, 0ul> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x89>
   2f1e5:	mov    $0x1,%eax
   2f1ea:	vmovdqa -0x2aad2(%rip),%ymm3        # 4720 <bloom_filters::FastPatternBF::sparse_patterns_+0x180>
   2f1f2:	xor    %esi,%esi
   2f1f4:	movabs $0xd6e8feb86659fd93,%rdi
   2f1fe:	movabs $0xf1357aea2e62a9c5,%r8
   2f208:	vpbroadcastq %rax,%ymm2
   2f20e:	xchg   %ax,%ax
   2f210:	mov    0x18(%rsp),%rax
   2f215:	mov    (%rax,%rsi,4),%ecx
   2f218:	imul   %rdi,%rcx
   2f21c:	mov    %rcx,%rax
   2f21f:	shr    $0x20,%rax
   2f223:	xor    %rax,%rcx
   2f226:	imul   %rdi,%rcx
   2f22a:	mov    %rcx,%rax
   2f22d:	shr    $0x20,%rax
   2f231:	xor    %rax,%rcx
   2f234:	or     $0x1,%rcx
   2f238:	mov    %rcx,%rax
   2f23b:	imul   %r8,%rcx
   2f23f:	mulq   0x10(%rbx)
   2f243:	vpbroadcastq %rcx,%ymm0
   2f249:	vpsllvq %ymm3,%ymm0,%ymm0
   2f24e:	shl    $0x6,%rdx
   2f252:	vpsrld $0x1a,%ymm0,%ymm0
   2f257:	add    0x20(%rbx),%rdx
   2f25b:	vpmovzxdq %xmm0,%ymm1
   2f260:	vmovdqa (%rdx),%ymm4
   2f264:	vpsllvq %ymm1,%ymm2,%ymm1
   2f269:	vextracti64x2 $0x1,%ymm0,%xmm0
   2f270:	xor    %ecx,%ecx
   2f272:	vpmovzxdq %xmm0,%ymm0
   2f277:	vptest %ymm1,%ymm4
   2f27c:	vpsllvq %ymm0,%ymm2,%ymm0
   2f281:	vmovdqa 0x20(%rdx),%ymm1
   2f286:	setb   %cl
   2f289:	xor    %eax,%eax
   2f28b:	vptest %ymm0,%ymm1
   2f290:	prefetcht0 (%rdx)
   2f293:	mov    0x10(%rsp),%rdx
   2f298:	setb   %al
   2f29b:	and    %ecx,%eax
   2f29d:	mov    %eax,(%rdx,%rsi,4)
   2f2a0:	inc    %rsi
   2f2a3:	cmp    %rsi,%r12
   2f2a6:	jne    2f210 <void vldb_stage2::Query<raw32_stage3::RawHash<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<8ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<8ul>, 0ul> > > >(raw32_stage3::RawHash<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<8ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<8ul>, 0ul> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0xd0>
   2f2ac:	vzeroupper
   2f2af:	lea    -0x28(%rbp),%rsp
   2f2b3:	pop    %rbx
   2f2b4:	pop    %r12
   2f2b6:	pop    %r13
   2f2b8:	pop    %r14
   2f2ba:	pop    %r15
   2f2bc:	pop    %rbp
   2f2bd:	ret
