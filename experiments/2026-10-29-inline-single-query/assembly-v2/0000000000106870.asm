0000000000106870 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 4ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 4ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
  106870:	test   %rsi,%rsi
  106873:	je     1069f4 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 4ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 4ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x184>
  106879:	push   %rbx
  10687a:	mov    %rdx,%rax
  10687d:	movabs $0xf1357aea2e62a9c5,%r9
  106887:	cmp    $0x1,%rsi
  10688b:	jne    106895 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 4ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 4ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x25>
  10688d:	xor    %r8d,%r8d
  106890:	jmp    106987 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 4ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 4ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x117>
  106895:	mov    %rsi,%r10
  106898:	and    $0xfffffffffffffffe,%r10
  10689c:	xor    %r8d,%r8d
  10689f:	vmovdqa -0x102087(%rip),%ymm0        # 4820 <typeinfo name for main::$_60+0x50>
  1068a7:	vpbroadcastq -0x103510(%rip),%ymm1        # 33a0 <_IO_stdin_used+0xec>
  1068b0:	vpbroadcastq -0x103561(%rip),%ymm2        # 3358 <_IO_stdin_used+0xa4>
  1068b9:	nopl   0x0(%rax)
  1068c0:	mov    (%rax,%r8,8),%rdx
  1068c4:	or     $0x1,%rdx
  1068c8:	mov    0x20(%rdi),%r11
  1068cc:	mulx   0x10(%rdi),%rbx,%rbx
  1068d2:	prefetcht0 (%r11,%rbx,8)
  1068d7:	imul   %r9,%rdx
  1068db:	vpbroadcastq %rdx,%ymm3
  1068e1:	vpsrlvq %ymm0,%ymm3,%ymm3
  1068e6:	vpand  %ymm1,%ymm3,%ymm3
  1068ea:	vpsllvq %ymm3,%ymm2,%ymm3
  1068ef:	vextracti128 $0x1,%ymm3,%xmm4
  1068f5:	vpor   %xmm4,%xmm3,%xmm3
  1068f9:	vpshufd $0xee,%xmm3,%xmm4
  1068fe:	vpor   %xmm4,%xmm3,%xmm3
  106902:	vmovq  %xmm3,%rdx
  106907:	mov    (%r11,%rbx,8),%r11
  10690b:	xor    %ebx,%ebx
  10690d:	andn   %rdx,%r11,%rdx
  106912:	sete   %bl
  106915:	mov    %ebx,(%rcx,%r8,4)
  106919:	mov    0x8(%rax,%r8,8),%rdx
  10691e:	or     $0x1,%rdx
  106922:	mov    0x20(%rdi),%r11
  106926:	mulx   0x10(%rdi),%rbx,%rbx
  10692c:	prefetcht0 (%r11,%rbx,8)
  106931:	imul   %r9,%rdx
  106935:	vpbroadcastq %rdx,%ymm3
  10693b:	vpsrlvq %ymm0,%ymm3,%ymm3
  106940:	vpand  %ymm1,%ymm3,%ymm3
  106944:	vpsllvq %ymm3,%ymm2,%ymm3
  106949:	vextracti128 $0x1,%ymm3,%xmm4
  10694f:	vpor   %xmm4,%xmm3,%xmm3
  106953:	vpshufd $0xee,%xmm3,%xmm4
  106958:	vpor   %xmm4,%xmm3,%xmm3
  10695c:	vmovq  %xmm3,%rdx
  106961:	mov    (%r11,%rbx,8),%r11
  106965:	xor    %ebx,%ebx
  106967:	andn   %rdx,%r11,%rdx
  10696c:	sete   %bl
  10696f:	mov    %ebx,0x4(%rcx,%r8,4)
  106974:	add    $0x2,%r8
  106978:	cmp    %r8,%r10
  10697b:	jne    1068c0 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 4ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 4ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  106981:	test   $0x1,%sil
  106985:	je     1069f3 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 4ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 4ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x183>
  106987:	mov    (%rax,%r8,8),%rdx
  10698b:	or     $0x1,%rdx
  10698f:	mov    0x20(%rdi),%rax
  106993:	mulx   0x10(%rdi),%rsi,%rsi
  106999:	prefetcht0 (%rax,%rsi,8)
  10699d:	imul   %r9,%rdx
  1069a1:	vpbroadcastq %rdx,%ymm0
  1069a7:	vpsrlvq -0x102190(%rip),%ymm0,%ymm0        # 4820 <typeinfo name for main::$_60+0x50>
  1069b0:	vpandq -0x10361a(%rip){1to4},%ymm0,%ymm0        # 33a0 <_IO_stdin_used+0xec>
  1069ba:	vpbroadcastq -0x10366b(%rip),%ymm1        # 3358 <_IO_stdin_used+0xa4>
  1069c3:	vpsllvq %ymm0,%ymm1,%ymm0
  1069c8:	vextracti128 $0x1,%ymm0,%xmm1
  1069ce:	vpor   %xmm1,%xmm0,%xmm0
  1069d2:	vpshufd $0xee,%xmm0,%xmm1
  1069d7:	vpor   %xmm1,%xmm0,%xmm0
  1069db:	vmovq  %xmm0,%rdx
  1069e0:	mov    (%rax,%rsi,8),%rax
  1069e4:	xor    %esi,%esi
  1069e6:	andn   %rdx,%rax,%rax
  1069eb:	sete   %sil
  1069ef:	mov    %esi,(%rcx,%r8,4)
  1069f3:	pop    %rbx
  1069f4:	vzeroupper
  1069f7:	ret
  1069f8:	int3
  1069f9:	int3
  1069fa:	int3
  1069fb:	int3
  1069fc:	int3
  1069fd:	int3
  1069fe:	int3
  1069ff:	int3

