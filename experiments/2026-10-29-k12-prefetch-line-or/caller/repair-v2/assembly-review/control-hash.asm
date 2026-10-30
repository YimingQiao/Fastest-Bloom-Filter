    b249:	call   1d5f0 <std::chrono::_V2::steady_clock::now()@plt>
    b24e:	mov    %rax,0x40(%rsp)
    b253:	mov    0x18(%rsp),%rsi
    b258:	lea    0x220(%rsp),%rdi
    b260:	mov    %ebp,%edx
    b262:	call   e0e0 <bloom_filters::K12ScalarOrControl make_filter<bloom_filters::K12ScalarOrControl>(unsigned long, unsigned int)>
    b267:	call   1d5f0 <std::chrono::_V2::steady_clock::now()@plt>
    b26c:	mov    %rax,0x78(%rsp)
    b271:	mov    0x18(%rsp),%rax
    b276:	test   %rax,%rax
    b279:	mov    0x3a8(%rsp),%rcx
    b281:	je     b670 <void run<bloom_filters::K12ScalarOrControl, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0x10b0>
    b287:	mov    $0x60,%r12d
    b28d:	mov    $0x10,%edx
    b292:	mov    %rdx,0x10(%rsp)
    b297:	xor    %ebp,%ebp
    b299:	xor    %r15d,%r15d
    b29c:	xor    %r13d,%r13d
    b29f:	xor    %r14d,%r14d
    b2a2:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
    b2b0:	mov    %rax,%rsi
    b2b3:	sub    %r14,%rsi
    b2b6:	cmp    %rcx,%rsi
    b2b9:	cmovae %rcx,%rsi
    b2bd:	mov    0x180(%rsp),%rdx
    b2c5:	test   %rsi,%rsi
    b2c8:	je     b473 <void run<bloom_filters::K12ScalarOrControl, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xeb3>
    b2ce:	mov    0x20(%rsp),%rcx
    b2d3:	mov    (%rcx),%rcx
    b2d6:	cmp    $0x4,%rsi
    b2da:	jb     b2f8 <void run<bloom_filters::K12ScalarOrControl, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xd38>
    b2dc:	mov    0x30(%rsp),%rdi
    b2e1:	imul   %r13,%rdi
    b2e5:	add    %rdx,%rdi
    b2e8:	sub    %rcx,%rdi
    b2eb:	cmp    $0x80,%rdi
    b2f2:	jae    b4b7 <void run<bloom_filters::K12ScalarOrControl, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xef7>
    b2f8:	xor    %edi,%edi
    b2fa:	mov    %r12,0x68(%rsp)
    b2ff:	mov    %rdi,%r8
    b302:	test   $0x3,%sil
    b306:	je     b366 <void run<bloom_filters::K12ScalarOrControl, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xda6>
    b308:	lea    (%rcx,%rbp,1),%r9
    b30c:	lea    (%rax,%r15,1),%r10
    b310:	mov    0x3a8(%rsp),%r8
    b318:	cmp    %r10,%r8
    b31b:	cmovb  %r8,%r10
    b31f:	and    $0x3,%r10d
    b323:	mov    %rdi,%r8
    b326:	cs nopw 0x0(%rax,%rax,1)
    b330:	mov    (%r9,%r8,8),%r12
    b334:	mov    %r12,%r11
    b337:	shr    $0x20,%r11
    b33b:	xor    %r12,%r11
    b33e:	imul   %rbx,%r11
    b342:	mov    %r11,%r12
    b345:	shr    $0x20,%r12
    b349:	xor    %r11,%r12
    b34c:	imul   %rbx,%r12
    b350:	mov    %r12,%r11
    b353:	shr    $0x20,%r11
    b357:	xor    %r12,%r11
    b35a:	mov    %r11,(%rdx,%r8,8)
    b35e:	inc    %r8
    b361:	dec    %r10
    b364:	jne    b330 <void run<bloom_filters::K12ScalarOrControl, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xd70>
    b366:	sub    %rsi,%rdi
    b369:	cmp    $0xfffffffffffffffc,%rdi
    b36d:	mov    0x68(%rsp),%r12
    b372:	ja     b46b <void run<bloom_filters::K12ScalarOrControl, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xeab>
    b378:	add    %r15,%rax
    b37b:	mov    0x3a8(%rsp),%rdi
    b383:	cmp    %rax,%rdi
    b386:	cmovb  %rdi,%rax
    b38a:	sub    %r8,%rax
    b38d:	lea    0x18(%rdx,%r8,8),%rdx
    b392:	mov    0x10(%rsp),%rdi
    b397:	lea    (%rdi,%r8,8),%rdi
    b39b:	add    %rdi,%rcx
    b39e:	xor    %edi,%edi
    b3a0:	mov    -0x10(%rcx,%rdi,8),%r8
    b3a5:	mov    %r8,%r9
    b3a8:	shr    $0x20,%r9
    b3ac:	xor    %r8,%r9
    b3af:	imul   %rbx,%r9
    b3b3:	mov    %r9,%r8
    b3b6:	shr    $0x20,%r8
    b3ba:	xor    %r9,%r8
    b3bd:	imul   %rbx,%r8
    b3c1:	mov    %r8,%r9
    b3c4:	shr    $0x20,%r9
    b3c8:	xor    %r8,%r9
    b3cb:	mov    %r9,-0x18(%rdx,%rdi,8)
    b3d0:	mov    -0x8(%rcx,%rdi,8),%r8
    b3d5:	mov    %r8,%r9
    b3d8:	shr    $0x20,%r9
    b3dc:	xor    %r8,%r9
    b3df:	imul   %rbx,%r9
    b3e3:	mov    %r9,%r8
    b3e6:	shr    $0x20,%r8
    b3ea:	xor    %r9,%r8
    b3ed:	imul   %rbx,%r8
    b3f1:	mov    %r8,%r9
    b3f4:	shr    $0x20,%r9
    b3f8:	xor    %r8,%r9
    b3fb:	mov    %r9,-0x10(%rdx,%rdi,8)
    b400:	mov    (%rcx,%rdi,8),%r8
    b404:	mov    %r8,%r9
    b407:	shr    $0x20,%r9
    b40b:	xor    %r8,%r9
    b40e:	imul   %rbx,%r9
    b412:	mov    %r9,%r8
    b415:	shr    $0x20,%r8
    b419:	xor    %r9,%r8
    b41c:	imul   %rbx,%r8
    b420:	mov    %r8,%r9
    b423:	shr    $0x20,%r9
    b427:	xor    %r8,%r9
    b42a:	mov    %r9,-0x8(%rdx,%rdi,8)
    b42f:	mov    0x8(%rcx,%rdi,8),%r8
    b434:	mov    %r8,%r9
    b437:	shr    $0x20,%r9
    b43b:	xor    %r8,%r9
    b43e:	imul   %rbx,%r9
    b442:	mov    %r9,%r8
    b445:	shr    $0x20,%r8
    b449:	xor    %r9,%r8
    b44c:	imul   %rbx,%r8
    b450:	mov    %r8,%r9
    b453:	shr    $0x20,%r9
    b457:	xor    %r8,%r9
    b45a:	mov    %r9,(%rdx,%rdi,8)
    b45e:	add    $0x4,%rdi
    b462:	cmp    %rdi,%rax
    b465:	jne    b3a0 <void run<bloom_filters::K12ScalarOrControl, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xde0>
    b46b:	mov    0x180(%rsp),%rdx
    b473:	lea    0x220(%rsp),%rdi
    b47b:	vzeroupper
    b47e:	call   e220 <void insert<bloom_filters::K12ScalarOrControl, unsigned long>(bloom_filters::K12ScalarOrControl&, unsigned long, unsigned long const*)>
    b483:	mov    0x3a8(%rsp),%rcx
    b48b:	add    %rcx,%r14
    b48e:	mov    0x18(%rsp),%rax
    b493:	inc    %r13
    b496:	sub    %rcx,%r15
    b499:	mov    0x48(%rsp),%rdx
    b49e:	add    %rdx,%r12
    b4a1:	add    %rdx,%rbp
    b4a4:	add    %rdx,0x10(%rsp)
    b4a9:	cmp    %rax,%r14
    b4ac:	jb     b2b0 <void run<bloom_filters::K12ScalarOrControl, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xcf0>
    b4b2:	jmp    b670 <void run<bloom_filters::K12ScalarOrControl, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0x10b0>
    b4b7:	cmp    $0x10,%rsi
    b4bb:	jae    b4c4 <void run<bloom_filters::K12ScalarOrControl, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xf04>
    b4bd:	xor    %edi,%edi
    b4bf:	jmp    b5f2 <void run<bloom_filters::K12ScalarOrControl, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0x1032>
    b4c4:	mov    %rsi,%rdi
    b4c7:	and    $0xfffffffffffffff0,%rdi
    b4cb:	lea    (%rax,%r15,1),%r8
    b4cf:	mov    0x3a8(%rsp),%r9
    b4d7:	cmp    %r8,%r9
    b4da:	cmovb  %r9,%r8
    b4de:	and    $0xfffffffffffffff0,%r8
    b4e2:	lea    (%rcx,%r12,1),%r9
    b4e6:	xor    %r10d,%r10d
    b4e9:	vpbroadcastq -0x9322(%rip),%ymm8        # 21d0 <_IO_stdin_used+0xf4>
    b4f2:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
    b500:	vmovdqu -0x60(%r9,%r10,8),%ymm0
    b507:	vmovdqu -0x40(%r9,%r10,8),%ymm1
    b50e:	vmovdqu -0x20(%r9,%r10,8),%ymm2
    b515:	vmovdqu (%r9,%r10,8),%ymm3
    b51b:	vpsrlq $0x20,%ymm0,%ymm4
    b520:	vpsrlq $0x20,%ymm1,%ymm5
    b525:	vpsrlq $0x20,%ymm2,%ymm6
    b52a:	vpsrlq $0x20,%ymm3,%ymm7
    b52f:	vpxor  %ymm0,%ymm4,%ymm0
    b533:	vpxor  %ymm1,%ymm5,%ymm1
    b537:	vpxor  %ymm2,%ymm6,%ymm2
    b53b:	vpmullq %ymm8,%ymm0,%ymm0
    b541:	vpmullq %ymm8,%ymm1,%ymm1
    b547:	vpmullq %ymm8,%ymm2,%ymm2
    b54d:	vpxor  %ymm3,%ymm7,%ymm3
    b551:	vpmullq %ymm8,%ymm3,%ymm3
    b557:	vpsrlq $0x20,%ymm0,%ymm4
    b55c:	vpsrlq $0x20,%ymm1,%ymm5
    b561:	vpsrlq $0x20,%ymm2,%ymm6
    b566:	vpsrlq $0x20,%ymm3,%ymm7
    b56b:	vpxor  %ymm0,%ymm4,%ymm0
    b56f:	vpxor  %ymm1,%ymm5,%ymm1
    b573:	vpxor  %ymm2,%ymm6,%ymm2
    b577:	vpxor  %ymm3,%ymm7,%ymm3
    b57b:	vpmullq %ymm8,%ymm0,%ymm0
    b581:	vpmullq %ymm8,%ymm1,%ymm1
    b587:	vpmullq %ymm8,%ymm2,%ymm2
    b58d:	vpmullq %ymm8,%ymm3,%ymm3
    b593:	vpsrlq $0x20,%ymm0,%ymm4
    b598:	vpsrlq $0x20,%ymm1,%ymm5
    b59d:	vpsrlq $0x20,%ymm2,%ymm6
    b5a2:	vpsrlq $0x20,%ymm3,%ymm7
    b5a7:	vpxor  %ymm0,%ymm4,%ymm0
    b5ab:	vpxor  %ymm1,%ymm5,%ymm1
    b5af:	vpxor  %ymm2,%ymm6,%ymm2
    b5b3:	vpxor  %ymm3,%ymm7,%ymm3
    b5b7:	vmovdqu %ymm0,(%rdx,%r10,8)
    b5bd:	vmovdqu %ymm1,0x20(%rdx,%r10,8)
    b5c4:	vmovdqu %ymm2,0x40(%rdx,%r10,8)
    b5cb:	vmovdqu %ymm3,0x60(%rdx,%r10,8)
    b5d2:	add    $0x10,%r10
    b5d6:	cmp    %r10,%r8
    b5d9:	jne    b500 <void run<bloom_filters::K12ScalarOrControl, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xf40>
    b5df:	cmp    %rdi,%rsi
    b5e2:	je     b46b <void run<bloom_filters::K12ScalarOrControl, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xeab>
    b5e8:	test   $0xc,%sil
    b5ec:	je     b2fa <void run<bloom_filters::K12ScalarOrControl, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xd3a>
    b5f2:	mov    %rdi,%r8
    b5f5:	mov    %rsi,%rdi
    b5f8:	and    $0xfffffffffffffffc,%rdi
    b5fc:	lea    (%rax,%r15,1),%r9
    b600:	mov    0x3a8(%rsp),%r10
    b608:	cmp    %r9,%r10
    b60b:	cmovb  %r10,%r9
    b60f:	and    $0xfffffffffffffffc,%r9
    b613:	lea    (%rcx,%rbp,1),%r10
    b617:	vpbroadcastq -0x9450(%rip),%ymm2        # 21d0 <_IO_stdin_used+0xf4>
    b620:	vmovdqu (%r10,%r8,8),%ymm0
    b626:	vpsrlq $0x20,%ymm0,%ymm1
    b62b:	vpxor  %ymm0,%ymm1,%ymm0
    b62f:	vpmullq %ymm2,%ymm0,%ymm0
    b635:	vpsrlq $0x20,%ymm0,%ymm1
    b63a:	vpxor  %ymm0,%ymm1,%ymm0
    b63e:	vpmullq %ymm2,%ymm0,%ymm0
    b644:	vpsrlq $0x20,%ymm0,%ymm1
    b649:	vpxor  %ymm0,%ymm1,%ymm0
    b64d:	vmovdqu %ymm0,(%rdx,%r8,8)
    b653:	add    $0x4,%r8
    b657:	cmp    %r8,%r9
    b65a:	jne    b620 <void run<bloom_filters::K12ScalarOrControl, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0x1060>
    b65c:	cmp    %rdi,%rsi
    b65f:	je     b46b <void run<bloom_filters::K12ScalarOrControl, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xeab>
    b665:	jmp    b2fa <void run<bloom_filters::K12ScalarOrControl, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xd3a>
    b66a:	nopw   0x0(%rax,%rax,1)
    b670:	call   1d5f0 <std::chrono::_V2::steady_clock::now()@plt>
