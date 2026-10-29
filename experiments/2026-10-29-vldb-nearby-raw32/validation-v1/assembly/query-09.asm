
/home/yiming/projects/fastest-bf-lab/build/vldb-nearby-raw32-v1/native/nearby_raw32:     file format elf64-x86-64


Disassembly of section .text:

000000000039bca0 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned long, 8u, 1u, true> >(nearby_raw32::PublicFilter<unsigned long, 8u, 1u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
  39bca0:	push   %r15
  39bca2:	push   %r14
  39bca4:	push   %r13
  39bca6:	push   %r12
  39bca8:	mov    %rcx,%r12
  39bcab:	push   %rbp
  39bcac:	mov    %rdi,%rbp
  39bcaf:	push   %rbx
  39bcb0:	mov    %rdx,%rbx
  39bcb3:	sub    $0x18,%rsp
  39bcb7:	mov    %r8,0x8(%rsp)
  39bcbc:	test   %esi,%esi
  39bcbe:	je     39bd28 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned long, 8u, 1u, true> >(nearby_raw32::PublicFilter<unsigned long, 8u, 1u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x88>
  39bcc0:	cmp    $0x1,%esi
  39bcc3:	mov    $0x1000,%r14d
  39bcc9:	mov    $0x1,%eax
  39bcce:	cmove  %rax,%r14
  39bcd2:	test   %rdx,%rdx
  39bcd5:	je     39bd14 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned long, 8u, 1u, true> >(nearby_raw32::PublicFilter<unsigned long, 8u, 1u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x74>
  39bcd7:	mov    %rdx,%r13
  39bcda:	xor    %r15d,%r15d
  39bcdd:	nopl   (%rax)
  39bce0:	mov    0x8(%rsp),%rax
  39bce5:	lea    0x0(,%r15,4),%rdx
  39bced:	lea    (%rax,%rdx,1),%rcx
  39bcf1:	add    %r12,%rdx
  39bcf4:	mov    %r14,%rax
  39bcf7:	cmp    %r14,%r13
  39bcfa:	cmovbe %r13,%rax
  39bcfe:	mov    %rbp,%rdi
  39bd01:	mov    %rax,%rsi
  39bd04:	add    %r14,%r15
  39bd07:	call   39bc20 <void vldb_stage2::DenseCall<nearby_raw32::PublicFilter<unsigned long, 8u, 1u, true> >(nearby_raw32::PublicFilter<unsigned long, 8u, 1u, true> const&, unsigned int, unsigned int const*, unsigned int*)>
  39bd0c:	sub    %r14,%r13
  39bd0f:	cmp    %rbx,%r15
  39bd12:	jb     39bce0 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned long, 8u, 1u, true> >(nearby_raw32::PublicFilter<unsigned long, 8u, 1u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x40>
  39bd14:	add    $0x18,%rsp
  39bd18:	pop    %rbx
  39bd19:	pop    %rbp
  39bd1a:	pop    %r12
  39bd1c:	pop    %r13
  39bd1e:	pop    %r14
  39bd20:	pop    %r15
  39bd22:	ret
  39bd23:	nopl   0x0(%rax,%rax,1)
  39bd28:	lea    0x8(%rdi),%r15
  39bd2c:	xor    %r14d,%r14d
  39bd2f:	test   %rdx,%rdx
  39bd32:	je     39bd14 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned long, 8u, 1u, true> >(nearby_raw32::PublicFilter<unsigned long, 8u, 1u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x74>
  39bd34:	nopl   0x0(%rax)
  39bd38:	mov    (%r12,%r14,4),%edx
  39bd3c:	mov    0x18(%rbp),%rsi
  39bd40:	mov    %r15,%rdi
  39bd43:	call   4f5190 <dtl::bbf_64::contains(unsigned long const*, unsigned int) const>
  39bd48:	mov    0x8(%rsp),%rdi
  39bd4d:	movzbl %al,%eax
  39bd50:	mov    %eax,(%rdi,%r14,4)
  39bd54:	inc    %r14
  39bd57:	cmp    %r14,%rbx
  39bd5a:	jne    39bd38 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned long, 8u, 1u, true> >(nearby_raw32::PublicFilter<unsigned long, 8u, 1u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x98>
  39bd5c:	add    $0x18,%rsp
  39bd60:	pop    %rbx
  39bd61:	pop    %rbp
  39bd62:	pop    %r12
  39bd64:	pop    %r13
  39bd66:	pop    %r14
  39bd68:	pop    %r15
  39bd6a:	ret
