000000000005c750 <void inline_single_kernel<false, external_bloom::Fixed16, unsigned long>(external_bloom::Fixed16 const&, unsigned long, unsigned long const*, unsigned int*)>:
   5c750:	48 85 f6             	test   %rsi,%rsi
   5c753:	0f 84 04 01 00 00    	je     5c85d <void inline_single_kernel<false, external_bloom::Fixed16, unsigned long>(external_bloom::Fixed16 const&, unsigned long, unsigned long const*, unsigned int*)+0x10d>
   5c759:	48 83 fe 01          	cmp    $0x1,%rsi
   5c75d:	75 07                	jne    5c766 <void inline_single_kernel<false, external_bloom::Fixed16, unsigned long>(external_bloom::Fixed16 const&, unsigned long, unsigned long const*, unsigned int*)+0x16>
   5c75f:	31 c0                	xor    %eax,%eax
   5c761:	e9 af 00 00 00       	jmp    5c815 <void inline_single_kernel<false, external_bloom::Fixed16, unsigned long>(external_bloom::Fixed16 const&, unsigned long, unsigned long const*, unsigned int*)+0xc5>
   5c766:	49 89 f0             	mov    %rsi,%r8
   5c769:	49 83 e0 fe          	and    $0xfffffffffffffffe,%r8
   5c76d:	31 c0                	xor    %eax,%eax
   5c76f:	c5 f9 6f 05 c9 84 fa 	vmovdqa -0x57b37(%rip),%xmm0        # 4c40 <typeinfo name for main::$_60+0x470>
   5c776:	ff
   5c777:	c4 e2 79 59 0d 70 6b 	vpbroadcastq -0x59490(%rip),%xmm1        # 32f0 <_IO_stdin_used+0x3c>
   5c77e:	fa ff
   5c780:	4c 8b 0c c2          	mov    (%rdx,%rax,8),%r9
   5c784:	62 d2 7d 08 7c d1    	vpbroadcastd %r9d,%xmm2
   5c78a:	49 c1 e9 20          	shr    $0x20,%r9
   5c78e:	44 8b 17             	mov    (%rdi),%r10d
   5c791:	4d 0f af d1          	imul   %r9,%r10
   5c795:	c5 e9 e5 d0          	vpmulhw %xmm0,%xmm2,%xmm2
   5c799:	c4 e2 71 00 d2       	vpshufb %xmm2,%xmm1,%xmm2
   5c79e:	4c 8b 4f 08          	mov    0x8(%rdi),%r9
   5c7a2:	49 c1 ea 1c          	shr    $0x1c,%r10
   5c7a6:	49 83 e2 f0          	and    $0xfffffffffffffff0,%r10
   5c7aa:	c4 81 7a 6f 1c 11    	vmovdqu (%r9,%r10,1),%xmm3
   5c7b0:	45 31 c9             	xor    %r9d,%r9d
   5c7b3:	c4 e2 79 17 da       	vptest %xmm2,%xmm3
   5c7b8:	41 0f 92 c1          	setb   %r9b
   5c7bc:	44 89 0c 81          	mov    %r9d,(%rcx,%rax,4)
   5c7c0:	4c 8b 4c c2 08       	mov    0x8(%rdx,%rax,8),%r9
   5c7c5:	62 d2 7d 08 7c d1    	vpbroadcastd %r9d,%xmm2
   5c7cb:	49 c1 e9 20          	shr    $0x20,%r9
   5c7cf:	44 8b 17             	mov    (%rdi),%r10d
   5c7d2:	4d 0f af d1          	imul   %r9,%r10
   5c7d6:	c5 e9 e5 d0          	vpmulhw %xmm0,%xmm2,%xmm2
   5c7da:	c4 e2 71 00 d2       	vpshufb %xmm2,%xmm1,%xmm2
   5c7df:	4c 8b 4f 08          	mov    0x8(%rdi),%r9
   5c7e3:	49 c1 ea 1c          	shr    $0x1c,%r10
   5c7e7:	49 83 e2 f0          	and    $0xfffffffffffffff0,%r10
   5c7eb:	c4 81 7a 6f 1c 11    	vmovdqu (%r9,%r10,1),%xmm3
   5c7f1:	45 31 c9             	xor    %r9d,%r9d
   5c7f4:	c4 e2 79 17 da       	vptest %xmm2,%xmm3
   5c7f9:	41 0f 92 c1          	setb   %r9b
   5c7fd:	44 89 4c 81 04       	mov    %r9d,0x4(%rcx,%rax,4)
   5c802:	48 83 c0 02          	add    $0x2,%rax
   5c806:	49 39 c0             	cmp    %rax,%r8
   5c809:	0f 85 71 ff ff ff    	jne    5c780 <void inline_single_kernel<false, external_bloom::Fixed16, unsigned long>(external_bloom::Fixed16 const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   5c80f:	40 f6 c6 01          	test   $0x1,%sil
   5c813:	74 48                	je     5c85d <void inline_single_kernel<false, external_bloom::Fixed16, unsigned long>(external_bloom::Fixed16 const&, unsigned long, unsigned long const*, unsigned int*)+0x10d>
   5c815:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
   5c819:	62 f2 7d 08 7c c2    	vpbroadcastd %edx,%xmm0
   5c81f:	48 c1 ea 20          	shr    $0x20,%rdx
   5c823:	8b 37                	mov    (%rdi),%esi
   5c825:	48 0f af f2          	imul   %rdx,%rsi
   5c829:	c5 f9 e5 05 0f 84 fa 	vpmulhw -0x57bf1(%rip),%xmm0,%xmm0        # 4c40 <typeinfo name for main::$_60+0x470>
   5c830:	ff
   5c831:	c4 e2 79 59 0d b6 6a 	vpbroadcastq -0x5954a(%rip),%xmm1        # 32f0 <_IO_stdin_used+0x3c>
   5c838:	fa ff
   5c83a:	c4 e2 71 00 c0       	vpshufb %xmm0,%xmm1,%xmm0
   5c83f:	48 8b 57 08          	mov    0x8(%rdi),%rdx
   5c843:	48 c1 ee 1c          	shr    $0x1c,%rsi
   5c847:	48 83 e6 f0          	and    $0xfffffffffffffff0,%rsi
   5c84b:	c5 fa 6f 0c 32       	vmovdqu (%rdx,%rsi,1),%xmm1
   5c850:	31 d2                	xor    %edx,%edx
   5c852:	c4 e2 79 17 c8       	vptest %xmm0,%xmm1
   5c857:	0f 92 c2             	setb   %dl
   5c85a:	89 14 81             	mov    %edx,(%rcx,%rax,4)
   5c85d:	c3                   	ret
   5c85e:	cc                   	int3
   5c85f:	cc                   	int3
