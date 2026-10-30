0000000000118ec0 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 6ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 6ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
  118ec0:	test   %rsi,%rsi
  118ec3:	je     118fe4 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 6ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 6ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x124>
  118ec9:	push   %r14
  118ecb:	push   %rbx
  118ecc:	mov    %rdx,%rax
  118ecf:	movabs $0xd6e8feb86659fd93,%r8
  118ed9:	xor    %r9d,%r9d
  118edc:	movabs $0xf1357aea2e62a9c5,%r10
  118ee6:	vmovdqa -0x11466e(%rip),%ymm0        # 4880 <typeinfo name for main::$_60+0xb0>
  118eee:	vpbroadcastq -0x115b17(%rip),%ymm1        # 33e0 <_IO_stdin_used+0x12c>
  118ef7:	vmovdqa -0x11453f(%rip),%ymm2        # 49c0 <typeinfo name for main::$_60+0x1f0>
  118eff:	vpbroadcastq -0x115b68(%rip),%ymm3        # 33a0 <_IO_stdin_used+0xec>
  118f08:	nopl   0x0(%rax,%rax,1)
  118f10:	mov    (%rax,%r9,8),%rdx
  118f14:	mov    %rdx,%r11
  118f17:	shr    $0x20,%r11
  118f1b:	xor    %rdx,%r11
  118f1e:	imul   %r8,%r11
  118f22:	mov    %r11,%rbx
  118f25:	shr    $0x20,%rbx
  118f29:	xor    %r11,%rbx
  118f2c:	imul   %r8,%rbx
  118f30:	mov    %rbx,%rdx
  118f33:	shr    $0x20,%rdx
  118f37:	xor    %rbx,%rdx
  118f3a:	or     $0x1,%rdx
  118f3e:	mov    0x20(%rdi),%rbx
  118f42:	mulx   0x10(%rdi),%r14,%r14
  118f48:	shl    $0x6,%r14
  118f4c:	lea    (%rbx,%r14,1),%r11
  118f50:	prefetcht0 (%rbx,%r14,1)
  118f55:	imul   %r10,%rdx
  118f59:	vpbroadcastq %rdx,%ymm4
  118f5f:	vpsrlvq %ymm0,%ymm4,%ymm5
  118f64:	vpand  %ymm1,%ymm5,%ymm5
  118f68:	kxnorw %k0,%k0,%k1
  118f6c:	vpxor  %xmm6,%xmm6,%xmm6
  118f70:	vpgatherqq (%r11,%ymm5,8),%ymm6{%k1}
  118f77:	vpsrlvq %ymm2,%ymm4,%ymm4
  118f7c:	mov    %rdx,%rbx
  118f7f:	shr    $0x2d,%rbx
  118f83:	and    $0x7,%ebx
  118f86:	mov    %rdx,%r14
  118f89:	shr    $0x30,%r14
  118f8d:	shrx   %r14,(%r11,%rbx,8),%rbx
  118f93:	vpand  %ymm3,%ymm4,%ymm4
  118f97:	mov    %rdx,%r14
  118f9a:	shr    $0x36,%r14
  118f9e:	and    $0x7,%r14d
  118fa2:	shr    $0x39,%rdx
  118fa6:	shrx   %rdx,(%r11,%r14,8),%rdx
  118fac:	vpsrlvq %ymm4,%ymm6,%ymm4
  118fb1:	vextracti128 $0x1,%ymm4,%xmm5
  118fb7:	vpand  %xmm5,%xmm4,%xmm4
  118fbb:	vpshufd $0xee,%xmm4,%xmm5
  118fc0:	vpand  %xmm4,%xmm5,%xmm4
  118fc4:	vmovd  %xmm4,%r11d
  118fc9:	and    %edx,%ebx
  118fcb:	and    %r11d,%ebx
  118fce:	and    $0x1,%ebx
  118fd1:	mov    %ebx,(%rcx,%r9,4)
  118fd5:	inc    %r9
  118fd8:	cmp    %r9,%rsi
  118fdb:	jne    118f10 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 6ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 6ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  118fe1:	pop    %rbx
  118fe2:	pop    %r14
  118fe4:	vzeroupper
  118fe7:	ret
  118fe8:	int3
  118fe9:	int3
  118fea:	int3
  118feb:	int3
  118fec:	int3
  118fed:	int3
  118fee:	int3
  118fef:	int3

