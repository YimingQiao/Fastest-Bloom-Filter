
/home/yiming/projects/fastest-bf-lab/build/vldb-raw32-stage3-v2/native/modern:     file format elf64-x86-64


Disassembly of section .text:

000000000002db30 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > >(raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
   2db30:	push   %r15
   2db32:	push   %r14
   2db34:	push   %r13
   2db36:	mov    %rdi,%r13
   2db39:	push   %r12
   2db3b:	mov    %r8,%r12
   2db3e:	push   %rbp
   2db3f:	push   %rbx
   2db40:	mov    %rdx,%rbx
   2db43:	sub    $0x18,%rsp
   2db47:	mov    %rcx,0x8(%rsp)
   2db4c:	test   %esi,%esi
   2db4e:	je     2dbb8 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > >(raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x88>
   2db50:	cmp    $0x1,%esi
   2db53:	mov    $0x1000,%r14d
   2db59:	mov    $0x1,%eax
   2db5e:	cmove  %rax,%r14
   2db62:	test   %rdx,%rdx
   2db65:	je     2dba4 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > >(raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x74>
   2db67:	mov    %rdx,%rbp
   2db6a:	xor    %r15d,%r15d
   2db6d:	nopl   (%rax)
   2db70:	mov    0x8(%rsp),%rax
   2db75:	lea    0x0(,%r15,4),%rdx
   2db7d:	lea    (%r12,%rdx,1),%rcx
   2db81:	add    %rax,%rdx
   2db84:	cmp    %r14,%rbp
   2db87:	mov    %r14,%rax
   2db8a:	cmovbe %rbp,%rax
   2db8e:	mov    %r13,%rdi
   2db91:	mov    %rax,%rsi
   2db94:	add    %r14,%r15
   2db97:	call   2ca90 <void vldb_stage2::DenseCall<raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > >(raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > const&, unsigned int, unsigned int const*, unsigned int*)>
   2db9c:	sub    %r14,%rbp
   2db9f:	cmp    %rbx,%r15
   2dba2:	jb     2db70 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > >(raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x40>
   2dba4:	add    $0x18,%rsp
   2dba8:	pop    %rbx
   2dba9:	pop    %rbp
   2dbaa:	pop    %r12
   2dbac:	pop    %r13
   2dbae:	pop    %r14
   2dbb0:	pop    %r15
   2dbb2:	ret
   2dbb3:	nopl   0x0(%rax,%rax,1)
   2dbb8:	xor    %edx,%edx
   2dbba:	movabs $0xd6e8feb86659fd93,%rsi
   2dbc4:	test   %rbx,%rbx
   2dbc7:	je     2dba4 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > >(raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x74>
   2dbc9:	nopl   0x0(%rax)
   2dbd0:	mov    0x8(%rsp),%rax
   2dbd5:	mov    0x0(%r13),%r10
   2dbd9:	mov    (%rax,%rdx,4),%eax
   2dbdc:	imul   %rsi,%rax
   2dbe0:	mov    %rax,%rcx
   2dbe3:	shr    $0x20,%rcx
   2dbe7:	xor    %rcx,%rax
   2dbea:	imul   %rsi,%rax
   2dbee:	mov    %rax,%rcx
   2dbf1:	shr    $0x20,%rcx
   2dbf5:	xor    %rcx,%rax
   2dbf8:	mov    %rax,%r8
   2dbfb:	and    $0x1f,%r8d
   2dbff:	mov    (%r10,%r8,4),%r8d
   2dc03:	mov    %eax,%ecx
   2dc05:	shr    $0x5,%ecx
   2dc08:	rol    %cl,%r8d
   2dc0b:	mov    %eax,%ecx
   2dc0d:	shr    $0xa,%ecx
   2dc10:	mov    %ecx,%r9d
   2dc13:	and    $0x1f,%r9d
   2dc17:	mov    (%r10,%r9,4),%r9d
   2dc1b:	mov    %rax,%rdi
   2dc1e:	mov    %eax,%ecx
   2dc20:	shr    $0x14,%eax
   2dc23:	shr    $0xf,%ecx
   2dc26:	shr    $0x20,%rdi
   2dc2a:	and    $0x7,%eax
   2dc2d:	and    0x8(%r13),%edi
   2dc31:	rol    %cl,%r9d
   2dc34:	add    $0x8,%eax
   2dc37:	mov    0x10(%r13),%rcx
   2dc3b:	xor    %edi,%eax
   2dc3d:	mov    (%rcx,%rax,4),%r11d
   2dc41:	mov    (%rcx,%rdi,4),%eax
   2dc44:	and    %r9d,%r11d
   2dc47:	cmp    %r9d,%r11d
   2dc4a:	sete   %r9b
   2dc4e:	and    %r8d,%eax
   2dc51:	cmp    %r8d,%eax
   2dc54:	sete   %al
   2dc57:	movzbl %al,%eax
   2dc5a:	and    %r9d,%eax
   2dc5d:	mov    %eax,(%r12,%rdx,4)
   2dc61:	inc    %rdx
   2dc64:	cmp    %rdx,%rbx
   2dc67:	jne    2dbd0 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > >(raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0xa0>
   2dc6d:	add    $0x18,%rsp
   2dc71:	pop    %rbx
   2dc72:	pop    %rbp
   2dc73:	pop    %r12
   2dc75:	pop    %r13
   2dc77:	pop    %r14
   2dc79:	pop    %r15
   2dc7b:	ret
