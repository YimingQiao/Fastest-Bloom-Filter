0000000000061d50 <compare_benchmark::lookup>:
   61d50:	55                   	push   %rbp
   61d51:	41 57                	push   %r15
   61d53:	41 56                	push   %r14
   61d55:	41 55                	push   %r13
   61d57:	41 54                	push   %r12
   61d59:	53                   	push   %rbx
   61d5a:	48 83 ec 68          	sub    $0x68,%rsp
   61d5e:	48 89 54 24 28       	mov    %rdx,0x28(%rsp)
   61d63:	4c 89 44 24 30       	mov    %r8,0x30(%rsp)
   61d68:	4c 39 c2             	cmp    %r8,%rdx
   61d6b:	0f 85 9c 0a 00 00    	jne    6280d <compare_benchmark::lookup+0xabd>
   61d71:	49 89 f7             	mov    %rsi,%r15
   61d74:	48 83 fa 04          	cmp    $0x4,%rdx
   61d78:	48 89 54 24 10       	mov    %rdx,0x10(%rsp)
   61d7d:	72 37                	jb     61db6 <compare_benchmark::lookup+0x66>
   61d7f:	80 7f 1c 00          	cmpb   $0x0,0x1c(%rdi)
   61d83:	74 31                	je     61db6 <compare_benchmark::lookup+0x66>
   61d85:	48 81 7f 10 00 80 00 	cmpq   $0x8000,0x10(%rdi)
   61d8c:	00 
   61d8d:	0f 86 b1 01 00 00    	jbe    61f44 <compare_benchmark::lookup+0x1f4>
   61d93:	62 f1 fd 48 6f 05 63 	vmovdqa64 -0x5829d(%rip),%zmm0        # 9b00 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x920>
   61d9a:	7d fa ff 
   61d9d:	48 83 fa 0f          	cmp    $0xf,%rdx
   61da1:	0f 87 03 05 00 00    	ja     622aa <compare_benchmark::lookup+0x55a>
   61da7:	4c 8b 57 08          	mov    0x8(%rdi),%r10
   61dab:	44 8b 47 18          	mov    0x18(%rdi),%r8d
   61daf:	31 ff                	xor    %edi,%edi
   61db1:	e9 a0 08 00 00       	jmp    62656 <compare_benchmark::lookup+0x906>
   61db6:	48 85 d2             	test   %rdx,%rdx
   61db9:	0f 84 3c 0a 00 00    	je     627fb <compare_benchmark::lookup+0xaab>
   61dbf:	8b 47 18             	mov    0x18(%rdi),%eax
   61dc2:	89 44 24 0c          	mov    %eax,0xc(%rsp)
   61dc6:	48 8b 47 08          	mov    0x8(%rdi),%rax
   61dca:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
   61dcf:	4c 8b 47 10          	mov    0x10(%rdi),%r8
   61dd3:	31 db                	xor    %ebx,%ebx
   61dd5:	4c 89 7c 24 18       	mov    %r15,0x18(%rsp)
   61dda:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
   61ddf:	90                   	nop
   61de0:	4d 8b 0c df          	mov    (%r15,%rbx,8),%r9
   61de4:	4d 89 cd             	mov    %r9,%r13
   61de7:	49 c1 ed 20          	shr    $0x20,%r13
   61deb:	8b 44 24 0c          	mov    0xc(%rsp),%eax
   61def:	44 21 e8             	and    %r13d,%eax
   61df2:	41 89 c6             	mov    %eax,%r14d
   61df5:	41 c1 ee 04          	shr    $0x4,%r14d
   61df9:	4d 39 c6             	cmp    %r8,%r14
   61dfc:	0f 83 a5 0a 00 00    	jae    628a7 <compare_benchmark::lookup+0xb57>
   61e02:	89 c5                	mov    %eax,%ebp
   61e04:	c1 ed 04             	shr    $0x4,%ebp
   61e07:	4c 39 c5             	cmp    %r8,%rbp
   61e0a:	0f 83 81 0a 00 00    	jae    62891 <compare_benchmark::lookup+0xb41>
   61e10:	4d 89 ca             	mov    %r9,%r10
   61e13:	49 c1 ea 3c          	shr    $0x3c,%r10
   61e17:	41 83 e2 03          	and    $0x3,%r10d
   61e1b:	41 83 ca 08          	or     $0x8,%r10d
   61e1f:	41 31 c2             	xor    %eax,%r10d
   61e22:	44 89 d7             	mov    %r10d,%edi
   61e25:	c1 ef 04             	shr    $0x4,%edi
   61e28:	4c 39 c7             	cmp    %r8,%rdi
   61e2b:	0f 83 4a 0a 00 00    	jae    6287b <compare_benchmark::lookup+0xb2b>
   61e31:	4d 89 cc             	mov    %r9,%r12
   61e34:	49 c1 ec 3e          	shr    $0x3e,%r12
   61e38:	41 83 cc 0c          	or     $0xc,%r12d
   61e3c:	41 31 c4             	xor    %eax,%r12d
   61e3f:	45 89 e7             	mov    %r12d,%r15d
   61e42:	41 c1 ef 04          	shr    $0x4,%r15d
   61e46:	4c 89 c6             	mov    %r8,%rsi
   61e49:	4d 39 c7             	cmp    %r8,%r15
   61e4c:	0f 83 16 0a 00 00    	jae    62868 <compare_benchmark::lookup+0xb18>
   61e52:	48 89 ca             	mov    %rcx,%rdx
   61e55:	45 89 d2             	mov    %r10d,%r10d
   61e58:	48 c1 e7 06          	shl    $0x6,%rdi
   61e5c:	4c 01 df             	add    %r11,%rdi
   61e5f:	41 83 e2 0f          	and    $0xf,%r10d
   61e63:	46 8b 14 97          	mov    (%rdi,%r10,4),%r10d
   61e67:	44 89 cf             	mov    %r9d,%edi
   61e6a:	c1 ef 06             	shr    $0x6,%edi
   61e6d:	83 e7 3c             	and    $0x3c,%edi
   61e70:	4c 8d 05 89 7c fa ff 	lea    -0x58377(%rip),%r8        # 9b00 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x920>
   61e77:	42 8b 3c 07          	mov    (%rdi,%r8,1),%edi
   61e7b:	41 c1 ed 1a          	shr    $0x1a,%r13d
   61e7f:	41 83 e5 03          	and    $0x3,%r13d
   61e83:	41 83 cd 04          	or     $0x4,%r13d
   61e87:	41 31 c5             	xor    %eax,%r13d
   61e8a:	48 c1 e5 06          	shl    $0x6,%rbp
   61e8e:	4c 01 dd             	add    %r11,%rbp
   61e91:	41 83 e5 0f          	and    $0xf,%r13d
   61e95:	42 8b 6c ad 00       	mov    0x0(%rbp,%r13,4),%ebp
   61e9a:	45 89 cd             	mov    %r9d,%r13d
   61e9d:	41 83 e5 0f          	and    $0xf,%r13d
   61ea1:	47 8b 2c a8          	mov    (%r8,%r13,4),%r13d
   61ea5:	49 c1 e6 06          	shl    $0x6,%r14
   61ea9:	4d 01 de             	add    %r11,%r14
   61eac:	83 e0 0f             	and    $0xf,%eax
   61eaf:	41 8b 04 86          	mov    (%r14,%rax,4),%eax
   61eb3:	44 89 c9             	mov    %r9d,%ecx
   61eb6:	c1 e9 04             	shr    $0x4,%ecx
   61eb9:	41 d3 c5             	rol    %cl,%r13d
   61ebc:	c4 c2 78 f2 c5       	andn   %r13d,%eax,%eax
   61ec1:	44 89 c9             	mov    %r9d,%ecx
   61ec4:	c1 e9 0c             	shr    $0xc,%ecx
   61ec7:	d3 c7                	rol    %cl,%edi
   61ec9:	c4 e2 50 f2 ef       	andn   %edi,%ebp,%ebp
   61ece:	44 89 c9             	mov    %r9d,%ecx
   61ed1:	c1 e9 0e             	shr    $0xe,%ecx
   61ed4:	83 e1 3c             	and    $0x3c,%ecx
   61ed7:	46 8b 2c 01          	mov    (%rcx,%r8,1),%r13d
   61edb:	09 c5                	or     %eax,%ebp
   61edd:	c4 c3 7b f0 f9 18    	rorx   $0x18,%r9d,%edi
   61ee3:	41 c1 e9 14          	shr    $0x14,%r9d
   61ee7:	44 89 c9             	mov    %r9d,%ecx
   61eea:	41 d3 c5             	rol    %cl,%r13d
   61eed:	c4 c2 28 f2 c5       	andn   %r13d,%r10d,%eax
   61ef2:	09 e8                	or     %ebp,%eax
   61ef4:	44 89 e1             	mov    %r12d,%ecx
   61ef7:	49 c1 e7 06          	shl    $0x6,%r15
   61efb:	4d 01 df             	add    %r11,%r15
   61efe:	83 e1 0f             	and    $0xf,%ecx
   61f01:	45 8b 0c 8f          	mov    (%r15,%rcx,4),%r9d
   61f05:	89 f9                	mov    %edi,%ecx
   61f07:	83 e1 0f             	and    $0xf,%ecx
   61f0a:	45 8b 14 88          	mov    (%r8,%rcx,4),%r10d
   61f0e:	c1 ef 04             	shr    $0x4,%edi
   61f11:	89 f9                	mov    %edi,%ecx
   61f13:	41 d3 c2             	rol    %cl,%r10d
   61f16:	c4 c2 30 f2 ca       	andn   %r10d,%r9d,%ecx
   61f1b:	31 ff                	xor    %edi,%edi
   61f1d:	09 c1                	or     %eax,%ecx
   61f1f:	40 0f 94 c7          	sete   %dil
   61f23:	48 89 d1             	mov    %rdx,%rcx
   61f26:	89 3c 9a             	mov    %edi,(%rdx,%rbx,4)
   61f29:	48 ff c3             	inc    %rbx
   61f2c:	48 39 5c 24 10       	cmp    %rbx,0x10(%rsp)
   61f31:	4c 8b 7c 24 18       	mov    0x18(%rsp),%r15
   61f36:	49 89 f0             	mov    %rsi,%r8
   61f39:	0f 85 a1 fe ff ff    	jne    61de0 <compare_benchmark::lookup+0x90>
   61f3f:	e9 b7 08 00 00       	jmp    627fb <compare_benchmark::lookup+0xaab>
   61f44:	62 f1 fd 48 6f 05 b2 	vmovdqa64 -0x5844e(%rip),%zmm0        # 9b00 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x920>
   61f4b:	7b fa ff 
   61f4e:	4c 8b 4f 08          	mov    0x8(%rdi),%r9
   61f52:	8b 47 18             	mov    0x18(%rdi),%eax
   61f55:	62 f2 7d 48 7c c8    	vpbroadcastd %eax,%zmm1
   61f5b:	31 ff                	xor    %edi,%edi
   61f5d:	48 83 fa 10          	cmp    $0x10,%rdx
   61f61:	0f 82 bd 01 00 00    	jb     62124 <compare_benchmark::lookup+0x3d4>
   61f67:	62 f1 fd 48 6f 15 0f 	vmovdqa64 -0x586f1(%rip),%zmm2        # 9880 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x6a0>
   61f6e:	79 fa ff 
   61f71:	62 f1 fd 48 6f 1d 45 	vmovdqa64 -0x586bb(%rip),%zmm3        # 98c0 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x6e0>
   61f78:	79 fa ff 
   61f7b:	62 f2 7d 48 58 25 e3 	vpbroadcastd -0x5971d(%rip),%zmm4        # 8868 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x153>
   61f82:	68 fa ff 
   61f85:	62 f2 7d 48 58 2d a5 	vpbroadcastd -0x5975b(%rip),%zmm5        # 8834 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x11f>
   61f8c:	68 fa ff 
   61f8f:	62 f2 7d 48 58 35 fb 	vpbroadcastd -0x59705(%rip),%zmm6        # 8894 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x17f>
   61f96:	68 fa ff 
   61f99:	62 f2 7d 48 58 3d 9d 	vpbroadcastd -0x59763(%rip),%zmm7        # 8840 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x12b>
   61fa0:	68 fa ff 
   61fa3:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   61faa:	84 00 00 00 00 00 
   61fb0:	49 89 f8             	mov    %rdi,%r8
   61fb3:	62 51 fe 48 6f 04 ff 	vmovdqu64 (%r15,%rdi,8),%zmm8
   61fba:	62 51 fe 48 6f 4c ff 	vmovdqu64 0x40(%r15,%rdi,8),%zmm9
   61fc1:	01 
   61fc2:	62 51 fd 48 6f d0    	vmovdqa64 %zmm8,%zmm10
   61fc8:	62 52 6d 48 7e d1    	vpermt2d %zmm9,%zmm2,%zmm10
   61fce:	62 52 65 48 7e c1    	vpermt2d %zmm9,%zmm3,%zmm8
   61fd4:	62 71 3d 48 db c9    	vpandd %zmm1,%zmm8,%zmm9
   61fda:	62 d1 25 48 72 d0 1a 	vpsrld $0x1a,%zmm8,%zmm11
   61fe1:	62 71 25 48 db dc    	vpandd %zmm4,%zmm11,%zmm11
   61fe7:	62 73 35 48 25 dd 36 	vpternlogd $0x36,%zmm5,%zmm9,%zmm11
   61fee:	62 d1 1d 48 72 d0 1c 	vpsrld $0x1c,%zmm8,%zmm12
   61ff5:	62 71 1d 48 db e4    	vpandd %zmm4,%zmm12,%zmm12
   61ffb:	62 73 35 48 25 e6 36 	vpternlogd $0x36,%zmm6,%zmm9,%zmm12
   62002:	62 d1 3d 48 72 d0 1e 	vpsrld $0x1e,%zmm8,%zmm8
   62009:	62 73 35 48 25 c7 36 	vpternlogd $0x36,%zmm7,%zmm9,%zmm8
   62010:	62 d1 15 48 72 ca 18 	vprold $0x18,%zmm10,%zmm13
   62017:	62 d1 0d 48 72 ca 10 	vprold $0x10,%zmm10,%zmm14
   6201e:	62 d1 05 48 72 ca 08 	vprold $0x8,%zmm10,%zmm15
   62025:	c5 fc 46 c8          	kxnorw %k0,%k0,%k1
   62029:	62 a1 7d 00 ef c0    	vpxord %xmm16,%xmm16,%xmm16
   6202f:	62 82 7d 49 90 04 89 	vpgatherdd (%r9,%zmm9,4),%zmm16{%k1}
   62036:	c4 41 31 ef c9       	vpxor  %xmm9,%xmm9,%xmm9
   6203b:	62 72 2d 48 36 c8    	vpermd %zmm0,%zmm10,%zmm9
   62041:	62 d1 2d 48 72 d2 04 	vpsrld $0x4,%zmm10,%zmm10
   62048:	62 52 35 48 15 ca    	vprolvd %zmm10,%zmm9,%zmm9
   6204e:	c5 fc 46 c8          	kxnorw %k0,%k0,%k1
   62052:	c4 41 29 ef d2       	vpxor  %xmm10,%xmm10,%xmm10
   62057:	62 12 7d 49 90 14 99 	vpgatherdd (%r9,%zmm11,4),%zmm10{%k1}
   6205e:	c4 41 21 ef db       	vpxor  %xmm11,%xmm11,%xmm11
   62063:	62 72 15 48 36 d8    	vpermd %zmm0,%zmm13,%zmm11
   62069:	62 d1 15 48 72 d5 04 	vpsrld $0x4,%zmm13,%zmm13
   62070:	62 52 25 48 15 dd    	vprolvd %zmm13,%zmm11,%zmm11
   62076:	c5 fc 46 c8          	kxnorw %k0,%k0,%k1
   6207a:	c4 41 11 ef ed       	vpxor  %xmm13,%xmm13,%xmm13
   6207f:	62 12 7d 49 90 2c a1 	vpgatherdd (%r9,%zmm12,4),%zmm13{%k1}
   62086:	c4 41 19 ef e4       	vpxor  %xmm12,%xmm12,%xmm12
   6208b:	62 72 0d 48 36 e0    	vpermd %zmm0,%zmm14,%zmm12
   62091:	62 d1 0d 48 72 d6 04 	vpsrld $0x4,%zmm14,%zmm14
   62098:	62 52 1d 48 15 e6    	vprolvd %zmm14,%zmm12,%zmm12
   6209e:	c5 fc 46 c8          	kxnorw %k0,%k0,%k1
   620a2:	c4 41 09 ef f6       	vpxor  %xmm14,%xmm14,%xmm14
   620a7:	62 12 7d 49 90 34 81 	vpgatherdd (%r9,%zmm8,4),%zmm14{%k1}
   620ae:	c4 41 39 ef c0       	vpxor  %xmm8,%xmm8,%xmm8
   620b3:	62 72 05 48 36 c0    	vpermd %zmm0,%zmm15,%zmm8
   620b9:	62 d1 05 48 72 d7 04 	vpsrld $0x4,%zmm15,%zmm15
   620c0:	62 52 3d 48 15 c7    	vprolvd %zmm15,%zmm8,%zmm8
   620c6:	62 51 7d 40 db f9    	vpandd %zmm9,%zmm16,%zmm15
   620cc:	62 d1 05 48 76 c9    	vpcmpeqd %zmm9,%zmm15,%k1
   620d2:	62 51 2d 48 db cb    	vpandd %zmm11,%zmm10,%zmm9
   620d8:	62 d1 35 49 76 cb    	vpcmpeqd %zmm11,%zmm9,%k1{%k1}
   620de:	62 51 15 48 db cc    	vpandd %zmm12,%zmm13,%zmm9
   620e4:	62 d1 35 49 76 cc    	vpcmpeqd %zmm12,%zmm9,%k1{%k1}
   620ea:	62 51 0d 48 db c8    	vpandd %zmm8,%zmm14,%zmm9
   620f0:	62 d1 35 49 76 c0    	vpcmpeqd %zmm8,%zmm9,%k0{%k1}
   620f6:	62 72 7e 48 38 c0    	vpmovm2d %k0,%zmm8
   620fc:	62 d1 3d 48 72 d0 1f 	vpsrld $0x1f,%zmm8,%zmm8
   62103:	62 71 fe 48 7f 04 b9 	vmovdqu64 %zmm8,(%rcx,%rdi,4)
   6210a:	48 83 c7 10          	add    $0x10,%rdi
   6210e:	49 83 c0 20          	add    $0x20,%r8
   62112:	49 39 d0             	cmp    %rdx,%r8
   62115:	0f 86 95 fe ff ff    	jbe    61fb0 <compare_benchmark::lookup+0x260>
   6211b:	48 39 d7             	cmp    %rdx,%rdi
   6211e:	0f 83 d7 06 00 00    	jae    627fb <compare_benchmark::lookup+0xaab>
   62124:	29 fa                	sub    %edi,%edx
   62126:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   6212b:	c4 e2 69 f7 d0       	shlx   %edx,%eax,%edx
   62130:	0f b7 c2             	movzwl %dx,%eax
   62133:	f7 d2                	not    %edx
   62135:	c5 fb 92 ca          	kmovd  %edx,%k1
   62139:	62 d1 fe c9 6f 1c ff 	vmovdqu64 (%r15,%rdi,8),%zmm3{%k1}{z}
   62140:	c5 e9 ef d2          	vpxor  %xmm2,%xmm2,%xmm2
   62144:	c5 d9 ef e4          	vpxor  %xmm4,%xmm4,%xmm4
   62148:	3d ff fe 00 00       	cmp    $0xfeff,%eax
   6214d:	77 14                	ja     62163 <compare_benchmark::lookup+0x413>
   6214f:	49 8d 04 ff          	lea    (%r15,%rdi,8),%rax
   62153:	89 d6                	mov    %edx,%esi
   62155:	c1 ee 08             	shr    $0x8,%esi
   62158:	c5 fb 92 ce          	kmovd  %esi,%k1
   6215c:	62 f1 fe c9 6f 60 01 	vmovdqu64 0x40(%rax),%zmm4{%k1}{z}
   62163:	62 f1 fd 48 6f 2d 13 	vmovdqa64 -0x588ed(%rip),%zmm5        # 9880 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x6a0>
   6216a:	77 fa ff 
   6216d:	62 f2 65 48 76 ec    	vpermi2d %zmm4,%zmm3,%zmm5
   62173:	62 f1 fd 48 6f 35 43 	vmovdqa64 -0x588bd(%rip),%zmm6        # 98c0 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x6e0>
   6217a:	77 fa ff 
   6217d:	62 f2 65 48 76 f4    	vpermi2d %zmm4,%zmm3,%zmm6
   62183:	62 f1 4d 48 db c9    	vpandd %zmm1,%zmm6,%zmm1
   62189:	62 f1 65 48 72 d6 1a 	vpsrld $0x1a,%zmm6,%zmm3
   62190:	62 f2 7d 48 58 25 ce 	vpbroadcastd -0x59932(%rip),%zmm4        # 8868 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x153>
   62197:	66 fa ff 
   6219a:	62 f1 65 48 db dc    	vpandd %zmm4,%zmm3,%zmm3
   621a0:	62 f3 75 58 25 1d 89 	vpternlogd $0x36,-0x59977(%rip){1to16},%zmm1,%zmm3        # 8834 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x11f>
   621a7:	66 fa ff 36 
   621ab:	62 f1 45 48 72 d6 1c 	vpsrld $0x1c,%zmm6,%zmm7
   621b2:	62 f1 45 48 db e4    	vpandd %zmm4,%zmm7,%zmm4
   621b8:	62 f3 75 58 25 25 d1 	vpternlogd $0x36,-0x5992f(%rip){1to16},%zmm1,%zmm4        # 8894 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x17f>
   621bf:	66 fa ff 36 
   621c3:	62 f1 4d 48 72 d6 1e 	vpsrld $0x1e,%zmm6,%zmm6
   621ca:	c5 fb 92 ca          	kmovd  %edx,%k1
   621ce:	c5 c1 ef ff          	vpxor  %xmm7,%xmm7,%xmm7
   621d2:	c4 e1 f8 90 d1       	kmovq  %k1,%k2
   621d7:	62 d2 7d 4a 90 3c 89 	vpgatherdd (%r9,%zmm1,4),%zmm7{%k2}
   621de:	62 f3 75 58 25 35 57 	vpternlogd $0x36,-0x599a9(%rip){1to16},%zmm1,%zmm6        # 8840 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x12b>
   621e5:	66 fa ff 36 
   621e9:	62 f1 75 48 72 cd 18 	vprold $0x18,%zmm5,%zmm1
   621f0:	62 f1 3d 48 72 cd 10 	vprold $0x10,%zmm5,%zmm8
   621f7:	c4 41 31 ef c9       	vpxor  %xmm9,%xmm9,%xmm9
   621fc:	c4 e1 f8 90 d1       	kmovq  %k1,%k2
   62201:	62 52 7d 4a 90 0c 99 	vpgatherdd (%r9,%zmm3,4),%zmm9{%k2}
   62208:	62 f1 65 48 72 cd 08 	vprold $0x8,%zmm5,%zmm3
   6220f:	62 72 55 48 36 d0    	vpermd %zmm0,%zmm5,%zmm10
   62215:	62 f1 55 48 72 d5 04 	vpsrld $0x4,%zmm5,%zmm5
   6221c:	62 f2 2d 48 15 ed    	vprolvd %zmm5,%zmm10,%zmm5
   62222:	c4 41 29 ef d2       	vpxor  %xmm10,%xmm10,%xmm10
   62227:	c4 e1 f8 90 d1       	kmovq  %k1,%k2
   6222c:	62 52 7d 4a 90 14 a1 	vpgatherdd (%r9,%zmm4,4),%zmm10{%k2}
   62233:	c5 d9 ef e4          	vpxor  %xmm4,%xmm4,%xmm4
   62237:	62 f2 75 48 36 e0    	vpermd %zmm0,%zmm1,%zmm4
   6223d:	62 f1 75 48 72 d1 04 	vpsrld $0x4,%zmm1,%zmm1
   62244:	62 f2 5d 48 15 c9    	vprolvd %zmm1,%zmm4,%zmm1
   6224a:	c5 d9 ef e4          	vpxor  %xmm4,%xmm4,%xmm4
   6224e:	62 f2 3d 48 36 e0    	vpermd %zmm0,%zmm8,%zmm4
   62254:	62 d1 3d 48 72 d0 04 	vpsrld $0x4,%zmm8,%zmm8
   6225b:	62 d2 7d 49 90 14 b1 	vpgatherdd (%r9,%zmm6,4),%zmm2{%k1}
   62262:	62 d2 5d 48 15 e0    	vprolvd %zmm8,%zmm4,%zmm4
   62268:	62 f2 65 48 36 c0    	vpermd %zmm0,%zmm3,%zmm0
   6226e:	62 f1 65 48 72 d3 04 	vpsrld $0x4,%zmm3,%zmm3
   62275:	62 f2 7d 48 15 c3    	vprolvd %zmm3,%zmm0,%zmm0
   6227b:	62 f1 45 48 db dd    	vpandd %zmm5,%zmm7,%zmm3
   62281:	62 f1 65 48 76 cd    	vpcmpeqd %zmm5,%zmm3,%k1
   62287:	62 f1 35 48 db d9    	vpandd %zmm1,%zmm9,%zmm3
   6228d:	62 f1 65 49 76 c9    	vpcmpeqd %zmm1,%zmm3,%k1{%k1}
   62293:	62 f1 2d 48 db cc    	vpandd %zmm4,%zmm10,%zmm1
   62299:	62 f1 75 49 76 cc    	vpcmpeqd %zmm4,%zmm1,%k1{%k1}
   6229f:	62 f1 6d 48 db c8    	vpandd %zmm0,%zmm2,%zmm1
   622a5:	e9 33 05 00 00       	jmp    627dd <compare_benchmark::lookup+0xa8d>
   622aa:	44 8b 47 18          	mov    0x18(%rdi),%r8d
   622ae:	4c 8b 57 08          	mov    0x8(%rdi),%r10
   622b2:	62 d2 7d 48 7c c8    	vpbroadcastd %r8d,%zmm1
   622b8:	45 31 c9             	xor    %r9d,%r9d
   622bb:	62 f1 fd 48 6f 15 bb 	vmovdqa64 -0x58a45(%rip),%zmm2        # 9880 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x6a0>
   622c2:	75 fa ff 
   622c5:	62 f1 fd 48 6f 1d f1 	vmovdqa64 -0x58a0f(%rip),%zmm3        # 98c0 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x6e0>
   622cc:	75 fa ff 
   622cf:	62 f2 7d 48 58 25 8f 	vpbroadcastd -0x59a71(%rip),%zmm4        # 8868 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x153>
   622d6:	65 fa ff 
   622d9:	62 f2 7d 48 58 2d 51 	vpbroadcastd -0x59aaf(%rip),%zmm5        # 8834 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x11f>
   622e0:	65 fa ff 
   622e3:	62 f2 7d 48 58 35 a7 	vpbroadcastd -0x59a59(%rip),%zmm6        # 8894 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x17f>
   622ea:	65 fa ff 
   622ed:	62 f2 7d 48 58 3d 49 	vpbroadcastd -0x59ab7(%rip),%zmm7        # 8840 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x12b>
   622f4:	65 fa ff 
   622f7:	e9 6f 01 00 00       	jmp    6246b <compare_benchmark::lookup+0x71b>
   622fc:	0f 1f 40 00          	nopl   0x0(%rax)
   62300:	62 11 fe 48 6f 04 cf 	vmovdqu64 (%r15,%r9,8),%zmm8
   62307:	62 11 fe 48 6f 4c cf 	vmovdqu64 0x40(%r15,%r9,8),%zmm9
   6230e:	01 
   6230f:	62 51 fd 48 6f d0    	vmovdqa64 %zmm8,%zmm10
   62315:	62 52 6d 48 7e d1    	vpermt2d %zmm9,%zmm2,%zmm10
   6231b:	62 52 65 48 7e c1    	vpermt2d %zmm9,%zmm3,%zmm8
   62321:	62 71 3d 48 db c9    	vpandd %zmm1,%zmm8,%zmm9
   62327:	62 d1 25 48 72 d0 1a 	vpsrld $0x1a,%zmm8,%zmm11
   6232e:	62 71 25 48 db dc    	vpandd %zmm4,%zmm11,%zmm11
   62334:	62 73 35 48 25 dd 36 	vpternlogd $0x36,%zmm5,%zmm9,%zmm11
   6233b:	62 d1 1d 48 72 d0 1c 	vpsrld $0x1c,%zmm8,%zmm12
   62342:	62 71 1d 48 db e4    	vpandd %zmm4,%zmm12,%zmm12
   62348:	62 73 35 48 25 e6 36 	vpternlogd $0x36,%zmm6,%zmm9,%zmm12
   6234f:	62 d1 3d 48 72 d0 1e 	vpsrld $0x1e,%zmm8,%zmm8
   62356:	62 73 35 48 25 c7 36 	vpternlogd $0x36,%zmm7,%zmm9,%zmm8
   6235d:	62 d1 15 48 72 ca 18 	vprold $0x18,%zmm10,%zmm13
   62364:	62 d1 0d 48 72 ca 10 	vprold $0x10,%zmm10,%zmm14
   6236b:	62 d1 05 48 72 ca 08 	vprold $0x8,%zmm10,%zmm15
   62372:	62 a1 7d 00 ef c0    	vpxord %xmm16,%xmm16,%xmm16
   62378:	c5 fc 46 c8          	kxnorw %k0,%k0,%k1
   6237c:	62 82 7d 49 90 04 8a 	vpgatherdd (%r10,%zmm9,4),%zmm16{%k1}
   62383:	c4 41 31 ef c9       	vpxor  %xmm9,%xmm9,%xmm9
   62388:	62 72 2d 48 36 c8    	vpermd %zmm0,%zmm10,%zmm9
   6238e:	62 d1 2d 48 72 d2 04 	vpsrld $0x4,%zmm10,%zmm10
   62395:	62 52 35 48 15 ca    	vprolvd %zmm10,%zmm9,%zmm9
   6239b:	c4 41 29 ef d2       	vpxor  %xmm10,%xmm10,%xmm10
   623a0:	c5 fc 46 c8          	kxnorw %k0,%k0,%k1
   623a4:	62 12 7d 49 90 14 9a 	vpgatherdd (%r10,%zmm11,4),%zmm10{%k1}
   623ab:	c4 41 21 ef db       	vpxor  %xmm11,%xmm11,%xmm11
   623b0:	62 72 15 48 36 d8    	vpermd %zmm0,%zmm13,%zmm11
   623b6:	62 d1 15 48 72 d5 04 	vpsrld $0x4,%zmm13,%zmm13
   623bd:	62 52 25 48 15 dd    	vprolvd %zmm13,%zmm11,%zmm11
   623c3:	c4 41 11 ef ed       	vpxor  %xmm13,%xmm13,%xmm13
   623c8:	c5 fc 46 c8          	kxnorw %k0,%k0,%k1
   623cc:	62 12 7d 49 90 2c a2 	vpgatherdd (%r10,%zmm12,4),%zmm13{%k1}
   623d3:	c4 41 19 ef e4       	vpxor  %xmm12,%xmm12,%xmm12
   623d8:	62 72 0d 48 36 e0    	vpermd %zmm0,%zmm14,%zmm12
   623de:	62 d1 0d 48 72 d6 04 	vpsrld $0x4,%zmm14,%zmm14
   623e5:	62 52 1d 48 15 e6    	vprolvd %zmm14,%zmm12,%zmm12
   623eb:	c4 41 09 ef f6       	vpxor  %xmm14,%xmm14,%xmm14
   623f0:	c5 fc 46 c8          	kxnorw %k0,%k0,%k1
   623f4:	62 12 7d 49 90 34 82 	vpgatherdd (%r10,%zmm8,4),%zmm14{%k1}
   623fb:	c4 41 39 ef c0       	vpxor  %xmm8,%xmm8,%xmm8
   62400:	62 72 05 48 36 c0    	vpermd %zmm0,%zmm15,%zmm8
   62406:	62 d1 05 48 72 d7 04 	vpsrld $0x4,%zmm15,%zmm15
   6240d:	62 52 3d 48 15 c7    	vprolvd %zmm15,%zmm8,%zmm8
   62413:	62 51 7d 40 db f9    	vpandd %zmm9,%zmm16,%zmm15
   62419:	62 d1 05 48 76 c9    	vpcmpeqd %zmm9,%zmm15,%k1
   6241f:	62 51 2d 48 db cb    	vpandd %zmm11,%zmm10,%zmm9
   62425:	62 d1 35 49 76 cb    	vpcmpeqd %zmm11,%zmm9,%k1{%k1}
   6242b:	62 51 15 48 db cc    	vpandd %zmm12,%zmm13,%zmm9
   62431:	62 d1 35 49 76 cc    	vpcmpeqd %zmm12,%zmm9,%k1{%k1}
   62437:	62 51 0d 48 db c8    	vpandd %zmm8,%zmm14,%zmm9
   6243d:	62 d1 35 49 76 c0    	vpcmpeqd %zmm8,%zmm9,%k0{%k1}
   62443:	62 72 7e 48 38 c0    	vpmovm2d %k0,%zmm8
   62449:	62 d1 3d 48 72 d0 1f 	vpsrld $0x1f,%zmm8,%zmm8
   62450:	62 31 fe 48 7f 04 89 	vmovdqu64 %zmm8,(%rcx,%r9,4)
   62457:	49 8d 79 10          	lea    0x10(%r9),%rdi
   6245b:	49 83 c1 20          	add    $0x20,%r9
   6245f:	49 39 d1             	cmp    %rdx,%r9
   62462:	49 89 f9             	mov    %rdi,%r9
   62465:	0f 87 e2 01 00 00    	ja     6264d <compare_benchmark::lookup+0x8fd>
   6246b:	49 8d 41 50          	lea    0x50(%r9),%rax
   6246f:	48 39 d0             	cmp    %rdx,%rax
   62472:	0f 87 88 fe ff ff    	ja     62300 <compare_benchmark::lookup+0x5b0>
   62478:	49 8d 79 40          	lea    0x40(%r9),%rdi
   6247c:	48 39 d7             	cmp    %rdx,%rdi
   6247f:	0f 83 ce 03 00 00    	jae    62853 <compare_benchmark::lookup+0xb03>
   62485:	43 8b 84 cf 04 02 00 	mov    0x204(%r15,%r9,8),%eax
   6248c:	00 
   6248d:	44 21 c0             	and    %r8d,%eax
   62490:	41 0f 18 0c 82       	prefetcht0 (%r10,%rax,4)
   62495:	49 8d 79 41          	lea    0x41(%r9),%rdi
   62499:	48 39 d7             	cmp    %rdx,%rdi
   6249c:	0f 83 b1 03 00 00    	jae    62853 <compare_benchmark::lookup+0xb03>
   624a2:	43 8b 84 cf 0c 02 00 	mov    0x20c(%r15,%r9,8),%eax
   624a9:	00 
   624aa:	44 21 c0             	and    %r8d,%eax
   624ad:	41 0f 18 0c 82       	prefetcht0 (%r10,%rax,4)
   624b2:	49 8d 79 42          	lea    0x42(%r9),%rdi
   624b6:	48 39 d7             	cmp    %rdx,%rdi
   624b9:	0f 83 94 03 00 00    	jae    62853 <compare_benchmark::lookup+0xb03>
   624bf:	43 8b 84 cf 14 02 00 	mov    0x214(%r15,%r9,8),%eax
   624c6:	00 
   624c7:	44 21 c0             	and    %r8d,%eax
   624ca:	41 0f 18 0c 82       	prefetcht0 (%r10,%rax,4)
   624cf:	49 8d 79 43          	lea    0x43(%r9),%rdi
   624d3:	48 39 d7             	cmp    %rdx,%rdi
   624d6:	0f 83 77 03 00 00    	jae    62853 <compare_benchmark::lookup+0xb03>
   624dc:	43 8b 84 cf 1c 02 00 	mov    0x21c(%r15,%r9,8),%eax
   624e3:	00 
   624e4:	44 21 c0             	and    %r8d,%eax
   624e7:	41 0f 18 0c 82       	prefetcht0 (%r10,%rax,4)
   624ec:	49 8d 79 44          	lea    0x44(%r9),%rdi
   624f0:	48 39 d7             	cmp    %rdx,%rdi
   624f3:	0f 83 5a 03 00 00    	jae    62853 <compare_benchmark::lookup+0xb03>
   624f9:	43 8b 84 cf 24 02 00 	mov    0x224(%r15,%r9,8),%eax
   62500:	00 
   62501:	44 21 c0             	and    %r8d,%eax
   62504:	41 0f 18 0c 82       	prefetcht0 (%r10,%rax,4)
   62509:	49 8d 79 45          	lea    0x45(%r9),%rdi
   6250d:	48 39 d7             	cmp    %rdx,%rdi
   62510:	0f 83 3d 03 00 00    	jae    62853 <compare_benchmark::lookup+0xb03>
   62516:	43 8b 84 cf 2c 02 00 	mov    0x22c(%r15,%r9,8),%eax
   6251d:	00 
   6251e:	44 21 c0             	and    %r8d,%eax
   62521:	41 0f 18 0c 82       	prefetcht0 (%r10,%rax,4)
   62526:	49 8d 79 46          	lea    0x46(%r9),%rdi
   6252a:	48 39 d7             	cmp    %rdx,%rdi
   6252d:	0f 83 20 03 00 00    	jae    62853 <compare_benchmark::lookup+0xb03>
   62533:	43 8b 84 cf 34 02 00 	mov    0x234(%r15,%r9,8),%eax
   6253a:	00 
   6253b:	44 21 c0             	and    %r8d,%eax
   6253e:	41 0f 18 0c 82       	prefetcht0 (%r10,%rax,4)
   62543:	49 8d 79 47          	lea    0x47(%r9),%rdi
   62547:	48 39 d7             	cmp    %rdx,%rdi
   6254a:	0f 83 03 03 00 00    	jae    62853 <compare_benchmark::lookup+0xb03>
   62550:	43 8b 84 cf 3c 02 00 	mov    0x23c(%r15,%r9,8),%eax
   62557:	00 
   62558:	44 21 c0             	and    %r8d,%eax
   6255b:	41 0f 18 0c 82       	prefetcht0 (%r10,%rax,4)
   62560:	49 8d 79 48          	lea    0x48(%r9),%rdi
   62564:	48 39 d7             	cmp    %rdx,%rdi
   62567:	0f 83 e6 02 00 00    	jae    62853 <compare_benchmark::lookup+0xb03>
   6256d:	43 8b 84 cf 44 02 00 	mov    0x244(%r15,%r9,8),%eax
   62574:	00 
   62575:	44 21 c0             	and    %r8d,%eax
   62578:	41 0f 18 0c 82       	prefetcht0 (%r10,%rax,4)
   6257d:	49 8d 79 49          	lea    0x49(%r9),%rdi
   62581:	48 39 d7             	cmp    %rdx,%rdi
   62584:	0f 83 c9 02 00 00    	jae    62853 <compare_benchmark::lookup+0xb03>
   6258a:	43 8b 84 cf 4c 02 00 	mov    0x24c(%r15,%r9,8),%eax
   62591:	00 
   62592:	44 21 c0             	and    %r8d,%eax
   62595:	41 0f 18 0c 82       	prefetcht0 (%r10,%rax,4)
   6259a:	49 8d 79 4a          	lea    0x4a(%r9),%rdi
   6259e:	48 39 d7             	cmp    %rdx,%rdi
   625a1:	0f 83 ac 02 00 00    	jae    62853 <compare_benchmark::lookup+0xb03>
   625a7:	43 8b 84 cf 54 02 00 	mov    0x254(%r15,%r9,8),%eax
   625ae:	00 
   625af:	44 21 c0             	and    %r8d,%eax
   625b2:	41 0f 18 0c 82       	prefetcht0 (%r10,%rax,4)
   625b7:	49 8d 79 4b          	lea    0x4b(%r9),%rdi
   625bb:	48 39 d7             	cmp    %rdx,%rdi
   625be:	0f 83 8f 02 00 00    	jae    62853 <compare_benchmark::lookup+0xb03>
   625c4:	43 8b 84 cf 5c 02 00 	mov    0x25c(%r15,%r9,8),%eax
   625cb:	00 
   625cc:	44 21 c0             	and    %r8d,%eax
   625cf:	41 0f 18 0c 82       	prefetcht0 (%r10,%rax,4)
   625d4:	49 8d 79 4c          	lea    0x4c(%r9),%rdi
   625d8:	48 39 d7             	cmp    %rdx,%rdi
   625db:	0f 83 72 02 00 00    	jae    62853 <compare_benchmark::lookup+0xb03>
   625e1:	43 8b 84 cf 64 02 00 	mov    0x264(%r15,%r9,8),%eax
   625e8:	00 
   625e9:	44 21 c0             	and    %r8d,%eax
   625ec:	41 0f 18 0c 82       	prefetcht0 (%r10,%rax,4)
   625f1:	49 8d 79 4d          	lea    0x4d(%r9),%rdi
   625f5:	48 39 d7             	cmp    %rdx,%rdi
   625f8:	0f 83 55 02 00 00    	jae    62853 <compare_benchmark::lookup+0xb03>
   625fe:	43 8b 84 cf 6c 02 00 	mov    0x26c(%r15,%r9,8),%eax
   62605:	00 
   62606:	44 21 c0             	and    %r8d,%eax
   62609:	41 0f 18 0c 82       	prefetcht0 (%r10,%rax,4)
   6260e:	49 8d 79 4e          	lea    0x4e(%r9),%rdi
   62612:	48 39 d7             	cmp    %rdx,%rdi
   62615:	0f 83 38 02 00 00    	jae    62853 <compare_benchmark::lookup+0xb03>
   6261b:	43 8b 84 cf 74 02 00 	mov    0x274(%r15,%r9,8),%eax
   62622:	00 
   62623:	44 21 c0             	and    %r8d,%eax
   62626:	41 0f 18 0c 82       	prefetcht0 (%r10,%rax,4)
   6262b:	49 8d 79 4f          	lea    0x4f(%r9),%rdi
   6262f:	48 39 d7             	cmp    %rdx,%rdi
   62632:	0f 83 1b 02 00 00    	jae    62853 <compare_benchmark::lookup+0xb03>
   62638:	43 8b 84 cf 7c 02 00 	mov    0x27c(%r15,%r9,8),%eax
   6263f:	00 
   62640:	44 21 c0             	and    %r8d,%eax
   62643:	41 0f 18 0c 82       	prefetcht0 (%r10,%rax,4)
   62648:	e9 b3 fc ff ff       	jmp    62300 <compare_benchmark::lookup+0x5b0>
   6264d:	48 39 d7             	cmp    %rdx,%rdi
   62650:	0f 83 a5 01 00 00    	jae    627fb <compare_benchmark::lookup+0xaab>
   62656:	29 fa                	sub    %edi,%edx
   62658:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   6265d:	c4 e2 69 f7 d0       	shlx   %edx,%eax,%edx
   62662:	0f b7 c2             	movzwl %dx,%eax
   62665:	f7 d2                	not    %edx
   62667:	c5 fb 92 ca          	kmovd  %edx,%k1
   6266b:	62 d1 fe c9 6f 14 ff 	vmovdqu64 (%r15,%rdi,8),%zmm2{%k1}{z}
   62672:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
   62676:	c5 e1 ef db          	vpxor  %xmm3,%xmm3,%xmm3
   6267a:	3d ff fe 00 00       	cmp    $0xfeff,%eax
   6267f:	77 14                	ja     62695 <compare_benchmark::lookup+0x945>
   62681:	49 8d 04 ff          	lea    (%r15,%rdi,8),%rax
   62685:	89 d6                	mov    %edx,%esi
   62687:	c1 ee 08             	shr    $0x8,%esi
   6268a:	c5 fb 92 ce          	kmovd  %esi,%k1
   6268e:	62 f1 fe c9 6f 58 01 	vmovdqu64 0x40(%rax),%zmm3{%k1}{z}
   62695:	62 f1 fd 48 6f 25 e1 	vmovdqa64 -0x58e1f(%rip),%zmm4        # 9880 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x6a0>
   6269c:	71 fa ff 
   6269f:	62 f2 6d 48 76 e3    	vpermi2d %zmm3,%zmm2,%zmm4
   626a5:	62 f1 fd 48 6f 2d 11 	vmovdqa64 -0x58def(%rip),%zmm5        # 98c0 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x6e0>
   626ac:	72 fa ff 
   626af:	62 f2 6d 48 76 eb    	vpermi2d %zmm3,%zmm2,%zmm5
   626b5:	62 d2 7d 48 7c d0    	vpbroadcastd %r8d,%zmm2
   626bb:	62 f1 55 48 db d2    	vpandd %zmm2,%zmm5,%zmm2
   626c1:	62 f1 65 48 72 d5 1a 	vpsrld $0x1a,%zmm5,%zmm3
   626c8:	62 f2 7d 48 58 35 96 	vpbroadcastd -0x59e6a(%rip),%zmm6        # 8868 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x153>
   626cf:	61 fa ff 
   626d2:	62 f1 65 48 db de    	vpandd %zmm6,%zmm3,%zmm3
   626d8:	62 f3 6d 58 25 1d 51 	vpternlogd $0x36,-0x59eaf(%rip){1to16},%zmm2,%zmm3        # 8834 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x11f>
   626df:	61 fa ff 36 
   626e3:	62 f1 45 48 72 d5 1c 	vpsrld $0x1c,%zmm5,%zmm7
   626ea:	62 f1 45 48 db f6    	vpandd %zmm6,%zmm7,%zmm6
   626f0:	62 f3 6d 58 25 35 99 	vpternlogd $0x36,-0x59e67(%rip){1to16},%zmm2,%zmm6        # 8894 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x17f>
   626f7:	61 fa ff 36 
   626fb:	62 f1 55 48 72 d5 1e 	vpsrld $0x1e,%zmm5,%zmm5
   62702:	c5 fb 92 ca          	kmovd  %edx,%k1
   62706:	c5 c1 ef ff          	vpxor  %xmm7,%xmm7,%xmm7
   6270a:	c4 e1 f8 90 d1       	kmovq  %k1,%k2
   6270f:	62 d2 7d 4a 90 3c 92 	vpgatherdd (%r10,%zmm2,4),%zmm7{%k2}
   62716:	62 f3 6d 58 25 2d 1f 	vpternlogd $0x36,-0x59ee1(%rip){1to16},%zmm2,%zmm5        # 8840 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x12b>
   6271d:	61 fa ff 36 
   62721:	62 f1 6d 48 72 cc 18 	vprold $0x18,%zmm4,%zmm2
   62728:	62 f1 3d 48 72 cc 10 	vprold $0x10,%zmm4,%zmm8
   6272f:	c4 41 31 ef c9       	vpxor  %xmm9,%xmm9,%xmm9
   62734:	c4 e1 f8 90 d1       	kmovq  %k1,%k2
   62739:	62 52 7d 4a 90 0c 9a 	vpgatherdd (%r10,%zmm3,4),%zmm9{%k2}
   62740:	62 f1 65 48 72 cc 08 	vprold $0x8,%zmm4,%zmm3
   62747:	62 72 5d 48 36 d0    	vpermd %zmm0,%zmm4,%zmm10
   6274d:	62 f1 5d 48 72 d4 04 	vpsrld $0x4,%zmm4,%zmm4
   62754:	62 f2 2d 48 15 e4    	vprolvd %zmm4,%zmm10,%zmm4
   6275a:	c4 41 29 ef d2       	vpxor  %xmm10,%xmm10,%xmm10
   6275f:	c4 e1 f8 90 d1       	kmovq  %k1,%k2
   62764:	62 52 7d 4a 90 14 b2 	vpgatherdd (%r10,%zmm6,4),%zmm10{%k2}
   6276b:	c5 c9 ef f6          	vpxor  %xmm6,%xmm6,%xmm6
   6276f:	62 f2 6d 48 36 f0    	vpermd %zmm0,%zmm2,%zmm6
   62775:	62 f1 6d 48 72 d2 04 	vpsrld $0x4,%zmm2,%zmm2
   6277c:	62 f2 4d 48 15 d2    	vprolvd %zmm2,%zmm6,%zmm2
   62782:	c5 c9 ef f6          	vpxor  %xmm6,%xmm6,%xmm6
   62786:	62 f2 3d 48 36 f0    	vpermd %zmm0,%zmm8,%zmm6
   6278c:	62 d1 3d 48 72 d0 04 	vpsrld $0x4,%zmm8,%zmm8
   62793:	62 d2 7d 49 90 0c aa 	vpgatherdd (%r10,%zmm5,4),%zmm1{%k1}
   6279a:	62 d2 4d 48 15 e8    	vprolvd %zmm8,%zmm6,%zmm5
   627a0:	62 f2 65 48 36 c0    	vpermd %zmm0,%zmm3,%zmm0
   627a6:	62 f1 65 48 72 d3 04 	vpsrld $0x4,%zmm3,%zmm3
   627ad:	62 f2 7d 48 15 c3    	vprolvd %zmm3,%zmm0,%zmm0
   627b3:	62 f1 45 48 db dc    	vpandd %zmm4,%zmm7,%zmm3
   627b9:	62 f1 65 48 76 cc    	vpcmpeqd %zmm4,%zmm3,%k1
   627bf:	62 f1 35 48 db da    	vpandd %zmm2,%zmm9,%zmm3
   627c5:	62 f1 65 49 76 ca    	vpcmpeqd %zmm2,%zmm3,%k1{%k1}
   627cb:	62 f1 2d 48 db d5    	vpandd %zmm5,%zmm10,%zmm2
   627d1:	62 f1 6d 49 76 cd    	vpcmpeqd %zmm5,%zmm2,%k1{%k1}
   627d7:	62 f1 75 48 db c8    	vpandd %zmm0,%zmm1,%zmm1
   627dd:	62 f1 75 49 76 c0    	vpcmpeqd %zmm0,%zmm1,%k0{%k1}
   627e3:	62 f2 7e 48 38 c0    	vpmovm2d %k0,%zmm0
   627e9:	62 f1 7d 48 72 d0 1f 	vpsrld $0x1f,%zmm0,%zmm0
   627f0:	c5 fb 92 ca          	kmovd  %edx,%k1
   627f4:	62 f1 7e 49 7f 04 b9 	vmovdqu32 %zmm0,(%rcx,%rdi,4){%k1}
   627fb:	48 83 c4 68          	add    $0x68,%rsp
   627ff:	5b                   	pop    %rbx
   62800:	41 5c                	pop    %r12
   62802:	41 5d                	pop    %r13
   62804:	41 5e                	pop    %r14
   62806:	41 5f                	pop    %r15
   62808:	5d                   	pop    %rbp
   62809:	c5 f8 77             	vzeroupper
   6280c:	c3                   	ret
   6280d:	48 8d 05 ac 21 05 00 	lea    0x521ac(%rip),%rax        # b49c0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0x1f0>
   62814:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
   62819:	48 c7 44 24 40 01 00 	movq   $0x1,0x40(%rsp)
   62820:	00 00 
   62822:	48 c7 44 24 48 08 00 	movq   $0x8,0x48(%rsp)
   62829:	00 00 
   6282b:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
   6282f:	c5 f8 11 44 24 50    	vmovups %xmm0,0x50(%rsp)
   62835:	4c 8d 05 94 21 05 00 	lea    0x52194(%rip),%r8        # b49d0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0x200>
   6283c:	48 8d 74 24 28       	lea    0x28(%rsp),%rsi
   62841:	48 8d 54 24 30       	lea    0x30(%rsp),%rdx
   62846:	48 8d 4c 24 38       	lea    0x38(%rsp),%rcx
   6284b:	31 ff                	xor    %edi,%edi
   6284d:	ff 15 9d 5f 05 00    	call   *0x55f9d(%rip)        # b87f0 <_DYNAMIC+0x3d8>
   62853:	48 8d 15 4e 22 05 00 	lea    0x5224e(%rip),%rdx        # b4aa8 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0x2d8>
   6285a:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
   6285f:	c5 f8 77             	vzeroupper
   62862:	ff 15 10 5e 05 00    	call   *0x55e10(%rip)        # b8678 <_DYNAMIC+0x260>
   62868:	4d 89 fe             	mov    %r15,%r14
   6286b:	48 8d 15 4e 22 05 00 	lea    0x5224e(%rip),%rdx        # b4ac0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0x2f0>
   62872:	4c 89 f7             	mov    %r14,%rdi
   62875:	ff 15 fd 5d 05 00    	call   *0x55dfd(%rip)        # b8678 <_DYNAMIC+0x260>
   6287b:	4c 89 c6             	mov    %r8,%rsi
   6287e:	49 89 fe             	mov    %rdi,%r14
   62881:	48 8d 15 38 22 05 00 	lea    0x52238(%rip),%rdx        # b4ac0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0x2f0>
   62888:	4c 89 f7             	mov    %r14,%rdi
   6288b:	ff 15 e7 5d 05 00    	call   *0x55de7(%rip)        # b8678 <_DYNAMIC+0x260>
   62891:	4c 89 c6             	mov    %r8,%rsi
   62894:	49 89 ee             	mov    %rbp,%r14
   62897:	48 8d 15 22 22 05 00 	lea    0x52222(%rip),%rdx        # b4ac0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0x2f0>
   6289e:	4c 89 f7             	mov    %r14,%rdi
   628a1:	ff 15 d1 5d 05 00    	call   *0x55dd1(%rip)        # b8678 <_DYNAMIC+0x260>
   628a7:	4c 89 c6             	mov    %r8,%rsi
   628aa:	48 8d 15 0f 22 05 00 	lea    0x5220f(%rip),%rdx        # b4ac0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0x2f0>
   628b1:	4c 89 f7             	mov    %r14,%rdi
   628b4:	ff 15 be 5d 05 00    	call   *0x55dbe(%rip)        # b8678 <_DYNAMIC+0x260>
   628ba:	cc                   	int3
   628bb:	cc                   	int3
   628bc:	cc                   	int3
   628bd:	cc                   	int3
   628be:	cc                   	int3
   628bf:	cc                   	int3

