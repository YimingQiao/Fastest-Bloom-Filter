00000000000d6220 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<6ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<6ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
   d6220:	test   %rsi,%rsi
   d6223:	je     d63ed <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<6ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<6ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x1cd>
   d6229:	push   %r14
   d622b:	push   %rbx
   d622c:	mov    %rdx,%rax
   d622f:	movabs $0xf1357aea2e62a9c5,%r9
   d6239:	movabs $0xd6e8feb86659fd93,%r10
   d6243:	cmp    $0x1,%rsi
   d6247:	jne    d6251 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<6ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<6ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x31>
   d6249:	xor    %r8d,%r8d
   d624c:	jmp    d636d <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<6ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<6ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x14d>
   d6251:	mov    %rsi,%r11
   d6254:	and    $0xfffffffffffffffe,%r11
   d6258:	xor    %r8d,%r8d
   d625b:	vmovdqa -0xd1723(%rip),%ymm0        # 4b40 <typeinfo name for main::$_60+0x370>
   d6263:	vmovdqa -0xd1a0b(%rip),%ymm1        # 4860 <typeinfo name for main::$_60+0x90>
   d626b:	nopl   0x0(%rax,%rax,1)
   d6270:	mov    (%rax,%r8,8),%rdx
   d6274:	mov    %rdx,%rbx
   d6277:	shr    $0x20,%rbx
   d627b:	xor    %rdx,%rbx
   d627e:	imul   %r10,%rbx
   d6282:	mov    %rbx,%r14
   d6285:	shr    $0x20,%r14
   d6289:	xor    %rbx,%r14
   d628c:	imul   %r10,%r14
   d6290:	mov    %r14,%rdx
   d6293:	shr    $0x20,%rdx
   d6297:	xor    %r14,%rdx
   d629a:	or     $0x1,%rdx
   d629e:	mov    0x20(%rdi),%rbx
   d62a2:	mulx   0x10(%rdi),%r14,%r14
   d62a8:	lea    (%r14,%r14,2),%r14
   d62ac:	prefetcht0 (%rbx,%r14,8)
   d62b1:	imul   %r9,%rdx
   d62b5:	vmovdqu (%rbx,%r14,8),%ymm2
   d62bb:	vpbroadcastq %rdx,%ymm3
   d62c1:	vpsllvq %ymm0,%ymm3,%ymm3
   d62c6:	vpsrld $0x1b,%ymm3,%ymm3
   d62cb:	vpsllvd %ymm3,%ymm1,%ymm3
   d62d0:	xor    %edx,%edx
   d62d2:	vptest %ymm3,%ymm2
   d62d7:	prefetcht0 0x40(%rbx,%r14,8)
   d62dd:	setb   %dl
   d62e0:	mov    %edx,(%rcx,%r8,4)
   d62e4:	mov    0x8(%rax,%r8,8),%rdx
   d62e9:	mov    %rdx,%rbx
   d62ec:	shr    $0x20,%rbx
   d62f0:	xor    %rdx,%rbx
   d62f3:	imul   %r10,%rbx
   d62f7:	mov    %rbx,%r14
   d62fa:	shr    $0x20,%r14
   d62fe:	xor    %rbx,%r14
   d6301:	imul   %r10,%r14
   d6305:	mov    %r14,%rdx
   d6308:	shr    $0x20,%rdx
   d630c:	xor    %r14,%rdx
   d630f:	or     $0x1,%rdx
   d6313:	mov    0x20(%rdi),%rbx
   d6317:	mulx   0x10(%rdi),%r14,%r14
   d631d:	lea    (%r14,%r14,2),%r14
   d6321:	prefetcht0 (%rbx,%r14,8)
   d6326:	prefetcht0 0x40(%rbx,%r14,8)
   d632c:	imul   %r9,%rdx
   d6330:	vmovdqu (%rbx,%r14,8),%ymm2
   d6336:	vpbroadcastq %rdx,%ymm3
   d633c:	vpsllvq %ymm0,%ymm3,%ymm3
   d6341:	vpsrld $0x1b,%ymm3,%ymm3
   d6346:	vpsllvd %ymm3,%ymm1,%ymm3
   d634b:	xor    %edx,%edx
   d634d:	vptest %ymm3,%ymm2
   d6352:	setb   %dl
   d6355:	mov    %edx,0x4(%rcx,%r8,4)
   d635a:	add    $0x2,%r8
   d635e:	cmp    %r8,%r11
   d6361:	jne    d6270 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<6ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<6ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
   d6367:	test   $0x1,%sil
   d636b:	je     d63ea <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<6ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<6ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x1ca>
   d636d:	mov    (%rax,%r8,8),%rax
   d6371:	mov    %rax,%rdx
   d6374:	shr    $0x20,%rdx
   d6378:	xor    %rax,%rdx
   d637b:	imul   %r10,%rdx
   d637f:	mov    %rdx,%rax
   d6382:	shr    $0x20,%rax
   d6386:	xor    %rdx,%rax
   d6389:	imul   %r10,%rax
   d638d:	mov    %rax,%rdx
   d6390:	shr    $0x20,%rdx
   d6394:	xor    %rax,%rdx
   d6397:	or     $0x1,%rdx
   d639b:	mov    0x20(%rdi),%rax
   d639f:	mulx   0x10(%rdi),%rsi,%rsi
   d63a5:	lea    (%rsi,%rsi,2),%rsi
   d63a9:	prefetcht0 (%rax,%rsi,8)
   d63ad:	prefetcht0 0x40(%rax,%rsi,8)
   d63b2:	imul   %r9,%rdx
   d63b6:	vmovdqu (%rax,%rsi,8),%ymm0
   d63bb:	vpbroadcastq %rdx,%ymm1
   d63c1:	vpsllvq -0xd188a(%rip),%ymm1,%ymm1        # 4b40 <typeinfo name for main::$_60+0x370>
   d63ca:	vpsrld $0x1b,%ymm1,%ymm1
   d63cf:	vmovdqa -0xd1b77(%rip),%ymm2        # 4860 <typeinfo name for main::$_60+0x90>
   d63d7:	vpsllvd %ymm1,%ymm2,%ymm1
   d63dc:	xor    %eax,%eax
   d63de:	vptest %ymm1,%ymm0
   d63e3:	setb   %al
   d63e6:	mov    %eax,(%rcx,%r8,4)
   d63ea:	pop    %rbx
   d63eb:	pop    %r14
   d63ed:	vzeroupper
   d63f0:	ret
   d63f1:	int3
   d63f2:	int3
   d63f3:	int3
   d63f4:	int3
   d63f5:	int3
   d63f6:	int3
   d63f7:	int3
   d63f8:	int3
   d63f9:	int3
   d63fa:	int3
   d63fb:	int3
   d63fc:	int3
   d63fd:	int3
   d63fe:	int3
   d63ff:	int3

