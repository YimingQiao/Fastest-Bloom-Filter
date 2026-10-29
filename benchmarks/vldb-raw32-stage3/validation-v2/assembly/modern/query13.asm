
/home/yiming/projects/fastest-bf-lab/build/vldb-raw32-stage3-v2/native/modern:     file format elf64-x86-64


Disassembly of section .text:

000000000002fc70 <void vldb_stage2::Query<raw32_stage3::RawHash<external_bloom::Fixed64, raw32_stage3::ModernPolicy<external_bloom::Fixed64> > >(raw32_stage3::RawHash<external_bloom::Fixed64, raw32_stage3::ModernPolicy<external_bloom::Fixed64> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
   2fc70:	push   %rbp
   2fc71:	mov    %rsp,%rbp
   2fc74:	push   %r15
   2fc76:	push   %r14
   2fc78:	push   %r13
   2fc7a:	push   %r12
   2fc7c:	mov    %rdx,%r12
   2fc7f:	push   %rbx
   2fc80:	mov    %rdi,%rbx
   2fc83:	and    $0xffffffffffffffe0,%rsp
   2fc87:	sub    $0x20,%rsp
   2fc8b:	mov    %rcx,0x18(%rsp)
   2fc90:	mov    %r8,0x10(%rsp)
   2fc95:	test   %esi,%esi
   2fc97:	je     2fd10 <void vldb_stage2::Query<raw32_stage3::RawHash<external_bloom::Fixed64, raw32_stage3::ModernPolicy<external_bloom::Fixed64> > >(raw32_stage3::RawHash<external_bloom::Fixed64, raw32_stage3::ModernPolicy<external_bloom::Fixed64> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0xa0>
   2fc99:	cmp    $0x1,%esi
   2fc9c:	mov    $0x1000,%r15d
   2fca2:	mov    $0x1,%eax
   2fca7:	cmove  %rax,%r15
   2fcab:	test   %rdx,%rdx
   2fcae:	je     2fcf9 <void vldb_stage2::Query<raw32_stage3::RawHash<external_bloom::Fixed64, raw32_stage3::ModernPolicy<external_bloom::Fixed64> > >(raw32_stage3::RawHash<external_bloom::Fixed64, raw32_stage3::ModernPolicy<external_bloom::Fixed64> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x89>
   2fcb0:	mov    %rdx,%r14
   2fcb3:	xor    %r13d,%r13d
   2fcb6:	cs nopw 0x0(%rax,%rax,1)
   2fcc0:	mov    0x10(%rsp),%rax
   2fcc5:	lea    0x0(,%r13,4),%rdx
   2fccd:	lea    (%rax,%rdx,1),%rcx
   2fcd1:	mov    0x18(%rsp),%rax
   2fcd6:	mov    %rbx,%rdi
   2fcd9:	add    %rax,%rdx
   2fcdc:	cmp    %r14,%r15
   2fcdf:	mov    %r14,%rax
   2fce2:	cmovbe %r15,%rax
   2fce6:	add    %r15,%r13
   2fce9:	mov    %rax,%rsi
   2fcec:	call   2fb90 <void vldb_stage2::DenseCall<raw32_stage3::RawHash<external_bloom::Fixed64, raw32_stage3::ModernPolicy<external_bloom::Fixed64> > >(raw32_stage3::RawHash<external_bloom::Fixed64, raw32_stage3::ModernPolicy<external_bloom::Fixed64> > const&, unsigned int, unsigned int const*, unsigned int*)>
   2fcf1:	sub    %r15,%r14
   2fcf4:	cmp    %r12,%r13
   2fcf7:	jb     2fcc0 <void vldb_stage2::Query<raw32_stage3::RawHash<external_bloom::Fixed64, raw32_stage3::ModernPolicy<external_bloom::Fixed64> > >(raw32_stage3::RawHash<external_bloom::Fixed64, raw32_stage3::ModernPolicy<external_bloom::Fixed64> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x50>
   2fcf9:	lea    -0x28(%rbp),%rsp
   2fcfd:	pop    %rbx
   2fcfe:	pop    %r12
   2fd00:	pop    %r13
   2fd02:	pop    %r14
   2fd04:	pop    %r15
   2fd06:	pop    %rbp
   2fd07:	ret
   2fd08:	nopl   0x0(%rax,%rax,1)
   2fd10:	test   %rdx,%rdx
   2fd13:	je     2fcf9 <void vldb_stage2::Query<raw32_stage3::RawHash<external_bloom::Fixed64, raw32_stage3::ModernPolicy<external_bloom::Fixed64> > >(raw32_stage3::RawHash<external_bloom::Fixed64, raw32_stage3::ModernPolicy<external_bloom::Fixed64> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x89>
   2fd15:	mov    $0x1,%eax
   2fd1a:	vmovdqa -0x2b6c2(%rip),%ymm4        # 4660 <bloom_filters::FastPatternBF::sparse_patterns_+0xc0>
   2fd22:	xor    %edx,%edx
   2fd24:	movabs $0xd6e8feb86659fd93,%rcx
   2fd2e:	vpxor  %xmm3,%xmm3,%xmm3
   2fd32:	vpbroadcastq %rax,%ymm2
   2fd38:	nopl   0x0(%rax,%rax,1)
   2fd40:	mov    0x18(%rsp),%rax
   2fd45:	mov    0x10(%rsp),%rdi
   2fd4a:	mov    (%rax,%rdx,4),%eax
   2fd4d:	imul   %rcx,%rax
   2fd51:	mov    %rax,%rsi
   2fd54:	shr    $0x20,%rsi
   2fd58:	xor    %rsi,%rax
   2fd5b:	imul   %rcx,%rax
   2fd5f:	mov    %rax,%rsi
   2fd62:	shr    $0x20,%rsi
   2fd66:	xor    %rsi,%rax
   2fd69:	vpbroadcastd %eax,%ymm0
   2fd6f:	mov    (%rbx),%esi
   2fd71:	shr    $0x20,%rax
   2fd75:	vpmulld %ymm4,%ymm0,%ymm0
   2fd7a:	imul   %rsi,%rax
   2fd7e:	xor    %esi,%esi
   2fd80:	shr    $0x20,%rax
   2fd84:	vpsrld $0x1a,%ymm0,%ymm0
   2fd89:	shl    $0x6,%rax
   2fd8d:	add    0x8(%rbx),%rax
   2fd91:	vpunpckhdq %ymm3,%ymm0,%ymm1
   2fd95:	vmovdqa (%rax),%ymm5
   2fd99:	vpsllvq %ymm1,%ymm2,%ymm1
   2fd9e:	vpunpckldq %ymm3,%ymm0,%ymm0
   2fda2:	vptest %ymm1,%ymm5
   2fda7:	vpsllvq %ymm0,%ymm2,%ymm0
   2fdac:	vmovdqa 0x20(%rax),%ymm1
   2fdb1:	setb   %sil
   2fdb5:	xor    %eax,%eax
   2fdb7:	vptest %ymm0,%ymm1
   2fdbc:	setb   %al
   2fdbf:	and    %esi,%eax
   2fdc1:	mov    %eax,(%rdi,%rdx,4)
   2fdc4:	inc    %rdx
   2fdc7:	cmp    %rdx,%r12
   2fdca:	jne    2fd40 <void vldb_stage2::Query<raw32_stage3::RawHash<external_bloom::Fixed64, raw32_stage3::ModernPolicy<external_bloom::Fixed64> > >(raw32_stage3::RawHash<external_bloom::Fixed64, raw32_stage3::ModernPolicy<external_bloom::Fixed64> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0xd0>
   2fdd0:	vzeroupper
   2fdd3:	lea    -0x28(%rbp),%rsp
   2fdd7:	pop    %rbx
   2fdd8:	pop    %r12
   2fdda:	pop    %r13
   2fddc:	pop    %r14
   2fdde:	pop    %r15
   2fde0:	pop    %rbp
   2fde1:	ret
