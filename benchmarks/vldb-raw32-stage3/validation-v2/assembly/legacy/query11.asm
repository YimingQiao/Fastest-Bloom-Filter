
/home/yiming/projects/fastest-bf-lab/build/vldb-raw32-stage3-v1/native/legacy:     file format elf64-x86-64


Disassembly of section .text:

000000000067c700 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 4u, 2u, (dtl::block_addressing)1> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 4u, 2u, (dtl::block_addressing)1> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
  67c700:	push   %r15
  67c702:	push   %r14
  67c704:	mov    %rcx,%r14
  67c707:	push   %r13
  67c709:	mov    %rdx,%r13
  67c70c:	push   %r12
  67c70e:	push   %rbp
  67c70f:	push   %rbx
  67c710:	mov    %rdi,%rbx
  67c713:	sub    $0x18,%rsp
  67c717:	mov    %r8,0x8(%rsp)
  67c71c:	test   %esi,%esi
  67c71e:	je     67c790 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 4u, 2u, (dtl::block_addressing)1> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 4u, 2u, (dtl::block_addressing)1> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x90>
  67c720:	cmp    $0x1,%esi
  67c723:	mov    $0x1000,%ebp
  67c728:	mov    $0x1,%eax
  67c72d:	cmove  %rax,%rbp
  67c731:	test   %rdx,%rdx
  67c734:	je     67c781 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 4u, 2u, (dtl::block_addressing)1> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 4u, 2u, (dtl::block_addressing)1> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x81>
  67c736:	mov    %rdi,(%rsp)
  67c73a:	mov    %rbp,%rbx
  67c73d:	mov    0x8(%rsp),%rbp
  67c742:	mov    %rdx,%r15
  67c745:	xor    %r12d,%r12d
  67c748:	nopl   0x0(%rax,%rax,1)
  67c750:	lea    0x0(,%r12,4),%rdx
  67c758:	lea    0x0(%rbp,%rdx,1),%rcx
  67c75d:	mov    %rbx,%rax
  67c760:	add    %r14,%rdx
  67c763:	cmp    %rbx,%r15
  67c766:	cmovbe %r15,%rax
  67c76a:	mov    (%rsp),%rdi
  67c76e:	mov    %rax,%rsi
  67c771:	add    %rbx,%r12
  67c774:	call   67c010 <void vldb_stage2::DenseCall<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 4u, 2u, (dtl::block_addressing)1> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 4u, 2u, (dtl::block_addressing)1> const&, unsigned int, unsigned int const*, unsigned int*)>
  67c779:	sub    %rbx,%r15
  67c77c:	cmp    %r13,%r12
  67c77f:	jb     67c750 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 4u, 2u, (dtl::block_addressing)1> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 4u, 2u, (dtl::block_addressing)1> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x50>
  67c781:	add    $0x18,%rsp
  67c785:	pop    %rbx
  67c786:	pop    %rbp
  67c787:	pop    %r12
  67c789:	pop    %r13
  67c78b:	pop    %r14
  67c78d:	pop    %r15
  67c78f:	ret
  67c790:	xor    %edi,%edi
  67c792:	mov    $0x1,%esi
  67c797:	test   %rdx,%rdx
  67c79a:	je     67c781 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 4u, 2u, (dtl::block_addressing)1> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 4u, 2u, (dtl::block_addressing)1> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x81>
  67c79c:	nopl   0x0(%rax)
  67c7a0:	mov    (%r14,%rdi,4),%eax
  67c7a4:	mov    0xc(%rbx),%edx
  67c7a7:	imul   $0x238ef8e3,%eax,%r8d
  67c7ae:	imul   %r8,%rdx
  67c7b2:	mov    %r8,%rcx
  67c7b5:	mov    0x10(%rbx),%r8d
  67c7b9:	shr    $0x20,%rdx
  67c7bd:	shrx   %r8d,%edx,%edx
  67c7c2:	imul   0x14(%rbx),%edx
  67c7c6:	sub    %edx,%ecx
  67c7c8:	mov    0x18(%rbx),%rdx
  67c7cc:	lea    0x0(,%rcx,8),%ecx
  67c7d3:	lea    (%rdx,%rcx,4),%rcx
  67c7d7:	imul   $0x16118b03,%eax,%edx
  67c7dd:	imul   $0x9e3779b9,%eax,%eax
  67c7e3:	mov    (%rcx),%r15d
  67c7e6:	mov    %edx,%r12d
  67c7e9:	shr    $0x1b,%r12d
  67c7ed:	shlx   %r12d,%esi,%r12d
  67c7f2:	mov    %edx,%ebp
  67c7f4:	and    %r12d,%r15d
  67c7f7:	mov    %edx,%r11d
  67c7fa:	mov    %edx,%r10d
  67c7fd:	mov    %edx,%r9d
  67c800:	mov    %eax,%r8d
  67c803:	shr    $0x16,%ebp
  67c806:	shr    $0x11,%r11d
  67c80a:	shr    $0xc,%r10d
  67c80e:	shr    $0x7,%r9d
  67c812:	shr    $0x2,%edx
  67c815:	shr    $0x1b,%r8d
  67c819:	shr    $0x16,%eax
  67c81c:	cmp    %r12d,%r15d
  67c81f:	mov    0x4(%rcx),%r12d
  67c823:	sete   %r15b
  67c827:	shlx   %ebp,%esi,%ebp
  67c82c:	and    %ebp,%r12d
  67c82f:	cmp    %ebp,%r12d
  67c832:	mov    0x8(%rcx),%r12d
  67c836:	sete   %bpl
  67c83a:	shlx   %r11d,%esi,%r11d
  67c83f:	and    %r11d,%r12d
  67c842:	and    %r15d,%ebp
  67c845:	cmp    %r11d,%r12d
  67c848:	sete   %r11b
  67c84c:	and    %ebp,%r11d
  67c84f:	mov    0xc(%rcx),%ebp
  67c852:	shlx   %r10d,%esi,%r10d
  67c857:	and    %r10d,%ebp
  67c85a:	cmp    %r10d,%ebp
  67c85d:	sete   %r10b
  67c861:	and    %r11d,%r10d
  67c864:	mov    0x10(%rcx),%r11d
  67c868:	shlx   %r9d,%esi,%r9d
  67c86d:	and    %r9d,%r11d
  67c870:	cmp    %r9d,%r11d
  67c873:	sete   %r9b
  67c877:	and    %r10d,%r9d
  67c87a:	mov    0x14(%rcx),%r10d
  67c87e:	shlx   %edx,%esi,%edx
  67c883:	and    %edx,%r10d
  67c886:	cmp    %edx,%r10d
  67c889:	sete   %dl
  67c88c:	and    %r9d,%edx
  67c88f:	mov    0x18(%rcx),%r9d
  67c893:	mov    0x1c(%rcx),%r15d
  67c897:	shlx   %r8d,%esi,%r8d
  67c89c:	and    %r8d,%r9d
  67c89f:	cmp    %r8d,%r9d
  67c8a2:	sete   %r8b
  67c8a6:	shlx   %eax,%esi,%eax
  67c8ab:	and    %eax,%r15d
  67c8ae:	and    %r8d,%edx
  67c8b1:	cmp    %eax,%r15d
  67c8b4:	sete   %al
  67c8b7:	mov    0x8(%rsp),%rcx
  67c8bc:	movzbl %al,%eax
  67c8bf:	and    %edx,%eax
  67c8c1:	mov    %eax,(%rcx,%rdi,4)
  67c8c4:	inc    %rdi
  67c8c7:	cmp    %rdi,%r13
  67c8ca:	jne    67c7a0 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 4u, 2u, (dtl::block_addressing)1> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 4u, 2u, (dtl::block_addressing)1> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0xa0>
  67c8d0:	add    $0x18,%rsp
  67c8d4:	pop    %rbx
  67c8d5:	pop    %rbp
  67c8d6:	pop    %r12
  67c8d8:	pop    %r13
  67c8da:	pop    %r14
  67c8dc:	pop    %r15
  67c8de:	ret
