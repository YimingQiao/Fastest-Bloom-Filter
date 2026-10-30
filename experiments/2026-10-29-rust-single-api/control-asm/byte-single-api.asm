
/tmp/fastest-bf-rust-single-api/release/compare_benchmark:     file format elf64-x86-64


Disassembly of section .text:

0000000000049940 <compare_benchmark::lookup>:
   49940:	48 83 ec 48          	sub    $0x48,%rsp
   49944:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
   49949:	4c 89 44 24 10       	mov    %r8,0x10(%rsp)
   4994e:	4c 39 c2             	cmp    %r8,%rdx
   49951:	0f 85 bc 01 00 00    	jne    49b13 <compare_benchmark::lookup+0x1d3>
   49957:	48 83 fa 01          	cmp    $0x1,%rdx
   4995b:	75 46                	jne    499a3 <compare_benchmark::lookup+0x63>
   4995d:	48 8b 16             	mov    (%rsi),%rdx
   49960:	48 89 d0             	mov    %rdx,%rax
   49963:	48 c1 e8 20          	shr    $0x20,%rax
   49967:	80 7f 1c 00          	cmpb   $0x0,0x1c(%rdi)
   4996b:	74 43                	je     499b0 <compare_benchmark::lookup+0x70>
   4996d:	23 47 18             	and    0x18(%rdi),%eax
   49970:	48 8b 77 08          	mov    0x8(%rdi),%rsi
   49974:	48 c1 e0 04          	shl    $0x4,%rax
   49978:	c5 f9 6f 04 06       	vmovdqa (%rsi,%rax,1),%xmm0
   4997d:	62 f2 7d 08 7c ca    	vpbroadcastd %edx,%xmm1
   49983:	c5 f1 e5 0d 15 ef fb 	vpmulhw -0x410eb(%rip),%xmm1,%xmm1        # 88a0 <anon.35274091df3394f4211c680a8c77ed4a.34.llvm.9036914972901821666+0x180>
   4998a:	ff 
   4998b:	c4 e2 79 59 15 74 e8 	vpbroadcastq -0x4178c(%rip),%xmm2        # 8208 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x25f>
   49992:	fb ff 
   49994:	c4 e2 69 00 c9       	vpshufb %xmm1,%xmm2,%xmm1
   49999:	c4 e2 79 17 c1       	vptest %xmm1,%xmm0
   4999e:	e9 60 01 00 00       	jmp    49b03 <compare_benchmark::lookup+0x1c3>
   499a3:	49 89 d0             	mov    %rdx,%r8
   499a6:	48 83 c4 48          	add    $0x48,%rsp
   499aa:	ff 25 28 48 05 00    	jmp    *0x54828(%rip)        # 9e1d8 <_DYNAMIC+0x3c0>
   499b0:	23 47 18             	and    0x18(%rdi),%eax
   499b3:	48 89 fe             	mov    %rdi,%rsi
   499b6:	89 c7                	mov    %eax,%edi
   499b8:	c1 ef 02             	shr    $0x2,%edi
   499bb:	49 89 f0             	mov    %rsi,%r8
   499be:	48 8b 76 10          	mov    0x10(%rsi),%rsi
   499c2:	48 39 f7             	cmp    %rsi,%rdi
   499c5:	0f 83 8e 01 00 00    	jae    49b59 <compare_benchmark::lookup+0x219>
   499cb:	48 c1 e7 06          	shl    $0x6,%rdi
   499cf:	49 03 78 08          	add    0x8(%r8),%rdi
   499d3:	c1 e0 04             	shl    $0x4,%eax
   499d6:	c5 f9 6e c2          	vmovd  %edx,%xmm0
   499da:	c1 e2 10             	shl    $0x10,%edx
   499dd:	c4 e3 79 22 c2 01    	vpinsrd $0x1,%edx,%xmm0,%xmm0
   499e3:	83 e0 30             	and    $0x30,%eax
   499e6:	c5 f9 72 e0 10       	vpsrad $0x10,%xmm0,%xmm0
   499eb:	c4 e2 7d 59 c8       	vpbroadcastq %xmm0,%ymm1
   499f0:	c5 f9 7e c6          	vmovd  %xmm0,%esi
   499f4:	c4 e3 79 16 c2 01    	vpextrd $0x1,%xmm0,%edx
   499fa:	85 d2                	test   %edx,%edx
   499fc:	0f 9f c2             	setg   %dl
   499ff:	41 0f 98 c0          	sets   %r8b
   49a03:	85 f6                	test   %esi,%esi
   49a05:	41 0f 98 c1          	sets   %r9b
   49a09:	c5 f5 f5 05 af e9 fb 	vpmaddwd -0x41651(%rip),%ymm1,%ymm0        # 83c0 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x130>
   49a10:	ff 
   49a11:	62 f1 fd 48 6f 0d a5 	vmovdqa64 -0x40c5b(%rip),%zmm1        # 8dc0 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x3b0>
   49a18:	f3 fb ff 
   49a1b:	62 f2 75 48 36 c0    	vpermd %zmm0,%zmm1,%zmm0
   49a21:	62 f2 7d 48 45 05 d5 	vpsrlvd -0x40c2b(%rip),%zmm0,%zmm0        # 8e00 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x3f0>
   49a28:	f3 fb ff 
   49a2b:	62 f2 7e 48 31 c0    	vpmovdb %zmm0,%xmm0
   49a31:	40 0f 9f c6          	setg   %sil
   49a35:	62 f1 7d 18 db 0d b9 	vpandd -0x41947(%rip){1to4},%xmm0,%xmm1        # 80f8 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x14f>
   49a3c:	e6 fb ff 
   49a3f:	c5 fa 7e 15 a9 ed fb 	vmovq  -0x41257(%rip),%xmm2        # 87f0 <anon.35274091df3394f4211c680a8c77ed4a.34.llvm.9036914972901821666+0xd0>
   49a46:	ff 
   49a47:	c5 e1 ef db          	vpxor  %xmm3,%xmm3,%xmm3
   49a4b:	66 41 ba fd ff       	mov    $0xfffd,%r10w
   49a50:	c4 c1 7b 92 ca       	kmovd  %r10d,%k1
   49a55:	62 f1 65 09 64 c0    	vpcmpgtb %xmm0,%xmm3,%k0{%k1}
   49a5b:	c4 c1 7b 92 c8       	kmovd  %r8d,%k1
   49a60:	c4 e3 f9 32 c9 0f    	kshiftlw $0xf,%k1,%k1
   49a66:	c4 e3 f9 30 c9 0e    	kshiftrw $0xe,%k1,%k1
   49a6c:	c5 fc 45 c1          	korw   %k1,%k0,%k0
   49a70:	66 41 b8 f7 ff       	mov    $0xfff7,%r8w
   49a75:	c4 c1 7b 92 c8       	kmovd  %r8d,%k1
   49a7a:	c5 fc 41 c1          	kandw  %k1,%k0,%k0
   49a7e:	c4 c1 7b 92 c9       	kmovd  %r9d,%k1
   49a83:	c4 e3 f9 32 c9 0f    	kshiftlw $0xf,%k1,%k1
   49a89:	c4 e3 f9 30 c9 0c    	kshiftrw $0xc,%k1,%k1
   49a8f:	c5 fc 45 c1          	korw   %k1,%k0,%k0
   49a93:	66 41 b8 df ff       	mov    $0xffdf,%r8w
   49a98:	c4 c1 7b 92 c8       	kmovd  %r8d,%k1
   49a9d:	c5 fc 41 c1          	kandw  %k1,%k0,%k0
   49aa1:	c5 fb 92 ca          	kmovd  %edx,%k1
   49aa5:	c4 e3 f9 32 c9 0f    	kshiftlw $0xf,%k1,%k1
   49aab:	c4 e3 f9 30 c9 0a    	kshiftrw $0xa,%k1,%k1
   49ab1:	c5 fc 45 c1          	korw   %k1,%k0,%k0
   49ab5:	66 ba 7f ff          	mov    $0xff7f,%dx
   49ab9:	c5 fb 92 ca          	kmovd  %edx,%k1
   49abd:	c5 fc 41 c1          	kandw  %k1,%k0,%k0
   49ac1:	c5 fb 92 ce          	kmovd  %esi,%k1
   49ac5:	c4 e3 f9 32 c9 0f    	kshiftlw $0xf,%k1,%k1
   49acb:	c4 e3 f9 30 c9 08    	kshiftrw $0x8,%k1,%k1
   49ad1:	c5 fc 45 c1          	korw   %k1,%k0,%k0
   49ad5:	62 f2 fe 28 28 c0    	vpmovm2w %k0,%ymm0
   49adb:	c5 fd 6f 1d 9d e8 fb 	vmovdqa -0x41763(%rip),%ymm3        # 8380 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0xf0>
   49ae2:	ff 
   49ae3:	62 f2 e5 28 8d c0    	vpermw %ymm0,%ymm3,%ymm0
   49ae9:	62 f2 fe 28 29 c0    	vpmovw2m %ymm0,%k0
   49aef:	c5 f8 44 c8          	knotw  %k0,%k1
   49af3:	62 f2 6d 89 00 c1    	vpshufb %xmm1,%xmm2,%xmm0{%k1}{z}
   49af9:	c5 fa 6f 0c 38       	vmovdqu (%rax,%rdi,1),%xmm1
   49afe:	c4 e2 79 17 c8       	vptest %xmm0,%xmm1
   49b03:	0f 92 c0             	setb   %al
   49b06:	0f b6 c0             	movzbl %al,%eax
   49b09:	89 01                	mov    %eax,(%rcx)
   49b0b:	48 83 c4 48          	add    $0x48,%rsp
   49b0f:	c5 f8 77             	vzeroupper
   49b12:	c3                   	ret
   49b13:	48 8d 05 5e 0c 05 00 	lea    0x50c5e(%rip),%rax        # 9a778 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0x178>
   49b1a:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
   49b1f:	48 c7 44 24 20 01 00 	movq   $0x1,0x20(%rsp)
   49b26:	00 00 
   49b28:	48 c7 44 24 28 08 00 	movq   $0x8,0x28(%rsp)
   49b2f:	00 00 
   49b31:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
   49b35:	c5 f8 11 44 24 30    	vmovups %xmm0,0x30(%rsp)
   49b3b:	4c 8d 05 16 17 05 00 	lea    0x51716(%rip),%r8        # 9b258 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0xc58>
   49b42:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
   49b47:	48 8d 54 24 10       	lea    0x10(%rsp),%rdx
   49b4c:	48 8d 4c 24 18       	lea    0x18(%rsp),%rcx
   49b51:	31 ff                	xor    %edi,%edi
   49b53:	ff 15 6f 46 05 00    	call   *0x5466f(%rip)        # 9e1c8 <_DYNAMIC+0x3b0>
   49b59:	48 8d 15 88 13 05 00 	lea    0x51388(%rip),%rdx        # 9aee8 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0x8e8>
   49b60:	ff 15 12 45 05 00    	call   *0x54512(%rip)        # 9e078 <_DYNAMIC+0x260>
   49b66:	cc                   	int3
   49b67:	cc                   	int3
   49b68:	cc                   	int3
   49b69:	cc                   	int3
   49b6a:	cc                   	int3
   49b6b:	cc                   	int3
   49b6c:	cc                   	int3
   49b6d:	cc                   	int3
   49b6e:	cc                   	int3
   49b6f:	cc                   	int3
