   15306:	add    $0x8,%r8
   1530a:	cmp    %r8,%r9
   1530d:	jne    15300 <_Z3RunIN13bloom_filters21FourSectorBloomFilterEEvRK5PointRK4CaseRK5Input+0x18d0>
   1530f:	cmp    %r9,%rdi
   15312:	je     1532f <_Z3RunIN13bloom_filters21FourSectorBloomFilterEEvRK5PointRK4CaseRK5Input+0x18ff>
   15314:	lea    0x40(%rcx,%rax,4),%rax
   15319:	nopl   0x0(%rax)
   15320:	movl   $0x2,(%rsi)
   15326:	add    $0x4,%rsi
   1532a:	cmp    %rax,%rsi
   1532d:	jne    15320 <_Z3RunIN13bloom_filters21FourSectorBloomFilterEEvRK5PointRK4CaseRK5Input+0x18f0>
   1532f:	vzeroupper
   15332:	call   2eab0 <_ZNSt6chrono3_V212steady_clock3nowEv@plt>
   15337:	mov    %rax,0x58(%rsp)
   1533c:	mov    %rbx,%r13
   1533f:	cmp    $0x3,%ebx
   15342:	ja     15770 <_Z3RunIN13bloom_filters21FourSectorBloomFilterEEvRK5PointRK4CaseRK5Input+0x1d40>
   15348:	mov    %r13d,%eax
   1534b:	lea    -0x13812(%rip),%rcx        # 1b40 <_IO_stdin_used+0x460>
   15352:	movslq (%rcx,%rax,4),%rax
   15356:	add    %rcx,%rax
   15359:	jmp    *%rax
   1535b:	mov    0x20(%rsp),%rax
   15360:	cmp    %rax,0x28(%rsp)
   15365:	mov    0x18(%rsp),%rbp
   1536a:	je     15770 <_Z3RunIN13bloom_filters21FourSectorBloomFilterEEvRK5PointRK4CaseRK5Input+0x1d40>
   15370:	mov    0x10(%rsp),%rax
   15375:	mov    0xc(%rax),%eax
   15378:	xor    %ebx,%ebx
   1537a:	nopw   0x0(%rax,%rax,1)
   15380:	mov    %eax,%eax
   15382:	mov    %rbp,%rsi
   15385:	sub    %rbx,%rsi
   15388:	cmp    %rax,%rsi
   1538b:	cmovae %rax,%rsi
   1538f:	lea    0x0(,%rbx,8),%rdx
   15397:	mov    (%rsp),%rax
   1539b:	add    0x48(%rax),%rdx
   1539f:	mov    0x30(%rsp),%rax
   153a4:	lea    0x40(%rax,%rbx,4),%rcx
   153a9:	mov    %r15,%rdi
   153ac:	call   29bb0 <_Z13lookup_kernelIN13bloom_filters21FourSectorBloomFilterEmEvRT_mPKT0_Pj>
   153b1:	mov    0x10(%rsp),%rax
   153b6:	mov    0xc(%rax),%eax
   153b9:	add    %rax,%rbx
   153bc:	cmp    %rbp,%rbx
   153bf:	jb     15380 <_Z3RunIN13bloom_filters21FourSectorBloomFilterEEvRK5PointRK4CaseRK5Input+0x1950>
   153c1:	jmp    15770 <_Z3RunIN13bloom_filters21FourSectorBloomFilterEEvRK5PointRK4CaseRK5Input+0x1d40>
   153c6:	mov    (%rsp),%rax
   153ca:	mov    0x48(%rax),%rdx
   153ce:	mov    0x30(%rsp),%rcx
   153d3:	add    $0x40,%rcx
   153d7:	mov    %r15,%rdi
   153da:	mov    0x18(%rsp),%rsi
   153df:	call   29cd0 <_Z20inline_single_kernelILb0EN13bloom_filters21FourSectorBloomFilterEmEvRKT0_mPKmPj>
   153e4:	jmp    15770 <_Z3RunIN13bloom_filters21FourSectorBloomFilterEEvRK5PointRK4CaseRK5Input+0x1d40>
   153e9:	mov    (%rsp),%rax
   153ed:	mov    0x18(%rax),%rdx
   153f1:	mov    0x30(%rsp),%rcx
   153f6:	add    $0x40,%rcx
   153fa:	mov    %r15,%rdi
   153fd:	mov    0x18(%rsp),%rsi
   15402:	call   29de0 <_Z20inline_single_kernelILb1EN13bloom_filters21FourSectorBloomFilterEmEvRKT0_mPKmPj>
   15407:	jmp    15770 <_Z3RunIN13bloom_filters21FourSectorBloomFilterEEvRK5PointRK4CaseRK5Input+0x1d40>
   1540c:	mov    0x20(%rsp),%rax
   15411:	cmp    %rax,0x28(%rsp)
   15416:	mov    0x18(%rsp),%rsi
   1541b:	je     15770 <_Z3RunIN13bloom_filters21FourSectorBloomFilterEEvRK5PointRK4CaseRK5Input+0x1d40>
   15421:	mov    0x10(%rsp),%rax
   15426:	mov    0xc(%rax),%eax
   15429:	xor    %ebp,%ebp
   1542b:	nopl   0x0(%rax,%rax,1)
   15430:	mov    %eax,%eax
   15432:	sub    %rbp,%rsi
   15435:	cmp    %rax,%rsi
   15438:	cmovae %rax,%rsi
   1543c:	test   %rsi,%rsi
   1543f:	je     1559b <_Z3RunIN13bloom_filters21FourSectorBloomFilterEEvRK5PointRK4CaseRK5Input+0x1b6b>
   15445:	mov    (%rsp),%rax
   15449:	mov    0x18(%rax),%rax
   1544d:	lea    (%rax,%rbp,8),%rcx
   15451:	cmp    $0x4,%rsi
   15455:	jb     1546a <_Z3RunIN13bloom_filters21FourSectorBloomFilterEEvRK5PointRK4CaseRK5Input+0x1a3a>
   15457:	mov    %r14,%rdx
   1545a:	sub    %rcx,%rdx
   1545d:	cmp    $0x80,%rdx
   15464:	jae    155d1 <_Z3RunIN13bloom_filters21FourSectorBloomFilterEEvRK5PointRK4CaseRK5Input+0x1ba1>
   1546a:	xor    %edx,%edx
   1546c:	mov    %rsi,%r8
   1546f:	mov    %rdx,%rdi
   15472:	and    $0x3,%r8
   15476:	je     154b6 <_Z3RunIN13bloom_filters21FourSectorBloomFilterEEvRK5PointRK4CaseRK5Input+0x1a86>
   15478:	mov    %rdx,%rdi
   1547b:	nopl   0x0(%rax,%rax,1)
   15480:	mov    (%rcx,%rdi,8),%r9
   15484:	mov    %r9,%r10
   15487:	shr    $0x20,%r10
   1548b:	xor    %r9,%r10
   1548e:	imul   %r12,%r10
   15492:	mov    %r10,%r9
   15495:	shr    $0x20,%r9
   15499:	xor    %r10,%r9
   1549c:	imul   %r12,%r9
   154a0:	mov    %r9,%r10
   154a3:	shr    $0x20,%r10
   154a7:	xor    %r9,%r10
   154aa:	mov    %r10,(%r14,%rdi,8)
   154ae:	inc    %rdi
   154b1:	dec    %r8
   154b4:	jne    15480 <_Z3RunIN13bloom_filters21FourSectorBloomFilterEEvRK5PointRK4CaseRK5Input+0x1a50>
   154b6:	sub    %rsi,%rdx
   154b9:	cmp    $0xfffffffffffffffc,%rdx
   154bd:	ja     1559b <_Z3RunIN13bloom_filters21FourSectorBloomFilterEEvRK5PointRK4CaseRK5Input+0x1b6b>
   154c3:	lea    0x18(%rax,%rbp,8),%rax
   154c8:	nopl   0x0(%rax,%rax,1)
   154d0:	mov    -0x18(%rax,%rdi,8),%rcx
   154d5:	mov    %rcx,%rdx
   154d8:	shr    $0x20,%rdx
   154dc:	xor    %rcx,%rdx
   154df:	imul   %r12,%rdx
   154e3:	mov    %rdx,%rcx
   154e6:	shr    $0x20,%rcx
   154ea:	xor    %rdx,%rcx
   154ed:	imul   %r12,%rcx
   154f1:	mov    %rcx,%rdx
   154f4:	shr    $0x20,%rdx
   154f8:	xor    %rcx,%rdx
   154fb:	mov    %rdx,(%r14,%rdi,8)
   154ff:	mov    -0x10(%rax,%rdi,8),%rcx
   15504:	mov    %rcx,%rdx
   15507:	shr    $0x20,%rdx
   1550b:	xor    %rcx,%rdx
   1550e:	imul   %r12,%rdx
   15512:	mov    %rdx,%rcx
   15515:	shr    $0x20,%rcx
   15519:	xor    %rdx,%rcx
   1551c:	imul   %r12,%rcx
   15520:	mov    %rcx,%rdx
   15523:	shr    $0x20,%rdx
   15527:	xor    %rcx,%rdx
   1552a:	mov    %rdx,0x8(%r14,%rdi,8)
   1552f:	mov    -0x8(%rax,%rdi,8),%rcx
   15534:	mov    %rcx,%rdx
   15537:	shr    $0x20,%rdx
   1553b:	xor    %rcx,%rdx
   1553e:	imul   %r12,%rdx
   15542:	mov    %rdx,%rcx
   15545:	shr    $0x20,%rcx
   15549:	xor    %rdx,%rcx
   1554c:	imul   %r12,%rcx
   15550:	mov    %rcx,%rdx
   15553:	shr    $0x20,%rdx
   15557:	xor    %rcx,%rdx
   1555a:	mov    %rdx,0x10(%r14,%rdi,8)
   1555f:	mov    (%rax,%rdi,8),%rcx
   15563:	mov    %rcx,%rdx
   15566:	shr    $0x20,%rdx
   1556a:	xor    %rcx,%rdx
   1556d:	imul   %r12,%rdx
   15571:	mov    %rdx,%rcx
   15574:	shr    $0x20,%rcx
   15578:	xor    %rdx,%rcx
   1557b:	imul   %r12,%rcx
   1557f:	mov    %rcx,%rdx
   15582:	shr    $0x20,%rdx
   15586:	xor    %rcx,%rdx
   15589:	mov    %rdx,0x18(%r14,%rdi,8)
   1558e:	add    $0x4,%rdi
   15592:	cmp    %rdi,%rsi
   15595:	jne    154d0 <_Z3RunIN13bloom_filters21FourSectorBloomFilterEEvRK5PointRK4CaseRK5Input+0x1aa0>
   1559b:	mov    0x30(%rsp),%rax
   155a0:	lea    0x40(%rax,%rbp,4),%rcx
   155a5:	mov    %r15,%rdi
   155a8:	mov    %r14,%rdx
   155ab:	vzeroupper
   155ae:	call   29bb0 <_Z13lookup_kernelIN13bloom_filters21FourSectorBloomFilterEmEvRT_mPKT0_Pj>
   155b3:	mov    0x10(%rsp),%rax
   155b8:	mov    0xc(%rax),%eax
   155bb:	add    %rax,%rbp
   155be:	mov    0x18(%rsp),%rsi
   155c3:	cmp    %rsi,%rbp
   155c6:	jb     15430 <_Z3RunIN13bloom_filters21FourSectorBloomFilterEEvRK5PointRK4CaseRK5Input+0x1a00>
   155cc:	jmp    15770 <_Z3RunIN13bloom_filters21FourSectorBloomFilterEEvRK5PointRK4CaseRK5Input+0x1d40>
   155d1:	cmp    $0x10,%rsi
   155d5:	jae    155de <_Z3RunIN13bloom_filters21FourSectorBloomFilterEEvRK5PointRK4CaseRK5Input+0x1bae>
   155d7:	xor    %edx,%edx
   155d9:	jmp    15702 <_Z3RunIN13bloom_filters21FourSectorBloomFilterEEvRK5PointRK4CaseRK5Input+0x1cd2>
   155de:	lea    0x0(,%rbp,8),%r8
   155e6:	mov    %esi,%edx
   155e8:	and    $0xfffffff0,%edx
   155eb:	lea    0x0(,%rsi,8),%rdi
   155f3:	and    $0xffffffffffffff80,%rdi
   155f7:	lea    0x60(%rax,%r8,1),%r8
   155fc:	xor    %r9d,%r9d
   155ff:	vpbroadcastq -0x13c38(%rip),%ymm8        # 19d0 <_IO_stdin_used+0x2f0>
   15608:	nopl   0x0(%rax,%rax,1)
   15610:	vmovdqu -0x60(%r8,%r9,1),%ymm0
   15617:	vmovdqu -0x40(%r8,%r9,1),%ymm1
   1561e:	vmovdqu -0x20(%r8,%r9,1),%ymm2
   15625:	vmovdqu (%r8,%r9,1),%ymm3
   1562b:	vpsrlq $0x20,%ymm0,%ymm4
   15630:	vpsrlq $0x20,%ymm1,%ymm5
   15635:	vpsrlq $0x20,%ymm2,%ymm6
   1563a:	vpsrlq $0x20,%ymm3,%ymm7
   1563f:	vpxor  %ymm0,%ymm4,%ymm0
   15643:	vpxor  %ymm1,%ymm5,%ymm1
   15647:	vpxor  %ymm2,%ymm6,%ymm2
   1564b:	vpmullq %ymm8,%ymm0,%ymm0
   15651:	vpmullq %ymm8,%ymm1,%ymm1
   15657:	vpmullq %ymm8,%ymm2,%ymm2
   1565d:	vpxor  %ymm3,%ymm7,%ymm3
   15661:	vpmullq %ymm8,%ymm3,%ymm3
   15667:	vpsrlq $0x20,%ymm0,%ymm4
   1566c:	vpsrlq $0x20,%ymm1,%ymm5
   15671:	vpsrlq $0x20,%ymm2,%ymm6
   15676:	vpsrlq $0x20,%ymm3,%ymm7
   1567b:	vpxor  %ymm0,%ymm4,%ymm0
   1567f:	vpxor  %ymm1,%ymm5,%ymm1
   15683:	vpxor  %ymm2,%ymm6,%ymm2
   15687:	vpxor  %ymm3,%ymm7,%ymm3
   1568b:	vpmullq %ymm8,%ymm0,%ymm0
   15691:	vpmullq %ymm8,%ymm1,%ymm1
   15697:	vpmullq %ymm8,%ymm2,%ymm2
   1569d:	vpmullq %ymm8,%ymm3,%ymm3
   156a3:	vpsrlq $0x20,%ymm0,%ymm4
   156a8:	vpsrlq $0x20,%ymm1,%ymm5
   156ad:	vpsrlq $0x20,%ymm2,%ymm6
   156b2:	vpsrlq $0x20,%ymm3,%ymm7
   156b7:	vpxor  %ymm0,%ymm4,%ymm0
   156bb:	vpxor  %ymm1,%ymm5,%ymm1
   156bf:	vpxor  %ymm2,%ymm6,%ymm2
   156c3:	vpxor  %ymm3,%ymm7,%ymm3
   156c7:	vmovdqu %ymm0,(%r14,%r9,1)
   156cd:	vmovdqu %ymm1,0x20(%r14,%r9,1)
   156d4:	vmovdqu %ymm2,0x40(%r14,%r9,1)
   156db:	vmovdqu %ymm3,0x60(%r14,%r9,1)
   156e2:	sub    $0xffffffffffffff80,%r9
   156e6:	cmp    %r9,%rdi
   156e9:	jne    15610 <_Z3RunIN13bloom_filters21FourSectorBloomFilterEEvRK5PointRK4CaseRK5Input+0x1be0>
   156ef:	cmp    %rdx,%rsi
   156f2:	je     1559b <_Z3RunIN13bloom_filters21FourSectorBloomFilterEEvRK5PointRK4CaseRK5Input+0x1b6b>
   156f8:	test   $0xc,%sil
   156fc:	je     1546c <_Z3RunIN13bloom_filters21FourSectorBloomFilterEEvRK5PointRK4CaseRK5Input+0x1a3c>
   15702:	mov    %rdx,%rdi
   15705:	mov    %esi,%edx
   15707:	and    $0xfffffffc,%edx
   1570a:	vpbroadcastq -0x13d43(%rip),%ymm2        # 19d0 <_IO_stdin_used+0x2f0>
   15713:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   15720:	vmovdqu (%rcx,%rdi,8),%ymm0
   15725:	vpsrlq $0x20,%ymm0,%ymm1
   1572a:	vpxor  %ymm0,%ymm1,%ymm0
   1572e:	vpmullq %ymm2,%ymm0,%ymm0
   15734:	vpsrlq $0x20,%ymm0,%ymm1
   15739:	vpxor  %ymm0,%ymm1,%ymm0
   1573d:	vpmullq %ymm2,%ymm0,%ymm0
   15743:	vpsrlq $0x20,%ymm0,%ymm1
   15748:	vpxor  %ymm0,%ymm1,%ymm0
   1574c:	vmovdqu %ymm0,(%r14,%rdi,8)
   15752:	add    $0x4,%rdi
   15756:	cmp    %rdi,%rdx
   15759:	jne    15720 <_Z3RunIN13bloom_filters21FourSectorBloomFilterEEvRK5PointRK4CaseRK5Input+0x1cf0>
   1575b:	cmp    %rdx,%rsi
   1575e:	je     1559b <_Z3RunIN13bloom_filters21FourSectorBloomFilterEEvRK5PointRK4CaseRK5Input+0x1b6b>
   15764:	jmp    1546c <_Z3RunIN13bloom_filters21FourSectorBloomFilterEEvRK5PointRK4CaseRK5Input+0x1a3c>
   15769:	nopl   0x0(%rax)
   15770:	call   2eab0 <_ZNSt6chrono3_V212steady_clock3nowEv@plt>
   15775:	sub    0x58(%rsp),%rax
   1577a:	vcvtsi2sd %rax,%xmm15,%xmm0
   1577f:	vdivsd 0x140(%rsp),%xmm0,%xmm0
   15788:	vmovq  %xmm0,%rax
   1578d:	mov    $0x3f,%cl
   1578f:	bzhi   %rcx,%rax,%rcx
   15794:	movabs $0xfff0000000000000,%rdx
   1579e:	add    %rdx,%rcx
   157a1:	shr    $0x35,%rcx
   157a5:	cmp    $0x3ff,%ecx
   157ab:	setb   %cl
   157ae:	test   %rax,%rax
   157b1:	setns  %dl
   157b4:	and    %cl,%dl
   157b6:	dec    %rax
   157b9:	movabs $0xfffffffffffff,%rcx
   157c3:	cmp    %rcx,%rax
   157c6:	setb   %al
   157c9:	or     %dl,%al
   157cb:	je     165e2 <_Z3RunIN13bloom_filters21FourSectorBloomFilterEEvRK5PointRK4CaseRK5Input+0x2bb2>
   157d1:	lea    0x0(%r13,%r13,2),%rax
   157d6:	lea    0x150(%rsp,%rax,8),%rcx
   157de:	mov    0x158(%rsp,%rax,8),%r13
   157e6:	cmp    0x160(%rsp,%rax,8),%r13
   157ee:	je     15810 <_Z3RunIN13bloom_filters21FourSectorBloomFilterEEvRK5PointRK4CaseRK5Input+0x1de0>
   157f0:	vmovsd %xmm0,0x0(%r13)
   157f6:	add    $0x8,%r13
   157fa:	mov    %r13,0x8(%rcx)
   157fe:	jmp    158c2 <_Z3RunIN13bloom_filters21FourSectorBloomFilterEEvRK5PointRK4CaseRK5Input+0x1e92>
   15803:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   15810:	mov    (%rcx),%rbx
   15813:	sub    %rbx,%r13
   15816:	movabs $0x7ffffffffffffff8,%rax
   15820:	cmp    %rax,%r13
   15823:	je     16628 <_Z3RunIN13bloom_filters21FourSectorBloomFilterEEvRK5PointRK4CaseRK5Input+0x2bf8>
   15829:	mov    %rcx,0x130(%rsp)
   15831:	vmovsd %xmm0,0x58(%rsp)
   15837:	mov    %r13,%rax
   1583a:	sar    $0x3,%rax
   1583e:	cmp    $0x1,%rax
   15842:	mov    %rax,%rcx
   15845:	adc    $0x0,%rcx
   15849:	lea    (%rcx,%rax,1),%rbp
   1584d:	movabs $0xfffffffffffffff,%rdx
   15857:	cmp    %rdx,%rbp
   1585a:	cmovae %rdx,%rbp
   1585e:	add    %rax,%rcx
   15861:	cmovb  %rdx,%rbp
   15865:	lea    0x0(,%rbp,8),%rdi
   1586d:	call   2ea50 <_Znwm@plt>
   15872:	mov    %rax,%r15
   15875:	vmovsd 0x58(%rsp),%xmm0
   1587b:	vmovsd %xmm0,(%rax,%r13,1)
   15881:	test   %r13,%r13
   15884:	jle    15894 <_Z3RunIN13bloom_filters21FourSectorBloomFilterEEvRK5PointRK4CaseRK5Input+0x1e64>
   15886:	mov    %r15,%rdi
   15889:	mov    %rbx,%rsi
   1588c:	mov    %r13,%rdx
   1588f:	call   2ea70 <memmove@plt>
   15894:	test   %rbx,%rbx
   15897:	je     158a4 <_Z3RunIN13bloom_filters21FourSectorBloomFilterEEvRK5PointRK4CaseRK5Input+0x1e74>
   15899:	mov    %rbx,%rdi
   1589c:	mov    %r13,%rsi
   1589f:	call   2ea60 <_ZdlPvm@plt>
   158a4:	add    %r15,%r13
   158a7:	mov    0x130(%rsp),%rcx
   158af:	mov    %r15,(%rcx)
   158b2:	add    $0x8,%r13
   158b6:	mov    %r13,0x8(%rcx)
   158ba:	lea    (%r15,%rbp,8),%rax
   158be:	mov    %rax,0x10(%rcx)
   158c2:	lea    0x30(%rsp),%rdi
   158c7:	lea    0x80(%rsp),%rsi
   158cf:	call   26830 <_ZN6Output5CheckERKSt6vectorIjSaIjEE>
   158d4:	mov    0x78(%rsp),%r15
   158d9:	add    $0x4,%r15
   158dd:	mov    0xe8(%rsp),%r10
