
/home/yiming/projects/fastest-bf-lab/build/vldb-nearby-raw32-v1/native/nearby_raw32:     file format elf64-x86-64


Disassembly of section .text:

000000000039b6e0 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned long, 8u, 4u, true> >(nearby_raw32::PublicFilter<unsigned long, 8u, 4u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
  39b6e0:	push   %r15
  39b6e2:	push   %r14
  39b6e4:	push   %r13
  39b6e6:	push   %r12
  39b6e8:	mov    %rcx,%r12
  39b6eb:	push   %rbp
  39b6ec:	mov    %rdi,%rbp
  39b6ef:	push   %rbx
  39b6f0:	mov    %rdx,%rbx
  39b6f3:	sub    $0x18,%rsp
  39b6f7:	mov    %r8,0x8(%rsp)
  39b6fc:	test   %esi,%esi
  39b6fe:	je     39b768 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned long, 8u, 4u, true> >(nearby_raw32::PublicFilter<unsigned long, 8u, 4u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x88>
  39b700:	cmp    $0x1,%esi
  39b703:	mov    $0x1000,%r14d
  39b709:	mov    $0x1,%eax
  39b70e:	cmove  %rax,%r14
  39b712:	test   %rdx,%rdx
  39b715:	je     39b754 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned long, 8u, 4u, true> >(nearby_raw32::PublicFilter<unsigned long, 8u, 4u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x74>
  39b717:	mov    %rdx,%r13
  39b71a:	xor    %r15d,%r15d
  39b71d:	nopl   (%rax)
  39b720:	mov    0x8(%rsp),%rax
  39b725:	lea    0x0(,%r15,4),%rdx
  39b72d:	lea    (%rax,%rdx,1),%rcx
  39b731:	add    %r12,%rdx
  39b734:	mov    %r14,%rax
  39b737:	cmp    %r14,%r13
  39b73a:	cmovbe %r13,%rax
  39b73e:	mov    %rbp,%rdi
  39b741:	mov    %rax,%rsi
  39b744:	add    %r14,%r15
  39b747:	call   39b660 <void vldb_stage2::DenseCall<nearby_raw32::PublicFilter<unsigned long, 8u, 4u, true> >(nearby_raw32::PublicFilter<unsigned long, 8u, 4u, true> const&, unsigned int, unsigned int const*, unsigned int*)>
  39b74c:	sub    %r14,%r13
  39b74f:	cmp    %rbx,%r15
  39b752:	jb     39b720 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned long, 8u, 4u, true> >(nearby_raw32::PublicFilter<unsigned long, 8u, 4u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x40>
  39b754:	add    $0x18,%rsp
  39b758:	pop    %rbx
  39b759:	pop    %rbp
  39b75a:	pop    %r12
  39b75c:	pop    %r13
  39b75e:	pop    %r14
  39b760:	pop    %r15
  39b762:	ret
  39b763:	nopl   0x0(%rax,%rax,1)
  39b768:	lea    0x8(%rdi),%r15
  39b76c:	xor    %r14d,%r14d
  39b76f:	test   %rdx,%rdx
  39b772:	je     39b754 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned long, 8u, 4u, true> >(nearby_raw32::PublicFilter<unsigned long, 8u, 4u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x74>
  39b774:	nopl   0x0(%rax)
  39b778:	mov    (%r12,%r14,4),%edx
  39b77c:	mov    0x18(%rbp),%rsi
  39b780:	mov    %r15,%rdi
  39b783:	call   4f5190 <dtl::bbf_64::contains(unsigned long const*, unsigned int) const>
  39b788:	mov    0x8(%rsp),%rdi
  39b78d:	movzbl %al,%eax
  39b790:	mov    %eax,(%rdi,%r14,4)
  39b794:	inc    %r14
  39b797:	cmp    %r14,%rbx
  39b79a:	jne    39b778 <void vldb_stage2::Query<nearby_raw32::PublicFilter<unsigned long, 8u, 4u, true> >(nearby_raw32::PublicFilter<unsigned long, 8u, 4u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x98>
  39b79c:	add    $0x18,%rsp
  39b7a0:	pop    %rbx
  39b7a1:	pop    %rbp
  39b7a2:	pop    %r12
  39b7a4:	pop    %r13
  39b7a6:	pop    %r14
  39b7a8:	pop    %r15
  39b7aa:	ret
