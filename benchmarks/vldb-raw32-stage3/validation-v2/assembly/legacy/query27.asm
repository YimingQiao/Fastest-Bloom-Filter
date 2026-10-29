
/home/yiming/projects/fastest-bf-lab/build/vldb-raw32-stage3-v1/native/legacy:     file format elf64-x86-64


Disassembly of section .text:

0000000000682e00 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 4u, 2u, (dtl::block_addressing)1> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 4u, 2u, (dtl::block_addressing)1> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
  682e00:	push   %r15
  682e02:	push   %r14
  682e04:	mov    %rcx,%r14
  682e07:	push   %r13
  682e09:	mov    %rdx,%r13
  682e0c:	push   %r12
  682e0e:	push   %rbp
  682e0f:	push   %rbx
  682e10:	mov    %rdi,%rbx
  682e13:	sub    $0x18,%rsp
  682e17:	mov    %r8,0x8(%rsp)
  682e1c:	test   %esi,%esi
  682e1e:	je     682e90 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 4u, 2u, (dtl::block_addressing)1> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 4u, 2u, (dtl::block_addressing)1> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x90>
  682e20:	cmp    $0x1,%esi
  682e23:	mov    $0x1000,%ebp
  682e28:	mov    $0x1,%eax
  682e2d:	cmove  %rax,%rbp
  682e31:	test   %rdx,%rdx
  682e34:	je     682e81 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 4u, 2u, (dtl::block_addressing)1> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 4u, 2u, (dtl::block_addressing)1> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x81>
  682e36:	mov    %rdi,(%rsp)
  682e3a:	mov    %rbp,%rbx
  682e3d:	mov    0x8(%rsp),%rbp
  682e42:	mov    %rdx,%r15
  682e45:	xor    %r12d,%r12d
  682e48:	nopl   0x0(%rax,%rax,1)
  682e50:	lea    0x0(,%r12,4),%rdx
  682e58:	lea    0x0(%rbp,%rdx,1),%rcx
  682e5d:	mov    %rbx,%rax
  682e60:	add    %r14,%rdx
  682e63:	cmp    %rbx,%r15
  682e66:	cmovbe %r15,%rax
  682e6a:	mov    (%rsp),%rdi
  682e6e:	mov    %rax,%rsi
  682e71:	add    %rbx,%r12
  682e74:	call   682490 <void vldb_stage2::DenseCall<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 4u, 2u, (dtl::block_addressing)1> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 4u, 2u, (dtl::block_addressing)1> const&, unsigned int, unsigned int const*, unsigned int*)>
  682e79:	sub    %rbx,%r15
  682e7c:	cmp    %r13,%r12
  682e7f:	jb     682e50 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 4u, 2u, (dtl::block_addressing)1> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 4u, 2u, (dtl::block_addressing)1> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x50>
  682e81:	add    $0x18,%rsp
  682e85:	pop    %rbx
  682e86:	pop    %rbp
  682e87:	pop    %r12
  682e89:	pop    %r13
  682e8b:	pop    %r14
  682e8d:	pop    %r15
  682e8f:	ret
  682e90:	xor    %edi,%edi
  682e92:	mov    $0x1,%esi
  682e97:	test   %rdx,%rdx
  682e9a:	je     682e81 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 4u, 2u, (dtl::block_addressing)1> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 4u, 2u, (dtl::block_addressing)1> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x81>
  682e9c:	nopl   0x0(%rax)
  682ea0:	mov    (%r14,%rdi,4),%eax
  682ea4:	mov    0xc(%rbx),%edx
  682ea7:	imul   $0x238ef8e3,%eax,%r8d
  682eae:	imul   %r8,%rdx
  682eb2:	mov    %r8,%rcx
  682eb5:	mov    0x10(%rbx),%r8d
  682eb9:	shr    $0x20,%rdx
  682ebd:	shrx   %r8d,%edx,%edx
  682ec2:	imul   0x14(%rbx),%edx
  682ec6:	sub    %edx,%ecx
  682ec8:	mov    0x18(%rbx),%rdx
  682ecc:	lea    0x0(,%rcx,8),%ecx
  682ed3:	lea    (%rdx,%rcx,8),%rcx
  682ed7:	imul   $0x16118b03,%eax,%edx
  682edd:	imul   $0x9e3779b9,%eax,%eax
  682ee3:	mov    (%rcx),%r15
  682ee6:	mov    %edx,%r12d
  682ee9:	shr    $0x1a,%r12d
  682eed:	shlx   %r12,%rsi,%r12
  682ef2:	mov    %edx,%ebp
  682ef4:	and    %r12,%r15
  682ef7:	mov    %edx,%r11d
  682efa:	mov    %edx,%r10d
  682efd:	mov    %eax,%r9d
  682f00:	mov    %eax,%r8d
  682f03:	shr    $0x14,%ebp
  682f06:	shr    $0xe,%r11d
  682f0a:	shr    $0x8,%r10d
  682f0e:	shr    $0x2,%edx
  682f11:	shr    $0x1a,%r9d
  682f15:	shr    $0x14,%r8d
  682f19:	shr    $0xe,%eax
  682f1c:	cmp    %r12,%r15
  682f1f:	mov    0x8(%rcx),%r12
  682f23:	sete   %r15b
  682f27:	shlx   %rbp,%rsi,%rbp
  682f2c:	and    %rbp,%r12
  682f2f:	cmp    %rbp,%r12
  682f32:	mov    0x10(%rcx),%r12
  682f36:	sete   %bpl
  682f3a:	shlx   %r11,%rsi,%r11
  682f3f:	and    %r11,%r12
  682f42:	and    %r15d,%ebp
  682f45:	cmp    %r11,%r12
  682f48:	sete   %r11b
  682f4c:	and    %ebp,%r11d
  682f4f:	mov    0x18(%rcx),%rbp
  682f53:	shlx   %r10,%rsi,%r10
  682f58:	and    %r10,%rbp
  682f5b:	cmp    %r10,%rbp
  682f5e:	sete   %r10b
  682f62:	and    %r11d,%r10d
  682f65:	mov    0x20(%rcx),%r11
  682f69:	shlx   %rdx,%rsi,%rdx
  682f6e:	and    %rdx,%r11
  682f71:	cmp    %rdx,%r11
  682f74:	sete   %dl
  682f77:	and    %r10d,%edx
  682f7a:	mov    0x28(%rcx),%r10
  682f7e:	shlx   %r9,%rsi,%r9
  682f83:	and    %r9,%r10
  682f86:	cmp    %r9,%r10
  682f89:	sete   %r9b
  682f8d:	and    %r9d,%edx
  682f90:	mov    0x30(%rcx),%r9
  682f94:	mov    0x38(%rcx),%r15
  682f98:	shlx   %r8,%rsi,%r8
  682f9d:	and    %r8,%r9
  682fa0:	cmp    %r8,%r9
  682fa3:	sete   %r8b
  682fa7:	shlx   %rax,%rsi,%rax
  682fac:	and    %rax,%r15
  682faf:	and    %r8d,%edx
  682fb2:	cmp    %rax,%r15
  682fb5:	sete   %al
  682fb8:	mov    0x8(%rsp),%rcx
  682fbd:	movzbl %al,%eax
  682fc0:	and    %edx,%eax
  682fc2:	mov    %eax,(%rcx,%rdi,4)
  682fc5:	inc    %rdi
  682fc8:	cmp    %rdi,%r13
  682fcb:	jne    682ea0 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 4u, 2u, (dtl::block_addressing)1> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 4u, 2u, (dtl::block_addressing)1> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0xa0>
  682fd1:	add    $0x18,%rsp
  682fd5:	pop    %rbx
  682fd6:	pop    %rbp
  682fd7:	pop    %r12
  682fd9:	pop    %r13
  682fdb:	pop    %r14
  682fdd:	pop    %r15
  682fdf:	ret
