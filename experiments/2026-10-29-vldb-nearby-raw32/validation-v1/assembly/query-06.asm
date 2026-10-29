
/home/yiming/projects/fastest-bf-lab/build/vldb-nearby-raw32-v1/native/nearby_raw32:     file format elf64-x86-64


Disassembly of section .text:

000000000039b060 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned long, 1u, 0u, false> >(nearby_raw32::PublicFilter<unsigned long, 1u, 0u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
  39b060:	push   %r15
  39b062:	push   %r14
  39b064:	push   %r13
  39b066:	push   %r12
  39b068:	mov    %rcx,%r12
  39b06b:	push   %rbp
  39b06c:	mov    %rdi,%rbp
  39b06f:	push   %rbx
  39b070:	mov    %rdx,%rbx
  39b073:	sub    $0x18,%rsp
  39b077:	mov    %r8,0x8(%rsp)
  39b07c:	test   %esi,%esi
  39b07e:	je     39b0e8 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned long, 1u, 0u, false> >(nearby_raw32::PublicFilter<unsigned long, 1u, 0u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x88>
  39b080:	cmp    $0x1,%esi
  39b083:	mov    $0x1000,%r14d
  39b089:	mov    $0x1,%eax
  39b08e:	cmove  %rax,%r14
  39b092:	test   %rdx,%rdx
  39b095:	je     39b0d4 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned long, 1u, 0u, false> >(nearby_raw32::PublicFilter<unsigned long, 1u, 0u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x74>
  39b097:	mov    %rdx,%r13
  39b09a:	xor    %r15d,%r15d
  39b09d:	nopl   (%rax)
  39b0a0:	mov    0x8(%rsp),%rax
  39b0a5:	lea    0x0(,%r15,4),%rdx
  39b0ad:	lea    (%rax,%rdx,1),%rcx
  39b0b1:	add    %r12,%rdx
  39b0b4:	mov    %r14,%rax
  39b0b7:	cmp    %r14,%r13
  39b0ba:	cmovbe %r13,%rax
  39b0be:	mov    %rbp,%rdi
  39b0c1:	mov    %rax,%rsi
  39b0c4:	add    %r14,%r15
  39b0c7:	call   39afe0 <void vldb_stage2::DenseCall<nearby_raw32::PublicFilter<unsigned long, 1u, 0u, false> >(nearby_raw32::PublicFilter<unsigned long, 1u, 0u, false> const&, unsigned int, unsigned int const*, unsigned int*)>
  39b0cc:	sub    %r14,%r13
  39b0cf:	cmp    %rbx,%r15
  39b0d2:	jb     39b0a0 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned long, 1u, 0u, false> >(nearby_raw32::PublicFilter<unsigned long, 1u, 0u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x40>
  39b0d4:	add    $0x18,%rsp
  39b0d8:	pop    %rbx
  39b0d9:	pop    %rbp
  39b0da:	pop    %r12
  39b0dc:	pop    %r13
  39b0de:	pop    %r14
  39b0e0:	pop    %r15
  39b0e2:	ret
  39b0e3:	nopl   0x0(%rax,%rax,1)
  39b0e8:	lea    0x8(%rdi),%r15
  39b0ec:	xor    %r14d,%r14d
  39b0ef:	test   %rdx,%rdx
  39b0f2:	je     39b0d4 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned long, 1u, 0u, false> >(nearby_raw32::PublicFilter<unsigned long, 1u, 0u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x74>
  39b0f4:	nopl   0x0(%rax)
  39b0f8:	mov    (%r12,%r14,4),%edx
  39b0fc:	mov    0x18(%rbp),%rsi
  39b100:	mov    %r15,%rdi
  39b103:	call   4f5190 <dtl::bbf_64::contains(unsigned long const*, unsigned int) const>
  39b108:	mov    0x8(%rsp),%rdi
  39b10d:	movzbl %al,%eax
  39b110:	mov    %eax,(%rdi,%r14,4)
  39b114:	inc    %r14
  39b117:	cmp    %r14,%rbx
  39b11a:	jne    39b0f8 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned long, 1u, 0u, false> >(nearby_raw32::PublicFilter<unsigned long, 1u, 0u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x98>
  39b11c:	add    $0x18,%rsp
  39b120:	pop    %rbx
  39b121:	pop    %rbp
  39b122:	pop    %r12
  39b124:	pop    %r13
  39b126:	pop    %r14
  39b128:	pop    %r15
  39b12a:	ret
