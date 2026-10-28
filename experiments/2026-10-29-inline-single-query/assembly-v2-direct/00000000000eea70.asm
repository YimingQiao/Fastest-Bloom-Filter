00000000000eea70 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<12ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<12ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
   eea70:	test   %rsi,%rsi
   eea73:	je     eeb7b <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<12ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<12ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x10b>
   eea79:	push   %rbp
   eea7a:	push   %r15
   eea7c:	push   %r14
   eea7e:	push   %rbx
   eea7f:	mov    %rdx,%rax
   eea82:	movabs $0xd6e8feb86659fd93,%r8
   eea8c:	xor    %r9d,%r9d
   eea8f:	movabs $0xf1357aea2e62a9c5,%r10
   eea99:	vmovdqa -0xe9f61(%rip),%ymm0        # 4b40 <typeinfo name for main::$_60+0x370>
   eeaa1:	vpbroadcastd -0xeb802(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
   eeaaa:	movabs $0x9e3779b97f4a7c15,%r11
   eeab4:	vmovdqa -0xea15c(%rip),%ymm2        # 4960 <typeinfo name for main::$_60+0x190>
   eeabc:	nopl   0x0(%rax)
   eeac0:	mov    (%rax,%r9,8),%rdx
   eeac4:	mov    %rdx,%rbx
   eeac7:	shr    $0x20,%rbx
   eeacb:	xor    %rdx,%rbx
   eeace:	imul   %r8,%rbx
   eead2:	mov    %rbx,%r14
   eead5:	shr    $0x20,%r14
   eead9:	xor    %rbx,%r14
   eeadc:	imul   %r8,%r14
   eeae0:	mov    %r14,%rdx
   eeae3:	shr    $0x20,%rdx
   eeae7:	xor    %r14,%rdx
   eeaea:	or     $0x1,%rdx
   eeaee:	mov    0x20(%rdi),%rbx
   eeaf2:	mulx   0x10(%rdi),%r14,%r14
   eeaf8:	lea    (%r14,%r14,2),%r14
   eeafc:	shl    $0x4,%r14
   eeb00:	imul   %r10,%rdx
   eeb04:	vmovdqu (%rbx,%r14,1),%ymm3
   eeb0a:	vpbroadcastq %rdx,%ymm4
   eeb10:	vpsllvq %ymm0,%ymm4,%ymm4
   eeb15:	vpsrld $0x1b,%ymm4,%ymm4
   eeb1a:	vpsllvd %ymm4,%ymm1,%ymm4
   eeb1f:	vptest %ymm4,%ymm3
   eeb24:	setb   %bpl
   eeb28:	mulx   %r11,%rdx,%r15
   eeb2d:	xor    %rdx,%r15
   eeb30:	vpbroadcastq %r15,%ymm3
   eeb36:	prefetcht0 (%rbx,%r14,1)
   eeb3b:	vmovdqu 0x20(%rbx,%r14,1),%ymm4
   eeb42:	vpsllvq %ymm0,%ymm3,%ymm3
   eeb47:	vpsrld $0x1b,%ymm3,%ymm3
   eeb4c:	vpsllvd %ymm3,%ymm2,%ymm3
   eeb51:	vptest %ymm3,%ymm4
   eeb56:	setb   %dl
   eeb59:	prefetcht0 0x40(%rbx,%r14,1)
   eeb5f:	and    %bpl,%dl
   eeb62:	movzbl %dl,%edx
   eeb65:	mov    %edx,(%rcx,%r9,4)
   eeb69:	inc    %r9
   eeb6c:	cmp    %r9,%rsi
   eeb6f:	jne    eeac0 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<12ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<12ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
   eeb75:	pop    %rbx
   eeb76:	pop    %r14
   eeb78:	pop    %r15
   eeb7a:	pop    %rbp
   eeb7b:	vzeroupper
   eeb7e:	ret
   eeb7f:	int3

