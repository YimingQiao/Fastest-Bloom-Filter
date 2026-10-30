   578c1:	mov    0x38(%rsp),%rcx
   578c6:	lea    0x8(%rcx),%rax
   578ca:	cmp    $0x20,%rcx
   578ce:	je     57870 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1810>
   578d0:	mov    0x58(%rsp),%rdx
   578d5:	mov    (%rdx,%rcx,1),%rcx
   578d9:	mov    %rcx,0xc8(%rsp)
   578e1:	mov    %rax,0x38(%rsp)
   578e6:	vzeroupper
   578e9:	call   *0x17e811(%rip)        # 1d6100 <_DYNAMIC+0x300>
   578ef:	mov    %rax,0x2a0(%rsp)
   578f7:	mov    %edx,0x2a8(%rsp)
   578fe:	mov    0xc8(%rsp),%rdx
   57906:	cmp    $0x3,%rdx
   5790a:	ja     5a287 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x4227>
   57910:	lea    -0x4d5ab(%rip),%rcx        # a36c <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x13c>
   57917:	movslq (%rcx,%rdx,4),%rax
   5791b:	add    %rcx,%rax
   5791e:	jmp    *%rax
   57920:	cmpq   $0x0,0x8(%rsp)
   57926:	je     57a01 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x19a1>
   5792c:	cmpq   $0x0,0x118(%rsp)
   57935:	je     57a2a <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x19ca>
   5793b:	mov    0x8(%rsp),%rax
   57940:	xor    %edx,%edx
   57942:	divq   0x10(%rsp)
   57947:	mov    %rax,%r13
   5794a:	jmp    57a38 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x19d8>
   5794f:	nop
   57950:	lea    0x200(%rsp),%rdi
   57958:	mov    0xa8(%rsp),%rsi
   57960:	mov    0x8(%rsp),%rdx
   57965:	mov    0x18(%rsp),%rcx
   5796a:	mov    %rdx,%r8
   5796d:	call   34430 <compare_benchmark::visible_lookup::<compare_benchmark::PoppyPublic<0>, false>>
   57972:	jmp    57d49 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1ce9>
   57977:	nopw   0x0(%rax,%rax,1)
   57980:	lea    0x200(%rsp),%rdi
   57988:	mov    0xc0(%rsp),%rsi
   57990:	mov    0x60(%rsp),%rdx
   57995:	mov    0x18(%rsp),%rcx
   5799a:	mov    0x8(%rsp),%r8
   5799f:	call   344f0 <compare_benchmark::visible_lookup::<compare_benchmark::PoppyPublic<0>, true>>
   579a4:	jmp    57d49 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1ce9>
   579a9:	nopl   0x0(%rax)
   579b0:	mov    0x60(%rsp),%rbx
   579b5:	mov    %rbx,%rax
   579b8:	mov    0x10(%rsp),%rcx
   579bd:	or     %rcx,%rax
   579c0:	shr    $0x20,%rax
   579c4:	je     57a0b <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x19ab>
   579c6:	mov    %rbx,%rax
   579c9:	xor    %edx,%edx
   579cb:	div    %rcx
   579ce:	mov    %rax,%rcx
   579d1:	cmp    $0x1,%rdx
   579d5:	sbb    $0xffffffffffffffff,%rcx
   579d9:	cmpq   $0x0,0x8(%rsp)
   579df:	je     57a23 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x19c3>
   579e1:	cmpq   $0x0,0x118(%rsp)
   579ea:	je     57aa5 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1a45>
   579f0:	mov    0x8(%rsp),%rax
   579f5:	xor    %edx,%edx
   579f7:	divq   0x10(%rsp)
   579fc:	jmp    57ab0 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1a50>
   57a01:	xor    %r13d,%r13d
   57a04:	mov    0x18(%rsp),%rcx
   57a09:	jmp    57a45 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x19e5>
   57a0b:	mov    %ebx,%eax
   57a0d:	xor    %edx,%edx
   57a0f:	div    %ecx
   57a11:	mov    %eax,%ecx
   57a13:	cmp    $0x1,%rdx
   57a17:	sbb    $0xffffffffffffffff,%rcx
   57a1b:	cmpq   $0x0,0x8(%rsp)
   57a21:	jne    579e1 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1981>
   57a23:	xor    %eax,%eax
   57a25:	jmp    57ab8 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1a58>
   57a2a:	mov    0x8(%rsp),%rax
   57a2f:	xor    %edx,%edx
   57a31:	divl   0x10(%rsp)
   57a35:	mov    %eax,%r13d
   57a38:	mov    0x18(%rsp),%rcx
   57a3d:	cmp    $0x1,%rdx
   57a41:	sbb    $0xffffffffffffffff,%r13
   57a45:	inc    %r13
   57a48:	mov    0x8(%rsp),%rdx
   57a4d:	mov    0xa8(%rsp),%rsi
   57a55:	data16 cs nopw 0x0(%rax,%rax,1)
   57a60:	dec    %r13
   57a63:	mov    0x10(%rsp),%rax
   57a68:	je     57d30 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1cd0>
   57a6e:	mov    0x40(%rsp),%rdi
   57a73:	lea    (%rcx,%rdi,1),%rbx
   57a77:	mov    0x30(%rsp),%rdi
   57a7c:	lea    (%rsi,%rdi,1),%r14
   57a80:	mov    %rdx,%rbp
   57a83:	sub    %rax,%rbp
   57a86:	cmova  %rax,%rdx
   57a8a:	lea    0x200(%rsp),%rdi
   57a92:	mov    %rdx,%r8
   57a95:	call   fdb50 <compare_benchmark::lookup::<compare_benchmark::PoppyPublic<0>>>
   57a9a:	mov    %rbp,%rdx
   57a9d:	mov    %r14,%rsi
   57aa0:	mov    %rbx,%rcx
   57aa3:	jmp    57a60 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1a00>
   57aa5:	mov    0x8(%rsp),%rax
   57aaa:	xor    %edx,%edx
   57aac:	divl   0x10(%rsp)
   57ab0:	cmp    $0x1,%rdx
   57ab4:	sbb    $0xffffffffffffffff,%rax
   57ab8:	cmp    %rcx,%rax
   57abb:	cmovb  %rax,%rcx
   57abf:	mov    0xc0(%rsp),%r14
   57ac7:	mov    0x198(%rsp),%rbp
   57acf:	xor    %r13d,%r13d
   57ad2:	mov    0x10(%rsp),%r12
   57ad7:	jmp    57b15 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1ab5>
   57ad9:	nopl   0x0(%rax)
   57ae0:	inc    %r13
   57ae3:	mov    0x18(%rsp),%rax
   57ae8:	lea    (%rax,%rcx,4),%rcx
   57aec:	mov    0x10(%rsp),%r12
   57af1:	sub    %r12,%rbx
   57af4:	mov    0x30(%rsp),%rax
   57af9:	add    %rax,%rbp
   57afc:	add    %rax,%r14
   57aff:	lea    0x200(%rsp),%rdi
   57b07:	mov    %r11,%rsi
   57b0a:	vzeroupper
   57b0d:	call   fdb50 <compare_benchmark::lookup::<compare_benchmark::PoppyPublic<0>>>
   57b12:	mov    %r15,%rcx
   57b15:	cmp    %rbx,%r12
   57b18:	mov    %rbx,%rax
   57b1b:	cmovb  %r12,%rax
   57b1f:	cmp    %rcx,%r13
   57b22:	mov    0x48(%rsp),%r15
   57b27:	je     57d30 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1cd0>
   57b2d:	mov    %r15,%r11
   57b30:	mov    %rcx,%r15
   57b33:	mov    %r13,%rcx
   57b36:	imul   %r12,%rcx
   57b3a:	mov    0x60(%rsp),%rdx
   57b3f:	sub    %rcx,%rdx
   57b42:	cmp    %rdx,%r12
   57b45:	cmovb  %r12,%rdx
   57b49:	mov    0x8(%rsp),%r8
   57b4e:	sub    %rcx,%r8
   57b51:	cmp    %r8,%r12
   57b54:	cmovb  %r12,%r8
   57b58:	test   %rdx,%rdx
   57b5b:	movabs $0xd6e8feb86659fd93,%r10
   57b65:	je     57ae0 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1a80>
   57b6b:	cmp    $0x4,%rax
   57b6f:	jae    57b80 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1b20>
   57b71:	xor    %esi,%esi
   57b73:	mov    0x48(%rsp),%r11
   57b78:	jmp    57cf0 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1c90>
   57b7d:	nopl   (%rax)
   57b80:	cmp    $0x10,%rax
   57b84:	jae    57b92 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1b32>
   57b86:	xor    %esi,%esi
   57b88:	mov    0x48(%rsp),%r11
   57b8d:	jmp    57c99 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1c39>
   57b92:	mov    %rax,%rsi
   57b95:	and    $0xfffffffffffffff0,%rsi
   57b99:	xor    %edi,%edi
   57b9b:	vpbroadcastq -0x4e35c(%rip),%ymm8        # 9848 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x225>
   57ba4:	mov    0x48(%rsp),%r11
   57ba9:	nopl   0x0(%rax)
   57bb0:	vmovdqu -0x60(%rbp,%rdi,8),%ymm0
   57bb6:	vmovdqu -0x40(%rbp,%rdi,8),%ymm1
   57bbc:	vmovdqu -0x20(%rbp,%rdi,8),%ymm2
   57bc2:	vmovdqu 0x0(%rbp,%rdi,8),%ymm3
   57bc8:	vpsrlq $0x20,%ymm0,%ymm4
   57bcd:	vpsrlq $0x20,%ymm1,%ymm5
   57bd2:	vpsrlq $0x20,%ymm2,%ymm6
   57bd7:	vpsrlq $0x20,%ymm3,%ymm7
   57bdc:	vpxor  %ymm0,%ymm4,%ymm0
   57be0:	vpxor  %ymm1,%ymm5,%ymm1
   57be4:	vpxor  %ymm2,%ymm6,%ymm2
   57be8:	vpmullq %ymm8,%ymm0,%ymm0
   57bee:	vpmullq %ymm8,%ymm1,%ymm1
   57bf4:	vpmullq %ymm8,%ymm2,%ymm2
   57bfa:	vpxor  %ymm3,%ymm7,%ymm3
   57bfe:	vpmullq %ymm8,%ymm3,%ymm3
   57c04:	vpsrlq $0x20,%ymm0,%ymm4
   57c09:	vpsrlq $0x20,%ymm1,%ymm5
   57c0e:	vpsrlq $0x20,%ymm2,%ymm6
   57c13:	vpsrlq $0x20,%ymm3,%ymm7
   57c18:	vpxor  %ymm0,%ymm4,%ymm0
   57c1c:	vpxor  %ymm1,%ymm5,%ymm1
   57c20:	vpxor  %ymm2,%ymm6,%ymm2
   57c24:	vpxor  %ymm3,%ymm7,%ymm3
   57c28:	vpmullq %ymm8,%ymm0,%ymm0
   57c2e:	vpmullq %ymm8,%ymm1,%ymm1
   57c34:	vpmullq %ymm8,%ymm2,%ymm2
   57c3a:	vpmullq %ymm8,%ymm3,%ymm3
   57c40:	vpsrlq $0x20,%ymm0,%ymm4
   57c45:	vpsrlq $0x20,%ymm1,%ymm5
   57c4a:	vpsrlq $0x20,%ymm2,%ymm6
   57c4f:	vpsrlq $0x20,%ymm3,%ymm7
   57c54:	vpxor  %ymm0,%ymm4,%ymm0
   57c58:	vpxor  %ymm1,%ymm5,%ymm1
   57c5c:	vpxor  %ymm2,%ymm6,%ymm2
   57c60:	vpxor  %ymm3,%ymm7,%ymm3
   57c64:	vmovdqu %ymm0,(%r11,%rdi,8)
   57c6a:	vmovdqu %ymm1,0x20(%r11,%rdi,8)
   57c71:	vmovdqu %ymm2,0x40(%r11,%rdi,8)
   57c78:	vmovdqu %ymm3,0x60(%r11,%rdi,8)
   57c7f:	add    $0x10,%rdi
   57c83:	cmp    %rdi,%rsi
   57c86:	jne    57bb0 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1b50>
   57c8c:	cmp    %rsi,%rax
   57c8f:	je     57ae0 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1a80>
   57c95:	test   $0xc,%al
   57c97:	je     57cf0 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1c90>
   57c99:	mov    %rsi,%rdi
   57c9c:	mov    %rax,%rsi
   57c9f:	and    $0xfffffffffffffffc,%rsi
   57ca3:	vpbroadcastq -0x4e464(%rip),%ymm2        # 9848 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x225>
   57cac:	nopl   0x0(%rax)
   57cb0:	vmovdqu (%r14,%rdi,8),%ymm0
   57cb6:	vpsrlq $0x20,%ymm0,%ymm1
   57cbb:	vpxor  %ymm0,%ymm1,%ymm0
   57cbf:	vpmullq %ymm2,%ymm0,%ymm0
   57cc5:	vpsrlq $0x20,%ymm0,%ymm1
   57cca:	vpxor  %ymm0,%ymm1,%ymm0
   57cce:	vpmullq %ymm2,%ymm0,%ymm0
   57cd4:	vpsrlq $0x20,%ymm0,%ymm1
   57cd9:	vpxor  %ymm0,%ymm1,%ymm0
   57cdd:	vmovdqu %ymm0,(%r11,%rdi,8)
   57ce3:	add    $0x4,%rdi
   57ce7:	cmp    %rdi,%rsi
   57cea:	jne    57cb0 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1c50>
   57cec:	jmp    57d21 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1cc1>
   57cee:	xchg   %ax,%ax
   57cf0:	mov    (%r14,%rsi,8),%rdi
   57cf4:	mov    %rdi,%r9
   57cf7:	shr    $0x20,%r9
   57cfb:	xor    %rdi,%r9
   57cfe:	imul   %r10,%r9
   57d02:	mov    %r9,%rdi
   57d05:	shr    $0x20,%rdi
   57d09:	xor    %r9,%rdi
   57d0c:	imul   %r10,%rdi
   57d10:	mov    %rdi,%r9
   57d13:	shr    $0x20,%r9
   57d17:	xor    %rdi,%r9
   57d1a:	mov    %r9,(%r11,%rsi,8)
   57d1e:	inc    %rsi
   57d21:	cmp    %rsi,%rax
   57d24:	jne    57cf0 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1c90>
   57d26:	jmp    57ae0 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1a80>
   57d2b:	nopl   0x0(%rax,%rax,1)
   57d30:	cmpq   $0x4,0xc8(%rsp)
   57d39:	movabs $0xd6e8feb86659fd93,%r12
   57d43:	jae    5a5c2 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x4562>
   57d49:	lea    0x2a0(%rsp),%rdi
   57d51:	call   *0x17e3b9(%rip)        # 1d6110 <_DYNAMIC+0x310>
   57d57:	mov    %rax,%r14
   57d5a:	mov    %edx,%ebp
   57d5c:	mov    0xc8(%rsp),%rax
   57d64:	lea    (%rax,%rax,2),%rax
   57d68:	lea    0x130(%rsp,%rax,8),%r13
   57d70:	mov    0x140(%rsp,%rax,8),%rbx
   57d78:	cmp    0x130(%rsp,%rax,8),%rbx
   57d80:	jne    57d8b <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1d2b>
   57d82:	mov    %r13,%rdi
   57d85:	call   *0x17e37d(%rip)        # 1d6108 <_DYNAMIC+0x308>
   57d8b:	vcvtusi2sd %r14,%xmm15,%xmm0
   57d91:	vcvtsi2sd %ebp,%xmm15,%xmm1
   57d95:	vmovsd -0x4e535(%rip),%xmm2        # 9868 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x245>
   57d9d:	vdivsd %xmm2,%xmm1,%xmm1
   57da1:	vaddsd %xmm0,%xmm1,%xmm0
   57da5:	vmulsd %xmm2,%xmm0,%xmm0
   57da9:	vdivsd 0x120(%rsp),%xmm0,%xmm0
   57db2:	mov    0x8(%r13),%rax
   57db6:	vmovsd %xmm0,(%rax,%rbx,8)
   57dbb:	inc    %rbx
   57dbe:	mov    %rbx,0x10(%r13)
   57dc2:	mov    0x128(%rsp),%rax
   57dca:	mov    0xc8(%rsp),%rdx
   57dd2:	shl    $0x4,%rdx
   57dd6:	lea    0x1794bb(%rip),%rcx        # 1d1298 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.52.llvm.3671060894988460240+0x4a8>
   57ddd:	vmovupd (%rdx,%rcx,1),%xmm0
   57de2:	sub    $0x20,%rsp
   57de6:	vmovupd %xmm0,0x10(%rsp)
   57dec:	mov    %rax,0x8(%rsp)
   57df1:	movq   $0x10,(%rsp)
   57df9:	mov    0x38(%rsp),%rdi
   57dfe:	mov    0x28(%rsp),%rcx
   57e03:	mov    %rcx,%rsi
   57e06:	mov    0x40(%rsp),%rdx
   57e0b:	mov    0xd0(%rsp),%r8
   57e13:	mov    0x108(%rsp),%r9
   57e1b:	call   103e70 <compare_benchmark::verify_dense_output>
   57e20:	add    $0x20,%rsp
