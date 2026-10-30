0000000000100660 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
  100660:	test   %rsi,%rsi
  100663:	je     100818 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x1b8>
  100669:	push   %rbx
  10066a:	mov    %rdx,%rax
  10066d:	movabs $0xf1357aea2e62a9c5,%r9
  100677:	cmp    $0x1,%rsi
  10067b:	jne    100685 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x25>
  10067d:	xor    %r8d,%r8d
  100680:	jmp    10079b <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x13b>
  100685:	mov    %rsi,%r10
  100688:	and    $0xfffffffffffffffe,%r10
  10068c:	xor    %r8d,%r8d
  10068f:	vmovdqa -0xfbc17(%rip),%ymm0        # 4a80 <typeinfo name for main::$_60+0x2b0>
  100697:	vpbroadcastq -0xfd348(%rip),%ymm1        # 3358 <_IO_stdin_used+0xa4>
  1006a0:	mov    (%rax,%r8,8),%rdx
  1006a4:	or     $0x1,%rdx
  1006a8:	mov    0x20(%rdi),%r11
  1006ac:	mulx   0x10(%rdi),%rbx,%rbx
  1006b2:	imul   %r9,%rdx
  1006b6:	shl    $0x6,%rbx
  1006ba:	prefetcht0 (%r11,%rbx,1)
  1006bf:	vmovdqa (%r11,%rbx,1),%ymm2
  1006c5:	vmovdqa 0x20(%r11,%rbx,1),%ymm3
  1006cc:	vpbroadcastq %rdx,%ymm4
  1006d2:	vpsllvq %ymm0,%ymm4,%ymm4
  1006d7:	vpsrld $0x1a,%ymm4,%ymm4
  1006dc:	vpmovzxdq %xmm4,%ymm5
  1006e1:	vpsllvq %ymm5,%ymm1,%ymm5
  1006e6:	vextracti128 $0x1,%ymm4,%xmm4
  1006ec:	vpmovzxdq %xmm4,%ymm4
  1006f1:	vpsllvq %ymm4,%ymm1,%ymm4
  1006f6:	vptest %ymm5,%ymm2
  1006fb:	setb   %dl
  1006fe:	vptest %ymm4,%ymm3
  100703:	setb   %r11b
  100707:	xor    %ebx,%ebx
  100709:	test   %dl,%r11b
  10070c:	setne  %bl
  10070f:	mov    %ebx,(%rcx,%r8,4)
  100713:	mov    0x8(%rax,%r8,8),%rdx
  100718:	or     $0x1,%rdx
  10071c:	mov    0x20(%rdi),%r11
  100720:	mulx   0x10(%rdi),%rbx,%rbx
  100726:	imul   %r9,%rdx
  10072a:	shl    $0x6,%rbx
  10072e:	prefetcht0 (%r11,%rbx,1)
  100733:	vmovdqa (%r11,%rbx,1),%ymm2
  100739:	vmovdqa 0x20(%r11,%rbx,1),%ymm3
  100740:	vpbroadcastq %rdx,%ymm4
  100746:	vpsllvq %ymm0,%ymm4,%ymm4
  10074b:	vpsrld $0x1a,%ymm4,%ymm4
  100750:	vpmovzxdq %xmm4,%ymm5
  100755:	vpsllvq %ymm5,%ymm1,%ymm5
  10075a:	vextracti128 $0x1,%ymm4,%xmm4
  100760:	vpmovzxdq %xmm4,%ymm4
  100765:	vpsllvq %ymm4,%ymm1,%ymm4
  10076a:	vptest %ymm5,%ymm2
  10076f:	setb   %dl
  100772:	vptest %ymm4,%ymm3
  100777:	setb   %r11b
  10077b:	xor    %ebx,%ebx
  10077d:	test   %dl,%r11b
  100780:	setne  %bl
  100783:	mov    %ebx,0x4(%rcx,%r8,4)
  100788:	add    $0x2,%r8
  10078c:	cmp    %r8,%r10
  10078f:	jne    1006a0 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
  100795:	test   $0x1,%sil
  100799:	je     100817 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x1b7>
  10079b:	mov    (%rax,%r8,8),%rdx
  10079f:	or     $0x1,%rdx
  1007a3:	mov    0x20(%rdi),%rax
  1007a7:	mulx   0x10(%rdi),%rsi,%rsi
  1007ad:	imul   %r9,%rdx
  1007b1:	shl    $0x6,%rsi
  1007b5:	prefetcht0 (%rax,%rsi,1)
  1007b9:	vmovdqa (%rax,%rsi,1),%ymm0
  1007be:	vmovdqa 0x20(%rax,%rsi,1),%ymm1
  1007c4:	vpbroadcastq %rdx,%ymm2
  1007ca:	vpsllvq -0xfbd53(%rip),%ymm2,%ymm2        # 4a80 <typeinfo name for main::$_60+0x2b0>
  1007d3:	vpsrld $0x1a,%ymm2,%ymm2
  1007d8:	vpmovzxdq %xmm2,%ymm3
  1007dd:	vpbroadcastq -0xfd48e(%rip),%ymm4        # 3358 <_IO_stdin_used+0xa4>
  1007e6:	vpsllvq %ymm3,%ymm4,%ymm3
  1007eb:	vextracti128 $0x1,%ymm2,%xmm2
  1007f1:	vpmovzxdq %xmm2,%ymm2
  1007f6:	vpsllvq %ymm2,%ymm4,%ymm2
  1007fb:	vptest %ymm3,%ymm0
  100800:	setb   %al
  100803:	vptest %ymm2,%ymm1
  100808:	setb   %dl
  10080b:	xor    %esi,%esi
  10080d:	test   %al,%dl
  10080f:	setne  %sil
  100813:	mov    %esi,(%rcx,%r8,4)
  100817:	pop    %rbx
  100818:	vzeroupper
  10081b:	ret
  10081c:	int3
  10081d:	int3
  10081e:	int3
  10081f:	int3

