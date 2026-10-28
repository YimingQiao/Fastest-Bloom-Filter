00000000000607b0 <compare_benchmark::lookup>:
   607b0:	55                   	push   %rbp
   607b1:	41 57                	push   %r15
   607b3:	41 56                	push   %r14
   607b5:	41 55                	push   %r13
   607b7:	41 54                	push   %r12
   607b9:	53                   	push   %rbx
   607ba:	48 83 ec 48          	sub    $0x48,%rsp
   607be:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
   607c3:	4c 89 44 24 10       	mov    %r8,0x10(%rsp)
   607c8:	4c 39 c2             	cmp    %r8,%rdx
   607cb:	0f 85 60 0e 00 00    	jne    61631 <compare_benchmark::lookup+0xe81>
   607d1:	48 89 c8             	mov    %rcx,%rax
   607d4:	48 83 fa 04          	cmp    $0x4,%rdx
   607d8:	0f 83 96 01 00 00    	jae    60974 <compare_benchmark::lookup+0x1c4>
   607de:	48 85 d2             	test   %rdx,%rdx
   607e1:	0f 84 38 0e 00 00    	je     6161f <compare_benchmark::lookup+0xe6f>
   607e7:	44 8b 57 20          	mov    0x20(%rdi),%r10d
   607eb:	4c 8b 47 10          	mov    0x10(%rdi),%r8
   607ef:	48 8b 1e             	mov    (%rsi),%rbx
   607f2:	49 89 de             	mov    %rbx,%r14
   607f5:	49 c1 ee 20          	shr    $0x20,%r14
   607f9:	45 21 d6             	and    %r10d,%r14d
   607fc:	45 89 f1             	mov    %r14d,%r9d
   607ff:	41 c1 e9 04          	shr    $0x4,%r9d
   60803:	4d 39 c1             	cmp    %r8,%r9
   60806:	0f 83 c1 0e 00 00    	jae    616cd <compare_benchmark::lookup+0xf1d>
   6080c:	4c 8b 5f 18          	mov    0x18(%rdi),%r11
   60810:	89 d9                	mov    %ebx,%ecx
   60812:	c1 e9 08             	shr    $0x8,%ecx
   60815:	83 e1 7c             	and    $0x7c,%ecx
   60818:	41 8b 2c 0b          	mov    (%r11,%rcx,1),%ebp
   6081c:	89 d9                	mov    %ebx,%ecx
   6081e:	c1 e9 0f             	shr    $0xf,%ecx
   60821:	d3 c5                	rol    %cl,%ebp
   60823:	48 8b 7f 08          	mov    0x8(%rdi),%rdi
   60827:	89 d9                	mov    %ebx,%ecx
   60829:	83 e1 1f             	and    $0x1f,%ecx
   6082c:	45 8b 3c 8b          	mov    (%r11,%rcx,4),%r15d
   60830:	89 d9                	mov    %ebx,%ecx
   60832:	c1 e9 05             	shr    $0x5,%ecx
   60835:	41 d3 c7             	rol    %cl,%r15d
   60838:	44 89 f1             	mov    %r14d,%ecx
   6083b:	83 e1 0f             	and    $0xf,%ecx
   6083e:	49 c1 e1 06          	shl    $0x6,%r9
   60842:	49 01 f9             	add    %rdi,%r9
   60845:	41 8b 0c 89          	mov    (%r9,%rcx,4),%ecx
   60849:	c4 c2 70 f2 cf       	andn   %r15d,%ecx,%ecx
   6084e:	c1 eb 14             	shr    $0x14,%ebx
   60851:	83 cb 08             	or     $0x8,%ebx
   60854:	44 31 f3             	xor    %r14d,%ebx
   60857:	83 e3 0f             	and    $0xf,%ebx
   6085a:	45 8b 0c 99          	mov    (%r9,%rbx,4),%r9d
   6085e:	c4 62 30 f2 cd       	andn   %ebp,%r9d,%r9d
   60863:	31 db                	xor    %ebx,%ebx
   60865:	41 09 c9             	or     %ecx,%r9d
   60868:	0f 94 c3             	sete   %bl
   6086b:	89 18                	mov    %ebx,(%rax)
   6086d:	48 83 fa 01          	cmp    $0x1,%rdx
   60871:	0f 84 a8 0d 00 00    	je     6161f <compare_benchmark::lookup+0xe6f>
   60877:	48 8b 5e 08          	mov    0x8(%rsi),%rbx
   6087b:	49 89 de             	mov    %rbx,%r14
   6087e:	49 c1 ee 20          	shr    $0x20,%r14
   60882:	45 21 d6             	and    %r10d,%r14d
   60885:	45 89 f1             	mov    %r14d,%r9d
   60888:	41 c1 e9 04          	shr    $0x4,%r9d
   6088c:	4d 39 c1             	cmp    %r8,%r9
   6088f:	0f 83 38 0e 00 00    	jae    616cd <compare_benchmark::lookup+0xf1d>
   60895:	89 d9                	mov    %ebx,%ecx
   60897:	c1 e9 08             	shr    $0x8,%ecx
   6089a:	83 e1 7c             	and    $0x7c,%ecx
   6089d:	41 8b 2c 0b          	mov    (%r11,%rcx,1),%ebp
   608a1:	89 d9                	mov    %ebx,%ecx
   608a3:	c1 e9 0f             	shr    $0xf,%ecx
   608a6:	d3 c5                	rol    %cl,%ebp
   608a8:	89 d9                	mov    %ebx,%ecx
   608aa:	83 e1 1f             	and    $0x1f,%ecx
   608ad:	45 8b 3c 8b          	mov    (%r11,%rcx,4),%r15d
   608b1:	89 d9                	mov    %ebx,%ecx
   608b3:	c1 e9 05             	shr    $0x5,%ecx
   608b6:	41 d3 c7             	rol    %cl,%r15d
   608b9:	44 89 f1             	mov    %r14d,%ecx
   608bc:	83 e1 0f             	and    $0xf,%ecx
   608bf:	49 c1 e1 06          	shl    $0x6,%r9
   608c3:	49 01 f9             	add    %rdi,%r9
   608c6:	41 8b 0c 89          	mov    (%r9,%rcx,4),%ecx
   608ca:	c4 c2 70 f2 cf       	andn   %r15d,%ecx,%ecx
   608cf:	c1 eb 14             	shr    $0x14,%ebx
   608d2:	83 cb 08             	or     $0x8,%ebx
   608d5:	44 31 f3             	xor    %r14d,%ebx
   608d8:	83 e3 0f             	and    $0xf,%ebx
   608db:	45 8b 0c 99          	mov    (%r9,%rbx,4),%r9d
   608df:	c4 62 30 f2 cd       	andn   %ebp,%r9d,%r9d
   608e4:	31 db                	xor    %ebx,%ebx
   608e6:	41 09 c9             	or     %ecx,%r9d
   608e9:	0f 94 c3             	sete   %bl
   608ec:	89 58 04             	mov    %ebx,0x4(%rax)
   608ef:	48 83 fa 02          	cmp    $0x2,%rdx
   608f3:	0f 84 26 0d 00 00    	je     6161f <compare_benchmark::lookup+0xe6f>
   608f9:	48 8b 56 10          	mov    0x10(%rsi),%rdx
   608fd:	48 89 d1             	mov    %rdx,%rcx
   60900:	48 c1 e9 20          	shr    $0x20,%rcx
   60904:	41 21 ca             	and    %ecx,%r10d
   60907:	45 89 d1             	mov    %r10d,%r9d
   6090a:	41 c1 e9 04          	shr    $0x4,%r9d
   6090e:	4d 39 c1             	cmp    %r8,%r9
   60911:	0f 83 b6 0d 00 00    	jae    616cd <compare_benchmark::lookup+0xf1d>
   60917:	89 d1                	mov    %edx,%ecx
   60919:	c1 e9 08             	shr    $0x8,%ecx
   6091c:	83 e1 7c             	and    $0x7c,%ecx
   6091f:	41 8b 34 0b          	mov    (%r11,%rcx,1),%esi
   60923:	89 d1                	mov    %edx,%ecx
   60925:	c1 e9 0f             	shr    $0xf,%ecx
   60928:	d3 c6                	rol    %cl,%esi
   6092a:	89 d1                	mov    %edx,%ecx
   6092c:	83 e1 1f             	and    $0x1f,%ecx
   6092f:	45 8b 04 8b          	mov    (%r11,%rcx,4),%r8d
   60933:	89 d1                	mov    %edx,%ecx
   60935:	c1 e9 05             	shr    $0x5,%ecx
   60938:	41 d3 c0             	rol    %cl,%r8d
   6093b:	44 89 d1             	mov    %r10d,%ecx
   6093e:	83 e1 0f             	and    $0xf,%ecx
   60941:	49 c1 e1 06          	shl    $0x6,%r9
   60945:	4c 01 cf             	add    %r9,%rdi
   60948:	8b 0c 8f             	mov    (%rdi,%rcx,4),%ecx
   6094b:	c4 c2 70 f2 c8       	andn   %r8d,%ecx,%ecx
   60950:	c1 ea 14             	shr    $0x14,%edx
   60953:	83 ca 08             	or     $0x8,%edx
   60956:	44 31 d2             	xor    %r10d,%edx
   60959:	83 e2 0f             	and    $0xf,%edx
   6095c:	8b 14 97             	mov    (%rdi,%rdx,4),%edx
   6095f:	c4 e2 68 f2 d6       	andn   %esi,%edx,%edx
   60964:	31 f6                	xor    %esi,%esi
   60966:	09 ca                	or     %ecx,%edx
   60968:	40 0f 94 c6          	sete   %sil
   6096c:	89 70 08             	mov    %esi,0x8(%rax)
   6096f:	e9 ab 0c 00 00       	jmp    6161f <compare_benchmark::lookup+0xe6f>
   60974:	80 7f 24 00          	cmpb   $0x0,0x24(%rdi)
   60978:	74 4f                	je     609c9 <compare_benchmark::lookup+0x219>
   6097a:	4c 8b 47 10          	mov    0x10(%rdi),%r8
   6097e:	49 81 f8 00 80 00 00 	cmp    $0x8000,%r8
   60985:	76 7a                	jbe    60a01 <compare_benchmark::lookup+0x251>
   60987:	4c 8b 57 08          	mov    0x8(%rdi),%r10
   6098b:	4c 8b 5f 18          	mov    0x18(%rdi),%r11
   6098f:	62 d1 fe 48 6f 03    	vmovdqu64 (%r11),%zmm0
   60995:	62 d1 fe 48 6f 4b 01 	vmovdqu64 0x40(%r11),%zmm1
   6099c:	48 83 fa 10          	cmp    $0x10,%rdx
   609a0:	0f 83 28 01 00 00    	jae    60ace <compare_benchmark::lookup+0x31e>
   609a6:	31 c9                	xor    %ecx,%ecx
   609a8:	48 89 cb             	mov    %rcx,%rbx
   609ab:	48 83 cb 08          	or     $0x8,%rbx
   609af:	48 39 d3             	cmp    %rdx,%rbx
   609b2:	0f 86 60 06 00 00    	jbe    61018 <compare_benchmark::lookup+0x868>
   609b8:	48 89 cb             	mov    %rcx,%rbx
   609bb:	48 39 d3             	cmp    %rdx,%rbx
   609be:	0f 82 e0 06 00 00    	jb     610a4 <compare_benchmark::lookup+0x8f4>
   609c4:	e9 56 0c 00 00       	jmp    6161f <compare_benchmark::lookup+0xe6f>
   609c9:	80 7f 25 00          	cmpb   $0x0,0x25(%rdi)
   609cd:	74 59                	je     60a28 <compare_benchmark::lookup+0x278>
   609cf:	48 8b 4f 10          	mov    0x10(%rdi),%rcx
   609d3:	48 89 0c 24          	mov    %rcx,(%rsp)
   609d7:	48 81 f9 00 80 00 00 	cmp    $0x8000,%rcx
   609de:	0f 86 cc 03 00 00    	jbe    60db0 <compare_benchmark::lookup+0x600>
   609e4:	4c 8b 5f 08          	mov    0x8(%rdi),%r11
   609e8:	8b 5f 20             	mov    0x20(%rdi),%ebx
   609eb:	48 83 fa 07          	cmp    $0x7,%rdx
   609ef:	0f 87 53 07 00 00    	ja     61148 <compare_benchmark::lookup+0x998>
   609f5:	4c 8b 77 18          	mov    0x18(%rdi),%r14
   609f9:	45 31 ff             	xor    %r15d,%r15d
   609fc:	e9 6c 0b 00 00       	jmp    6156d <compare_benchmark::lookup+0xdbd>
   60a01:	4c 8b 57 08          	mov    0x8(%rdi),%r10
   60a05:	4c 8b 5f 18          	mov    0x18(%rdi),%r11
   60a09:	62 d1 fe 48 6f 03    	vmovdqu64 (%r11),%zmm0
   60a0f:	62 d1 fe 48 6f 4b 01 	vmovdqu64 0x40(%r11),%zmm1
   60a16:	48 83 fa 10          	cmp    $0x10,%rdx
   60a1a:	0f 83 ad 03 00 00    	jae    60dcd <compare_benchmark::lookup+0x61d>
   60a20:	45 31 c9             	xor    %r9d,%r9d
   60a23:	e9 a6 04 00 00       	jmp    60ece <compare_benchmark::lookup+0x71e>
   60a28:	44 8b 4f 20          	mov    0x20(%rdi),%r9d
   60a2c:	4c 8b 57 08          	mov    0x8(%rdi),%r10
   60a30:	4c 8b 47 10          	mov    0x10(%rdi),%r8
   60a34:	4c 8b 5f 18          	mov    0x18(%rdi),%r11
   60a38:	31 db                	xor    %ebx,%ebx
   60a3a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
   60a40:	4c 8b 34 de          	mov    (%rsi,%rbx,8),%r14
   60a44:	4d 89 f7             	mov    %r14,%r15
   60a47:	49 c1 ef 20          	shr    $0x20,%r15
   60a4b:	45 21 cf             	and    %r9d,%r15d
   60a4e:	44 89 ff             	mov    %r15d,%edi
   60a51:	c1 ef 04             	shr    $0x4,%edi
   60a54:	4c 39 c7             	cmp    %r8,%rdi
   60a57:	0f 83 1a 0c 00 00    	jae    61677 <compare_benchmark::lookup+0xec7>
   60a5d:	44 89 f1             	mov    %r14d,%ecx
   60a60:	c1 e9 08             	shr    $0x8,%ecx
   60a63:	83 e1 7c             	and    $0x7c,%ecx
   60a66:	41 8b 2c 0b          	mov    (%r11,%rcx,1),%ebp
   60a6a:	44 89 f1             	mov    %r14d,%ecx
   60a6d:	c1 e9 0f             	shr    $0xf,%ecx
   60a70:	d3 c5                	rol    %cl,%ebp
   60a72:	44 89 f1             	mov    %r14d,%ecx
   60a75:	83 e1 1f             	and    $0x1f,%ecx
   60a78:	45 8b 24 8b          	mov    (%r11,%rcx,4),%r12d
   60a7c:	44 89 f1             	mov    %r14d,%ecx
   60a7f:	c1 e9 05             	shr    $0x5,%ecx
   60a82:	41 d3 c4             	rol    %cl,%r12d
   60a85:	44 89 f9             	mov    %r15d,%ecx
   60a88:	83 e1 0f             	and    $0xf,%ecx
   60a8b:	48 c1 e7 06          	shl    $0x6,%rdi
   60a8f:	4c 01 d7             	add    %r10,%rdi
   60a92:	8b 0c 8f             	mov    (%rdi,%rcx,4),%ecx
   60a95:	c4 c2 70 f2 cc       	andn   %r12d,%ecx,%ecx
   60a9a:	41 c1 ee 14          	shr    $0x14,%r14d
   60a9e:	41 83 ce 08          	or     $0x8,%r14d
   60aa2:	45 31 fe             	xor    %r15d,%r14d
   60aa5:	41 83 e6 0f          	and    $0xf,%r14d
   60aa9:	42 8b 3c b7          	mov    (%rdi,%r14,4),%edi
   60aad:	c4 e2 40 f2 fd       	andn   %ebp,%edi,%edi
   60ab2:	31 ed                	xor    %ebp,%ebp
   60ab4:	09 cf                	or     %ecx,%edi
   60ab6:	40 0f 94 c5          	sete   %bpl
   60aba:	89 2c 98             	mov    %ebp,(%rax,%rbx,4)
   60abd:	48 ff c3             	inc    %rbx
   60ac0:	48 39 da             	cmp    %rbx,%rdx
   60ac3:	0f 85 77 ff ff ff    	jne    60a40 <compare_benchmark::lookup+0x290>
   60ac9:	e9 51 0b 00 00       	jmp    6161f <compare_benchmark::lookup+0xe6f>
   60ace:	44 8b 4f 20          	mov    0x20(%rdi),%r9d
   60ad2:	62 d2 7d 48 7c d1    	vpbroadcastd %r9d,%zmm2
   60ad8:	31 db                	xor    %ebx,%ebx
   60ada:	62 f1 fd 48 6f 1d dc 	vmovdqa64 -0x57524(%rip),%zmm3        # 95c0 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x3e0>
   60ae1:	8a fa ff 
   60ae4:	62 f1 fd 48 6f 25 12 	vmovdqa64 -0x574ee(%rip),%zmm4        # 9600 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x420>
   60aeb:	8b fa ff 
   60aee:	62 f2 7d 48 58 2d 38 	vpbroadcastd -0x582c8(%rip),%zmm5        # 8830 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x11b>
   60af5:	7d fa ff 
   60af8:	62 f2 7d 48 58 35 92 	vpbroadcastd -0x5826e(%rip),%zmm6        # 8894 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x17f>
   60aff:	7d fa ff 
   60b02:	e9 e6 00 00 00       	jmp    60bed <compare_benchmark::lookup+0x43d>
   60b07:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
   60b0e:	00 00 
   60b10:	8b 8c de 7c 02 00 00 	mov    0x27c(%rsi,%rbx,8),%ecx
   60b17:	44 21 c9             	and    %r9d,%ecx
   60b1a:	41 0f 18 0c 8a       	prefetcht0 (%r10,%rcx,4)
   60b1f:	62 f1 fe 48 6f 3c de 	vmovdqu64 (%rsi,%rbx,8),%zmm7
   60b26:	62 71 fe 48 6f 44 de 	vmovdqu64 0x40(%rsi,%rbx,8),%zmm8
   60b2d:	01 
   60b2e:	62 71 fd 48 6f cf    	vmovdqa64 %zmm7,%zmm9
   60b34:	62 52 65 48 7e c8    	vpermt2d %zmm8,%zmm3,%zmm9
   60b3a:	62 d2 5d 48 7e f8    	vpermt2d %zmm8,%zmm4,%zmm7
   60b40:	62 f1 45 48 db fa    	vpandd %zmm2,%zmm7,%zmm7
   60b46:	c4 41 39 ef c0       	vpxor  %xmm8,%xmm8,%xmm8
   60b4b:	c5 fc 46 c8          	kxnorw %k0,%k0,%k1
   60b4f:	62 52 7d 49 90 04 ba 	vpgatherdd (%r10,%zmm7,4),%zmm8{%k1}
   60b56:	62 d1 2d 48 72 d1 14 	vpsrld $0x14,%zmm9,%zmm10
   60b5d:	62 71 2d 48 db d5    	vpandd %zmm5,%zmm10,%zmm10
   60b63:	62 73 45 48 25 d6 36 	vpternlogd $0x36,%zmm6,%zmm7,%zmm10
   60b6a:	62 f1 fd 48 6f f8    	vmovdqa64 %zmm0,%zmm7
   60b70:	c4 41 21 ef db       	vpxor  %xmm11,%xmm11,%xmm11
   60b75:	c5 fc 46 c8          	kxnorw %k0,%k0,%k1
   60b79:	62 12 7d 49 90 1c 92 	vpgatherdd (%r10,%zmm10,4),%zmm11{%k1}
   60b80:	62 f2 35 48 7e f9    	vpermt2d %zmm1,%zmm9,%zmm7
   60b86:	62 d1 2d 48 72 d1 05 	vpsrld $0x5,%zmm9,%zmm10
   60b8d:	62 d2 45 48 15 fa    	vprolvd %zmm10,%zmm7,%zmm7
   60b93:	62 d1 2d 48 72 d1 0a 	vpsrld $0xa,%zmm9,%zmm10
   60b9a:	62 72 7d 48 76 d1    	vpermi2d %zmm1,%zmm0,%zmm10
   60ba0:	62 d1 35 48 72 d1 0f 	vpsrld $0xf,%zmm9,%zmm9
   60ba7:	62 52 2d 48 15 c9    	vprolvd %zmm9,%zmm10,%zmm9
   60bad:	62 71 3d 48 db c7    	vpandd %zmm7,%zmm8,%zmm8
   60bb3:	62 f1 3d 48 76 cf    	vpcmpeqd %zmm7,%zmm8,%k1
   60bb9:	62 d1 25 48 db f9    	vpandd %zmm9,%zmm11,%zmm7
   60bbf:	62 d1 45 49 76 c1    	vpcmpeqd %zmm9,%zmm7,%k0{%k1}
   60bc5:	62 f2 7e 48 38 f8    	vpmovm2d %k0,%zmm7
   60bcb:	62 f1 45 48 72 d7 1f 	vpsrld $0x1f,%zmm7,%zmm7
   60bd2:	62 f1 fe 48 7f 3c 98 	vmovdqu64 %zmm7,(%rax,%rbx,4)
   60bd9:	48 8d 4b 10          	lea    0x10(%rbx),%rcx
   60bdd:	48 83 c3 20          	add    $0x20,%rbx
   60be1:	48 39 d3             	cmp    %rdx,%rbx
   60be4:	48 89 cb             	mov    %rcx,%rbx
   60be7:	0f 87 bb fd ff ff    	ja     609a8 <compare_benchmark::lookup+0x1f8>
   60bed:	48 8d 4b 50          	lea    0x50(%rbx),%rcx
   60bf1:	48 39 d1             	cmp    %rdx,%rcx
   60bf4:	0f 87 25 ff ff ff    	ja     60b1f <compare_benchmark::lookup+0x36f>
   60bfa:	48 8d 4b 40          	lea    0x40(%rbx),%rcx
   60bfe:	48 39 d1             	cmp    %rdx,%rcx
   60c01:	0f 83 90 01 00 00    	jae    60d97 <compare_benchmark::lookup+0x5e7>
   60c07:	8b 8c de 04 02 00 00 	mov    0x204(%rsi,%rbx,8),%ecx
   60c0e:	44 21 c9             	and    %r9d,%ecx
   60c11:	41 0f 18 0c 8a       	prefetcht0 (%r10,%rcx,4)
   60c16:	48 8d 4b 41          	lea    0x41(%rbx),%rcx
   60c1a:	48 39 d1             	cmp    %rdx,%rcx
   60c1d:	0f 83 74 01 00 00    	jae    60d97 <compare_benchmark::lookup+0x5e7>
   60c23:	8b 8c de 0c 02 00 00 	mov    0x20c(%rsi,%rbx,8),%ecx
   60c2a:	44 21 c9             	and    %r9d,%ecx
   60c2d:	41 0f 18 0c 8a       	prefetcht0 (%r10,%rcx,4)
   60c32:	48 8d 4b 42          	lea    0x42(%rbx),%rcx
   60c36:	48 39 d1             	cmp    %rdx,%rcx
   60c39:	0f 83 58 01 00 00    	jae    60d97 <compare_benchmark::lookup+0x5e7>
   60c3f:	8b 8c de 14 02 00 00 	mov    0x214(%rsi,%rbx,8),%ecx
   60c46:	44 21 c9             	and    %r9d,%ecx
   60c49:	41 0f 18 0c 8a       	prefetcht0 (%r10,%rcx,4)
   60c4e:	48 8d 4b 43          	lea    0x43(%rbx),%rcx
   60c52:	48 39 d1             	cmp    %rdx,%rcx
   60c55:	0f 83 3c 01 00 00    	jae    60d97 <compare_benchmark::lookup+0x5e7>
   60c5b:	8b 8c de 1c 02 00 00 	mov    0x21c(%rsi,%rbx,8),%ecx
   60c62:	44 21 c9             	and    %r9d,%ecx
   60c65:	41 0f 18 0c 8a       	prefetcht0 (%r10,%rcx,4)
   60c6a:	48 8d 4b 44          	lea    0x44(%rbx),%rcx
   60c6e:	48 39 d1             	cmp    %rdx,%rcx
   60c71:	0f 83 20 01 00 00    	jae    60d97 <compare_benchmark::lookup+0x5e7>
   60c77:	8b 8c de 24 02 00 00 	mov    0x224(%rsi,%rbx,8),%ecx
   60c7e:	44 21 c9             	and    %r9d,%ecx
   60c81:	41 0f 18 0c 8a       	prefetcht0 (%r10,%rcx,4)
   60c86:	48 8d 4b 45          	lea    0x45(%rbx),%rcx
   60c8a:	48 39 d1             	cmp    %rdx,%rcx
   60c8d:	0f 83 04 01 00 00    	jae    60d97 <compare_benchmark::lookup+0x5e7>
   60c93:	8b 8c de 2c 02 00 00 	mov    0x22c(%rsi,%rbx,8),%ecx
   60c9a:	44 21 c9             	and    %r9d,%ecx
   60c9d:	41 0f 18 0c 8a       	prefetcht0 (%r10,%rcx,4)
   60ca2:	48 8d 4b 46          	lea    0x46(%rbx),%rcx
   60ca6:	48 39 d1             	cmp    %rdx,%rcx
   60ca9:	0f 83 e8 00 00 00    	jae    60d97 <compare_benchmark::lookup+0x5e7>
   60caf:	8b 8c de 34 02 00 00 	mov    0x234(%rsi,%rbx,8),%ecx
   60cb6:	44 21 c9             	and    %r9d,%ecx
   60cb9:	41 0f 18 0c 8a       	prefetcht0 (%r10,%rcx,4)
   60cbe:	48 8d 4b 47          	lea    0x47(%rbx),%rcx
   60cc2:	48 39 d1             	cmp    %rdx,%rcx
   60cc5:	0f 83 cc 00 00 00    	jae    60d97 <compare_benchmark::lookup+0x5e7>
   60ccb:	8b 8c de 3c 02 00 00 	mov    0x23c(%rsi,%rbx,8),%ecx
   60cd2:	44 21 c9             	and    %r9d,%ecx
   60cd5:	41 0f 18 0c 8a       	prefetcht0 (%r10,%rcx,4)
   60cda:	48 8d 4b 48          	lea    0x48(%rbx),%rcx
   60cde:	48 39 d1             	cmp    %rdx,%rcx
   60ce1:	0f 83 b0 00 00 00    	jae    60d97 <compare_benchmark::lookup+0x5e7>
   60ce7:	8b 8c de 44 02 00 00 	mov    0x244(%rsi,%rbx,8),%ecx
   60cee:	44 21 c9             	and    %r9d,%ecx
   60cf1:	41 0f 18 0c 8a       	prefetcht0 (%r10,%rcx,4)
   60cf6:	48 8d 4b 49          	lea    0x49(%rbx),%rcx
   60cfa:	48 39 d1             	cmp    %rdx,%rcx
   60cfd:	0f 83 94 00 00 00    	jae    60d97 <compare_benchmark::lookup+0x5e7>
   60d03:	8b 8c de 4c 02 00 00 	mov    0x24c(%rsi,%rbx,8),%ecx
   60d0a:	44 21 c9             	and    %r9d,%ecx
   60d0d:	41 0f 18 0c 8a       	prefetcht0 (%r10,%rcx,4)
   60d12:	48 8d 4b 4a          	lea    0x4a(%rbx),%rcx
   60d16:	48 39 d1             	cmp    %rdx,%rcx
   60d19:	73 7c                	jae    60d97 <compare_benchmark::lookup+0x5e7>
   60d1b:	8b 8c de 54 02 00 00 	mov    0x254(%rsi,%rbx,8),%ecx
   60d22:	44 21 c9             	and    %r9d,%ecx
   60d25:	41 0f 18 0c 8a       	prefetcht0 (%r10,%rcx,4)
   60d2a:	48 8d 4b 4b          	lea    0x4b(%rbx),%rcx
   60d2e:	48 39 d1             	cmp    %rdx,%rcx
   60d31:	73 64                	jae    60d97 <compare_benchmark::lookup+0x5e7>
   60d33:	8b 8c de 5c 02 00 00 	mov    0x25c(%rsi,%rbx,8),%ecx
   60d3a:	44 21 c9             	and    %r9d,%ecx
   60d3d:	41 0f 18 0c 8a       	prefetcht0 (%r10,%rcx,4)
   60d42:	48 8d 4b 4c          	lea    0x4c(%rbx),%rcx
   60d46:	48 39 d1             	cmp    %rdx,%rcx
   60d49:	73 4c                	jae    60d97 <compare_benchmark::lookup+0x5e7>
   60d4b:	8b 8c de 64 02 00 00 	mov    0x264(%rsi,%rbx,8),%ecx
   60d52:	44 21 c9             	and    %r9d,%ecx
   60d55:	41 0f 18 0c 8a       	prefetcht0 (%r10,%rcx,4)
   60d5a:	48 8d 4b 4d          	lea    0x4d(%rbx),%rcx
   60d5e:	48 39 d1             	cmp    %rdx,%rcx
   60d61:	73 34                	jae    60d97 <compare_benchmark::lookup+0x5e7>
   60d63:	8b 8c de 6c 02 00 00 	mov    0x26c(%rsi,%rbx,8),%ecx
   60d6a:	44 21 c9             	and    %r9d,%ecx
   60d6d:	41 0f 18 0c 8a       	prefetcht0 (%r10,%rcx,4)
   60d72:	48 8d 4b 4e          	lea    0x4e(%rbx),%rcx
   60d76:	48 39 d1             	cmp    %rdx,%rcx
   60d79:	73 1c                	jae    60d97 <compare_benchmark::lookup+0x5e7>
   60d7b:	8b 8c de 74 02 00 00 	mov    0x274(%rsi,%rbx,8),%ecx
   60d82:	44 21 c9             	and    %r9d,%ecx
   60d85:	41 0f 18 0c 8a       	prefetcht0 (%r10,%rcx,4)
   60d8a:	48 8d 4b 4f          	lea    0x4f(%rbx),%rcx
   60d8e:	48 39 d1             	cmp    %rdx,%rcx
   60d91:	0f 82 79 fd ff ff    	jb     60b10 <compare_benchmark::lookup+0x360>
   60d97:	48 8d 05 42 45 05 00 	lea    0x54542(%rip),%rax        # b52e0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0xb10>
   60d9e:	48 89 cf             	mov    %rcx,%rdi
   60da1:	48 89 d6             	mov    %rdx,%rsi
   60da4:	48 89 c2             	mov    %rax,%rdx
   60da7:	c5 f8 77             	vzeroupper
   60daa:	ff 15 c8 78 05 00    	call   *0x578c8(%rip)        # b8678 <_DYNAMIC+0x260>
   60db0:	4c 8b 5f 08          	mov    0x8(%rdi),%r11
   60db4:	8b 5f 20             	mov    0x20(%rdi),%ebx
   60db7:	48 83 fa 07          	cmp    $0x7,%rdx
   60dbb:	0f 87 a7 05 00 00    	ja     61368 <compare_benchmark::lookup+0xbb8>
   60dc1:	4c 8b 77 18          	mov    0x18(%rdi),%r14
   60dc5:	45 31 ff             	xor    %r15d,%r15d
   60dc8:	e9 db 06 00 00       	jmp    614a8 <compare_benchmark::lookup+0xcf8>
   60dcd:	62 f2 7d 48 58 57 08 	vpbroadcastd 0x20(%rdi),%zmm2
   60dd4:	31 c9                	xor    %ecx,%ecx
   60dd6:	62 f1 fd 48 6f 1d e0 	vmovdqa64 -0x57820(%rip),%zmm3        # 95c0 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x3e0>
   60ddd:	87 fa ff 
   60de0:	62 f1 fd 48 6f 25 16 	vmovdqa64 -0x577ea(%rip),%zmm4        # 9600 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x420>
   60de7:	88 fa ff 
   60dea:	62 f2 7d 48 58 2d 3c 	vpbroadcastd -0x585c4(%rip),%zmm5        # 8830 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x11b>
   60df1:	7a fa ff 
   60df4:	62 f2 7d 48 58 35 96 	vpbroadcastd -0x5856a(%rip),%zmm6        # 8894 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x17f>
   60dfb:	7a fa ff 
   60dfe:	66 90                	xchg   %ax,%ax
   60e00:	62 f1 fe 48 6f 3c ce 	vmovdqu64 (%rsi,%rcx,8),%zmm7
   60e07:	62 71 fe 48 6f 44 ce 	vmovdqu64 0x40(%rsi,%rcx,8),%zmm8
   60e0e:	01 
   60e0f:	62 71 fd 48 6f cf    	vmovdqa64 %zmm7,%zmm9
   60e15:	62 52 65 48 7e c8    	vpermt2d %zmm8,%zmm3,%zmm9
   60e1b:	62 d2 5d 48 7e f8    	vpermt2d %zmm8,%zmm4,%zmm7
   60e21:	62 f1 45 48 db fa    	vpandd %zmm2,%zmm7,%zmm7
   60e27:	c4 41 39 ef c0       	vpxor  %xmm8,%xmm8,%xmm8
   60e2c:	c5 fc 46 c8          	kxnorw %k0,%k0,%k1
   60e30:	62 52 7d 49 90 04 ba 	vpgatherdd (%r10,%zmm7,4),%zmm8{%k1}
   60e37:	62 d1 2d 48 72 d1 14 	vpsrld $0x14,%zmm9,%zmm10
   60e3e:	62 71 2d 48 db d5    	vpandd %zmm5,%zmm10,%zmm10
   60e44:	62 73 45 48 25 d6 36 	vpternlogd $0x36,%zmm6,%zmm7,%zmm10
   60e4b:	62 f1 fd 48 6f f8    	vmovdqa64 %zmm0,%zmm7
   60e51:	c4 41 21 ef db       	vpxor  %xmm11,%xmm11,%xmm11
   60e56:	c5 fc 46 c8          	kxnorw %k0,%k0,%k1
   60e5a:	62 12 7d 49 90 1c 92 	vpgatherdd (%r10,%zmm10,4),%zmm11{%k1}
   60e61:	62 f2 35 48 7e f9    	vpermt2d %zmm1,%zmm9,%zmm7
   60e67:	62 d1 2d 48 72 d1 05 	vpsrld $0x5,%zmm9,%zmm10
   60e6e:	62 d2 45 48 15 fa    	vprolvd %zmm10,%zmm7,%zmm7
   60e74:	62 d1 2d 48 72 d1 0a 	vpsrld $0xa,%zmm9,%zmm10
   60e7b:	62 72 7d 48 76 d1    	vpermi2d %zmm1,%zmm0,%zmm10
   60e81:	62 d1 35 48 72 d1 0f 	vpsrld $0xf,%zmm9,%zmm9
   60e88:	62 52 2d 48 15 c9    	vprolvd %zmm9,%zmm10,%zmm9
   60e8e:	62 71 3d 48 db c7    	vpandd %zmm7,%zmm8,%zmm8
   60e94:	62 f1 3d 48 76 cf    	vpcmpeqd %zmm7,%zmm8,%k1
   60e9a:	62 d1 25 48 db f9    	vpandd %zmm9,%zmm11,%zmm7
   60ea0:	62 d1 45 49 76 c1    	vpcmpeqd %zmm9,%zmm7,%k0{%k1}
   60ea6:	62 f2 7e 48 38 f8    	vpmovm2d %k0,%zmm7
   60eac:	62 f1 45 48 72 d7 1f 	vpsrld $0x1f,%zmm7,%zmm7
   60eb3:	62 f1 fe 48 7f 3c 88 	vmovdqu64 %zmm7,(%rax,%rcx,4)
   60eba:	4c 8d 49 10          	lea    0x10(%rcx),%r9
   60ebe:	48 83 c1 20          	add    $0x20,%rcx
   60ec2:	48 39 d1             	cmp    %rdx,%rcx
   60ec5:	4c 89 c9             	mov    %r9,%rcx
   60ec8:	0f 86 32 ff ff ff    	jbe    60e00 <compare_benchmark::lookup+0x650>
   60ece:	4c 89 cb             	mov    %r9,%rbx
   60ed1:	48 83 cb 08          	or     $0x8,%rbx
   60ed5:	48 39 d3             	cmp    %rdx,%rbx
   60ed8:	76 11                	jbe    60eeb <compare_benchmark::lookup+0x73b>
   60eda:	4c 89 cb             	mov    %r9,%rbx
   60edd:	48 39 d3             	cmp    %rdx,%rbx
   60ee0:	0f 82 92 00 00 00    	jb     60f78 <compare_benchmark::lookup+0x7c8>
   60ee6:	e9 34 07 00 00       	jmp    6161f <compare_benchmark::lookup+0xe6f>
   60eeb:	62 b1 fe 48 6f 14 ce 	vmovdqu64 (%rsi,%r9,8),%zmm2
   60ef2:	62 f1 7d 48 70 da f5 	vpshufd $0xf5,%zmm2,%zmm3
   60ef9:	62 f1 65 58 db 5f 08 	vpandd 0x20(%rdi){1to16},%zmm3,%zmm3
   60f00:	62 f1 dd 48 73 f2 0c 	vpsllq $0xc,%zmm2,%zmm4
   60f07:	62 f1 dd 58 db 25 6f 	vpandq -0x58591(%rip){1to8},%zmm4,%zmm4        # 8980 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x26b>
   60f0e:	7a fa ff 
   60f11:	62 f3 e5 58 25 25 24 	vpternlogq $0x36,-0x584dc(%rip){1to8},%zmm3,%zmm4        # 8a40 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x70>
   60f18:	7b fa ff 36 
   60f1c:	62 f1 7d 48 70 d2 a0 	vpshufd $0xa0,%zmm2,%zmm2
   60f23:	62 f2 6d 48 45 1d 93 	vpsrlvd -0x5786d(%rip),%zmm2,%zmm3        # 96c0 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x4e0>
   60f2a:	87 fa ff 
   60f2d:	62 f2 65 48 7e c1    	vpermt2d %zmm1,%zmm3,%zmm0
   60f33:	62 f2 6d 48 45 0d c3 	vpsrlvd -0x5783d(%rip),%zmm2,%zmm1        # 9700 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x520>
   60f3a:	87 fa ff 
   60f3d:	62 f2 7d 48 15 c1    	vprolvd %zmm1,%zmm0,%zmm0
   60f43:	c5 fc 46 c8          	kxnorw %k0,%k0,%k1
   60f47:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
   60f4b:	62 d2 7d 49 90 0c a2 	vpgatherdd (%r10,%zmm4,4),%zmm1{%k1}
   60f52:	62 f1 7d 48 db c9    	vpandd %zmm1,%zmm0,%zmm1
   60f58:	62 f2 f5 48 29 c0    	vpcmpeqq %zmm0,%zmm1,%k0
   60f5e:	62 f2 7e 48 38 c0    	vpmovm2d %k0,%zmm0
   60f64:	c5 fd 72 d0 1f       	vpsrld $0x1f,%ymm0,%ymm0
   60f69:	c4 a1 7e 7f 04 88    	vmovdqu %ymm0,(%rax,%r9,4)
   60f6f:	48 39 d3             	cmp    %rdx,%rbx
   60f72:	0f 83 a7 06 00 00    	jae    6161f <compare_benchmark::lookup+0xe6f>
   60f78:	8b 6f 20             	mov    0x20(%rdi),%ebp
   60f7b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
   60f80:	4c 8b 0c de          	mov    (%rsi,%rbx,8),%r9
   60f84:	4d 89 ce             	mov    %r9,%r14
   60f87:	49 c1 ee 20          	shr    $0x20,%r14
   60f8b:	41 21 ee             	and    %ebp,%r14d
   60f8e:	44 89 f7             	mov    %r14d,%edi
   60f91:	c1 ef 04             	shr    $0x4,%edi
   60f94:	4c 39 c7             	cmp    %r8,%rdi
   60f97:	0f 83 da 06 00 00    	jae    61677 <compare_benchmark::lookup+0xec7>
   60f9d:	48 c1 e7 06          	shl    $0x6,%rdi
   60fa1:	4c 01 d7             	add    %r10,%rdi
   60fa4:	45 89 f7             	mov    %r14d,%r15d
   60fa7:	41 83 e7 0f          	and    $0xf,%r15d
   60fab:	44 89 c9             	mov    %r9d,%ecx
   60fae:	83 e1 1f             	and    $0x1f,%ecx
   60fb1:	45 8b 24 8b          	mov    (%r11,%rcx,4),%r12d
   60fb5:	44 89 c9             	mov    %r9d,%ecx
   60fb8:	c1 e9 05             	shr    $0x5,%ecx
   60fbb:	41 d3 c4             	rol    %cl,%r12d
   60fbe:	46 8b 3c bf          	mov    (%rdi,%r15,4),%r15d
   60fc2:	45 21 e7             	and    %r12d,%r15d
   60fc5:	45 31 e7             	xor    %r12d,%r15d
   60fc8:	45 89 cc             	mov    %r9d,%r12d
   60fcb:	41 c1 ec 14          	shr    $0x14,%r12d
   60fcf:	41 83 cc 08          	or     $0x8,%r12d
   60fd3:	45 31 f4             	xor    %r14d,%r12d
   60fd6:	44 89 c9             	mov    %r9d,%ecx
   60fd9:	c1 e9 08             	shr    $0x8,%ecx
   60fdc:	83 e1 7c             	and    $0x7c,%ecx
   60fdf:	45 8b 34 0b          	mov    (%r11,%rcx,1),%r14d
   60fe3:	41 c1 e9 0f          	shr    $0xf,%r9d
   60fe7:	44 89 c9             	mov    %r9d,%ecx
   60fea:	41 d3 c6             	rol    %cl,%r14d
   60fed:	41 83 e4 0f          	and    $0xf,%r12d
   60ff1:	42 8b 0c a7          	mov    (%rdi,%r12,4),%ecx
   60ff5:	44 21 f1             	and    %r14d,%ecx
   60ff8:	44 31 f1             	xor    %r14d,%ecx
   60ffb:	31 ff                	xor    %edi,%edi
   60ffd:	44 09 f9             	or     %r15d,%ecx
   61000:	40 0f 94 c7          	sete   %dil
   61004:	89 3c 98             	mov    %edi,(%rax,%rbx,4)
   61007:	48 ff c3             	inc    %rbx
   6100a:	48 39 da             	cmp    %rbx,%rdx
   6100d:	0f 85 6d ff ff ff    	jne    60f80 <compare_benchmark::lookup+0x7d0>
   61013:	e9 07 06 00 00       	jmp    6161f <compare_benchmark::lookup+0xe6f>
   61018:	62 f1 fe 48 6f 14 ce 	vmovdqu64 (%rsi,%rcx,8),%zmm2
   6101f:	62 f1 7d 48 70 da f5 	vpshufd $0xf5,%zmm2,%zmm3
   61026:	62 f1 65 58 db 5f 08 	vpandd 0x20(%rdi){1to16},%zmm3,%zmm3
   6102d:	62 f1 dd 48 73 f2 0c 	vpsllq $0xc,%zmm2,%zmm4
   61034:	62 f1 dd 58 db 25 42 	vpandq -0x586be(%rip){1to8},%zmm4,%zmm4        # 8980 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x26b>
   6103b:	79 fa ff 
   6103e:	62 f3 e5 58 25 25 f7 	vpternlogq $0x36,-0x58609(%rip){1to8},%zmm3,%zmm4        # 8a40 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x70>
   61045:	79 fa ff 36 
   61049:	62 f1 7d 48 70 d2 a0 	vpshufd $0xa0,%zmm2,%zmm2
   61050:	62 f2 6d 48 45 1d 66 	vpsrlvd -0x5799a(%rip),%zmm2,%zmm3        # 96c0 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x4e0>
   61057:	86 fa ff 
   6105a:	62 f2 65 48 7e c1    	vpermt2d %zmm1,%zmm3,%zmm0
   61060:	62 f2 6d 48 45 0d 96 	vpsrlvd -0x5796a(%rip),%zmm2,%zmm1        # 9700 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x520>
   61067:	86 fa ff 
   6106a:	62 f2 7d 48 15 c1    	vprolvd %zmm1,%zmm0,%zmm0
   61070:	c5 fc 46 c8          	kxnorw %k0,%k0,%k1
   61074:	c5 f1 ef c9          	vpxor  %xmm1,%xmm1,%xmm1
   61078:	62 d2 7d 49 90 0c a2 	vpgatherdd (%r10,%zmm4,4),%zmm1{%k1}
   6107f:	62 f1 7d 48 db c9    	vpandd %zmm1,%zmm0,%zmm1
   61085:	62 f2 f5 48 29 c0    	vpcmpeqq %zmm0,%zmm1,%k0
   6108b:	62 f2 7e 48 38 c0    	vpmovm2d %k0,%zmm0
   61091:	c5 fd 72 d0 1f       	vpsrld $0x1f,%ymm0,%ymm0
   61096:	c5 fe 7f 04 88       	vmovdqu %ymm0,(%rax,%rcx,4)
   6109b:	48 39 d3             	cmp    %rdx,%rbx
   6109e:	0f 83 7b 05 00 00    	jae    6161f <compare_benchmark::lookup+0xe6f>
   610a4:	8b 6f 20             	mov    0x20(%rdi),%ebp
   610a7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
   610ae:	00 00 
   610b0:	4c 8b 0c de          	mov    (%rsi,%rbx,8),%r9
   610b4:	4d 89 ce             	mov    %r9,%r14
   610b7:	49 c1 ee 20          	shr    $0x20,%r14
   610bb:	41 21 ee             	and    %ebp,%r14d
   610be:	44 89 f7             	mov    %r14d,%edi
   610c1:	c1 ef 04             	shr    $0x4,%edi
   610c4:	4c 39 c7             	cmp    %r8,%rdi
   610c7:	0f 83 aa 05 00 00    	jae    61677 <compare_benchmark::lookup+0xec7>
   610cd:	48 c1 e7 06          	shl    $0x6,%rdi
   610d1:	4c 01 d7             	add    %r10,%rdi
   610d4:	45 89 f7             	mov    %r14d,%r15d
   610d7:	41 83 e7 0f          	and    $0xf,%r15d
   610db:	44 89 c9             	mov    %r9d,%ecx
   610de:	83 e1 1f             	and    $0x1f,%ecx
   610e1:	45 8b 24 8b          	mov    (%r11,%rcx,4),%r12d
   610e5:	44 89 c9             	mov    %r9d,%ecx
   610e8:	c1 e9 05             	shr    $0x5,%ecx
   610eb:	41 d3 c4             	rol    %cl,%r12d
   610ee:	46 8b 3c bf          	mov    (%rdi,%r15,4),%r15d
   610f2:	45 21 e7             	and    %r12d,%r15d
   610f5:	45 31 e7             	xor    %r12d,%r15d
   610f8:	45 89 cc             	mov    %r9d,%r12d
   610fb:	41 c1 ec 14          	shr    $0x14,%r12d
   610ff:	41 83 cc 08          	or     $0x8,%r12d
   61103:	45 31 f4             	xor    %r14d,%r12d
   61106:	44 89 c9             	mov    %r9d,%ecx
   61109:	c1 e9 08             	shr    $0x8,%ecx
   6110c:	83 e1 7c             	and    $0x7c,%ecx
   6110f:	45 8b 34 0b          	mov    (%r11,%rcx,1),%r14d
   61113:	41 c1 e9 0f          	shr    $0xf,%r9d
   61117:	44 89 c9             	mov    %r9d,%ecx
   6111a:	41 d3 c6             	rol    %cl,%r14d
   6111d:	41 83 e4 0f          	and    $0xf,%r12d
   61121:	42 8b 0c a7          	mov    (%rdi,%r12,4),%ecx
   61125:	44 21 f1             	and    %r14d,%ecx
   61128:	44 31 f1             	xor    %r14d,%ecx
   6112b:	31 ff                	xor    %edi,%edi
   6112d:	44 09 f9             	or     %r15d,%ecx
   61130:	40 0f 94 c7          	sete   %dil
   61134:	89 3c 98             	mov    %edi,(%rax,%rbx,4)
   61137:	48 ff c3             	inc    %rbx
   6113a:	48 39 da             	cmp    %rbx,%rdx
   6113d:	0f 85 6d ff ff ff    	jne    610b0 <compare_benchmark::lookup+0x900>
   61143:	e9 d7 04 00 00       	jmp    6161f <compare_benchmark::lookup+0xe6f>
   61148:	62 f2 7d 28 7c c3    	vpbroadcastd %ebx,%ymm0
   6114e:	4c 8b 77 18          	mov    0x18(%rdi),%r14
   61152:	31 c9                	xor    %ecx,%ecx
   61154:	c5 fd 6f 0d 44 7b fa 	vmovdqa -0x584bc(%rip),%ymm1        # 8ca0 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x2d0>
   6115b:	ff 
   6115c:	c4 e2 7d 58 15 1f 77 	vpbroadcastd -0x588e1(%rip),%ymm2        # 8884 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x16f>
   61163:	fa ff 
   61165:	c4 e2 7d 58 1d 22 77 	vpbroadcastd -0x588de(%rip),%ymm3        # 8890 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x17b>
   6116c:	fa ff 
   6116e:	c4 e2 7d 58 25 b9 76 	vpbroadcastd -0x58947(%rip),%ymm4        # 8830 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x11b>
   61175:	fa ff 
   61177:	c4 e2 7d 58 2d 14 77 	vpbroadcastd -0x588ec(%rip),%ymm5        # 8894 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x17f>
   6117e:	fa ff 
   61180:	c4 e2 7d 59 35 e7 78 	vpbroadcastq -0x58719(%rip),%ymm6        # 8a70 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0xa0>
   61187:	fa ff 
   61189:	e9 f0 00 00 00       	jmp    6127e <compare_benchmark::lookup+0xace>
   6118e:	66 90                	xchg   %ax,%ax
   61190:	62 f1 fe 48 6f 3c ce 	vmovdqu64 (%rsi,%rcx,8),%zmm7
   61197:	62 d2 7e 48 35 f8    	vpmovqd %zmm7,%ymm8
   6119d:	c5 c1 ef ff          	vpxor  %xmm7,%xmm7,%xmm7
   611a1:	62 f2 75 48 36 3c ce 	vpermd (%rsi,%rcx,8),%zmm1,%zmm7
   611a8:	c5 3d db ca          	vpand  %ymm2,%ymm8,%ymm9
   611ac:	c4 41 29 ef d2       	vpxor  %xmm10,%xmm10,%xmm10
   611b1:	c4 41 25 76 db       	vpcmpeqd %ymm11,%ymm11,%ymm11
   611b6:	c4 02 25 90 14 8e    	vpgatherdd %ymm11,(%r14,%ymm9,4),%ymm10
   611bc:	c5 c5 db f8          	vpand  %ymm0,%ymm7,%ymm7
   611c0:	c4 c1 35 72 d0 0a    	vpsrld $0xa,%ymm8,%ymm9
   611c6:	c5 35 db ca          	vpand  %ymm2,%ymm9,%ymm9
   611ca:	c4 41 21 ef db       	vpxor  %xmm11,%xmm11,%xmm11
   611cf:	c4 41 1d 76 e4       	vpcmpeqd %ymm12,%ymm12,%ymm12
   611d4:	c4 02 1d 90 1c 8e    	vpgatherdd %ymm12,(%r14,%ymm9,4),%ymm11
   611da:	c4 c1 35 72 d0 14    	vpsrld $0x14,%ymm8,%ymm9
   611e0:	c5 35 db cc          	vpand  %ymm4,%ymm9,%ymm9
   611e4:	c4 c1 1d 72 d0 05    	vpsrld $0x5,%ymm8,%ymm12
   611ea:	c5 1d db e2          	vpand  %ymm2,%ymm12,%ymm12
   611ee:	c4 42 2d 47 ec       	vpsllvd %ymm12,%ymm10,%ymm13
   611f3:	c4 41 65 fa e4       	vpsubd %ymm12,%ymm3,%ymm12
   611f8:	c4 42 2d 45 d4       	vpsrlvd %ymm12,%ymm10,%ymm10
   611fd:	c4 41 15 eb d2       	vpor   %ymm10,%ymm13,%ymm10
   61202:	c4 c1 3d 72 d0 0f    	vpsrld $0xf,%ymm8,%ymm8
   61208:	c5 3d db c2          	vpand  %ymm2,%ymm8,%ymm8
   6120c:	c4 41 19 ef e4       	vpxor  %xmm12,%xmm12,%xmm12
   61211:	c4 41 15 76 ed       	vpcmpeqd %ymm13,%ymm13,%ymm13
   61216:	c4 42 15 90 24 bb    	vpgatherdd %ymm13,(%r11,%ymm7,4),%ymm12
   6121c:	c4 42 25 47 e8       	vpsllvd %ymm8,%ymm11,%ymm13
   61221:	c4 41 65 fa c0       	vpsubd %ymm8,%ymm3,%ymm8
   61226:	c4 42 25 45 c0       	vpsrlvd %ymm8,%ymm11,%ymm8
   6122b:	62 73 45 28 25 cd 36 	vpternlogd $0x36,%ymm5,%ymm7,%ymm9
   61232:	c5 c1 ef ff          	vpxor  %xmm7,%xmm7,%xmm7
   61236:	c4 41 25 76 db       	vpcmpeqd %ymm11,%ymm11,%ymm11
   6123b:	c4 82 25 90 3c 8b    	vpgatherdd %ymm11,(%r11,%ymm9,4),%ymm7
   61241:	c4 41 15 eb c0       	vpor   %ymm8,%ymm13,%ymm8
   61246:	c4 41 2d db cc       	vpand  %ymm12,%ymm10,%ymm9
   6124b:	62 d1 35 28 76 ca    	vpcmpeqd %ymm10,%ymm9,%k1
   61251:	c5 bd db ff          	vpand  %ymm7,%ymm8,%ymm7
   61255:	62 d1 45 29 76 c0    	vpcmpeqd %ymm8,%ymm7,%k0{%k1}
   6125b:	62 f2 7e 28 38 f8    	vpmovm2d %k0,%ymm7
   61261:	c5 c5 db fe          	vpand  %ymm6,%ymm7,%ymm7
   61265:	c5 fe 7f 3c 88       	vmovdqu %ymm7,(%rax,%rcx,4)
   6126a:	4c 8d 79 08          	lea    0x8(%rcx),%r15
   6126e:	48 83 c1 10          	add    $0x10,%rcx
   61272:	48 39 d1             	cmp    %rdx,%rcx
   61275:	4c 89 f9             	mov    %r15,%rcx
   61278:	0f 87 e6 02 00 00    	ja     61564 <compare_benchmark::lookup+0xdb4>
   6127e:	48 8d 79 48          	lea    0x48(%rcx),%rdi
   61282:	48 39 d7             	cmp    %rdx,%rdi
   61285:	0f 87 05 ff ff ff    	ja     61190 <compare_benchmark::lookup+0x9e0>
   6128b:	48 8d 79 40          	lea    0x40(%rcx),%rdi
   6128f:	48 39 d7             	cmp    %rdx,%rdi
   61292:	0f 83 f2 03 00 00    	jae    6168a <compare_benchmark::lookup+0xeda>
   61298:	8b bc ce 04 02 00 00 	mov    0x204(%rsi,%rcx,8),%edi
   6129f:	21 df                	and    %ebx,%edi
   612a1:	41 0f 18 0c bb       	prefetcht0 (%r11,%rdi,4)
   612a6:	48 8d 79 41          	lea    0x41(%rcx),%rdi
   612aa:	48 39 d7             	cmp    %rdx,%rdi
   612ad:	0f 83 d7 03 00 00    	jae    6168a <compare_benchmark::lookup+0xeda>
   612b3:	8b bc ce 0c 02 00 00 	mov    0x20c(%rsi,%rcx,8),%edi
   612ba:	21 df                	and    %ebx,%edi
   612bc:	41 0f 18 0c bb       	prefetcht0 (%r11,%rdi,4)
   612c1:	48 8d 79 42          	lea    0x42(%rcx),%rdi
   612c5:	48 39 d7             	cmp    %rdx,%rdi
   612c8:	0f 83 bc 03 00 00    	jae    6168a <compare_benchmark::lookup+0xeda>
   612ce:	8b bc ce 14 02 00 00 	mov    0x214(%rsi,%rcx,8),%edi
   612d5:	21 df                	and    %ebx,%edi
   612d7:	41 0f 18 0c bb       	prefetcht0 (%r11,%rdi,4)
   612dc:	48 8d 79 43          	lea    0x43(%rcx),%rdi
   612e0:	48 39 d7             	cmp    %rdx,%rdi
   612e3:	0f 83 a1 03 00 00    	jae    6168a <compare_benchmark::lookup+0xeda>
   612e9:	8b bc ce 1c 02 00 00 	mov    0x21c(%rsi,%rcx,8),%edi
   612f0:	21 df                	and    %ebx,%edi
   612f2:	41 0f 18 0c bb       	prefetcht0 (%r11,%rdi,4)
   612f7:	48 8d 79 44          	lea    0x44(%rcx),%rdi
   612fb:	48 39 d7             	cmp    %rdx,%rdi
   612fe:	0f 83 86 03 00 00    	jae    6168a <compare_benchmark::lookup+0xeda>
   61304:	8b bc ce 24 02 00 00 	mov    0x224(%rsi,%rcx,8),%edi
   6130b:	21 df                	and    %ebx,%edi
   6130d:	41 0f 18 0c bb       	prefetcht0 (%r11,%rdi,4)
   61312:	48 8d 79 45          	lea    0x45(%rcx),%rdi
   61316:	48 39 d7             	cmp    %rdx,%rdi
   61319:	0f 83 6b 03 00 00    	jae    6168a <compare_benchmark::lookup+0xeda>
   6131f:	8b bc ce 2c 02 00 00 	mov    0x22c(%rsi,%rcx,8),%edi
   61326:	21 df                	and    %ebx,%edi
   61328:	41 0f 18 0c bb       	prefetcht0 (%r11,%rdi,4)
   6132d:	48 8d 79 46          	lea    0x46(%rcx),%rdi
   61331:	48 39 d7             	cmp    %rdx,%rdi
   61334:	0f 83 50 03 00 00    	jae    6168a <compare_benchmark::lookup+0xeda>
   6133a:	8b bc ce 34 02 00 00 	mov    0x234(%rsi,%rcx,8),%edi
   61341:	21 df                	and    %ebx,%edi
   61343:	41 0f 18 0c bb       	prefetcht0 (%r11,%rdi,4)
   61348:	48 8d 79 47          	lea    0x47(%rcx),%rdi
   6134c:	48 39 d7             	cmp    %rdx,%rdi
   6134f:	0f 83 35 03 00 00    	jae    6168a <compare_benchmark::lookup+0xeda>
   61355:	8b bc ce 3c 02 00 00 	mov    0x23c(%rsi,%rcx,8),%edi
   6135c:	21 df                	and    %ebx,%edi
   6135e:	41 0f 18 0c bb       	prefetcht0 (%r11,%rdi,4)
   61363:	e9 28 fe ff ff       	jmp    61190 <compare_benchmark::lookup+0x9e0>
   61368:	62 f2 7d 28 7c c3    	vpbroadcastd %ebx,%ymm0
   6136e:	4c 8b 77 18          	mov    0x18(%rdi),%r14
   61372:	45 31 ff             	xor    %r15d,%r15d
   61375:	c5 fd 6f 0d 23 79 fa 	vmovdqa -0x586dd(%rip),%ymm1        # 8ca0 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x2d0>
   6137c:	ff 
   6137d:	c4 e2 7d 58 15 fe 74 	vpbroadcastd -0x58b02(%rip),%ymm2        # 8884 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x16f>
   61384:	fa ff 
   61386:	c4 e2 7d 58 1d 01 75 	vpbroadcastd -0x58aff(%rip),%ymm3        # 8890 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x17b>
   6138d:	fa ff 
   6138f:	c4 e2 7d 58 25 98 74 	vpbroadcastd -0x58b68(%rip),%ymm4        # 8830 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x11b>
   61396:	fa ff 
   61398:	c4 e2 7d 58 2d f3 74 	vpbroadcastd -0x58b0d(%rip),%ymm5        # 8894 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x17f>
   6139f:	fa ff 
   613a1:	c4 e2 7d 59 35 c6 76 	vpbroadcastq -0x5893a(%rip),%ymm6        # 8a70 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0xa0>
   613a8:	fa ff 
   613aa:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
   613b0:	4c 89 f9             	mov    %r15,%rcx
   613b3:	62 b1 fe 48 6f 3c fe 	vmovdqu64 (%rsi,%r15,8),%zmm7
   613ba:	62 d2 7e 48 35 f8    	vpmovqd %zmm7,%ymm8
   613c0:	c5 c1 ef ff          	vpxor  %xmm7,%xmm7,%xmm7
   613c4:	62 b2 75 48 36 3c fe 	vpermd (%rsi,%r15,8),%zmm1,%zmm7
   613cb:	c5 3d db ca          	vpand  %ymm2,%ymm8,%ymm9
   613cf:	c4 41 29 ef d2       	vpxor  %xmm10,%xmm10,%xmm10
   613d4:	c4 41 25 76 db       	vpcmpeqd %ymm11,%ymm11,%ymm11
   613d9:	c4 02 25 90 14 8e    	vpgatherdd %ymm11,(%r14,%ymm9,4),%ymm10
   613df:	c5 c5 db f8          	vpand  %ymm0,%ymm7,%ymm7
   613e3:	c4 c1 35 72 d0 0a    	vpsrld $0xa,%ymm8,%ymm9
   613e9:	c5 35 db ca          	vpand  %ymm2,%ymm9,%ymm9
   613ed:	c4 41 21 ef db       	vpxor  %xmm11,%xmm11,%xmm11
   613f2:	c4 41 1d 76 e4       	vpcmpeqd %ymm12,%ymm12,%ymm12
   613f7:	c4 02 1d 90 1c 8e    	vpgatherdd %ymm12,(%r14,%ymm9,4),%ymm11
   613fd:	c4 c1 35 72 d0 14    	vpsrld $0x14,%ymm8,%ymm9
   61403:	c5 35 db cc          	vpand  %ymm4,%ymm9,%ymm9
   61407:	c4 c1 1d 72 d0 05    	vpsrld $0x5,%ymm8,%ymm12
   6140d:	c5 1d db e2          	vpand  %ymm2,%ymm12,%ymm12
   61411:	c4 42 2d 47 ec       	vpsllvd %ymm12,%ymm10,%ymm13
   61416:	c4 41 65 fa e4       	vpsubd %ymm12,%ymm3,%ymm12
   6141b:	c4 42 2d 45 d4       	vpsrlvd %ymm12,%ymm10,%ymm10
   61420:	c4 41 15 eb d2       	vpor   %ymm10,%ymm13,%ymm10
   61425:	c4 c1 3d 72 d0 0f    	vpsrld $0xf,%ymm8,%ymm8
   6142b:	c5 3d db c2          	vpand  %ymm2,%ymm8,%ymm8
   6142f:	c4 41 19 ef e4       	vpxor  %xmm12,%xmm12,%xmm12
   61434:	c4 41 15 76 ed       	vpcmpeqd %ymm13,%ymm13,%ymm13
   61439:	c4 42 15 90 24 bb    	vpgatherdd %ymm13,(%r11,%ymm7,4),%ymm12
   6143f:	c4 42 25 47 e8       	vpsllvd %ymm8,%ymm11,%ymm13
   61444:	c4 41 65 fa c0       	vpsubd %ymm8,%ymm3,%ymm8
   61449:	c4 42 25 45 c0       	vpsrlvd %ymm8,%ymm11,%ymm8
   6144e:	62 73 45 28 25 cd 36 	vpternlogd $0x36,%ymm5,%ymm7,%ymm9
   61455:	c5 c1 ef ff          	vpxor  %xmm7,%xmm7,%xmm7
   61459:	c4 41 25 76 db       	vpcmpeqd %ymm11,%ymm11,%ymm11
   6145e:	c4 82 25 90 3c 8b    	vpgatherdd %ymm11,(%r11,%ymm9,4),%ymm7
   61464:	c4 41 15 eb c0       	vpor   %ymm8,%ymm13,%ymm8
   61469:	c4 41 2d db cc       	vpand  %ymm12,%ymm10,%ymm9
   6146e:	62 d1 35 28 76 ca    	vpcmpeqd %ymm10,%ymm9,%k1
   61474:	c5 bd db ff          	vpand  %ymm7,%ymm8,%ymm7
   61478:	62 d1 45 29 76 c0    	vpcmpeqd %ymm8,%ymm7,%k0{%k1}
   6147e:	62 f2 7e 28 38 f8    	vpmovm2d %k0,%ymm7
   61484:	c5 c5 db fe          	vpand  %ymm6,%ymm7,%ymm7
   61488:	c4 a1 7e 7f 3c b8    	vmovdqu %ymm7,(%rax,%r15,4)
   6148e:	49 83 c7 08          	add    $0x8,%r15
   61492:	48 83 c1 10          	add    $0x10,%rcx
   61496:	48 39 d1             	cmp    %rdx,%rcx
   61499:	0f 86 11 ff ff ff    	jbe    613b0 <compare_benchmark::lookup+0xc00>
   6149f:	49 39 d7             	cmp    %rdx,%r15
   614a2:	0f 83 77 01 00 00    	jae    6161f <compare_benchmark::lookup+0xe6f>
   614a8:	49 39 d7             	cmp    %rdx,%r15
   614ab:	48 89 d7             	mov    %rdx,%rdi
   614ae:	49 0f 47 ff          	cmova  %r15,%rdi
   614b2:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   614b9:	1f 84 00 00 00 00 00 
   614c0:	4e 8b 14 fe          	mov    (%rsi,%r15,8),%r10
   614c4:	4d 89 d4             	mov    %r10,%r12
   614c7:	49 c1 ec 20          	shr    $0x20,%r12
   614cb:	41 21 dc             	and    %ebx,%r12d
   614ce:	45 89 e1             	mov    %r12d,%r9d
   614d1:	41 c1 e9 04          	shr    $0x4,%r9d
   614d5:	4c 3b 0c 24          	cmp    (%rsp),%r9
   614d9:	0f 83 d7 01 00 00    	jae    616b6 <compare_benchmark::lookup+0xf06>
   614df:	4c 39 ff             	cmp    %r15,%rdi
   614e2:	0f 84 b8 01 00 00    	je     616a0 <compare_benchmark::lookup+0xef0>
   614e8:	49 c1 e1 06          	shl    $0x6,%r9
   614ec:	4d 01 d9             	add    %r11,%r9
   614ef:	45 89 e5             	mov    %r12d,%r13d
   614f2:	41 83 e5 0f          	and    $0xf,%r13d
   614f6:	44 89 d1             	mov    %r10d,%ecx
   614f9:	83 e1 1f             	and    $0x1f,%ecx
   614fc:	45 8b 04 8e          	mov    (%r14,%rcx,4),%r8d
   61500:	44 89 d1             	mov    %r10d,%ecx
   61503:	c1 e9 05             	shr    $0x5,%ecx
   61506:	41 d3 c0             	rol    %cl,%r8d
   61509:	43 8b 2c a9          	mov    (%r9,%r13,4),%ebp
   6150d:	44 21 c5             	and    %r8d,%ebp
   61510:	44 31 c5             	xor    %r8d,%ebp
   61513:	45 89 d0             	mov    %r10d,%r8d
   61516:	41 c1 e8 14          	shr    $0x14,%r8d
   6151a:	41 83 c8 08          	or     $0x8,%r8d
   6151e:	45 31 e0             	xor    %r12d,%r8d
   61521:	44 89 d1             	mov    %r10d,%ecx
   61524:	c1 e9 08             	shr    $0x8,%ecx
   61527:	83 e1 7c             	and    $0x7c,%ecx
   6152a:	45 8b 24 0e          	mov    (%r14,%rcx,1),%r12d
   6152e:	41 c1 ea 0f          	shr    $0xf,%r10d
   61532:	44 89 d1             	mov    %r10d,%ecx
   61535:	41 d3 c4             	rol    %cl,%r12d
   61538:	41 83 e0 0f          	and    $0xf,%r8d
   6153c:	43 8b 0c 81          	mov    (%r9,%r8,4),%ecx
   61540:	44 21 e1             	and    %r12d,%ecx
   61543:	44 31 e1             	xor    %r12d,%ecx
   61546:	45 31 c0             	xor    %r8d,%r8d
   61549:	09 e9                	or     %ebp,%ecx
   6154b:	41 0f 94 c0          	sete   %r8b
   6154f:	46 89 04 b8          	mov    %r8d,(%rax,%r15,4)
   61553:	49 ff c7             	inc    %r15
   61556:	4c 39 fa             	cmp    %r15,%rdx
   61559:	0f 85 61 ff ff ff    	jne    614c0 <compare_benchmark::lookup+0xd10>
   6155f:	e9 bb 00 00 00       	jmp    6161f <compare_benchmark::lookup+0xe6f>
   61564:	49 39 d7             	cmp    %rdx,%r15
   61567:	0f 83 b2 00 00 00    	jae    6161f <compare_benchmark::lookup+0xe6f>
   6156d:	49 39 d7             	cmp    %rdx,%r15
   61570:	48 89 d7             	mov    %rdx,%rdi
   61573:	49 0f 47 ff          	cmova  %r15,%rdi
   61577:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
   6157e:	00 00 
   61580:	4e 8b 14 fe          	mov    (%rsi,%r15,8),%r10
   61584:	4d 89 d4             	mov    %r10,%r12
   61587:	49 c1 ec 20          	shr    $0x20,%r12
   6158b:	41 21 dc             	and    %ebx,%r12d
   6158e:	45 89 e1             	mov    %r12d,%r9d
   61591:	41 c1 e9 04          	shr    $0x4,%r9d
   61595:	4c 3b 0c 24          	cmp    (%rsp),%r9
   61599:	0f 83 17 01 00 00    	jae    616b6 <compare_benchmark::lookup+0xf06>
   6159f:	4c 39 ff             	cmp    %r15,%rdi
   615a2:	0f 84 f8 00 00 00    	je     616a0 <compare_benchmark::lookup+0xef0>
   615a8:	49 c1 e1 06          	shl    $0x6,%r9
   615ac:	4d 01 d9             	add    %r11,%r9
   615af:	45 89 e0             	mov    %r12d,%r8d
   615b2:	41 83 e0 0f          	and    $0xf,%r8d
   615b6:	44 89 d1             	mov    %r10d,%ecx
   615b9:	83 e1 1f             	and    $0x1f,%ecx
   615bc:	45 8b 2c 8e          	mov    (%r14,%rcx,4),%r13d
   615c0:	44 89 d1             	mov    %r10d,%ecx
   615c3:	c1 e9 05             	shr    $0x5,%ecx
   615c6:	41 d3 c5             	rol    %cl,%r13d
   615c9:	43 8b 2c 81          	mov    (%r9,%r8,4),%ebp
   615cd:	44 21 ed             	and    %r13d,%ebp
   615d0:	44 31 ed             	xor    %r13d,%ebp
   615d3:	45 89 d0             	mov    %r10d,%r8d
   615d6:	41 c1 e8 14          	shr    $0x14,%r8d
   615da:	41 83 c8 08          	or     $0x8,%r8d
   615de:	45 31 e0             	xor    %r12d,%r8d
   615e1:	44 89 d1             	mov    %r10d,%ecx
   615e4:	c1 e9 08             	shr    $0x8,%ecx
   615e7:	83 e1 7c             	and    $0x7c,%ecx
   615ea:	45 8b 24 0e          	mov    (%r14,%rcx,1),%r12d
   615ee:	41 c1 ea 0f          	shr    $0xf,%r10d
   615f2:	44 89 d1             	mov    %r10d,%ecx
   615f5:	41 d3 c4             	rol    %cl,%r12d
   615f8:	41 83 e0 0f          	and    $0xf,%r8d
   615fc:	43 8b 0c 81          	mov    (%r9,%r8,4),%ecx
   61600:	44 21 e1             	and    %r12d,%ecx
   61603:	44 31 e1             	xor    %r12d,%ecx
   61606:	45 31 c0             	xor    %r8d,%r8d
   61609:	09 e9                	or     %ebp,%ecx
   6160b:	41 0f 94 c0          	sete   %r8b
   6160f:	46 89 04 b8          	mov    %r8d,(%rax,%r15,4)
   61613:	49 ff c7             	inc    %r15
   61616:	4c 39 fa             	cmp    %r15,%rdx
   61619:	0f 85 61 ff ff ff    	jne    61580 <compare_benchmark::lookup+0xdd0>
   6161f:	48 83 c4 48          	add    $0x48,%rsp
   61623:	5b                   	pop    %rbx
   61624:	41 5c                	pop    %r12
   61626:	41 5d                	pop    %r13
   61628:	41 5e                	pop    %r14
   6162a:	41 5f                	pop    %r15
   6162c:	5d                   	pop    %rbp
   6162d:	c5 f8 77             	vzeroupper
   61630:	c3                   	ret
   61631:	48 8d 05 88 33 05 00 	lea    0x53388(%rip),%rax        # b49c0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0x1f0>
   61638:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
   6163d:	48 c7 44 24 20 01 00 	movq   $0x1,0x20(%rsp)
   61644:	00 00 
   61646:	48 c7 44 24 28 08 00 	movq   $0x8,0x28(%rsp)
   6164d:	00 00 
   6164f:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
   61653:	c5 f8 11 44 24 30    	vmovups %xmm0,0x30(%rsp)
   61659:	4c 8d 05 98 3c 05 00 	lea    0x53c98(%rip),%r8        # b52f8 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0xb28>
   61660:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
   61665:	48 8d 54 24 10       	lea    0x10(%rsp),%rdx
   6166a:	48 8d 4c 24 18       	lea    0x18(%rsp),%rcx
   6166f:	31 ff                	xor    %edi,%edi
   61671:	ff 15 79 71 05 00    	call   *0x57179(%rip)        # b87f0 <_DYNAMIC+0x3d8>
   61677:	48 8d 15 1a 3c 05 00 	lea    0x53c1a(%rip),%rdx        # b5298 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0xac8>
   6167e:	4c 89 c6             	mov    %r8,%rsi
   61681:	c5 f8 77             	vzeroupper
   61684:	ff 15 ee 6f 05 00    	call   *0x56fee(%rip)        # b8678 <_DYNAMIC+0x260>
   6168a:	48 8d 05 ef 3b 05 00 	lea    0x53bef(%rip),%rax        # b5280 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0xab0>
   61691:	48 89 d6             	mov    %rdx,%rsi
   61694:	48 89 c2             	mov    %rax,%rdx
   61697:	c5 f8 77             	vzeroupper
   6169a:	ff 15 d8 6f 05 00    	call   *0x56fd8(%rip)        # b8678 <_DYNAMIC+0x260>
   616a0:	48 8d 05 c1 3b 05 00 	lea    0x53bc1(%rip),%rax        # b5268 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0xa98>
   616a7:	48 89 d6             	mov    %rdx,%rsi
   616aa:	48 89 c2             	mov    %rax,%rdx
   616ad:	c5 f8 77             	vzeroupper
   616b0:	ff 15 c2 6f 05 00    	call   *0x56fc2(%rip)        # b8678 <_DYNAMIC+0x260>
   616b6:	48 8d 15 db 3b 05 00 	lea    0x53bdb(%rip),%rdx        # b5298 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0xac8>
   616bd:	4c 89 cf             	mov    %r9,%rdi
   616c0:	48 8b 34 24          	mov    (%rsp),%rsi
   616c4:	c5 f8 77             	vzeroupper
   616c7:	ff 15 ab 6f 05 00    	call   *0x56fab(%rip)        # b8678 <_DYNAMIC+0x260>
   616cd:	48 8d 15 c4 3b 05 00 	lea    0x53bc4(%rip),%rdx        # b5298 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0xac8>
   616d4:	4c 89 cf             	mov    %r9,%rdi
   616d7:	4c 89 c6             	mov    %r8,%rsi
   616da:	ff 15 98 6f 05 00    	call   *0x56f98(%rip)        # b8678 <_DYNAMIC+0x260>

