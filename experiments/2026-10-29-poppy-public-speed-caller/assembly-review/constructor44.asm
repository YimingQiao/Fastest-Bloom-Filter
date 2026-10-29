000000000017a680 <<compare_benchmark::PoppyPublic<44> as compare_benchmark::Filter>::new>:
  17a680:	push   %r15
  17a682:	push   %r14
  17a684:	push   %r12
  17a686:	push   %rbx
  17a687:	sub    $0x148,%rsp
  17a68e:	mov    %rsi,%r15
  17a691:	mov    %rdi,%rbx
  17a694:	movabs $0x8000000000000000,%r12
  17a69e:	mov    %rsi,0x20(%rsp)
  17a6a3:	cmp    $0x10000,%rsi
  17a6aa:	sete   %al
  17a6ad:	cmp    $0x18,%edx
  17a6b0:	sete   %cl
  17a6b3:	test   %cl,%al
  17a6b5:	jne    17a6de <<compare_benchmark::PoppyPublic<44> as compare_benchmark::Filter>::new+0x5e>
  17a6b7:	lea    -0x16f0ab(%rip),%rdi        # b613 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x13e3>
  17a6be:	mov    $0x34,%esi
  17a6c3:	call   *0x5b9f7(%rip)        # 1d60c0 <_DYNAMIC+0x2c0>
  17a6c9:	test   %rax,%rax
  17a6cc:	je     17a6de <<compare_benchmark::PoppyPublic<44> as compare_benchmark::Filter>::new+0x5e>
  17a6ce:	mov    %rax,0x8(%rbx)
  17a6d2:	mov    %rdx,0x10(%rbx)
  17a6d6:	mov    %r12,(%rbx)
  17a6d9:	jmp    17a84c <<compare_benchmark::PoppyPublic<44> as compare_benchmark::Filter>::new+0x1cc>
  17a6de:	lea    0xc8(%rsp),%r14
  17a6e6:	vmovsd -0x170e76(%rip),%xmm0        # 9878 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x255>
  17a6ee:	mov    %r14,%rdi
  17a6f1:	mov    %r15,%rsi
  17a6f4:	mov    $0x3,%edx
  17a6f9:	call   196ec0 <<poppy_filters::bloom::v2::BloomFilter>::make>
  17a6fe:	mov    0xc8(%rsp),%rax
  17a706:	vmovdqu 0xd0(%rsp),%xmm0
  17a70f:	vmovdqa %xmm0,(%rsp)
  17a714:	mov    0xe0(%rsp),%rcx
  17a71c:	mov    %rcx,0x10(%rsp)
  17a721:	cmp    %r12,%rax
  17a724:	jne    17a763 <<compare_benchmark::PoppyPublic<44> as compare_benchmark::Filter>::new+0xe3>
  17a726:	mov    $0x18,%edi
  17a72b:	call   *0x5b8c7(%rip)        # 1d5ff8 <malloc@GLIBC_2.2.5>
  17a731:	test   %rax,%rax
  17a734:	je     17a85e <<compare_benchmark::PoppyPublic<44> as compare_benchmark::Filter>::new+0x1de>
  17a73a:	mov    0x10(%rsp),%rcx
  17a73f:	mov    %rcx,0x10(%rax)
  17a743:	vmovaps (%rsp),%xmm0
  17a748:	vmovups %xmm0,(%rax)
  17a74c:	mov    %rax,0x8(%rbx)
  17a750:	lea    0x58751(%rip),%rax        # 1d2ea8 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.52.llvm.3671060894988460240+0x20b8>
  17a757:	mov    %rax,0x10(%rbx)
  17a75b:	mov    %r12,(%rbx)
  17a75e:	jmp    17a84c <<compare_benchmark::PoppyPublic<44> as compare_benchmark::Filter>::new+0x1cc>
  17a763:	vmovups 0xe8(%rsp),%ymm0
  17a76c:	vmovups 0x108(%rsp),%ymm1
  17a775:	vmovups 0x128(%rsp),%ymm2
  17a77e:	vmovups %ymm2,0xa8(%rsp)
  17a787:	vmovups %ymm1,0x88(%rsp)
  17a790:	vmovups %ymm0,0x68(%rsp)
  17a796:	vmovdqa (%rsp),%xmm0
  17a79b:	vmovdqu %xmm0,0x50(%rsp)
  17a7a1:	mov    0x10(%rsp),%rcx
  17a7a6:	mov    %rcx,0x60(%rsp)
  17a7ab:	mov    %rax,0x48(%rsp)
  17a7b0:	mov    0xa8(%rsp),%rax
  17a7b8:	mov    %rax,0x28(%rsp)
  17a7bd:	cmp    %r15,%rax
  17a7c0:	jne    17a870 <<compare_benchmark::PoppyPublic<44> as compare_benchmark::Filter>::new+0x1f0>
  17a7c6:	vmovq  0xb0(%rsp),%xmm0
  17a7cf:	vmovq  %xmm0,0x30(%rsp)
  17a7d5:	vmovq  %xmm0,%rax
  17a7da:	movabs $0x3ef0c18cafbc307f,%rcx
  17a7e4:	cmp    %rcx,%rax
  17a7e7:	jne    17a883 <<compare_benchmark::PoppyPublic<44> as compare_benchmark::Filter>::new+0x203>
  17a7ed:	mov    0x98(%rsp),%rax
  17a7f5:	shl    $0xc,%rax
  17a7f9:	add    0xa0(%rsp),%rax
  17a801:	mov    %rax,0x38(%rsp)
  17a806:	movq   $0x30000,0x40(%rsp)
  17a80f:	cmp    $0x30000,%rax
  17a815:	jne    17a8b7 <<compare_benchmark::PoppyPublic<44> as compare_benchmark::Filter>::new+0x237>
  17a81b:	vmovups 0x48(%rsp),%ymm0
  17a821:	vmovups 0x68(%rsp),%ymm1
  17a827:	vmovups 0x88(%rsp),%ymm2
  17a830:	vmovups 0xa8(%rsp),%ymm3
  17a839:	vmovups %ymm3,0x60(%rbx)
  17a83e:	vmovups %ymm2,0x40(%rbx)
  17a843:	vmovups %ymm1,0x20(%rbx)
  17a848:	vmovups %ymm0,(%rbx)
  17a84c:	add    $0x148,%rsp
  17a853:	pop    %rbx
  17a854:	pop    %r12
  17a856:	pop    %r14
  17a858:	pop    %r15
  17a85a:	vzeroupper
  17a85d:	ret
  17a85e:	mov    $0x8,%edi
  17a863:	mov    $0x18,%esi
  17a868:	call   *0x5b842(%rip)        # 1d60b0 <_DYNAMIC+0x2b0>
  17a86e:	jmp    17a8dd <<compare_benchmark::PoppyPublic<44> as compare_benchmark::Filter>::new+0x25d>
  17a870:	lea    0x585c9(%rip),%r8        # 1d2e40 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.52.llvm.3671060894988460240+0x2050>
  17a877:	lea    0x20(%rsp),%rdx
  17a87c:	lea    0x28(%rsp),%rsi
  17a881:	jmp    17a8c8 <<compare_benchmark::PoppyPublic<44> as compare_benchmark::Filter>::new+0x248>
  17a883:	movq   $0x0,0xc8(%rsp)
  17a88f:	lea    0x57d2a(%rip),%rdx        # 1d25c0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.52.llvm.3671060894988460240+0x17d0>
  17a896:	lea    0x585bb(%rip),%r8        # 1d2e58 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.52.llvm.3671060894988460240+0x2068>
  17a89d:	lea    0x30(%rsp),%rsi
  17a8a2:	lea    0xc8(%rsp),%rcx
  17a8aa:	xor    %edi,%edi
  17a8ac:	vzeroupper
  17a8af:	call   *0x5b903(%rip)        # 1d61b8 <_DYNAMIC+0x3b8>
  17a8b5:	jmp    17a8dd <<compare_benchmark::PoppyPublic<44> as compare_benchmark::Filter>::new+0x25d>
  17a8b7:	lea    0x585b2(%rip),%r8        # 1d2e70 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.52.llvm.3671060894988460240+0x2080>
  17a8be:	lea    0x40(%rsp),%rdx
  17a8c3:	lea    0x38(%rsp),%rsi
  17a8c8:	movq   $0x0,(%r14)
  17a8cf:	xor    %edi,%edi
  17a8d1:	mov    %r14,%rcx
  17a8d4:	vzeroupper
  17a8d7:	call   *0x5b81b(%rip)        # 1d60f8 <_DYNAMIC+0x2f8>
  17a8dd:	ud2
  17a8df:	mov    %rax,%rbx
  17a8e2:	mov    %rsp,%rdi
  17a8e5:	call   ff670 <core::ptr::drop_in_place::<poppy_filters::bloom::Error>>
  17a8ea:	mov    %rbx,%rdi
  17a8ed:	call   1cfd20 <_Unwind_Resume@plt>
  17a8f2:	call   *0x5b860(%rip)        # 1d6158 <_DYNAMIC+0x358>
  17a8f8:	mov    %rax,%rbx
  17a8fb:	lea    0x48(%rsp),%rdi
  17a900:	call   ff7e0 <core::ptr::drop_in_place::<poppy_filters::bloom::v2::BloomFilter>>
  17a905:	mov    %rbx,%rdi
  17a908:	call   1cfd20 <_Unwind_Resume@plt>
  17a90d:	int3
  17a90e:	int3
  17a90f:	int3

