000000000011eb40 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
  11eb40:	test   %rsi,%rsi
  11eb43:	je     11ec6a <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x12a>
  11eb49:	push   %r15
  11eb4b:	push   %r14
  11eb4d:	push   %rbx
  11eb4e:	mov    %rdx,%rax
  11eb51:	xor    %r8d,%r8d
  11eb54:	movabs $0xf1357aea2e62a9c5,%r9
  11eb5e:	movabs $0x9e3779b97f4a7c15,%r10
  11eb68:	vmovdqa -0x11a190(%rip),%ymm0        # 49e0 <typeinfo name for main::$_60+0x210>
  11eb70:	vmovdqa -0x11a2f8(%rip),%ymm1        # 4880 <typeinfo name for main::$_60+0xb0>
  11eb78:	vpbroadcastd -0x11b8fd(%rip),%xmm2        # 3284 <__abi_tag+0x2fc0>
  11eb81:	vmovdqa -0x11a289(%rip),%ymm3        # 4900 <typeinfo name for main::$_60+0x130>
  11eb89:	vmovdqa -0x11a1d1(%rip),%ymm4        # 49c0 <typeinfo name for main::$_60+0x1f0>
  11eb91:	vpbroadcastq -0x11b7fa(%rip),%ymm5        # 33a0 <_IO_stdin_used+0xec>
  11eb9a:	nopw   0x0(%rax,%rax,1)
  11eba0:	mov    (%rax,%r8,8),%rdx
  11eba4:	or     $0x1,%rdx
  11eba8:	mov    0x20(%rdi),%r11
  11ebac:	mulx   0x10(%rdi),%rbx,%rbx
  11ebb2:	imul   %r9,%rdx
  11ebb6:	mulx   %r10,%r14,%r15
  11ebbb:	xor    %r14,%r15
  11ebbe:	shl    $0x6,%rbx
  11ebc2:	vpbroadcastq %rdx,%ymm6
  11ebc8:	lea    (%r11,%rbx,1),%rdx
  11ebcc:	vpbroadcastq %r15,%xmm7
  11ebd2:	vinserti128 $0x1,%xmm7,%ymm6,%ymm7
  11ebd8:	vpsrlvq %ymm1,%ymm6,%ymm8
  11ebdd:	vpmovqd %ymm8,%xmm8
  11ebe3:	vpand  %xmm2,%xmm8,%xmm8
  11ebe7:	kxnorw %k0,%k0,%k1
  11ebeb:	vpxor  %xmm9,%xmm9,%xmm9
  11ebf0:	vpgatherdq (%rdx,%xmm8,8),%ymm9{%k1}
  11ebf7:	vpsrlvq %ymm0,%ymm7,%ymm8
  11ebfc:	vpmovqd %ymm8,%xmm8
  11ec02:	vpand  %xmm2,%xmm8,%xmm8
  11ec06:	kxnorw %k0,%k0,%k1
  11ec0a:	vpxor  %xmm10,%xmm10,%xmm10
  11ec0f:	vpgatherdq (%rdx,%xmm8,8),%ymm10{%k1}
  11ec16:	prefetcht0 (%r11,%rbx,1)
  11ec1b:	vpsrlvq %ymm3,%ymm7,%ymm7
  11ec20:	vpsrlvq %ymm4,%ymm6,%ymm6
  11ec25:	vpand  %ymm5,%ymm7,%ymm7
  11ec29:	vpsrlvq %ymm7,%ymm10,%ymm7
  11ec2e:	vpand  %ymm5,%ymm6,%ymm6
  11ec32:	vpsrlvq %ymm6,%ymm9,%ymm6
  11ec37:	vpand  %ymm7,%ymm6,%ymm6
  11ec3b:	vextracti128 $0x1,%ymm6,%xmm7
  11ec41:	vpand  %xmm7,%xmm6,%xmm6
  11ec45:	vpshufd $0xee,%xmm6,%xmm7
  11ec4a:	vpand  %xmm6,%xmm7,%xmm6
  11ec4e:	vmovd  %xmm6,%edx
  11ec52:	and    $0x1,%edx
  11ec55:	mov    %edx,(%rcx,%r8,4)
  11ec59:	inc    %r8
  11ec5c:	cmp    %r8,%rsi
  11ec5f:	jne    11eba0 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x60>
  11ec65:	pop    %rbx
  11ec66:	pop    %r14
  11ec68:	pop    %r15
  11ec6a:	vzeroupper
  11ec6d:	ret
  11ec6e:	int3
  11ec6f:	int3

