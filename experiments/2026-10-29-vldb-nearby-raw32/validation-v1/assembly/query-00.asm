
/home/yiming/projects/fastest-bf-lab/build/vldb-nearby-raw32-v1/native/nearby_raw32:     file format elf64-x86-64


Disassembly of section .text:

0000000000390ed0 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned int, 8u, 1u, false> >(nearby_raw32::PublicFilter<unsigned int, 8u, 1u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
  390ed0:	push   %r15
  390ed2:	push   %r14
  390ed4:	push   %r13
  390ed6:	push   %r12
  390ed8:	mov    %rcx,%r12
  390edb:	push   %rbp
  390edc:	mov    %rdi,%rbp
  390edf:	push   %rbx
  390ee0:	mov    %rdx,%rbx
  390ee3:	sub    $0x18,%rsp
  390ee7:	mov    %r8,0x8(%rsp)
  390eec:	test   %esi,%esi
  390eee:	je     390f58 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned int, 8u, 1u, false> >(nearby_raw32::PublicFilter<unsigned int, 8u, 1u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x88>
  390ef0:	cmp    $0x1,%esi
  390ef3:	mov    $0x1000,%r14d
  390ef9:	mov    $0x1,%eax
  390efe:	cmove  %rax,%r14
  390f02:	test   %rdx,%rdx
  390f05:	je     390f44 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned int, 8u, 1u, false> >(nearby_raw32::PublicFilter<unsigned int, 8u, 1u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x74>
  390f07:	mov    %rdx,%r13
  390f0a:	xor    %r15d,%r15d
  390f0d:	nopl   (%rax)
  390f10:	mov    0x8(%rsp),%rax
  390f15:	lea    0x0(,%r15,4),%rdx
  390f1d:	lea    (%rax,%rdx,1),%rcx
  390f21:	add    %r12,%rdx
  390f24:	mov    %r14,%rax
  390f27:	cmp    %r14,%r13
  390f2a:	cmovbe %r13,%rax
  390f2e:	mov    %rbp,%rdi
  390f31:	mov    %rax,%rsi
  390f34:	add    %r14,%r15
  390f37:	call   390e50 <void vldb_stage2::DenseCall<nearby_raw32::PublicFilter<unsigned int, 8u, 1u, false> >(nearby_raw32::PublicFilter<unsigned int, 8u, 1u, false> const&, unsigned int, unsigned int const*, unsigned int*)>
  390f3c:	sub    %r14,%r13
  390f3f:	cmp    %rbx,%r15
  390f42:	jb     390f10 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned int, 8u, 1u, false> >(nearby_raw32::PublicFilter<unsigned int, 8u, 1u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x40>
  390f44:	add    $0x18,%rsp
  390f48:	pop    %rbx
  390f49:	pop    %rbp
  390f4a:	pop    %r12
  390f4c:	pop    %r13
  390f4e:	pop    %r14
  390f50:	pop    %r15
  390f52:	ret
  390f53:	nopl   0x0(%rax,%rax,1)
  390f58:	lea    0x8(%rdi),%r15
  390f5c:	xor    %r14d,%r14d
  390f5f:	test   %rdx,%rdx
  390f62:	je     390f44 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned int, 8u, 1u, false> >(nearby_raw32::PublicFilter<unsigned int, 8u, 1u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x74>
  390f64:	nopl   0x0(%rax)
  390f68:	mov    (%r12,%r14,4),%edx
  390f6c:	mov    0x18(%rbp),%rsi
  390f70:	mov    %r15,%rdi
  390f73:	call   39c1d0 <dtl::bbf_32::contains(unsigned long const*, unsigned int) const>
  390f78:	mov    0x8(%rsp),%rdi
  390f7d:	movzbl %al,%eax
  390f80:	mov    %eax,(%rdi,%r14,4)
  390f84:	inc    %r14
  390f87:	cmp    %r14,%rbx
  390f8a:	jne    390f68 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned int, 8u, 1u, false> >(nearby_raw32::PublicFilter<unsigned int, 8u, 1u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x98>
  390f8c:	add    $0x18,%rsp
  390f90:	pop    %rbx
  390f91:	pop    %rbp
  390f92:	pop    %r12
  390f94:	pop    %r13
  390f96:	pop    %r14
  390f98:	pop    %r15
  390f9a:	ret
