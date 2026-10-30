00000000000618e0 <compare_benchmark::lookup>:
   618e0:	48 83 ec 48          	sub    $0x48,%rsp
   618e4:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
   618e9:	4c 89 44 24 10       	mov    %r8,0x10(%rsp)
   618ee:	4c 39 c2             	cmp    %r8,%rdx
   618f1:	0f 85 bc 01 00 00    	jne    61ab3 <compare_benchmark::lookup+0x1d3>
   618f7:	48 83 fa 01          	cmp    $0x1,%rdx
   618fb:	75 46                	jne    61943 <compare_benchmark::lookup+0x63>
   618fd:	48 8b 16             	mov    (%rsi),%rdx
   61900:	48 89 d0             	mov    %rdx,%rax
   61903:	48 c1 e8 20          	shr    $0x20,%rax
   61907:	80 7f 1c 00          	cmpb   $0x0,0x1c(%rdi)
   6190b:	74 43                	je     61950 <compare_benchmark::lookup+0x70>
   6190d:	23 47 18             	and    0x18(%rdi),%eax
   61910:	48 8b 77 08          	mov    0x8(%rdi),%rsi
   61914:	48 c1 e0 04          	shl    $0x4,%rax
   61918:	c5 f9 6f 04 06       	vmovdqa (%rsi,%rax,1),%xmm0
   6191d:	62 f2 7d 08 7c ca    	vpbroadcastd %edx,%xmm1
   61923:	c5 f1 e5 0d 15 77 fa 	vpmulhw -0x588eb(%rip),%xmm1,%xmm1        # 9040 <anon.35274091df3394f4211c680a8c77ed4a.34.llvm.9036914972901821666+0x1d0>
   6192a:	ff 
   6192b:	c4 e2 79 59 15 14 70 	vpbroadcastq -0x58fec(%rip),%xmm2        # 8948 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x233>
   61932:	fa ff 
   61934:	c4 e2 69 00 c9       	vpshufb %xmm1,%xmm2,%xmm1
   61939:	c4 e2 79 17 c1       	vptest %xmm1,%xmm0
   6193e:	e9 60 01 00 00       	jmp    61aa3 <compare_benchmark::lookup+0x1c3>
   61943:	49 89 d0             	mov    %rdx,%r8
   61946:	48 83 c4 48          	add    $0x48,%rsp
   6194a:	ff 25 c0 6e 05 00    	jmp    *0x56ec0(%rip)        # b8810 <_DYNAMIC+0x3f8>
   61950:	23 47 18             	and    0x18(%rdi),%eax
   61953:	48 89 fe             	mov    %rdi,%rsi
   61956:	89 c7                	mov    %eax,%edi
   61958:	c1 ef 02             	shr    $0x2,%edi
   6195b:	49 89 f0             	mov    %rsi,%r8
   6195e:	48 8b 76 10          	mov    0x10(%rsi),%rsi
   61962:	48 39 f7             	cmp    %rsi,%rdi
   61965:	0f 83 8e 01 00 00    	jae    61af9 <compare_benchmark::lookup+0x219>
   6196b:	48 c1 e7 06          	shl    $0x6,%rdi
   6196f:	49 03 78 08          	add    0x8(%r8),%rdi
   61973:	c1 e0 04             	shl    $0x4,%eax
   61976:	c5 f9 6e c2          	vmovd  %edx,%xmm0
   6197a:	c1 e2 10             	shl    $0x10,%edx
   6197d:	c4 e3 79 22 c2 01    	vpinsrd $0x1,%edx,%xmm0,%xmm0
   61983:	83 e0 30             	and    $0x30,%eax
   61986:	c5 f9 72 e0 10       	vpsrad $0x10,%xmm0,%xmm0
   6198b:	c4 e2 7d 59 c8       	vpbroadcastq %xmm0,%ymm1
   61990:	c5 f9 7e c6          	vmovd  %xmm0,%esi
   61994:	c4 e3 79 16 c2 01    	vpextrd $0x1,%xmm0,%edx
   6199a:	85 d2                	test   %edx,%edx
   6199c:	0f 9f c2             	setg   %dl
   6199f:	41 0f 98 c0          	sets   %r8b
   619a3:	85 f6                	test   %esi,%esi
   619a5:	41 0f 98 c1          	sets   %r9b
   619a9:	c5 f5 f5 05 4f 71 fa 	vpmaddwd -0x58eb1(%rip),%ymm1,%ymm0        # 8b00 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x130>
   619b0:	ff 
   619b1:	62 f1 fd 48 6f 0d 05 	vmovdqa64 -0x581fb(%rip),%zmm1        # 97c0 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x5e0>
   619b8:	7e fa ff 
   619bb:	62 f2 75 48 36 c0    	vpermd %zmm0,%zmm1,%zmm0
   619c1:	62 f2 7d 48 45 05 35 	vpsrlvd -0x581cb(%rip),%zmm0,%zmm0        # 9800 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x620>
   619c8:	7e fa ff 
   619cb:	62 f2 7e 48 31 c0    	vpmovdb %zmm0,%xmm0
   619d1:	40 0f 9f c6          	setg   %sil
   619d5:	62 f1 7d 18 db 0d 85 	vpandd -0x5917b(%rip){1to4},%xmm0,%xmm1        # 8864 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x14f>
   619dc:	6e fa ff 
   619df:	c5 fa 7e 15 99 75 fa 	vmovq  -0x58a67(%rip),%xmm2        # 8f80 <anon.35274091df3394f4211c680a8c77ed4a.34.llvm.9036914972901821666+0x110>
   619e6:	ff 
   619e7:	c5 e1 ef db          	vpxor  %xmm3,%xmm3,%xmm3
   619eb:	66 41 ba fd ff       	mov    $0xfffd,%r10w
   619f0:	c4 c1 7b 92 ca       	kmovd  %r10d,%k1
   619f5:	62 f1 65 09 64 c0    	vpcmpgtb %xmm0,%xmm3,%k0{%k1}
   619fb:	c4 c1 7b 92 c8       	kmovd  %r8d,%k1
   61a00:	c4 e3 f9 32 c9 0f    	kshiftlw $0xf,%k1,%k1
   61a06:	c4 e3 f9 30 c9 0e    	kshiftrw $0xe,%k1,%k1
   61a0c:	c5 fc 45 c1          	korw   %k1,%k0,%k0
   61a10:	66 41 b8 f7 ff       	mov    $0xfff7,%r8w
   61a15:	c4 c1 7b 92 c8       	kmovd  %r8d,%k1
   61a1a:	c5 fc 41 c1          	kandw  %k1,%k0,%k0
   61a1e:	c4 c1 7b 92 c9       	kmovd  %r9d,%k1
   61a23:	c4 e3 f9 32 c9 0f    	kshiftlw $0xf,%k1,%k1
   61a29:	c4 e3 f9 30 c9 0c    	kshiftrw $0xc,%k1,%k1
   61a2f:	c5 fc 45 c1          	korw   %k1,%k0,%k0
   61a33:	66 41 b8 df ff       	mov    $0xffdf,%r8w
   61a38:	c4 c1 7b 92 c8       	kmovd  %r8d,%k1
   61a3d:	c5 fc 41 c1          	kandw  %k1,%k0,%k0
   61a41:	c5 fb 92 ca          	kmovd  %edx,%k1
   61a45:	c4 e3 f9 32 c9 0f    	kshiftlw $0xf,%k1,%k1
   61a4b:	c4 e3 f9 30 c9 0a    	kshiftrw $0xa,%k1,%k1
   61a51:	c5 fc 45 c1          	korw   %k1,%k0,%k0
   61a55:	66 ba 7f ff          	mov    $0xff7f,%dx
   61a59:	c5 fb 92 ca          	kmovd  %edx,%k1
   61a5d:	c5 fc 41 c1          	kandw  %k1,%k0,%k0
   61a61:	c5 fb 92 ce          	kmovd  %esi,%k1
   61a65:	c4 e3 f9 32 c9 0f    	kshiftlw $0xf,%k1,%k1
   61a6b:	c4 e3 f9 30 c9 08    	kshiftrw $0x8,%k1,%k1
   61a71:	c5 fc 45 c1          	korw   %k1,%k0,%k0
   61a75:	62 f2 fe 28 28 c0    	vpmovm2w %k0,%ymm0
   61a7b:	c5 fd 6f 1d 3d 70 fa 	vmovdqa -0x58fc3(%rip),%ymm3        # 8ac0 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0xf0>
   61a82:	ff 
   61a83:	62 f2 e5 28 8d c0    	vpermw %ymm0,%ymm3,%ymm0
   61a89:	62 f2 fe 28 29 c0    	vpmovw2m %ymm0,%k0
   61a8f:	c5 f8 44 c8          	knotw  %k0,%k1
   61a93:	62 f2 6d 89 00 c1    	vpshufb %xmm1,%xmm2,%xmm0{%k1}{z}
   61a99:	c5 fa 6f 0c 38       	vmovdqu (%rax,%rdi,1),%xmm1
   61a9e:	c4 e2 79 17 c8       	vptest %xmm0,%xmm1
   61aa3:	0f 92 c0             	setb   %al
   61aa6:	0f b6 c0             	movzbl %al,%eax
   61aa9:	89 01                	mov    %eax,(%rcx)
   61aab:	48 83 c4 48          	add    $0x48,%rsp
   61aaf:	c5 f8 77             	vzeroupper
   61ab2:	c3                   	ret
   61ab3:	48 8d 05 06 2f 05 00 	lea    0x52f06(%rip),%rax        # b49c0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0x1f0>
   61aba:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
   61abf:	48 c7 44 24 20 01 00 	movq   $0x1,0x20(%rsp)
   61ac6:	00 00 
   61ac8:	48 c7 44 24 28 08 00 	movq   $0x8,0x28(%rsp)
   61acf:	00 00 
   61ad1:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
   61ad5:	c5 f8 11 44 24 30    	vmovups %xmm0,0x30(%rsp)
   61adb:	4c 8d 05 46 38 05 00 	lea    0x53846(%rip),%r8        # b5328 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0xb58>
   61ae2:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
   61ae7:	48 8d 54 24 10       	lea    0x10(%rsp),%rdx
   61aec:	48 8d 4c 24 18       	lea    0x18(%rsp),%rcx
   61af1:	31 ff                	xor    %edi,%edi
   61af3:	ff 15 f7 6c 05 00    	call   *0x56cf7(%rip)        # b87f0 <_DYNAMIC+0x3d8>
   61af9:	48 8d 15 40 38 05 00 	lea    0x53840(%rip),%rdx        # b5340 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0xb70>
   61b00:	ff 15 72 6b 05 00    	call   *0x56b72(%rip)        # b8678 <_DYNAMIC+0x260>
   61b06:	cc                   	int3
   61b07:	cc                   	int3
   61b08:	cc                   	int3
   61b09:	cc                   	int3
   61b0a:	cc                   	int3
   61b0b:	cc                   	int3
   61b0c:	cc                   	int3
   61b0d:	cc                   	int3
   61b0e:	cc                   	int3
   61b0f:	cc                   	int3

