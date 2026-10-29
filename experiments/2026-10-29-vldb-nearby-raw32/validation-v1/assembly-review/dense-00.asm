
/home/yiming/projects/fastest-bf-lab/build/vldb-nearby-raw32-v1/native/nearby_raw32:     file format elf64-x86-64


Disassembly of section .text:

0000000000390e50 <void vldb_stage2::DenseCall<nearby_raw32::PublicFilter<unsigned int, 8u, 1u, false> >(nearby_raw32::PublicFilter<unsigned int, 8u, 1u, false> const&, unsigned int, unsigned int const*, unsigned int*)>:
  390e50:	test   %esi,%esi
  390e52:	jne    390e58 <void vldb_stage2::DenseCall<nearby_raw32::PublicFilter<unsigned int, 8u, 1u, false> >(nearby_raw32::PublicFilter<unsigned int, 8u, 1u, false> const&, unsigned int, unsigned int const*, unsigned int*)+0x8>
  390e54:	ret
  390e55:	nopl   (%rax)
  390e58:	push   %r13
  390e5a:	add    $0x8,%rdi
  390e5e:	xor    %r9d,%r9d
  390e61:	push   %r12
  390e63:	mov    %esi,%r12d
  390e66:	push   %rbp
  390e67:	mov    %rcx,%rbp
  390e6a:	mov    %r12d,%ecx
  390e6d:	push   %rbx
  390e6e:	sub    $0x8,%rsp
  390e72:	mov    0x120(%rdi),%rbx
  390e79:	mov    0x10(%rdi),%rsi
  390e7d:	mov    %rbx,%r8
  390e80:	call   39c210 <dtl::bbf_32::batch_contains(unsigned long const*, unsigned int const*, unsigned int, unsigned int*, unsigned int) const>
  390e85:	mov    %r12d,%edx
  390e88:	mov    %rax,%r13
  390e8b:	shl    $0x2,%rdx
  390e8f:	xor    %esi,%esi
  390e91:	mov    %rbp,%rdi
  390e94:	call   1906a10 <memset@plt>
  390e99:	test   %r13,%r13
  390e9c:	je     390ebc <void vldb_stage2::DenseCall<nearby_raw32::PublicFilter<unsigned int, 8u, 1u, false> >(nearby_raw32::PublicFilter<unsigned int, 8u, 1u, false> const&, unsigned int, unsigned int const*, unsigned int*)+0x6c>
  390e9e:	mov    %rbx,%r8
  390ea1:	lea    (%rbx,%r13,4),%rdx
  390ea5:	nopl   (%rax)
  390ea8:	mov    (%r8),%eax
  390eab:	add    $0x4,%r8
  390eaf:	movl   $0x1,0x0(%rbp,%rax,4)
  390eb7:	cmp    %r8,%rdx
  390eba:	jne    390ea8 <void vldb_stage2::DenseCall<nearby_raw32::PublicFilter<unsigned int, 8u, 1u, false> >(nearby_raw32::PublicFilter<unsigned int, 8u, 1u, false> const&, unsigned int, unsigned int const*, unsigned int*)+0x58>
  390ebc:	add    $0x8,%rsp
  390ec0:	pop    %rbx
  390ec1:	pop    %rbp
  390ec2:	pop    %r12
  390ec4:	pop    %r13
  390ec6:	ret
