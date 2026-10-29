   11289:	call   16dd0 <std::chrono::_V2::steady_clock::now()@plt>
   1128e:	mov    %rax,0x40(%rsp)
   11293:	mov    0x18(%rsp),%rsi
   11298:	lea    0x220(%rsp),%rdi
   112a0:	mov    %ebp,%edx
   112a2:	call   14120 <bloom_filters::K12LineOrCandidate make_filter<bloom_filters::K12LineOrCandidate>(unsigned long, unsigned int)>
   112a7:	call   16dd0 <std::chrono::_V2::steady_clock::now()@plt>
   112ac:	mov    %rax,0x78(%rsp)
   112b1:	mov    0x18(%rsp),%rax
   112b6:	test   %rax,%rax
   112b9:	mov    0x3a8(%rsp),%rcx
   112c1:	je     116b0 <void run<bloom_filters::K12LineOrCandidate, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0x10b0>
   112c7:	mov    $0x60,%r12d
   112cd:	mov    $0x10,%edx
   112d2:	mov    %rdx,0x10(%rsp)
   112d7:	xor    %ebp,%ebp
   112d9:	xor    %r15d,%r15d
   112dc:	xor    %r13d,%r13d
   112df:	xor    %r14d,%r14d
   112e2:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   112f0:	mov    %rax,%rsi
   112f3:	sub    %r14,%rsi
   112f6:	cmp    %rcx,%rsi
   112f9:	cmovae %rcx,%rsi
   112fd:	mov    0x180(%rsp),%rdx
   11305:	test   %rsi,%rsi
   11308:	je     114b3 <void run<bloom_filters::K12LineOrCandidate, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xeb3>
   1130e:	mov    0x20(%rsp),%rcx
   11313:	mov    (%rcx),%rcx
   11316:	cmp    $0x4,%rsi
   1131a:	jb     11338 <void run<bloom_filters::K12LineOrCandidate, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xd38>
   1131c:	mov    0x30(%rsp),%rdi
   11321:	imul   %r13,%rdi
   11325:	add    %rdx,%rdi
   11328:	sub    %rcx,%rdi
   1132b:	cmp    $0x80,%rdi
   11332:	jae    114f7 <void run<bloom_filters::K12LineOrCandidate, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xef7>
   11338:	xor    %edi,%edi
   1133a:	mov    %r12,0x68(%rsp)
   1133f:	mov    %rdi,%r8
   11342:	test   $0x3,%sil
   11346:	je     113a6 <void run<bloom_filters::K12LineOrCandidate, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xda6>
   11348:	lea    (%rcx,%rbp,1),%r9
   1134c:	lea    (%rax,%r15,1),%r10
   11350:	mov    0x3a8(%rsp),%r8
   11358:	cmp    %r10,%r8
   1135b:	cmovb  %r8,%r10
   1135f:	and    $0x3,%r10d
   11363:	mov    %rdi,%r8
   11366:	cs nopw 0x0(%rax,%rax,1)
   11370:	mov    (%r9,%r8,8),%r12
   11374:	mov    %r12,%r11
   11377:	shr    $0x20,%r11
   1137b:	xor    %r12,%r11
   1137e:	imul   %rbx,%r11
   11382:	mov    %r11,%r12
   11385:	shr    $0x20,%r12
   11389:	xor    %r11,%r12
   1138c:	imul   %rbx,%r12
   11390:	mov    %r12,%r11
   11393:	shr    $0x20,%r11
   11397:	xor    %r12,%r11
   1139a:	mov    %r11,(%rdx,%r8,8)
   1139e:	inc    %r8
   113a1:	dec    %r10
   113a4:	jne    11370 <void run<bloom_filters::K12LineOrCandidate, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xd70>
   113a6:	sub    %rsi,%rdi
   113a9:	cmp    $0xfffffffffffffffc,%rdi
   113ad:	mov    0x68(%rsp),%r12
   113b2:	ja     114ab <void run<bloom_filters::K12LineOrCandidate, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xeab>
   113b8:	add    %r15,%rax
   113bb:	mov    0x3a8(%rsp),%rdi
   113c3:	cmp    %rax,%rdi
   113c6:	cmovb  %rdi,%rax
   113ca:	sub    %r8,%rax
   113cd:	lea    0x18(%rdx,%r8,8),%rdx
   113d2:	mov    0x10(%rsp),%rdi
   113d7:	lea    (%rdi,%r8,8),%rdi
   113db:	add    %rdi,%rcx
   113de:	xor    %edi,%edi
   113e0:	mov    -0x10(%rcx,%rdi,8),%r8
   113e5:	mov    %r8,%r9
   113e8:	shr    $0x20,%r9
   113ec:	xor    %r8,%r9
   113ef:	imul   %rbx,%r9
   113f3:	mov    %r9,%r8
   113f6:	shr    $0x20,%r8
   113fa:	xor    %r9,%r8
   113fd:	imul   %rbx,%r8
   11401:	mov    %r8,%r9
   11404:	shr    $0x20,%r9
   11408:	xor    %r8,%r9
   1140b:	mov    %r9,-0x18(%rdx,%rdi,8)
   11410:	mov    -0x8(%rcx,%rdi,8),%r8
   11415:	mov    %r8,%r9
   11418:	shr    $0x20,%r9
   1141c:	xor    %r8,%r9
   1141f:	imul   %rbx,%r9
   11423:	mov    %r9,%r8
   11426:	shr    $0x20,%r8
   1142a:	xor    %r9,%r8
   1142d:	imul   %rbx,%r8
   11431:	mov    %r8,%r9
   11434:	shr    $0x20,%r9
   11438:	xor    %r8,%r9
   1143b:	mov    %r9,-0x10(%rdx,%rdi,8)
   11440:	mov    (%rcx,%rdi,8),%r8
   11444:	mov    %r8,%r9
   11447:	shr    $0x20,%r9
   1144b:	xor    %r8,%r9
   1144e:	imul   %rbx,%r9
   11452:	mov    %r9,%r8
   11455:	shr    $0x20,%r8
   11459:	xor    %r9,%r8
   1145c:	imul   %rbx,%r8
   11460:	mov    %r8,%r9
   11463:	shr    $0x20,%r9
   11467:	xor    %r8,%r9
   1146a:	mov    %r9,-0x8(%rdx,%rdi,8)
   1146f:	mov    0x8(%rcx,%rdi,8),%r8
   11474:	mov    %r8,%r9
   11477:	shr    $0x20,%r9
   1147b:	xor    %r8,%r9
   1147e:	imul   %rbx,%r9
   11482:	mov    %r9,%r8
   11485:	shr    $0x20,%r8
   11489:	xor    %r9,%r8
   1148c:	imul   %rbx,%r8
   11490:	mov    %r8,%r9
   11493:	shr    $0x20,%r9
   11497:	xor    %r8,%r9
   1149a:	mov    %r9,(%rdx,%rdi,8)
   1149e:	add    $0x4,%rdi
   114a2:	cmp    %rdi,%rax
   114a5:	jne    113e0 <void run<bloom_filters::K12LineOrCandidate, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xde0>
   114ab:	mov    0x180(%rsp),%rdx
   114b3:	lea    0x220(%rsp),%rdi
   114bb:	vzeroupper
   114be:	call   14260 <void insert<bloom_filters::K12LineOrCandidate, unsigned long>(bloom_filters::K12LineOrCandidate&, unsigned long, unsigned long const*)>
   114c3:	mov    0x3a8(%rsp),%rcx
   114cb:	add    %rcx,%r14
   114ce:	mov    0x18(%rsp),%rax
   114d3:	inc    %r13
   114d6:	sub    %rcx,%r15
   114d9:	mov    0x48(%rsp),%rdx
   114de:	add    %rdx,%r12
   114e1:	add    %rdx,%rbp
   114e4:	add    %rdx,0x10(%rsp)
   114e9:	cmp    %rax,%r14
   114ec:	jb     112f0 <void run<bloom_filters::K12LineOrCandidate, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xcf0>
   114f2:	jmp    116b0 <void run<bloom_filters::K12LineOrCandidate, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0x10b0>
   114f7:	cmp    $0x10,%rsi
   114fb:	jae    11504 <void run<bloom_filters::K12LineOrCandidate, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xf04>
   114fd:	xor    %edi,%edi
   114ff:	jmp    11632 <void run<bloom_filters::K12LineOrCandidate, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0x1032>
   11504:	mov    %rsi,%rdi
   11507:	and    $0xfffffffffffffff0,%rdi
   1150b:	lea    (%rax,%r15,1),%r8
   1150f:	mov    0x3a8(%rsp),%r9
   11517:	cmp    %r8,%r9
   1151a:	cmovb  %r9,%r8
   1151e:	and    $0xfffffffffffffff0,%r8
   11522:	lea    (%rcx,%r12,1),%r9
   11526:	xor    %r10d,%r10d
   11529:	vpbroadcastq -0xf3c2(%rip),%ymm8        # 2170 <_IO_stdin_used+0xd4>
   11532:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   11540:	vmovdqu -0x60(%r9,%r10,8),%ymm0
   11547:	vmovdqu -0x40(%r9,%r10,8),%ymm1
   1154e:	vmovdqu -0x20(%r9,%r10,8),%ymm2
   11555:	vmovdqu (%r9,%r10,8),%ymm3
   1155b:	vpsrlq $0x20,%ymm0,%ymm4
   11560:	vpsrlq $0x20,%ymm1,%ymm5
   11565:	vpsrlq $0x20,%ymm2,%ymm6
   1156a:	vpsrlq $0x20,%ymm3,%ymm7
   1156f:	vpxor  %ymm0,%ymm4,%ymm0
   11573:	vpxor  %ymm1,%ymm5,%ymm1
   11577:	vpxor  %ymm2,%ymm6,%ymm2
   1157b:	vpmullq %ymm8,%ymm0,%ymm0
   11581:	vpmullq %ymm8,%ymm1,%ymm1
   11587:	vpmullq %ymm8,%ymm2,%ymm2
   1158d:	vpxor  %ymm3,%ymm7,%ymm3
   11591:	vpmullq %ymm8,%ymm3,%ymm3
   11597:	vpsrlq $0x20,%ymm0,%ymm4
   1159c:	vpsrlq $0x20,%ymm1,%ymm5
   115a1:	vpsrlq $0x20,%ymm2,%ymm6
   115a6:	vpsrlq $0x20,%ymm3,%ymm7
   115ab:	vpxor  %ymm0,%ymm4,%ymm0
   115af:	vpxor  %ymm1,%ymm5,%ymm1
   115b3:	vpxor  %ymm2,%ymm6,%ymm2
   115b7:	vpxor  %ymm3,%ymm7,%ymm3
   115bb:	vpmullq %ymm8,%ymm0,%ymm0
   115c1:	vpmullq %ymm8,%ymm1,%ymm1
   115c7:	vpmullq %ymm8,%ymm2,%ymm2
   115cd:	vpmullq %ymm8,%ymm3,%ymm3
   115d3:	vpsrlq $0x20,%ymm0,%ymm4
   115d8:	vpsrlq $0x20,%ymm1,%ymm5
   115dd:	vpsrlq $0x20,%ymm2,%ymm6
   115e2:	vpsrlq $0x20,%ymm3,%ymm7
   115e7:	vpxor  %ymm0,%ymm4,%ymm0
   115eb:	vpxor  %ymm1,%ymm5,%ymm1
   115ef:	vpxor  %ymm2,%ymm6,%ymm2
   115f3:	vpxor  %ymm3,%ymm7,%ymm3
   115f7:	vmovdqu %ymm0,(%rdx,%r10,8)
   115fd:	vmovdqu %ymm1,0x20(%rdx,%r10,8)
   11604:	vmovdqu %ymm2,0x40(%rdx,%r10,8)
   1160b:	vmovdqu %ymm3,0x60(%rdx,%r10,8)
   11612:	add    $0x10,%r10
   11616:	cmp    %r10,%r8
   11619:	jne    11540 <void run<bloom_filters::K12LineOrCandidate, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xf40>
   1161f:	cmp    %rdi,%rsi
   11622:	je     114ab <void run<bloom_filters::K12LineOrCandidate, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xeab>
   11628:	test   $0xc,%sil
   1162c:	je     1133a <void run<bloom_filters::K12LineOrCandidate, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xd3a>
   11632:	mov    %rdi,%r8
   11635:	mov    %rsi,%rdi
   11638:	and    $0xfffffffffffffffc,%rdi
   1163c:	lea    (%rax,%r15,1),%r9
   11640:	mov    0x3a8(%rsp),%r10
   11648:	cmp    %r9,%r10
   1164b:	cmovb  %r10,%r9
   1164f:	and    $0xfffffffffffffffc,%r9
   11653:	lea    (%rcx,%rbp,1),%r10
   11657:	vpbroadcastq -0xf4f0(%rip),%ymm2        # 2170 <_IO_stdin_used+0xd4>
   11660:	vmovdqu (%r10,%r8,8),%ymm0
   11666:	vpsrlq $0x20,%ymm0,%ymm1
   1166b:	vpxor  %ymm0,%ymm1,%ymm0
   1166f:	vpmullq %ymm2,%ymm0,%ymm0
   11675:	vpsrlq $0x20,%ymm0,%ymm1
   1167a:	vpxor  %ymm0,%ymm1,%ymm0
   1167e:	vpmullq %ymm2,%ymm0,%ymm0
   11684:	vpsrlq $0x20,%ymm0,%ymm1
   11689:	vpxor  %ymm0,%ymm1,%ymm0
   1168d:	vmovdqu %ymm0,(%rdx,%r8,8)
   11693:	add    $0x4,%r8
   11697:	cmp    %r8,%r9
   1169a:	jne    11660 <void run<bloom_filters::K12LineOrCandidate, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0x1060>
   1169c:	cmp    %rdi,%rsi
   1169f:	je     114ab <void run<bloom_filters::K12LineOrCandidate, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xeab>
   116a5:	jmp    1133a <void run<bloom_filters::K12LineOrCandidate, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xd3a>
   116aa:	nopw   0x0(%rax,%rax,1)
   116b0:	call   16dd0 <std::chrono::_V2::steady_clock::now()@plt>
