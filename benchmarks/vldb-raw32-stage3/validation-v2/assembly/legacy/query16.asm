
/home/yiming/projects/fastest-bf-lab/build/vldb-raw32-stage3-v1/native/legacy:     file format elf64-x86-64


Disassembly of section .text:

0000000000690ff0 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 1u, 0u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 1u, 0u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
  690ff0:	push   %r15
  690ff2:	push   %r14
  690ff4:	push   %r13
  690ff6:	push   %r12
  690ff8:	mov    %rcx,%r12
  690ffb:	push   %rbp
  690ffc:	mov    %rdi,%rbp
  690fff:	push   %rbx
  691000:	mov    %rdx,%rbx
  691003:	sub    $0x18,%rsp
  691007:	mov    %r8,0x8(%rsp)
  69100c:	test   %esi,%esi
  69100e:	je     691078 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 1u, 0u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 1u, 0u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x88>
  691010:	cmp    $0x1,%esi
  691013:	mov    $0x1000,%r14d
  691019:	mov    $0x1,%eax
  69101e:	cmove  %rax,%r14
  691022:	test   %rdx,%rdx
  691025:	je     691064 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 1u, 0u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 1u, 0u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x74>
  691027:	mov    %rdx,%r13
  69102a:	xor    %r15d,%r15d
  69102d:	nopl   (%rax)
  691030:	mov    0x8(%rsp),%rax
  691035:	lea    0x0(,%r15,4),%rdx
  69103d:	lea    (%rax,%rdx,1),%rcx
  691041:	add    %r12,%rdx
  691044:	mov    %r14,%rax
  691047:	cmp    %r14,%r13
  69104a:	cmovbe %r13,%rax
  69104e:	mov    %rbp,%rdi
  691051:	mov    %rax,%rsi
  691054:	add    %r14,%r15
  691057:	call   690f70 <void vldb_stage2::DenseCall<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 1u, 0u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 1u, 0u, (dtl::block_addressing)2> const&, unsigned int, unsigned int const*, unsigned int*)>
  69105c:	sub    %r14,%r13
  69105f:	cmp    %rbx,%r15
  691062:	jb     691030 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 1u, 0u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 1u, 0u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x40>
  691064:	add    $0x18,%rsp
  691068:	pop    %rbx
  691069:	pop    %rbp
  69106a:	pop    %r12
  69106c:	pop    %r13
  69106e:	pop    %r14
  691070:	pop    %r15
  691072:	ret
  691073:	nopl   0x0(%rax,%rax,1)
  691078:	lea    0x8(%rdi),%r15
  69107c:	xor    %r14d,%r14d
  69107f:	test   %rdx,%rdx
  691082:	je     691064 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 1u, 0u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 1u, 0u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x74>
  691084:	nopl   0x0(%rax)
  691088:	mov    (%r12,%r14,4),%edx
  69108c:	mov    0x18(%rbp),%rsi
  691090:	mov    %r15,%rdi
  691093:	call   69c930 <dtl::bbf_64::contains(unsigned long const*, unsigned int) const>
  691098:	mov    0x8(%rsp),%rdi
  69109d:	movzbl %al,%eax
  6910a0:	mov    %eax,(%rdi,%r14,4)
  6910a4:	inc    %r14
  6910a7:	cmp    %r14,%rbx
  6910aa:	jne    691088 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 1u, 0u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 1u, 0u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x98>
  6910ac:	add    $0x18,%rsp
  6910b0:	pop    %rbx
  6910b1:	pop    %rbp
  6910b2:	pop    %r12
  6910b4:	pop    %r13
  6910b6:	pop    %r14
  6910b8:	pop    %r15
  6910ba:	ret
