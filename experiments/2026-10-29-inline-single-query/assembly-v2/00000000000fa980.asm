00000000000fa980 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<4ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<4ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
   fa980:	test   %rsi,%rsi
   fa983:	je     fab61 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<4ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<4ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x1e1>
   fa989:	push   %r14
   fa98b:	push   %rbx
   fa98c:	mov    %rdx,%rax
   fa98f:	movabs $0xf1357aea2e62a9c5,%r9
   fa999:	movabs $0xd6e8feb86659fd93,%r10
   fa9a3:	cmp    $0x1,%rsi
   fa9a7:	jne    fa9b1 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<4ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<4ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x31>
   fa9a9:	xor    %r8d,%r8d
   fa9ac:	jmp    faadb <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<4ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<4ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x15b>
   fa9b1:	mov    %rsi,%r11
   fa9b4:	and    $0xfffffffffffffffe,%r11
   fa9b8:	xor    %r8d,%r8d
   fa9bb:	vmovdqa -0xf5d63(%rip),%xmm0        # 4c60 <typeinfo name for main::$_60+0x490>
   fa9c3:	vpbroadcastq -0xf7674(%rip),%ymm1        # 3358 <_IO_stdin_used+0xa4>
   fa9cc:	nopl   0x0(%rax)
   fa9d0:	mov    (%rax,%r8,8),%rdx
   fa9d4:	mov    %rdx,%rbx
   fa9d7:	shr    $0x20,%rbx
   fa9db:	xor    %rdx,%rbx
   fa9de:	imul   %r10,%rbx
   fa9e2:	mov    %rbx,%r14
   fa9e5:	shr    $0x20,%r14
   fa9e9:	xor    %rbx,%r14
   fa9ec:	imul   %r10,%r14
   fa9f0:	mov    %r14,%rdx
   fa9f3:	shr    $0x20,%rdx
   fa9f7:	xor    %r14,%rdx
   fa9fa:	or     $0x1,%rdx
   fa9fe:	mov    0x20(%rdi),%rbx
   faa02:	mulx   0x10(%rdi),%r14,%r14
   faa08:	shl    $0x5,%r14
   faa0c:	prefetcht0 (%rbx,%r14,1)
   faa11:	prefetcht0 0x40(%rbx,%r14,1)
   faa17:	imul   %r9,%rdx
   faa1b:	vpbroadcastq %rdx,%xmm2
   faa21:	vpsllvq %xmm0,%xmm2,%xmm2
   faa26:	vpsrld $0x1a,%xmm2,%xmm2
   faa2b:	vpmovzxdq %xmm2,%ymm2
   faa30:	vpsllvq %ymm2,%ymm1,%ymm2
   faa35:	vmovdqa (%rbx,%r14,1),%ymm3
   faa3b:	xor    %edx,%edx
   faa3d:	vptest %ymm2,%ymm3
   faa42:	setb   %dl
   faa45:	mov    %edx,(%rcx,%r8,4)
   faa49:	mov    0x8(%rax,%r8,8),%rdx
   faa4e:	mov    %rdx,%rbx
   faa51:	shr    $0x20,%rbx
   faa55:	xor    %rdx,%rbx
   faa58:	imul   %r10,%rbx
   faa5c:	mov    %rbx,%r14
   faa5f:	shr    $0x20,%r14
   faa63:	xor    %rbx,%r14
   faa66:	imul   %r10,%r14
   faa6a:	mov    %r14,%rdx
   faa6d:	shr    $0x20,%rdx
   faa71:	xor    %r14,%rdx
   faa74:	or     $0x1,%rdx
   faa78:	mov    0x20(%rdi),%rbx
   faa7c:	mulx   0x10(%rdi),%r14,%r14
   faa82:	shl    $0x5,%r14
   faa86:	prefetcht0 (%rbx,%r14,1)
   faa8b:	prefetcht0 0x40(%rbx,%r14,1)
   faa91:	imul   %r9,%rdx
   faa95:	vpbroadcastq %rdx,%xmm2
   faa9b:	vpsllvq %xmm0,%xmm2,%xmm2
   faaa0:	vpsrld $0x1a,%xmm2,%xmm2
   faaa5:	vpmovzxdq %xmm2,%ymm2
   faaaa:	vpsllvq %ymm2,%ymm1,%ymm2
   faaaf:	vmovdqa (%rbx,%r14,1),%ymm3
   faab5:	xor    %edx,%edx
   faab7:	vptest %ymm2,%ymm3
   faabc:	setb   %dl
   faabf:	mov    %edx,0x4(%rcx,%r8,4)
   faac4:	add    $0x2,%r8
   faac8:	cmp    %r8,%r11
   faacb:	jne    fa9d0 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<4ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<4ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
   faad1:	test   $0x1,%sil
   faad5:	je     fab5e <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<4ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<4ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x1de>
   faadb:	mov    (%rax,%r8,8),%rax
   faadf:	mov    %rax,%rdx
   faae2:	shr    $0x20,%rdx
   faae6:	xor    %rax,%rdx
   faae9:	imul   %r10,%rdx
   faaed:	mov    %rdx,%rax
   faaf0:	shr    $0x20,%rax
   faaf4:	xor    %rdx,%rax
   faaf7:	imul   %r10,%rax
   faafb:	mov    %rax,%rdx
   faafe:	shr    $0x20,%rdx
   fab02:	xor    %rax,%rdx
   fab05:	or     $0x1,%rdx
   fab09:	mov    0x20(%rdi),%rax
   fab0d:	mulx   0x10(%rdi),%rsi,%rsi
   fab13:	shl    $0x5,%rsi
   fab17:	prefetcht0 (%rax,%rsi,1)
   fab1b:	prefetcht0 0x40(%rax,%rsi,1)
   fab20:	imul   %r9,%rdx
   fab24:	vpbroadcastq %rdx,%xmm0
   fab2a:	vpsllvq -0xf5ed3(%rip),%xmm0,%xmm0        # 4c60 <typeinfo name for main::$_60+0x490>
   fab33:	vpsrld $0x1a,%xmm0,%xmm0
   fab38:	vpmovzxdq %xmm0,%ymm0
   fab3d:	vpbroadcastq -0xf77ee(%rip),%ymm1        # 3358 <_IO_stdin_used+0xa4>
   fab46:	vpsllvq %ymm0,%ymm1,%ymm0
   fab4b:	vmovdqa (%rax,%rsi,1),%ymm1
   fab50:	xor    %eax,%eax
   fab52:	vptest %ymm0,%ymm1
   fab57:	setb   %al
   fab5a:	mov    %eax,(%rcx,%r8,4)
   fab5e:	pop    %rbx
   fab5f:	pop    %r14
   fab61:	vzeroupper
   fab64:	ret
   fab65:	int3
   fab66:	int3
   fab67:	int3
   fab68:	int3
   fab69:	int3
   fab6a:	int3
   fab6b:	int3
   fab6c:	int3
   fab6d:	int3
   fab6e:	int3
   fab6f:	int3

