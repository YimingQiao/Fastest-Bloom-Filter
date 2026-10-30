
/home/yiming/projects/fastest-bf-lab/build/vldb-nearby-raw32-v1/native/nearby_raw32:     file format elf64-x86-64


Disassembly of section .text:

000000000039b140 <void vldb_stage2::DenseCall<nearby_raw32::PublicFilter<unsigned long, 8u, 4u, false> >(nearby_raw32::PublicFilter<unsigned long, 8u, 4u, false> const&, unsigned int, unsigned int const*, unsigned int*)>:
  39b140:	test   %esi,%esi
  39b142:	jne    39b148 <void vldb_stage2::DenseCall<nearby_raw32::PublicFilter<unsigned long, 8u, 4u, false> >(nearby_raw32::PublicFilter<unsigned long, 8u, 4u, false> const&, unsigned int, unsigned int const*, unsigned int*)+0x8>
  39b144:	ret
  39b145:	nopl   (%rax)
  39b148:	push   %r13
  39b14a:	add    $0x8,%rdi
  39b14e:	xor    %r9d,%r9d
  39b151:	push   %r12
  39b153:	mov    %esi,%r12d
  39b156:	push   %rbp
  39b157:	mov    %rcx,%rbp
  39b15a:	mov    %r12d,%ecx
  39b15d:	push   %rbx
  39b15e:	sub    $0x8,%rsp
  39b162:	mov    0x120(%rdi),%rbx
  39b169:	mov    0x10(%rdi),%rsi
  39b16d:	mov    %rbx,%r8
  39b170:	call   4f51d0 <dtl::bbf_64::batch_contains(unsigned long const*, unsigned int const*, unsigned int, unsigned int*, unsigned int) const>
  39b175:	mov    %r12d,%edx
  39b178:	mov    %rax,%r13
  39b17b:	shl    $0x2,%rdx
  39b17f:	xor    %esi,%esi
  39b181:	mov    %rbp,%rdi
  39b184:	call   1906a10 <memset@plt>
  39b189:	test   %r13,%r13
  39b18c:	je     39b1ac <void vldb_stage2::DenseCall<nearby_raw32::PublicFilter<unsigned long, 8u, 4u, false> >(nearby_raw32::PublicFilter<unsigned long, 8u, 4u, false> const&, unsigned int, unsigned int const*, unsigned int*)+0x6c>
  39b18e:	mov    %rbx,%r8
  39b191:	lea    (%rbx,%r13,4),%rdx
  39b195:	nopl   (%rax)
  39b198:	mov    (%r8),%eax
  39b19b:	add    $0x4,%r8
  39b19f:	movl   $0x1,0x0(%rbp,%rax,4)
  39b1a7:	cmp    %r8,%rdx
  39b1aa:	jne    39b198 <void vldb_stage2::DenseCall<nearby_raw32::PublicFilter<unsigned long, 8u, 4u, false> >(nearby_raw32::PublicFilter<unsigned long, 8u, 4u, false> const&, unsigned int, unsigned int const*, unsigned int*)+0x58>
  39b1ac:	add    $0x8,%rsp
  39b1b0:	pop    %rbx
  39b1b1:	pop    %rbp
  39b1b2:	pop    %r12
  39b1b4:	pop    %r13
  39b1b6:	ret
