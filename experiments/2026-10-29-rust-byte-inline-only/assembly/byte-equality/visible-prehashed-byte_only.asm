
/tmp/fastest-bf-rust-byte-inline-only/release/compare_benchmark:     file format elf64-x86-64


Disassembly of section .text:

0000000000019f90 <compare_benchmark::visible_lookup::<fastest_bloom_filter_byte_inline_only::byte_split::ByteSplitBloomFilter, false>>:
   19f90:	push   %rbp
   19f91:	push   %r15
   19f93:	push   %r14
   19f95:	push   %r13
   19f97:	push   %r12
   19f99:	push   %rbx
   19f9a:	sub    $0x48,%rsp
   19f9e:	mov    %rdx,0x8(%rsp)
   19fa3:	mov    %r8,0x10(%rsp)
   19fa8:	cmp    %r8,%rdx
   19fab:	jne    1a0f1 <compare_benchmark::visible_lookup::<fastest_bloom_filter_byte_inline_only::byte_split::ByteSplitBloomFilter, false>+0x161>
   19fb1:	mov    %rdx,%r15
   19fb4:	test   %rdx,%rdx
   19fb7:	je     1a0e2 <compare_benchmark::visible_lookup::<fastest_bloom_filter_byte_inline_only::byte_split::ByteSplitBloomFilter, false>+0x152>
   19fbd:	mov    %rcx,%rbx
   19fc0:	mov    %rsi,%r14
   19fc3:	mov    %rdi,%r12
   19fc6:	cmpb   $0x0,0x1c(%rdi)
   19fca:	je     19fe3 <compare_benchmark::visible_lookup::<fastest_bloom_filter_byte_inline_only::byte_split::ByteSplitBloomFilter, false>+0x53>
   19fcc:	mov    0x18(%r12),%eax
   19fd1:	mov    0x8(%r12),%rcx
   19fd6:	cmp    $0x1,%r15
   19fda:	jne    1a014 <compare_benchmark::visible_lookup::<fastest_bloom_filter_byte_inline_only::byte_split::ByteSplitBloomFilter, false>+0x84>
   19fdc:	xor    %edi,%edi
   19fde:	jmp    1a0a0 <compare_benchmark::visible_lookup::<fastest_bloom_filter_byte_inline_only::byte_split::ByteSplitBloomFilter, false>+0x110>
   19fe3:	xor    %r13d,%r13d
   19fe6:	cs nopw 0x0(%rax,%rax,1)
   19ff0:	lea    0x1(%r13),%rbp
   19ff4:	mov    (%r14,%r13,8),%rsi
   19ff8:	mov    %r12,%rdi
   19ffb:	call   2eaf0 <<fastest_bloom_filter_byte_inline_only::byte_split::ByteSplitBloomFilter>::contains_scalar>
   1a000:	movzbl %al,%eax
   1a003:	mov    %eax,(%rbx,%r13,4)
   1a007:	mov    %rbp,%r13
   1a00a:	cmp    %rbp,%r15
   1a00d:	jne    19ff0 <compare_benchmark::visible_lookup::<fastest_bloom_filter_byte_inline_only::byte_split::ByteSplitBloomFilter, false>+0x60>
   1a00f:	jmp    1a0e2 <compare_benchmark::visible_lookup::<fastest_bloom_filter_byte_inline_only::byte_split::ByteSplitBloomFilter, false>+0x152>
   1a014:	mov    %r15,%rdx
   1a017:	and    $0xfffffffffffffffe,%rdx
   1a01b:	xor    %esi,%esi
   1a01d:	vmovdqa -0x11f25(%rip),%xmm0        # 8100 <anon.35274091df3394f4211c680a8c77ed4a.34.llvm.9036914972901821666+0x100>
   1a025:	vpbroadcastq -0x123b6(%rip),%xmm1        # 7c78 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x224>
   1a02e:	xchg   %ax,%ax
   1a030:	mov    (%r14,%rsi,8),%rdi
   1a034:	vpbroadcastd %edi,%xmm2
   1a03a:	shr    $0x20,%rdi
   1a03e:	and    %eax,%edi
   1a040:	shl    $0x4,%rdi
   1a044:	vmovdqa (%rcx,%rdi,1),%xmm3
   1a049:	vpmulhw %xmm0,%xmm2,%xmm2
   1a04d:	vpshufb %xmm2,%xmm1,%xmm2
   1a052:	xor    %edi,%edi
   1a054:	vptest %xmm2,%xmm3
   1a059:	setb   %dil
   1a05d:	mov    %edi,(%rbx,%rsi,4)
   1a060:	mov    0x8(%r14,%rsi,8),%rdi
   1a065:	vpbroadcastd %edi,%xmm2
   1a06b:	shr    $0x20,%rdi
   1a06f:	and    %eax,%edi
   1a071:	shl    $0x4,%rdi
   1a075:	vmovdqa (%rcx,%rdi,1),%xmm3
   1a07a:	vpmulhw %xmm0,%xmm2,%xmm2
   1a07e:	vpshufb %xmm2,%xmm1,%xmm2
   1a083:	xor    %r8d,%r8d
   1a086:	vptest %xmm2,%xmm3
   1a08b:	lea    0x2(%rsi),%rdi
   1a08f:	setb   %r8b
   1a093:	mov    %r8d,0x4(%rbx,%rsi,4)
   1a098:	mov    %rdi,%rsi
   1a09b:	cmp    %rdi,%rdx
   1a09e:	jne    1a030 <compare_benchmark::visible_lookup::<fastest_bloom_filter_byte_inline_only::byte_split::ByteSplitBloomFilter, false>+0xa0>
   1a0a0:	test   $0x1,%r15b
   1a0a4:	je     1a0e2 <compare_benchmark::visible_lookup::<fastest_bloom_filter_byte_inline_only::byte_split::ByteSplitBloomFilter, false>+0x152>
   1a0a6:	mov    (%r14,%rdi,8),%rdx
   1a0aa:	vpbroadcastd %edx,%xmm0
   1a0b0:	shr    $0x20,%rdx
   1a0b4:	and    %edx,%eax
   1a0b6:	shl    $0x4,%rax
   1a0ba:	vmovdqa (%rcx,%rax,1),%xmm1
   1a0bf:	vpmulhw -0x11fc7(%rip),%xmm0,%xmm0        # 8100 <anon.35274091df3394f4211c680a8c77ed4a.34.llvm.9036914972901821666+0x100>
   1a0c7:	vpbroadcastq -0x12458(%rip),%xmm2        # 7c78 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x224>
   1a0d0:	vpshufb %xmm0,%xmm2,%xmm0
   1a0d5:	xor    %eax,%eax
   1a0d7:	vptest %xmm0,%xmm1
   1a0dc:	setb   %al
   1a0df:	mov    %eax,(%rbx,%rdi,4)
   1a0e2:	add    $0x48,%rsp
   1a0e6:	pop    %rbx
   1a0e7:	pop    %r12
   1a0e9:	pop    %r13
   1a0eb:	pop    %r14
   1a0ed:	pop    %r15
   1a0ef:	pop    %rbp
   1a0f0:	ret
   1a0f1:	lea    0x5dcc0(%rip),%rax        # 77db8 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0x88>
   1a0f8:	mov    %rax,0x18(%rsp)
   1a0fd:	movq   $0x1,0x20(%rsp)
   1a106:	movq   $0x8,0x28(%rsp)
   1a10f:	vxorps %xmm0,%xmm0,%xmm0
   1a113:	vmovups %xmm0,0x30(%rsp)
   1a119:	lea    0x5dca8(%rip),%r8        # 77dc8 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0x98>
   1a120:	lea    0x8(%rsp),%rsi
   1a125:	lea    0x10(%rsp),%rdx
   1a12a:	lea    0x18(%rsp),%rcx
   1a12f:	xor    %edi,%edi
   1a131:	call   *0x613d1(%rip)        # 7b508 <_DYNAMIC+0x2d8>
   1a137:	int3
   1a138:	int3
   1a139:	int3
   1a13a:	int3
   1a13b:	int3
   1a13c:	int3
   1a13d:	int3
   1a13e:	int3
   1a13f:	int3
