0000000000075e90 <fastest_bloom_filter_short_v3::byte_split::ByteSplitBloomFilter::lookup_hashes_bulk>:
   75e90:	55                   	push   %rbp
   75e91:	41 57                	push   %r15
   75e93:	41 56                	push   %r14
   75e95:	41 55                	push   %r13
   75e97:	41 54                	push   %r12
   75e99:	53                   	push   %rbx
   75e9a:	50                   	push   %rax
   75e9b:	80 7f 1c 00          	cmpb   $0x0,0x1c(%rdi)
   75e9f:	74 29                	je     75eca <fastest_bloom_filter_short_v3::byte_split::ByteSplitBloomFilter::lookup_hashes_bulk+0x3a>
   75ea1:	49 39 d0             	cmp    %rdx,%r8
   75ea4:	49 0f 42 d0          	cmovb  %r8,%rdx
   75ea8:	48 85 d2             	test   %rdx,%rdx
   75eab:	0f 84 a7 02 00 00    	je     76158 <fastest_bloom_filter_short_v3::byte_split::ByteSplitBloomFilter::lookup_hashes_bulk+0x2c8>
   75eb1:	8b 47 18             	mov    0x18(%rdi),%eax
   75eb4:	48 8b 7f 08          	mov    0x8(%rdi),%rdi
   75eb8:	48 83 fa 01          	cmp    $0x1,%rdx
   75ebc:	0f 85 b9 01 00 00    	jne    7607b <fastest_bloom_filter_short_v3::byte_split::ByteSplitBloomFilter::lookup_hashes_bulk+0x1eb>
   75ec2:	45 31 d2             	xor    %r10d,%r10d
   75ec5:	e9 4c 02 00 00       	jmp    76116 <fastest_bloom_filter_short_v3::byte_split::ByteSplitBloomFilter::lookup_hashes_bulk+0x286>
   75eca:	49 39 d0             	cmp    %rdx,%r8
   75ecd:	49 0f 42 d0          	cmovb  %r8,%rdx
   75ed1:	48 85 d2             	test   %rdx,%rdx
   75ed4:	0f 84 7e 02 00 00    	je     76158 <fastest_bloom_filter_short_v3::byte_split::ByteSplitBloomFilter::lookup_hashes_bulk+0x2c8>
   75eda:	44 8b 47 18          	mov    0x18(%rdi),%r8d
   75ede:	4c 8b 4f 08          	mov    0x8(%rdi),%r9
   75ee2:	48 8b 47 10          	mov    0x10(%rdi),%rax
   75ee6:	45 31 d2             	xor    %r10d,%r10d
   75ee9:	c5 fd 6f 05 0f 2c f9 	vmovdqa -0x6d3f1(%rip),%ymm0        # 8b00 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x130>
   75ef0:	ff 
   75ef1:	62 f1 fd 48 6f 0d 05 	vmovdqa64 -0x69bfb(%rip),%zmm1        # c300 <anon.b245d78d28829f835f48a10d63243492.0.llvm.14563942429929576898+0x8f0>
   75ef8:	64 f9 ff 
   75efb:	62 f2 fd 48 59 15 93 	vpbroadcastq -0x6d56d(%rip),%zmm2        # 8998 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x283>
   75f02:	2a f9 ff 
   75f05:	c4 e2 79 58 1d 56 29 	vpbroadcastd -0x6d6aa(%rip),%xmm3        # 8864 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x14f>
   75f0c:	f9 ff 
   75f0e:	c5 fa 7e 25 6a 30 f9 	vmovq  -0x6cf96(%rip),%xmm4        # 8f80 <anon.35274091df3394f4211c680a8c77ed4a.34.llvm.9036914972901821666+0x110>
   75f15:	ff 
   75f16:	c5 d1 ef ed          	vpxor  %xmm5,%xmm5,%xmm5
   75f1a:	66 41 be 7f ff       	mov    $0xff7f,%r14w
   75f1f:	c5 fd 6f 35 99 2b f9 	vmovdqa -0x6d467(%rip),%ymm6        # 8ac0 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0xf0>
   75f26:	ff 
   75f27:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
   75f2e:	00 00 
   75f30:	4e 8b 24 d6          	mov    (%rsi,%r10,8),%r12
   75f34:	4d 89 e7             	mov    %r12,%r15
   75f37:	49 c1 ef 20          	shr    $0x20,%r15
   75f3b:	45 21 c7             	and    %r8d,%r15d
   75f3e:	44 89 ff             	mov    %r15d,%edi
   75f41:	c1 ef 02             	shr    $0x2,%edi
   75f44:	48 39 c7             	cmp    %rax,%rdi
   75f47:	0f 83 1d 02 00 00    	jae    7616a <fastest_bloom_filter_short_v3::byte_split::ByteSplitBloomFilter::lookup_hashes_bulk+0x2da>
   75f4d:	48 c1 e7 06          	shl    $0x6,%rdi
   75f51:	4c 01 cf             	add    %r9,%rdi
   75f54:	41 c1 e7 04          	shl    $0x4,%r15d
   75f58:	41 83 e7 30          	and    $0x30,%r15d
   75f5c:	c4 c1 79 6e fc       	vmovd  %r12d,%xmm7
   75f61:	41 c1 e4 10          	shl    $0x10,%r12d
   75f65:	c4 c3 41 22 fc 01    	vpinsrd $0x1,%r12d,%xmm7,%xmm7
   75f6b:	c5 c1 72 e7 10       	vpsrad $0x10,%xmm7,%xmm7
   75f70:	c4 62 7d 59 c7       	vpbroadcastq %xmm7,%ymm8
   75f75:	c5 3d f5 c0          	vpmaddwd %ymm0,%ymm8,%ymm8
   75f79:	c4 c1 79 7e fc       	vmovd  %xmm7,%r12d
   75f7e:	c4 c3 79 16 fd 01    	vpextrd $0x1,%xmm7,%r13d
   75f84:	45 85 ed             	test   %r13d,%r13d
   75f87:	41 0f 9f c5          	setg   %r13b
   75f8b:	41 0f 98 c3          	sets   %r11b
   75f8f:	45 85 e4             	test   %r12d,%r12d
   75f92:	41 0f 98 c4          	sets   %r12b
   75f96:	c5 c1 ef ff          	vpxor  %xmm7,%xmm7,%xmm7
   75f9a:	62 d2 75 48 36 f8    	vpermd %zmm8,%zmm1,%zmm7
   75fa0:	62 f2 45 48 45 fa    	vpsrlvd %zmm2,%zmm7,%zmm7
   75fa6:	62 f2 7e 48 31 ff    	vpmovdb %zmm7,%xmm7
   75fac:	0f 9f c3             	setg   %bl
   75faf:	c5 41 db c3          	vpand  %xmm3,%xmm7,%xmm8
   75fb3:	66 bd fd ff          	mov    $0xfffd,%bp
   75fb7:	c5 fb 92 cd          	kmovd  %ebp,%k1
   75fbb:	62 f1 55 09 64 c7    	vpcmpgtb %xmm7,%xmm5,%k0{%k1}
   75fc1:	c4 c1 7b 92 cb       	kmovd  %r11d,%k1
   75fc6:	c4 e3 f9 32 c9 0f    	kshiftlw $0xf,%k1,%k1
   75fcc:	c4 e3 f9 30 c9 0e    	kshiftrw $0xe,%k1,%k1
   75fd2:	c5 fc 45 c1          	korw   %k1,%k0,%k0
   75fd6:	66 41 bb f7 ff       	mov    $0xfff7,%r11w
   75fdb:	c4 c1 7b 92 cb       	kmovd  %r11d,%k1
   75fe0:	c5 fc 41 c1          	kandw  %k1,%k0,%k0
   75fe4:	c4 c1 7b 92 cc       	kmovd  %r12d,%k1
   75fe9:	c4 e3 f9 32 c9 0f    	kshiftlw $0xf,%k1,%k1
   75fef:	c4 e3 f9 30 c9 0c    	kshiftrw $0xc,%k1,%k1
   75ff5:	c5 fc 45 c1          	korw   %k1,%k0,%k0
   75ff9:	66 41 bb df ff       	mov    $0xffdf,%r11w
   75ffe:	c4 c1 7b 92 cb       	kmovd  %r11d,%k1
   76003:	c5 fc 41 c1          	kandw  %k1,%k0,%k0
   76007:	c4 c1 7b 92 cd       	kmovd  %r13d,%k1
   7600c:	c4 e3 f9 32 c9 0f    	kshiftlw $0xf,%k1,%k1
   76012:	c4 e3 f9 30 c9 0a    	kshiftrw $0xa,%k1,%k1
   76018:	c5 fc 45 c1          	korw   %k1,%k0,%k0
   7601c:	c4 c1 7b 92 ce       	kmovd  %r14d,%k1
   76021:	c5 fc 41 c1          	kandw  %k1,%k0,%k0
   76025:	c5 fb 92 cb          	kmovd  %ebx,%k1
   76029:	c4 e3 f9 32 c9 0f    	kshiftlw $0xf,%k1,%k1
   7602f:	c4 e3 f9 30 c9 08    	kshiftrw $0x8,%k1,%k1
   76035:	c5 fc 45 c1          	korw   %k1,%k0,%k0
   76039:	62 f2 fe 28 28 f8    	vpmovm2w %k0,%ymm7
   7603f:	62 f2 cd 28 8d ff    	vpermw %ymm7,%ymm6,%ymm7
   76045:	62 f2 fe 28 29 c7    	vpmovw2m %ymm7,%k0
   7604b:	c5 f8 44 c8          	knotw  %k0,%k1
   7604f:	62 d2 5d 89 00 f8    	vpshufb %xmm8,%xmm4,%xmm7{%k1}{z}
   76055:	c4 41 7a 6f 04 3f    	vmovdqu (%r15,%rdi,1),%xmm8
   7605b:	31 ff                	xor    %edi,%edi
   7605d:	c4 62 79 17 c7       	vptest %xmm7,%xmm8
   76062:	40 0f 92 c7          	setb   %dil
   76066:	42 89 3c 91          	mov    %edi,(%rcx,%r10,4)
   7606a:	49 ff c2             	inc    %r10
   7606d:	4c 39 d2             	cmp    %r10,%rdx
   76070:	0f 85 ba fe ff ff    	jne    75f30 <fastest_bloom_filter_short_v3::byte_split::ByteSplitBloomFilter::lookup_hashes_bulk+0xa0>
   76076:	e9 dd 00 00 00       	jmp    76158 <fastest_bloom_filter_short_v3::byte_split::ByteSplitBloomFilter::lookup_hashes_bulk+0x2c8>
   7607b:	49 89 d0             	mov    %rdx,%r8
   7607e:	49 83 e0 fe          	and    $0xfffffffffffffffe,%r8
   76082:	45 31 c9             	xor    %r9d,%r9d
   76085:	c5 f9 6f 05 b3 2f f9 	vmovdqa -0x6d04d(%rip),%xmm0        # 9040 <anon.35274091df3394f4211c680a8c77ed4a.34.llvm.9036914972901821666+0x1d0>
   7608c:	ff 
   7608d:	c4 e2 79 59 0d b2 28 	vpbroadcastq -0x6d74e(%rip),%xmm1        # 8948 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x233>
   76094:	f9 ff 
   76096:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
   7609d:	00 00 00 
   760a0:	4e 8b 14 ce          	mov    (%rsi,%r9,8),%r10
   760a4:	62 d2 7d 08 7c d2    	vpbroadcastd %r10d,%xmm2
   760aa:	49 c1 ea 20          	shr    $0x20,%r10
   760ae:	41 21 c2             	and    %eax,%r10d
   760b1:	49 c1 e2 04          	shl    $0x4,%r10
   760b5:	c4 a1 79 6f 1c 17    	vmovdqa (%rdi,%r10,1),%xmm3
   760bb:	c5 e9 e5 d0          	vpmulhw %xmm0,%xmm2,%xmm2
   760bf:	c4 e2 71 00 d2       	vpshufb %xmm2,%xmm1,%xmm2
   760c4:	45 31 d2             	xor    %r10d,%r10d
   760c7:	c4 e2 79 17 da       	vptest %xmm2,%xmm3
   760cc:	41 0f 92 c2          	setb   %r10b
   760d0:	46 89 14 89          	mov    %r10d,(%rcx,%r9,4)
   760d4:	4e 8b 54 ce 08       	mov    0x8(%rsi,%r9,8),%r10
   760d9:	62 d2 7d 08 7c d2    	vpbroadcastd %r10d,%xmm2
   760df:	49 c1 ea 20          	shr    $0x20,%r10
   760e3:	41 21 c2             	and    %eax,%r10d
   760e6:	49 c1 e2 04          	shl    $0x4,%r10
   760ea:	c4 a1 79 6f 1c 17    	vmovdqa (%rdi,%r10,1),%xmm3
   760f0:	c5 e9 e5 d0          	vpmulhw %xmm0,%xmm2,%xmm2
   760f4:	c4 e2 71 00 d2       	vpshufb %xmm2,%xmm1,%xmm2
   760f9:	45 31 db             	xor    %r11d,%r11d
   760fc:	c4 e2 79 17 da       	vptest %xmm2,%xmm3
   76101:	4d 8d 51 02          	lea    0x2(%r9),%r10
   76105:	41 0f 92 c3          	setb   %r11b
   76109:	46 89 5c 89 04       	mov    %r11d,0x4(%rcx,%r9,4)
   7610e:	4d 89 d1             	mov    %r10,%r9
   76111:	4d 39 d0             	cmp    %r10,%r8
   76114:	75 8a                	jne    760a0 <fastest_bloom_filter_short_v3::byte_split::ByteSplitBloomFilter::lookup_hashes_bulk+0x210>
   76116:	f6 c2 01             	test   $0x1,%dl
   76119:	74 3d                	je     76158 <fastest_bloom_filter_short_v3::byte_split::ByteSplitBloomFilter::lookup_hashes_bulk+0x2c8>
   7611b:	4a 8b 14 d6          	mov    (%rsi,%r10,8),%rdx
   7611f:	62 f2 7d 08 7c c2    	vpbroadcastd %edx,%xmm0
   76125:	48 c1 ea 20          	shr    $0x20,%rdx
   76129:	21 d0                	and    %edx,%eax
   7612b:	48 c1 e0 04          	shl    $0x4,%rax
   7612f:	c5 f9 6f 0c 07       	vmovdqa (%rdi,%rax,1),%xmm1
   76134:	c5 f9 e5 05 04 2f f9 	vpmulhw -0x6d0fc(%rip),%xmm0,%xmm0        # 9040 <anon.35274091df3394f4211c680a8c77ed4a.34.llvm.9036914972901821666+0x1d0>
   7613b:	ff 
   7613c:	c4 e2 79 59 15 03 28 	vpbroadcastq -0x6d7fd(%rip),%xmm2        # 8948 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x233>
   76143:	f9 ff 
   76145:	c4 e2 69 00 c0       	vpshufb %xmm0,%xmm2,%xmm0
   7614a:	31 c0                	xor    %eax,%eax
   7614c:	c4 e2 79 17 c8       	vptest %xmm0,%xmm1
   76151:	0f 92 c0             	setb   %al
   76154:	42 89 04 91          	mov    %eax,(%rcx,%r10,4)
   76158:	48 83 c4 08          	add    $0x8,%rsp
   7615c:	5b                   	pop    %rbx
   7615d:	41 5c                	pop    %r12
   7615f:	41 5d                	pop    %r13
   76161:	41 5e                	pop    %r14
   76163:	41 5f                	pop    %r15
   76165:	5d                   	pop    %rbp
   76166:	c5 f8 77             	vzeroupper
   76169:	c3                   	ret
   7616a:	48 8d 15 e7 01 04 00 	lea    0x401e7(%rip),%rdx        # b6358 <anon.abf104a84019cbc1bb0d904df564a1ce.60.llvm.13157284832119116749+0x130>
   76171:	48 89 c6             	mov    %rax,%rsi
   76174:	c5 f8 77             	vzeroupper
   76177:	ff 15 fb 24 04 00    	call   *0x424fb(%rip)        # b8678 <_DYNAMIC+0x260>
   7617d:	cc                   	int3
   7617e:	cc                   	int3
   7617f:	cc                   	int3

