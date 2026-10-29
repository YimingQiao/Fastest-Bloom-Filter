
/home/yiming/projects/fastest-bf-lab/build/vldb-raw32-stage3-v1/native/legacy:     file format elf64-x86-64


Disassembly of section .text:

000000000049b010 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > >(raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
  49b010:	push   %rbp
  49b011:	mov    %rsp,%rbp
  49b014:	push   %r15
  49b016:	push   %r14
  49b018:	push   %r13
  49b01a:	push   %r12
  49b01c:	mov    %rdx,%r12
  49b01f:	push   %rbx
  49b020:	mov    %rdi,%rbx
  49b023:	and    $0xffffffffffffffc0,%rsp
  49b027:	sub    $0x40,%rsp
  49b02b:	mov    %rcx,0x38(%rsp)
  49b030:	mov    %r8,0x30(%rsp)
  49b035:	test   %esi,%esi
  49b037:	je     49b0b0 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > >(raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0xa0>
  49b039:	cmp    $0x1,%esi
  49b03c:	mov    $0x1000,%r15d
  49b042:	mov    $0x1,%eax
  49b047:	cmove  %rax,%r15
  49b04b:	test   %rdx,%rdx
  49b04e:	je     49b099 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > >(raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x89>
  49b050:	mov    %rdx,%r14
  49b053:	xor    %r13d,%r13d
  49b056:	cs nopw 0x0(%rax,%rax,1)
  49b060:	mov    0x30(%rsp),%rax
  49b065:	lea    0x0(,%r13,4),%rdx
  49b06d:	lea    (%rax,%rdx,1),%rcx
  49b071:	mov    0x38(%rsp),%rax
  49b076:	mov    %rbx,%rdi
  49b079:	add    %rax,%rdx
  49b07c:	cmp    %r15,%r14
  49b07f:	mov    %r15,%rax
  49b082:	cmovbe %r14,%rax
  49b086:	add    %r15,%r13
  49b089:	mov    %rax,%rsi
  49b08c:	call   49adb0 <void vldb_stage2::DenseCall<raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > >(raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > const&, unsigned int, unsigned int const*, unsigned int*)>
  49b091:	sub    %r15,%r14
  49b094:	cmp    %r12,%r13
  49b097:	jb     49b060 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > >(raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x50>
  49b099:	lea    -0x28(%rbp),%rsp
  49b09d:	pop    %rbx
  49b09e:	pop    %r12
  49b0a0:	pop    %r13
  49b0a2:	pop    %r14
  49b0a4:	pop    %r15
  49b0a6:	pop    %rbp
  49b0a7:	ret
  49b0a8:	nopl   0x0(%rax,%rax,1)
  49b0b0:	test   %rdx,%rdx
  49b0b3:	je     49b099 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > >(raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x89>
  49b0b5:	mov    $0x1,%eax
  49b0ba:	vmovdqa -0x29fac2(%rip),%ymm3        # 1fb600 <bloom_filters::FastPatternBF::sparse_patterns_+0x80>
  49b0c2:	xor    %edx,%edx
  49b0c4:	movabs $0xd6e8feb86659fd93,%rcx
  49b0ce:	vpbroadcastq %rax,%zmm2
  49b0d4:	nopl   0x0(%rax)
  49b0d8:	mov    0x38(%rsp),%rax
  49b0dd:	mov    0x30(%rsp),%rdi
  49b0e2:	mov    (%rax,%rdx,4),%eax
  49b0e5:	imul   %rcx,%rax
  49b0e9:	mov    %rax,%rsi
  49b0ec:	shr    $0x20,%rsi
  49b0f0:	xor    %rsi,%rax
  49b0f3:	imul   %rcx,%rax
  49b0f7:	mov    %rax,%rsi
  49b0fa:	shr    $0x20,%rsi
  49b0fe:	xor    %rsi,%rax
  49b101:	vpbroadcastd %eax,%ymm0
  49b107:	vpmulld %ymm3,%ymm0,%ymm0
  49b10c:	shr    $0x20,%rax
  49b110:	and    0x18(%rbx),%eax
  49b113:	shl    $0x6,%rax
  49b117:	add    (%rbx),%rax
  49b11a:	vpsrld $0x1a,%ymm0,%ymm0
  49b11f:	vpmovzxdq %ymm0,%zmm0
  49b125:	vmovdqa64 (%rax),%zmm1
  49b12b:	vpsllvq %zmm0,%zmm2,%zmm0
  49b131:	xor    %eax,%eax
  49b133:	vptestnmq %zmm0,%zmm1,%k0
  49b139:	kortestb %k0,%k0
  49b13d:	sete   %al
  49b140:	mov    %eax,(%rdi,%rdx,4)
  49b143:	inc    %rdx
  49b146:	cmp    %rdx,%r12
  49b149:	jne    49b0d8 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > >(raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0xc8>
  49b14b:	vzeroupper
  49b14e:	lea    -0x28(%rbp),%rsp
  49b152:	pop    %rbx
  49b153:	pop    %r12
  49b155:	pop    %r13
  49b157:	pop    %r14
  49b159:	pop    %r15
  49b15b:	pop    %rbp
  49b15c:	ret
