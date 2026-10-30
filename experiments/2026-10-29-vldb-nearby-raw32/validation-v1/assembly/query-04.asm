
/home/yiming/projects/fastest-bf-lab/build/vldb-nearby-raw32-v1/native/nearby_raw32:     file format elf64-x86-64


Disassembly of section .text:

0000000000390c10 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned int, 8u, 4u, false> >(nearby_raw32::PublicFilter<unsigned int, 8u, 4u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
  390c10:	push   %r15
  390c12:	push   %r14
  390c14:	push   %r13
  390c16:	push   %r12
  390c18:	mov    %rcx,%r12
  390c1b:	push   %rbp
  390c1c:	mov    %rdi,%rbp
  390c1f:	push   %rbx
  390c20:	mov    %rdx,%rbx
  390c23:	sub    $0x18,%rsp
  390c27:	mov    %r8,0x8(%rsp)
  390c2c:	test   %esi,%esi
  390c2e:	je     390c98 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned int, 8u, 4u, false> >(nearby_raw32::PublicFilter<unsigned int, 8u, 4u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x88>
  390c30:	cmp    $0x1,%esi
  390c33:	mov    $0x1000,%r14d
  390c39:	mov    $0x1,%eax
  390c3e:	cmove  %rax,%r14
  390c42:	test   %rdx,%rdx
  390c45:	je     390c84 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned int, 8u, 4u, false> >(nearby_raw32::PublicFilter<unsigned int, 8u, 4u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x74>
  390c47:	mov    %rdx,%r13
  390c4a:	xor    %r15d,%r15d
  390c4d:	nopl   (%rax)
  390c50:	mov    0x8(%rsp),%rax
  390c55:	lea    0x0(,%r15,4),%rdx
  390c5d:	lea    (%rax,%rdx,1),%rcx
  390c61:	add    %r12,%rdx
  390c64:	mov    %r14,%rax
  390c67:	cmp    %r14,%r13
  390c6a:	cmovbe %r13,%rax
  390c6e:	mov    %rbp,%rdi
  390c71:	mov    %rax,%rsi
  390c74:	add    %r14,%r15
  390c77:	call   390b90 <void vldb_stage2::DenseCall<nearby_raw32::PublicFilter<unsigned int, 8u, 4u, false> >(nearby_raw32::PublicFilter<unsigned int, 8u, 4u, false> const&, unsigned int, unsigned int const*, unsigned int*)>
  390c7c:	sub    %r14,%r13
  390c7f:	cmp    %rbx,%r15
  390c82:	jb     390c50 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned int, 8u, 4u, false> >(nearby_raw32::PublicFilter<unsigned int, 8u, 4u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x40>
  390c84:	add    $0x18,%rsp
  390c88:	pop    %rbx
  390c89:	pop    %rbp
  390c8a:	pop    %r12
  390c8c:	pop    %r13
  390c8e:	pop    %r14
  390c90:	pop    %r15
  390c92:	ret
  390c93:	nopl   0x0(%rax,%rax,1)
  390c98:	lea    0x8(%rdi),%r15
  390c9c:	xor    %r14d,%r14d
  390c9f:	test   %rdx,%rdx
  390ca2:	je     390c84 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned int, 8u, 4u, false> >(nearby_raw32::PublicFilter<unsigned int, 8u, 4u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x74>
  390ca4:	nopl   0x0(%rax)
  390ca8:	mov    (%r12,%r14,4),%edx
  390cac:	mov    0x18(%rbp),%rsi
  390cb0:	mov    %r15,%rdi
  390cb3:	call   39c1d0 <dtl::bbf_32::contains(unsigned long const*, unsigned int) const>
  390cb8:	mov    0x8(%rsp),%rdi
  390cbd:	movzbl %al,%eax
  390cc0:	mov    %eax,(%rdi,%r14,4)
  390cc4:	inc    %r14
  390cc7:	cmp    %r14,%rbx
  390cca:	jne    390ca8 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned int, 8u, 4u, false> >(nearby_raw32::PublicFilter<unsigned int, 8u, 4u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x98>
  390ccc:	add    $0x18,%rsp
  390cd0:	pop    %rbx
  390cd1:	pop    %rbp
  390cd2:	pop    %r12
  390cd4:	pop    %r13
  390cd6:	pop    %r14
  390cd8:	pop    %r15
  390cda:	ret
