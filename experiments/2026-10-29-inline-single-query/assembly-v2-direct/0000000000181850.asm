0000000000181850 <void inline_single_kernel<true, independent_vbmi_experiment::IndependentVbmi32, unsigned long>(independent_vbmi_experiment::IndependentVbmi32 const&, unsigned long, unsigned long const*, unsigned int*)>:
  181850:	test   %rsi,%rsi
  181853:	je     1819e4 <void inline_single_kernel<true, independent_vbmi_experiment::IndependentVbmi32, unsigned long>(independent_vbmi_experiment::IndependentVbmi32 const&, unsigned long, unsigned long const*, unsigned int*)+0x194>
  181859:	push   %rbx
  18185a:	movabs $0xd6e8feb86659fd93,%r8
  181864:	cmp    $0x1,%rsi
  181868:	jne    181871 <void inline_single_kernel<true, independent_vbmi_experiment::IndependentVbmi32, unsigned long>(independent_vbmi_experiment::IndependentVbmi32 const&, unsigned long, unsigned long const*, unsigned int*)+0x21>
  18186a:	xor    %eax,%eax
  18186c:	jmp    181971 <void inline_single_kernel<true, independent_vbmi_experiment::IndependentVbmi32, unsigned long>(independent_vbmi_experiment::IndependentVbmi32 const&, unsigned long, unsigned long const*, unsigned int*)+0x121>
  181871:	mov    %rsi,%r9
  181874:	and    $0xfffffffffffffffe,%r9
  181878:	xor    %eax,%eax
  18187a:	vpbroadcastq -0x17e58b(%rip),%xmm0        # 32f8 <_IO_stdin_used+0x44>
  181883:	vpbroadcastd -0x17e5e4(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
  18188c:	nopl   0x0(%rax)
  181890:	mov    (%rdx,%rax,8),%r10
  181894:	mov    %r10,%r11
  181897:	shr    $0x20,%r11
  18189b:	xor    %r10,%r11
  18189e:	imul   %r8,%r11
  1818a2:	mov    %r11,%r10
  1818a5:	shr    $0x20,%r10
  1818a9:	xor    %r11,%r10
  1818ac:	imul   %r8,%r10
  1818b0:	mov    %r10,%r11
  1818b3:	shr    $0x20,%r11
  1818b7:	xor    %r10,%r11
  1818ba:	shr    $0x29,%r10
  1818be:	and    0x18(%rdi),%r10d
  1818c2:	mov    (%rdi),%rbx
  1818c5:	shl    $0x5,%r10d
  1818c9:	vmovdqa (%rbx,%r10,1),%ymm2
  1818cf:	vpbroadcastq %r11,%xmm3
  1818d5:	vpmultishiftqb %xmm3,%xmm0,%xmm3
  1818db:	vpmovzxbd %xmm3,%ymm3
  1818e0:	vprolvd %ymm3,%ymm1,%ymm3
  1818e6:	xor    %r10d,%r10d
  1818e9:	vptest %ymm3,%ymm2
  1818ee:	setb   %r10b
  1818f2:	mov    %r10d,(%rcx,%rax,4)
  1818f6:	mov    0x8(%rdx,%rax,8),%r10
  1818fb:	mov    %r10,%r11
  1818fe:	shr    $0x20,%r11
  181902:	xor    %r10,%r11
  181905:	imul   %r8,%r11
  181909:	mov    %r11,%r10
  18190c:	shr    $0x20,%r10
  181910:	xor    %r11,%r10
  181913:	imul   %r8,%r10
  181917:	mov    %r10,%r11
  18191a:	shr    $0x20,%r11
  18191e:	xor    %r10,%r11
  181921:	shr    $0x29,%r10
  181925:	and    0x18(%rdi),%r10d
  181929:	mov    (%rdi),%rbx
  18192c:	shl    $0x5,%r10d
  181930:	vmovdqa (%rbx,%r10,1),%ymm2
  181936:	vpbroadcastq %r11,%xmm3
  18193c:	vpmultishiftqb %xmm3,%xmm0,%xmm3
  181942:	vpmovzxbd %xmm3,%ymm3
  181947:	vprolvd %ymm3,%ymm1,%ymm3
  18194d:	xor    %r10d,%r10d
  181950:	vptest %ymm3,%ymm2
  181955:	setb   %r10b
  181959:	mov    %r10d,0x4(%rcx,%rax,4)
  18195e:	add    $0x2,%rax
  181962:	cmp    %rax,%r9
  181965:	jne    181890 <void inline_single_kernel<true, independent_vbmi_experiment::IndependentVbmi32, unsigned long>(independent_vbmi_experiment::IndependentVbmi32 const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
  18196b:	test   $0x1,%sil
  18196f:	je     1819e3 <void inline_single_kernel<true, independent_vbmi_experiment::IndependentVbmi32, unsigned long>(independent_vbmi_experiment::IndependentVbmi32 const&, unsigned long, unsigned long const*, unsigned int*)+0x193>
  181971:	mov    (%rdx,%rax,8),%rdx
  181975:	mov    %rdx,%rsi
  181978:	shr    $0x20,%rsi
  18197c:	xor    %rdx,%rsi
  18197f:	imul   %r8,%rsi
  181983:	mov    %rsi,%rdx
  181986:	shr    $0x20,%rdx
  18198a:	xor    %rsi,%rdx
  18198d:	imul   %r8,%rdx
  181991:	mov    %rdx,%rsi
  181994:	shr    $0x20,%rsi
  181998:	xor    %rdx,%rsi
  18199b:	shr    $0x29,%rdx
  18199f:	and    0x18(%rdi),%edx
  1819a2:	mov    (%rdi),%rdi
  1819a5:	shl    $0x5,%edx
  1819a8:	vmovdqa (%rdi,%rdx,1),%ymm0
  1819ad:	vpbroadcastq %rsi,%xmm1
  1819b3:	vpbroadcastq -0x17e6c4(%rip),%xmm2        # 32f8 <_IO_stdin_used+0x44>
  1819bc:	vpmultishiftqb %xmm1,%xmm2,%xmm1
  1819c2:	vpmovzxbd %xmm1,%ymm1
  1819c7:	vpbroadcastd -0x17e728(%rip),%ymm2        # 32a8 <__abi_tag+0x2fe4>
  1819d0:	vprolvd %ymm1,%ymm2,%ymm1
  1819d6:	xor    %edx,%edx
  1819d8:	vptest %ymm1,%ymm0
  1819dd:	setb   %dl
  1819e0:	mov    %edx,(%rcx,%rax,4)
  1819e3:	pop    %rbx
  1819e4:	vzeroupper
  1819e7:	ret
  1819e8:	int3
  1819e9:	int3
  1819ea:	int3
  1819eb:	int3
  1819ec:	int3
  1819ed:	int3
  1819ee:	int3
  1819ef:	int3

