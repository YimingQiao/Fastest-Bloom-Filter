00000000000d62a0 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<6ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<6ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
   d62a0:	test   %rsi,%rsi
   d62a3:	je     d646d <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<6ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<6ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x1cd>
   d62a9:	push   %r14
   d62ab:	push   %rbx
   d62ac:	mov    %rdx,%rax
   d62af:	movabs $0xf1357aea2e62a9c5,%r9
   d62b9:	movabs $0xd6e8feb86659fd93,%r10
   d62c3:	cmp    $0x1,%rsi
   d62c7:	jne    d62d1 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<6ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<6ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x31>
   d62c9:	xor    %r8d,%r8d
   d62cc:	jmp    d63ed <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<6ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<6ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x14d>
   d62d1:	mov    %rsi,%r11
   d62d4:	and    $0xfffffffffffffffe,%r11
   d62d8:	xor    %r8d,%r8d
   d62db:	vmovdqa -0xd17a3(%rip),%ymm0        # 4b40 <typeinfo name for main::$_60+0x370>
   d62e3:	vmovdqa -0xd1a8b(%rip),%ymm1        # 4860 <typeinfo name for main::$_60+0x90>
   d62eb:	nopl   0x0(%rax,%rax,1)
   d62f0:	mov    (%rax,%r8,8),%rdx
   d62f4:	mov    %rdx,%rbx
   d62f7:	shr    $0x20,%rbx
   d62fb:	xor    %rdx,%rbx
   d62fe:	imul   %r10,%rbx
   d6302:	mov    %rbx,%r14
   d6305:	shr    $0x20,%r14
   d6309:	xor    %rbx,%r14
   d630c:	imul   %r10,%r14
   d6310:	mov    %r14,%rdx
   d6313:	shr    $0x20,%rdx
   d6317:	xor    %r14,%rdx
   d631a:	or     $0x1,%rdx
   d631e:	mov    0x20(%rdi),%rbx
   d6322:	mulx   0x10(%rdi),%r14,%r14
   d6328:	lea    (%r14,%r14,2),%r14
   d632c:	prefetcht0 (%rbx,%r14,8)
   d6331:	imul   %r9,%rdx
   d6335:	vmovdqu (%rbx,%r14,8),%ymm2
   d633b:	vpbroadcastq %rdx,%ymm3
   d6341:	vpsllvq %ymm0,%ymm3,%ymm3
   d6346:	vpsrld $0x1b,%ymm3,%ymm3
   d634b:	vpsllvd %ymm3,%ymm1,%ymm3
   d6350:	xor    %edx,%edx
   d6352:	vptest %ymm3,%ymm2
   d6357:	prefetcht0 0x40(%rbx,%r14,8)
   d635d:	setb   %dl
   d6360:	mov    %edx,(%rcx,%r8,4)
   d6364:	mov    0x8(%rax,%r8,8),%rdx
   d6369:	mov    %rdx,%rbx
   d636c:	shr    $0x20,%rbx
   d6370:	xor    %rdx,%rbx
   d6373:	imul   %r10,%rbx
   d6377:	mov    %rbx,%r14
   d637a:	shr    $0x20,%r14
   d637e:	xor    %rbx,%r14
   d6381:	imul   %r10,%r14
   d6385:	mov    %r14,%rdx
   d6388:	shr    $0x20,%rdx
   d638c:	xor    %r14,%rdx
   d638f:	or     $0x1,%rdx
   d6393:	mov    0x20(%rdi),%rbx
   d6397:	mulx   0x10(%rdi),%r14,%r14
   d639d:	lea    (%r14,%r14,2),%r14
   d63a1:	prefetcht0 (%rbx,%r14,8)
   d63a6:	prefetcht0 0x40(%rbx,%r14,8)
   d63ac:	imul   %r9,%rdx
   d63b0:	vmovdqu (%rbx,%r14,8),%ymm2
   d63b6:	vpbroadcastq %rdx,%ymm3
   d63bc:	vpsllvq %ymm0,%ymm3,%ymm3
   d63c1:	vpsrld $0x1b,%ymm3,%ymm3
   d63c6:	vpsllvd %ymm3,%ymm1,%ymm3
   d63cb:	xor    %edx,%edx
   d63cd:	vptest %ymm3,%ymm2
   d63d2:	setb   %dl
   d63d5:	mov    %edx,0x4(%rcx,%r8,4)
   d63da:	add    $0x2,%r8
   d63de:	cmp    %r8,%r11
   d63e1:	jne    d62f0 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<6ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<6ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
   d63e7:	test   $0x1,%sil
   d63eb:	je     d646a <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<6ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<6ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x1ca>
   d63ed:	mov    (%rax,%r8,8),%rax
   d63f1:	mov    %rax,%rdx
   d63f4:	shr    $0x20,%rdx
   d63f8:	xor    %rax,%rdx
   d63fb:	imul   %r10,%rdx
   d63ff:	mov    %rdx,%rax
   d6402:	shr    $0x20,%rax
   d6406:	xor    %rdx,%rax
   d6409:	imul   %r10,%rax
   d640d:	mov    %rax,%rdx
   d6410:	shr    $0x20,%rdx
   d6414:	xor    %rax,%rdx
   d6417:	or     $0x1,%rdx
   d641b:	mov    0x20(%rdi),%rax
   d641f:	mulx   0x10(%rdi),%rsi,%rsi
   d6425:	lea    (%rsi,%rsi,2),%rsi
   d6429:	prefetcht0 (%rax,%rsi,8)
   d642d:	prefetcht0 0x40(%rax,%rsi,8)
   d6432:	imul   %r9,%rdx
   d6436:	vmovdqu (%rax,%rsi,8),%ymm0
   d643b:	vpbroadcastq %rdx,%ymm1
   d6441:	vpsllvq -0xd190a(%rip),%ymm1,%ymm1        # 4b40 <typeinfo name for main::$_60+0x370>
   d644a:	vpsrld $0x1b,%ymm1,%ymm1
   d644f:	vmovdqa -0xd1bf7(%rip),%ymm2        # 4860 <typeinfo name for main::$_60+0x90>
   d6457:	vpsllvd %ymm1,%ymm2,%ymm1
   d645c:	xor    %eax,%eax
   d645e:	vptest %ymm1,%ymm0
   d6463:	setb   %al
   d6466:	mov    %eax,(%rcx,%r8,4)
   d646a:	pop    %rbx
   d646b:	pop    %r14
   d646d:	vzeroupper
   d6470:	ret
   d6471:	int3
   d6472:	int3
   d6473:	int3
   d6474:	int3
   d6475:	int3
   d6476:	int3
   d6477:	int3
   d6478:	int3
   d6479:	int3
   d647a:	int3
   d647b:	int3
   d647c:	int3
   d647d:	int3
   d647e:	int3
   d647f:	int3

