0000000000056e10 <void inline_single_kernel<false, external_bloom::Fixed64, unsigned long>(external_bloom::Fixed64 const&, unsigned long, unsigned long const*, unsigned int*)>:
   56e10:	test   %rsi,%rsi
   56e13:	je     56fae <void inline_single_kernel<false, external_bloom::Fixed64, unsigned long>(external_bloom::Fixed64 const&, unsigned long, unsigned long const*, unsigned int*)+0x19e>
   56e19:	cmp    $0x1,%rsi
   56e1d:	jne    56e26 <void inline_single_kernel<false, external_bloom::Fixed64, unsigned long>(external_bloom::Fixed64 const&, unsigned long, unsigned long const*, unsigned int*)+0x16>
   56e1f:	xor    %eax,%eax
   56e21:	jmp    56f39 <void inline_single_kernel<false, external_bloom::Fixed64, unsigned long>(external_bloom::Fixed64 const&, unsigned long, unsigned long const*, unsigned int*)+0x129>
   56e26:	mov    %rsi,%r8
   56e29:	and    $0xfffffffffffffffe,%r8
   56e2d:	xor    %eax,%eax
   56e2f:	vmovdqa -0x52517(%rip),%ymm0        # 4920 <typeinfo name for main::$_60+0x150>
   56e37:	vpxor  %xmm1,%xmm1,%xmm1
   56e3b:	vpbroadcastq -0x53aec(%rip),%ymm2        # 3358 <_IO_stdin_used+0xa4>
   56e44:	data16 data16 cs nopw 0x0(%rax,%rax,1)
   56e50:	mov    (%rdx,%rax,8),%r9
   56e54:	vpbroadcastd %r9d,%ymm3
   56e5a:	shr    $0x20,%r9
   56e5e:	mov    (%rdi),%r10d
   56e61:	imul   %r9,%r10
   56e65:	vpmulld %ymm0,%ymm3,%ymm3
   56e6a:	vpsrld $0x1a,%ymm3,%ymm3
   56e6f:	vpunpckhdq %ymm1,%ymm3,%ymm4
   56e73:	vpsllvq %ymm4,%ymm2,%ymm4
   56e78:	vpunpckldq %ymm1,%ymm3,%ymm3
   56e7c:	vpsllvq %ymm3,%ymm2,%ymm3
   56e81:	mov    0x8(%rdi),%r9
   56e85:	shr    $0x1a,%r10
   56e89:	and    $0xffffffffffffffc0,%r10
   56e8d:	vmovdqa (%r9,%r10,1),%ymm5
   56e93:	vmovdqa 0x20(%r9,%r10,1),%ymm6
   56e9a:	vptest %ymm4,%ymm5
   56e9f:	setb   %r9b
   56ea3:	vptest %ymm3,%ymm6
   56ea8:	setb   %r10b
   56eac:	xor    %r11d,%r11d
   56eaf:	test   %r9b,%r10b
   56eb2:	setne  %r11b
   56eb6:	mov    %r11d,(%rcx,%rax,4)
   56eba:	mov    0x8(%rdx,%rax,8),%r9
   56ebf:	vpbroadcastd %r9d,%ymm3
   56ec5:	shr    $0x20,%r9
   56ec9:	mov    (%rdi),%r10d
   56ecc:	imul   %r9,%r10
   56ed0:	vpmulld %ymm0,%ymm3,%ymm3
   56ed5:	vpsrld $0x1a,%ymm3,%ymm3
   56eda:	vpunpckhdq %ymm1,%ymm3,%ymm4
   56ede:	vpsllvq %ymm4,%ymm2,%ymm4
   56ee3:	vpunpckldq %ymm1,%ymm3,%ymm3
   56ee7:	vpsllvq %ymm3,%ymm2,%ymm3
   56eec:	mov    0x8(%rdi),%r9
   56ef0:	shr    $0x1a,%r10
   56ef4:	and    $0xffffffffffffffc0,%r10
   56ef8:	vmovdqa (%r9,%r10,1),%ymm5
   56efe:	vmovdqa 0x20(%r9,%r10,1),%ymm6
   56f05:	vptest %ymm4,%ymm5
   56f0a:	setb   %r9b
   56f0e:	vptest %ymm3,%ymm6
   56f13:	setb   %r10b
   56f17:	xor    %r11d,%r11d
   56f1a:	test   %r9b,%r10b
   56f1d:	setne  %r11b
   56f21:	mov    %r11d,0x4(%rcx,%rax,4)
   56f26:	add    $0x2,%rax
   56f2a:	cmp    %rax,%r8
   56f2d:	jne    56e50 <void inline_single_kernel<false, external_bloom::Fixed64, unsigned long>(external_bloom::Fixed64 const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
   56f33:	test   $0x1,%sil
   56f37:	je     56fae <void inline_single_kernel<false, external_bloom::Fixed64, unsigned long>(external_bloom::Fixed64 const&, unsigned long, unsigned long const*, unsigned int*)+0x19e>
   56f39:	mov    (%rdx,%rax,8),%rdx
   56f3d:	vpbroadcastd %edx,%ymm0
   56f43:	shr    $0x20,%rdx
   56f47:	mov    (%rdi),%esi
   56f49:	imul   %rdx,%rsi
   56f4d:	vpmulld -0x52636(%rip),%ymm0,%ymm0        # 4920 <typeinfo name for main::$_60+0x150>
   56f56:	vpsrld $0x1a,%ymm0,%ymm0
   56f5b:	vpxor  %xmm1,%xmm1,%xmm1
   56f5f:	vpunpckhdq %ymm1,%ymm0,%ymm2
   56f63:	vpbroadcastq -0x53c14(%rip),%ymm3        # 3358 <_IO_stdin_used+0xa4>
   56f6c:	vpsllvq %ymm2,%ymm3,%ymm2
   56f71:	vpunpckldq %ymm1,%ymm0,%ymm0
   56f75:	vpsllvq %ymm0,%ymm3,%ymm0
   56f7a:	mov    0x8(%rdi),%rdx
   56f7e:	shr    $0x1a,%rsi
   56f82:	and    $0xffffffffffffffc0,%rsi
   56f86:	vmovdqa (%rdx,%rsi,1),%ymm1
   56f8b:	vmovdqa 0x20(%rdx,%rsi,1),%ymm3
   56f91:	vptest %ymm2,%ymm1
   56f96:	setb   %dl
   56f99:	vptest %ymm0,%ymm3
   56f9e:	setb   %sil
   56fa2:	xor    %edi,%edi
   56fa4:	test   %dl,%sil
   56fa7:	setne  %dil
   56fab:	mov    %edi,(%rcx,%rax,4)
   56fae:	vzeroupper
   56fb1:	ret
   56fb2:	int3
   56fb3:	int3
   56fb4:	int3
   56fb5:	int3
   56fb6:	int3
   56fb7:	int3
   56fb8:	int3
   56fb9:	int3
   56fba:	int3
   56fbb:	int3
   56fbc:	int3
   56fbd:	int3
   56fbe:	int3
   56fbf:	int3

