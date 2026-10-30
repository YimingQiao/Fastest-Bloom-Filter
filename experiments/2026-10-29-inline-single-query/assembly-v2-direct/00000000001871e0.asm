00000000001871e0 <void inline_single_kernel<true, direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32>, unsigned long>(direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32> const&, unsigned long, unsigned long const*, unsigned int*)>:
  1871e0:	test   %rsi,%rsi
  1871e3:	je     187374 <void inline_single_kernel<true, direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32>, unsigned long>(direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32> const&, unsigned long, unsigned long const*, unsigned int*)+0x194>
  1871e9:	push   %rbx
  1871ea:	movabs $0xd6e8feb86659fd93,%r8
  1871f4:	cmp    $0x1,%rsi
  1871f8:	jne    187201 <void inline_single_kernel<true, direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32>, unsigned long>(direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32> const&, unsigned long, unsigned long const*, unsigned int*)+0x21>
  1871fa:	xor    %eax,%eax
  1871fc:	jmp    187301 <void inline_single_kernel<true, direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32>, unsigned long>(direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32> const&, unsigned long, unsigned long const*, unsigned int*)+0x121>
  187201:	mov    %rsi,%r9
  187204:	and    $0xfffffffffffffffe,%r9
  187208:	xor    %eax,%eax
  18720a:	vpbroadcastq -0x183f1b(%rip),%xmm0        # 32f8 <_IO_stdin_used+0x44>
  187213:	vpbroadcastd -0x183f74(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
  18721c:	nopl   0x0(%rax)
  187220:	mov    (%rdx,%rax,8),%r10
  187224:	mov    %r10,%r11
  187227:	shr    $0x20,%r11
  18722b:	xor    %r10,%r11
  18722e:	imul   %r8,%r11
  187232:	mov    %r11,%r10
  187235:	shr    $0x20,%r10
  187239:	xor    %r11,%r10
  18723c:	imul   %r8,%r10
  187240:	mov    %r10,%r11
  187243:	shr    $0x20,%r11
  187247:	xor    %r10,%r11
  18724a:	shr    $0x29,%r10
  18724e:	and    0x18(%rdi),%r10d
  187252:	mov    (%rdi),%rbx
  187255:	shl    $0x5,%r10d
  187259:	vmovdqa (%rbx,%r10,1),%ymm2
  18725f:	vpbroadcastq %r11,%xmm3
  187265:	vpmultishiftqb %xmm3,%xmm0,%xmm3
  18726b:	vpmovzxbd %xmm3,%ymm3
  187270:	vprolvd %ymm3,%ymm1,%ymm3
  187276:	xor    %r10d,%r10d
  187279:	vptest %ymm3,%ymm2
  18727e:	setb   %r10b
  187282:	mov    %r10d,(%rcx,%rax,4)
  187286:	mov    0x8(%rdx,%rax,8),%r10
  18728b:	mov    %r10,%r11
  18728e:	shr    $0x20,%r11
  187292:	xor    %r10,%r11
  187295:	imul   %r8,%r11
  187299:	mov    %r11,%r10
  18729c:	shr    $0x20,%r10
  1872a0:	xor    %r11,%r10
  1872a3:	imul   %r8,%r10
  1872a7:	mov    %r10,%r11
  1872aa:	shr    $0x20,%r11
  1872ae:	xor    %r10,%r11
  1872b1:	shr    $0x29,%r10
  1872b5:	and    0x18(%rdi),%r10d
  1872b9:	mov    (%rdi),%rbx
  1872bc:	shl    $0x5,%r10d
  1872c0:	vmovdqa (%rbx,%r10,1),%ymm2
  1872c6:	vpbroadcastq %r11,%xmm3
  1872cc:	vpmultishiftqb %xmm3,%xmm0,%xmm3
  1872d2:	vpmovzxbd %xmm3,%ymm3
  1872d7:	vprolvd %ymm3,%ymm1,%ymm3
  1872dd:	xor    %r10d,%r10d
  1872e0:	vptest %ymm3,%ymm2
  1872e5:	setb   %r10b
  1872e9:	mov    %r10d,0x4(%rcx,%rax,4)
  1872ee:	add    $0x2,%rax
  1872f2:	cmp    %rax,%r9
  1872f5:	jne    187220 <void inline_single_kernel<true, direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32>, unsigned long>(direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
  1872fb:	test   $0x1,%sil
  1872ff:	je     187373 <void inline_single_kernel<true, direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32>, unsigned long>(direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32> const&, unsigned long, unsigned long const*, unsigned int*)+0x193>
  187301:	mov    (%rdx,%rax,8),%rdx
  187305:	mov    %rdx,%rsi
  187308:	shr    $0x20,%rsi
  18730c:	xor    %rdx,%rsi
  18730f:	imul   %r8,%rsi
  187313:	mov    %rsi,%rdx
  187316:	shr    $0x20,%rdx
  18731a:	xor    %rsi,%rdx
  18731d:	imul   %r8,%rdx
  187321:	mov    %rdx,%rsi
  187324:	shr    $0x20,%rsi
  187328:	xor    %rdx,%rsi
  18732b:	shr    $0x29,%rdx
  18732f:	and    0x18(%rdi),%edx
  187332:	mov    (%rdi),%rdi
  187335:	shl    $0x5,%edx
  187338:	vmovdqa (%rdi,%rdx,1),%ymm0
  18733d:	vpbroadcastq %rsi,%xmm1
  187343:	vpbroadcastq -0x184054(%rip),%xmm2        # 32f8 <_IO_stdin_used+0x44>
  18734c:	vpmultishiftqb %xmm1,%xmm2,%xmm1
  187352:	vpmovzxbd %xmm1,%ymm1
  187357:	vpbroadcastd -0x1840b8(%rip),%ymm2        # 32a8 <__abi_tag+0x2fe4>
  187360:	vprolvd %ymm1,%ymm2,%ymm1
  187366:	xor    %edx,%edx
  187368:	vptest %ymm1,%ymm0
  18736d:	setb   %dl
  187370:	mov    %edx,(%rcx,%rax,4)
  187373:	pop    %rbx
  187374:	vzeroupper
  187377:	ret
  187378:	int3
  187379:	int3
  18737a:	int3
  18737b:	int3
  18737c:	int3
  18737d:	int3
  18737e:	int3
  18737f:	int3

