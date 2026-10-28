000000000017bf40 <void inline_single_kernel<true, bloom_filters::ByteSplitBloomFilter, unsigned long>(bloom_filters::ByteSplitBloomFilter const&, unsigned long, unsigned long const*, unsigned int*)>:
  17bf40:	test   %rsi,%rsi
  17bf43:	je     17c0ab <void inline_single_kernel<true, bloom_filters::ByteSplitBloomFilter, unsigned long>(bloom_filters::ByteSplitBloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x16b>
  17bf49:	push   %rbx
  17bf4a:	movabs $0xd6e8feb86659fd93,%r8
  17bf54:	cmp    $0x1,%rsi
  17bf58:	jne    17bf61 <void inline_single_kernel<true, bloom_filters::ByteSplitBloomFilter, unsigned long>(bloom_filters::ByteSplitBloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x21>
  17bf5a:	xor    %eax,%eax
  17bf5c:	jmp    17c049 <void inline_single_kernel<true, bloom_filters::ByteSplitBloomFilter, unsigned long>(bloom_filters::ByteSplitBloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x109>
  17bf61:	mov    %rsi,%r9
  17bf64:	and    $0xfffffffffffffffe,%r9
  17bf68:	xor    %eax,%eax
  17bf6a:	vmovdqa -0x177332(%rip),%xmm0        # 4c40 <typeinfo name for main::$_60+0x470>
  17bf72:	vpbroadcastq -0x178c8b(%rip),%xmm1        # 32f0 <_IO_stdin_used+0x3c>
  17bf7b:	nopl   0x0(%rax,%rax,1)
  17bf80:	mov    (%rdx,%rax,8),%r10
  17bf84:	mov    %r10,%r11
  17bf87:	shr    $0x20,%r11
  17bf8b:	xor    %r10,%r11
  17bf8e:	imul   %r8,%r11
  17bf92:	mov    %r11,%r10
  17bf95:	shr    $0x20,%r10
  17bf99:	xor    %r11,%r10
  17bf9c:	imul   %r8,%r10
  17bfa0:	mov    %r10,%r11
  17bfa3:	shr    $0x20,%r11
  17bfa7:	xor    %r11d,%r10d
  17bfaa:	and    0x18(%rdi),%r11d
  17bfae:	mov    (%rdi),%rbx
  17bfb1:	shl    $0x4,%r11
  17bfb5:	vmovdqa (%rbx,%r11,1),%xmm2
  17bfbb:	vpbroadcastd %r10d,%xmm3
  17bfc1:	vpmulhw %xmm0,%xmm3,%xmm3
  17bfc5:	vpshufb %xmm3,%xmm1,%xmm3
  17bfca:	xor    %r10d,%r10d
  17bfcd:	vptest %xmm3,%xmm2
  17bfd2:	setb   %r10b
  17bfd6:	mov    %r10d,(%rcx,%rax,4)
  17bfda:	mov    0x8(%rdx,%rax,8),%r10
  17bfdf:	mov    %r10,%r11
  17bfe2:	shr    $0x20,%r11
  17bfe6:	xor    %r10,%r11
  17bfe9:	imul   %r8,%r11
  17bfed:	mov    %r11,%r10
  17bff0:	shr    $0x20,%r10
  17bff4:	xor    %r11,%r10
  17bff7:	imul   %r8,%r10
  17bffb:	mov    %r10,%r11
  17bffe:	shr    $0x20,%r11
  17c002:	xor    %r11d,%r10d
  17c005:	and    0x18(%rdi),%r11d
  17c009:	mov    (%rdi),%rbx
  17c00c:	shl    $0x4,%r11
  17c010:	vmovdqa (%rbx,%r11,1),%xmm2
  17c016:	vpbroadcastd %r10d,%xmm3
  17c01c:	vpmulhw %xmm0,%xmm3,%xmm3
  17c020:	vpshufb %xmm3,%xmm1,%xmm3
  17c025:	xor    %r10d,%r10d
  17c028:	vptest %xmm3,%xmm2
  17c02d:	setb   %r10b
  17c031:	mov    %r10d,0x4(%rcx,%rax,4)
  17c036:	add    $0x2,%rax
  17c03a:	cmp    %rax,%r9
  17c03d:	jne    17bf80 <void inline_single_kernel<true, bloom_filters::ByteSplitBloomFilter, unsigned long>(bloom_filters::ByteSplitBloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
  17c043:	test   $0x1,%sil
  17c047:	je     17c0aa <void inline_single_kernel<true, bloom_filters::ByteSplitBloomFilter, unsigned long>(bloom_filters::ByteSplitBloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x16a>
  17c049:	mov    (%rdx,%rax,8),%rdx
  17c04d:	mov    %rdx,%rsi
  17c050:	shr    $0x20,%rsi
  17c054:	xor    %rdx,%rsi
  17c057:	imul   %r8,%rsi
  17c05b:	mov    %rsi,%rdx
  17c05e:	shr    $0x20,%rdx
  17c062:	xor    %rsi,%rdx
  17c065:	imul   %r8,%rdx
  17c069:	mov    %rdx,%rsi
  17c06c:	shr    $0x20,%rsi
  17c070:	xor    %esi,%edx
  17c072:	and    0x18(%rdi),%esi
  17c075:	mov    (%rdi),%rdi
  17c078:	shl    $0x4,%rsi
  17c07c:	vmovdqa (%rdi,%rsi,1),%xmm0
  17c081:	vpbroadcastd %edx,%xmm1
  17c087:	vpmulhw -0x17744f(%rip),%xmm1,%xmm1        # 4c40 <typeinfo name for main::$_60+0x470>
  17c08f:	vpbroadcastq -0x178da8(%rip),%xmm2        # 32f0 <_IO_stdin_used+0x3c>
  17c098:	vpshufb %xmm1,%xmm2,%xmm1
  17c09d:	xor    %edx,%edx
  17c09f:	vptest %xmm1,%xmm0
  17c0a4:	setb   %dl
  17c0a7:	mov    %edx,(%rcx,%rax,4)
  17c0aa:	pop    %rbx
  17c0ab:	ret
  17c0ac:	int3
  17c0ad:	int3
  17c0ae:	int3
  17c0af:	int3

