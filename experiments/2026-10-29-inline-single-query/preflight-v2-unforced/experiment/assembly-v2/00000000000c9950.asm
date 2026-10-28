00000000000c9950 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
   c9950:	test   %rsi,%rsi
   c9953:	je     c9a99 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x149>
   c9959:	push   %rbx
   c995a:	mov    %rdx,%rax
   c995d:	movabs $0xf1357aea2e62a9c5,%r9
   c9967:	cmp    $0x1,%rsi
   c996b:	jne    c9975 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x25>
   c996d:	xor    %r8d,%r8d
   c9970:	jmp    c9a41 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0xf1>
   c9975:	mov    %rsi,%r10
   c9978:	and    $0xfffffffffffffffe,%r10
   c997c:	xor    %r8d,%r8d
   c997f:	vmovdqa -0xc4e47(%rip),%ymm0        # 4b40 <typeinfo name for main::$_60+0x370>
   c9987:	vpbroadcastd -0xc66e8(%rip),%xmm1        # 32a8 <__abi_tag+0x2fe4>
   c9990:	mov    (%rax,%r8,8),%rdx
   c9994:	or     $0x1,%rdx
   c9998:	mov    0x20(%rdi),%r11
   c999c:	mulx   0x10(%rdi),%rbx,%rbx
   c99a2:	shl    $0x4,%rbx
   c99a6:	prefetcht0 (%r11,%rbx,1)
   c99ab:	prefetcht0 0x40(%r11,%rbx,1)
   c99b1:	imul   %r9,%rdx
   c99b5:	vmovdqu (%r11,%rbx,1),%ymm2
   c99bb:	vpbroadcastq %rdx,%ymm3
   c99c1:	vpsllvq %ymm0,%ymm3,%ymm3
   c99c6:	vpsrld $0x1b,%ymm3,%ymm3
   c99cb:	vpsllvd %ymm3,%ymm1,%ymm3
   c99d0:	xor    %edx,%edx
   c99d2:	vptest %ymm3,%ymm2
   c99d7:	setb   %dl
   c99da:	mov    %edx,(%rcx,%r8,4)
   c99de:	mov    0x8(%rax,%r8,8),%rdx
   c99e3:	or     $0x1,%rdx
   c99e7:	mov    0x20(%rdi),%r11
   c99eb:	mulx   0x10(%rdi),%rbx,%rbx
   c99f1:	shl    $0x4,%rbx
   c99f5:	prefetcht0 (%r11,%rbx,1)
   c99fa:	prefetcht0 0x40(%r11,%rbx,1)
   c9a00:	imul   %r9,%rdx
   c9a04:	vmovdqu (%r11,%rbx,1),%ymm2
   c9a0a:	vpbroadcastq %rdx,%ymm3
   c9a10:	vpsllvq %ymm0,%ymm3,%ymm3
   c9a15:	vpsrld $0x1b,%ymm3,%ymm3
   c9a1a:	vpsllvd %ymm3,%ymm1,%ymm3
   c9a1f:	xor    %edx,%edx
   c9a21:	vptest %ymm3,%ymm2
   c9a26:	setb   %dl
   c9a29:	mov    %edx,0x4(%rcx,%r8,4)
   c9a2e:	add    $0x2,%r8
   c9a32:	cmp    %r8,%r10
   c9a35:	jne    c9990 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
   c9a3b:	test   $0x1,%sil
   c9a3f:	je     c9a98 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x148>
   c9a41:	mov    (%rax,%r8,8),%rdx
   c9a45:	or     $0x1,%rdx
   c9a49:	mov    0x20(%rdi),%rax
   c9a4d:	mulx   0x10(%rdi),%rsi,%rsi
   c9a53:	shl    $0x4,%rsi
   c9a57:	prefetcht0 (%rax,%rsi,1)
   c9a5b:	prefetcht0 0x40(%rax,%rsi,1)
   c9a60:	imul   %r9,%rdx
   c9a64:	vmovdqu (%rax,%rsi,1),%ymm0
   c9a69:	vpbroadcastq %rdx,%ymm1
   c9a6f:	vpsllvq -0xc4f38(%rip),%ymm1,%ymm1        # 4b40 <typeinfo name for main::$_60+0x370>
   c9a78:	vpsrld $0x1b,%ymm1,%ymm1
   c9a7d:	vmovdqa -0xc5125(%rip),%ymm2        # 4960 <typeinfo name for main::$_60+0x190>
   c9a85:	vpsllvd %ymm1,%ymm2,%ymm1
   c9a8a:	xor    %eax,%eax
   c9a8c:	vptest %ymm1,%ymm0
   c9a91:	setb   %al
   c9a94:	mov    %eax,(%rcx,%r8,4)
   c9a98:	pop    %rbx
   c9a99:	vzeroupper
   c9a9c:	ret
   c9a9d:	int3
   c9a9e:	int3
   c9a9f:	int3

