
/home/yiming/projects/fastest-bf-lab/build/vldb-raw32-stage3-v1/native/legacy:     file format elf64-x86-64


Disassembly of section .text:

00000000004b9ea0 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 1u, 1u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 1u, 1u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
  4b9ea0:	push   %r15
  4b9ea2:	push   %r14
  4b9ea4:	push   %r13
  4b9ea6:	push   %r12
  4b9ea8:	mov    %rcx,%r12
  4b9eab:	push   %rbp
  4b9eac:	mov    %rdx,%rbp
  4b9eaf:	push   %rbx
  4b9eb0:	mov    %rdi,%rbx
  4b9eb3:	sub    $0x28,%rsp
  4b9eb7:	mov    %r8,0x8(%rsp)
  4b9ebc:	test   %esi,%esi
  4b9ebe:	je     4b9f28 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 1u, 1u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 1u, 1u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x88>
  4b9ec0:	cmp    $0x1,%esi
  4b9ec3:	mov    $0x1000,%r14d
  4b9ec9:	mov    $0x1,%eax
  4b9ece:	cmove  %rax,%r14
  4b9ed2:	test   %rdx,%rdx
  4b9ed5:	je     4b9f14 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 1u, 1u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 1u, 1u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x74>
  4b9ed7:	mov    %rdx,%r13
  4b9eda:	xor    %r15d,%r15d
  4b9edd:	nopl   (%rax)
  4b9ee0:	mov    0x8(%rsp),%rax
  4b9ee5:	lea    0x0(,%r15,4),%rdx
  4b9eed:	lea    (%rax,%rdx,1),%rcx
  4b9ef1:	add    %r12,%rdx
  4b9ef4:	mov    %r14,%rax
  4b9ef7:	cmp    %r14,%r13
  4b9efa:	cmovbe %r13,%rax
  4b9efe:	mov    %rbx,%rdi
  4b9f01:	mov    %rax,%rsi
  4b9f04:	add    %r14,%r15
  4b9f07:	call   4b9de0 <void vldb_stage2::DenseCall<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 1u, 1u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 1u, 1u, (dtl::block_addressing)2> const&, unsigned int, unsigned int const*, unsigned int*)>
  4b9f0c:	sub    %r14,%r13
  4b9f0f:	cmp    %rbp,%r15
  4b9f12:	jb     4b9ee0 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 1u, 1u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 1u, 1u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x40>
  4b9f14:	add    $0x28,%rsp
  4b9f18:	pop    %rbx
  4b9f19:	pop    %rbp
  4b9f1a:	pop    %r12
  4b9f1c:	pop    %r13
  4b9f1e:	pop    %r14
  4b9f20:	pop    %r15
  4b9f22:	ret
  4b9f23:	nopl   0x0(%rax,%rax,1)
  4b9f28:	xor    %r14d,%r14d
  4b9f2b:	lea    0x14(%rsp),%r15
  4b9f30:	test   %rdx,%rdx
  4b9f33:	je     4b9f14 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 1u, 1u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 1u, 1u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x74>
  4b9f35:	nopl   (%rax)
  4b9f38:	mov    (%r12,%r14,4),%eax
  4b9f3c:	mov    0xc0(%rbx),%rdx
  4b9f43:	cmpq   $0x0,0x90(%rbx)
  4b9f4b:	mov    %rdx,0x18(%rsp)
  4b9f50:	mov    %eax,0x14(%rsp)
  4b9f54:	je     4b9f8e <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 1u, 1u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 1u, 1u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0xee>
  4b9f56:	lea    0x80(%rbx),%rdi
  4b9f5d:	lea    0x18(%rsp),%rsi
  4b9f62:	mov    %r15,%rdx
  4b9f65:	call   *0x98(%rbx)
  4b9f6b:	mov    0x8(%rsp),%rdi
  4b9f70:	movzbl %al,%eax
  4b9f73:	mov    %eax,(%rdi,%r14,4)
  4b9f77:	inc    %r14
  4b9f7a:	cmp    %r14,%rbp
  4b9f7d:	jne    4b9f38 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 1u, 1u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 1u, 1u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x98>
  4b9f7f:	add    $0x28,%rsp
  4b9f83:	pop    %rbx
  4b9f84:	pop    %rbp
  4b9f85:	pop    %r12
  4b9f87:	pop    %r13
  4b9f89:	pop    %r14
  4b9f8b:	pop    %r15
  4b9f8d:	ret
  4b9f8e:	call   1948ca0 <std::__throw_bad_function_call()@plt>
