   11589:	call   170d0 <std::chrono::_V2::steady_clock::now()@plt>
   1158e:	mov    %rax,0x40(%rsp)
   11593:	mov    0x18(%rsp),%rsi
   11598:	lea    0x220(%rsp),%rdi
   115a0:	mov    %ebp,%edx
   115a2:	call   14420 <bloom_filters::K12LineOrCandidate make_filter<bloom_filters::K12LineOrCandidate>(unsigned long, unsigned int)>
   115a7:	call   170d0 <std::chrono::_V2::steady_clock::now()@plt>
   115ac:	mov    %rax,0x78(%rsp)
   115b1:	mov    0x18(%rsp),%rax
   115b6:	test   %rax,%rax
   115b9:	mov    0x3a8(%rsp),%rcx
   115c1:	je     119b0 <void run<bloom_filters::K12LineOrCandidate, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0x10b0>
   115c7:	mov    $0x60,%r12d
   115cd:	mov    $0x10,%edx
   115d2:	mov    %rdx,0x10(%rsp)
   115d7:	xor    %ebp,%ebp
   115d9:	xor    %r15d,%r15d
   115dc:	xor    %r13d,%r13d
   115df:	xor    %r14d,%r14d
   115e2:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   115f0:	mov    %rax,%rsi
   115f3:	sub    %r14,%rsi
   115f6:	cmp    %rcx,%rsi
   115f9:	cmovae %rcx,%rsi
   115fd:	mov    0x180(%rsp),%rdx
   11605:	test   %rsi,%rsi
   11608:	je     117b3 <void run<bloom_filters::K12LineOrCandidate, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xeb3>
   1160e:	mov    0x20(%rsp),%rcx
   11613:	mov    (%rcx),%rcx
   11616:	cmp    $0x4,%rsi
   1161a:	jb     11638 <void run<bloom_filters::K12LineOrCandidate, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xd38>
   1161c:	mov    0x30(%rsp),%rdi
   11621:	imul   %r13,%rdi
   11625:	add    %rdx,%rdi
   11628:	sub    %rcx,%rdi
   1162b:	cmp    $0x80,%rdi
   11632:	jae    117f7 <void run<bloom_filters::K12LineOrCandidate, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xef7>
   11638:	xor    %edi,%edi
   1163a:	mov    %r12,0x68(%rsp)
   1163f:	mov    %rdi,%r8
   11642:	test   $0x3,%sil
   11646:	je     116a6 <void run<bloom_filters::K12LineOrCandidate, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xda6>
   11648:	lea    (%rcx,%rbp,1),%r9
   1164c:	lea    (%rax,%r15,1),%r10
   11650:	mov    0x3a8(%rsp),%r8
   11658:	cmp    %r10,%r8
   1165b:	cmovb  %r8,%r10
   1165f:	and    $0x3,%r10d
   11663:	mov    %rdi,%r8
   11666:	cs nopw 0x0(%rax,%rax,1)
   11670:	mov    (%r9,%r8,8),%r12
   11674:	mov    %r12,%r11
   11677:	shr    $0x20,%r11
   1167b:	xor    %r12,%r11
   1167e:	imul   %rbx,%r11
   11682:	mov    %r11,%r12
   11685:	shr    $0x20,%r12
   11689:	xor    %r11,%r12
   1168c:	imul   %rbx,%r12
   11690:	mov    %r12,%r11
   11693:	shr    $0x20,%r11
   11697:	xor    %r12,%r11
   1169a:	mov    %r11,(%rdx,%r8,8)
   1169e:	inc    %r8
   116a1:	dec    %r10
   116a4:	jne    11670 <void run<bloom_filters::K12LineOrCandidate, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xd70>
   116a6:	sub    %rsi,%rdi
   116a9:	cmp    $0xfffffffffffffffc,%rdi
   116ad:	mov    0x68(%rsp),%r12
   116b2:	ja     117ab <void run<bloom_filters::K12LineOrCandidate, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xeab>
   116b8:	add    %r15,%rax
   116bb:	mov    0x3a8(%rsp),%rdi
   116c3:	cmp    %rax,%rdi
   116c6:	cmovb  %rdi,%rax
   116ca:	sub    %r8,%rax
   116cd:	lea    0x18(%rdx,%r8,8),%rdx
   116d2:	mov    0x10(%rsp),%rdi
   116d7:	lea    (%rdi,%r8,8),%rdi
   116db:	add    %rdi,%rcx
   116de:	xor    %edi,%edi
   116e0:	mov    -0x10(%rcx,%rdi,8),%r8
   116e5:	mov    %r8,%r9
   116e8:	shr    $0x20,%r9
   116ec:	xor    %r8,%r9
   116ef:	imul   %rbx,%r9
   116f3:	mov    %r9,%r8
   116f6:	shr    $0x20,%r8
   116fa:	xor    %r9,%r8
   116fd:	imul   %rbx,%r8
   11701:	mov    %r8,%r9
   11704:	shr    $0x20,%r9
   11708:	xor    %r8,%r9
   1170b:	mov    %r9,-0x18(%rdx,%rdi,8)
   11710:	mov    -0x8(%rcx,%rdi,8),%r8
   11715:	mov    %r8,%r9
   11718:	shr    $0x20,%r9
   1171c:	xor    %r8,%r9
   1171f:	imul   %rbx,%r9
   11723:	mov    %r9,%r8
   11726:	shr    $0x20,%r8
   1172a:	xor    %r9,%r8
   1172d:	imul   %rbx,%r8
   11731:	mov    %r8,%r9
   11734:	shr    $0x20,%r9
   11738:	xor    %r8,%r9
   1173b:	mov    %r9,-0x10(%rdx,%rdi,8)
   11740:	mov    (%rcx,%rdi,8),%r8
   11744:	mov    %r8,%r9
   11747:	shr    $0x20,%r9
   1174b:	xor    %r8,%r9
   1174e:	imul   %rbx,%r9
   11752:	mov    %r9,%r8
   11755:	shr    $0x20,%r8
   11759:	xor    %r9,%r8
   1175c:	imul   %rbx,%r8
   11760:	mov    %r8,%r9
   11763:	shr    $0x20,%r9
   11767:	xor    %r8,%r9
   1176a:	mov    %r9,-0x8(%rdx,%rdi,8)
   1176f:	mov    0x8(%rcx,%rdi,8),%r8
   11774:	mov    %r8,%r9
   11777:	shr    $0x20,%r9
   1177b:	xor    %r8,%r9
   1177e:	imul   %rbx,%r9
   11782:	mov    %r9,%r8
   11785:	shr    $0x20,%r8
   11789:	xor    %r9,%r8
   1178c:	imul   %rbx,%r8
   11790:	mov    %r8,%r9
   11793:	shr    $0x20,%r9
   11797:	xor    %r8,%r9
   1179a:	mov    %r9,(%rdx,%rdi,8)
   1179e:	add    $0x4,%rdi
   117a2:	cmp    %rdi,%rax
   117a5:	jne    116e0 <void run<bloom_filters::K12LineOrCandidate, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xde0>
   117ab:	mov    0x180(%rsp),%rdx
   117b3:	lea    0x220(%rsp),%rdi
   117bb:	vzeroupper
   117be:	call   14560 <void insert<bloom_filters::K12LineOrCandidate, unsigned long>(bloom_filters::K12LineOrCandidate&, unsigned long, unsigned long const*)>
   117c3:	mov    0x3a8(%rsp),%rcx
   117cb:	add    %rcx,%r14
   117ce:	mov    0x18(%rsp),%rax
   117d3:	inc    %r13
   117d6:	sub    %rcx,%r15
   117d9:	mov    0x48(%rsp),%rdx
   117de:	add    %rdx,%r12
   117e1:	add    %rdx,%rbp
   117e4:	add    %rdx,0x10(%rsp)
   117e9:	cmp    %rax,%r14
   117ec:	jb     115f0 <void run<bloom_filters::K12LineOrCandidate, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xcf0>
   117f2:	jmp    119b0 <void run<bloom_filters::K12LineOrCandidate, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0x10b0>
   117f7:	cmp    $0x10,%rsi
   117fb:	jae    11804 <void run<bloom_filters::K12LineOrCandidate, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xf04>
   117fd:	xor    %edi,%edi
   117ff:	jmp    11932 <void run<bloom_filters::K12LineOrCandidate, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0x1032>
   11804:	mov    %rsi,%rdi
   11807:	and    $0xfffffffffffffff0,%rdi
   1180b:	lea    (%rax,%r15,1),%r8
   1180f:	mov    0x3a8(%rsp),%r9
   11817:	cmp    %r8,%r9
   1181a:	cmovb  %r9,%r8
   1181e:	and    $0xfffffffffffffff0,%r8
   11822:	lea    (%rcx,%r12,1),%r9
   11826:	xor    %r10d,%r10d
   11829:	vpbroadcastq -0xf6c2(%rip),%ymm8        # 2170 <_IO_stdin_used+0xd4>
   11832:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   11840:	vmovdqu -0x60(%r9,%r10,8),%ymm0
   11847:	vmovdqu -0x40(%r9,%r10,8),%ymm1
   1184e:	vmovdqu -0x20(%r9,%r10,8),%ymm2
   11855:	vmovdqu (%r9,%r10,8),%ymm3
   1185b:	vpsrlq $0x20,%ymm0,%ymm4
   11860:	vpsrlq $0x20,%ymm1,%ymm5
   11865:	vpsrlq $0x20,%ymm2,%ymm6
   1186a:	vpsrlq $0x20,%ymm3,%ymm7
   1186f:	vpxor  %ymm0,%ymm4,%ymm0
   11873:	vpxor  %ymm1,%ymm5,%ymm1
   11877:	vpxor  %ymm2,%ymm6,%ymm2
   1187b:	vpmullq %ymm8,%ymm0,%ymm0
   11881:	vpmullq %ymm8,%ymm1,%ymm1
   11887:	vpmullq %ymm8,%ymm2,%ymm2
   1188d:	vpxor  %ymm3,%ymm7,%ymm3
   11891:	vpmullq %ymm8,%ymm3,%ymm3
   11897:	vpsrlq $0x20,%ymm0,%ymm4
   1189c:	vpsrlq $0x20,%ymm1,%ymm5
   118a1:	vpsrlq $0x20,%ymm2,%ymm6
   118a6:	vpsrlq $0x20,%ymm3,%ymm7
   118ab:	vpxor  %ymm0,%ymm4,%ymm0
   118af:	vpxor  %ymm1,%ymm5,%ymm1
   118b3:	vpxor  %ymm2,%ymm6,%ymm2
   118b7:	vpxor  %ymm3,%ymm7,%ymm3
   118bb:	vpmullq %ymm8,%ymm0,%ymm0
   118c1:	vpmullq %ymm8,%ymm1,%ymm1
   118c7:	vpmullq %ymm8,%ymm2,%ymm2
   118cd:	vpmullq %ymm8,%ymm3,%ymm3
   118d3:	vpsrlq $0x20,%ymm0,%ymm4
   118d8:	vpsrlq $0x20,%ymm1,%ymm5
   118dd:	vpsrlq $0x20,%ymm2,%ymm6
   118e2:	vpsrlq $0x20,%ymm3,%ymm7
   118e7:	vpxor  %ymm0,%ymm4,%ymm0
   118eb:	vpxor  %ymm1,%ymm5,%ymm1
   118ef:	vpxor  %ymm2,%ymm6,%ymm2
   118f3:	vpxor  %ymm3,%ymm7,%ymm3
   118f7:	vmovdqu %ymm0,(%rdx,%r10,8)
   118fd:	vmovdqu %ymm1,0x20(%rdx,%r10,8)
   11904:	vmovdqu %ymm2,0x40(%rdx,%r10,8)
   1190b:	vmovdqu %ymm3,0x60(%rdx,%r10,8)
   11912:	add    $0x10,%r10
   11916:	cmp    %r10,%r8
   11919:	jne    11840 <void run<bloom_filters::K12LineOrCandidate, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xf40>
   1191f:	cmp    %rdi,%rsi
   11922:	je     117ab <void run<bloom_filters::K12LineOrCandidate, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xeab>
   11928:	test   $0xc,%sil
   1192c:	je     1163a <void run<bloom_filters::K12LineOrCandidate, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xd3a>
   11932:	mov    %rdi,%r8
   11935:	mov    %rsi,%rdi
   11938:	and    $0xfffffffffffffffc,%rdi
   1193c:	lea    (%rax,%r15,1),%r9
   11940:	mov    0x3a8(%rsp),%r10
   11948:	cmp    %r9,%r10
   1194b:	cmovb  %r10,%r9
   1194f:	and    $0xfffffffffffffffc,%r9
   11953:	lea    (%rcx,%rbp,1),%r10
   11957:	vpbroadcastq -0xf7f0(%rip),%ymm2        # 2170 <_IO_stdin_used+0xd4>
   11960:	vmovdqu (%r10,%r8,8),%ymm0
   11966:	vpsrlq $0x20,%ymm0,%ymm1
   1196b:	vpxor  %ymm0,%ymm1,%ymm0
   1196f:	vpmullq %ymm2,%ymm0,%ymm0
   11975:	vpsrlq $0x20,%ymm0,%ymm1
   1197a:	vpxor  %ymm0,%ymm1,%ymm0
   1197e:	vpmullq %ymm2,%ymm0,%ymm0
   11984:	vpsrlq $0x20,%ymm0,%ymm1
   11989:	vpxor  %ymm0,%ymm1,%ymm0
   1198d:	vmovdqu %ymm0,(%rdx,%r8,8)
   11993:	add    $0x4,%r8
   11997:	cmp    %r8,%r9
   1199a:	jne    11960 <void run<bloom_filters::K12LineOrCandidate, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0x1060>
   1199c:	cmp    %rdi,%rsi
   1199f:	je     117ab <void run<bloom_filters::K12LineOrCandidate, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xeab>
   119a5:	jmp    1163a <void run<bloom_filters::K12LineOrCandidate, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xd3a>
   119aa:	nopw   0x0(%rax,%rax,1)
   119b0:	call   170d0 <std::chrono::_V2::steady_clock::now()@plt>
