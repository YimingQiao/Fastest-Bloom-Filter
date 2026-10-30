
/home/yiming/projects/fastest-bf-lab/build/vldb-raw32-stage3-v1/native/legacy:     file format elf64-x86-64


Disassembly of section .text:

00000000006897d0 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 2u, 0u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 2u, 0u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
  6897d0:	push   %r15
  6897d2:	push   %r14
  6897d4:	push   %r13
  6897d6:	push   %r12
  6897d8:	mov    %rcx,%r12
  6897db:	push   %rbp
  6897dc:	mov    %rdi,%rbp
  6897df:	push   %rbx
  6897e0:	mov    %rdx,%rbx
  6897e3:	sub    $0x18,%rsp
  6897e7:	mov    %r8,0x8(%rsp)
  6897ec:	test   %esi,%esi
  6897ee:	je     689858 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 2u, 0u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 2u, 0u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x88>
  6897f0:	cmp    $0x1,%esi
  6897f3:	mov    $0x1000,%r14d
  6897f9:	mov    $0x1,%eax
  6897fe:	cmove  %rax,%r14
  689802:	test   %rdx,%rdx
  689805:	je     689844 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 2u, 0u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 2u, 0u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x74>
  689807:	mov    %rdx,%r13
  68980a:	xor    %r15d,%r15d
  68980d:	nopl   (%rax)
  689810:	mov    0x8(%rsp),%rax
  689815:	lea    0x0(,%r15,4),%rdx
  68981d:	lea    (%rax,%rdx,1),%rcx
  689821:	add    %r12,%rdx
  689824:	mov    %r14,%rax
  689827:	cmp    %r14,%r13
  68982a:	cmovbe %r13,%rax
  68982e:	mov    %rbp,%rdi
  689831:	mov    %rax,%rsi
  689834:	add    %r14,%r15
  689837:	call   689750 <void vldb_stage2::DenseCall<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 2u, 0u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 2u, 0u, (dtl::block_addressing)2> const&, unsigned int, unsigned int const*, unsigned int*)>
  68983c:	sub    %r14,%r13
  68983f:	cmp    %rbx,%r15
  689842:	jb     689810 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 2u, 0u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 2u, 0u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x40>
  689844:	add    $0x18,%rsp
  689848:	pop    %rbx
  689849:	pop    %rbp
  68984a:	pop    %r12
  68984c:	pop    %r13
  68984e:	pop    %r14
  689850:	pop    %r15
  689852:	ret
  689853:	nopl   0x0(%rax,%rax,1)
  689858:	lea    0x8(%rdi),%r15
  68985c:	xor    %r14d,%r14d
  68985f:	test   %rdx,%rdx
  689862:	je     689844 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 2u, 0u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 2u, 0u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x74>
  689864:	nopl   0x0(%rax)
  689868:	mov    (%r12,%r14,4),%edx
  68986c:	mov    0x18(%rbp),%rsi
  689870:	mov    %r15,%rdi
  689873:	call   6917a0 <dtl::bbf_32::contains(unsigned long const*, unsigned int) const>
  689878:	mov    0x8(%rsp),%rdi
  68987d:	movzbl %al,%eax
  689880:	mov    %eax,(%rdi,%r14,4)
  689884:	inc    %r14
  689887:	cmp    %r14,%rbx
  68988a:	jne    689868 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 2u, 0u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 2u, 0u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x98>
  68988c:	add    $0x18,%rsp
  689890:	pop    %rbx
  689891:	pop    %rbp
  689892:	pop    %r12
  689894:	pop    %r13
  689896:	pop    %r14
  689898:	pop    %r15
  68989a:	ret
