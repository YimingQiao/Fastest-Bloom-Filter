0000000000046360 <void inline_single_kernel<false, external_bloom::SimdBlock, unsigned long>(external_bloom::SimdBlock const&, unsigned long, unsigned long const*, unsigned int*)>:
   46360:	test   %rsi,%rsi
   46363:	je     46481 <void inline_single_kernel<false, external_bloom::SimdBlock, unsigned long>(external_bloom::SimdBlock const&, unsigned long, unsigned long const*, unsigned int*)+0x121>
   46369:	cmp    $0x1,%rsi
   4636d:	jne    46376 <void inline_single_kernel<false, external_bloom::SimdBlock, unsigned long>(external_bloom::SimdBlock const&, unsigned long, unsigned long const*, unsigned int*)+0x16>
   4636f:	xor    %eax,%eax
   46371:	jmp    46433 <void inline_single_kernel<false, external_bloom::SimdBlock, unsigned long>(external_bloom::SimdBlock const&, unsigned long, unsigned long const*, unsigned int*)+0xd3>
   46376:	mov    %rsi,%r8
   46379:	and    $0xfffffffffffffffe,%r8
   4637d:	xor    %eax,%eax
   4637f:	vmovdqa -0x41a67(%rip),%ymm0        # 4920 <typeinfo name for main::$_60+0x150>
   46387:	vpbroadcastd -0x430e8(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
   46390:	mov    (%rdx,%rax,8),%r9
   46394:	mov    0x4(%rdi),%r10d
   46398:	and    %r9d,%r10d
   4639b:	movzbl (%rdi),%r11d
   4639f:	shrx   %r11,%r9,%r9
   463a4:	vpbroadcastd %r9d,%ymm2
   463aa:	vpmulld %ymm0,%ymm2,%ymm2
   463af:	vpsrld $0x1b,%ymm2,%ymm2
   463b4:	vpsllvd %ymm2,%ymm1,%ymm2
   463b9:	mov    0x8(%rdi),%r9
   463bd:	shl    $0x5,%r10
   463c1:	vmovdqa (%r9,%r10,1),%ymm3
   463c7:	xor    %r9d,%r9d
   463ca:	vptest %ymm2,%ymm3
   463cf:	setb   %r9b
   463d3:	mov    %r9d,(%rcx,%rax,4)
   463d7:	mov    0x8(%rdx,%rax,8),%r9
   463dc:	mov    0x4(%rdi),%r10d
   463e0:	and    %r9d,%r10d
   463e3:	movzbl (%rdi),%r11d
   463e7:	shrx   %r11,%r9,%r9
   463ec:	vpbroadcastd %r9d,%ymm2
   463f2:	vpmulld %ymm0,%ymm2,%ymm2
   463f7:	vpsrld $0x1b,%ymm2,%ymm2
   463fc:	vpsllvd %ymm2,%ymm1,%ymm2
   46401:	mov    0x8(%rdi),%r9
   46405:	shl    $0x5,%r10
   46409:	vmovdqa (%r9,%r10,1),%ymm3
   4640f:	xor    %r9d,%r9d
   46412:	vptest %ymm2,%ymm3
   46417:	setb   %r9b
   4641b:	mov    %r9d,0x4(%rcx,%rax,4)
   46420:	add    $0x2,%rax
   46424:	cmp    %rax,%r8
   46427:	jne    46390 <void inline_single_kernel<false, external_bloom::SimdBlock, unsigned long>(external_bloom::SimdBlock const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   4642d:	test   $0x1,%sil
   46431:	je     46481 <void inline_single_kernel<false, external_bloom::SimdBlock, unsigned long>(external_bloom::SimdBlock const&, unsigned long, unsigned long const*, unsigned int*)+0x121>
   46433:	mov    (%rdx,%rax,8),%rdx
   46437:	mov    0x4(%rdi),%esi
   4643a:	and    %edx,%esi
   4643c:	movzbl (%rdi),%r8d
   46440:	shrx   %r8,%rdx,%rdx
   46445:	vpbroadcastd %edx,%ymm0
   4644b:	vpmulld -0x41b34(%rip),%ymm0,%ymm0        # 4920 <typeinfo name for main::$_60+0x150>
   46454:	vpsrld $0x1b,%ymm0,%ymm0
   46459:	vpbroadcastd -0x431ba(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
   46462:	vpsllvd %ymm0,%ymm1,%ymm0
   46467:	mov    0x8(%rdi),%rdx
   4646b:	shl    $0x5,%rsi
   4646f:	vmovdqa (%rdx,%rsi,1),%ymm1
   46474:	xor    %edx,%edx
   46476:	vptest %ymm0,%ymm1
   4647b:	setb   %dl
   4647e:	mov    %edx,(%rcx,%rax,4)
   46481:	vzeroupper
   46484:	ret
   46485:	int3
   46486:	int3
   46487:	int3
   46488:	int3
   46489:	int3
   4648a:	int3
   4648b:	int3
   4648c:	int3
   4648d:	int3
   4648e:	int3
   4648f:	int3

