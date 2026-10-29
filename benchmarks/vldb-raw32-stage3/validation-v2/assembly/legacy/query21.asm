
/home/yiming/projects/fastest-bf-lab/build/vldb-raw32-stage3-v1/native/legacy:     file format elf64-x86-64


Disassembly of section .text:

00000000004bcb30 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 2u, 1u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 2u, 1u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
  4bcb30:	push   %r15
  4bcb32:	push   %r14
  4bcb34:	push   %r13
  4bcb36:	push   %r12
  4bcb38:	mov    %rcx,%r12
  4bcb3b:	push   %rbp
  4bcb3c:	mov    %rdx,%rbp
  4bcb3f:	push   %rbx
  4bcb40:	mov    %rdi,%rbx
  4bcb43:	sub    $0x28,%rsp
  4bcb47:	mov    %r8,0x8(%rsp)
  4bcb4c:	test   %esi,%esi
  4bcb4e:	je     4bcbb8 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 2u, 1u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 2u, 1u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x88>
  4bcb50:	cmp    $0x1,%esi
  4bcb53:	mov    $0x1000,%r14d
  4bcb59:	mov    $0x1,%eax
  4bcb5e:	cmove  %rax,%r14
  4bcb62:	test   %rdx,%rdx
  4bcb65:	je     4bcba4 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 2u, 1u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 2u, 1u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x74>
  4bcb67:	mov    %rdx,%r13
  4bcb6a:	xor    %r15d,%r15d
  4bcb6d:	nopl   (%rax)
  4bcb70:	mov    0x8(%rsp),%rax
  4bcb75:	lea    0x0(,%r15,4),%rdx
  4bcb7d:	lea    (%rax,%rdx,1),%rcx
  4bcb81:	add    %r12,%rdx
  4bcb84:	mov    %r14,%rax
  4bcb87:	cmp    %r14,%r13
  4bcb8a:	cmovbe %r13,%rax
  4bcb8e:	mov    %rbx,%rdi
  4bcb91:	mov    %rax,%rsi
  4bcb94:	add    %r14,%r15
  4bcb97:	call   4bca70 <void vldb_stage2::DenseCall<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 2u, 1u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 2u, 1u, (dtl::block_addressing)2> const&, unsigned int, unsigned int const*, unsigned int*)>
  4bcb9c:	sub    %r14,%r13
  4bcb9f:	cmp    %rbp,%r15
  4bcba2:	jb     4bcb70 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 2u, 1u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 2u, 1u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x40>
  4bcba4:	add    $0x28,%rsp
  4bcba8:	pop    %rbx
  4bcba9:	pop    %rbp
  4bcbaa:	pop    %r12
  4bcbac:	pop    %r13
  4bcbae:	pop    %r14
  4bcbb0:	pop    %r15
  4bcbb2:	ret
  4bcbb3:	nopl   0x0(%rax,%rax,1)
  4bcbb8:	xor    %r14d,%r14d
  4bcbbb:	lea    0x14(%rsp),%r15
  4bcbc0:	test   %rdx,%rdx
  4bcbc3:	je     4bcba4 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 2u, 1u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 2u, 1u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x74>
  4bcbc5:	nopl   (%rax)
  4bcbc8:	mov    (%r12,%r14,4),%eax
  4bcbcc:	mov    0xc0(%rbx),%rdx
  4bcbd3:	cmpq   $0x0,0x90(%rbx)
  4bcbdb:	mov    %rdx,0x18(%rsp)
  4bcbe0:	mov    %eax,0x14(%rsp)
  4bcbe4:	je     4bcc1e <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 2u, 1u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 2u, 1u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0xee>
  4bcbe6:	lea    0x80(%rbx),%rdi
  4bcbed:	lea    0x18(%rsp),%rsi
  4bcbf2:	mov    %r15,%rdx
  4bcbf5:	call   *0x98(%rbx)
  4bcbfb:	mov    0x8(%rsp),%rdi
  4bcc00:	movzbl %al,%eax
  4bcc03:	mov    %eax,(%rdi,%r14,4)
  4bcc07:	inc    %r14
  4bcc0a:	cmp    %r14,%rbp
  4bcc0d:	jne    4bcbc8 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 2u, 1u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 2u, 1u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x98>
  4bcc0f:	add    $0x28,%rsp
  4bcc13:	pop    %rbx
  4bcc14:	pop    %rbp
  4bcc15:	pop    %r12
  4bcc17:	pop    %r13
  4bcc19:	pop    %r14
  4bcc1b:	pop    %r15
  4bcc1d:	ret
  4bcc1e:	call   1948ca0 <std::__throw_bad_function_call()@plt>
