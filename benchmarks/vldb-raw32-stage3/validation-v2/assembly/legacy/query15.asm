
/home/yiming/projects/fastest-bf-lab/build/vldb-raw32-stage3-v1/native/legacy:     file format elf64-x86-64


Disassembly of section .text:

00000000004bda60 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 1u, 1u, 0u, 2u, (dtl::block_addressing)1> >(raw32_stage3::RawOriginal<unsigned long, 1u, 1u, 0u, 2u, (dtl::block_addressing)1> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
  4bda60:	push   %r15
  4bda62:	push   %r14
  4bda64:	push   %r13
  4bda66:	mov    %rdi,%r13
  4bda69:	push   %r12
  4bda6b:	push   %rbp
  4bda6c:	mov    %rcx,%rbp
  4bda6f:	push   %rbx
  4bda70:	mov    %rdx,%rbx
  4bda73:	sub    $0x18,%rsp
  4bda77:	mov    %r8,0x8(%rsp)
  4bda7c:	test   %esi,%esi
  4bda7e:	je     4bdae8 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 1u, 1u, 0u, 2u, (dtl::block_addressing)1> >(raw32_stage3::RawOriginal<unsigned long, 1u, 1u, 0u, 2u, (dtl::block_addressing)1> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x88>
  4bda80:	cmp    $0x1,%esi
  4bda83:	mov    $0x1000,%r14d
  4bda89:	mov    $0x1,%eax
  4bda8e:	cmove  %rax,%r14
  4bda92:	test   %rdx,%rdx
  4bda95:	je     4bdad4 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 1u, 1u, 0u, 2u, (dtl::block_addressing)1> >(raw32_stage3::RawOriginal<unsigned long, 1u, 1u, 0u, 2u, (dtl::block_addressing)1> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x74>
  4bda97:	mov    %rdx,%r12
  4bda9a:	xor    %r15d,%r15d
  4bda9d:	nopl   (%rax)
  4bdaa0:	mov    0x8(%rsp),%rax
  4bdaa5:	lea    0x0(,%r15,4),%rdx
  4bdaad:	lea    (%rax,%rdx,1),%rcx
  4bdab1:	add    %rbp,%rdx
  4bdab4:	mov    %r14,%rax
  4bdab7:	cmp    %r14,%r12
  4bdaba:	cmovbe %r12,%rax
  4bdabe:	mov    %r13,%rdi
  4bdac1:	mov    %rax,%rsi
  4bdac4:	add    %r14,%r15
  4bdac7:	call   4bd5c0 <void vldb_stage2::DenseCall<raw32_stage3::RawOriginal<unsigned long, 1u, 1u, 0u, 2u, (dtl::block_addressing)1> >(raw32_stage3::RawOriginal<unsigned long, 1u, 1u, 0u, 2u, (dtl::block_addressing)1> const&, unsigned int, unsigned int const*, unsigned int*)>
  4bdacc:	sub    %r14,%r12
  4bdacf:	cmp    %rbx,%r15
  4bdad2:	jb     4bdaa0 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 1u, 1u, 0u, 2u, (dtl::block_addressing)1> >(raw32_stage3::RawOriginal<unsigned long, 1u, 1u, 0u, 2u, (dtl::block_addressing)1> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x40>
  4bdad4:	add    $0x18,%rsp
  4bdad8:	pop    %rbx
  4bdad9:	pop    %rbp
  4bdada:	pop    %r12
  4bdadc:	pop    %r13
  4bdade:	pop    %r14
  4bdae0:	pop    %r15
  4bdae2:	ret
  4bdae3:	nopl   0x0(%rax,%rax,1)
  4bdae8:	xor    %ecx,%ecx
  4bdaea:	mov    $0x1,%edx
  4bdaef:	test   %rbx,%rbx
  4bdaf2:	je     4bdad4 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 1u, 1u, 0u, 2u, (dtl::block_addressing)1> >(raw32_stage3::RawOriginal<unsigned long, 1u, 1u, 0u, 2u, (dtl::block_addressing)1> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x74>
  4bdaf4:	nopl   0x0(%rax)
  4bdaf8:	mov    0x0(%rbp,%rcx,4),%edi
  4bdafc:	imul   $0x16118b03,%edi,%r8d
  4bdb03:	imul   $0x238ef8e3,%edi,%esi
  4bdb09:	imul   $0x9e3779b9,%edi,%edi
  4bdb0f:	mov    %r8d,%r9d
  4bdb12:	shr    $0x1a,%r9d
  4bdb16:	mov    %edi,%eax
  4bdb18:	shr    $0x1a,%eax
  4bdb1b:	shlx   %rax,%rdx,%rax
  4bdb20:	bts    %r9,%rax
  4bdb24:	mov    %r8d,%r9d
  4bdb27:	shr    $0x14,%r9d
  4bdb2b:	shlx   %r9,%rdx,%r9
  4bdb30:	or     %r9,%rax
  4bdb33:	mov    %r8d,%r9d
  4bdb36:	shr    $0xe,%r9d
  4bdb3a:	shlx   %r9,%rdx,%r9
  4bdb3f:	or     %r9,%rax
  4bdb42:	mov    %r8d,%r9d
  4bdb45:	shr    $0x8,%r9d
  4bdb49:	shr    $0x2,%r8d
  4bdb4d:	shlx   %r9,%rdx,%r9
  4bdb52:	or     %r9,%rax
  4bdb55:	shlx   %r8,%rdx,%r8
  4bdb5a:	or     %r8,%rax
  4bdb5d:	mov    %edi,%r8d
  4bdb60:	shr    $0x14,%r8d
  4bdb64:	shr    $0xe,%edi
  4bdb67:	shlx   %r8,%rdx,%r8
  4bdb6c:	or     %r8,%rax
  4bdb6f:	shlx   %rdi,%rdx,%rdi
  4bdb74:	or     %rdi,%rax
  4bdb77:	mov    0xc(%r13),%edi
  4bdb7b:	mov    %esi,%r8d
  4bdb7e:	imul   %r8,%rdi
  4bdb82:	mov    0x10(%r13),%r8d
  4bdb86:	shr    $0x20,%rdi
  4bdb8a:	shrx   %r8d,%edi,%edi
  4bdb8f:	imul   0x14(%r13),%edi
  4bdb94:	sub    %edi,%esi
  4bdb96:	mov    0x18(%r13),%rdi
  4bdb9a:	mov    (%rdi,%rsi,8),%r10
  4bdb9e:	mov    0x8(%rsp),%rsi
  4bdba3:	and    %rax,%r10
  4bdba6:	cmp    %rax,%r10
  4bdba9:	sete   %al
  4bdbac:	movzbl %al,%eax
  4bdbaf:	mov    %eax,(%rsi,%rcx,4)
  4bdbb2:	inc    %rcx
  4bdbb5:	cmp    %rcx,%rbx
  4bdbb8:	jne    4bdaf8 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 1u, 1u, 0u, 2u, (dtl::block_addressing)1> >(raw32_stage3::RawOriginal<unsigned long, 1u, 1u, 0u, 2u, (dtl::block_addressing)1> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x98>
  4bdbbe:	add    $0x18,%rsp
  4bdbc2:	pop    %rbx
  4bdbc3:	pop    %rbp
  4bdbc4:	pop    %r12
  4bdbc6:	pop    %r13
  4bdbc8:	pop    %r14
  4bdbca:	pop    %r15
  4bdbcc:	ret
