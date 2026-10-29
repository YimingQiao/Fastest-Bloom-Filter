
/home/yiming/projects/fastest-bf-lab/build/vldb-nearby-raw32-v1/native/nearby_raw32:     file format elf64-x86-64


Disassembly of section .text:

0000000000391570 <void vldb_stage2::DenseCall<nearby_raw32::PublicFilter<unsigned int, 8u, 4u, true> >(nearby_raw32::PublicFilter<unsigned int, 8u, 4u, true> const&, unsigned int, unsigned int const*, unsigned int*)>:
  391570:	test   %esi,%esi
  391572:	jne    391578 <void vldb_stage2::DenseCall<nearby_raw32::PublicFilter<unsigned int, 8u, 4u, true> >(nearby_raw32::PublicFilter<unsigned int, 8u, 4u, true> const&, unsigned int, unsigned int const*, unsigned int*)+0x8>
  391574:	ret
  391575:	nopl   (%rax)
  391578:	push   %r13
  39157a:	add    $0x8,%rdi
  39157e:	xor    %r9d,%r9d
  391581:	push   %r12
  391583:	mov    %esi,%r12d
  391586:	push   %rbp
  391587:	mov    %rcx,%rbp
  39158a:	mov    %r12d,%ecx
  39158d:	push   %rbx
  39158e:	sub    $0x8,%rsp
  391592:	mov    0x120(%rdi),%rbx
  391599:	mov    0x10(%rdi),%rsi
  39159d:	mov    %rbx,%r8
  3915a0:	call   39c210 <dtl::bbf_32::batch_contains(unsigned long const*, unsigned int const*, unsigned int, unsigned int*, unsigned int) const>
  3915a5:	mov    %r12d,%edx
  3915a8:	mov    %rax,%r13
  3915ab:	shl    $0x2,%rdx
  3915af:	xor    %esi,%esi
  3915b1:	mov    %rbp,%rdi
  3915b4:	call   1906a10 <memset@plt>
  3915b9:	test   %r13,%r13
  3915bc:	je     3915dc <void vldb_stage2::DenseCall<nearby_raw32::PublicFilter<unsigned int, 8u, 4u, true> >(nearby_raw32::PublicFilter<unsigned int, 8u, 4u, true> const&, unsigned int, unsigned int const*, unsigned int*)+0x6c>
  3915be:	mov    %rbx,%r8
  3915c1:	lea    (%rbx,%r13,4),%rdx
  3915c5:	nopl   (%rax)
  3915c8:	mov    (%r8),%eax
  3915cb:	add    $0x4,%r8
  3915cf:	movl   $0x1,0x0(%rbp,%rax,4)
  3915d7:	cmp    %r8,%rdx
  3915da:	jne    3915c8 <void vldb_stage2::DenseCall<nearby_raw32::PublicFilter<unsigned int, 8u, 4u, true> >(nearby_raw32::PublicFilter<unsigned int, 8u, 4u, true> const&, unsigned int, unsigned int const*, unsigned int*)+0x58>
  3915dc:	add    $0x8,%rsp
  3915e0:	pop    %rbx
  3915e1:	pop    %rbp
  3915e2:	pop    %r12
  3915e4:	pop    %r13
  3915e6:	ret
