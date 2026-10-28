0000000000013c10 <byte_inline_production_probe::byte_public_contains_loop>:
   13c10:	push   %rbp
   13c11:	push   %r15
   13c13:	push   %r14
   13c15:	push   %r13
   13c17:	push   %r12
   13c19:	push   %rbx
   13c1a:	sub    $0x48,%rsp
   13c1e:	mov    %rdx,0x8(%rsp)
   13c23:	mov    %r8,0x10(%rsp)
   13c28:	cmp    %r8,%rdx
   13c2b:	jne    13edc <byte_inline_production_probe::byte_public_contains_loop+0x2cc>
   13c31:	test   %rdx,%rdx
   13c34:	je     13eca <byte_inline_production_probe::byte_public_contains_loop+0x2ba>
   13c3a:	mov    0x18(%rdi),%r8d
   13c3e:	mov    0x8(%rdi),%r9
   13c42:	cmpb   $0x0,0x1c(%rdi)
   13c46:	je     13c5a <byte_inline_production_probe::byte_public_contains_loop+0x4a>
   13c48:	cmp    $0x1,%rdx
   13c4c:	jne    13deb <byte_inline_production_probe::byte_public_contains_loop+0x1db>
   13c52:	xor    %r10d,%r10d
   13c55:	jmp    13e86 <byte_inline_production_probe::byte_public_contains_loop+0x276>
   13c5a:	mov    0x10(%rdi),%rax
   13c5e:	xor    %r10d,%r10d
   13c61:	vmovdqa -0xdf09(%rip),%ymm0        # 5d60 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x144>
   13c69:	vmovdqa64 -0xdcb3(%rip),%zmm1        # 5fc0 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x60>
   13c73:	vpbroadcastq -0xdd55(%rip),%zmm2        # 5f28 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.11.llvm.15448142832521594973+0x88>
   13c7d:	vpbroadcastd -0xdf9e(%rip),%xmm3        # 5ce8 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0xcc>
   13c86:	vmovq  -0xdb8e(%rip),%xmm4        # 6100 <anon.35274091df3394f4211c680a8c77ed4a.34.llvm.9036914972901821666+0x80>
   13c8e:	vpxor  %xmm5,%xmm5,%xmm5
   13c92:	mov    $0xff7f,%r14w
   13c97:	vmovdqa -0xdf5f(%rip),%ymm6        # 5d40 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x124>
   13c9f:	nop
   13ca0:	mov    (%rsi,%r10,8),%r12
   13ca4:	mov    %r12,%r15
   13ca7:	shr    $0x20,%r15
   13cab:	and    %r8d,%r15d
   13cae:	mov    %r15d,%edi
   13cb1:	shr    $0x2,%edi
   13cb4:	cmp    %rax,%rdi
   13cb7:	jae    13f03 <byte_inline_production_probe::byte_public_contains_loop+0x2f3>
   13cbd:	shl    $0x6,%rdi
   13cc1:	add    %r9,%rdi
   13cc4:	shl    $0x4,%r15d
   13cc8:	and    $0x30,%r15d
   13ccc:	vmovd  %r12d,%xmm7
   13cd1:	shl    $0x10,%r12d
   13cd5:	vpinsrd $0x1,%r12d,%xmm7,%xmm7
   13cdb:	vpsrad $0x10,%xmm7,%xmm7
   13ce0:	vpbroadcastq %xmm7,%ymm8
   13ce5:	vpmaddwd %ymm0,%ymm8,%ymm8
   13ce9:	vmovd  %xmm7,%r12d
   13cee:	vpextrd $0x1,%xmm7,%r13d
   13cf4:	test   %r13d,%r13d
   13cf7:	setg   %r13b
   13cfb:	sets   %r11b
   13cff:	test   %r12d,%r12d
   13d02:	sets   %r12b
   13d06:	vpxor  %xmm7,%xmm7,%xmm7
   13d0a:	vpermd %zmm8,%zmm1,%zmm7
   13d10:	vpsrlvd %zmm2,%zmm7,%zmm7
   13d16:	vpmovdb %zmm7,%xmm7
   13d1c:	setg   %bl
   13d1f:	vpand  %xmm3,%xmm7,%xmm8
   13d23:	mov    $0xfffd,%bp
   13d27:	kmovd  %ebp,%k1
   13d2b:	vpcmpgtb %xmm7,%xmm5,%k0{%k1}
   13d31:	kmovd  %r11d,%k1
   13d36:	kshiftlw $0xf,%k1,%k1
   13d3c:	kshiftrw $0xe,%k1,%k1
   13d42:	korw   %k1,%k0,%k0
   13d46:	mov    $0xfff7,%r11w
   13d4b:	kmovd  %r11d,%k1
   13d50:	kandw  %k1,%k0,%k0
   13d54:	kmovd  %r12d,%k1
   13d59:	kshiftlw $0xf,%k1,%k1
   13d5f:	kshiftrw $0xc,%k1,%k1
   13d65:	korw   %k1,%k0,%k0
   13d69:	mov    $0xffdf,%r11w
   13d6e:	kmovd  %r11d,%k1
   13d73:	kandw  %k1,%k0,%k0
   13d77:	kmovd  %r13d,%k1
   13d7c:	kshiftlw $0xf,%k1,%k1
   13d82:	kshiftrw $0xa,%k1,%k1
   13d88:	korw   %k1,%k0,%k0
   13d8c:	kmovd  %r14d,%k1
   13d91:	kandw  %k1,%k0,%k0
   13d95:	kmovd  %ebx,%k1
   13d99:	kshiftlw $0xf,%k1,%k1
   13d9f:	kshiftrw $0x8,%k1,%k1
   13da5:	korw   %k1,%k0,%k0
   13da9:	vpmovm2w %k0,%ymm7
   13daf:	vpermw %ymm7,%ymm6,%ymm7
   13db5:	vpmovw2m %ymm7,%k0
   13dbb:	knotw  %k0,%k1
   13dbf:	vpshufb %xmm8,%xmm4,%xmm7{%k1}{z}
   13dc5:	vmovdqu (%r15,%rdi,1),%xmm8
   13dcb:	xor    %edi,%edi
   13dcd:	vptest %xmm7,%xmm8
   13dd2:	setb   %dil
   13dd6:	mov    %edi,(%rcx,%r10,4)
   13dda:	inc    %r10
   13ddd:	cmp    %r10,%rdx
   13de0:	jne    13ca0 <byte_inline_production_probe::byte_public_contains_loop+0x90>
   13de6:	jmp    13eca <byte_inline_production_probe::byte_public_contains_loop+0x2ba>
   13deb:	mov    %rdx,%rax
   13dee:	and    $0xfffffffffffffffe,%rax
   13df2:	xor    %edi,%edi
   13df4:	vmovdqa -0xdc9c(%rip),%xmm0        # 6160 <anon.35274091df3394f4211c680a8c77ed4a.34.llvm.9036914972901821666+0xe0>
   13dfc:	vpbroadcastq -0xdf05(%rip),%xmm1        # 5f00 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.11.llvm.15448142832521594973+0x60>
   13e05:	data16 cs nopw 0x0(%rax,%rax,1)
   13e10:	mov    (%rsi,%rdi,8),%r10
   13e14:	vpbroadcastd %r10d,%xmm2
   13e1a:	shr    $0x20,%r10
   13e1e:	and    %r8d,%r10d
   13e21:	shl    $0x4,%r10
   13e25:	vmovdqa (%r9,%r10,1),%xmm3
   13e2b:	vpmulhw %xmm0,%xmm2,%xmm2
   13e2f:	vpshufb %xmm2,%xmm1,%xmm2
   13e34:	xor    %r10d,%r10d
   13e37:	vptest %xmm2,%xmm3
   13e3c:	setb   %r10b
   13e40:	mov    %r10d,(%rcx,%rdi,4)
   13e44:	mov    0x8(%rsi,%rdi,8),%r10
   13e49:	vpbroadcastd %r10d,%xmm2
   13e4f:	shr    $0x20,%r10
   13e53:	and    %r8d,%r10d
   13e56:	shl    $0x4,%r10
   13e5a:	vmovdqa (%r9,%r10,1),%xmm3
   13e60:	vpmulhw %xmm0,%xmm2,%xmm2
   13e64:	vpshufb %xmm2,%xmm1,%xmm2
   13e69:	xor    %r11d,%r11d
   13e6c:	vptest %xmm2,%xmm3
   13e71:	lea    0x2(%rdi),%r10
   13e75:	setb   %r11b
   13e79:	mov    %r11d,0x4(%rcx,%rdi,4)
   13e7e:	mov    %r10,%rdi
   13e81:	cmp    %r10,%rax
   13e84:	jne    13e10 <byte_inline_production_probe::byte_public_contains_loop+0x200>
   13e86:	test   $0x1,%dl
   13e89:	je     13eca <byte_inline_production_probe::byte_public_contains_loop+0x2ba>
   13e8b:	mov    (%rsi,%r10,8),%rax
   13e8f:	vpbroadcastd %eax,%xmm0
   13e95:	shr    $0x20,%rax
   13e99:	and    %eax,%r8d
   13e9c:	shl    $0x4,%r8
   13ea0:	vmovdqa (%r9,%r8,1),%xmm1
   13ea6:	vpmulhw -0xdd4e(%rip),%xmm0,%xmm0        # 6160 <anon.35274091df3394f4211c680a8c77ed4a.34.llvm.9036914972901821666+0xe0>
   13eae:	vpbroadcastq -0xdfb7(%rip),%xmm2        # 5f00 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.11.llvm.15448142832521594973+0x60>
   13eb7:	vpshufb %xmm0,%xmm2,%xmm0
   13ebc:	xor    %eax,%eax
   13ebe:	vptest %xmm0,%xmm1
   13ec3:	setb   %al
   13ec6:	mov    %eax,(%rcx,%r10,4)
   13eca:	add    $0x48,%rsp
   13ece:	pop    %rbx
   13ecf:	pop    %r12
   13ed1:	pop    %r13
   13ed3:	pop    %r14
   13ed5:	pop    %r15
   13ed7:	pop    %rbp
   13ed8:	vzeroupper
   13edb:	ret
   13edc:	movq   $0x0,0x18(%rsp)
   13ee5:	lea    0x42124(%rip),%r8        # 56010 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0x90>
   13eec:	lea    0x8(%rsp),%rsi
   13ef1:	lea    0x10(%rsp),%rdx
   13ef6:	lea    0x18(%rsp),%rcx
   13efb:	xor    %edi,%edi
   13efd:	call   *0x445ed(%rip)        # 584f0 <_DYNAMIC+0x2c8>
   13f03:	lea    0x4219e(%rip),%rdx        # 560a8 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0x128>
   13f0a:	mov    %rax,%rsi
   13f0d:	vzeroupper
   13f10:	call   *0x44562(%rip)        # 58478 <_DYNAMIC+0x250>
   13f16:	int3
   13f17:	int3
   13f18:	int3
   13f19:	int3
   13f1a:	int3
   13f1b:	int3
   13f1c:	int3
   13f1d:	int3
   13f1e:	int3
   13f1f:	int3

