
/home/yiming/projects/fastest-bf-lab/build/vldb-nearby-raw32-v1/native/nearby_raw32:     file format elf64-x86-64


Disassembly of section .text:

000000000039ae80 <void vldb_stage2::DenseCall<nearby_raw32::PublicFilter<unsigned long, 8u, 1u, false> >(nearby_raw32::PublicFilter<unsigned long, 8u, 1u, false> const&, unsigned int, unsigned int const*, unsigned int*)>:
  39ae80:	test   %esi,%esi
  39ae82:	jne    39ae88 <void vldb_stage2::DenseCall<nearby_raw32::PublicFilter<unsigned long, 8u, 1u, false> >(nearby_raw32::PublicFilter<unsigned long, 8u, 1u, false> const&, unsigned int, unsigned int const*, unsigned int*)+0x8>
  39ae84:	ret
  39ae85:	nopl   (%rax)
  39ae88:	push   %r13
  39ae8a:	add    $0x8,%rdi
  39ae8e:	xor    %r9d,%r9d
  39ae91:	push   %r12
  39ae93:	mov    %esi,%r12d
  39ae96:	push   %rbp
  39ae97:	mov    %rcx,%rbp
  39ae9a:	mov    %r12d,%ecx
  39ae9d:	push   %rbx
  39ae9e:	sub    $0x8,%rsp
  39aea2:	mov    0x120(%rdi),%rbx
  39aea9:	mov    0x10(%rdi),%rsi
  39aead:	mov    %rbx,%r8
  39aeb0:	call   4f51d0 <dtl::bbf_64::batch_contains(unsigned long const*, unsigned int const*, unsigned int, unsigned int*, unsigned int) const>
  39aeb5:	mov    %r12d,%edx
  39aeb8:	mov    %rax,%r13
  39aebb:	shl    $0x2,%rdx
  39aebf:	xor    %esi,%esi
  39aec1:	mov    %rbp,%rdi
  39aec4:	call   1906a10 <memset@plt>
  39aec9:	test   %r13,%r13
  39aecc:	je     39aeec <void vldb_stage2::DenseCall<nearby_raw32::PublicFilter<unsigned long, 8u, 1u, false> >(nearby_raw32::PublicFilter<unsigned long, 8u, 1u, false> const&, unsigned int, unsigned int const*, unsigned int*)+0x6c>
  39aece:	mov    %rbx,%r8
  39aed1:	lea    (%rbx,%r13,4),%rdx
  39aed5:	nopl   (%rax)
  39aed8:	mov    (%r8),%eax
  39aedb:	add    $0x4,%r8
  39aedf:	movl   $0x1,0x0(%rbp,%rax,4)
  39aee7:	cmp    %r8,%rdx
  39aeea:	jne    39aed8 <void vldb_stage2::DenseCall<nearby_raw32::PublicFilter<unsigned long, 8u, 1u, false> >(nearby_raw32::PublicFilter<unsigned long, 8u, 1u, false> const&, unsigned int, unsigned int const*, unsigned int*)+0x58>
  39aeec:	add    $0x8,%rsp
  39aef0:	pop    %rbx
  39aef1:	pop    %rbp
  39aef2:	pop    %r12
  39aef4:	pop    %r13
  39aef6:	ret
