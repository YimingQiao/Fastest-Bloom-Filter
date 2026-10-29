
/home/yiming/projects/fastest-bf-lab/build/vldb-raw32-stage3-v1/native/legacy:     file format elf64-x86-64


Disassembly of section .text:

00000000004bb3b0 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 2u, 1u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 2u, 1u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
  4bb3b0:	push   %r15
  4bb3b2:	push   %r14
  4bb3b4:	push   %r13
  4bb3b6:	push   %r12
  4bb3b8:	mov    %rcx,%r12
  4bb3bb:	push   %rbp
  4bb3bc:	mov    %rdx,%rbp
  4bb3bf:	push   %rbx
  4bb3c0:	mov    %rdi,%rbx
  4bb3c3:	sub    $0x28,%rsp
  4bb3c7:	mov    %r8,0x8(%rsp)
  4bb3cc:	test   %esi,%esi
  4bb3ce:	je     4bb438 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 2u, 1u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 2u, 1u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x88>
  4bb3d0:	cmp    $0x1,%esi
  4bb3d3:	mov    $0x1000,%r14d
  4bb3d9:	mov    $0x1,%eax
  4bb3de:	cmove  %rax,%r14
  4bb3e2:	test   %rdx,%rdx
  4bb3e5:	je     4bb424 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 2u, 1u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 2u, 1u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x74>
  4bb3e7:	mov    %rdx,%r13
  4bb3ea:	xor    %r15d,%r15d
  4bb3ed:	nopl   (%rax)
  4bb3f0:	mov    0x8(%rsp),%rax
  4bb3f5:	lea    0x0(,%r15,4),%rdx
  4bb3fd:	lea    (%rax,%rdx,1),%rcx
  4bb401:	add    %r12,%rdx
  4bb404:	mov    %r14,%rax
  4bb407:	cmp    %r14,%r13
  4bb40a:	cmovbe %r13,%rax
  4bb40e:	mov    %rbx,%rdi
  4bb411:	mov    %rax,%rsi
  4bb414:	add    %r14,%r15
  4bb417:	call   4bb2f0 <void vldb_stage2::DenseCall<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 2u, 1u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 2u, 1u, (dtl::block_addressing)2> const&, unsigned int, unsigned int const*, unsigned int*)>
  4bb41c:	sub    %r14,%r13
  4bb41f:	cmp    %rbp,%r15
  4bb422:	jb     4bb3f0 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 2u, 1u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 2u, 1u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x40>
  4bb424:	add    $0x28,%rsp
  4bb428:	pop    %rbx
  4bb429:	pop    %rbp
  4bb42a:	pop    %r12
  4bb42c:	pop    %r13
  4bb42e:	pop    %r14
  4bb430:	pop    %r15
  4bb432:	ret
  4bb433:	nopl   0x0(%rax,%rax,1)
  4bb438:	xor    %r14d,%r14d
  4bb43b:	lea    0x14(%rsp),%r15
  4bb440:	test   %rdx,%rdx
  4bb443:	je     4bb424 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 2u, 1u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 2u, 1u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x74>
  4bb445:	nopl   (%rax)
  4bb448:	mov    (%r12,%r14,4),%eax
  4bb44c:	mov    0xc0(%rbx),%rdx
  4bb453:	cmpq   $0x0,0x90(%rbx)
  4bb45b:	mov    %rdx,0x18(%rsp)
  4bb460:	mov    %eax,0x14(%rsp)
  4bb464:	je     4bb49e <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 2u, 1u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 2u, 1u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0xee>
  4bb466:	lea    0x80(%rbx),%rdi
  4bb46d:	lea    0x18(%rsp),%rsi
  4bb472:	mov    %r15,%rdx
  4bb475:	call   *0x98(%rbx)
  4bb47b:	mov    0x8(%rsp),%rdi
  4bb480:	movzbl %al,%eax
  4bb483:	mov    %eax,(%rdi,%r14,4)
  4bb487:	inc    %r14
  4bb48a:	cmp    %r14,%rbp
  4bb48d:	jne    4bb448 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 2u, 1u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 2u, 1u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x98>
  4bb48f:	add    $0x28,%rsp
  4bb493:	pop    %rbx
  4bb494:	pop    %rbp
  4bb495:	pop    %r12
  4bb497:	pop    %r13
  4bb499:	pop    %r14
  4bb49b:	pop    %r15
  4bb49d:	ret
  4bb49e:	call   1948ca0 <std::__throw_bad_function_call()@plt>
