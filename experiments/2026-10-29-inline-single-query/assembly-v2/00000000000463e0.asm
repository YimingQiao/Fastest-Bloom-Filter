00000000000463e0 <void inline_single_kernel<false, external_bloom::SimdBlock, unsigned long>(external_bloom::SimdBlock const&, unsigned long, unsigned long const*, unsigned int*)>:
   463e0:	test   %rsi,%rsi
   463e3:	je     46501 <void inline_single_kernel<false, external_bloom::SimdBlock, unsigned long>(external_bloom::SimdBlock const&, unsigned long, unsigned long const*, unsigned int*)+0x121>
   463e9:	cmp    $0x1,%rsi
   463ed:	jne    463f6 <void inline_single_kernel<false, external_bloom::SimdBlock, unsigned long>(external_bloom::SimdBlock const&, unsigned long, unsigned long const*, unsigned int*)+0x16>
   463ef:	xor    %eax,%eax
   463f1:	jmp    464b3 <void inline_single_kernel<false, external_bloom::SimdBlock, unsigned long>(external_bloom::SimdBlock const&, unsigned long, unsigned long const*, unsigned int*)+0xd3>
   463f6:	mov    %rsi,%r8
   463f9:	and    $0xfffffffffffffffe,%r8
   463fd:	xor    %eax,%eax
   463ff:	vmovdqa -0x41ae7(%rip),%ymm0        # 4920 <typeinfo name for main::$_60+0x150>
   46407:	vpbroadcastd -0x43168(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
   46410:	mov    (%rdx,%rax,8),%r9
   46414:	mov    0x4(%rdi),%r10d
   46418:	and    %r9d,%r10d
   4641b:	movzbl (%rdi),%r11d
   4641f:	shrx   %r11,%r9,%r9
   46424:	vpbroadcastd %r9d,%ymm2
   4642a:	vpmulld %ymm0,%ymm2,%ymm2
   4642f:	vpsrld $0x1b,%ymm2,%ymm2
   46434:	vpsllvd %ymm2,%ymm1,%ymm2
   46439:	mov    0x8(%rdi),%r9
   4643d:	shl    $0x5,%r10
   46441:	vmovdqa (%r9,%r10,1),%ymm3
   46447:	xor    %r9d,%r9d
   4644a:	vptest %ymm2,%ymm3
   4644f:	setb   %r9b
   46453:	mov    %r9d,(%rcx,%rax,4)
   46457:	mov    0x8(%rdx,%rax,8),%r9
   4645c:	mov    0x4(%rdi),%r10d
   46460:	and    %r9d,%r10d
   46463:	movzbl (%rdi),%r11d
   46467:	shrx   %r11,%r9,%r9
   4646c:	vpbroadcastd %r9d,%ymm2
   46472:	vpmulld %ymm0,%ymm2,%ymm2
   46477:	vpsrld $0x1b,%ymm2,%ymm2
   4647c:	vpsllvd %ymm2,%ymm1,%ymm2
   46481:	mov    0x8(%rdi),%r9
   46485:	shl    $0x5,%r10
   46489:	vmovdqa (%r9,%r10,1),%ymm3
   4648f:	xor    %r9d,%r9d
   46492:	vptest %ymm2,%ymm3
   46497:	setb   %r9b
   4649b:	mov    %r9d,0x4(%rcx,%rax,4)
   464a0:	add    $0x2,%rax
   464a4:	cmp    %rax,%r8
   464a7:	jne    46410 <void inline_single_kernel<false, external_bloom::SimdBlock, unsigned long>(external_bloom::SimdBlock const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   464ad:	test   $0x1,%sil
   464b1:	je     46501 <void inline_single_kernel<false, external_bloom::SimdBlock, unsigned long>(external_bloom::SimdBlock const&, unsigned long, unsigned long const*, unsigned int*)+0x121>
   464b3:	mov    (%rdx,%rax,8),%rdx
   464b7:	mov    0x4(%rdi),%esi
   464ba:	and    %edx,%esi
   464bc:	movzbl (%rdi),%r8d
   464c0:	shrx   %r8,%rdx,%rdx
   464c5:	vpbroadcastd %edx,%ymm0
   464cb:	vpmulld -0x41bb4(%rip),%ymm0,%ymm0        # 4920 <typeinfo name for main::$_60+0x150>
   464d4:	vpsrld $0x1b,%ymm0,%ymm0
   464d9:	vpbroadcastd -0x4323a(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
   464e2:	vpsllvd %ymm0,%ymm1,%ymm0
   464e7:	mov    0x8(%rdi),%rdx
   464eb:	shl    $0x5,%rsi
   464ef:	vmovdqa (%rdx,%rsi,1),%ymm1
   464f4:	xor    %edx,%edx
   464f6:	vptest %ymm0,%ymm1
   464fb:	setb   %dl
   464fe:	mov    %edx,(%rcx,%rax,4)
   46501:	vzeroupper
   46504:	ret
   46505:	int3
   46506:	int3
   46507:	int3
   46508:	int3
   46509:	int3
   4650a:	int3
   4650b:	int3
   4650c:	int3
   4650d:	int3
   4650e:	int3
   4650f:	int3

