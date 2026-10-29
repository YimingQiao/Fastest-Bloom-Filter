
/home/yiming/projects/fastest-bf-lab/build/vldb-raw32-stage3-v2/native/modern:     file format elf64-x86-64


Disassembly of section .text:

0000000000030170 <void vldb_stage2::Query<raw32_stage3::RawHash<external_bloom::SingleShortcutV1<external_bloom::SimdBlock>, raw32_stage3::ModernPolicy<external_bloom::SingleShortcutV1<external_bloom::SimdBlock> > > >(raw32_stage3::RawHash<external_bloom::SingleShortcutV1<external_bloom::SimdBlock>, raw32_stage3::ModernPolicy<external_bloom::SingleShortcutV1<external_bloom::SimdBlock> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
   30170:	push   %rbp
   30171:	mov    %rsp,%rbp
   30174:	push   %r15
   30176:	push   %r14
   30178:	mov    %rdi,%r14
   3017b:	push   %r13
   3017d:	push   %r12
   3017f:	push   %rbx
   30180:	mov    %rdx,%rbx
   30183:	and    $0xffffffffffffffe0,%rsp
   30187:	sub    $0x20,%rsp
   3018b:	mov    %rcx,0x18(%rsp)
   30190:	mov    %r8,0x10(%rsp)
   30195:	test   %esi,%esi
   30197:	je     30210 <void vldb_stage2::Query<raw32_stage3::RawHash<external_bloom::SingleShortcutV1<external_bloom::SimdBlock>, raw32_stage3::ModernPolicy<external_bloom::SingleShortcutV1<external_bloom::SimdBlock> > > >(raw32_stage3::RawHash<external_bloom::SingleShortcutV1<external_bloom::SimdBlock>, raw32_stage3::ModernPolicy<external_bloom::SingleShortcutV1<external_bloom::SimdBlock> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0xa0>
   30199:	cmp    $0x1,%esi
   3019c:	mov    $0x1000,%r15d
   301a2:	mov    $0x1,%eax
   301a7:	cmove  %rax,%r15
   301ab:	test   %rdx,%rdx
   301ae:	je     301f9 <void vldb_stage2::Query<raw32_stage3::RawHash<external_bloom::SingleShortcutV1<external_bloom::SimdBlock>, raw32_stage3::ModernPolicy<external_bloom::SingleShortcutV1<external_bloom::SimdBlock> > > >(raw32_stage3::RawHash<external_bloom::SingleShortcutV1<external_bloom::SimdBlock>, raw32_stage3::ModernPolicy<external_bloom::SingleShortcutV1<external_bloom::SimdBlock> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x89>
   301b0:	mov    %rdx,%r13
   301b3:	xor    %r12d,%r12d
   301b6:	cs nopw 0x0(%rax,%rax,1)
   301c0:	mov    0x10(%rsp),%rax
   301c5:	lea    0x0(,%r12,4),%rdx
   301cd:	lea    (%rax,%rdx,1),%rcx
   301d1:	mov    0x18(%rsp),%rax
   301d6:	mov    %r14,%rdi
   301d9:	add    %rax,%rdx
   301dc:	cmp    %r15,%r13
   301df:	mov    %r15,%rax
   301e2:	cmovbe %r13,%rax
   301e6:	add    %r15,%r12
   301e9:	mov    %rax,%rsi
   301ec:	call   30030 <void vldb_stage2::DenseCall<raw32_stage3::RawHash<external_bloom::SingleShortcutV1<external_bloom::SimdBlock>, raw32_stage3::ModernPolicy<external_bloom::SingleShortcutV1<external_bloom::SimdBlock> > > >(raw32_stage3::RawHash<external_bloom::SingleShortcutV1<external_bloom::SimdBlock>, raw32_stage3::ModernPolicy<external_bloom::SingleShortcutV1<external_bloom::SimdBlock> > > const&, unsigned int, unsigned int const*, unsigned int*)>
   301f1:	sub    %r15,%r13
   301f4:	cmp    %rbx,%r12
   301f7:	jb     301c0 <void vldb_stage2::Query<raw32_stage3::RawHash<external_bloom::SingleShortcutV1<external_bloom::SimdBlock>, raw32_stage3::ModernPolicy<external_bloom::SingleShortcutV1<external_bloom::SimdBlock> > > >(raw32_stage3::RawHash<external_bloom::SingleShortcutV1<external_bloom::SimdBlock>, raw32_stage3::ModernPolicy<external_bloom::SingleShortcutV1<external_bloom::SimdBlock> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x50>
   301f9:	lea    -0x28(%rbp),%rsp
   301fd:	pop    %rbx
   301fe:	pop    %r12
   30200:	pop    %r13
   30202:	pop    %r14
   30204:	pop    %r15
   30206:	pop    %rbp
   30207:	ret
   30208:	nopl   0x0(%rax,%rax,1)
   30210:	test   %rdx,%rdx
   30213:	je     301f9 <void vldb_stage2::Query<raw32_stage3::RawHash<external_bloom::SingleShortcutV1<external_bloom::SimdBlock>, raw32_stage3::ModernPolicy<external_bloom::SingleShortcutV1<external_bloom::SimdBlock> > > >(raw32_stage3::RawHash<external_bloom::SingleShortcutV1<external_bloom::SimdBlock>, raw32_stage3::ModernPolicy<external_bloom::SingleShortcutV1<external_bloom::SimdBlock> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x89>
   30215:	mov    $0x1,%eax
   3021a:	vmovdqa -0x2bbc2(%rip),%ymm3        # 4660 <bloom_filters::FastPatternBF::sparse_patterns_+0xc0>
   30222:	xor    %edx,%edx
   30224:	movabs $0xd6e8feb86659fd93,%rcx
   3022e:	vpbroadcastd %eax,%ymm2
   30234:	nopl   0x0(%rax)
   30238:	mov    0x18(%rsp),%rax
   3023d:	mov    0x10(%rsp),%rdi
   30242:	mov    (%rax,%rdx,4),%eax
   30245:	imul   %rcx,%rax
   30249:	mov    %rax,%rsi
   3024c:	shr    $0x20,%rsi
   30250:	xor    %rsi,%rax
   30253:	imul   %rcx,%rax
   30257:	mov    %rax,%rsi
   3025a:	shr    $0x20,%rsi
   3025e:	xor    %rsi,%rax
   30261:	mov    (%r14),%esi
   30264:	shrx   %rsi,%rax,%rsi
   30269:	vpbroadcastd %esi,%ymm0
   3026f:	vpmulld %ymm3,%ymm0,%ymm0
   30274:	and    0x4(%r14),%eax
   30278:	shl    $0x5,%rax
   3027c:	add    0x8(%r14),%rax
   30280:	vmovdqa (%rax),%ymm1
   30284:	vpsrld $0x1b,%ymm0,%ymm0
   30289:	vpsllvd %ymm0,%ymm2,%ymm0
   3028e:	xor    %eax,%eax
   30290:	vptest %ymm0,%ymm1
   30295:	setb   %al
   30298:	mov    %eax,(%rdi,%rdx,4)
   3029b:	inc    %rdx
   3029e:	cmp    %rdx,%rbx
   302a1:	jne    30238 <void vldb_stage2::Query<raw32_stage3::RawHash<external_bloom::SingleShortcutV1<external_bloom::SimdBlock>, raw32_stage3::ModernPolicy<external_bloom::SingleShortcutV1<external_bloom::SimdBlock> > > >(raw32_stage3::RawHash<external_bloom::SingleShortcutV1<external_bloom::SimdBlock>, raw32_stage3::ModernPolicy<external_bloom::SingleShortcutV1<external_bloom::SimdBlock> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0xc8>
   302a3:	vzeroupper
   302a6:	lea    -0x28(%rbp),%rsp
   302aa:	pop    %rbx
   302ab:	pop    %r12
   302ad:	pop    %r13
   302af:	pop    %r14
   302b1:	pop    %r15
   302b3:	pop    %rbp
   302b4:	ret
