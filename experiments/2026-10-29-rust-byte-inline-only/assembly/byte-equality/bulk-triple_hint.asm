
/tmp/fastest-bf-rust-byte-inline-only/release/compare_benchmark:     file format elf64-x86-64


Disassembly of section .text:

000000000003a2a0 <<fastest_bloom_filter_leaf_inline::byte_split::ByteSplitBloomFilter>::lookup_hashes>:
   3a2a0:	push   %rbp
   3a2a1:	push   %r15
   3a2a3:	push   %r14
   3a2a5:	push   %r13
   3a2a7:	push   %r12
   3a2a9:	push   %rbx
   3a2aa:	sub    $0x48,%rsp
   3a2ae:	mov    %rdx,0x8(%rsp)
   3a2b3:	mov    %r8,0x10(%rsp)
   3a2b8:	cmp    %r8,%rdx
   3a2bb:	jne    3a44e <<fastest_bloom_filter_leaf_inline::byte_split::ByteSplitBloomFilter>::lookup_hashes+0x1ae>
   3a2c1:	mov    %rcx,%rbx
   3a2c4:	mov    %rdx,%r15
   3a2c7:	mov    %rsi,%r14
   3a2ca:	mov    %rdi,%r12
   3a2cd:	cmp    $0x1,%rdx
   3a2d1:	jne    3a325 <<fastest_bloom_filter_leaf_inline::byte_split::ByteSplitBloomFilter>::lookup_hashes+0x85>
   3a2d3:	mov    (%r14),%rsi
   3a2d6:	cmpb   $0x0,0x1c(%r12)
   3a2dc:	je     3a406 <<fastest_bloom_filter_leaf_inline::byte_split::ByteSplitBloomFilter>::lookup_hashes+0x166>
   3a2e2:	mov    %rsi,%rax
   3a2e5:	shr    $0x20,%rax
   3a2e9:	and    0x18(%r12),%eax
   3a2ee:	mov    0x8(%r12),%rcx
   3a2f3:	shl    $0x4,%rax
   3a2f7:	vmovdqa (%rcx,%rax,1),%xmm0
   3a2fc:	vpbroadcastd %esi,%xmm1
   3a302:	vpmulhw -0x3220a(%rip),%xmm1,%xmm1        # 8100 <anon.35274091df3394f4211c680a8c77ed4a.34.llvm.9036914972901821666+0x100>
   3a30a:	vpbroadcastq -0x3269b(%rip),%xmm2        # 7c78 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x224>
   3a313:	vpshufb %xmm1,%xmm2,%xmm1
   3a318:	vptest %xmm1,%xmm0
   3a31d:	setb   %al
   3a320:	jmp    3a40e <<fastest_bloom_filter_leaf_inline::byte_split::ByteSplitBloomFilter>::lookup_hashes+0x16e>
   3a325:	cmpb   $0x0,0x1c(%r12)
   3a32b:	je     3a415 <<fastest_bloom_filter_leaf_inline::byte_split::ByteSplitBloomFilter>::lookup_hashes+0x175>
   3a331:	test   %r15,%r15
   3a334:	je     3a43f <<fastest_bloom_filter_leaf_inline::byte_split::ByteSplitBloomFilter>::lookup_hashes+0x19f>
   3a33a:	mov    0x18(%r12),%eax
   3a33f:	mov    0x8(%r12),%rcx
   3a344:	mov    %r15,%rdx
   3a347:	and    $0xfffffffffffffffe,%rdx
   3a34b:	xor    %esi,%esi
   3a34d:	vmovdqa -0x32255(%rip),%xmm1        # 8100 <anon.35274091df3394f4211c680a8c77ed4a.34.llvm.9036914972901821666+0x100>
   3a355:	vpbroadcastq -0x326e6(%rip),%xmm0        # 7c78 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x224>
   3a35e:	xchg   %ax,%ax
   3a360:	mov    (%r14,%rsi,8),%rdi
   3a364:	vpbroadcastd %edi,%xmm2
   3a36a:	shr    $0x20,%rdi
   3a36e:	and    %eax,%edi
   3a370:	shl    $0x4,%rdi
   3a374:	vmovdqa (%rcx,%rdi,1),%xmm3
   3a379:	vpmulhw %xmm1,%xmm2,%xmm2
   3a37d:	vpshufb %xmm2,%xmm0,%xmm2
   3a382:	xor    %edi,%edi
   3a384:	vptest %xmm2,%xmm3
   3a389:	setb   %dil
   3a38d:	mov    %edi,(%rbx,%rsi,4)
   3a390:	mov    0x8(%r14,%rsi,8),%rdi
   3a395:	vpbroadcastd %edi,%xmm2
   3a39b:	shr    $0x20,%rdi
   3a39f:	and    %eax,%edi
   3a3a1:	shl    $0x4,%rdi
   3a3a5:	vmovdqa (%rcx,%rdi,1),%xmm3
   3a3aa:	vpmulhw %xmm1,%xmm2,%xmm2
   3a3ae:	vpshufb %xmm2,%xmm0,%xmm2
   3a3b3:	xor    %edi,%edi
   3a3b5:	vptest %xmm2,%xmm3
   3a3ba:	setb   %dil
   3a3be:	mov    %edi,0x4(%rbx,%rsi,4)
   3a3c2:	add    $0x2,%rsi
   3a3c6:	cmp    %rsi,%rdx
   3a3c9:	jne    3a360 <<fastest_bloom_filter_leaf_inline::byte_split::ByteSplitBloomFilter>::lookup_hashes+0xc0>
   3a3cb:	test   $0x1,%r15b
   3a3cf:	je     3a43f <<fastest_bloom_filter_leaf_inline::byte_split::ByteSplitBloomFilter>::lookup_hashes+0x19f>
   3a3d1:	mov    (%r14,%rsi,8),%rdx
   3a3d5:	vpbroadcastd %edx,%xmm1
   3a3db:	shr    $0x20,%rdx
   3a3df:	and    %edx,%eax
   3a3e1:	shl    $0x4,%rax
   3a3e5:	vmovdqa (%rcx,%rax,1),%xmm2
   3a3ea:	vpmulhw -0x322f2(%rip),%xmm1,%xmm1        # 8100 <anon.35274091df3394f4211c680a8c77ed4a.34.llvm.9036914972901821666+0x100>
   3a3f2:	vpshufb %xmm1,%xmm0,%xmm0
   3a3f7:	xor    %eax,%eax
   3a3f9:	vptest %xmm0,%xmm2
   3a3fe:	setb   %al
   3a401:	mov    %eax,(%rbx,%rsi,4)
   3a404:	jmp    3a43f <<fastest_bloom_filter_leaf_inline::byte_split::ByteSplitBloomFilter>::lookup_hashes+0x19f>
   3a406:	mov    %r12,%rdi
   3a409:	call   3a4a0 <<fastest_bloom_filter_leaf_inline::byte_split::ByteSplitBloomFilter>::contains_scalar>
   3a40e:	movzbl %al,%eax
   3a411:	mov    %eax,(%rbx)
   3a413:	jmp    3a43f <<fastest_bloom_filter_leaf_inline::byte_split::ByteSplitBloomFilter>::lookup_hashes+0x19f>
   3a415:	test   %r15,%r15
   3a418:	je     3a43f <<fastest_bloom_filter_leaf_inline::byte_split::ByteSplitBloomFilter>::lookup_hashes+0x19f>
   3a41a:	xor    %r13d,%r13d
   3a41d:	nopl   (%rax)
   3a420:	lea    0x1(%r13),%rbp
   3a424:	mov    (%r14,%r13,8),%rsi
   3a428:	mov    %r12,%rdi
   3a42b:	call   3a4a0 <<fastest_bloom_filter_leaf_inline::byte_split::ByteSplitBloomFilter>::contains_scalar>
   3a430:	movzbl %al,%eax
   3a433:	mov    %eax,(%rbx,%r13,4)
   3a437:	mov    %rbp,%r13
   3a43a:	cmp    %rbp,%r15
   3a43d:	jne    3a420 <<fastest_bloom_filter_leaf_inline::byte_split::ByteSplitBloomFilter>::lookup_hashes+0x180>
   3a43f:	add    $0x48,%rsp
   3a443:	pop    %rbx
   3a444:	pop    %r12
   3a446:	pop    %r13
   3a448:	pop    %r14
   3a44a:	pop    %r15
   3a44c:	pop    %rbp
   3a44d:	ret
   3a44e:	lea    0x3edb3(%rip),%rax        # 79208 <anon.35274091df3394f4211c680a8c77ed4a.292.llvm.9036914972901821666+0x278>
   3a455:	mov    %rax,0x18(%rsp)
   3a45a:	movq   $0x1,0x20(%rsp)
   3a463:	movq   $0x8,0x28(%rsp)
   3a46c:	vxorps %xmm0,%xmm0,%xmm0
   3a470:	vmovups %xmm0,0x30(%rsp)
   3a476:	lea    0x3ed9b(%rip),%r8        # 79218 <anon.35274091df3394f4211c680a8c77ed4a.292.llvm.9036914972901821666+0x288>
   3a47d:	lea    0x8(%rsp),%rsi
   3a482:	lea    0x10(%rsp),%rdx
   3a487:	lea    0x18(%rsp),%rcx
   3a48c:	xor    %edi,%edi
   3a48e:	call   *0x41074(%rip)        # 7b508 <_DYNAMIC+0x2d8>
