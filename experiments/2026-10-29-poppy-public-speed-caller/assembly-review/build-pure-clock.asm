   569b0:	cmp    %rcx,%rdx
   569b3:	mov    %rdx,%rax
   569b6:	adc    $0x0,%rax
   569ba:	movl   $0x0,0x40(%rsp)
   569c2:	cmp    %rcx,%rdx
   569c5:	mov    %rax,0xc8(%rsp)
   569cd:	jae    571e5 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x1185>
   569d3:	vzeroupper
   569d6:	call   *0x17f724(%rip)        # 1d6100 <_DYNAMIC+0x300>
   569dc:	mov    %rax,%rbx
   569df:	mov    %edx,%ebp
   569e1:	lea    0x2a0(%rsp),%rdi
   569e9:	mov    0x28(%rsp),%rsi
   569ee:	mov    0x6c(%rsp),%edx
   569f2:	call   17a680 <<compare_benchmark::PoppyPublic<44> as compare_benchmark::Filter>::new>
   569f7:	movabs $0x8000000000000000,%rax
   56a01:	cmp    %rax,0x2a0(%rsp)
   56a09:	je     5a583 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x4523>
   56a0f:	mov    %ebp,0xe8(%rsp)
   56a16:	mov    %rbx,0x20(%rsp)
   56a1b:	vmovupd 0x2a0(%rsp),%ymm0
   56a24:	vmovupd 0x2c0(%rsp),%ymm1
   56a2d:	vmovdqu 0x2e0(%rsp),%ymm2
   56a36:	vmovdqu 0x300(%rsp),%ymm3
   56a3f:	vmovdqu %ymm3,0x260(%rsp)
   56a48:	vmovdqu %ymm2,0x240(%rsp)
   56a51:	vmovupd %ymm1,0x220(%rsp)
   56a5a:	vmovupd %ymm0,0x200(%rsp)
   56a63:	vzeroupper
   56a66:	call   *0x17f694(%rip)        # 1d6100 <_DYNAMIC+0x300>
   56a6c:	mov    %rax,0x38(%rsp)
   56a71:	mov    %edx,0x58(%rsp)
   56a75:	mov    0x28(%rsp),%rbx
   56a7a:	mov    0x50(%rsp),%rsi
   56a7f:	nop
   56a80:	test   %rbx,%rbx
   56a83:	je     56ab0 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0xa50>
   56a85:	cmp    %rbx,%r14
   56a88:	mov    %rbx,%rdx
   56a8b:	cmovb  %r14,%rdx
   56a8f:	lea    (%rsi,%rdx,8),%r13
   56a93:	sub    %rdx,%rbx
   56a96:	lea    0x200(%rsp),%rdi
   56a9e:	call   fcbe0 <compare_benchmark::insert::<compare_benchmark::PoppyPublic<0>>>
   56aa3:	mov    %r13,%rsi
   56aa6:	jmp    56a80 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0xa20>
   56aa8:	nopl   0x0(%rax,%rax,1)
   56ab0:	call   *0x17f64a(%rip)        # 1d6100 <_DYNAMIC+0x300>
   56ab6:	mov    %rax,%rbp
   56ab9:	mov    %edx,%r13d
   56abc:	mov    %rax,0x70(%rsp)
   56ac1:	mov    %edx,0x78(%rsp)
   56ac5:	mov    0x38(%rsp),%rax
   56aca:	mov    %rax,0x130(%rsp)
   56ad2:	mov    0x58(%rsp),%eax
   56ad6:	mov    %eax,0x138(%rsp)
   56add:	lea    0x2a0(%rsp),%rdi
   56ae5:	lea    0x70(%rsp),%rsi
   56aea:	lea    0x130(%rsp),%rdx
   56af2:	call   1ad410 <std::sys::pal::unix::time::Timespec::sub_timespec>
   56af7:	kmovb  0x2a0(%rsp),%k1
   56b00:	kmovd  %k1,0x38(%rsp)
   56b07:	vcvtusi2sdq 0x2a8(%rsp),%xmm15,%xmm0
   56b0f:	vmovsd %xmm0,0x58(%rsp)
   56b15:	vcvtsi2sdl 0x2b0(%rsp),%xmm15,%xmm0
   56b1e:	vmovsd %xmm0,0x120(%rsp)
   56b27:	mov    0x1b0(%rsp),%rbx
   56b2f:	cmp    0x1a0(%rsp),%rbx
   56b37:	jne    56b47 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0xae7>
   56b39:	lea    0x1a0(%rsp),%rdi
   56b41:	call   *0x17f5c1(%rip)        # 1d6108 <_DYNAMIC+0x308>
   56b47:	vmovsd -0x4d2e7(%rip),%xmm1        # 9868 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x245>
   56b4f:	vmovsd 0x120(%rsp),%xmm0
   56b58:	vdivsd %xmm1,%xmm0,%xmm0
   56b5c:	vaddsd 0x58(%rsp),%xmm0,%xmm0
   56b62:	vmulsd %xmm1,%xmm0,%xmm0
   56b66:	vxorpd %xmm1,%xmm1,%xmm1
   56b6a:	kmovd  0x38(%rsp),%k1
   56b71:	vmovsd %xmm1,%xmm0,%xmm0{%k1}
   56b77:	vdivsd 0x30(%rsp),%xmm0,%xmm0
   56b7d:	mov    0x1a8(%rsp),%rax
   56b85:	vmovsd %xmm0,(%rax,%rbx,8)
   56b8a:	inc    %rbx
   56b8d:	mov    %rbx,0x1b0(%rsp)
   56b95:	mov    %rbp,0x70(%rsp)
   56b9a:	mov    %r13d,0x78(%rsp)
   56b9f:	mov    0x20(%rsp),%rax
   56ba4:	mov    %rax,0x130(%rsp)
   56bac:	mov    0xe8(%rsp),%eax
   56bb3:	mov    %eax,0x138(%rsp)
   56bba:	lea    0x2a0(%rsp),%rdi
   56bc2:	lea    0x70(%rsp),%rsi
   56bc7:	lea    0x130(%rsp),%rdx
   56bcf:	call   1ad410 <std::sys::pal::unix::time::Timespec::sub_timespec>
   56bd4:	kmovb  0x2a0(%rsp),%k1
   56bdd:	kmovd  %k1,0x38(%rsp)
   56be4:	vcvtusi2sdq 0x2a8(%rsp),%xmm15,%xmm0
   56bec:	vmovsd %xmm0,0x58(%rsp)
   56bf2:	vcvtsi2sdl 0x2b0(%rsp),%xmm15,%xmm0
   56bfb:	vmovsd %xmm0,0x20(%rsp)
   56c01:	mov    0x1c8(%rsp),%rbx
   56c09:	cmp    0x1b8(%rsp),%rbx
   56c11:	jne    56c21 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0xbc1>
   56c13:	lea    0x1b8(%rsp),%rdi
   56c1b:	call   *0x17f4e7(%rip)        # 1d6108 <_DYNAMIC+0x308>
   56c21:	vmovsd -0x4d3c1(%rip),%xmm1        # 9868 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x245>
   56c29:	vmovsd 0x20(%rsp),%xmm0
   56c2f:	vdivsd %xmm1,%xmm0,%xmm0
   56c33:	vaddsd 0x58(%rsp),%xmm0,%xmm0
   56c39:	vmulsd %xmm1,%xmm0,%xmm0
   56c3d:	vxorpd %xmm1,%xmm1,%xmm1
   56c41:	kmovd  0x38(%rsp),%k1
   56c48:	vmovsd %xmm1,%xmm0,%xmm0{%k1}
   56c4e:	vdivsd 0x30(%rsp),%xmm0,%xmm0
   56c54:	mov    0x1c0(%rsp),%rax
   56c5c:	vmovsd %xmm0,(%rax,%rbx,8)
   56c61:	inc    %rbx
   56c64:	mov    %rbx,0x1c8(%rsp)
   56c6c:	movzbl 0x40(%rsp),%ebx
   56c71:	and    $0x1,%ebx
   56c74:	mov    0x28(%rsp),%rcx
   56c79:	mov    %rcx,%rdi
   56c7c:	mov    0x10(%rsp),%rsi
   56c81:	mov    0x50(%rsp),%rdx
   56c86:	lea    0x200(%rsp),%r8
   56c8e:	mov    0x18(%rsp),%r9
   56c93:	push   %rbx
   56c94:	push   0x50(%rsp)
   56c98:	call   101c80 <compare_benchmark::run::<compare_benchmark::PoppyPublic<0>>::{closure#0}>
   56c9d:	add    $0x10,%rsp
   56ca1:	cmpq   $0x0,0x200(%rsp)
   56caa:	je     56cba <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0xc5a>
   56cac:	mov    0x208(%rsp),%rdi
   56cb4:	call   *0x17f34e(%rip)        # 1d6008 <free@GLIBC_2.2.5>
   56cba:	cmpq   $0x0,0x218(%rsp)
