
/tmp/fastest-bf-rust-byte-external/release/compare_benchmark:     file format elf64-x86-64


Disassembly of section .text:

000000000004b120 <fastest_bloom_filter::split64::Split64BloomFilter::lookup_hashes>:
   4b120:	55                   	push   %rbp
   4b121:	41 57                	push   %r15
   4b123:	41 56                	push   %r14
   4b125:	41 55                	push   %r13
   4b127:	41 54                	push   %r12
   4b129:	53                   	push   %rbx
   4b12a:	48 83 ec 48          	sub    $0x48,%rsp
   4b12e:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
   4b133:	4c 89 44 24 10       	mov    %r8,0x10(%rsp)
   4b138:	4c 39 c2             	cmp    %r8,%rdx
   4b13b:	0f 85 31 07 00 00    	jne    4b872 <fastest_bloom_filter::split64::Split64BloomFilter::lookup_hashes+0x752>
   4b141:	48 89 cb             	mov    %rcx,%rbx
   4b144:	49 89 d7             	mov    %rdx,%r15
   4b147:	49 89 f6             	mov    %rsi,%r14
   4b14a:	49 89 fc             	mov    %rdi,%r12
   4b14d:	0f b6 47 1c          	movzbl 0x1c(%rdi),%eax
   4b151:	48 83 fa 01          	cmp    $0x1,%rdx
   4b155:	75 5a                	jne    4b1b1 <fastest_bloom_filter::split64::Split64BloomFilter::lookup_hashes+0x91>
   4b157:	84 c0                	test   %al,%al
   4b159:	0f 84 91 01 00 00    	je     4b2f0 <fastest_bloom_filter::split64::Split64BloomFilter::lookup_hashes+0x1d0>
   4b15f:	49 8b 06             	mov    (%r14),%rax
   4b162:	49 8b 4c 24 08       	mov    0x8(%r12),%rcx
   4b167:	62 f2 7d 28 7c c0    	vpbroadcastd %eax,%ymm0
   4b16d:	48 c1 e8 20          	shr    $0x20,%rax
   4b171:	41 23 44 24 18       	and    0x18(%r12),%eax
   4b176:	48 c1 e0 06          	shl    $0x6,%rax
   4b17a:	62 f1 fd 48 6f 0c 01 	vmovdqa64 (%rcx,%rax,1),%zmm1
   4b181:	c4 e2 7d 40 05 56 ce 	vpmulld -0x431aa(%rip),%ymm0,%ymm0        # 7fe0 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x110>
   4b188:	fb ff 
   4b18a:	c5 fd 72 d0 1a       	vpsrld $0x1a,%ymm0,%ymm0
   4b18f:	62 f2 7d 48 35 c0    	vpmovzxdq %ymm0,%zmm0
   4b195:	62 f2 f5 48 45 c0    	vpsrlvq %zmm0,%zmm1,%zmm0
   4b19b:	62 f2 fe 58 27 05 fb 	vptestnmq -0x43305(%rip){1to8},%zmm0,%k0        # 7ea0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x2ae>
   4b1a2:	cc fb ff 
   4b1a5:	c5 f9 98 c0          	kortestb %k0,%k0
   4b1a9:	0f 94 c0             	sete   %al
   4b1ac:	e9 8e 03 00 00       	jmp    4b53f <fastest_bloom_filter::split64::Split64BloomFilter::lookup_hashes+0x41f>
   4b1b1:	84 c0                	test   %al,%al
   4b1b3:	0f 84 b4 01 00 00    	je     4b36d <fastest_bloom_filter::split64::Split64BloomFilter::lookup_hashes+0x24d>
   4b1b9:	49 83 ff 10          	cmp    $0x10,%r15
   4b1bd:	0f 83 a7 02 00 00    	jae    4b46a <fastest_bloom_filter::split64::Split64BloomFilter::lookup_hashes+0x34a>
   4b1c3:	4d 85 ff             	test   %r15,%r15
   4b1c6:	0f 84 78 03 00 00    	je     4b544 <fastest_bloom_filter::split64::Split64BloomFilter::lookup_hashes+0x424>
   4b1cc:	49 8b 4c 24 08       	mov    0x8(%r12),%rcx
   4b1d1:	41 8b 54 24 18       	mov    0x18(%r12),%edx
   4b1d6:	42 8d 34 bd 00 00 00 	lea    0x0(,%r15,4),%esi
   4b1dd:	00 
   4b1de:	83 e6 38             	and    $0x38,%esi
   4b1e1:	31 c0                	xor    %eax,%eax
   4b1e3:	62 f1 fd 48 6f 05 d3 	vmovdqa64 -0x4032d(%rip),%zmm0        # aec0 <anon.b245d78d28829f835f48a10d63243492.0.llvm.14563942429929576898+0x4b0>
   4b1ea:	fc fb ff 
   4b1ed:	62 f2 fd 48 59 0d a9 	vpbroadcastq -0x43357(%rip),%zmm1        # 7ea0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x2ae>
   4b1f4:	cc fb ff 
   4b1f7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
   4b1fe:	00 00 
   4b200:	49 8b 3c 46          	mov    (%r14,%rax,2),%rdi
   4b204:	41 89 f8             	mov    %edi,%r8d
   4b207:	48 c1 ef 20          	shr    $0x20,%rdi
   4b20b:	21 d7                	and    %edx,%edi
   4b20d:	48 c1 e7 06          	shl    $0x6,%rdi
   4b211:	62 d2 fd 48 7c d0    	vpbroadcastq %r8,%zmm2
   4b217:	62 f2 6d 48 40 d0    	vpmulld %zmm0,%zmm2,%zmm2
   4b21d:	62 f1 fd 48 6f 1c 39 	vmovdqa64 (%rcx,%rdi,1),%zmm3
   4b224:	62 f1 ed 48 73 d2 1a 	vpsrlq $0x1a,%zmm2,%zmm2
   4b22b:	62 f2 e5 48 45 d2    	vpsrlvq %zmm2,%zmm3,%zmm2
   4b231:	62 f2 ee 48 27 c1    	vptestnmq %zmm1,%zmm2,%k0
   4b237:	31 ff                	xor    %edi,%edi
   4b239:	c5 f9 98 c0          	kortestb %k0,%k0
   4b23d:	40 0f 94 c7          	sete   %dil
   4b241:	89 3c 03             	mov    %edi,(%rbx,%rax,1)
   4b244:	49 8b 7c 46 08       	mov    0x8(%r14,%rax,2),%rdi
   4b249:	41 89 f8             	mov    %edi,%r8d
   4b24c:	48 c1 ef 20          	shr    $0x20,%rdi
   4b250:	21 d7                	and    %edx,%edi
   4b252:	48 c1 e7 06          	shl    $0x6,%rdi
   4b256:	62 d2 fd 48 7c d0    	vpbroadcastq %r8,%zmm2
   4b25c:	62 f2 6d 48 40 d0    	vpmulld %zmm0,%zmm2,%zmm2
   4b262:	62 f1 fd 48 6f 1c 39 	vmovdqa64 (%rcx,%rdi,1),%zmm3
   4b269:	62 f1 ed 48 73 d2 1a 	vpsrlq $0x1a,%zmm2,%zmm2
   4b270:	62 f2 e5 48 45 d2    	vpsrlvq %zmm2,%zmm3,%zmm2
   4b276:	62 f2 ee 48 27 c1    	vptestnmq %zmm1,%zmm2,%k0
   4b27c:	31 ff                	xor    %edi,%edi
   4b27e:	c5 f9 98 c0          	kortestb %k0,%k0
   4b282:	40 0f 94 c7          	sete   %dil
   4b286:	89 7c 03 04          	mov    %edi,0x4(%rbx,%rax,1)
   4b28a:	48 83 c0 08          	add    $0x8,%rax
   4b28e:	48 39 c6             	cmp    %rax,%rsi
   4b291:	0f 85 69 ff ff ff    	jne    4b200 <fastest_bloom_filter::split64::Split64BloomFilter::lookup_hashes+0xe0>
   4b297:	41 f6 c7 01          	test   $0x1,%r15b
   4b29b:	0f 84 a3 02 00 00    	je     4b544 <fastest_bloom_filter::split64::Split64BloomFilter::lookup_hashes+0x424>
   4b2a1:	49 8b 34 46          	mov    (%r14,%rax,2),%rsi
   4b2a5:	89 f7                	mov    %esi,%edi
   4b2a7:	48 c1 ee 20          	shr    $0x20,%rsi
   4b2ab:	21 f2                	and    %esi,%edx
   4b2ad:	62 f2 fd 48 7c c7    	vpbroadcastq %rdi,%zmm0
   4b2b3:	62 f2 7d 48 40 05 03 	vpmulld -0x403fd(%rip),%zmm0,%zmm0        # aec0 <anon.b245d78d28829f835f48a10d63243492.0.llvm.14563942429929576898+0x4b0>
   4b2ba:	fc fb ff 
   4b2bd:	48 c1 e2 06          	shl    $0x6,%rdx
   4b2c1:	62 f1 fd 48 6f 0c 11 	vmovdqa64 (%rcx,%rdx,1),%zmm1
   4b2c8:	62 f1 fd 48 73 d0 1a 	vpsrlq $0x1a,%zmm0,%zmm0
   4b2cf:	62 f2 f5 48 45 c0    	vpsrlvq %zmm0,%zmm1,%zmm0
   4b2d5:	62 f2 fe 58 27 05 c1 	vptestnmq -0x4343f(%rip){1to8},%zmm0,%k0        # 7ea0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x2ae>
   4b2dc:	cb fb ff 
   4b2df:	31 c9                	xor    %ecx,%ecx
   4b2e1:	c5 f9 98 c0          	kortestb %k0,%k0
   4b2e5:	0f 94 c1             	sete   %cl
   4b2e8:	89 0c 03             	mov    %ecx,(%rbx,%rax,1)
   4b2eb:	e9 54 02 00 00       	jmp    4b544 <fastest_bloom_filter::split64::Split64BloomFilter::lookup_hashes+0x424>
   4b2f0:	49 8b 36             	mov    (%r14),%rsi
   4b2f3:	41 80 7c 24 1d 00    	cmpb   $0x0,0x1d(%r12)
   4b2f9:	0f 84 38 02 00 00    	je     4b537 <fastest_bloom_filter::split64::Split64BloomFilter::lookup_hashes+0x417>
   4b2ff:	48 89 f0             	mov    %rsi,%rax
   4b302:	48 c1 e8 20          	shr    $0x20,%rax
   4b306:	41 23 44 24 18       	and    0x18(%r12),%eax
   4b30b:	49 8b 4c 24 08       	mov    0x8(%r12),%rcx
   4b310:	48 c1 e0 06          	shl    $0x6,%rax
   4b314:	62 f2 7d 28 7c c6    	vpbroadcastd %esi,%ymm0
   4b31a:	c4 e2 7d 40 05 bd cc 	vpmulld -0x43343(%rip),%ymm0,%ymm0        # 7fe0 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x110>
   4b321:	fb ff 
   4b323:	c5 fd 72 d0 1a       	vpsrld $0x1a,%ymm0,%ymm0
   4b328:	c4 e2 7d 35 c8       	vpmovzxdq %xmm0,%ymm1
   4b32d:	c4 e2 7d 59 15 6a cb 	vpbroadcastq -0x43496(%rip),%ymm2        # 7ea0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x2ae>
   4b334:	fb ff 
   4b336:	c4 e2 ed 47 c9       	vpsllvq %ymm1,%ymm2,%ymm1
   4b33b:	c5 fd 6f 1c 01       	vmovdqa (%rcx,%rax,1),%ymm3
   4b340:	c5 fd 6f 64 01 20    	vmovdqa 0x20(%rcx,%rax,1),%ymm4
   4b346:	c4 e2 7d 17 d9       	vptest %ymm1,%ymm3
   4b34b:	0f 92 c1             	setb   %cl
   4b34e:	c4 e3 7d 39 c0 01    	vextracti128 $0x1,%ymm0,%xmm0
   4b354:	c4 e2 7d 35 c0       	vpmovzxdq %xmm0,%ymm0
   4b359:	c4 e2 ed 47 c0       	vpsllvq %ymm0,%ymm2,%ymm0
   4b35e:	c4 e2 7d 17 e0       	vptest %ymm0,%ymm4
   4b363:	0f 92 c0             	setb   %al
   4b366:	20 c8                	and    %cl,%al
   4b368:	e9 d2 01 00 00       	jmp    4b53f <fastest_bloom_filter::split64::Split64BloomFilter::lookup_hashes+0x41f>
   4b36d:	41 80 7c 24 1d 00    	cmpb   $0x0,0x1d(%r12)
   4b373:	0f 84 dd 01 00 00    	je     4b556 <fastest_bloom_filter::split64::Split64BloomFilter::lookup_hashes+0x436>
   4b379:	31 c0                	xor    %eax,%eax
   4b37b:	4c 89 f9             	mov    %r15,%rcx
   4b37e:	48 83 e9 20          	sub    $0x20,%rcx
   4b382:	48 0f 43 c1          	cmovae %rcx,%rax
   4b386:	0f 86 b6 00 00 00    	jbe    4b442 <fastest_bloom_filter::split64::Split64BloomFilter::lookup_hashes+0x322>
   4b38c:	49 8b 4c 24 08       	mov    0x8(%r12),%rcx
   4b391:	41 8b 54 24 18       	mov    0x18(%r12),%edx
   4b396:	bf 20 00 00 00       	mov    $0x20,%edi
   4b39b:	c5 fd 6f 05 3d cc fb 	vmovdqa -0x433c3(%rip),%ymm0        # 7fe0 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x110>
   4b3a2:	ff 
   4b3a3:	c4 e2 7d 59 0d f4 ca 	vpbroadcastq -0x4350c(%rip),%ymm1        # 7ea0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x2ae>
   4b3aa:	fb ff 
   4b3ac:	0f 1f 40 00          	nopl   0x0(%rax)
   4b3b0:	49 39 ff             	cmp    %rdi,%r15
   4b3b3:	0f 84 ff 04 00 00    	je     4b8b8 <fastest_bloom_filter::split64::Split64BloomFilter::lookup_hashes+0x798>
   4b3b9:	49 8b b4 fe 00 ff ff 	mov    -0x100(%r14,%rdi,8),%rsi
   4b3c0:	ff 
   4b3c1:	45 8b 44 fe 04       	mov    0x4(%r14,%rdi,8),%r8d
   4b3c6:	41 21 d0             	and    %edx,%r8d
   4b3c9:	49 c1 e0 06          	shl    $0x6,%r8
   4b3cd:	42 0f 18 0c 01       	prefetcht0 (%rcx,%r8,1)
   4b3d2:	62 f2 7d 28 7c d6    	vpbroadcastd %esi,%ymm2
   4b3d8:	48 c1 ee 20          	shr    $0x20,%rsi
   4b3dc:	21 d6                	and    %edx,%esi
   4b3de:	c4 e2 6d 40 d0       	vpmulld %ymm0,%ymm2,%ymm2
   4b3e3:	48 c1 e6 06          	shl    $0x6,%rsi
   4b3e7:	c5 ed 72 d2 1a       	vpsrld $0x1a,%ymm2,%ymm2
   4b3ec:	c4 e2 7d 35 da       	vpmovzxdq %xmm2,%ymm3
   4b3f1:	c4 e2 f5 47 db       	vpsllvq %ymm3,%ymm1,%ymm3
   4b3f6:	c4 e3 7d 39 d2 01    	vextracti128 $0x1,%ymm2,%xmm2
   4b3fc:	c4 e2 7d 35 d2       	vpmovzxdq %xmm2,%ymm2
   4b401:	c4 e2 f5 47 d2       	vpsllvq %ymm2,%ymm1,%ymm2
   4b406:	c5 fd 6f 24 31       	vmovdqa (%rcx,%rsi,1),%ymm4
   4b40b:	c4 e2 7d 17 e3       	vptest %ymm3,%ymm4
   4b410:	41 0f 92 c0          	setb   %r8b
   4b414:	c5 fd 6f 5c 31 20    	vmovdqa 0x20(%rcx,%rsi,1),%ymm3
   4b41a:	c4 e2 7d 17 da       	vptest %ymm2,%ymm3
   4b41f:	40 0f 92 c6          	setb   %sil
   4b423:	44 20 c6             	and    %r8b,%sil
   4b426:	40 0f b6 f6          	movzbl %sil,%esi
   4b42a:	89 74 bb 80          	mov    %esi,-0x80(%rbx,%rdi,4)
   4b42e:	48 8d 77 01          	lea    0x1(%rdi),%rsi
   4b432:	48 83 c7 e1          	add    $0xffffffffffffffe1,%rdi
   4b436:	48 39 c7             	cmp    %rax,%rdi
   4b439:	48 89 f7             	mov    %rsi,%rdi
   4b43c:	0f 82 6e ff ff ff    	jb     4b3b0 <fastest_bloom_filter::split64::Split64BloomFilter::lookup_hashes+0x290>
   4b442:	4c 89 fe             	mov    %r15,%rsi
   4b445:	48 29 c6             	sub    %rax,%rsi
   4b448:	0f 84 f6 00 00 00    	je     4b544 <fastest_bloom_filter::split64::Split64BloomFilter::lookup_hashes+0x424>
   4b44e:	49 8b 4c 24 08       	mov    0x8(%r12),%rcx
   4b453:	41 8b 54 24 18       	mov    0x18(%r12),%edx
   4b458:	48 83 fe 01          	cmp    $0x1,%rsi
   4b45c:	0f 85 1f 01 00 00    	jne    4b581 <fastest_bloom_filter::split64::Split64BloomFilter::lookup_hashes+0x461>
   4b462:	45 31 db             	xor    %r11d,%r11d
   4b465:	e9 3e 02 00 00       	jmp    4b6a8 <fastest_bloom_filter::split64::Split64BloomFilter::lookup_hashes+0x588>
   4b46a:	31 c0                	xor    %eax,%eax
   4b46c:	4c 89 f9             	mov    %r15,%rcx
   4b46f:	48 83 e9 20          	sub    $0x20,%rcx
   4b473:	48 0f 43 c1          	cmovae %rcx,%rax
   4b477:	0f 86 96 00 00 00    	jbe    4b513 <fastest_bloom_filter::split64::Split64BloomFilter::lookup_hashes+0x3f3>
   4b47d:	49 8b 4c 24 08       	mov    0x8(%r12),%rcx
   4b482:	41 8b 54 24 18       	mov    0x18(%r12),%edx
   4b487:	bf 20 00 00 00       	mov    $0x20,%edi
   4b48c:	c5 fd 6f 05 4c cb fb 	vmovdqa -0x434b4(%rip),%ymm0        # 7fe0 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x110>
   4b493:	ff 
   4b494:	62 f2 fd 48 59 0d 02 	vpbroadcastq -0x435fe(%rip),%zmm1        # 7ea0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x2ae>
   4b49b:	ca fb ff 
   4b49e:	66 90                	xchg   %ax,%ax
   4b4a0:	49 39 ff             	cmp    %rdi,%r15
   4b4a3:	0f 84 22 04 00 00    	je     4b8cb <fastest_bloom_filter::split64::Split64BloomFilter::lookup_hashes+0x7ab>
   4b4a9:	49 8b b4 fe 00 ff ff 	mov    -0x100(%r14,%rdi,8),%rsi
   4b4b0:	ff 
   4b4b1:	45 8b 44 fe 04       	mov    0x4(%r14,%rdi,8),%r8d
   4b4b6:	41 21 d0             	and    %edx,%r8d
   4b4b9:	49 c1 e0 06          	shl    $0x6,%r8
   4b4bd:	42 0f 18 0c 01       	prefetcht0 (%rcx,%r8,1)
   4b4c2:	62 f2 7d 28 7c d6    	vpbroadcastd %esi,%ymm2
   4b4c8:	48 c1 ee 20          	shr    $0x20,%rsi
   4b4cc:	21 d6                	and    %edx,%esi
   4b4ce:	48 c1 e6 06          	shl    $0x6,%rsi
   4b4d2:	62 f1 fd 48 6f 1c 31 	vmovdqa64 (%rcx,%rsi,1),%zmm3
   4b4d9:	c4 e2 6d 40 d0       	vpmulld %ymm0,%ymm2,%ymm2
   4b4de:	c5 ed 72 d2 1a       	vpsrld $0x1a,%ymm2,%ymm2
   4b4e3:	62 f2 7d 48 35 d2    	vpmovzxdq %ymm2,%zmm2
   4b4e9:	62 f2 e5 48 45 d2    	vpsrlvq %zmm2,%zmm3,%zmm2
   4b4ef:	62 f2 ee 48 27 c1    	vptestnmq %zmm1,%zmm2,%k0
   4b4f5:	31 f6                	xor    %esi,%esi
   4b4f7:	c5 f9 98 c0          	kortestb %k0,%k0
   4b4fb:	40 0f 94 c6          	sete   %sil
   4b4ff:	89 74 bb 80          	mov    %esi,-0x80(%rbx,%rdi,4)
   4b503:	48 8d 77 01          	lea    0x1(%rdi),%rsi
   4b507:	48 83 c7 e1          	add    $0xffffffffffffffe1,%rdi
   4b50b:	48 39 c7             	cmp    %rax,%rdi
   4b50e:	48 89 f7             	mov    %rsi,%rdi
   4b511:	72 8d                	jb     4b4a0 <fastest_bloom_filter::split64::Split64BloomFilter::lookup_hashes+0x380>
   4b513:	4c 89 fe             	mov    %r15,%rsi
   4b516:	48 29 c6             	sub    %rax,%rsi
   4b519:	74 29                	je     4b544 <fastest_bloom_filter::split64::Split64BloomFilter::lookup_hashes+0x424>
   4b51b:	49 8b 4c 24 08       	mov    0x8(%r12),%rcx
   4b520:	41 8b 54 24 18       	mov    0x18(%r12),%edx
   4b525:	48 83 fe 01          	cmp    $0x1,%rsi
   4b529:	0f 85 f9 01 00 00    	jne    4b728 <fastest_bloom_filter::split64::Split64BloomFilter::lookup_hashes+0x608>
   4b52f:	45 31 d2             	xor    %r10d,%r10d
   4b532:	e9 d8 02 00 00       	jmp    4b80f <fastest_bloom_filter::split64::Split64BloomFilter::lookup_hashes+0x6ef>
   4b537:	4c 89 e7             	mov    %r12,%rdi
   4b53a:	e8 a1 03 00 00       	call   4b8e0 <fastest_bloom_filter::split64::Split64BloomFilter::contains_scalar>
   4b53f:	0f b6 c0             	movzbl %al,%eax
   4b542:	89 03                	mov    %eax,(%rbx)
   4b544:	48 83 c4 48          	add    $0x48,%rsp
   4b548:	5b                   	pop    %rbx
   4b549:	41 5c                	pop    %r12
   4b54b:	41 5d                	pop    %r13
   4b54d:	41 5e                	pop    %r14
   4b54f:	41 5f                	pop    %r15
   4b551:	5d                   	pop    %rbp
   4b552:	c5 f8 77             	vzeroupper
   4b555:	c3                   	ret
   4b556:	4d 85 ff             	test   %r15,%r15
   4b559:	74 e9                	je     4b544 <fastest_bloom_filter::split64::Split64BloomFilter::lookup_hashes+0x424>
   4b55b:	45 31 ed             	xor    %r13d,%r13d
   4b55e:	66 90                	xchg   %ax,%ax
   4b560:	49 8d 6d 01          	lea    0x1(%r13),%rbp
   4b564:	4b 8b 34 ee          	mov    (%r14,%r13,8),%rsi
   4b568:	4c 89 e7             	mov    %r12,%rdi
   4b56b:	e8 70 03 00 00       	call   4b8e0 <fastest_bloom_filter::split64::Split64BloomFilter::contains_scalar>
   4b570:	0f b6 c0             	movzbl %al,%eax
   4b573:	42 89 04 ab          	mov    %eax,(%rbx,%r13,4)
   4b577:	49 89 ed             	mov    %rbp,%r13
   4b57a:	49 39 ef             	cmp    %rbp,%r15
   4b57d:	75 e1                	jne    4b560 <fastest_bloom_filter::split64::Split64BloomFilter::lookup_hashes+0x440>
   4b57f:	eb c3                	jmp    4b544 <fastest_bloom_filter::split64::Split64BloomFilter::lookup_hashes+0x424>
   4b581:	48 89 f7             	mov    %rsi,%rdi
   4b584:	48 83 e7 fe          	and    $0xfffffffffffffffe,%rdi
   4b588:	4c 8d 0c f5 00 00 00 	lea    0x0(,%rsi,8),%r9
   4b58f:	00 
   4b590:	4f 8d 04 fe          	lea    (%r14,%r15,8),%r8
   4b594:	4d 29 c8             	sub    %r9,%r8
   4b597:	49 83 c0 08          	add    $0x8,%r8
   4b59b:	4c 8d 14 b5 00 00 00 	lea    0x0(,%rsi,4),%r10
   4b5a2:	00 
   4b5a3:	4e 8d 0c bb          	lea    (%rbx,%r15,4),%r9
   4b5a7:	4d 29 d1             	sub    %r10,%r9
   4b5aa:	49 83 c1 04          	add    $0x4,%r9
   4b5ae:	45 31 d2             	xor    %r10d,%r10d
   4b5b1:	c5 fd 6f 05 27 ca fb 	vmovdqa -0x435d9(%rip),%ymm0        # 7fe0 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x110>
   4b5b8:	ff 
   4b5b9:	c4 e2 7d 59 0d de c8 	vpbroadcastq -0x43722(%rip),%ymm1        # 7ea0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x2ae>
   4b5c0:	fb ff 
   4b5c2:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   4b5c9:	1f 84 00 00 00 00 00 
   4b5d0:	4f 8b 5c d0 f8       	mov    -0x8(%r8,%r10,8),%r11
   4b5d5:	62 d2 7d 28 7c d3    	vpbroadcastd %r11d,%ymm2
   4b5db:	49 c1 eb 20          	shr    $0x20,%r11
   4b5df:	41 21 d3             	and    %edx,%r11d
   4b5e2:	49 c1 e3 06          	shl    $0x6,%r11
   4b5e6:	c4 e2 6d 40 d0       	vpmulld %ymm0,%ymm2,%ymm2
   4b5eb:	c5 ed 72 d2 1a       	vpsrld $0x1a,%ymm2,%ymm2
   4b5f0:	c4 e2 7d 35 da       	vpmovzxdq %xmm2,%ymm3
   4b5f5:	c4 e2 f5 47 db       	vpsllvq %ymm3,%ymm1,%ymm3
   4b5fa:	c4 e3 7d 39 d2 01    	vextracti128 $0x1,%ymm2,%xmm2
   4b600:	c4 e2 7d 35 d2       	vpmovzxdq %xmm2,%ymm2
   4b605:	c4 e2 f5 47 d2       	vpsllvq %ymm2,%ymm1,%ymm2
   4b60a:	c4 a1 7d 6f 24 19    	vmovdqa (%rcx,%r11,1),%ymm4
   4b610:	c4 a1 7d 6f 6c 19 20 	vmovdqa 0x20(%rcx,%r11,1),%ymm5
   4b617:	c4 e2 7d 17 e3       	vptest %ymm3,%ymm4
   4b61c:	41 0f 92 c3          	setb   %r11b
   4b620:	c4 e2 7d 17 ea       	vptest %ymm2,%ymm5
   4b625:	40 0f 92 c5          	setb   %bpl
   4b629:	44 20 dd             	and    %r11b,%bpl
   4b62c:	44 0f b6 dd          	movzbl %bpl,%r11d
   4b630:	47 89 5c 91 fc       	mov    %r11d,-0x4(%r9,%r10,4)
   4b635:	4f 8b 1c d0          	mov    (%r8,%r10,8),%r11
   4b639:	62 d2 7d 28 7c d3    	vpbroadcastd %r11d,%ymm2
   4b63f:	49 c1 eb 20          	shr    $0x20,%r11
   4b643:	41 21 d3             	and    %edx,%r11d
   4b646:	49 c1 e3 06          	shl    $0x6,%r11
   4b64a:	c4 e2 6d 40 d0       	vpmulld %ymm0,%ymm2,%ymm2
   4b64f:	c5 ed 72 d2 1a       	vpsrld $0x1a,%ymm2,%ymm2
   4b654:	c4 e2 7d 35 da       	vpmovzxdq %xmm2,%ymm3
   4b659:	c4 e2 f5 47 db       	vpsllvq %ymm3,%ymm1,%ymm3
   4b65e:	c4 e3 7d 39 d2 01    	vextracti128 $0x1,%ymm2,%xmm2
   4b664:	c4 e2 7d 35 d2       	vpmovzxdq %xmm2,%ymm2
   4b669:	c4 e2 f5 47 d2       	vpsllvq %ymm2,%ymm1,%ymm2
   4b66e:	c4 a1 7d 6f 24 19    	vmovdqa (%rcx,%r11,1),%ymm4
   4b674:	c4 a1 7d 6f 6c 19 20 	vmovdqa 0x20(%rcx,%r11,1),%ymm5
   4b67b:	c4 e2 7d 17 e3       	vptest %ymm3,%ymm4
   4b680:	40 0f 92 c5          	setb   %bpl
   4b684:	c4 e2 7d 17 ea       	vptest %ymm2,%ymm5
   4b689:	41 0f 92 c7          	setb   %r15b
   4b68d:	4d 8d 5a 02          	lea    0x2(%r10),%r11
   4b691:	41 20 ef             	and    %bpl,%r15b
   4b694:	41 0f b6 ef          	movzbl %r15b,%ebp
   4b698:	43 89 2c 91          	mov    %ebp,(%r9,%r10,4)
   4b69c:	4d 89 da             	mov    %r11,%r10
   4b69f:	4c 39 df             	cmp    %r11,%rdi
   4b6a2:	0f 85 28 ff ff ff    	jne    4b5d0 <fastest_bloom_filter::split64::Split64BloomFilter::lookup_hashes+0x4b0>
   4b6a8:	40 f6 c6 01          	test   $0x1,%sil
   4b6ac:	0f 84 92 fe ff ff    	je     4b544 <fastest_bloom_filter::split64::Split64BloomFilter::lookup_hashes+0x424>
   4b6b2:	49 8d 34 c6          	lea    (%r14,%rax,8),%rsi
   4b6b6:	48 8d 04 83          	lea    (%rbx,%rax,4),%rax
   4b6ba:	4a 8b 34 de          	mov    (%rsi,%r11,8),%rsi
   4b6be:	62 f2 7d 28 7c c6    	vpbroadcastd %esi,%ymm0
   4b6c4:	48 c1 ee 20          	shr    $0x20,%rsi
   4b6c8:	21 f2                	and    %esi,%edx
   4b6ca:	48 c1 e2 06          	shl    $0x6,%rdx
   4b6ce:	c4 e2 7d 40 05 09 c9 	vpmulld -0x436f7(%rip),%ymm0,%ymm0        # 7fe0 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x110>
   4b6d5:	fb ff 
   4b6d7:	c5 fd 72 d0 1a       	vpsrld $0x1a,%ymm0,%ymm0
   4b6dc:	c4 e2 7d 35 c8       	vpmovzxdq %xmm0,%ymm1
   4b6e1:	c4 e2 7d 59 15 b6 c7 	vpbroadcastq -0x4384a(%rip),%ymm2        # 7ea0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x2ae>
   4b6e8:	fb ff 
   4b6ea:	c4 e2 ed 47 c9       	vpsllvq %ymm1,%ymm2,%ymm1
   4b6ef:	c4 e3 7d 39 c0 01    	vextracti128 $0x1,%ymm0,%xmm0
   4b6f5:	c4 e2 7d 35 c0       	vpmovzxdq %xmm0,%ymm0
   4b6fa:	c4 e2 ed 47 c0       	vpsllvq %ymm0,%ymm2,%ymm0
   4b6ff:	c5 fd 6f 14 11       	vmovdqa (%rcx,%rdx,1),%ymm2
   4b704:	c5 fd 6f 5c 11 20    	vmovdqa 0x20(%rcx,%rdx,1),%ymm3
   4b70a:	c4 e2 7d 17 d1       	vptest %ymm1,%ymm2
   4b70f:	0f 92 c1             	setb   %cl
   4b712:	c4 e2 7d 17 d8       	vptest %ymm0,%ymm3
   4b717:	0f 92 c2             	setb   %dl
   4b71a:	20 ca                	and    %cl,%dl
   4b71c:	0f b6 ca             	movzbl %dl,%ecx
   4b71f:	42 89 0c 98          	mov    %ecx,(%rax,%r11,4)
   4b723:	e9 1c fe ff ff       	jmp    4b544 <fastest_bloom_filter::split64::Split64BloomFilter::lookup_hashes+0x424>
   4b728:	48 89 f7             	mov    %rsi,%rdi
   4b72b:	48 83 e7 fe          	and    $0xfffffffffffffffe,%rdi
   4b72f:	4c 8d 0c f5 00 00 00 	lea    0x0(,%rsi,8),%r9
   4b736:	00 
   4b737:	4f 8d 04 fe          	lea    (%r14,%r15,8),%r8
   4b73b:	4d 29 c8             	sub    %r9,%r8
   4b73e:	49 83 c0 08          	add    $0x8,%r8
   4b742:	4c 8d 14 b5 00 00 00 	lea    0x0(,%rsi,4),%r10
   4b749:	00 
   4b74a:	4e 8d 0c bb          	lea    (%rbx,%r15,4),%r9
   4b74e:	4d 29 d1             	sub    %r10,%r9
   4b751:	49 83 c1 04          	add    $0x4,%r9
   4b755:	45 31 db             	xor    %r11d,%r11d
   4b758:	c5 fd 6f 05 80 c8 fb 	vmovdqa -0x43780(%rip),%ymm0        # 7fe0 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x110>
   4b75f:	ff 
   4b760:	62 f2 fd 48 59 0d 36 	vpbroadcastq -0x438ca(%rip),%zmm1        # 7ea0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x2ae>
   4b767:	c7 fb ff 
   4b76a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
   4b770:	4f 8b 54 d8 f8       	mov    -0x8(%r8,%r11,8),%r10
   4b775:	62 d2 7d 28 7c d2    	vpbroadcastd %r10d,%ymm2
   4b77b:	49 c1 ea 20          	shr    $0x20,%r10
   4b77f:	41 21 d2             	and    %edx,%r10d
   4b782:	49 c1 e2 06          	shl    $0x6,%r10
   4b786:	62 b1 fd 48 6f 1c 11 	vmovdqa64 (%rcx,%r10,1),%zmm3
   4b78d:	c4 e2 6d 40 d0       	vpmulld %ymm0,%ymm2,%ymm2
   4b792:	c5 ed 72 d2 1a       	vpsrld $0x1a,%ymm2,%ymm2
   4b797:	62 f2 7d 48 35 d2    	vpmovzxdq %ymm2,%zmm2
   4b79d:	62 f2 e5 48 45 d2    	vpsrlvq %zmm2,%zmm3,%zmm2
   4b7a3:	62 f2 ee 48 27 c1    	vptestnmq %zmm1,%zmm2,%k0
   4b7a9:	45 31 d2             	xor    %r10d,%r10d
   4b7ac:	c5 f9 98 c0          	kortestb %k0,%k0
   4b7b0:	41 0f 94 c2          	sete   %r10b
   4b7b4:	47 89 54 99 fc       	mov    %r10d,-0x4(%r9,%r11,4)
   4b7b9:	4d 8d 53 02          	lea    0x2(%r11),%r10
   4b7bd:	4f 8b 3c d8          	mov    (%r8,%r11,8),%r15
   4b7c1:	62 d2 7d 28 7c d7    	vpbroadcastd %r15d,%ymm2
   4b7c7:	49 c1 ef 20          	shr    $0x20,%r15
   4b7cb:	41 21 d7             	and    %edx,%r15d
   4b7ce:	49 c1 e7 06          	shl    $0x6,%r15
   4b7d2:	c4 e2 6d 40 d0       	vpmulld %ymm0,%ymm2,%ymm2
   4b7d7:	62 b1 fd 48 6f 1c 39 	vmovdqa64 (%rcx,%r15,1),%zmm3
   4b7de:	c5 ed 72 d2 1a       	vpsrld $0x1a,%ymm2,%ymm2
   4b7e3:	62 f2 7d 48 35 d2    	vpmovzxdq %ymm2,%zmm2
   4b7e9:	62 f2 e5 48 45 d2    	vpsrlvq %zmm2,%zmm3,%zmm2
   4b7ef:	62 f2 ee 48 27 c1    	vptestnmq %zmm1,%zmm2,%k0
   4b7f5:	31 ed                	xor    %ebp,%ebp
   4b7f7:	c5 f9 98 c0          	kortestb %k0,%k0
   4b7fb:	40 0f 94 c5          	sete   %bpl
   4b7ff:	43 89 2c 99          	mov    %ebp,(%r9,%r11,4)
   4b803:	4d 89 d3             	mov    %r10,%r11
   4b806:	4c 39 d7             	cmp    %r10,%rdi
   4b809:	0f 85 61 ff ff ff    	jne    4b770 <fastest_bloom_filter::split64::Split64BloomFilter::lookup_hashes+0x650>
   4b80f:	40 f6 c6 01          	test   $0x1,%sil
   4b813:	0f 84 2b fd ff ff    	je     4b544 <fastest_bloom_filter::split64::Split64BloomFilter::lookup_hashes+0x424>
   4b819:	49 8d 34 c6          	lea    (%r14,%rax,8),%rsi
   4b81d:	48 8d 04 83          	lea    (%rbx,%rax,4),%rax
   4b821:	4a 8b 34 d6          	mov    (%rsi,%r10,8),%rsi
   4b825:	62 f2 7d 28 7c c6    	vpbroadcastd %esi,%ymm0
   4b82b:	48 c1 ee 20          	shr    $0x20,%rsi
   4b82f:	21 f2                	and    %esi,%edx
   4b831:	48 c1 e2 06          	shl    $0x6,%rdx
   4b835:	c4 e2 7d 40 05 a2 c7 	vpmulld -0x4385e(%rip),%ymm0,%ymm0        # 7fe0 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x110>
   4b83c:	fb ff 
   4b83e:	62 f1 fd 48 6f 0c 11 	vmovdqa64 (%rcx,%rdx,1),%zmm1
   4b845:	c5 fd 72 d0 1a       	vpsrld $0x1a,%ymm0,%ymm0
   4b84a:	62 f2 7d 48 35 c0    	vpmovzxdq %ymm0,%zmm0
   4b850:	62 f2 f5 48 45 c0    	vpsrlvq %zmm0,%zmm1,%zmm0
   4b856:	62 f2 fe 58 27 05 40 	vptestnmq -0x439c0(%rip){1to8},%zmm0,%k0        # 7ea0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x2ae>
   4b85d:	c6 fb ff 
   4b860:	31 c9                	xor    %ecx,%ecx
   4b862:	c5 f9 98 c0          	kortestb %k0,%k0
   4b866:	0f 94 c1             	sete   %cl
   4b869:	42 89 0c 90          	mov    %ecx,(%rax,%r10,4)
   4b86d:	e9 d2 fc ff ff       	jmp    4b544 <fastest_bloom_filter::split64::Split64BloomFilter::lookup_hashes+0x424>
   4b872:	48 8d 05 2f ef 03 00 	lea    0x3ef2f(%rip),%rax        # 8a7a8 <anon.b245d78d28829f835f48a10d63243492.2.llvm.14563942429929576898+0x18>
   4b879:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
   4b87e:	48 c7 44 24 20 01 00 	movq   $0x1,0x20(%rsp)
   4b885:	00 00 
   4b887:	48 c7 44 24 28 08 00 	movq   $0x8,0x28(%rsp)
   4b88e:	00 00 
   4b890:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
   4b894:	c5 f8 11 44 24 30    	vmovups %xmm0,0x30(%rsp)
   4b89a:	4c 8d 05 af f0 03 00 	lea    0x3f0af(%rip),%r8        # 8a950 <anon.b245d78d28829f835f48a10d63243492.2.llvm.14563942429929576898+0x1c0>
   4b8a1:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
   4b8a6:	48 8d 54 24 10       	lea    0x10(%rsp),%rdx
   4b8ab:	48 8d 4c 24 18       	lea    0x18(%rsp),%rcx
   4b8b0:	31 ff                	xor    %edi,%edi
   4b8b2:	ff 15 48 14 04 00    	call   *0x41448(%rip)        # 8cd00 <_DYNAMIC+0x398>
   4b8b8:	48 8d 15 49 f0 03 00 	lea    0x3f049(%rip),%rdx        # 8a908 <anon.b245d78d28829f835f48a10d63243492.2.llvm.14563942429929576898+0x178>
   4b8bf:	4c 89 fe             	mov    %r15,%rsi
   4b8c2:	c5 f8 77             	vzeroupper
   4b8c5:	ff 15 fd 12 04 00    	call   *0x412fd(%rip)        # 8cbc8 <_DYNAMIC+0x260>
   4b8cb:	48 8d 15 66 f0 03 00 	lea    0x3f066(%rip),%rdx        # 8a938 <anon.b245d78d28829f835f48a10d63243492.2.llvm.14563942429929576898+0x1a8>
   4b8d2:	4c 89 fe             	mov    %r15,%rsi
   4b8d5:	c5 f8 77             	vzeroupper
   4b8d8:	ff 15 ea 12 04 00    	call   *0x412ea(%rip)        # 8cbc8 <_DYNAMIC+0x260>
   4b8de:	cc                   	int3
   4b8df:	cc                   	int3
