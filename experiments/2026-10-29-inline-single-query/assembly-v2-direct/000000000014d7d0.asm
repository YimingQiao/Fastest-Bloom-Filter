000000000014d7d0 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<8, false>, unsigned long>(rocksdb_external::FastLocalBloom64<8, false> const&, unsigned long, unsigned long const*, unsigned int*)>:
  14d7d0:	test   %rsi,%rsi
  14d7d3:	je     14d9ea <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<8, false>, unsigned long>(rocksdb_external::FastLocalBloom64<8, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x21a>
  14d7d9:	push   %r14
  14d7db:	push   %rbx
  14d7dc:	movabs $0xd6e8feb86659fd93,%r8
  14d7e6:	cmp    $0x1,%rsi
  14d7ea:	jne    14d7f3 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<8, false>, unsigned long>(rocksdb_external::FastLocalBloom64<8, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x23>
  14d7ec:	xor    %eax,%eax
  14d7ee:	jmp    14d951 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<8, false>, unsigned long>(rocksdb_external::FastLocalBloom64<8, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x181>
  14d7f3:	mov    %rsi,%r9
  14d7f6:	and    $0xfffffffffffffffe,%r9
  14d7fa:	xor    %eax,%eax
  14d7fc:	vmovdqa -0x148d24(%rip),%ymm0        # 4ae0 <typeinfo name for main::$_60+0x310>
  14d804:	vmovdqa -0x148e8c(%rip),%ymm1        # 4980 <typeinfo name for main::$_60+0x1b0>
  14d80c:	vpbroadcastd -0x14a56d(%rip),%ymm2        # 32a8 <__abi_tag+0x2fe4>
  14d815:	data16 cs nopw 0x0(%rax,%rax,1)
  14d820:	mov    (%rdx,%rax,8),%r10
  14d824:	mov    %r10,%r11
  14d827:	shr    $0x20,%r11
  14d82b:	xor    %r10,%r11
  14d82e:	imul   %r8,%r11
  14d832:	mov    %r11,%r10
  14d835:	shr    $0x20,%r10
  14d839:	xor    %r11,%r10
  14d83c:	imul   %r8,%r10
  14d840:	mov    %r10d,%r11d
  14d843:	shr    $0x20,%r10
  14d847:	mov    (%rdi),%rbx
  14d84a:	xor    %r10,%r11
  14d84d:	mov    0x18(%rdi),%r14d
  14d851:	shr    $0x6,%r14d
  14d855:	imul   %r11,%r14
  14d859:	shr    $0x1a,%r14
  14d85d:	and    $0xffffffc0,%r14d
  14d861:	vpbroadcastd %r10d,%ymm3
  14d867:	vpmulld %ymm0,%ymm3,%ymm4
  14d86c:	vpsrld $0x1c,%ymm4,%ymm5
  14d871:	vxorps %xmm6,%xmm6,%xmm6
  14d875:	vpermd (%rbx,%r14,1),%ymm5,%ymm6
  14d87b:	vpermd 0x20(%rbx,%r14,1),%ymm5,%ymm5
  14d882:	vpsrad $0x1f,%ymm4,%ymm4
  14d887:	vpblendvb %ymm4,%ymm5,%ymm6,%ymm4
  14d88d:	vpmulld %ymm1,%ymm3,%ymm3
  14d892:	vpsrld $0x1b,%ymm3,%ymm3
  14d897:	vpsllvd %ymm3,%ymm2,%ymm3
  14d89c:	xor    %r10d,%r10d
  14d89f:	vptest %ymm3,%ymm4
  14d8a4:	setb   %r10b
  14d8a8:	mov    %r10d,(%rcx,%rax,4)
  14d8ac:	mov    0x8(%rdx,%rax,8),%r10
  14d8b1:	mov    %r10,%r11
  14d8b4:	shr    $0x20,%r11
  14d8b8:	xor    %r10,%r11
  14d8bb:	imul   %r8,%r11
  14d8bf:	mov    %r11,%r10
  14d8c2:	shr    $0x20,%r10
  14d8c6:	xor    %r11,%r10
  14d8c9:	imul   %r8,%r10
  14d8cd:	mov    %r10d,%r11d
  14d8d0:	shr    $0x20,%r10
  14d8d4:	mov    (%rdi),%rbx
  14d8d7:	xor    %r10,%r11
  14d8da:	mov    0x18(%rdi),%r14d
  14d8de:	shr    $0x6,%r14d
  14d8e2:	imul   %r11,%r14
  14d8e6:	shr    $0x1a,%r14
  14d8ea:	vpbroadcastd %r10d,%ymm3
  14d8f0:	vpmulld %ymm0,%ymm3,%ymm4
  14d8f5:	and    $0xffffffc0,%r14d
  14d8f9:	vpsrld $0x1c,%ymm4,%ymm5
  14d8fe:	vxorps %xmm6,%xmm6,%xmm6
  14d902:	vpermd (%rbx,%r14,1),%ymm5,%ymm6
  14d908:	vpermd 0x20(%rbx,%r14,1),%ymm5,%ymm5
  14d90f:	vpsrad $0x1f,%ymm4,%ymm4
  14d914:	vpblendvb %ymm4,%ymm5,%ymm6,%ymm4
  14d91a:	vpmulld %ymm1,%ymm3,%ymm3
  14d91f:	vpsrld $0x1b,%ymm3,%ymm3
  14d924:	vpsllvd %ymm3,%ymm2,%ymm3
  14d929:	xor    %r10d,%r10d
  14d92c:	vptest %ymm3,%ymm4
  14d931:	setb   %r10b
  14d935:	mov    %r10d,0x4(%rcx,%rax,4)
  14d93a:	add    $0x2,%rax
  14d93e:	cmp    %rax,%r9
  14d941:	jne    14d820 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<8, false>, unsigned long>(rocksdb_external::FastLocalBloom64<8, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  14d947:	test   $0x1,%sil
  14d94b:	je     14d9e7 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<8, false>, unsigned long>(rocksdb_external::FastLocalBloom64<8, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x217>
  14d951:	mov    (%rdx,%rax,8),%rdx
  14d955:	mov    %rdx,%rsi
  14d958:	shr    $0x20,%rsi
  14d95c:	xor    %rdx,%rsi
  14d95f:	imul   %r8,%rsi
  14d963:	mov    %rsi,%rdx
  14d966:	shr    $0x20,%rdx
  14d96a:	xor    %rsi,%rdx
  14d96d:	imul   %r8,%rdx
  14d971:	mov    %edx,%esi
  14d973:	shr    $0x20,%rdx
  14d977:	mov    (%rdi),%r8
  14d97a:	xor    %rdx,%rsi
  14d97d:	mov    0x18(%rdi),%edi
  14d980:	shr    $0x6,%edi
  14d983:	imul   %rsi,%rdi
  14d987:	shr    $0x1a,%rdi
  14d98b:	and    $0xffffffc0,%edi
  14d98e:	vpbroadcastd %edx,%ymm0
  14d994:	vpmulld -0x148ebd(%rip),%ymm0,%ymm1        # 4ae0 <typeinfo name for main::$_60+0x310>
  14d99d:	vpsrld $0x1c,%ymm1,%ymm2
  14d9a2:	vxorps %xmm3,%xmm3,%xmm3
  14d9a6:	vpermd (%r8,%rdi,1),%ymm2,%ymm3
  14d9ac:	vpermd 0x20(%r8,%rdi,1),%ymm2,%ymm2
  14d9b3:	vpsrad $0x1f,%ymm1,%ymm1
  14d9b8:	vpblendvb %ymm1,%ymm2,%ymm3,%ymm1
  14d9be:	vpmulld -0x149047(%rip),%ymm0,%ymm0        # 4980 <typeinfo name for main::$_60+0x1b0>
  14d9c7:	vpsrld $0x1b,%ymm0,%ymm0
  14d9cc:	vpbroadcastd -0x14a72d(%rip),%ymm2        # 32a8 <__abi_tag+0x2fe4>
  14d9d5:	vpsllvd %ymm0,%ymm2,%ymm0
  14d9da:	xor    %edx,%edx
  14d9dc:	vptest %ymm0,%ymm1
  14d9e1:	setb   %dl
  14d9e4:	mov    %edx,(%rcx,%rax,4)
  14d9e7:	pop    %rbx
  14d9e8:	pop    %r14
  14d9ea:	vzeroupper
  14d9ed:	ret
  14d9ee:	int3
  14d9ef:	int3

