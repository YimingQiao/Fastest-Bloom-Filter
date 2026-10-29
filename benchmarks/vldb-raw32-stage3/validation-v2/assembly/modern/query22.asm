
/home/yiming/projects/fastest-bf-lab/build/vldb-raw32-stage3-v2/native/modern:     file format elf64-x86-64


Disassembly of section .text:

0000000000032980 <void vldb_stage2::Query<raw32_stage3::RawPage<8u, true> >(raw32_stage3::RawPage<8u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
   32980:	push   %r15
   32982:	push   %r14
   32984:	push   %r13
   32986:	mov    %r8,%r13
   32989:	push   %r12
   3298b:	mov    %rcx,%r12
   3298e:	push   %rbp
   3298f:	push   %rbx
   32990:	mov    %rdx,%rbx
   32993:	sub    $0x28,%rsp
   32997:	mov    %rdi,0x8(%rsp)
   3299c:	test   %esi,%esi
   3299e:	je     32a08 <void vldb_stage2::Query<raw32_stage3::RawPage<8u, true> >(raw32_stage3::RawPage<8u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x88>
   329a0:	cmp    $0x1,%esi
   329a3:	mov    $0x1000,%r14d
   329a9:	mov    $0x1,%eax
   329ae:	cmove  %rax,%r14
   329b2:	test   %rdx,%rdx
   329b5:	je     329f2 <void vldb_stage2::Query<raw32_stage3::RawPage<8u, true> >(raw32_stage3::RawPage<8u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x72>
   329b7:	mov    %rdx,%rbp
   329ba:	xor    %r15d,%r15d
   329bd:	nopl   (%rax)
   329c0:	lea    0x0(,%r15,4),%rdx
   329c8:	lea    0x0(%r13,%rdx,1),%rcx
   329cd:	mov    %r14,%rax
   329d0:	add    %r12,%rdx
   329d3:	cmp    %r14,%rbp
   329d6:	cmovbe %rbp,%rax
   329da:	mov    0x8(%rsp),%rdi
   329df:	mov    %rax,%rsi
   329e2:	add    %r14,%r15
   329e5:	call   32820 <void vldb_stage2::DenseCall<raw32_stage3::RawPage<8u, true> >(raw32_stage3::RawPage<8u, true> const&, unsigned int, unsigned int const*, unsigned int*)>
   329ea:	sub    %r14,%rbp
   329ed:	cmp    %rbx,%r15
   329f0:	jb     329c0 <void vldb_stage2::Query<raw32_stage3::RawPage<8u, true> >(raw32_stage3::RawPage<8u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x40>
   329f2:	add    $0x28,%rsp
   329f6:	pop    %rbx
   329f7:	pop    %rbp
   329f8:	pop    %r12
   329fa:	pop    %r13
   329fc:	pop    %r14
   329fe:	pop    %r15
   32a00:	ret
   32a01:	nopl   0x0(%rax)
   32a08:	xor    %r9d,%r9d
   32a0b:	lea    0x1c(%rsp),%r10
   32a10:	test   %rdx,%rdx
   32a13:	je     329f2 <void vldb_stage2::Query<raw32_stage3::RawPage<8u, true> >(raw32_stage3::RawPage<8u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x72>
   32a15:	nopl   (%rax)
   32a18:	mov    (%r12,%r9,4),%eax
   32a1c:	mov    0x8(%rsp),%rdi
   32a21:	mov    %r10,%rsi
   32a24:	mov    %eax,0x1c(%rsp)
   32a28:	call   c0a0 <pbf::PageBloomFilter<8u>::test(unsigned char const*, unsigned int) const [clone .constprop.0]>
   32a2d:	movzbl %al,%eax
   32a30:	mov    %eax,0x0(%r13,%r9,4)
   32a35:	inc    %r9
   32a38:	cmp    %r9,%rbx
   32a3b:	jne    32a18 <void vldb_stage2::Query<raw32_stage3::RawPage<8u, true> >(raw32_stage3::RawPage<8u, true> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x98>
   32a3d:	add    $0x28,%rsp
   32a41:	pop    %rbx
   32a42:	pop    %rbp
   32a43:	pop    %r12
   32a45:	pop    %r13
   32a47:	pop    %r14
   32a49:	pop    %r15
   32a4b:	ret
