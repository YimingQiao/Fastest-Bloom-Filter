    a0f9:	call   170d0 <std::chrono::_V2::steady_clock::now()@plt>
    a0fe:	mov    %rax,0x40(%rsp)
    a103:	mov    0x18(%rsp),%rsi
    a108:	lea    0x220(%rsp),%rdi
    a110:	mov    %ebp,%edx
    a112:	call   cf90 <bloom_filters::K12ScalarOrControl make_filter<bloom_filters::K12ScalarOrControl>(unsigned long, unsigned int)>
    a117:	call   170d0 <std::chrono::_V2::steady_clock::now()@plt>
    a11c:	mov    %rax,0x78(%rsp)
    a121:	mov    0x18(%rsp),%rax
    a126:	test   %rax,%rax
    a129:	mov    0x3a8(%rsp),%rcx
    a131:	je     a520 <void run<bloom_filters::K12ScalarOrControl, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0x10b0>
    a137:	mov    $0x60,%r12d
    a13d:	mov    $0x10,%edx
    a142:	mov    %rdx,0x10(%rsp)
    a147:	xor    %ebp,%ebp
    a149:	xor    %r15d,%r15d
    a14c:	xor    %r13d,%r13d
    a14f:	xor    %r14d,%r14d
    a152:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
    a160:	mov    %rax,%rsi
    a163:	sub    %r14,%rsi
    a166:	cmp    %rcx,%rsi
    a169:	cmovae %rcx,%rsi
    a16d:	mov    0x180(%rsp),%rdx
    a175:	test   %rsi,%rsi
    a178:	je     a323 <void run<bloom_filters::K12ScalarOrControl, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xeb3>
    a17e:	mov    0x20(%rsp),%rcx
    a183:	mov    (%rcx),%rcx
    a186:	cmp    $0x4,%rsi
    a18a:	jb     a1a8 <void run<bloom_filters::K12ScalarOrControl, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xd38>
    a18c:	mov    0x30(%rsp),%rdi
    a191:	imul   %r13,%rdi
    a195:	add    %rdx,%rdi
    a198:	sub    %rcx,%rdi
    a19b:	cmp    $0x80,%rdi
    a1a2:	jae    a367 <void run<bloom_filters::K12ScalarOrControl, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xef7>
    a1a8:	xor    %edi,%edi
    a1aa:	mov    %r12,0x68(%rsp)
    a1af:	mov    %rdi,%r8
    a1b2:	test   $0x3,%sil
    a1b6:	je     a216 <void run<bloom_filters::K12ScalarOrControl, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xda6>
    a1b8:	lea    (%rcx,%rbp,1),%r9
    a1bc:	lea    (%rax,%r15,1),%r10
    a1c0:	mov    0x3a8(%rsp),%r8
    a1c8:	cmp    %r10,%r8
    a1cb:	cmovb  %r8,%r10
    a1cf:	and    $0x3,%r10d
    a1d3:	mov    %rdi,%r8
    a1d6:	cs nopw 0x0(%rax,%rax,1)
    a1e0:	mov    (%r9,%r8,8),%r12
    a1e4:	mov    %r12,%r11
    a1e7:	shr    $0x20,%r11
    a1eb:	xor    %r12,%r11
    a1ee:	imul   %rbx,%r11
    a1f2:	mov    %r11,%r12
    a1f5:	shr    $0x20,%r12
    a1f9:	xor    %r11,%r12
    a1fc:	imul   %rbx,%r12
    a200:	mov    %r12,%r11
    a203:	shr    $0x20,%r11
    a207:	xor    %r12,%r11
    a20a:	mov    %r11,(%rdx,%r8,8)
    a20e:	inc    %r8
    a211:	dec    %r10
    a214:	jne    a1e0 <void run<bloom_filters::K12ScalarOrControl, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xd70>
    a216:	sub    %rsi,%rdi
    a219:	cmp    $0xfffffffffffffffc,%rdi
    a21d:	mov    0x68(%rsp),%r12
    a222:	ja     a31b <void run<bloom_filters::K12ScalarOrControl, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xeab>
    a228:	add    %r15,%rax
    a22b:	mov    0x3a8(%rsp),%rdi
    a233:	cmp    %rax,%rdi
    a236:	cmovb  %rdi,%rax
    a23a:	sub    %r8,%rax
    a23d:	lea    0x18(%rdx,%r8,8),%rdx
    a242:	mov    0x10(%rsp),%rdi
    a247:	lea    (%rdi,%r8,8),%rdi
    a24b:	add    %rdi,%rcx
    a24e:	xor    %edi,%edi
    a250:	mov    -0x10(%rcx,%rdi,8),%r8
    a255:	mov    %r8,%r9
    a258:	shr    $0x20,%r9
    a25c:	xor    %r8,%r9
    a25f:	imul   %rbx,%r9
    a263:	mov    %r9,%r8
    a266:	shr    $0x20,%r8
    a26a:	xor    %r9,%r8
    a26d:	imul   %rbx,%r8
    a271:	mov    %r8,%r9
    a274:	shr    $0x20,%r9
    a278:	xor    %r8,%r9
    a27b:	mov    %r9,-0x18(%rdx,%rdi,8)
    a280:	mov    -0x8(%rcx,%rdi,8),%r8
    a285:	mov    %r8,%r9
    a288:	shr    $0x20,%r9
    a28c:	xor    %r8,%r9
    a28f:	imul   %rbx,%r9
    a293:	mov    %r9,%r8
    a296:	shr    $0x20,%r8
    a29a:	xor    %r9,%r8
    a29d:	imul   %rbx,%r8
    a2a1:	mov    %r8,%r9
    a2a4:	shr    $0x20,%r9
    a2a8:	xor    %r8,%r9
    a2ab:	mov    %r9,-0x10(%rdx,%rdi,8)
    a2b0:	mov    (%rcx,%rdi,8),%r8
    a2b4:	mov    %r8,%r9
    a2b7:	shr    $0x20,%r9
    a2bb:	xor    %r8,%r9
    a2be:	imul   %rbx,%r9
    a2c2:	mov    %r9,%r8
    a2c5:	shr    $0x20,%r8
    a2c9:	xor    %r9,%r8
    a2cc:	imul   %rbx,%r8
    a2d0:	mov    %r8,%r9
    a2d3:	shr    $0x20,%r9
    a2d7:	xor    %r8,%r9
    a2da:	mov    %r9,-0x8(%rdx,%rdi,8)
    a2df:	mov    0x8(%rcx,%rdi,8),%r8
    a2e4:	mov    %r8,%r9
    a2e7:	shr    $0x20,%r9
    a2eb:	xor    %r8,%r9
    a2ee:	imul   %rbx,%r9
    a2f2:	mov    %r9,%r8
    a2f5:	shr    $0x20,%r8
    a2f9:	xor    %r9,%r8
    a2fc:	imul   %rbx,%r8
    a300:	mov    %r8,%r9
    a303:	shr    $0x20,%r9
    a307:	xor    %r8,%r9
    a30a:	mov    %r9,(%rdx,%rdi,8)
    a30e:	add    $0x4,%rdi
    a312:	cmp    %rdi,%rax
    a315:	jne    a250 <void run<bloom_filters::K12ScalarOrControl, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xde0>
    a31b:	mov    0x180(%rsp),%rdx
    a323:	lea    0x220(%rsp),%rdi
    a32b:	vzeroupper
    a32e:	call   d0d0 <void insert<bloom_filters::K12ScalarOrControl, unsigned long>(bloom_filters::K12ScalarOrControl&, unsigned long, unsigned long const*)>
    a333:	mov    0x3a8(%rsp),%rcx
    a33b:	add    %rcx,%r14
    a33e:	mov    0x18(%rsp),%rax
    a343:	inc    %r13
    a346:	sub    %rcx,%r15
    a349:	mov    0x48(%rsp),%rdx
    a34e:	add    %rdx,%r12
    a351:	add    %rdx,%rbp
    a354:	add    %rdx,0x10(%rsp)
    a359:	cmp    %rax,%r14
    a35c:	jb     a160 <void run<bloom_filters::K12ScalarOrControl, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xcf0>
    a362:	jmp    a520 <void run<bloom_filters::K12ScalarOrControl, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0x10b0>
    a367:	cmp    $0x10,%rsi
    a36b:	jae    a374 <void run<bloom_filters::K12ScalarOrControl, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xf04>
    a36d:	xor    %edi,%edi
    a36f:	jmp    a4a2 <void run<bloom_filters::K12ScalarOrControl, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0x1032>
    a374:	mov    %rsi,%rdi
    a377:	and    $0xfffffffffffffff0,%rdi
    a37b:	lea    (%rax,%r15,1),%r8
    a37f:	mov    0x3a8(%rsp),%r9
    a387:	cmp    %r8,%r9
    a38a:	cmovb  %r9,%r8
    a38e:	and    $0xfffffffffffffff0,%r8
    a392:	lea    (%rcx,%r12,1),%r9
    a396:	xor    %r10d,%r10d
    a399:	vpbroadcastq -0x8232(%rip),%ymm8        # 2170 <_IO_stdin_used+0xd4>
    a3a2:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
    a3b0:	vmovdqu -0x60(%r9,%r10,8),%ymm0
    a3b7:	vmovdqu -0x40(%r9,%r10,8),%ymm1
    a3be:	vmovdqu -0x20(%r9,%r10,8),%ymm2
    a3c5:	vmovdqu (%r9,%r10,8),%ymm3
    a3cb:	vpsrlq $0x20,%ymm0,%ymm4
    a3d0:	vpsrlq $0x20,%ymm1,%ymm5
    a3d5:	vpsrlq $0x20,%ymm2,%ymm6
    a3da:	vpsrlq $0x20,%ymm3,%ymm7
    a3df:	vpxor  %ymm0,%ymm4,%ymm0
    a3e3:	vpxor  %ymm1,%ymm5,%ymm1
    a3e7:	vpxor  %ymm2,%ymm6,%ymm2
    a3eb:	vpmullq %ymm8,%ymm0,%ymm0
    a3f1:	vpmullq %ymm8,%ymm1,%ymm1
    a3f7:	vpmullq %ymm8,%ymm2,%ymm2
    a3fd:	vpxor  %ymm3,%ymm7,%ymm3
    a401:	vpmullq %ymm8,%ymm3,%ymm3
    a407:	vpsrlq $0x20,%ymm0,%ymm4
    a40c:	vpsrlq $0x20,%ymm1,%ymm5
    a411:	vpsrlq $0x20,%ymm2,%ymm6
    a416:	vpsrlq $0x20,%ymm3,%ymm7
    a41b:	vpxor  %ymm0,%ymm4,%ymm0
    a41f:	vpxor  %ymm1,%ymm5,%ymm1
    a423:	vpxor  %ymm2,%ymm6,%ymm2
    a427:	vpxor  %ymm3,%ymm7,%ymm3
    a42b:	vpmullq %ymm8,%ymm0,%ymm0
    a431:	vpmullq %ymm8,%ymm1,%ymm1
    a437:	vpmullq %ymm8,%ymm2,%ymm2
    a43d:	vpmullq %ymm8,%ymm3,%ymm3
    a443:	vpsrlq $0x20,%ymm0,%ymm4
    a448:	vpsrlq $0x20,%ymm1,%ymm5
    a44d:	vpsrlq $0x20,%ymm2,%ymm6
    a452:	vpsrlq $0x20,%ymm3,%ymm7
    a457:	vpxor  %ymm0,%ymm4,%ymm0
    a45b:	vpxor  %ymm1,%ymm5,%ymm1
    a45f:	vpxor  %ymm2,%ymm6,%ymm2
    a463:	vpxor  %ymm3,%ymm7,%ymm3
    a467:	vmovdqu %ymm0,(%rdx,%r10,8)
    a46d:	vmovdqu %ymm1,0x20(%rdx,%r10,8)
    a474:	vmovdqu %ymm2,0x40(%rdx,%r10,8)
    a47b:	vmovdqu %ymm3,0x60(%rdx,%r10,8)
    a482:	add    $0x10,%r10
    a486:	cmp    %r10,%r8
    a489:	jne    a3b0 <void run<bloom_filters::K12ScalarOrControl, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xf40>
    a48f:	cmp    %rdi,%rsi
    a492:	je     a31b <void run<bloom_filters::K12ScalarOrControl, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xeab>
    a498:	test   $0xc,%sil
    a49c:	je     a1aa <void run<bloom_filters::K12ScalarOrControl, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xd3a>
    a4a2:	mov    %rdi,%r8
    a4a5:	mov    %rsi,%rdi
    a4a8:	and    $0xfffffffffffffffc,%rdi
    a4ac:	lea    (%rax,%r15,1),%r9
    a4b0:	mov    0x3a8(%rsp),%r10
    a4b8:	cmp    %r9,%r10
    a4bb:	cmovb  %r10,%r9
    a4bf:	and    $0xfffffffffffffffc,%r9
    a4c3:	lea    (%rcx,%rbp,1),%r10
    a4c7:	vpbroadcastq -0x8360(%rip),%ymm2        # 2170 <_IO_stdin_used+0xd4>
    a4d0:	vmovdqu (%r10,%r8,8),%ymm0
    a4d6:	vpsrlq $0x20,%ymm0,%ymm1
    a4db:	vpxor  %ymm0,%ymm1,%ymm0
    a4df:	vpmullq %ymm2,%ymm0,%ymm0
    a4e5:	vpsrlq $0x20,%ymm0,%ymm1
    a4ea:	vpxor  %ymm0,%ymm1,%ymm0
    a4ee:	vpmullq %ymm2,%ymm0,%ymm0
    a4f4:	vpsrlq $0x20,%ymm0,%ymm1
    a4f9:	vpxor  %ymm0,%ymm1,%ymm0
    a4fd:	vmovdqu %ymm0,(%rdx,%r8,8)
    a503:	add    $0x4,%r8
    a507:	cmp    %r8,%r9
    a50a:	jne    a4d0 <void run<bloom_filters::K12ScalarOrControl, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0x1060>
    a50c:	cmp    %rdi,%rsi
    a50f:	je     a31b <void run<bloom_filters::K12ScalarOrControl, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xeab>
    a515:	jmp    a1aa <void run<bloom_filters::K12ScalarOrControl, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xd3a>
    a51a:	nopw   0x0(%rax,%rax,1)
    a520:	call   170d0 <std::chrono::_V2::steady_clock::now()@plt>
