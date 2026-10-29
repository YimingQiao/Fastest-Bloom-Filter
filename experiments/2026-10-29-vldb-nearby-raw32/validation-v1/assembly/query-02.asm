
/home/yiming/projects/fastest-bf-lab/build/vldb-nearby-raw32-v1/native/nearby_raw32:     file format elf64-x86-64


Disassembly of section .text:

0000000000390d70 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned int, 8u, 2u, false> >(nearby_raw32::PublicFilter<unsigned int, 8u, 2u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
  390d70:	push   %r15
  390d72:	push   %r14
  390d74:	push   %r13
  390d76:	push   %r12
  390d78:	mov    %rcx,%r12
  390d7b:	push   %rbp
  390d7c:	mov    %rdi,%rbp
  390d7f:	push   %rbx
  390d80:	mov    %rdx,%rbx
  390d83:	sub    $0x18,%rsp
  390d87:	mov    %r8,0x8(%rsp)
  390d8c:	test   %esi,%esi
  390d8e:	je     390df8 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned int, 8u, 2u, false> >(nearby_raw32::PublicFilter<unsigned int, 8u, 2u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x88>
  390d90:	cmp    $0x1,%esi
  390d93:	mov    $0x1000,%r14d
  390d99:	mov    $0x1,%eax
  390d9e:	cmove  %rax,%r14
  390da2:	test   %rdx,%rdx
  390da5:	je     390de4 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned int, 8u, 2u, false> >(nearby_raw32::PublicFilter<unsigned int, 8u, 2u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x74>
  390da7:	mov    %rdx,%r13
  390daa:	xor    %r15d,%r15d
  390dad:	nopl   (%rax)
  390db0:	mov    0x8(%rsp),%rax
  390db5:	lea    0x0(,%r15,4),%rdx
  390dbd:	lea    (%rax,%rdx,1),%rcx
  390dc1:	add    %r12,%rdx
  390dc4:	mov    %r14,%rax
  390dc7:	cmp    %r14,%r13
  390dca:	cmovbe %r13,%rax
  390dce:	mov    %rbp,%rdi
  390dd1:	mov    %rax,%rsi
  390dd4:	add    %r14,%r15
  390dd7:	call   390cf0 <void vldb_stage2::DenseCall<nearby_raw32::PublicFilter<unsigned int, 8u, 2u, false> >(nearby_raw32::PublicFilter<unsigned int, 8u, 2u, false> const&, unsigned int, unsigned int const*, unsigned int*)>
  390ddc:	sub    %r14,%r13
  390ddf:	cmp    %rbx,%r15
  390de2:	jb     390db0 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned int, 8u, 2u, false> >(nearby_raw32::PublicFilter<unsigned int, 8u, 2u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x40>
  390de4:	add    $0x18,%rsp
  390de8:	pop    %rbx
  390de9:	pop    %rbp
  390dea:	pop    %r12
  390dec:	pop    %r13
  390dee:	pop    %r14
  390df0:	pop    %r15
  390df2:	ret
  390df3:	nopl   0x0(%rax,%rax,1)
  390df8:	lea    0x8(%rdi),%r15
  390dfc:	xor    %r14d,%r14d
  390dff:	test   %rdx,%rdx
  390e02:	je     390de4 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned int, 8u, 2u, false> >(nearby_raw32::PublicFilter<unsigned int, 8u, 2u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x74>
  390e04:	nopl   0x0(%rax)
  390e08:	mov    (%r12,%r14,4),%edx
  390e0c:	mov    0x18(%rbp),%rsi
  390e10:	mov    %r15,%rdi
  390e13:	call   39c1d0 <dtl::bbf_32::contains(unsigned long const*, unsigned int) const>
  390e18:	mov    0x8(%rsp),%rdi
  390e1d:	movzbl %al,%eax
  390e20:	mov    %eax,(%rdi,%r14,4)
  390e24:	inc    %r14
  390e27:	cmp    %r14,%rbx
  390e2a:	jne    390e08 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned int, 8u, 2u, false> >(nearby_raw32::PublicFilter<unsigned int, 8u, 2u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x98>
  390e2c:	add    $0x18,%rsp
  390e30:	pop    %rbx
  390e31:	pop    %rbp
  390e32:	pop    %r12
  390e34:	pop    %r13
  390e36:	pop    %r14
  390e38:	pop    %r15
  390e3a:	ret
