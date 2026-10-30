
/tmp/fastest-bf-rust-byte-external/release/compare_benchmark:     file format elf64-x86-64


Disassembly of section .text:

0000000000048770 <fastest_bloom_filter::byte_split::ByteSplitBloomFilter::lookup_hashes>:
   48770:	55                   	push   %rbp
   48771:	41 57                	push   %r15
   48773:	41 56                	push   %r14
   48775:	41 55                	push   %r13
   48777:	41 54                	push   %r12
   48779:	53                   	push   %rbx
   4877a:	48 83 ec 48          	sub    $0x48,%rsp
   4877e:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
   48783:	4c 89 44 24 10       	mov    %r8,0x10(%rsp)
   48788:	4c 39 c2             	cmp    %r8,%rdx
   4878b:	0f 85 8d 01 00 00    	jne    4891e <fastest_bloom_filter::byte_split::ByteSplitBloomFilter::lookup_hashes+0x1ae>
   48791:	48 89 cb             	mov    %rcx,%rbx
   48794:	49 89 d7             	mov    %rdx,%r15
   48797:	49 89 f6             	mov    %rsi,%r14
   4879a:	49 89 fc             	mov    %rdi,%r12
   4879d:	48 83 fa 01          	cmp    $0x1,%rdx
   487a1:	75 52                	jne    487f5 <fastest_bloom_filter::byte_split::ByteSplitBloomFilter::lookup_hashes+0x85>
   487a3:	49 8b 36             	mov    (%r14),%rsi
   487a6:	41 80 7c 24 1c 00    	cmpb   $0x0,0x1c(%r12)
   487ac:	0f 84 24 01 00 00    	je     488d6 <fastest_bloom_filter::byte_split::ByteSplitBloomFilter::lookup_hashes+0x166>
   487b2:	48 89 f0             	mov    %rsi,%rax
   487b5:	48 c1 e8 20          	shr    $0x20,%rax
   487b9:	41 23 44 24 18       	and    0x18(%r12),%eax
   487be:	49 8b 4c 24 08       	mov    0x8(%r12),%rcx
   487c3:	48 c1 e0 04          	shl    $0x4,%rax
   487c7:	c5 f9 6f 04 01       	vmovdqa (%rcx,%rax,1),%xmm0
   487cc:	62 f2 7d 08 7c ce    	vpbroadcastd %esi,%xmm1
   487d2:	c5 f1 e5 0d d6 fc fb 	vpmulhw -0x4032a(%rip),%xmm1,%xmm1        # 84b0 <anon.35274091df3394f4211c680a8c77ed4a.34.llvm.9036914972901821666+0x170>
   487d9:	ff 
   487da:	c4 e2 79 59 15 6d f6 	vpbroadcastq -0x40993(%rip),%xmm2        # 7e50 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x25e>
   487e1:	fb ff 
   487e3:	c4 e2 69 00 c9       	vpshufb %xmm1,%xmm2,%xmm1
   487e8:	c4 e2 79 17 c1       	vptest %xmm1,%xmm0
   487ed:	0f 92 c0             	setb   %al
   487f0:	e9 e9 00 00 00       	jmp    488de <fastest_bloom_filter::byte_split::ByteSplitBloomFilter::lookup_hashes+0x16e>
   487f5:	41 80 7c 24 1c 00    	cmpb   $0x0,0x1c(%r12)
   487fb:	0f 84 e4 00 00 00    	je     488e5 <fastest_bloom_filter::byte_split::ByteSplitBloomFilter::lookup_hashes+0x175>
   48801:	4d 85 ff             	test   %r15,%r15
   48804:	0f 84 05 01 00 00    	je     4890f <fastest_bloom_filter::byte_split::ByteSplitBloomFilter::lookup_hashes+0x19f>
   4880a:	41 8b 44 24 18       	mov    0x18(%r12),%eax
   4880f:	49 8b 4c 24 08       	mov    0x8(%r12),%rcx
   48814:	4c 89 fa             	mov    %r15,%rdx
   48817:	48 83 e2 fe          	and    $0xfffffffffffffffe,%rdx
   4881b:	31 f6                	xor    %esi,%esi
   4881d:	c5 f9 6f 0d 8b fc fb 	vmovdqa -0x40375(%rip),%xmm1        # 84b0 <anon.35274091df3394f4211c680a8c77ed4a.34.llvm.9036914972901821666+0x170>
   48824:	ff 
   48825:	c4 e2 79 59 05 22 f6 	vpbroadcastq -0x409de(%rip),%xmm0        # 7e50 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x25e>
   4882c:	fb ff 
   4882e:	66 90                	xchg   %ax,%ax
   48830:	49 8b 3c f6          	mov    (%r14,%rsi,8),%rdi
   48834:	62 f2 7d 08 7c d7    	vpbroadcastd %edi,%xmm2
   4883a:	48 c1 ef 20          	shr    $0x20,%rdi
   4883e:	21 c7                	and    %eax,%edi
   48840:	48 c1 e7 04          	shl    $0x4,%rdi
   48844:	c5 f9 6f 1c 39       	vmovdqa (%rcx,%rdi,1),%xmm3
   48849:	c5 e9 e5 d1          	vpmulhw %xmm1,%xmm2,%xmm2
   4884d:	c4 e2 79 00 d2       	vpshufb %xmm2,%xmm0,%xmm2
   48852:	31 ff                	xor    %edi,%edi
   48854:	c4 e2 79 17 da       	vptest %xmm2,%xmm3
   48859:	40 0f 92 c7          	setb   %dil
   4885d:	89 3c b3             	mov    %edi,(%rbx,%rsi,4)
   48860:	49 8b 7c f6 08       	mov    0x8(%r14,%rsi,8),%rdi
   48865:	62 f2 7d 08 7c d7    	vpbroadcastd %edi,%xmm2
   4886b:	48 c1 ef 20          	shr    $0x20,%rdi
   4886f:	21 c7                	and    %eax,%edi
   48871:	48 c1 e7 04          	shl    $0x4,%rdi
   48875:	c5 f9 6f 1c 39       	vmovdqa (%rcx,%rdi,1),%xmm3
   4887a:	c5 e9 e5 d1          	vpmulhw %xmm1,%xmm2,%xmm2
   4887e:	c4 e2 79 00 d2       	vpshufb %xmm2,%xmm0,%xmm2
   48883:	31 ff                	xor    %edi,%edi
   48885:	c4 e2 79 17 da       	vptest %xmm2,%xmm3
   4888a:	40 0f 92 c7          	setb   %dil
   4888e:	89 7c b3 04          	mov    %edi,0x4(%rbx,%rsi,4)
   48892:	48 83 c6 02          	add    $0x2,%rsi
   48896:	48 39 f2             	cmp    %rsi,%rdx
   48899:	75 95                	jne    48830 <fastest_bloom_filter::byte_split::ByteSplitBloomFilter::lookup_hashes+0xc0>
   4889b:	41 f6 c7 01          	test   $0x1,%r15b
   4889f:	74 6e                	je     4890f <fastest_bloom_filter::byte_split::ByteSplitBloomFilter::lookup_hashes+0x19f>
   488a1:	49 8b 14 f6          	mov    (%r14,%rsi,8),%rdx
   488a5:	62 f2 7d 08 7c ca    	vpbroadcastd %edx,%xmm1
   488ab:	48 c1 ea 20          	shr    $0x20,%rdx
   488af:	21 d0                	and    %edx,%eax
   488b1:	48 c1 e0 04          	shl    $0x4,%rax
   488b5:	c5 f9 6f 14 01       	vmovdqa (%rcx,%rax,1),%xmm2
   488ba:	c5 f1 e5 0d ee fb fb 	vpmulhw -0x40412(%rip),%xmm1,%xmm1        # 84b0 <anon.35274091df3394f4211c680a8c77ed4a.34.llvm.9036914972901821666+0x170>
   488c1:	ff 
   488c2:	c4 e2 79 00 c1       	vpshufb %xmm1,%xmm0,%xmm0
   488c7:	31 c0                	xor    %eax,%eax
   488c9:	c4 e2 79 17 d0       	vptest %xmm0,%xmm2
   488ce:	0f 92 c0             	setb   %al
   488d1:	89 04 b3             	mov    %eax,(%rbx,%rsi,4)
   488d4:	eb 39                	jmp    4890f <fastest_bloom_filter::byte_split::ByteSplitBloomFilter::lookup_hashes+0x19f>
   488d6:	4c 89 e7             	mov    %r12,%rdi
   488d9:	e8 92 00 00 00       	call   48970 <fastest_bloom_filter::byte_split::ByteSplitBloomFilter::contains_scalar>
   488de:	0f b6 c0             	movzbl %al,%eax
   488e1:	89 03                	mov    %eax,(%rbx)
   488e3:	eb 2a                	jmp    4890f <fastest_bloom_filter::byte_split::ByteSplitBloomFilter::lookup_hashes+0x19f>
   488e5:	4d 85 ff             	test   %r15,%r15
   488e8:	74 25                	je     4890f <fastest_bloom_filter::byte_split::ByteSplitBloomFilter::lookup_hashes+0x19f>
   488ea:	45 31 ed             	xor    %r13d,%r13d
   488ed:	0f 1f 00             	nopl   (%rax)
   488f0:	49 8d 6d 01          	lea    0x1(%r13),%rbp
   488f4:	4b 8b 34 ee          	mov    (%r14,%r13,8),%rsi
   488f8:	4c 89 e7             	mov    %r12,%rdi
   488fb:	e8 70 00 00 00       	call   48970 <fastest_bloom_filter::byte_split::ByteSplitBloomFilter::contains_scalar>
   48900:	0f b6 c0             	movzbl %al,%eax
   48903:	42 89 04 ab          	mov    %eax,(%rbx,%r13,4)
   48907:	49 89 ed             	mov    %rbp,%r13
   4890a:	49 39 ef             	cmp    %rbp,%r15
   4890d:	75 e1                	jne    488f0 <fastest_bloom_filter::byte_split::ByteSplitBloomFilter::lookup_hashes+0x180>
   4890f:	48 83 c4 48          	add    $0x48,%rsp
   48913:	5b                   	pop    %rbx
   48914:	41 5c                	pop    %r12
   48916:	41 5d                	pop    %r13
   48918:	41 5e                	pop    %r14
   4891a:	41 5f                	pop    %r15
   4891c:	5d                   	pop    %rbp
   4891d:	c3                   	ret
   4891e:	48 8d 05 83 1e 04 00 	lea    0x41e83(%rip),%rax        # 8a7a8 <anon.b245d78d28829f835f48a10d63243492.2.llvm.14563942429929576898+0x18>
   48925:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
   4892a:	48 c7 44 24 20 01 00 	movq   $0x1,0x20(%rsp)
   48931:	00 00 
   48933:	48 c7 44 24 28 08 00 	movq   $0x8,0x28(%rsp)
   4893a:	00 00 
   4893c:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
   48940:	c5 f8 11 44 24 30    	vmovups %xmm0,0x30(%rsp)
   48946:	4c 8d 05 6b 1e 04 00 	lea    0x41e6b(%rip),%r8        # 8a7b8 <anon.b245d78d28829f835f48a10d63243492.2.llvm.14563942429929576898+0x28>
   4894d:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
   48952:	48 8d 54 24 10       	lea    0x10(%rsp),%rdx
   48957:	48 8d 4c 24 18       	lea    0x18(%rsp),%rcx
   4895c:	31 ff                	xor    %edi,%edi
   4895e:	ff 15 9c 43 04 00    	call   *0x4439c(%rip)        # 8cd00 <_DYNAMIC+0x398>
   48964:	cc                   	int3
   48965:	cc                   	int3
   48966:	cc                   	int3
   48967:	cc                   	int3
   48968:	cc                   	int3
   48969:	cc                   	int3
   4896a:	cc                   	int3
   4896b:	cc                   	int3
   4896c:	cc                   	int3
   4896d:	cc                   	int3
   4896e:	cc                   	int3
   4896f:	cc                   	int3
