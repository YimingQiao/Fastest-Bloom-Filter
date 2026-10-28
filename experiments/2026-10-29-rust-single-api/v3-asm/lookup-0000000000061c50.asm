0000000000061c50 <compare_benchmark::lookup>:
   61c50:	48 83 ec 48          	sub    $0x48,%rsp
   61c54:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
   61c59:	4c 89 44 24 10       	mov    %r8,0x10(%rsp)
   61c5e:	4c 39 c2             	cmp    %r8,%rdx
   61c61:	0f 85 8c 00 00 00    	jne    61cf3 <compare_benchmark::lookup+0xa3>
   61c67:	48 83 fa 01          	cmp    $0x1,%rdx
   61c6b:	75 79                	jne    61ce6 <compare_benchmark::lookup+0x96>
   61c6d:	48 8b 16             	mov    (%rsi),%rdx
   61c70:	48 89 d0             	mov    %rdx,%rax
   61c73:	48 c1 e8 20          	shr    $0x20,%rax
   61c77:	23 47 18             	and    0x18(%rdi),%eax
   61c7a:	48 8b 77 10          	mov    0x10(%rdi),%rsi
   61c7e:	48 39 c6             	cmp    %rax,%rsi
   61c81:	0f 86 b2 00 00 00    	jbe    61d39 <compare_benchmark::lookup+0xe9>
   61c87:	62 f2 fd 48 7c c2    	vpbroadcastq %rdx,%zmm0
   61c8d:	62 f2 fd 48 40 05 a9 	vpmullq -0x58457(%rip),%zmm0,%zmm0        # 9840 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x660>
   61c94:	7b fa ff 
   61c97:	48 8b 57 08          	mov    0x8(%rdi),%rdx
   61c9b:	62 f1 fd 48 73 d0 1a 	vpsrlq $0x1a,%zmm0,%zmm0
   61ca2:	62 f1 fd 58 db 05 64 	vpandq -0x5929c(%rip){1to8},%zmm0,%zmm0        # 8a10 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x40>
   61ca9:	6d fa ff 
   61cac:	48 c1 e0 06          	shl    $0x6,%rax
   61cb0:	62 f2 fd 48 59 0d e6 	vpbroadcastq -0x5931a(%rip),%zmm1        # 89a0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x28b>
   61cb7:	6c fa ff 
   61cba:	62 f2 f5 48 47 c0    	vpsllvq %zmm0,%zmm1,%zmm0
   61cc0:	62 f1 fe 48 6f 0c 02 	vmovdqu64 (%rdx,%rax,1),%zmm1
   61cc7:	62 f1 f5 48 df c0    	vpandnq %zmm0,%zmm1,%zmm0
   61ccd:	62 f2 7d 48 27 c0    	vptestmd %zmm0,%zmm0,%k0
   61cd3:	31 c0                	xor    %eax,%eax
   61cd5:	c5 f8 98 c0          	kortestw %k0,%k0
   61cd9:	0f 94 c0             	sete   %al
   61cdc:	89 01                	mov    %eax,(%rcx)
   61cde:	48 83 c4 48          	add    $0x48,%rsp
   61ce2:	c5 f8 77             	vzeroupper
   61ce5:	c3                   	ret
   61ce6:	49 89 d0             	mov    %rdx,%r8
   61ce9:	48 83 c4 48          	add    $0x48,%rsp
   61ced:	ff 25 05 6b 05 00    	jmp    *0x56b05(%rip)        # b87f8 <_DYNAMIC+0x3e0>
   61cf3:	48 8d 05 c6 2c 05 00 	lea    0x52cc6(%rip),%rax        # b49c0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0x1f0>
   61cfa:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
   61cff:	48 c7 44 24 20 01 00 	movq   $0x1,0x20(%rsp)
   61d06:	00 00 
   61d08:	48 c7 44 24 28 08 00 	movq   $0x8,0x28(%rsp)
   61d0f:	00 00 
   61d11:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
   61d15:	c5 f8 11 44 24 30    	vmovups %xmm0,0x30(%rsp)
   61d1b:	4c 8d 05 5e 39 05 00 	lea    0x5395e(%rip),%r8        # b5680 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0xeb0>
   61d22:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
   61d27:	48 8d 54 24 10       	lea    0x10(%rsp),%rdx
   61d2c:	48 8d 4c 24 18       	lea    0x18(%rsp),%rcx
   61d31:	31 ff                	xor    %edi,%edi
   61d33:	ff 15 b7 6a 05 00    	call   *0x56ab7(%rip)        # b87f0 <_DYNAMIC+0x3d8>
   61d39:	48 8d 15 d0 35 05 00 	lea    0x535d0(%rip),%rdx        # b5310 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0xb40>
   61d40:	48 89 c7             	mov    %rax,%rdi
   61d43:	ff 15 2f 69 05 00    	call   *0x5692f(%rip)        # b8678 <_DYNAMIC+0x260>
   61d49:	cc                   	int3
   61d4a:	cc                   	int3
   61d4b:	cc                   	int3
   61d4c:	cc                   	int3
   61d4d:	cc                   	int3
   61d4e:	cc                   	int3
   61d4f:	cc                   	int3

