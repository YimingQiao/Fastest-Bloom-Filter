
/tmp/fastest-bf-rust-byte-inline-only/release/compare_benchmark:     file format elf64-x86-64


Disassembly of section .text:

000000000001a140 <compare_benchmark::visible_lookup::<fastest_bloom_filter_byte_inline_only::byte_split::ByteSplitBloomFilter, true>>:
   1a140:	push   %rbp
   1a141:	push   %r15
   1a143:	push   %r14
   1a145:	push   %r13
   1a147:	push   %r12
   1a149:	push   %rbx
   1a14a:	sub    $0x48,%rsp
   1a14e:	mov    %rdx,0x8(%rsp)
   1a153:	mov    %r8,0x10(%rsp)
   1a158:	cmp    %r8,%rdx
   1a15b:	jne    1a352 <compare_benchmark::visible_lookup::<fastest_bloom_filter_byte_inline_only::byte_split::ByteSplitBloomFilter, true>+0x212>
   1a161:	mov    %rcx,%r13
   1a164:	mov    %rsi,%r12
   1a167:	mov    %rdi,%r15
   1a16a:	movabs $0xd6e8feb86659fd93,%r14
   1a174:	cmpb   $0x0,0x1c(%rdi)
   1a178:	je     1a18f <compare_benchmark::visible_lookup::<fastest_bloom_filter_byte_inline_only::byte_split::ByteSplitBloomFilter, true>+0x4f>
   1a17a:	mov    0x18(%r15),%eax
   1a17e:	mov    0x8(%r15),%r10
   1a182:	cmp    $0x1,%rdx
   1a186:	jne    1a1f9 <compare_benchmark::visible_lookup::<fastest_bloom_filter_byte_inline_only::byte_split::ByteSplitBloomFilter, true>+0xb9>
   1a188:	xor    %edi,%edi
   1a18a:	jmp    1a2de <compare_benchmark::visible_lookup::<fastest_bloom_filter_byte_inline_only::byte_split::ByteSplitBloomFilter, true>+0x19e>
   1a18f:	xor    %ebp,%ebp
   1a191:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   1a1a0:	lea    0x1(%rbp),%rax
   1a1a4:	mov    %rax,(%rsp)
   1a1a8:	mov    (%r12,%rbp,8),%rax
   1a1ac:	mov    %rax,%rsi
   1a1af:	shr    $0x20,%rsi
   1a1b3:	xor    %rax,%rsi
   1a1b6:	imul   %r14,%rsi
   1a1ba:	mov    %rsi,%rax
   1a1bd:	shr    $0x20,%rax
   1a1c1:	xor    %rsi,%rax
   1a1c4:	imul   %r14,%rax
   1a1c8:	mov    %rax,%rsi
   1a1cb:	shr    $0x20,%rsi
   1a1cf:	xor    %rax,%rsi
   1a1d2:	mov    %r15,%rdi
   1a1d5:	mov    %rdx,%rbx
   1a1d8:	call   2eaf0 <<fastest_bloom_filter_byte_inline_only::byte_split::ByteSplitBloomFilter>::contains_scalar>
   1a1dd:	mov    %rbx,%rdx
   1a1e0:	movzbl %al,%eax
   1a1e3:	mov    %eax,0x0(%r13,%rbp,4)
   1a1e8:	mov    (%rsp),%rax
   1a1ec:	mov    %rax,%rbp
   1a1ef:	cmp    %rax,%rbx
   1a1f2:	jne    1a1a0 <compare_benchmark::visible_lookup::<fastest_bloom_filter_byte_inline_only::byte_split::ByteSplitBloomFilter, true>+0x60>
   1a1f4:	jmp    1a343 <compare_benchmark::visible_lookup::<fastest_bloom_filter_byte_inline_only::byte_split::ByteSplitBloomFilter, true>+0x203>
   1a1f9:	movabs $0x7ffffffffffffffe,%r9
   1a203:	and    %rdx,%r9
   1a206:	xor    %esi,%esi
   1a208:	vmovdqa -0x12110(%rip),%xmm0        # 8100 <anon.35274091df3394f4211c680a8c77ed4a.34.llvm.9036914972901821666+0x100>
   1a210:	vpbroadcastq -0x125a1(%rip),%xmm1        # 7c78 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x224>
   1a219:	nopl   0x0(%rax)
   1a220:	mov    (%r12,%rsi,8),%rdi
   1a224:	mov    %rdi,%r8
   1a227:	shr    $0x20,%r8
   1a22b:	xor    %rdi,%r8
   1a22e:	imul   %r14,%r8
   1a232:	mov    %r8,%rdi
   1a235:	shr    $0x20,%rdi
   1a239:	xor    %r8,%rdi
   1a23c:	imul   %r14,%rdi
   1a240:	mov    %rdi,%r8
   1a243:	shr    $0x20,%r8
   1a247:	xor    %r8d,%edi
   1a24a:	and    %eax,%r8d
   1a24d:	shl    $0x4,%r8
   1a251:	vmovdqa (%r10,%r8,1),%xmm2
   1a257:	vpbroadcastd %edi,%xmm3
   1a25d:	vpmulhw %xmm0,%xmm3,%xmm3
   1a261:	vpshufb %xmm3,%xmm1,%xmm3
   1a266:	xor    %edi,%edi
   1a268:	vptest %xmm3,%xmm2
   1a26d:	setb   %dil
   1a271:	mov    %edi,0x0(%r13,%rsi,4)
   1a276:	mov    0x8(%r12,%rsi,8),%rdi
   1a27b:	mov    %rdi,%r8
   1a27e:	shr    $0x20,%r8
   1a282:	xor    %rdi,%r8
   1a285:	imul   %r14,%r8
   1a289:	mov    %r8,%rdi
   1a28c:	shr    $0x20,%rdi
   1a290:	xor    %r8,%rdi
   1a293:	imul   %r14,%rdi
   1a297:	mov    %rdi,%r8
   1a29a:	shr    $0x20,%r8
   1a29e:	xor    %r8d,%edi
   1a2a1:	and    %eax,%r8d
   1a2a4:	shl    $0x4,%r8
   1a2a8:	vmovdqa (%r10,%r8,1),%xmm2
   1a2ae:	vpbroadcastd %edi,%xmm3
   1a2b4:	vpmulhw %xmm0,%xmm3,%xmm3
   1a2b8:	vpshufb %xmm3,%xmm1,%xmm3
   1a2bd:	xor    %r8d,%r8d
   1a2c0:	vptest %xmm3,%xmm2
   1a2c5:	lea    0x2(%rsi),%rdi
   1a2c9:	setb   %r8b
   1a2cd:	mov    %r8d,0x4(%r13,%rsi,4)
   1a2d2:	mov    %rdi,%rsi
   1a2d5:	cmp    %rdi,%r9
   1a2d8:	jne    1a220 <compare_benchmark::visible_lookup::<fastest_bloom_filter_byte_inline_only::byte_split::ByteSplitBloomFilter, true>+0xe0>
   1a2de:	test   $0x1,%dl
   1a2e1:	je     1a343 <compare_benchmark::visible_lookup::<fastest_bloom_filter_byte_inline_only::byte_split::ByteSplitBloomFilter, true>+0x203>
   1a2e3:	mov    (%r12,%rdi,8),%rdx
   1a2e7:	mov    %rdx,%rsi
   1a2ea:	shr    $0x20,%rsi
   1a2ee:	xor    %rdx,%rsi
   1a2f1:	imul   %r14,%rsi
   1a2f5:	mov    %rsi,%rdx
   1a2f8:	shr    $0x20,%rdx
   1a2fc:	xor    %rsi,%rdx
   1a2ff:	imul   %r14,%rdx
   1a303:	mov    %rdx,%rsi
   1a306:	shr    $0x20,%rsi
   1a30a:	xor    %esi,%edx
   1a30c:	and    %esi,%eax
   1a30e:	shl    $0x4,%rax
   1a312:	vmovdqa (%r10,%rax,1),%xmm0
   1a318:	vpbroadcastd %edx,%xmm1
   1a31e:	vpmulhw -0x12226(%rip),%xmm1,%xmm1        # 8100 <anon.35274091df3394f4211c680a8c77ed4a.34.llvm.9036914972901821666+0x100>
   1a326:	vpbroadcastq -0x126b7(%rip),%xmm2        # 7c78 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x224>
   1a32f:	vpshufb %xmm1,%xmm2,%xmm1
   1a334:	xor    %eax,%eax
   1a336:	vptest %xmm1,%xmm0
   1a33b:	setb   %al
   1a33e:	mov    %eax,0x0(%r13,%rdi,4)
   1a343:	add    $0x48,%rsp
   1a347:	pop    %rbx
   1a348:	pop    %r12
   1a34a:	pop    %r13
   1a34c:	pop    %r14
   1a34e:	pop    %r15
   1a350:	pop    %rbp
   1a351:	ret
   1a352:	lea    0x5da5f(%rip),%rax        # 77db8 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0x88>
   1a359:	mov    %rax,0x18(%rsp)
   1a35e:	movq   $0x1,0x20(%rsp)
   1a367:	movq   $0x8,0x28(%rsp)
   1a370:	vxorps %xmm0,%xmm0,%xmm0
   1a374:	vmovups %xmm0,0x30(%rsp)
   1a37a:	lea    0x5da47(%rip),%r8        # 77dc8 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0x98>
   1a381:	lea    0x8(%rsp),%rsi
   1a386:	lea    0x10(%rsp),%rdx
   1a38b:	lea    0x18(%rsp),%rcx
   1a390:	xor    %edi,%edi
   1a392:	call   *0x61170(%rip)        # 7b508 <_DYNAMIC+0x2d8>
   1a398:	int3
   1a399:	int3
   1a39a:	int3
   1a39b:	int3
   1a39c:	int3
   1a39d:	int3
   1a39e:	int3
   1a39f:	int3
