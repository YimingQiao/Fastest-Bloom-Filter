0000000000124ec0 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 10ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 10ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
  124ec0:	test   %rsi,%rsi
  124ec3:	je     12501b <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 10ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 10ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x15b>
  124ec9:	push   %r15
  124ecb:	push   %r14
  124ecd:	push   %rbx
  124ece:	mov    %rdx,%rax
  124ed1:	xor    %r8d,%r8d
  124ed4:	movabs $0xf1357aea2e62a9c5,%r9
  124ede:	movabs $0x9e3779b97f4a7c15,%r10
  124ee8:	vmovdqa -0x120510(%rip),%ymm0        # 49e0 <typeinfo name for main::$_60+0x210>
  124ef0:	vmovdqa -0x120678(%rip),%ymm1        # 4880 <typeinfo name for main::$_60+0xb0>
  124ef8:	vpbroadcastd -0x121c7d(%rip),%xmm2        # 3284 <__abi_tag+0x2fc0>
  124f01:	vmovdqa -0x120609(%rip),%ymm3        # 4900 <typeinfo name for main::$_60+0x130>
  124f09:	vmovdqa -0x120551(%rip),%ymm4        # 49c0 <typeinfo name for main::$_60+0x1f0>
  124f11:	vpbroadcastq -0x121b7a(%rip),%ymm5        # 33a0 <_IO_stdin_used+0xec>
  124f1a:	nopw   0x0(%rax,%rax,1)
  124f20:	mov    (%rax,%r8,8),%rdx
  124f24:	or     $0x1,%rdx
  124f28:	mov    0x20(%rdi),%rbx
  124f2c:	mulx   0x10(%rdi),%r14,%r14
  124f32:	imul   %r9,%rdx
  124f36:	mulx   %r10,%r15,%r11
  124f3b:	xor    %r15,%r11
  124f3e:	shl    $0x6,%r14
  124f42:	vpbroadcastq %rdx,%ymm6
  124f48:	lea    (%rbx,%r14,1),%rdx
  124f4c:	vpbroadcastq %r11,%xmm7
  124f52:	vinserti128 $0x1,%xmm7,%ymm6,%ymm7
  124f58:	vpsrlvq %ymm1,%ymm6,%ymm8
  124f5d:	vpmovqd %ymm8,%xmm8
  124f63:	vpand  %xmm2,%xmm8,%xmm8
  124f67:	kxnorw %k0,%k0,%k1
  124f6b:	vpxor  %xmm9,%xmm9,%xmm9
  124f70:	vpgatherdq (%rdx,%xmm8,8),%ymm9{%k1}
  124f77:	vpsrlvq %ymm0,%ymm7,%ymm8
  124f7c:	vpmovqd %ymm8,%xmm8
  124f82:	vpand  %xmm2,%xmm8,%xmm8
  124f86:	kxnorw %k0,%k0,%k1
  124f8a:	vpxor  %xmm10,%xmm10,%xmm10
  124f8f:	vpgatherdq (%rdx,%xmm8,8),%ymm10{%k1}
  124f96:	prefetcht0 (%rbx,%r14,1)
  124f9b:	vpsrlvq %ymm3,%ymm7,%ymm7
  124fa0:	vpsrlvq %ymm4,%ymm6,%ymm6
  124fa5:	vpand  %ymm5,%ymm7,%ymm7
  124fa9:	vpsrlvq %ymm7,%ymm10,%ymm7
  124fae:	vpand  %ymm5,%ymm6,%ymm6
  124fb2:	mov    %r11d,%ebx
  124fb5:	shr    $0x18,%ebx
  124fb8:	and    $0x38,%ebx
  124fbb:	mov    %r11,%r14
  124fbe:	shr    $0x1e,%r14
  124fc2:	shrx   %r14,(%rbx,%rdx,1),%rbx
  124fc8:	vpsrlvq %ymm6,%ymm9,%ymm6
  124fcd:	mov    %r11,%r14
  124fd0:	shr    $0x24,%r14
  124fd4:	and    $0x7,%r14d
  124fd8:	shr    $0x27,%r11
  124fdc:	shrx   %r11,(%rdx,%r14,8),%rdx
  124fe2:	vpand  %ymm7,%ymm6,%ymm6
  124fe6:	vextracti128 $0x1,%ymm6,%xmm7
  124fec:	vpand  %xmm7,%xmm6,%xmm6
  124ff0:	vpshufd $0xee,%xmm6,%xmm7
  124ff5:	vpand  %xmm6,%xmm7,%xmm6
  124ff9:	vmovd  %xmm6,%r11d
  124ffe:	and    %edx,%ebx
  125000:	and    %r11d,%ebx
  125003:	and    $0x1,%ebx
  125006:	mov    %ebx,(%rcx,%r8,4)
  12500a:	inc    %r8
  12500d:	cmp    %r8,%rsi
  125010:	jne    124f20 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 10ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 10ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x60>
  125016:	pop    %rbx
  125017:	pop    %r14
  125019:	pop    %r15
  12501b:	vzeroupper
  12501e:	ret
  12501f:	int3

