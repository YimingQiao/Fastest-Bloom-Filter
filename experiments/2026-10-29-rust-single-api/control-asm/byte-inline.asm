
/tmp/fastest-bf-rust-single-api/release/compare_benchmark:     file format elf64-x86-64


Disassembly of section .text:

000000000004bcc0 <compare_benchmark::lookup>:
   4bcc0:	55                   	push   %rbp
   4bcc1:	41 57                	push   %r15
   4bcc3:	41 56                	push   %r14
   4bcc5:	41 55                	push   %r13
   4bcc7:	41 54                	push   %r12
   4bcc9:	53                   	push   %rbx
   4bcca:	48 83 ec 48          	sub    $0x48,%rsp
   4bcce:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
   4bcd3:	4c 89 44 24 10       	mov    %r8,0x10(%rsp)
   4bcd8:	4c 39 c2             	cmp    %r8,%rdx
   4bcdb:	0f 85 8d 01 00 00    	jne    4be6e <compare_benchmark::lookup+0x1ae>
   4bce1:	48 89 cb             	mov    %rcx,%rbx
   4bce4:	49 89 d7             	mov    %rdx,%r15
   4bce7:	49 89 f6             	mov    %rsi,%r14
   4bcea:	49 89 fc             	mov    %rdi,%r12
   4bced:	48 83 fa 01          	cmp    $0x1,%rdx
   4bcf1:	75 52                	jne    4bd45 <compare_benchmark::lookup+0x85>
   4bcf3:	49 8b 36             	mov    (%r14),%rsi
   4bcf6:	41 80 7c 24 1c 00    	cmpb   $0x0,0x1c(%r12)
   4bcfc:	0f 84 24 01 00 00    	je     4be26 <compare_benchmark::lookup+0x166>
   4bd02:	48 89 f0             	mov    %rsi,%rax
   4bd05:	48 c1 e8 20          	shr    $0x20,%rax
   4bd09:	41 23 44 24 18       	and    0x18(%r12),%eax
   4bd0e:	49 8b 4c 24 08       	mov    0x8(%r12),%rcx
   4bd13:	48 c1 e0 04          	shl    $0x4,%rax
   4bd17:	c5 f9 6f 04 01       	vmovdqa (%rcx,%rax,1),%xmm0
   4bd1c:	62 f2 7d 08 7c ce    	vpbroadcastd %esi,%xmm1
   4bd22:	c5 f1 e5 0d 76 cb fb 	vpmulhw -0x4348a(%rip),%xmm1,%xmm1        # 88a0 <anon.35274091df3394f4211c680a8c77ed4a.34.llvm.9036914972901821666+0x180>
   4bd29:	ff 
   4bd2a:	c4 e2 79 59 15 d5 c4 	vpbroadcastq -0x43b2b(%rip),%xmm2        # 8208 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x25f>
   4bd31:	fb ff 
   4bd33:	c4 e2 69 00 c9       	vpshufb %xmm1,%xmm2,%xmm1
   4bd38:	c4 e2 79 17 c1       	vptest %xmm1,%xmm0
   4bd3d:	0f 92 c0             	setb   %al
   4bd40:	e9 e9 00 00 00       	jmp    4be2e <compare_benchmark::lookup+0x16e>
   4bd45:	41 80 7c 24 1c 00    	cmpb   $0x0,0x1c(%r12)
   4bd4b:	0f 84 e4 00 00 00    	je     4be35 <compare_benchmark::lookup+0x175>
   4bd51:	4d 85 ff             	test   %r15,%r15
   4bd54:	0f 84 05 01 00 00    	je     4be5f <compare_benchmark::lookup+0x19f>
   4bd5a:	41 8b 44 24 18       	mov    0x18(%r12),%eax
   4bd5f:	49 8b 4c 24 08       	mov    0x8(%r12),%rcx
   4bd64:	4c 89 fa             	mov    %r15,%rdx
   4bd67:	48 83 e2 fe          	and    $0xfffffffffffffffe,%rdx
   4bd6b:	31 f6                	xor    %esi,%esi
   4bd6d:	c5 f9 6f 0d 2b cb fb 	vmovdqa -0x434d5(%rip),%xmm1        # 88a0 <anon.35274091df3394f4211c680a8c77ed4a.34.llvm.9036914972901821666+0x180>
   4bd74:	ff 
   4bd75:	c4 e2 79 59 05 8a c4 	vpbroadcastq -0x43b76(%rip),%xmm0        # 8208 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x25f>
   4bd7c:	fb ff 
   4bd7e:	66 90                	xchg   %ax,%ax
   4bd80:	49 8b 3c f6          	mov    (%r14,%rsi,8),%rdi
   4bd84:	62 f2 7d 08 7c d7    	vpbroadcastd %edi,%xmm2
   4bd8a:	48 c1 ef 20          	shr    $0x20,%rdi
   4bd8e:	21 c7                	and    %eax,%edi
   4bd90:	48 c1 e7 04          	shl    $0x4,%rdi
   4bd94:	c5 f9 6f 1c 39       	vmovdqa (%rcx,%rdi,1),%xmm3
   4bd99:	c5 e9 e5 d1          	vpmulhw %xmm1,%xmm2,%xmm2
   4bd9d:	c4 e2 79 00 d2       	vpshufb %xmm2,%xmm0,%xmm2
   4bda2:	31 ff                	xor    %edi,%edi
   4bda4:	c4 e2 79 17 da       	vptest %xmm2,%xmm3
   4bda9:	40 0f 92 c7          	setb   %dil
   4bdad:	89 3c b3             	mov    %edi,(%rbx,%rsi,4)
   4bdb0:	49 8b 7c f6 08       	mov    0x8(%r14,%rsi,8),%rdi
   4bdb5:	62 f2 7d 08 7c d7    	vpbroadcastd %edi,%xmm2
   4bdbb:	48 c1 ef 20          	shr    $0x20,%rdi
   4bdbf:	21 c7                	and    %eax,%edi
   4bdc1:	48 c1 e7 04          	shl    $0x4,%rdi
   4bdc5:	c5 f9 6f 1c 39       	vmovdqa (%rcx,%rdi,1),%xmm3
   4bdca:	c5 e9 e5 d1          	vpmulhw %xmm1,%xmm2,%xmm2
   4bdce:	c4 e2 79 00 d2       	vpshufb %xmm2,%xmm0,%xmm2
   4bdd3:	31 ff                	xor    %edi,%edi
   4bdd5:	c4 e2 79 17 da       	vptest %xmm2,%xmm3
   4bdda:	40 0f 92 c7          	setb   %dil
   4bdde:	89 7c b3 04          	mov    %edi,0x4(%rbx,%rsi,4)
   4bde2:	48 83 c6 02          	add    $0x2,%rsi
   4bde6:	48 39 f2             	cmp    %rsi,%rdx
   4bde9:	75 95                	jne    4bd80 <compare_benchmark::lookup+0xc0>
   4bdeb:	41 f6 c7 01          	test   $0x1,%r15b
   4bdef:	74 6e                	je     4be5f <compare_benchmark::lookup+0x19f>
   4bdf1:	49 8b 14 f6          	mov    (%r14,%rsi,8),%rdx
   4bdf5:	62 f2 7d 08 7c ca    	vpbroadcastd %edx,%xmm1
   4bdfb:	48 c1 ea 20          	shr    $0x20,%rdx
   4bdff:	21 d0                	and    %edx,%eax
   4be01:	48 c1 e0 04          	shl    $0x4,%rax
   4be05:	c5 f9 6f 14 01       	vmovdqa (%rcx,%rax,1),%xmm2
   4be0a:	c5 f1 e5 0d 8e ca fb 	vpmulhw -0x43572(%rip),%xmm1,%xmm1        # 88a0 <anon.35274091df3394f4211c680a8c77ed4a.34.llvm.9036914972901821666+0x180>
   4be11:	ff 
   4be12:	c4 e2 79 00 c1       	vpshufb %xmm1,%xmm0,%xmm0
   4be17:	31 c0                	xor    %eax,%eax
   4be19:	c4 e2 79 17 d0       	vptest %xmm0,%xmm2
   4be1e:	0f 92 c0             	setb   %al
   4be21:	89 04 b3             	mov    %eax,(%rbx,%rsi,4)
   4be24:	eb 39                	jmp    4be5f <compare_benchmark::lookup+0x19f>
   4be26:	4c 89 e7             	mov    %r12,%rdi
   4be29:	e8 d2 01 00 00       	call   4c000 <fastest_bloom_filter_inline::byte_split::ByteSplitBloomFilter::contains_scalar>
   4be2e:	0f b6 c0             	movzbl %al,%eax
   4be31:	89 03                	mov    %eax,(%rbx)
   4be33:	eb 2a                	jmp    4be5f <compare_benchmark::lookup+0x19f>
   4be35:	4d 85 ff             	test   %r15,%r15
   4be38:	74 25                	je     4be5f <compare_benchmark::lookup+0x19f>
   4be3a:	45 31 ed             	xor    %r13d,%r13d
   4be3d:	0f 1f 00             	nopl   (%rax)
   4be40:	49 8d 6d 01          	lea    0x1(%r13),%rbp
   4be44:	4b 8b 34 ee          	mov    (%r14,%r13,8),%rsi
   4be48:	4c 89 e7             	mov    %r12,%rdi
   4be4b:	e8 b0 01 00 00       	call   4c000 <fastest_bloom_filter_inline::byte_split::ByteSplitBloomFilter::contains_scalar>
   4be50:	0f b6 c0             	movzbl %al,%eax
   4be53:	42 89 04 ab          	mov    %eax,(%rbx,%r13,4)
   4be57:	49 89 ed             	mov    %rbp,%r13
   4be5a:	49 39 ef             	cmp    %rbp,%r15
   4be5d:	75 e1                	jne    4be40 <compare_benchmark::lookup+0x180>
   4be5f:	48 83 c4 48          	add    $0x48,%rsp
   4be63:	5b                   	pop    %rbx
   4be64:	41 5c                	pop    %r12
   4be66:	41 5d                	pop    %r13
   4be68:	41 5e                	pop    %r14
   4be6a:	41 5f                	pop    %r15
   4be6c:	5d                   	pop    %rbp
   4be6d:	c3                   	ret
   4be6e:	48 8d 05 03 e9 04 00 	lea    0x4e903(%rip),%rax        # 9a778 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0x178>
   4be75:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
   4be7a:	48 c7 44 24 20 01 00 	movq   $0x1,0x20(%rsp)
   4be81:	00 00 
   4be83:	48 c7 44 24 28 08 00 	movq   $0x8,0x28(%rsp)
   4be8a:	00 00 
   4be8c:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
   4be90:	c5 f8 11 44 24 30    	vmovups %xmm0,0x30(%rsp)
   4be96:	4c 8d 05 6b f1 04 00 	lea    0x4f16b(%rip),%r8        # 9b008 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0xa08>
   4be9d:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
   4bea2:	48 8d 54 24 10       	lea    0x10(%rsp),%rdx
   4bea7:	48 8d 4c 24 18       	lea    0x18(%rsp),%rcx
   4beac:	31 ff                	xor    %edi,%edi
   4beae:	ff 15 14 23 05 00    	call   *0x52314(%rip)        # 9e1c8 <_DYNAMIC+0x3b0>
   4beb4:	cc                   	int3
   4beb5:	cc                   	int3
   4beb6:	cc                   	int3
   4beb7:	cc                   	int3
   4beb8:	cc                   	int3
   4beb9:	cc                   	int3
   4beba:	cc                   	int3
   4bebb:	cc                   	int3
   4bebc:	cc                   	int3
   4bebd:	cc                   	int3
   4bebe:	cc                   	int3
   4bebf:	cc                   	int3
