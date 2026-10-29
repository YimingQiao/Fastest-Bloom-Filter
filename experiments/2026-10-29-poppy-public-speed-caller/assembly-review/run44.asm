0000000000056060 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>>:
   56060:	push   %rbp
   56061:	push   %r15
   56063:	push   %r14
   56065:	push   %r13
   56067:	push   %r12
   56069:	push   %rbx
   5606a:	sub    $0x5c8,%rsp
   56071:	mov    %rdx,0x118(%rsp)
   56079:	mov    %rdi,0x4e0(%rsp)
   56081:	movq   $0xe,0x4e8(%rsp)
   5608d:	mov    %r9,0xb8(%rsp)
   56095:	mov    (%r9),%rdx
   56098:	mov    %rdx,%rax
   5609b:	shr    $0x3d,%rax
   5609f:	jne    56460 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x400>
   560a5:	movabs $0xffffffffffffe01,%rax
   560af:	lea    0x0(,%rdx,8),%rbx
   560b7:	cmp    $0x1,%rbx
   560bb:	mov    %rbx,%r14
   560be:	adc    $0x0,%r14
   560c2:	cmp    %rax,%rdx
   560c5:	jae    5646d <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x40d>
   560cb:	mov    %r8,%r12
   560ce:	mov    %rsi,0xf8(%rsp)
   560d6:	mov    %rcx,0xc0(%rsp)
   560de:	mov    %rdx,0x28(%rsp)
   560e3:	movq   $0x0,0x2a0(%rsp)
   560ef:	lea    0x2a0(%rsp),%rdi
   560f7:	mov    $0x1000,%esi
   560fc:	mov    %r14,%rdx
   560ff:	call   *0x17fefb(%rip)        # 1d6000 <posix_memalign@GLIBC_2.2.5>
   56105:	test   %eax,%eax
   56107:	jne    56495 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x435>
   5610d:	mov    0x2a0(%rsp),%r15
   56115:	test   %r15,%r15
   56118:	je     56495 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x435>
   5611e:	movabs $0x1fffffffffffffff,%rbp
   56128:	cmpq   $0x0,0x28(%rsp)
   5612e:	je     5613e <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0xde>
   56130:	mov    %r15,%rdi
   56133:	xor    %esi,%esi
   56135:	mov    %rbx,%rdx
   56138:	call   *0x17feea(%rip)        # 1d6028 <memset@GLIBC_2.2.5>
   5613e:	mov    0xb8(%rsp),%rax
   56146:	mov    0x8(%rax),%rax
   5614a:	cmp    %rbp,%rax
   5614d:	ja     564a3 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x443>
   56153:	lea    0x0(,%rax,8),%rbx
   5615b:	cmp    $0x1,%rbx
   5615f:	mov    %rbx,%r14
   56162:	adc    $0x0,%r14
   56166:	mov    %rax,0x8(%rsp)
   5616b:	movabs $0xffffffffffffe01,%rcx
   56175:	cmp    %rcx,%rax
   56178:	jae    564b5 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x455>
   5617e:	movq   $0x0,0x2a0(%rsp)
   5618a:	lea    0x2a0(%rsp),%rdi
   56192:	mov    $0x1000,%esi
   56197:	mov    %r14,%rdx
   5619a:	call   *0x17fe60(%rip)        # 1d6000 <posix_memalign@GLIBC_2.2.5>
   561a0:	test   %eax,%eax
   561a2:	jne    564e2 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x482>
   561a8:	mov    0x2a0(%rsp),%rax
   561b0:	mov    %rax,0xa8(%rsp)
   561b8:	test   %rax,%rax
   561bb:	je     564e2 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x482>
   561c1:	cmpq   $0x0,0x8(%rsp)
   561c7:	je     561dc <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x17c>
   561c9:	mov    0xa8(%rsp),%rdi
   561d1:	xor    %esi,%esi
   561d3:	mov    %rbx,%rdx
   561d6:	call   *0x17fe4c(%rip)        # 1d6028 <memset@GLIBC_2.2.5>
   561dc:	mov    0xb8(%rsp),%rax
   561e4:	mov    0x18(%rax),%rcx
   561e8:	mov    0x20(%rax),%r14
   561ec:	cmp    %rcx,%r14
   561ef:	mov    %rcx,%rbx
   561f2:	cmova  %r14,%rbx
   561f6:	cmp    %rbp,%rbx
   561f9:	ja     564f5 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x495>
   561ff:	mov    %r12,0x60(%rsp)
   56204:	mov    %rcx,0x10(%rsp)
   56209:	lea    0x0(,%rbx,8),%r13
   56211:	cmp    $0x1,%r13
   56215:	mov    %r13,%r12
   56218:	adc    $0x0,%r12
   5621c:	movabs $0xffffffffffffe01,%rax
   56226:	cmp    %rax,%rbx
   56229:	jae    56507 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x4a7>
   5622f:	mov    %r15,0x50(%rsp)
   56234:	movq   $0x0,0x2a0(%rsp)
   56240:	lea    0x2a0(%rsp),%rdi
   56248:	mov    $0x1000,%esi
   5624d:	mov    %r12,%rdx
   56250:	call   *0x17fdaa(%rip)        # 1d6000 <posix_memalign@GLIBC_2.2.5>
   56256:	test   %eax,%eax
   56258:	jne    56534 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x4d4>
   5625e:	mov    0x2a0(%rsp),%r15
   56266:	test   %r15,%r15
   56269:	je     56534 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x4d4>
   5626f:	test   %rbx,%rbx
   56272:	je     56282 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x222>
   56274:	mov    %r15,%rdi
   56277:	xor    %esi,%esi
   56279:	mov    %r13,%rdx
   5627c:	call   *0x17fda6(%rip)        # 1d6028 <memset@GLIBC_2.2.5>
   56282:	movabs $0xd6e8feb86659fd93,%r12
   5628c:	mov    0x28(%rsp),%rax
   56291:	mov    0x118(%rsp),%rcx
   56299:	cmp    %rax,%rcx
   5629c:	cmovb  %rcx,%rax
   562a0:	test   %rax,%rax
   562a3:	je     5659e <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x53e>
   562a9:	cmp    $0x4,%rax
   562ad:	jae    562c3 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x263>
   562af:	xor    %ecx,%ecx
   562b1:	mov    0x50(%rsp),%rdi
   562b6:	mov    0xf8(%rsp),%r8
   562be:	jmp    56568 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x508>
   562c3:	cmp    $0x10,%rax
   562c7:	jae    562dd <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x27d>
   562c9:	xor    %ecx,%ecx
   562cb:	mov    0x50(%rsp),%rdi
   562d0:	mov    0xf8(%rsp),%r8
   562d8:	jmp    563fc <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x39c>
   562dd:	movabs $0xffffffffffffe01,%rcx
   562e7:	add    $0x1ef,%rcx
   562ee:	and    %rax,%rcx
   562f1:	xor    %edx,%edx
   562f3:	vpbroadcastq -0x4cab4(%rip),%ymm0        # 9848 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x225>
   562fc:	mov    0x50(%rsp),%rdi
   56301:	mov    0xf8(%rsp),%r8
   56309:	nopl   0x0(%rax)
   56310:	vmovdqu (%r8,%rdx,8),%ymm1
   56316:	vmovdqu 0x20(%r8,%rdx,8),%ymm2
   5631d:	vmovdqu 0x40(%r8,%rdx,8),%ymm3
   56324:	vmovdqu 0x60(%r8,%rdx,8),%ymm4
   5632b:	vpsrlq $0x20,%ymm1,%ymm5
   56330:	vpsrlq $0x20,%ymm2,%ymm6
   56335:	vpsrlq $0x20,%ymm3,%ymm7
   5633a:	vpsrlq $0x20,%ymm4,%ymm8
   5633f:	vpxor  %ymm1,%ymm5,%ymm1
   56343:	vpxor  %ymm2,%ymm6,%ymm2
   56347:	vpxor  %ymm3,%ymm7,%ymm3
   5634b:	vpmullq %ymm0,%ymm1,%ymm1
   56351:	vpmullq %ymm0,%ymm2,%ymm2
   56357:	vpmullq %ymm0,%ymm3,%ymm3
   5635d:	vpxor  %ymm4,%ymm8,%ymm4
   56361:	vpmullq %ymm0,%ymm4,%ymm4
   56367:	vpsrlq $0x20,%ymm1,%ymm5
   5636c:	vpsrlq $0x20,%ymm2,%ymm6
   56371:	vpsrlq $0x20,%ymm3,%ymm7
   56376:	vpsrlq $0x20,%ymm4,%ymm8
   5637b:	vpxor  %ymm1,%ymm5,%ymm1
   5637f:	vpxor  %ymm2,%ymm6,%ymm2
   56383:	vpxor  %ymm3,%ymm7,%ymm3
   56387:	vpxor  %ymm4,%ymm8,%ymm4
   5638b:	vpmullq %ymm0,%ymm1,%ymm1
   56391:	vpmullq %ymm0,%ymm2,%ymm2
   56397:	vpmullq %ymm0,%ymm3,%ymm3
   5639d:	vpmullq %ymm0,%ymm4,%ymm4
   563a3:	vpsrlq $0x20,%ymm1,%ymm5
   563a8:	vpsrlq $0x20,%ymm2,%ymm6
   563ad:	vpsrlq $0x20,%ymm3,%ymm7
   563b2:	vpsrlq $0x20,%ymm4,%ymm8
   563b7:	vpxor  %ymm1,%ymm5,%ymm1
   563bb:	vpxor  %ymm2,%ymm6,%ymm2
   563bf:	vpxor  %ymm3,%ymm7,%ymm3
   563c3:	vpxor  %ymm4,%ymm8,%ymm4
   563c7:	vmovdqu %ymm1,(%rdi,%rdx,8)
   563cc:	vmovdqu %ymm2,0x20(%rdi,%rdx,8)
   563d2:	vmovdqu %ymm3,0x40(%rdi,%rdx,8)
   563d8:	vmovdqu %ymm4,0x60(%rdi,%rdx,8)
   563de:	add    $0x10,%rdx
   563e2:	cmp    %rdx,%rcx
   563e5:	jne    56310 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x2b0>
   563eb:	cmp    %rcx,%rax
   563ee:	je     5659e <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x53e>
   563f4:	test   $0xc,%al
   563f6:	je     56568 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x508>
   563fc:	mov    %rcx,%rdx
   563ff:	movabs $0xffffffffffffe01,%rcx
   56409:	add    $0x1fb,%rcx
   56410:	and    %rax,%rcx
   56413:	vpbroadcastq -0x4cbd4(%rip),%ymm0        # 9848 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x225>
   5641c:	nopl   0x0(%rax)
   56420:	vmovdqu (%r8,%rdx,8),%ymm1
   56426:	vpsrlq $0x20,%ymm1,%ymm2
   5642b:	vpxor  %ymm1,%ymm2,%ymm1
   5642f:	vpmullq %ymm0,%ymm1,%ymm1
   56435:	vpsrlq $0x20,%ymm1,%ymm2
   5643a:	vpxor  %ymm1,%ymm2,%ymm1
   5643e:	vpmullq %ymm0,%ymm1,%ymm1
   56444:	vpsrlq $0x20,%ymm1,%ymm2
   56449:	vpxor  %ymm1,%ymm2,%ymm1
   5644d:	vmovdqu %ymm1,(%rdi,%rdx,8)
   56452:	add    $0x4,%rdx
   56456:	cmp    %rdx,%rcx
   56459:	jne    56420 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x3c0>
   5645b:	jmp    56599 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x539>
   56460:	lea    0x17ba49(%rip),%rdi        # 1d1eb0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.52.llvm.3671060894988460240+0x10c0>
   56467:	call   *0x17fc7b(%rip)        # 1d60e8 <_DYNAMIC+0x2e8>
   5646d:	lea    -0x4ae8c(%rip),%rdi        # b5e8 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x13b8>
   56474:	lea    0x17b7f5(%rip),%rcx        # 1d1c70 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.52.llvm.3671060894988460240+0xe80>
   5647b:	lea    0x17ba16(%rip),%r8        # 1d1e98 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.52.llvm.3671060894988460240+0x10a8>
   56482:	lea    0xd0(%rsp),%rdx
   5648a:	mov    $0x2b,%esi
   5648f:	call   *0x17fc13(%rip)        # 1d60a8 <_DYNAMIC+0x2a8>
   56495:	mov    $0x1000,%edi
   5649a:	mov    %r14,%rsi
   5649d:	call   *0x17fc0d(%rip)        # 1d60b0 <_DYNAMIC+0x2b0>
   564a3:	lea    0x17ba06(%rip),%rdi        # 1d1eb0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.52.llvm.3671060894988460240+0x10c0>
   564aa:	call   *0x17fc38(%rip)        # 1d60e8 <_DYNAMIC+0x2e8>
   564b0:	jmp    5a643 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x45e3>
   564b5:	lea    -0x4aed4(%rip),%rdi        # b5e8 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x13b8>
   564bc:	lea    0x17b7ad(%rip),%rcx        # 1d1c70 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.52.llvm.3671060894988460240+0xe80>
   564c3:	lea    0x17b9ce(%rip),%r8        # 1d1e98 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.52.llvm.3671060894988460240+0x10a8>
   564ca:	lea    0xd0(%rsp),%rdx
   564d2:	mov    $0x2b,%esi
   564d7:	call   *0x17fbcb(%rip)        # 1d60a8 <_DYNAMIC+0x2a8>
   564dd:	jmp    5a643 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x45e3>
   564e2:	mov    $0x1000,%edi
   564e7:	mov    %r14,%rsi
   564ea:	call   *0x17fbc0(%rip)        # 1d60b0 <_DYNAMIC+0x2b0>
   564f0:	jmp    5a643 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x45e3>
   564f5:	lea    0x17b9b4(%rip),%rdi        # 1d1eb0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.52.llvm.3671060894988460240+0x10c0>
   564fc:	call   *0x17fbe6(%rip)        # 1d60e8 <_DYNAMIC+0x2e8>
   56502:	jmp    5a643 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x45e3>
   56507:	lea    -0x4af26(%rip),%rdi        # b5e8 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x13b8>
   5650e:	lea    0x17b75b(%rip),%rcx        # 1d1c70 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.52.llvm.3671060894988460240+0xe80>
   56515:	lea    0x17b97c(%rip),%r8        # 1d1e98 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.52.llvm.3671060894988460240+0x10a8>
   5651c:	lea    0xd0(%rsp),%rdx
   56524:	mov    $0x2b,%esi
   56529:	call   *0x17fb79(%rip)        # 1d60a8 <_DYNAMIC+0x2a8>
   5652f:	jmp    5a643 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x45e3>
   56534:	mov    $0x1000,%edi
   56539:	mov    %r12,%rsi
   5653c:	mov    0x50(%rsp),%r15
   56541:	call   *0x17fb69(%rip)        # 1d60b0 <_DYNAMIC+0x2b0>
   56547:	jmp    5a643 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x45e3>
   5654c:	mov    %rax,%r14
   5654f:	jmp    5a913 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x48b3>
   56554:	mov    %rax,%r14
   56557:	mov    %r15,%rdi
   5655a:	call   *0x17faa8(%rip)        # 1d6008 <free@GLIBC_2.2.5>
   56560:	mov    %r14,%rdi
   56563:	call   1cfd20 <_Unwind_Resume@plt>
   56568:	mov    (%r8,%rcx,8),%rdx
   5656c:	mov    %rdx,%rsi
   5656f:	shr    $0x20,%rsi
   56573:	xor    %rdx,%rsi
   56576:	imul   %r12,%rsi
   5657a:	mov    %rsi,%rdx
   5657d:	shr    $0x20,%rdx
   56581:	xor    %rsi,%rdx
   56584:	imul   %r12,%rdx
   56588:	mov    %rdx,%rsi
   5658b:	shr    $0x20,%rsi
   5658f:	xor    %rdx,%rsi
   56592:	mov    %rsi,(%rdi,%rcx,8)
   56596:	inc    %rcx
   56599:	cmp    %rcx,%rax
   5659c:	jne    56568 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x508>
   5659e:	mov    0x8(%rsp),%rcx
   565a3:	mov    0x60(%rsp),%rdx
   565a8:	cmp    %rcx,%rdx
   565ab:	mov    %rcx,%rax
   565ae:	cmovb  %rdx,%rax
   565b2:	test   %rcx,%rcx
   565b5:	je     567b3 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x753>
   565bb:	cmp    $0x4,%rax
   565bf:	jae    565d8 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x578>
   565c1:	xor    %ecx,%ecx
   565c3:	mov    0xa8(%rsp),%rdi
   565cb:	mov    0xc0(%rsp),%r8
   565d3:	jmp    5677d <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x71d>
   565d8:	cmp    $0x10,%rax
   565dc:	jae    565f5 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x595>
   565de:	xor    %ecx,%ecx
   565e0:	mov    0xa8(%rsp),%rdi
   565e8:	mov    0xc0(%rsp),%r8
   565f0:	jmp    56718 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x6b8>
   565f5:	movabs $0xffffffffffffe01,%rcx
   565ff:	add    $0x1ef,%rcx
   56606:	and    %rax,%rcx
   56609:	xor    %edx,%edx
   5660b:	vpbroadcastq -0x4cdcc(%rip),%ymm0        # 9848 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x225>
   56614:	mov    0xa8(%rsp),%rdi
   5661c:	mov    0xc0(%rsp),%r8
   56624:	data16 data16 cs nopw 0x0(%rax,%rax,1)
   56630:	vmovdqu (%r8,%rdx,8),%ymm1
   56636:	vmovdqu 0x20(%r8,%rdx,8),%ymm2
   5663d:	vmovdqu 0x40(%r8,%rdx,8),%ymm3
   56644:	vmovdqu 0x60(%r8,%rdx,8),%ymm4
   5664b:	vpsrlq $0x20,%ymm1,%ymm5
   56650:	vpsrlq $0x20,%ymm2,%ymm6
   56655:	vpsrlq $0x20,%ymm3,%ymm7
   5665a:	vpsrlq $0x20,%ymm4,%ymm8
   5665f:	vpxor  %ymm1,%ymm5,%ymm1
   56663:	vpxor  %ymm2,%ymm6,%ymm2
   56667:	vpxor  %ymm3,%ymm7,%ymm3
   5666b:	vpmullq %ymm0,%ymm1,%ymm1
   56671:	vpmullq %ymm0,%ymm2,%ymm2
   56677:	vpmullq %ymm0,%ymm3,%ymm3
   5667d:	vpxor  %ymm4,%ymm8,%ymm4
   56681:	vpmullq %ymm0,%ymm4,%ymm4
   56687:	vpsrlq $0x20,%ymm1,%ymm5
   5668c:	vpsrlq $0x20,%ymm2,%ymm6
   56691:	vpsrlq $0x20,%ymm3,%ymm7
   56696:	vpsrlq $0x20,%ymm4,%ymm8
   5669b:	vpxor  %ymm1,%ymm5,%ymm1
   5669f:	vpxor  %ymm2,%ymm6,%ymm2
   566a3:	vpxor  %ymm3,%ymm7,%ymm3
   566a7:	vpxor  %ymm4,%ymm8,%ymm4
   566ab:	vpmullq %ymm0,%ymm1,%ymm1
   566b1:	vpmullq %ymm0,%ymm2,%ymm2
   566b7:	vpmullq %ymm0,%ymm3,%ymm3
   566bd:	vpmullq %ymm0,%ymm4,%ymm4
   566c3:	vpsrlq $0x20,%ymm1,%ymm5
   566c8:	vpsrlq $0x20,%ymm2,%ymm6
   566cd:	vpsrlq $0x20,%ymm3,%ymm7
   566d2:	vpsrlq $0x20,%ymm4,%ymm8
   566d7:	vpxor  %ymm1,%ymm5,%ymm1
   566db:	vpxor  %ymm2,%ymm6,%ymm2
   566df:	vpxor  %ymm3,%ymm7,%ymm3
   566e3:	vpxor  %ymm4,%ymm8,%ymm4
   566e7:	vmovdqu %ymm1,(%rdi,%rdx,8)
   566ec:	vmovdqu %ymm2,0x20(%rdi,%rdx,8)
   566f2:	vmovdqu %ymm3,0x40(%rdi,%rdx,8)
   566f8:	vmovdqu %ymm4,0x60(%rdi,%rdx,8)
   566fe:	add    $0x10,%rdx
   56702:	cmp    %rdx,%rcx
   56705:	jne    56630 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x5d0>
   5670b:	cmp    %rcx,%rax
   5670e:	je     567b3 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x753>
   56714:	test   $0xc,%al
   56716:	je     5677d <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x71d>
   56718:	mov    %rcx,%rdx
   5671b:	movabs $0xffffffffffffe01,%rcx
   56725:	add    $0x1fb,%rcx
   5672c:	and    %rax,%rcx
   5672f:	vpbroadcastq -0x4cef0(%rip),%ymm0        # 9848 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x225>
   56738:	nopl   0x0(%rax,%rax,1)
   56740:	vmovdqu (%r8,%rdx,8),%ymm1
   56746:	vpsrlq $0x20,%ymm1,%ymm2
   5674b:	vpxor  %ymm1,%ymm2,%ymm1
   5674f:	vpmullq %ymm0,%ymm1,%ymm1
   56755:	vpsrlq $0x20,%ymm1,%ymm2
   5675a:	vpxor  %ymm1,%ymm2,%ymm1
   5675e:	vpmullq %ymm0,%ymm1,%ymm1
   56764:	vpsrlq $0x20,%ymm1,%ymm2
   56769:	vpxor  %ymm1,%ymm2,%ymm1
   5676d:	vmovdqu %ymm1,(%rdi,%rdx,8)
   56772:	add    $0x4,%rdx
   56776:	cmp    %rdx,%rcx
   56779:	jne    56740 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x6e0>
   5677b:	jmp    567ae <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x74e>
   5677d:	mov    (%r8,%rcx,8),%rdx
   56781:	mov    %rdx,%rsi
   56784:	shr    $0x20,%rsi
   56788:	xor    %rdx,%rsi
   5678b:	imul   %r12,%rsi
   5678f:	mov    %rsi,%rdx
   56792:	shr    $0x20,%rdx
   56796:	xor    %rsi,%rdx
   56799:	imul   %r12,%rdx
   5679d:	mov    %rdx,%rsi
   567a0:	shr    $0x20,%rsi
   567a4:	xor    %rdx,%rsi
   567a7:	mov    %rsi,(%rdi,%rcx,8)
   567ab:	inc    %rcx
   567ae:	cmp    %rcx,%rax
   567b1:	jne    5677d <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x71d>
   567b3:	movabs $0x3ffffffffffffff0,%rdx
   567bd:	mov    0x8(%rsp),%rax
   567c2:	mov    0x10(%rsp),%rcx
   567c7:	cmp    %rax,%rcx
   567ca:	cmova  %rcx,%rax
   567ce:	mov    %rax,%rcx
   567d1:	lea    0x20(%rax),%rbx
   567d5:	lea    0xf(%rdx),%rax
   567d9:	cmp    %rax,%rbx
   567dc:	ja     5a305 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x42a5>
   567e2:	mov    %rbp,%rax
   567e5:	lea    0x0(,%rbx,4),%rbp
   567ed:	cmp    $0x1,%rbp
   567f1:	mov    %rbp,%r13
   567f4:	adc    $0x0,%r13
   567f8:	add    $0xfffffffffffffc02,%rax
   567fe:	cmp    %rax,%rbx
   56801:	jae    5a31a <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x42ba>
   56807:	mov    %rcx,0x48(%rsp)
   5680c:	movq   $0x0,0x2a0(%rsp)
   56818:	lea    0x2a0(%rsp),%rdi
   56820:	mov    $0x1000,%esi
   56825:	mov    %rdi,0x30(%rsp)
   5682a:	mov    %r13,%rdx
   5682d:	vzeroupper
   56830:	call   *0x17f7ca(%rip)        # 1d6000 <posix_memalign@GLIBC_2.2.5>
   56836:	test   %eax,%eax
   56838:	jne    5a34a <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x42ea>
   5683e:	mov    0x2a0(%rsp),%rax
   56846:	mov    %rax,0xb0(%rsp)
   5684e:	test   %rax,%rax
   56851:	je     5a34a <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x42ea>
   56857:	test   %rbx,%rbx
   5685a:	je     5a608 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x45a8>
   56860:	mov    0xb0(%rsp),%rdi
   56868:	xor    %esi,%esi
   5686a:	mov    %rbp,%rdx
   5686d:	call   *0x17f7b5(%rip)        # 1d6028 <memset@GLIBC_2.2.5>
   56873:	cmp    $0xf,%rbx
   56877:	jbe    5a608 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x45a8>
   5687d:	mov    0x48(%rsp),%rcx
   56882:	cmp    $0xfffffffffffffff0,%rcx
   56886:	jae    5a35d <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x42fd>
   5688c:	mov    0xb0(%rsp),%rax
   56894:	lea    0x40(%rax),%rbx
   56898:	vbroadcastss -0x4d0ed(%rip),%ymm0        # 97b4 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x191>
   568a1:	vmovupd %ymm0,(%rax)
   568a5:	vmovupd %ymm0,0x20(%rax)
   568aa:	vmovupd %ymm0,0x40(%rax,%rcx,4)
   568b0:	vmovupd %ymm0,0x60(%rax,%rcx,4)
   568b6:	movq   $0x0,0x1a0(%rsp)
   568c2:	movq   $0x8,0x1a8(%rsp)
   568ce:	movq   $0x0,0x1b0(%rsp)
   568da:	movq   $0x0,0x1b8(%rsp)
   568e6:	movq   $0x8,0x1c0(%rsp)
   568f2:	movq   $0x0,0x1c8(%rsp)
   568fe:	movq   $0x0,0x1d0(%rsp)
   5690a:	movq   $0x8,0x1d8(%rsp)
   56916:	movq   $0x0,0x1e0(%rsp)
   56922:	movq   $0x0,0x1e8(%rsp)
   5692e:	movq   $0x8,0x1f0(%rsp)
   5693a:	movq   $0x0,0x1f8(%rsp)
   56946:	mov    0xb8(%rsp),%rax
   5694e:	mov    0x28(%rax),%rcx
   56952:	mov    0x40(%rax),%eax
   56955:	mov    %eax,0x6c(%rsp)
   56959:	mov    %rcx,0x198(%rsp)
   56961:	test   %rcx,%rcx
   56964:	mov    %rbx,0x18(%rsp)
   56969:	je     571e5 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1185>
   5696f:	test   %r14,%r14
   56972:	je     5a4be <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x445e>
   56978:	vcvtsi2sdq 0x28(%rsp),%xmm15,%xmm0
   5697f:	vmovsd %xmm0,0x30(%rsp)
   56985:	mov    $0x1,%al
   56987:	mov    %eax,0x40(%rsp)
   5698b:	mov    $0x1,%eax
   56990:	mov    %rax,0xc8(%rsp)
   56998:	jmp    569d3 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x973>
   5699a:	nopw   0x0(%rax,%rax,1)
   569a0:	mov    0x198(%rsp),%rcx
   569a8:	mov    0xc8(%rsp),%rdx
   569b0:	cmp    %rcx,%rdx
   569b3:	mov    %rdx,%rax
   569b6:	adc    $0x0,%rax
   569ba:	movl   $0x0,0x40(%rsp)
   569c2:	cmp    %rcx,%rdx
   569c5:	mov    %rax,0xc8(%rsp)
   569cd:	jae    571e5 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1185>
   569d3:	vzeroupper
   569d6:	call   *0x17f724(%rip)        # 1d6100 <_DYNAMIC+0x300>
   569dc:	mov    %rax,%rbx
   569df:	mov    %edx,%ebp
   569e1:	lea    0x2a0(%rsp),%rdi
   569e9:	mov    0x28(%rsp),%rsi
   569ee:	mov    0x6c(%rsp),%edx
   569f2:	call   17a680 <<compare_benchmark::PoppyPublic<44> as compare_benchmark::Filter>::new>
   569f7:	movabs $0x8000000000000000,%rax
   56a01:	cmp    %rax,0x2a0(%rsp)
   56a09:	je     5a583 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x4523>
   56a0f:	mov    %ebp,0xe8(%rsp)
   56a16:	mov    %rbx,0x20(%rsp)
   56a1b:	vmovupd 0x2a0(%rsp),%ymm0
   56a24:	vmovupd 0x2c0(%rsp),%ymm1
   56a2d:	vmovdqu 0x2e0(%rsp),%ymm2
   56a36:	vmovdqu 0x300(%rsp),%ymm3
   56a3f:	vmovdqu %ymm3,0x260(%rsp)
   56a48:	vmovdqu %ymm2,0x240(%rsp)
   56a51:	vmovupd %ymm1,0x220(%rsp)
   56a5a:	vmovupd %ymm0,0x200(%rsp)
   56a63:	vzeroupper
   56a66:	call   *0x17f694(%rip)        # 1d6100 <_DYNAMIC+0x300>
   56a6c:	mov    %rax,0x38(%rsp)
   56a71:	mov    %edx,0x58(%rsp)
   56a75:	mov    0x28(%rsp),%rbx
   56a7a:	mov    0x50(%rsp),%rsi
   56a7f:	nop
   56a80:	test   %rbx,%rbx
   56a83:	je     56ab0 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0xa50>
   56a85:	cmp    %rbx,%r14
   56a88:	mov    %rbx,%rdx
   56a8b:	cmovb  %r14,%rdx
   56a8f:	lea    (%rsi,%rdx,8),%r13
   56a93:	sub    %rdx,%rbx
   56a96:	lea    0x200(%rsp),%rdi
   56a9e:	call   fcbe0 <compare_benchmark::insert::<compare_benchmark::PoppyPublic<0>>>
   56aa3:	mov    %r13,%rsi
   56aa6:	jmp    56a80 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0xa20>
   56aa8:	nopl   0x0(%rax,%rax,1)
   56ab0:	call   *0x17f64a(%rip)        # 1d6100 <_DYNAMIC+0x300>
   56ab6:	mov    %rax,%rbp
   56ab9:	mov    %edx,%r13d
   56abc:	mov    %rax,0x70(%rsp)
   56ac1:	mov    %edx,0x78(%rsp)
   56ac5:	mov    0x38(%rsp),%rax
   56aca:	mov    %rax,0x130(%rsp)
   56ad2:	mov    0x58(%rsp),%eax
   56ad6:	mov    %eax,0x138(%rsp)
   56add:	lea    0x2a0(%rsp),%rdi
   56ae5:	lea    0x70(%rsp),%rsi
   56aea:	lea    0x130(%rsp),%rdx
   56af2:	call   1ad410 <std::sys::pal::unix::time::Timespec::sub_timespec>
   56af7:	kmovb  0x2a0(%rsp),%k1
   56b00:	kmovd  %k1,0x38(%rsp)
   56b07:	vcvtusi2sdq 0x2a8(%rsp),%xmm15,%xmm0
   56b0f:	vmovsd %xmm0,0x58(%rsp)
   56b15:	vcvtsi2sdl 0x2b0(%rsp),%xmm15,%xmm0
   56b1e:	vmovsd %xmm0,0x120(%rsp)
   56b27:	mov    0x1b0(%rsp),%rbx
   56b2f:	cmp    0x1a0(%rsp),%rbx
   56b37:	jne    56b47 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0xae7>
   56b39:	lea    0x1a0(%rsp),%rdi
   56b41:	call   *0x17f5c1(%rip)        # 1d6108 <_DYNAMIC+0x308>
   56b47:	vmovsd -0x4d2e7(%rip),%xmm1        # 9868 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x245>
   56b4f:	vmovsd 0x120(%rsp),%xmm0
   56b58:	vdivsd %xmm1,%xmm0,%xmm0
   56b5c:	vaddsd 0x58(%rsp),%xmm0,%xmm0
   56b62:	vmulsd %xmm1,%xmm0,%xmm0
   56b66:	vxorpd %xmm1,%xmm1,%xmm1
   56b6a:	kmovd  0x38(%rsp),%k1
   56b71:	vmovsd %xmm1,%xmm0,%xmm0{%k1}
   56b77:	vdivsd 0x30(%rsp),%xmm0,%xmm0
   56b7d:	mov    0x1a8(%rsp),%rax
   56b85:	vmovsd %xmm0,(%rax,%rbx,8)
   56b8a:	inc    %rbx
   56b8d:	mov    %rbx,0x1b0(%rsp)
   56b95:	mov    %rbp,0x70(%rsp)
   56b9a:	mov    %r13d,0x78(%rsp)
   56b9f:	mov    0x20(%rsp),%rax
   56ba4:	mov    %rax,0x130(%rsp)
   56bac:	mov    0xe8(%rsp),%eax
   56bb3:	mov    %eax,0x138(%rsp)
   56bba:	lea    0x2a0(%rsp),%rdi
   56bc2:	lea    0x70(%rsp),%rsi
   56bc7:	lea    0x130(%rsp),%rdx
   56bcf:	call   1ad410 <std::sys::pal::unix::time::Timespec::sub_timespec>
   56bd4:	kmovb  0x2a0(%rsp),%k1
   56bdd:	kmovd  %k1,0x38(%rsp)
   56be4:	vcvtusi2sdq 0x2a8(%rsp),%xmm15,%xmm0
   56bec:	vmovsd %xmm0,0x58(%rsp)
   56bf2:	vcvtsi2sdl 0x2b0(%rsp),%xmm15,%xmm0
   56bfb:	vmovsd %xmm0,0x20(%rsp)
   56c01:	mov    0x1c8(%rsp),%rbx
   56c09:	cmp    0x1b8(%rsp),%rbx
   56c11:	jne    56c21 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0xbc1>
   56c13:	lea    0x1b8(%rsp),%rdi
   56c1b:	call   *0x17f4e7(%rip)        # 1d6108 <_DYNAMIC+0x308>
   56c21:	vmovsd -0x4d3c1(%rip),%xmm1        # 9868 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x245>
   56c29:	vmovsd 0x20(%rsp),%xmm0
   56c2f:	vdivsd %xmm1,%xmm0,%xmm0
   56c33:	vaddsd 0x58(%rsp),%xmm0,%xmm0
   56c39:	vmulsd %xmm1,%xmm0,%xmm0
   56c3d:	vxorpd %xmm1,%xmm1,%xmm1
   56c41:	kmovd  0x38(%rsp),%k1
   56c48:	vmovsd %xmm1,%xmm0,%xmm0{%k1}
   56c4e:	vdivsd 0x30(%rsp),%xmm0,%xmm0
   56c54:	mov    0x1c0(%rsp),%rax
   56c5c:	vmovsd %xmm0,(%rax,%rbx,8)
   56c61:	inc    %rbx
   56c64:	mov    %rbx,0x1c8(%rsp)
   56c6c:	movzbl 0x40(%rsp),%ebx
   56c71:	and    $0x1,%ebx
   56c74:	mov    0x28(%rsp),%rcx
   56c79:	mov    %rcx,%rdi
   56c7c:	mov    0x10(%rsp),%rsi
   56c81:	mov    0x50(%rsp),%rdx
   56c86:	lea    0x200(%rsp),%r8
   56c8e:	mov    0x18(%rsp),%r9
   56c93:	push   %rbx
   56c94:	push   0x50(%rsp)
   56c98:	call   101c80 <compare_benchmark::run::<compare_benchmark::PoppyPublic<0>>::{closure#0}>
   56c9d:	add    $0x10,%rsp
   56ca1:	cmpq   $0x0,0x200(%rsp)
   56caa:	je     56cba <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0xc5a>
   56cac:	mov    0x208(%rsp),%rdi
   56cb4:	call   *0x17f34e(%rip)        # 1d6008 <free@GLIBC_2.2.5>
   56cba:	cmpq   $0x0,0x218(%rsp)
   56cc3:	je     56cd3 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0xc73>
   56cc5:	mov    0x220(%rsp),%rdi
   56ccd:	call   *0x17f335(%rip)        # 1d6008 <free@GLIBC_2.2.5>
   56cd3:	cmpq   $0x0,0x230(%rsp)
   56cdc:	je     56cec <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0xc8c>
   56cde:	mov    0x238(%rsp),%rdi
   56ce6:	call   *0x17f31c(%rip)        # 1d6008 <free@GLIBC_2.2.5>
   56cec:	call   *0x17f40e(%rip)        # 1d6100 <_DYNAMIC+0x300>
   56cf2:	mov    %rax,%r13
   56cf5:	mov    %edx,%ebp
   56cf7:	lea    0x2a0(%rsp),%rdi
   56cff:	mov    0x28(%rsp),%rsi
   56d04:	mov    0x6c(%rsp),%edx
   56d08:	call   17a680 <<compare_benchmark::PoppyPublic<44> as compare_benchmark::Filter>::new>
   56d0d:	movabs $0x8000000000000000,%rax
   56d17:	cmp    %rax,0x2a0(%rsp)
   56d1f:	je     5a2c6 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x4266>
   56d25:	mov    %ebp,0x20(%rsp)
   56d29:	mov    %r13,0x58(%rsp)
   56d2e:	mov    %rbx,0xe8(%rsp)
   56d36:	vmovdqu 0x2a0(%rsp),%ymm0
   56d3f:	vmovdqu 0x2c0(%rsp),%ymm1
   56d48:	vmovdqu 0x2e0(%rsp),%ymm2
   56d51:	vmovdqu 0x300(%rsp),%ymm3
   56d5a:	vmovdqu %ymm3,0x260(%rsp)
   56d63:	vmovdqu %ymm2,0x240(%rsp)
   56d6c:	vmovdqu %ymm1,0x220(%rsp)
   56d75:	vmovdqu %ymm0,0x200(%rsp)
   56d7e:	vzeroupper
   56d81:	call   *0x17f379(%rip)        # 1d6100 <_DYNAMIC+0x300>
   56d87:	mov    %rax,0x40(%rsp)
   56d8c:	mov    %edx,0x38(%rsp)
   56d90:	mov    0xf8(%rsp),%rbx
   56d98:	mov    0x118(%rsp),%r13
   56da0:	jmp    56dca <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0xd6a>
   56da2:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   56db0:	lea    (%rbx,%rdx,8),%rbx
   56db4:	sub    %rdx,%r13
   56db7:	lea    0x200(%rsp),%rdi
   56dbf:	mov    %r15,%rsi
   56dc2:	vzeroupper
   56dc5:	call   fcbe0 <compare_benchmark::insert::<compare_benchmark::PoppyPublic<0>>>
   56dca:	test   %r13,%r13
   56dcd:	je     56fa0 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0xf40>
   56dd3:	cmp    %r13,%r14
   56dd6:	mov    %r13,%rdx
   56dd9:	cmovb  %r14,%rdx
   56ddd:	cmp    $0x4,%rdx
   56de1:	jae    56df0 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0xd90>
   56de3:	xor    %eax,%eax
   56de5:	jmp    56f60 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0xf00>
   56dea:	nopw   0x0(%rax,%rax,1)
   56df0:	cmp    $0x10,%rdx
   56df4:	jae    56e00 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0xda0>
   56df6:	xor    %eax,%eax
   56df8:	jmp    56f09 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0xea9>
   56dfd:	nopl   (%rax)
   56e00:	mov    %rdx,%rax
   56e03:	and    $0xfffffffffffffff0,%rax
   56e07:	xor    %ecx,%ecx
   56e09:	vpbroadcastq -0x4d5ca(%rip),%ymm8        # 9848 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x225>
   56e12:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   56e20:	vmovdqu (%rbx,%rcx,8),%ymm0
   56e25:	vmovdqu 0x20(%rbx,%rcx,8),%ymm1
   56e2b:	vmovdqu 0x40(%rbx,%rcx,8),%ymm2
   56e31:	vmovdqu 0x60(%rbx,%rcx,8),%ymm3
   56e37:	vpsrlq $0x20,%ymm0,%ymm4
   56e3c:	vpsrlq $0x20,%ymm1,%ymm5
   56e41:	vpsrlq $0x20,%ymm2,%ymm6
   56e46:	vpsrlq $0x20,%ymm3,%ymm7
   56e4b:	vpxor  %ymm0,%ymm4,%ymm0
   56e4f:	vpxor  %ymm1,%ymm5,%ymm1
   56e53:	vpxor  %ymm2,%ymm6,%ymm2
   56e57:	vpmullq %ymm8,%ymm0,%ymm0
   56e5d:	vpmullq %ymm8,%ymm1,%ymm1
   56e63:	vpmullq %ymm8,%ymm2,%ymm2
   56e69:	vpxor  %ymm3,%ymm7,%ymm3
   56e6d:	vpmullq %ymm8,%ymm3,%ymm3
   56e73:	vpsrlq $0x20,%ymm0,%ymm4
   56e78:	vpsrlq $0x20,%ymm1,%ymm5
   56e7d:	vpsrlq $0x20,%ymm2,%ymm6
   56e82:	vpsrlq $0x20,%ymm3,%ymm7
   56e87:	vpxor  %ymm0,%ymm4,%ymm0
   56e8b:	vpxor  %ymm1,%ymm5,%ymm1
   56e8f:	vpxor  %ymm2,%ymm6,%ymm2
   56e93:	vpxor  %ymm3,%ymm7,%ymm3
   56e97:	vpmullq %ymm8,%ymm0,%ymm0
   56e9d:	vpmullq %ymm8,%ymm1,%ymm1
   56ea3:	vpmullq %ymm8,%ymm2,%ymm2
   56ea9:	vpmullq %ymm8,%ymm3,%ymm3
   56eaf:	vpsrlq $0x20,%ymm0,%ymm4
   56eb4:	vpsrlq $0x20,%ymm1,%ymm5
   56eb9:	vpsrlq $0x20,%ymm2,%ymm6
   56ebe:	vpsrlq $0x20,%ymm3,%ymm7
   56ec3:	vpxor  %ymm0,%ymm4,%ymm0
   56ec7:	vpxor  %ymm1,%ymm5,%ymm1
   56ecb:	vpxor  %ymm2,%ymm6,%ymm2
   56ecf:	vpxor  %ymm3,%ymm7,%ymm3
   56ed3:	vmovdqu %ymm0,(%r15,%rcx,8)
   56ed9:	vmovdqu %ymm1,0x20(%r15,%rcx,8)
   56ee0:	vmovdqu %ymm2,0x40(%r15,%rcx,8)
   56ee7:	vmovdqu %ymm3,0x60(%r15,%rcx,8)
   56eee:	add    $0x10,%rcx
   56ef2:	cmp    %rcx,%rax
   56ef5:	jne    56e20 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0xdc0>
   56efb:	cmp    %rax,%rdx
   56efe:	je     56db0 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0xd50>
   56f04:	test   $0xc,%dl
   56f07:	je     56f60 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0xf00>
   56f09:	mov    %rax,%rcx
   56f0c:	mov    %rdx,%rax
   56f0f:	and    $0xfffffffffffffffc,%rax
   56f13:	vpbroadcastq -0x4d6d4(%rip),%ymm2        # 9848 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x225>
   56f1c:	nopl   0x0(%rax)
   56f20:	vmovdqu (%rbx,%rcx,8),%ymm0
   56f25:	vpsrlq $0x20,%ymm0,%ymm1
   56f2a:	vpxor  %ymm0,%ymm1,%ymm0
   56f2e:	vpmullq %ymm2,%ymm0,%ymm0
   56f34:	vpsrlq $0x20,%ymm0,%ymm1
   56f39:	vpxor  %ymm0,%ymm1,%ymm0
   56f3d:	vpmullq %ymm2,%ymm0,%ymm0
   56f43:	vpsrlq $0x20,%ymm0,%ymm1
   56f48:	vpxor  %ymm0,%ymm1,%ymm0
   56f4c:	vmovdqu %ymm0,(%r15,%rcx,8)
   56f52:	add    $0x4,%rcx
   56f56:	cmp    %rcx,%rax
   56f59:	jne    56f20 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0xec0>
   56f5b:	jmp    56f91 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0xf31>
   56f5d:	nopl   (%rax)
   56f60:	mov    (%rbx,%rax,8),%rcx
   56f64:	mov    %rcx,%rsi
   56f67:	shr    $0x20,%rsi
   56f6b:	xor    %rcx,%rsi
   56f6e:	imul   %r12,%rsi
   56f72:	mov    %rsi,%rcx
   56f75:	shr    $0x20,%rcx
   56f79:	xor    %rsi,%rcx
   56f7c:	imul   %r12,%rcx
   56f80:	mov    %rcx,%rsi
   56f83:	shr    $0x20,%rsi
   56f87:	xor    %rcx,%rsi
   56f8a:	mov    %rsi,(%r15,%rax,8)
   56f8e:	inc    %rax
   56f91:	cmp    %rax,%rdx
   56f94:	jne    56f60 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0xf00>
   56f96:	jmp    56db0 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0xd50>
   56f9b:	nopl   0x0(%rax,%rax,1)
   56fa0:	call   *0x17f15a(%rip)        # 1d6100 <_DYNAMIC+0x300>
   56fa6:	mov    %rax,%rbp
   56fa9:	mov    %edx,%r13d
   56fac:	mov    %rax,0x70(%rsp)
   56fb1:	mov    %edx,0x78(%rsp)
   56fb5:	mov    0x40(%rsp),%rax
   56fba:	mov    %rax,0x130(%rsp)
   56fc2:	mov    0x38(%rsp),%eax
   56fc6:	mov    %eax,0x138(%rsp)
   56fcd:	lea    0x2a0(%rsp),%rdi
   56fd5:	lea    0x70(%rsp),%rsi
   56fda:	lea    0x130(%rsp),%rdx
   56fe2:	call   1ad410 <std::sys::pal::unix::time::Timespec::sub_timespec>
   56fe7:	kmovb  0x2a0(%rsp),%k1
   56ff0:	kmovd  %k1,0x40(%rsp)
   56ff7:	vcvtusi2sdq 0x2a8(%rsp),%xmm15,%xmm0
   56fff:	vmovsd %xmm0,0x38(%rsp)
   57005:	vcvtsi2sdl 0x2b0(%rsp),%xmm15,%xmm0
   5700e:	vmovsd %xmm0,0x120(%rsp)
   57017:	mov    0x1e0(%rsp),%rbx
   5701f:	cmp    0x1d0(%rsp),%rbx
   57027:	jne    57037 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0xfd7>
   57029:	lea    0x1d0(%rsp),%rdi
   57031:	call   *0x17f0d1(%rip)        # 1d6108 <_DYNAMIC+0x308>
   57037:	vmovsd -0x4d7d7(%rip),%xmm1        # 9868 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x245>
   5703f:	vmovsd 0x120(%rsp),%xmm0
   57048:	vdivsd %xmm1,%xmm0,%xmm0
   5704c:	vaddsd 0x38(%rsp),%xmm0,%xmm0
   57052:	vmulsd %xmm1,%xmm0,%xmm0
   57056:	vxorpd %xmm1,%xmm1,%xmm1
   5705a:	kmovd  0x40(%rsp),%k1
   57061:	vmovsd %xmm1,%xmm0,%xmm0{%k1}
   57067:	vdivsd 0x30(%rsp),%xmm0,%xmm0
   5706d:	mov    0x1d8(%rsp),%rax
   57075:	vmovsd %xmm0,(%rax,%rbx,8)
   5707a:	inc    %rbx
   5707d:	mov    %rbx,0x1e0(%rsp)
   57085:	mov    %rbp,0x70(%rsp)
   5708a:	mov    %r13d,0x78(%rsp)
   5708f:	mov    0x58(%rsp),%rax
   57094:	mov    %rax,0x130(%rsp)
   5709c:	mov    0x20(%rsp),%eax
   570a0:	mov    %eax,0x138(%rsp)
   570a7:	lea    0x2a0(%rsp),%rdi
   570af:	lea    0x70(%rsp),%rsi
   570b4:	lea    0x130(%rsp),%rdx
   570bc:	call   1ad410 <std::sys::pal::unix::time::Timespec::sub_timespec>
   570c1:	kmovb  0x2a0(%rsp),%k1
   570ca:	kmovd  %k1,0x40(%rsp)
   570d1:	vcvtusi2sdq 0x2a8(%rsp),%xmm15,%xmm0
   570d9:	vmovsd %xmm0,0x38(%rsp)
   570df:	vcvtsi2sdl 0x2b0(%rsp),%xmm15,%xmm0
   570e8:	vmovsd %xmm0,0x58(%rsp)
   570ee:	mov    0x1f8(%rsp),%rbx
   570f6:	cmp    0x1e8(%rsp),%rbx
   570fe:	jne    5710e <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x10ae>
   57100:	lea    0x1e8(%rsp),%rdi
   57108:	call   *0x17effa(%rip)        # 1d6108 <_DYNAMIC+0x308>
   5710e:	vmovsd -0x4d8ae(%rip),%xmm1        # 9868 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x245>
   57116:	vmovsd 0x58(%rsp),%xmm0
   5711c:	vdivsd %xmm1,%xmm0,%xmm0
   57120:	vaddsd 0x38(%rsp),%xmm0,%xmm0
   57126:	vmulsd %xmm1,%xmm0,%xmm0
   5712a:	vxorpd %xmm1,%xmm1,%xmm1
   5712e:	kmovd  0x40(%rsp),%k1
   57135:	vmovsd %xmm1,%xmm0,%xmm0{%k1}
   5713b:	vdivsd 0x30(%rsp),%xmm0,%xmm0
   57141:	mov    0x1f0(%rsp),%rax
   57149:	vmovsd %xmm0,(%rax,%rbx,8)
   5714e:	inc    %rbx
   57151:	mov    %rbx,0x1f8(%rsp)
   57159:	mov    0x28(%rsp),%rcx
   5715e:	mov    %rcx,%rdi
   57161:	mov    0x10(%rsp),%rsi
   57166:	mov    0x50(%rsp),%rdx
   5716b:	lea    0x200(%rsp),%r8
   57173:	mov    0x18(%rsp),%r9
   57178:	push   0xe8(%rsp)
   5717f:	push   0x50(%rsp)
   57183:	call   101c80 <compare_benchmark::run::<compare_benchmark::PoppyPublic<0>>::{closure#0}>
   57188:	add    $0x10,%rsp
   5718c:	cmpq   $0x0,0x200(%rsp)
   57195:	je     571a5 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1145>
   57197:	mov    0x208(%rsp),%rdi
   5719f:	call   *0x17ee63(%rip)        # 1d6008 <free@GLIBC_2.2.5>
   571a5:	cmpq   $0x0,0x218(%rsp)
   571ae:	mov    0x18(%rsp),%rbx
   571b3:	je     571c3 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1163>
   571b5:	mov    0x220(%rsp),%rdi
   571bd:	call   *0x17ee45(%rip)        # 1d6008 <free@GLIBC_2.2.5>
   571c3:	cmpq   $0x0,0x230(%rsp)
   571cc:	je     569a0 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x940>
   571d2:	mov    0x238(%rsp),%rdi
   571da:	call   *0x17ee28(%rip)        # 1d6008 <free@GLIBC_2.2.5>
   571e0:	jmp    569a0 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x940>
   571e5:	lea    0x2a0(%rsp),%r13
   571ed:	mov    %r13,%rdi
   571f0:	mov    0x28(%rsp),%rsi
   571f5:	mov    0x6c(%rsp),%edx
   571f9:	vzeroupper
   571fc:	call   17a680 <<compare_benchmark::PoppyPublic<44> as compare_benchmark::Filter>::new>
   57201:	movabs $0x8000000000000000,%rax
   5720b:	cmp    %rax,0x2a0(%rsp)
   57213:	je     5a38e <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x432e>
   57219:	vmovupd 0x2a0(%rsp),%ymm0
   57222:	vmovups 0x2e0(%rsp),%ymm1
   5722b:	vmovdqu 0x300(%rsp),%ymm2
   57234:	vmovdqu %ymm2,0x260(%rsp)
   5723d:	vmovups %ymm1,0x240(%rsp)
   57246:	vmovdqu 0x2c0(%rsp),%ymm1
   5724f:	vmovdqu %ymm1,0x220(%rsp)
   57258:	vmovupd %ymm0,0x200(%rsp)
   57261:	test   %r14,%r14
   57264:	je     5a3cd <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x436d>
   5726a:	mov    0xb8(%rsp),%rax
   57272:	lea    0x8(%rax),%rcx
   57276:	mov    %rcx,0x4f8(%rsp)
   5727e:	lea    0x18(%rax),%rcx
   57282:	mov    %rcx,0x508(%rsp)
   5728a:	lea    0x20(%rax),%rcx
   5728e:	mov    %rcx,0x510(%rsp)
   57296:	mov    0x48(%rsp),%rcx
   5729b:	lea    (%rbx,%rcx,4),%rcx
   5729f:	mov    %rcx,0xe8(%rsp)
   572a7:	lea    0x28(%rax),%rcx
   572ab:	mov    %rcx,0x500(%rsp)
   572b3:	add    $0x40,%rax
   572b7:	mov    %rax,0x4f0(%rsp)
   572bf:	lea    0x200(%rsp),%r13
   572c7:	mov    0x50(%rsp),%rsi
   572cc:	mov    0x28(%rsp),%rbx
   572d1:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   572e0:	test   %rbx,%rbx
   572e3:	je     57306 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x12a6>
   572e5:	cmp    %rbx,%r14
   572e8:	mov    %rbx,%rdx
   572eb:	cmovb  %r14,%rdx
   572ef:	lea    (%rsi,%rdx,8),%rbp
   572f3:	sub    %rdx,%rbx
   572f6:	mov    %r13,%rdi
   572f9:	vzeroupper
   572fc:	call   fcbe0 <compare_benchmark::insert::<compare_benchmark::PoppyPublic<0>>>
   57301:	mov    %rbp,%rsi
   57304:	jmp    572e0 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1280>
   57306:	cmpq   $0x0,0x10(%rsp)
   5730c:	je     5a3e5 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x4385>
   57312:	cmpq   $0x0,0x28(%rsp)
   57318:	je     573af <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x134f>
   5731e:	lea    0x200(%rsp),%rbp
   57326:	mov    0x28(%rsp),%rbx
   5732b:	mov    0x50(%rsp),%r13
   57330:	jmp    57345 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x12e5>
   57332:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   57340:	test   %rbx,%rbx
   57343:	je     573af <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x134f>
   57345:	mov    0x10(%rsp),%rax
   5734a:	cmp    %rbx,%rax
   5734d:	mov    %rbx,%r14
   57350:	cmovb  %rax,%r14
   57354:	mov    %rbp,%rdi
   57357:	mov    %r13,%rsi
   5735a:	mov    %r14,%rdx
   5735d:	mov    0x18(%rsp),%rcx
   57362:	mov    %r14,%r8
   57365:	vzeroupper
   57368:	call   fdb50 <compare_benchmark::lookup::<compare_benchmark::PoppyPublic<0>>>
   5736d:	lea    0x0(%r13,%r14,8),%r13
   57372:	sub    %r14,%rbx
   57375:	shl    $0x2,%r14
   57379:	xor    %eax,%eax
   5737b:	nopl   0x0(%rax,%rax,1)
   57380:	cmp    %rax,%r14
   57383:	je     57340 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x12e0>
   57385:	mov    0x18(%rsp),%rcx
   5738a:	cmpl   $0x1,(%rcx,%rax,1)
   5738e:	lea    0x4(%rax),%rax
   57392:	je     57380 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1320>
   57394:	lea    0x179fad(%rip),%rax        # 1d1348 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.52.llvm.3671060894988460240+0x558>
   5739b:	mov    %rax,0x2a0(%rsp)
   573a3:	lea    0x179fae(%rip),%rsi        # 1d1358 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.52.llvm.3671060894988460240+0x568>
   573aa:	jmp    5a3fb <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x439b>
   573af:	mov    0x8(%rsp),%rax
   573b4:	test   %rax,%rax
   573b7:	je     573d4 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1374>
   573b9:	mov    %rax,%rcx
   573bc:	mov    0x10(%rsp),%rsi
   573c1:	or     %rsi,%rcx
   573c4:	shr    $0x20,%rcx
   573c8:	je     573de <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x137e>
   573ca:	xor    %edx,%edx
   573cc:	div    %rsi
   573cf:	mov    %rax,%r14
   573d2:	jmp    573e5 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1385>
   573d4:	xor    %r14d,%r14d
   573d7:	mov    0x18(%rsp),%rcx
   573dc:	jmp    573f2 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1392>
   573de:	xor    %edx,%edx
   573e0:	div    %esi
   573e2:	mov    %eax,%r14d
   573e5:	mov    0x18(%rsp),%rcx
   573ea:	cmp    $0x1,%rdx
   573ee:	sbb    $0xffffffffffffffff,%r14
   573f2:	mov    0x10(%rsp),%rax
   573f7:	lea    0x0(,%rax,4),%rdx
   573ff:	mov    %rdx,0x40(%rsp)
   57404:	lea    0x0(,%rax,8),%rax
   5740c:	mov    %rax,0x30(%rsp)
   57411:	inc    %r14
   57414:	mov    0x8(%rsp),%rdx
   57419:	mov    0xa8(%rsp),%rsi
   57421:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   57430:	dec    %r14
   57433:	je     57474 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1414>
   57435:	mov    0x40(%rsp),%rax
   5743a:	lea    (%rcx,%rax,1),%rbx
   5743e:	mov    0x30(%rsp),%rax
   57443:	lea    (%rsi,%rax,1),%rbp
   57447:	mov    %rdx,%r13
   5744a:	mov    0x10(%rsp),%rax
   5744f:	sub    %rax,%r13
   57452:	cmova  %rax,%rdx
   57456:	lea    0x200(%rsp),%rdi
   5745e:	mov    %rdx,%r8
   57461:	vzeroupper
   57464:	call   fdb50 <compare_benchmark::lookup::<compare_benchmark::PoppyPublic<0>>>
   57469:	mov    %r13,%rdx
   5746c:	mov    %rbp,%rsi
   5746f:	mov    %rbx,%rcx
   57472:	jmp    57430 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x13d0>
   57474:	movq   $0x0,0x280(%rsp)
   57480:	movq   $0x0,0x498(%rsp)
   5748c:	movq   $0x0,0x288(%rsp)
   57498:	movabs $0xcbf29ce484222325,%rax
   574a2:	mov    %rax,0x128(%rsp)
   574aa:	mov    0x60(%rsp),%rcx
   574af:	mov    0x48(%rsp),%r13
   574b4:	cmp    %rcx,%r13
   574b7:	cmovae %rcx,%r13
   574bb:	mov    0xb8(%rsp),%rcx
   574c3:	mov    0x38(%rcx),%r14
   574c7:	mov    0x28(%rsp),%rcx
   574cc:	add    %r14,%rcx
   574cf:	xor    %edx,%edx
   574d1:	movabs $0x100000001b3,%rsi
   574db:	xor    %edi,%edi
   574dd:	xor    %r8d,%r8d
   574e0:	xor    %r9d,%r9d
   574e3:	jmp    57517 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x14b7>
   574e5:	data16 cs nopw 0x0(%rax,%rax,1)
   574f0:	inc    %rdi
   574f3:	mov    %rdi,0x280(%rsp)
   574fb:	add    %r10,%r8
   574fe:	mov    %r8,0x288(%rsp)
   57506:	mov    0x18(%rsp),%rbx
   5750b:	inc    %rdx
   5750e:	cmp    %rdx,%r13
   57511:	je     575b0 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1550>
   57517:	mov    0xc0(%rsp),%r10
   5751f:	mov    (%r10,%rdx,8),%r11
   57523:	mov    0xb0(%rsp),%r10
   5752b:	mov    0x40(%r10,%rdx,4),%r10d
   57530:	mov    %r10d,0x294(%rsp)
   57538:	cmp    $0x2,%r10
   5753c:	jae    5a2a5 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x4245>
   57542:	xor    %r10,%rax
   57545:	imul   %rsi,%rax
   57549:	mov    %rax,0x128(%rsp)
   57551:	cmp    %r14,%r11
   57554:	setae  %bl
   57557:	cmp    %rcx,%r11
   5755a:	setb   %r11b
   5755e:	test   %r11b,%bl
   57561:	je     574f0 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1490>
   57563:	inc    %r9
   57566:	mov    %r9,0x498(%rsp)
   5756e:	cmp    $0x1,%r10d
   57572:	mov    0x18(%rsp),%rbx
   57577:	je     5750b <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x14ab>
   57579:	movq   $0x0,0x2a0(%rsp)
   57585:	lea    -0x4ddf4(%rip),%rsi        # 9798 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x175>
   5758c:	lea    0x179d9d(%rip),%rcx        # 1d1330 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.52.llvm.3671060894988460240+0x540>
   57593:	lea    0x294(%rsp),%rdi
   5759b:	lea    0x2a0(%rsp),%rdx
   575a3:	vzeroupper
   575a6:	call   ff850 <core::panicking::assert_failed::<u32, u32>>
   575ab:	jmp    5a643 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x45e3>
   575b0:	mov    %r14,0x190(%rsp)
   575b8:	mov    0x8(%rsp),%rax
   575bd:	lea    0x0(,%rax,4),%r14
   575c5:	test   %rax,%rax
   575c8:	je     575ee <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x158e>
   575ca:	mov    %r14,%rdi
   575cd:	vzeroupper
   575d0:	call   *0x17ea22(%rip)        # 1d5ff8 <malloc@GLIBC_2.2.5>
   575d6:	test   %rax,%rax
   575d9:	jne    575f3 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1593>
   575db:	mov    $0x4,%edi
   575e0:	mov    %r14,%rsi
   575e3:	call   *0x17ea67(%rip)        # 1d6050 <_DYNAMIC+0x250>
   575e9:	jmp    5a643 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x45e3>
   575ee:	mov    $0x4,%eax
   575f3:	mov    %rax,0x20(%rsp)
   575f8:	mov    %rax,%rdi
   575fb:	mov    %rbx,%rsi
   575fe:	mov    %r14,%rdx
   57601:	vzeroupper
   57604:	call   *0x17ea0e(%rip)        # 1d6018 <memcpy@GLIBC_2.14>
   5760a:	mov    0x50(%rsp),%r13
   5760f:	mov    0x28(%rsp),%rax
   57614:	lea    0x0(%r13,%rax,8),%rbx
   57619:	nopl   0x0(%rax)
   57620:	xor    %ebp,%ebp
   57622:	cmp    %rbx,%r13
   57625:	setne  %r14b
   57629:	je     57685 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1625>
   5762b:	mov    0x0(%r13),%rsi
   5762f:	lea    0x200(%rsp),%rdi
   57637:	call   ff3a0 <<poppy_filters::bloom::v2::BloomFilter>::contains_bytes::<[u8; 8]>>
   5763c:	mov    %r14b,%bpl
   5763f:	lea    0x0(%r13,%rbp,8),%r13
   57644:	test   %al,%al
   57646:	jne    57620 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x15c0>
   57648:	lea    0x179ca1(%rip),%rax        # 1d12f0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.52.llvm.3671060894988460240+0x500>
   5764f:	mov    %rax,0x2a0(%rsp)
   57657:	vmovapd -0x4d91f(%rip),%ymm0        # 9d40 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x3a8>
   5765f:	vmovupd %ymm0,0x2a8(%rsp)
   57668:	lea    0x179c91(%rip),%rsi        # 1d1300 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.52.llvm.3671060894988460240+0x510>
   5766f:	lea    0x2a0(%rsp),%rdi
   57677:	vzeroupper
   5767a:	call   *0x17ea58(%rip)        # 1d60d8 <_DYNAMIC+0x2d8>
   57680:	jmp    5a643 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x45e3>
   57685:	lea    0x200(%rsp),%rdi
   5768d:	mov    0xa8(%rsp),%rsi
   57695:	mov    0x8(%rsp),%rdx
   5769a:	mov    0x18(%rsp),%rbx
   5769f:	mov    %rbx,%rcx
   576a2:	mov    %rdx,%r8
   576a5:	call   34430 <compare_benchmark::visible_lookup::<compare_benchmark::PoppyPublic<0>, false>>
   576aa:	lea    -0x4cb19(%rip),%rax        # ab98 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x968>
   576b1:	mov    %rbx,%rdi
   576b4:	mov    0x8(%rsp),%rcx
   576b9:	mov    %rcx,%rsi
   576bc:	mov    0x20(%rsp),%rdx
   576c1:	mov    0xb0(%rsp),%r8
   576c9:	mov    0xe8(%rsp),%r9
   576d1:	push   $0x18
   576d3:	push   %rax
   576d4:	push   0x138(%rsp)
   576db:	push   $0x10
   576dd:	call   103e70 <compare_benchmark::verify_dense_output>
   576e2:	add    $0x20,%rsp
   576e6:	lea    0x200(%rsp),%rdi
   576ee:	mov    0xc0(%rsp),%rsi
   576f6:	mov    0x60(%rsp),%rdx
   576fb:	mov    %rbx,%rcx
   576fe:	mov    0x8(%rsp),%r8
   57703:	call   344f0 <compare_benchmark::visible_lookup::<compare_benchmark::PoppyPublic<0>, true>>
   57708:	lea    -0x4cb5f(%rip),%rax        # abb0 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x980>
   5770f:	mov    %rbx,%rdi
   57712:	mov    0x8(%rsp),%rcx
   57717:	mov    %rcx,%rsi
   5771a:	mov    0x20(%rsp),%rdx
   5771f:	mov    0xb0(%rsp),%r8
   57727:	mov    0xe8(%rsp),%r9
   5772f:	push   $0x12
   57731:	push   %rax
   57732:	push   0x138(%rsp)
   57739:	push   $0x10
   5773b:	call   103e70 <compare_benchmark::verify_dense_output>
   57740:	add    $0x20,%rsp
   57744:	mov    0xb8(%rsp),%rax
   5774c:	mov    0x30(%rax),%rsi
   57750:	lea    0x4c8(%rsp),%rdi
   57758:	mov    0x198(%rsp),%rdx
   57760:	call   103980 <compare_benchmark::phase_orders>
   57765:	vxorpd %xmm0,%xmm0,%xmm0
   57769:	vmovupd %xmm0,0x140(%rsp)
   57772:	vmovupd %xmm0,0x158(%rsp)
   5777b:	vmovupd %xmm0,0x170(%rsp)
   57784:	movq   $0x0,0x130(%rsp)
   57790:	movq   $0x8,0x138(%rsp)
   5779c:	movq   $0x8,0x150(%rsp)
   577a8:	movq   $0x8,0x168(%rsp)
   577b4:	movq   $0x8,0x180(%rsp)
   577c0:	movq   $0x0,0x188(%rsp)
   577cc:	mov    0x4d8(%rsp),%rcx
   577d4:	test   %rcx,%rcx
   577d7:	mov    %r15,0x48(%rsp)
   577dc:	je     57f63 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1f03>
   577e2:	mov    %rcx,%rax
   577e5:	mov    0x4d0(%rsp),%rsi
   577ed:	shl    $0x5,%rax
   577f1:	add    %rsi,%rax
   577f4:	mov    %rax,0x518(%rsp)
   577fc:	mov    0x8(%rsp),%rcx
   57801:	vcvtsi2sd %rcx,%xmm15,%xmm0
   57806:	vmovsd %xmm0,0x120(%rsp)
   5780f:	lea    0x20(%rsi),%rax
   57813:	movabs $0xffffffffffffe01,%rdx
   5781d:	lea    0x1ef(%rdx),%rdi
   57824:	and    %rcx,%rdi
   57827:	mov    %rdi,0x528(%rsp)
   5782f:	add    $0x1fb,%rdx
   57836:	and    %rcx,%rdx
   57839:	mov    %rdx,0xf8(%rsp)
   57841:	mov    0xc0(%rsp),%rdx
   57849:	add    $0x60,%rdx
   5784d:	mov    %rdx,0x198(%rsp)
   57855:	or     0x10(%rsp),%rcx
   5785a:	shr    $0x20,%rcx
   5785e:	mov    %rcx,0x118(%rsp)
   57866:	jmp    57897 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1837>
   57868:	nopl   0x0(%rax,%rax,1)
   57870:	xor    %eax,%eax
   57872:	mov    0x518(%rsp),%rcx
   5787a:	mov    0x520(%rsp),%rsi
   57882:	cmp    %rcx,%rsi
   57885:	setne  %al
   57888:	shl    $0x5,%eax
   5788b:	add    %rsi,%rax
   5788e:	cmp    %rcx,%rsi
   57891:	je     57f63 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1f03>
   57897:	mov    %rsi,0x58(%rsp)
   5789c:	mov    %rax,0x520(%rsp)
   578a4:	mov    $0x8,%eax
   578a9:	xor    %ecx,%ecx
   578ab:	jmp    578d0 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1870>
   578ad:	nopl   (%rax)
   578b0:	xor    %eax,%eax
   578b2:	mov    0x18(%rsp),%rbx
   578b7:	mov    %rax,0x70(%rsp)
   578bc:	lea    0x70(%rsp),%rax
   578c1:	mov    0x38(%rsp),%rcx
   578c6:	lea    0x8(%rcx),%rax
   578ca:	cmp    $0x20,%rcx
   578ce:	je     57870 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1810>
   578d0:	mov    0x58(%rsp),%rdx
   578d5:	mov    (%rdx,%rcx,1),%rcx
   578d9:	mov    %rcx,0xc8(%rsp)
   578e1:	mov    %rax,0x38(%rsp)
   578e6:	vzeroupper
   578e9:	call   *0x17e811(%rip)        # 1d6100 <_DYNAMIC+0x300>
   578ef:	mov    %rax,0x2a0(%rsp)
   578f7:	mov    %edx,0x2a8(%rsp)
   578fe:	mov    0xc8(%rsp),%rdx
   57906:	cmp    $0x3,%rdx
   5790a:	ja     5a287 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x4227>
   57910:	lea    -0x4d5ab(%rip),%rcx        # a36c <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x13c>
   57917:	movslq (%rcx,%rdx,4),%rax
   5791b:	add    %rcx,%rax
   5791e:	jmp    *%rax
   57920:	cmpq   $0x0,0x8(%rsp)
   57926:	je     57a01 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x19a1>
   5792c:	cmpq   $0x0,0x118(%rsp)
   57935:	je     57a2a <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x19ca>
   5793b:	mov    0x8(%rsp),%rax
   57940:	xor    %edx,%edx
   57942:	divq   0x10(%rsp)
   57947:	mov    %rax,%r13
   5794a:	jmp    57a38 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x19d8>
   5794f:	nop
   57950:	lea    0x200(%rsp),%rdi
   57958:	mov    0xa8(%rsp),%rsi
   57960:	mov    0x8(%rsp),%rdx
   57965:	mov    0x18(%rsp),%rcx
   5796a:	mov    %rdx,%r8
   5796d:	call   34430 <compare_benchmark::visible_lookup::<compare_benchmark::PoppyPublic<0>, false>>
   57972:	jmp    57d49 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1ce9>
   57977:	nopw   0x0(%rax,%rax,1)
   57980:	lea    0x200(%rsp),%rdi
   57988:	mov    0xc0(%rsp),%rsi
   57990:	mov    0x60(%rsp),%rdx
   57995:	mov    0x18(%rsp),%rcx
   5799a:	mov    0x8(%rsp),%r8
   5799f:	call   344f0 <compare_benchmark::visible_lookup::<compare_benchmark::PoppyPublic<0>, true>>
   579a4:	jmp    57d49 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1ce9>
   579a9:	nopl   0x0(%rax)
   579b0:	mov    0x60(%rsp),%rbx
   579b5:	mov    %rbx,%rax
   579b8:	mov    0x10(%rsp),%rcx
   579bd:	or     %rcx,%rax
   579c0:	shr    $0x20,%rax
   579c4:	je     57a0b <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x19ab>
   579c6:	mov    %rbx,%rax
   579c9:	xor    %edx,%edx
   579cb:	div    %rcx
   579ce:	mov    %rax,%rcx
   579d1:	cmp    $0x1,%rdx
   579d5:	sbb    $0xffffffffffffffff,%rcx
   579d9:	cmpq   $0x0,0x8(%rsp)
   579df:	je     57a23 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x19c3>
   579e1:	cmpq   $0x0,0x118(%rsp)
   579ea:	je     57aa5 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1a45>
   579f0:	mov    0x8(%rsp),%rax
   579f5:	xor    %edx,%edx
   579f7:	divq   0x10(%rsp)
   579fc:	jmp    57ab0 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1a50>
   57a01:	xor    %r13d,%r13d
   57a04:	mov    0x18(%rsp),%rcx
   57a09:	jmp    57a45 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x19e5>
   57a0b:	mov    %ebx,%eax
   57a0d:	xor    %edx,%edx
   57a0f:	div    %ecx
   57a11:	mov    %eax,%ecx
   57a13:	cmp    $0x1,%rdx
   57a17:	sbb    $0xffffffffffffffff,%rcx
   57a1b:	cmpq   $0x0,0x8(%rsp)
   57a21:	jne    579e1 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1981>
   57a23:	xor    %eax,%eax
   57a25:	jmp    57ab8 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1a58>
   57a2a:	mov    0x8(%rsp),%rax
   57a2f:	xor    %edx,%edx
   57a31:	divl   0x10(%rsp)
   57a35:	mov    %eax,%r13d
   57a38:	mov    0x18(%rsp),%rcx
   57a3d:	cmp    $0x1,%rdx
   57a41:	sbb    $0xffffffffffffffff,%r13
   57a45:	inc    %r13
   57a48:	mov    0x8(%rsp),%rdx
   57a4d:	mov    0xa8(%rsp),%rsi
   57a55:	data16 cs nopw 0x0(%rax,%rax,1)
   57a60:	dec    %r13
   57a63:	mov    0x10(%rsp),%rax
   57a68:	je     57d30 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1cd0>
   57a6e:	mov    0x40(%rsp),%rdi
   57a73:	lea    (%rcx,%rdi,1),%rbx
   57a77:	mov    0x30(%rsp),%rdi
   57a7c:	lea    (%rsi,%rdi,1),%r14
   57a80:	mov    %rdx,%rbp
   57a83:	sub    %rax,%rbp
   57a86:	cmova  %rax,%rdx
   57a8a:	lea    0x200(%rsp),%rdi
   57a92:	mov    %rdx,%r8
   57a95:	call   fdb50 <compare_benchmark::lookup::<compare_benchmark::PoppyPublic<0>>>
   57a9a:	mov    %rbp,%rdx
   57a9d:	mov    %r14,%rsi
   57aa0:	mov    %rbx,%rcx
   57aa3:	jmp    57a60 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1a00>
   57aa5:	mov    0x8(%rsp),%rax
   57aaa:	xor    %edx,%edx
   57aac:	divl   0x10(%rsp)
   57ab0:	cmp    $0x1,%rdx
   57ab4:	sbb    $0xffffffffffffffff,%rax
   57ab8:	cmp    %rcx,%rax
   57abb:	cmovb  %rax,%rcx
   57abf:	mov    0xc0(%rsp),%r14
   57ac7:	mov    0x198(%rsp),%rbp
   57acf:	xor    %r13d,%r13d
   57ad2:	mov    0x10(%rsp),%r12
   57ad7:	jmp    57b15 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1ab5>
   57ad9:	nopl   0x0(%rax)
   57ae0:	inc    %r13
   57ae3:	mov    0x18(%rsp),%rax
   57ae8:	lea    (%rax,%rcx,4),%rcx
   57aec:	mov    0x10(%rsp),%r12
   57af1:	sub    %r12,%rbx
   57af4:	mov    0x30(%rsp),%rax
   57af9:	add    %rax,%rbp
   57afc:	add    %rax,%r14
   57aff:	lea    0x200(%rsp),%rdi
   57b07:	mov    %r11,%rsi
   57b0a:	vzeroupper
   57b0d:	call   fdb50 <compare_benchmark::lookup::<compare_benchmark::PoppyPublic<0>>>
   57b12:	mov    %r15,%rcx
   57b15:	cmp    %rbx,%r12
   57b18:	mov    %rbx,%rax
   57b1b:	cmovb  %r12,%rax
   57b1f:	cmp    %rcx,%r13
   57b22:	mov    0x48(%rsp),%r15
   57b27:	je     57d30 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1cd0>
   57b2d:	mov    %r15,%r11
   57b30:	mov    %rcx,%r15
   57b33:	mov    %r13,%rcx
   57b36:	imul   %r12,%rcx
   57b3a:	mov    0x60(%rsp),%rdx
   57b3f:	sub    %rcx,%rdx
   57b42:	cmp    %rdx,%r12
   57b45:	cmovb  %r12,%rdx
   57b49:	mov    0x8(%rsp),%r8
   57b4e:	sub    %rcx,%r8
   57b51:	cmp    %r8,%r12
   57b54:	cmovb  %r12,%r8
   57b58:	test   %rdx,%rdx
   57b5b:	movabs $0xd6e8feb86659fd93,%r10
   57b65:	je     57ae0 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1a80>
   57b6b:	cmp    $0x4,%rax
   57b6f:	jae    57b80 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1b20>
   57b71:	xor    %esi,%esi
   57b73:	mov    0x48(%rsp),%r11
   57b78:	jmp    57cf0 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1c90>
   57b7d:	nopl   (%rax)
   57b80:	cmp    $0x10,%rax
   57b84:	jae    57b92 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1b32>
   57b86:	xor    %esi,%esi
   57b88:	mov    0x48(%rsp),%r11
   57b8d:	jmp    57c99 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1c39>
   57b92:	mov    %rax,%rsi
   57b95:	and    $0xfffffffffffffff0,%rsi
   57b99:	xor    %edi,%edi
   57b9b:	vpbroadcastq -0x4e35c(%rip),%ymm8        # 9848 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x225>
   57ba4:	mov    0x48(%rsp),%r11
   57ba9:	nopl   0x0(%rax)
   57bb0:	vmovdqu -0x60(%rbp,%rdi,8),%ymm0
   57bb6:	vmovdqu -0x40(%rbp,%rdi,8),%ymm1
   57bbc:	vmovdqu -0x20(%rbp,%rdi,8),%ymm2
   57bc2:	vmovdqu 0x0(%rbp,%rdi,8),%ymm3
   57bc8:	vpsrlq $0x20,%ymm0,%ymm4
   57bcd:	vpsrlq $0x20,%ymm1,%ymm5
   57bd2:	vpsrlq $0x20,%ymm2,%ymm6
   57bd7:	vpsrlq $0x20,%ymm3,%ymm7
   57bdc:	vpxor  %ymm0,%ymm4,%ymm0
   57be0:	vpxor  %ymm1,%ymm5,%ymm1
   57be4:	vpxor  %ymm2,%ymm6,%ymm2
   57be8:	vpmullq %ymm8,%ymm0,%ymm0
   57bee:	vpmullq %ymm8,%ymm1,%ymm1
   57bf4:	vpmullq %ymm8,%ymm2,%ymm2
   57bfa:	vpxor  %ymm3,%ymm7,%ymm3
   57bfe:	vpmullq %ymm8,%ymm3,%ymm3
   57c04:	vpsrlq $0x20,%ymm0,%ymm4
   57c09:	vpsrlq $0x20,%ymm1,%ymm5
   57c0e:	vpsrlq $0x20,%ymm2,%ymm6
   57c13:	vpsrlq $0x20,%ymm3,%ymm7
   57c18:	vpxor  %ymm0,%ymm4,%ymm0
   57c1c:	vpxor  %ymm1,%ymm5,%ymm1
   57c20:	vpxor  %ymm2,%ymm6,%ymm2
   57c24:	vpxor  %ymm3,%ymm7,%ymm3
   57c28:	vpmullq %ymm8,%ymm0,%ymm0
   57c2e:	vpmullq %ymm8,%ymm1,%ymm1
   57c34:	vpmullq %ymm8,%ymm2,%ymm2
   57c3a:	vpmullq %ymm8,%ymm3,%ymm3
   57c40:	vpsrlq $0x20,%ymm0,%ymm4
   57c45:	vpsrlq $0x20,%ymm1,%ymm5
   57c4a:	vpsrlq $0x20,%ymm2,%ymm6
   57c4f:	vpsrlq $0x20,%ymm3,%ymm7
   57c54:	vpxor  %ymm0,%ymm4,%ymm0
   57c58:	vpxor  %ymm1,%ymm5,%ymm1
   57c5c:	vpxor  %ymm2,%ymm6,%ymm2
   57c60:	vpxor  %ymm3,%ymm7,%ymm3
   57c64:	vmovdqu %ymm0,(%r11,%rdi,8)
   57c6a:	vmovdqu %ymm1,0x20(%r11,%rdi,8)
   57c71:	vmovdqu %ymm2,0x40(%r11,%rdi,8)
   57c78:	vmovdqu %ymm3,0x60(%r11,%rdi,8)
   57c7f:	add    $0x10,%rdi
   57c83:	cmp    %rdi,%rsi
   57c86:	jne    57bb0 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1b50>
   57c8c:	cmp    %rsi,%rax
   57c8f:	je     57ae0 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1a80>
   57c95:	test   $0xc,%al
   57c97:	je     57cf0 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1c90>
   57c99:	mov    %rsi,%rdi
   57c9c:	mov    %rax,%rsi
   57c9f:	and    $0xfffffffffffffffc,%rsi
   57ca3:	vpbroadcastq -0x4e464(%rip),%ymm2        # 9848 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x225>
   57cac:	nopl   0x0(%rax)
   57cb0:	vmovdqu (%r14,%rdi,8),%ymm0
   57cb6:	vpsrlq $0x20,%ymm0,%ymm1
   57cbb:	vpxor  %ymm0,%ymm1,%ymm0
   57cbf:	vpmullq %ymm2,%ymm0,%ymm0
   57cc5:	vpsrlq $0x20,%ymm0,%ymm1
   57cca:	vpxor  %ymm0,%ymm1,%ymm0
   57cce:	vpmullq %ymm2,%ymm0,%ymm0
   57cd4:	vpsrlq $0x20,%ymm0,%ymm1
   57cd9:	vpxor  %ymm0,%ymm1,%ymm0
   57cdd:	vmovdqu %ymm0,(%r11,%rdi,8)
   57ce3:	add    $0x4,%rdi
   57ce7:	cmp    %rdi,%rsi
   57cea:	jne    57cb0 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1c50>
   57cec:	jmp    57d21 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1cc1>
   57cee:	xchg   %ax,%ax
   57cf0:	mov    (%r14,%rsi,8),%rdi
   57cf4:	mov    %rdi,%r9
   57cf7:	shr    $0x20,%r9
   57cfb:	xor    %rdi,%r9
   57cfe:	imul   %r10,%r9
   57d02:	mov    %r9,%rdi
   57d05:	shr    $0x20,%rdi
   57d09:	xor    %r9,%rdi
   57d0c:	imul   %r10,%rdi
   57d10:	mov    %rdi,%r9
   57d13:	shr    $0x20,%r9
   57d17:	xor    %rdi,%r9
   57d1a:	mov    %r9,(%r11,%rsi,8)
   57d1e:	inc    %rsi
   57d21:	cmp    %rsi,%rax
   57d24:	jne    57cf0 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1c90>
   57d26:	jmp    57ae0 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1a80>
   57d2b:	nopl   0x0(%rax,%rax,1)
   57d30:	cmpq   $0x4,0xc8(%rsp)
   57d39:	movabs $0xd6e8feb86659fd93,%r12
   57d43:	jae    5a5c2 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x4562>
   57d49:	lea    0x2a0(%rsp),%rdi
   57d51:	call   *0x17e3b9(%rip)        # 1d6110 <_DYNAMIC+0x310>
   57d57:	mov    %rax,%r14
   57d5a:	mov    %edx,%ebp
   57d5c:	mov    0xc8(%rsp),%rax
   57d64:	lea    (%rax,%rax,2),%rax
   57d68:	lea    0x130(%rsp,%rax,8),%r13
   57d70:	mov    0x140(%rsp,%rax,8),%rbx
   57d78:	cmp    0x130(%rsp,%rax,8),%rbx
   57d80:	jne    57d8b <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1d2b>
   57d82:	mov    %r13,%rdi
   57d85:	call   *0x17e37d(%rip)        # 1d6108 <_DYNAMIC+0x308>
   57d8b:	vcvtusi2sd %r14,%xmm15,%xmm0
   57d91:	vcvtsi2sd %ebp,%xmm15,%xmm1
   57d95:	vmovsd -0x4e535(%rip),%xmm2        # 9868 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x245>
   57d9d:	vdivsd %xmm2,%xmm1,%xmm1
   57da1:	vaddsd %xmm0,%xmm1,%xmm0
   57da5:	vmulsd %xmm2,%xmm0,%xmm0
   57da9:	vdivsd 0x120(%rsp),%xmm0,%xmm0
   57db2:	mov    0x8(%r13),%rax
   57db6:	vmovsd %xmm0,(%rax,%rbx,8)
   57dbb:	inc    %rbx
   57dbe:	mov    %rbx,0x10(%r13)
   57dc2:	mov    0x128(%rsp),%rax
   57dca:	mov    0xc8(%rsp),%rdx
   57dd2:	shl    $0x4,%rdx
   57dd6:	lea    0x1794bb(%rip),%rcx        # 1d1298 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.52.llvm.3671060894988460240+0x4a8>
   57ddd:	vmovupd (%rdx,%rcx,1),%xmm0
   57de2:	sub    $0x20,%rsp
   57de6:	vmovupd %xmm0,0x10(%rsp)
   57dec:	mov    %rax,0x8(%rsp)
   57df1:	movq   $0x10,(%rsp)
   57df9:	mov    0x38(%rsp),%rdi
   57dfe:	mov    0x28(%rsp),%rcx
   57e03:	mov    %rcx,%rsi
   57e06:	mov    0x40(%rsp),%rdx
   57e0b:	mov    0xd0(%rsp),%r8
   57e13:	mov    0x108(%rsp),%r9
   57e1b:	call   103e70 <compare_benchmark::verify_dense_output>
   57e20:	add    $0x20,%rsp
   57e24:	mov    0x8(%rsp),%rsi
   57e29:	test   %rsi,%rsi
   57e2c:	je     578b0 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1850>
   57e32:	cmp    $0x4,%rsi
   57e36:	mov    0x18(%rsp),%rbx
   57e3b:	jae    57e50 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1df0>
   57e3d:	xor    %ecx,%ecx
   57e3f:	xor    %eax,%eax
   57e41:	jmp    57f50 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1ef0>
   57e46:	cs nopw 0x0(%rax,%rax,1)
   57e50:	cmp    $0x10,%rsi
   57e54:	jae    57e5f <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1dff>
   57e56:	xor    %edx,%edx
   57e58:	xor    %eax,%eax
   57e5a:	jmp    57f00 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1ea0>
   57e5f:	vxorpd %xmm0,%xmm0,%xmm0
   57e63:	xor    %eax,%eax
   57e65:	vxorpd %xmm1,%xmm1,%xmm1
   57e69:	vxorpd %xmm2,%xmm2,%xmm2
   57e6d:	vpxor  %xmm3,%xmm3,%xmm3
   57e71:	mov    0xb0(%rsp),%rcx
   57e79:	mov    0x528(%rsp),%rdx
   57e81:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   57e90:	vpmovzxdq 0x40(%rcx,%rax,4),%ymm4
   57e97:	vpaddq %ymm4,%ymm0,%ymm0
   57e9b:	vpmovzxdq 0x50(%rcx,%rax,4),%ymm4
   57ea2:	vpaddq %ymm4,%ymm1,%ymm1
   57ea6:	vpmovzxdq 0x60(%rcx,%rax,4),%ymm4
   57ead:	vpaddq %ymm4,%ymm2,%ymm2
   57eb1:	vpmovzxdq 0x70(%rcx,%rax,4),%ymm4
   57eb8:	vpaddq %ymm4,%ymm3,%ymm3
   57ebc:	add    $0x10,%rax
   57ec0:	cmp    %rax,%rdx
   57ec3:	jne    57e90 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1e30>
   57ec5:	vpaddq %ymm0,%ymm1,%ymm0
   57ec9:	vpaddq %ymm0,%ymm2,%ymm0
   57ecd:	vpaddq %ymm0,%ymm3,%ymm0
   57ed1:	vextracti128 $0x1,%ymm0,%xmm1
   57ed7:	vpaddq %xmm1,%xmm0,%xmm0
   57edb:	vpshufd $0xee,%xmm0,%xmm1
   57ee0:	vpaddq %xmm1,%xmm0,%xmm0
   57ee4:	vmovq  %xmm0,%rax
   57ee9:	mov    0x8(%rsp),%rsi
   57eee:	cmp    %rdx,%rsi
   57ef1:	je     578b7 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1857>
   57ef7:	mov    %rdx,%rcx
   57efa:	test   $0xc,%sil
   57efe:	je     57f50 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1ef0>
   57f00:	vmovq  %rax,%xmm0
   57f05:	mov    0xf8(%rsp),%rcx
   57f0d:	nopl   (%rax)
   57f10:	vpmovzxdq (%rbx,%rdx,4),%ymm1
   57f16:	vpaddq %ymm1,%ymm0,%ymm0
   57f1a:	add    $0x4,%rdx
   57f1e:	cmp    %rdx,%rcx
   57f21:	jne    57f10 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1eb0>
   57f23:	vextracti128 $0x1,%ymm0,%xmm1
   57f29:	vpaddq %xmm1,%xmm0,%xmm0
   57f2d:	vpshufd $0xee,%xmm0,%xmm1
   57f32:	vpaddq %xmm1,%xmm0,%xmm0
   57f36:	vmovq  %xmm0,%rax
   57f3b:	mov    0x8(%rsp),%rsi
   57f40:	jmp    57f59 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1ef9>
   57f42:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   57f50:	mov    (%rbx,%rcx,4),%edx
   57f53:	add    %rdx,%rax
   57f56:	inc    %rcx
   57f59:	cmp    %rcx,%rsi
   57f5c:	jne    57f50 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1ef0>
   57f5e:	jmp    578b7 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1857>
   57f63:	mov    0xb8(%rsp),%rax
   57f6b:	mov    0x44(%rax),%ecx
   57f6e:	xor    %eax,%eax
   57f70:	test   %ecx,%ecx
   57f72:	mov    $0x1,%edx
   57f77:	shlx   %rcx,%rdx,%rcx
   57f7c:	cmovne %rcx,%rax
   57f80:	mov    %rax,0x4a0(%rsp)
   57f88:	movq   $0x0,0x4a8(%rsp)
   57f94:	mov    %rax,%rcx
   57f97:	mov    0x10(%rsp),%rsi
   57f9c:	or     %rsi,%rcx
   57f9f:	shr    $0x20,%rcx
   57fa3:	je     57fac <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1f4c>
   57fa5:	xor    %edx,%edx
   57fa7:	div    %rsi
   57faa:	jmp    57fb0 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1f50>
   57fac:	xor    %edx,%edx
   57fae:	div    %esi
   57fb0:	xor    %r14d,%r14d
   57fb3:	test   %rdx,%rdx
   57fb6:	setne  %r14b
   57fba:	add    %rax,%r14
   57fbd:	mov    0x10(%rsp),%rsi
   57fc2:	je     583b4 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x2354>
   57fc8:	mov    0x8(%rsp),%rax
   57fcd:	mov    0x28(%rsp),%rcx
   57fd2:	lea    (%rax,%rcx,1),%rdi
   57fd6:	mov    0x190(%rsp),%rdx
   57fde:	add    %rdx,%rdi
   57fe1:	mov    %rdi,0x40(%rsp)
   57fe6:	add    %rax,%rdx
   57fe9:	add    %rcx,%rdx
   57fec:	mov    %rdx,0x190(%rsp)
   57ff4:	movq   $0x0,0x60(%rsp)
   57ffd:	mov    %rsi,%rax
   58000:	xor    %ecx,%ecx
   58002:	jmp    58042 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1fe2>
   58004:	data16 data16 cs nopw 0x0(%rax,%rax,1)
   58010:	dec    %r14
   58013:	mov    0x10(%rsp),%rsi
   58018:	mov    %rsi,%rax
   5801b:	cmove  %r14,%rax
   5801f:	mov    0x30(%rsp),%rcx
   58024:	add    %rcx,%rax
   58027:	sub    %rsi,0x60(%rsp)
   5802c:	add    %rsi,0x190(%rsp)
   58034:	test   %r14,%r14
   58037:	mov    0x18(%rsp),%rbx
   5803c:	je     583b4 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x2354>
   58042:	mov    %rcx,%r13
   58045:	mov    %rax,%r11
   58048:	mov    0x4a0(%rsp),%rbp
   58050:	mov    %rbp,%rdx
   58053:	sub    %rcx,%rdx
   58056:	cmp    %rsi,%rdx
   58059:	cmovae %rsi,%rdx
   5805d:	cmp    %rcx,%rbp
   58060:	je     58315 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x22b5>
   58066:	lea    0x0(,%rdx,8),%rax
   5806e:	add    $0xfffffffffffffff8,%rax
   58072:	cmp    $0x18,%rax
   58076:	jae    58090 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x2030>
   58078:	xor    %eax,%eax
   5807a:	mov    %r15,%rsi
   5807d:	jmp    582d0 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x2270>
   58082:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   58090:	mov    0x40(%rsp),%rcx
   58095:	lea    (%rcx,%r13,1),%rsi
   58099:	mov    %rax,%rcx
   5809c:	shr    $0x3,%rcx
   580a0:	inc    %rcx
   580a3:	vpbroadcastq %rsi,%ymm0
   580a9:	cmp    $0x78,%rax
   580ad:	jae    580b6 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x2056>
   580af:	xor    %eax,%eax
   580b1:	jmp    58220 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x21c0>
   580b6:	mov    %rcx,%rax
   580b9:	movabs $0x3ffffffffffffff0,%rsi
   580c3:	and    %rsi,%rax
   580c6:	vpaddq -0x4e688(%rip){1to4},%ymm0,%ymm1        # 9a48 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0xb0>
   580d0:	vpaddq -0x4e89a(%rip){1to4},%ymm0,%ymm2        # 9840 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x21d>
   580da:	vpaddq -0x4e894(%rip){1to4},%ymm0,%ymm3        # 9850 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x22d>
   580e4:	mov    0x60(%rsp),%rsi
   580e9:	add    %rbp,%rsi
   580ec:	mov    0x10(%rsp),%rdi
   580f1:	cmp    %rsi,%rdi
   580f4:	cmovb  %rdi,%rsi
   580f8:	lea    -0x8(,%rsi,8),%rsi
   58100:	shr    $0x3,%rsi
   58104:	inc    %rsi
   58107:	and    $0xfffffffffffffff0,%rsi
   5810b:	xor    %edi,%edi
   5810d:	vmovdqa -0x4e3b5(%rip),%ymm4        # 9d60 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x3c8>
   58115:	vpbroadcastq -0x4e8d6(%rip),%ymm13        # 9848 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x225>
   5811e:	vpbroadcastq -0x4e6c7(%rip),%ymm14        # 9a60 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0xc8>
   58127:	nopw   0x0(%rax,%rax,1)
   58130:	vpaddq %ymm4,%ymm0,%ymm5
   58134:	vpaddq %ymm1,%ymm4,%ymm6
   58138:	vpaddq %ymm2,%ymm4,%ymm7
   5813c:	vpaddq %ymm3,%ymm4,%ymm8
   58140:	vpsrlq $0x20,%ymm5,%ymm9
   58145:	vpsrlq $0x20,%ymm6,%ymm10
   5814a:	vpsrlq $0x20,%ymm7,%ymm11
   5814f:	vpsrlq $0x20,%ymm8,%ymm12
   58155:	vpxor  %ymm5,%ymm9,%ymm5
   58159:	vpxor  %ymm6,%ymm10,%ymm6
   5815d:	vpxor  %ymm7,%ymm11,%ymm7
   58161:	vpxor  %ymm8,%ymm12,%ymm8
   58166:	vpmullq %ymm13,%ymm5,%ymm5
   5816c:	vpmullq %ymm13,%ymm6,%ymm6
   58172:	vpmullq %ymm13,%ymm7,%ymm7
   58178:	vpmullq %ymm13,%ymm8,%ymm8
   5817e:	vpsrlq $0x20,%ymm5,%ymm9
   58183:	vpsrlq $0x20,%ymm6,%ymm10
   58188:	vpsrlq $0x20,%ymm7,%ymm11
   5818d:	vpxor  %ymm5,%ymm9,%ymm5
   58191:	vpxor  %ymm6,%ymm10,%ymm6
   58195:	vpxor  %ymm7,%ymm11,%ymm7
   58199:	vpmullq %ymm13,%ymm5,%ymm5
   5819f:	vpmullq %ymm13,%ymm6,%ymm6
   581a5:	vpmullq %ymm13,%ymm7,%ymm7
   581ab:	vpsrlq $0x20,%ymm8,%ymm9
   581b1:	vpxor  %ymm8,%ymm9,%ymm8
   581b6:	vpmullq %ymm13,%ymm8,%ymm8
   581bc:	vpsrlq $0x20,%ymm5,%ymm9
   581c1:	vpsrlq $0x20,%ymm6,%ymm10
   581c6:	vpsrlq $0x20,%ymm7,%ymm11
   581cb:	vpsrlq $0x20,%ymm8,%ymm12
   581d1:	vpxor  %ymm5,%ymm9,%ymm5
   581d5:	vpxor  %ymm6,%ymm10,%ymm6
   581d9:	vpxor  %ymm7,%ymm11,%ymm7
   581dd:	vmovdqu %ymm5,(%r15,%rdi,8)
   581e3:	vmovdqu %ymm6,0x20(%r15,%rdi,8)
   581ea:	vmovdqu %ymm7,0x40(%r15,%rdi,8)
   581f1:	vpxor  %ymm8,%ymm12,%ymm5
   581f6:	vmovdqu %ymm5,0x60(%r15,%rdi,8)
   581fd:	add    $0x10,%rdi
   58201:	vpaddq %ymm4,%ymm14,%ymm4
   58205:	cmp    %rdi,%rsi
   58208:	jne    58130 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x20d0>
   5820e:	cmp    %rax,%rcx
   58211:	je     58315 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x22b5>
   58217:	test   $0xc,%cl
   5821a:	je     582c5 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x2265>
   58220:	mov    %rax,%rdi
   58223:	movabs $0x3ffffffffffffff0,%rax
   5822d:	add    $0xc,%rax
   58231:	and    %rcx,%rax
   58234:	lea    (%r15,%rax,8),%rsi
   58238:	vpbroadcastq %rdi,%ymm1
   5823e:	vpor   -0x4e4e6(%rip),%ymm1,%ymm1        # 9d60 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x3c8>
   58246:	mov    0x60(%rsp),%r8
   5824b:	add    %rbp,%r8
   5824e:	mov    0x10(%rsp),%r9
   58253:	cmp    %r8,%r9
   58256:	cmovb  %r9,%r8
   5825a:	lea    -0x8(,%r8,8),%r8
   58262:	shr    $0x3,%r8
   58266:	inc    %r8
   58269:	and    $0xfffffffffffffffc,%r8
   5826d:	vpbroadcastq -0x4ea2e(%rip),%ymm4        # 9848 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x225>
   58276:	vpbroadcastq -0x4e837(%rip),%ymm5        # 9a48 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0xb0>
   5827f:	nop
   58280:	vpaddq %ymm1,%ymm0,%ymm2
   58284:	vpsrlq $0x20,%ymm2,%ymm3
   58289:	vpxor  %ymm2,%ymm3,%ymm2
   5828d:	vpmullq %ymm4,%ymm2,%ymm2
   58293:	vpsrlq $0x20,%ymm2,%ymm3
   58298:	vpxor  %ymm2,%ymm3,%ymm2
   5829c:	vpmullq %ymm4,%ymm2,%ymm2
   582a2:	vpsrlq $0x20,%ymm2,%ymm3
   582a7:	vpxor  %ymm2,%ymm3,%ymm2
   582ab:	vmovdqu %ymm2,(%r15,%rdi,8)
   582b1:	add    $0x4,%rdi
   582b5:	vpaddq %ymm5,%ymm1,%ymm1
   582b9:	cmp    %rdi,%r8
   582bc:	jne    58280 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x2220>
   582be:	cmp    %rax,%rcx
   582c1:	jne    582d0 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x2270>
   582c3:	jmp    58315 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x22b5>
   582c5:	lea    (%r15,%rax,8),%rsi
   582c9:	nopl   0x0(%rax)
   582d0:	lea    (%r15,%rdx,8),%rcx
   582d4:	add    0x190(%rsp),%rax
   582dc:	nopl   0x0(%rax)
   582e0:	mov    %rax,%rdi
   582e3:	shr    $0x20,%rdi
   582e7:	xor    %rax,%rdi
   582ea:	imul   %r12,%rdi
   582ee:	mov    %rdi,%r8
   582f1:	shr    $0x20,%r8
   582f5:	xor    %rdi,%r8
   582f8:	imul   %r12,%r8
   582fc:	mov    %r8,%rdi
   582ff:	shr    $0x20,%rdi
   58303:	xor    %r8,%rdi
   58306:	mov    %rdi,(%rsi)
   58309:	add    $0x8,%rsi
   5830d:	inc    %rax
   58310:	cmp    %rcx,%rsi
   58313:	jne    582e0 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x2280>
   58315:	mov    %r11,0x30(%rsp)
   5831a:	lea    0x200(%rsp),%rdi
   58322:	mov    %r15,%rsi
   58325:	mov    %rbx,%rcx
   58328:	mov    %rdx,%r8
   5832b:	vzeroupper
   5832e:	call   fdb50 <compare_benchmark::lookup::<compare_benchmark::PoppyPublic<0>>>
   58333:	cmp    %r13,%rbp
   58336:	je     58010 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1fb0>
   5833c:	add    0x60(%rsp),%rbp
   58341:	mov    0x10(%rsp),%rax
   58346:	cmp    %rbp,%rax
   58349:	cmovb  %rax,%rbp
   5834d:	cmp    $0x1,%rbp
   58351:	adc    $0x0,%rbp
   58355:	xor    %ebx,%ebx
   58357:	nopw   0x0(%rax,%rax,1)
   58360:	mov    (%r15,%rbx,8),%rsi
   58364:	mov    0x18(%rsp),%rax
   58369:	mov    (%rax,%rbx,4),%r13d
   5836d:	mov    %r13d,0x298(%rsp)
   58375:	cmp    $0x2,%r13
   58379:	jae    5a1ed <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x418d>
   5837f:	lea    0x200(%rsp),%rdi
   58387:	call   ff3a0 <<poppy_filters::bloom::v2::BloomFilter>::contains_bytes::<[u8; 8]>>
   5838c:	movzbl %al,%eax
   5838f:	mov    %eax,0x29c(%rsp)
   58396:	cmp    %eax,%r13d
   58399:	jne    5a22a <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x41ca>
   5839f:	inc    %rbx
   583a2:	add    %r13,0x4a8(%rsp)
   583aa:	cmp    %rbx,%rbp
   583ad:	jne    58360 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x2300>
   583af:	jmp    58010 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1fb0>
   583b4:	mov    0x4e0(%rsp),%rsi
   583bc:	mov    0x4e8(%rsp),%rdx
   583c4:	lea    0x2a0(%rsp),%rdi
   583cc:	mov    0x28(%rsp),%rcx
   583d1:	mov    0x6c(%rsp),%r8d
   583d6:	vzeroupper
   583d9:	call   1764e0 <compare_benchmark::geometry::plan>
   583de:	cmpq   $0x0,0x2a0(%rsp)
   583e7:	je     5a422 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x43c2>
   583ed:	vmovupd 0x2a0(%rsp),%ymm0
   583f6:	vmovupd 0x2c0(%rsp),%ymm1
   583ff:	vmovupd 0x2e0(%rsp),%ymm2
   58408:	vmovupd %ymm2,0x5a0(%rsp)
   58411:	vmovupd %ymm1,0x580(%rsp)
   5841a:	vmovupd %ymm0,0x560(%rsp)
   58423:	mov    0x250(%rsp),%rbx
   5842b:	shl    $0xc,%rbx
   5842f:	add    0x258(%rsp),%rbx
   58437:	mov    %rbx,0x530(%rsp)
   5843f:	cmp    0x598(%rsp),%rbx
   58447:	jne    5a45b <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x43fb>
   5844d:	mov    0x158(%rsp),%rax
   58455:	test   %rax,%rax
   58458:	je     584a7 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x2447>
   5845a:	mov    0x150(%rsp),%rcx
   58462:	cmp    $0x10,%rax
   58466:	jae    584c2 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x2462>
   58468:	vmovsd -0x4eba8(%rip),%xmm0        # 98c8 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x2a5>
   58470:	xor    %esi,%esi
   58472:	vmovapd %xmm0,%xmm1
   58476:	cs nopw 0x0(%rax,%rax,1)
   58480:	vmovsd (%rcx,%rsi,8),%xmm2
   58485:	vminsd %xmm1,%xmm2,%xmm0
   58489:	vcmpunordsd %xmm1,%xmm1,%k1
   58490:	vmovsd %xmm2,%xmm0,%xmm0{%k1}
   58496:	inc    %rsi
   58499:	vmovapd %xmm0,%xmm1
   5849d:	cmp    %rsi,%rax
   584a0:	jne    58480 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x2420>
   584a2:	jmp    5865c <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x25fc>
   584a7:	movabs $0x7ff0000000000000,%rax
   584b1:	mov    %rax,0x4b0(%rsp)
   584b9:	vxorpd %xmm0,%xmm0,%xmm0
   584bd:	jmp    5883c <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x27dc>
   584c2:	mov    %rax,%rdx
   584c5:	and    $0xfffffffffffffff0,%rdx
   584c9:	mov    $0x10,%r8d
   584cf:	sub    %rdx,%r8
   584d2:	vbroadcastsd -0x4ec13(%rip),%ymm0        # 98c8 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x2a5>
   584db:	mov    $0xfffffffffffffff0,%r9
   584e2:	vmovapd %ymm0,%ymm2
   584e6:	vmovapd %ymm0,%ymm4
   584ea:	vmovapd %ymm0,%ymm5
   584ee:	xchg   %ax,%ax
   584f0:	vmovapd %ymm5,%ymm1
   584f4:	vmovapd %ymm4,%ymm3
   584f8:	vmovapd %ymm2,%ymm6
   584fc:	vmovapd %ymm0,%ymm7
   58500:	vmovupd 0x80(%rcx,%r9,8),%ymm8
   5850a:	vmovupd 0xa0(%rcx,%r9,8),%ymm9
   58514:	vmovupd 0xc0(%rcx,%r9,8),%ymm10
   5851e:	vmovupd 0xe0(%rcx,%r9,8),%ymm11
   58528:	vminpd %ymm0,%ymm8,%ymm0
   5852c:	vcmpunordpd %ymm7,%ymm7,%k1
   58533:	vmovapd %ymm8,%ymm0{%k1}
   58539:	vminpd %ymm2,%ymm9,%ymm2
   5853d:	vcmpunordpd %ymm6,%ymm6,%k1
   58544:	vmovapd %ymm9,%ymm2{%k1}
   5854a:	vminpd %ymm4,%ymm10,%ymm4
   5854e:	vcmpunordpd %ymm3,%ymm3,%k1
   58555:	vmovapd %ymm10,%ymm4{%k1}
   5855b:	vminpd %ymm5,%ymm11,%ymm5
   5855f:	vcmpunordpd %ymm1,%ymm1,%k1
   58566:	vmovapd %ymm11,%ymm5{%k1}
   5856c:	vcmpunordpd %ymm9,%ymm8,%k0
   58573:	vcmpunordpd %ymm10,%ymm11,%k1
   5857a:	korw   %k1,%k0,%k0
   5857e:	kmovd  %k0,%edi
   58582:	lea    0x10(%r9),%rsi
   58586:	test   $0xf,%dil
   5858a:	jne    5859c <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x253c>
   5858c:	add    %r8,%r9
   5858f:	cmp    $0xfffffffffffffff0,%r9
   58593:	mov    %rsi,%r9
   58596:	jne    584f0 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x2490>
   5859c:	mov    %edi,%r8d
   5859f:	and    $0xf,%r8b
   585a3:	xor    %r9d,%r9d
   585a6:	mov    %r8d,%r10d
   585a9:	neg    %r10b
   585ac:	sbb    %r9d,%r9d
   585af:	test   %r8b,%r8b
   585b2:	kmovd  %r9d,%k1
   585b7:	vmovapd %ymm7,%ymm0{%k1}
   585bd:	vmovapd %ymm6,%ymm2{%k1}
   585c3:	vmovapd %ymm3,%ymm4{%k1}
   585c9:	vmovapd %ymm1,%ymm5{%k1}
   585cf:	cmove  %rdx,%rsi
   585d3:	vminpd %ymm0,%ymm2,%ymm1
   585d7:	vcmpunordpd %ymm0,%ymm0,%k1
   585de:	vmovapd %ymm2,%ymm1{%k1}
   585e4:	vminpd %ymm1,%ymm4,%ymm0
   585e8:	vcmpunordpd %ymm1,%ymm1,%k1
   585ef:	vmovapd %ymm4,%ymm0{%k1}
   585f5:	vminpd %ymm0,%ymm5,%ymm1
   585f9:	vcmpunordpd %ymm0,%ymm0,%k1
   58600:	vmovapd %ymm5,%ymm1{%k1}
   58606:	vextractf128 $0x1,%ymm1,%xmm0
   5860c:	vshufpd $0x1,%xmm0,%xmm0,%xmm2
   58611:	vshufpd $0x1,%xmm1,%xmm1,%xmm3
   58616:	vminsd %xmm1,%xmm3,%xmm4
   5861a:	vcmpunordsd %xmm1,%xmm1,%k1
   58621:	vmovsd %xmm3,%xmm4,%xmm4{%k1}
   58627:	vcmpunordsd %xmm4,%xmm4,%k1
   5862e:	vminsd %xmm4,%xmm0,%xmm1
   58632:	vmovsd %xmm0,%xmm1,%xmm1{%k1}
   58638:	vcmpunordsd %xmm1,%xmm1,%k1
   5863f:	vminsd %xmm1,%xmm2,%xmm0
   58643:	vmovsd %xmm2,%xmm0,%xmm0{%k1}
   58649:	cmp    %rdx,%rax
   5864c:	jne    58472 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x2412>
   58652:	test   $0xf,%dil
   58656:	jne    58472 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x2412>
   5865c:	vmovsd %xmm0,0x4b0(%rsp)
   58665:	cmp    $0x10,%rax
   58669:	jae    586a7 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x2647>
   5866b:	vxorpd %xmm0,%xmm0,%xmm0
   5866f:	xor    %esi,%esi
   58671:	vmovapd %xmm0,%xmm1
   58675:	data16 cs nopw 0x0(%rax,%rax,1)
   58680:	vmovsd (%rcx,%rsi,8),%xmm2
   58685:	vmaxsd %xmm1,%xmm2,%xmm0
   58689:	vcmpunordsd %xmm1,%xmm1,%k1
   58690:	vmovsd %xmm2,%xmm0,%xmm0{%k1}
   58696:	inc    %rsi
   58699:	vmovapd %xmm0,%xmm1
   5869d:	cmp    %rsi,%rax
   586a0:	jne    58680 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x2620>
   586a2:	jmp    5883c <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x27dc>
   586a7:	mov    %rax,%rdx
   586aa:	and    $0xfffffffffffffff0,%rdx
   586ae:	mov    $0x10,%r8d
   586b4:	sub    %rdx,%r8
   586b7:	vxorpd %xmm0,%xmm0,%xmm0
   586bb:	mov    $0xfffffffffffffff0,%r9
   586c2:	vxorpd %xmm2,%xmm2,%xmm2
   586c6:	vxorpd %xmm4,%xmm4,%xmm4
   586ca:	vxorpd %xmm5,%xmm5,%xmm5
   586ce:	xchg   %ax,%ax
   586d0:	vmovapd %ymm5,%ymm1
   586d4:	vmovapd %ymm4,%ymm3
   586d8:	vmovapd %ymm2,%ymm6
   586dc:	vmovapd %ymm0,%ymm7
   586e0:	vmovupd 0x80(%rcx,%r9,8),%ymm8
   586ea:	vmovupd 0xa0(%rcx,%r9,8),%ymm9
   586f4:	vmovupd 0xc0(%rcx,%r9,8),%ymm10
   586fe:	vmovupd 0xe0(%rcx,%r9,8),%ymm11
   58708:	vmaxpd %ymm0,%ymm8,%ymm0
   5870c:	vcmpunordpd %ymm7,%ymm7,%k1
   58713:	vmovapd %ymm8,%ymm0{%k1}
   58719:	vmaxpd %ymm2,%ymm9,%ymm2
   5871d:	vcmpunordpd %ymm6,%ymm6,%k1
   58724:	vmovapd %ymm9,%ymm2{%k1}
   5872a:	vmaxpd %ymm4,%ymm10,%ymm4
   5872e:	vcmpunordpd %ymm3,%ymm3,%k1
   58735:	vmovapd %ymm10,%ymm4{%k1}
   5873b:	vmaxpd %ymm5,%ymm11,%ymm5
   5873f:	vcmpunordpd %ymm1,%ymm1,%k1
   58746:	vmovapd %ymm11,%ymm5{%k1}
   5874c:	vcmpunordpd %ymm9,%ymm8,%k0
   58753:	vcmpunordpd %ymm10,%ymm11,%k1
   5875a:	korw   %k1,%k0,%k0
   5875e:	kmovd  %k0,%edi
   58762:	lea    0x10(%r9),%rsi
   58766:	test   $0xf,%dil
   5876a:	jne    5877c <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x271c>
   5876c:	add    %r8,%r9
   5876f:	cmp    $0xfffffffffffffff0,%r9
   58773:	mov    %rsi,%r9
   58776:	jne    586d0 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x2670>
   5877c:	mov    %edi,%r8d
   5877f:	and    $0xf,%r8b
   58783:	xor    %r9d,%r9d
   58786:	mov    %r8d,%r10d
   58789:	neg    %r10b
   5878c:	sbb    %r9d,%r9d
   5878f:	test   %r8b,%r8b
   58792:	kmovd  %r9d,%k1
   58797:	vmovapd %ymm7,%ymm0{%k1}
   5879d:	vmovapd %ymm6,%ymm2{%k1}
   587a3:	vmovapd %ymm3,%ymm4{%k1}
   587a9:	vmovapd %ymm1,%ymm5{%k1}
   587af:	cmove  %rdx,%rsi
   587b3:	vmaxpd %ymm0,%ymm2,%ymm1
   587b7:	vcmpunordpd %ymm0,%ymm0,%k1
   587be:	vmovapd %ymm2,%ymm1{%k1}
   587c4:	vmaxpd %ymm1,%ymm4,%ymm0
   587c8:	vcmpunordpd %ymm1,%ymm1,%k1
   587cf:	vmovapd %ymm4,%ymm0{%k1}
   587d5:	vmaxpd %ymm0,%ymm5,%ymm1
   587d9:	vcmpunordpd %ymm0,%ymm0,%k1
   587e0:	vmovapd %ymm5,%ymm1{%k1}
   587e6:	vextractf128 $0x1,%ymm1,%xmm0
   587ec:	vshufpd $0x1,%xmm0,%xmm0,%xmm2
   587f1:	vshufpd $0x1,%xmm1,%xmm1,%xmm3
   587f6:	vmaxsd %xmm1,%xmm3,%xmm4
   587fa:	vcmpunordsd %xmm1,%xmm1,%k1
   58801:	vmovsd %xmm3,%xmm4,%xmm4{%k1}
   58807:	vcmpunordsd %xmm4,%xmm4,%k1
   5880e:	vmaxsd %xmm4,%xmm0,%xmm1
   58812:	vmovsd %xmm0,%xmm1,%xmm1{%k1}
   58818:	vcmpunordsd %xmm1,%xmm1,%k1
   5881f:	vmaxsd %xmm1,%xmm2,%xmm0
   58823:	vmovsd %xmm2,%xmm0,%xmm0{%k1}
   58829:	cmp    %rdx,%rax
   5882c:	jne    58671 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x2611>
   58832:	test   $0xf,%dil
   58836:	jne    58671 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x2611>
   5883c:	vmovsd %xmm0,0x538(%rsp)
   58845:	mov    0x280(%rsp),%rax
   5884d:	test   %rax,%rax
   58850:	je     588ec <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x288c>
   58856:	vcvtusi2sdq 0x288(%rsp),%xmm15,%xmm0
   5885e:	vcvtusi2sd %rax,%xmm15,%xmm1
   58864:	movq   $0x0,0x70(%rsp)
   5886d:	movq   $0x1,0x78(%rsp)
   58876:	vdivsd %xmm1,%xmm0,%xmm0
   5887a:	movq   $0x0,0x80(%rsp)
   58886:	mov    $0xe0000020,%eax
   5888b:	mov    %rax,0x2b0(%rsp)
   58893:	lea    0x70(%rsp),%rax
   58898:	mov    %rax,0x2a0(%rsp)
   588a0:	lea    0x17a689(%rip),%rax        # 1d2f30 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.52.llvm.3671060894988460240+0x2140>
   588a7:	mov    %rax,0x2a8(%rsp)
   588af:	lea    0x2a0(%rsp),%rdi
   588b7:	xor    %esi,%esi
   588b9:	xor    %edx,%edx
   588bb:	vzeroupper
   588be:	call   1837a0 <core::fmt::float::float_to_decimal_common_shortest>
   588c3:	test   %al,%al
   588c5:	jne    5a5de <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x457e>
   588cb:	vmovupd 0x70(%rsp),%xmm0
   588d1:	vmovapd %xmm0,0x460(%rsp)
   588da:	mov    0x80(%rsp),%rax
   588e2:	mov    %rax,0x470(%rsp)
   588ea:	jmp    5892c <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x28cc>
   588ec:	mov    $0x3,%edi
   588f1:	vzeroupper
   588f4:	call   *0x17d6fe(%rip)        # 1d5ff8 <malloc@GLIBC_2.2.5>
   588fa:	test   %rax,%rax
   588fd:	je     5a633 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x45d3>
   58903:	movb   $0x6e,0x2(%rax)
   58907:	movw   $0x616e,(%rax)
   5890c:	movq   $0x3,0x460(%rsp)
   58918:	mov    %rax,0x468(%rsp)
   58920:	movq   $0x3,0x470(%rsp)
   5892c:	mov    %rbx,0x540(%rsp)
   58934:	vcvtusi2sd %rbx,%xmm15,%xmm0
   5893a:	vmulsd -0x4f01a(%rip),%xmm0,%xmm0        # 9928 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x305>
   58942:	vcvtusi2sdq 0x28(%rsp),%xmm15,%xmm1
   5894a:	vdivsd %xmm1,%xmm0,%xmm0
   5894e:	vmovsd %xmm0,0x548(%rsp)
   58957:	mov    0x1a8(%rsp),%rdi
   5895f:	mov    0x1b0(%rsp),%rsi
   58967:	call   1756d0 <compare_benchmark::median>
   5896c:	vmovsd %xmm0,0x550(%rsp)
   58975:	mov    0x1c0(%rsp),%rdi
   5897d:	mov    0x1c8(%rsp),%rsi
   58985:	call   1756d0 <compare_benchmark::median>
   5898a:	vmovsd %xmm0,0x558(%rsp)
   58993:	mov    0x138(%rsp),%rdi
   5899b:	mov    0x140(%rsp),%rsi
   589a3:	call   1756d0 <compare_benchmark::median>
   589a8:	vmovsd %xmm0,0x4b8(%rsp)
   589b1:	mov    0x150(%rsp),%rdi
   589b9:	mov    0x158(%rsp),%rsi
   589c1:	call   1756d0 <compare_benchmark::median>
   589c6:	vmovsd %xmm0,0x4c0(%rsp)
   589cf:	mov    0x140(%rsp),%rax
   589d7:	test   %rax,%rax
   589da:	je     58a27 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x29c7>
   589dc:	mov    0x138(%rsp),%rcx
   589e4:	cmp    $0x10,%rax
   589e8:	jae    58a42 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x29e2>
   589ea:	vmovsd -0x4f12a(%rip),%xmm0        # 98c8 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x2a5>
   589f2:	xor    %esi,%esi
   589f4:	vmovapd %xmm0,%xmm1
   589f8:	nopl   0x0(%rax,%rax,1)
   58a00:	vmovsd (%rcx,%rsi,8),%xmm2
   58a05:	vminsd %xmm1,%xmm2,%xmm0
   58a09:	vcmpunordsd %xmm1,%xmm1,%k1
   58a10:	vmovsd %xmm2,%xmm0,%xmm0{%k1}
   58a16:	inc    %rsi
   58a19:	vmovapd %xmm0,%xmm1
   58a1d:	cmp    %rsi,%rax
   58a20:	jne    58a00 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x29a0>
   58a22:	jmp    58bdc <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x2b7c>
   58a27:	movabs $0x7ff0000000000000,%rax
   58a31:	mov    %rax,0xf0(%rsp)
   58a39:	vxorpd %xmm0,%xmm0,%xmm0
   58a3d:	jmp    58dbc <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x2d5c>
   58a42:	mov    %rax,%rdx
   58a45:	and    $0xfffffffffffffff0,%rdx
   58a49:	mov    $0x10,%r8d
   58a4f:	sub    %rdx,%r8
   58a52:	vbroadcastsd -0x4f193(%rip),%ymm0        # 98c8 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x2a5>
   58a5b:	mov    $0xfffffffffffffff0,%r9
   58a62:	vmovapd %ymm0,%ymm2
   58a66:	vmovapd %ymm0,%ymm4
   58a6a:	vmovapd %ymm0,%ymm5
   58a6e:	xchg   %ax,%ax
   58a70:	vmovapd %ymm5,%ymm1
   58a74:	vmovapd %ymm4,%ymm3
   58a78:	vmovapd %ymm2,%ymm6
   58a7c:	vmovapd %ymm0,%ymm7
   58a80:	vmovupd 0x80(%rcx,%r9,8),%ymm8
   58a8a:	vmovupd 0xa0(%rcx,%r9,8),%ymm9
   58a94:	vmovupd 0xc0(%rcx,%r9,8),%ymm10
   58a9e:	vmovupd 0xe0(%rcx,%r9,8),%ymm11
   58aa8:	vminpd %ymm0,%ymm8,%ymm0
   58aac:	vcmpunordpd %ymm7,%ymm7,%k1
   58ab3:	vmovapd %ymm8,%ymm0{%k1}
   58ab9:	vminpd %ymm2,%ymm9,%ymm2
   58abd:	vcmpunordpd %ymm6,%ymm6,%k1
   58ac4:	vmovapd %ymm9,%ymm2{%k1}
   58aca:	vminpd %ymm4,%ymm10,%ymm4
   58ace:	vcmpunordpd %ymm3,%ymm3,%k1
   58ad5:	vmovapd %ymm10,%ymm4{%k1}
   58adb:	vminpd %ymm5,%ymm11,%ymm5
   58adf:	vcmpunordpd %ymm1,%ymm1,%k1
   58ae6:	vmovapd %ymm11,%ymm5{%k1}
   58aec:	vcmpunordpd %ymm9,%ymm8,%k0
   58af3:	vcmpunordpd %ymm10,%ymm11,%k1
   58afa:	korw   %k1,%k0,%k0
   58afe:	kmovd  %k0,%edi
   58b02:	lea    0x10(%r9),%rsi
   58b06:	test   $0xf,%dil
   58b0a:	jne    58b1c <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x2abc>
   58b0c:	add    %r8,%r9
   58b0f:	cmp    $0xfffffffffffffff0,%r9
   58b13:	mov    %rsi,%r9
   58b16:	jne    58a70 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x2a10>
   58b1c:	mov    %edi,%r8d
   58b1f:	and    $0xf,%r8b
   58b23:	xor    %r9d,%r9d
   58b26:	mov    %r8d,%r10d
   58b29:	neg    %r10b
   58b2c:	sbb    %r9d,%r9d
   58b2f:	test   %r8b,%r8b
   58b32:	kmovd  %r9d,%k1
   58b37:	vmovapd %ymm7,%ymm0{%k1}
   58b3d:	vmovapd %ymm6,%ymm2{%k1}
   58b43:	vmovapd %ymm3,%ymm4{%k1}
   58b49:	vmovapd %ymm1,%ymm5{%k1}
   58b4f:	cmove  %rdx,%rsi
   58b53:	vminpd %ymm0,%ymm2,%ymm1
   58b57:	vcmpunordpd %ymm0,%ymm0,%k1
   58b5e:	vmovapd %ymm2,%ymm1{%k1}
   58b64:	vminpd %ymm1,%ymm4,%ymm0
   58b68:	vcmpunordpd %ymm1,%ymm1,%k1
   58b6f:	vmovapd %ymm4,%ymm0{%k1}
   58b75:	vminpd %ymm0,%ymm5,%ymm1
   58b79:	vcmpunordpd %ymm0,%ymm0,%k1
   58b80:	vmovapd %ymm5,%ymm1{%k1}
   58b86:	vextractf128 $0x1,%ymm1,%xmm0
   58b8c:	vshufpd $0x1,%xmm0,%xmm0,%xmm2
   58b91:	vshufpd $0x1,%xmm1,%xmm1,%xmm3
   58b96:	vminsd %xmm1,%xmm3,%xmm4
   58b9a:	vcmpunordsd %xmm1,%xmm1,%k1
   58ba1:	vmovsd %xmm3,%xmm4,%xmm4{%k1}
   58ba7:	vcmpunordsd %xmm4,%xmm4,%k1
   58bae:	vminsd %xmm4,%xmm0,%xmm1
   58bb2:	vmovsd %xmm0,%xmm1,%xmm1{%k1}
   58bb8:	vcmpunordsd %xmm1,%xmm1,%k1
   58bbf:	vminsd %xmm1,%xmm2,%xmm0
   58bc3:	vmovsd %xmm2,%xmm0,%xmm0{%k1}
   58bc9:	cmp    %rdx,%rax
   58bcc:	jne    589f4 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x2994>
   58bd2:	test   $0xf,%dil
   58bd6:	jne    589f4 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x2994>
   58bdc:	vmovsd %xmm0,0xf0(%rsp)
   58be5:	cmp    $0x10,%rax
   58be9:	jae    58c27 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x2bc7>
   58beb:	vxorpd %xmm0,%xmm0,%xmm0
   58bef:	xor    %esi,%esi
   58bf1:	vmovapd %xmm0,%xmm1
   58bf5:	data16 cs nopw 0x0(%rax,%rax,1)
   58c00:	vmovsd (%rcx,%rsi,8),%xmm2
   58c05:	vmaxsd %xmm1,%xmm2,%xmm0
   58c09:	vcmpunordsd %xmm1,%xmm1,%k1
   58c10:	vmovsd %xmm2,%xmm0,%xmm0{%k1}
   58c16:	inc    %rsi
   58c19:	vmovapd %xmm0,%xmm1
   58c1d:	cmp    %rsi,%rax
   58c20:	jne    58c00 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x2ba0>
   58c22:	jmp    58dbc <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x2d5c>
   58c27:	mov    %rax,%rdx
   58c2a:	and    $0xfffffffffffffff0,%rdx
   58c2e:	mov    $0x10,%r8d
   58c34:	sub    %rdx,%r8
   58c37:	vxorpd %xmm0,%xmm0,%xmm0
   58c3b:	mov    $0xfffffffffffffff0,%r9
   58c42:	vxorpd %xmm2,%xmm2,%xmm2
   58c46:	vxorpd %xmm4,%xmm4,%xmm4
   58c4a:	vxorpd %xmm5,%xmm5,%xmm5
   58c4e:	xchg   %ax,%ax
   58c50:	vmovapd %ymm5,%ymm1
   58c54:	vmovapd %ymm4,%ymm3
   58c58:	vmovapd %ymm2,%ymm6
   58c5c:	vmovapd %ymm0,%ymm7
   58c60:	vmovupd 0x80(%rcx,%r9,8),%ymm8
   58c6a:	vmovupd 0xa0(%rcx,%r9,8),%ymm9
   58c74:	vmovupd 0xc0(%rcx,%r9,8),%ymm10
   58c7e:	vmovupd 0xe0(%rcx,%r9,8),%ymm11
   58c88:	vmaxpd %ymm0,%ymm8,%ymm0
   58c8c:	vcmpunordpd %ymm7,%ymm7,%k1
   58c93:	vmovapd %ymm8,%ymm0{%k1}
   58c99:	vmaxpd %ymm2,%ymm9,%ymm2
   58c9d:	vcmpunordpd %ymm6,%ymm6,%k1
   58ca4:	vmovapd %ymm9,%ymm2{%k1}
   58caa:	vmaxpd %ymm4,%ymm10,%ymm4
   58cae:	vcmpunordpd %ymm3,%ymm3,%k1
   58cb5:	vmovapd %ymm10,%ymm4{%k1}
   58cbb:	vmaxpd %ymm5,%ymm11,%ymm5
   58cbf:	vcmpunordpd %ymm1,%ymm1,%k1
   58cc6:	vmovapd %ymm11,%ymm5{%k1}
   58ccc:	vcmpunordpd %ymm9,%ymm8,%k0
   58cd3:	vcmpunordpd %ymm10,%ymm11,%k1
   58cda:	korw   %k1,%k0,%k0
   58cde:	kmovd  %k0,%edi
   58ce2:	lea    0x10(%r9),%rsi
   58ce6:	test   $0xf,%dil
   58cea:	jne    58cfc <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x2c9c>
   58cec:	add    %r8,%r9
   58cef:	cmp    $0xfffffffffffffff0,%r9
   58cf3:	mov    %rsi,%r9
   58cf6:	jne    58c50 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x2bf0>
   58cfc:	mov    %edi,%r8d
   58cff:	and    $0xf,%r8b
   58d03:	xor    %r9d,%r9d
   58d06:	mov    %r8d,%r10d
   58d09:	neg    %r10b
   58d0c:	sbb    %r9d,%r9d
   58d0f:	test   %r8b,%r8b
   58d12:	kmovd  %r9d,%k1
   58d17:	vmovapd %ymm7,%ymm0{%k1}
   58d1d:	vmovapd %ymm6,%ymm2{%k1}
   58d23:	vmovapd %ymm3,%ymm4{%k1}
   58d29:	vmovapd %ymm1,%ymm5{%k1}
   58d2f:	cmove  %rdx,%rsi
   58d33:	vmaxpd %ymm0,%ymm2,%ymm1
   58d37:	vcmpunordpd %ymm0,%ymm0,%k1
   58d3e:	vmovapd %ymm2,%ymm1{%k1}
   58d44:	vmaxpd %ymm1,%ymm4,%ymm0
   58d48:	vcmpunordpd %ymm1,%ymm1,%k1
   58d4f:	vmovapd %ymm4,%ymm0{%k1}
   58d55:	vmaxpd %ymm0,%ymm5,%ymm1
   58d59:	vcmpunordpd %ymm0,%ymm0,%k1
   58d60:	vmovapd %ymm5,%ymm1{%k1}
   58d66:	vextractf128 $0x1,%ymm1,%xmm0
   58d6c:	vshufpd $0x1,%xmm0,%xmm0,%xmm2
   58d71:	vshufpd $0x1,%xmm1,%xmm1,%xmm3
   58d76:	vmaxsd %xmm1,%xmm3,%xmm4
   58d7a:	vcmpunordsd %xmm1,%xmm1,%k1
   58d81:	vmovsd %xmm3,%xmm4,%xmm4{%k1}
   58d87:	vcmpunordsd %xmm4,%xmm4,%k1
   58d8e:	vmaxsd %xmm4,%xmm0,%xmm1
   58d92:	vmovsd %xmm0,%xmm1,%xmm1{%k1}
   58d98:	vcmpunordsd %xmm1,%xmm1,%k1
   58d9f:	vmaxsd %xmm1,%xmm2,%xmm0
   58da3:	vmovsd %xmm2,%xmm0,%xmm0{%k1}
   58da9:	cmp    %rdx,%rax
   58dac:	jne    58bf1 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x2b91>
   58db2:	test   $0xf,%dil
   58db6:	jne    58bf1 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x2b91>
   58dbc:	vmovsd %xmm0,0x480(%rsp)
   58dc5:	mov    0x1d8(%rsp),%rdi
   58dcd:	mov    0x1e0(%rsp),%rsi
   58dd5:	vzeroupper
   58dd8:	call   1756d0 <compare_benchmark::median>
   58ddd:	vmovsd %xmm0,0x100(%rsp)
   58de6:	mov    0x1f0(%rsp),%rdi
   58dee:	mov    0x1f8(%rsp),%rsi
   58df6:	call   1756d0 <compare_benchmark::median>
   58dfb:	vmovsd %xmm0,0xd0(%rsp)
   58e04:	lea    0x4e0(%rsp),%rax
   58e0c:	mov    %rax,0x2a0(%rsp)
   58e14:	lea    0x11ef45(%rip),%rax        # 177d60 <<&str as core::fmt::Display>::fmt>
   58e1b:	mov    %rax,0x2a8(%rsp)
   58e23:	mov    0xb8(%rsp),%rdx
   58e2b:	mov    %rdx,0x2b0(%rsp)
   58e33:	mov    0x17d2de(%rip),%rsi        # 1d6118 <_DYNAMIC+0x318>
   58e3a:	mov    %rsi,0x2b8(%rsp)
   58e42:	mov    0x4f8(%rsp),%rax
   58e4a:	mov    %rax,0x2c0(%rsp)
   58e52:	mov    %rsi,0x2c8(%rsp)
   58e5a:	mov    0x4f0(%rsp),%rax
   58e62:	mov    %rax,0x2d0(%rsp)
   58e6a:	mov    0x17d2af(%rip),%rax        # 1d6120 <_DYNAMIC+0x320>
   58e71:	mov    %rax,0x2d8(%rsp)
   58e79:	lea    0x540(%rsp),%rax
   58e81:	mov    %rax,0x2e0(%rsp)
   58e89:	lea    0x30(%rdx),%rcx
   58e8d:	mov    %rsi,0x2e8(%rsp)
   58e95:	lea    0x548(%rsp),%rax
   58e9d:	mov    %rax,0x2f0(%rsp)
   58ea5:	add    $0x10,%rdx
   58ea9:	mov    0x17d278(%rip),%r12        # 1d6128 <_DYNAMIC+0x328>
   58eb0:	mov    %r12,0x2f8(%rsp)
   58eb8:	mov    %rdx,0x300(%rsp)
   58ec0:	mov    0x17d269(%rip),%rax        # 1d6130 <_DYNAMIC+0x330>
   58ec7:	mov    %rax,0x308(%rsp)
   58ecf:	lea    0x498(%rsp),%rdx
   58ed7:	mov    %rdx,0x310(%rsp)
   58edf:	mov    %rsi,0x318(%rsp)
   58ee7:	mov    0x508(%rsp),%rdx
   58eef:	mov    %rdx,0x320(%rsp)
   58ef7:	mov    %rsi,0x328(%rsp)
   58eff:	mov    0x500(%rsp),%rdx
   58f07:	mov    %rdx,0x330(%rsp)
   58f0f:	mov    %rsi,0x338(%rsp)
   58f17:	mov    %rcx,0x340(%rsp)
   58f1f:	mov    %rax,0x348(%rsp)
   58f27:	lea    0x550(%rsp),%rcx
   58f2f:	mov    %rcx,0x350(%rsp)
   58f37:	mov    %r12,0x358(%rsp)
   58f3f:	lea    0x558(%rsp),%rcx
   58f47:	mov    %rcx,0x360(%rsp)
   58f4f:	mov    %r12,0x368(%rsp)
   58f57:	lea    0x4b8(%rsp),%r13
   58f5f:	mov    %r13,0x370(%rsp)
   58f67:	mov    %r12,0x378(%rsp)
   58f6f:	lea    0x4c0(%rsp),%rbp
   58f77:	mov    %rbp,0x380(%rsp)
   58f7f:	mov    %r12,0x388(%rsp)
   58f87:	lea    0x280(%rsp),%rcx
   58f8f:	mov    %rcx,0x390(%rsp)
   58f97:	mov    %rsi,0x398(%rsp)
   58f9f:	lea    0x288(%rsp),%rcx
   58fa7:	mov    %rcx,0x3a0(%rsp)
   58faf:	mov    %rsi,0x3a8(%rsp)
   58fb7:	lea    0x460(%rsp),%rcx
   58fbf:	mov    %rcx,0x3b0(%rsp)
   58fc7:	lea    0x1293d2(%rip),%rcx        # 1823a0 <<alloc::string::String as core::fmt::Display>::fmt>
   58fce:	mov    %rcx,0x3b8(%rsp)
   58fd6:	lea    0xf0(%rsp),%rcx
   58fde:	mov    %rcx,0x3c0(%rsp)
   58fe6:	mov    %r12,0x3c8(%rsp)
   58fee:	lea    0x480(%rsp),%rbx
   58ff6:	mov    %rbx,0x3d0(%rsp)
   58ffe:	mov    %r12,0x3d8(%rsp)
   59006:	lea    0x128(%rsp),%rcx
   5900e:	mov    %rcx,0x3e0(%rsp)
   59016:	mov    %rax,0x3e8(%rsp)
   5901e:	lea    0x100(%rsp),%rax
   59026:	mov    %rax,0x3f0(%rsp)
   5902e:	mov    %r12,0x3f8(%rsp)
   59036:	lea    0xd0(%rsp),%r14
   5903e:	mov    %r14,0x400(%rsp)
   59046:	mov    %r12,0x408(%rsp)
   5904e:	mov    0x510(%rsp),%rax
   59056:	mov    %rax,0x410(%rsp)
   5905e:	mov    %rsi,0x418(%rsp)
   59066:	lea    0x4b0(%rsp),%rax
   5906e:	mov    %rax,0x420(%rsp)
   59076:	mov    %r12,0x428(%rsp)
   5907e:	lea    0x538(%rsp),%rax
   59086:	mov    %rax,0x430(%rsp)
   5908e:	mov    %r12,0x438(%rsp)
   59096:	lea    0x4a0(%rsp),%rax
   5909e:	mov    %rax,0x440(%rsp)
   590a6:	mov    %rsi,0x448(%rsp)
   590ae:	lea    0x4a8(%rsp),%rax
   590b6:	mov    %rax,0x450(%rsp)
   590be:	mov    %rsi,0x458(%rsp)
   590c6:	lea    0x177ed3(%rip),%rax        # 1d0fa0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.52.llvm.3671060894988460240+0x1b0>
   590cd:	mov    %rax,0x70(%rsp)
   590d2:	movq   $0x1c,0x78(%rsp)
   590db:	movq   $0x0,0x90(%rsp)
   590e7:	lea    0x2a0(%rsp),%rax
   590ef:	mov    %rax,0x80(%rsp)
   590f7:	movq   $0x1c,0x88(%rsp)
   59103:	lea    0x70(%rsp),%rdi
   59108:	call   *0x17d02a(%rip)        # 1d6138 <_DYNAMIC+0x338>
   5910e:	mov    0x168(%rsp),%rdi
   59116:	mov    0x170(%rsp),%rsi
   5911e:	call   1756d0 <compare_benchmark::median>
   59123:	vmovsd %xmm0,0x4b8(%rsp)
   5912c:	mov    0x180(%rsp),%rdi
   59134:	mov    0x188(%rsp),%rsi
   5913c:	call   1756d0 <compare_benchmark::median>
   59141:	vmovsd %xmm0,0x4c0(%rsp)
   5914a:	mov    0x170(%rsp),%rax
   59152:	test   %rax,%rax
   59155:	je     591a7 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x3147>
   59157:	mov    0x168(%rsp),%rcx
   5915f:	cmp    $0x10,%rax
   59163:	jae    591c2 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x3162>
   59165:	vmovsd -0x4f8a5(%rip),%xmm0        # 98c8 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x2a5>
   5916d:	xor    %esi,%esi
   5916f:	vmovapd %xmm0,%xmm1
   59173:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   59180:	vmovsd (%rcx,%rsi,8),%xmm2
   59185:	vminsd %xmm1,%xmm2,%xmm0
   59189:	vcmpunordsd %xmm1,%xmm1,%k1
   59190:	vmovsd %xmm2,%xmm0,%xmm0{%k1}
   59196:	inc    %rsi
   59199:	vmovapd %xmm0,%xmm1
   5919d:	cmp    %rsi,%rax
   591a0:	jne    59180 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x3120>
   591a2:	jmp    5935c <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x32fc>
   591a7:	movabs $0x7ff0000000000000,%rax
   591b1:	mov    %rax,0xf0(%rsp)
   591b9:	vxorpd %xmm0,%xmm0,%xmm0
   591bd:	jmp    5953c <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x34dc>
   591c2:	mov    %rax,%rdx
   591c5:	and    $0xfffffffffffffff0,%rdx
   591c9:	mov    $0x10,%r8d
   591cf:	sub    %rdx,%r8
   591d2:	vbroadcastsd -0x4f913(%rip),%ymm0        # 98c8 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x2a5>
   591db:	mov    $0xfffffffffffffff0,%r9
   591e2:	vmovapd %ymm0,%ymm2
   591e6:	vmovapd %ymm0,%ymm4
   591ea:	vmovapd %ymm0,%ymm5
   591ee:	xchg   %ax,%ax
   591f0:	vmovapd %ymm5,%ymm1
   591f4:	vmovapd %ymm4,%ymm3
   591f8:	vmovapd %ymm2,%ymm6
   591fc:	vmovapd %ymm0,%ymm7
   59200:	vmovupd 0x80(%rcx,%r9,8),%ymm8
   5920a:	vmovupd 0xa0(%rcx,%r9,8),%ymm9
   59214:	vmovupd 0xc0(%rcx,%r9,8),%ymm10
   5921e:	vmovupd 0xe0(%rcx,%r9,8),%ymm11
   59228:	vminpd %ymm0,%ymm8,%ymm0
   5922c:	vcmpunordpd %ymm7,%ymm7,%k1
   59233:	vmovapd %ymm8,%ymm0{%k1}
   59239:	vminpd %ymm2,%ymm9,%ymm2
   5923d:	vcmpunordpd %ymm6,%ymm6,%k1
   59244:	vmovapd %ymm9,%ymm2{%k1}
   5924a:	vminpd %ymm4,%ymm10,%ymm4
   5924e:	vcmpunordpd %ymm3,%ymm3,%k1
   59255:	vmovapd %ymm10,%ymm4{%k1}
   5925b:	vminpd %ymm5,%ymm11,%ymm5
   5925f:	vcmpunordpd %ymm1,%ymm1,%k1
   59266:	vmovapd %ymm11,%ymm5{%k1}
   5926c:	vcmpunordpd %ymm9,%ymm8,%k0
   59273:	vcmpunordpd %ymm10,%ymm11,%k1
   5927a:	korw   %k1,%k0,%k0
   5927e:	kmovd  %k0,%edi
   59282:	lea    0x10(%r9),%rsi
   59286:	test   $0xf,%dil
   5928a:	jne    5929c <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x323c>
   5928c:	add    %r8,%r9
   5928f:	cmp    $0xfffffffffffffff0,%r9
   59293:	mov    %rsi,%r9
   59296:	jne    591f0 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x3190>
   5929c:	mov    %edi,%r8d
   5929f:	and    $0xf,%r8b
   592a3:	xor    %r9d,%r9d
   592a6:	mov    %r8d,%r10d
   592a9:	neg    %r10b
   592ac:	sbb    %r9d,%r9d
   592af:	test   %r8b,%r8b
   592b2:	kmovd  %r9d,%k1
   592b7:	vmovapd %ymm7,%ymm0{%k1}
   592bd:	vmovapd %ymm6,%ymm2{%k1}
   592c3:	vmovapd %ymm3,%ymm4{%k1}
   592c9:	vmovapd %ymm1,%ymm5{%k1}
   592cf:	cmove  %rdx,%rsi
   592d3:	vminpd %ymm0,%ymm2,%ymm1
   592d7:	vcmpunordpd %ymm0,%ymm0,%k1
   592de:	vmovapd %ymm2,%ymm1{%k1}
   592e4:	vminpd %ymm1,%ymm4,%ymm0
   592e8:	vcmpunordpd %ymm1,%ymm1,%k1
   592ef:	vmovapd %ymm4,%ymm0{%k1}
   592f5:	vminpd %ymm0,%ymm5,%ymm1
   592f9:	vcmpunordpd %ymm0,%ymm0,%k1
   59300:	vmovapd %ymm5,%ymm1{%k1}
   59306:	vextractf128 $0x1,%ymm1,%xmm0
   5930c:	vshufpd $0x1,%xmm0,%xmm0,%xmm2
   59311:	vshufpd $0x1,%xmm1,%xmm1,%xmm3
   59316:	vminsd %xmm1,%xmm3,%xmm4
   5931a:	vcmpunordsd %xmm1,%xmm1,%k1
   59321:	vmovsd %xmm3,%xmm4,%xmm4{%k1}
   59327:	vcmpunordsd %xmm4,%xmm4,%k1
   5932e:	vminsd %xmm4,%xmm0,%xmm1
   59332:	vmovsd %xmm0,%xmm1,%xmm1{%k1}
   59338:	vcmpunordsd %xmm1,%xmm1,%k1
   5933f:	vminsd %xmm1,%xmm2,%xmm0
   59343:	vmovsd %xmm2,%xmm0,%xmm0{%k1}
   59349:	cmp    %rdx,%rax
   5934c:	jne    5916f <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x310f>
   59352:	test   $0xf,%dil
   59356:	jne    5916f <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x310f>
   5935c:	vmovsd %xmm0,0xf0(%rsp)
   59365:	cmp    $0x10,%rax
   59369:	jae    593a7 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x3347>
   5936b:	vxorpd %xmm0,%xmm0,%xmm0
   5936f:	xor    %esi,%esi
   59371:	vmovapd %xmm0,%xmm1
   59375:	data16 cs nopw 0x0(%rax,%rax,1)
   59380:	vmovsd (%rcx,%rsi,8),%xmm2
   59385:	vmaxsd %xmm1,%xmm2,%xmm0
   59389:	vcmpunordsd %xmm1,%xmm1,%k1
   59390:	vmovsd %xmm2,%xmm0,%xmm0{%k1}
   59396:	inc    %rsi
   59399:	vmovapd %xmm0,%xmm1
   5939d:	cmp    %rsi,%rax
   593a0:	jne    59380 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x3320>
   593a2:	jmp    5953c <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x34dc>
   593a7:	mov    %rax,%rdx
   593aa:	and    $0xfffffffffffffff0,%rdx
   593ae:	mov    $0x10,%r8d
   593b4:	sub    %rdx,%r8
   593b7:	vxorpd %xmm0,%xmm0,%xmm0
   593bb:	mov    $0xfffffffffffffff0,%r9
   593c2:	vxorpd %xmm2,%xmm2,%xmm2
   593c6:	vxorpd %xmm4,%xmm4,%xmm4
   593ca:	vxorpd %xmm5,%xmm5,%xmm5
   593ce:	xchg   %ax,%ax
   593d0:	vmovapd %ymm5,%ymm1
   593d4:	vmovapd %ymm4,%ymm3
   593d8:	vmovapd %ymm2,%ymm6
   593dc:	vmovapd %ymm0,%ymm7
   593e0:	vmovupd 0x80(%rcx,%r9,8),%ymm8
   593ea:	vmovupd 0xa0(%rcx,%r9,8),%ymm9
   593f4:	vmovupd 0xc0(%rcx,%r9,8),%ymm10
   593fe:	vmovupd 0xe0(%rcx,%r9,8),%ymm11
   59408:	vmaxpd %ymm0,%ymm8,%ymm0
   5940c:	vcmpunordpd %ymm7,%ymm7,%k1
   59413:	vmovapd %ymm8,%ymm0{%k1}
   59419:	vmaxpd %ymm2,%ymm9,%ymm2
   5941d:	vcmpunordpd %ymm6,%ymm6,%k1
   59424:	vmovapd %ymm9,%ymm2{%k1}
   5942a:	vmaxpd %ymm4,%ymm10,%ymm4
   5942e:	vcmpunordpd %ymm3,%ymm3,%k1
   59435:	vmovapd %ymm10,%ymm4{%k1}
   5943b:	vmaxpd %ymm5,%ymm11,%ymm5
   5943f:	vcmpunordpd %ymm1,%ymm1,%k1
   59446:	vmovapd %ymm11,%ymm5{%k1}
   5944c:	vcmpunordpd %ymm9,%ymm8,%k0
   59453:	vcmpunordpd %ymm10,%ymm11,%k1
   5945a:	korw   %k1,%k0,%k0
   5945e:	kmovd  %k0,%edi
   59462:	lea    0x10(%r9),%rsi
   59466:	test   $0xf,%dil
   5946a:	jne    5947c <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x341c>
   5946c:	add    %r8,%r9
   5946f:	cmp    $0xfffffffffffffff0,%r9
   59473:	mov    %rsi,%r9
   59476:	jne    593d0 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x3370>
   5947c:	mov    %edi,%r8d
   5947f:	and    $0xf,%r8b
   59483:	xor    %r9d,%r9d
   59486:	mov    %r8d,%r10d
   59489:	neg    %r10b
   5948c:	sbb    %r9d,%r9d
   5948f:	test   %r8b,%r8b
   59492:	kmovd  %r9d,%k1
   59497:	vmovapd %ymm7,%ymm0{%k1}
   5949d:	vmovapd %ymm6,%ymm2{%k1}
   594a3:	vmovapd %ymm3,%ymm4{%k1}
   594a9:	vmovapd %ymm1,%ymm5{%k1}
   594af:	cmove  %rdx,%rsi
   594b3:	vmaxpd %ymm0,%ymm2,%ymm1
   594b7:	vcmpunordpd %ymm0,%ymm0,%k1
   594be:	vmovapd %ymm2,%ymm1{%k1}
   594c4:	vmaxpd %ymm1,%ymm4,%ymm0
   594c8:	vcmpunordpd %ymm1,%ymm1,%k1
   594cf:	vmovapd %ymm4,%ymm0{%k1}
   594d5:	vmaxpd %ymm0,%ymm5,%ymm1
   594d9:	vcmpunordpd %ymm0,%ymm0,%k1
   594e0:	vmovapd %ymm5,%ymm1{%k1}
   594e6:	vextractf128 $0x1,%ymm1,%xmm0
   594ec:	vshufpd $0x1,%xmm0,%xmm0,%xmm2
   594f1:	vshufpd $0x1,%xmm1,%xmm1,%xmm3
   594f6:	vmaxsd %xmm1,%xmm3,%xmm4
   594fa:	vcmpunordsd %xmm1,%xmm1,%k1
   59501:	vmovsd %xmm3,%xmm4,%xmm4{%k1}
   59507:	vcmpunordsd %xmm4,%xmm4,%k1
   5950e:	vmaxsd %xmm4,%xmm0,%xmm1
   59512:	vmovsd %xmm0,%xmm1,%xmm1{%k1}
   59518:	vcmpunordsd %xmm1,%xmm1,%k1
   5951f:	vmaxsd %xmm1,%xmm2,%xmm0
   59523:	vmovsd %xmm2,%xmm0,%xmm0{%k1}
   59529:	cmp    %rdx,%rax
   5952c:	jne    59371 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x3311>
   59532:	test   $0xf,%dil
   59536:	jne    59371 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x3311>
   5953c:	vmovsd %xmm0,0x480(%rsp)
   59545:	mov    0x188(%rsp),%rax
   5954d:	test   %rax,%rax
   59550:	je     59597 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x3537>
   59552:	mov    0x180(%rsp),%rcx
   5955a:	cmp    $0x10,%rax
   5955e:	jae    595b2 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x3552>
   59560:	vmovsd -0x4fca0(%rip),%xmm0        # 98c8 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x2a5>
   59568:	xor    %esi,%esi
   5956a:	vmovapd %xmm0,%xmm1
   5956e:	xchg   %ax,%ax
   59570:	vmovsd (%rcx,%rsi,8),%xmm2
   59575:	vminsd %xmm1,%xmm2,%xmm0
   59579:	vcmpunordsd %xmm1,%xmm1,%k1
   59580:	vmovsd %xmm2,%xmm0,%xmm0{%k1}
   59586:	inc    %rsi
   59589:	vmovapd %xmm0,%xmm1
   5958d:	cmp    %rsi,%rax
   59590:	jne    59570 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x3510>
   59592:	jmp    5974c <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x36ec>
   59597:	movabs $0x7ff0000000000000,%rax
   595a1:	mov    %rax,0x100(%rsp)
   595a9:	vxorpd %xmm0,%xmm0,%xmm0
   595ad:	jmp    5992c <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x38cc>
   595b2:	mov    %rax,%rdx
   595b5:	and    $0xfffffffffffffff0,%rdx
   595b9:	mov    $0x10,%r8d
   595bf:	sub    %rdx,%r8
   595c2:	vbroadcastsd -0x4fd03(%rip),%ymm0        # 98c8 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x2a5>
   595cb:	mov    $0xfffffffffffffff0,%r9
   595d2:	vmovapd %ymm0,%ymm2
   595d6:	vmovapd %ymm0,%ymm4
   595da:	vmovapd %ymm0,%ymm5
   595de:	xchg   %ax,%ax
   595e0:	vmovapd %ymm5,%ymm1
   595e4:	vmovapd %ymm4,%ymm3
   595e8:	vmovapd %ymm2,%ymm6
   595ec:	vmovapd %ymm0,%ymm7
   595f0:	vmovupd 0x80(%rcx,%r9,8),%ymm8
   595fa:	vmovupd 0xa0(%rcx,%r9,8),%ymm9
   59604:	vmovupd 0xc0(%rcx,%r9,8),%ymm10
   5960e:	vmovupd 0xe0(%rcx,%r9,8),%ymm11
   59618:	vminpd %ymm0,%ymm8,%ymm0
   5961c:	vcmpunordpd %ymm7,%ymm7,%k1
   59623:	vmovapd %ymm8,%ymm0{%k1}
   59629:	vminpd %ymm2,%ymm9,%ymm2
   5962d:	vcmpunordpd %ymm6,%ymm6,%k1
   59634:	vmovapd %ymm9,%ymm2{%k1}
   5963a:	vminpd %ymm4,%ymm10,%ymm4
   5963e:	vcmpunordpd %ymm3,%ymm3,%k1
   59645:	vmovapd %ymm10,%ymm4{%k1}
   5964b:	vminpd %ymm5,%ymm11,%ymm5
   5964f:	vcmpunordpd %ymm1,%ymm1,%k1
   59656:	vmovapd %ymm11,%ymm5{%k1}
   5965c:	vcmpunordpd %ymm9,%ymm8,%k0
   59663:	vcmpunordpd %ymm10,%ymm11,%k1
   5966a:	korw   %k1,%k0,%k0
   5966e:	kmovd  %k0,%edi
   59672:	lea    0x10(%r9),%rsi
   59676:	test   $0xf,%dil
   5967a:	jne    5968c <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x362c>
   5967c:	add    %r8,%r9
   5967f:	cmp    $0xfffffffffffffff0,%r9
   59683:	mov    %rsi,%r9
   59686:	jne    595e0 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x3580>
   5968c:	mov    %edi,%r8d
   5968f:	and    $0xf,%r8b
   59693:	xor    %r9d,%r9d
   59696:	mov    %r8d,%r10d
   59699:	neg    %r10b
   5969c:	sbb    %r9d,%r9d
   5969f:	test   %r8b,%r8b
   596a2:	kmovd  %r9d,%k1
   596a7:	vmovapd %ymm7,%ymm0{%k1}
   596ad:	vmovapd %ymm6,%ymm2{%k1}
   596b3:	vmovapd %ymm3,%ymm4{%k1}
   596b9:	vmovapd %ymm1,%ymm5{%k1}
   596bf:	cmove  %rdx,%rsi
   596c3:	vminpd %ymm0,%ymm2,%ymm1
   596c7:	vcmpunordpd %ymm0,%ymm0,%k1
   596ce:	vmovapd %ymm2,%ymm1{%k1}
   596d4:	vminpd %ymm1,%ymm4,%ymm0
   596d8:	vcmpunordpd %ymm1,%ymm1,%k1
   596df:	vmovapd %ymm4,%ymm0{%k1}
   596e5:	vminpd %ymm0,%ymm5,%ymm1
   596e9:	vcmpunordpd %ymm0,%ymm0,%k1
   596f0:	vmovapd %ymm5,%ymm1{%k1}
   596f6:	vextractf128 $0x1,%ymm1,%xmm0
   596fc:	vshufpd $0x1,%xmm0,%xmm0,%xmm2
   59701:	vshufpd $0x1,%xmm1,%xmm1,%xmm3
   59706:	vminsd %xmm1,%xmm3,%xmm4
   5970a:	vcmpunordsd %xmm1,%xmm1,%k1
   59711:	vmovsd %xmm3,%xmm4,%xmm4{%k1}
   59717:	vcmpunordsd %xmm4,%xmm4,%k1
   5971e:	vminsd %xmm4,%xmm0,%xmm1
   59722:	vmovsd %xmm0,%xmm1,%xmm1{%k1}
   59728:	vcmpunordsd %xmm1,%xmm1,%k1
   5972f:	vminsd %xmm1,%xmm2,%xmm0
   59733:	vmovsd %xmm2,%xmm0,%xmm0{%k1}
   59739:	cmp    %rdx,%rax
   5973c:	jne    5956a <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x350a>
   59742:	test   $0xf,%dil
   59746:	jne    5956a <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x350a>
   5974c:	vmovsd %xmm0,0x100(%rsp)
   59755:	cmp    $0x10,%rax
   59759:	jae    59797 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x3737>
   5975b:	vxorpd %xmm0,%xmm0,%xmm0
   5975f:	xor    %esi,%esi
   59761:	vmovapd %xmm0,%xmm1
   59765:	data16 cs nopw 0x0(%rax,%rax,1)
   59770:	vmovsd (%rcx,%rsi,8),%xmm2
   59775:	vmaxsd %xmm1,%xmm2,%xmm0
   59779:	vcmpunordsd %xmm1,%xmm1,%k1
   59780:	vmovsd %xmm2,%xmm0,%xmm0{%k1}
   59786:	inc    %rsi
   59789:	vmovapd %xmm0,%xmm1
   5978d:	cmp    %rsi,%rax
   59790:	jne    59770 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x3710>
   59792:	jmp    5992c <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x38cc>
   59797:	mov    %rax,%rdx
   5979a:	and    $0xfffffffffffffff0,%rdx
   5979e:	mov    $0x10,%r8d
   597a4:	sub    %rdx,%r8
   597a7:	vxorpd %xmm0,%xmm0,%xmm0
   597ab:	mov    $0xfffffffffffffff0,%r9
   597b2:	vxorpd %xmm2,%xmm2,%xmm2
   597b6:	vxorpd %xmm4,%xmm4,%xmm4
   597ba:	vxorpd %xmm5,%xmm5,%xmm5
   597be:	xchg   %ax,%ax
   597c0:	vmovapd %ymm5,%ymm1
   597c4:	vmovapd %ymm4,%ymm3
   597c8:	vmovapd %ymm2,%ymm6
   597cc:	vmovapd %ymm0,%ymm7
   597d0:	vmovupd 0x80(%rcx,%r9,8),%ymm8
   597da:	vmovupd 0xa0(%rcx,%r9,8),%ymm9
   597e4:	vmovupd 0xc0(%rcx,%r9,8),%ymm10
   597ee:	vmovupd 0xe0(%rcx,%r9,8),%ymm11
   597f8:	vmaxpd %ymm0,%ymm8,%ymm0
   597fc:	vcmpunordpd %ymm7,%ymm7,%k1
   59803:	vmovapd %ymm8,%ymm0{%k1}
   59809:	vmaxpd %ymm2,%ymm9,%ymm2
   5980d:	vcmpunordpd %ymm6,%ymm6,%k1
   59814:	vmovapd %ymm9,%ymm2{%k1}
   5981a:	vmaxpd %ymm4,%ymm10,%ymm4
   5981e:	vcmpunordpd %ymm3,%ymm3,%k1
   59825:	vmovapd %ymm10,%ymm4{%k1}
   5982b:	vmaxpd %ymm5,%ymm11,%ymm5
   5982f:	vcmpunordpd %ymm1,%ymm1,%k1
   59836:	vmovapd %ymm11,%ymm5{%k1}
   5983c:	vcmpunordpd %ymm9,%ymm8,%k0
   59843:	vcmpunordpd %ymm10,%ymm11,%k1
   5984a:	korw   %k1,%k0,%k0
   5984e:	kmovd  %k0,%edi
   59852:	lea    0x10(%r9),%rsi
   59856:	test   $0xf,%dil
   5985a:	jne    5986c <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x380c>
   5985c:	add    %r8,%r9
   5985f:	cmp    $0xfffffffffffffff0,%r9
   59863:	mov    %rsi,%r9
   59866:	jne    597c0 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x3760>
   5986c:	mov    %edi,%r8d
   5986f:	and    $0xf,%r8b
   59873:	xor    %r9d,%r9d
   59876:	mov    %r8d,%r10d
   59879:	neg    %r10b
   5987c:	sbb    %r9d,%r9d
   5987f:	test   %r8b,%r8b
   59882:	kmovd  %r9d,%k1
   59887:	vmovapd %ymm7,%ymm0{%k1}
   5988d:	vmovapd %ymm6,%ymm2{%k1}
   59893:	vmovapd %ymm3,%ymm4{%k1}
   59899:	vmovapd %ymm1,%ymm5{%k1}
   5989f:	cmove  %rdx,%rsi
   598a3:	vmaxpd %ymm0,%ymm2,%ymm1
   598a7:	vcmpunordpd %ymm0,%ymm0,%k1
   598ae:	vmovapd %ymm2,%ymm1{%k1}
   598b4:	vmaxpd %ymm1,%ymm4,%ymm0
   598b8:	vcmpunordpd %ymm1,%ymm1,%k1
   598bf:	vmovapd %ymm4,%ymm0{%k1}
   598c5:	vmaxpd %ymm0,%ymm5,%ymm1
   598c9:	vcmpunordpd %ymm0,%ymm0,%k1
   598d0:	vmovapd %ymm5,%ymm1{%k1}
   598d6:	vextractf128 $0x1,%ymm1,%xmm0
   598dc:	vshufpd $0x1,%xmm0,%xmm0,%xmm2
   598e1:	vshufpd $0x1,%xmm1,%xmm1,%xmm3
   598e6:	vmaxsd %xmm1,%xmm3,%xmm4
   598ea:	vcmpunordsd %xmm1,%xmm1,%k1
   598f1:	vmovsd %xmm3,%xmm4,%xmm4{%k1}
   598f7:	vcmpunordsd %xmm4,%xmm4,%k1
   598fe:	vmaxsd %xmm4,%xmm0,%xmm1
   59902:	vmovsd %xmm0,%xmm1,%xmm1{%k1}
   59908:	vcmpunordsd %xmm1,%xmm1,%k1
   5990f:	vmaxsd %xmm1,%xmm2,%xmm0
   59913:	vmovsd %xmm2,%xmm0,%xmm0{%k1}
   59919:	cmp    %rdx,%rax
   5991c:	jne    59761 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x3701>
   59922:	test   $0xf,%dil
   59926:	jne    59761 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x3701>
   5992c:	vmovsd %xmm0,0xd0(%rsp)
   59935:	mov    %r13,0x2a0(%rsp)
   5993d:	mov    %r12,0x2a8(%rsp)
   59945:	mov    %rbp,0x2b0(%rsp)
   5994d:	mov    %r12,0x2b8(%rsp)
   59955:	lea    0xf0(%rsp),%rax
   5995d:	mov    %rax,0x2c0(%rsp)
   59965:	mov    %r12,0x2c8(%rsp)
   5996d:	mov    %rbx,0x2d0(%rsp)
   59975:	mov    %r12,0x2d8(%rsp)
   5997d:	lea    0x100(%rsp),%rax
   59985:	mov    %rax,0x2e0(%rsp)
   5998d:	mov    %r12,0x2e8(%rsp)
   59995:	mov    %r14,0x2f0(%rsp)
   5999d:	mov    %r12,0x2f8(%rsp)
   599a5:	lea    0x1777b4(%rip),%rax        # 1d1160 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.52.llvm.3671060894988460240+0x370>
   599ac:	mov    %rax,0x70(%rsp)
   599b1:	movq   $0x6,0x78(%rsp)
   599ba:	movq   $0x0,0x90(%rsp)
   599c6:	lea    0x2a0(%rsp),%rax
   599ce:	mov    %rax,0x80(%rsp)
   599d6:	movq   $0x6,0x88(%rsp)
   599e2:	lea    0x70(%rsp),%rdi
   599e7:	vzeroupper
   599ea:	call   *0x17c748(%rip)        # 1d6138 <_DYNAMIC+0x338>
   599f0:	mov    0x138(%rsp),%rsi
   599f8:	mov    0x140(%rsp),%rdx
   59a00:	lea    0x70(%rsp),%rbx
   59a05:	mov    %rbx,%rdi
   59a08:	call   103c40 <compare_benchmark::trial_string>
   59a0d:	lea    0x12898c(%rip),%r13        # 1823a0 <<alloc::string::String as core::fmt::Display>::fmt>
   59a14:	mov    %rbx,0xd0(%rsp)
   59a1c:	mov    %r13,0xd8(%rsp)
   59a24:	lea    0x1777c5(%rip),%r12        # 1d11f0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.52.llvm.3671060894988460240+0x400>
   59a2b:	mov    %r12,0x2a0(%rsp)
   59a33:	movq   $0x1,0x2a8(%rsp)
   59a3f:	movq   $0x0,0x2c0(%rsp)
   59a4b:	mov    %r14,0x2b0(%rsp)
   59a53:	movq   $0x1,0x2b8(%rsp)
   59a5f:	lea    0x2a0(%rsp),%rdi
   59a67:	call   *0x17c6cb(%rip)        # 1d6138 <_DYNAMIC+0x338>
   59a6d:	cmpq   $0x0,0x70(%rsp)
   59a73:	je     59a80 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x3a20>
   59a75:	mov    0x78(%rsp),%rdi
   59a7a:	call   *0x17c588(%rip)        # 1d6008 <free@GLIBC_2.2.5>
   59a80:	mov    0x150(%rsp),%rsi
   59a88:	mov    0x158(%rsp),%rdx
   59a90:	lea    0x70(%rsp),%rbx
   59a95:	mov    %rbx,%rdi
   59a98:	call   103c40 <compare_benchmark::trial_string>
   59a9d:	mov    %rbx,0xd0(%rsp)
   59aa5:	mov    %r13,0xd8(%rsp)
   59aad:	mov    %r12,0x2a0(%rsp)
   59ab5:	movq   $0x1,0x2a8(%rsp)
   59ac1:	movq   $0x0,0x2c0(%rsp)
   59acd:	mov    %r14,0x2b0(%rsp)
   59ad5:	movq   $0x1,0x2b8(%rsp)
   59ae1:	lea    0x2a0(%rsp),%rdi
   59ae9:	call   *0x17c649(%rip)        # 1d6138 <_DYNAMIC+0x338>
   59aef:	cmpq   $0x0,0x70(%rsp)
   59af5:	je     59b02 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x3aa2>
   59af7:	mov    0x78(%rsp),%rdi
   59afc:	call   *0x17c506(%rip)        # 1d6008 <free@GLIBC_2.2.5>
   59b02:	mov    0x168(%rsp),%rsi
   59b0a:	mov    0x170(%rsp),%rdx
   59b12:	lea    0x70(%rsp),%rbx
   59b17:	mov    %rbx,%rdi
   59b1a:	call   103c40 <compare_benchmark::trial_string>
   59b1f:	mov    %rbx,0xd0(%rsp)
   59b27:	mov    %r13,0xd8(%rsp)
   59b2f:	mov    %r12,0x2a0(%rsp)
   59b37:	movq   $0x1,0x2a8(%rsp)
   59b43:	movq   $0x0,0x2c0(%rsp)
   59b4f:	mov    %r14,0x2b0(%rsp)
   59b57:	movq   $0x1,0x2b8(%rsp)
   59b63:	lea    0x2a0(%rsp),%rdi
   59b6b:	call   *0x17c5c7(%rip)        # 1d6138 <_DYNAMIC+0x338>
   59b71:	cmpq   $0x0,0x70(%rsp)
   59b77:	je     59b84 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x3b24>
   59b79:	mov    0x78(%rsp),%rdi
   59b7e:	call   *0x17c484(%rip)        # 1d6008 <free@GLIBC_2.2.5>
   59b84:	mov    0x180(%rsp),%rsi
   59b8c:	mov    0x188(%rsp),%rdx
   59b94:	lea    0x70(%rsp),%rbx
   59b99:	mov    %rbx,%rdi
   59b9c:	call   103c40 <compare_benchmark::trial_string>
   59ba1:	mov    %rbx,0xd0(%rsp)
   59ba9:	mov    %r13,0xd8(%rsp)
   59bb1:	mov    %r12,0x2a0(%rsp)
   59bb9:	movq   $0x1,0x2a8(%rsp)
   59bc5:	movq   $0x0,0x2c0(%rsp)
   59bd1:	mov    %r14,0x2b0(%rsp)
   59bd9:	movq   $0x1,0x2b8(%rsp)
   59be5:	lea    0x2a0(%rsp),%rdi
   59bed:	call   *0x17c545(%rip)        # 1d6138 <_DYNAMIC+0x338>
   59bf3:	cmpq   $0x0,0x70(%rsp)
   59bf9:	je     59c06 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x3ba6>
   59bfb:	mov    0x78(%rsp),%rdi
   59c00:	call   *0x17c402(%rip)        # 1d6008 <free@GLIBC_2.2.5>
   59c06:	mov    0x4d0(%rsp),%rax
   59c0e:	mov    %rax,0x10(%rsp)
   59c13:	mov    0x4d8(%rsp),%r14
   59c1b:	test   %r14,%r14
   59c1e:	mov    %r14,0x30(%rsp)
   59c23:	je     59d57 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x3cf7>
   59c29:	lea    0x0(,%r14,8),%rax
   59c31:	lea    (%rax,%rax,2),%r13
   59c35:	mov    %r13,%rdi
   59c38:	call   *0x17c3ba(%rip)        # 1d5ff8 <malloc@GLIBC_2.2.5>
   59c3e:	test   %rax,%rax
   59c41:	je     5a623 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x45c3>
   59c47:	mov    %r14,0x100(%rsp)
   59c4f:	mov    %rax,0x108(%rsp)
   59c57:	xor    %ebx,%ebx
   59c59:	mov    0x17c3a8(%rip),%r12        # 1d6008 <free@GLIBC_2.2.5>
   59c60:	mov    %rax,0x18(%rsp)
   59c65:	jmp    59ca5 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x3c45>
   59c67:	nopw   0x0(%rax,%rax,1)
   59c70:	lea    (%rbx,%rbx,2),%rdx
   59c74:	mov    0xe0(%rsp),%rcx
   59c7c:	mov    0x18(%rsp),%rax
   59c81:	mov    %rcx,0x10(%rax,%rdx,8)
   59c86:	vmovapd 0xd0(%rsp),%xmm0
   59c8f:	vmovupd %xmm0,(%rax,%rdx,8)
   59c94:	inc    %rbx
   59c97:	mov    0x30(%rsp),%r14
   59c9c:	cmp    %r14,%rbx
   59c9f:	je     59d6f <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x3d0f>
   59ca5:	mov    %rbx,%rax
   59ca8:	shl    $0x5,%rax
   59cac:	mov    0x10(%rsp),%rcx
   59cb1:	lea    (%rcx,%rax,1),%rsi
   59cb5:	lea    0x20(%rcx,%rax,1),%rdx
   59cba:	lea    0x70(%rsp),%rdi
   59cbf:	call   17fa00 <<alloc::vec::Vec<alloc::string::String> as alloc::vec::spec_from_iter_nested::SpecFromIterNested<alloc::string::String, core::iter::adapters::map::Map<core::slice::iter::Iter<usize>, <usize as alloc::string::ToString>::to_string>>>::from_iter>
   59cc4:	mov    0x78(%rsp),%r13
   59cc9:	mov    0x80(%rsp),%rbp
   59cd1:	lea    0x2a0(%rsp),%rdi
   59cd9:	mov    %r13,%rsi
   59cdc:	mov    %rbp,%rdx
   59cdf:	mov    $0x7c,%ecx
   59ce4:	call   ff890 <alloc::str::join_generic_copy::<str, u8, alloc::string::String>>
   59ce9:	mov    0x2b0(%rsp),%rax
   59cf1:	mov    %rax,0xe0(%rsp)
   59cf9:	vmovupd 0x2a0(%rsp),%xmm0
   59d02:	vmovapd %xmm0,0xd0(%rsp)
   59d0b:	test   %rbp,%rbp
   59d0e:	je     59d40 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x3ce0>
   59d10:	lea    0x8(%r13),%r14
   59d14:	jmp    59d29 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x3cc9>
   59d16:	cs nopw 0x0(%rax,%rax,1)
   59d20:	add    $0x18,%r14
   59d24:	dec    %rbp
   59d27:	je     59d40 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x3ce0>
   59d29:	cmpq   $0x0,-0x8(%r14)
   59d2e:	je     59d20 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x3cc0>
   59d30:	mov    (%r14),%rdi
   59d33:	call   *%r12
   59d36:	jmp    59d20 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x3cc0>
   59d38:	nopl   0x0(%rax,%rax,1)
   59d40:	cmpq   $0x0,0x70(%rsp)
   59d46:	je     59c70 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x3c10>
   59d4c:	mov    %r13,%rdi
   59d4f:	call   *%r12
   59d52:	jmp    59c70 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x3c10>
   59d57:	movq   $0x0,0x100(%rsp)
   59d63:	movq   $0x8,0x108(%rsp)
   59d6f:	mov    0x100(%rsp),%rax
   59d77:	mov    %rax,0x480(%rsp)
   59d7f:	mov    0x108(%rsp),%rax
   59d87:	mov    %rax,0x488(%rsp)
   59d8f:	mov    %r14,0x490(%rsp)
   59d97:	mov    0x488(%rsp),%r12
   59d9f:	lea    0x2a0(%rsp),%r13
   59da7:	mov    %r13,%rdi
   59daa:	mov    %r12,%rsi
   59dad:	mov    %r14,%rdx
   59db0:	mov    $0x3b,%ecx
   59db5:	call   ff890 <alloc::str::join_generic_copy::<str, u8, alloc::string::String>>
   59dba:	mov    0x2b0(%rsp),%rax
   59dc2:	mov    %rax,0x110(%rsp)
   59dca:	vmovupd 0x2a0(%rsp),%xmm0
   59dd3:	vmovapd %xmm0,0x100(%rsp)
   59ddc:	mov    0x5a8(%rsp),%r8
   59de4:	test   %r8,%r8
   59de7:	je     5a614 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x45b4>
   59ded:	lea    0x5a8(%rsp),%rcx
   59df5:	lea    0x5a0(%rsp),%rsi
   59dfd:	mov    0x5a0(%rsp),%rax
   59e05:	lea    0x590(%rsp),%rdi
   59e0d:	mov    %rax,%rdx
   59e10:	or     %r8,%rdx
   59e13:	shr    $0x20,%rdx
   59e17:	je     59e20 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x3dc0>
   59e19:	xor    %edx,%edx
   59e1b:	div    %r8
   59e1e:	jmp    59e25 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x3dc5>
   59e20:	xor    %edx,%edx
   59e22:	div    %r8d
   59e25:	mov    %rax,0xf0(%rsp)
   59e2d:	lea    0x5b8(%rsp),%rax
   59e35:	lea    0x570(%rsp),%rdx
   59e3d:	mov    %rdi,0x2a0(%rsp)
   59e45:	mov    0x17c2cc(%rip),%r8        # 1d6118 <_DYNAMIC+0x318>
   59e4c:	mov    %r8,0x2a8(%rsp)
   59e54:	lea    0x5b0(%rsp),%rdi
   59e5c:	mov    %rsi,0x2b0(%rsp)
   59e64:	mov    %r8,0x2b8(%rsp)
   59e6c:	lea    0x560(%rsp),%rsi
   59e74:	mov    %rsi,0x2c0(%rsp)
   59e7c:	lea    0x11dedd(%rip),%rsi        # 177d60 <<&str as core::fmt::Display>::fmt>
   59e83:	mov    %rsi,0x2c8(%rsp)
   59e8b:	mov    %rcx,0x2d0(%rsp)
   59e93:	mov    %r8,0x2d8(%rsp)
   59e9b:	lea    0xf0(%rsp),%rcx
   59ea3:	mov    %rcx,0x2e0(%rsp)
   59eab:	mov    %r8,0x2e8(%rsp)
   59eb3:	lea    0x580(%rsp),%rcx
   59ebb:	mov    %rax,0x2f0(%rsp)
   59ec3:	mov    0x17c276(%rip),%rax        # 1d6140 <_DYNAMIC+0x340>
   59eca:	mov    %rax,0x2f8(%rsp)
   59ed2:	mov    %rdx,0x300(%rsp)
   59eda:	mov    %rsi,0x308(%rsp)
   59ee2:	mov    %rdi,0x310(%rsp)
   59eea:	mov    %r8,0x318(%rsp)
   59ef2:	mov    %rcx,0x320(%rsp)
   59efa:	mov    %rsi,0x328(%rsp)
   59f02:	lea    0x177e2f(%rip),%rax        # 1d1d38 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.52.llvm.3671060894988460240+0xf48>
   59f09:	mov    %rax,0x70(%rsp)
   59f0e:	movq   $0xa,0x78(%rsp)
   59f17:	mov    %r13,0x80(%rsp)
   59f1f:	movq   $0x9,0x88(%rsp)
   59f2b:	movq   $0x0,0x90(%rsp)
   59f37:	lea    0xd0(%rsp),%rbp
   59f3f:	lea    0x70(%rsp),%r13
   59f44:	mov    %rbp,%rdi
   59f47:	mov    %r13,%rsi
   59f4a:	call   *0x17c150(%rip)        # 1d60a0 <_DYNAMIC+0x2a0>
   59f50:	lea    0x100(%rsp),%rax
   59f58:	mov    %rax,0x70(%rsp)
   59f5d:	lea    0x12843c(%rip),%rax        # 1823a0 <<alloc::string::String as core::fmt::Display>::fmt>
   59f64:	mov    %rax,0x78(%rsp)
   59f69:	mov    %rbp,0x80(%rsp)
   59f71:	mov    %rax,0x88(%rsp)
   59f79:	lea    0x177240(%rip),%rax        # 1d11c0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.52.llvm.3671060894988460240+0x3d0>
   59f80:	mov    %rax,0x2a0(%rsp)
   59f88:	movq   $0x3,0x2a8(%rsp)
   59f94:	movq   $0x0,0x2c0(%rsp)
   59fa0:	mov    %r13,0x2b0(%rsp)
   59fa8:	movq   $0x2,0x2b8(%rsp)
   59fb4:	lea    0x2a0(%rsp),%rdi
   59fbc:	call   *0x17c176(%rip)        # 1d6138 <_DYNAMIC+0x338>
   59fc2:	cmpq   $0x0,0xd0(%rsp)
   59fcb:	je     59fdb <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x3f7b>
   59fcd:	mov    0xd8(%rsp),%rdi
   59fd5:	call   *0x17c02d(%rip)        # 1d6008 <free@GLIBC_2.2.5>
   59fdb:	cmpq   $0x0,0x100(%rsp)
   59fe4:	je     59ff4 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x3f94>
   59fe6:	mov    0x108(%rsp),%rdi
   59fee:	call   *0x17c014(%rip)        # 1d6008 <free@GLIBC_2.2.5>
   59ff4:	test   %r14,%r14
   59ff7:	mov    0x20(%rsp),%rdi
   59ffc:	je     5a02d <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x3fcd>
   59ffe:	lea    0x8(%r12),%rbx
   5a003:	mov    0x17bffe(%rip),%r13        # 1d6008 <free@GLIBC_2.2.5>
   5a00a:	jmp    5a019 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x3fb9>
   5a00c:	nopl   0x0(%rax)
   5a010:	add    $0x18,%rbx
   5a014:	dec    %r14
   5a017:	je     5a02d <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x3fcd>
   5a019:	cmpq   $0x0,-0x8(%rbx)
   5a01e:	je     5a010 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x3fb0>
   5a020:	mov    (%rbx),%rdi
   5a023:	call   *%r13
   5a026:	mov    0x20(%rsp),%rdi
   5a02b:	jmp    5a010 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x3fb0>
   5a02d:	cmpq   $0x0,0x480(%rsp)
   5a036:	je     5a046 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x3fe6>
   5a038:	mov    %r12,%rdi
   5a03b:	call   *0x17bfc7(%rip)        # 1d6008 <free@GLIBC_2.2.5>
   5a041:	mov    0x20(%rsp),%rdi
   5a046:	cmpq   $0x0,0x460(%rsp)
   5a04f:	je     5a064 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x4004>
   5a051:	mov    0x468(%rsp),%rdi
   5a059:	call   *0x17bfa9(%rip)        # 1d6008 <free@GLIBC_2.2.5>
   5a05f:	mov    0x20(%rsp),%rdi
   5a064:	cmpq   $0x0,0x130(%rsp)
   5a06d:	je     5a082 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x4022>
   5a06f:	mov    0x138(%rsp),%rdi
   5a077:	call   *0x17bf8b(%rip)        # 1d6008 <free@GLIBC_2.2.5>
   5a07d:	mov    0x20(%rsp),%rdi
   5a082:	cmpq   $0x0,0x148(%rsp)
   5a08b:	je     5a0a0 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x4040>
   5a08d:	mov    0x150(%rsp),%rdi
   5a095:	call   *0x17bf6d(%rip)        # 1d6008 <free@GLIBC_2.2.5>
   5a09b:	mov    0x20(%rsp),%rdi
   5a0a0:	cmpq   $0x0,0x160(%rsp)
   5a0a9:	je     5a0be <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x405e>
   5a0ab:	mov    0x168(%rsp),%rdi
   5a0b3:	call   *0x17bf4f(%rip)        # 1d6008 <free@GLIBC_2.2.5>
   5a0b9:	mov    0x20(%rsp),%rdi
   5a0be:	cmpq   $0x0,0x178(%rsp)
   5a0c7:	je     5a0dc <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x407c>
   5a0c9:	mov    0x180(%rsp),%rdi
   5a0d1:	call   *0x17bf31(%rip)        # 1d6008 <free@GLIBC_2.2.5>
   5a0d7:	mov    0x20(%rsp),%rdi
   5a0dc:	cmpq   $0x0,0x4c8(%rsp)
   5a0e5:	je     5a0f7 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x4097>
   5a0e7:	mov    0x10(%rsp),%rdi
   5a0ec:	call   *0x17bf16(%rip)        # 1d6008 <free@GLIBC_2.2.5>
   5a0f2:	mov    0x20(%rsp),%rdi
   5a0f7:	cmpq   $0x0,0x8(%rsp)
   5a0fd:	je     5a105 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x40a5>
   5a0ff:	call   *0x17bf03(%rip)        # 1d6008 <free@GLIBC_2.2.5>
   5a105:	cmpq   $0x0,0x200(%rsp)
   5a10e:	je     5a11e <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x40be>
   5a110:	mov    0x208(%rsp),%rdi
   5a118:	call   *0x17beea(%rip)        # 1d6008 <free@GLIBC_2.2.5>
   5a11e:	cmpq   $0x0,0x218(%rsp)
   5a127:	je     5a137 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x40d7>
   5a129:	mov    0x220(%rsp),%rdi
   5a131:	call   *0x17bed1(%rip)        # 1d6008 <free@GLIBC_2.2.5>
   5a137:	cmpq   $0x0,0x230(%rsp)
   5a140:	je     5a150 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x40f0>
   5a142:	mov    0x238(%rsp),%rdi
   5a14a:	call   *0x17beb8(%rip)        # 1d6008 <free@GLIBC_2.2.5>
   5a150:	cmpq   $0x0,0x1e8(%rsp)
   5a159:	je     5a169 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x4109>
   5a15b:	mov    0x1f0(%rsp),%rdi
   5a163:	call   *0x17be9f(%rip)        # 1d6008 <free@GLIBC_2.2.5>
   5a169:	cmpq   $0x0,0x1d0(%rsp)
   5a172:	je     5a182 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x4122>
   5a174:	mov    0x1d8(%rsp),%rdi
   5a17c:	call   *0x17be86(%rip)        # 1d6008 <free@GLIBC_2.2.5>
   5a182:	cmpq   $0x0,0x1b8(%rsp)
   5a18b:	je     5a19b <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x413b>
   5a18d:	mov    0x1c0(%rsp),%rdi
   5a195:	call   *0x17be6d(%rip)        # 1d6008 <free@GLIBC_2.2.5>
   5a19b:	cmpq   $0x0,0x1a0(%rsp)
   5a1a4:	je     5a1b4 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x4154>
   5a1a6:	mov    0x1a8(%rsp),%rdi
   5a1ae:	call   *0x17be54(%rip)        # 1d6008 <free@GLIBC_2.2.5>
   5a1b4:	mov    0x17be4d(%rip),%rbx        # 1d6008 <free@GLIBC_2.2.5>
   5a1bb:	mov    0xb0(%rsp),%rdi
   5a1c3:	call   *%rbx
   5a1c5:	mov    %r15,%rdi
   5a1c8:	call   *%rbx
   5a1ca:	mov    0xa8(%rsp),%rdi
   5a1d2:	call   *%rbx
   5a1d4:	mov    0x50(%rsp),%rdi
   5a1d9:	call   *%rbx
   5a1db:	add    $0x5c8,%rsp
   5a1e2:	pop    %rbx
   5a1e3:	pop    %r12
   5a1e5:	pop    %r13
   5a1e7:	pop    %r14
   5a1e9:	pop    %r15
   5a1eb:	pop    %rbp
   5a1ec:	ret
   5a1ed:	lea    0x17700c(%rip),%rax        # 1d1200 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.52.llvm.3671060894988460240+0x410>
   5a1f4:	mov    %rax,0x2a0(%rsp)
   5a1fc:	vmovaps -0x504c4(%rip),%ymm0        # 9d40 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x3a8>
   5a204:	vmovups %ymm0,0x2a8(%rsp)
   5a20d:	lea    0x176ffc(%rip),%rsi        # 1d1210 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.52.llvm.3671060894988460240+0x420>
   5a214:	lea    0x2a0(%rsp),%rdi
   5a21c:	vzeroupper
   5a21f:	call   *0x17beb3(%rip)        # 1d60d8 <_DYNAMIC+0x2d8>
   5a225:	jmp    5a643 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x45e3>
   5a22a:	lea    0x176ff7(%rip),%rax        # 1d1228 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.52.llvm.3671060894988460240+0x438>
   5a231:	mov    %rax,0x2a0(%rsp)
   5a239:	movq   $0x1,0x2a8(%rsp)
   5a245:	movq   $0x8,0x2b0(%rsp)
   5a251:	vxorpd %xmm0,%xmm0,%xmm0
   5a255:	vmovupd %xmm0,0x2b8(%rsp)
   5a25e:	lea    0x176fd3(%rip),%rcx        # 1d1238 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.52.llvm.3671060894988460240+0x448>
   5a265:	lea    0x298(%rsp),%rdi
   5a26d:	lea    0x29c(%rsp),%rsi
   5a275:	lea    0x2a0(%rsp),%rdx
   5a27d:	call   ff850 <core::panicking::assert_failed::<u32, u32>>
   5a282:	jmp    5a643 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x45e3>
   5a287:	lea    -0x4f5ea(%rip),%rdi        # aca4 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0xa74>
   5a28e:	lea    0x177043(%rip),%rdx        # 1d12d8 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.52.llvm.3671060894988460240+0x4e8>
   5a295:	mov    $0x28,%esi
   5a29a:	call   *0x17bea8(%rip)        # 1d6148 <_DYNAMIC+0x348>
   5a2a0:	jmp    5a643 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x45e3>
   5a2a5:	lea    -0x4f5ca(%rip),%rdi        # ace2 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0xab2>
   5a2ac:	lea    0x177065(%rip),%rdx        # 1d1318 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.52.llvm.3671060894988460240+0x528>
   5a2b3:	mov    $0x1d,%esi
   5a2b8:	vzeroupper
   5a2bb:	call   *0x17be87(%rip)        # 1d6148 <_DYNAMIC+0x348>
   5a2c1:	jmp    5a643 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x45e3>
   5a2c6:	vmovupd 0x2a8(%rsp),%xmm0
   5a2cf:	vmovapd %xmm0,0x200(%rsp)
   5a2d8:	lea    -0x4ecf7(%rip),%rdi        # b5e8 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x13b8>
   5a2df:	lea    0x17796a(%rip),%rcx        # 1d1c50 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.52.llvm.3671060894988460240+0xe60>
   5a2e6:	lea    0x1770b3(%rip),%r8        # 1d13a0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.52.llvm.3671060894988460240+0x5b0>
   5a2ed:	lea    0x200(%rsp),%rdx
   5a2f5:	mov    $0x2b,%esi
   5a2fa:	call   *0x17bda8(%rip)        # 1d60a8 <_DYNAMIC+0x2a8>
   5a300:	jmp    5a643 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x45e3>
   5a305:	lea    0x177ba4(%rip),%rdi        # 1d1eb0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.52.llvm.3671060894988460240+0x10c0>
   5a30c:	vzeroupper
   5a30f:	call   *0x17bdd3(%rip)        # 1d60e8 <_DYNAMIC+0x2e8>
   5a315:	jmp    5a643 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x45e3>
   5a31a:	lea    -0x4ed39(%rip),%rdi        # b5e8 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x13b8>
   5a321:	lea    0x177948(%rip),%rcx        # 1d1c70 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.52.llvm.3671060894988460240+0xe80>
   5a328:	lea    0x177b69(%rip),%r8        # 1d1e98 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.52.llvm.3671060894988460240+0x10a8>
   5a32f:	lea    0xd0(%rsp),%rdx
   5a337:	mov    $0x2b,%esi
   5a33c:	vzeroupper
   5a33f:	call   *0x17bd63(%rip)        # 1d60a8 <_DYNAMIC+0x2a8>
   5a345:	jmp    5a643 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x45e3>
   5a34a:	mov    $0x1000,%edi
   5a34f:	mov    %r13,%rsi
   5a352:	call   *0x17bd58(%rip)        # 1d60b0 <_DYNAMIC+0x2b0>
   5a358:	jmp    5a643 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x45e3>
   5a35d:	lea    0x176b8c(%rip),%rsi        # 1d0ef0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.52.llvm.3671060894988460240+0x100>
   5a364:	lea    0x176b5d(%rip),%rax        # 1d0ec8 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.52.llvm.3671060894988460240+0xd8>
   5a36b:	mov    0x30(%rsp),%rdi
   5a370:	mov    %rax,(%rdi)
   5a373:	vmovapd -0x5063b(%rip),%ymm0        # 9d40 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x3a8>
   5a37b:	vmovupd %ymm0,0x8(%rdi)
   5a380:	vzeroupper
   5a383:	call   *0x17bd4f(%rip)        # 1d60d8 <_DYNAMIC+0x2d8>
   5a389:	jmp    5a643 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x45e3>
   5a38e:	vmovupd 0x2a8(%rsp),%xmm0
   5a397:	vmovapd %xmm0,0x200(%rsp)
   5a3a0:	lea    -0x4edbf(%rip),%rdi        # b5e8 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x13b8>
   5a3a7:	lea    0x1778a2(%rip),%rcx        # 1d1c50 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.52.llvm.3671060894988460240+0xe60>
   5a3ae:	lea    0x176b53(%rip),%r8        # 1d0f08 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.52.llvm.3671060894988460240+0x118>
   5a3b5:	lea    0x200(%rsp),%rdx
   5a3bd:	mov    $0x2b,%esi
   5a3c2:	call   *0x17bce0(%rip)        # 1d60a8 <_DYNAMIC+0x2a8>
   5a3c8:	jmp    5a643 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x45e3>
   5a3cd:	lea    0x176b4c(%rip),%rax        # 1d0f20 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.52.llvm.3671060894988460240+0x130>
   5a3d4:	mov    %rax,0x2a0(%rsp)
   5a3dc:	lea    0x176b4d(%rip),%rsi        # 1d0f30 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.52.llvm.3671060894988460240+0x140>
   5a3e3:	jmp    5a403 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x43a3>
   5a3e5:	lea    0x176b34(%rip),%rax        # 1d0f20 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.52.llvm.3671060894988460240+0x130>
   5a3ec:	mov    %rax,0x2a0(%rsp)
   5a3f4:	lea    0x176b4d(%rip),%rsi        # 1d0f48 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.52.llvm.3671060894988460240+0x158>
   5a3fb:	lea    0x2a0(%rsp),%r13
   5a403:	vmovapd -0x506cb(%rip),%ymm0        # 9d40 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x3a8>
   5a40b:	vmovupd %ymm0,0x8(%r13)
   5a411:	mov    %r13,%rdi
   5a414:	vzeroupper
   5a417:	call   *0x17bcbb(%rip)        # 1d60d8 <_DYNAMIC+0x2d8>
   5a41d:	jmp    5a643 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x45e3>
   5a422:	vmovupd 0x2a8(%rsp),%xmm0
   5a42b:	vmovapd %xmm0,0x70(%rsp)
   5a431:	lea    -0x4ee50(%rip),%rdi        # b5e8 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x13b8>
   5a438:	lea    0x177811(%rip),%rcx        # 1d1c50 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.52.llvm.3671060894988460240+0xe60>
   5a43f:	lea    0x176b1a(%rip),%r8        # 1d0f60 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.52.llvm.3671060894988460240+0x170>
   5a446:	lea    0x70(%rsp),%rdx
   5a44b:	mov    $0x2b,%esi
   5a450:	call   *0x17bc52(%rip)        # 1d60a8 <_DYNAMIC+0x2a8>
   5a456:	jmp    5a643 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x45e3>
   5a45b:	lea    0x176b16(%rip),%rax        # 1d0f78 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.52.llvm.3671060894988460240+0x188>
   5a462:	mov    %rax,0x2a0(%rsp)
   5a46a:	movq   $0x1,0x2a8(%rsp)
   5a476:	lea    0x598(%rsp),%rdx
   5a47e:	movq   $0x8,0x2b0(%rsp)
   5a48a:	vxorpd %xmm0,%xmm0,%xmm0
   5a48e:	vmovupd %xmm0,0x2b8(%rsp)
   5a497:	lea    0x176aea(%rip),%r8        # 1d0f88 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.52.llvm.3671060894988460240+0x198>
   5a49e:	lea    0x530(%rsp),%rsi
   5a4a6:	lea    0x2a0(%rsp),%rcx
   5a4ae:	xor    %edi,%edi
   5a4b0:	vzeroupper
   5a4b3:	call   *0x17bc3f(%rip)        # 1d60f8 <_DYNAMIC+0x2f8>
   5a4b9:	jmp    5a643 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x45e3>
   5a4be:	vzeroupper
   5a4c1:	call   *0x17bc39(%rip)        # 1d6100 <_DYNAMIC+0x300>
   5a4c7:	lea    0x2a0(%rsp),%rdi
   5a4cf:	mov    0x28(%rsp),%rsi
   5a4d4:	mov    0x6c(%rsp),%edx
   5a4d8:	call   17a680 <<compare_benchmark::PoppyPublic<44> as compare_benchmark::Filter>::new>
   5a4dd:	movabs $0x8000000000000000,%rax
   5a4e7:	cmp    %rax,0x2a0(%rsp)
   5a4ef:	je     5a583 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x4523>
   5a4f5:	vmovupd 0x2a0(%rsp),%ymm0
   5a4fe:	vmovdqu 0x2c0(%rsp),%ymm1
   5a507:	vmovdqu 0x2e0(%rsp),%ymm2
   5a510:	vmovdqu 0x300(%rsp),%ymm3
   5a519:	vmovdqu %ymm3,0x260(%rsp)
   5a522:	vmovdqu %ymm2,0x240(%rsp)
   5a52b:	vmovdqu %ymm1,0x220(%rsp)
   5a534:	vmovupd %ymm0,0x200(%rsp)
   5a53d:	vzeroupper
   5a540:	call   *0x17bbba(%rip)        # 1d6100 <_DYNAMIC+0x300>
   5a546:	lea    0x1769d3(%rip),%rax        # 1d0f20 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.52.llvm.3671060894988460240+0x130>
   5a54d:	mov    %rax,0x2a0(%rsp)
   5a555:	vmovapd -0x5081d(%rip),%ymm0        # 9d40 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x3a8>
   5a55d:	vmovupd %ymm0,0x2a8(%rsp)
   5a566:	lea    0x176e1b(%rip),%rsi        # 1d1388 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.52.llvm.3671060894988460240+0x598>
   5a56d:	lea    0x2a0(%rsp),%rdi
   5a575:	vzeroupper
   5a578:	call   *0x17bb5a(%rip)        # 1d60d8 <_DYNAMIC+0x2d8>
   5a57e:	jmp    5a643 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x45e3>
   5a583:	vmovupd 0x2a8(%rsp),%xmm0
   5a58c:	vmovapd %xmm0,0x130(%rsp)
   5a595:	lea    -0x4efb4(%rip),%rdi        # b5e8 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x13b8>
   5a59c:	lea    0x1776ad(%rip),%rcx        # 1d1c50 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.52.llvm.3671060894988460240+0xe60>
   5a5a3:	lea    0x176dc6(%rip),%r8        # 1d1370 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.52.llvm.3671060894988460240+0x580>
   5a5aa:	lea    0x130(%rsp),%rdx
   5a5b2:	mov    $0x2b,%esi
   5a5b7:	call   *0x17baeb(%rip)        # 1d60a8 <_DYNAMIC+0x2a8>
   5a5bd:	jmp    5a643 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x45e3>
   5a5c2:	lea    0x176cb7(%rip),%rdx        # 1d1280 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.52.llvm.3671060894988460240+0x490>
   5a5c9:	mov    $0x4,%esi
   5a5ce:	mov    0xc8(%rsp),%rdi
   5a5d6:	call   *0x17ba84(%rip)        # 1d6060 <_DYNAMIC+0x260>
   5a5dc:	jmp    5a643 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x45e3>
   5a5de:	lea    -0x4ea9f(%rip),%rdi        # bb46 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x1916>
   5a5e5:	lea    0x1776c4(%rip),%rcx        # 1d1cb0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.52.llvm.3671060894988460240+0xec0>
   5a5ec:	lea    0x178b1d(%rip),%r8        # 1d3110 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.52.llvm.3671060894988460240+0x2320>
   5a5f3:	lea    0xd0(%rsp),%rdx
   5a5fb:	mov    $0x37,%esi
   5a600:	call   *0x17baa2(%rip)        # 1d60a8 <_DYNAMIC+0x2a8>
   5a606:	jmp    5a643 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x45e3>
   5a608:	lea    0x1768c9(%rip),%rsi        # 1d0ed8 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.52.llvm.3671060894988460240+0xe8>
   5a60f:	jmp    5a364 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x4304>
   5a614:	lea    0x177705(%rip),%rdi        # 1d1d20 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.52.llvm.3671060894988460240+0xf30>
   5a61b:	call   *0x17bb2f(%rip)        # 1d6150 <_DYNAMIC+0x350>
   5a621:	jmp    5a643 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x45e3>
   5a623:	mov    $0x8,%edi
   5a628:	mov    %r13,%rsi
   5a62b:	call   *0x17ba1f(%rip)        # 1d6050 <_DYNAMIC+0x250>
   5a631:	jmp    5a643 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x45e3>
   5a633:	mov    $0x1,%edi
   5a638:	mov    $0x3,%esi
   5a63d:	call   *0x17ba0d(%rip)        # 1d6050 <_DYNAMIC+0x250>
   5a643:	ud2
   5a645:	mov    %rax,%r14
   5a648:	cmpq   $0x0,0xd0(%rsp)
   5a651:	je     5a670 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x4610>
   5a653:	mov    0xd8(%rsp),%rdi
   5a65b:	call   *0x17b9a7(%rip)        # 1d6008 <free@GLIBC_2.2.5>
   5a661:	jmp    5a670 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x4610>
   5a663:	mov    %rax,%r14
   5a666:	jmp    5a689 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x4629>
   5a668:	jmp    5a764 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x4704>
   5a66d:	mov    %rax,%r14
   5a670:	cmpq   $0x0,0x100(%rsp)
   5a679:	je     5a689 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x4629>
   5a67b:	mov    0x108(%rsp),%rdi
   5a683:	call   *0x17b97f(%rip)        # 1d6008 <free@GLIBC_2.2.5>
   5a689:	lea    0x480(%rsp),%rdi
   5a691:	jmp    5a6d9 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x4679>
   5a693:	mov    %rax,%r14
   5a696:	cmpq   $0x0,0x70(%rsp)
   5a69c:	je     5a6de <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x467e>
   5a69e:	mov    0x78(%rsp),%rdi
   5a6a3:	call   *0x17b95f(%rip)        # 1d6008 <free@GLIBC_2.2.5>
   5a6a9:	jmp    5a6de <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x467e>
   5a6ab:	jmp    5a6ad <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x464d>
   5a6ad:	mov    %rax,%r14
   5a6b0:	jmp    5a6de <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x467e>
   5a6b2:	jmp    5a821 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x47c1>
   5a6b7:	mov    %rax,%r14
   5a6ba:	lea    0x70(%rsp),%rdi
   5a6bf:	call   ff530 <core::ptr::drop_in_place::<alloc::vec::Vec<alloc::string::String>>>
   5a6c4:	jmp    5a6c9 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x4669>
   5a6c6:	mov    %rax,%r14
   5a6c9:	mov    %rbx,0x110(%rsp)
   5a6d1:	lea    0x100(%rsp),%rdi
   5a6d9:	call   ff530 <core::ptr::drop_in_place::<alloc::vec::Vec<alloc::string::String>>>
   5a6de:	cmpq   $0x0,0x460(%rsp)
   5a6e7:	jne    5a6f3 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x4693>
   5a6e9:	mov    0x48(%rsp),%r15
   5a6ee:	jmp    5a824 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x47c4>
   5a6f3:	mov    0x468(%rsp),%rdi
   5a6fb:	call   *0x17b907(%rip)        # 1d6008 <free@GLIBC_2.2.5>
   5a701:	mov    0x48(%rsp),%r15
   5a706:	jmp    5a824 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x47c4>
   5a70b:	jmp    5a81c <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x47bc>
   5a710:	mov    %rax,%r14
   5a713:	mov    0x20(%rsp),%rdi
   5a718:	cmpq   $0x0,0x8(%rsp)
   5a71e:	jne    5a87c <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x481c>
   5a724:	jmp    5a882 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x4822>
   5a729:	jmp    5a81c <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x47bc>
   5a72e:	jmp    5a81c <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x47bc>
   5a733:	jmp    5a7a9 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x4749>
   5a735:	jmp    5a7a9 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x4749>
   5a737:	jmp    5a764 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x4704>
   5a739:	jmp    5a81c <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x47bc>
   5a73e:	jmp    5a7a9 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x4749>
   5a740:	jmp    5a821 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x47c1>
   5a745:	mov    %rax,%r14
   5a748:	cmpq   $0x0,0x70(%rsp)
   5a74e:	je     5a824 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x47c4>
   5a754:	mov    0x78(%rsp),%rdi
   5a759:	call   *0x17b8a9(%rip)        # 1d6008 <free@GLIBC_2.2.5>
   5a75f:	jmp    5a824 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x47c4>
   5a764:	mov    %rax,%r14
   5a767:	jmp    5a8b9 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x4859>
   5a76c:	mov    %rax,%r14
   5a76f:	lea    0x70(%rsp),%rdi
   5a774:	call   ff5a0 <core::ptr::drop_in_place::<alloc::boxed::Box<dyn core::error::Error>>>
   5a779:	jmp    5a824 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x47c4>
   5a77e:	call   *0x17b9d4(%rip)        # 1d6158 <_DYNAMIC+0x358>
   5a784:	mov    %rax,%r14
   5a787:	lea    0x200(%rsp),%rdi
   5a78f:	call   ff5a0 <core::ptr::drop_in_place::<alloc::boxed::Box<dyn core::error::Error>>>
   5a794:	jmp    5a8b9 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x4859>
   5a799:	call   *0x17b9b9(%rip)        # 1d6158 <_DYNAMIC+0x358>
   5a79f:	mov    %rax,%r14
   5a7a2:	jmp    5a8f7 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x4897>
   5a7a7:	jmp    5a81c <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x47bc>
   5a7a9:	mov    %rax,%r14
   5a7ac:	lea    0x200(%rsp),%rdi
   5a7b4:	call   ff4f0 <core::ptr::drop_in_place::<compare_benchmark::PoppyPublic<0>>>
   5a7b9:	jmp    5a8b9 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x4859>
   5a7be:	mov    %rax,%r14
   5a7c1:	jmp    5a905 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x48a5>
   5a7c6:	jmp    5a821 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x47c1>
   5a7c8:	jmp    5a821 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x47c1>
   5a7ca:	mov    %rax,%r14
   5a7cd:	mov    0x48(%rsp),%r15
   5a7d2:	jmp    5a824 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x47c4>
   5a7d4:	mov    %rax,%r14
   5a7d7:	lea    0x200(%rsp),%rdi
   5a7df:	call   ff5a0 <core::ptr::drop_in_place::<alloc::boxed::Box<dyn core::error::Error>>>
   5a7e4:	jmp    5a8b9 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x4859>
   5a7e9:	call   *0x17b969(%rip)        # 1d6158 <_DYNAMIC+0x358>
   5a7ef:	mov    %rax,%r14
   5a7f2:	lea    0x130(%rsp),%rdi
   5a7fa:	call   ff5a0 <core::ptr::drop_in_place::<alloc::boxed::Box<dyn core::error::Error>>>
   5a7ff:	jmp    5a8b9 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x4859>
   5a804:	call   *0x17b94e(%rip)        # 1d6158 <_DYNAMIC+0x358>
   5a80a:	mov    %rax,%r14
   5a80d:	mov    0x20(%rsp),%rdi
   5a812:	cmpq   $0x0,0x8(%rsp)
   5a818:	jne    5a87c <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x481c>
   5a81a:	jmp    5a882 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x4822>
   5a81c:	mov    %rax,%r14
   5a81f:	jmp    5a882 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x4822>
   5a821:	mov    %rax,%r14
   5a824:	cmpq   $0x0,0x130(%rsp)
   5a82d:	jne    5a9c9 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x4969>
   5a833:	cmpq   $0x0,0x148(%rsp)
   5a83c:	jne    5a9e6 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x4986>
   5a842:	cmpq   $0x0,0x160(%rsp)
   5a84b:	jne    5aa03 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x49a3>
   5a851:	cmpq   $0x0,0x178(%rsp)
   5a85a:	jne    5aa20 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x49c0>
   5a860:	cmpq   $0x0,0x4c8(%rsp)
   5a869:	jne    5aa3d <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x49dd>
   5a86f:	mov    0x20(%rsp),%rdi
   5a874:	cmpq   $0x0,0x8(%rsp)
   5a87a:	je     5a882 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x4822>
   5a87c:	call   *0x17b786(%rip)        # 1d6008 <free@GLIBC_2.2.5>
   5a882:	cmpq   $0x0,0x200(%rsp)
   5a88b:	jne    5a98a <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x492a>
   5a891:	cmpq   $0x0,0x218(%rsp)
   5a89a:	jne    5a9a7 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x4947>
   5a8a0:	cmpq   $0x0,0x230(%rsp)
   5a8a9:	je     5a8b9 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x4859>
   5a8ab:	mov    0x238(%rsp),%rdi
   5a8b3:	call   *0x17b74f(%rip)        # 1d6008 <free@GLIBC_2.2.5>
   5a8b9:	cmpq   $0x0,0x1e8(%rsp)
   5a8c2:	jne    5a932 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x48d2>
   5a8c4:	cmpq   $0x0,0x1d0(%rsp)
   5a8cd:	jne    5a94b <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x48eb>
   5a8cf:	cmpq   $0x0,0x1b8(%rsp)
   5a8d8:	jne    5a968 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x4908>
   5a8de:	cmpq   $0x0,0x1a0(%rsp)
   5a8e7:	je     5a8f7 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x4897>
   5a8e9:	mov    0x1a8(%rsp),%rdi
   5a8f1:	call   *0x17b711(%rip)        # 1d6008 <free@GLIBC_2.2.5>
   5a8f7:	mov    0xb0(%rsp),%rdi
   5a8ff:	call   *0x17b703(%rip)        # 1d6008 <free@GLIBC_2.2.5>
   5a905:	mov    %r15,%rdi
   5a908:	call   *0x17b6fa(%rip)        # 1d6008 <free@GLIBC_2.2.5>
   5a90e:	mov    0x50(%rsp),%r15
   5a913:	mov    0xa8(%rsp),%rdi
   5a91b:	call   *0x17b6e7(%rip)        # 1d6008 <free@GLIBC_2.2.5>
   5a921:	mov    %r15,%rdi
   5a924:	call   *0x17b6de(%rip)        # 1d6008 <free@GLIBC_2.2.5>
   5a92a:	mov    %r14,%rdi
   5a92d:	call   1cfd20 <_Unwind_Resume@plt>
   5a932:	mov    0x1f0(%rsp),%rdi
   5a93a:	call   *0x17b6c8(%rip)        # 1d6008 <free@GLIBC_2.2.5>
   5a940:	cmpq   $0x0,0x1d0(%rsp)
   5a949:	je     5a8cf <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x486f>
   5a94b:	mov    0x1d8(%rsp),%rdi
   5a953:	call   *0x17b6af(%rip)        # 1d6008 <free@GLIBC_2.2.5>
   5a959:	cmpq   $0x0,0x1b8(%rsp)
   5a962:	je     5a8de <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x487e>
   5a968:	mov    0x1c0(%rsp),%rdi
   5a970:	call   *0x17b692(%rip)        # 1d6008 <free@GLIBC_2.2.5>
   5a976:	cmpq   $0x0,0x1a0(%rsp)
   5a97f:	jne    5a8e9 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x4889>
   5a985:	jmp    5a8f7 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x4897>
   5a98a:	mov    0x208(%rsp),%rdi
   5a992:	call   *0x17b670(%rip)        # 1d6008 <free@GLIBC_2.2.5>
   5a998:	cmpq   $0x0,0x218(%rsp)
   5a9a1:	je     5a8a0 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x4840>
   5a9a7:	mov    0x220(%rsp),%rdi
   5a9af:	call   *0x17b653(%rip)        # 1d6008 <free@GLIBC_2.2.5>
   5a9b5:	cmpq   $0x0,0x230(%rsp)
   5a9be:	jne    5a8ab <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x484b>
   5a9c4:	jmp    5a8b9 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x4859>
   5a9c9:	mov    0x138(%rsp),%rdi
   5a9d1:	call   *0x17b631(%rip)        # 1d6008 <free@GLIBC_2.2.5>
   5a9d7:	cmpq   $0x0,0x148(%rsp)
   5a9e0:	je     5a842 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x47e2>
   5a9e6:	mov    0x150(%rsp),%rdi
   5a9ee:	call   *0x17b614(%rip)        # 1d6008 <free@GLIBC_2.2.5>
   5a9f4:	cmpq   $0x0,0x160(%rsp)
   5a9fd:	je     5a851 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x47f1>
   5aa03:	mov    0x168(%rsp),%rdi
   5aa0b:	call   *0x17b5f7(%rip)        # 1d6008 <free@GLIBC_2.2.5>
   5aa11:	cmpq   $0x0,0x178(%rsp)
   5aa1a:	je     5a860 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x4800>
   5aa20:	mov    0x180(%rsp),%rdi
   5aa28:	call   *0x17b5da(%rip)        # 1d6008 <free@GLIBC_2.2.5>
   5aa2e:	cmpq   $0x0,0x4c8(%rsp)
   5aa37:	je     5a86f <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x480f>
   5aa3d:	mov    0x4d0(%rsp),%rdi
   5aa45:	call   *0x17b5bd(%rip)        # 1d6008 <free@GLIBC_2.2.5>
   5aa4b:	mov    0x20(%rsp),%rdi
   5aa50:	cmpq   $0x0,0x8(%rsp)
   5aa56:	jne    5a87c <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x481c>
   5aa5c:	jmp    5a882 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x4822>
   5aa61:	int3
   5aa62:	int3
   5aa63:	int3
   5aa64:	int3
   5aa65:	int3
   5aa66:	int3
   5aa67:	int3
   5aa68:	int3
   5aa69:	int3
   5aa6a:	int3
   5aa6b:	int3
   5aa6c:	int3
   5aa6d:	int3
   5aa6e:	int3
   5aa6f:	int3

