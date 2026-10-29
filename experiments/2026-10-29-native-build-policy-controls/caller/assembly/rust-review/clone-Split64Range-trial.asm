000000000004bee0 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>>:
   4bee0:	55                   	push   %rbp
   4bee1:	41 57                	push   %r15
   4bee3:	41 56                	push   %r14
   4bee5:	41 55                	push   %r13
   4bee7:	41 54                	push   %r12
   4bee9:	53                   	push   %rbx
   4beea:	49 89 e3             	mov    %rsp,%r11
   4beed:	49 81 eb 00 80 00 00 	sub    $0x8000,%r11
   4bef4:	48 81 ec 00 10 00 00 	sub    $0x1000,%rsp
   4befb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
   4bf02:	00 
   4bf03:	4c 39 dc             	cmp    %r11,%rsp
   4bf06:	75 ec                	jne    4bef4 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0x14>
   4bf08:	48 81 ec e8 00 00 00 	sub    $0xe8,%rsp
   4bf0f:	4c 89 4c 24 08       	mov    %r9,0x8(%rsp)
   4bf14:	48 89 74 24 30       	mov    %rsi,0x30(%rsp)
   4bf19:	4c 8b 77 10          	mov    0x10(%rdi),%r14
   4bf1d:	4d 85 f6             	test   %r14,%r14
   4bf20:	0f 84 45 0d 00 00    	je     4cc6b <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xd8b>
   4bf26:	48 89 fb             	mov    %rdi,%rbx
   4bf29:	4c 8b 6f 08          	mov    0x8(%rdi),%r13
   4bf2d:	49 8b 45 00          	mov    0x0(%r13),%rax
   4bf31:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
   4bf35:	c5 fe 7f 84 24 40 01 	vmovdqu %ymm0,0x140(%rsp)
   4bf3c:	00 00 
   4bf3e:	c5 fe 7f 84 24 20 01 	vmovdqu %ymm0,0x120(%rsp)
   4bf45:	00 00 
   4bf47:	c5 fe 7f 84 24 00 01 	vmovdqu %ymm0,0x100(%rsp)
   4bf4e:	00 00 
   4bf50:	c5 fe 7f 84 24 e0 00 	vmovdqu %ymm0,0xe0(%rsp)
   4bf57:	00 00 
   4bf59:	48 3d 00 04 00 00    	cmp    $0x400,%rax
   4bf5f:	0f 83 c6 0b 00 00    	jae    4cb2b <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xc4b>
   4bf65:	44 89 c5             	mov    %r8d,%ebp
   4bf68:	48 89 54 24 68       	mov    %rdx,0x68(%rsp)
   4bf6d:	48 89 4c 24 70       	mov    %rcx,0x70(%rsp)
   4bf72:	b9 01 00 00 00       	mov    $0x1,%ecx
   4bf77:	c4 e2 f9 f7 c9       	shlx   %rax,%rcx,%rcx
   4bf7c:	48 c1 e8 06          	shr    $0x6,%rax
   4bf80:	48 09 8c c4 e0 00 00 	or     %rcx,0xe0(%rsp,%rax,8)
   4bf87:	00 
   4bf88:	48 8d 94 24 e0 00 00 	lea    0xe0(%rsp),%rdx
   4bf8f:	00 
   4bf90:	be 80 00 00 00       	mov    $0x80,%esi
   4bf95:	31 ff                	xor    %edi,%edi
   4bf97:	c5 f8 77             	vzeroupper
   4bf9a:	ff 15 80 87 05 00    	call   *0x58780(%rip)        # a4720 <sched_setaffinity@GLIBC_2.3.4>
   4bfa0:	89 44 24 10          	mov    %eax,0x10(%rsp)
   4bfa4:	85 c0                	test   %eax,%eax
   4bfa6:	0f 85 28 0b 00 00    	jne    4cad4 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xbf4>
   4bfac:	48 8d 44 24 18       	lea    0x18(%rsp),%rax
   4bfb1:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
   4bfb8:	00 
   4bfb9:	40 84 ed             	test   %bpl,%bpl
   4bfbc:	0f 84 ea 02 00 00    	je     4c2ac <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0x3cc>
   4bfc2:	48 83 7b 38 00       	cmpq   $0x0,0x38(%rbx)
   4bfc7:	0f 85 7a 0b 00 00    	jne    4cb47 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xc67>
   4bfcd:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
   4bfd1:	c5 fe 7f 84 24 40 01 	vmovdqu %ymm0,0x140(%rsp)
   4bfd8:	00 00 
   4bfda:	c5 fe 7f 84 24 20 01 	vmovdqu %ymm0,0x120(%rsp)
   4bfe1:	00 00 
   4bfe3:	c5 fe 7f 84 24 00 01 	vmovdqu %ymm0,0x100(%rsp)
   4bfea:	00 00 
   4bfec:	c5 fe 7f 84 24 e0 00 	vmovdqu %ymm0,0xe0(%rsp)
   4bff3:	00 00 
   4bff5:	49 c1 e6 03          	shl    $0x3,%r14
   4bff9:	31 c0                	xor    %eax,%eax
   4bffb:	b9 01 00 00 00       	mov    $0x1,%ecx
   4c000:	49 8b 54 05 00       	mov    0x0(%r13,%rax,1),%rdx
   4c005:	48 81 fa 00 04 00 00 	cmp    $0x400,%rdx
   4c00c:	0f 83 a6 0a 00 00    	jae    4cab8 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xbd8>
   4c012:	c4 e2 e9 f7 f1       	shlx   %rdx,%rcx,%rsi
   4c017:	48 c1 ea 06          	shr    $0x6,%rdx
   4c01b:	48 09 b4 d4 e0 00 00 	or     %rsi,0xe0(%rsp,%rdx,8)
   4c022:	00 
   4c023:	48 83 c0 08          	add    $0x8,%rax
   4c027:	49 39 c6             	cmp    %rax,%r14
   4c02a:	75 d4                	jne    4c000 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0x120>
   4c02c:	48 8d 94 24 e0 00 00 	lea    0xe0(%rsp),%rdx
   4c033:	00 
   4c034:	be 80 00 00 00       	mov    $0x80,%esi
   4c039:	31 ff                	xor    %edi,%edi
   4c03b:	c5 f8 77             	vzeroupper
   4c03e:	ff 15 dc 86 05 00    	call   *0x586dc(%rip)        # a4720 <sched_setaffinity@GLIBC_2.3.4>
   4c044:	89 44 24 10          	mov    %eax,0x10(%rsp)
   4c048:	85 c0                	test   %eax,%eax
   4c04a:	0f 85 84 0a 00 00    	jne    4cad4 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xbf4>
   4c050:	ff 15 d2 86 05 00    	call   *0x586d2(%rip)        # a4728 <_DYNAMIC+0x828>
   4c056:	48 89 44 24 48       	mov    %rax,0x48(%rsp)
   4c05b:	89 54 24 50          	mov    %edx,0x50(%rsp)
   4c05f:	49 89 dc             	mov    %rbx,%r12
   4c062:	48 8b 5b 20          	mov    0x20(%rbx),%rbx
   4c066:	48 81 fb 80 00 00 00 	cmp    $0x80,%rbx
   4c06d:	0f 82 09 0c 00 00    	jb     4cc7c <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xd9c>
   4c073:	48 81 fb 00 00 00 10 	cmp    $0x10000000,%rbx
   4c07a:	0f 87 00 0c 00 00    	ja     4cc80 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xda0>
   4c080:	41 89 de             	mov    %ebx,%r14d
   4c083:	41 81 e6 c0 ff ff 1f 	and    $0x1fffffc0,%r14d
   4c08a:	48 c7 84 24 e0 00 00 	movq   $0x0,0xe0(%rsp)
   4c091:	00 00 00 00 00 
   4c096:	48 8d bc 24 e0 00 00 	lea    0xe0(%rsp),%rdi
   4c09d:	00 
   4c09e:	be 40 00 00 00       	mov    $0x40,%esi
   4c0a3:	4c 89 f2             	mov    %r14,%rdx
   4c0a6:	ff 15 44 80 05 00    	call   *0x58044(%rip)        # a40f0 <posix_memalign@GLIBC_2.2.5>
   4c0ac:	85 c0                	test   %eax,%eax
   4c0ae:	0f 85 0b 0c 00 00    	jne    4ccbf <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xddf>
   4c0b4:	4c 8b bc 24 e0 00 00 	mov    0xe0(%rsp),%r15
   4c0bb:	00 
   4c0bc:	4d 85 ff             	test   %r15,%r15
   4c0bf:	0f 84 fa 0b 00 00    	je     4ccbf <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xddf>
   4c0c5:	48 c1 eb 06          	shr    $0x6,%rbx
   4c0c9:	49 8d 56 c0          	lea    -0x40(%r14),%rdx
   4c0cd:	4c 89 ff             	mov    %r15,%rdi
   4c0d0:	31 f6                	xor    %esi,%esi
   4c0d2:	ff 15 40 80 05 00    	call   *0x58040(%rip)        # a4118 <memset@GLIBC_2.2.5>
   4c0d8:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
   4c0dc:	c4 81 7d 7f 44 37 c0 	vmovdqa %ymm0,-0x40(%r15,%r14,1)
   4c0e3:	c4 81 7d 7f 44 37 e0 	vmovdqa %ymm0,-0x20(%r15,%r14,1)
   4c0ea:	48 89 5c 24 10       	mov    %rbx,0x10(%rsp)
   4c0ef:	4c 89 7c 24 18       	mov    %r15,0x18(%rsp)
   4c0f4:	48 89 5c 24 20       	mov    %rbx,0x20(%rsp)
   4c0f9:	89 5c 24 28          	mov    %ebx,0x28(%rsp)
   4c0fd:	66 c7 44 24 2c 01 01 	movw   $0x101,0x2c(%rsp)
   4c104:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
   4c109:	c5 fa 6f 40 08       	vmovdqu 0x8(%rax),%xmm0
   4c10e:	c5 fa 7f 84 24 e0 00 	vmovdqu %xmm0,0xe0(%rsp)
   4c115:	00 00 
   4c117:	48 8d 84 24 e0 00 00 	lea    0xe0(%rsp),%rax
   4c11e:	00 
   4c11f:	48 8b b4 24 e0 00 00 	mov    0xe0(%rsp),%rsi
   4c126:	00 
   4c127:	48 8b 94 24 e8 00 00 	mov    0xe8(%rsp),%rdx
   4c12e:	00 
   4c12f:	49 8b 4c 24 30       	mov    0x30(%r12),%rcx
   4c134:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
   4c139:	c5 f8 77             	vzeroupper
   4c13c:	ff 15 fe 82 05 00    	call   *0x582fe(%rip)        # a4440 <_DYNAMIC+0x540>
   4c142:	48 8d 7c 24 48       	lea    0x48(%rsp),%rdi
   4c147:	ff 15 e3 85 05 00    	call   *0x585e3(%rip)        # a4730 <_DYNAMIC+0x830>
   4c14d:	49 89 c6             	mov    %rax,%r14
   4c150:	49 8b 45 00          	mov    0x0(%r13),%rax
   4c154:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
   4c158:	c5 fe 7f 84 24 40 01 	vmovdqu %ymm0,0x140(%rsp)
   4c15f:	00 00 
   4c161:	c5 fe 7f 84 24 20 01 	vmovdqu %ymm0,0x120(%rsp)
   4c168:	00 00 
   4c16a:	c5 fe 7f 84 24 00 01 	vmovdqu %ymm0,0x100(%rsp)
   4c171:	00 00 
   4c173:	c5 fe 7f 84 24 e0 00 	vmovdqu %ymm0,0xe0(%rsp)
   4c17a:	00 00 
   4c17c:	48 3d 00 04 00 00    	cmp    $0x400,%rax
   4c182:	0f 83 1f 0a 00 00    	jae    4cba7 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xcc7>
   4c188:	89 d5                	mov    %edx,%ebp
   4c18a:	b9 01 00 00 00       	mov    $0x1,%ecx
   4c18f:	c4 e2 f9 f7 c9       	shlx   %rax,%rcx,%rcx
   4c194:	48 c1 e8 06          	shr    $0x6,%rax
   4c198:	48 09 8c c4 e0 00 00 	or     %rcx,0xe0(%rsp,%rax,8)
   4c19f:	00 
   4c1a0:	48 8d 94 24 e0 00 00 	lea    0xe0(%rsp),%rdx
   4c1a7:	00 
   4c1a8:	be 80 00 00 00       	mov    $0x80,%esi
   4c1ad:	31 ff                	xor    %edi,%edi
   4c1af:	c5 f8 77             	vzeroupper
   4c1b2:	ff 15 68 85 05 00    	call   *0x58568(%rip)        # a4720 <sched_setaffinity@GLIBC_2.3.4>
   4c1b8:	89 84 24 b8 00 00 00 	mov    %eax,0xb8(%rsp)
   4c1bf:	85 c0                	test   %eax,%eax
   4c1c1:	0f 85 48 0a 00 00    	jne    4cc0f <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xd2f>
   4c1c7:	b8 00 ca 9a 3b       	mov    $0x3b9aca00,%eax
   4c1cc:	4c 89 f2             	mov    %r14,%rdx
   4c1cf:	c4 62 fb f6 f0       	mulx   %rax,%rax,%r14
   4c1d4:	89 eb                	mov    %ebp,%ebx
   4c1d6:	48 01 c3             	add    %rax,%rbx
   4c1d9:	49 83 d6 00          	adc    $0x0,%r14
   4c1dd:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
   4c1e2:	4c 8b 78 28          	mov    0x28(%rax),%r15
   4c1e6:	4c 3b 78 18          	cmp    0x18(%rax),%r15
   4c1ea:	75 0e                	jne    4c1fa <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0x31a>
   4c1ec:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
   4c1f1:	48 8d 78 18          	lea    0x18(%rax),%rdi
   4c1f5:	e8 96 35 01 00       	call   5f790 <<alloc::raw_vec::RawVec<u128>>::grow_one>
   4c1fa:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
   4c1ff:	48 8b 42 20          	mov    0x20(%rdx),%rax
   4c203:	4c 89 f9             	mov    %r15,%rcx
   4c206:	48 c1 e1 04          	shl    $0x4,%rcx
   4c20a:	4c 89 74 08 08       	mov    %r14,0x8(%rax,%rcx,1)
   4c20f:	48 89 1c 08          	mov    %rbx,(%rax,%rcx,1)
   4c213:	49 ff c7             	inc    %r15
   4c216:	4c 89 7a 28          	mov    %r15,0x28(%rdx)
   4c21a:	48 8b 5a 58          	mov    0x58(%rdx),%rbx
   4c21e:	48 3b 5a 48          	cmp    0x48(%rdx),%rbx
   4c222:	75 0e                	jne    4c232 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0x352>
   4c224:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
   4c229:	48 8d 78 48          	lea    0x48(%rax),%rdi
   4c22d:	e8 5e 35 01 00       	call   5f790 <<alloc::raw_vec::RawVec<u128>>::grow_one>
   4c232:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
   4c237:	48 8b 42 50          	mov    0x50(%rdx),%rax
   4c23b:	48 89 d9             	mov    %rbx,%rcx
   4c23e:	48 c1 e1 04          	shl    $0x4,%rcx
   4c242:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
   4c246:	c5 f9 7f 04 08       	vmovdqa %xmm0,(%rax,%rcx,1)
   4c24b:	48 ff c3             	inc    %rbx
   4c24e:	48 89 5a 58          	mov    %rbx,0x58(%rdx)
   4c252:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
   4c257:	48 8b 54 24 20       	mov    0x20(%rsp),%rdx
   4c25c:	48 8d bc 24 e0 00 00 	lea    0xe0(%rsp),%rdi
   4c263:	00 
   4c264:	4c 89 e1             	mov    %r12,%rcx
   4c267:	e8 d4 53 00 00       	call   51640 <policy_confirmation::observe::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>>
   4c26c:	48 8b 84 24 f0 00 00 	mov    0xf0(%rsp),%rax
   4c273:	00 
   4c274:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
   4c279:	48 89 41 70          	mov    %rax,0x70(%rcx)
   4c27d:	c5 fa 6f 84 24 e0 00 	vmovdqu 0xe0(%rsp),%xmm0
   4c284:	00 00 
   4c286:	c5 fa 7f 41 60       	vmovdqu %xmm0,0x60(%rcx)
   4c28b:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
   4c290:	4c 89 e6             	mov    %r12,%rsi
   4c293:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
   4c298:	48 8b 4c 24 68       	mov    0x68(%rsp),%rcx
   4c29d:	4c 8b 44 24 70       	mov    0x70(%rsp),%r8
   4c2a2:	e8 79 5e 00 00       	call   52120 <policy_confirmation::validate::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>>
   4c2a7:	e9 c6 07 00 00       	jmp    4ca72 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xb92>
   4c2ac:	4c 8b 63 20          	mov    0x20(%rbx),%r12
   4c2b0:	49 81 fc 80 00 00 00 	cmp    $0x80,%r12
   4c2b7:	0f 82 bf 09 00 00    	jb     4cc7c <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xd9c>
   4c2bd:	49 81 fc 00 00 00 10 	cmp    $0x10000000,%r12
   4c2c4:	0f 87 b6 09 00 00    	ja     4cc80 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xda0>
   4c2ca:	4c 89 6c 24 60       	mov    %r13,0x60(%rsp)
   4c2cf:	45 89 e7             	mov    %r12d,%r15d
   4c2d2:	41 81 e7 c0 ff ff 1f 	and    $0x1fffffc0,%r15d
   4c2d9:	48 c7 84 24 e0 00 00 	movq   $0x0,0xe0(%rsp)
   4c2e0:	00 00 00 00 00 
   4c2e5:	48 8d bc 24 e0 00 00 	lea    0xe0(%rsp),%rdi
   4c2ec:	00 
   4c2ed:	be 40 00 00 00       	mov    $0x40,%esi
   4c2f2:	4c 89 fa             	mov    %r15,%rdx
   4c2f5:	ff 15 f5 7d 05 00    	call   *0x57df5(%rip)        # a40f0 <posix_memalign@GLIBC_2.2.5>
   4c2fb:	85 c0                	test   %eax,%eax
   4c2fd:	0f 85 ae 09 00 00    	jne    4ccb1 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xdd1>
   4c303:	4c 8b ac 24 e0 00 00 	mov    0xe0(%rsp),%r13
   4c30a:	00 
   4c30b:	4d 85 ed             	test   %r13,%r13
   4c30e:	0f 84 9d 09 00 00    	je     4ccb1 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xdd1>
   4c314:	4c 89 b4 24 c8 00 00 	mov    %r14,0xc8(%rsp)
   4c31b:	00 
   4c31c:	49 c1 ec 06          	shr    $0x6,%r12
   4c320:	49 8d 57 c0          	lea    -0x40(%r15),%rdx
   4c324:	4c 89 ef             	mov    %r13,%rdi
   4c327:	31 f6                	xor    %esi,%esi
   4c329:	ff 15 e9 7d 05 00    	call   *0x57de9(%rip)        # a4118 <memset@GLIBC_2.2.5>
   4c32f:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
   4c333:	c4 81 7d 7f 44 3d c0 	vmovdqa %ymm0,-0x40(%r13,%r15,1)
   4c33a:	c4 81 7d 7f 44 3d e0 	vmovdqa %ymm0,-0x20(%r13,%r15,1)
   4c341:	4c 89 64 24 10       	mov    %r12,0x10(%rsp)
   4c346:	4c 89 ac 24 d8 00 00 	mov    %r13,0xd8(%rsp)
   4c34d:	00 
   4c34e:	4c 89 6c 24 18       	mov    %r13,0x18(%rsp)
   4c353:	4c 89 64 24 20       	mov    %r12,0x20(%rsp)
   4c358:	44 89 64 24 28       	mov    %r12d,0x28(%rsp)
   4c35d:	66 c7 44 24 2c 01 01 	movw   $0x101,0x2c(%rsp)
   4c364:	48 8d bc 24 e0 00 00 	lea    0xe0(%rsp),%rdi
   4c36b:	00 
   4c36c:	4c 89 e6             	mov    %r12,%rsi
   4c36f:	4c 89 a4 24 80 00 00 	mov    %r12,0x80(%rsp)
   4c376:	00 
   4c377:	4c 89 e2             	mov    %r12,%rdx
   4c37a:	48 89 5c 24 38       	mov    %rbx,0x38(%rsp)
   4c37f:	48 89 d9             	mov    %rbx,%rcx
   4c382:	c5 f8 77             	vzeroupper
   4c385:	e8 b6 52 00 00       	call   51640 <policy_confirmation::observe::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>>
   4c38a:	48 8b 84 24 f0 00 00 	mov    0xf0(%rsp),%rax
   4c391:	00 
   4c392:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
   4c397:	48 89 41 70          	mov    %rax,0x70(%rcx)
   4c39b:	c5 fa 6f 84 24 e0 00 	vmovdqu 0xe0(%rsp),%xmm0
   4c3a2:	00 00 
   4c3a4:	c5 fa 7f 41 60       	vmovdqu %xmm0,0x60(%rcx)
   4c3a9:	ff 15 79 83 05 00    	call   *0x58379(%rip)        # a4728 <_DYNAMIC+0x828>
   4c3af:	48 89 84 24 b8 00 00 	mov    %rax,0xb8(%rsp)
   4c3b6:	00 
   4c3b7:	89 94 24 c0 00 00 00 	mov    %edx,0xc0(%rsp)
   4c3be:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
   4c3c3:	48 8b 58 38          	mov    0x38(%rax),%rbx
   4c3c7:	48 8b 40 48          	mov    0x48(%rax),%rax
   4c3cb:	48 89 44 24 78       	mov    %rax,0x78(%rsp)
   4c3d0:	48 8d bc 24 e0 00 00 	lea    0xe0(%rsp),%rdi
   4c3d7:	00 
   4c3d8:	ba 00 80 00 00       	mov    $0x8000,%edx
   4c3dd:	31 f6                	xor    %esi,%esi
   4c3df:	ff 15 33 7d 05 00    	call   *0x57d33(%rip)        # a4118 <memset@GLIBC_2.2.5>
   4c3e5:	48 89 5c 24 40       	mov    %rbx,0x40(%rsp)
   4c3ea:	48 85 db             	test   %rbx,%rbx
   4c3ed:	0f 84 1c 04 00 00    	je     4c80f <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0x92f>
   4c3f3:	48 8b 5c 24 40       	mov    0x40(%rsp),%rbx
   4c3f8:	49 89 dd             	mov    %rbx,%r13
   4c3fb:	49 c1 ed 0c          	shr    $0xc,%r13
   4c3ff:	89 d8                	mov    %ebx,%eax
   4c401:	25 ff 0f 00 00       	and    $0xfff,%eax
   4c406:	48 83 f8 01          	cmp    $0x1,%rax
   4c40a:	49 83 dd ff          	sbb    $0xffffffffffffffff,%r13
   4c40e:	45 31 f6             	xor    %r14d,%r14d
   4c411:	49 bf 15 7c 4a 7f b9 	movabs $0x9e3779b97f4a7c15,%r15
   4c418:	79 37 9e 
   4c41b:	4c 8b 64 24 78       	mov    0x78(%rsp),%r12
   4c420:	31 ed                	xor    %ebp,%ebp
   4c422:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   4c429:	1f 84 00 00 00 00 00 
   4c430:	48 81 fb 00 10 00 00 	cmp    $0x1000,%rbx
   4c437:	b9 00 10 00 00       	mov    $0x1000,%ecx
   4c43c:	48 0f 42 cb          	cmovb  %rbx,%rcx
   4c440:	4c 89 f0             	mov    %r14,%rax
   4c443:	48 c1 e0 0c          	shl    $0xc,%rax
   4c447:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
   4c44c:	48 89 f2             	mov    %rsi,%rdx
   4c44f:	48 29 c2             	sub    %rax,%rdx
   4c452:	48 81 fa 00 10 00 00 	cmp    $0x1000,%rdx
   4c459:	bf 00 10 00 00       	mov    $0x1000,%edi
   4c45e:	48 0f 43 d7          	cmovae %rdi,%rdx
   4c462:	48 89 f0             	mov    %rsi,%rax
   4c465:	48 29 e8             	sub    %rbp,%rax
   4c468:	48 3d 00 10 00 00    	cmp    $0x1000,%rax
   4c46e:	48 0f 43 c7          	cmovae %rdi,%rax
   4c472:	48 39 ee             	cmp    %rbp,%rsi
   4c475:	0f 84 2a 03 00 00    	je     4c7a5 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0x8c5>
   4c47b:	48 ff ca             	dec    %rdx
   4c47e:	40 b6 3d             	mov    $0x3d,%sil
   4c481:	c4 e2 c8 f5 fa       	bzhi   %rsi,%rdx,%rdi
   4c486:	48 83 ff 03          	cmp    $0x3,%rdi
   4c48a:	73 24                	jae    4c4b0 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0x5d0>
   4c48c:	31 c9                	xor    %ecx,%ecx
   4c48e:	48 8d bc 24 e0 00 00 	lea    0xe0(%rsp),%rdi
   4c495:	00 
   4c496:	49 b9 b9 e5 e4 1c 6d 	movabs $0xbf58476d1ce4e5b9,%r9
   4c49d:	47 58 bf 
   4c4a0:	49 ba eb 11 31 13 bb 	movabs $0x94d049bb133111eb,%r10
   4c4a7:	49 d0 94 
   4c4aa:	e9 96 02 00 00       	jmp    4c745 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0x865>
   4c4af:	90                   	nop
   4c4b0:	48 ff c9             	dec    %rcx
   4c4b3:	c4 e2 c8 f5 d1       	bzhi   %rsi,%rcx,%rdx
   4c4b8:	48 ff c2             	inc    %rdx
   4c4bb:	48 8d 77 01          	lea    0x1(%rdi),%rsi
   4c4bf:	48 8b 4c 24 78       	mov    0x78(%rsp),%rcx
   4c4c4:	48 01 e9             	add    %rbp,%rcx
   4c4c7:	62 f2 fd 28 7c c1    	vpbroadcastq %rcx,%ymm0
   4c4cd:	48 83 ff 0f          	cmp    $0xf,%rdi
   4c4d1:	73 07                	jae    4c4da <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0x5fa>
   4c4d3:	31 c9                	xor    %ecx,%ecx
   4c4d5:	e9 9f 01 00 00       	jmp    4c679 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0x799>
   4c4da:	48 89 d7             	mov    %rdx,%rdi
   4c4dd:	48 83 e7 f0          	and    $0xfffffffffffffff0,%rdi
   4c4e1:	48 89 f1             	mov    %rsi,%rcx
   4c4e4:	49 b8 f0 ff ff ff ff 	movabs $0x3ffffffffffffff0,%r8
   4c4eb:	ff ff 3f 
   4c4ee:	4c 21 c1             	and    %r8,%rcx
   4c4f1:	62 f1 fd 38 d4 0d 4d 	vpaddq -0x423b3(%rip){1to4},%ymm0,%ymm1        # a148 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x50>
   4c4f8:	dc fb ff 
   4c4fb:	62 f1 fd 38 d4 15 7b 	vpaddq -0x42485(%rip){1to4},%ymm0,%ymm2        # a080 <anon.25805f450824d4a1248fcaae526abf58.283.llvm.3576388159787090369+0x84>
   4c502:	db fb ff 
   4c505:	62 f1 fd 38 d4 1d 79 	vpaddq -0x42487(%rip){1to4},%ymm0,%ymm3        # a088 <anon.25805f450824d4a1248fcaae526abf58.283.llvm.3576388159787090369+0x8c>
   4c50c:	db fb ff 
   4c50f:	45 31 c0             	xor    %r8d,%r8d
   4c512:	c5 fd 6f 25 46 dd fb 	vmovdqa -0x422ba(%rip),%ymm4        # a260 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x168>
   4c519:	ff 
   4c51a:	c4 62 7d 59 2d e5 db 	vpbroadcastq -0x4241b(%rip),%ymm13        # a108 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x10>
   4c521:	fb ff 
   4c523:	c4 62 7d 59 35 9c db 	vpbroadcastq -0x42464(%rip),%ymm14        # a0c8 <anon.25805f450824d4a1248fcaae526abf58.283.llvm.3576388159787090369+0xcc>
   4c52a:	fb ff 
   4c52c:	c4 62 7d 59 3d 73 db 	vpbroadcastq -0x4248d(%rip),%ymm15        # a0a8 <anon.25805f450824d4a1248fcaae526abf58.283.llvm.3576388159787090369+0xac>
   4c533:	fb ff 
   4c535:	62 e2 fd 28 59 05 11 	vpbroadcastq -0x423ef(%rip),%ymm16        # a150 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x58>
   4c53c:	dc fb ff 
   4c53f:	62 e2 fd 28 59 0d 0f 	vpbroadcastq -0x423f1(%rip),%ymm17        # a158 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x60>
   4c546:	dc fb ff 
   4c549:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
   4c550:	c5 fd d4 ec          	vpaddq %ymm4,%ymm0,%ymm5
   4c554:	c5 dd d4 f1          	vpaddq %ymm1,%ymm4,%ymm6
   4c558:	c5 dd d4 fa          	vpaddq %ymm2,%ymm4,%ymm7
   4c55c:	c5 5d d4 c3          	vpaddq %ymm3,%ymm4,%ymm8
   4c560:	62 d2 d5 28 40 ed    	vpmullq %ymm13,%ymm5,%ymm5
   4c566:	62 d2 cd 28 40 f5    	vpmullq %ymm13,%ymm6,%ymm6
   4c56c:	62 d2 c5 28 40 fd    	vpmullq %ymm13,%ymm7,%ymm7
   4c572:	62 52 bd 28 40 c5    	vpmullq %ymm13,%ymm8,%ymm8
   4c578:	c5 8d d4 ed          	vpaddq %ymm5,%ymm14,%ymm5
   4c57c:	c5 8d d4 f6          	vpaddq %ymm6,%ymm14,%ymm6
   4c580:	c5 8d d4 ff          	vpaddq %ymm7,%ymm14,%ymm7
   4c584:	c4 41 3d d4 c6       	vpaddq %ymm14,%ymm8,%ymm8
   4c589:	c5 b5 73 d5 1e       	vpsrlq $0x1e,%ymm5,%ymm9
   4c58e:	c5 ad 73 d6 1e       	vpsrlq $0x1e,%ymm6,%ymm10
   4c593:	c5 a5 73 d7 1e       	vpsrlq $0x1e,%ymm7,%ymm11
   4c598:	c4 c1 1d 73 d0 1e    	vpsrlq $0x1e,%ymm8,%ymm12
   4c59e:	c5 b5 ef ed          	vpxor  %ymm5,%ymm9,%ymm5
   4c5a2:	c5 ad ef f6          	vpxor  %ymm6,%ymm10,%ymm6
   4c5a6:	c5 a5 ef ff          	vpxor  %ymm7,%ymm11,%ymm7
   4c5aa:	c4 41 1d ef c0       	vpxor  %ymm8,%ymm12,%ymm8
   4c5af:	62 d2 d5 28 40 ef    	vpmullq %ymm15,%ymm5,%ymm5
   4c5b5:	62 d2 cd 28 40 f7    	vpmullq %ymm15,%ymm6,%ymm6
   4c5bb:	62 d2 c5 28 40 ff    	vpmullq %ymm15,%ymm7,%ymm7
   4c5c1:	62 52 bd 28 40 c7    	vpmullq %ymm15,%ymm8,%ymm8
   4c5c7:	c5 b5 73 d5 1b       	vpsrlq $0x1b,%ymm5,%ymm9
   4c5cc:	c5 ad 73 d6 1b       	vpsrlq $0x1b,%ymm6,%ymm10
   4c5d1:	c5 a5 73 d7 1b       	vpsrlq $0x1b,%ymm7,%ymm11
   4c5d6:	c5 b5 ef ed          	vpxor  %ymm5,%ymm9,%ymm5
   4c5da:	c5 ad ef f6          	vpxor  %ymm6,%ymm10,%ymm6
   4c5de:	c5 a5 ef ff          	vpxor  %ymm7,%ymm11,%ymm7
   4c5e2:	62 b2 d5 28 40 e8    	vpmullq %ymm16,%ymm5,%ymm5
   4c5e8:	62 b2 cd 28 40 f0    	vpmullq %ymm16,%ymm6,%ymm6
   4c5ee:	62 b2 c5 28 40 f8    	vpmullq %ymm16,%ymm7,%ymm7
   4c5f4:	c4 c1 35 73 d0 1b    	vpsrlq $0x1b,%ymm8,%ymm9
   4c5fa:	c4 41 35 ef c0       	vpxor  %ymm8,%ymm9,%ymm8
   4c5ff:	62 32 bd 28 40 c0    	vpmullq %ymm16,%ymm8,%ymm8
   4c605:	c5 b5 73 d5 1f       	vpsrlq $0x1f,%ymm5,%ymm9
   4c60a:	c5 ad 73 d6 1f       	vpsrlq $0x1f,%ymm6,%ymm10
   4c60f:	c5 a5 73 d7 1f       	vpsrlq $0x1f,%ymm7,%ymm11
   4c614:	c4 c1 1d 73 d0 1f    	vpsrlq $0x1f,%ymm8,%ymm12
   4c61a:	c5 b5 ef ed          	vpxor  %ymm5,%ymm9,%ymm5
   4c61e:	c5 ad ef f6          	vpxor  %ymm6,%ymm10,%ymm6
   4c622:	c5 a5 ef ff          	vpxor  %ymm7,%ymm11,%ymm7
   4c626:	c4 a1 7e 7f ac c4 e0 	vmovdqu %ymm5,0xe0(%rsp,%r8,8)
   4c62d:	00 00 00 
   4c630:	c4 a1 7e 7f b4 c4 00 	vmovdqu %ymm6,0x100(%rsp,%r8,8)
   4c637:	01 00 00 
   4c63a:	c4 a1 7e 7f bc c4 20 	vmovdqu %ymm7,0x120(%rsp,%r8,8)
   4c641:	01 00 00 
   4c644:	c4 c1 1d ef e8       	vpxor  %ymm8,%ymm12,%ymm5
   4c649:	c4 a1 7e 7f ac c4 40 	vmovdqu %ymm5,0x140(%rsp,%r8,8)
   4c650:	01 00 00 
   4c653:	49 83 c0 10          	add    $0x10,%r8
   4c657:	62 b1 dd 28 d4 e1    	vpaddq %ymm17,%ymm4,%ymm4
   4c65d:	4c 39 c7             	cmp    %r8,%rdi
   4c660:	0f 85 ea fe ff ff    	jne    4c550 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0x670>
   4c666:	48 39 ce             	cmp    %rcx,%rsi
   4c669:	0f 84 36 01 00 00    	je     4c7a5 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0x8c5>
   4c66f:	40 f6 c6 0c          	test   $0xc,%sil
   4c673:	0f 84 89 01 00 00    	je     4c802 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0x922>
   4c679:	49 89 c8             	mov    %rcx,%r8
   4c67c:	48 83 e2 fc          	and    $0xfffffffffffffffc,%rdx
   4c680:	48 b9 f0 ff ff ff ff 	movabs $0x3ffffffffffffff0,%rcx
   4c687:	ff ff 3f 
   4c68a:	48 83 c1 0c          	add    $0xc,%rcx
   4c68e:	48 21 f1             	and    %rsi,%rcx
   4c691:	48 8d bc cc e0 00 00 	lea    0xe0(%rsp,%rcx,8),%rdi
   4c698:	00 
   4c699:	62 d2 fd 28 7c c8    	vpbroadcastq %r8,%ymm1
   4c69f:	c5 f5 eb 0d b9 db fb 	vpor   -0x42447(%rip),%ymm1,%ymm1        # a260 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x168>
   4c6a6:	ff 
   4c6a7:	c4 e2 7d 59 25 58 da 	vpbroadcastq -0x425a8(%rip),%ymm4        # a108 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x10>
   4c6ae:	fb ff 
   4c6b0:	c4 e2 7d 59 2d 0f da 	vpbroadcastq -0x425f1(%rip),%ymm5        # a0c8 <anon.25805f450824d4a1248fcaae526abf58.283.llvm.3576388159787090369+0xcc>
   4c6b7:	fb ff 
   4c6b9:	c4 e2 7d 59 35 e6 d9 	vpbroadcastq -0x4261a(%rip),%ymm6        # a0a8 <anon.25805f450824d4a1248fcaae526abf58.283.llvm.3576388159787090369+0xac>
   4c6c0:	fb ff 
   4c6c2:	c4 e2 7d 59 3d 85 da 	vpbroadcastq -0x4257b(%rip),%ymm7        # a150 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x58>
   4c6c9:	fb ff 
   4c6cb:	c4 62 7d 59 05 74 da 	vpbroadcastq -0x4258c(%rip),%ymm8        # a148 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x50>
   4c6d2:	fb ff 
   4c6d4:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
   4c6db:	00 00 00 00 00 
   4c6e0:	c5 fd d4 d1          	vpaddq %ymm1,%ymm0,%ymm2
   4c6e4:	62 f2 ed 28 40 d4    	vpmullq %ymm4,%ymm2,%ymm2
   4c6ea:	c5 ed d4 d5          	vpaddq %ymm5,%ymm2,%ymm2
   4c6ee:	c5 e5 73 d2 1e       	vpsrlq $0x1e,%ymm2,%ymm3
   4c6f3:	c5 e5 ef d2          	vpxor  %ymm2,%ymm3,%ymm2
   4c6f7:	62 f2 ed 28 40 d6    	vpmullq %ymm6,%ymm2,%ymm2
   4c6fd:	c5 e5 73 d2 1b       	vpsrlq $0x1b,%ymm2,%ymm3
   4c702:	c5 e5 ef d2          	vpxor  %ymm2,%ymm3,%ymm2
   4c706:	62 f2 ed 28 40 d7    	vpmullq %ymm7,%ymm2,%ymm2
   4c70c:	c5 e5 73 d2 1f       	vpsrlq $0x1f,%ymm2,%ymm3
   4c711:	c5 e5 ef d2          	vpxor  %ymm2,%ymm3,%ymm2
   4c715:	c4 a1 7e 7f 94 c4 e0 	vmovdqu %ymm2,0xe0(%rsp,%r8,8)
   4c71c:	00 00 00 
   4c71f:	49 83 c0 04          	add    $0x4,%r8
   4c723:	c5 bd d4 c9          	vpaddq %ymm1,%ymm8,%ymm1
   4c727:	4c 39 c2             	cmp    %r8,%rdx
   4c72a:	75 b4                	jne    4c6e0 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0x800>
   4c72c:	48 39 ce             	cmp    %rcx,%rsi
   4c72f:	49 b9 b9 e5 e4 1c 6d 	movabs $0xbf58476d1ce4e5b9,%r9
   4c736:	47 58 bf 
   4c739:	49 ba eb 11 31 13 bb 	movabs $0x94d049bb133111eb,%r10
   4c740:	49 d0 94 
   4c743:	74 60                	je     4c7a5 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0x8c5>
   4c745:	89 c2                	mov    %eax,%edx
   4c747:	48 8d 94 d4 e0 00 00 	lea    0xe0(%rsp,%rdx,8),%rdx
   4c74e:	00 
   4c74f:	4c 01 e1             	add    %r12,%rcx
   4c752:	48 be eb 83 b5 80 46 	movabs $0x61c8864680b583eb,%rsi
   4c759:	86 c8 61 
   4c75c:	48 0f af ce          	imul   %rsi,%rcx
   4c760:	48 be e8 84 ed 04 42 	movabs $0xc276e44204ed84e8,%rsi
   4c767:	e4 76 c2 
   4c76a:	48 29 ce             	sub    %rcx,%rsi
   4c76d:	0f 1f 00             	nopl   (%rax)
   4c770:	48 89 f1             	mov    %rsi,%rcx
   4c773:	48 c1 e9 1e          	shr    $0x1e,%rcx
   4c777:	48 31 f1             	xor    %rsi,%rcx
   4c77a:	49 0f af c9          	imul   %r9,%rcx
   4c77e:	49 89 c8             	mov    %rcx,%r8
   4c781:	49 c1 e8 1b          	shr    $0x1b,%r8
   4c785:	49 31 c8             	xor    %rcx,%r8
   4c788:	4d 0f af c2          	imul   %r10,%r8
   4c78c:	4c 89 c1             	mov    %r8,%rcx
   4c78f:	48 c1 e9 1f          	shr    $0x1f,%rcx
   4c793:	4c 31 c1             	xor    %r8,%rcx
   4c796:	48 89 0f             	mov    %rcx,(%rdi)
   4c799:	48 83 c7 08          	add    $0x8,%rdi
   4c79d:	4c 01 fe             	add    %r15,%rsi
   4c7a0:	48 39 d7             	cmp    %rdx,%rdi
   4c7a3:	75 cb                	jne    4c770 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0x890>
   4c7a5:	48 8b bc 24 d8 00 00 	mov    0xd8(%rsp),%rdi
   4c7ac:	00 
   4c7ad:	48 8b 8c 24 80 00 00 	mov    0x80(%rsp),%rcx
   4c7b4:	00 
   4c7b5:	48 89 ce             	mov    %rcx,%rsi
   4c7b8:	31 d2                	xor    %edx,%edx
   4c7ba:	41 b8 01 00 00 00    	mov    $0x1,%r8d
   4c7c0:	41 b9 01 00 00 00    	mov    $0x1,%r9d
   4c7c6:	50                   	push   %rax
   4c7c7:	48 8d 84 24 e8 00 00 	lea    0xe8(%rsp),%rax
   4c7ce:	00 
   4c7cf:	50                   	push   %rax
   4c7d0:	c5 f8 77             	vzeroupper
   4c7d3:	e8 38 c5 fd ff       	call   28d10 <<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>::insert_into>
   4c7d8:	48 83 c4 10          	add    $0x10,%rsp
   4c7dc:	48 81 c5 00 10 00 00 	add    $0x1000,%rbp
   4c7e3:	49 ff cd             	dec    %r13
   4c7e6:	49 ff c6             	inc    %r14
   4c7e9:	48 81 c3 00 f0 ff ff 	add    $0xfffffffffffff000,%rbx
   4c7f0:	49 81 c4 00 10 00 00 	add    $0x1000,%r12
   4c7f7:	4d 85 ed             	test   %r13,%r13
   4c7fa:	0f 85 30 fc ff ff    	jne    4c430 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0x550>
   4c800:	eb 0d                	jmp    4c80f <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0x92f>
   4c802:	48 8d bc cc e0 00 00 	lea    0xe0(%rsp,%rcx,8),%rdi
   4c809:	00 
   4c80a:	e9 87 fc ff ff       	jmp    4c496 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0x5b6>
   4c80f:	48 8d bc 24 b8 00 00 	lea    0xb8(%rsp),%rdi
   4c816:	00 
   4c817:	ff 15 13 7f 05 00    	call   *0x57f13(%rip)        # a4730 <_DYNAMIC+0x830>
   4c81d:	49 89 c6             	mov    %rax,%r14
   4c820:	89 d5                	mov    %edx,%ebp
   4c822:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
   4c826:	c5 fe 7f 84 24 40 01 	vmovdqu %ymm0,0x140(%rsp)
   4c82d:	00 00 
   4c82f:	c5 fe 7f 84 24 20 01 	vmovdqu %ymm0,0x120(%rsp)
   4c836:	00 00 
   4c838:	c5 fe 7f 84 24 00 01 	vmovdqu %ymm0,0x100(%rsp)
   4c83f:	00 00 
   4c841:	48 8d 9c 24 a0 00 00 	lea    0xa0(%rsp),%rbx
   4c848:	00 
   4c849:	c5 fe 7f 84 24 e0 00 	vmovdqu %ymm0,0xe0(%rsp)
   4c850:	00 00 
   4c852:	4c 8b 84 24 c8 00 00 	mov    0xc8(%rsp),%r8
   4c859:	00 
   4c85a:	49 c1 e0 03          	shl    $0x3,%r8
   4c85e:	31 c0                	xor    %eax,%eax
   4c860:	b9 01 00 00 00       	mov    $0x1,%ecx
   4c865:	48 8b 7c 24 60       	mov    0x60(%rsp),%rdi
   4c86a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
   4c870:	48 8b 14 07          	mov    (%rdi,%rax,1),%rdx
   4c874:	48 81 fa 00 04 00 00 	cmp    $0x400,%rdx
   4c87b:	0f 83 16 02 00 00    	jae    4ca97 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xbb7>
   4c881:	c4 e2 e9 f7 f1       	shlx   %rdx,%rcx,%rsi
   4c886:	48 c1 ea 06          	shr    $0x6,%rdx
   4c88a:	48 09 b4 d4 e0 00 00 	or     %rsi,0xe0(%rsp,%rdx,8)
   4c891:	00 
   4c892:	48 83 c0 08          	add    $0x8,%rax
   4c896:	49 39 c0             	cmp    %rax,%r8
   4c899:	75 d5                	jne    4c870 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0x990>
   4c89b:	48 8d 94 24 e0 00 00 	lea    0xe0(%rsp),%rdx
   4c8a2:	00 
   4c8a3:	be 80 00 00 00       	mov    $0x80,%esi
   4c8a8:	31 ff                	xor    %edi,%edi
   4c8aa:	c5 f8 77             	vzeroupper
   4c8ad:	ff 15 6d 7e 05 00    	call   *0x57e6d(%rip)        # a4720 <sched_setaffinity@GLIBC_2.3.4>
   4c8b3:	89 44 24 48          	mov    %eax,0x48(%rsp)
   4c8b7:	85 c0                	test   %eax,%eax
   4c8b9:	0f 85 e1 02 00 00    	jne    4cba0 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xcc0>
   4c8bf:	ff 15 63 7e 05 00    	call   *0x57e63(%rip)        # a4728 <_DYNAMIC+0x828>
   4c8c5:	48 89 44 24 48       	mov    %rax,0x48(%rsp)
   4c8ca:	89 54 24 50          	mov    %edx,0x50(%rsp)
   4c8ce:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
   4c8d3:	c5 fa 6f 40 08       	vmovdqu 0x8(%rax),%xmm0
   4c8d8:	c5 fa 7f 84 24 e0 00 	vmovdqu %xmm0,0xe0(%rsp)
   4c8df:	00 00 
   4c8e1:	48 8d 84 24 e0 00 00 	lea    0xe0(%rsp),%rax
   4c8e8:	00 
   4c8e9:	48 8b b4 24 e0 00 00 	mov    0xe0(%rsp),%rsi
   4c8f0:	00 
   4c8f1:	48 8b 94 24 e8 00 00 	mov    0xe8(%rsp),%rdx
   4c8f8:	00 
   4c8f9:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
   4c8fe:	48 8b 48 30          	mov    0x30(%rax),%rcx
   4c902:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
   4c907:	ff 15 33 7b 05 00    	call   *0x57b33(%rip)        # a4440 <_DYNAMIC+0x540>
   4c90d:	48 8d 7c 24 48       	lea    0x48(%rsp),%rdi
   4c912:	ff 15 18 7e 05 00    	call   *0x57e18(%rip)        # a4730 <_DYNAMIC+0x830>
   4c918:	49 89 c4             	mov    %rax,%r12
   4c91b:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
   4c920:	48 8b 00             	mov    (%rax),%rax
   4c923:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
   4c927:	c5 fe 7f 84 24 40 01 	vmovdqu %ymm0,0x140(%rsp)
   4c92e:	00 00 
   4c930:	c5 fe 7f 84 24 20 01 	vmovdqu %ymm0,0x120(%rsp)
   4c937:	00 00 
   4c939:	c5 fe 7f 84 24 00 01 	vmovdqu %ymm0,0x100(%rsp)
   4c940:	00 00 
   4c942:	c5 fe 7f 84 24 e0 00 	vmovdqu %ymm0,0xe0(%rsp)
   4c949:	00 00 
   4c94b:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
   4c951:	0f 87 40 01 00 00    	ja     4ca97 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xbb7>
   4c957:	41 89 d5             	mov    %edx,%r13d
   4c95a:	b9 01 00 00 00       	mov    $0x1,%ecx
   4c95f:	c4 e2 f9 f7 c9       	shlx   %rax,%rcx,%rcx
   4c964:	48 c1 e8 06          	shr    $0x6,%rax
   4c968:	48 09 8c c4 e0 00 00 	or     %rcx,0xe0(%rsp,%rax,8)
   4c96f:	00 
   4c970:	48 8d 94 24 e0 00 00 	lea    0xe0(%rsp),%rdx
   4c977:	00 
   4c978:	be 80 00 00 00       	mov    $0x80,%esi
   4c97d:	31 ff                	xor    %edi,%edi
   4c97f:	c5 f8 77             	vzeroupper
   4c982:	ff 15 98 7d 05 00    	call   *0x57d98(%rip)        # a4720 <sched_setaffinity@GLIBC_2.3.4>
   4c988:	89 44 24 5c          	mov    %eax,0x5c(%rsp)
   4c98c:	85 c0                	test   %eax,%eax
   4c98e:	0f 85 34 02 00 00    	jne    4cbc8 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xce8>
   4c994:	b8 00 ca 9a 3b       	mov    $0x3b9aca00,%eax
   4c999:	4c 89 e2             	mov    %r12,%rdx
   4c99c:	c4 62 fb f6 f8       	mulx   %rax,%rax,%r15
   4c9a1:	44 89 eb             	mov    %r13d,%ebx
   4c9a4:	48 01 c3             	add    %rax,%rbx
   4c9a7:	49 83 d7 00          	adc    $0x0,%r15
   4c9ab:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
   4c9b0:	4c 8b 60 10          	mov    0x10(%rax),%r12
   4c9b4:	4c 3b 20             	cmp    (%rax),%r12
   4c9b7:	75 0a                	jne    4c9c3 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xae3>
   4c9b9:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
   4c9be:	e8 cd 2d 01 00       	call   5f790 <<alloc::raw_vec::RawVec<u128>>::grow_one>
   4c9c3:	4c 89 e0             	mov    %r12,%rax
   4c9c6:	48 c1 e0 04          	shl    $0x4,%rax
   4c9ca:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
   4c9cf:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
   4c9d3:	4c 89 7c 01 08       	mov    %r15,0x8(%rcx,%rax,1)
   4c9d8:	49 ff c4             	inc    %r12
   4c9db:	48 89 1c 01          	mov    %rbx,(%rcx,%rax,1)
   4c9df:	4c 89 62 10          	mov    %r12,0x10(%rdx)
   4c9e3:	48 83 7c 24 40 00    	cmpq   $0x0,0x40(%rsp)
   4c9e9:	74 27                	je     4ca12 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xb32>
   4c9eb:	b8 00 ca 9a 3b       	mov    $0x3b9aca00,%eax
   4c9f0:	4c 89 f2             	mov    %r14,%rdx
   4c9f3:	c4 62 fb f6 f0       	mulx   %rax,%rax,%r14
   4c9f8:	89 eb                	mov    %ebp,%ebx
   4c9fa:	48 01 c3             	add    %rax,%rbx
   4c9fd:	49 83 d6 00          	adc    $0x0,%r14
   4ca01:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
   4ca06:	4c 8b 78 40          	mov    0x40(%rax),%r15
   4ca0a:	4c 3b 78 30          	cmp    0x30(%rax),%r15
   4ca0e:	74 16                	je     4ca26 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xb46>
   4ca10:	eb 22                	jmp    4ca34 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xb54>
   4ca12:	31 db                	xor    %ebx,%ebx
   4ca14:	45 31 f6             	xor    %r14d,%r14d
   4ca17:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
   4ca1c:	4c 8b 78 40          	mov    0x40(%rax),%r15
   4ca20:	4c 3b 78 30          	cmp    0x30(%rax),%r15
   4ca24:	75 0e                	jne    4ca34 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xb54>
   4ca26:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
   4ca2b:	48 8d 78 30          	lea    0x30(%rax),%rdi
   4ca2f:	e8 5c 2d 01 00       	call   5f790 <<alloc::raw_vec::RawVec<u128>>::grow_one>
   4ca34:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
   4ca39:	48 8b 42 38          	mov    0x38(%rdx),%rax
   4ca3d:	4c 89 f9             	mov    %r15,%rcx
   4ca40:	48 c1 e1 04          	shl    $0x4,%rcx
   4ca44:	4c 89 74 08 08       	mov    %r14,0x8(%rax,%rcx,1)
   4ca49:	48 89 1c 08          	mov    %rbx,(%rax,%rcx,1)
   4ca4d:	49 ff c7             	inc    %r15
   4ca50:	4c 89 7a 40          	mov    %r15,0x40(%rdx)
   4ca54:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
   4ca59:	48 8b 74 24 38       	mov    0x38(%rsp),%rsi
   4ca5e:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
   4ca63:	48 8b 4c 24 68       	mov    0x68(%rsp),%rcx
   4ca68:	4c 8b 44 24 70       	mov    0x70(%rsp),%r8
   4ca6d:	e8 ae 56 00 00       	call   52120 <policy_confirmation::validate::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>>
   4ca72:	48 83 7c 24 10 00    	cmpq   $0x0,0x10(%rsp)
   4ca78:	74 0b                	je     4ca85 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xba5>
   4ca7a:	48 8b 7c 24 18       	mov    0x18(%rsp),%rdi
   4ca7f:	ff 15 73 76 05 00    	call   *0x57673(%rip)        # a40f8 <free@GLIBC_2.2.5>
   4ca85:	48 81 c4 e8 80 00 00 	add    $0x80e8,%rsp
   4ca8c:	5b                   	pop    %rbx
   4ca8d:	41 5c                	pop    %r12
   4ca8f:	41 5d                	pop    %r13
   4ca91:	41 5e                	pop    %r14
   4ca93:	41 5f                	pop    %r15
   4ca95:	5d                   	pop    %rbp
   4ca96:	c3                   	ret
   4ca97:	48 8d 3d b7 fc fb ff 	lea    -0x40349(%rip),%rdi        # c755 <panic_unwind::imp::CANARY+0x5a9>
   4ca9e:	48 8d 15 03 55 05 00 	lea    0x55503(%rip),%rdx        # a1fa8 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.1797.llvm.15448142832521594973+0xb80>
   4caa5:	be 1c 00 00 00       	mov    $0x1c,%esi
   4caaa:	c5 f8 77             	vzeroupper
   4caad:	ff 15 55 78 05 00    	call   *0x57855(%rip)        # a4308 <_DYNAMIC+0x408>
   4cab3:	e9 b1 01 00 00       	jmp    4cc69 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xd89>
   4cab8:	48 8d 3d 96 fc fb ff 	lea    -0x4036a(%rip),%rdi        # c755 <panic_unwind::imp::CANARY+0x5a9>
   4cabf:	48 8d 15 e2 54 05 00 	lea    0x554e2(%rip),%rdx        # a1fa8 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.1797.llvm.15448142832521594973+0xb80>
   4cac6:	be 1c 00 00 00       	mov    $0x1c,%esi
   4cacb:	c5 f8 77             	vzeroupper
   4cace:	ff 15 34 78 05 00    	call   *0x57834(%rip)        # a4308 <_DYNAMIC+0x408>
   4cad4:	48 8d 05 e5 54 05 00 	lea    0x554e5(%rip),%rax        # a1fc0 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.1797.llvm.15448142832521594973+0xb98>
   4cadb:	48 89 84 24 88 00 00 	mov    %rax,0x88(%rsp)
   4cae2:	00 
   4cae3:	48 c7 84 24 90 00 00 	movq   $0x1,0x90(%rsp)
   4caea:	00 01 00 00 00 
   4caef:	48 c7 84 24 98 00 00 	movq   $0x8,0x98(%rsp)
   4caf6:	00 08 00 00 00 
   4cafb:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
   4caff:	c5 fa 7f 84 24 a0 00 	vmovdqu %xmm0,0xa0(%rsp)
   4cb06:	00 00 
   4cb08:	48 8d 15 b9 d4 fb ff 	lea    -0x42b47(%rip),%rdx        # 9fc8 <anon.25805f450824d4a1248fcaae526abf58.318.llvm.3576388159787090369+0x6c>
   4cb0f:	4c 8d 05 ba 54 05 00 	lea    0x554ba(%rip),%r8        # a1fd0 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.1797.llvm.15448142832521594973+0xba8>
   4cb16:	48 8d 74 24 10       	lea    0x10(%rsp),%rsi
   4cb1b:	48 8d 8c 24 88 00 00 	lea    0x88(%rsp),%rcx
   4cb22:	00 
   4cb23:	31 ff                	xor    %edi,%edi
   4cb25:	ff 15 0d 7c 05 00    	call   *0x57c0d(%rip)        # a4738 <_DYNAMIC+0x838>
   4cb2b:	48 8d 3d 23 fc fb ff 	lea    -0x403dd(%rip),%rdi        # c755 <panic_unwind::imp::CANARY+0x5a9>
   4cb32:	48 8d 15 6f 54 05 00 	lea    0x5546f(%rip),%rdx        # a1fa8 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.1797.llvm.15448142832521594973+0xb80>
   4cb39:	be 1c 00 00 00       	mov    $0x1c,%esi
   4cb3e:	c5 f8 77             	vzeroupper
   4cb41:	ff 15 c1 77 05 00    	call   *0x577c1(%rip)        # a4308 <_DYNAMIC+0x408>
   4cb47:	48 8d 05 b2 4f 05 00 	lea    0x54fb2(%rip),%rax        # a1b00 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.1797.llvm.15448142832521594973+0x6d8>
   4cb4e:	48 89 84 24 e0 00 00 	mov    %rax,0xe0(%rsp)
   4cb55:	00 
   4cb56:	48 c7 84 24 e8 00 00 	movq   $0x1,0xe8(%rsp)
   4cb5d:	00 01 00 00 00 
   4cb62:	48 c7 84 24 f0 00 00 	movq   $0x8,0xf0(%rsp)
   4cb69:	00 08 00 00 00 
   4cb6e:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
   4cb72:	c5 fa 7f 84 24 f8 00 	vmovdqu %xmm0,0xf8(%rsp)
   4cb79:	00 00 
   4cb7b:	48 83 c3 38          	add    $0x38,%rbx
   4cb7f:	48 8d 15 72 d5 fb ff 	lea    -0x42a8e(%rip),%rdx        # a0f8 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973>
   4cb86:	4c 8d 05 83 4f 05 00 	lea    0x54f83(%rip),%r8        # a1b10 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.1797.llvm.15448142832521594973+0x6e8>
   4cb8d:	48 8d 8c 24 e0 00 00 	lea    0xe0(%rsp),%rcx
   4cb94:	00 
   4cb95:	31 ff                	xor    %edi,%edi
   4cb97:	48 89 de             	mov    %rbx,%rsi
   4cb9a:	ff 15 90 77 05 00    	call   *0x57790(%rip)        # a4330 <_DYNAMIC+0x430>
   4cba0:	48 8d 74 24 48       	lea    0x48(%rsp),%rsi
   4cba5:	eb 26                	jmp    4cbcd <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xced>
   4cba7:	48 8d 3d a7 fb fb ff 	lea    -0x40459(%rip),%rdi        # c755 <panic_unwind::imp::CANARY+0x5a9>
   4cbae:	48 8d 15 f3 53 05 00 	lea    0x553f3(%rip),%rdx        # a1fa8 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.1797.llvm.15448142832521594973+0xb80>
   4cbb5:	be 1c 00 00 00       	mov    $0x1c,%esi
   4cbba:	c5 f8 77             	vzeroupper
   4cbbd:	ff 15 45 77 05 00    	call   *0x57745(%rip)        # a4308 <_DYNAMIC+0x408>
   4cbc3:	e9 a1 00 00 00       	jmp    4cc69 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xd89>
   4cbc8:	48 8d 74 24 5c       	lea    0x5c(%rsp),%rsi
   4cbcd:	48 8d 8c 24 88 00 00 	lea    0x88(%rsp),%rcx
   4cbd4:	00 
   4cbd5:	48 8d 05 e4 53 05 00 	lea    0x553e4(%rip),%rax        # a1fc0 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.1797.llvm.15448142832521594973+0xb98>
   4cbdc:	48 89 01             	mov    %rax,(%rcx)
   4cbdf:	48 c7 41 08 01 00 00 	movq   $0x1,0x8(%rcx)
   4cbe6:	00 
   4cbe7:	48 c7 41 10 08 00 00 	movq   $0x8,0x10(%rcx)
   4cbee:	00 
   4cbef:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
   4cbf3:	c5 fa 7f 03          	vmovdqu %xmm0,(%rbx)
   4cbf7:	48 8d 15 ca d3 fb ff 	lea    -0x42c36(%rip),%rdx        # 9fc8 <anon.25805f450824d4a1248fcaae526abf58.318.llvm.3576388159787090369+0x6c>
   4cbfe:	4c 8d 05 cb 53 05 00 	lea    0x553cb(%rip),%r8        # a1fd0 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.1797.llvm.15448142832521594973+0xba8>
   4cc05:	31 ff                	xor    %edi,%edi
   4cc07:	ff 15 2b 7b 05 00    	call   *0x57b2b(%rip)        # a4738 <_DYNAMIC+0x838>
   4cc0d:	eb 5a                	jmp    4cc69 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xd89>
   4cc0f:	48 8d 05 aa 53 05 00 	lea    0x553aa(%rip),%rax        # a1fc0 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.1797.llvm.15448142832521594973+0xb98>
   4cc16:	48 89 84 24 88 00 00 	mov    %rax,0x88(%rsp)
   4cc1d:	00 
   4cc1e:	48 c7 84 24 90 00 00 	movq   $0x1,0x90(%rsp)
   4cc25:	00 01 00 00 00 
   4cc2a:	48 c7 84 24 98 00 00 	movq   $0x8,0x98(%rsp)
   4cc31:	00 08 00 00 00 
   4cc36:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
   4cc3a:	c5 fa 7f 84 24 a0 00 	vmovdqu %xmm0,0xa0(%rsp)
   4cc41:	00 00 
   4cc43:	48 8d 15 7e d3 fb ff 	lea    -0x42c82(%rip),%rdx        # 9fc8 <anon.25805f450824d4a1248fcaae526abf58.318.llvm.3576388159787090369+0x6c>
   4cc4a:	4c 8d 05 7f 53 05 00 	lea    0x5537f(%rip),%r8        # a1fd0 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.1797.llvm.15448142832521594973+0xba8>
   4cc51:	48 8d b4 24 b8 00 00 	lea    0xb8(%rsp),%rsi
   4cc58:	00 
   4cc59:	48 8d 8c 24 88 00 00 	lea    0x88(%rsp),%rcx
   4cc60:	00 
   4cc61:	31 ff                	xor    %edi,%edi
   4cc63:	ff 15 cf 7a 05 00    	call   *0x57acf(%rip)        # a4738 <_DYNAMIC+0x838>
   4cc69:	0f 0b                	ud2
   4cc6b:	48 8d 15 76 4e 05 00 	lea    0x54e76(%rip),%rdx        # a1ae8 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.1797.llvm.15448142832521594973+0x6c0>
   4cc72:	31 ff                	xor    %edi,%edi
   4cc74:	31 f6                	xor    %esi,%esi
   4cc76:	ff 15 d4 74 05 00    	call   *0x574d4(%rip)        # a4150 <_DYNAMIC+0x250>
   4cc7c:	31 c0                	xor    %eax,%eax
   4cc7e:	eb 02                	jmp    4cc82 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xda2>
   4cc80:	b0 01                	mov    $0x1,%al
   4cc82:	88 84 24 e0 00 00 00 	mov    %al,0xe0(%rsp)
   4cc89:	48 8d 3d f4 fa fb ff 	lea    -0x4050c(%rip),%rdi        # c784 <panic_unwind::imp::CANARY+0x5d8>
   4cc90:	48 8d 0d 69 53 05 00 	lea    0x55369(%rip),%rcx        # a2000 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.1797.llvm.15448142832521594973+0xbd8>
   4cc97:	4c 8d 05 92 54 05 00 	lea    0x55492(%rip),%r8        # a2130 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.1797.llvm.15448142832521594973+0xd08>
   4cc9e:	48 8d 94 24 e0 00 00 	lea    0xe0(%rsp),%rdx
   4cca5:	00 
   4cca6:	be 2b 00 00 00       	mov    $0x2b,%esi
   4ccab:	ff 15 e7 74 05 00    	call   *0x574e7(%rip)        # a4198 <_DYNAMIC+0x298>
   4ccb1:	bf 40 00 00 00       	mov    $0x40,%edi
   4ccb6:	4c 89 fe             	mov    %r15,%rsi
   4ccb9:	ff 15 81 74 05 00    	call   *0x57481(%rip)        # a4140 <_DYNAMIC+0x240>
   4ccbf:	bf 40 00 00 00       	mov    $0x40,%edi
   4ccc4:	4c 89 f6             	mov    %r14,%rsi
   4ccc7:	ff 15 73 74 05 00    	call   *0x57473(%rip)        # a4140 <_DYNAMIC+0x240>
   4cccd:	48 89 c3             	mov    %rax,%rbx
   4ccd0:	48 8b 84 24 80 00 00 	mov    0x80(%rsp),%rax
   4ccd7:	00 
   4ccd8:	eb 2c                	jmp    4cd06 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xe26>
   4ccda:	48 89 c3             	mov    %rax,%rbx
   4ccdd:	48 83 7c 24 10 00    	cmpq   $0x0,0x10(%rsp)
   4cce3:	74 26                	je     4cd0b <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xe2b>
   4cce5:	48 8b 84 24 d0 00 00 	mov    0xd0(%rsp),%rax
   4ccec:	00 
   4cced:	48 8b 38             	mov    (%rax),%rdi
   4ccf0:	ff 15 02 74 05 00    	call   *0x57402(%rip)        # a40f8 <free@GLIBC_2.2.5>
   4ccf6:	48 89 df             	mov    %rbx,%rdi
   4ccf9:	e8 12 18 05 00       	call   9e510 <_Unwind_Resume@plt>
   4ccfe:	48 89 c3             	mov    %rax,%rbx
   4cd01:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
   4cd06:	48 85 c0             	test   %rax,%rax
   4cd09:	75 da                	jne    4cce5 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xe05>
   4cd0b:	48 89 df             	mov    %rbx,%rdi
   4cd0e:	e8 fd 17 05 00       	call   9e510 <_Unwind_Resume@plt>
   4cd13:	cc                   	int3
   4cd14:	cc                   	int3
   4cd15:	cc                   	int3
   4cd16:	cc                   	int3
   4cd17:	cc                   	int3
   4cd18:	cc                   	int3
   4cd19:	cc                   	int3
   4cd1a:	cc                   	int3
   4cd1b:	cc                   	int3
   4cd1c:	cc                   	int3
   4cd1d:	cc                   	int3
   4cd1e:	cc                   	int3
   4cd1f:	cc                   	int3

