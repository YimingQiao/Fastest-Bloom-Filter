00000000000d5d70 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<6ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<6ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
   d5d70:	test   %rsi,%rsi
   d5d73:	je     d5eb9 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<6ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<6ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x149>
   d5d79:	push   %rbx
   d5d7a:	mov    %rdx,%rax
   d5d7d:	movabs $0xf1357aea2e62a9c5,%r9
   d5d87:	cmp    $0x1,%rsi
   d5d8b:	jne    d5d95 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<6ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<6ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x25>
   d5d8d:	xor    %r8d,%r8d
   d5d90:	jmp    d5e61 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<6ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<6ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0xf1>
   d5d95:	mov    %rsi,%r10
   d5d98:	and    $0xfffffffffffffffe,%r10
   d5d9c:	xor    %r8d,%r8d
   d5d9f:	vmovdqa -0xd1267(%rip),%ymm0        # 4b40 <typeinfo name for main::$_60+0x370>
   d5da7:	vmovdqa -0xd154f(%rip),%ymm1        # 4860 <typeinfo name for main::$_60+0x90>
   d5daf:	nop
   d5db0:	mov    (%rax,%r8,8),%rdx
   d5db4:	or     $0x1,%rdx
   d5db8:	mov    0x20(%rdi),%r11
   d5dbc:	mulx   0x10(%rdi),%rbx,%rbx
   d5dc2:	lea    (%rbx,%rbx,2),%rbx
   d5dc6:	prefetcht0 (%r11,%rbx,8)
   d5dcb:	prefetcht0 0x40(%r11,%rbx,8)
   d5dd1:	imul   %r9,%rdx
   d5dd5:	vmovdqu (%r11,%rbx,8),%ymm2
   d5ddb:	vpbroadcastq %rdx,%ymm3
   d5de1:	vpsllvq %ymm0,%ymm3,%ymm3
   d5de6:	vpsrld $0x1b,%ymm3,%ymm3
   d5deb:	vpsllvd %ymm3,%ymm1,%ymm3
   d5df0:	xor    %edx,%edx
   d5df2:	vptest %ymm3,%ymm2
   d5df7:	setb   %dl
   d5dfa:	mov    %edx,(%rcx,%r8,4)
   d5dfe:	mov    0x8(%rax,%r8,8),%rdx
   d5e03:	or     $0x1,%rdx
   d5e07:	mov    0x20(%rdi),%r11
   d5e0b:	mulx   0x10(%rdi),%rbx,%rbx
   d5e11:	lea    (%rbx,%rbx,2),%rbx
   d5e15:	prefetcht0 (%r11,%rbx,8)
   d5e1a:	prefetcht0 0x40(%r11,%rbx,8)
   d5e20:	imul   %r9,%rdx
   d5e24:	vmovdqu (%r11,%rbx,8),%ymm2
   d5e2a:	vpbroadcastq %rdx,%ymm3
   d5e30:	vpsllvq %ymm0,%ymm3,%ymm3
   d5e35:	vpsrld $0x1b,%ymm3,%ymm3
   d5e3a:	vpsllvd %ymm3,%ymm1,%ymm3
   d5e3f:	xor    %edx,%edx
   d5e41:	vptest %ymm3,%ymm2
   d5e46:	setb   %dl
   d5e49:	mov    %edx,0x4(%rcx,%r8,4)
   d5e4e:	add    $0x2,%r8
   d5e52:	cmp    %r8,%r10
   d5e55:	jne    d5db0 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<6ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<6ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
   d5e5b:	test   $0x1,%sil
   d5e5f:	je     d5eb8 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<6ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<6ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x148>
   d5e61:	mov    (%rax,%r8,8),%rdx
   d5e65:	or     $0x1,%rdx
   d5e69:	mov    0x20(%rdi),%rax
   d5e6d:	mulx   0x10(%rdi),%rsi,%rsi
   d5e73:	lea    (%rsi,%rsi,2),%rsi
   d5e77:	prefetcht0 (%rax,%rsi,8)
   d5e7b:	prefetcht0 0x40(%rax,%rsi,8)
   d5e80:	imul   %r9,%rdx
   d5e84:	vmovdqu (%rax,%rsi,8),%ymm0
   d5e89:	vpbroadcastq %rdx,%ymm1
   d5e8f:	vpsllvq -0xd1358(%rip),%ymm1,%ymm1        # 4b40 <typeinfo name for main::$_60+0x370>
   d5e98:	vpsrld $0x1b,%ymm1,%ymm1
   d5e9d:	vmovdqa -0xd1645(%rip),%ymm2        # 4860 <typeinfo name for main::$_60+0x90>
   d5ea5:	vpsllvd %ymm1,%ymm2,%ymm1
   d5eaa:	xor    %eax,%eax
   d5eac:	vptest %ymm1,%ymm0
   d5eb1:	setb   %al
   d5eb4:	mov    %eax,(%rcx,%r8,4)
   d5eb8:	pop    %rbx
   d5eb9:	vzeroupper
   d5ebc:	ret
   d5ebd:	int3
   d5ebe:	int3
   d5ebf:	int3

