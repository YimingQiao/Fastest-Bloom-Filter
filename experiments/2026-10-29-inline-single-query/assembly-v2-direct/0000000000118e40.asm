0000000000118e40 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 6ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 6ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
  118e40:	test   %rsi,%rsi
  118e43:	je     118f64 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 6ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 6ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x124>
  118e49:	push   %r14
  118e4b:	push   %rbx
  118e4c:	mov    %rdx,%rax
  118e4f:	movabs $0xd6e8feb86659fd93,%r8
  118e59:	xor    %r9d,%r9d
  118e5c:	movabs $0xf1357aea2e62a9c5,%r10
  118e66:	vmovdqa -0x1145ee(%rip),%ymm0        # 4880 <typeinfo name for main::$_60+0xb0>
  118e6e:	vpbroadcastq -0x115a97(%rip),%ymm1        # 33e0 <_IO_stdin_used+0x12c>
  118e77:	vmovdqa -0x1144bf(%rip),%ymm2        # 49c0 <typeinfo name for main::$_60+0x1f0>
  118e7f:	vpbroadcastq -0x115ae8(%rip),%ymm3        # 33a0 <_IO_stdin_used+0xec>
  118e88:	nopl   0x0(%rax,%rax,1)
  118e90:	mov    (%rax,%r9,8),%rdx
  118e94:	mov    %rdx,%r11
  118e97:	shr    $0x20,%r11
  118e9b:	xor    %rdx,%r11
  118e9e:	imul   %r8,%r11
  118ea2:	mov    %r11,%rbx
  118ea5:	shr    $0x20,%rbx
  118ea9:	xor    %r11,%rbx
  118eac:	imul   %r8,%rbx
  118eb0:	mov    %rbx,%rdx
  118eb3:	shr    $0x20,%rdx
  118eb7:	xor    %rbx,%rdx
  118eba:	or     $0x1,%rdx
  118ebe:	mov    0x20(%rdi),%rbx
  118ec2:	mulx   0x10(%rdi),%r14,%r14
  118ec8:	imul   %r10,%rdx
  118ecc:	shl    $0x6,%r14
  118ed0:	lea    (%rbx,%r14,1),%r11
  118ed4:	prefetcht0 (%rbx,%r14,1)
  118ed9:	vpbroadcastq %rdx,%ymm4
  118edf:	vpsrlvq %ymm0,%ymm4,%ymm5
  118ee4:	vpand  %ymm1,%ymm5,%ymm5
  118ee8:	kxnorw %k0,%k0,%k1
  118eec:	vpxor  %xmm6,%xmm6,%xmm6
  118ef0:	vpgatherqq (%r11,%ymm5,8),%ymm6{%k1}
  118ef7:	vpsrlvq %ymm2,%ymm4,%ymm4
  118efc:	mov    %rdx,%rbx
  118eff:	shr    $0x2d,%rbx
  118f03:	and    $0x7,%ebx
  118f06:	mov    %rdx,%r14
  118f09:	shr    $0x30,%r14
  118f0d:	shrx   %r14,(%r11,%rbx,8),%rbx
  118f13:	vpand  %ymm3,%ymm4,%ymm4
  118f17:	mov    %rdx,%r14
  118f1a:	shr    $0x36,%r14
  118f1e:	and    $0x7,%r14d
  118f22:	shr    $0x39,%rdx
  118f26:	shrx   %rdx,(%r11,%r14,8),%rdx
  118f2c:	vpsrlvq %ymm4,%ymm6,%ymm4
  118f31:	vextracti128 $0x1,%ymm4,%xmm5
  118f37:	vpand  %xmm5,%xmm4,%xmm4
  118f3b:	vpshufd $0xee,%xmm4,%xmm5
  118f40:	vpand  %xmm4,%xmm5,%xmm4
  118f44:	vmovd  %xmm4,%r11d
  118f49:	and    %edx,%ebx
  118f4b:	and    %r11d,%ebx
  118f4e:	and    $0x1,%ebx
  118f51:	mov    %ebx,(%rcx,%r9,4)
  118f55:	inc    %r9
  118f58:	cmp    %r9,%rsi
  118f5b:	jne    118e90 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 6ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 6ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  118f61:	pop    %rbx
  118f62:	pop    %r14
  118f64:	vzeroupper
  118f67:	ret
  118f68:	int3
  118f69:	int3
  118f6a:	int3
  118f6b:	int3
  118f6c:	int3
  118f6d:	int3
  118f6e:	int3
  118f6f:	int3

