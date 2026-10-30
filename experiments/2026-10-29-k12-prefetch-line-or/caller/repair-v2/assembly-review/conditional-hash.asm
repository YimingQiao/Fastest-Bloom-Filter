   126d9:	call   1d5f0 <std::chrono::_V2::steady_clock::now()@plt>
   126de:	mov    %rax,0x40(%rsp)
   126e3:	mov    0x18(%rsp),%rsi
   126e8:	lea    0x220(%rsp),%rdi
   126f0:	mov    %ebp,%edx
   126f2:	call   15570 <bloom_filters::K12PrefetchLineOrCandidate make_filter<bloom_filters::K12PrefetchLineOrCandidate>(unsigned long, unsigned int)>
   126f7:	call   1d5f0 <std::chrono::_V2::steady_clock::now()@plt>
   126fc:	mov    %rax,0x78(%rsp)
   12701:	mov    0x18(%rsp),%rax
   12706:	test   %rax,%rax
   12709:	mov    0x3a8(%rsp),%rcx
   12711:	je     12b00 <void run<bloom_filters::K12PrefetchLineOrCandidate, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0x10b0>
   12717:	mov    $0x60,%r12d
   1271d:	mov    $0x10,%edx
   12722:	mov    %rdx,0x10(%rsp)
   12727:	xor    %ebp,%ebp
   12729:	xor    %r15d,%r15d
   1272c:	xor    %r13d,%r13d
   1272f:	xor    %r14d,%r14d
   12732:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   12740:	mov    %rax,%rsi
   12743:	sub    %r14,%rsi
   12746:	cmp    %rcx,%rsi
   12749:	cmovae %rcx,%rsi
   1274d:	mov    0x180(%rsp),%rdx
   12755:	test   %rsi,%rsi
   12758:	je     12903 <void run<bloom_filters::K12PrefetchLineOrCandidate, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xeb3>
   1275e:	mov    0x20(%rsp),%rcx
   12763:	mov    (%rcx),%rcx
   12766:	cmp    $0x4,%rsi
   1276a:	jb     12788 <void run<bloom_filters::K12PrefetchLineOrCandidate, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xd38>
   1276c:	mov    0x30(%rsp),%rdi
   12771:	imul   %r13,%rdi
   12775:	add    %rdx,%rdi
   12778:	sub    %rcx,%rdi
   1277b:	cmp    $0x80,%rdi
   12782:	jae    12947 <void run<bloom_filters::K12PrefetchLineOrCandidate, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xef7>
   12788:	xor    %edi,%edi
   1278a:	mov    %r12,0x68(%rsp)
   1278f:	mov    %rdi,%r8
   12792:	test   $0x3,%sil
   12796:	je     127f6 <void run<bloom_filters::K12PrefetchLineOrCandidate, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xda6>
   12798:	lea    (%rcx,%rbp,1),%r9
   1279c:	lea    (%rax,%r15,1),%r10
   127a0:	mov    0x3a8(%rsp),%r8
   127a8:	cmp    %r10,%r8
   127ab:	cmovb  %r8,%r10
   127af:	and    $0x3,%r10d
   127b3:	mov    %rdi,%r8
   127b6:	cs nopw 0x0(%rax,%rax,1)
   127c0:	mov    (%r9,%r8,8),%r12
   127c4:	mov    %r12,%r11
   127c7:	shr    $0x20,%r11
   127cb:	xor    %r12,%r11
   127ce:	imul   %rbx,%r11
   127d2:	mov    %r11,%r12
   127d5:	shr    $0x20,%r12
   127d9:	xor    %r11,%r12
   127dc:	imul   %rbx,%r12
   127e0:	mov    %r12,%r11
   127e3:	shr    $0x20,%r11
   127e7:	xor    %r12,%r11
   127ea:	mov    %r11,(%rdx,%r8,8)
   127ee:	inc    %r8
   127f1:	dec    %r10
   127f4:	jne    127c0 <void run<bloom_filters::K12PrefetchLineOrCandidate, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xd70>
   127f6:	sub    %rsi,%rdi
   127f9:	cmp    $0xfffffffffffffffc,%rdi
   127fd:	mov    0x68(%rsp),%r12
   12802:	ja     128fb <void run<bloom_filters::K12PrefetchLineOrCandidate, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xeab>
   12808:	add    %r15,%rax
   1280b:	mov    0x3a8(%rsp),%rdi
   12813:	cmp    %rax,%rdi
   12816:	cmovb  %rdi,%rax
   1281a:	sub    %r8,%rax
   1281d:	lea    0x18(%rdx,%r8,8),%rdx
   12822:	mov    0x10(%rsp),%rdi
   12827:	lea    (%rdi,%r8,8),%rdi
   1282b:	add    %rdi,%rcx
   1282e:	xor    %edi,%edi
   12830:	mov    -0x10(%rcx,%rdi,8),%r8
   12835:	mov    %r8,%r9
   12838:	shr    $0x20,%r9
   1283c:	xor    %r8,%r9
   1283f:	imul   %rbx,%r9
   12843:	mov    %r9,%r8
   12846:	shr    $0x20,%r8
   1284a:	xor    %r9,%r8
   1284d:	imul   %rbx,%r8
   12851:	mov    %r8,%r9
   12854:	shr    $0x20,%r9
   12858:	xor    %r8,%r9
   1285b:	mov    %r9,-0x18(%rdx,%rdi,8)
   12860:	mov    -0x8(%rcx,%rdi,8),%r8
   12865:	mov    %r8,%r9
   12868:	shr    $0x20,%r9
   1286c:	xor    %r8,%r9
   1286f:	imul   %rbx,%r9
   12873:	mov    %r9,%r8
   12876:	shr    $0x20,%r8
   1287a:	xor    %r9,%r8
   1287d:	imul   %rbx,%r8
   12881:	mov    %r8,%r9
   12884:	shr    $0x20,%r9
   12888:	xor    %r8,%r9
   1288b:	mov    %r9,-0x10(%rdx,%rdi,8)
   12890:	mov    (%rcx,%rdi,8),%r8
   12894:	mov    %r8,%r9
   12897:	shr    $0x20,%r9
   1289b:	xor    %r8,%r9
   1289e:	imul   %rbx,%r9
   128a2:	mov    %r9,%r8
   128a5:	shr    $0x20,%r8
   128a9:	xor    %r9,%r8
   128ac:	imul   %rbx,%r8
   128b0:	mov    %r8,%r9
   128b3:	shr    $0x20,%r9
   128b7:	xor    %r8,%r9
   128ba:	mov    %r9,-0x8(%rdx,%rdi,8)
   128bf:	mov    0x8(%rcx,%rdi,8),%r8
   128c4:	mov    %r8,%r9
   128c7:	shr    $0x20,%r9
   128cb:	xor    %r8,%r9
   128ce:	imul   %rbx,%r9
   128d2:	mov    %r9,%r8
   128d5:	shr    $0x20,%r8
   128d9:	xor    %r9,%r8
   128dc:	imul   %rbx,%r8
   128e0:	mov    %r8,%r9
   128e3:	shr    $0x20,%r9
   128e7:	xor    %r8,%r9
   128ea:	mov    %r9,(%rdx,%rdi,8)
   128ee:	add    $0x4,%rdi
   128f2:	cmp    %rdi,%rax
   128f5:	jne    12830 <void run<bloom_filters::K12PrefetchLineOrCandidate, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xde0>
   128fb:	mov    0x180(%rsp),%rdx
   12903:	lea    0x220(%rsp),%rdi
   1290b:	vzeroupper
   1290e:	call   156b0 <void insert<bloom_filters::K12PrefetchLineOrCandidate, unsigned long>(bloom_filters::K12PrefetchLineOrCandidate&, unsigned long, unsigned long const*)>
   12913:	mov    0x3a8(%rsp),%rcx
   1291b:	add    %rcx,%r14
   1291e:	mov    0x18(%rsp),%rax
   12923:	inc    %r13
   12926:	sub    %rcx,%r15
   12929:	mov    0x48(%rsp),%rdx
   1292e:	add    %rdx,%r12
   12931:	add    %rdx,%rbp
   12934:	add    %rdx,0x10(%rsp)
   12939:	cmp    %rax,%r14
   1293c:	jb     12740 <void run<bloom_filters::K12PrefetchLineOrCandidate, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xcf0>
   12942:	jmp    12b00 <void run<bloom_filters::K12PrefetchLineOrCandidate, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0x10b0>
   12947:	cmp    $0x10,%rsi
   1294b:	jae    12954 <void run<bloom_filters::K12PrefetchLineOrCandidate, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xf04>
   1294d:	xor    %edi,%edi
   1294f:	jmp    12a82 <void run<bloom_filters::K12PrefetchLineOrCandidate, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0x1032>
   12954:	mov    %rsi,%rdi
   12957:	and    $0xfffffffffffffff0,%rdi
   1295b:	lea    (%rax,%r15,1),%r8
   1295f:	mov    0x3a8(%rsp),%r9
   12967:	cmp    %r8,%r9
   1296a:	cmovb  %r9,%r8
   1296e:	and    $0xfffffffffffffff0,%r8
   12972:	lea    (%rcx,%r12,1),%r9
   12976:	xor    %r10d,%r10d
   12979:	vpbroadcastq -0x107b2(%rip),%ymm8        # 21d0 <_IO_stdin_used+0xf4>
   12982:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   12990:	vmovdqu -0x60(%r9,%r10,8),%ymm0
   12997:	vmovdqu -0x40(%r9,%r10,8),%ymm1
   1299e:	vmovdqu -0x20(%r9,%r10,8),%ymm2
   129a5:	vmovdqu (%r9,%r10,8),%ymm3
   129ab:	vpsrlq $0x20,%ymm0,%ymm4
   129b0:	vpsrlq $0x20,%ymm1,%ymm5
   129b5:	vpsrlq $0x20,%ymm2,%ymm6
   129ba:	vpsrlq $0x20,%ymm3,%ymm7
   129bf:	vpxor  %ymm0,%ymm4,%ymm0
   129c3:	vpxor  %ymm1,%ymm5,%ymm1
   129c7:	vpxor  %ymm2,%ymm6,%ymm2
   129cb:	vpmullq %ymm8,%ymm0,%ymm0
   129d1:	vpmullq %ymm8,%ymm1,%ymm1
   129d7:	vpmullq %ymm8,%ymm2,%ymm2
   129dd:	vpxor  %ymm3,%ymm7,%ymm3
   129e1:	vpmullq %ymm8,%ymm3,%ymm3
   129e7:	vpsrlq $0x20,%ymm0,%ymm4
   129ec:	vpsrlq $0x20,%ymm1,%ymm5
   129f1:	vpsrlq $0x20,%ymm2,%ymm6
   129f6:	vpsrlq $0x20,%ymm3,%ymm7
   129fb:	vpxor  %ymm0,%ymm4,%ymm0
   129ff:	vpxor  %ymm1,%ymm5,%ymm1
   12a03:	vpxor  %ymm2,%ymm6,%ymm2
   12a07:	vpxor  %ymm3,%ymm7,%ymm3
   12a0b:	vpmullq %ymm8,%ymm0,%ymm0
   12a11:	vpmullq %ymm8,%ymm1,%ymm1
   12a17:	vpmullq %ymm8,%ymm2,%ymm2
   12a1d:	vpmullq %ymm8,%ymm3,%ymm3
   12a23:	vpsrlq $0x20,%ymm0,%ymm4
   12a28:	vpsrlq $0x20,%ymm1,%ymm5
   12a2d:	vpsrlq $0x20,%ymm2,%ymm6
   12a32:	vpsrlq $0x20,%ymm3,%ymm7
   12a37:	vpxor  %ymm0,%ymm4,%ymm0
   12a3b:	vpxor  %ymm1,%ymm5,%ymm1
   12a3f:	vpxor  %ymm2,%ymm6,%ymm2
   12a43:	vpxor  %ymm3,%ymm7,%ymm3
   12a47:	vmovdqu %ymm0,(%rdx,%r10,8)
   12a4d:	vmovdqu %ymm1,0x20(%rdx,%r10,8)
   12a54:	vmovdqu %ymm2,0x40(%rdx,%r10,8)
   12a5b:	vmovdqu %ymm3,0x60(%rdx,%r10,8)
   12a62:	add    $0x10,%r10
   12a66:	cmp    %r10,%r8
   12a69:	jne    12990 <void run<bloom_filters::K12PrefetchLineOrCandidate, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xf40>
   12a6f:	cmp    %rdi,%rsi
   12a72:	je     128fb <void run<bloom_filters::K12PrefetchLineOrCandidate, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xeab>
   12a78:	test   $0xc,%sil
   12a7c:	je     1278a <void run<bloom_filters::K12PrefetchLineOrCandidate, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xd3a>
   12a82:	mov    %rdi,%r8
   12a85:	mov    %rsi,%rdi
   12a88:	and    $0xfffffffffffffffc,%rdi
   12a8c:	lea    (%rax,%r15,1),%r9
   12a90:	mov    0x3a8(%rsp),%r10
   12a98:	cmp    %r9,%r10
   12a9b:	cmovb  %r10,%r9
   12a9f:	and    $0xfffffffffffffffc,%r9
   12aa3:	lea    (%rcx,%rbp,1),%r10
   12aa7:	vpbroadcastq -0x108e0(%rip),%ymm2        # 21d0 <_IO_stdin_used+0xf4>
   12ab0:	vmovdqu (%r10,%r8,8),%ymm0
   12ab6:	vpsrlq $0x20,%ymm0,%ymm1
   12abb:	vpxor  %ymm0,%ymm1,%ymm0
   12abf:	vpmullq %ymm2,%ymm0,%ymm0
   12ac5:	vpsrlq $0x20,%ymm0,%ymm1
   12aca:	vpxor  %ymm0,%ymm1,%ymm0
   12ace:	vpmullq %ymm2,%ymm0,%ymm0
   12ad4:	vpsrlq $0x20,%ymm0,%ymm1
   12ad9:	vpxor  %ymm0,%ymm1,%ymm0
   12add:	vmovdqu %ymm0,(%rdx,%r8,8)
   12ae3:	add    $0x4,%r8
   12ae7:	cmp    %r8,%r9
   12aea:	jne    12ab0 <void run<bloom_filters::K12PrefetchLineOrCandidate, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0x1060>
   12aec:	cmp    %rdi,%rsi
   12aef:	je     128fb <void run<bloom_filters::K12PrefetchLineOrCandidate, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xeab>
   12af5:	jmp    1278a <void run<bloom_filters::K12PrefetchLineOrCandidate, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xd3a>
   12afa:	nopw   0x0(%rax,%rax,1)
   12b00:	call   1d5f0 <std::chrono::_V2::steady_clock::now()@plt>
