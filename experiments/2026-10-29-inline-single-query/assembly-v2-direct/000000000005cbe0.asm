000000000005cbe0 <void inline_single_kernel<true, external_bloom::Fixed16, unsigned long>(external_bloom::Fixed16 const&, unsigned long, unsigned long const*, unsigned int*)>:
   5cbe0:	test   %rsi,%rsi
   5cbe3:	je     5cd63 <void inline_single_kernel<true, external_bloom::Fixed16, unsigned long>(external_bloom::Fixed16 const&, unsigned long, unsigned long const*, unsigned int*)+0x183>
   5cbe9:	push   %rbx
   5cbea:	movabs $0xd6e8feb86659fd93,%r8
   5cbf4:	cmp    $0x1,%rsi
   5cbf8:	jne    5cc01 <void inline_single_kernel<true, external_bloom::Fixed16, unsigned long>(external_bloom::Fixed16 const&, unsigned long, unsigned long const*, unsigned int*)+0x21>
   5cbfa:	xor    %eax,%eax
   5cbfc:	jmp    5ccf7 <void inline_single_kernel<true, external_bloom::Fixed16, unsigned long>(external_bloom::Fixed16 const&, unsigned long, unsigned long const*, unsigned int*)+0x117>
   5cc01:	mov    %rsi,%r9
   5cc04:	and    $0xfffffffffffffffe,%r9
   5cc08:	xor    %eax,%eax
   5cc0a:	vmovdqa -0x57fd2(%rip),%xmm0        # 4c40 <typeinfo name for main::$_60+0x470>
   5cc12:	vpbroadcastq -0x5992b(%rip),%xmm1        # 32f0 <_IO_stdin_used+0x3c>
   5cc1b:	nopl   0x0(%rax,%rax,1)
   5cc20:	mov    (%rdx,%rax,8),%r10
   5cc24:	mov    %r10,%r11
   5cc27:	shr    $0x20,%r11
   5cc2b:	xor    %r10,%r11
   5cc2e:	imul   %r8,%r11
   5cc32:	mov    %r11,%r10
   5cc35:	shr    $0x20,%r10
   5cc39:	xor    %r11,%r10
   5cc3c:	imul   %r8,%r10
   5cc40:	mov    %r10,%r11
   5cc43:	shr    $0x20,%r11
   5cc47:	xor    %r11d,%r10d
   5cc4a:	mov    (%rdi),%ebx
   5cc4c:	imul   %r11,%rbx
   5cc50:	vpbroadcastd %r10d,%xmm2
   5cc56:	vpmulhw %xmm0,%xmm2,%xmm2
   5cc5a:	vpshufb %xmm2,%xmm1,%xmm2
   5cc5f:	mov    0x8(%rdi),%r10
   5cc63:	shr    $0x1c,%rbx
   5cc67:	and    $0xfffffffffffffff0,%rbx
   5cc6b:	vmovdqu (%r10,%rbx,1),%xmm3
   5cc71:	xor    %r10d,%r10d
   5cc74:	vptest %xmm2,%xmm3
   5cc79:	setb   %r10b
   5cc7d:	mov    %r10d,(%rcx,%rax,4)
   5cc81:	mov    0x8(%rdx,%rax,8),%r10
   5cc86:	mov    %r10,%r11
   5cc89:	shr    $0x20,%r11
   5cc8d:	xor    %r10,%r11
   5cc90:	imul   %r8,%r11
   5cc94:	mov    %r11,%r10
   5cc97:	shr    $0x20,%r10
   5cc9b:	xor    %r11,%r10
   5cc9e:	imul   %r8,%r10
   5cca2:	mov    %r10,%r11
   5cca5:	shr    $0x20,%r11
   5cca9:	xor    %r11d,%r10d
   5ccac:	mov    (%rdi),%ebx
   5ccae:	imul   %r11,%rbx
   5ccb2:	vpbroadcastd %r10d,%xmm2
   5ccb8:	vpmulhw %xmm0,%xmm2,%xmm2
   5ccbc:	vpshufb %xmm2,%xmm1,%xmm2
   5ccc1:	mov    0x8(%rdi),%r10
   5ccc5:	shr    $0x1c,%rbx
   5ccc9:	and    $0xfffffffffffffff0,%rbx
   5cccd:	vmovdqu (%r10,%rbx,1),%xmm3
   5ccd3:	xor    %r10d,%r10d
   5ccd6:	vptest %xmm2,%xmm3
   5ccdb:	setb   %r10b
   5ccdf:	mov    %r10d,0x4(%rcx,%rax,4)
   5cce4:	add    $0x2,%rax
   5cce8:	cmp    %rax,%r9
   5cceb:	jne    5cc20 <void inline_single_kernel<true, external_bloom::Fixed16, unsigned long>(external_bloom::Fixed16 const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
   5ccf1:	test   $0x1,%sil
   5ccf5:	je     5cd62 <void inline_single_kernel<true, external_bloom::Fixed16, unsigned long>(external_bloom::Fixed16 const&, unsigned long, unsigned long const*, unsigned int*)+0x182>
   5ccf7:	mov    (%rdx,%rax,8),%rdx
   5ccfb:	mov    %rdx,%rsi
   5ccfe:	shr    $0x20,%rsi
   5cd02:	xor    %rdx,%rsi
   5cd05:	imul   %r8,%rsi
   5cd09:	mov    %rsi,%rdx
   5cd0c:	shr    $0x20,%rdx
   5cd10:	xor    %rsi,%rdx
   5cd13:	imul   %r8,%rdx
   5cd17:	mov    %rdx,%rsi
   5cd1a:	shr    $0x20,%rsi
   5cd1e:	xor    %esi,%edx
   5cd20:	mov    (%rdi),%r8d
   5cd23:	imul   %rsi,%r8
   5cd27:	vpbroadcastd %edx,%xmm0
   5cd2d:	vpmulhw -0x580f5(%rip),%xmm0,%xmm0        # 4c40 <typeinfo name for main::$_60+0x470>
   5cd35:	vpbroadcastq -0x59a4e(%rip),%xmm1        # 32f0 <_IO_stdin_used+0x3c>
   5cd3e:	vpshufb %xmm0,%xmm1,%xmm0
   5cd43:	mov    0x8(%rdi),%rdx
   5cd47:	shr    $0x1c,%r8
   5cd4b:	and    $0xfffffffffffffff0,%r8
   5cd4f:	vmovdqu (%rdx,%r8,1),%xmm1
   5cd55:	xor    %edx,%edx
   5cd57:	vptest %xmm0,%xmm1
   5cd5c:	setb   %dl
   5cd5f:	mov    %edx,(%rcx,%rax,4)
   5cd62:	pop    %rbx
   5cd63:	ret
   5cd64:	int3
   5cd65:	int3
   5cd66:	int3
   5cd67:	int3
   5cd68:	int3
   5cd69:	int3
   5cd6a:	int3
   5cd6b:	int3
   5cd6c:	int3
   5cd6d:	int3
   5cd6e:	int3
   5cd6f:	int3

