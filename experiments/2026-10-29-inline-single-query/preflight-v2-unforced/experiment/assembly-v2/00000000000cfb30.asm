00000000000cfb30 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<5ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<5ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
   cfb30:	test   %rsi,%rsi
   cfb33:	je     cfc79 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<5ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<5ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x149>
   cfb39:	push   %rbx
   cfb3a:	mov    %rdx,%rax
   cfb3d:	movabs $0xf1357aea2e62a9c5,%r9
   cfb47:	cmp    $0x1,%rsi
   cfb4b:	jne    cfb55 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<5ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<5ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x25>
   cfb4d:	xor    %r8d,%r8d
   cfb50:	jmp    cfc21 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<5ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<5ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0xf1>
   cfb55:	mov    %rsi,%r10
   cfb58:	and    $0xfffffffffffffffe,%r10
   cfb5c:	xor    %r8d,%r8d
   cfb5f:	vmovdqa -0xcb027(%rip),%ymm0        # 4b40 <typeinfo name for main::$_60+0x370>
   cfb67:	vmovdqa -0xcb14f(%rip),%ymm1        # 4a20 <typeinfo name for main::$_60+0x250>
   cfb6f:	nop
   cfb70:	mov    (%rax,%r8,8),%rdx
   cfb74:	or     $0x1,%rdx
   cfb78:	mov    0x20(%rdi),%r11
   cfb7c:	mulx   0x10(%rdi),%rbx,%rbx
   cfb82:	lea    (%rbx,%rbx,4),%rbx
   cfb86:	prefetcht0 (%r11,%rbx,4)
   cfb8b:	prefetcht0 0x40(%r11,%rbx,4)
   cfb91:	imul   %r9,%rdx
   cfb95:	vmovdqu (%r11,%rbx,4),%ymm2
   cfb9b:	vpbroadcastq %rdx,%ymm3
   cfba1:	vpsllvq %ymm0,%ymm3,%ymm3
   cfba6:	vpsrld $0x1b,%ymm3,%ymm3
   cfbab:	vpsllvd %ymm3,%ymm1,%ymm3
   cfbb0:	xor    %edx,%edx
   cfbb2:	vptest %ymm3,%ymm2
   cfbb7:	setb   %dl
   cfbba:	mov    %edx,(%rcx,%r8,4)
   cfbbe:	mov    0x8(%rax,%r8,8),%rdx
   cfbc3:	or     $0x1,%rdx
   cfbc7:	mov    0x20(%rdi),%r11
   cfbcb:	mulx   0x10(%rdi),%rbx,%rbx
   cfbd1:	lea    (%rbx,%rbx,4),%rbx
   cfbd5:	prefetcht0 (%r11,%rbx,4)
   cfbda:	prefetcht0 0x40(%r11,%rbx,4)
   cfbe0:	imul   %r9,%rdx
   cfbe4:	vmovdqu (%r11,%rbx,4),%ymm2
   cfbea:	vpbroadcastq %rdx,%ymm3
   cfbf0:	vpsllvq %ymm0,%ymm3,%ymm3
   cfbf5:	vpsrld $0x1b,%ymm3,%ymm3
   cfbfa:	vpsllvd %ymm3,%ymm1,%ymm3
   cfbff:	xor    %edx,%edx
   cfc01:	vptest %ymm3,%ymm2
   cfc06:	setb   %dl
   cfc09:	mov    %edx,0x4(%rcx,%r8,4)
   cfc0e:	add    $0x2,%r8
   cfc12:	cmp    %r8,%r10
   cfc15:	jne    cfb70 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<5ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<5ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
   cfc1b:	test   $0x1,%sil
   cfc1f:	je     cfc78 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<5ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<5ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x148>
   cfc21:	mov    (%rax,%r8,8),%rdx
   cfc25:	or     $0x1,%rdx
   cfc29:	mov    0x20(%rdi),%rax
   cfc2d:	mulx   0x10(%rdi),%rsi,%rsi
   cfc33:	lea    (%rsi,%rsi,4),%rsi
   cfc37:	prefetcht0 (%rax,%rsi,4)
   cfc3b:	prefetcht0 0x40(%rax,%rsi,4)
   cfc40:	imul   %r9,%rdx
   cfc44:	vmovdqu (%rax,%rsi,4),%ymm0
   cfc49:	vpbroadcastq %rdx,%ymm1
   cfc4f:	vpsllvq -0xcb118(%rip),%ymm1,%ymm1        # 4b40 <typeinfo name for main::$_60+0x370>
   cfc58:	vpsrld $0x1b,%ymm1,%ymm1
   cfc5d:	vmovdqa -0xcb245(%rip),%ymm2        # 4a20 <typeinfo name for main::$_60+0x250>
   cfc65:	vpsllvd %ymm1,%ymm2,%ymm1
   cfc6a:	xor    %eax,%eax
   cfc6c:	vptest %ymm1,%ymm0
   cfc71:	setb   %al
   cfc74:	mov    %eax,(%rcx,%r8,4)
   cfc78:	pop    %rbx
   cfc79:	vzeroupper
   cfc7c:	ret
   cfc7d:	int3
   cfc7e:	int3
   cfc7f:	int3

