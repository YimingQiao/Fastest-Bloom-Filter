00000000001005e0 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
  1005e0:	test   %rsi,%rsi
  1005e3:	je     100798 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x1b8>
  1005e9:	push   %rbx
  1005ea:	mov    %rdx,%rax
  1005ed:	movabs $0xf1357aea2e62a9c5,%r9
  1005f7:	cmp    $0x1,%rsi
  1005fb:	jne    100605 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x25>
  1005fd:	xor    %r8d,%r8d
  100600:	jmp    10071b <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x13b>
  100605:	mov    %rsi,%r10
  100608:	and    $0xfffffffffffffffe,%r10
  10060c:	xor    %r8d,%r8d
  10060f:	vmovdqa -0xfbb97(%rip),%ymm0        # 4a80 <typeinfo name for main::$_60+0x2b0>
  100617:	vpbroadcastq -0xfd2c8(%rip),%ymm1        # 3358 <_IO_stdin_used+0xa4>
  100620:	mov    (%rax,%r8,8),%rdx
  100624:	or     $0x1,%rdx
  100628:	mov    0x20(%rdi),%r11
  10062c:	mulx   0x10(%rdi),%rbx,%rbx
  100632:	imul   %r9,%rdx
  100636:	shl    $0x6,%rbx
  10063a:	prefetcht0 (%r11,%rbx,1)
  10063f:	vmovdqa (%r11,%rbx,1),%ymm2
  100645:	vmovdqa 0x20(%r11,%rbx,1),%ymm3
  10064c:	vpbroadcastq %rdx,%ymm4
  100652:	vpsllvq %ymm0,%ymm4,%ymm4
  100657:	vpsrld $0x1a,%ymm4,%ymm4
  10065c:	vpmovzxdq %xmm4,%ymm5
  100661:	vpsllvq %ymm5,%ymm1,%ymm5
  100666:	vextracti128 $0x1,%ymm4,%xmm4
  10066c:	vpmovzxdq %xmm4,%ymm4
  100671:	vpsllvq %ymm4,%ymm1,%ymm4
  100676:	vptest %ymm5,%ymm2
  10067b:	setb   %dl
  10067e:	vptest %ymm4,%ymm3
  100683:	setb   %r11b
  100687:	xor    %ebx,%ebx
  100689:	test   %dl,%r11b
  10068c:	setne  %bl
  10068f:	mov    %ebx,(%rcx,%r8,4)
  100693:	mov    0x8(%rax,%r8,8),%rdx
  100698:	or     $0x1,%rdx
  10069c:	mov    0x20(%rdi),%r11
  1006a0:	mulx   0x10(%rdi),%rbx,%rbx
  1006a6:	imul   %r9,%rdx
  1006aa:	shl    $0x6,%rbx
  1006ae:	prefetcht0 (%r11,%rbx,1)
  1006b3:	vmovdqa (%r11,%rbx,1),%ymm2
  1006b9:	vmovdqa 0x20(%r11,%rbx,1),%ymm3
  1006c0:	vpbroadcastq %rdx,%ymm4
  1006c6:	vpsllvq %ymm0,%ymm4,%ymm4
  1006cb:	vpsrld $0x1a,%ymm4,%ymm4
  1006d0:	vpmovzxdq %xmm4,%ymm5
  1006d5:	vpsllvq %ymm5,%ymm1,%ymm5
  1006da:	vextracti128 $0x1,%ymm4,%xmm4
  1006e0:	vpmovzxdq %xmm4,%ymm4
  1006e5:	vpsllvq %ymm4,%ymm1,%ymm4
  1006ea:	vptest %ymm5,%ymm2
  1006ef:	setb   %dl
  1006f2:	vptest %ymm4,%ymm3
  1006f7:	setb   %r11b
  1006fb:	xor    %ebx,%ebx
  1006fd:	test   %dl,%r11b
  100700:	setne  %bl
  100703:	mov    %ebx,0x4(%rcx,%r8,4)
  100708:	add    $0x2,%r8
  10070c:	cmp    %r8,%r10
  10070f:	jne    100620 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
  100715:	test   $0x1,%sil
  100719:	je     100797 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock64<8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x1b7>
  10071b:	mov    (%rax,%r8,8),%rdx
  10071f:	or     $0x1,%rdx
  100723:	mov    0x20(%rdi),%rax
  100727:	mulx   0x10(%rdi),%rsi,%rsi
  10072d:	imul   %r9,%rdx
  100731:	shl    $0x6,%rsi
  100735:	prefetcht0 (%rax,%rsi,1)
  100739:	vmovdqa (%rax,%rsi,1),%ymm0
  10073e:	vmovdqa 0x20(%rax,%rsi,1),%ymm1
  100744:	vpbroadcastq %rdx,%ymm2
  10074a:	vpsllvq -0xfbcd3(%rip),%ymm2,%ymm2        # 4a80 <typeinfo name for main::$_60+0x2b0>
  100753:	vpsrld $0x1a,%ymm2,%ymm2
  100758:	vpmovzxdq %xmm2,%ymm3
  10075d:	vpbroadcastq -0xfd40e(%rip),%ymm4        # 3358 <_IO_stdin_used+0xa4>
  100766:	vpsllvq %ymm3,%ymm4,%ymm3
  10076b:	vextracti128 $0x1,%ymm2,%xmm2
  100771:	vpmovzxdq %xmm2,%ymm2
  100776:	vpsllvq %ymm2,%ymm4,%ymm2
  10077b:	vptest %ymm3,%ymm0
  100780:	setb   %al
  100783:	vptest %ymm2,%ymm1
  100788:	setb   %dl
  10078b:	xor    %esi,%esi
  10078d:	test   %al,%dl
  10078f:	setne  %sil
  100793:	mov    %esi,(%rcx,%r8,4)
  100797:	pop    %rbx
  100798:	vzeroupper
  10079b:	ret
  10079c:	int3
  10079d:	int3
  10079e:	int3
  10079f:	int3

