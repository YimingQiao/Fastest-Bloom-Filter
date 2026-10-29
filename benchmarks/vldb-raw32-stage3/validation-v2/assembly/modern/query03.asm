
/home/yiming/projects/fastest-bf-lab/build/vldb-raw32-stage3-v2/native/modern:     file format elf64-x86-64


Disassembly of section .text:

000000000002dca0 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::FourSectorBloomFilter, raw32_stage3::NativePolicy<bloom_filters::FourSectorBloomFilter, 8> > >(raw32_stage3::RawHash<bloom_filters::FourSectorBloomFilter, raw32_stage3::NativePolicy<bloom_filters::FourSectorBloomFilter, 8> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
   2dca0:	push   %r15
   2dca2:	push   %r14
   2dca4:	push   %r13
   2dca6:	mov    %r8,%r13
   2dca9:	push   %r12
   2dcab:	push   %rbp
   2dcac:	mov    %rdx,%rbp
   2dcaf:	push   %rbx
   2dcb0:	mov    %rdi,%rbx
   2dcb3:	sub    $0x18,%rsp
   2dcb7:	mov    %rcx,0x8(%rsp)
   2dcbc:	test   %esi,%esi
   2dcbe:	je     2dd24 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::FourSectorBloomFilter, raw32_stage3::NativePolicy<bloom_filters::FourSectorBloomFilter, 8> > >(raw32_stage3::RawHash<bloom_filters::FourSectorBloomFilter, raw32_stage3::NativePolicy<bloom_filters::FourSectorBloomFilter, 8> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x84>
   2dcc0:	cmp    $0x1,%esi
   2dcc3:	mov    $0x1000,%r14d
   2dcc9:	mov    $0x1,%eax
   2dcce:	cmove  %rax,%r14
   2dcd2:	test   %rdx,%rdx
   2dcd5:	je     2dd15 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::FourSectorBloomFilter, raw32_stage3::NativePolicy<bloom_filters::FourSectorBloomFilter, 8> > >(raw32_stage3::RawHash<bloom_filters::FourSectorBloomFilter, raw32_stage3::NativePolicy<bloom_filters::FourSectorBloomFilter, 8> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x75>
   2dcd7:	mov    %rdx,%r12
   2dcda:	xor    %r15d,%r15d
   2dcdd:	nopl   (%rax)
   2dce0:	mov    0x8(%rsp),%rax
   2dce5:	lea    0x0(,%r15,4),%rdx
   2dced:	lea    0x0(%r13,%rdx,1),%rcx
   2dcf2:	add    %rax,%rdx
   2dcf5:	cmp    %r14,%r12
   2dcf8:	mov    %r14,%rax
   2dcfb:	cmovbe %r12,%rax
   2dcff:	mov    %rbx,%rdi
   2dd02:	mov    %rax,%rsi
   2dd05:	add    %r14,%r15
   2dd08:	call   2dc90 <void vldb_stage2::DenseCall<raw32_stage3::RawHash<bloom_filters::FourSectorBloomFilter, raw32_stage3::NativePolicy<bloom_filters::FourSectorBloomFilter, 8> > >(raw32_stage3::RawHash<bloom_filters::FourSectorBloomFilter, raw32_stage3::NativePolicy<bloom_filters::FourSectorBloomFilter, 8> > const&, unsigned int, unsigned int const*, unsigned int*)>
   2dd0d:	sub    %r14,%r12
   2dd10:	cmp    %rbp,%r15
   2dd13:	jb     2dce0 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::FourSectorBloomFilter, raw32_stage3::NativePolicy<bloom_filters::FourSectorBloomFilter, 8> > >(raw32_stage3::RawHash<bloom_filters::FourSectorBloomFilter, raw32_stage3::NativePolicy<bloom_filters::FourSectorBloomFilter, 8> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x40>
   2dd15:	add    $0x18,%rsp
   2dd19:	pop    %rbx
   2dd1a:	pop    %rbp
   2dd1b:	pop    %r12
   2dd1d:	pop    %r13
   2dd1f:	pop    %r14
   2dd21:	pop    %r15
   2dd23:	ret
   2dd24:	xor    %esi,%esi
   2dd26:	lea    -0x2984d(%rip),%r8        # 44e0 <bloom_filters::FourSectorBloomFilter::patterns2>
   2dd2d:	movabs $0xd6e8feb86659fd93,%r9
   2dd37:	test   %rdx,%rdx
   2dd3a:	je     2dd15 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::FourSectorBloomFilter, raw32_stage3::NativePolicy<bloom_filters::FourSectorBloomFilter, 8> > >(raw32_stage3::RawHash<bloom_filters::FourSectorBloomFilter, raw32_stage3::NativePolicy<bloom_filters::FourSectorBloomFilter, 8> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x75>
   2dd3c:	nopl   0x0(%rax)
   2dd40:	mov    0x8(%rsp),%rax
   2dd45:	mov    0x18(%rbx),%r10d
   2dd49:	mov    (%rax,%rsi,4),%eax
   2dd4c:	imul   %r9,%rax
   2dd50:	mov    %rax,%rdx
   2dd53:	shr    $0x20,%rdx
   2dd57:	xor    %rdx,%rax
   2dd5a:	imul   %r9,%rax
   2dd5e:	mov    %rax,%rdx
   2dd61:	shr    $0x20,%rdx
   2dd65:	xor    %rdx,%rax
   2dd68:	mov    %rax,%rdi
   2dd6b:	and    $0xf,%edi
   2dd6e:	mov    (%r8,%rdi,4),%r14d
   2dd72:	mov    %eax,%ecx
   2dd74:	shr    $0x4,%ecx
   2dd77:	rol    %cl,%r14d
   2dd7a:	rorx   $0x8,%eax,%ecx
   2dd80:	mov    %ecx,%edi
   2dd82:	and    $0xf,%edi
   2dd85:	mov    (%r8,%rdi,4),%r11d
   2dd89:	shr    $0x4,%ecx
   2dd8c:	rol    %cl,%r11d
   2dd8f:	rorx   $0x10,%eax,%ecx
   2dd95:	mov    %ecx,%edi
   2dd97:	and    $0xf,%edi
   2dd9a:	mov    (%r8,%rdi,4),%edi
   2dd9e:	shr    $0x4,%ecx
   2dda1:	rol    %cl,%edi
   2dda3:	mov    %rax,%rdx
   2dda6:	rorx   $0x18,%eax,%ecx
   2ddac:	mov    %ecx,%eax
   2ddae:	shr    $0x20,%rdx
   2ddb2:	and    $0xf,%eax
   2ddb5:	mov    (%r8,%rax,4),%r15d
   2ddb9:	mov    %edx,%eax
   2ddbb:	and    %edx,%r10d
   2ddbe:	shr    $0x4,%ecx
   2ddc1:	shr    $0x1e,%eax
   2ddc4:	rol    %cl,%r15d
   2ddc7:	xor    %r10d,%eax
   2ddca:	mov    (%rbx),%rcx
   2ddcd:	xor    $0xc,%eax
   2ddd0:	mov    (%rcx,%rax,4),%r12d
   2ddd4:	and    %r15d,%r12d
   2ddd7:	cmp    %r15d,%r12d
   2ddda:	mov    %r10d,%r15d
   2dddd:	mov    (%rcx,%r15,4),%r12d
   2dde1:	sete   %al
   2dde4:	and    %r14d,%r12d
   2dde7:	cmp    %r14d,%r12d
   2ddea:	sete   %r14b
   2ddee:	and    %r14d,%eax
   2ddf1:	mov    %edx,%r14d
   2ddf4:	shr    $0x1a,%r14d
   2ddf8:	and    $0x3,%r14d
   2ddfc:	xor    %r10d,%r14d
   2ddff:	xor    $0x4,%r14d
   2de03:	mov    (%rcx,%r14,4),%r15d
   2de07:	and    %r11d,%r15d
   2de0a:	cmp    %r11d,%r15d
   2de0d:	sete   %r11b
   2de11:	shr    $0x1c,%edx
   2de14:	and    $0x3,%edx
   2de17:	xor    %r10d,%edx
   2de1a:	xor    $0x8,%edx
   2de1d:	and    %r11d,%eax
   2de20:	mov    (%rcx,%rdx,4),%r11d
   2de24:	and    %edi,%r11d
   2de27:	cmp    %edi,%r11d
   2de2a:	sete   %dl
   2de2d:	movzbl %dl,%edx
   2de30:	and    %edx,%eax
   2de32:	mov    %eax,0x0(%r13,%rsi,4)
   2de37:	inc    %rsi
   2de3a:	cmp    %rsi,%rbp
   2de3d:	jne    2dd40 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::FourSectorBloomFilter, raw32_stage3::NativePolicy<bloom_filters::FourSectorBloomFilter, 8> > >(raw32_stage3::RawHash<bloom_filters::FourSectorBloomFilter, raw32_stage3::NativePolicy<bloom_filters::FourSectorBloomFilter, 8> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0xa0>
   2de43:	add    $0x18,%rsp
   2de47:	pop    %rbx
   2de48:	pop    %rbp
   2de49:	pop    %r12
   2de4b:	pop    %r13
   2de4d:	pop    %r14
   2de4f:	pop    %r15
   2de51:	ret
