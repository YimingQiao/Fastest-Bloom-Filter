
/tmp/fastest-bf-rust-leaf-inline/release/compare_benchmark:     file format elf64-x86-64


Disassembly of section .text:

0000000000065fb0 <<fastest_bloom_filter_leaf_inline::byte_split::ByteSplitBloomFilter>::lookup_hashes>:
   65fb0:	push   %rbp
   65fb1:	push   %r15
   65fb3:	push   %r14
   65fb5:	push   %r13
   65fb7:	push   %r12
   65fb9:	push   %rbx
   65fba:	sub    $0x48,%rsp
   65fbe:	mov    %rdx,0x8(%rsp)
   65fc3:	mov    %r8,0x10(%rsp)
   65fc8:	cmp    %r8,%rdx
   65fcb:	jne    6615e <<fastest_bloom_filter_leaf_inline::byte_split::ByteSplitBloomFilter>::lookup_hashes+0x1ae>
   65fd1:	mov    %rcx,%rbx
   65fd4:	mov    %rdx,%r15
   65fd7:	mov    %rsi,%r14
   65fda:	mov    %rdi,%r12
   65fdd:	cmp    $0x1,%rdx
   65fe1:	jne    66035 <<fastest_bloom_filter_leaf_inline::byte_split::ByteSplitBloomFilter>::lookup_hashes+0x85>
   65fe3:	mov    (%r14),%rsi
   65fe6:	cmpb   $0x0,0x1c(%r12)
   65fec:	je     66116 <<fastest_bloom_filter_leaf_inline::byte_split::ByteSplitBloomFilter>::lookup_hashes+0x166>
   65ff2:	mov    %rsi,%rax
   65ff5:	shr    $0x20,%rax
   65ff9:	and    0x18(%r12),%eax
   65ffe:	mov    0x8(%r12),%rcx
   66003:	shl    $0x4,%rax
   66007:	vmovdqa (%rcx,%rax,1),%xmm0
   6600c:	vpbroadcastd %esi,%xmm1
   66012:	vpmulhw -0x5d26a(%rip),%xmm1,%xmm1        # 8db0 <anon.35274091df3394f4211c680a8c77ed4a.34.llvm.9036914972901821666+0x160>
   6601a:	vpbroadcastq -0x5d91b(%rip),%xmm2        # 8708 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x249>
   66023:	vpshufb %xmm1,%xmm2,%xmm1
   66028:	vptest %xmm1,%xmm0
   6602d:	setb   %al
   66030:	jmp    6611e <<fastest_bloom_filter_leaf_inline::byte_split::ByteSplitBloomFilter>::lookup_hashes+0x16e>
   66035:	cmpb   $0x0,0x1c(%r12)
   6603b:	je     66125 <<fastest_bloom_filter_leaf_inline::byte_split::ByteSplitBloomFilter>::lookup_hashes+0x175>
   66041:	test   %r15,%r15
   66044:	je     6614f <<fastest_bloom_filter_leaf_inline::byte_split::ByteSplitBloomFilter>::lookup_hashes+0x19f>
   6604a:	mov    0x18(%r12),%eax
   6604f:	mov    0x8(%r12),%rcx
   66054:	mov    %r15,%rdx
   66057:	and    $0xfffffffffffffffe,%rdx
   6605b:	xor    %esi,%esi
   6605d:	vmovdqa -0x5d2b5(%rip),%xmm1        # 8db0 <anon.35274091df3394f4211c680a8c77ed4a.34.llvm.9036914972901821666+0x160>
   66065:	vpbroadcastq -0x5d966(%rip),%xmm0        # 8708 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x249>
   6606e:	xchg   %ax,%ax
   66070:	mov    (%r14,%rsi,8),%rdi
   66074:	vpbroadcastd %edi,%xmm2
   6607a:	shr    $0x20,%rdi
   6607e:	and    %eax,%edi
   66080:	shl    $0x4,%rdi
   66084:	vmovdqa (%rcx,%rdi,1),%xmm3
   66089:	vpmulhw %xmm1,%xmm2,%xmm2
   6608d:	vpshufb %xmm2,%xmm0,%xmm2
   66092:	xor    %edi,%edi
   66094:	vptest %xmm2,%xmm3
   66099:	setb   %dil
   6609d:	mov    %edi,(%rbx,%rsi,4)
   660a0:	mov    0x8(%r14,%rsi,8),%rdi
   660a5:	vpbroadcastd %edi,%xmm2
   660ab:	shr    $0x20,%rdi
   660af:	and    %eax,%edi
   660b1:	shl    $0x4,%rdi
   660b5:	vmovdqa (%rcx,%rdi,1),%xmm3
   660ba:	vpmulhw %xmm1,%xmm2,%xmm2
   660be:	vpshufb %xmm2,%xmm0,%xmm2
   660c3:	xor    %edi,%edi
   660c5:	vptest %xmm2,%xmm3
   660ca:	setb   %dil
   660ce:	mov    %edi,0x4(%rbx,%rsi,4)
   660d2:	add    $0x2,%rsi
   660d6:	cmp    %rsi,%rdx
   660d9:	jne    66070 <<fastest_bloom_filter_leaf_inline::byte_split::ByteSplitBloomFilter>::lookup_hashes+0xc0>
   660db:	test   $0x1,%r15b
   660df:	je     6614f <<fastest_bloom_filter_leaf_inline::byte_split::ByteSplitBloomFilter>::lookup_hashes+0x19f>
   660e1:	mov    (%r14,%rsi,8),%rdx
   660e5:	vpbroadcastd %edx,%xmm1
   660eb:	shr    $0x20,%rdx
   660ef:	and    %edx,%eax
   660f1:	shl    $0x4,%rax
   660f5:	vmovdqa (%rcx,%rax,1),%xmm2
   660fa:	vpmulhw -0x5d352(%rip),%xmm1,%xmm1        # 8db0 <anon.35274091df3394f4211c680a8c77ed4a.34.llvm.9036914972901821666+0x160>
   66102:	vpshufb %xmm1,%xmm0,%xmm0
   66107:	xor    %eax,%eax
   66109:	vptest %xmm0,%xmm2
   6610e:	setb   %al
   66111:	mov    %eax,(%rbx,%rsi,4)
   66114:	jmp    6614f <<fastest_bloom_filter_leaf_inline::byte_split::ByteSplitBloomFilter>::lookup_hashes+0x19f>
   66116:	mov    %r12,%rdi
   66119:	call   661b0 <<fastest_bloom_filter_leaf_inline::byte_split::ByteSplitBloomFilter>::contains_scalar>
   6611e:	movzbl %al,%eax
   66121:	mov    %eax,(%rbx)
   66123:	jmp    6614f <<fastest_bloom_filter_leaf_inline::byte_split::ByteSplitBloomFilter>::lookup_hashes+0x19f>
   66125:	test   %r15,%r15
   66128:	je     6614f <<fastest_bloom_filter_leaf_inline::byte_split::ByteSplitBloomFilter>::lookup_hashes+0x19f>
   6612a:	xor    %r13d,%r13d
   6612d:	nopl   (%rax)
   66130:	lea    0x1(%r13),%rbp
   66134:	mov    (%r14,%r13,8),%rsi
   66138:	mov    %r12,%rdi
   6613b:	call   661b0 <<fastest_bloom_filter_leaf_inline::byte_split::ByteSplitBloomFilter>::contains_scalar>
   66140:	movzbl %al,%eax
   66143:	mov    %eax,(%rbx,%r13,4)
   66147:	mov    %rbp,%r13
   6614a:	cmp    %rbp,%r15
   6614d:	jne    66130 <<fastest_bloom_filter_leaf_inline::byte_split::ByteSplitBloomFilter>::lookup_hashes+0x180>
   6614f:	add    $0x48,%rsp
   66153:	pop    %rbx
   66154:	pop    %r12
   66156:	pop    %r13
   66158:	pop    %r14
   6615a:	pop    %r15
   6615c:	pop    %rbp
   6615d:	ret
   6615e:	lea    0x41a5b(%rip),%rax        # a7bc0 <anon.663c38bb301f18615f4d3110a8e62152.2.llvm.1231715614483663210+0x2b0>
   66165:	mov    %rax,0x18(%rsp)
   6616a:	movq   $0x1,0x20(%rsp)
   66173:	movq   $0x8,0x28(%rsp)
   6617c:	vxorps %xmm0,%xmm0,%xmm0
   66180:	vmovups %xmm0,0x30(%rsp)
   66186:	lea    0x41abb(%rip),%r8        # a7c48 <anon.663c38bb301f18615f4d3110a8e62152.2.llvm.1231715614483663210+0x338>
   6618d:	lea    0x8(%rsp),%rsi
   66192:	lea    0x10(%rsp),%rdx
   66197:	lea    0x18(%rsp),%rcx
   6619c:	xor    %edi,%edi
   6619e:	call   *0x43e5c(%rip)        # aa000 <_DYNAMIC+0x2f8>
