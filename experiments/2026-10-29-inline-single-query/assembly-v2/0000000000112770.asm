0000000000112770 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
  112770:	test   %rsi,%rsi
  112773:	je     112945 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x1d5>
  112779:	push   %rbx
  11277a:	mov    %rdx,%rax
  11277d:	movabs $0xf1357aea2e62a9c5,%r9
  112787:	cmp    $0x1,%rsi
  11278b:	jne    112795 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x25>
  11278d:	xor    %r8d,%r8d
  112790:	jmp    1128bf <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x14f>
  112795:	mov    %rsi,%r10
  112798:	and    $0xfffffffffffffffe,%r10
  11279c:	xor    %r8d,%r8d
  11279f:	vmovdqa -0x10dec7(%rip),%ymm0        # 48e0 <typeinfo name for main::$_60+0x110>
  1127a7:	vmovdqa -0x10df8f(%rip),%ymm1        # 4820 <typeinfo name for main::$_60+0x50>
  1127af:	vpbroadcastq -0x10f418(%rip),%ymm2        # 33a0 <_IO_stdin_used+0xec>
  1127b8:	vpbroadcastq -0x10f469(%rip),%ymm3        # 3358 <_IO_stdin_used+0xa4>
  1127c1:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  1127d0:	mov    (%rax,%r8,8),%rdx
  1127d4:	or     $0x1,%rdx
  1127d8:	mov    0x20(%rdi),%r11
  1127dc:	mulx   0x10(%rdi),%rbx,%rbx
  1127e2:	prefetcht0 (%r11,%rbx,8)
  1127e7:	imul   %r9,%rdx
  1127eb:	vpbroadcastq %rdx,%ymm4
  1127f1:	vpsrlvq %ymm0,%ymm4,%ymm5
  1127f6:	vpsrlvq %ymm1,%ymm4,%ymm4
  1127fb:	vpand  %ymm2,%ymm4,%ymm4
  1127ff:	vpand  %ymm2,%ymm5,%ymm5
  112803:	vpsllvq %ymm5,%ymm3,%ymm5
  112808:	vpsllvq %ymm4,%ymm3,%ymm4
  11280d:	vpor   %ymm5,%ymm4,%ymm4
  112811:	vextracti128 $0x1,%ymm4,%xmm5
  112817:	vpor   %xmm5,%xmm4,%xmm4
  11281b:	vpshufd $0xee,%xmm4,%xmm5
  112820:	vpor   %xmm5,%xmm4,%xmm4
  112824:	vmovq  %xmm4,%rdx
  112829:	mov    (%r11,%rbx,8),%r11
  11282d:	xor    %ebx,%ebx
  11282f:	andn   %rdx,%r11,%rdx
  112834:	sete   %bl
  112837:	mov    %ebx,(%rcx,%r8,4)
  11283b:	mov    0x8(%rax,%r8,8),%rdx
  112840:	or     $0x1,%rdx
  112844:	mov    0x20(%rdi),%r11
  112848:	mulx   0x10(%rdi),%rbx,%rbx
  11284e:	prefetcht0 (%r11,%rbx,8)
  112853:	imul   %r9,%rdx
  112857:	vpbroadcastq %rdx,%ymm4
  11285d:	vpsrlvq %ymm0,%ymm4,%ymm5
  112862:	vpsrlvq %ymm1,%ymm4,%ymm4
  112867:	vpand  %ymm2,%ymm4,%ymm4
  11286b:	vpand  %ymm2,%ymm5,%ymm5
  11286f:	vpsllvq %ymm5,%ymm3,%ymm5
  112874:	vpsllvq %ymm4,%ymm3,%ymm4
  112879:	vpor   %ymm5,%ymm4,%ymm4
  11287d:	vextracti128 $0x1,%ymm4,%xmm5
  112883:	vpor   %xmm5,%xmm4,%xmm4
  112887:	vpshufd $0xee,%xmm4,%xmm5
  11288c:	vpor   %xmm5,%xmm4,%xmm4
  112890:	vmovq  %xmm4,%rdx
  112895:	mov    (%r11,%rbx,8),%r11
  112899:	xor    %ebx,%ebx
  11289b:	andn   %rdx,%r11,%rdx
  1128a0:	sete   %bl
  1128a3:	mov    %ebx,0x4(%rcx,%r8,4)
  1128a8:	add    $0x2,%r8
  1128ac:	cmp    %r8,%r10
  1128af:	jne    1127d0 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x60>
  1128b5:	test   $0x1,%sil
  1128b9:	je     112944 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x1d4>
  1128bf:	mov    (%rax,%r8,8),%rdx
  1128c3:	or     $0x1,%rdx
  1128c7:	mov    0x20(%rdi),%rax
  1128cb:	mulx   0x10(%rdi),%rsi,%rsi
  1128d1:	prefetcht0 (%rax,%rsi,8)
  1128d5:	imul   %r9,%rdx
  1128d9:	vpbroadcastq %rdx,%ymm0
  1128df:	vpsrlvq -0x10e008(%rip),%ymm0,%ymm1        # 48e0 <typeinfo name for main::$_60+0x110>
  1128e8:	vpsrlvq -0x10e0d1(%rip),%ymm0,%ymm0        # 4820 <typeinfo name for main::$_60+0x50>
  1128f1:	vpbroadcastq -0x10f55a(%rip),%ymm2        # 33a0 <_IO_stdin_used+0xec>
  1128fa:	vpand  %ymm2,%ymm0,%ymm0
  1128fe:	vpand  %ymm2,%ymm1,%ymm1
  112902:	vpbroadcastq -0x10f5b3(%rip),%ymm2        # 3358 <_IO_stdin_used+0xa4>
  11290b:	vpsllvq %ymm1,%ymm2,%ymm1
  112910:	vpsllvq %ymm0,%ymm2,%ymm0
  112915:	vpor   %ymm1,%ymm0,%ymm0
  112919:	vextracti128 $0x1,%ymm0,%xmm1
  11291f:	vpor   %xmm1,%xmm0,%xmm0
  112923:	vpshufd $0xee,%xmm0,%xmm1
  112928:	vpor   %xmm1,%xmm0,%xmm0
  11292c:	vmovq  %xmm0,%rdx
  112931:	mov    (%rax,%rsi,8),%rax
  112935:	xor    %esi,%esi
  112937:	andn   %rdx,%rax,%rax
  11293c:	sete   %sil
  112940:	mov    %esi,(%rcx,%r8,4)
  112944:	pop    %rbx
  112945:	vzeroupper
  112948:	ret
  112949:	int3
  11294a:	int3
  11294b:	int3
  11294c:	int3
  11294d:	int3
  11294e:	int3
  11294f:	int3

