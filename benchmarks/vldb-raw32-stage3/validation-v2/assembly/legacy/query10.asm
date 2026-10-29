
/home/yiming/projects/fastest-bf-lab/build/vldb-raw32-stage3-v1/native/legacy:     file format elf64-x86-64


Disassembly of section .text:

000000000067b320 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 4u, 2u, (dtl::block_addressing)0> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 4u, 2u, (dtl::block_addressing)0> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
  67b320:	push   %r15
  67b322:	push   %r14
  67b324:	mov    %rcx,%r14
  67b327:	push   %r13
  67b329:	mov    %rdx,%r13
  67b32c:	push   %r12
  67b32e:	push   %rbp
  67b32f:	push   %rbx
  67b330:	mov    %rdi,%rbx
  67b333:	sub    $0x18,%rsp
  67b337:	mov    %r8,0x8(%rsp)
  67b33c:	test   %esi,%esi
  67b33e:	je     67b3b0 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 4u, 2u, (dtl::block_addressing)0> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 4u, 2u, (dtl::block_addressing)0> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x90>
  67b340:	cmp    $0x1,%esi
  67b343:	mov    $0x1000,%ebp
  67b348:	mov    $0x1,%eax
  67b34d:	cmove  %rax,%rbp
  67b351:	test   %rdx,%rdx
  67b354:	je     67b3a1 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 4u, 2u, (dtl::block_addressing)0> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 4u, 2u, (dtl::block_addressing)0> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x81>
  67b356:	mov    %rdi,(%rsp)
  67b35a:	mov    %rbp,%rbx
  67b35d:	mov    0x8(%rsp),%rbp
  67b362:	mov    %rdx,%r15
  67b365:	xor    %r12d,%r12d
  67b368:	nopl   0x0(%rax,%rax,1)
  67b370:	lea    0x0(,%r12,4),%rdx
  67b378:	lea    0x0(%rbp,%rdx,1),%rcx
  67b37d:	mov    %rbx,%rax
  67b380:	add    %r14,%rdx
  67b383:	cmp    %rbx,%r15
  67b386:	cmovbe %r15,%rax
  67b38a:	mov    (%rsp),%rdi
  67b38e:	mov    %rax,%rsi
  67b391:	add    %rbx,%r12
  67b394:	call   67ac40 <void vldb_stage2::DenseCall<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 4u, 2u, (dtl::block_addressing)0> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 4u, 2u, (dtl::block_addressing)0> const&, unsigned int, unsigned int const*, unsigned int*)>
  67b399:	sub    %rbx,%r15
  67b39c:	cmp    %r13,%r12
  67b39f:	jb     67b370 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 4u, 2u, (dtl::block_addressing)0> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 4u, 2u, (dtl::block_addressing)0> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x50>
  67b3a1:	add    $0x18,%rsp
  67b3a5:	pop    %rbx
  67b3a6:	pop    %rbp
  67b3a7:	pop    %r12
  67b3a9:	pop    %r13
  67b3ab:	pop    %r14
  67b3ad:	pop    %r15
  67b3af:	ret
  67b3b0:	xor    %edi,%edi
  67b3b2:	mov    $0x1,%esi
  67b3b7:	test   %rdx,%rdx
  67b3ba:	je     67b3a1 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 4u, 2u, (dtl::block_addressing)0> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 4u, 2u, (dtl::block_addressing)0> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x81>
  67b3bc:	nopl   0x0(%rax)
  67b3c0:	mov    (%r14,%rdi,4),%eax
  67b3c4:	mov    $0x20,%ecx
  67b3c9:	imul   $0x238ef8e3,%eax,%edx
  67b3cf:	sub    0x4(%rbx),%ecx
  67b3d2:	shrx   %ecx,%edx,%edx
  67b3d7:	lea    0x0(,%rdx,8),%ecx
  67b3de:	mov    0x10(%rbx),%rdx
  67b3e2:	lea    (%rdx,%rcx,4),%rcx
  67b3e6:	imul   $0x16118b03,%eax,%edx
  67b3ec:	imul   $0x9e3779b9,%eax,%eax
  67b3f2:	mov    (%rcx),%r15d
  67b3f5:	mov    %edx,%r12d
  67b3f8:	shr    $0x1b,%r12d
  67b3fc:	shlx   %r12d,%esi,%r12d
  67b401:	mov    %edx,%ebp
  67b403:	and    %r12d,%r15d
  67b406:	mov    %edx,%r11d
  67b409:	mov    %edx,%r10d
  67b40c:	mov    %edx,%r9d
  67b40f:	mov    %eax,%r8d
  67b412:	shr    $0x16,%ebp
  67b415:	shr    $0x11,%r11d
  67b419:	shr    $0xc,%r10d
  67b41d:	shr    $0x7,%r9d
  67b421:	shr    $0x2,%edx
  67b424:	shr    $0x1b,%r8d
  67b428:	shr    $0x16,%eax
  67b42b:	cmp    %r12d,%r15d
  67b42e:	mov    0x4(%rcx),%r12d
  67b432:	sete   %r15b
  67b436:	shlx   %ebp,%esi,%ebp
  67b43b:	and    %ebp,%r12d
  67b43e:	cmp    %ebp,%r12d
  67b441:	mov    0x8(%rcx),%r12d
  67b445:	sete   %bpl
  67b449:	shlx   %r11d,%esi,%r11d
  67b44e:	and    %r11d,%r12d
  67b451:	and    %r15d,%ebp
  67b454:	cmp    %r11d,%r12d
  67b457:	sete   %r11b
  67b45b:	and    %ebp,%r11d
  67b45e:	mov    0xc(%rcx),%ebp
  67b461:	shlx   %r10d,%esi,%r10d
  67b466:	and    %r10d,%ebp
  67b469:	cmp    %r10d,%ebp
  67b46c:	sete   %r10b
  67b470:	and    %r11d,%r10d
  67b473:	mov    0x10(%rcx),%r11d
  67b477:	shlx   %r9d,%esi,%r9d
  67b47c:	and    %r9d,%r11d
  67b47f:	cmp    %r9d,%r11d
  67b482:	sete   %r9b
  67b486:	and    %r10d,%r9d
  67b489:	mov    0x14(%rcx),%r10d
  67b48d:	shlx   %edx,%esi,%edx
  67b492:	and    %edx,%r10d
  67b495:	cmp    %edx,%r10d
  67b498:	sete   %dl
  67b49b:	and    %r9d,%edx
  67b49e:	mov    0x18(%rcx),%r9d
  67b4a2:	shlx   %r8d,%esi,%r8d
  67b4a7:	and    %r8d,%r9d
  67b4aa:	cmp    %r8d,%r9d
  67b4ad:	sete   %r8b
  67b4b1:	and    %r8d,%edx
  67b4b4:	mov    0x1c(%rcx),%r8d
  67b4b8:	shlx   %eax,%esi,%eax
  67b4bd:	and    %eax,%r8d
  67b4c0:	cmp    %eax,%r8d
  67b4c3:	sete   %al
  67b4c6:	mov    0x8(%rsp),%rcx
  67b4cb:	movzbl %al,%eax
  67b4ce:	and    %edx,%eax
  67b4d0:	mov    %eax,(%rcx,%rdi,4)
  67b4d3:	inc    %rdi
  67b4d6:	cmp    %rdi,%r13
  67b4d9:	jne    67b3c0 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 4u, 2u, (dtl::block_addressing)0> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 4u, 2u, (dtl::block_addressing)0> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0xa0>
  67b4df:	add    $0x18,%rsp
  67b4e3:	pop    %rbx
  67b4e4:	pop    %rbp
  67b4e5:	pop    %r12
  67b4e7:	pop    %r13
  67b4e9:	pop    %r14
  67b4eb:	pop    %r15
  67b4ed:	ret
