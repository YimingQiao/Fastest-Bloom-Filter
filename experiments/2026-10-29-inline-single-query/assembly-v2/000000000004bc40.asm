000000000004bc40 <void inline_single_kernel<false, external_bloom::Fixed32<false>, unsigned long>(external_bloom::Fixed32<false> const&, unsigned long, unsigned long const*, unsigned int*)>:
   4bc40:	test   %rsi,%rsi
   4bc43:	je     4bd5f <void inline_single_kernel<false, external_bloom::Fixed32<false>, unsigned long>(external_bloom::Fixed32<false> const&, unsigned long, unsigned long const*, unsigned int*)+0x11f>
   4bc49:	cmp    $0x1,%rsi
   4bc4d:	jne    4bc56 <void inline_single_kernel<false, external_bloom::Fixed32<false>, unsigned long>(external_bloom::Fixed32<false> const&, unsigned long, unsigned long const*, unsigned int*)+0x16>
   4bc4f:	xor    %eax,%eax
   4bc51:	jmp    4bd11 <void inline_single_kernel<false, external_bloom::Fixed32<false>, unsigned long>(external_bloom::Fixed32<false> const&, unsigned long, unsigned long const*, unsigned int*)+0xd1>
   4bc56:	mov    %rsi,%r8
   4bc59:	and    $0xfffffffffffffffe,%r8
   4bc5d:	xor    %eax,%eax
   4bc5f:	vmovdqa -0x47347(%rip),%ymm0        # 4920 <typeinfo name for main::$_60+0x150>
   4bc67:	vpbroadcastd -0x489c8(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
   4bc70:	mov    (%rdx,%rax,8),%r9
   4bc74:	vpbroadcastd %r9d,%ymm2
   4bc7a:	shr    $0x20,%r9
   4bc7e:	mov    (%rdi),%r10d
   4bc81:	vpmulld %ymm0,%ymm2,%ymm2
   4bc86:	imul   %r9,%r10
   4bc8a:	vpsrld $0x1b,%ymm2,%ymm2
   4bc8f:	vpsllvd %ymm2,%ymm1,%ymm2
   4bc94:	mov    0x8(%rdi),%r9
   4bc98:	shr    $0x1b,%r10
   4bc9c:	and    $0xffffffffffffffe0,%r10
   4bca0:	vmovdqa (%r9,%r10,1),%ymm3
   4bca6:	xor    %r9d,%r9d
   4bca9:	vptest %ymm2,%ymm3
   4bcae:	setb   %r9b
   4bcb2:	mov    %r9d,(%rcx,%rax,4)
   4bcb6:	mov    0x8(%rdx,%rax,8),%r9
   4bcbb:	vpbroadcastd %r9d,%ymm2
   4bcc1:	shr    $0x20,%r9
   4bcc5:	mov    (%rdi),%r10d
   4bcc8:	imul   %r9,%r10
   4bccc:	vpmulld %ymm0,%ymm2,%ymm2
   4bcd1:	vpsrld $0x1b,%ymm2,%ymm2
   4bcd6:	vpsllvd %ymm2,%ymm1,%ymm2
   4bcdb:	mov    0x8(%rdi),%r9
   4bcdf:	shr    $0x1b,%r10
   4bce3:	and    $0xffffffffffffffe0,%r10
   4bce7:	vmovdqa (%r9,%r10,1),%ymm3
   4bced:	xor    %r9d,%r9d
   4bcf0:	vptest %ymm2,%ymm3
   4bcf5:	setb   %r9b
   4bcf9:	mov    %r9d,0x4(%rcx,%rax,4)
   4bcfe:	add    $0x2,%rax
   4bd02:	cmp    %rax,%r8
   4bd05:	jne    4bc70 <void inline_single_kernel<false, external_bloom::Fixed32<false>, unsigned long>(external_bloom::Fixed32<false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   4bd0b:	test   $0x1,%sil
   4bd0f:	je     4bd5f <void inline_single_kernel<false, external_bloom::Fixed32<false>, unsigned long>(external_bloom::Fixed32<false> const&, unsigned long, unsigned long const*, unsigned int*)+0x11f>
   4bd11:	mov    (%rdx,%rax,8),%rdx
   4bd15:	vpbroadcastd %edx,%ymm0
   4bd1b:	shr    $0x20,%rdx
   4bd1f:	mov    (%rdi),%esi
   4bd21:	imul   %rdx,%rsi
   4bd25:	vpmulld -0x4740e(%rip),%ymm0,%ymm0        # 4920 <typeinfo name for main::$_60+0x150>
   4bd2e:	vpsrld $0x1b,%ymm0,%ymm0
   4bd33:	vpbroadcastd -0x48a94(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
   4bd3c:	vpsllvd %ymm0,%ymm1,%ymm0
   4bd41:	mov    0x8(%rdi),%rdx
   4bd45:	shr    $0x1b,%rsi
   4bd49:	and    $0xffffffffffffffe0,%rsi
   4bd4d:	vmovdqa (%rdx,%rsi,1),%ymm1
   4bd52:	xor    %edx,%edx
   4bd54:	vptest %ymm0,%ymm1
   4bd59:	setb   %dl
   4bd5c:	mov    %edx,(%rcx,%rax,4)
   4bd5f:	vzeroupper
   4bd62:	ret
   4bd63:	int3
   4bd64:	int3
   4bd65:	int3
   4bd66:	int3
   4bd67:	int3
   4bd68:	int3
   4bd69:	int3
   4bd6a:	int3
   4bd6b:	int3
   4bd6c:	int3
   4bd6d:	int3
   4bd6e:	int3
   4bd6f:	int3

