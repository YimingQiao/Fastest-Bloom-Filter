
/home/yiming/projects/fastest-bf-lab/build/vldb-raw32-stage3-v2/native/modern:     file format elf64-x86-64


Disassembly of section .text:

00000000000305b0 <void vldb_stage2::Query<raw32_stage3::RawHash<rocksdb_external::FastLocalBloom64<8, true>, raw32_stage3::ModernPolicy<rocksdb_external::FastLocalBloom64<8, true> > > >(raw32_stage3::RawHash<rocksdb_external::FastLocalBloom64<8, true>, raw32_stage3::ModernPolicy<rocksdb_external::FastLocalBloom64<8, true> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
   305b0:	push   %r15
   305b2:	push   %r14
   305b4:	push   %r13
   305b6:	mov    %r8,%r13
   305b9:	push   %r12
   305bb:	mov    %rcx,%r12
   305be:	push   %rbp
   305bf:	push   %rbx
   305c0:	mov    %rdx,%rbx
   305c3:	sub    $0x28,%rsp
   305c7:	mov    %rdi,(%rsp)
   305cb:	test   %esi,%esi
   305cd:	je     30630 <void vldb_stage2::Query<raw32_stage3::RawHash<rocksdb_external::FastLocalBloom64<8, true>, raw32_stage3::ModernPolicy<rocksdb_external::FastLocalBloom64<8, true> > > >(raw32_stage3::RawHash<rocksdb_external::FastLocalBloom64<8, true>, raw32_stage3::ModernPolicy<rocksdb_external::FastLocalBloom64<8, true> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x80>
   305cf:	cmp    $0x1,%esi
   305d2:	mov    $0x1000,%r14d
   305d8:	mov    $0x1,%eax
   305dd:	cmove  %rax,%r14
   305e1:	test   %rdx,%rdx
   305e4:	je     30621 <void vldb_stage2::Query<raw32_stage3::RawHash<rocksdb_external::FastLocalBloom64<8, true>, raw32_stage3::ModernPolicy<rocksdb_external::FastLocalBloom64<8, true> > > >(raw32_stage3::RawHash<rocksdb_external::FastLocalBloom64<8, true>, raw32_stage3::ModernPolicy<rocksdb_external::FastLocalBloom64<8, true> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x71>
   305e6:	mov    %rdx,%rbp
   305e9:	xor    %r15d,%r15d
   305ec:	nopl   0x0(%rax)
   305f0:	lea    0x0(,%r15,4),%rdx
   305f8:	lea    0x0(%r13,%rdx,1),%rcx
   305fd:	mov    %rbp,%rax
   30600:	add    %r12,%rdx
   30603:	cmp    %rbp,%r14
   30606:	cmovbe %r14,%rax
   3060a:	mov    (%rsp),%rdi
   3060e:	mov    %rax,%rsi
   30611:	add    %r14,%r15
   30614:	call   30540 <void vldb_stage2::DenseCall<raw32_stage3::RawHash<rocksdb_external::FastLocalBloom64<8, true>, raw32_stage3::ModernPolicy<rocksdb_external::FastLocalBloom64<8, true> > > >(raw32_stage3::RawHash<rocksdb_external::FastLocalBloom64<8, true>, raw32_stage3::ModernPolicy<rocksdb_external::FastLocalBloom64<8, true> > > const&, unsigned int, unsigned int const*, unsigned int*)>
   30619:	sub    %r14,%rbp
   3061c:	cmp    %rbx,%r15
   3061f:	jb     305f0 <void vldb_stage2::Query<raw32_stage3::RawHash<rocksdb_external::FastLocalBloom64<8, true>, raw32_stage3::ModernPolicy<rocksdb_external::FastLocalBloom64<8, true> > > >(raw32_stage3::RawHash<rocksdb_external::FastLocalBloom64<8, true>, raw32_stage3::ModernPolicy<rocksdb_external::FastLocalBloom64<8, true> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x40>
   30621:	add    $0x28,%rsp
   30625:	pop    %rbx
   30626:	pop    %rbp
   30627:	pop    %r12
   30629:	pop    %r13
   3062b:	pop    %r14
   3062d:	pop    %r15
   3062f:	ret
   30630:	lea    0x18(%rsp),%rax
   30635:	mov    %rax,0x8(%rsp)
   3063a:	xor    %ebp,%ebp
   3063c:	lea    0x14(%rsp),%r15
   30641:	movabs $0xd6e8feb86659fd93,%r14
   3064b:	test   %rdx,%rdx
   3064e:	je     30621 <void vldb_stage2::Query<raw32_stage3::RawHash<rocksdb_external::FastLocalBloom64<8, true>, raw32_stage3::ModernPolicy<rocksdb_external::FastLocalBloom64<8, true> > > >(raw32_stage3::RawHash<rocksdb_external::FastLocalBloom64<8, true>, raw32_stage3::ModernPolicy<rocksdb_external::FastLocalBloom64<8, true> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x71>
   30650:	mov    (%r12,%rbp,4),%eax
   30654:	mov    (%rsp),%rdi
   30658:	imul   %r14,%rax
   3065c:	mov    %r15,%rcx
   3065f:	mov    $0x1,%esi
   30664:	mov    %rax,%rdx
   30667:	shr    $0x20,%rdx
   3066b:	xor    %rdx,%rax
   3066e:	imul   %r14,%rax
   30672:	movl   $0x0,0x14(%rsp)
   3067a:	mov    %rax,%rdx
   3067d:	shr    $0x20,%rdx
   30681:	xor    %rdx,%rax
   30684:	mov    0x8(%rsp),%rdx
   30689:	mov    %rax,0x18(%rsp)
   3068e:	call   d6d0 <rocksdb_external::FastLocalBloom64<8, true>::Lookup(unsigned int, unsigned long const*, unsigned int*) const [clone .isra.0]>
   30693:	mov    0x14(%rsp),%edx
   30697:	xor    %eax,%eax
   30699:	test   %edx,%edx
   3069b:	setne  %al
   3069e:	mov    %eax,0x0(%r13,%rbp,4)
   306a3:	inc    %rbp
   306a6:	cmp    %rbp,%rbx
   306a9:	jne    30650 <void vldb_stage2::Query<raw32_stage3::RawHash<rocksdb_external::FastLocalBloom64<8, true>, raw32_stage3::ModernPolicy<rocksdb_external::FastLocalBloom64<8, true> > > >(raw32_stage3::RawHash<rocksdb_external::FastLocalBloom64<8, true>, raw32_stage3::ModernPolicy<rocksdb_external::FastLocalBloom64<8, true> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0xa0>
   306ab:	add    $0x28,%rsp
   306af:	pop    %rbx
   306b0:	pop    %rbp
   306b1:	pop    %r12
   306b3:	pop    %r13
   306b5:	pop    %r14
   306b7:	pop    %r15
   306b9:	ret
