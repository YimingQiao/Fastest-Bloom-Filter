
/home/yiming/projects/fastest-bf-lab/build/page-pointer-preflight-v1/native/worker/page_pointer_control:     file format elf64-x86-64


Disassembly of section .text:

00000000000229d0 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::FourSectorBloomFilter, raw32_stage3::NativePolicy<bloom_filters::FourSectorBloomFilter, 8> > >(raw32_stage3::RawHash<bloom_filters::FourSectorBloomFilter, raw32_stage3::NativePolicy<bloom_filters::FourSectorBloomFilter, 8> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
   229d0:	push   %r15
   229d2:	push   %r14
   229d4:	push   %r13
   229d6:	mov    %r8,%r13
   229d9:	push   %r12
   229db:	push   %rbp
   229dc:	mov    %rdx,%rbp
   229df:	push   %rbx
   229e0:	mov    %rdi,%rbx
   229e3:	sub    $0x18,%rsp
   229e7:	mov    %rcx,0x8(%rsp)
   229ec:	test   %esi,%esi
   229ee:	je     22a54 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::FourSectorBloomFilter, raw32_stage3::NativePolicy<bloom_filters::FourSectorBloomFilter, 8> > >(raw32_stage3::RawHash<bloom_filters::FourSectorBloomFilter, raw32_stage3::NativePolicy<bloom_filters::FourSectorBloomFilter, 8> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x84>
   229f0:	cmp    $0x1,%esi
   229f3:	mov    $0x1000,%r14d
   229f9:	mov    $0x1,%eax
   229fe:	cmove  %rax,%r14
   22a02:	test   %rdx,%rdx
   22a05:	je     22a45 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::FourSectorBloomFilter, raw32_stage3::NativePolicy<bloom_filters::FourSectorBloomFilter, 8> > >(raw32_stage3::RawHash<bloom_filters::FourSectorBloomFilter, raw32_stage3::NativePolicy<bloom_filters::FourSectorBloomFilter, 8> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x75>
   22a07:	mov    %rdx,%r12
   22a0a:	xor    %r15d,%r15d
   22a0d:	nopl   (%rax)
   22a10:	mov    0x8(%rsp),%rax
   22a15:	lea    0x0(,%r15,4),%rdx
   22a1d:	lea    0x0(%r13,%rdx,1),%rcx
   22a22:	add    %rax,%rdx
   22a25:	cmp    %r14,%r12
   22a28:	mov    %r14,%rax
   22a2b:	cmovbe %r12,%rax
   22a2f:	mov    %rbx,%rdi
   22a32:	mov    %rax,%rsi
   22a35:	add    %r14,%r15
   22a38:	call   229c0 <void vldb_stage2::DenseCall<raw32_stage3::RawHash<bloom_filters::FourSectorBloomFilter, raw32_stage3::NativePolicy<bloom_filters::FourSectorBloomFilter, 8> > >(raw32_stage3::RawHash<bloom_filters::FourSectorBloomFilter, raw32_stage3::NativePolicy<bloom_filters::FourSectorBloomFilter, 8> > const&, unsigned int, unsigned int const*, unsigned int*)>
   22a3d:	sub    %r14,%r12
   22a40:	cmp    %rbp,%r15
   22a43:	jb     22a10 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::FourSectorBloomFilter, raw32_stage3::NativePolicy<bloom_filters::FourSectorBloomFilter, 8> > >(raw32_stage3::RawHash<bloom_filters::FourSectorBloomFilter, raw32_stage3::NativePolicy<bloom_filters::FourSectorBloomFilter, 8> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x40>
   22a45:	add    $0x18,%rsp
   22a49:	pop    %rbx
   22a4a:	pop    %rbp
   22a4b:	pop    %r12
   22a4d:	pop    %r13
   22a4f:	pop    %r14
   22a51:	pop    %r15
   22a53:	ret
   22a54:	xor    %esi,%esi
   22a56:	lea    -0x1e83d(%rip),%r8        # 4220 <bloom_filters::FourSectorBloomFilter::patterns2>
   22a5d:	movabs $0xd6e8feb86659fd93,%r9
   22a67:	test   %rdx,%rdx
   22a6a:	je     22a45 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::FourSectorBloomFilter, raw32_stage3::NativePolicy<bloom_filters::FourSectorBloomFilter, 8> > >(raw32_stage3::RawHash<bloom_filters::FourSectorBloomFilter, raw32_stage3::NativePolicy<bloom_filters::FourSectorBloomFilter, 8> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x75>
   22a6c:	nopl   0x0(%rax)
   22a70:	mov    0x8(%rsp),%rax
   22a75:	mov    0x18(%rbx),%r10d
   22a79:	mov    (%rax,%rsi,4),%eax
   22a7c:	imul   %r9,%rax
   22a80:	mov    %rax,%rdx
   22a83:	shr    $0x20,%rdx
   22a87:	xor    %rdx,%rax
   22a8a:	imul   %r9,%rax
   22a8e:	mov    %rax,%rdx
   22a91:	shr    $0x20,%rdx
   22a95:	xor    %rdx,%rax
   22a98:	mov    %rax,%rdi
   22a9b:	and    $0xf,%edi
   22a9e:	mov    (%r8,%rdi,4),%r14d
   22aa2:	mov    %eax,%ecx
   22aa4:	shr    $0x4,%ecx
   22aa7:	rol    %cl,%r14d
   22aaa:	rorx   $0x8,%eax,%ecx
   22ab0:	mov    %ecx,%edi
   22ab2:	and    $0xf,%edi
   22ab5:	mov    (%r8,%rdi,4),%r11d
   22ab9:	shr    $0x4,%ecx
   22abc:	rol    %cl,%r11d
   22abf:	rorx   $0x10,%eax,%ecx
   22ac5:	mov    %ecx,%edi
   22ac7:	and    $0xf,%edi
   22aca:	mov    (%r8,%rdi,4),%edi
   22ace:	shr    $0x4,%ecx
   22ad1:	rol    %cl,%edi
   22ad3:	mov    %rax,%rdx
   22ad6:	rorx   $0x18,%eax,%ecx
   22adc:	mov    %ecx,%eax
   22ade:	shr    $0x20,%rdx
   22ae2:	and    $0xf,%eax
   22ae5:	mov    (%r8,%rax,4),%r15d
   22ae9:	mov    %edx,%eax
   22aeb:	and    %edx,%r10d
   22aee:	shr    $0x4,%ecx
   22af1:	shr    $0x1e,%eax
   22af4:	rol    %cl,%r15d
   22af7:	xor    %r10d,%eax
   22afa:	mov    (%rbx),%rcx
   22afd:	xor    $0xc,%eax
   22b00:	mov    (%rcx,%rax,4),%r12d
   22b04:	and    %r15d,%r12d
   22b07:	cmp    %r15d,%r12d
   22b0a:	mov    %r10d,%r15d
   22b0d:	mov    (%rcx,%r15,4),%r12d
   22b11:	sete   %al
   22b14:	and    %r14d,%r12d
   22b17:	cmp    %r14d,%r12d
   22b1a:	sete   %r14b
   22b1e:	and    %r14d,%eax
   22b21:	mov    %edx,%r14d
   22b24:	shr    $0x1a,%r14d
   22b28:	and    $0x3,%r14d
   22b2c:	xor    %r10d,%r14d
   22b2f:	xor    $0x4,%r14d
   22b33:	mov    (%rcx,%r14,4),%r15d
   22b37:	and    %r11d,%r15d
   22b3a:	cmp    %r11d,%r15d
   22b3d:	sete   %r11b
   22b41:	shr    $0x1c,%edx
   22b44:	and    $0x3,%edx
   22b47:	xor    %r10d,%edx
   22b4a:	xor    $0x8,%edx
   22b4d:	and    %r11d,%eax
   22b50:	mov    (%rcx,%rdx,4),%r11d
   22b54:	and    %edi,%r11d
   22b57:	cmp    %edi,%r11d
   22b5a:	sete   %dl
   22b5d:	movzbl %dl,%edx
   22b60:	and    %edx,%eax
   22b62:	mov    %eax,0x0(%r13,%rsi,4)
   22b67:	inc    %rsi
   22b6a:	cmp    %rsi,%rbp
   22b6d:	jne    22a70 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::FourSectorBloomFilter, raw32_stage3::NativePolicy<bloom_filters::FourSectorBloomFilter, 8> > >(raw32_stage3::RawHash<bloom_filters::FourSectorBloomFilter, raw32_stage3::NativePolicy<bloom_filters::FourSectorBloomFilter, 8> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0xa0>
   22b73:	add    $0x18,%rsp
   22b77:	pop    %rbx
   22b78:	pop    %rbp
   22b79:	pop    %r12
   22b7b:	pop    %r13
   22b7d:	pop    %r14
   22b7f:	pop    %r15
   22b81:	ret
