00000000000e8a50 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<10ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<10ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
   e8a50:	test   %rsi,%rsi
   e8a53:	je     e8b57 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<10ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<10ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x107>
   e8a59:	push   %rbp
   e8a5a:	push   %r15
   e8a5c:	push   %r14
   e8a5e:	push   %rbx
   e8a5f:	mov    %rdx,%rax
   e8a62:	movabs $0xd6e8feb86659fd93,%r8
   e8a6c:	xor    %r9d,%r9d
   e8a6f:	movabs $0xf1357aea2e62a9c5,%r10
   e8a79:	vmovdqa -0xe3f41(%rip),%ymm0        # 4b40 <typeinfo name for main::$_60+0x370>
   e8a81:	vpbroadcastd -0xe57e2(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
   e8a8a:	movabs $0x9e3779b97f4a7c15,%r11
   e8a94:	vmovdqa -0xe3fdc(%rip),%ymm2        # 4ac0 <typeinfo name for main::$_60+0x2f0>
   e8a9c:	nopl   0x0(%rax)
   e8aa0:	mov    (%rax,%r9,8),%rdx
   e8aa4:	mov    %rdx,%rbx
   e8aa7:	shr    $0x20,%rbx
   e8aab:	xor    %rdx,%rbx
   e8aae:	imul   %r8,%rbx
   e8ab2:	mov    %rbx,%r14
   e8ab5:	shr    $0x20,%r14
   e8ab9:	xor    %rbx,%r14
   e8abc:	imul   %r8,%r14
   e8ac0:	mov    %r14,%rdx
   e8ac3:	shr    $0x20,%rdx
   e8ac7:	xor    %r14,%rdx
   e8aca:	or     $0x1,%rdx
   e8ace:	mov    0x20(%rdi),%rbx
   e8ad2:	mulx   0x10(%rdi),%r14,%r14
   e8ad8:	lea    (%r14,%r14,4),%r14
   e8adc:	imul   %r10,%rdx
   e8ae0:	vmovdqu (%rbx,%r14,8),%ymm3
   e8ae6:	vpbroadcastq %rdx,%ymm4
   e8aec:	vpsllvq %ymm0,%ymm4,%ymm4
   e8af1:	vpsrld $0x1b,%ymm4,%ymm4
   e8af6:	vpsllvd %ymm4,%ymm1,%ymm4
   e8afb:	vptest %ymm4,%ymm3
   e8b00:	setb   %bpl
   e8b04:	mulx   %r11,%rdx,%r15
   e8b09:	xor    %rdx,%r15
   e8b0c:	vpbroadcastq %r15,%ymm3
   e8b12:	prefetcht0 (%rbx,%r14,8)
   e8b17:	vmovdqu 0x20(%rbx,%r14,8),%ymm4
   e8b1e:	vpsllvq %ymm0,%ymm3,%ymm3
   e8b23:	vpsrld $0x1b,%ymm3,%ymm3
   e8b28:	vpsllvd %ymm3,%ymm2,%ymm3
   e8b2d:	vptest %ymm3,%ymm4
   e8b32:	setb   %dl
   e8b35:	prefetcht0 0x40(%rbx,%r14,8)
   e8b3b:	and    %bpl,%dl
   e8b3e:	movzbl %dl,%edx
   e8b41:	mov    %edx,(%rcx,%r9,4)
   e8b45:	inc    %r9
   e8b48:	cmp    %r9,%rsi
   e8b4b:	jne    e8aa0 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<10ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<10ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
   e8b51:	pop    %rbx
   e8b52:	pop    %r14
   e8b54:	pop    %r15
   e8b56:	pop    %rbp
   e8b57:	vzeroupper
   e8b5a:	ret
   e8b5b:	int3
   e8b5c:	int3
   e8b5d:	int3
   e8b5e:	int3
   e8b5f:	int3

