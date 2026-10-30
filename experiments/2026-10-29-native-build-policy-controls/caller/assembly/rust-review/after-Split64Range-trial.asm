000000000004f920 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>>:
   4f920:	55                   	push   %rbp
   4f921:	41 57                	push   %r15
   4f923:	41 56                	push   %r14
   4f925:	41 55                	push   %r13
   4f927:	41 54                	push   %r12
   4f929:	53                   	push   %rbx
   4f92a:	49 89 e3             	mov    %rsp,%r11
   4f92d:	49 81 eb 00 80 00 00 	sub    $0x8000,%r11
   4f934:	48 81 ec 00 10 00 00 	sub    $0x1000,%rsp
   4f93b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
   4f942:	00 
   4f943:	4c 39 dc             	cmp    %r11,%rsp
   4f946:	75 ec                	jne    4f934 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0x14>
   4f948:	48 81 ec e8 00 00 00 	sub    $0xe8,%rsp
   4f94f:	4c 89 4c 24 08       	mov    %r9,0x8(%rsp)
   4f954:	48 89 74 24 30       	mov    %rsi,0x30(%rsp)
   4f959:	4c 8b 77 10          	mov    0x10(%rdi),%r14
   4f95d:	4d 85 f6             	test   %r14,%r14
   4f960:	0f 84 45 0d 00 00    	je     506ab <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xd8b>
   4f966:	48 89 fb             	mov    %rdi,%rbx
   4f969:	4c 8b 6f 08          	mov    0x8(%rdi),%r13
   4f96d:	49 8b 45 00          	mov    0x0(%r13),%rax
   4f971:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
   4f975:	c5 fe 7f 84 24 40 01 	vmovdqu %ymm0,0x140(%rsp)
   4f97c:	00 00 
   4f97e:	c5 fe 7f 84 24 20 01 	vmovdqu %ymm0,0x120(%rsp)
   4f985:	00 00 
   4f987:	c5 fe 7f 84 24 00 01 	vmovdqu %ymm0,0x100(%rsp)
   4f98e:	00 00 
   4f990:	c5 fe 7f 84 24 e0 00 	vmovdqu %ymm0,0xe0(%rsp)
   4f997:	00 00 
   4f999:	48 3d 00 04 00 00    	cmp    $0x400,%rax
   4f99f:	0f 83 c6 0b 00 00    	jae    5056b <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xc4b>
   4f9a5:	44 89 c5             	mov    %r8d,%ebp
   4f9a8:	48 89 54 24 68       	mov    %rdx,0x68(%rsp)
   4f9ad:	48 89 4c 24 70       	mov    %rcx,0x70(%rsp)
   4f9b2:	b9 01 00 00 00       	mov    $0x1,%ecx
   4f9b7:	c4 e2 f9 f7 c9       	shlx   %rax,%rcx,%rcx
   4f9bc:	48 c1 e8 06          	shr    $0x6,%rax
   4f9c0:	48 09 8c c4 e0 00 00 	or     %rcx,0xe0(%rsp,%rax,8)
   4f9c7:	00 
   4f9c8:	48 8d 94 24 e0 00 00 	lea    0xe0(%rsp),%rdx
   4f9cf:	00 
   4f9d0:	be 80 00 00 00       	mov    $0x80,%esi
   4f9d5:	31 ff                	xor    %edi,%edi
   4f9d7:	c5 f8 77             	vzeroupper
   4f9da:	ff 15 40 4d 05 00    	call   *0x54d40(%rip)        # a4720 <sched_setaffinity@GLIBC_2.3.4>
   4f9e0:	89 44 24 10          	mov    %eax,0x10(%rsp)
   4f9e4:	85 c0                	test   %eax,%eax
   4f9e6:	0f 85 28 0b 00 00    	jne    50514 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xbf4>
   4f9ec:	48 8d 44 24 18       	lea    0x18(%rsp),%rax
   4f9f1:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
   4f9f8:	00 
   4f9f9:	40 84 ed             	test   %bpl,%bpl
   4f9fc:	0f 84 ea 02 00 00    	je     4fcec <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0x3cc>
   4fa02:	48 83 7b 38 00       	cmpq   $0x0,0x38(%rbx)
   4fa07:	0f 85 7a 0b 00 00    	jne    50587 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xc67>
   4fa0d:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
   4fa11:	c5 fe 7f 84 24 40 01 	vmovdqu %ymm0,0x140(%rsp)
   4fa18:	00 00 
   4fa1a:	c5 fe 7f 84 24 20 01 	vmovdqu %ymm0,0x120(%rsp)
   4fa21:	00 00 
   4fa23:	c5 fe 7f 84 24 00 01 	vmovdqu %ymm0,0x100(%rsp)
   4fa2a:	00 00 
   4fa2c:	c5 fe 7f 84 24 e0 00 	vmovdqu %ymm0,0xe0(%rsp)
   4fa33:	00 00 
   4fa35:	49 c1 e6 03          	shl    $0x3,%r14
   4fa39:	31 c0                	xor    %eax,%eax
   4fa3b:	b9 01 00 00 00       	mov    $0x1,%ecx
   4fa40:	49 8b 54 05 00       	mov    0x0(%r13,%rax,1),%rdx
   4fa45:	48 81 fa 00 04 00 00 	cmp    $0x400,%rdx
   4fa4c:	0f 83 a6 0a 00 00    	jae    504f8 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xbd8>
   4fa52:	c4 e2 e9 f7 f1       	shlx   %rdx,%rcx,%rsi
   4fa57:	48 c1 ea 06          	shr    $0x6,%rdx
   4fa5b:	48 09 b4 d4 e0 00 00 	or     %rsi,0xe0(%rsp,%rdx,8)
   4fa62:	00 
   4fa63:	48 83 c0 08          	add    $0x8,%rax
   4fa67:	49 39 c6             	cmp    %rax,%r14
   4fa6a:	75 d4                	jne    4fa40 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0x120>
   4fa6c:	48 8d 94 24 e0 00 00 	lea    0xe0(%rsp),%rdx
   4fa73:	00 
   4fa74:	be 80 00 00 00       	mov    $0x80,%esi
   4fa79:	31 ff                	xor    %edi,%edi
   4fa7b:	c5 f8 77             	vzeroupper
   4fa7e:	ff 15 9c 4c 05 00    	call   *0x54c9c(%rip)        # a4720 <sched_setaffinity@GLIBC_2.3.4>
   4fa84:	89 44 24 10          	mov    %eax,0x10(%rsp)
   4fa88:	85 c0                	test   %eax,%eax
   4fa8a:	0f 85 84 0a 00 00    	jne    50514 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xbf4>
   4fa90:	ff 15 92 4c 05 00    	call   *0x54c92(%rip)        # a4728 <_DYNAMIC+0x828>
   4fa96:	48 89 44 24 48       	mov    %rax,0x48(%rsp)
   4fa9b:	89 54 24 50          	mov    %edx,0x50(%rsp)
   4fa9f:	49 89 dc             	mov    %rbx,%r12
   4faa2:	48 8b 5b 20          	mov    0x20(%rbx),%rbx
   4faa6:	48 81 fb 80 00 00 00 	cmp    $0x80,%rbx
   4faad:	0f 82 09 0c 00 00    	jb     506bc <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xd9c>
   4fab3:	48 81 fb 00 00 00 10 	cmp    $0x10000000,%rbx
   4faba:	0f 87 00 0c 00 00    	ja     506c0 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xda0>
   4fac0:	41 89 de             	mov    %ebx,%r14d
   4fac3:	41 81 e6 c0 ff ff 1f 	and    $0x1fffffc0,%r14d
   4faca:	48 c7 84 24 e0 00 00 	movq   $0x0,0xe0(%rsp)
   4fad1:	00 00 00 00 00 
   4fad6:	48 8d bc 24 e0 00 00 	lea    0xe0(%rsp),%rdi
   4fadd:	00 
   4fade:	be 40 00 00 00       	mov    $0x40,%esi
   4fae3:	4c 89 f2             	mov    %r14,%rdx
   4fae6:	ff 15 04 46 05 00    	call   *0x54604(%rip)        # a40f0 <posix_memalign@GLIBC_2.2.5>
   4faec:	85 c0                	test   %eax,%eax
   4faee:	0f 85 0b 0c 00 00    	jne    506ff <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xddf>
   4faf4:	4c 8b bc 24 e0 00 00 	mov    0xe0(%rsp),%r15
   4fafb:	00 
   4fafc:	4d 85 ff             	test   %r15,%r15
   4faff:	0f 84 fa 0b 00 00    	je     506ff <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xddf>
   4fb05:	48 c1 eb 06          	shr    $0x6,%rbx
   4fb09:	49 8d 56 c0          	lea    -0x40(%r14),%rdx
   4fb0d:	4c 89 ff             	mov    %r15,%rdi
   4fb10:	31 f6                	xor    %esi,%esi
   4fb12:	ff 15 00 46 05 00    	call   *0x54600(%rip)        # a4118 <memset@GLIBC_2.2.5>
   4fb18:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
   4fb1c:	c4 81 7d 7f 44 37 c0 	vmovdqa %ymm0,-0x40(%r15,%r14,1)
   4fb23:	c4 81 7d 7f 44 37 e0 	vmovdqa %ymm0,-0x20(%r15,%r14,1)
   4fb2a:	48 89 5c 24 10       	mov    %rbx,0x10(%rsp)
   4fb2f:	4c 89 7c 24 18       	mov    %r15,0x18(%rsp)
   4fb34:	48 89 5c 24 20       	mov    %rbx,0x20(%rsp)
   4fb39:	89 5c 24 28          	mov    %ebx,0x28(%rsp)
   4fb3d:	66 c7 44 24 2c 01 01 	movw   $0x101,0x2c(%rsp)
   4fb44:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
   4fb49:	c5 fa 6f 40 08       	vmovdqu 0x8(%rax),%xmm0
   4fb4e:	c5 fa 7f 84 24 e0 00 	vmovdqu %xmm0,0xe0(%rsp)
   4fb55:	00 00 
   4fb57:	48 8d 84 24 e0 00 00 	lea    0xe0(%rsp),%rax
   4fb5e:	00 
   4fb5f:	48 8b b4 24 e0 00 00 	mov    0xe0(%rsp),%rsi
   4fb66:	00 
   4fb67:	48 8b 94 24 e8 00 00 	mov    0xe8(%rsp),%rdx
   4fb6e:	00 
   4fb6f:	49 8b 4c 24 30       	mov    0x30(%r12),%rcx
   4fb74:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
   4fb79:	c5 f8 77             	vzeroupper
   4fb7c:	ff 15 b6 49 05 00    	call   *0x549b6(%rip)        # a4538 <_DYNAMIC+0x638>
   4fb82:	48 8d 7c 24 48       	lea    0x48(%rsp),%rdi
   4fb87:	ff 15 a3 4b 05 00    	call   *0x54ba3(%rip)        # a4730 <_DYNAMIC+0x830>
   4fb8d:	49 89 c6             	mov    %rax,%r14
   4fb90:	49 8b 45 00          	mov    0x0(%r13),%rax
   4fb94:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
   4fb98:	c5 fe 7f 84 24 40 01 	vmovdqu %ymm0,0x140(%rsp)
   4fb9f:	00 00 
   4fba1:	c5 fe 7f 84 24 20 01 	vmovdqu %ymm0,0x120(%rsp)
   4fba8:	00 00 
   4fbaa:	c5 fe 7f 84 24 00 01 	vmovdqu %ymm0,0x100(%rsp)
   4fbb1:	00 00 
   4fbb3:	c5 fe 7f 84 24 e0 00 	vmovdqu %ymm0,0xe0(%rsp)
   4fbba:	00 00 
   4fbbc:	48 3d 00 04 00 00    	cmp    $0x400,%rax
   4fbc2:	0f 83 1f 0a 00 00    	jae    505e7 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xcc7>
   4fbc8:	89 d5                	mov    %edx,%ebp
   4fbca:	b9 01 00 00 00       	mov    $0x1,%ecx
   4fbcf:	c4 e2 f9 f7 c9       	shlx   %rax,%rcx,%rcx
   4fbd4:	48 c1 e8 06          	shr    $0x6,%rax
   4fbd8:	48 09 8c c4 e0 00 00 	or     %rcx,0xe0(%rsp,%rax,8)
   4fbdf:	00 
   4fbe0:	48 8d 94 24 e0 00 00 	lea    0xe0(%rsp),%rdx
   4fbe7:	00 
   4fbe8:	be 80 00 00 00       	mov    $0x80,%esi
   4fbed:	31 ff                	xor    %edi,%edi
   4fbef:	c5 f8 77             	vzeroupper
   4fbf2:	ff 15 28 4b 05 00    	call   *0x54b28(%rip)        # a4720 <sched_setaffinity@GLIBC_2.3.4>
   4fbf8:	89 84 24 b8 00 00 00 	mov    %eax,0xb8(%rsp)
   4fbff:	85 c0                	test   %eax,%eax
   4fc01:	0f 85 48 0a 00 00    	jne    5064f <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xd2f>
   4fc07:	b8 00 ca 9a 3b       	mov    $0x3b9aca00,%eax
   4fc0c:	4c 89 f2             	mov    %r14,%rdx
   4fc0f:	c4 62 fb f6 f0       	mulx   %rax,%rax,%r14
   4fc14:	89 eb                	mov    %ebp,%ebx
   4fc16:	48 01 c3             	add    %rax,%rbx
   4fc19:	49 83 d6 00          	adc    $0x0,%r14
   4fc1d:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
   4fc22:	4c 8b 78 28          	mov    0x28(%rax),%r15
   4fc26:	4c 3b 78 18          	cmp    0x18(%rax),%r15
   4fc2a:	75 0e                	jne    4fc3a <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0x31a>
   4fc2c:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
   4fc31:	48 8d 78 18          	lea    0x18(%rax),%rdi
   4fc35:	e8 56 fb 00 00       	call   5f790 <<alloc::raw_vec::RawVec<u128>>::grow_one>
   4fc3a:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
   4fc3f:	48 8b 42 20          	mov    0x20(%rdx),%rax
   4fc43:	4c 89 f9             	mov    %r15,%rcx
   4fc46:	48 c1 e1 04          	shl    $0x4,%rcx
   4fc4a:	4c 89 74 08 08       	mov    %r14,0x8(%rax,%rcx,1)
   4fc4f:	48 89 1c 08          	mov    %rbx,(%rax,%rcx,1)
   4fc53:	49 ff c7             	inc    %r15
   4fc56:	4c 89 7a 28          	mov    %r15,0x28(%rdx)
   4fc5a:	48 8b 5a 58          	mov    0x58(%rdx),%rbx
   4fc5e:	48 3b 5a 48          	cmp    0x48(%rdx),%rbx
   4fc62:	75 0e                	jne    4fc72 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0x352>
   4fc64:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
   4fc69:	48 8d 78 48          	lea    0x48(%rax),%rdi
   4fc6d:	e8 1e fb 00 00       	call   5f790 <<alloc::raw_vec::RawVec<u128>>::grow_one>
   4fc72:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
   4fc77:	48 8b 42 50          	mov    0x50(%rdx),%rax
   4fc7b:	48 89 d9             	mov    %rbx,%rcx
   4fc7e:	48 c1 e1 04          	shl    $0x4,%rcx
   4fc82:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
   4fc86:	c5 f9 7f 04 08       	vmovdqa %xmm0,(%rax,%rcx,1)
   4fc8b:	48 ff c3             	inc    %rbx
   4fc8e:	48 89 5a 58          	mov    %rbx,0x58(%rdx)
   4fc92:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
   4fc97:	48 8b 54 24 20       	mov    0x20(%rsp),%rdx
   4fc9c:	48 8d bc 24 e0 00 00 	lea    0xe0(%rsp),%rdi
   4fca3:	00 
   4fca4:	4c 89 e1             	mov    %r12,%rcx
   4fca7:	e8 b4 20 00 00       	call   51d60 <policy_confirmation::observe::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>>
   4fcac:	48 8b 84 24 f0 00 00 	mov    0xf0(%rsp),%rax
   4fcb3:	00 
   4fcb4:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
   4fcb9:	48 89 41 70          	mov    %rax,0x70(%rcx)
   4fcbd:	c5 fa 6f 84 24 e0 00 	vmovdqu 0xe0(%rsp),%xmm0
   4fcc4:	00 00 
   4fcc6:	c5 fa 7f 41 60       	vmovdqu %xmm0,0x60(%rcx)
   4fccb:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
   4fcd0:	4c 89 e6             	mov    %r12,%rsi
   4fcd3:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
   4fcd8:	48 8b 4c 24 68       	mov    0x68(%rsp),%rcx
   4fcdd:	4c 8b 44 24 70       	mov    0x70(%rsp),%r8
   4fce2:	e8 39 59 00 00       	call   55620 <policy_confirmation::validate::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>>
   4fce7:	e9 c6 07 00 00       	jmp    504b2 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xb92>
   4fcec:	4c 8b 63 20          	mov    0x20(%rbx),%r12
   4fcf0:	49 81 fc 80 00 00 00 	cmp    $0x80,%r12
   4fcf7:	0f 82 bf 09 00 00    	jb     506bc <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xd9c>
   4fcfd:	49 81 fc 00 00 00 10 	cmp    $0x10000000,%r12
   4fd04:	0f 87 b6 09 00 00    	ja     506c0 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xda0>
   4fd0a:	4c 89 6c 24 60       	mov    %r13,0x60(%rsp)
   4fd0f:	45 89 e7             	mov    %r12d,%r15d
   4fd12:	41 81 e7 c0 ff ff 1f 	and    $0x1fffffc0,%r15d
   4fd19:	48 c7 84 24 e0 00 00 	movq   $0x0,0xe0(%rsp)
   4fd20:	00 00 00 00 00 
   4fd25:	48 8d bc 24 e0 00 00 	lea    0xe0(%rsp),%rdi
   4fd2c:	00 
   4fd2d:	be 40 00 00 00       	mov    $0x40,%esi
   4fd32:	4c 89 fa             	mov    %r15,%rdx
   4fd35:	ff 15 b5 43 05 00    	call   *0x543b5(%rip)        # a40f0 <posix_memalign@GLIBC_2.2.5>
   4fd3b:	85 c0                	test   %eax,%eax
   4fd3d:	0f 85 ae 09 00 00    	jne    506f1 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xdd1>
   4fd43:	4c 8b ac 24 e0 00 00 	mov    0xe0(%rsp),%r13
   4fd4a:	00 
   4fd4b:	4d 85 ed             	test   %r13,%r13
   4fd4e:	0f 84 9d 09 00 00    	je     506f1 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xdd1>
   4fd54:	4c 89 b4 24 c8 00 00 	mov    %r14,0xc8(%rsp)
   4fd5b:	00 
   4fd5c:	49 c1 ec 06          	shr    $0x6,%r12
   4fd60:	49 8d 57 c0          	lea    -0x40(%r15),%rdx
   4fd64:	4c 89 ef             	mov    %r13,%rdi
   4fd67:	31 f6                	xor    %esi,%esi
   4fd69:	ff 15 a9 43 05 00    	call   *0x543a9(%rip)        # a4118 <memset@GLIBC_2.2.5>
   4fd6f:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
   4fd73:	c4 81 7d 7f 44 3d c0 	vmovdqa %ymm0,-0x40(%r13,%r15,1)
   4fd7a:	c4 81 7d 7f 44 3d e0 	vmovdqa %ymm0,-0x20(%r13,%r15,1)
   4fd81:	4c 89 64 24 10       	mov    %r12,0x10(%rsp)
   4fd86:	4c 89 ac 24 d8 00 00 	mov    %r13,0xd8(%rsp)
   4fd8d:	00 
   4fd8e:	4c 89 6c 24 18       	mov    %r13,0x18(%rsp)
   4fd93:	4c 89 64 24 20       	mov    %r12,0x20(%rsp)
   4fd98:	44 89 64 24 28       	mov    %r12d,0x28(%rsp)
   4fd9d:	66 c7 44 24 2c 01 01 	movw   $0x101,0x2c(%rsp)
   4fda4:	48 8d bc 24 e0 00 00 	lea    0xe0(%rsp),%rdi
   4fdab:	00 
   4fdac:	4c 89 e6             	mov    %r12,%rsi
   4fdaf:	4c 89 a4 24 80 00 00 	mov    %r12,0x80(%rsp)
   4fdb6:	00 
   4fdb7:	4c 89 e2             	mov    %r12,%rdx
   4fdba:	48 89 5c 24 38       	mov    %rbx,0x38(%rsp)
   4fdbf:	48 89 d9             	mov    %rbx,%rcx
   4fdc2:	c5 f8 77             	vzeroupper
   4fdc5:	e8 96 1f 00 00       	call   51d60 <policy_confirmation::observe::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>>
   4fdca:	48 8b 84 24 f0 00 00 	mov    0xf0(%rsp),%rax
   4fdd1:	00 
   4fdd2:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
   4fdd7:	48 89 41 70          	mov    %rax,0x70(%rcx)
   4fddb:	c5 fa 6f 84 24 e0 00 	vmovdqu 0xe0(%rsp),%xmm0
   4fde2:	00 00 
   4fde4:	c5 fa 7f 41 60       	vmovdqu %xmm0,0x60(%rcx)
   4fde9:	ff 15 39 49 05 00    	call   *0x54939(%rip)        # a4728 <_DYNAMIC+0x828>
   4fdef:	48 89 84 24 b8 00 00 	mov    %rax,0xb8(%rsp)
   4fdf6:	00 
   4fdf7:	89 94 24 c0 00 00 00 	mov    %edx,0xc0(%rsp)
   4fdfe:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
   4fe03:	48 8b 58 38          	mov    0x38(%rax),%rbx
   4fe07:	48 8b 40 48          	mov    0x48(%rax),%rax
   4fe0b:	48 89 44 24 78       	mov    %rax,0x78(%rsp)
   4fe10:	48 8d bc 24 e0 00 00 	lea    0xe0(%rsp),%rdi
   4fe17:	00 
   4fe18:	ba 00 80 00 00       	mov    $0x8000,%edx
   4fe1d:	31 f6                	xor    %esi,%esi
   4fe1f:	ff 15 f3 42 05 00    	call   *0x542f3(%rip)        # a4118 <memset@GLIBC_2.2.5>
   4fe25:	48 89 5c 24 40       	mov    %rbx,0x40(%rsp)
   4fe2a:	48 85 db             	test   %rbx,%rbx
   4fe2d:	0f 84 1c 04 00 00    	je     5024f <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0x92f>
   4fe33:	48 8b 5c 24 40       	mov    0x40(%rsp),%rbx
   4fe38:	49 89 dd             	mov    %rbx,%r13
   4fe3b:	49 c1 ed 0c          	shr    $0xc,%r13
   4fe3f:	89 d8                	mov    %ebx,%eax
   4fe41:	25 ff 0f 00 00       	and    $0xfff,%eax
   4fe46:	48 83 f8 01          	cmp    $0x1,%rax
   4fe4a:	49 83 dd ff          	sbb    $0xffffffffffffffff,%r13
   4fe4e:	45 31 f6             	xor    %r14d,%r14d
   4fe51:	49 bf 15 7c 4a 7f b9 	movabs $0x9e3779b97f4a7c15,%r15
   4fe58:	79 37 9e 
   4fe5b:	4c 8b 64 24 78       	mov    0x78(%rsp),%r12
   4fe60:	31 ed                	xor    %ebp,%ebp
   4fe62:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   4fe69:	1f 84 00 00 00 00 00 
   4fe70:	48 81 fb 00 10 00 00 	cmp    $0x1000,%rbx
   4fe77:	b9 00 10 00 00       	mov    $0x1000,%ecx
   4fe7c:	48 0f 42 cb          	cmovb  %rbx,%rcx
   4fe80:	4c 89 f0             	mov    %r14,%rax
   4fe83:	48 c1 e0 0c          	shl    $0xc,%rax
   4fe87:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
   4fe8c:	48 89 f2             	mov    %rsi,%rdx
   4fe8f:	48 29 c2             	sub    %rax,%rdx
   4fe92:	48 81 fa 00 10 00 00 	cmp    $0x1000,%rdx
   4fe99:	bf 00 10 00 00       	mov    $0x1000,%edi
   4fe9e:	48 0f 43 d7          	cmovae %rdi,%rdx
   4fea2:	48 89 f0             	mov    %rsi,%rax
   4fea5:	48 29 e8             	sub    %rbp,%rax
   4fea8:	48 3d 00 10 00 00    	cmp    $0x1000,%rax
   4feae:	48 0f 43 c7          	cmovae %rdi,%rax
   4feb2:	48 39 ee             	cmp    %rbp,%rsi
   4feb5:	0f 84 2a 03 00 00    	je     501e5 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0x8c5>
   4febb:	48 ff ca             	dec    %rdx
   4febe:	40 b6 3d             	mov    $0x3d,%sil
   4fec1:	c4 e2 c8 f5 fa       	bzhi   %rsi,%rdx,%rdi
   4fec6:	48 83 ff 03          	cmp    $0x3,%rdi
   4feca:	73 24                	jae    4fef0 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0x5d0>
   4fecc:	31 c9                	xor    %ecx,%ecx
   4fece:	48 8d bc 24 e0 00 00 	lea    0xe0(%rsp),%rdi
   4fed5:	00 
   4fed6:	49 b9 b9 e5 e4 1c 6d 	movabs $0xbf58476d1ce4e5b9,%r9
   4fedd:	47 58 bf 
   4fee0:	49 ba eb 11 31 13 bb 	movabs $0x94d049bb133111eb,%r10
   4fee7:	49 d0 94 
   4feea:	e9 96 02 00 00       	jmp    50185 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0x865>
   4feef:	90                   	nop
   4fef0:	48 ff c9             	dec    %rcx
   4fef3:	c4 e2 c8 f5 d1       	bzhi   %rsi,%rcx,%rdx
   4fef8:	48 ff c2             	inc    %rdx
   4fefb:	48 8d 77 01          	lea    0x1(%rdi),%rsi
   4feff:	48 8b 4c 24 78       	mov    0x78(%rsp),%rcx
   4ff04:	48 01 e9             	add    %rbp,%rcx
   4ff07:	62 f2 fd 28 7c c1    	vpbroadcastq %rcx,%ymm0
   4ff0d:	48 83 ff 0f          	cmp    $0xf,%rdi
   4ff11:	73 07                	jae    4ff1a <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0x5fa>
   4ff13:	31 c9                	xor    %ecx,%ecx
   4ff15:	e9 9f 01 00 00       	jmp    500b9 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0x799>
   4ff1a:	48 89 d7             	mov    %rdx,%rdi
   4ff1d:	48 83 e7 f0          	and    $0xfffffffffffffff0,%rdi
   4ff21:	48 89 f1             	mov    %rsi,%rcx
   4ff24:	49 b8 f0 ff ff ff ff 	movabs $0x3ffffffffffffff0,%r8
   4ff2b:	ff ff 3f 
   4ff2e:	4c 21 c1             	and    %r8,%rcx
   4ff31:	62 f1 fd 38 d4 0d 0d 	vpaddq -0x45df3(%rip){1to4},%ymm0,%ymm1        # a148 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x50>
   4ff38:	a2 fb ff 
   4ff3b:	62 f1 fd 38 d4 15 3b 	vpaddq -0x45ec5(%rip){1to4},%ymm0,%ymm2        # a080 <anon.25805f450824d4a1248fcaae526abf58.283.llvm.3576388159787090369+0x84>
   4ff42:	a1 fb ff 
   4ff45:	62 f1 fd 38 d4 1d 39 	vpaddq -0x45ec7(%rip){1to4},%ymm0,%ymm3        # a088 <anon.25805f450824d4a1248fcaae526abf58.283.llvm.3576388159787090369+0x8c>
   4ff4c:	a1 fb ff 
   4ff4f:	45 31 c0             	xor    %r8d,%r8d
   4ff52:	c5 fd 6f 25 06 a3 fb 	vmovdqa -0x45cfa(%rip),%ymm4        # a260 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x168>
   4ff59:	ff 
   4ff5a:	c4 62 7d 59 2d a5 a1 	vpbroadcastq -0x45e5b(%rip),%ymm13        # a108 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x10>
   4ff61:	fb ff 
   4ff63:	c4 62 7d 59 35 5c a1 	vpbroadcastq -0x45ea4(%rip),%ymm14        # a0c8 <anon.25805f450824d4a1248fcaae526abf58.283.llvm.3576388159787090369+0xcc>
   4ff6a:	fb ff 
   4ff6c:	c4 62 7d 59 3d 33 a1 	vpbroadcastq -0x45ecd(%rip),%ymm15        # a0a8 <anon.25805f450824d4a1248fcaae526abf58.283.llvm.3576388159787090369+0xac>
   4ff73:	fb ff 
   4ff75:	62 e2 fd 28 59 05 d1 	vpbroadcastq -0x45e2f(%rip),%ymm16        # a150 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x58>
   4ff7c:	a1 fb ff 
   4ff7f:	62 e2 fd 28 59 0d cf 	vpbroadcastq -0x45e31(%rip),%ymm17        # a158 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x60>
   4ff86:	a1 fb ff 
   4ff89:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
   4ff90:	c5 fd d4 ec          	vpaddq %ymm4,%ymm0,%ymm5
   4ff94:	c5 dd d4 f1          	vpaddq %ymm1,%ymm4,%ymm6
   4ff98:	c5 dd d4 fa          	vpaddq %ymm2,%ymm4,%ymm7
   4ff9c:	c5 5d d4 c3          	vpaddq %ymm3,%ymm4,%ymm8
   4ffa0:	62 d2 d5 28 40 ed    	vpmullq %ymm13,%ymm5,%ymm5
   4ffa6:	62 d2 cd 28 40 f5    	vpmullq %ymm13,%ymm6,%ymm6
   4ffac:	62 d2 c5 28 40 fd    	vpmullq %ymm13,%ymm7,%ymm7
   4ffb2:	62 52 bd 28 40 c5    	vpmullq %ymm13,%ymm8,%ymm8
   4ffb8:	c5 8d d4 ed          	vpaddq %ymm5,%ymm14,%ymm5
   4ffbc:	c5 8d d4 f6          	vpaddq %ymm6,%ymm14,%ymm6
   4ffc0:	c5 8d d4 ff          	vpaddq %ymm7,%ymm14,%ymm7
   4ffc4:	c4 41 3d d4 c6       	vpaddq %ymm14,%ymm8,%ymm8
   4ffc9:	c5 b5 73 d5 1e       	vpsrlq $0x1e,%ymm5,%ymm9
   4ffce:	c5 ad 73 d6 1e       	vpsrlq $0x1e,%ymm6,%ymm10
   4ffd3:	c5 a5 73 d7 1e       	vpsrlq $0x1e,%ymm7,%ymm11
   4ffd8:	c4 c1 1d 73 d0 1e    	vpsrlq $0x1e,%ymm8,%ymm12
   4ffde:	c5 b5 ef ed          	vpxor  %ymm5,%ymm9,%ymm5
   4ffe2:	c5 ad ef f6          	vpxor  %ymm6,%ymm10,%ymm6
   4ffe6:	c5 a5 ef ff          	vpxor  %ymm7,%ymm11,%ymm7
   4ffea:	c4 41 1d ef c0       	vpxor  %ymm8,%ymm12,%ymm8
   4ffef:	62 d2 d5 28 40 ef    	vpmullq %ymm15,%ymm5,%ymm5
   4fff5:	62 d2 cd 28 40 f7    	vpmullq %ymm15,%ymm6,%ymm6
   4fffb:	62 d2 c5 28 40 ff    	vpmullq %ymm15,%ymm7,%ymm7
   50001:	62 52 bd 28 40 c7    	vpmullq %ymm15,%ymm8,%ymm8
   50007:	c5 b5 73 d5 1b       	vpsrlq $0x1b,%ymm5,%ymm9
   5000c:	c5 ad 73 d6 1b       	vpsrlq $0x1b,%ymm6,%ymm10
   50011:	c5 a5 73 d7 1b       	vpsrlq $0x1b,%ymm7,%ymm11
   50016:	c5 b5 ef ed          	vpxor  %ymm5,%ymm9,%ymm5
   5001a:	c5 ad ef f6          	vpxor  %ymm6,%ymm10,%ymm6
   5001e:	c5 a5 ef ff          	vpxor  %ymm7,%ymm11,%ymm7
   50022:	62 b2 d5 28 40 e8    	vpmullq %ymm16,%ymm5,%ymm5
   50028:	62 b2 cd 28 40 f0    	vpmullq %ymm16,%ymm6,%ymm6
   5002e:	62 b2 c5 28 40 f8    	vpmullq %ymm16,%ymm7,%ymm7
   50034:	c4 c1 35 73 d0 1b    	vpsrlq $0x1b,%ymm8,%ymm9
   5003a:	c4 41 35 ef c0       	vpxor  %ymm8,%ymm9,%ymm8
   5003f:	62 32 bd 28 40 c0    	vpmullq %ymm16,%ymm8,%ymm8
   50045:	c5 b5 73 d5 1f       	vpsrlq $0x1f,%ymm5,%ymm9
   5004a:	c5 ad 73 d6 1f       	vpsrlq $0x1f,%ymm6,%ymm10
   5004f:	c5 a5 73 d7 1f       	vpsrlq $0x1f,%ymm7,%ymm11
   50054:	c4 c1 1d 73 d0 1f    	vpsrlq $0x1f,%ymm8,%ymm12
   5005a:	c5 b5 ef ed          	vpxor  %ymm5,%ymm9,%ymm5
   5005e:	c5 ad ef f6          	vpxor  %ymm6,%ymm10,%ymm6
   50062:	c5 a5 ef ff          	vpxor  %ymm7,%ymm11,%ymm7
   50066:	c4 a1 7e 7f ac c4 e0 	vmovdqu %ymm5,0xe0(%rsp,%r8,8)
   5006d:	00 00 00 
   50070:	c4 a1 7e 7f b4 c4 00 	vmovdqu %ymm6,0x100(%rsp,%r8,8)
   50077:	01 00 00 
   5007a:	c4 a1 7e 7f bc c4 20 	vmovdqu %ymm7,0x120(%rsp,%r8,8)
   50081:	01 00 00 
   50084:	c4 c1 1d ef e8       	vpxor  %ymm8,%ymm12,%ymm5
   50089:	c4 a1 7e 7f ac c4 40 	vmovdqu %ymm5,0x140(%rsp,%r8,8)
   50090:	01 00 00 
   50093:	49 83 c0 10          	add    $0x10,%r8
   50097:	62 b1 dd 28 d4 e1    	vpaddq %ymm17,%ymm4,%ymm4
   5009d:	4c 39 c7             	cmp    %r8,%rdi
   500a0:	0f 85 ea fe ff ff    	jne    4ff90 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0x670>
   500a6:	48 39 ce             	cmp    %rcx,%rsi
   500a9:	0f 84 36 01 00 00    	je     501e5 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0x8c5>
   500af:	40 f6 c6 0c          	test   $0xc,%sil
   500b3:	0f 84 89 01 00 00    	je     50242 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0x922>
   500b9:	49 89 c8             	mov    %rcx,%r8
   500bc:	48 83 e2 fc          	and    $0xfffffffffffffffc,%rdx
   500c0:	48 b9 f0 ff ff ff ff 	movabs $0x3ffffffffffffff0,%rcx
   500c7:	ff ff 3f 
   500ca:	48 83 c1 0c          	add    $0xc,%rcx
   500ce:	48 21 f1             	and    %rsi,%rcx
   500d1:	48 8d bc cc e0 00 00 	lea    0xe0(%rsp,%rcx,8),%rdi
   500d8:	00 
   500d9:	62 d2 fd 28 7c c8    	vpbroadcastq %r8,%ymm1
   500df:	c5 f5 eb 0d 79 a1 fb 	vpor   -0x45e87(%rip),%ymm1,%ymm1        # a260 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x168>
   500e6:	ff 
   500e7:	c4 e2 7d 59 25 18 a0 	vpbroadcastq -0x45fe8(%rip),%ymm4        # a108 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x10>
   500ee:	fb ff 
   500f0:	c4 e2 7d 59 2d cf 9f 	vpbroadcastq -0x46031(%rip),%ymm5        # a0c8 <anon.25805f450824d4a1248fcaae526abf58.283.llvm.3576388159787090369+0xcc>
   500f7:	fb ff 
   500f9:	c4 e2 7d 59 35 a6 9f 	vpbroadcastq -0x4605a(%rip),%ymm6        # a0a8 <anon.25805f450824d4a1248fcaae526abf58.283.llvm.3576388159787090369+0xac>
   50100:	fb ff 
   50102:	c4 e2 7d 59 3d 45 a0 	vpbroadcastq -0x45fbb(%rip),%ymm7        # a150 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x58>
   50109:	fb ff 
   5010b:	c4 62 7d 59 05 34 a0 	vpbroadcastq -0x45fcc(%rip),%ymm8        # a148 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x50>
   50112:	fb ff 
   50114:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
   5011b:	00 00 00 00 00 
   50120:	c5 fd d4 d1          	vpaddq %ymm1,%ymm0,%ymm2
   50124:	62 f2 ed 28 40 d4    	vpmullq %ymm4,%ymm2,%ymm2
   5012a:	c5 ed d4 d5          	vpaddq %ymm5,%ymm2,%ymm2
   5012e:	c5 e5 73 d2 1e       	vpsrlq $0x1e,%ymm2,%ymm3
   50133:	c5 e5 ef d2          	vpxor  %ymm2,%ymm3,%ymm2
   50137:	62 f2 ed 28 40 d6    	vpmullq %ymm6,%ymm2,%ymm2
   5013d:	c5 e5 73 d2 1b       	vpsrlq $0x1b,%ymm2,%ymm3
   50142:	c5 e5 ef d2          	vpxor  %ymm2,%ymm3,%ymm2
   50146:	62 f2 ed 28 40 d7    	vpmullq %ymm7,%ymm2,%ymm2
   5014c:	c5 e5 73 d2 1f       	vpsrlq $0x1f,%ymm2,%ymm3
   50151:	c5 e5 ef d2          	vpxor  %ymm2,%ymm3,%ymm2
   50155:	c4 a1 7e 7f 94 c4 e0 	vmovdqu %ymm2,0xe0(%rsp,%r8,8)
   5015c:	00 00 00 
   5015f:	49 83 c0 04          	add    $0x4,%r8
   50163:	c5 bd d4 c9          	vpaddq %ymm1,%ymm8,%ymm1
   50167:	4c 39 c2             	cmp    %r8,%rdx
   5016a:	75 b4                	jne    50120 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0x800>
   5016c:	48 39 ce             	cmp    %rcx,%rsi
   5016f:	49 b9 b9 e5 e4 1c 6d 	movabs $0xbf58476d1ce4e5b9,%r9
   50176:	47 58 bf 
   50179:	49 ba eb 11 31 13 bb 	movabs $0x94d049bb133111eb,%r10
   50180:	49 d0 94 
   50183:	74 60                	je     501e5 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0x8c5>
   50185:	89 c2                	mov    %eax,%edx
   50187:	48 8d 94 d4 e0 00 00 	lea    0xe0(%rsp,%rdx,8),%rdx
   5018e:	00 
   5018f:	4c 01 e1             	add    %r12,%rcx
   50192:	48 be eb 83 b5 80 46 	movabs $0x61c8864680b583eb,%rsi
   50199:	86 c8 61 
   5019c:	48 0f af ce          	imul   %rsi,%rcx
   501a0:	48 be e8 84 ed 04 42 	movabs $0xc276e44204ed84e8,%rsi
   501a7:	e4 76 c2 
   501aa:	48 29 ce             	sub    %rcx,%rsi
   501ad:	0f 1f 00             	nopl   (%rax)
   501b0:	48 89 f1             	mov    %rsi,%rcx
   501b3:	48 c1 e9 1e          	shr    $0x1e,%rcx
   501b7:	48 31 f1             	xor    %rsi,%rcx
   501ba:	49 0f af c9          	imul   %r9,%rcx
   501be:	49 89 c8             	mov    %rcx,%r8
   501c1:	49 c1 e8 1b          	shr    $0x1b,%r8
   501c5:	49 31 c8             	xor    %rcx,%r8
   501c8:	4d 0f af c2          	imul   %r10,%r8
   501cc:	4c 89 c1             	mov    %r8,%rcx
   501cf:	48 c1 e9 1f          	shr    $0x1f,%rcx
   501d3:	4c 31 c1             	xor    %r8,%rcx
   501d6:	48 89 0f             	mov    %rcx,(%rdi)
   501d9:	48 83 c7 08          	add    $0x8,%rdi
   501dd:	4c 01 fe             	add    %r15,%rsi
   501e0:	48 39 d7             	cmp    %rdx,%rdi
   501e3:	75 cb                	jne    501b0 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0x890>
   501e5:	48 8b bc 24 d8 00 00 	mov    0xd8(%rsp),%rdi
   501ec:	00 
   501ed:	48 8b 8c 24 80 00 00 	mov    0x80(%rsp),%rcx
   501f4:	00 
   501f5:	48 89 ce             	mov    %rcx,%rsi
   501f8:	31 d2                	xor    %edx,%edx
   501fa:	41 b8 01 00 00 00    	mov    $0x1,%r8d
   50200:	41 b9 01 00 00 00    	mov    $0x1,%r9d
   50206:	50                   	push   %rax
   50207:	48 8d 84 24 e8 00 00 	lea    0xe8(%rsp),%rax
   5020e:	00 
   5020f:	50                   	push   %rax
   50210:	c5 f8 77             	vzeroupper
   50213:	e8 78 3d fe ff       	call   33f90 <<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>::insert_into>
   50218:	48 83 c4 10          	add    $0x10,%rsp
   5021c:	48 81 c5 00 10 00 00 	add    $0x1000,%rbp
   50223:	49 ff cd             	dec    %r13
   50226:	49 ff c6             	inc    %r14
   50229:	48 81 c3 00 f0 ff ff 	add    $0xfffffffffffff000,%rbx
   50230:	49 81 c4 00 10 00 00 	add    $0x1000,%r12
   50237:	4d 85 ed             	test   %r13,%r13
   5023a:	0f 85 30 fc ff ff    	jne    4fe70 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0x550>
   50240:	eb 0d                	jmp    5024f <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0x92f>
   50242:	48 8d bc cc e0 00 00 	lea    0xe0(%rsp,%rcx,8),%rdi
   50249:	00 
   5024a:	e9 87 fc ff ff       	jmp    4fed6 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0x5b6>
   5024f:	48 8d bc 24 b8 00 00 	lea    0xb8(%rsp),%rdi
   50256:	00 
   50257:	ff 15 d3 44 05 00    	call   *0x544d3(%rip)        # a4730 <_DYNAMIC+0x830>
   5025d:	49 89 c6             	mov    %rax,%r14
   50260:	89 d5                	mov    %edx,%ebp
   50262:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
   50266:	c5 fe 7f 84 24 40 01 	vmovdqu %ymm0,0x140(%rsp)
   5026d:	00 00 
   5026f:	c5 fe 7f 84 24 20 01 	vmovdqu %ymm0,0x120(%rsp)
   50276:	00 00 
   50278:	c5 fe 7f 84 24 00 01 	vmovdqu %ymm0,0x100(%rsp)
   5027f:	00 00 
   50281:	48 8d 9c 24 a0 00 00 	lea    0xa0(%rsp),%rbx
   50288:	00 
   50289:	c5 fe 7f 84 24 e0 00 	vmovdqu %ymm0,0xe0(%rsp)
   50290:	00 00 
   50292:	4c 8b 84 24 c8 00 00 	mov    0xc8(%rsp),%r8
   50299:	00 
   5029a:	49 c1 e0 03          	shl    $0x3,%r8
   5029e:	31 c0                	xor    %eax,%eax
   502a0:	b9 01 00 00 00       	mov    $0x1,%ecx
   502a5:	48 8b 7c 24 60       	mov    0x60(%rsp),%rdi
   502aa:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
   502b0:	48 8b 14 07          	mov    (%rdi,%rax,1),%rdx
   502b4:	48 81 fa 00 04 00 00 	cmp    $0x400,%rdx
   502bb:	0f 83 16 02 00 00    	jae    504d7 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xbb7>
   502c1:	c4 e2 e9 f7 f1       	shlx   %rdx,%rcx,%rsi
   502c6:	48 c1 ea 06          	shr    $0x6,%rdx
   502ca:	48 09 b4 d4 e0 00 00 	or     %rsi,0xe0(%rsp,%rdx,8)
   502d1:	00 
   502d2:	48 83 c0 08          	add    $0x8,%rax
   502d6:	49 39 c0             	cmp    %rax,%r8
   502d9:	75 d5                	jne    502b0 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0x990>
   502db:	48 8d 94 24 e0 00 00 	lea    0xe0(%rsp),%rdx
   502e2:	00 
   502e3:	be 80 00 00 00       	mov    $0x80,%esi
   502e8:	31 ff                	xor    %edi,%edi
   502ea:	c5 f8 77             	vzeroupper
   502ed:	ff 15 2d 44 05 00    	call   *0x5442d(%rip)        # a4720 <sched_setaffinity@GLIBC_2.3.4>
   502f3:	89 44 24 48          	mov    %eax,0x48(%rsp)
   502f7:	85 c0                	test   %eax,%eax
   502f9:	0f 85 e1 02 00 00    	jne    505e0 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xcc0>
   502ff:	ff 15 23 44 05 00    	call   *0x54423(%rip)        # a4728 <_DYNAMIC+0x828>
   50305:	48 89 44 24 48       	mov    %rax,0x48(%rsp)
   5030a:	89 54 24 50          	mov    %edx,0x50(%rsp)
   5030e:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
   50313:	c5 fa 6f 40 08       	vmovdqu 0x8(%rax),%xmm0
   50318:	c5 fa 7f 84 24 e0 00 	vmovdqu %xmm0,0xe0(%rsp)
   5031f:	00 00 
   50321:	48 8d 84 24 e0 00 00 	lea    0xe0(%rsp),%rax
   50328:	00 
   50329:	48 8b b4 24 e0 00 00 	mov    0xe0(%rsp),%rsi
   50330:	00 
   50331:	48 8b 94 24 e8 00 00 	mov    0xe8(%rsp),%rdx
   50338:	00 
   50339:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
   5033e:	48 8b 48 30          	mov    0x30(%rax),%rcx
   50342:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
   50347:	ff 15 eb 41 05 00    	call   *0x541eb(%rip)        # a4538 <_DYNAMIC+0x638>
   5034d:	48 8d 7c 24 48       	lea    0x48(%rsp),%rdi
   50352:	ff 15 d8 43 05 00    	call   *0x543d8(%rip)        # a4730 <_DYNAMIC+0x830>
   50358:	49 89 c4             	mov    %rax,%r12
   5035b:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
   50360:	48 8b 00             	mov    (%rax),%rax
   50363:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
   50367:	c5 fe 7f 84 24 40 01 	vmovdqu %ymm0,0x140(%rsp)
   5036e:	00 00 
   50370:	c5 fe 7f 84 24 20 01 	vmovdqu %ymm0,0x120(%rsp)
   50377:	00 00 
   50379:	c5 fe 7f 84 24 00 01 	vmovdqu %ymm0,0x100(%rsp)
   50380:	00 00 
   50382:	c5 fe 7f 84 24 e0 00 	vmovdqu %ymm0,0xe0(%rsp)
   50389:	00 00 
   5038b:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
   50391:	0f 87 40 01 00 00    	ja     504d7 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xbb7>
   50397:	41 89 d5             	mov    %edx,%r13d
   5039a:	b9 01 00 00 00       	mov    $0x1,%ecx
   5039f:	c4 e2 f9 f7 c9       	shlx   %rax,%rcx,%rcx
   503a4:	48 c1 e8 06          	shr    $0x6,%rax
   503a8:	48 09 8c c4 e0 00 00 	or     %rcx,0xe0(%rsp,%rax,8)
   503af:	00 
   503b0:	48 8d 94 24 e0 00 00 	lea    0xe0(%rsp),%rdx
   503b7:	00 
   503b8:	be 80 00 00 00       	mov    $0x80,%esi
   503bd:	31 ff                	xor    %edi,%edi
   503bf:	c5 f8 77             	vzeroupper
   503c2:	ff 15 58 43 05 00    	call   *0x54358(%rip)        # a4720 <sched_setaffinity@GLIBC_2.3.4>
   503c8:	89 44 24 5c          	mov    %eax,0x5c(%rsp)
   503cc:	85 c0                	test   %eax,%eax
   503ce:	0f 85 34 02 00 00    	jne    50608 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xce8>
   503d4:	b8 00 ca 9a 3b       	mov    $0x3b9aca00,%eax
   503d9:	4c 89 e2             	mov    %r12,%rdx
   503dc:	c4 62 fb f6 f8       	mulx   %rax,%rax,%r15
   503e1:	44 89 eb             	mov    %r13d,%ebx
   503e4:	48 01 c3             	add    %rax,%rbx
   503e7:	49 83 d7 00          	adc    $0x0,%r15
   503eb:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
   503f0:	4c 8b 60 10          	mov    0x10(%rax),%r12
   503f4:	4c 3b 20             	cmp    (%rax),%r12
   503f7:	75 0a                	jne    50403 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xae3>
   503f9:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
   503fe:	e8 8d f3 00 00       	call   5f790 <<alloc::raw_vec::RawVec<u128>>::grow_one>
   50403:	4c 89 e0             	mov    %r12,%rax
   50406:	48 c1 e0 04          	shl    $0x4,%rax
   5040a:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
   5040f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
   50413:	4c 89 7c 01 08       	mov    %r15,0x8(%rcx,%rax,1)
   50418:	49 ff c4             	inc    %r12
   5041b:	48 89 1c 01          	mov    %rbx,(%rcx,%rax,1)
   5041f:	4c 89 62 10          	mov    %r12,0x10(%rdx)
   50423:	48 83 7c 24 40 00    	cmpq   $0x0,0x40(%rsp)
   50429:	74 27                	je     50452 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xb32>
   5042b:	b8 00 ca 9a 3b       	mov    $0x3b9aca00,%eax
   50430:	4c 89 f2             	mov    %r14,%rdx
   50433:	c4 62 fb f6 f0       	mulx   %rax,%rax,%r14
   50438:	89 eb                	mov    %ebp,%ebx
   5043a:	48 01 c3             	add    %rax,%rbx
   5043d:	49 83 d6 00          	adc    $0x0,%r14
   50441:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
   50446:	4c 8b 78 40          	mov    0x40(%rax),%r15
   5044a:	4c 3b 78 30          	cmp    0x30(%rax),%r15
   5044e:	74 16                	je     50466 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xb46>
   50450:	eb 22                	jmp    50474 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xb54>
   50452:	31 db                	xor    %ebx,%ebx
   50454:	45 31 f6             	xor    %r14d,%r14d
   50457:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
   5045c:	4c 8b 78 40          	mov    0x40(%rax),%r15
   50460:	4c 3b 78 30          	cmp    0x30(%rax),%r15
   50464:	75 0e                	jne    50474 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xb54>
   50466:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
   5046b:	48 8d 78 30          	lea    0x30(%rax),%rdi
   5046f:	e8 1c f3 00 00       	call   5f790 <<alloc::raw_vec::RawVec<u128>>::grow_one>
   50474:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
   50479:	48 8b 42 38          	mov    0x38(%rdx),%rax
   5047d:	4c 89 f9             	mov    %r15,%rcx
   50480:	48 c1 e1 04          	shl    $0x4,%rcx
   50484:	4c 89 74 08 08       	mov    %r14,0x8(%rax,%rcx,1)
   50489:	48 89 1c 08          	mov    %rbx,(%rax,%rcx,1)
   5048d:	49 ff c7             	inc    %r15
   50490:	4c 89 7a 40          	mov    %r15,0x40(%rdx)
   50494:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
   50499:	48 8b 74 24 38       	mov    0x38(%rsp),%rsi
   5049e:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
   504a3:	48 8b 4c 24 68       	mov    0x68(%rsp),%rcx
   504a8:	4c 8b 44 24 70       	mov    0x70(%rsp),%r8
   504ad:	e8 6e 51 00 00       	call   55620 <policy_confirmation::validate::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>>
   504b2:	48 83 7c 24 10 00    	cmpq   $0x0,0x10(%rsp)
   504b8:	74 0b                	je     504c5 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xba5>
   504ba:	48 8b 7c 24 18       	mov    0x18(%rsp),%rdi
   504bf:	ff 15 33 3c 05 00    	call   *0x53c33(%rip)        # a40f8 <free@GLIBC_2.2.5>
   504c5:	48 81 c4 e8 80 00 00 	add    $0x80e8,%rsp
   504cc:	5b                   	pop    %rbx
   504cd:	41 5c                	pop    %r12
   504cf:	41 5d                	pop    %r13
   504d1:	41 5e                	pop    %r14
   504d3:	41 5f                	pop    %r15
   504d5:	5d                   	pop    %rbp
   504d6:	c3                   	ret
   504d7:	48 8d 3d 77 c2 fb ff 	lea    -0x43d89(%rip),%rdi        # c755 <panic_unwind::imp::CANARY+0x5a9>
   504de:	48 8d 15 c3 1a 05 00 	lea    0x51ac3(%rip),%rdx        # a1fa8 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.1797.llvm.15448142832521594973+0xb80>
   504e5:	be 1c 00 00 00       	mov    $0x1c,%esi
   504ea:	c5 f8 77             	vzeroupper
   504ed:	ff 15 15 3e 05 00    	call   *0x53e15(%rip)        # a4308 <_DYNAMIC+0x408>
   504f3:	e9 b1 01 00 00       	jmp    506a9 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xd89>
   504f8:	48 8d 3d 56 c2 fb ff 	lea    -0x43daa(%rip),%rdi        # c755 <panic_unwind::imp::CANARY+0x5a9>
   504ff:	48 8d 15 a2 1a 05 00 	lea    0x51aa2(%rip),%rdx        # a1fa8 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.1797.llvm.15448142832521594973+0xb80>
   50506:	be 1c 00 00 00       	mov    $0x1c,%esi
   5050b:	c5 f8 77             	vzeroupper
   5050e:	ff 15 f4 3d 05 00    	call   *0x53df4(%rip)        # a4308 <_DYNAMIC+0x408>
   50514:	48 8d 05 a5 1a 05 00 	lea    0x51aa5(%rip),%rax        # a1fc0 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.1797.llvm.15448142832521594973+0xb98>
   5051b:	48 89 84 24 88 00 00 	mov    %rax,0x88(%rsp)
   50522:	00 
   50523:	48 c7 84 24 90 00 00 	movq   $0x1,0x90(%rsp)
   5052a:	00 01 00 00 00 
   5052f:	48 c7 84 24 98 00 00 	movq   $0x8,0x98(%rsp)
   50536:	00 08 00 00 00 
   5053b:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
   5053f:	c5 fa 7f 84 24 a0 00 	vmovdqu %xmm0,0xa0(%rsp)
   50546:	00 00 
   50548:	48 8d 15 79 9a fb ff 	lea    -0x46587(%rip),%rdx        # 9fc8 <anon.25805f450824d4a1248fcaae526abf58.318.llvm.3576388159787090369+0x6c>
   5054f:	4c 8d 05 7a 1a 05 00 	lea    0x51a7a(%rip),%r8        # a1fd0 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.1797.llvm.15448142832521594973+0xba8>
   50556:	48 8d 74 24 10       	lea    0x10(%rsp),%rsi
   5055b:	48 8d 8c 24 88 00 00 	lea    0x88(%rsp),%rcx
   50562:	00 
   50563:	31 ff                	xor    %edi,%edi
   50565:	ff 15 cd 41 05 00    	call   *0x541cd(%rip)        # a4738 <_DYNAMIC+0x838>
   5056b:	48 8d 3d e3 c1 fb ff 	lea    -0x43e1d(%rip),%rdi        # c755 <panic_unwind::imp::CANARY+0x5a9>
   50572:	48 8d 15 2f 1a 05 00 	lea    0x51a2f(%rip),%rdx        # a1fa8 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.1797.llvm.15448142832521594973+0xb80>
   50579:	be 1c 00 00 00       	mov    $0x1c,%esi
   5057e:	c5 f8 77             	vzeroupper
   50581:	ff 15 81 3d 05 00    	call   *0x53d81(%rip)        # a4308 <_DYNAMIC+0x408>
   50587:	48 8d 05 72 15 05 00 	lea    0x51572(%rip),%rax        # a1b00 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.1797.llvm.15448142832521594973+0x6d8>
   5058e:	48 89 84 24 e0 00 00 	mov    %rax,0xe0(%rsp)
   50595:	00 
   50596:	48 c7 84 24 e8 00 00 	movq   $0x1,0xe8(%rsp)
   5059d:	00 01 00 00 00 
   505a2:	48 c7 84 24 f0 00 00 	movq   $0x8,0xf0(%rsp)
   505a9:	00 08 00 00 00 
   505ae:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
   505b2:	c5 fa 7f 84 24 f8 00 	vmovdqu %xmm0,0xf8(%rsp)
   505b9:	00 00 
   505bb:	48 83 c3 38          	add    $0x38,%rbx
   505bf:	48 8d 15 32 9b fb ff 	lea    -0x464ce(%rip),%rdx        # a0f8 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973>
   505c6:	4c 8d 05 43 15 05 00 	lea    0x51543(%rip),%r8        # a1b10 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.1797.llvm.15448142832521594973+0x6e8>
   505cd:	48 8d 8c 24 e0 00 00 	lea    0xe0(%rsp),%rcx
   505d4:	00 
   505d5:	31 ff                	xor    %edi,%edi
   505d7:	48 89 de             	mov    %rbx,%rsi
   505da:	ff 15 50 3d 05 00    	call   *0x53d50(%rip)        # a4330 <_DYNAMIC+0x430>
   505e0:	48 8d 74 24 48       	lea    0x48(%rsp),%rsi
   505e5:	eb 26                	jmp    5060d <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xced>
   505e7:	48 8d 3d 67 c1 fb ff 	lea    -0x43e99(%rip),%rdi        # c755 <panic_unwind::imp::CANARY+0x5a9>
   505ee:	48 8d 15 b3 19 05 00 	lea    0x519b3(%rip),%rdx        # a1fa8 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.1797.llvm.15448142832521594973+0xb80>
   505f5:	be 1c 00 00 00       	mov    $0x1c,%esi
   505fa:	c5 f8 77             	vzeroupper
   505fd:	ff 15 05 3d 05 00    	call   *0x53d05(%rip)        # a4308 <_DYNAMIC+0x408>
   50603:	e9 a1 00 00 00       	jmp    506a9 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xd89>
   50608:	48 8d 74 24 5c       	lea    0x5c(%rsp),%rsi
   5060d:	48 8d 8c 24 88 00 00 	lea    0x88(%rsp),%rcx
   50614:	00 
   50615:	48 8d 05 a4 19 05 00 	lea    0x519a4(%rip),%rax        # a1fc0 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.1797.llvm.15448142832521594973+0xb98>
   5061c:	48 89 01             	mov    %rax,(%rcx)
   5061f:	48 c7 41 08 01 00 00 	movq   $0x1,0x8(%rcx)
   50626:	00 
   50627:	48 c7 41 10 08 00 00 	movq   $0x8,0x10(%rcx)
   5062e:	00 
   5062f:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
   50633:	c5 fa 7f 03          	vmovdqu %xmm0,(%rbx)
   50637:	48 8d 15 8a 99 fb ff 	lea    -0x46676(%rip),%rdx        # 9fc8 <anon.25805f450824d4a1248fcaae526abf58.318.llvm.3576388159787090369+0x6c>
   5063e:	4c 8d 05 8b 19 05 00 	lea    0x5198b(%rip),%r8        # a1fd0 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.1797.llvm.15448142832521594973+0xba8>
   50645:	31 ff                	xor    %edi,%edi
   50647:	ff 15 eb 40 05 00    	call   *0x540eb(%rip)        # a4738 <_DYNAMIC+0x838>
   5064d:	eb 5a                	jmp    506a9 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xd89>
   5064f:	48 8d 05 6a 19 05 00 	lea    0x5196a(%rip),%rax        # a1fc0 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.1797.llvm.15448142832521594973+0xb98>
   50656:	48 89 84 24 88 00 00 	mov    %rax,0x88(%rsp)
   5065d:	00 
   5065e:	48 c7 84 24 90 00 00 	movq   $0x1,0x90(%rsp)
   50665:	00 01 00 00 00 
   5066a:	48 c7 84 24 98 00 00 	movq   $0x8,0x98(%rsp)
   50671:	00 08 00 00 00 
   50676:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
   5067a:	c5 fa 7f 84 24 a0 00 	vmovdqu %xmm0,0xa0(%rsp)
   50681:	00 00 
   50683:	48 8d 15 3e 99 fb ff 	lea    -0x466c2(%rip),%rdx        # 9fc8 <anon.25805f450824d4a1248fcaae526abf58.318.llvm.3576388159787090369+0x6c>
   5068a:	4c 8d 05 3f 19 05 00 	lea    0x5193f(%rip),%r8        # a1fd0 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.1797.llvm.15448142832521594973+0xba8>
   50691:	48 8d b4 24 b8 00 00 	lea    0xb8(%rsp),%rsi
   50698:	00 
   50699:	48 8d 8c 24 88 00 00 	lea    0x88(%rsp),%rcx
   506a0:	00 
   506a1:	31 ff                	xor    %edi,%edi
   506a3:	ff 15 8f 40 05 00    	call   *0x5408f(%rip)        # a4738 <_DYNAMIC+0x838>
   506a9:	0f 0b                	ud2
   506ab:	48 8d 15 36 14 05 00 	lea    0x51436(%rip),%rdx        # a1ae8 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.1797.llvm.15448142832521594973+0x6c0>
   506b2:	31 ff                	xor    %edi,%edi
   506b4:	31 f6                	xor    %esi,%esi
   506b6:	ff 15 94 3a 05 00    	call   *0x53a94(%rip)        # a4150 <_DYNAMIC+0x250>
   506bc:	31 c0                	xor    %eax,%eax
   506be:	eb 02                	jmp    506c2 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xda2>
   506c0:	b0 01                	mov    $0x1,%al
   506c2:	88 84 24 e0 00 00 00 	mov    %al,0xe0(%rsp)
   506c9:	48 8d 3d b4 c0 fb ff 	lea    -0x43f4c(%rip),%rdi        # c784 <panic_unwind::imp::CANARY+0x5d8>
   506d0:	48 8d 0d 89 19 05 00 	lea    0x51989(%rip),%rcx        # a2060 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.1797.llvm.15448142832521594973+0xc38>
   506d7:	4c 8d 05 22 1a 05 00 	lea    0x51a22(%rip),%r8        # a2100 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.1797.llvm.15448142832521594973+0xcd8>
   506de:	48 8d 94 24 e0 00 00 	lea    0xe0(%rsp),%rdx
   506e5:	00 
   506e6:	be 2b 00 00 00       	mov    $0x2b,%esi
   506eb:	ff 15 a7 3a 05 00    	call   *0x53aa7(%rip)        # a4198 <_DYNAMIC+0x298>
   506f1:	bf 40 00 00 00       	mov    $0x40,%edi
   506f6:	4c 89 fe             	mov    %r15,%rsi
   506f9:	ff 15 41 3a 05 00    	call   *0x53a41(%rip)        # a4140 <_DYNAMIC+0x240>
   506ff:	bf 40 00 00 00       	mov    $0x40,%edi
   50704:	4c 89 f6             	mov    %r14,%rsi
   50707:	ff 15 33 3a 05 00    	call   *0x53a33(%rip)        # a4140 <_DYNAMIC+0x240>
   5070d:	48 89 c3             	mov    %rax,%rbx
   50710:	48 8b 84 24 80 00 00 	mov    0x80(%rsp),%rax
   50717:	00 
   50718:	eb 2c                	jmp    50746 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xe26>
   5071a:	48 89 c3             	mov    %rax,%rbx
   5071d:	48 83 7c 24 10 00    	cmpq   $0x0,0x10(%rsp)
   50723:	74 26                	je     5074b <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xe2b>
   50725:	48 8b 84 24 d0 00 00 	mov    0xd0(%rsp),%rax
   5072c:	00 
   5072d:	48 8b 38             	mov    (%rax),%rdi
   50730:	ff 15 c2 39 05 00    	call   *0x539c2(%rip)        # a40f8 <free@GLIBC_2.2.5>
   50736:	48 89 df             	mov    %rbx,%rdi
   50739:	e8 d2 dd 04 00       	call   9e510 <_Unwind_Resume@plt>
   5073e:	48 89 c3             	mov    %rax,%rbx
   50741:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
   50746:	48 85 c0             	test   %rax,%rax
   50749:	75 da                	jne    50725 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xe05>
   5074b:	48 89 df             	mov    %rbx,%rdi
   5074e:	e8 bd dd 04 00       	call   9e510 <_Unwind_Resume@plt>
   50753:	cc                   	int3
   50754:	cc                   	int3
   50755:	cc                   	int3
   50756:	cc                   	int3
   50757:	cc                   	int3
   50758:	cc                   	int3
   50759:	cc                   	int3
   5075a:	cc                   	int3
   5075b:	cc                   	int3
   5075c:	cc                   	int3
   5075d:	cc                   	int3
   5075e:	cc                   	int3
   5075f:	cc                   	int3

