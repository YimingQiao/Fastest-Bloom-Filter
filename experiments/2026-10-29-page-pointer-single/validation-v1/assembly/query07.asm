
/home/yiming/projects/fastest-bf-lab/build/page-pointer-preflight-v1/native/worker/page_pointer_control:     file format elf64-x86-64


Disassembly of section .text:

0000000000022e00 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > >(raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
   22e00:	push   %rbp
   22e01:	mov    %rsp,%rbp
   22e04:	push   %r15
   22e06:	push   %r14
   22e08:	push   %r13
   22e0a:	push   %r12
   22e0c:	mov    %rdx,%r12
   22e0f:	push   %rbx
   22e10:	mov    %rdi,%rbx
   22e13:	and    $0xffffffffffffffc0,%rsp
   22e17:	sub    $0x40,%rsp
   22e1b:	mov    %rcx,0x38(%rsp)
   22e20:	mov    %r8,0x30(%rsp)
   22e25:	test   %esi,%esi
   22e27:	je     22ea0 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > >(raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0xa0>
   22e29:	cmp    $0x1,%esi
   22e2c:	mov    $0x1000,%r15d
   22e32:	mov    $0x1,%eax
   22e37:	cmove  %rax,%r15
   22e3b:	test   %rdx,%rdx
   22e3e:	je     22e89 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > >(raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x89>
   22e40:	mov    %rdx,%r14
   22e43:	xor    %r13d,%r13d
   22e46:	cs nopw 0x0(%rax,%rax,1)
   22e50:	mov    0x30(%rsp),%rax
   22e55:	lea    0x0(,%r13,4),%rdx
   22e5d:	lea    (%rax,%rdx,1),%rcx
   22e61:	mov    0x38(%rsp),%rax
   22e66:	mov    %rbx,%rdi
   22e69:	add    %rax,%rdx
   22e6c:	cmp    %r15,%r14
   22e6f:	mov    %r15,%rax
   22e72:	cmovbe %r14,%rax
   22e76:	add    %r15,%r13
   22e79:	mov    %rax,%rsi
   22e7c:	call   22ba0 <void vldb_stage2::DenseCall<raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > >(raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > const&, unsigned int, unsigned int const*, unsigned int*)>
   22e81:	sub    %r15,%r14
   22e84:	cmp    %r12,%r13
   22e87:	jb     22e50 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > >(raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x50>
   22e89:	lea    -0x28(%rbp),%rsp
   22e8d:	pop    %rbx
   22e8e:	pop    %r12
   22e90:	pop    %r13
   22e92:	pop    %r14
   22e94:	pop    %r15
   22e96:	pop    %rbp
   22e97:	ret
   22e98:	nopl   0x0(%rax,%rax,1)
   22ea0:	test   %rdx,%rdx
   22ea3:	je     22e89 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > >(raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x89>
   22ea5:	mov    $0x1,%eax
   22eaa:	vmovdqa -0x1eb12(%rip),%ymm3        # 43a0 <bloom_filters::FastPatternBF::sparse_patterns_+0xc0>
   22eb2:	xor    %edx,%edx
   22eb4:	movabs $0xd6e8feb86659fd93,%rcx
   22ebe:	vpbroadcastq %rax,%zmm2
   22ec4:	nopl   0x0(%rax)
   22ec8:	mov    0x38(%rsp),%rax
   22ecd:	mov    0x30(%rsp),%rdi
   22ed2:	mov    (%rax,%rdx,4),%eax
   22ed5:	imul   %rcx,%rax
   22ed9:	mov    %rax,%rsi
   22edc:	shr    $0x20,%rsi
   22ee0:	xor    %rsi,%rax
   22ee3:	imul   %rcx,%rax
   22ee7:	mov    %rax,%rsi
   22eea:	shr    $0x20,%rsi
   22eee:	xor    %rsi,%rax
   22ef1:	vpbroadcastd %eax,%ymm0
   22ef7:	vpmulld %ymm3,%ymm0,%ymm0
   22efc:	shr    $0x20,%rax
   22f00:	and    0x18(%rbx),%eax
   22f03:	shl    $0x6,%rax
   22f07:	add    (%rbx),%rax
   22f0a:	vpsrld $0x1a,%ymm0,%ymm0
   22f0f:	vpmovzxdq %ymm0,%zmm0
   22f15:	vmovdqa64 (%rax),%zmm1
   22f1b:	vpsllvq %zmm0,%zmm2,%zmm0
   22f21:	xor    %eax,%eax
   22f23:	vptestnmq %zmm0,%zmm1,%k0
   22f29:	kortestb %k0,%k0
   22f2d:	sete   %al
   22f30:	mov    %eax,(%rdi,%rdx,4)
   22f33:	inc    %rdx
   22f36:	cmp    %rdx,%r12
   22f39:	jne    22ec8 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > >(raw32_stage3::RawHash<bloom_filters::Split64BloomFilter, raw32_stage3::NativePolicy<bloom_filters::Split64BloomFilter, 8> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0xc8>
   22f3b:	vzeroupper
   22f3e:	lea    -0x28(%rbp),%rsp
   22f42:	pop    %rbx
   22f43:	pop    %r12
   22f45:	pop    %r13
   22f47:	pop    %r14
   22f49:	pop    %r15
   22f4b:	pop    %rbp
   22f4c:	ret
