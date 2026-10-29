
/home/yiming/projects/fastest-bf-lab/build/vldb-nearby-raw32-v1/native/nearby_raw32:     file format elf64-x86-64


Disassembly of section .text:

000000000039bb40 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned long, 1u, 0u, true> >(nearby_raw32::PublicFilter<unsigned long, 1u, 0u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
  39bb40:	push   %r15
  39bb42:	push   %r14
  39bb44:	push   %r13
  39bb46:	push   %r12
  39bb48:	mov    %rcx,%r12
  39bb4b:	push   %rbp
  39bb4c:	mov    %rdi,%rbp
  39bb4f:	push   %rbx
  39bb50:	mov    %rdx,%rbx
  39bb53:	sub    $0x18,%rsp
  39bb57:	mov    %r8,0x8(%rsp)
  39bb5c:	test   %esi,%esi
  39bb5e:	je     39bbc8 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned long, 1u, 0u, true> >(nearby_raw32::PublicFilter<unsigned long, 1u, 0u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x88>
  39bb60:	cmp    $0x1,%esi
  39bb63:	mov    $0x1000,%r14d
  39bb69:	mov    $0x1,%eax
  39bb6e:	cmove  %rax,%r14
  39bb72:	test   %rdx,%rdx
  39bb75:	je     39bbb4 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned long, 1u, 0u, true> >(nearby_raw32::PublicFilter<unsigned long, 1u, 0u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x74>
  39bb77:	mov    %rdx,%r13
  39bb7a:	xor    %r15d,%r15d
  39bb7d:	nopl   (%rax)
  39bb80:	mov    0x8(%rsp),%rax
  39bb85:	lea    0x0(,%r15,4),%rdx
  39bb8d:	lea    (%rax,%rdx,1),%rcx
  39bb91:	add    %r12,%rdx
  39bb94:	mov    %r14,%rax
  39bb97:	cmp    %r14,%r13
  39bb9a:	cmovbe %r13,%rax
  39bb9e:	mov    %rbp,%rdi
  39bba1:	mov    %rax,%rsi
  39bba4:	add    %r14,%r15
  39bba7:	call   39bac0 <void vldb_stage2::DenseCall<nearby_raw32::PublicFilter<unsigned long, 1u, 0u, true> >(nearby_raw32::PublicFilter<unsigned long, 1u, 0u, true> const&, unsigned int, unsigned int const*, unsigned int*)>
  39bbac:	sub    %r14,%r13
  39bbaf:	cmp    %rbx,%r15
  39bbb2:	jb     39bb80 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned long, 1u, 0u, true> >(nearby_raw32::PublicFilter<unsigned long, 1u, 0u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x40>
  39bbb4:	add    $0x18,%rsp
  39bbb8:	pop    %rbx
  39bbb9:	pop    %rbp
  39bbba:	pop    %r12
  39bbbc:	pop    %r13
  39bbbe:	pop    %r14
  39bbc0:	pop    %r15
  39bbc2:	ret
  39bbc3:	nopl   0x0(%rax,%rax,1)
  39bbc8:	lea    0x8(%rdi),%r15
  39bbcc:	xor    %r14d,%r14d
  39bbcf:	test   %rdx,%rdx
  39bbd2:	je     39bbb4 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned long, 1u, 0u, true> >(nearby_raw32::PublicFilter<unsigned long, 1u, 0u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x74>
  39bbd4:	nopl   0x0(%rax)
  39bbd8:	mov    (%r12,%r14,4),%edx
  39bbdc:	mov    0x18(%rbp),%rsi
  39bbe0:	mov    %r15,%rdi
  39bbe3:	call   4f5190 <dtl::bbf_64::contains(unsigned long const*, unsigned int) const>
  39bbe8:	mov    0x8(%rsp),%rdi
  39bbed:	movzbl %al,%eax
  39bbf0:	mov    %eax,(%rdi,%r14,4)
  39bbf4:	inc    %r14
  39bbf7:	cmp    %r14,%rbx
  39bbfa:	jne    39bbd8 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned long, 1u, 0u, true> >(nearby_raw32::PublicFilter<unsigned long, 1u, 0u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x98>
  39bbfc:	add    $0x18,%rsp
  39bc00:	pop    %rbx
  39bc01:	pop    %rbp
  39bc02:	pop    %r12
  39bc04:	pop    %r13
  39bc06:	pop    %r14
  39bc08:	pop    %r15
  39bc0a:	ret
