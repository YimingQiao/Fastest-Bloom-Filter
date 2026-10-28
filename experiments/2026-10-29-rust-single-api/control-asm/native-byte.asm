
/tmp/fastest-bf-rust-single-api/release/compare_benchmark:     file format elf64-x86-64


Disassembly of section .text:

0000000000058d20 <fastest_bloom_filter::byte_split::ByteSplitBloomFilter::lookup_hashes>:
   58d20:	55                   	push   %rbp
   58d21:	41 57                	push   %r15
   58d23:	41 56                	push   %r14
   58d25:	41 55                	push   %r13
   58d27:	41 54                	push   %r12
   58d29:	53                   	push   %rbx
   58d2a:	48 83 ec 48          	sub    $0x48,%rsp
   58d2e:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
   58d33:	4c 89 44 24 10       	mov    %r8,0x10(%rsp)
   58d38:	4c 39 c2             	cmp    %r8,%rdx
   58d3b:	0f 85 8d 01 00 00    	jne    58ece <fastest_bloom_filter::byte_split::ByteSplitBloomFilter::lookup_hashes+0x1ae>
   58d41:	48 89 cb             	mov    %rcx,%rbx
   58d44:	49 89 d7             	mov    %rdx,%r15
   58d47:	49 89 f6             	mov    %rsi,%r14
   58d4a:	49 89 fc             	mov    %rdi,%r12
   58d4d:	48 83 fa 01          	cmp    $0x1,%rdx
   58d51:	75 52                	jne    58da5 <fastest_bloom_filter::byte_split::ByteSplitBloomFilter::lookup_hashes+0x85>
   58d53:	49 8b 36             	mov    (%r14),%rsi
   58d56:	41 80 7c 24 1c 00    	cmpb   $0x0,0x1c(%r12)
   58d5c:	0f 84 24 01 00 00    	je     58e86 <fastest_bloom_filter::byte_split::ByteSplitBloomFilter::lookup_hashes+0x166>
   58d62:	48 89 f0             	mov    %rsi,%rax
   58d65:	48 c1 e8 20          	shr    $0x20,%rax
   58d69:	41 23 44 24 18       	and    0x18(%r12),%eax
   58d6e:	49 8b 4c 24 08       	mov    0x8(%r12),%rcx
   58d73:	48 c1 e0 04          	shl    $0x4,%rax
   58d77:	c5 f9 6f 04 01       	vmovdqa (%rcx,%rax,1),%xmm0
   58d7c:	62 f2 7d 08 7c ce    	vpbroadcastd %esi,%xmm1
   58d82:	c5 f1 e5 0d 16 fb fa 	vpmulhw -0x504ea(%rip),%xmm1,%xmm1        # 88a0 <anon.35274091df3394f4211c680a8c77ed4a.34.llvm.9036914972901821666+0x180>
   58d89:	ff 
   58d8a:	c4 e2 79 59 15 75 f4 	vpbroadcastq -0x50b8b(%rip),%xmm2        # 8208 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x25f>
   58d91:	fa ff 
   58d93:	c4 e2 69 00 c9       	vpshufb %xmm1,%xmm2,%xmm1
   58d98:	c4 e2 79 17 c1       	vptest %xmm1,%xmm0
   58d9d:	0f 92 c0             	setb   %al
   58da0:	e9 e9 00 00 00       	jmp    58e8e <fastest_bloom_filter::byte_split::ByteSplitBloomFilter::lookup_hashes+0x16e>
   58da5:	41 80 7c 24 1c 00    	cmpb   $0x0,0x1c(%r12)
   58dab:	0f 84 e4 00 00 00    	je     58e95 <fastest_bloom_filter::byte_split::ByteSplitBloomFilter::lookup_hashes+0x175>
   58db1:	4d 85 ff             	test   %r15,%r15
   58db4:	0f 84 05 01 00 00    	je     58ebf <fastest_bloom_filter::byte_split::ByteSplitBloomFilter::lookup_hashes+0x19f>
   58dba:	41 8b 44 24 18       	mov    0x18(%r12),%eax
   58dbf:	49 8b 4c 24 08       	mov    0x8(%r12),%rcx
   58dc4:	4c 89 fa             	mov    %r15,%rdx
   58dc7:	48 83 e2 fe          	and    $0xfffffffffffffffe,%rdx
   58dcb:	31 f6                	xor    %esi,%esi
   58dcd:	c5 f9 6f 0d cb fa fa 	vmovdqa -0x50535(%rip),%xmm1        # 88a0 <anon.35274091df3394f4211c680a8c77ed4a.34.llvm.9036914972901821666+0x180>
   58dd4:	ff 
   58dd5:	c4 e2 79 59 05 2a f4 	vpbroadcastq -0x50bd6(%rip),%xmm0        # 8208 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x25f>
   58ddc:	fa ff 
   58dde:	66 90                	xchg   %ax,%ax
   58de0:	49 8b 3c f6          	mov    (%r14,%rsi,8),%rdi
   58de4:	62 f2 7d 08 7c d7    	vpbroadcastd %edi,%xmm2
   58dea:	48 c1 ef 20          	shr    $0x20,%rdi
   58dee:	21 c7                	and    %eax,%edi
   58df0:	48 c1 e7 04          	shl    $0x4,%rdi
   58df4:	c5 f9 6f 1c 39       	vmovdqa (%rcx,%rdi,1),%xmm3
   58df9:	c5 e9 e5 d1          	vpmulhw %xmm1,%xmm2,%xmm2
   58dfd:	c4 e2 79 00 d2       	vpshufb %xmm2,%xmm0,%xmm2
   58e02:	31 ff                	xor    %edi,%edi
   58e04:	c4 e2 79 17 da       	vptest %xmm2,%xmm3
   58e09:	40 0f 92 c7          	setb   %dil
   58e0d:	89 3c b3             	mov    %edi,(%rbx,%rsi,4)
   58e10:	49 8b 7c f6 08       	mov    0x8(%r14,%rsi,8),%rdi
   58e15:	62 f2 7d 08 7c d7    	vpbroadcastd %edi,%xmm2
   58e1b:	48 c1 ef 20          	shr    $0x20,%rdi
   58e1f:	21 c7                	and    %eax,%edi
   58e21:	48 c1 e7 04          	shl    $0x4,%rdi
   58e25:	c5 f9 6f 1c 39       	vmovdqa (%rcx,%rdi,1),%xmm3
   58e2a:	c5 e9 e5 d1          	vpmulhw %xmm1,%xmm2,%xmm2
   58e2e:	c4 e2 79 00 d2       	vpshufb %xmm2,%xmm0,%xmm2
   58e33:	31 ff                	xor    %edi,%edi
   58e35:	c4 e2 79 17 da       	vptest %xmm2,%xmm3
   58e3a:	40 0f 92 c7          	setb   %dil
   58e3e:	89 7c b3 04          	mov    %edi,0x4(%rbx,%rsi,4)
   58e42:	48 83 c6 02          	add    $0x2,%rsi
   58e46:	48 39 f2             	cmp    %rsi,%rdx
   58e49:	75 95                	jne    58de0 <fastest_bloom_filter::byte_split::ByteSplitBloomFilter::lookup_hashes+0xc0>
   58e4b:	41 f6 c7 01          	test   $0x1,%r15b
   58e4f:	74 6e                	je     58ebf <fastest_bloom_filter::byte_split::ByteSplitBloomFilter::lookup_hashes+0x19f>
   58e51:	49 8b 14 f6          	mov    (%r14,%rsi,8),%rdx
   58e55:	62 f2 7d 08 7c ca    	vpbroadcastd %edx,%xmm1
   58e5b:	48 c1 ea 20          	shr    $0x20,%rdx
   58e5f:	21 d0                	and    %edx,%eax
   58e61:	48 c1 e0 04          	shl    $0x4,%rax
   58e65:	c5 f9 6f 14 01       	vmovdqa (%rcx,%rax,1),%xmm2
   58e6a:	c5 f1 e5 0d 2e fa fa 	vpmulhw -0x505d2(%rip),%xmm1,%xmm1        # 88a0 <anon.35274091df3394f4211c680a8c77ed4a.34.llvm.9036914972901821666+0x180>
   58e71:	ff 
   58e72:	c4 e2 79 00 c1       	vpshufb %xmm1,%xmm0,%xmm0
   58e77:	31 c0                	xor    %eax,%eax
   58e79:	c4 e2 79 17 d0       	vptest %xmm0,%xmm2
   58e7e:	0f 92 c0             	setb   %al
   58e81:	89 04 b3             	mov    %eax,(%rbx,%rsi,4)
   58e84:	eb 39                	jmp    58ebf <fastest_bloom_filter::byte_split::ByteSplitBloomFilter::lookup_hashes+0x19f>
   58e86:	4c 89 e7             	mov    %r12,%rdi
   58e89:	e8 92 00 00 00       	call   58f20 <fastest_bloom_filter::byte_split::ByteSplitBloomFilter::contains_scalar>
   58e8e:	0f b6 c0             	movzbl %al,%eax
   58e91:	89 03                	mov    %eax,(%rbx)
   58e93:	eb 2a                	jmp    58ebf <fastest_bloom_filter::byte_split::ByteSplitBloomFilter::lookup_hashes+0x19f>
   58e95:	4d 85 ff             	test   %r15,%r15
   58e98:	74 25                	je     58ebf <fastest_bloom_filter::byte_split::ByteSplitBloomFilter::lookup_hashes+0x19f>
   58e9a:	45 31 ed             	xor    %r13d,%r13d
   58e9d:	0f 1f 00             	nopl   (%rax)
   58ea0:	49 8d 6d 01          	lea    0x1(%r13),%rbp
   58ea4:	4b 8b 34 ee          	mov    (%r14,%r13,8),%rsi
   58ea8:	4c 89 e7             	mov    %r12,%rdi
   58eab:	e8 70 00 00 00       	call   58f20 <fastest_bloom_filter::byte_split::ByteSplitBloomFilter::contains_scalar>
   58eb0:	0f b6 c0             	movzbl %al,%eax
   58eb3:	42 89 04 ab          	mov    %eax,(%rbx,%r13,4)
   58eb7:	49 89 ed             	mov    %rbp,%r13
   58eba:	49 39 ef             	cmp    %rbp,%r15
   58ebd:	75 e1                	jne    58ea0 <fastest_bloom_filter::byte_split::ByteSplitBloomFilter::lookup_hashes+0x180>
   58ebf:	48 83 c4 48          	add    $0x48,%rsp
   58ec3:	5b                   	pop    %rbx
   58ec4:	41 5c                	pop    %r12
   58ec6:	41 5d                	pop    %r13
   58ec8:	41 5e                	pop    %r14
   58eca:	41 5f                	pop    %r15
   58ecc:	5d                   	pop    %rbp
   58ecd:	c3                   	ret
   58ece:	48 8d 05 db 2c 04 00 	lea    0x42cdb(%rip),%rax        # 9bbb0 <anon.b245d78d28829f835f48a10d63243492.2.llvm.14563942429929576898+0x18>
   58ed5:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
   58eda:	48 c7 44 24 20 01 00 	movq   $0x1,0x20(%rsp)
   58ee1:	00 00 
   58ee3:	48 c7 44 24 28 08 00 	movq   $0x8,0x28(%rsp)
   58eea:	00 00 
   58eec:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
   58ef0:	c5 f8 11 44 24 30    	vmovups %xmm0,0x30(%rsp)
   58ef6:	4c 8d 05 c3 2c 04 00 	lea    0x42cc3(%rip),%r8        # 9bbc0 <anon.b245d78d28829f835f48a10d63243492.2.llvm.14563942429929576898+0x28>
   58efd:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
   58f02:	48 8d 54 24 10       	lea    0x10(%rsp),%rdx
   58f07:	48 8d 4c 24 18       	lea    0x18(%rsp),%rcx
   58f0c:	31 ff                	xor    %edi,%edi
   58f0e:	ff 15 b4 52 04 00    	call   *0x452b4(%rip)        # 9e1c8 <_DYNAMIC+0x3b0>
   58f14:	cc                   	int3
   58f15:	cc                   	int3
   58f16:	cc                   	int3
   58f17:	cc                   	int3
   58f18:	cc                   	int3
   58f19:	cc                   	int3
   58f1a:	cc                   	int3
   58f1b:	cc                   	int3
   58f1c:	cc                   	int3
   58f1d:	cc                   	int3
   58f1e:	cc                   	int3
   58f1f:	cc                   	int3
