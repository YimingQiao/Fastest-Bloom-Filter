
/home/yiming/projects/fastest-bf-lab/build/vldb-nearby-raw32-v1/native/nearby_raw32:     file format elf64-x86-64


Disassembly of section .text:

000000000039b1c0 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned long, 8u, 4u, false> >(nearby_raw32::PublicFilter<unsigned long, 8u, 4u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
  39b1c0:	push   %r15
  39b1c2:	push   %r14
  39b1c4:	push   %r13
  39b1c6:	push   %r12
  39b1c8:	mov    %rcx,%r12
  39b1cb:	push   %rbp
  39b1cc:	mov    %rdi,%rbp
  39b1cf:	push   %rbx
  39b1d0:	mov    %rdx,%rbx
  39b1d3:	sub    $0x18,%rsp
  39b1d7:	mov    %r8,0x8(%rsp)
  39b1dc:	test   %esi,%esi
  39b1de:	je     39b248 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned long, 8u, 4u, false> >(nearby_raw32::PublicFilter<unsigned long, 8u, 4u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x88>
  39b1e0:	cmp    $0x1,%esi
  39b1e3:	mov    $0x1000,%r14d
  39b1e9:	mov    $0x1,%eax
  39b1ee:	cmove  %rax,%r14
  39b1f2:	test   %rdx,%rdx
  39b1f5:	je     39b234 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned long, 8u, 4u, false> >(nearby_raw32::PublicFilter<unsigned long, 8u, 4u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x74>
  39b1f7:	mov    %rdx,%r13
  39b1fa:	xor    %r15d,%r15d
  39b1fd:	nopl   (%rax)
  39b200:	mov    0x8(%rsp),%rax
  39b205:	lea    0x0(,%r15,4),%rdx
  39b20d:	lea    (%rax,%rdx,1),%rcx
  39b211:	add    %r12,%rdx
  39b214:	mov    %r14,%rax
  39b217:	cmp    %r14,%r13
  39b21a:	cmovbe %r13,%rax
  39b21e:	mov    %rbp,%rdi
  39b221:	mov    %rax,%rsi
  39b224:	add    %r14,%r15
  39b227:	call   39b140 <void vldb_stage2::DenseCall<nearby_raw32::PublicFilter<unsigned long, 8u, 4u, false> >(nearby_raw32::PublicFilter<unsigned long, 8u, 4u, false> const&, unsigned int, unsigned int const*, unsigned int*)>
  39b22c:	sub    %r14,%r13
  39b22f:	cmp    %rbx,%r15
  39b232:	jb     39b200 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned long, 8u, 4u, false> >(nearby_raw32::PublicFilter<unsigned long, 8u, 4u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x40>
  39b234:	add    $0x18,%rsp
  39b238:	pop    %rbx
  39b239:	pop    %rbp
  39b23a:	pop    %r12
  39b23c:	pop    %r13
  39b23e:	pop    %r14
  39b240:	pop    %r15
  39b242:	ret
  39b243:	nopl   0x0(%rax,%rax,1)
  39b248:	lea    0x8(%rdi),%r15
  39b24c:	xor    %r14d,%r14d
  39b24f:	test   %rdx,%rdx
  39b252:	je     39b234 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned long, 8u, 4u, false> >(nearby_raw32::PublicFilter<unsigned long, 8u, 4u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x74>
  39b254:	nopl   0x0(%rax)
  39b258:	mov    (%r12,%r14,4),%edx
  39b25c:	mov    0x18(%rbp),%rsi
  39b260:	mov    %r15,%rdi
  39b263:	call   4f5190 <dtl::bbf_64::contains(unsigned long const*, unsigned int) const>
  39b268:	mov    0x8(%rsp),%rdi
  39b26d:	movzbl %al,%eax
  39b270:	mov    %eax,(%rdi,%r14,4)
  39b274:	inc    %r14
  39b277:	cmp    %r14,%rbx
  39b27a:	jne    39b258 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned long, 8u, 4u, false> >(nearby_raw32::PublicFilter<unsigned long, 8u, 4u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x98>
  39b27c:	add    $0x18,%rsp
  39b280:	pop    %rbx
  39b281:	pop    %rbp
  39b282:	pop    %r12
  39b284:	pop    %r13
  39b286:	pop    %r14
  39b288:	pop    %r15
  39b28a:	ret
