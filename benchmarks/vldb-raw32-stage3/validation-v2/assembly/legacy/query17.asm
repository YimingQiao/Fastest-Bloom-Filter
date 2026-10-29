
/home/yiming/projects/fastest-bf-lab/build/vldb-raw32-stage3-v1/native/legacy:     file format elf64-x86-64


Disassembly of section .text:

00000000004bc960 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 1u, 1u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 1u, 1u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
  4bc960:	push   %r15
  4bc962:	push   %r14
  4bc964:	push   %r13
  4bc966:	push   %r12
  4bc968:	mov    %rcx,%r12
  4bc96b:	push   %rbp
  4bc96c:	mov    %rdx,%rbp
  4bc96f:	push   %rbx
  4bc970:	mov    %rdi,%rbx
  4bc973:	sub    $0x28,%rsp
  4bc977:	mov    %r8,0x8(%rsp)
  4bc97c:	test   %esi,%esi
  4bc97e:	je     4bc9e8 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 1u, 1u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 1u, 1u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x88>
  4bc980:	cmp    $0x1,%esi
  4bc983:	mov    $0x1000,%r14d
  4bc989:	mov    $0x1,%eax
  4bc98e:	cmove  %rax,%r14
  4bc992:	test   %rdx,%rdx
  4bc995:	je     4bc9d4 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 1u, 1u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 1u, 1u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x74>
  4bc997:	mov    %rdx,%r13
  4bc99a:	xor    %r15d,%r15d
  4bc99d:	nopl   (%rax)
  4bc9a0:	mov    0x8(%rsp),%rax
  4bc9a5:	lea    0x0(,%r15,4),%rdx
  4bc9ad:	lea    (%rax,%rdx,1),%rcx
  4bc9b1:	add    %r12,%rdx
  4bc9b4:	mov    %r14,%rax
  4bc9b7:	cmp    %r14,%r13
  4bc9ba:	cmovbe %r13,%rax
  4bc9be:	mov    %rbx,%rdi
  4bc9c1:	mov    %rax,%rsi
  4bc9c4:	add    %r14,%r15
  4bc9c7:	call   4bc8a0 <void vldb_stage2::DenseCall<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 1u, 1u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 1u, 1u, (dtl::block_addressing)2> const&, unsigned int, unsigned int const*, unsigned int*)>
  4bc9cc:	sub    %r14,%r13
  4bc9cf:	cmp    %rbp,%r15
  4bc9d2:	jb     4bc9a0 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 1u, 1u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 1u, 1u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x40>
  4bc9d4:	add    $0x28,%rsp
  4bc9d8:	pop    %rbx
  4bc9d9:	pop    %rbp
  4bc9da:	pop    %r12
  4bc9dc:	pop    %r13
  4bc9de:	pop    %r14
  4bc9e0:	pop    %r15
  4bc9e2:	ret
  4bc9e3:	nopl   0x0(%rax,%rax,1)
  4bc9e8:	xor    %r14d,%r14d
  4bc9eb:	lea    0x14(%rsp),%r15
  4bc9f0:	test   %rdx,%rdx
  4bc9f3:	je     4bc9d4 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 1u, 1u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 1u, 1u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x74>
  4bc9f5:	nopl   (%rax)
  4bc9f8:	mov    (%r12,%r14,4),%eax
  4bc9fc:	mov    0xc0(%rbx),%rdx
  4bca03:	cmpq   $0x0,0x90(%rbx)
  4bca0b:	mov    %rdx,0x18(%rsp)
  4bca10:	mov    %eax,0x14(%rsp)
  4bca14:	je     4bca4e <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 1u, 1u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 1u, 1u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0xee>
  4bca16:	lea    0x80(%rbx),%rdi
  4bca1d:	lea    0x18(%rsp),%rsi
  4bca22:	mov    %r15,%rdx
  4bca25:	call   *0x98(%rbx)
  4bca2b:	mov    0x8(%rsp),%rdi
  4bca30:	movzbl %al,%eax
  4bca33:	mov    %eax,(%rdi,%r14,4)
  4bca37:	inc    %r14
  4bca3a:	cmp    %r14,%rbp
  4bca3d:	jne    4bc9f8 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 1u, 1u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 1u, 1u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x98>
  4bca3f:	add    $0x28,%rsp
  4bca43:	pop    %rbx
  4bca44:	pop    %rbp
  4bca45:	pop    %r12
  4bca47:	pop    %r13
  4bca49:	pop    %r14
  4bca4b:	pop    %r15
  4bca4d:	ret
  4bca4e:	call   1948ca0 <std::__throw_bad_function_call()@plt>
