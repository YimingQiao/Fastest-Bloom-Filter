000000000011ebc0 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
  11ebc0:	test   %rsi,%rsi
  11ebc3:	je     11ecea <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x12a>
  11ebc9:	push   %r15
  11ebcb:	push   %r14
  11ebcd:	push   %rbx
  11ebce:	mov    %rdx,%rax
  11ebd1:	xor    %r8d,%r8d
  11ebd4:	movabs $0xf1357aea2e62a9c5,%r9
  11ebde:	movabs $0x9e3779b97f4a7c15,%r10
  11ebe8:	vmovdqa -0x11a210(%rip),%ymm0        # 49e0 <typeinfo name for main::$_60+0x210>
  11ebf0:	vmovdqa -0x11a378(%rip),%ymm1        # 4880 <typeinfo name for main::$_60+0xb0>
  11ebf8:	vpbroadcastd -0x11b97d(%rip),%xmm2        # 3284 <__abi_tag+0x2fc0>
  11ec01:	vmovdqa -0x11a309(%rip),%ymm3        # 4900 <typeinfo name for main::$_60+0x130>
  11ec09:	vmovdqa -0x11a251(%rip),%ymm4        # 49c0 <typeinfo name for main::$_60+0x1f0>
  11ec11:	vpbroadcastq -0x11b87a(%rip),%ymm5        # 33a0 <_IO_stdin_used+0xec>
  11ec1a:	nopw   0x0(%rax,%rax,1)
  11ec20:	mov    (%rax,%r8,8),%rdx
  11ec24:	or     $0x1,%rdx
  11ec28:	mov    0x20(%rdi),%r11
  11ec2c:	mulx   0x10(%rdi),%rbx,%rbx
  11ec32:	imul   %r9,%rdx
  11ec36:	mulx   %r10,%r14,%r15
  11ec3b:	xor    %r14,%r15
  11ec3e:	shl    $0x6,%rbx
  11ec42:	vpbroadcastq %rdx,%ymm6
  11ec48:	lea    (%r11,%rbx,1),%rdx
  11ec4c:	vpbroadcastq %r15,%xmm7
  11ec52:	vinserti128 $0x1,%xmm7,%ymm6,%ymm7
  11ec58:	vpsrlvq %ymm1,%ymm6,%ymm8
  11ec5d:	vpmovqd %ymm8,%xmm8
  11ec63:	vpand  %xmm2,%xmm8,%xmm8
  11ec67:	kxnorw %k0,%k0,%k1
  11ec6b:	vpxor  %xmm9,%xmm9,%xmm9
  11ec70:	vpgatherdq (%rdx,%xmm8,8),%ymm9{%k1}
  11ec77:	vpsrlvq %ymm0,%ymm7,%ymm8
  11ec7c:	vpmovqd %ymm8,%xmm8
  11ec82:	vpand  %xmm2,%xmm8,%xmm8
  11ec86:	kxnorw %k0,%k0,%k1
  11ec8a:	vpxor  %xmm10,%xmm10,%xmm10
  11ec8f:	vpgatherdq (%rdx,%xmm8,8),%ymm10{%k1}
  11ec96:	prefetcht0 (%r11,%rbx,1)
  11ec9b:	vpsrlvq %ymm3,%ymm7,%ymm7
  11eca0:	vpsrlvq %ymm4,%ymm6,%ymm6
  11eca5:	vpand  %ymm5,%ymm7,%ymm7
  11eca9:	vpsrlvq %ymm7,%ymm10,%ymm7
  11ecae:	vpand  %ymm5,%ymm6,%ymm6
  11ecb2:	vpsrlvq %ymm6,%ymm9,%ymm6
  11ecb7:	vpand  %ymm7,%ymm6,%ymm6
  11ecbb:	vextracti128 $0x1,%ymm6,%xmm7
  11ecc1:	vpand  %xmm7,%xmm6,%xmm6
  11ecc5:	vpshufd $0xee,%xmm6,%xmm7
  11ecca:	vpand  %xmm6,%xmm7,%xmm6
  11ecce:	vmovd  %xmm6,%edx
  11ecd2:	and    $0x1,%edx
  11ecd5:	mov    %edx,(%rcx,%r8,4)
  11ecd9:	inc    %r8
  11ecdc:	cmp    %r8,%rsi
  11ecdf:	jne    11ec20 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long [8], 8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x60>
  11ece5:	pop    %rbx
  11ece6:	pop    %r14
  11ece8:	pop    %r15
  11ecea:	vzeroupper
  11eced:	ret
  11ecee:	int3
  11ecef:	int3

