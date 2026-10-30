00000000000c9e00 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
   c9e00:	test   %rsi,%rsi
   c9e03:	je     c9fcd <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x1cd>
   c9e09:	push   %r14
   c9e0b:	push   %rbx
   c9e0c:	mov    %rdx,%rax
   c9e0f:	movabs $0xf1357aea2e62a9c5,%r9
   c9e19:	movabs $0xd6e8feb86659fd93,%r10
   c9e23:	cmp    $0x1,%rsi
   c9e27:	jne    c9e31 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x31>
   c9e29:	xor    %r8d,%r8d
   c9e2c:	jmp    c9f4d <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x14d>
   c9e31:	mov    %rsi,%r11
   c9e34:	and    $0xfffffffffffffffe,%r11
   c9e38:	xor    %r8d,%r8d
   c9e3b:	vmovdqa -0xc5303(%rip),%ymm0        # 4b40 <typeinfo name for main::$_60+0x370>
   c9e43:	vpbroadcastd -0xc6ba4(%rip),%xmm1        # 32a8 <__abi_tag+0x2fe4>
   c9e4c:	nopl   0x0(%rax)
   c9e50:	mov    (%rax,%r8,8),%rdx
   c9e54:	mov    %rdx,%rbx
   c9e57:	shr    $0x20,%rbx
   c9e5b:	xor    %rdx,%rbx
   c9e5e:	imul   %r10,%rbx
   c9e62:	mov    %rbx,%r14
   c9e65:	shr    $0x20,%r14
   c9e69:	xor    %rbx,%r14
   c9e6c:	imul   %r10,%r14
   c9e70:	mov    %r14,%rdx
   c9e73:	shr    $0x20,%rdx
   c9e77:	xor    %r14,%rdx
   c9e7a:	or     $0x1,%rdx
   c9e7e:	mov    0x20(%rdi),%rbx
   c9e82:	mulx   0x10(%rdi),%r14,%r14
   c9e88:	shl    $0x4,%r14
   c9e8c:	prefetcht0 (%rbx,%r14,1)
   c9e91:	imul   %r9,%rdx
   c9e95:	vmovdqu (%rbx,%r14,1),%ymm2
   c9e9b:	vpbroadcastq %rdx,%ymm3
   c9ea1:	vpsllvq %ymm0,%ymm3,%ymm3
   c9ea6:	vpsrld $0x1b,%ymm3,%ymm3
   c9eab:	vpsllvd %ymm3,%ymm1,%ymm3
   c9eb0:	xor    %edx,%edx
   c9eb2:	vptest %ymm3,%ymm2
   c9eb7:	prefetcht0 0x40(%rbx,%r14,1)
   c9ebd:	setb   %dl
   c9ec0:	mov    %edx,(%rcx,%r8,4)
   c9ec4:	mov    0x8(%rax,%r8,8),%rdx
   c9ec9:	mov    %rdx,%rbx
   c9ecc:	shr    $0x20,%rbx
   c9ed0:	xor    %rdx,%rbx
   c9ed3:	imul   %r10,%rbx
   c9ed7:	mov    %rbx,%r14
   c9eda:	shr    $0x20,%r14
   c9ede:	xor    %rbx,%r14
   c9ee1:	imul   %r10,%r14
   c9ee5:	mov    %r14,%rdx
   c9ee8:	shr    $0x20,%rdx
   c9eec:	xor    %r14,%rdx
   c9eef:	or     $0x1,%rdx
   c9ef3:	mov    0x20(%rdi),%rbx
   c9ef7:	mulx   0x10(%rdi),%r14,%r14
   c9efd:	shl    $0x4,%r14
   c9f01:	prefetcht0 (%rbx,%r14,1)
   c9f06:	prefetcht0 0x40(%rbx,%r14,1)
   c9f0c:	imul   %r9,%rdx
   c9f10:	vmovdqu (%rbx,%r14,1),%ymm2
   c9f16:	vpbroadcastq %rdx,%ymm3
   c9f1c:	vpsllvq %ymm0,%ymm3,%ymm3
   c9f21:	vpsrld $0x1b,%ymm3,%ymm3
   c9f26:	vpsllvd %ymm3,%ymm1,%ymm3
   c9f2b:	xor    %edx,%edx
   c9f2d:	vptest %ymm3,%ymm2
   c9f32:	setb   %dl
   c9f35:	mov    %edx,0x4(%rcx,%r8,4)
   c9f3a:	add    $0x2,%r8
   c9f3e:	cmp    %r8,%r11
   c9f41:	jne    c9e50 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
   c9f47:	test   $0x1,%sil
   c9f4b:	je     c9fca <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x1ca>
   c9f4d:	mov    (%rax,%r8,8),%rax
   c9f51:	mov    %rax,%rdx
   c9f54:	shr    $0x20,%rdx
   c9f58:	xor    %rax,%rdx
   c9f5b:	imul   %r10,%rdx
   c9f5f:	mov    %rdx,%rax
   c9f62:	shr    $0x20,%rax
   c9f66:	xor    %rdx,%rax
   c9f69:	imul   %r10,%rax
   c9f6d:	mov    %rax,%rdx
   c9f70:	shr    $0x20,%rdx
   c9f74:	xor    %rax,%rdx
   c9f77:	or     $0x1,%rdx
   c9f7b:	mov    0x20(%rdi),%rax
   c9f7f:	mulx   0x10(%rdi),%rsi,%rsi
   c9f85:	shl    $0x4,%rsi
   c9f89:	prefetcht0 (%rax,%rsi,1)
   c9f8d:	prefetcht0 0x40(%rax,%rsi,1)
   c9f92:	imul   %r9,%rdx
   c9f96:	vmovdqu (%rax,%rsi,1),%ymm0
   c9f9b:	vpbroadcastq %rdx,%ymm1
   c9fa1:	vpsllvq -0xc546a(%rip),%ymm1,%ymm1        # 4b40 <typeinfo name for main::$_60+0x370>
   c9faa:	vpsrld $0x1b,%ymm1,%ymm1
   c9faf:	vmovdqa -0xc5657(%rip),%ymm2        # 4960 <typeinfo name for main::$_60+0x190>
   c9fb7:	vpsllvd %ymm1,%ymm2,%ymm1
   c9fbc:	xor    %eax,%eax
   c9fbe:	vptest %ymm1,%ymm0
   c9fc3:	setb   %al
   c9fc6:	mov    %eax,(%rcx,%r8,4)
   c9fca:	pop    %rbx
   c9fcb:	pop    %r14
   c9fcd:	vzeroupper
   c9fd0:	ret
   c9fd1:	int3
   c9fd2:	int3
   c9fd3:	int3
   c9fd4:	int3
   c9fd5:	int3
   c9fd6:	int3
   c9fd7:	int3
   c9fd8:	int3
   c9fd9:	int3
   c9fda:	int3
   c9fdb:	int3
   c9fdc:	int3
   c9fdd:	int3
   c9fde:	int3
   c9fdf:	int3

