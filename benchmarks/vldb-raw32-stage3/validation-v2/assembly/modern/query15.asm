
/home/yiming/projects/fastest-bf-lab/build/vldb-raw32-stage3-v2/native/modern:     file format elf64-x86-64


Disassembly of section .text:

00000000000303c0 <void vldb_stage2::Query<raw32_stage3::RawHash<rocksdb_external::FastLocalBloom64<8, false>, raw32_stage3::ModernPolicy<rocksdb_external::FastLocalBloom64<8, false> > > >(raw32_stage3::RawHash<rocksdb_external::FastLocalBloom64<8, false>, raw32_stage3::ModernPolicy<rocksdb_external::FastLocalBloom64<8, false> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
   303c0:	push   %rbp
   303c1:	mov    %rsp,%rbp
   303c4:	push   %r15
   303c6:	push   %r14
   303c8:	push   %r13
   303ca:	push   %r12
   303cc:	mov    %rdx,%r12
   303cf:	push   %rbx
   303d0:	mov    %rdi,%rbx
   303d3:	and    $0xffffffffffffffe0,%rsp
   303d7:	sub    $0x20,%rsp
   303db:	mov    %rcx,0x18(%rsp)
   303e0:	mov    %r8,0x10(%rsp)
   303e5:	test   %esi,%esi
   303e7:	je     30458 <void vldb_stage2::Query<raw32_stage3::RawHash<rocksdb_external::FastLocalBloom64<8, false>, raw32_stage3::ModernPolicy<rocksdb_external::FastLocalBloom64<8, false> > > >(raw32_stage3::RawHash<rocksdb_external::FastLocalBloom64<8, false>, raw32_stage3::ModernPolicy<rocksdb_external::FastLocalBloom64<8, false> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x98>
   303e9:	cmp    $0x1,%esi
   303ec:	mov    $0x1000,%r15d
   303f2:	mov    $0x1,%eax
   303f7:	cmove  %rax,%r15
   303fb:	test   %rdx,%rdx
   303fe:	je     30449 <void vldb_stage2::Query<raw32_stage3::RawHash<rocksdb_external::FastLocalBloom64<8, false>, raw32_stage3::ModernPolicy<rocksdb_external::FastLocalBloom64<8, false> > > >(raw32_stage3::RawHash<rocksdb_external::FastLocalBloom64<8, false>, raw32_stage3::ModernPolicy<rocksdb_external::FastLocalBloom64<8, false> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x89>
   30400:	mov    %rdx,%r14
   30403:	xor    %r13d,%r13d
   30406:	cs nopw 0x0(%rax,%rax,1)
   30410:	mov    0x10(%rsp),%rax
   30415:	lea    0x0(,%r13,4),%rdx
   3041d:	lea    (%rax,%rdx,1),%rcx
   30421:	mov    0x18(%rsp),%rax
   30426:	mov    %rbx,%rdi
   30429:	add    %rax,%rdx
   3042c:	cmp    %r14,%r15
   3042f:	mov    %r14,%rax
   30432:	cmovbe %r15,%rax
   30436:	add    %r15,%r13
   30439:	mov    %rax,%rsi
   3043c:	call   302d0 <void vldb_stage2::DenseCall<raw32_stage3::RawHash<rocksdb_external::FastLocalBloom64<8, false>, raw32_stage3::ModernPolicy<rocksdb_external::FastLocalBloom64<8, false> > > >(raw32_stage3::RawHash<rocksdb_external::FastLocalBloom64<8, false>, raw32_stage3::ModernPolicy<rocksdb_external::FastLocalBloom64<8, false> > > const&, unsigned int, unsigned int const*, unsigned int*)>
   30441:	sub    %r15,%r14
   30444:	cmp    %r12,%r13
   30447:	jb     30410 <void vldb_stage2::Query<raw32_stage3::RawHash<rocksdb_external::FastLocalBloom64<8, false>, raw32_stage3::ModernPolicy<rocksdb_external::FastLocalBloom64<8, false> > > >(raw32_stage3::RawHash<rocksdb_external::FastLocalBloom64<8, false>, raw32_stage3::ModernPolicy<rocksdb_external::FastLocalBloom64<8, false> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x50>
   30449:	lea    -0x28(%rbp),%rsp
   3044d:	pop    %rbx
   3044e:	pop    %r12
   30450:	pop    %r13
   30452:	pop    %r14
   30454:	pop    %r15
   30456:	pop    %rbp
   30457:	ret
   30458:	test   %rdx,%rdx
   3045b:	je     30449 <void vldb_stage2::Query<raw32_stage3::RawHash<rocksdb_external::FastLocalBloom64<8, false>, raw32_stage3::ModernPolicy<rocksdb_external::FastLocalBloom64<8, false> > > >(raw32_stage3::RawHash<rocksdb_external::FastLocalBloom64<8, false>, raw32_stage3::ModernPolicy<rocksdb_external::FastLocalBloom64<8, false> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x89>
   3045d:	mov    $0x1,%eax
   30462:	vmovdqa -0x2bd2a(%rip),%ymm5        # 4740 <bloom_filters::FastPatternBF::sparse_patterns_+0x1a0>
   3046a:	xor    %ecx,%ecx
   3046c:	movabs $0xd6e8feb86659fd93,%rsi
   30476:	vpbroadcastd %eax,%ymm4
   3047c:	nopl   0x0(%rax)
   30480:	mov    0x18(%rsp),%rax
   30485:	mov    $0x6,%edi
   3048a:	mov    (%rax,%rcx,4),%eax
   3048d:	imul   %rsi,%rax
   30491:	mov    %rax,%rdx
   30494:	shr    $0x20,%rdx
   30498:	xor    %rdx,%rax
   3049b:	imul   %rsi,%rax
   3049f:	mov    %rax,%rdx
   304a2:	shr    $0x20,%rdx
   304a6:	xor    %rdx,%rax
   304a9:	shrx   %edi,0x18(%rbx),%edx
   304af:	mov    %eax,%edi
   304b1:	shr    $0x20,%rax
   304b5:	vpbroadcastd %eax,%ymm0
   304bb:	vpmulld %ymm5,%ymm0,%ymm0
   304c0:	imul   %rdi,%rdx
   304c4:	xor    %eax,%eax
   304c6:	mov    0x10(%rsp),%rdi
   304cb:	shr    $0x20,%rdx
   304cf:	shl    $0x6,%rdx
   304d3:	add    (%rbx),%rdx
   304d6:	vpsrld $0x1c,%ymm0,%ymm1
   304db:	vpsrad $0x1f,%ymm0,%ymm3
   304e0:	vpslld $0x4,%ymm0,%ymm0
   304e5:	vxorps %xmm2,%xmm2,%xmm2
   304e9:	vpermd (%rdx),%ymm1,%ymm2
   304ee:	vpsrld $0x1b,%ymm0,%ymm0
   304f3:	vpermd 0x20(%rdx),%ymm1,%ymm1
   304f9:	vpsllvd %ymm0,%ymm4,%ymm0
   304fe:	vpblendvb %ymm3,%ymm1,%ymm2,%ymm1
   30504:	vptest %ymm0,%ymm1
   30509:	setb   %al
   3050c:	mov    %eax,(%rdi,%rcx,4)
   3050f:	inc    %rcx
   30512:	cmp    %rcx,%r12
   30515:	jne    30480 <void vldb_stage2::Query<raw32_stage3::RawHash<rocksdb_external::FastLocalBloom64<8, false>, raw32_stage3::ModernPolicy<rocksdb_external::FastLocalBloom64<8, false> > > >(raw32_stage3::RawHash<rocksdb_external::FastLocalBloom64<8, false>, raw32_stage3::ModernPolicy<rocksdb_external::FastLocalBloom64<8, false> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0xc0>
   3051b:	vzeroupper
   3051e:	lea    -0x28(%rbp),%rsp
   30522:	pop    %rbx
   30523:	pop    %r12
   30525:	pop    %r13
   30527:	pop    %r14
   30529:	pop    %r15
   3052b:	pop    %rbp
   3052c:	ret
