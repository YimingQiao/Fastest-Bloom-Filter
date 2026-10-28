0000000000062e70 <compare_benchmark::lookup>:
   62e70:	55                   	push   %rbp
   62e71:	41 57                	push   %r15
   62e73:	41 56                	push   %r14
   62e75:	41 55                	push   %r13
   62e77:	41 54                	push   %r12
   62e79:	53                   	push   %rbx
   62e7a:	48 83 ec 48          	sub    $0x48,%rsp
   62e7e:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
   62e83:	4c 89 44 24 10       	mov    %r8,0x10(%rsp)
   62e88:	4c 39 c2             	cmp    %r8,%rdx
   62e8b:	0f 85 8d 01 00 00    	jne    6301e <compare_benchmark::lookup+0x1ae>
   62e91:	48 89 cb             	mov    %rcx,%rbx
   62e94:	49 89 d7             	mov    %rdx,%r15
   62e97:	49 89 f6             	mov    %rsi,%r14
   62e9a:	49 89 fc             	mov    %rdi,%r12
   62e9d:	48 83 fa 01          	cmp    $0x1,%rdx
   62ea1:	75 52                	jne    62ef5 <compare_benchmark::lookup+0x85>
   62ea3:	49 8b 36             	mov    (%r14),%rsi
   62ea6:	41 80 7c 24 1c 00    	cmpb   $0x0,0x1c(%r12)
   62eac:	0f 84 24 01 00 00    	je     62fd6 <compare_benchmark::lookup+0x166>
   62eb2:	48 89 f0             	mov    %rsi,%rax
   62eb5:	48 c1 e8 20          	shr    $0x20,%rax
   62eb9:	41 23 44 24 18       	and    0x18(%r12),%eax
   62ebe:	49 8b 4c 24 08       	mov    0x8(%r12),%rcx
   62ec3:	48 c1 e0 04          	shl    $0x4,%rax
   62ec7:	c5 f9 6f 04 01       	vmovdqa (%rcx,%rax,1),%xmm0
   62ecc:	62 f2 7d 08 7c ce    	vpbroadcastd %esi,%xmm1
   62ed2:	c5 f1 e5 0d 66 61 fa 	vpmulhw -0x59e9a(%rip),%xmm1,%xmm1        # 9040 <anon.35274091df3394f4211c680a8c77ed4a.34.llvm.9036914972901821666+0x1d0>
   62ed9:	ff 
   62eda:	c4 e2 79 59 15 65 5a 	vpbroadcastq -0x5a59b(%rip),%xmm2        # 8948 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x233>
   62ee1:	fa ff 
   62ee3:	c4 e2 69 00 c9       	vpshufb %xmm1,%xmm2,%xmm1
   62ee8:	c4 e2 79 17 c1       	vptest %xmm1,%xmm0
   62eed:	0f 92 c0             	setb   %al
   62ef0:	e9 e9 00 00 00       	jmp    62fde <compare_benchmark::lookup+0x16e>
   62ef5:	41 80 7c 24 1c 00    	cmpb   $0x0,0x1c(%r12)
   62efb:	0f 84 e4 00 00 00    	je     62fe5 <compare_benchmark::lookup+0x175>
   62f01:	4d 85 ff             	test   %r15,%r15
   62f04:	0f 84 05 01 00 00    	je     6300f <compare_benchmark::lookup+0x19f>
   62f0a:	41 8b 44 24 18       	mov    0x18(%r12),%eax
   62f0f:	49 8b 4c 24 08       	mov    0x8(%r12),%rcx
   62f14:	4c 89 fa             	mov    %r15,%rdx
   62f17:	48 83 e2 fe          	and    $0xfffffffffffffffe,%rdx
   62f1b:	31 f6                	xor    %esi,%esi
   62f1d:	c5 f9 6f 0d 1b 61 fa 	vmovdqa -0x59ee5(%rip),%xmm1        # 9040 <anon.35274091df3394f4211c680a8c77ed4a.34.llvm.9036914972901821666+0x1d0>
   62f24:	ff 
   62f25:	c4 e2 79 59 05 1a 5a 	vpbroadcastq -0x5a5e6(%rip),%xmm0        # 8948 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x233>
   62f2c:	fa ff 
   62f2e:	66 90                	xchg   %ax,%ax
   62f30:	49 8b 3c f6          	mov    (%r14,%rsi,8),%rdi
   62f34:	62 f2 7d 08 7c d7    	vpbroadcastd %edi,%xmm2
   62f3a:	48 c1 ef 20          	shr    $0x20,%rdi
   62f3e:	21 c7                	and    %eax,%edi
   62f40:	48 c1 e7 04          	shl    $0x4,%rdi
   62f44:	c5 f9 6f 1c 39       	vmovdqa (%rcx,%rdi,1),%xmm3
   62f49:	c5 e9 e5 d1          	vpmulhw %xmm1,%xmm2,%xmm2
   62f4d:	c4 e2 79 00 d2       	vpshufb %xmm2,%xmm0,%xmm2
   62f52:	31 ff                	xor    %edi,%edi
   62f54:	c4 e2 79 17 da       	vptest %xmm2,%xmm3
   62f59:	40 0f 92 c7          	setb   %dil
   62f5d:	89 3c b3             	mov    %edi,(%rbx,%rsi,4)
   62f60:	49 8b 7c f6 08       	mov    0x8(%r14,%rsi,8),%rdi
   62f65:	62 f2 7d 08 7c d7    	vpbroadcastd %edi,%xmm2
   62f6b:	48 c1 ef 20          	shr    $0x20,%rdi
   62f6f:	21 c7                	and    %eax,%edi
   62f71:	48 c1 e7 04          	shl    $0x4,%rdi
   62f75:	c5 f9 6f 1c 39       	vmovdqa (%rcx,%rdi,1),%xmm3
   62f7a:	c5 e9 e5 d1          	vpmulhw %xmm1,%xmm2,%xmm2
   62f7e:	c4 e2 79 00 d2       	vpshufb %xmm2,%xmm0,%xmm2
   62f83:	31 ff                	xor    %edi,%edi
   62f85:	c4 e2 79 17 da       	vptest %xmm2,%xmm3
   62f8a:	40 0f 92 c7          	setb   %dil
   62f8e:	89 7c b3 04          	mov    %edi,0x4(%rbx,%rsi,4)
   62f92:	48 83 c6 02          	add    $0x2,%rsi
   62f96:	48 39 f2             	cmp    %rsi,%rdx
   62f99:	75 95                	jne    62f30 <compare_benchmark::lookup+0xc0>
   62f9b:	41 f6 c7 01          	test   $0x1,%r15b
   62f9f:	74 6e                	je     6300f <compare_benchmark::lookup+0x19f>
   62fa1:	49 8b 14 f6          	mov    (%r14,%rsi,8),%rdx
   62fa5:	62 f2 7d 08 7c ca    	vpbroadcastd %edx,%xmm1
   62fab:	48 c1 ea 20          	shr    $0x20,%rdx
   62faf:	21 d0                	and    %edx,%eax
   62fb1:	48 c1 e0 04          	shl    $0x4,%rax
   62fb5:	c5 f9 6f 14 01       	vmovdqa (%rcx,%rax,1),%xmm2
   62fba:	c5 f1 e5 0d 7e 60 fa 	vpmulhw -0x59f82(%rip),%xmm1,%xmm1        # 9040 <anon.35274091df3394f4211c680a8c77ed4a.34.llvm.9036914972901821666+0x1d0>
   62fc1:	ff 
   62fc2:	c4 e2 79 00 c1       	vpshufb %xmm1,%xmm0,%xmm0
   62fc7:	31 c0                	xor    %eax,%eax
   62fc9:	c4 e2 79 17 d0       	vptest %xmm0,%xmm2
   62fce:	0f 92 c0             	setb   %al
   62fd1:	89 04 b3             	mov    %eax,(%rbx,%rsi,4)
   62fd4:	eb 39                	jmp    6300f <compare_benchmark::lookup+0x19f>
   62fd6:	4c 89 e7             	mov    %r12,%rdi
   62fd9:	e8 02 04 00 00       	call   633e0 <fastest_bloom_filter_inline::byte_split::ByteSplitBloomFilter::contains_scalar>
   62fde:	0f b6 c0             	movzbl %al,%eax
   62fe1:	89 03                	mov    %eax,(%rbx)
   62fe3:	eb 2a                	jmp    6300f <compare_benchmark::lookup+0x19f>
   62fe5:	4d 85 ff             	test   %r15,%r15
   62fe8:	74 25                	je     6300f <compare_benchmark::lookup+0x19f>
   62fea:	45 31 ed             	xor    %r13d,%r13d
   62fed:	0f 1f 00             	nopl   (%rax)
   62ff0:	49 8d 6d 01          	lea    0x1(%r13),%rbp
   62ff4:	4b 8b 34 ee          	mov    (%r14,%r13,8),%rsi
   62ff8:	4c 89 e7             	mov    %r12,%rdi
   62ffb:	e8 e0 03 00 00       	call   633e0 <fastest_bloom_filter_inline::byte_split::ByteSplitBloomFilter::contains_scalar>
   63000:	0f b6 c0             	movzbl %al,%eax
   63003:	42 89 04 ab          	mov    %eax,(%rbx,%r13,4)
   63007:	49 89 ed             	mov    %rbp,%r13
   6300a:	49 39 ef             	cmp    %rbp,%r15
   6300d:	75 e1                	jne    62ff0 <compare_benchmark::lookup+0x180>
   6300f:	48 83 c4 48          	add    $0x48,%rsp
   63013:	5b                   	pop    %rbx
   63014:	41 5c                	pop    %r12
   63016:	41 5d                	pop    %r13
   63018:	41 5e                	pop    %r14
   6301a:	41 5f                	pop    %r15
   6301c:	5d                   	pop    %rbp
   6301d:	c3                   	ret
   6301e:	48 8d 05 9b 19 05 00 	lea    0x5199b(%rip),%rax        # b49c0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0x1f0>
   63025:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
   6302a:	48 c7 44 24 20 01 00 	movq   $0x1,0x20(%rsp)
   63031:	00 00 
   63033:	48 c7 44 24 28 08 00 	movq   $0x8,0x28(%rsp)
   6303a:	00 00 
   6303c:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
   63040:	c5 f8 11 44 24 30    	vmovups %xmm0,0x30(%rsp)
   63046:	4c 8d 05 3b 23 05 00 	lea    0x5233b(%rip),%r8        # b5388 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0xbb8>
   6304d:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
   63052:	48 8d 54 24 10       	lea    0x10(%rsp),%rdx
   63057:	48 8d 4c 24 18       	lea    0x18(%rsp),%rcx
   6305c:	31 ff                	xor    %edi,%edi
   6305e:	ff 15 8c 57 05 00    	call   *0x5578c(%rip)        # b87f0 <_DYNAMIC+0x3d8>
   63064:	cc                   	int3
   63065:	cc                   	int3
   63066:	cc                   	int3
   63067:	cc                   	int3
   63068:	cc                   	int3
   63069:	cc                   	int3
   6306a:	cc                   	int3
   6306b:	cc                   	int3
   6306c:	cc                   	int3
   6306d:	cc                   	int3
   6306e:	cc                   	int3
   6306f:	cc                   	int3

