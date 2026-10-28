000000000005cc60 <void inline_single_kernel<true, external_bloom::Fixed16, unsigned long>(external_bloom::Fixed16 const&, unsigned long, unsigned long const*, unsigned int*)>:
   5cc60:	test   %rsi,%rsi
   5cc63:	je     5cde3 <void inline_single_kernel<true, external_bloom::Fixed16, unsigned long>(external_bloom::Fixed16 const&, unsigned long, unsigned long const*, unsigned int*)+0x183>
   5cc69:	push   %rbx
   5cc6a:	movabs $0xd6e8feb86659fd93,%r8
   5cc74:	cmp    $0x1,%rsi
   5cc78:	jne    5cc81 <void inline_single_kernel<true, external_bloom::Fixed16, unsigned long>(external_bloom::Fixed16 const&, unsigned long, unsigned long const*, unsigned int*)+0x21>
   5cc7a:	xor    %eax,%eax
   5cc7c:	jmp    5cd77 <void inline_single_kernel<true, external_bloom::Fixed16, unsigned long>(external_bloom::Fixed16 const&, unsigned long, unsigned long const*, unsigned int*)+0x117>
   5cc81:	mov    %rsi,%r9
   5cc84:	and    $0xfffffffffffffffe,%r9
   5cc88:	xor    %eax,%eax
   5cc8a:	vmovdqa -0x58052(%rip),%xmm0        # 4c40 <typeinfo name for main::$_60+0x470>
   5cc92:	vpbroadcastq -0x599ab(%rip),%xmm1        # 32f0 <_IO_stdin_used+0x3c>
   5cc9b:	nopl   0x0(%rax,%rax,1)
   5cca0:	mov    (%rdx,%rax,8),%r10
   5cca4:	mov    %r10,%r11
   5cca7:	shr    $0x20,%r11
   5ccab:	xor    %r10,%r11
   5ccae:	imul   %r8,%r11
   5ccb2:	mov    %r11,%r10
   5ccb5:	shr    $0x20,%r10
   5ccb9:	xor    %r11,%r10
   5ccbc:	imul   %r8,%r10
   5ccc0:	mov    %r10,%r11
   5ccc3:	shr    $0x20,%r11
   5ccc7:	xor    %r11d,%r10d
   5ccca:	mov    (%rdi),%ebx
   5cccc:	imul   %r11,%rbx
   5ccd0:	vpbroadcastd %r10d,%xmm2
   5ccd6:	vpmulhw %xmm0,%xmm2,%xmm2
   5ccda:	vpshufb %xmm2,%xmm1,%xmm2
   5ccdf:	mov    0x8(%rdi),%r10
   5cce3:	shr    $0x1c,%rbx
   5cce7:	and    $0xfffffffffffffff0,%rbx
   5cceb:	vmovdqu (%r10,%rbx,1),%xmm3
   5ccf1:	xor    %r10d,%r10d
   5ccf4:	vptest %xmm2,%xmm3
   5ccf9:	setb   %r10b
   5ccfd:	mov    %r10d,(%rcx,%rax,4)
   5cd01:	mov    0x8(%rdx,%rax,8),%r10
   5cd06:	mov    %r10,%r11
   5cd09:	shr    $0x20,%r11
   5cd0d:	xor    %r10,%r11
   5cd10:	imul   %r8,%r11
   5cd14:	mov    %r11,%r10
   5cd17:	shr    $0x20,%r10
   5cd1b:	xor    %r11,%r10
   5cd1e:	imul   %r8,%r10
   5cd22:	mov    %r10,%r11
   5cd25:	shr    $0x20,%r11
   5cd29:	xor    %r11d,%r10d
   5cd2c:	mov    (%rdi),%ebx
   5cd2e:	imul   %r11,%rbx
   5cd32:	vpbroadcastd %r10d,%xmm2
   5cd38:	vpmulhw %xmm0,%xmm2,%xmm2
   5cd3c:	vpshufb %xmm2,%xmm1,%xmm2
   5cd41:	mov    0x8(%rdi),%r10
   5cd45:	shr    $0x1c,%rbx
   5cd49:	and    $0xfffffffffffffff0,%rbx
   5cd4d:	vmovdqu (%r10,%rbx,1),%xmm3
   5cd53:	xor    %r10d,%r10d
   5cd56:	vptest %xmm2,%xmm3
   5cd5b:	setb   %r10b
   5cd5f:	mov    %r10d,0x4(%rcx,%rax,4)
   5cd64:	add    $0x2,%rax
   5cd68:	cmp    %rax,%r9
   5cd6b:	jne    5cca0 <void inline_single_kernel<true, external_bloom::Fixed16, unsigned long>(external_bloom::Fixed16 const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
   5cd71:	test   $0x1,%sil
   5cd75:	je     5cde2 <void inline_single_kernel<true, external_bloom::Fixed16, unsigned long>(external_bloom::Fixed16 const&, unsigned long, unsigned long const*, unsigned int*)+0x182>
   5cd77:	mov    (%rdx,%rax,8),%rdx
   5cd7b:	mov    %rdx,%rsi
   5cd7e:	shr    $0x20,%rsi
   5cd82:	xor    %rdx,%rsi
   5cd85:	imul   %r8,%rsi
   5cd89:	mov    %rsi,%rdx
   5cd8c:	shr    $0x20,%rdx
   5cd90:	xor    %rsi,%rdx
   5cd93:	imul   %r8,%rdx
   5cd97:	mov    %rdx,%rsi
   5cd9a:	shr    $0x20,%rsi
   5cd9e:	xor    %esi,%edx
   5cda0:	mov    (%rdi),%r8d
   5cda3:	imul   %rsi,%r8
   5cda7:	vpbroadcastd %edx,%xmm0
   5cdad:	vpmulhw -0x58175(%rip),%xmm0,%xmm0        # 4c40 <typeinfo name for main::$_60+0x470>
   5cdb5:	vpbroadcastq -0x59ace(%rip),%xmm1        # 32f0 <_IO_stdin_used+0x3c>
   5cdbe:	vpshufb %xmm0,%xmm1,%xmm0
   5cdc3:	mov    0x8(%rdi),%rdx
   5cdc7:	shr    $0x1c,%r8
   5cdcb:	and    $0xfffffffffffffff0,%r8
   5cdcf:	vmovdqu (%rdx,%r8,1),%xmm1
   5cdd5:	xor    %edx,%edx
   5cdd7:	vptest %xmm0,%xmm1
   5cddc:	setb   %dl
   5cddf:	mov    %edx,(%rcx,%rax,4)
   5cde2:	pop    %rbx
   5cde3:	ret
   5cde4:	int3
   5cde5:	int3
   5cde6:	int3
   5cde7:	int3
   5cde8:	int3
   5cde9:	int3
   5cdea:	int3
   5cdeb:	int3
   5cdec:	int3
   5cded:	int3
   5cdee:	int3
   5cdef:	int3

