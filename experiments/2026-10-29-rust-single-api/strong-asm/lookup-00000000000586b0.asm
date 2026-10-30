00000000000586b0 <compare_benchmark::lookup>:
   586b0:	55                   	push   %rbp
   586b1:	41 57                	push   %r15
   586b3:	41 56                	push   %r14
   586b5:	41 55                	push   %r13
   586b7:	41 54                	push   %r12
   586b9:	53                   	push   %rbx
   586ba:	48 83 ec 68          	sub    $0x68,%rsp
   586be:	48 89 54 24 28       	mov    %rdx,0x28(%rsp)
   586c3:	4c 89 44 24 30       	mov    %r8,0x30(%rsp)
   586c8:	4c 39 c2             	cmp    %r8,%rdx
   586cb:	0f 85 9c 0a 00 00    	jne    5916d <compare_benchmark::lookup+0xabd>
   586d1:	49 89 f7             	mov    %rsi,%r15
   586d4:	48 83 fa 04          	cmp    $0x4,%rdx
   586d8:	48 89 54 24 10       	mov    %rdx,0x10(%rsp)
   586dd:	72 37                	jb     58716 <compare_benchmark::lookup+0x66>
   586df:	80 7f 1c 00          	cmpb   $0x0,0x1c(%rdi)
   586e3:	74 31                	je     58716 <compare_benchmark::lookup+0x66>
   586e5:	48 81 7f 10 00 80 00 	cmpq   $0x8000,0x10(%rdi)
   586ec:	00 
   586ed:	0f 86 b1 01 00 00    	jbe    588a4 <compare_benchmark::lookup+0x1f4>
   586f3:	62 f1 fd 48 6f 05 83 	vmovdqa64 -0x4f07d(%rip),%zmm0        # 9680 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x850>
   586fa:	0f fb ff 
   586fd:	48 83 fa 0f          	cmp    $0xf,%rdx
   58701:	0f 87 03 05 00 00    	ja     58c0a <compare_benchmark::lookup+0x55a>
   58707:	4c 8b 57 08          	mov    0x8(%rdi),%r10
   5870b:	44 8b 47 18          	mov    0x18(%rdi),%r8d
   5870f:	31 ff                	xor    %edi,%edi
   58711:	e9 a0 08 00 00       	jmp    58fb6 <compare_benchmark::lookup+0x906>
   58716:	48 85 d2             	test   %rdx,%rdx
   58719:	0f 84 3c 0a 00 00    	je     5915b <compare_benchmark::lookup+0xaab>
   5871f:	8b 47 18             	mov    0x18(%rdi),%eax
   58722:	89 44 24 0c          	mov    %eax,0xc(%rsp)
   58726:	48 8b 47 08          	mov    0x8(%rdi),%rax
   5872a:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
   5872f:	4c 8b 47 10          	mov    0x10(%rdi),%r8
   58733:	31 db                	xor    %ebx,%ebx
   58735:	4c 89 7c 24 18       	mov    %r15,0x18(%rsp)
   5873a:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
   5873f:	90                   	nop
   58740:	4d 8b 0c df          	mov    (%r15,%rbx,8),%r9
   58744:	4d 89 cd             	mov    %r9,%r13
   58747:	49 c1 ed 20          	shr    $0x20,%r13
   5874b:	8b 44 24 0c          	mov    0xc(%rsp),%eax
   5874f:	44 21 e8             	and    %r13d,%eax
   58752:	41 89 c6             	mov    %eax,%r14d
   58755:	41 c1 ee 04          	shr    $0x4,%r14d
   58759:	4d 39 c6             	cmp    %r8,%r14
   5875c:	0f 83 a5 0a 00 00    	jae    59207 <compare_benchmark::lookup+0xb57>
   58762:	89 c5                	mov    %eax,%ebp
   58764:	c1 ed 04             	shr    $0x4,%ebp
   58767:	4c 39 c5             	cmp    %r8,%rbp
   5876a:	0f 83 81 0a 00 00    	jae    591f1 <compare_benchmark::lookup+0xb41>
   58770:	4d 89 ca             	mov    %r9,%r10
   58773:	49 c1 ea 3c          	shr    $0x3c,%r10
   58777:	41 83 e2 03          	and    $0x3,%r10d
   5877b:	41 83 ca 08          	or     $0x8,%r10d
   5877f:	41 31 c2             	xor    %eax,%r10d
   58782:	44 89 d7             	mov    %r10d,%edi
   58785:	c1 ef 04             	shr    $0x4,%edi
   58788:	4c 39 c7             	cmp    %r8,%rdi
   5878b:	0f 83 4a 0a 00 00    	jae    591db <compare_benchmark::lookup+0xb2b>
   58791:	4d 89 cc             	mov    %r9,%r12
   58794:	49 c1 ec 3e          	shr    $0x3e,%r12
   58798:	41 83 cc 0c          	or     $0xc,%r12d
   5879c:	41 31 c4             	xor    %eax,%r12d
   5879f:	45 89 e7             	mov    %r12d,%r15d
   587a2:	41 c1 ef 04          	shr    $0x4,%r15d
   587a6:	4c 89 c6             	mov    %r8,%rsi
   587a9:	4d 39 c7             	cmp    %r8,%r15
   587ac:	0f 83 16 0a 00 00    	jae    591c8 <compare_benchmark::lookup+0xb18>
   587b2:	48 89 ca             	mov    %rcx,%rdx
   587b5:	45 89 d2             	mov    %r10d,%r10d
   587b8:	48 c1 e7 06          	shl    $0x6,%rdi
   587bc:	4c 01 df             	add    %r11,%rdi
   587bf:	41 83 e2 0f          	and    $0xf,%r10d
   587c3:	46 8b 14 97          	mov    (%rdi,%r10,4),%r10d
   587c7:	44 89 cf             	mov    %r9d,%edi
   587ca:	c1 ef 06             	shr    $0x6,%edi
   587cd:	83 e7 3c             	and    $0x3c,%edi
   587d0:	4c 8d 05 a9 0e fb ff 	lea    -0x4f157(%rip),%r8        # 9680 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x850>
   587d7:	42 8b 3c 07          	mov    (%rdi,%r8,1),%edi
   587db:	41 c1 ed 1a          	shr    $0x1a,%r13d
   587df:	41 83 e5 03          	and    $0x3,%r13d
   587e3:	41 83 cd 04          	or     $0x4,%r13d
   587e7:	41 31 c5             	xor    %eax,%r13d
   587ea:	48 c1 e5 06          	shl    $0x6,%rbp
   587ee:	4c 01 dd             	add    %r11,%rbp
   587f1:	41 83 e5 0f          	and    $0xf,%r13d
   587f5:	42 8b 6c ad 00       	mov    0x0(%rbp,%r13,4),%ebp
   587fa:	45 89 cd             	mov    %r9d,%r13d
   587fd:	41 83 e5 0f          	and    $0xf,%r13d
   58801:	47 8b 2c a8          	mov    (%r8,%r13,4),%r13d
   58805:	49 c1 e6 06          	shl    $0x6,%r14
   58809:	4d 01 de             	add    %r11,%r14
   5880c:	83 e0 0f             	and    $0xf,%eax
   5880f:	41 8b 04 86          	mov    (%r14,%rax,4),%eax
   58813:	44 89 c9             	mov    %r9d,%ecx
   58816:	c1 e9 04             	shr    $0x4,%ecx
   58819:	41 d3 c5             	rol    %cl,%r13d
   5881c:	c4 c2 78 f2 c5       	andn   %r13d,%eax,%eax
   58821:	44 89 c9             	mov    %r9d,%ecx
   58824:	c1 e9 0c             	shr    $0xc,%ecx
   58827:	d3 c7                	rol    %cl,%edi
   58829:	c4 e2 50 f2 ef       	andn   %edi,%ebp,%ebp
   5882e:	44 89 c9             	mov    %r9d,%ecx
   58831:	c1 e9 0e             	shr    $0xe,%ecx
   58834:	83 e1 3c             	and    $0x3c,%ecx
   58837:	46 8b 2c 01          	mov    (%rcx,%r8,1),%r13d
   5883b:	09 c5                	or     %eax,%ebp
   5883d:	c4 c3 7b f0 f9 18    	rorx   $0x18,%r9d,%edi
   58843:	41 c1 e9 14          	shr    $0x14,%r9d
   58847:	44 89 c9             	mov    %r9d,%ecx
   5884a:	41 d3 c5             	rol    %cl,%r13d
   5884d:	c4 c2 28 f2 c5       	andn   %r13d,%r10d,%eax
   58852:	09 e8                	or     %ebp,%eax
   58854:	44 89 e1             	mov    %r12d,%ecx
   58857:	49 c1 e7 06          	shl    $0x6,%r15
   5885b:	4d 01 df             	add    %r11,%r15
   5885e:	83 e1 0f             	and    $0xf,%ecx
   58861:	45 8b 0c 8f          	mov    (%r15,%rcx,4),%r9d
   58865:	89 f9                	mov    %edi,%ecx
   58867:	83 e1 0f             	and    $0xf,%ecx
   5886a:	45 8b 14 88          	mov    (%r8,%rcx,4),%r10d
   5886e:	c1 ef 04             	shr    $0x4,%edi
   58871:	89 f9                	mov    %edi,%ecx
   58873:	41 d3 c2             	rol    %cl,%r10d
   58876:	c4 c2 30 f2 ca       	andn   %r10d,%r9d,%ecx
   5887b:	31 ff                	xor    %edi,%edi
   5887d:	09 c1                	or     %eax,%ecx
   5887f:	40 0f 94 c7          	sete   %dil
   58883:	48 89 d1             	mov    %rdx,%rcx
   58886:	89 3c 9a             	mov    %edi,(%rdx,%rbx,4)
   58889:	48 ff c3             	inc    %rbx
   5888c:	48 39 5c 24 10       	cmp    %rbx,0x10(%rsp)
   58891:	4c 8b 7c 24 18       	mov    0x18(%rsp),%r15
   58896:	49 89 f0             	mov    %rsi,%r8
   58899:	0f 85 a1 fe ff ff    	jne    58740 <compare_benchmark::lookup+0x90>
   5889f:	e9 b7 08 00 00       	jmp    5915b <compare_benchmark::lookup+0xaab>
   588a4:	62 f1 fd 48 6f 05 d2 	vmovdqa64 -0x4f22e(%rip),%zmm0        # 9680 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x850>
   588ab:	0d fb ff 
   588ae:	4c 8b 4f 08          	mov    0x8(%rdi),%r9
   588b2:	8b 47 18             	mov    0x18(%rdi),%eax
   588b5:	62 f2 7d 48 7c c8    	vpbroadcastd %eax,%zmm1
   588bb:	31 ff                	xor    %edi,%edi
   588bd:	48 83 fa 10          	cmp    $0x10,%rdx
   588c1:	0f 82 bd 01 00 00    	jb     58a84 <compare_benchmark::lookup+0x3d4>
   588c7:	62 f1 fd 48 6f 15 ef 	vmovdqa64 -0x4f711(%rip),%zmm2        # 91c0 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x390>
   588ce:	08 fb ff 
   588d1:	62 f1 fd 48 6f 1d 25 	vmovdqa64 -0x4f6db(%rip),%zmm3        # 9200 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x3d0>
   588d8:	09 fb ff 
   588db:	62 f2 7d 48 58 25 eb 	vpbroadcastd -0x50415(%rip),%zmm4        # 84d0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x154>
   588e2:	fb fa ff 
   588e5:	62 f2 7d 48 58 2d a9 	vpbroadcastd -0x50457(%rip),%zmm5        # 8498 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x11c>
   588ec:	fb fa ff 
   588ef:	62 f2 7d 48 58 35 03 	vpbroadcastd -0x503fd(%rip),%zmm6        # 84fc <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x180>
   588f6:	fc fa ff 
   588f9:	62 f2 7d 48 58 3d a5 	vpbroadcastd -0x5045b(%rip),%zmm7        # 84a8 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x12c>
   58900:	fb fa ff 
   58903:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   5890a:	84 00 00 00 00 00 
   58910:	49 89 f8             	mov    %rdi,%r8
   58913:	62 51 fe 48 6f 04 ff 	vmovdqu64 (%r15,%rdi,8),%zmm8
   5891a:	62 51 fe 48 6f 4c ff 	vmovdqu64 0x40(%r15,%rdi,8),%zmm9
   58921:	01 
   58922:	62 51 fd 48 6f d0    	vmovdqa64 %zmm8,%zmm10
   58928:	62 52 6d 48 7e d1    	vpermt2d %zmm9,%zmm2,%zmm10
   5892e:	62 52 65 48 7e c1    	vpermt2d %zmm9,%zmm3,%zmm8
   58934:	62 71 3d 48 db c9    	vpandd %zmm1,%zmm8,%zmm9
   5893a:	62 d1 25 48 72 d0 1a 	vpsrld $0x1a,%zmm8,%zmm11
   58941:	62 71 25 48 db dc    	vpandd %zmm4,%zmm11,%zmm11
   58947:	62 73 35 48 25 dd 36 	vpternlogd $0x36,%zmm5,%zmm9,%zmm11
   5894e:	62 d1 1d 48 72 d0 1c 	vpsrld $0x1c,%zmm8,%zmm12
   58955:	62 71 1d 48 db e4    	vpandd %zmm4,%zmm12,%zmm12
   5895b:	62 73 35 48 25 e6 36 	vpternlogd $0x36,%zmm6,%zmm9,%zmm12
   58962:	62 d1 3d 48 72 d0 1e 	vpsrld $0x1e,%zmm8,%zmm8
   58969:	62 73 35 48 25 c7 36 	vpternlogd $0x36,%zmm7,%zmm9,%zmm8
   58970:	62 d1 15 48 72 ca 18 	vprold $0x18,%zmm10,%zmm13
   58977:	62 d1 0d 48 72 ca 10 	vprold $0x10,%zmm10,%zmm14
   5897e:	62 d1 05 48 72 ca 08 	vprold $0x8,%zmm10,%zmm15
   58985:	c5 fc 46 c8          	kxnorw %k0,%k0,%k1
   58989:	62 a1 7d 00 ef c0    	vpxord %xmm16,%xmm16,%xmm16
   5898f:	62 82 7d 49 90 04 89 	vpgatherdd (%r9,%zmm9,4),%zmm16{%k1}
   58996:	c4 41 31 ef c9       	vpxor  %xmm9,%xmm9,%xmm9
   5899b:	62 72 2d 48 36 c8    	vpermd %zmm0,%zmm10,%zmm9
   589a1:	62 d1 2d 48 72 d2 04 	vpsrld $0x4,%zmm10,%zmm10
   589a8:	62 52 35 48 15 ca    	vprolvd %zmm10,%zmm9,%zmm9
   589ae:	c5 fc 46 c8          	kxnorw %k0,%k0,%k1
   589b2:	c4 41 29 ef d2       	vpxor  %xmm10,%xmm10,%xmm10
   589b7:	62 12 7d 49 90 14 99 	vpgatherdd (%r9,%zmm11,4),%zmm10{%k1}
   589be:	c4 41 21 ef db       	vpxor  %xmm11,%xmm11,%xmm11
   589c3:	62 72 15 48 36 d8    	vpermd %zmm0,%zmm13,%zmm11
   589c9:	62 d1 15 48 72 d5 04 	vpsrld $0x4,%zmm13,%zmm13
   589d0:	62 52 25 48 15 dd    	vprolvd %zmm13,%zmm11,%zmm11
   589d6:	c5 fc 46 c8          	kxnorw %k0,%k0,%k1
   589da:	c4 41 11 ef ed       	vpxor  %xmm13,%xmm13,%xmm13
   589df:	62 12 7d 49 90 2c a1 	vpgatherdd (%r9,%zmm12,4),%zmm13{%k1}
   589e6:	c4 41 19 ef e4       	vpxor  %xmm12,%xmm12,%xmm12
   589eb:	62 72 0d 48 36 e0    	vpermd %zmm0,%zmm14,%zmm12
   589f1:	62 d1 0d 48 72 d6 04 	vpsrld $0x4,%zmm14,%zmm14
   589f8:	62 52 1d 48 15 e6    	vprolvd %zmm14,%zmm12,%zmm12
   589fe:	c5 fc 46 c8          	kxnorw %k0,%k0,%k1
   58a02:	c4 41 09 ef f6       	vpxor  %xmm14,%xmm14,%xmm14
   58a07:	62 12 7d 49 90 34 81 	vpgatherdd (%r9,%zmm8,4),%zmm14{%k1}
   58a0e:	c4 41 39 ef c0       	vpxor  %xmm8,%xmm8,%xmm8
   58a13:	62 72 05 48 36 c0    	vpermd %zmm0,%zmm15,%zmm8
   58a19:	62 d1 05 48 72 d7 04 	vpsrld $0x4,%zmm15,%zmm15
   58a20:	62 52 3d 48 15 c7    	vprolvd %zmm15,%zmm8,%zmm8
   58a26:	62 51 7d 40 db f9    	vpandd %zmm9,%zmm16,%zmm15
   58a2c:	62 d1 05 48 76 c9    	vpcmpeqd %zmm9,%zmm15,%k1
   58a32:	62 51 2d 48 db cb    	vpandd %zmm11,%zmm10,%zmm9
   58a38:	62 d1 35 49 76 cb    	vpcmpeqd %zmm11,%zmm9,%k1{%k1}
   58a3e:	62 51 15 48 db cc    	vpandd %zmm12,%zmm13,%zmm9
   58a44:	62 d1 35 49 76 cc    	vpcmpeqd %zmm12,%zmm9,%k1{%k1}
   58a4a:	62 51 0d 48 db c8    	vpandd %zmm8,%zmm14,%zmm9
   58a50:	62 d1 35 49 76 c0    	vpcmpeqd %zmm8,%zmm9,%k0{%k1}
   58a56:	62 72 7e 48 38 c0    	vpmovm2d %k0,%zmm8
   58a5c:	62 d1 3d 48 72 d0 1f 	vpsrld $0x1f,%zmm8,%zmm8
   58a63:	62 71 fe 48 7f 04 b9 	vmovdqu64 %zmm8,(%rcx,%rdi,4)
   58a6a:	48 83 c7 10          	add    $0x10,%rdi
   58a6e:	49 83 c0 20          	add    $0x20,%r8
   58a72:	49 39 d0             	cmp    %rdx,%r8
   58a75:	0f 86 95 fe ff ff    	jbe    58910 <compare_benchmark::lookup+0x260>
   58a7b:	48 39 d7             	cmp    %rdx,%rdi
   58a7e:	0f 83 d7 06 00 00    	jae    5915b <compare_benchmark::lookup+0xaab>
   58a84:	29 fa                	sub    %edi,%edx
   58a86:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   58a8b:	c4 e2 69 f7 d0       	shlx   %edx,%eax,%edx
   58a90:	0f b7 c2             	movzwl %dx,%eax
   58a93:	f7 d2                	not    %edx
   58a95:	c5 fb 92 ca          	kmovd  %edx,%k1
   58a99:	62 d1 fe c9 6f 1c ff 	vmovdqu64 (%r15,%rdi,8),%zmm3{%k1}{z}
   58aa0:	c5 e9 ef d2          	vpxor  %xmm2,%xmm2,%xmm2
   58aa4:	c5 d9 ef e4          	vpxor  %xmm4,%xmm4,%xmm4
   58aa8:	3d ff fe 00 00       	cmp    $0xfeff,%eax
   58aad:	77 14                	ja     58ac3 <compare_benchmark::lookup+0x413>
   58aaf:	49 8d 04 ff          	lea    (%r15,%rdi,8),%rax
   58ab3:	89 d6                	mov    %edx,%esi
   58ab5:	c1 ee 08             	shr    $0x8,%esi
   58ab8:	c5 fb 92 ce          	kmovd  %esi,%k1
   58abc:	62 f1 fe c9 6f 60 01 	vmovdqu64 0x40(%rax),%zmm4{%k1}{z}
   58ac3:	62 f1 fd 48 6f 2d f3 	vmovdqa64 -0x4f90d(%rip),%zmm5        # 91c0 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x390>
   58aca:	06 fb ff 
   58acd:	62 f2 65 48 76 ec    	vpermi2d %zmm4,%zmm3,%zmm5
   58ad3:	62 f1 fd 48 6f 35 23 	vmovdqa64 -0x4f8dd(%rip),%zmm6        # 9200 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x3d0>
   58ada:	07 fb ff 
   58add:	62 f2 65 48 76 f4    	vpermi2d %zmm4,%zmm3,%zmm6
   58ae3:	62 f1 4d 48 db c9    	vpandd %zmm1,%zmm6,%zmm1
   58ae9:	62 f1 65 48 72 d6 1a 	vpsrld $0x1a,%zmm6,%zmm3
   58af0:	62 f2 7d 48 58 25 d6 	vpbroadcastd -0x5062a(%rip),%zmm4        # 84d0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x154>
   58af7:	f9 fa ff 
   58afa:	62 f1 65 48 db dc    	vpandd %zmm4,%zmm3,%zmm3
   58b00:	62 f3 75 58 25 1d 8d 	vpternlogd $0x36,-0x50673(%rip){1to16},%zmm1,%zmm3        # 8498 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x11c>
   58b07:	f9 fa ff 36 
   58b0b:	62 f1 45 48 72 d6 1c 	vpsrld $0x1c,%zmm6,%zmm7
   58b12:	62 f1 45 48 db e4    	vpandd %zmm4,%zmm7,%zmm4
   58b18:	62 f3 75 58 25 25 d9 	vpternlogd $0x36,-0x50627(%rip){1to16},%zmm1,%zmm4        # 84fc <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x180>
   58b1f:	f9 fa ff 36 
   58b23:	62 f1 4d 48 72 d6 1e 	vpsrld $0x1e,%zmm6,%zmm6
   58b2a:	c5 fb 92 ca          	kmovd  %edx,%k1
   58b2e:	c5 c1 ef ff          	vpxor  %xmm7,%xmm7,%xmm7
   58b32:	c4 e1 f8 90 d1       	kmovq  %k1,%k2
   58b37:	62 d2 7d 4a 90 3c 89 	vpgatherdd (%r9,%zmm1,4),%zmm7{%k2}
   58b3e:	62 f3 75 58 25 35 5f 	vpternlogd $0x36,-0x506a1(%rip){1to16},%zmm1,%zmm6        # 84a8 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x12c>
   58b45:	f9 fa ff 36 
   58b49:	62 f1 75 48 72 cd 18 	vprold $0x18,%zmm5,%zmm1
   58b50:	62 f1 3d 48 72 cd 10 	vprold $0x10,%zmm5,%zmm8
   58b57:	c4 41 31 ef c9       	vpxor  %xmm9,%xmm9,%xmm9
   58b5c:	c4 e1 f8 90 d1       	kmovq  %k1,%k2
   58b61:	62 52 7d 4a 90 0c 99 	vpgatherdd (%r9,%zmm3,4),%zmm9{%k2}
   58b68:	62 f1 65 48 72 cd 08 	vprold $0x8,%zmm5,%zmm3
   58b6f:	62 72 55 48 36 d0    	vpermd %zmm0,%zmm5,%zmm10
   58b75:	62 f1 55 48 72 d5 04 	vpsrld $0x4,%zmm5,%zmm5
   58b7c:	62 f2 2d 48 15 ed    	vprolvd %zmm5,%zmm10,%zmm5
   58b82:	c4 41 29 ef d2       	vpxor  %xmm10,%xmm10,%xmm10
   58b87:	c4 e1 f8 90 d1       	kmovq  %k1,%k2
   58b8c:	62 52 7d 4a 90 14 a1 	vpgatherdd (%r9,%zmm4,4),%zmm10{%k2}
   58b93:	c5 d9 ef e4          	vpxor  %xmm4,%xmm4,%xmm4
   58b97:	62 f2 75 48 36 e0    	vpermd %zmm0,%zmm1,%zmm4
   58b9d:	62 f1 75 48 72 d1 04 	vpsrld $0x4,%zmm1,%zmm1
   58ba4:	62 f2 5d 48 15 c9    	vprolvd %zmm1,%zmm4,%zmm1
   58baa:	c5 d9 ef e4          	vpxor  %xmm4,%xmm4,%xmm4
   58bae:	62 f2 3d 48 36 e0    	vpermd %zmm0,%zmm8,%zmm4
   58bb4:	62 d1 3d 48 72 d0 04 	vpsrld $0x4,%zmm8,%zmm8
   58bbb:	62 d2 7d 49 90 14 b1 	vpgatherdd (%r9,%zmm6,4),%zmm2{%k1}
   58bc2:	62 d2 5d 48 15 e0    	vprolvd %zmm8,%zmm4,%zmm4
   58bc8:	62 f2 65 48 36 c0    	vpermd %zmm0,%zmm3,%zmm0
   58bce:	62 f1 65 48 72 d3 04 	vpsrld $0x4,%zmm3,%zmm3
   58bd5:	62 f2 7d 48 15 c3    	vprolvd %zmm3,%zmm0,%zmm0
   58bdb:	62 f1 45 48 db dd    	vpandd %zmm5,%zmm7,%zmm3
   58be1:	62 f1 65 48 76 cd    	vpcmpeqd %zmm5,%zmm3,%k1
   58be7:	62 f1 35 48 db d9    	vpandd %zmm1,%zmm9,%zmm3
   58bed:	62 f1 65 49 76 c9    	vpcmpeqd %zmm1,%zmm3,%k1{%k1}
   58bf3:	62 f1 2d 48 db cc    	vpandd %zmm4,%zmm10,%zmm1
   58bf9:	62 f1 75 49 76 cc    	vpcmpeqd %zmm4,%zmm1,%k1{%k1}
   58bff:	62 f1 6d 48 db c8    	vpandd %zmm0,%zmm2,%zmm1
   58c05:	e9 33 05 00 00       	jmp    5913d <compare_benchmark::lookup+0xa8d>
   58c0a:	44 8b 47 18          	mov    0x18(%rdi),%r8d
   58c0e:	4c 8b 57 08          	mov    0x8(%rdi),%r10
   58c12:	62 d2 7d 48 7c c8    	vpbroadcastd %r8d,%zmm1
   58c18:	45 31 c9             	xor    %r9d,%r9d
   58c1b:	62 f1 fd 48 6f 15 9b 	vmovdqa64 -0x4fa65(%rip),%zmm2        # 91c0 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x390>
   58c22:	05 fb ff 
   58c25:	62 f1 fd 48 6f 1d d1 	vmovdqa64 -0x4fa2f(%rip),%zmm3        # 9200 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x3d0>
   58c2c:	05 fb ff 
   58c2f:	62 f2 7d 48 58 25 97 	vpbroadcastd -0x50769(%rip),%zmm4        # 84d0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x154>
   58c36:	f8 fa ff 
   58c39:	62 f2 7d 48 58 2d 55 	vpbroadcastd -0x507ab(%rip),%zmm5        # 8498 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x11c>
   58c40:	f8 fa ff 
   58c43:	62 f2 7d 48 58 35 af 	vpbroadcastd -0x50751(%rip),%zmm6        # 84fc <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x180>
   58c4a:	f8 fa ff 
   58c4d:	62 f2 7d 48 58 3d 51 	vpbroadcastd -0x507af(%rip),%zmm7        # 84a8 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x12c>
   58c54:	f8 fa ff 
   58c57:	e9 6f 01 00 00       	jmp    58dcb <compare_benchmark::lookup+0x71b>
   58c5c:	0f 1f 40 00          	nopl   0x0(%rax)
   58c60:	62 11 fe 48 6f 04 cf 	vmovdqu64 (%r15,%r9,8),%zmm8
   58c67:	62 11 fe 48 6f 4c cf 	vmovdqu64 0x40(%r15,%r9,8),%zmm9
   58c6e:	01 
   58c6f:	62 51 fd 48 6f d0    	vmovdqa64 %zmm8,%zmm10
   58c75:	62 52 6d 48 7e d1    	vpermt2d %zmm9,%zmm2,%zmm10
   58c7b:	62 52 65 48 7e c1    	vpermt2d %zmm9,%zmm3,%zmm8
   58c81:	62 71 3d 48 db c9    	vpandd %zmm1,%zmm8,%zmm9
   58c87:	62 d1 25 48 72 d0 1a 	vpsrld $0x1a,%zmm8,%zmm11
   58c8e:	62 71 25 48 db dc    	vpandd %zmm4,%zmm11,%zmm11
   58c94:	62 73 35 48 25 dd 36 	vpternlogd $0x36,%zmm5,%zmm9,%zmm11
   58c9b:	62 d1 1d 48 72 d0 1c 	vpsrld $0x1c,%zmm8,%zmm12
   58ca2:	62 71 1d 48 db e4    	vpandd %zmm4,%zmm12,%zmm12
   58ca8:	62 73 35 48 25 e6 36 	vpternlogd $0x36,%zmm6,%zmm9,%zmm12
   58caf:	62 d1 3d 48 72 d0 1e 	vpsrld $0x1e,%zmm8,%zmm8
   58cb6:	62 73 35 48 25 c7 36 	vpternlogd $0x36,%zmm7,%zmm9,%zmm8
   58cbd:	62 d1 15 48 72 ca 18 	vprold $0x18,%zmm10,%zmm13
   58cc4:	62 d1 0d 48 72 ca 10 	vprold $0x10,%zmm10,%zmm14
   58ccb:	62 d1 05 48 72 ca 08 	vprold $0x8,%zmm10,%zmm15
   58cd2:	62 a1 7d 00 ef c0    	vpxord %xmm16,%xmm16,%xmm16
   58cd8:	c5 fc 46 c8          	kxnorw %k0,%k0,%k1
   58cdc:	62 82 7d 49 90 04 8a 	vpgatherdd (%r10,%zmm9,4),%zmm16{%k1}
   58ce3:	c4 41 31 ef c9       	vpxor  %xmm9,%xmm9,%xmm9
   58ce8:	62 72 2d 48 36 c8    	vpermd %zmm0,%zmm10,%zmm9
   58cee:	62 d1 2d 48 72 d2 04 	vpsrld $0x4,%zmm10,%zmm10
   58cf5:	62 52 35 48 15 ca    	vprolvd %zmm10,%zmm9,%zmm9
   58cfb:	c4 41 29 ef d2       	vpxor  %xmm10,%xmm10,%xmm10
   58d00:	c5 fc 46 c8          	kxnorw %k0,%k0,%k1
   58d04:	62 12 7d 49 90 14 9a 	vpgatherdd (%r10,%zmm11,4),%zmm10{%k1}
   58d0b:	c4 41 21 ef db       	vpxor  %xmm11,%xmm11,%xmm11
   58d10:	62 72 15 48 36 d8    	vpermd %zmm0,%zmm13,%zmm11
   58d16:	62 d1 15 48 72 d5 04 	vpsrld $0x4,%zmm13,%zmm13
   58d1d:	62 52 25 48 15 dd    	vprolvd %zmm13,%zmm11,%zmm11
   58d23:	c4 41 11 ef ed       	vpxor  %xmm13,%xmm13,%xmm13
   58d28:	c5 fc 46 c8          	kxnorw %k0,%k0,%k1
   58d2c:	62 12 7d 49 90 2c a2 	vpgatherdd (%r10,%zmm12,4),%zmm13{%k1}
   58d33:	c4 41 19 ef e4       	vpxor  %xmm12,%xmm12,%xmm12
   58d38:	62 72 0d 48 36 e0    	vpermd %zmm0,%zmm14,%zmm12
   58d3e:	62 d1 0d 48 72 d6 04 	vpsrld $0x4,%zmm14,%zmm14
   58d45:	62 52 1d 48 15 e6    	vprolvd %zmm14,%zmm12,%zmm12
   58d4b:	c4 41 09 ef f6       	vpxor  %xmm14,%xmm14,%xmm14
   58d50:	c5 fc 46 c8          	kxnorw %k0,%k0,%k1
   58d54:	62 12 7d 49 90 34 82 	vpgatherdd (%r10,%zmm8,4),%zmm14{%k1}
   58d5b:	c4 41 39 ef c0       	vpxor  %xmm8,%xmm8,%xmm8
   58d60:	62 72 05 48 36 c0    	vpermd %zmm0,%zmm15,%zmm8
   58d66:	62 d1 05 48 72 d7 04 	vpsrld $0x4,%zmm15,%zmm15
   58d6d:	62 52 3d 48 15 c7    	vprolvd %zmm15,%zmm8,%zmm8
   58d73:	62 51 7d 40 db f9    	vpandd %zmm9,%zmm16,%zmm15
   58d79:	62 d1 05 48 76 c9    	vpcmpeqd %zmm9,%zmm15,%k1
   58d7f:	62 51 2d 48 db cb    	vpandd %zmm11,%zmm10,%zmm9
   58d85:	62 d1 35 49 76 cb    	vpcmpeqd %zmm11,%zmm9,%k1{%k1}
   58d8b:	62 51 15 48 db cc    	vpandd %zmm12,%zmm13,%zmm9
   58d91:	62 d1 35 49 76 cc    	vpcmpeqd %zmm12,%zmm9,%k1{%k1}
   58d97:	62 51 0d 48 db c8    	vpandd %zmm8,%zmm14,%zmm9
   58d9d:	62 d1 35 49 76 c0    	vpcmpeqd %zmm8,%zmm9,%k0{%k1}
   58da3:	62 72 7e 48 38 c0    	vpmovm2d %k0,%zmm8
   58da9:	62 d1 3d 48 72 d0 1f 	vpsrld $0x1f,%zmm8,%zmm8
   58db0:	62 31 fe 48 7f 04 89 	vmovdqu64 %zmm8,(%rcx,%r9,4)
   58db7:	49 8d 79 10          	lea    0x10(%r9),%rdi
   58dbb:	49 83 c1 20          	add    $0x20,%r9
   58dbf:	49 39 d1             	cmp    %rdx,%r9
   58dc2:	49 89 f9             	mov    %rdi,%r9
   58dc5:	0f 87 e2 01 00 00    	ja     58fad <compare_benchmark::lookup+0x8fd>
   58dcb:	49 8d 41 50          	lea    0x50(%r9),%rax
   58dcf:	48 39 d0             	cmp    %rdx,%rax
   58dd2:	0f 87 88 fe ff ff    	ja     58c60 <compare_benchmark::lookup+0x5b0>
   58dd8:	49 8d 79 40          	lea    0x40(%r9),%rdi
   58ddc:	48 39 d7             	cmp    %rdx,%rdi
   58ddf:	0f 83 ce 03 00 00    	jae    591b3 <compare_benchmark::lookup+0xb03>
   58de5:	43 8b 84 cf 04 02 00 	mov    0x204(%r15,%r9,8),%eax
   58dec:	00 
   58ded:	44 21 c0             	and    %r8d,%eax
   58df0:	41 0f 18 0c 82       	prefetcht0 (%r10,%rax,4)
   58df5:	49 8d 79 41          	lea    0x41(%r9),%rdi
   58df9:	48 39 d7             	cmp    %rdx,%rdi
   58dfc:	0f 83 b1 03 00 00    	jae    591b3 <compare_benchmark::lookup+0xb03>
   58e02:	43 8b 84 cf 0c 02 00 	mov    0x20c(%r15,%r9,8),%eax
   58e09:	00 
   58e0a:	44 21 c0             	and    %r8d,%eax
   58e0d:	41 0f 18 0c 82       	prefetcht0 (%r10,%rax,4)
   58e12:	49 8d 79 42          	lea    0x42(%r9),%rdi
   58e16:	48 39 d7             	cmp    %rdx,%rdi
   58e19:	0f 83 94 03 00 00    	jae    591b3 <compare_benchmark::lookup+0xb03>
   58e1f:	43 8b 84 cf 14 02 00 	mov    0x214(%r15,%r9,8),%eax
   58e26:	00 
   58e27:	44 21 c0             	and    %r8d,%eax
   58e2a:	41 0f 18 0c 82       	prefetcht0 (%r10,%rax,4)
   58e2f:	49 8d 79 43          	lea    0x43(%r9),%rdi
   58e33:	48 39 d7             	cmp    %rdx,%rdi
   58e36:	0f 83 77 03 00 00    	jae    591b3 <compare_benchmark::lookup+0xb03>
   58e3c:	43 8b 84 cf 1c 02 00 	mov    0x21c(%r15,%r9,8),%eax
   58e43:	00 
   58e44:	44 21 c0             	and    %r8d,%eax
   58e47:	41 0f 18 0c 82       	prefetcht0 (%r10,%rax,4)
   58e4c:	49 8d 79 44          	lea    0x44(%r9),%rdi
   58e50:	48 39 d7             	cmp    %rdx,%rdi
   58e53:	0f 83 5a 03 00 00    	jae    591b3 <compare_benchmark::lookup+0xb03>
   58e59:	43 8b 84 cf 24 02 00 	mov    0x224(%r15,%r9,8),%eax
   58e60:	00 
   58e61:	44 21 c0             	and    %r8d,%eax
   58e64:	41 0f 18 0c 82       	prefetcht0 (%r10,%rax,4)
   58e69:	49 8d 79 45          	lea    0x45(%r9),%rdi
   58e6d:	48 39 d7             	cmp    %rdx,%rdi
   58e70:	0f 83 3d 03 00 00    	jae    591b3 <compare_benchmark::lookup+0xb03>
   58e76:	43 8b 84 cf 2c 02 00 	mov    0x22c(%r15,%r9,8),%eax
   58e7d:	00 
   58e7e:	44 21 c0             	and    %r8d,%eax
   58e81:	41 0f 18 0c 82       	prefetcht0 (%r10,%rax,4)
   58e86:	49 8d 79 46          	lea    0x46(%r9),%rdi
   58e8a:	48 39 d7             	cmp    %rdx,%rdi
   58e8d:	0f 83 20 03 00 00    	jae    591b3 <compare_benchmark::lookup+0xb03>
   58e93:	43 8b 84 cf 34 02 00 	mov    0x234(%r15,%r9,8),%eax
   58e9a:	00 
   58e9b:	44 21 c0             	and    %r8d,%eax
   58e9e:	41 0f 18 0c 82       	prefetcht0 (%r10,%rax,4)
   58ea3:	49 8d 79 47          	lea    0x47(%r9),%rdi
   58ea7:	48 39 d7             	cmp    %rdx,%rdi
   58eaa:	0f 83 03 03 00 00    	jae    591b3 <compare_benchmark::lookup+0xb03>
   58eb0:	43 8b 84 cf 3c 02 00 	mov    0x23c(%r15,%r9,8),%eax
   58eb7:	00 
   58eb8:	44 21 c0             	and    %r8d,%eax
   58ebb:	41 0f 18 0c 82       	prefetcht0 (%r10,%rax,4)
   58ec0:	49 8d 79 48          	lea    0x48(%r9),%rdi
   58ec4:	48 39 d7             	cmp    %rdx,%rdi
   58ec7:	0f 83 e6 02 00 00    	jae    591b3 <compare_benchmark::lookup+0xb03>
   58ecd:	43 8b 84 cf 44 02 00 	mov    0x244(%r15,%r9,8),%eax
   58ed4:	00 
   58ed5:	44 21 c0             	and    %r8d,%eax
   58ed8:	41 0f 18 0c 82       	prefetcht0 (%r10,%rax,4)
   58edd:	49 8d 79 49          	lea    0x49(%r9),%rdi
   58ee1:	48 39 d7             	cmp    %rdx,%rdi
   58ee4:	0f 83 c9 02 00 00    	jae    591b3 <compare_benchmark::lookup+0xb03>
   58eea:	43 8b 84 cf 4c 02 00 	mov    0x24c(%r15,%r9,8),%eax
   58ef1:	00 
   58ef2:	44 21 c0             	and    %r8d,%eax
   58ef5:	41 0f 18 0c 82       	prefetcht0 (%r10,%rax,4)
   58efa:	49 8d 79 4a          	lea    0x4a(%r9),%rdi
   58efe:	48 39 d7             	cmp    %rdx,%rdi
   58f01:	0f 83 ac 02 00 00    	jae    591b3 <compare_benchmark::lookup+0xb03>
   58f07:	43 8b 84 cf 54 02 00 	mov    0x254(%r15,%r9,8),%eax
   58f0e:	00 
   58f0f:	44 21 c0             	and    %r8d,%eax
   58f12:	41 0f 18 0c 82       	prefetcht0 (%r10,%rax,4)
   58f17:	49 8d 79 4b          	lea    0x4b(%r9),%rdi
   58f1b:	48 39 d7             	cmp    %rdx,%rdi
   58f1e:	0f 83 8f 02 00 00    	jae    591b3 <compare_benchmark::lookup+0xb03>
   58f24:	43 8b 84 cf 5c 02 00 	mov    0x25c(%r15,%r9,8),%eax
   58f2b:	00 
   58f2c:	44 21 c0             	and    %r8d,%eax
   58f2f:	41 0f 18 0c 82       	prefetcht0 (%r10,%rax,4)
   58f34:	49 8d 79 4c          	lea    0x4c(%r9),%rdi
   58f38:	48 39 d7             	cmp    %rdx,%rdi
   58f3b:	0f 83 72 02 00 00    	jae    591b3 <compare_benchmark::lookup+0xb03>
   58f41:	43 8b 84 cf 64 02 00 	mov    0x264(%r15,%r9,8),%eax
   58f48:	00 
   58f49:	44 21 c0             	and    %r8d,%eax
   58f4c:	41 0f 18 0c 82       	prefetcht0 (%r10,%rax,4)
   58f51:	49 8d 79 4d          	lea    0x4d(%r9),%rdi
   58f55:	48 39 d7             	cmp    %rdx,%rdi
   58f58:	0f 83 55 02 00 00    	jae    591b3 <compare_benchmark::lookup+0xb03>
   58f5e:	43 8b 84 cf 6c 02 00 	mov    0x26c(%r15,%r9,8),%eax
   58f65:	00 
   58f66:	44 21 c0             	and    %r8d,%eax
   58f69:	41 0f 18 0c 82       	prefetcht0 (%r10,%rax,4)
   58f6e:	49 8d 79 4e          	lea    0x4e(%r9),%rdi
   58f72:	48 39 d7             	cmp    %rdx,%rdi
   58f75:	0f 83 38 02 00 00    	jae    591b3 <compare_benchmark::lookup+0xb03>
   58f7b:	43 8b 84 cf 74 02 00 	mov    0x274(%r15,%r9,8),%eax
   58f82:	00 
   58f83:	44 21 c0             	and    %r8d,%eax
   58f86:	41 0f 18 0c 82       	prefetcht0 (%r10,%rax,4)
   58f8b:	49 8d 79 4f          	lea    0x4f(%r9),%rdi
   58f8f:	48 39 d7             	cmp    %rdx,%rdi
   58f92:	0f 83 1b 02 00 00    	jae    591b3 <compare_benchmark::lookup+0xb03>
   58f98:	43 8b 84 cf 7c 02 00 	mov    0x27c(%r15,%r9,8),%eax
   58f9f:	00 
   58fa0:	44 21 c0             	and    %r8d,%eax
   58fa3:	41 0f 18 0c 82       	prefetcht0 (%r10,%rax,4)
   58fa8:	e9 b3 fc ff ff       	jmp    58c60 <compare_benchmark::lookup+0x5b0>
   58fad:	48 39 d7             	cmp    %rdx,%rdi
   58fb0:	0f 83 a5 01 00 00    	jae    5915b <compare_benchmark::lookup+0xaab>
   58fb6:	29 fa                	sub    %edi,%edx
   58fb8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   58fbd:	c4 e2 69 f7 d0       	shlx   %edx,%eax,%edx
   58fc2:	0f b7 c2             	movzwl %dx,%eax
   58fc5:	f7 d2                	not    %edx
   58fc7:	c5 fb 92 ca          	kmovd  %edx,%k1
   58fcb:	62 d1 fe c9 6f 14 ff 	vmovdqu64 (%r15,%rdi,8),%zmm2{%k1}{z}
   58fd2:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
   58fd6:	c5 e1 ef db          	vpxor  %xmm3,%xmm3,%xmm3
   58fda:	3d ff fe 00 00       	cmp    $0xfeff,%eax
   58fdf:	77 14                	ja     58ff5 <compare_benchmark::lookup+0x945>
   58fe1:	49 8d 04 ff          	lea    (%r15,%rdi,8),%rax
   58fe5:	89 d6                	mov    %edx,%esi
   58fe7:	c1 ee 08             	shr    $0x8,%esi
   58fea:	c5 fb 92 ce          	kmovd  %esi,%k1
   58fee:	62 f1 fe c9 6f 58 01 	vmovdqu64 0x40(%rax),%zmm3{%k1}{z}
   58ff5:	62 f1 fd 48 6f 25 c1 	vmovdqa64 -0x4fe3f(%rip),%zmm4        # 91c0 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x390>
   58ffc:	01 fb ff 
   58fff:	62 f2 6d 48 76 e3    	vpermi2d %zmm3,%zmm2,%zmm4
   59005:	62 f1 fd 48 6f 2d f1 	vmovdqa64 -0x4fe0f(%rip),%zmm5        # 9200 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x3d0>
   5900c:	01 fb ff 
   5900f:	62 f2 6d 48 76 eb    	vpermi2d %zmm3,%zmm2,%zmm5
   59015:	62 d2 7d 48 7c d0    	vpbroadcastd %r8d,%zmm2
   5901b:	62 f1 55 48 db d2    	vpandd %zmm2,%zmm5,%zmm2
   59021:	62 f1 65 48 72 d5 1a 	vpsrld $0x1a,%zmm5,%zmm3
   59028:	62 f2 7d 48 58 35 9e 	vpbroadcastd -0x50b62(%rip),%zmm6        # 84d0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x154>
   5902f:	f4 fa ff 
   59032:	62 f1 65 48 db de    	vpandd %zmm6,%zmm3,%zmm3
   59038:	62 f3 6d 58 25 1d 55 	vpternlogd $0x36,-0x50bab(%rip){1to16},%zmm2,%zmm3        # 8498 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x11c>
   5903f:	f4 fa ff 36 
   59043:	62 f1 45 48 72 d5 1c 	vpsrld $0x1c,%zmm5,%zmm7
   5904a:	62 f1 45 48 db f6    	vpandd %zmm6,%zmm7,%zmm6
   59050:	62 f3 6d 58 25 35 a1 	vpternlogd $0x36,-0x50b5f(%rip){1to16},%zmm2,%zmm6        # 84fc <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x180>
   59057:	f4 fa ff 36 
   5905b:	62 f1 55 48 72 d5 1e 	vpsrld $0x1e,%zmm5,%zmm5
   59062:	c5 fb 92 ca          	kmovd  %edx,%k1
   59066:	c5 c1 ef ff          	vpxor  %xmm7,%xmm7,%xmm7
   5906a:	c4 e1 f8 90 d1       	kmovq  %k1,%k2
   5906f:	62 d2 7d 4a 90 3c 92 	vpgatherdd (%r10,%zmm2,4),%zmm7{%k2}
   59076:	62 f3 6d 58 25 2d 27 	vpternlogd $0x36,-0x50bd9(%rip){1to16},%zmm2,%zmm5        # 84a8 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x12c>
   5907d:	f4 fa ff 36 
   59081:	62 f1 6d 48 72 cc 18 	vprold $0x18,%zmm4,%zmm2
   59088:	62 f1 3d 48 72 cc 10 	vprold $0x10,%zmm4,%zmm8
   5908f:	c4 41 31 ef c9       	vpxor  %xmm9,%xmm9,%xmm9
   59094:	c4 e1 f8 90 d1       	kmovq  %k1,%k2
   59099:	62 52 7d 4a 90 0c 9a 	vpgatherdd (%r10,%zmm3,4),%zmm9{%k2}
   590a0:	62 f1 65 48 72 cc 08 	vprold $0x8,%zmm4,%zmm3
   590a7:	62 72 5d 48 36 d0    	vpermd %zmm0,%zmm4,%zmm10
   590ad:	62 f1 5d 48 72 d4 04 	vpsrld $0x4,%zmm4,%zmm4
   590b4:	62 f2 2d 48 15 e4    	vprolvd %zmm4,%zmm10,%zmm4
   590ba:	c4 41 29 ef d2       	vpxor  %xmm10,%xmm10,%xmm10
   590bf:	c4 e1 f8 90 d1       	kmovq  %k1,%k2
   590c4:	62 52 7d 4a 90 14 b2 	vpgatherdd (%r10,%zmm6,4),%zmm10{%k2}
   590cb:	c5 c9 ef f6          	vpxor  %xmm6,%xmm6,%xmm6
   590cf:	62 f2 6d 48 36 f0    	vpermd %zmm0,%zmm2,%zmm6
   590d5:	62 f1 6d 48 72 d2 04 	vpsrld $0x4,%zmm2,%zmm2
   590dc:	62 f2 4d 48 15 d2    	vprolvd %zmm2,%zmm6,%zmm2
   590e2:	c5 c9 ef f6          	vpxor  %xmm6,%xmm6,%xmm6
   590e6:	62 f2 3d 48 36 f0    	vpermd %zmm0,%zmm8,%zmm6
   590ec:	62 d1 3d 48 72 d0 04 	vpsrld $0x4,%zmm8,%zmm8
   590f3:	62 d2 7d 49 90 0c aa 	vpgatherdd (%r10,%zmm5,4),%zmm1{%k1}
   590fa:	62 d2 4d 48 15 e8    	vprolvd %zmm8,%zmm6,%zmm5
   59100:	62 f2 65 48 36 c0    	vpermd %zmm0,%zmm3,%zmm0
   59106:	62 f1 65 48 72 d3 04 	vpsrld $0x4,%zmm3,%zmm3
   5910d:	62 f2 7d 48 15 c3    	vprolvd %zmm3,%zmm0,%zmm0
   59113:	62 f1 45 48 db dc    	vpandd %zmm4,%zmm7,%zmm3
   59119:	62 f1 65 48 76 cc    	vpcmpeqd %zmm4,%zmm3,%k1
   5911f:	62 f1 35 48 db da    	vpandd %zmm2,%zmm9,%zmm3
   59125:	62 f1 65 49 76 ca    	vpcmpeqd %zmm2,%zmm3,%k1{%k1}
   5912b:	62 f1 2d 48 db d5    	vpandd %zmm5,%zmm10,%zmm2
   59131:	62 f1 6d 49 76 cd    	vpcmpeqd %zmm5,%zmm2,%k1{%k1}
   59137:	62 f1 75 48 db c8    	vpandd %zmm0,%zmm1,%zmm1
   5913d:	62 f1 75 49 76 c0    	vpcmpeqd %zmm0,%zmm1,%k0{%k1}
   59143:	62 f2 7e 48 38 c0    	vpmovm2d %k0,%zmm0
   59149:	62 f1 7d 48 72 d0 1f 	vpsrld $0x1f,%zmm0,%zmm0
   59150:	c5 fb 92 ca          	kmovd  %edx,%k1
   59154:	62 f1 7e 49 7f 04 b9 	vmovdqu32 %zmm0,(%rcx,%rdi,4){%k1}
   5915b:	48 83 c4 68          	add    $0x68,%rsp
   5915f:	5b                   	pop    %rbx
   59160:	41 5c                	pop    %r12
   59162:	41 5d                	pop    %r13
   59164:	41 5e                	pop    %r14
   59166:	41 5f                	pop    %r15
   59168:	5d                   	pop    %rbp
   59169:	c5 f8 77             	vzeroupper
   5916c:	c3                   	ret
   5916d:	48 8d 05 ac 27 05 00 	lea    0x527ac(%rip),%rax        # ab920 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0x1f0>
   59174:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
   59179:	48 c7 44 24 40 01 00 	movq   $0x1,0x40(%rsp)
   59180:	00 00 
   59182:	48 c7 44 24 48 08 00 	movq   $0x8,0x48(%rsp)
   59189:	00 00 
   5918b:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
   5918f:	c5 f8 11 44 24 50    	vmovups %xmm0,0x50(%rsp)
   59195:	4c 8d 05 94 27 05 00 	lea    0x52794(%rip),%r8        # ab930 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0x200>
   5919c:	48 8d 74 24 28       	lea    0x28(%rsp),%rsi
   591a1:	48 8d 54 24 30       	lea    0x30(%rsp),%rdx
   591a6:	48 8d 4c 24 38       	lea    0x38(%rsp),%rcx
   591ab:	31 ff                	xor    %edi,%edi
   591ad:	ff 15 85 63 05 00    	call   *0x56385(%rip)        # af538 <_DYNAMIC+0x3a8>
   591b3:	48 8d 15 d6 27 05 00 	lea    0x527d6(%rip),%rdx        # ab990 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0x260>
   591ba:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
   591bf:	c5 f8 77             	vzeroupper
   591c2:	ff 15 f8 61 05 00    	call   *0x561f8(%rip)        # af3c0 <_DYNAMIC+0x230>
   591c8:	4d 89 fe             	mov    %r15,%r14
   591cb:	48 8d 15 d6 27 05 00 	lea    0x527d6(%rip),%rdx        # ab9a8 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0x278>
   591d2:	4c 89 f7             	mov    %r14,%rdi
   591d5:	ff 15 e5 61 05 00    	call   *0x561e5(%rip)        # af3c0 <_DYNAMIC+0x230>
   591db:	4c 89 c6             	mov    %r8,%rsi
   591de:	49 89 fe             	mov    %rdi,%r14
   591e1:	48 8d 15 c0 27 05 00 	lea    0x527c0(%rip),%rdx        # ab9a8 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0x278>
   591e8:	4c 89 f7             	mov    %r14,%rdi
   591eb:	ff 15 cf 61 05 00    	call   *0x561cf(%rip)        # af3c0 <_DYNAMIC+0x230>
   591f1:	4c 89 c6             	mov    %r8,%rsi
   591f4:	49 89 ee             	mov    %rbp,%r14
   591f7:	48 8d 15 aa 27 05 00 	lea    0x527aa(%rip),%rdx        # ab9a8 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0x278>
   591fe:	4c 89 f7             	mov    %r14,%rdi
   59201:	ff 15 b9 61 05 00    	call   *0x561b9(%rip)        # af3c0 <_DYNAMIC+0x230>
   59207:	4c 89 c6             	mov    %r8,%rsi
   5920a:	48 8d 15 97 27 05 00 	lea    0x52797(%rip),%rdx        # ab9a8 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0x278>
   59211:	4c 89 f7             	mov    %r14,%rdi
   59214:	ff 15 a6 61 05 00    	call   *0x561a6(%rip)        # af3c0 <_DYNAMIC+0x230>
   5921a:	cc                   	int3
   5921b:	cc                   	int3
   5921c:	cc                   	int3
   5921d:	cc                   	int3
   5921e:	cc                   	int3
   5921f:	cc                   	int3

