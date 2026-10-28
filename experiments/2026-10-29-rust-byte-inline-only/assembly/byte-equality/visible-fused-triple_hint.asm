
/tmp/fastest-bf-rust-byte-inline-only/release/compare_benchmark:     file format elf64-x86-64


Disassembly of section .text:

000000000001a6f0 <compare_benchmark::visible_lookup::<fastest_bloom_filter_leaf_inline::byte_split::ByteSplitBloomFilter, true>>:
   1a6f0:	push   %rbp
   1a6f1:	push   %r15
   1a6f3:	push   %r14
   1a6f5:	push   %r13
   1a6f7:	push   %r12
   1a6f9:	push   %rbx
   1a6fa:	sub    $0x48,%rsp
   1a6fe:	mov    %rdx,0x8(%rsp)
   1a703:	mov    %r8,0x10(%rsp)
   1a708:	cmp    %r8,%rdx
   1a70b:	jne    1a902 <compare_benchmark::visible_lookup::<fastest_bloom_filter_leaf_inline::byte_split::ByteSplitBloomFilter, true>+0x212>
   1a711:	mov    %rcx,%r13
   1a714:	mov    %rsi,%r12
   1a717:	mov    %rdi,%r15
   1a71a:	movabs $0xd6e8feb86659fd93,%r14
   1a724:	cmpb   $0x0,0x1c(%rdi)
   1a728:	je     1a73f <compare_benchmark::visible_lookup::<fastest_bloom_filter_leaf_inline::byte_split::ByteSplitBloomFilter, true>+0x4f>
   1a72a:	mov    0x18(%r15),%eax
   1a72e:	mov    0x8(%r15),%r10
   1a732:	cmp    $0x1,%rdx
   1a736:	jne    1a7a9 <compare_benchmark::visible_lookup::<fastest_bloom_filter_leaf_inline::byte_split::ByteSplitBloomFilter, true>+0xb9>
   1a738:	xor    %edi,%edi
   1a73a:	jmp    1a88e <compare_benchmark::visible_lookup::<fastest_bloom_filter_leaf_inline::byte_split::ByteSplitBloomFilter, true>+0x19e>
   1a73f:	xor    %ebp,%ebp
   1a741:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   1a750:	lea    0x1(%rbp),%rax
   1a754:	mov    %rax,(%rsp)
   1a758:	mov    (%r12,%rbp,8),%rax
   1a75c:	mov    %rax,%rsi
   1a75f:	shr    $0x20,%rsi
   1a763:	xor    %rax,%rsi
   1a766:	imul   %r14,%rsi
   1a76a:	mov    %rsi,%rax
   1a76d:	shr    $0x20,%rax
   1a771:	xor    %rsi,%rax
   1a774:	imul   %r14,%rax
   1a778:	mov    %rax,%rsi
   1a77b:	shr    $0x20,%rsi
   1a77f:	xor    %rax,%rsi
   1a782:	mov    %r15,%rdi
   1a785:	mov    %rdx,%rbx
   1a788:	call   2ee10 <<fastest_bloom_filter_leaf_inline::byte_split::ByteSplitBloomFilter>::contains_scalar>
   1a78d:	mov    %rbx,%rdx
   1a790:	movzbl %al,%eax
   1a793:	mov    %eax,0x0(%r13,%rbp,4)
   1a798:	mov    (%rsp),%rax
   1a79c:	mov    %rax,%rbp
   1a79f:	cmp    %rax,%rbx
   1a7a2:	jne    1a750 <compare_benchmark::visible_lookup::<fastest_bloom_filter_leaf_inline::byte_split::ByteSplitBloomFilter, true>+0x60>
   1a7a4:	jmp    1a8f3 <compare_benchmark::visible_lookup::<fastest_bloom_filter_leaf_inline::byte_split::ByteSplitBloomFilter, true>+0x203>
   1a7a9:	movabs $0x7ffffffffffffffe,%r9
   1a7b3:	and    %rdx,%r9
   1a7b6:	xor    %esi,%esi
   1a7b8:	vmovdqa -0x126c0(%rip),%xmm0        # 8100 <anon.35274091df3394f4211c680a8c77ed4a.34.llvm.9036914972901821666+0x100>
   1a7c0:	vpbroadcastq -0x12b51(%rip),%xmm1        # 7c78 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x224>
   1a7c9:	nopl   0x0(%rax)
   1a7d0:	mov    (%r12,%rsi,8),%rdi
   1a7d4:	mov    %rdi,%r8
   1a7d7:	shr    $0x20,%r8
   1a7db:	xor    %rdi,%r8
   1a7de:	imul   %r14,%r8
   1a7e2:	mov    %r8,%rdi
   1a7e5:	shr    $0x20,%rdi
   1a7e9:	xor    %r8,%rdi
   1a7ec:	imul   %r14,%rdi
   1a7f0:	mov    %rdi,%r8
   1a7f3:	shr    $0x20,%r8
   1a7f7:	xor    %r8d,%edi
   1a7fa:	and    %eax,%r8d
   1a7fd:	shl    $0x4,%r8
   1a801:	vmovdqa (%r10,%r8,1),%xmm2
   1a807:	vpbroadcastd %edi,%xmm3
   1a80d:	vpmulhw %xmm0,%xmm3,%xmm3
   1a811:	vpshufb %xmm3,%xmm1,%xmm3
   1a816:	xor    %edi,%edi
   1a818:	vptest %xmm3,%xmm2
   1a81d:	setb   %dil
   1a821:	mov    %edi,0x0(%r13,%rsi,4)
   1a826:	mov    0x8(%r12,%rsi,8),%rdi
   1a82b:	mov    %rdi,%r8
   1a82e:	shr    $0x20,%r8
   1a832:	xor    %rdi,%r8
   1a835:	imul   %r14,%r8
   1a839:	mov    %r8,%rdi
   1a83c:	shr    $0x20,%rdi
   1a840:	xor    %r8,%rdi
   1a843:	imul   %r14,%rdi
   1a847:	mov    %rdi,%r8
   1a84a:	shr    $0x20,%r8
   1a84e:	xor    %r8d,%edi
   1a851:	and    %eax,%r8d
   1a854:	shl    $0x4,%r8
   1a858:	vmovdqa (%r10,%r8,1),%xmm2
   1a85e:	vpbroadcastd %edi,%xmm3
   1a864:	vpmulhw %xmm0,%xmm3,%xmm3
   1a868:	vpshufb %xmm3,%xmm1,%xmm3
   1a86d:	xor    %r8d,%r8d
   1a870:	vptest %xmm3,%xmm2
   1a875:	lea    0x2(%rsi),%rdi
   1a879:	setb   %r8b
   1a87d:	mov    %r8d,0x4(%r13,%rsi,4)
   1a882:	mov    %rdi,%rsi
   1a885:	cmp    %rdi,%r9
   1a888:	jne    1a7d0 <compare_benchmark::visible_lookup::<fastest_bloom_filter_leaf_inline::byte_split::ByteSplitBloomFilter, true>+0xe0>
   1a88e:	test   $0x1,%dl
   1a891:	je     1a8f3 <compare_benchmark::visible_lookup::<fastest_bloom_filter_leaf_inline::byte_split::ByteSplitBloomFilter, true>+0x203>
   1a893:	mov    (%r12,%rdi,8),%rdx
   1a897:	mov    %rdx,%rsi
   1a89a:	shr    $0x20,%rsi
   1a89e:	xor    %rdx,%rsi
   1a8a1:	imul   %r14,%rsi
   1a8a5:	mov    %rsi,%rdx
   1a8a8:	shr    $0x20,%rdx
   1a8ac:	xor    %rsi,%rdx
   1a8af:	imul   %r14,%rdx
   1a8b3:	mov    %rdx,%rsi
   1a8b6:	shr    $0x20,%rsi
   1a8ba:	xor    %esi,%edx
   1a8bc:	and    %esi,%eax
   1a8be:	shl    $0x4,%rax
   1a8c2:	vmovdqa (%r10,%rax,1),%xmm0
   1a8c8:	vpbroadcastd %edx,%xmm1
   1a8ce:	vpmulhw -0x127d6(%rip),%xmm1,%xmm1        # 8100 <anon.35274091df3394f4211c680a8c77ed4a.34.llvm.9036914972901821666+0x100>
   1a8d6:	vpbroadcastq -0x12c67(%rip),%xmm2        # 7c78 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x224>
   1a8df:	vpshufb %xmm1,%xmm2,%xmm1
   1a8e4:	xor    %eax,%eax
   1a8e6:	vptest %xmm1,%xmm0
   1a8eb:	setb   %al
   1a8ee:	mov    %eax,0x0(%r13,%rdi,4)
   1a8f3:	add    $0x48,%rsp
   1a8f7:	pop    %rbx
   1a8f8:	pop    %r12
   1a8fa:	pop    %r13
   1a8fc:	pop    %r14
   1a8fe:	pop    %r15
   1a900:	pop    %rbp
   1a901:	ret
   1a902:	lea    0x5d4af(%rip),%rax        # 77db8 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0x88>
   1a909:	mov    %rax,0x18(%rsp)
   1a90e:	movq   $0x1,0x20(%rsp)
   1a917:	movq   $0x8,0x28(%rsp)
   1a920:	vxorps %xmm0,%xmm0,%xmm0
   1a924:	vmovups %xmm0,0x30(%rsp)
   1a92a:	lea    0x5d497(%rip),%r8        # 77dc8 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0x98>
   1a931:	lea    0x8(%rsp),%rsi
   1a936:	lea    0x10(%rsp),%rdx
   1a93b:	lea    0x18(%rsp),%rcx
   1a940:	xor    %edi,%edi
   1a942:	call   *0x60bc0(%rip)        # 7b508 <_DYNAMIC+0x2d8>
   1a948:	int3
   1a949:	int3
   1a94a:	int3
   1a94b:	int3
   1a94c:	int3
   1a94d:	int3
   1a94e:	int3
   1a94f:	int3
