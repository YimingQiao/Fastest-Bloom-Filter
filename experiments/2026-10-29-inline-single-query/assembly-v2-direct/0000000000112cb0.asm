0000000000112cb0 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
  112cb0:	test   %rsi,%rsi
  112cb3:	je     112d9e <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0xee>
  112cb9:	push   %rbx
  112cba:	mov    %rdx,%rax
  112cbd:	movabs $0xd6e8feb86659fd93,%r8
  112cc7:	xor    %r9d,%r9d
  112cca:	movabs $0xf1357aea2e62a9c5,%r10
  112cd4:	vmovdqa -0x10e3fc(%rip),%ymm0        # 48e0 <typeinfo name for main::$_60+0x110>
  112cdc:	vmovdqa -0x10e4c4(%rip),%ymm1        # 4820 <typeinfo name for main::$_60+0x50>
  112ce4:	vpbroadcastq -0x10f94d(%rip),%ymm2        # 33a0 <_IO_stdin_used+0xec>
  112ced:	vpbroadcastq -0x10f99e(%rip),%ymm3        # 3358 <_IO_stdin_used+0xa4>
  112cf6:	cs nopw 0x0(%rax,%rax,1)
  112d00:	mov    (%rax,%r9,8),%rdx
  112d04:	mov    %rdx,%r11
  112d07:	shr    $0x20,%r11
  112d0b:	xor    %rdx,%r11
  112d0e:	imul   %r8,%r11
  112d12:	mov    %r11,%rbx
  112d15:	shr    $0x20,%rbx
  112d19:	xor    %r11,%rbx
  112d1c:	imul   %r8,%rbx
  112d20:	mov    %rbx,%rdx
  112d23:	shr    $0x20,%rdx
  112d27:	xor    %rbx,%rdx
  112d2a:	or     $0x1,%rdx
  112d2e:	mov    0x20(%rdi),%r11
  112d32:	mulx   0x10(%rdi),%rbx,%rbx
  112d38:	imul   %r10,%rdx
  112d3c:	prefetcht0 (%r11,%rbx,8)
  112d41:	vpbroadcastq %rdx,%ymm4
  112d47:	vpsrlvq %ymm0,%ymm4,%ymm5
  112d4c:	vpsrlvq %ymm1,%ymm4,%ymm4
  112d51:	vpand  %ymm2,%ymm4,%ymm4
  112d55:	vpand  %ymm2,%ymm5,%ymm5
  112d59:	vpsllvq %ymm5,%ymm3,%ymm5
  112d5e:	vpsllvq %ymm4,%ymm3,%ymm4
  112d63:	vpor   %ymm5,%ymm4,%ymm4
  112d67:	vextracti128 $0x1,%ymm4,%xmm5
  112d6d:	vpor   %xmm5,%xmm4,%xmm4
  112d71:	vpshufd $0xee,%xmm4,%xmm5
  112d76:	vpor   %xmm5,%xmm4,%xmm4
  112d7a:	vmovq  %xmm4,%rdx
  112d7f:	mov    (%r11,%rbx,8),%r11
  112d83:	xor    %ebx,%ebx
  112d85:	andn   %rdx,%r11,%rdx
  112d8a:	sete   %bl
  112d8d:	mov    %ebx,(%rcx,%r9,4)
  112d91:	inc    %r9
  112d94:	cmp    %r9,%rsi
  112d97:	jne    112d00 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 8ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 8ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  112d9d:	pop    %rbx
  112d9e:	vzeroupper
  112da1:	ret
  112da2:	int3
  112da3:	int3
  112da4:	int3
  112da5:	int3
  112da6:	int3
  112da7:	int3
  112da8:	int3
  112da9:	int3
  112daa:	int3
  112dab:	int3
  112dac:	int3
  112dad:	int3
  112dae:	int3
  112daf:	int3

