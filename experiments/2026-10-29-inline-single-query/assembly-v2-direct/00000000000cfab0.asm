00000000000cfab0 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<5ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<5ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
   cfab0:	test   %rsi,%rsi
   cfab3:	je     cfbf9 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<5ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<5ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x149>
   cfab9:	push   %rbx
   cfaba:	mov    %rdx,%rax
   cfabd:	movabs $0xf1357aea2e62a9c5,%r9
   cfac7:	cmp    $0x1,%rsi
   cfacb:	jne    cfad5 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<5ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<5ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x25>
   cfacd:	xor    %r8d,%r8d
   cfad0:	jmp    cfba1 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<5ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<5ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0xf1>
   cfad5:	mov    %rsi,%r10
   cfad8:	and    $0xfffffffffffffffe,%r10
   cfadc:	xor    %r8d,%r8d
   cfadf:	vmovdqa -0xcafa7(%rip),%ymm0        # 4b40 <typeinfo name for main::$_60+0x370>
   cfae7:	vmovdqa -0xcb0cf(%rip),%ymm1        # 4a20 <typeinfo name for main::$_60+0x250>
   cfaef:	nop
   cfaf0:	mov    (%rax,%r8,8),%rdx
   cfaf4:	or     $0x1,%rdx
   cfaf8:	mov    0x20(%rdi),%r11
   cfafc:	mulx   0x10(%rdi),%rbx,%rbx
   cfb02:	lea    (%rbx,%rbx,4),%rbx
   cfb06:	prefetcht0 (%r11,%rbx,4)
   cfb0b:	prefetcht0 0x40(%r11,%rbx,4)
   cfb11:	imul   %r9,%rdx
   cfb15:	vmovdqu (%r11,%rbx,4),%ymm2
   cfb1b:	vpbroadcastq %rdx,%ymm3
   cfb21:	vpsllvq %ymm0,%ymm3,%ymm3
   cfb26:	vpsrld $0x1b,%ymm3,%ymm3
   cfb2b:	vpsllvd %ymm3,%ymm1,%ymm3
   cfb30:	xor    %edx,%edx
   cfb32:	vptest %ymm3,%ymm2
   cfb37:	setb   %dl
   cfb3a:	mov    %edx,(%rcx,%r8,4)
   cfb3e:	mov    0x8(%rax,%r8,8),%rdx
   cfb43:	or     $0x1,%rdx
   cfb47:	mov    0x20(%rdi),%r11
   cfb4b:	mulx   0x10(%rdi),%rbx,%rbx
   cfb51:	lea    (%rbx,%rbx,4),%rbx
   cfb55:	prefetcht0 (%r11,%rbx,4)
   cfb5a:	prefetcht0 0x40(%r11,%rbx,4)
   cfb60:	imul   %r9,%rdx
   cfb64:	vmovdqu (%r11,%rbx,4),%ymm2
   cfb6a:	vpbroadcastq %rdx,%ymm3
   cfb70:	vpsllvq %ymm0,%ymm3,%ymm3
   cfb75:	vpsrld $0x1b,%ymm3,%ymm3
   cfb7a:	vpsllvd %ymm3,%ymm1,%ymm3
   cfb7f:	xor    %edx,%edx
   cfb81:	vptest %ymm3,%ymm2
   cfb86:	setb   %dl
   cfb89:	mov    %edx,0x4(%rcx,%r8,4)
   cfb8e:	add    $0x2,%r8
   cfb92:	cmp    %r8,%r10
   cfb95:	jne    cfaf0 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<5ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<5ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
   cfb9b:	test   $0x1,%sil
   cfb9f:	je     cfbf8 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<5ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<5ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x148>
   cfba1:	mov    (%rax,%r8,8),%rdx
   cfba5:	or     $0x1,%rdx
   cfba9:	mov    0x20(%rdi),%rax
   cfbad:	mulx   0x10(%rdi),%rsi,%rsi
   cfbb3:	lea    (%rsi,%rsi,4),%rsi
   cfbb7:	prefetcht0 (%rax,%rsi,4)
   cfbbb:	prefetcht0 0x40(%rax,%rsi,4)
   cfbc0:	imul   %r9,%rdx
   cfbc4:	vmovdqu (%rax,%rsi,4),%ymm0
   cfbc9:	vpbroadcastq %rdx,%ymm1
   cfbcf:	vpsllvq -0xcb098(%rip),%ymm1,%ymm1        # 4b40 <typeinfo name for main::$_60+0x370>
   cfbd8:	vpsrld $0x1b,%ymm1,%ymm1
   cfbdd:	vmovdqa -0xcb1c5(%rip),%ymm2        # 4a20 <typeinfo name for main::$_60+0x250>
   cfbe5:	vpsllvd %ymm1,%ymm2,%ymm1
   cfbea:	xor    %eax,%eax
   cfbec:	vptest %ymm1,%ymm0
   cfbf1:	setb   %al
   cfbf4:	mov    %eax,(%rcx,%r8,4)
   cfbf8:	pop    %rbx
   cfbf9:	vzeroupper
   cfbfc:	ret
   cfbfd:	int3
   cfbfe:	int3
   cfbff:	int3

