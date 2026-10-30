
/home/yiming/projects/fastest-bf-lab/build/vldb-raw32-stage3-v1/native/legacy:     file format elf64-x86-64


Disassembly of section .text:

00000000004bcd00 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 4u, 1u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 4u, 1u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
  4bcd00:	push   %r15
  4bcd02:	push   %r14
  4bcd04:	push   %r13
  4bcd06:	push   %r12
  4bcd08:	mov    %rcx,%r12
  4bcd0b:	push   %rbp
  4bcd0c:	mov    %rdx,%rbp
  4bcd0f:	push   %rbx
  4bcd10:	mov    %rdi,%rbx
  4bcd13:	sub    $0x28,%rsp
  4bcd17:	mov    %r8,0x8(%rsp)
  4bcd1c:	test   %esi,%esi
  4bcd1e:	je     4bcd88 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 4u, 1u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 4u, 1u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x88>
  4bcd20:	cmp    $0x1,%esi
  4bcd23:	mov    $0x1000,%r14d
  4bcd29:	mov    $0x1,%eax
  4bcd2e:	cmove  %rax,%r14
  4bcd32:	test   %rdx,%rdx
  4bcd35:	je     4bcd74 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 4u, 1u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 4u, 1u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x74>
  4bcd37:	mov    %rdx,%r13
  4bcd3a:	xor    %r15d,%r15d
  4bcd3d:	nopl   (%rax)
  4bcd40:	mov    0x8(%rsp),%rax
  4bcd45:	lea    0x0(,%r15,4),%rdx
  4bcd4d:	lea    (%rax,%rdx,1),%rcx
  4bcd51:	add    %r12,%rdx
  4bcd54:	mov    %r14,%rax
  4bcd57:	cmp    %r14,%r13
  4bcd5a:	cmovbe %r13,%rax
  4bcd5e:	mov    %rbx,%rdi
  4bcd61:	mov    %rax,%rsi
  4bcd64:	add    %r14,%r15
  4bcd67:	call   4bcc40 <void vldb_stage2::DenseCall<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 4u, 1u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 4u, 1u, (dtl::block_addressing)2> const&, unsigned int, unsigned int const*, unsigned int*)>
  4bcd6c:	sub    %r14,%r13
  4bcd6f:	cmp    %rbp,%r15
  4bcd72:	jb     4bcd40 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 4u, 1u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 4u, 1u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x40>
  4bcd74:	add    $0x28,%rsp
  4bcd78:	pop    %rbx
  4bcd79:	pop    %rbp
  4bcd7a:	pop    %r12
  4bcd7c:	pop    %r13
  4bcd7e:	pop    %r14
  4bcd80:	pop    %r15
  4bcd82:	ret
  4bcd83:	nopl   0x0(%rax,%rax,1)
  4bcd88:	xor    %r14d,%r14d
  4bcd8b:	lea    0x14(%rsp),%r15
  4bcd90:	test   %rdx,%rdx
  4bcd93:	je     4bcd74 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 4u, 1u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 4u, 1u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x74>
  4bcd95:	nopl   (%rax)
  4bcd98:	mov    (%r12,%r14,4),%eax
  4bcd9c:	mov    0xc0(%rbx),%rdx
  4bcda3:	cmpq   $0x0,0x90(%rbx)
  4bcdab:	mov    %rdx,0x18(%rsp)
  4bcdb0:	mov    %eax,0x14(%rsp)
  4bcdb4:	je     4bcdee <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 4u, 1u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 4u, 1u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0xee>
  4bcdb6:	lea    0x80(%rbx),%rdi
  4bcdbd:	lea    0x18(%rsp),%rsi
  4bcdc2:	mov    %r15,%rdx
  4bcdc5:	call   *0x98(%rbx)
  4bcdcb:	mov    0x8(%rsp),%rdi
  4bcdd0:	movzbl %al,%eax
  4bcdd3:	mov    %eax,(%rdi,%r14,4)
  4bcdd7:	inc    %r14
  4bcdda:	cmp    %r14,%rbp
  4bcddd:	jne    4bcd98 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 4u, 1u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 4u, 1u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x98>
  4bcddf:	add    $0x28,%rsp
  4bcde3:	pop    %rbx
  4bcde4:	pop    %rbp
  4bcde5:	pop    %r12
  4bcde7:	pop    %r13
  4bcde9:	pop    %r14
  4bcdeb:	pop    %r15
  4bcded:	ret
  4bcdee:	call   1948ca0 <std::__throw_bad_function_call()@plt>
