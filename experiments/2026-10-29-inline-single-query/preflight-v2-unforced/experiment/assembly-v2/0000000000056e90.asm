0000000000056e90 <void inline_single_kernel<false, external_bloom::Fixed64, unsigned long>(external_bloom::Fixed64 const&, unsigned long, unsigned long const*, unsigned int*)>:
   56e90:	test   %rsi,%rsi
   56e93:	je     5702e <void inline_single_kernel<false, external_bloom::Fixed64, unsigned long>(external_bloom::Fixed64 const&, unsigned long, unsigned long const*, unsigned int*)+0x19e>
   56e99:	cmp    $0x1,%rsi
   56e9d:	jne    56ea6 <void inline_single_kernel<false, external_bloom::Fixed64, unsigned long>(external_bloom::Fixed64 const&, unsigned long, unsigned long const*, unsigned int*)+0x16>
   56e9f:	xor    %eax,%eax
   56ea1:	jmp    56fb9 <void inline_single_kernel<false, external_bloom::Fixed64, unsigned long>(external_bloom::Fixed64 const&, unsigned long, unsigned long const*, unsigned int*)+0x129>
   56ea6:	mov    %rsi,%r8
   56ea9:	and    $0xfffffffffffffffe,%r8
   56ead:	xor    %eax,%eax
   56eaf:	vmovdqa -0x52597(%rip),%ymm0        # 4920 <typeinfo name for main::$_60+0x150>
   56eb7:	vpxor  %xmm1,%xmm1,%xmm1
   56ebb:	vpbroadcastq -0x53b6c(%rip),%ymm2        # 3358 <_IO_stdin_used+0xa4>
   56ec4:	data16 data16 cs nopw 0x0(%rax,%rax,1)
   56ed0:	mov    (%rdx,%rax,8),%r9
   56ed4:	vpbroadcastd %r9d,%ymm3
   56eda:	shr    $0x20,%r9
   56ede:	mov    (%rdi),%r10d
   56ee1:	imul   %r9,%r10
   56ee5:	vpmulld %ymm0,%ymm3,%ymm3
   56eea:	vpsrld $0x1a,%ymm3,%ymm3
   56eef:	vpunpckhdq %ymm1,%ymm3,%ymm4
   56ef3:	vpsllvq %ymm4,%ymm2,%ymm4
   56ef8:	vpunpckldq %ymm1,%ymm3,%ymm3
   56efc:	vpsllvq %ymm3,%ymm2,%ymm3
   56f01:	mov    0x8(%rdi),%r9
   56f05:	shr    $0x1a,%r10
   56f09:	and    $0xffffffffffffffc0,%r10
   56f0d:	vmovdqa (%r9,%r10,1),%ymm5
   56f13:	vmovdqa 0x20(%r9,%r10,1),%ymm6
   56f1a:	vptest %ymm4,%ymm5
   56f1f:	setb   %r9b
   56f23:	vptest %ymm3,%ymm6
   56f28:	setb   %r10b
   56f2c:	xor    %r11d,%r11d
   56f2f:	test   %r9b,%r10b
   56f32:	setne  %r11b
   56f36:	mov    %r11d,(%rcx,%rax,4)
   56f3a:	mov    0x8(%rdx,%rax,8),%r9
   56f3f:	vpbroadcastd %r9d,%ymm3
   56f45:	shr    $0x20,%r9
   56f49:	mov    (%rdi),%r10d
   56f4c:	imul   %r9,%r10
   56f50:	vpmulld %ymm0,%ymm3,%ymm3
   56f55:	vpsrld $0x1a,%ymm3,%ymm3
   56f5a:	vpunpckhdq %ymm1,%ymm3,%ymm4
   56f5e:	vpsllvq %ymm4,%ymm2,%ymm4
   56f63:	vpunpckldq %ymm1,%ymm3,%ymm3
   56f67:	vpsllvq %ymm3,%ymm2,%ymm3
   56f6c:	mov    0x8(%rdi),%r9
   56f70:	shr    $0x1a,%r10
   56f74:	and    $0xffffffffffffffc0,%r10
   56f78:	vmovdqa (%r9,%r10,1),%ymm5
   56f7e:	vmovdqa 0x20(%r9,%r10,1),%ymm6
   56f85:	vptest %ymm4,%ymm5
   56f8a:	setb   %r9b
   56f8e:	vptest %ymm3,%ymm6
   56f93:	setb   %r10b
   56f97:	xor    %r11d,%r11d
   56f9a:	test   %r9b,%r10b
   56f9d:	setne  %r11b
   56fa1:	mov    %r11d,0x4(%rcx,%rax,4)
   56fa6:	add    $0x2,%rax
   56faa:	cmp    %rax,%r8
   56fad:	jne    56ed0 <void inline_single_kernel<false, external_bloom::Fixed64, unsigned long>(external_bloom::Fixed64 const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
   56fb3:	test   $0x1,%sil
   56fb7:	je     5702e <void inline_single_kernel<false, external_bloom::Fixed64, unsigned long>(external_bloom::Fixed64 const&, unsigned long, unsigned long const*, unsigned int*)+0x19e>
   56fb9:	mov    (%rdx,%rax,8),%rdx
   56fbd:	vpbroadcastd %edx,%ymm0
   56fc3:	shr    $0x20,%rdx
   56fc7:	mov    (%rdi),%esi
   56fc9:	imul   %rdx,%rsi
   56fcd:	vpmulld -0x526b6(%rip),%ymm0,%ymm0        # 4920 <typeinfo name for main::$_60+0x150>
   56fd6:	vpsrld $0x1a,%ymm0,%ymm0
   56fdb:	vpxor  %xmm1,%xmm1,%xmm1
   56fdf:	vpunpckhdq %ymm1,%ymm0,%ymm2
   56fe3:	vpbroadcastq -0x53c94(%rip),%ymm3        # 3358 <_IO_stdin_used+0xa4>
   56fec:	vpsllvq %ymm2,%ymm3,%ymm2
   56ff1:	vpunpckldq %ymm1,%ymm0,%ymm0
   56ff5:	vpsllvq %ymm0,%ymm3,%ymm0
   56ffa:	mov    0x8(%rdi),%rdx
   56ffe:	shr    $0x1a,%rsi
   57002:	and    $0xffffffffffffffc0,%rsi
   57006:	vmovdqa (%rdx,%rsi,1),%ymm1
   5700b:	vmovdqa 0x20(%rdx,%rsi,1),%ymm3
   57011:	vptest %ymm2,%ymm1
   57016:	setb   %dl
   57019:	vptest %ymm0,%ymm3
   5701e:	setb   %sil
   57022:	xor    %edi,%edi
   57024:	test   %dl,%sil
   57027:	setne  %dil
   5702b:	mov    %edi,(%rcx,%rax,4)
   5702e:	vzeroupper
   57031:	ret
   57032:	int3
   57033:	int3
   57034:	int3
   57035:	int3
   57036:	int3
   57037:	int3
   57038:	int3
   57039:	int3
   5703a:	int3
   5703b:	int3
   5703c:	int3
   5703d:	int3
   5703e:	int3
   5703f:	int3

