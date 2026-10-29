   56cec:	call   *0x17f40e(%rip)        # 1d6100 <_DYNAMIC+0x300>
   56cf2:	mov    %rax,%r13
   56cf5:	mov    %edx,%ebp
   56cf7:	lea    0x2a0(%rsp),%rdi
   56cff:	mov    0x28(%rsp),%rsi
   56d04:	mov    0x6c(%rsp),%edx
   56d08:	call   17a680 <<compare_benchmark::PoppyPublic<44> as compare_benchmark::Filter>::new>
   56d0d:	movabs $0x8000000000000000,%rax
   56d17:	cmp    %rax,0x2a0(%rsp)
   56d1f:	je     5a2c6 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x4266>
   56d25:	mov    %ebp,0x20(%rsp)
   56d29:	mov    %r13,0x58(%rsp)
   56d2e:	mov    %rbx,0xe8(%rsp)
   56d36:	vmovdqu 0x2a0(%rsp),%ymm0
   56d3f:	vmovdqu 0x2c0(%rsp),%ymm1
   56d48:	vmovdqu 0x2e0(%rsp),%ymm2
   56d51:	vmovdqu 0x300(%rsp),%ymm3
   56d5a:	vmovdqu %ymm3,0x260(%rsp)
   56d63:	vmovdqu %ymm2,0x240(%rsp)
   56d6c:	vmovdqu %ymm1,0x220(%rsp)
   56d75:	vmovdqu %ymm0,0x200(%rsp)
   56d7e:	vzeroupper
   56d81:	call   *0x17f379(%rip)        # 1d6100 <_DYNAMIC+0x300>
   56d87:	mov    %rax,0x40(%rsp)
   56d8c:	mov    %edx,0x38(%rsp)
   56d90:	mov    0xf8(%rsp),%rbx
   56d98:	mov    0x118(%rsp),%r13
   56da0:	jmp    56dca <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0xd6a>
   56da2:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   56db0:	lea    (%rbx,%rdx,8),%rbx
   56db4:	sub    %rdx,%r13
   56db7:	lea    0x200(%rsp),%rdi
   56dbf:	mov    %r15,%rsi
   56dc2:	vzeroupper
   56dc5:	call   fcbe0 <compare_benchmark::insert::<compare_benchmark::PoppyPublic<0>>>
   56dca:	test   %r13,%r13
   56dcd:	je     56fa0 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0xf40>
   56dd3:	cmp    %r13,%r14
   56dd6:	mov    %r13,%rdx
   56dd9:	cmovb  %r14,%rdx
   56ddd:	cmp    $0x4,%rdx
   56de1:	jae    56df0 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0xd90>
   56de3:	xor    %eax,%eax
   56de5:	jmp    56f60 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0xf00>
   56dea:	nopw   0x0(%rax,%rax,1)
   56df0:	cmp    $0x10,%rdx
   56df4:	jae    56e00 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0xda0>
   56df6:	xor    %eax,%eax
   56df8:	jmp    56f09 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0xea9>
   56dfd:	nopl   (%rax)
   56e00:	mov    %rdx,%rax
   56e03:	and    $0xfffffffffffffff0,%rax
   56e07:	xor    %ecx,%ecx
   56e09:	vpbroadcastq -0x4d5ca(%rip),%ymm8        # 9848 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x225>
   56e12:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   56e20:	vmovdqu (%rbx,%rcx,8),%ymm0
   56e25:	vmovdqu 0x20(%rbx,%rcx,8),%ymm1
   56e2b:	vmovdqu 0x40(%rbx,%rcx,8),%ymm2
   56e31:	vmovdqu 0x60(%rbx,%rcx,8),%ymm3
   56e37:	vpsrlq $0x20,%ymm0,%ymm4
   56e3c:	vpsrlq $0x20,%ymm1,%ymm5
   56e41:	vpsrlq $0x20,%ymm2,%ymm6
   56e46:	vpsrlq $0x20,%ymm3,%ymm7
   56e4b:	vpxor  %ymm0,%ymm4,%ymm0
   56e4f:	vpxor  %ymm1,%ymm5,%ymm1
   56e53:	vpxor  %ymm2,%ymm6,%ymm2
   56e57:	vpmullq %ymm8,%ymm0,%ymm0
   56e5d:	vpmullq %ymm8,%ymm1,%ymm1
   56e63:	vpmullq %ymm8,%ymm2,%ymm2
   56e69:	vpxor  %ymm3,%ymm7,%ymm3
   56e6d:	vpmullq %ymm8,%ymm3,%ymm3
   56e73:	vpsrlq $0x20,%ymm0,%ymm4
   56e78:	vpsrlq $0x20,%ymm1,%ymm5
   56e7d:	vpsrlq $0x20,%ymm2,%ymm6
   56e82:	vpsrlq $0x20,%ymm3,%ymm7
   56e87:	vpxor  %ymm0,%ymm4,%ymm0
   56e8b:	vpxor  %ymm1,%ymm5,%ymm1
   56e8f:	vpxor  %ymm2,%ymm6,%ymm2
   56e93:	vpxor  %ymm3,%ymm7,%ymm3
   56e97:	vpmullq %ymm8,%ymm0,%ymm0
   56e9d:	vpmullq %ymm8,%ymm1,%ymm1
   56ea3:	vpmullq %ymm8,%ymm2,%ymm2
   56ea9:	vpmullq %ymm8,%ymm3,%ymm3
   56eaf:	vpsrlq $0x20,%ymm0,%ymm4
   56eb4:	vpsrlq $0x20,%ymm1,%ymm5
   56eb9:	vpsrlq $0x20,%ymm2,%ymm6
   56ebe:	vpsrlq $0x20,%ymm3,%ymm7
   56ec3:	vpxor  %ymm0,%ymm4,%ymm0
   56ec7:	vpxor  %ymm1,%ymm5,%ymm1
   56ecb:	vpxor  %ymm2,%ymm6,%ymm2
   56ecf:	vpxor  %ymm3,%ymm7,%ymm3
   56ed3:	vmovdqu %ymm0,(%r15,%rcx,8)
   56ed9:	vmovdqu %ymm1,0x20(%r15,%rcx,8)
   56ee0:	vmovdqu %ymm2,0x40(%r15,%rcx,8)
   56ee7:	vmovdqu %ymm3,0x60(%r15,%rcx,8)
   56eee:	add    $0x10,%rcx
   56ef2:	cmp    %rcx,%rax
   56ef5:	jne    56e20 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0xdc0>
   56efb:	cmp    %rax,%rdx
   56efe:	je     56db0 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0xd50>
   56f04:	test   $0xc,%dl
   56f07:	je     56f60 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0xf00>
   56f09:	mov    %rax,%rcx
   56f0c:	mov    %rdx,%rax
   56f0f:	and    $0xfffffffffffffffc,%rax
   56f13:	vpbroadcastq -0x4d6d4(%rip),%ymm2        # 9848 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x225>
   56f1c:	nopl   0x0(%rax)
   56f20:	vmovdqu (%rbx,%rcx,8),%ymm0
   56f25:	vpsrlq $0x20,%ymm0,%ymm1
   56f2a:	vpxor  %ymm0,%ymm1,%ymm0
   56f2e:	vpmullq %ymm2,%ymm0,%ymm0
   56f34:	vpsrlq $0x20,%ymm0,%ymm1
   56f39:	vpxor  %ymm0,%ymm1,%ymm0
   56f3d:	vpmullq %ymm2,%ymm0,%ymm0
   56f43:	vpsrlq $0x20,%ymm0,%ymm1
   56f48:	vpxor  %ymm0,%ymm1,%ymm0
   56f4c:	vmovdqu %ymm0,(%r15,%rcx,8)
   56f52:	add    $0x4,%rcx
   56f56:	cmp    %rcx,%rax
   56f59:	jne    56f20 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0xec0>
   56f5b:	jmp    56f91 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0xf31>
   56f5d:	nopl   (%rax)
   56f60:	mov    (%rbx,%rax,8),%rcx
   56f64:	mov    %rcx,%rsi
   56f67:	shr    $0x20,%rsi
   56f6b:	xor    %rcx,%rsi
   56f6e:	imul   %r12,%rsi
   56f72:	mov    %rsi,%rcx
   56f75:	shr    $0x20,%rcx
   56f79:	xor    %rsi,%rcx
   56f7c:	imul   %r12,%rcx
   56f80:	mov    %rcx,%rsi
   56f83:	shr    $0x20,%rsi
   56f87:	xor    %rcx,%rsi
   56f8a:	mov    %rsi,(%r15,%rax,8)
   56f8e:	inc    %rax
   56f91:	cmp    %rax,%rdx
   56f94:	jne    56f60 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0xf00>
   56f96:	jmp    56db0 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0xd50>
   56f9b:	nopl   0x0(%rax,%rax,1)
   56fa0:	call   *0x17f15a(%rip)        # 1d6100 <_DYNAMIC+0x300>
   56fa6:	mov    %rax,%rbp
   56fa9:	mov    %edx,%r13d
   56fac:	mov    %rax,0x70(%rsp)
   56fb1:	mov    %edx,0x78(%rsp)
   56fb5:	mov    0x40(%rsp),%rax
   56fba:	mov    %rax,0x130(%rsp)
   56fc2:	mov    0x38(%rsp),%eax
   56fc6:	mov    %eax,0x138(%rsp)
   56fcd:	lea    0x2a0(%rsp),%rdi
   56fd5:	lea    0x70(%rsp),%rsi
   56fda:	lea    0x130(%rsp),%rdx
   56fe2:	call   1ad410 <std::sys::pal::unix::time::Timespec::sub_timespec>
   56fe7:	kmovb  0x2a0(%rsp),%k1
   56ff0:	kmovd  %k1,0x40(%rsp)
   56ff7:	vcvtusi2sdq 0x2a8(%rsp),%xmm15,%xmm0
   56fff:	vmovsd %xmm0,0x38(%rsp)
   57005:	vcvtsi2sdl 0x2b0(%rsp),%xmm15,%xmm0
   5700e:	vmovsd %xmm0,0x120(%rsp)
   57017:	mov    0x1e0(%rsp),%rbx
   5701f:	cmp    0x1d0(%rsp),%rbx
   57027:	jne    57037 <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0xfd7>
   57029:	lea    0x1d0(%rsp),%rdi
   57031:	call   *0x17f0d1(%rip)        # 1d6108 <_DYNAMIC+0x308>
   57037:	vmovsd -0x4d7d7(%rip),%xmm1        # 9868 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x245>
   5703f:	vmovsd 0x120(%rsp),%xmm0
   57048:	vdivsd %xmm1,%xmm0,%xmm0
   5704c:	vaddsd 0x38(%rsp),%xmm0,%xmm0
   57052:	vmulsd %xmm1,%xmm0,%xmm0
   57056:	vxorpd %xmm1,%xmm1,%xmm1
   5705a:	kmovd  0x40(%rsp),%k1
   57061:	vmovsd %xmm1,%xmm0,%xmm0{%k1}
   57067:	vdivsd 0x30(%rsp),%xmm0,%xmm0
   5706d:	mov    0x1d8(%rsp),%rax
   57075:	vmovsd %xmm0,(%rax,%rbx,8)
   5707a:	inc    %rbx
   5707d:	mov    %rbx,0x1e0(%rsp)
   57085:	mov    %rbp,0x70(%rsp)
   5708a:	mov    %r13d,0x78(%rsp)
   5708f:	mov    0x58(%rsp),%rax
   57094:	mov    %rax,0x130(%rsp)
   5709c:	mov    0x20(%rsp),%eax
   570a0:	mov    %eax,0x138(%rsp)
   570a7:	lea    0x2a0(%rsp),%rdi
   570af:	lea    0x70(%rsp),%rsi
   570b4:	lea    0x130(%rsp),%rdx
   570bc:	call   1ad410 <std::sys::pal::unix::time::Timespec::sub_timespec>
   570c1:	kmovb  0x2a0(%rsp),%k1
   570ca:	kmovd  %k1,0x40(%rsp)
   570d1:	vcvtusi2sdq 0x2a8(%rsp),%xmm15,%xmm0
   570d9:	vmovsd %xmm0,0x38(%rsp)
   570df:	vcvtsi2sdl 0x2b0(%rsp),%xmm15,%xmm0
   570e8:	vmovsd %xmm0,0x58(%rsp)
   570ee:	mov    0x1f8(%rsp),%rbx
   570f6:	cmp    0x1e8(%rsp),%rbx
   570fe:	jne    5710e <compare_benchmark::run::<compare_benchmark::PoppyPublic<44>>+0x10ae>
   57100:	lea    0x1e8(%rsp),%rdi
   57108:	call   *0x17effa(%rip)        # 1d6108 <_DYNAMIC+0x308>
   5710e:	vmovsd -0x4d8ae(%rip),%xmm1        # 9868 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x245>
   57116:	vmovsd 0x58(%rsp),%xmm0
   5711c:	vdivsd %xmm1,%xmm0,%xmm0
   57120:	vaddsd 0x38(%rsp),%xmm0,%xmm0
   57126:	vmulsd %xmm1,%xmm0,%xmm0
   5712a:	vxorpd %xmm1,%xmm1,%xmm1
   5712e:	kmovd  0x40(%rsp),%k1
   57135:	vmovsd %xmm1,%xmm0,%xmm0{%k1}
   5713b:	vdivsd 0x30(%rsp),%xmm0,%xmm0
   57141:	mov    0x1f0(%rsp),%rax
   57149:	vmovsd %xmm0,(%rax,%rbx,8)
   5714e:	inc    %rbx
   57151:	mov    %rbx,0x1f8(%rsp)
   57159:	mov    0x28(%rsp),%rcx
   5715e:	mov    %rcx,%rdi
   57161:	mov    0x10(%rsp),%rsi
   57166:	mov    0x50(%rsp),%rdx
   5716b:	lea    0x200(%rsp),%r8
   57173:	mov    0x18(%rsp),%r9
   57178:	push   0xe8(%rsp)
   5717f:	push   0x50(%rsp)
   57183:	call   101c80 <compare_benchmark::run::<compare_benchmark::PoppyPublic<0>>::{closure#0}>
   57188:	add    $0x10,%rsp
   5718c:	cmpq   $0x0,0x200(%rsp)
