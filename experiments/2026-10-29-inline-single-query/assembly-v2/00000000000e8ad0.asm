00000000000e8ad0 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<10ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<10ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
   e8ad0:	test   %rsi,%rsi
   e8ad3:	je     e8bd7 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<10ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<10ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x107>
   e8ad9:	push   %rbp
   e8ada:	push   %r15
   e8adc:	push   %r14
   e8ade:	push   %rbx
   e8adf:	mov    %rdx,%rax
   e8ae2:	movabs $0xd6e8feb86659fd93,%r8
   e8aec:	xor    %r9d,%r9d
   e8aef:	movabs $0xf1357aea2e62a9c5,%r10
   e8af9:	vmovdqa -0xe3fc1(%rip),%ymm0        # 4b40 <typeinfo name for main::$_60+0x370>
   e8b01:	vpbroadcastd -0xe5862(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
   e8b0a:	movabs $0x9e3779b97f4a7c15,%r11
   e8b14:	vmovdqa -0xe405c(%rip),%ymm2        # 4ac0 <typeinfo name for main::$_60+0x2f0>
   e8b1c:	nopl   0x0(%rax)
   e8b20:	mov    (%rax,%r9,8),%rdx
   e8b24:	mov    %rdx,%rbx
   e8b27:	shr    $0x20,%rbx
   e8b2b:	xor    %rdx,%rbx
   e8b2e:	imul   %r8,%rbx
   e8b32:	mov    %rbx,%r14
   e8b35:	shr    $0x20,%r14
   e8b39:	xor    %rbx,%r14
   e8b3c:	imul   %r8,%r14
   e8b40:	mov    %r14,%rdx
   e8b43:	shr    $0x20,%rdx
   e8b47:	xor    %r14,%rdx
   e8b4a:	or     $0x1,%rdx
   e8b4e:	mov    0x20(%rdi),%rbx
   e8b52:	mulx   0x10(%rdi),%r14,%r14
   e8b58:	lea    (%r14,%r14,4),%r14
   e8b5c:	imul   %r10,%rdx
   e8b60:	vmovdqu (%rbx,%r14,8),%ymm3
   e8b66:	vpbroadcastq %rdx,%ymm4
   e8b6c:	vpsllvq %ymm0,%ymm4,%ymm4
   e8b71:	vpsrld $0x1b,%ymm4,%ymm4
   e8b76:	vpsllvd %ymm4,%ymm1,%ymm4
   e8b7b:	vptest %ymm4,%ymm3
   e8b80:	setb   %bpl
   e8b84:	mulx   %r11,%rdx,%r15
   e8b89:	xor    %rdx,%r15
   e8b8c:	vpbroadcastq %r15,%ymm3
   e8b92:	prefetcht0 (%rbx,%r14,8)
   e8b97:	vmovdqu 0x20(%rbx,%r14,8),%ymm4
   e8b9e:	vpsllvq %ymm0,%ymm3,%ymm3
   e8ba3:	vpsrld $0x1b,%ymm3,%ymm3
   e8ba8:	vpsllvd %ymm3,%ymm2,%ymm3
   e8bad:	vptest %ymm3,%ymm4
   e8bb2:	setb   %dl
   e8bb5:	prefetcht0 0x40(%rbx,%r14,8)
   e8bbb:	and    %bpl,%dl
   e8bbe:	movzbl %dl,%edx
   e8bc1:	mov    %edx,(%rcx,%r9,4)
   e8bc5:	inc    %r9
   e8bc8:	cmp    %r9,%rsi
   e8bcb:	jne    e8b20 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<10ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<10ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
   e8bd1:	pop    %rbx
   e8bd2:	pop    %r14
   e8bd4:	pop    %r15
   e8bd6:	pop    %rbp
   e8bd7:	vzeroupper
   e8bda:	ret
   e8bdb:	int3
   e8bdc:	int3
   e8bdd:	int3
   e8bde:	int3
   e8bdf:	int3

