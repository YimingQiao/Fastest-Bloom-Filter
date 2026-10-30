
/home/yiming/projects/fastest-bf-lab/build/vldb-raw32-stage3-v2/native/modern:     file format elf64-x86-64


Disassembly of section .text:

000000000002fa30 <void vldb_stage2::Query<raw32_stage3::RawHash<external_bloom::Fixed32<true>, raw32_stage3::ModernPolicy<external_bloom::Fixed32<true> > > >(raw32_stage3::RawHash<external_bloom::Fixed32<true>, raw32_stage3::ModernPolicy<external_bloom::Fixed32<true> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
   2fa30:	push   %rbp
   2fa31:	mov    %rsp,%rbp
   2fa34:	push   %r15
   2fa36:	push   %r14
   2fa38:	push   %r13
   2fa3a:	push   %r12
   2fa3c:	mov    %rdx,%r12
   2fa3f:	push   %rbx
   2fa40:	mov    %rdi,%rbx
   2fa43:	and    $0xffffffffffffffe0,%rsp
   2fa47:	sub    $0x20,%rsp
   2fa4b:	mov    %rcx,0x18(%rsp)
   2fa50:	mov    %r8,0x10(%rsp)
   2fa55:	test   %esi,%esi
   2fa57:	je     2fad0 <void vldb_stage2::Query<raw32_stage3::RawHash<external_bloom::Fixed32<true>, raw32_stage3::ModernPolicy<external_bloom::Fixed32<true> > > >(raw32_stage3::RawHash<external_bloom::Fixed32<true>, raw32_stage3::ModernPolicy<external_bloom::Fixed32<true> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0xa0>
   2fa59:	cmp    $0x1,%esi
   2fa5c:	mov    $0x1000,%r15d
   2fa62:	mov    $0x1,%eax
   2fa67:	cmove  %rax,%r15
   2fa6b:	test   %rdx,%rdx
   2fa6e:	je     2fab9 <void vldb_stage2::Query<raw32_stage3::RawHash<external_bloom::Fixed32<true>, raw32_stage3::ModernPolicy<external_bloom::Fixed32<true> > > >(raw32_stage3::RawHash<external_bloom::Fixed32<true>, raw32_stage3::ModernPolicy<external_bloom::Fixed32<true> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x89>
   2fa70:	mov    %rdx,%r14
   2fa73:	xor    %r13d,%r13d
   2fa76:	cs nopw 0x0(%rax,%rax,1)
   2fa80:	mov    0x10(%rsp),%rax
   2fa85:	lea    0x0(,%r13,4),%rdx
   2fa8d:	lea    (%rax,%rdx,1),%rcx
   2fa91:	mov    0x18(%rsp),%rax
   2fa96:	mov    %rbx,%rdi
   2fa99:	add    %rax,%rdx
   2fa9c:	cmp    %r14,%r15
   2fa9f:	mov    %r14,%rax
   2faa2:	cmovbe %r15,%rax
   2faa6:	add    %r15,%r13
   2faa9:	mov    %rax,%rsi
   2faac:	call   2f960 <void vldb_stage2::DenseCall<raw32_stage3::RawHash<external_bloom::Fixed32<true>, raw32_stage3::ModernPolicy<external_bloom::Fixed32<true> > > >(raw32_stage3::RawHash<external_bloom::Fixed32<true>, raw32_stage3::ModernPolicy<external_bloom::Fixed32<true> > > const&, unsigned int, unsigned int const*, unsigned int*)>
   2fab1:	sub    %r15,%r14
   2fab4:	cmp    %r12,%r13
   2fab7:	jb     2fa80 <void vldb_stage2::Query<raw32_stage3::RawHash<external_bloom::Fixed32<true>, raw32_stage3::ModernPolicy<external_bloom::Fixed32<true> > > >(raw32_stage3::RawHash<external_bloom::Fixed32<true>, raw32_stage3::ModernPolicy<external_bloom::Fixed32<true> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x50>
   2fab9:	lea    -0x28(%rbp),%rsp
   2fabd:	pop    %rbx
   2fabe:	pop    %r12
   2fac0:	pop    %r13
   2fac2:	pop    %r14
   2fac4:	pop    %r15
   2fac6:	pop    %rbp
   2fac7:	ret
   2fac8:	nopl   0x0(%rax,%rax,1)
   2fad0:	test   %rdx,%rdx
   2fad3:	je     2fab9 <void vldb_stage2::Query<raw32_stage3::RawHash<external_bloom::Fixed32<true>, raw32_stage3::ModernPolicy<external_bloom::Fixed32<true> > > >(raw32_stage3::RawHash<external_bloom::Fixed32<true>, raw32_stage3::ModernPolicy<external_bloom::Fixed32<true> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x89>
   2fad5:	mov    $0x1,%eax
   2fada:	vmovdqa -0x2b482(%rip),%ymm3        # 4660 <bloom_filters::FastPatternBF::sparse_patterns_+0xc0>
   2fae2:	xor    %edx,%edx
   2fae4:	movabs $0xd6e8feb86659fd93,%rcx
   2faee:	vpbroadcastd %eax,%ymm2
   2faf4:	nopl   0x0(%rax)
   2faf8:	mov    0x18(%rsp),%rax
   2fafd:	mov    0x10(%rsp),%rdi
   2fb02:	mov    (%rax,%rdx,4),%eax
   2fb05:	imul   %rcx,%rax
   2fb09:	mov    %rax,%rsi
   2fb0c:	shr    $0x20,%rsi
   2fb10:	xor    %rsi,%rax
   2fb13:	imul   %rcx,%rax
   2fb17:	mov    %rax,%rsi
   2fb1a:	shr    $0x20,%rsi
   2fb1e:	xor    %rsi,%rax
   2fb21:	mov    (%rbx),%esi
   2fb23:	vpbroadcastd %eax,%ymm0
   2fb29:	shr    $0x20,%rax
   2fb2d:	imul   %rsi,%rax
   2fb31:	vpmulld %ymm3,%ymm0,%ymm0
   2fb36:	shr    $0x20,%rax
   2fb3a:	shl    $0x5,%rax
   2fb3e:	add    0x8(%rbx),%rax
   2fb42:	vpsrld $0x1b,%ymm0,%ymm0
   2fb47:	vmovdqa (%rax),%ymm1
   2fb4b:	vpsllvd %ymm0,%ymm2,%ymm0
   2fb50:	xor    %eax,%eax
   2fb52:	vptest %ymm0,%ymm1
   2fb57:	setb   %al
   2fb5a:	mov    %eax,(%rdi,%rdx,4)
   2fb5d:	inc    %rdx
   2fb60:	cmp    %rdx,%r12
   2fb63:	jne    2faf8 <void vldb_stage2::Query<raw32_stage3::RawHash<external_bloom::Fixed32<true>, raw32_stage3::ModernPolicy<external_bloom::Fixed32<true> > > >(raw32_stage3::RawHash<external_bloom::Fixed32<true>, raw32_stage3::ModernPolicy<external_bloom::Fixed32<true> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0xc8>
   2fb65:	vzeroupper
   2fb68:	lea    -0x28(%rbp),%rsp
   2fb6c:	pop    %rbx
   2fb6d:	pop    %r12
   2fb6f:	pop    %r13
   2fb71:	pop    %r14
   2fb73:	pop    %r15
   2fb75:	pop    %rbp
   2fb76:	ret
