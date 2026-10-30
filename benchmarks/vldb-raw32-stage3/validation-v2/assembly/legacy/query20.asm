
/home/yiming/projects/fastest-bf-lab/build/vldb-raw32-stage3-v1/native/legacy:     file format elf64-x86-64


Disassembly of section .text:

0000000000690e10 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 2u, 0u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 2u, 0u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
  690e10:	push   %r15
  690e12:	push   %r14
  690e14:	push   %r13
  690e16:	push   %r12
  690e18:	mov    %rcx,%r12
  690e1b:	push   %rbp
  690e1c:	mov    %rdi,%rbp
  690e1f:	push   %rbx
  690e20:	mov    %rdx,%rbx
  690e23:	sub    $0x18,%rsp
  690e27:	mov    %r8,0x8(%rsp)
  690e2c:	test   %esi,%esi
  690e2e:	je     690e98 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 2u, 0u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 2u, 0u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x88>
  690e30:	cmp    $0x1,%esi
  690e33:	mov    $0x1000,%r14d
  690e39:	mov    $0x1,%eax
  690e3e:	cmove  %rax,%r14
  690e42:	test   %rdx,%rdx
  690e45:	je     690e84 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 2u, 0u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 2u, 0u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x74>
  690e47:	mov    %rdx,%r13
  690e4a:	xor    %r15d,%r15d
  690e4d:	nopl   (%rax)
  690e50:	mov    0x8(%rsp),%rax
  690e55:	lea    0x0(,%r15,4),%rdx
  690e5d:	lea    (%rax,%rdx,1),%rcx
  690e61:	add    %r12,%rdx
  690e64:	mov    %r14,%rax
  690e67:	cmp    %r14,%r13
  690e6a:	cmovbe %r13,%rax
  690e6e:	mov    %rbp,%rdi
  690e71:	mov    %rax,%rsi
  690e74:	add    %r14,%r15
  690e77:	call   690d90 <void vldb_stage2::DenseCall<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 2u, 0u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 2u, 0u, (dtl::block_addressing)2> const&, unsigned int, unsigned int const*, unsigned int*)>
  690e7c:	sub    %r14,%r13
  690e7f:	cmp    %rbx,%r15
  690e82:	jb     690e50 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 2u, 0u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 2u, 0u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x40>
  690e84:	add    $0x18,%rsp
  690e88:	pop    %rbx
  690e89:	pop    %rbp
  690e8a:	pop    %r12
  690e8c:	pop    %r13
  690e8e:	pop    %r14
  690e90:	pop    %r15
  690e92:	ret
  690e93:	nopl   0x0(%rax,%rax,1)
  690e98:	lea    0x8(%rdi),%r15
  690e9c:	xor    %r14d,%r14d
  690e9f:	test   %rdx,%rdx
  690ea2:	je     690e84 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 2u, 0u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 2u, 0u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x74>
  690ea4:	nopl   0x0(%rax)
  690ea8:	mov    (%r12,%r14,4),%edx
  690eac:	mov    0x18(%rbp),%rsi
  690eb0:	mov    %r15,%rdi
  690eb3:	call   69c930 <dtl::bbf_64::contains(unsigned long const*, unsigned int) const>
  690eb8:	mov    0x8(%rsp),%rdi
  690ebd:	movzbl %al,%eax
  690ec0:	mov    %eax,(%rdi,%r14,4)
  690ec4:	inc    %r14
  690ec7:	cmp    %r14,%rbx
  690eca:	jne    690ea8 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 2u, 0u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 2u, 0u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x98>
  690ecc:	add    $0x18,%rsp
  690ed0:	pop    %rbx
  690ed1:	pop    %rbp
  690ed2:	pop    %r12
  690ed4:	pop    %r13
  690ed6:	pop    %r14
  690ed8:	pop    %r15
  690eda:	ret
