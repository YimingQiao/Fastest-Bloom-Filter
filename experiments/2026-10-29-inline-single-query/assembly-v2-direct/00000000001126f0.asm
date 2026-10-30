00000000001126f0 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
  1126f0:	test   %rsi,%rsi
  1126f3:	je     1128c5 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x1d5>
  1126f9:	push   %rbx
  1126fa:	mov    %rdx,%rax
  1126fd:	movabs $0xf1357aea2e62a9c5,%r9
  112707:	cmp    $0x1,%rsi
  11270b:	jne    112715 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x25>
  11270d:	xor    %r8d,%r8d
  112710:	jmp    11283f <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x14f>
  112715:	mov    %rsi,%r10
  112718:	and    $0xfffffffffffffffe,%r10
  11271c:	xor    %r8d,%r8d
  11271f:	vmovdqa -0x10de47(%rip),%ymm0        # 48e0 <typeinfo name for main::$_60+0x110>
  112727:	vmovdqa -0x10df0f(%rip),%ymm1        # 4820 <typeinfo name for main::$_60+0x50>
  11272f:	vpbroadcastq -0x10f398(%rip),%ymm2        # 33a0 <_IO_stdin_used+0xec>
  112738:	vpbroadcastq -0x10f3e9(%rip),%ymm3        # 3358 <_IO_stdin_used+0xa4>
  112741:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  112750:	mov    (%rax,%r8,8),%rdx
  112754:	or     $0x1,%rdx
  112758:	mov    0x20(%rdi),%r11
  11275c:	mulx   0x10(%rdi),%rbx,%rbx
  112762:	imul   %r9,%rdx
  112766:	prefetcht0 (%r11,%rbx,8)
  11276b:	vpbroadcastq %rdx,%ymm4
  112771:	vpsrlvq %ymm0,%ymm4,%ymm5
  112776:	vpsrlvq %ymm1,%ymm4,%ymm4
  11277b:	vpand  %ymm2,%ymm4,%ymm4
  11277f:	vpand  %ymm2,%ymm5,%ymm5
  112783:	vpsllvq %ymm5,%ymm3,%ymm5
  112788:	vpsllvq %ymm4,%ymm3,%ymm4
  11278d:	vpor   %ymm5,%ymm4,%ymm4
  112791:	vextracti128 $0x1,%ymm4,%xmm5
  112797:	vpor   %xmm5,%xmm4,%xmm4
  11279b:	vpshufd $0xee,%xmm4,%xmm5
  1127a0:	vpor   %xmm5,%xmm4,%xmm4
  1127a4:	vmovq  %xmm4,%rdx
  1127a9:	mov    (%r11,%rbx,8),%r11
  1127ad:	xor    %ebx,%ebx
  1127af:	andn   %rdx,%r11,%rdx
  1127b4:	sete   %bl
  1127b7:	mov    %ebx,(%rcx,%r8,4)
  1127bb:	mov    0x8(%rax,%r8,8),%rdx
  1127c0:	or     $0x1,%rdx
  1127c4:	mov    0x20(%rdi),%r11
  1127c8:	mulx   0x10(%rdi),%rbx,%rbx
  1127ce:	imul   %r9,%rdx
  1127d2:	prefetcht0 (%r11,%rbx,8)
  1127d7:	vpbroadcastq %rdx,%ymm4
  1127dd:	vpsrlvq %ymm0,%ymm4,%ymm5
  1127e2:	vpsrlvq %ymm1,%ymm4,%ymm4
  1127e7:	vpand  %ymm2,%ymm4,%ymm4
  1127eb:	vpand  %ymm2,%ymm5,%ymm5
  1127ef:	vpsllvq %ymm5,%ymm3,%ymm5
  1127f4:	vpsllvq %ymm4,%ymm3,%ymm4
  1127f9:	vpor   %ymm5,%ymm4,%ymm4
  1127fd:	vextracti128 $0x1,%ymm4,%xmm5
  112803:	vpor   %xmm5,%xmm4,%xmm4
  112807:	vpshufd $0xee,%xmm4,%xmm5
  11280c:	vpor   %xmm5,%xmm4,%xmm4
  112810:	vmovq  %xmm4,%rdx
  112815:	mov    (%r11,%rbx,8),%r11
  112819:	xor    %ebx,%ebx
  11281b:	andn   %rdx,%r11,%rdx
  112820:	sete   %bl
  112823:	mov    %ebx,0x4(%rcx,%r8,4)
  112828:	add    $0x2,%r8
  11282c:	cmp    %r8,%r10
  11282f:	jne    112750 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x60>
  112835:	test   $0x1,%sil
  112839:	je     1128c4 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x1d4>
  11283f:	mov    (%rax,%r8,8),%rdx
  112843:	or     $0x1,%rdx
  112847:	mov    0x20(%rdi),%rax
  11284b:	mulx   0x10(%rdi),%rsi,%rsi
  112851:	imul   %r9,%rdx
  112855:	prefetcht0 (%rax,%rsi,8)
  112859:	vpbroadcastq %rdx,%ymm0
  11285f:	vpsrlvq -0x10df88(%rip),%ymm0,%ymm1        # 48e0 <typeinfo name for main::$_60+0x110>
  112868:	vpsrlvq -0x10e051(%rip),%ymm0,%ymm0        # 4820 <typeinfo name for main::$_60+0x50>
  112871:	vpbroadcastq -0x10f4da(%rip),%ymm2        # 33a0 <_IO_stdin_used+0xec>
  11287a:	vpand  %ymm2,%ymm0,%ymm0
  11287e:	vpand  %ymm2,%ymm1,%ymm1
  112882:	vpbroadcastq -0x10f533(%rip),%ymm2        # 3358 <_IO_stdin_used+0xa4>
  11288b:	vpsllvq %ymm1,%ymm2,%ymm1
  112890:	vpsllvq %ymm0,%ymm2,%ymm0
  112895:	vpor   %ymm1,%ymm0,%ymm0
  112899:	vextracti128 $0x1,%ymm0,%xmm1
  11289f:	vpor   %xmm1,%xmm0,%xmm0
  1128a3:	vpshufd $0xee,%xmm0,%xmm1
  1128a8:	vpor   %xmm1,%xmm0,%xmm0
  1128ac:	vmovq  %xmm0,%rdx
  1128b1:	mov    (%rax,%rsi,8),%rax
  1128b5:	xor    %esi,%esi
  1128b7:	andn   %rdx,%rax,%rax
  1128bc:	sete   %sil
  1128c0:	mov    %esi,(%rcx,%r8,4)
  1128c4:	pop    %rbx
  1128c5:	vzeroupper
  1128c8:	ret
  1128c9:	int3
  1128ca:	int3
  1128cb:	int3
  1128cc:	int3
  1128cd:	int3
  1128ce:	int3
  1128cf:	int3

