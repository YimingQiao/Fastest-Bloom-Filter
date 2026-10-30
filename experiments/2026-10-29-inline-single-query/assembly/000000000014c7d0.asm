000000000014c7d0 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<8, false>, unsigned long>(rocksdb_external::FastLocalBloom64<8, false> const&, unsigned long, unsigned long const*, unsigned int*)>:
  14c7d0:	48 85 f6             	test   %rsi,%rsi
  14c7d3:	0f 84 11 02 00 00    	je     14c9ea <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<8, false>, unsigned long>(rocksdb_external::FastLocalBloom64<8, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x21a>
  14c7d9:	41 56                	push   %r14
  14c7db:	53                   	push   %rbx
  14c7dc:	49 b8 93 fd 59 66 b8 	movabs $0xd6e8feb86659fd93,%r8
  14c7e3:	fe e8 d6
  14c7e6:	48 83 fe 01          	cmp    $0x1,%rsi
  14c7ea:	75 07                	jne    14c7f3 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<8, false>, unsigned long>(rocksdb_external::FastLocalBloom64<8, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x23>
  14c7ec:	31 c0                	xor    %eax,%eax
  14c7ee:	e9 5e 01 00 00       	jmp    14c951 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<8, false>, unsigned long>(rocksdb_external::FastLocalBloom64<8, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x181>
  14c7f3:	49 89 f1             	mov    %rsi,%r9
  14c7f6:	49 83 e1 fe          	and    $0xfffffffffffffffe,%r9
  14c7fa:	31 c0                	xor    %eax,%eax
  14c7fc:	c5 fd 6f 05 dc 82 eb 	vmovdqa -0x147d24(%rip),%ymm0        # 4ae0 <typeinfo name for main::$_60+0x310>
  14c803:	ff
  14c804:	c5 fd 6f 0d 74 81 eb 	vmovdqa -0x147e8c(%rip),%ymm1        # 4980 <typeinfo name for main::$_60+0x1b0>
  14c80b:	ff
  14c80c:	c4 e2 7d 58 15 93 6a 	vpbroadcastd -0x14956d(%rip),%ymm2        # 32a8 <__abi_tag+0x2fe4>
  14c813:	eb ff
  14c815:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  14c81c:	00 00 00 00
  14c820:	4c 8b 14 c2          	mov    (%rdx,%rax,8),%r10
  14c824:	4d 89 d3             	mov    %r10,%r11
  14c827:	49 c1 eb 20          	shr    $0x20,%r11
  14c82b:	4d 31 d3             	xor    %r10,%r11
  14c82e:	4d 0f af d8          	imul   %r8,%r11
  14c832:	4d 89 da             	mov    %r11,%r10
  14c835:	49 c1 ea 20          	shr    $0x20,%r10
  14c839:	4d 31 da             	xor    %r11,%r10
  14c83c:	4d 0f af d0          	imul   %r8,%r10
  14c840:	45 89 d3             	mov    %r10d,%r11d
  14c843:	49 c1 ea 20          	shr    $0x20,%r10
  14c847:	48 8b 1f             	mov    (%rdi),%rbx
  14c84a:	4d 31 d3             	xor    %r10,%r11
  14c84d:	44 8b 77 18          	mov    0x18(%rdi),%r14d
  14c851:	41 c1 ee 06          	shr    $0x6,%r14d
  14c855:	4d 0f af f3          	imul   %r11,%r14
  14c859:	49 c1 ee 1a          	shr    $0x1a,%r14
  14c85d:	41 83 e6 c0          	and    $0xffffffc0,%r14d
  14c861:	62 d2 7d 28 7c da    	vpbroadcastd %r10d,%ymm3
  14c867:	c4 e2 65 40 e0       	vpmulld %ymm0,%ymm3,%ymm4
  14c86c:	c5 d5 72 d4 1c       	vpsrld $0x1c,%ymm4,%ymm5
  14c871:	c5 c8 57 f6          	vxorps %xmm6,%xmm6,%xmm6
  14c875:	c4 a2 55 36 34 33    	vpermd (%rbx,%r14,1),%ymm5,%ymm6
  14c87b:	c4 a2 55 36 6c 33 20 	vpermd 0x20(%rbx,%r14,1),%ymm5,%ymm5
  14c882:	c5 dd 72 e4 1f       	vpsrad $0x1f,%ymm4,%ymm4
  14c887:	c4 e3 4d 4c e5 40    	vpblendvb %ymm4,%ymm5,%ymm6,%ymm4
  14c88d:	c4 e2 65 40 d9       	vpmulld %ymm1,%ymm3,%ymm3
  14c892:	c5 e5 72 d3 1b       	vpsrld $0x1b,%ymm3,%ymm3
  14c897:	c4 e2 6d 47 db       	vpsllvd %ymm3,%ymm2,%ymm3
  14c89c:	45 31 d2             	xor    %r10d,%r10d
  14c89f:	c4 e2 7d 17 e3       	vptest %ymm3,%ymm4
  14c8a4:	41 0f 92 c2          	setb   %r10b
  14c8a8:	44 89 14 81          	mov    %r10d,(%rcx,%rax,4)
  14c8ac:	4c 8b 54 c2 08       	mov    0x8(%rdx,%rax,8),%r10
  14c8b1:	4d 89 d3             	mov    %r10,%r11
  14c8b4:	49 c1 eb 20          	shr    $0x20,%r11
  14c8b8:	4d 31 d3             	xor    %r10,%r11
  14c8bb:	4d 0f af d8          	imul   %r8,%r11
  14c8bf:	4d 89 da             	mov    %r11,%r10
  14c8c2:	49 c1 ea 20          	shr    $0x20,%r10
  14c8c6:	4d 31 da             	xor    %r11,%r10
  14c8c9:	4d 0f af d0          	imul   %r8,%r10
  14c8cd:	45 89 d3             	mov    %r10d,%r11d
  14c8d0:	49 c1 ea 20          	shr    $0x20,%r10
  14c8d4:	48 8b 1f             	mov    (%rdi),%rbx
  14c8d7:	4d 31 d3             	xor    %r10,%r11
  14c8da:	44 8b 77 18          	mov    0x18(%rdi),%r14d
  14c8de:	41 c1 ee 06          	shr    $0x6,%r14d
  14c8e2:	4d 0f af f3          	imul   %r11,%r14
  14c8e6:	49 c1 ee 1a          	shr    $0x1a,%r14
  14c8ea:	62 d2 7d 28 7c da    	vpbroadcastd %r10d,%ymm3
  14c8f0:	c4 e2 65 40 e0       	vpmulld %ymm0,%ymm3,%ymm4
  14c8f5:	41 83 e6 c0          	and    $0xffffffc0,%r14d
  14c8f9:	c5 d5 72 d4 1c       	vpsrld $0x1c,%ymm4,%ymm5
  14c8fe:	c5 c8 57 f6          	vxorps %xmm6,%xmm6,%xmm6
  14c902:	c4 a2 55 36 34 33    	vpermd (%rbx,%r14,1),%ymm5,%ymm6
  14c908:	c4 a2 55 36 6c 33 20 	vpermd 0x20(%rbx,%r14,1),%ymm5,%ymm5
  14c90f:	c5 dd 72 e4 1f       	vpsrad $0x1f,%ymm4,%ymm4
  14c914:	c4 e3 4d 4c e5 40    	vpblendvb %ymm4,%ymm5,%ymm6,%ymm4
  14c91a:	c4 e2 65 40 d9       	vpmulld %ymm1,%ymm3,%ymm3
  14c91f:	c5 e5 72 d3 1b       	vpsrld $0x1b,%ymm3,%ymm3
  14c924:	c4 e2 6d 47 db       	vpsllvd %ymm3,%ymm2,%ymm3
  14c929:	45 31 d2             	xor    %r10d,%r10d
  14c92c:	c4 e2 7d 17 e3       	vptest %ymm3,%ymm4
  14c931:	41 0f 92 c2          	setb   %r10b
  14c935:	44 89 54 81 04       	mov    %r10d,0x4(%rcx,%rax,4)
  14c93a:	48 83 c0 02          	add    $0x2,%rax
  14c93e:	49 39 c1             	cmp    %rax,%r9
  14c941:	0f 85 d9 fe ff ff    	jne    14c820 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<8, false>, unsigned long>(rocksdb_external::FastLocalBloom64<8, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  14c947:	40 f6 c6 01          	test   $0x1,%sil
  14c94b:	0f 84 96 00 00 00    	je     14c9e7 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<8, false>, unsigned long>(rocksdb_external::FastLocalBloom64<8, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x217>
  14c951:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  14c955:	48 89 d6             	mov    %rdx,%rsi
  14c958:	48 c1 ee 20          	shr    $0x20,%rsi
  14c95c:	48 31 d6             	xor    %rdx,%rsi
  14c95f:	49 0f af f0          	imul   %r8,%rsi
  14c963:	48 89 f2             	mov    %rsi,%rdx
  14c966:	48 c1 ea 20          	shr    $0x20,%rdx
  14c96a:	48 31 f2             	xor    %rsi,%rdx
  14c96d:	49 0f af d0          	imul   %r8,%rdx
  14c971:	89 d6                	mov    %edx,%esi
  14c973:	48 c1 ea 20          	shr    $0x20,%rdx
  14c977:	4c 8b 07             	mov    (%rdi),%r8
  14c97a:	48 31 d6             	xor    %rdx,%rsi
  14c97d:	8b 7f 18             	mov    0x18(%rdi),%edi
  14c980:	c1 ef 06             	shr    $0x6,%edi
  14c983:	48 0f af fe          	imul   %rsi,%rdi
  14c987:	48 c1 ef 1a          	shr    $0x1a,%rdi
  14c98b:	83 e7 c0             	and    $0xffffffc0,%edi
  14c98e:	62 f2 7d 28 7c c2    	vpbroadcastd %edx,%ymm0
  14c994:	c4 e2 7d 40 0d 43 81 	vpmulld -0x147ebd(%rip),%ymm0,%ymm1        # 4ae0 <typeinfo name for main::$_60+0x310>
  14c99b:	eb ff
  14c99d:	c5 ed 72 d1 1c       	vpsrld $0x1c,%ymm1,%ymm2
  14c9a2:	c5 e0 57 db          	vxorps %xmm3,%xmm3,%xmm3
  14c9a6:	c4 c2 6d 36 1c 38    	vpermd (%r8,%rdi,1),%ymm2,%ymm3
  14c9ac:	c4 c2 6d 36 54 38 20 	vpermd 0x20(%r8,%rdi,1),%ymm2,%ymm2
  14c9b3:	c5 f5 72 e1 1f       	vpsrad $0x1f,%ymm1,%ymm1
  14c9b8:	c4 e3 65 4c ca 10    	vpblendvb %ymm1,%ymm2,%ymm3,%ymm1
  14c9be:	c4 e2 7d 40 05 b9 7f 	vpmulld -0x148047(%rip),%ymm0,%ymm0        # 4980 <typeinfo name for main::$_60+0x1b0>
  14c9c5:	eb ff
  14c9c7:	c5 fd 72 d0 1b       	vpsrld $0x1b,%ymm0,%ymm0
  14c9cc:	c4 e2 7d 58 15 d3 68 	vpbroadcastd -0x14972d(%rip),%ymm2        # 32a8 <__abi_tag+0x2fe4>
  14c9d3:	eb ff
  14c9d5:	c4 e2 6d 47 c0       	vpsllvd %ymm0,%ymm2,%ymm0
  14c9da:	31 d2                	xor    %edx,%edx
  14c9dc:	c4 e2 7d 17 c8       	vptest %ymm0,%ymm1
  14c9e1:	0f 92 c2             	setb   %dl
  14c9e4:	89 14 81             	mov    %edx,(%rcx,%rax,4)
  14c9e7:	5b                   	pop    %rbx
  14c9e8:	41 5e                	pop    %r14
  14c9ea:	c5 f8 77             	vzeroupper
  14c9ed:	c3                   	ret
  14c9ee:	cc                   	int3
  14c9ef:	cc                   	int3
