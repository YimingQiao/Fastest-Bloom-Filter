000000000004bbc0 <void inline_single_kernel<false, external_bloom::Fixed32<false>, unsigned long>(external_bloom::Fixed32<false> const&, unsigned long, unsigned long const*, unsigned int*)>:
   4bbc0:	test   %rsi,%rsi
   4bbc3:	je     4bcdf <void inline_single_kernel<false, external_bloom::Fixed32<false>, unsigned long>(external_bloom::Fixed32<false> const&, unsigned long, unsigned long const*, unsigned int*)+0x11f>
   4bbc9:	cmp    $0x1,%rsi
   4bbcd:	jne    4bbd6 <void inline_single_kernel<false, external_bloom::Fixed32<false>, unsigned long>(external_bloom::Fixed32<false> const&, unsigned long, unsigned long const*, unsigned int*)+0x16>
   4bbcf:	xor    %eax,%eax
   4bbd1:	jmp    4bc91 <void inline_single_kernel<false, external_bloom::Fixed32<false>, unsigned long>(external_bloom::Fixed32<false> const&, unsigned long, unsigned long const*, unsigned int*)+0xd1>
   4bbd6:	mov    %rsi,%r8
   4bbd9:	and    $0xfffffffffffffffe,%r8
   4bbdd:	xor    %eax,%eax
   4bbdf:	vmovdqa -0x472c7(%rip),%ymm0        # 4920 <typeinfo name for main::$_60+0x150>
   4bbe7:	vpbroadcastd -0x48948(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
   4bbf0:	mov    (%rdx,%rax,8),%r9
   4bbf4:	vpbroadcastd %r9d,%ymm2
   4bbfa:	shr    $0x20,%r9
   4bbfe:	mov    (%rdi),%r10d
   4bc01:	vpmulld %ymm0,%ymm2,%ymm2
   4bc06:	imul   %r9,%r10
   4bc0a:	vpsrld $0x1b,%ymm2,%ymm2
   4bc0f:	vpsllvd %ymm2,%ymm1,%ymm2
   4bc14:	mov    0x8(%rdi),%r9
   4bc18:	shr    $0x1b,%r10
   4bc1c:	and    $0xffffffffffffffe0,%r10
   4bc20:	vmovdqa (%r9,%r10,1),%ymm3
   4bc26:	xor    %r9d,%r9d
   4bc29:	vptest %ymm2,%ymm3
   4bc2e:	setb   %r9b
   4bc32:	mov    %r9d,(%rcx,%rax,4)
   4bc36:	mov    0x8(%rdx,%rax,8),%r9
   4bc3b:	vpbroadcastd %r9d,%ymm2
   4bc41:	shr    $0x20,%r9
   4bc45:	mov    (%rdi),%r10d
   4bc48:	imul   %r9,%r10
   4bc4c:	vpmulld %ymm0,%ymm2,%ymm2
   4bc51:	vpsrld $0x1b,%ymm2,%ymm2
   4bc56:	vpsllvd %ymm2,%ymm1,%ymm2
   4bc5b:	mov    0x8(%rdi),%r9
   4bc5f:	shr    $0x1b,%r10
   4bc63:	and    $0xffffffffffffffe0,%r10
   4bc67:	vmovdqa (%r9,%r10,1),%ymm3
   4bc6d:	xor    %r9d,%r9d
   4bc70:	vptest %ymm2,%ymm3
   4bc75:	setb   %r9b
   4bc79:	mov    %r9d,0x4(%rcx,%rax,4)
   4bc7e:	add    $0x2,%rax
   4bc82:	cmp    %rax,%r8
   4bc85:	jne    4bbf0 <void inline_single_kernel<false, external_bloom::Fixed32<false>, unsigned long>(external_bloom::Fixed32<false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   4bc8b:	test   $0x1,%sil
   4bc8f:	je     4bcdf <void inline_single_kernel<false, external_bloom::Fixed32<false>, unsigned long>(external_bloom::Fixed32<false> const&, unsigned long, unsigned long const*, unsigned int*)+0x11f>
   4bc91:	mov    (%rdx,%rax,8),%rdx
   4bc95:	vpbroadcastd %edx,%ymm0
   4bc9b:	shr    $0x20,%rdx
   4bc9f:	mov    (%rdi),%esi
   4bca1:	imul   %rdx,%rsi
   4bca5:	vpmulld -0x4738e(%rip),%ymm0,%ymm0        # 4920 <typeinfo name for main::$_60+0x150>
   4bcae:	vpsrld $0x1b,%ymm0,%ymm0
   4bcb3:	vpbroadcastd -0x48a14(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
   4bcbc:	vpsllvd %ymm0,%ymm1,%ymm0
   4bcc1:	mov    0x8(%rdi),%rdx
   4bcc5:	shr    $0x1b,%rsi
   4bcc9:	and    $0xffffffffffffffe0,%rsi
   4bccd:	vmovdqa (%rdx,%rsi,1),%ymm1
   4bcd2:	xor    %edx,%edx
   4bcd4:	vptest %ymm0,%ymm1
   4bcd9:	setb   %dl
   4bcdc:	mov    %edx,(%rcx,%rax,4)
   4bcdf:	vzeroupper
   4bce2:	ret
   4bce3:	int3
   4bce4:	int3
   4bce5:	int3
   4bce6:	int3
   4bce7:	int3
   4bce8:	int3
   4bce9:	int3
   4bcea:	int3
   4bceb:	int3
   4bcec:	int3
   4bced:	int3
   4bcee:	int3
   4bcef:	int3

