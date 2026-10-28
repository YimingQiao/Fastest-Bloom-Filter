00000000001067f0 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 4ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 4ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
  1067f0:	test   %rsi,%rsi
  1067f3:	je     106974 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 4ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 4ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x184>
  1067f9:	push   %rbx
  1067fa:	mov    %rdx,%rax
  1067fd:	movabs $0xf1357aea2e62a9c5,%r9
  106807:	cmp    $0x1,%rsi
  10680b:	jne    106815 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 4ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 4ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x25>
  10680d:	xor    %r8d,%r8d
  106810:	jmp    106907 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 4ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 4ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x117>
  106815:	mov    %rsi,%r10
  106818:	and    $0xfffffffffffffffe,%r10
  10681c:	xor    %r8d,%r8d
  10681f:	vmovdqa -0x102007(%rip),%ymm0        # 4820 <typeinfo name for main::$_60+0x50>
  106827:	vpbroadcastq -0x103490(%rip),%ymm1        # 33a0 <_IO_stdin_used+0xec>
  106830:	vpbroadcastq -0x1034e1(%rip),%ymm2        # 3358 <_IO_stdin_used+0xa4>
  106839:	nopl   0x0(%rax)
  106840:	mov    (%rax,%r8,8),%rdx
  106844:	or     $0x1,%rdx
  106848:	mov    0x20(%rdi),%r11
  10684c:	mulx   0x10(%rdi),%rbx,%rbx
  106852:	imul   %r9,%rdx
  106856:	prefetcht0 (%r11,%rbx,8)
  10685b:	vpbroadcastq %rdx,%ymm3
  106861:	vpsrlvq %ymm0,%ymm3,%ymm3
  106866:	vpand  %ymm1,%ymm3,%ymm3
  10686a:	vpsllvq %ymm3,%ymm2,%ymm3
  10686f:	vextracti128 $0x1,%ymm3,%xmm4
  106875:	vpor   %xmm4,%xmm3,%xmm3
  106879:	vpshufd $0xee,%xmm3,%xmm4
  10687e:	vpor   %xmm4,%xmm3,%xmm3
  106882:	vmovq  %xmm3,%rdx
  106887:	mov    (%r11,%rbx,8),%r11
  10688b:	xor    %ebx,%ebx
  10688d:	andn   %rdx,%r11,%rdx
  106892:	sete   %bl
  106895:	mov    %ebx,(%rcx,%r8,4)
  106899:	mov    0x8(%rax,%r8,8),%rdx
  10689e:	or     $0x1,%rdx
  1068a2:	mov    0x20(%rdi),%r11
  1068a6:	mulx   0x10(%rdi),%rbx,%rbx
  1068ac:	imul   %r9,%rdx
  1068b0:	prefetcht0 (%r11,%rbx,8)
  1068b5:	vpbroadcastq %rdx,%ymm3
  1068bb:	vpsrlvq %ymm0,%ymm3,%ymm3
  1068c0:	vpand  %ymm1,%ymm3,%ymm3
  1068c4:	vpsllvq %ymm3,%ymm2,%ymm3
  1068c9:	vextracti128 $0x1,%ymm3,%xmm4
  1068cf:	vpor   %xmm4,%xmm3,%xmm3
  1068d3:	vpshufd $0xee,%xmm3,%xmm4
  1068d8:	vpor   %xmm4,%xmm3,%xmm3
  1068dc:	vmovq  %xmm3,%rdx
  1068e1:	mov    (%r11,%rbx,8),%r11
  1068e5:	xor    %ebx,%ebx
  1068e7:	andn   %rdx,%r11,%rdx
  1068ec:	sete   %bl
  1068ef:	mov    %ebx,0x4(%rcx,%r8,4)
  1068f4:	add    $0x2,%r8
  1068f8:	cmp    %r8,%r10
  1068fb:	jne    106840 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 4ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 4ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  106901:	test   $0x1,%sil
  106905:	je     106973 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 4ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 4ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x183>
  106907:	mov    (%rax,%r8,8),%rdx
  10690b:	or     $0x1,%rdx
  10690f:	mov    0x20(%rdi),%rax
  106913:	mulx   0x10(%rdi),%rsi,%rsi
  106919:	imul   %r9,%rdx
  10691d:	prefetcht0 (%rax,%rsi,8)
  106921:	vpbroadcastq %rdx,%ymm0
  106927:	vpsrlvq -0x102110(%rip),%ymm0,%ymm0        # 4820 <typeinfo name for main::$_60+0x50>
  106930:	vpandq -0x10359a(%rip){1to4},%ymm0,%ymm0        # 33a0 <_IO_stdin_used+0xec>
  10693a:	vpbroadcastq -0x1035eb(%rip),%ymm1        # 3358 <_IO_stdin_used+0xa4>
  106943:	vpsllvq %ymm0,%ymm1,%ymm0
  106948:	vextracti128 $0x1,%ymm0,%xmm1
  10694e:	vpor   %xmm1,%xmm0,%xmm0
  106952:	vpshufd $0xee,%xmm0,%xmm1
  106957:	vpor   %xmm1,%xmm0,%xmm0
  10695b:	vmovq  %xmm0,%rdx
  106960:	mov    (%rax,%rsi,8),%rax
  106964:	xor    %esi,%esi
  106966:	andn   %rdx,%rax,%rax
  10696b:	sete   %sil
  10696f:	mov    %esi,(%rcx,%r8,4)
  106973:	pop    %rbx
  106974:	vzeroupper
  106977:	ret
  106978:	int3
  106979:	int3
  10697a:	int3
  10697b:	int3
  10697c:	int3
  10697d:	int3
  10697e:	int3
  10697f:	int3

