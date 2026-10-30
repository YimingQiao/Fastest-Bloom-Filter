00000000000fa900 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<4ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<4ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
   fa900:	test   %rsi,%rsi
   fa903:	je     faae1 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<4ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<4ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x1e1>
   fa909:	push   %r14
   fa90b:	push   %rbx
   fa90c:	mov    %rdx,%rax
   fa90f:	movabs $0xf1357aea2e62a9c5,%r9
   fa919:	movabs $0xd6e8feb86659fd93,%r10
   fa923:	cmp    $0x1,%rsi
   fa927:	jne    fa931 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<4ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<4ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x31>
   fa929:	xor    %r8d,%r8d
   fa92c:	jmp    faa5b <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<4ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<4ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x15b>
   fa931:	mov    %rsi,%r11
   fa934:	and    $0xfffffffffffffffe,%r11
   fa938:	xor    %r8d,%r8d
   fa93b:	vmovdqa -0xf5ce3(%rip),%xmm0        # 4c60 <typeinfo name for main::$_60+0x490>
   fa943:	vpbroadcastq -0xf75f4(%rip),%ymm1        # 3358 <_IO_stdin_used+0xa4>
   fa94c:	nopl   0x0(%rax)
   fa950:	mov    (%rax,%r8,8),%rdx
   fa954:	mov    %rdx,%rbx
   fa957:	shr    $0x20,%rbx
   fa95b:	xor    %rdx,%rbx
   fa95e:	imul   %r10,%rbx
   fa962:	mov    %rbx,%r14
   fa965:	shr    $0x20,%r14
   fa969:	xor    %rbx,%r14
   fa96c:	imul   %r10,%r14
   fa970:	mov    %r14,%rdx
   fa973:	shr    $0x20,%rdx
   fa977:	xor    %r14,%rdx
   fa97a:	or     $0x1,%rdx
   fa97e:	mov    0x20(%rdi),%rbx
   fa982:	mulx   0x10(%rdi),%r14,%r14
   fa988:	shl    $0x5,%r14
   fa98c:	prefetcht0 (%rbx,%r14,1)
   fa991:	prefetcht0 0x40(%rbx,%r14,1)
   fa997:	imul   %r9,%rdx
   fa99b:	vpbroadcastq %rdx,%xmm2
   fa9a1:	vpsllvq %xmm0,%xmm2,%xmm2
   fa9a6:	vpsrld $0x1a,%xmm2,%xmm2
   fa9ab:	vpmovzxdq %xmm2,%ymm2
   fa9b0:	vpsllvq %ymm2,%ymm1,%ymm2
   fa9b5:	vmovdqa (%rbx,%r14,1),%ymm3
   fa9bb:	xor    %edx,%edx
   fa9bd:	vptest %ymm2,%ymm3
   fa9c2:	setb   %dl
   fa9c5:	mov    %edx,(%rcx,%r8,4)
   fa9c9:	mov    0x8(%rax,%r8,8),%rdx
   fa9ce:	mov    %rdx,%rbx
   fa9d1:	shr    $0x20,%rbx
   fa9d5:	xor    %rdx,%rbx
   fa9d8:	imul   %r10,%rbx
   fa9dc:	mov    %rbx,%r14
   fa9df:	shr    $0x20,%r14
   fa9e3:	xor    %rbx,%r14
   fa9e6:	imul   %r10,%r14
   fa9ea:	mov    %r14,%rdx
   fa9ed:	shr    $0x20,%rdx
   fa9f1:	xor    %r14,%rdx
   fa9f4:	or     $0x1,%rdx
   fa9f8:	mov    0x20(%rdi),%rbx
   fa9fc:	mulx   0x10(%rdi),%r14,%r14
   faa02:	shl    $0x5,%r14
   faa06:	prefetcht0 (%rbx,%r14,1)
   faa0b:	prefetcht0 0x40(%rbx,%r14,1)
   faa11:	imul   %r9,%rdx
   faa15:	vpbroadcastq %rdx,%xmm2
   faa1b:	vpsllvq %xmm0,%xmm2,%xmm2
   faa20:	vpsrld $0x1a,%xmm2,%xmm2
   faa25:	vpmovzxdq %xmm2,%ymm2
   faa2a:	vpsllvq %ymm2,%ymm1,%ymm2
   faa2f:	vmovdqa (%rbx,%r14,1),%ymm3
   faa35:	xor    %edx,%edx
   faa37:	vptest %ymm2,%ymm3
   faa3c:	setb   %dl
   faa3f:	mov    %edx,0x4(%rcx,%r8,4)
   faa44:	add    $0x2,%r8
   faa48:	cmp    %r8,%r11
   faa4b:	jne    fa950 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<4ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<4ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
   faa51:	test   $0x1,%sil
   faa55:	je     faade <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<4ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<4ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x1de>
   faa5b:	mov    (%rax,%r8,8),%rax
   faa5f:	mov    %rax,%rdx
   faa62:	shr    $0x20,%rdx
   faa66:	xor    %rax,%rdx
   faa69:	imul   %r10,%rdx
   faa6d:	mov    %rdx,%rax
   faa70:	shr    $0x20,%rax
   faa74:	xor    %rdx,%rax
   faa77:	imul   %r10,%rax
   faa7b:	mov    %rax,%rdx
   faa7e:	shr    $0x20,%rdx
   faa82:	xor    %rax,%rdx
   faa85:	or     $0x1,%rdx
   faa89:	mov    0x20(%rdi),%rax
   faa8d:	mulx   0x10(%rdi),%rsi,%rsi
   faa93:	shl    $0x5,%rsi
   faa97:	prefetcht0 (%rax,%rsi,1)
   faa9b:	prefetcht0 0x40(%rax,%rsi,1)
   faaa0:	imul   %r9,%rdx
   faaa4:	vpbroadcastq %rdx,%xmm0
   faaaa:	vpsllvq -0xf5e53(%rip),%xmm0,%xmm0        # 4c60 <typeinfo name for main::$_60+0x490>
   faab3:	vpsrld $0x1a,%xmm0,%xmm0
   faab8:	vpmovzxdq %xmm0,%ymm0
   faabd:	vpbroadcastq -0xf776e(%rip),%ymm1        # 3358 <_IO_stdin_used+0xa4>
   faac6:	vpsllvq %ymm0,%ymm1,%ymm0
   faacb:	vmovdqa (%rax,%rsi,1),%ymm1
   faad0:	xor    %eax,%eax
   faad2:	vptest %ymm0,%ymm1
   faad7:	setb   %al
   faada:	mov    %eax,(%rcx,%r8,4)
   faade:	pop    %rbx
   faadf:	pop    %r14
   faae1:	vzeroupper
   faae4:	ret
   faae5:	int3
   faae6:	int3
   faae7:	int3
   faae8:	int3
   faae9:	int3
   faaea:	int3
   faaeb:	int3
   faaec:	int3
   faaed:	int3
   faaee:	int3
   faaef:	int3

