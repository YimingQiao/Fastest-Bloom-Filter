00000000000eeaf0 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<12ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<12ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
   eeaf0:	test   %rsi,%rsi
   eeaf3:	je     eebfb <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<12ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<12ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x10b>
   eeaf9:	push   %rbp
   eeafa:	push   %r15
   eeafc:	push   %r14
   eeafe:	push   %rbx
   eeaff:	mov    %rdx,%rax
   eeb02:	movabs $0xd6e8feb86659fd93,%r8
   eeb0c:	xor    %r9d,%r9d
   eeb0f:	movabs $0xf1357aea2e62a9c5,%r10
   eeb19:	vmovdqa -0xe9fe1(%rip),%ymm0        # 4b40 <typeinfo name for main::$_60+0x370>
   eeb21:	vpbroadcastd -0xeb882(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
   eeb2a:	movabs $0x9e3779b97f4a7c15,%r11
   eeb34:	vmovdqa -0xea1dc(%rip),%ymm2        # 4960 <typeinfo name for main::$_60+0x190>
   eeb3c:	nopl   0x0(%rax)
   eeb40:	mov    (%rax,%r9,8),%rdx
   eeb44:	mov    %rdx,%rbx
   eeb47:	shr    $0x20,%rbx
   eeb4b:	xor    %rdx,%rbx
   eeb4e:	imul   %r8,%rbx
   eeb52:	mov    %rbx,%r14
   eeb55:	shr    $0x20,%r14
   eeb59:	xor    %rbx,%r14
   eeb5c:	imul   %r8,%r14
   eeb60:	mov    %r14,%rdx
   eeb63:	shr    $0x20,%rdx
   eeb67:	xor    %r14,%rdx
   eeb6a:	or     $0x1,%rdx
   eeb6e:	mov    0x20(%rdi),%rbx
   eeb72:	mulx   0x10(%rdi),%r14,%r14
   eeb78:	lea    (%r14,%r14,2),%r14
   eeb7c:	shl    $0x4,%r14
   eeb80:	imul   %r10,%rdx
   eeb84:	vmovdqu (%rbx,%r14,1),%ymm3
   eeb8a:	vpbroadcastq %rdx,%ymm4
   eeb90:	vpsllvq %ymm0,%ymm4,%ymm4
   eeb95:	vpsrld $0x1b,%ymm4,%ymm4
   eeb9a:	vpsllvd %ymm4,%ymm1,%ymm4
   eeb9f:	vptest %ymm4,%ymm3
   eeba4:	setb   %bpl
   eeba8:	mulx   %r11,%rdx,%r15
   eebad:	xor    %rdx,%r15
   eebb0:	vpbroadcastq %r15,%ymm3
   eebb6:	prefetcht0 (%rbx,%r14,1)
   eebbb:	vmovdqu 0x20(%rbx,%r14,1),%ymm4
   eebc2:	vpsllvq %ymm0,%ymm3,%ymm3
   eebc7:	vpsrld $0x1b,%ymm3,%ymm3
   eebcc:	vpsllvd %ymm3,%ymm2,%ymm3
   eebd1:	vptest %ymm3,%ymm4
   eebd6:	setb   %dl
   eebd9:	prefetcht0 0x40(%rbx,%r14,1)
   eebdf:	and    %bpl,%dl
   eebe2:	movzbl %dl,%edx
   eebe5:	mov    %edx,(%rcx,%r9,4)
   eebe9:	inc    %r9
   eebec:	cmp    %r9,%rsi
   eebef:	jne    eeb40 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<12ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<12ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
   eebf5:	pop    %rbx
   eebf6:	pop    %r14
   eebf8:	pop    %r15
   eebfa:	pop    %rbp
   eebfb:	vzeroupper
   eebfe:	ret
   eebff:	int3

