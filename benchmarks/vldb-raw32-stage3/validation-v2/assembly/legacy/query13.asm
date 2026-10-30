
/home/yiming/projects/fastest-bf-lab/build/vldb-raw32-stage3-v1/native/legacy:     file format elf64-x86-64


Disassembly of section .text:

00000000004bced0 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 1u, 1u, 0u, 1u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned long, 1u, 1u, 0u, 1u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
  4bced0:	push   %r15
  4bced2:	push   %r14
  4bced4:	push   %r13
  4bced6:	push   %r12
  4bced8:	mov    %rcx,%r12
  4bcedb:	push   %rbp
  4bcedc:	mov    %rdx,%rbp
  4bcedf:	push   %rbx
  4bcee0:	mov    %rdi,%rbx
  4bcee3:	sub    $0x28,%rsp
  4bcee7:	mov    %r8,0x8(%rsp)
  4bceec:	test   %esi,%esi
  4bceee:	je     4bcf58 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 1u, 1u, 0u, 1u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned long, 1u, 1u, 0u, 1u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x88>
  4bcef0:	cmp    $0x1,%esi
  4bcef3:	mov    $0x1000,%r14d
  4bcef9:	mov    $0x1,%eax
  4bcefe:	cmove  %rax,%r14
  4bcf02:	test   %rdx,%rdx
  4bcf05:	je     4bcf44 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 1u, 1u, 0u, 1u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned long, 1u, 1u, 0u, 1u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x74>
  4bcf07:	mov    %rdx,%r13
  4bcf0a:	xor    %r15d,%r15d
  4bcf0d:	nopl   (%rax)
  4bcf10:	mov    0x8(%rsp),%rax
  4bcf15:	lea    0x0(,%r15,4),%rdx
  4bcf1d:	lea    (%rax,%rdx,1),%rcx
  4bcf21:	add    %r12,%rdx
  4bcf24:	mov    %r14,%rax
  4bcf27:	cmp    %r14,%r13
  4bcf2a:	cmovbe %r13,%rax
  4bcf2e:	mov    %rbx,%rdi
  4bcf31:	mov    %rax,%rsi
  4bcf34:	add    %r14,%r15
  4bcf37:	call   4bce10 <void vldb_stage2::DenseCall<raw32_stage3::RawOriginal<unsigned long, 1u, 1u, 0u, 1u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned long, 1u, 1u, 0u, 1u, (dtl::block_addressing)2> const&, unsigned int, unsigned int const*, unsigned int*)>
  4bcf3c:	sub    %r14,%r13
  4bcf3f:	cmp    %rbp,%r15
  4bcf42:	jb     4bcf10 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 1u, 1u, 0u, 1u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned long, 1u, 1u, 0u, 1u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x40>
  4bcf44:	add    $0x28,%rsp
  4bcf48:	pop    %rbx
  4bcf49:	pop    %rbp
  4bcf4a:	pop    %r12
  4bcf4c:	pop    %r13
  4bcf4e:	pop    %r14
  4bcf50:	pop    %r15
  4bcf52:	ret
  4bcf53:	nopl   0x0(%rax,%rax,1)
  4bcf58:	xor    %r14d,%r14d
  4bcf5b:	lea    0x14(%rsp),%r15
  4bcf60:	test   %rdx,%rdx
  4bcf63:	je     4bcf44 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 1u, 1u, 0u, 1u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned long, 1u, 1u, 0u, 1u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x74>
  4bcf65:	nopl   (%rax)
  4bcf68:	mov    (%r12,%r14,4),%eax
  4bcf6c:	mov    0xc0(%rbx),%rdx
  4bcf73:	cmpq   $0x0,0x90(%rbx)
  4bcf7b:	mov    %rdx,0x18(%rsp)
  4bcf80:	mov    %eax,0x14(%rsp)
  4bcf84:	je     4bcfbe <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 1u, 1u, 0u, 1u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned long, 1u, 1u, 0u, 1u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0xee>
  4bcf86:	lea    0x80(%rbx),%rdi
  4bcf8d:	lea    0x18(%rsp),%rsi
  4bcf92:	mov    %r15,%rdx
  4bcf95:	call   *0x98(%rbx)
  4bcf9b:	mov    0x8(%rsp),%rdi
  4bcfa0:	movzbl %al,%eax
  4bcfa3:	mov    %eax,(%rdi,%r14,4)
  4bcfa7:	inc    %r14
  4bcfaa:	cmp    %r14,%rbp
  4bcfad:	jne    4bcf68 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 1u, 1u, 0u, 1u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned long, 1u, 1u, 0u, 1u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x98>
  4bcfaf:	add    $0x28,%rsp
  4bcfb3:	pop    %rbx
  4bcfb4:	pop    %rbp
  4bcfb5:	pop    %r12
  4bcfb7:	pop    %r13
  4bcfb9:	pop    %r14
  4bcfbb:	pop    %r15
  4bcfbd:	ret
  4bcfbe:	call   1948ca0 <std::__throw_bad_function_call()@plt>
