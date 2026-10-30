
/home/yiming/projects/fastest-bf-lab/build/vldb-raw32-stage3-v2/native/modern:     file format elf64-x86-64


Disassembly of section .text:

000000000002fed0 <void vldb_stage2::Query<raw32_stage3::RawHash<external_bloom::SimdBlock, raw32_stage3::ModernPolicy<external_bloom::SimdBlock> > >(raw32_stage3::RawHash<external_bloom::SimdBlock, raw32_stage3::ModernPolicy<external_bloom::SimdBlock> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
   2fed0:	push   %rbp
   2fed1:	mov    %rsp,%rbp
   2fed4:	push   %r15
   2fed6:	push   %r14
   2fed8:	mov    %rdi,%r14
   2fedb:	push   %r13
   2fedd:	push   %r12
   2fedf:	push   %rbx
   2fee0:	mov    %rdx,%rbx
   2fee3:	and    $0xffffffffffffffe0,%rsp
   2fee7:	sub    $0x20,%rsp
   2feeb:	mov    %rcx,0x18(%rsp)
   2fef0:	mov    %r8,0x10(%rsp)
   2fef5:	test   %esi,%esi
   2fef7:	je     2ff70 <void vldb_stage2::Query<raw32_stage3::RawHash<external_bloom::SimdBlock, raw32_stage3::ModernPolicy<external_bloom::SimdBlock> > >(raw32_stage3::RawHash<external_bloom::SimdBlock, raw32_stage3::ModernPolicy<external_bloom::SimdBlock> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0xa0>
   2fef9:	cmp    $0x1,%esi
   2fefc:	mov    $0x1000,%r15d
   2ff02:	mov    $0x1,%eax
   2ff07:	cmove  %rax,%r15
   2ff0b:	test   %rdx,%rdx
   2ff0e:	je     2ff59 <void vldb_stage2::Query<raw32_stage3::RawHash<external_bloom::SimdBlock, raw32_stage3::ModernPolicy<external_bloom::SimdBlock> > >(raw32_stage3::RawHash<external_bloom::SimdBlock, raw32_stage3::ModernPolicy<external_bloom::SimdBlock> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x89>
   2ff10:	mov    %rdx,%r13
   2ff13:	xor    %r12d,%r12d
   2ff16:	cs nopw 0x0(%rax,%rax,1)
   2ff20:	mov    0x10(%rsp),%rax
   2ff25:	lea    0x0(,%r12,4),%rdx
   2ff2d:	lea    (%rax,%rdx,1),%rcx
   2ff31:	mov    0x18(%rsp),%rax
   2ff36:	mov    %r14,%rdi
   2ff39:	add    %rax,%rdx
   2ff3c:	cmp    %r15,%r13
   2ff3f:	mov    %r15,%rax
   2ff42:	cmovbe %r13,%rax
   2ff46:	add    %r15,%r12
   2ff49:	mov    %rax,%rsi
   2ff4c:	call   2fe00 <void vldb_stage2::DenseCall<raw32_stage3::RawHash<external_bloom::SimdBlock, raw32_stage3::ModernPolicy<external_bloom::SimdBlock> > >(raw32_stage3::RawHash<external_bloom::SimdBlock, raw32_stage3::ModernPolicy<external_bloom::SimdBlock> > const&, unsigned int, unsigned int const*, unsigned int*)>
   2ff51:	sub    %r15,%r13
   2ff54:	cmp    %rbx,%r12
   2ff57:	jb     2ff20 <void vldb_stage2::Query<raw32_stage3::RawHash<external_bloom::SimdBlock, raw32_stage3::ModernPolicy<external_bloom::SimdBlock> > >(raw32_stage3::RawHash<external_bloom::SimdBlock, raw32_stage3::ModernPolicy<external_bloom::SimdBlock> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x50>
   2ff59:	lea    -0x28(%rbp),%rsp
   2ff5d:	pop    %rbx
   2ff5e:	pop    %r12
   2ff60:	pop    %r13
   2ff62:	pop    %r14
   2ff64:	pop    %r15
   2ff66:	pop    %rbp
   2ff67:	ret
   2ff68:	nopl   0x0(%rax,%rax,1)
   2ff70:	test   %rdx,%rdx
   2ff73:	je     2ff59 <void vldb_stage2::Query<raw32_stage3::RawHash<external_bloom::SimdBlock, raw32_stage3::ModernPolicy<external_bloom::SimdBlock> > >(raw32_stage3::RawHash<external_bloom::SimdBlock, raw32_stage3::ModernPolicy<external_bloom::SimdBlock> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x89>
   2ff75:	mov    $0x1,%eax
   2ff7a:	vmovdqa -0x2b922(%rip),%ymm3        # 4660 <bloom_filters::FastPatternBF::sparse_patterns_+0xc0>
   2ff82:	xor    %edx,%edx
   2ff84:	movabs $0xd6e8feb86659fd93,%rcx
   2ff8e:	vpbroadcastd %eax,%ymm2
   2ff94:	nopl   0x0(%rax)
   2ff98:	mov    0x18(%rsp),%rax
   2ff9d:	mov    0x10(%rsp),%rdi
   2ffa2:	mov    (%rax,%rdx,4),%eax
   2ffa5:	imul   %rcx,%rax
   2ffa9:	mov    %rax,%rsi
   2ffac:	shr    $0x20,%rsi
   2ffb0:	xor    %rsi,%rax
   2ffb3:	imul   %rcx,%rax
   2ffb7:	mov    %rax,%rsi
   2ffba:	shr    $0x20,%rsi
   2ffbe:	xor    %rsi,%rax
   2ffc1:	mov    (%r14),%esi
   2ffc4:	shrx   %rsi,%rax,%rsi
   2ffc9:	vpbroadcastd %esi,%ymm0
   2ffcf:	vpmulld %ymm3,%ymm0,%ymm0
   2ffd4:	and    0x4(%r14),%eax
   2ffd8:	shl    $0x5,%rax
   2ffdc:	add    0x8(%r14),%rax
   2ffe0:	vmovdqa (%rax),%ymm1
   2ffe4:	vpsrld $0x1b,%ymm0,%ymm0
   2ffe9:	vpsllvd %ymm0,%ymm2,%ymm0
   2ffee:	xor    %eax,%eax
   2fff0:	vptest %ymm0,%ymm1
   2fff5:	setb   %al
   2fff8:	mov    %eax,(%rdi,%rdx,4)
   2fffb:	inc    %rdx
   2fffe:	cmp    %rdx,%rbx
   30001:	jne    2ff98 <void vldb_stage2::Query<raw32_stage3::RawHash<external_bloom::SimdBlock, raw32_stage3::ModernPolicy<external_bloom::SimdBlock> > >(raw32_stage3::RawHash<external_bloom::SimdBlock, raw32_stage3::ModernPolicy<external_bloom::SimdBlock> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0xc8>
   30003:	vzeroupper
   30006:	lea    -0x28(%rbp),%rsp
   3000a:	pop    %rbx
   3000b:	pop    %r12
   3000d:	pop    %r13
   3000f:	pop    %r14
   30011:	pop    %r15
   30013:	pop    %rbp
   30014:	ret
