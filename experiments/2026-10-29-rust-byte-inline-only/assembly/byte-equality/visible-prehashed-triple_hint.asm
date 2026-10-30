
/tmp/fastest-bf-rust-byte-inline-only/release/compare_benchmark:     file format elf64-x86-64


Disassembly of section .text:

000000000001a540 <compare_benchmark::visible_lookup::<fastest_bloom_filter_leaf_inline::byte_split::ByteSplitBloomFilter, false>>:
   1a540:	push   %rbp
   1a541:	push   %r15
   1a543:	push   %r14
   1a545:	push   %r13
   1a547:	push   %r12
   1a549:	push   %rbx
   1a54a:	sub    $0x48,%rsp
   1a54e:	mov    %rdx,0x8(%rsp)
   1a553:	mov    %r8,0x10(%rsp)
   1a558:	cmp    %r8,%rdx
   1a55b:	jne    1a6a1 <compare_benchmark::visible_lookup::<fastest_bloom_filter_leaf_inline::byte_split::ByteSplitBloomFilter, false>+0x161>
   1a561:	mov    %rdx,%r15
   1a564:	test   %rdx,%rdx
   1a567:	je     1a692 <compare_benchmark::visible_lookup::<fastest_bloom_filter_leaf_inline::byte_split::ByteSplitBloomFilter, false>+0x152>
   1a56d:	mov    %rcx,%rbx
   1a570:	mov    %rsi,%r14
   1a573:	mov    %rdi,%r12
   1a576:	cmpb   $0x0,0x1c(%rdi)
   1a57a:	je     1a593 <compare_benchmark::visible_lookup::<fastest_bloom_filter_leaf_inline::byte_split::ByteSplitBloomFilter, false>+0x53>
   1a57c:	mov    0x18(%r12),%eax
   1a581:	mov    0x8(%r12),%rcx
   1a586:	cmp    $0x1,%r15
   1a58a:	jne    1a5c4 <compare_benchmark::visible_lookup::<fastest_bloom_filter_leaf_inline::byte_split::ByteSplitBloomFilter, false>+0x84>
   1a58c:	xor    %edi,%edi
   1a58e:	jmp    1a650 <compare_benchmark::visible_lookup::<fastest_bloom_filter_leaf_inline::byte_split::ByteSplitBloomFilter, false>+0x110>
   1a593:	xor    %r13d,%r13d
   1a596:	cs nopw 0x0(%rax,%rax,1)
   1a5a0:	lea    0x1(%r13),%rbp
   1a5a4:	mov    (%r14,%r13,8),%rsi
   1a5a8:	mov    %r12,%rdi
   1a5ab:	call   2ee10 <<fastest_bloom_filter_leaf_inline::byte_split::ByteSplitBloomFilter>::contains_scalar>
   1a5b0:	movzbl %al,%eax
   1a5b3:	mov    %eax,(%rbx,%r13,4)
   1a5b7:	mov    %rbp,%r13
   1a5ba:	cmp    %rbp,%r15
   1a5bd:	jne    1a5a0 <compare_benchmark::visible_lookup::<fastest_bloom_filter_leaf_inline::byte_split::ByteSplitBloomFilter, false>+0x60>
   1a5bf:	jmp    1a692 <compare_benchmark::visible_lookup::<fastest_bloom_filter_leaf_inline::byte_split::ByteSplitBloomFilter, false>+0x152>
   1a5c4:	mov    %r15,%rdx
   1a5c7:	and    $0xfffffffffffffffe,%rdx
   1a5cb:	xor    %esi,%esi
   1a5cd:	vmovdqa -0x124d5(%rip),%xmm0        # 8100 <anon.35274091df3394f4211c680a8c77ed4a.34.llvm.9036914972901821666+0x100>
   1a5d5:	vpbroadcastq -0x12966(%rip),%xmm1        # 7c78 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x224>
   1a5de:	xchg   %ax,%ax
   1a5e0:	mov    (%r14,%rsi,8),%rdi
   1a5e4:	vpbroadcastd %edi,%xmm2
   1a5ea:	shr    $0x20,%rdi
   1a5ee:	and    %eax,%edi
   1a5f0:	shl    $0x4,%rdi
   1a5f4:	vmovdqa (%rcx,%rdi,1),%xmm3
   1a5f9:	vpmulhw %xmm0,%xmm2,%xmm2
   1a5fd:	vpshufb %xmm2,%xmm1,%xmm2
   1a602:	xor    %edi,%edi
   1a604:	vptest %xmm2,%xmm3
   1a609:	setb   %dil
   1a60d:	mov    %edi,(%rbx,%rsi,4)
   1a610:	mov    0x8(%r14,%rsi,8),%rdi
   1a615:	vpbroadcastd %edi,%xmm2
   1a61b:	shr    $0x20,%rdi
   1a61f:	and    %eax,%edi
   1a621:	shl    $0x4,%rdi
   1a625:	vmovdqa (%rcx,%rdi,1),%xmm3
   1a62a:	vpmulhw %xmm0,%xmm2,%xmm2
   1a62e:	vpshufb %xmm2,%xmm1,%xmm2
   1a633:	xor    %r8d,%r8d
   1a636:	vptest %xmm2,%xmm3
   1a63b:	lea    0x2(%rsi),%rdi
   1a63f:	setb   %r8b
   1a643:	mov    %r8d,0x4(%rbx,%rsi,4)
   1a648:	mov    %rdi,%rsi
   1a64b:	cmp    %rdi,%rdx
   1a64e:	jne    1a5e0 <compare_benchmark::visible_lookup::<fastest_bloom_filter_leaf_inline::byte_split::ByteSplitBloomFilter, false>+0xa0>
   1a650:	test   $0x1,%r15b
   1a654:	je     1a692 <compare_benchmark::visible_lookup::<fastest_bloom_filter_leaf_inline::byte_split::ByteSplitBloomFilter, false>+0x152>
   1a656:	mov    (%r14,%rdi,8),%rdx
   1a65a:	vpbroadcastd %edx,%xmm0
   1a660:	shr    $0x20,%rdx
   1a664:	and    %edx,%eax
   1a666:	shl    $0x4,%rax
   1a66a:	vmovdqa (%rcx,%rax,1),%xmm1
   1a66f:	vpmulhw -0x12577(%rip),%xmm0,%xmm0        # 8100 <anon.35274091df3394f4211c680a8c77ed4a.34.llvm.9036914972901821666+0x100>
   1a677:	vpbroadcastq -0x12a08(%rip),%xmm2        # 7c78 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x224>
   1a680:	vpshufb %xmm0,%xmm2,%xmm0
   1a685:	xor    %eax,%eax
   1a687:	vptest %xmm0,%xmm1
   1a68c:	setb   %al
   1a68f:	mov    %eax,(%rbx,%rdi,4)
   1a692:	add    $0x48,%rsp
   1a696:	pop    %rbx
   1a697:	pop    %r12
   1a699:	pop    %r13
   1a69b:	pop    %r14
   1a69d:	pop    %r15
   1a69f:	pop    %rbp
   1a6a0:	ret
   1a6a1:	lea    0x5d710(%rip),%rax        # 77db8 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0x88>
   1a6a8:	mov    %rax,0x18(%rsp)
   1a6ad:	movq   $0x1,0x20(%rsp)
   1a6b6:	movq   $0x8,0x28(%rsp)
   1a6bf:	vxorps %xmm0,%xmm0,%xmm0
   1a6c3:	vmovups %xmm0,0x30(%rsp)
   1a6c9:	lea    0x5d6f8(%rip),%r8        # 77dc8 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0x98>
   1a6d0:	lea    0x8(%rsp),%rsi
   1a6d5:	lea    0x10(%rsp),%rdx
   1a6da:	lea    0x18(%rsp),%rcx
   1a6df:	xor    %edi,%edi
   1a6e1:	call   *0x60e21(%rip)        # 7b508 <_DYNAMIC+0x2d8>
   1a6e7:	int3
   1a6e8:	int3
   1a6e9:	int3
   1a6ea:	int3
   1a6eb:	int3
   1a6ec:	int3
   1a6ed:	int3
   1a6ee:	int3
   1a6ef:	int3
