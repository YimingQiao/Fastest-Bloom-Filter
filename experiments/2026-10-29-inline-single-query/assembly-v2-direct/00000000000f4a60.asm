00000000000f4a60 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<16ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<16ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
   f4a60:	test   %rsi,%rsi
   f4a63:	je     f4b61 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<16ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<16ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x101>
   f4a69:	push   %rbp
   f4a6a:	push   %r15
   f4a6c:	push   %r14
   f4a6e:	push   %rbx
   f4a6f:	mov    %rdx,%rax
   f4a72:	movabs $0xd6e8feb86659fd93,%r8
   f4a7c:	xor    %r9d,%r9d
   f4a7f:	movabs $0xf1357aea2e62a9c5,%r10
   f4a89:	vmovdqa -0xeff51(%rip),%ymm0        # 4b40 <typeinfo name for main::$_60+0x370>
   f4a91:	vpbroadcastd -0xf17f2(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
   f4a9a:	movabs $0x9e3779b97f4a7c15,%r11
   f4aa4:	data16 data16 cs nopw 0x0(%rax,%rax,1)
   f4ab0:	mov    (%rax,%r9,8),%rdx
   f4ab4:	mov    %rdx,%rbx
   f4ab7:	shr    $0x20,%rbx
   f4abb:	xor    %rdx,%rbx
   f4abe:	imul   %r8,%rbx
   f4ac2:	mov    %rbx,%r14
   f4ac5:	shr    $0x20,%r14
   f4ac9:	xor    %rbx,%r14
   f4acc:	imul   %r8,%r14
   f4ad0:	mov    %r14,%rdx
   f4ad3:	shr    $0x20,%rdx
   f4ad7:	xor    %r14,%rdx
   f4ada:	or     $0x1,%rdx
   f4ade:	mov    0x20(%rdi),%rbx
   f4ae2:	mulx   0x10(%rdi),%r14,%r14
   f4ae8:	imul   %r10,%rdx
   f4aec:	shl    $0x6,%r14
   f4af0:	vpbroadcastq %rdx,%ymm2
   f4af6:	vpsllvq %ymm0,%ymm2,%ymm2
   f4afb:	vpsrld $0x1b,%ymm2,%ymm2
   f4b00:	vpsllvd %ymm2,%ymm1,%ymm2
   f4b05:	vmovdqa (%rbx,%r14,1),%ymm3
   f4b0b:	vptest %ymm2,%ymm3
   f4b10:	setb   %bpl
   f4b14:	mulx   %r11,%rdx,%r15
   f4b19:	xor    %rdx,%r15
   f4b1c:	vpbroadcastq %r15,%ymm2
   f4b22:	vmovdqa 0x20(%rbx,%r14,1),%ymm3
   f4b29:	vpsllvq %ymm0,%ymm2,%ymm2
   f4b2e:	vpsrld $0x1b,%ymm2,%ymm2
   f4b33:	vpsllvd %ymm2,%ymm1,%ymm2
   f4b38:	vptest %ymm2,%ymm3
   f4b3d:	setb   %dl
   f4b40:	prefetcht0 (%rbx,%r14,1)
   f4b45:	and    %bpl,%dl
   f4b48:	movzbl %dl,%edx
   f4b4b:	mov    %edx,(%rcx,%r9,4)
   f4b4f:	inc    %r9
   f4b52:	cmp    %r9,%rsi
   f4b55:	jne    f4ab0 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<16ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<16ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
   f4b5b:	pop    %rbx
   f4b5c:	pop    %r14
   f4b5e:	pop    %r15
   f4b60:	pop    %rbp
   f4b61:	vzeroupper
   f4b64:	ret
   f4b65:	int3
   f4b66:	int3
   f4b67:	int3
   f4b68:	int3
   f4b69:	int3
   f4b6a:	int3
   f4b6b:	int3
   f4b6c:	int3
   f4b6d:	int3
   f4b6e:	int3
   f4b6f:	int3

