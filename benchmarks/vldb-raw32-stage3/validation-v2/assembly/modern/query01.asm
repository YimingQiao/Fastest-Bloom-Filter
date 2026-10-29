
/home/yiming/projects/fastest-bf-lab/build/vldb-raw32-stage3-v2/native/modern:     file format elf64-x86-64


Disassembly of section .text:

000000000002e0d0 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > >(raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
   2e0d0:	push   %rbp
   2e0d1:	mov    %rsp,%rbp
   2e0d4:	push   %r15
   2e0d6:	push   %r14
   2e0d8:	push   %r13
   2e0da:	push   %r12
   2e0dc:	mov    %rdx,%r12
   2e0df:	push   %rbx
   2e0e0:	mov    %rdi,%rbx
   2e0e3:	and    $0xffffffffffffffc0,%rsp
   2e0e7:	sub    $0x40,%rsp
   2e0eb:	mov    %rcx,0x38(%rsp)
   2e0f0:	mov    %r8,0x30(%rsp)
   2e0f5:	test   %esi,%esi
   2e0f7:	je     2e170 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > >(raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0xa0>
   2e0f9:	cmp    $0x1,%esi
   2e0fc:	mov    $0x1000,%r15d
   2e102:	mov    $0x1,%eax
   2e107:	cmove  %rax,%r15
   2e10b:	test   %rdx,%rdx
   2e10e:	je     2e159 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > >(raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x89>
   2e110:	mov    %rdx,%r14
   2e113:	xor    %r13d,%r13d
   2e116:	cs nopw 0x0(%rax,%rax,1)
   2e120:	mov    0x30(%rsp),%rax
   2e125:	lea    0x0(,%r13,4),%rdx
   2e12d:	lea    (%rax,%rdx,1),%rcx
   2e131:	mov    0x38(%rsp),%rax
   2e136:	mov    %rbx,%rdi
   2e139:	add    %rax,%rdx
   2e13c:	cmp    %r15,%r14
   2e13f:	mov    %r15,%rax
   2e142:	cmovbe %r14,%rax
   2e146:	add    %r15,%r13
   2e149:	mov    %rax,%rsi
   2e14c:	call   2de70 <void vldb_stage2::DenseCall<raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > >(raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > const&, unsigned int, unsigned int const*, unsigned int*)>
   2e151:	sub    %r15,%r14
   2e154:	cmp    %r12,%r13
   2e157:	jb     2e120 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > >(raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x50>
   2e159:	lea    -0x28(%rbp),%rsp
   2e15d:	pop    %rbx
   2e15e:	pop    %r12
   2e160:	pop    %r13
   2e162:	pop    %r14
   2e164:	pop    %r15
   2e166:	pop    %rbp
   2e167:	ret
   2e168:	nopl   0x0(%rax,%rax,1)
   2e170:	test   %rdx,%rdx
   2e173:	je     2e159 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > >(raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x89>
   2e175:	mov    $0x1,%eax
   2e17a:	vmovdqa -0x29b22(%rip),%ymm3        # 4660 <bloom_filters::FastPatternBF::sparse_patterns_+0xc0>
   2e182:	xor    %edx,%edx
   2e184:	movabs $0xd6e8feb86659fd93,%rcx
   2e18e:	vpbroadcastq %rax,%zmm2
   2e194:	nopl   0x0(%rax)
   2e198:	mov    0x38(%rsp),%rax
   2e19d:	mov    0x30(%rsp),%rdi
   2e1a2:	mov    (%rax,%rdx,4),%eax
   2e1a5:	imul   %rcx,%rax
   2e1a9:	mov    %rax,%rsi
   2e1ac:	shr    $0x20,%rsi
   2e1b0:	xor    %rsi,%rax
   2e1b3:	imul   %rcx,%rax
   2e1b7:	mov    %rax,%rsi
   2e1ba:	shr    $0x20,%rsi
   2e1be:	xor    %rsi,%rax
   2e1c1:	vpbroadcastd %eax,%ymm0
   2e1c7:	vpmulld %ymm3,%ymm0,%ymm0
   2e1cc:	shr    $0x20,%rax
   2e1d0:	and    0x18(%rbx),%eax
   2e1d3:	shl    $0x6,%rax
   2e1d7:	add    (%rbx),%rax
   2e1da:	vpsrld $0x1a,%ymm0,%ymm0
   2e1df:	vpmovzxdq %ymm0,%zmm0
   2e1e5:	vmovdqa64 (%rax),%zmm1
   2e1eb:	vpsllvq %zmm0,%zmm2,%zmm0
   2e1f1:	xor    %eax,%eax
   2e1f3:	vptestnmq %zmm0,%zmm1,%k0
   2e1f9:	kortestb %k0,%k0
   2e1fd:	sete   %al
   2e200:	mov    %eax,(%rdi,%rdx,4)
   2e203:	inc    %rdx
   2e206:	cmp    %rdx,%r12
   2e209:	jne    2e198 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > >(raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0xc8>
   2e20b:	vzeroupper
   2e20e:	lea    -0x28(%rbp),%rsp
   2e212:	pop    %rbx
   2e213:	pop    %r12
   2e215:	pop    %r13
   2e217:	pop    %r14
   2e219:	pop    %r15
   2e21b:	pop    %rbp
   2e21c:	ret
