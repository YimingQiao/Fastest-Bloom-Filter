00000000000d5cf0 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<6ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<6ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
   d5cf0:	test   %rsi,%rsi
   d5cf3:	je     d5e39 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<6ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<6ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x149>
   d5cf9:	push   %rbx
   d5cfa:	mov    %rdx,%rax
   d5cfd:	movabs $0xf1357aea2e62a9c5,%r9
   d5d07:	cmp    $0x1,%rsi
   d5d0b:	jne    d5d15 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<6ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<6ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x25>
   d5d0d:	xor    %r8d,%r8d
   d5d10:	jmp    d5de1 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<6ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<6ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0xf1>
   d5d15:	mov    %rsi,%r10
   d5d18:	and    $0xfffffffffffffffe,%r10
   d5d1c:	xor    %r8d,%r8d
   d5d1f:	vmovdqa -0xd11e7(%rip),%ymm0        # 4b40 <typeinfo name for main::$_60+0x370>
   d5d27:	vmovdqa -0xd14cf(%rip),%ymm1        # 4860 <typeinfo name for main::$_60+0x90>
   d5d2f:	nop
   d5d30:	mov    (%rax,%r8,8),%rdx
   d5d34:	or     $0x1,%rdx
   d5d38:	mov    0x20(%rdi),%r11
   d5d3c:	mulx   0x10(%rdi),%rbx,%rbx
   d5d42:	lea    (%rbx,%rbx,2),%rbx
   d5d46:	prefetcht0 (%r11,%rbx,8)
   d5d4b:	prefetcht0 0x40(%r11,%rbx,8)
   d5d51:	imul   %r9,%rdx
   d5d55:	vmovdqu (%r11,%rbx,8),%ymm2
   d5d5b:	vpbroadcastq %rdx,%ymm3
   d5d61:	vpsllvq %ymm0,%ymm3,%ymm3
   d5d66:	vpsrld $0x1b,%ymm3,%ymm3
   d5d6b:	vpsllvd %ymm3,%ymm1,%ymm3
   d5d70:	xor    %edx,%edx
   d5d72:	vptest %ymm3,%ymm2
   d5d77:	setb   %dl
   d5d7a:	mov    %edx,(%rcx,%r8,4)
   d5d7e:	mov    0x8(%rax,%r8,8),%rdx
   d5d83:	or     $0x1,%rdx
   d5d87:	mov    0x20(%rdi),%r11
   d5d8b:	mulx   0x10(%rdi),%rbx,%rbx
   d5d91:	lea    (%rbx,%rbx,2),%rbx
   d5d95:	prefetcht0 (%r11,%rbx,8)
   d5d9a:	prefetcht0 0x40(%r11,%rbx,8)
   d5da0:	imul   %r9,%rdx
   d5da4:	vmovdqu (%r11,%rbx,8),%ymm2
   d5daa:	vpbroadcastq %rdx,%ymm3
   d5db0:	vpsllvq %ymm0,%ymm3,%ymm3
   d5db5:	vpsrld $0x1b,%ymm3,%ymm3
   d5dba:	vpsllvd %ymm3,%ymm1,%ymm3
   d5dbf:	xor    %edx,%edx
   d5dc1:	vptest %ymm3,%ymm2
   d5dc6:	setb   %dl
   d5dc9:	mov    %edx,0x4(%rcx,%r8,4)
   d5dce:	add    $0x2,%r8
   d5dd2:	cmp    %r8,%r10
   d5dd5:	jne    d5d30 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<6ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<6ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
   d5ddb:	test   $0x1,%sil
   d5ddf:	je     d5e38 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<6ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<6ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x148>
   d5de1:	mov    (%rax,%r8,8),%rdx
   d5de5:	or     $0x1,%rdx
   d5de9:	mov    0x20(%rdi),%rax
   d5ded:	mulx   0x10(%rdi),%rsi,%rsi
   d5df3:	lea    (%rsi,%rsi,2),%rsi
   d5df7:	prefetcht0 (%rax,%rsi,8)
   d5dfb:	prefetcht0 0x40(%rax,%rsi,8)
   d5e00:	imul   %r9,%rdx
   d5e04:	vmovdqu (%rax,%rsi,8),%ymm0
   d5e09:	vpbroadcastq %rdx,%ymm1
   d5e0f:	vpsllvq -0xd12d8(%rip),%ymm1,%ymm1        # 4b40 <typeinfo name for main::$_60+0x370>
   d5e18:	vpsrld $0x1b,%ymm1,%ymm1
   d5e1d:	vmovdqa -0xd15c5(%rip),%ymm2        # 4860 <typeinfo name for main::$_60+0x90>
   d5e25:	vpsllvd %ymm1,%ymm2,%ymm1
   d5e2a:	xor    %eax,%eax
   d5e2c:	vptest %ymm1,%ymm0
   d5e31:	setb   %al
   d5e34:	mov    %eax,(%rcx,%r8,4)
   d5e38:	pop    %rbx
   d5e39:	vzeroupper
   d5e3c:	ret
   d5e3d:	int3
   d5e3e:	int3
   d5e3f:	int3

