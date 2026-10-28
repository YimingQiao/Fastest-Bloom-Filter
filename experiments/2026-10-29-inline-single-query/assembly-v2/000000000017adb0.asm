000000000017adb0 <void inline_single_kernel<false, bloom_filters::ByteSplitBloomFilter, unsigned long>(bloom_filters::ByteSplitBloomFilter const&, unsigned long, unsigned long const*, unsigned int*)>:
  17adb0:	test   %rsi,%rsi
  17adb3:	je     17af50 <void inline_single_kernel<false, bloom_filters::ByteSplitBloomFilter, unsigned long>(bloom_filters::ByteSplitBloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x1a0>
  17adb9:	mov    %esi,%eax
  17adbb:	and    $0x3,%eax
  17adbe:	cmp    $0x4,%rsi
  17adc2:	jae    17adcc <void inline_single_kernel<false, bloom_filters::ByteSplitBloomFilter, unsigned long>(bloom_filters::ByteSplitBloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x1c>
  17adc4:	xor    %r8d,%r8d
  17adc7:	jmp    17aee8 <void inline_single_kernel<false, bloom_filters::ByteSplitBloomFilter, unsigned long>(bloom_filters::ByteSplitBloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x138>
  17adcc:	and    $0xfffffffffffffffc,%rsi
  17add0:	xor    %r8d,%r8d
  17add3:	vmovdqa -0x17619b(%rip),%xmm0        # 4c40 <typeinfo name for main::$_60+0x470>
  17addb:	vpbroadcastq -0x177af4(%rip),%xmm1        # 32f0 <_IO_stdin_used+0x3c>
  17ade4:	data16 data16 cs nopw 0x0(%rax,%rax,1)
  17adf0:	mov    (%rdx,%r8,8),%r9
  17adf4:	vpbroadcastd %r9d,%xmm2
  17adfa:	shr    $0x20,%r9
  17adfe:	and    0x18(%rdi),%r9d
  17ae02:	mov    (%rdi),%r10
  17ae05:	shl    $0x4,%r9
  17ae09:	vmovdqa (%r10,%r9,1),%xmm3
  17ae0f:	vpmulhw %xmm0,%xmm2,%xmm2
  17ae13:	vpshufb %xmm2,%xmm1,%xmm2
  17ae18:	xor    %r9d,%r9d
  17ae1b:	vptest %xmm2,%xmm3
  17ae20:	setb   %r9b
  17ae24:	mov    %r9d,(%rcx,%r8,4)
  17ae28:	mov    0x8(%rdx,%r8,8),%r9
  17ae2d:	vpbroadcastd %r9d,%xmm2
  17ae33:	shr    $0x20,%r9
  17ae37:	and    0x18(%rdi),%r9d
  17ae3b:	mov    (%rdi),%r10
  17ae3e:	shl    $0x4,%r9
  17ae42:	vmovdqa (%r10,%r9,1),%xmm3
  17ae48:	vpmulhw %xmm0,%xmm2,%xmm2
  17ae4c:	vpshufb %xmm2,%xmm1,%xmm2
  17ae51:	xor    %r9d,%r9d
  17ae54:	vptest %xmm2,%xmm3
  17ae59:	setb   %r9b
  17ae5d:	mov    %r9d,0x4(%rcx,%r8,4)
  17ae62:	mov    0x10(%rdx,%r8,8),%r9
  17ae67:	vpbroadcastd %r9d,%xmm2
  17ae6d:	shr    $0x20,%r9
  17ae71:	and    0x18(%rdi),%r9d
  17ae75:	mov    (%rdi),%r10
  17ae78:	shl    $0x4,%r9
  17ae7c:	vmovdqa (%r10,%r9,1),%xmm3
  17ae82:	vpmulhw %xmm0,%xmm2,%xmm2
  17ae86:	vpshufb %xmm2,%xmm1,%xmm2
  17ae8b:	xor    %r9d,%r9d
  17ae8e:	vptest %xmm2,%xmm3
  17ae93:	setb   %r9b
  17ae97:	mov    %r9d,0x8(%rcx,%r8,4)
  17ae9c:	mov    0x18(%rdx,%r8,8),%r9
  17aea1:	vpbroadcastd %r9d,%xmm2
  17aea7:	shr    $0x20,%r9
  17aeab:	and    0x18(%rdi),%r9d
  17aeaf:	mov    (%rdi),%r10
  17aeb2:	shl    $0x4,%r9
  17aeb6:	vmovdqa (%r10,%r9,1),%xmm3
  17aebc:	vpmulhw %xmm0,%xmm2,%xmm2
  17aec0:	vpshufb %xmm2,%xmm1,%xmm2
  17aec5:	xor    %r9d,%r9d
  17aec8:	vptest %xmm2,%xmm3
  17aecd:	setb   %r9b
  17aed1:	mov    %r9d,0xc(%rcx,%r8,4)
  17aed6:	add    $0x4,%r8
  17aeda:	cmp    %r8,%rsi
  17aedd:	jne    17adf0 <void inline_single_kernel<false, bloom_filters::ByteSplitBloomFilter, unsigned long>(bloom_filters::ByteSplitBloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
  17aee3:	test   %rax,%rax
  17aee6:	je     17af50 <void inline_single_kernel<false, bloom_filters::ByteSplitBloomFilter, unsigned long>(bloom_filters::ByteSplitBloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x1a0>
  17aee8:	lea    (%rcx,%r8,4),%rcx
  17aeec:	lea    (%rdx,%r8,8),%rdx
  17aef0:	xor    %esi,%esi
  17aef2:	vmovdqa -0x1762ba(%rip),%xmm0        # 4c40 <typeinfo name for main::$_60+0x470>
  17aefa:	vpbroadcastq -0x177c13(%rip),%xmm1        # 32f0 <_IO_stdin_used+0x3c>
  17af03:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  17af10:	mov    (%rdx,%rsi,8),%r8
  17af14:	vpbroadcastd %r8d,%xmm2
  17af1a:	shr    $0x20,%r8
  17af1e:	and    0x18(%rdi),%r8d
  17af22:	mov    (%rdi),%r9
  17af25:	shl    $0x4,%r8
  17af29:	vmovdqa (%r9,%r8,1),%xmm3
  17af2f:	vpmulhw %xmm0,%xmm2,%xmm2
  17af33:	vpshufb %xmm2,%xmm1,%xmm2
  17af38:	xor    %r8d,%r8d
  17af3b:	vptest %xmm2,%xmm3
  17af40:	setb   %r8b
  17af44:	mov    %r8d,(%rcx,%rsi,4)
  17af48:	inc    %rsi
  17af4b:	cmp    %rsi,%rax
  17af4e:	jne    17af10 <void inline_single_kernel<false, bloom_filters::ByteSplitBloomFilter, unsigned long>(bloom_filters::ByteSplitBloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x160>
  17af50:	ret
  17af51:	int3
  17af52:	int3
  17af53:	int3
  17af54:	int3
  17af55:	int3
  17af56:	int3
  17af57:	int3
  17af58:	int3
  17af59:	int3
  17af5a:	int3
  17af5b:	int3
  17af5c:	int3
  17af5d:	int3
  17af5e:	int3
  17af5f:	int3

