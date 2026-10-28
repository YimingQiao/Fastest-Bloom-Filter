000000000014c640 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<8, false>, unsigned long>(rocksdb_external::FastLocalBloom64<8, false> const&, unsigned long, unsigned long const*, unsigned int*)>:
  14c640:	test   %rsi,%rsi
  14c643:	je     14c7e2 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<8, false>, unsigned long>(rocksdb_external::FastLocalBloom64<8, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x1a2>
  14c649:	push   %rbx
  14c64a:	cmp    $0x1,%rsi
  14c64e:	jne    14c657 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<8, false>, unsigned long>(rocksdb_external::FastLocalBloom64<8, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x17>
  14c650:	xor    %eax,%eax
  14c652:	jmp    14c769 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<8, false>, unsigned long>(rocksdb_external::FastLocalBloom64<8, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x129>
  14c657:	mov    %rsi,%r8
  14c65a:	and    $0xfffffffffffffffe,%r8
  14c65e:	xor    %eax,%eax
  14c660:	vmovdqa -0x147b88(%rip),%ymm0        # 4ae0 <typeinfo name for main::$_60+0x310>
  14c668:	vmovdqa -0x147cf0(%rip),%ymm1        # 4980 <typeinfo name for main::$_60+0x1b0>
  14c670:	vpbroadcastd -0x1493d1(%rip),%ymm2        # 32a8 <__abi_tag+0x2fe4>
  14c679:	nopl   0x0(%rax)
  14c680:	mov    (%rdx,%rax,8),%r9
  14c684:	mov    (%rdi),%r10
  14c687:	mov    %r9d,%r11d
  14c68a:	mov    0x18(%rdi),%ebx
  14c68d:	shr    $0x6,%ebx
  14c690:	imul   %r11,%rbx
  14c694:	shr    $0x1a,%rbx
  14c698:	and    $0xffffffc0,%ebx
  14c69b:	shr    $0x20,%r9
  14c69f:	vpbroadcastd %r9d,%ymm3
  14c6a5:	vpmulld %ymm0,%ymm3,%ymm4
  14c6aa:	vpsrld $0x1c,%ymm4,%ymm5
  14c6af:	vxorps %xmm6,%xmm6,%xmm6
  14c6b3:	vpermd (%r10,%rbx,1),%ymm5,%ymm6
  14c6b9:	vpermd 0x20(%r10,%rbx,1),%ymm5,%ymm5
  14c6c0:	vpsrad $0x1f,%ymm4,%ymm4
  14c6c5:	vpblendvb %ymm4,%ymm5,%ymm6,%ymm4
  14c6cb:	vpmulld %ymm1,%ymm3,%ymm3
  14c6d0:	vpsrld $0x1b,%ymm3,%ymm3
  14c6d5:	vpsllvd %ymm3,%ymm2,%ymm3
  14c6da:	xor    %r9d,%r9d
  14c6dd:	vptest %ymm3,%ymm4
  14c6e2:	setb   %r9b
  14c6e6:	mov    %r9d,(%rcx,%rax,4)
  14c6ea:	mov    0x8(%rdx,%rax,8),%r9
  14c6ef:	mov    (%rdi),%r10
  14c6f2:	mov    %r9d,%r11d
  14c6f5:	mov    0x18(%rdi),%ebx
  14c6f8:	shr    $0x6,%ebx
  14c6fb:	imul   %r11,%rbx
  14c6ff:	shr    $0x1a,%rbx
  14c703:	shr    $0x20,%r9
  14c707:	vpbroadcastd %r9d,%ymm3
  14c70d:	vpmulld %ymm0,%ymm3,%ymm4
  14c712:	and    $0xffffffc0,%ebx
  14c715:	vpsrld $0x1c,%ymm4,%ymm5
  14c71a:	vxorps %xmm6,%xmm6,%xmm6
  14c71e:	vpermd (%r10,%rbx,1),%ymm5,%ymm6
  14c724:	vpermd 0x20(%r10,%rbx,1),%ymm5,%ymm5
  14c72b:	vpsrad $0x1f,%ymm4,%ymm4
  14c730:	vpblendvb %ymm4,%ymm5,%ymm6,%ymm4
  14c736:	vpmulld %ymm1,%ymm3,%ymm3
  14c73b:	vpsrld $0x1b,%ymm3,%ymm3
  14c740:	vpsllvd %ymm3,%ymm2,%ymm3
  14c745:	xor    %r9d,%r9d
  14c748:	vptest %ymm3,%ymm4
  14c74d:	setb   %r9b
  14c751:	mov    %r9d,0x4(%rcx,%rax,4)
  14c756:	add    $0x2,%rax
  14c75a:	cmp    %rax,%r8
  14c75d:	jne    14c680 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<8, false>, unsigned long>(rocksdb_external::FastLocalBloom64<8, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
  14c763:	test   $0x1,%sil
  14c767:	je     14c7e1 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<8, false>, unsigned long>(rocksdb_external::FastLocalBloom64<8, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x1a1>
  14c769:	mov    (%rdx,%rax,8),%rdx
  14c76d:	mov    (%rdi),%rsi
  14c770:	mov    %edx,%r8d
  14c773:	mov    0x18(%rdi),%edi
  14c776:	shr    $0x6,%edi
  14c779:	imul   %r8,%rdi
  14c77d:	shr    $0x1a,%rdi
  14c781:	and    $0xffffffc0,%edi
  14c784:	shr    $0x20,%rdx
  14c788:	vpbroadcastd %edx,%ymm0
  14c78e:	vpmulld -0x147cb7(%rip),%ymm0,%ymm1        # 4ae0 <typeinfo name for main::$_60+0x310>
  14c797:	vpsrld $0x1c,%ymm1,%ymm2
  14c79c:	vxorps %xmm3,%xmm3,%xmm3
  14c7a0:	vpermd (%rsi,%rdi,1),%ymm2,%ymm3
  14c7a6:	vpermd 0x20(%rsi,%rdi,1),%ymm2,%ymm2
  14c7ad:	vpsrad $0x1f,%ymm1,%ymm1
  14c7b2:	vpblendvb %ymm1,%ymm2,%ymm3,%ymm1
  14c7b8:	vpmulld -0x147e41(%rip),%ymm0,%ymm0        # 4980 <typeinfo name for main::$_60+0x1b0>
  14c7c1:	vpsrld $0x1b,%ymm0,%ymm0
  14c7c6:	vpbroadcastd -0x149527(%rip),%ymm2        # 32a8 <__abi_tag+0x2fe4>
  14c7cf:	vpsllvd %ymm0,%ymm2,%ymm0
  14c7d4:	xor    %edx,%edx
  14c7d6:	vptest %ymm0,%ymm1
  14c7db:	setb   %dl
  14c7de:	mov    %edx,(%rcx,%rax,4)
  14c7e1:	pop    %rbx
  14c7e2:	vzeroupper
  14c7e5:	ret
  14c7e6:	int3
  14c7e7:	int3
  14c7e8:	int3
  14c7e9:	int3
  14c7ea:	int3
  14c7eb:	int3
  14c7ec:	int3
  14c7ed:	int3
  14c7ee:	int3
  14c7ef:	int3

