
/home/yiming/projects/fastest-bf-lab/build/vldb-raw32-stage3-v2/native/modern:     file format elf64-x86-64


Disassembly of section .text:

0000000000032740 <void vldb_stage2::Query<raw32_stage3::RawPage<8u, false> >(raw32_stage3::RawPage<8u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
   32740:	push   %r15
   32742:	push   %r14
   32744:	push   %r13
   32746:	mov    %r8,%r13
   32749:	push   %r12
   3274b:	mov    %rcx,%r12
   3274e:	push   %rbp
   3274f:	push   %rbx
   32750:	mov    %rdx,%rbx
   32753:	sub    $0x28,%rsp
   32757:	mov    %rdi,0x8(%rsp)
   3275c:	test   %esi,%esi
   3275e:	je     327c8 <void vldb_stage2::Query<raw32_stage3::RawPage<8u, false> >(raw32_stage3::RawPage<8u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x88>
   32760:	cmp    $0x1,%esi
   32763:	mov    $0x1000,%r14d
   32769:	mov    $0x1,%eax
   3276e:	cmove  %rax,%r14
   32772:	test   %rdx,%rdx
   32775:	je     327b2 <void vldb_stage2::Query<raw32_stage3::RawPage<8u, false> >(raw32_stage3::RawPage<8u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x72>
   32777:	mov    %rdx,%rbp
   3277a:	xor    %r15d,%r15d
   3277d:	nopl   (%rax)
   32780:	lea    0x0(,%r15,4),%rdx
   32788:	lea    0x0(%r13,%rdx,1),%rcx
   3278d:	mov    %r14,%rax
   32790:	add    %r12,%rdx
   32793:	cmp    %r14,%rbp
   32796:	cmovbe %rbp,%rax
   3279a:	mov    0x8(%rsp),%rdi
   3279f:	mov    %rax,%rsi
   327a2:	add    %r14,%r15
   327a5:	call   325e0 <void vldb_stage2::DenseCall<raw32_stage3::RawPage<8u, false> >(raw32_stage3::RawPage<8u, false> const&, unsigned int, unsigned int const*, unsigned int*)>
   327aa:	sub    %r14,%rbp
   327ad:	cmp    %rbx,%r15
   327b0:	jb     32780 <void vldb_stage2::Query<raw32_stage3::RawPage<8u, false> >(raw32_stage3::RawPage<8u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x40>
   327b2:	add    $0x28,%rsp
   327b6:	pop    %rbx
   327b7:	pop    %rbp
   327b8:	pop    %r12
   327ba:	pop    %r13
   327bc:	pop    %r14
   327be:	pop    %r15
   327c0:	ret
   327c1:	nopl   0x0(%rax)
   327c8:	xor    %r9d,%r9d
   327cb:	lea    0x1c(%rsp),%r10
   327d0:	test   %rdx,%rdx
   327d3:	je     327b2 <void vldb_stage2::Query<raw32_stage3::RawPage<8u, false> >(raw32_stage3::RawPage<8u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x72>
   327d5:	nopl   (%rax)
   327d8:	mov    (%r12,%r9,4),%eax
   327dc:	mov    0x8(%rsp),%rdi
   327e1:	mov    %r10,%rsi
   327e4:	mov    %eax,0x1c(%rsp)
   327e8:	call   c0a0 <pbf::PageBloomFilter<8u>::test(unsigned char const*, unsigned int) const [clone .constprop.0]>
   327ed:	movzbl %al,%eax
   327f0:	mov    %eax,0x0(%r13,%r9,4)
   327f5:	inc    %r9
   327f8:	cmp    %r9,%rbx
   327fb:	jne    327d8 <void vldb_stage2::Query<raw32_stage3::RawPage<8u, false> >(raw32_stage3::RawPage<8u, false> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x98>
   327fd:	add    $0x28,%rsp
   32801:	pop    %rbx
   32802:	pop    %rbp
   32803:	pop    %r12
   32805:	pop    %r13
   32807:	pop    %r14
   32809:	pop    %r15
   3280b:	ret
