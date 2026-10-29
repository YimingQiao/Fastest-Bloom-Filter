
/home/yiming/projects/fastest-bf-lab/build/vldb-nearby-raw32-v1/native/nearby_raw32:     file format elf64-x86-64


Disassembly of section .text:

000000000039af00 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned long, 8u, 1u, false> >(nearby_raw32::PublicFilter<unsigned long, 8u, 1u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
  39af00:	push   %r15
  39af02:	push   %r14
  39af04:	push   %r13
  39af06:	push   %r12
  39af08:	mov    %rcx,%r12
  39af0b:	push   %rbp
  39af0c:	mov    %rdi,%rbp
  39af0f:	push   %rbx
  39af10:	mov    %rdx,%rbx
  39af13:	sub    $0x18,%rsp
  39af17:	mov    %r8,0x8(%rsp)
  39af1c:	test   %esi,%esi
  39af1e:	je     39af88 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned long, 8u, 1u, false> >(nearby_raw32::PublicFilter<unsigned long, 8u, 1u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x88>
  39af20:	cmp    $0x1,%esi
  39af23:	mov    $0x1000,%r14d
  39af29:	mov    $0x1,%eax
  39af2e:	cmove  %rax,%r14
  39af32:	test   %rdx,%rdx
  39af35:	je     39af74 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned long, 8u, 1u, false> >(nearby_raw32::PublicFilter<unsigned long, 8u, 1u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x74>
  39af37:	mov    %rdx,%r13
  39af3a:	xor    %r15d,%r15d
  39af3d:	nopl   (%rax)
  39af40:	mov    0x8(%rsp),%rax
  39af45:	lea    0x0(,%r15,4),%rdx
  39af4d:	lea    (%rax,%rdx,1),%rcx
  39af51:	add    %r12,%rdx
  39af54:	mov    %r14,%rax
  39af57:	cmp    %r14,%r13
  39af5a:	cmovbe %r13,%rax
  39af5e:	mov    %rbp,%rdi
  39af61:	mov    %rax,%rsi
  39af64:	add    %r14,%r15
  39af67:	call   39ae80 <void vldb_stage2::DenseCall<nearby_raw32::PublicFilter<unsigned long, 8u, 1u, false> >(nearby_raw32::PublicFilter<unsigned long, 8u, 1u, false> const&, unsigned int, unsigned int const*, unsigned int*)>
  39af6c:	sub    %r14,%r13
  39af6f:	cmp    %rbx,%r15
  39af72:	jb     39af40 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned long, 8u, 1u, false> >(nearby_raw32::PublicFilter<unsigned long, 8u, 1u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x40>
  39af74:	add    $0x18,%rsp
  39af78:	pop    %rbx
  39af79:	pop    %rbp
  39af7a:	pop    %r12
  39af7c:	pop    %r13
  39af7e:	pop    %r14
  39af80:	pop    %r15
  39af82:	ret
  39af83:	nopl   0x0(%rax,%rax,1)
  39af88:	lea    0x8(%rdi),%r15
  39af8c:	xor    %r14d,%r14d
  39af8f:	test   %rdx,%rdx
  39af92:	je     39af74 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned long, 8u, 1u, false> >(nearby_raw32::PublicFilter<unsigned long, 8u, 1u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x74>
  39af94:	nopl   0x0(%rax)
  39af98:	mov    (%r12,%r14,4),%edx
  39af9c:	mov    0x18(%rbp),%rsi
  39afa0:	mov    %r15,%rdi
  39afa3:	call   4f5190 <dtl::bbf_64::contains(unsigned long const*, unsigned int) const>
  39afa8:	mov    0x8(%rsp),%rdi
  39afad:	movzbl %al,%eax
  39afb0:	mov    %eax,(%rdi,%r14,4)
  39afb4:	inc    %r14
  39afb7:	cmp    %r14,%rbx
  39afba:	jne    39af98 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned long, 8u, 1u, false> >(nearby_raw32::PublicFilter<unsigned long, 8u, 1u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x98>
  39afbc:	add    $0x18,%rsp
  39afc0:	pop    %rbx
  39afc1:	pop    %rbp
  39afc2:	pop    %r12
  39afc4:	pop    %r13
  39afc6:	pop    %r14
  39afc8:	pop    %r15
  39afca:	ret
