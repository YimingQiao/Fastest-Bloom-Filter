
/home/yiming/projects/fastest-bf-lab/build/vldb-raw32-stage3-v2/native/modern:     file format elf64-x86-64


Disassembly of section .text:

0000000000031b40 <void vldb_stage2::Query<raw32_stage3::RawPage<6u, false> >(raw32_stage3::RawPage<6u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
   31b40:	push   %r15
   31b42:	push   %r14
   31b44:	push   %r13
   31b46:	mov    %r8,%r13
   31b49:	push   %r12
   31b4b:	mov    %rcx,%r12
   31b4e:	push   %rbp
   31b4f:	push   %rbx
   31b50:	mov    %rdx,%rbx
   31b53:	sub    $0x28,%rsp
   31b57:	mov    %rdi,0x8(%rsp)
   31b5c:	test   %esi,%esi
   31b5e:	je     31bc8 <void vldb_stage2::Query<raw32_stage3::RawPage<6u, false> >(raw32_stage3::RawPage<6u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x88>
   31b60:	cmp    $0x1,%esi
   31b63:	mov    $0x1000,%r14d
   31b69:	mov    $0x1,%eax
   31b6e:	cmove  %rax,%r14
   31b72:	test   %rdx,%rdx
   31b75:	je     31bb2 <void vldb_stage2::Query<raw32_stage3::RawPage<6u, false> >(raw32_stage3::RawPage<6u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x72>
   31b77:	mov    %rdx,%rbp
   31b7a:	xor    %r15d,%r15d
   31b7d:	nopl   (%rax)
   31b80:	lea    0x0(,%r15,4),%rdx
   31b88:	lea    0x0(%r13,%rdx,1),%rcx
   31b8d:	mov    %r14,%rax
   31b90:	add    %r12,%rdx
   31b93:	cmp    %r14,%rbp
   31b96:	cmovbe %rbp,%rax
   31b9a:	mov    0x8(%rsp),%rdi
   31b9f:	mov    %rax,%rsi
   31ba2:	add    %r14,%r15
   31ba5:	call   319e0 <void vldb_stage2::DenseCall<raw32_stage3::RawPage<6u, false> >(raw32_stage3::RawPage<6u, false> const&, unsigned int, unsigned int const*, unsigned int*)>
   31baa:	sub    %r14,%rbp
   31bad:	cmp    %rbx,%r15
   31bb0:	jb     31b80 <void vldb_stage2::Query<raw32_stage3::RawPage<6u, false> >(raw32_stage3::RawPage<6u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x40>
   31bb2:	add    $0x28,%rsp
   31bb6:	pop    %rbx
   31bb7:	pop    %rbp
   31bb8:	pop    %r12
   31bba:	pop    %r13
   31bbc:	pop    %r14
   31bbe:	pop    %r15
   31bc0:	ret
   31bc1:	nopl   0x0(%rax)
   31bc8:	xor    %r9d,%r9d
   31bcb:	lea    0x1c(%rsp),%r10
   31bd0:	test   %rdx,%rdx
   31bd3:	je     31bb2 <void vldb_stage2::Query<raw32_stage3::RawPage<6u, false> >(raw32_stage3::RawPage<6u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x72>
   31bd5:	nopl   (%rax)
   31bd8:	mov    (%r12,%r9,4),%eax
   31bdc:	mov    0x8(%rsp),%rdi
   31be1:	mov    %r10,%rsi
   31be4:	mov    %eax,0x1c(%rsp)
   31be8:	call   bfa0 <pbf::PageBloomFilter<6u>::test(unsigned char const*, unsigned int) const [clone .constprop.0]>
   31bed:	movzbl %al,%eax
   31bf0:	mov    %eax,0x0(%r13,%r9,4)
   31bf5:	inc    %r9
   31bf8:	cmp    %r9,%rbx
   31bfb:	jne    31bd8 <void vldb_stage2::Query<raw32_stage3::RawPage<6u, false> >(raw32_stage3::RawPage<6u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x98>
   31bfd:	add    $0x28,%rsp
   31c01:	pop    %rbx
   31c02:	pop    %rbp
   31c03:	pop    %r12
   31c05:	pop    %r13
   31c07:	pop    %r14
   31c09:	pop    %r15
   31c0b:	ret
