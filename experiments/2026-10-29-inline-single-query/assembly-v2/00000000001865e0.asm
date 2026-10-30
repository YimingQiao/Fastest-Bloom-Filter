00000000001865e0 <void inline_single_kernel<true, direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32>, unsigned long>(direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32> const&, unsigned long, unsigned long const*, unsigned int*)>:
  1865e0:	test   %rsi,%rsi
  1865e3:	je     186774 <void inline_single_kernel<true, direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32>, unsigned long>(direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32> const&, unsigned long, unsigned long const*, unsigned int*)+0x194>
  1865e9:	push   %rbx
  1865ea:	movabs $0xd6e8feb86659fd93,%r8
  1865f4:	cmp    $0x1,%rsi
  1865f8:	jne    186601 <void inline_single_kernel<true, direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32>, unsigned long>(direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32> const&, unsigned long, unsigned long const*, unsigned int*)+0x21>
  1865fa:	xor    %eax,%eax
  1865fc:	jmp    186701 <void inline_single_kernel<true, direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32>, unsigned long>(direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32> const&, unsigned long, unsigned long const*, unsigned int*)+0x121>
  186601:	mov    %rsi,%r9
  186604:	and    $0xfffffffffffffffe,%r9
  186608:	xor    %eax,%eax
  18660a:	vpbroadcastq -0x18331b(%rip),%xmm0        # 32f8 <_IO_stdin_used+0x44>
  186613:	vpbroadcastd -0x183374(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
  18661c:	nopl   0x0(%rax)
  186620:	mov    (%rdx,%rax,8),%r10
  186624:	mov    %r10,%r11
  186627:	shr    $0x20,%r11
  18662b:	xor    %r10,%r11
  18662e:	imul   %r8,%r11
  186632:	mov    %r11,%r10
  186635:	shr    $0x20,%r10
  186639:	xor    %r11,%r10
  18663c:	imul   %r8,%r10
  186640:	mov    %r10,%r11
  186643:	shr    $0x20,%r11
  186647:	xor    %r10,%r11
  18664a:	shr    $0x29,%r10
  18664e:	and    0x18(%rdi),%r10d
  186652:	mov    (%rdi),%rbx
  186655:	shl    $0x5,%r10d
  186659:	vmovdqa (%rbx,%r10,1),%ymm2
  18665f:	vpbroadcastq %r11,%xmm3
  186665:	vpmultishiftqb %xmm3,%xmm0,%xmm3
  18666b:	vpmovzxbd %xmm3,%ymm3
  186670:	vprolvd %ymm3,%ymm1,%ymm3
  186676:	xor    %r10d,%r10d
  186679:	vptest %ymm3,%ymm2
  18667e:	setb   %r10b
  186682:	mov    %r10d,(%rcx,%rax,4)
  186686:	mov    0x8(%rdx,%rax,8),%r10
  18668b:	mov    %r10,%r11
  18668e:	shr    $0x20,%r11
  186692:	xor    %r10,%r11
  186695:	imul   %r8,%r11
  186699:	mov    %r11,%r10
  18669c:	shr    $0x20,%r10
  1866a0:	xor    %r11,%r10
  1866a3:	imul   %r8,%r10
  1866a7:	mov    %r10,%r11
  1866aa:	shr    $0x20,%r11
  1866ae:	xor    %r10,%r11
  1866b1:	shr    $0x29,%r10
  1866b5:	and    0x18(%rdi),%r10d
  1866b9:	mov    (%rdi),%rbx
  1866bc:	shl    $0x5,%r10d
  1866c0:	vmovdqa (%rbx,%r10,1),%ymm2
  1866c6:	vpbroadcastq %r11,%xmm3
  1866cc:	vpmultishiftqb %xmm3,%xmm0,%xmm3
  1866d2:	vpmovzxbd %xmm3,%ymm3
  1866d7:	vprolvd %ymm3,%ymm1,%ymm3
  1866dd:	xor    %r10d,%r10d
  1866e0:	vptest %ymm3,%ymm2
  1866e5:	setb   %r10b
  1866e9:	mov    %r10d,0x4(%rcx,%rax,4)
  1866ee:	add    $0x2,%rax
  1866f2:	cmp    %rax,%r9
  1866f5:	jne    186620 <void inline_single_kernel<true, direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32>, unsigned long>(direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
  1866fb:	test   $0x1,%sil
  1866ff:	je     186773 <void inline_single_kernel<true, direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32>, unsigned long>(direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32> const&, unsigned long, unsigned long const*, unsigned int*)+0x193>
  186701:	mov    (%rdx,%rax,8),%rdx
  186705:	mov    %rdx,%rsi
  186708:	shr    $0x20,%rsi
  18670c:	xor    %rdx,%rsi
  18670f:	imul   %r8,%rsi
  186713:	mov    %rsi,%rdx
  186716:	shr    $0x20,%rdx
  18671a:	xor    %rsi,%rdx
  18671d:	imul   %r8,%rdx
  186721:	mov    %rdx,%rsi
  186724:	shr    $0x20,%rsi
  186728:	xor    %rdx,%rsi
  18672b:	shr    $0x29,%rdx
  18672f:	and    0x18(%rdi),%edx
  186732:	mov    (%rdi),%rdi
  186735:	shl    $0x5,%edx
  186738:	vmovdqa (%rdi,%rdx,1),%ymm0
  18673d:	vpbroadcastq %rsi,%xmm1
  186743:	vpbroadcastq -0x183454(%rip),%xmm2        # 32f8 <_IO_stdin_used+0x44>
  18674c:	vpmultishiftqb %xmm1,%xmm2,%xmm1
  186752:	vpmovzxbd %xmm1,%ymm1
  186757:	vpbroadcastd -0x1834b8(%rip),%ymm2        # 32a8 <__abi_tag+0x2fe4>
  186760:	vprolvd %ymm1,%ymm2,%ymm1
  186766:	xor    %edx,%edx
  186768:	vptest %ymm1,%ymm0
  18676d:	setb   %dl
  186770:	mov    %edx,(%rcx,%rax,4)
  186773:	pop    %rbx
  186774:	vzeroupper
  186777:	ret
  186778:	int3
  186779:	int3
  18677a:	int3
  18677b:	int3
  18677c:	int3
  18677d:	int3
  18677e:	int3
  18677f:	int3

