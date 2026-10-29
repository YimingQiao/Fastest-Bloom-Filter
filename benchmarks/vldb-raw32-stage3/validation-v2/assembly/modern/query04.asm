
/home/yiming/projects/fastest-bf-lab/build/vldb-raw32-stage3-v2/native/modern:     file format elf64-x86-64


Disassembly of section .text:

000000000002e7b0 <void vldb_stage2::Query<raw32_stage3::RawHash<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> > > >(raw32_stage3::RawHash<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
   2e7b0:	push   %r15
   2e7b2:	push   %r14
   2e7b4:	mov    %r8,%r14
   2e7b7:	push   %r13
   2e7b9:	mov    %rdx,%r13
   2e7bc:	push   %r12
   2e7be:	push   %rbp
   2e7bf:	mov    %rdi,%rbp
   2e7c2:	push   %rbx
   2e7c3:	sub    $0x18,%rsp
   2e7c7:	mov    %rcx,0x8(%rsp)
   2e7cc:	test   %esi,%esi
   2e7ce:	je     2e840 <void vldb_stage2::Query<raw32_stage3::RawHash<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> > > >(raw32_stage3::RawHash<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x90>
   2e7d0:	cmp    $0x1,%esi
   2e7d3:	mov    $0x1000,%ebx
   2e7d8:	mov    $0x1,%eax
   2e7dd:	cmove  %rax,%rbx
   2e7e1:	test   %rdx,%rdx
   2e7e4:	je     2e830 <void vldb_stage2::Query<raw32_stage3::RawHash<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> > > >(raw32_stage3::RawHash<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x80>
   2e7e6:	mov    %rdi,(%rsp)
   2e7ea:	mov    %rbx,%rbp
   2e7ed:	mov    0x8(%rsp),%rbx
   2e7f2:	mov    %rdx,%r15
   2e7f5:	xor    %r12d,%r12d
   2e7f8:	nopl   0x0(%rax,%rax,1)
   2e800:	lea    0x0(,%r12,4),%rdx
   2e808:	lea    (%r14,%rdx,1),%rcx
   2e80c:	mov    %rbp,%rax
   2e80f:	add    %rbx,%rdx
   2e812:	cmp    %rbp,%r15
   2e815:	cmovbe %r15,%rax
   2e819:	mov    (%rsp),%rdi
   2e81d:	mov    %rax,%rsi
   2e820:	add    %rbp,%r12
   2e823:	call   2e470 <void vldb_stage2::DenseCall<raw32_stage3::RawHash<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> > > >(raw32_stage3::RawHash<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> > > const&, unsigned int, unsigned int const*, unsigned int*)>
   2e828:	sub    %rbp,%r15
   2e82b:	cmp    %r13,%r12
   2e82e:	jb     2e800 <void vldb_stage2::Query<raw32_stage3::RawHash<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> > > >(raw32_stage3::RawHash<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x50>
   2e830:	add    $0x18,%rsp
   2e834:	pop    %rbx
   2e835:	pop    %rbp
   2e836:	pop    %r12
   2e838:	pop    %r13
   2e83a:	pop    %r14
   2e83c:	pop    %r15
   2e83e:	ret
   2e83f:	nop
   2e840:	xor    %ebx,%ebx
   2e842:	movabs $0xd6e8feb86659fd93,%r8
   2e84c:	test   %rdx,%rdx
   2e84f:	je     2e830 <void vldb_stage2::Query<raw32_stage3::RawHash<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> > > >(raw32_stage3::RawHash<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x80>
   2e851:	nopl   0x0(%rax)
   2e858:	mov    0x8(%rsp),%rax
   2e85d:	mov    0x10(%rbp),%rsi
   2e861:	mov    (%rax,%rbx,4),%ecx
   2e864:	movabs $0xf1357aea2e62a9c5,%rdi
   2e86e:	imul   %r8,%rcx
   2e872:	mov    0x20(%rbp),%r9
   2e876:	movabs $0x1427bb2d3769b199,%r10
   2e880:	mov    %rcx,%rax
   2e883:	shr    $0x20,%rax
   2e887:	xor    %rax,%rcx
   2e88a:	imul   %r8,%rcx
   2e88e:	mov    %rcx,%rax
   2e891:	shr    $0x20,%rax
   2e895:	xor    %rax,%rcx
   2e898:	or     $0x1,%rcx
   2e89c:	imul   %rcx,%rdi
   2e8a0:	mov    %rcx,%rax
   2e8a3:	mul    %rsi
   2e8a6:	mov    %rdi,%rax
   2e8a9:	shr    $0x3,%rdi
   2e8ad:	lea    (%r9,%rdx,1),%r11
   2e8b1:	mul    %rsi
   2e8b4:	mov    %rdi,%rax
   2e8b7:	and    $0x7,%eax
   2e8ba:	lea    (%r9,%rdx,1),%r15
   2e8be:	movzbl (%r11),%edx
   2e8c2:	mov    $0x1,%edi
   2e8c7:	shlx   %eax,%edi,%eax
   2e8cc:	and    %eax,%edx
   2e8ce:	imul   %rcx,%r10
   2e8d2:	prefetcht0 (%r11)
   2e8d6:	prefetcht0 (%r15)
   2e8da:	cmp    %dl,%al
   2e8dc:	jne    2eb18 <void vldb_stage2::Query<raw32_stage3::RawHash<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> > > >(raw32_stage3::RawHash<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x368>
   2e8e2:	mov    %rsi,%rax
   2e8e5:	mul    %r10
   2e8e8:	movzbl (%r15),%eax
   2e8ec:	shr    $0x3,%r10
   2e8f0:	and    $0x7,%r10d
   2e8f4:	movabs $0x57545799e525abbd,%r11
   2e8fe:	lea    (%r9,%rdx,1),%r12
   2e902:	shlx   %r10d,%edi,%r10d
   2e907:	and    %r10d,%eax
   2e90a:	imul   %rcx,%r11
   2e90e:	prefetcht0 (%r12)
   2e913:	cmp    %al,%r10b
   2e916:	jne    2eb18 <void vldb_stage2::Query<raw32_stage3::RawHash<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> > > >(raw32_stage3::RawHash<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x368>
   2e91c:	mov    %rsi,%rax
   2e91f:	mul    %r11
   2e922:	movzbl (%r12),%eax
   2e927:	shr    $0x3,%r11
   2e92b:	and    $0x7,%r11d
   2e92f:	movabs $0xf53a8bbce8b6ed71,%r10
   2e939:	lea    (%r9,%rdx,1),%r15
   2e93d:	shlx   %r11d,%edi,%r11d
   2e942:	and    %r11d,%eax
   2e945:	imul   %rcx,%r10
   2e949:	prefetcht0 (%r15)
   2e94d:	cmp    %al,%r11b
   2e950:	jne    2eb18 <void vldb_stage2::Query<raw32_stage3::RawHash<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> > > >(raw32_stage3::RawHash<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x368>
   2e956:	mov    %rsi,%rax
   2e959:	mul    %r10
   2e95c:	movzbl (%r15),%eax
   2e960:	shr    $0x3,%r10
   2e964:	and    $0x7,%r10d
   2e968:	movabs $0x3a3115fb0ac650f5,%r11
   2e972:	lea    (%r9,%rdx,1),%r12
   2e976:	shlx   %r10d,%edi,%r10d
   2e97b:	and    %r10d,%eax
   2e97e:	imul   %rcx,%r11
   2e982:	prefetcht0 (%r12)
   2e987:	cmp    %al,%r10b
   2e98a:	jne    2eb18 <void vldb_stage2::Query<raw32_stage3::RawHash<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> > > >(raw32_stage3::RawHash<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x368>
   2e990:	mov    %rsi,%rax
   2e993:	mul    %r11
   2e996:	movzbl (%r12),%eax
   2e99b:	shr    $0x3,%r11
   2e99f:	and    $0x7,%r11d
   2e9a3:	movabs $0x78e628b539d80989,%r10
   2e9ad:	lea    (%r9,%rdx,1),%r15
   2e9b1:	shlx   %r11d,%edi,%r11d
   2e9b6:	and    %r11d,%eax
   2e9b9:	imul   %rcx,%r10
   2e9bd:	prefetcht0 (%r15)
   2e9c1:	cmp    %al,%r11b
   2e9c4:	jne    2eb18 <void vldb_stage2::Query<raw32_stage3::RawHash<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> > > >(raw32_stage3::RawHash<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x368>
   2e9ca:	mov    %rsi,%rax
   2e9cd:	mul    %r10
   2e9d0:	movzbl (%r15),%eax
   2e9d4:	shr    $0x3,%r10
   2e9d8:	and    $0x7,%r10d
   2e9dc:	movabs $0xe622ee4965fcc76d,%r11
   2e9e6:	lea    (%r9,%rdx,1),%r12
   2e9ea:	shlx   %r10d,%edi,%r10d
   2e9ef:	and    %r10d,%eax
   2e9f2:	imul   %rcx,%r11
   2e9f6:	prefetcht0 (%r12)
   2e9fb:	cmp    %al,%r10b
   2e9fe:	jne    2eb18 <void vldb_stage2::Query<raw32_stage3::RawHash<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> > > >(raw32_stage3::RawHash<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x368>
   2ea04:	mov    %rsi,%rax
   2ea07:	mul    %r11
   2ea0a:	movzbl (%r12),%eax
   2ea0f:	shr    $0x3,%r11
   2ea13:	and    $0x7,%r11d
   2ea17:	movabs $0x2745850b48e66be1,%r10
   2ea21:	lea    (%r9,%rdx,1),%r15
   2ea25:	shlx   %r11d,%edi,%r11d
   2ea2a:	and    %r11d,%eax
   2ea2d:	imul   %rcx,%r10
   2ea31:	prefetcht0 (%r15)
   2ea35:	cmp    %al,%r11b
   2ea38:	jne    2eb18 <void vldb_stage2::Query<raw32_stage3::RawHash<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> > > >(raw32_stage3::RawHash<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x368>
   2ea3e:	mov    %rsi,%rax
   2ea41:	mul    %r10
   2ea44:	movzbl (%r15),%eax
   2ea48:	shr    $0x3,%r10
   2ea4c:	and    $0x7,%r10d
   2ea50:	movabs $0xab5bfa10f0aa8d25,%r11
   2ea5a:	lea    (%r9,%rdx,1),%r12
   2ea5e:	shlx   %r10d,%edi,%r10d
   2ea63:	and    %r10d,%eax
   2ea66:	imul   %rcx,%r11
   2ea6a:	prefetcht0 (%r12)
   2ea6f:	cmp    %al,%r10b
   2ea72:	jne    2eb18 <void vldb_stage2::Query<raw32_stage3::RawHash<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> > > >(raw32_stage3::RawHash<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x368>
   2ea78:	mov    %rsi,%rax
   2ea7b:	mul    %r11
   2ea7e:	movzbl (%r12),%eax
   2ea83:	shr    $0x3,%r11
   2ea87:	and    $0x7,%r11d
   2ea8b:	movabs $0xac690a6278960a79,%r10
   2ea95:	lea    (%r9,%rdx,1),%r15
   2ea99:	shlx   %r11d,%edi,%r11d
   2ea9e:	and    %r11d,%eax
   2eaa1:	imul   %rcx,%r10
   2eaa5:	prefetcht0 (%r15)
   2eaa9:	cmp    %al,%r11b
   2eaac:	jne    2eb18 <void vldb_stage2::Query<raw32_stage3::RawHash<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> > > >(raw32_stage3::RawHash<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x368>
   2eaae:	movabs $0x7e3d5b4d98b1f01d,%rax
   2eab8:	imul   %rax,%rcx
   2eabc:	mov    %rsi,%rax
   2eabf:	mul    %r10
   2eac2:	movzbl (%r15),%eax
   2eac6:	shr    $0x3,%r10
   2eaca:	and    $0x7,%r10d
   2eace:	add    %r9,%rdx
   2ead1:	shlx   %r10d,%edi,%edi
   2ead6:	and    %edi,%eax
   2ead8:	prefetcht0 (%rdx)
   2eadb:	cmp    %al,%dil
   2eade:	jne    2eb18 <void vldb_stage2::Query<raw32_stage3::RawHash<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> > > >(raw32_stage3::RawHash<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x368>
   2eae0:	shr    $0x3,%rcx
   2eae4:	movzbl (%rdx),%esi
   2eae7:	and    $0x7,%ecx
   2eaea:	mov    $0x1,%eax
   2eaef:	shlx   %ecx,%eax,%eax
   2eaf4:	and    %eax,%esi
   2eaf6:	cmp    %al,%sil
   2eaf9:	sete   %al
   2eafc:	movzbl %al,%eax
   2eaff:	mov    %eax,(%r14,%rbx,4)
   2eb03:	inc    %rbx
   2eb06:	cmp    %rbx,%r13
   2eb09:	jne    2e858 <void vldb_stage2::Query<raw32_stage3::RawHash<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> > > >(raw32_stage3::RawHash<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0xa8>
   2eb0f:	jmp    2e830 <void vldb_stage2::Query<raw32_stage3::RawHash<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> > > >(raw32_stage3::RawHash<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x80>
   2eb14:	nopl   0x0(%rax)
   2eb18:	xor    %eax,%eax
   2eb1a:	jmp    2eaff <void vldb_stage2::Query<raw32_stage3::RawHash<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> > > >(raw32_stage3::RawHash<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, raw32_stage3::ModernPolicy<boost_baseline::Adapter<11ul, boost::bloom::block<unsigned char, 1ul>, 0ul> > > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x34f>
