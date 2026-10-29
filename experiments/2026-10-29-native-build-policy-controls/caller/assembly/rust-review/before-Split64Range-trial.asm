000000000004dc00 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>>:
   4dc00:	55                   	push   %rbp
   4dc01:	41 57                	push   %r15
   4dc03:	41 56                	push   %r14
   4dc05:	41 55                	push   %r13
   4dc07:	41 54                	push   %r12
   4dc09:	53                   	push   %rbx
   4dc0a:	49 89 e3             	mov    %rsp,%r11
   4dc0d:	49 81 eb 00 80 00 00 	sub    $0x8000,%r11
   4dc14:	48 81 ec 00 10 00 00 	sub    $0x1000,%rsp
   4dc1b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
   4dc22:	00 
   4dc23:	4c 39 dc             	cmp    %r11,%rsp
   4dc26:	75 ec                	jne    4dc14 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0x14>
   4dc28:	48 81 ec e8 00 00 00 	sub    $0xe8,%rsp
   4dc2f:	4c 89 4c 24 08       	mov    %r9,0x8(%rsp)
   4dc34:	48 89 74 24 30       	mov    %rsi,0x30(%rsp)
   4dc39:	4c 8b 77 10          	mov    0x10(%rdi),%r14
   4dc3d:	4d 85 f6             	test   %r14,%r14
   4dc40:	0f 84 45 0d 00 00    	je     4e98b <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xd8b>
   4dc46:	48 89 fb             	mov    %rdi,%rbx
   4dc49:	4c 8b 6f 08          	mov    0x8(%rdi),%r13
   4dc4d:	49 8b 45 00          	mov    0x0(%r13),%rax
   4dc51:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
   4dc55:	c5 fe 7f 84 24 40 01 	vmovdqu %ymm0,0x140(%rsp)
   4dc5c:	00 00 
   4dc5e:	c5 fe 7f 84 24 20 01 	vmovdqu %ymm0,0x120(%rsp)
   4dc65:	00 00 
   4dc67:	c5 fe 7f 84 24 00 01 	vmovdqu %ymm0,0x100(%rsp)
   4dc6e:	00 00 
   4dc70:	c5 fe 7f 84 24 e0 00 	vmovdqu %ymm0,0xe0(%rsp)
   4dc77:	00 00 
   4dc79:	48 3d 00 04 00 00    	cmp    $0x400,%rax
   4dc7f:	0f 83 c6 0b 00 00    	jae    4e84b <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xc4b>
   4dc85:	44 89 c5             	mov    %r8d,%ebp
   4dc88:	48 89 54 24 68       	mov    %rdx,0x68(%rsp)
   4dc8d:	48 89 4c 24 70       	mov    %rcx,0x70(%rsp)
   4dc92:	b9 01 00 00 00       	mov    $0x1,%ecx
   4dc97:	c4 e2 f9 f7 c9       	shlx   %rax,%rcx,%rcx
   4dc9c:	48 c1 e8 06          	shr    $0x6,%rax
   4dca0:	48 09 8c c4 e0 00 00 	or     %rcx,0xe0(%rsp,%rax,8)
   4dca7:	00 
   4dca8:	48 8d 94 24 e0 00 00 	lea    0xe0(%rsp),%rdx
   4dcaf:	00 
   4dcb0:	be 80 00 00 00       	mov    $0x80,%esi
   4dcb5:	31 ff                	xor    %edi,%edi
   4dcb7:	c5 f8 77             	vzeroupper
   4dcba:	ff 15 60 6a 05 00    	call   *0x56a60(%rip)        # a4720 <sched_setaffinity@GLIBC_2.3.4>
   4dcc0:	89 44 24 10          	mov    %eax,0x10(%rsp)
   4dcc4:	85 c0                	test   %eax,%eax
   4dcc6:	0f 85 28 0b 00 00    	jne    4e7f4 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xbf4>
   4dccc:	48 8d 44 24 18       	lea    0x18(%rsp),%rax
   4dcd1:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
   4dcd8:	00 
   4dcd9:	40 84 ed             	test   %bpl,%bpl
   4dcdc:	0f 84 ea 02 00 00    	je     4dfcc <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0x3cc>
   4dce2:	48 83 7b 38 00       	cmpq   $0x0,0x38(%rbx)
   4dce7:	0f 85 7a 0b 00 00    	jne    4e867 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xc67>
   4dced:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
   4dcf1:	c5 fe 7f 84 24 40 01 	vmovdqu %ymm0,0x140(%rsp)
   4dcf8:	00 00 
   4dcfa:	c5 fe 7f 84 24 20 01 	vmovdqu %ymm0,0x120(%rsp)
   4dd01:	00 00 
   4dd03:	c5 fe 7f 84 24 00 01 	vmovdqu %ymm0,0x100(%rsp)
   4dd0a:	00 00 
   4dd0c:	c5 fe 7f 84 24 e0 00 	vmovdqu %ymm0,0xe0(%rsp)
   4dd13:	00 00 
   4dd15:	49 c1 e6 03          	shl    $0x3,%r14
   4dd19:	31 c0                	xor    %eax,%eax
   4dd1b:	b9 01 00 00 00       	mov    $0x1,%ecx
   4dd20:	49 8b 54 05 00       	mov    0x0(%r13,%rax,1),%rdx
   4dd25:	48 81 fa 00 04 00 00 	cmp    $0x400,%rdx
   4dd2c:	0f 83 a6 0a 00 00    	jae    4e7d8 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xbd8>
   4dd32:	c4 e2 e9 f7 f1       	shlx   %rdx,%rcx,%rsi
   4dd37:	48 c1 ea 06          	shr    $0x6,%rdx
   4dd3b:	48 09 b4 d4 e0 00 00 	or     %rsi,0xe0(%rsp,%rdx,8)
   4dd42:	00 
   4dd43:	48 83 c0 08          	add    $0x8,%rax
   4dd47:	49 39 c6             	cmp    %rax,%r14
   4dd4a:	75 d4                	jne    4dd20 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0x120>
   4dd4c:	48 8d 94 24 e0 00 00 	lea    0xe0(%rsp),%rdx
   4dd53:	00 
   4dd54:	be 80 00 00 00       	mov    $0x80,%esi
   4dd59:	31 ff                	xor    %edi,%edi
   4dd5b:	c5 f8 77             	vzeroupper
   4dd5e:	ff 15 bc 69 05 00    	call   *0x569bc(%rip)        # a4720 <sched_setaffinity@GLIBC_2.3.4>
   4dd64:	89 44 24 10          	mov    %eax,0x10(%rsp)
   4dd68:	85 c0                	test   %eax,%eax
   4dd6a:	0f 85 84 0a 00 00    	jne    4e7f4 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xbf4>
   4dd70:	ff 15 b2 69 05 00    	call   *0x569b2(%rip)        # a4728 <_DYNAMIC+0x828>
   4dd76:	48 89 44 24 48       	mov    %rax,0x48(%rsp)
   4dd7b:	89 54 24 50          	mov    %edx,0x50(%rsp)
   4dd7f:	49 89 dc             	mov    %rbx,%r12
   4dd82:	48 8b 5b 20          	mov    0x20(%rbx),%rbx
   4dd86:	48 81 fb 80 00 00 00 	cmp    $0x80,%rbx
   4dd8d:	0f 82 09 0c 00 00    	jb     4e99c <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xd9c>
   4dd93:	48 81 fb 00 00 00 10 	cmp    $0x10000000,%rbx
   4dd9a:	0f 87 00 0c 00 00    	ja     4e9a0 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xda0>
   4dda0:	41 89 de             	mov    %ebx,%r14d
   4dda3:	41 81 e6 c0 ff ff 1f 	and    $0x1fffffc0,%r14d
   4ddaa:	48 c7 84 24 e0 00 00 	movq   $0x0,0xe0(%rsp)
   4ddb1:	00 00 00 00 00 
   4ddb6:	48 8d bc 24 e0 00 00 	lea    0xe0(%rsp),%rdi
   4ddbd:	00 
   4ddbe:	be 40 00 00 00       	mov    $0x40,%esi
   4ddc3:	4c 89 f2             	mov    %r14,%rdx
   4ddc6:	ff 15 24 63 05 00    	call   *0x56324(%rip)        # a40f0 <posix_memalign@GLIBC_2.2.5>
   4ddcc:	85 c0                	test   %eax,%eax
   4ddce:	0f 85 0b 0c 00 00    	jne    4e9df <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xddf>
   4ddd4:	4c 8b bc 24 e0 00 00 	mov    0xe0(%rsp),%r15
   4dddb:	00 
   4dddc:	4d 85 ff             	test   %r15,%r15
   4dddf:	0f 84 fa 0b 00 00    	je     4e9df <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xddf>
   4dde5:	48 c1 eb 06          	shr    $0x6,%rbx
   4dde9:	49 8d 56 c0          	lea    -0x40(%r14),%rdx
   4dded:	4c 89 ff             	mov    %r15,%rdi
   4ddf0:	31 f6                	xor    %esi,%esi
   4ddf2:	ff 15 20 63 05 00    	call   *0x56320(%rip)        # a4118 <memset@GLIBC_2.2.5>
   4ddf8:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
   4ddfc:	c4 81 7d 7f 44 37 c0 	vmovdqa %ymm0,-0x40(%r15,%r14,1)
   4de03:	c4 81 7d 7f 44 37 e0 	vmovdqa %ymm0,-0x20(%r15,%r14,1)
   4de0a:	48 89 5c 24 10       	mov    %rbx,0x10(%rsp)
   4de0f:	4c 89 7c 24 18       	mov    %r15,0x18(%rsp)
   4de14:	48 89 5c 24 20       	mov    %rbx,0x20(%rsp)
   4de19:	89 5c 24 28          	mov    %ebx,0x28(%rsp)
   4de1d:	66 c7 44 24 2c 01 01 	movw   $0x101,0x2c(%rsp)
   4de24:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
   4de29:	c5 fa 6f 40 08       	vmovdqu 0x8(%rax),%xmm0
   4de2e:	c5 fa 7f 84 24 e0 00 	vmovdqu %xmm0,0xe0(%rsp)
   4de35:	00 00 
   4de37:	48 8d 84 24 e0 00 00 	lea    0xe0(%rsp),%rax
   4de3e:	00 
   4de3f:	48 8b b4 24 e0 00 00 	mov    0xe0(%rsp),%rsi
   4de46:	00 
   4de47:	48 8b 94 24 e8 00 00 	mov    0xe8(%rsp),%rdx
   4de4e:	00 
   4de4f:	49 8b 4c 24 30       	mov    0x30(%r12),%rcx
   4de54:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
   4de59:	c5 f8 77             	vzeroupper
   4de5c:	ff 15 76 67 05 00    	call   *0x56776(%rip)        # a45d8 <_DYNAMIC+0x6d8>
   4de62:	48 8d 7c 24 48       	lea    0x48(%rsp),%rdi
   4de67:	ff 15 c3 68 05 00    	call   *0x568c3(%rip)        # a4730 <_DYNAMIC+0x830>
   4de6d:	49 89 c6             	mov    %rax,%r14
   4de70:	49 8b 45 00          	mov    0x0(%r13),%rax
   4de74:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
   4de78:	c5 fe 7f 84 24 40 01 	vmovdqu %ymm0,0x140(%rsp)
   4de7f:	00 00 
   4de81:	c5 fe 7f 84 24 20 01 	vmovdqu %ymm0,0x120(%rsp)
   4de88:	00 00 
   4de8a:	c5 fe 7f 84 24 00 01 	vmovdqu %ymm0,0x100(%rsp)
   4de91:	00 00 
   4de93:	c5 fe 7f 84 24 e0 00 	vmovdqu %ymm0,0xe0(%rsp)
   4de9a:	00 00 
   4de9c:	48 3d 00 04 00 00    	cmp    $0x400,%rax
   4dea2:	0f 83 1f 0a 00 00    	jae    4e8c7 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xcc7>
   4dea8:	89 d5                	mov    %edx,%ebp
   4deaa:	b9 01 00 00 00       	mov    $0x1,%ecx
   4deaf:	c4 e2 f9 f7 c9       	shlx   %rax,%rcx,%rcx
   4deb4:	48 c1 e8 06          	shr    $0x6,%rax
   4deb8:	48 09 8c c4 e0 00 00 	or     %rcx,0xe0(%rsp,%rax,8)
   4debf:	00 
   4dec0:	48 8d 94 24 e0 00 00 	lea    0xe0(%rsp),%rdx
   4dec7:	00 
   4dec8:	be 80 00 00 00       	mov    $0x80,%esi
   4decd:	31 ff                	xor    %edi,%edi
   4decf:	c5 f8 77             	vzeroupper
   4ded2:	ff 15 48 68 05 00    	call   *0x56848(%rip)        # a4720 <sched_setaffinity@GLIBC_2.3.4>
   4ded8:	89 84 24 b8 00 00 00 	mov    %eax,0xb8(%rsp)
   4dedf:	85 c0                	test   %eax,%eax
   4dee1:	0f 85 48 0a 00 00    	jne    4e92f <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xd2f>
   4dee7:	b8 00 ca 9a 3b       	mov    $0x3b9aca00,%eax
   4deec:	4c 89 f2             	mov    %r14,%rdx
   4deef:	c4 62 fb f6 f0       	mulx   %rax,%rax,%r14
   4def4:	89 eb                	mov    %ebp,%ebx
   4def6:	48 01 c3             	add    %rax,%rbx
   4def9:	49 83 d6 00          	adc    $0x0,%r14
   4defd:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
   4df02:	4c 8b 78 28          	mov    0x28(%rax),%r15
   4df06:	4c 3b 78 18          	cmp    0x18(%rax),%r15
   4df0a:	75 0e                	jne    4df1a <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0x31a>
   4df0c:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
   4df11:	48 8d 78 18          	lea    0x18(%rax),%rdi
   4df15:	e8 76 18 01 00       	call   5f790 <<alloc::raw_vec::RawVec<u128>>::grow_one>
   4df1a:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
   4df1f:	48 8b 42 20          	mov    0x20(%rdx),%rax
   4df23:	4c 89 f9             	mov    %r15,%rcx
   4df26:	48 c1 e1 04          	shl    $0x4,%rcx
   4df2a:	4c 89 74 08 08       	mov    %r14,0x8(%rax,%rcx,1)
   4df2f:	48 89 1c 08          	mov    %rbx,(%rax,%rcx,1)
   4df33:	49 ff c7             	inc    %r15
   4df36:	4c 89 7a 28          	mov    %r15,0x28(%rdx)
   4df3a:	48 8b 5a 58          	mov    0x58(%rdx),%rbx
   4df3e:	48 3b 5a 48          	cmp    0x48(%rdx),%rbx
   4df42:	75 0e                	jne    4df52 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0x352>
   4df44:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
   4df49:	48 8d 78 48          	lea    0x48(%rax),%rdi
   4df4d:	e8 3e 18 01 00       	call   5f790 <<alloc::raw_vec::RawVec<u128>>::grow_one>
   4df52:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
   4df57:	48 8b 42 50          	mov    0x50(%rdx),%rax
   4df5b:	48 89 d9             	mov    %rbx,%rcx
   4df5e:	48 c1 e1 04          	shl    $0x4,%rcx
   4df62:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
   4df66:	c5 f9 7f 04 08       	vmovdqa %xmm0,(%rax,%rcx,1)
   4df6b:	48 ff c3             	inc    %rbx
   4df6e:	48 89 5a 58          	mov    %rbx,0x58(%rdx)
   4df72:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
   4df77:	48 8b 54 24 20       	mov    0x20(%rsp),%rdx
   4df7c:	48 8d bc 24 e0 00 00 	lea    0xe0(%rsp),%rdi
   4df83:	00 
   4df84:	4c 89 e1             	mov    %r12,%rcx
   4df87:	e8 44 3a 00 00       	call   519d0 <policy_confirmation::observe::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>>
   4df8c:	48 8b 84 24 f0 00 00 	mov    0xf0(%rsp),%rax
   4df93:	00 
   4df94:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
   4df99:	48 89 41 70          	mov    %rax,0x70(%rcx)
   4df9d:	c5 fa 6f 84 24 e0 00 	vmovdqu 0xe0(%rsp),%xmm0
   4dfa4:	00 00 
   4dfa6:	c5 fa 7f 41 60       	vmovdqu %xmm0,0x60(%rcx)
   4dfab:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
   4dfb0:	4c 89 e6             	mov    %r12,%rsi
   4dfb3:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
   4dfb8:	48 8b 4c 24 68       	mov    0x68(%rsp),%rcx
   4dfbd:	4c 8b 44 24 70       	mov    0x70(%rsp),%r8
   4dfc2:	e8 d9 5b 00 00       	call   53ba0 <policy_confirmation::validate::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>>
   4dfc7:	e9 c6 07 00 00       	jmp    4e792 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xb92>
   4dfcc:	4c 8b 63 20          	mov    0x20(%rbx),%r12
   4dfd0:	49 81 fc 80 00 00 00 	cmp    $0x80,%r12
   4dfd7:	0f 82 bf 09 00 00    	jb     4e99c <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xd9c>
   4dfdd:	49 81 fc 00 00 00 10 	cmp    $0x10000000,%r12
   4dfe4:	0f 87 b6 09 00 00    	ja     4e9a0 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xda0>
   4dfea:	4c 89 6c 24 60       	mov    %r13,0x60(%rsp)
   4dfef:	45 89 e7             	mov    %r12d,%r15d
   4dff2:	41 81 e7 c0 ff ff 1f 	and    $0x1fffffc0,%r15d
   4dff9:	48 c7 84 24 e0 00 00 	movq   $0x0,0xe0(%rsp)
   4e000:	00 00 00 00 00 
   4e005:	48 8d bc 24 e0 00 00 	lea    0xe0(%rsp),%rdi
   4e00c:	00 
   4e00d:	be 40 00 00 00       	mov    $0x40,%esi
   4e012:	4c 89 fa             	mov    %r15,%rdx
   4e015:	ff 15 d5 60 05 00    	call   *0x560d5(%rip)        # a40f0 <posix_memalign@GLIBC_2.2.5>
   4e01b:	85 c0                	test   %eax,%eax
   4e01d:	0f 85 ae 09 00 00    	jne    4e9d1 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xdd1>
   4e023:	4c 8b ac 24 e0 00 00 	mov    0xe0(%rsp),%r13
   4e02a:	00 
   4e02b:	4d 85 ed             	test   %r13,%r13
   4e02e:	0f 84 9d 09 00 00    	je     4e9d1 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xdd1>
   4e034:	4c 89 b4 24 c8 00 00 	mov    %r14,0xc8(%rsp)
   4e03b:	00 
   4e03c:	49 c1 ec 06          	shr    $0x6,%r12
   4e040:	49 8d 57 c0          	lea    -0x40(%r15),%rdx
   4e044:	4c 89 ef             	mov    %r13,%rdi
   4e047:	31 f6                	xor    %esi,%esi
   4e049:	ff 15 c9 60 05 00    	call   *0x560c9(%rip)        # a4118 <memset@GLIBC_2.2.5>
   4e04f:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
   4e053:	c4 81 7d 7f 44 3d c0 	vmovdqa %ymm0,-0x40(%r13,%r15,1)
   4e05a:	c4 81 7d 7f 44 3d e0 	vmovdqa %ymm0,-0x20(%r13,%r15,1)
   4e061:	4c 89 64 24 10       	mov    %r12,0x10(%rsp)
   4e066:	4c 89 ac 24 d8 00 00 	mov    %r13,0xd8(%rsp)
   4e06d:	00 
   4e06e:	4c 89 6c 24 18       	mov    %r13,0x18(%rsp)
   4e073:	4c 89 64 24 20       	mov    %r12,0x20(%rsp)
   4e078:	44 89 64 24 28       	mov    %r12d,0x28(%rsp)
   4e07d:	66 c7 44 24 2c 01 01 	movw   $0x101,0x2c(%rsp)
   4e084:	48 8d bc 24 e0 00 00 	lea    0xe0(%rsp),%rdi
   4e08b:	00 
   4e08c:	4c 89 e6             	mov    %r12,%rsi
   4e08f:	4c 89 a4 24 80 00 00 	mov    %r12,0x80(%rsp)
   4e096:	00 
   4e097:	4c 89 e2             	mov    %r12,%rdx
   4e09a:	48 89 5c 24 38       	mov    %rbx,0x38(%rsp)
   4e09f:	48 89 d9             	mov    %rbx,%rcx
   4e0a2:	c5 f8 77             	vzeroupper
   4e0a5:	e8 26 39 00 00       	call   519d0 <policy_confirmation::observe::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>>
   4e0aa:	48 8b 84 24 f0 00 00 	mov    0xf0(%rsp),%rax
   4e0b1:	00 
   4e0b2:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
   4e0b7:	48 89 41 70          	mov    %rax,0x70(%rcx)
   4e0bb:	c5 fa 6f 84 24 e0 00 	vmovdqu 0xe0(%rsp),%xmm0
   4e0c2:	00 00 
   4e0c4:	c5 fa 7f 41 60       	vmovdqu %xmm0,0x60(%rcx)
   4e0c9:	ff 15 59 66 05 00    	call   *0x56659(%rip)        # a4728 <_DYNAMIC+0x828>
   4e0cf:	48 89 84 24 b8 00 00 	mov    %rax,0xb8(%rsp)
   4e0d6:	00 
   4e0d7:	89 94 24 c0 00 00 00 	mov    %edx,0xc0(%rsp)
   4e0de:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
   4e0e3:	48 8b 58 38          	mov    0x38(%rax),%rbx
   4e0e7:	48 8b 40 48          	mov    0x48(%rax),%rax
   4e0eb:	48 89 44 24 78       	mov    %rax,0x78(%rsp)
   4e0f0:	48 8d bc 24 e0 00 00 	lea    0xe0(%rsp),%rdi
   4e0f7:	00 
   4e0f8:	ba 00 80 00 00       	mov    $0x8000,%edx
   4e0fd:	31 f6                	xor    %esi,%esi
   4e0ff:	ff 15 13 60 05 00    	call   *0x56013(%rip)        # a4118 <memset@GLIBC_2.2.5>
   4e105:	48 89 5c 24 40       	mov    %rbx,0x40(%rsp)
   4e10a:	48 85 db             	test   %rbx,%rbx
   4e10d:	0f 84 1c 04 00 00    	je     4e52f <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0x92f>
   4e113:	48 8b 5c 24 40       	mov    0x40(%rsp),%rbx
   4e118:	49 89 dd             	mov    %rbx,%r13
   4e11b:	49 c1 ed 0c          	shr    $0xc,%r13
   4e11f:	89 d8                	mov    %ebx,%eax
   4e121:	25 ff 0f 00 00       	and    $0xfff,%eax
   4e126:	48 83 f8 01          	cmp    $0x1,%rax
   4e12a:	49 83 dd ff          	sbb    $0xffffffffffffffff,%r13
   4e12e:	45 31 f6             	xor    %r14d,%r14d
   4e131:	49 bf 15 7c 4a 7f b9 	movabs $0x9e3779b97f4a7c15,%r15
   4e138:	79 37 9e 
   4e13b:	4c 8b 64 24 78       	mov    0x78(%rsp),%r12
   4e140:	31 ed                	xor    %ebp,%ebp
   4e142:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   4e149:	1f 84 00 00 00 00 00 
   4e150:	48 81 fb 00 10 00 00 	cmp    $0x1000,%rbx
   4e157:	b9 00 10 00 00       	mov    $0x1000,%ecx
   4e15c:	48 0f 42 cb          	cmovb  %rbx,%rcx
   4e160:	4c 89 f0             	mov    %r14,%rax
   4e163:	48 c1 e0 0c          	shl    $0xc,%rax
   4e167:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
   4e16c:	48 89 f2             	mov    %rsi,%rdx
   4e16f:	48 29 c2             	sub    %rax,%rdx
   4e172:	48 81 fa 00 10 00 00 	cmp    $0x1000,%rdx
   4e179:	bf 00 10 00 00       	mov    $0x1000,%edi
   4e17e:	48 0f 43 d7          	cmovae %rdi,%rdx
   4e182:	48 89 f0             	mov    %rsi,%rax
   4e185:	48 29 e8             	sub    %rbp,%rax
   4e188:	48 3d 00 10 00 00    	cmp    $0x1000,%rax
   4e18e:	48 0f 43 c7          	cmovae %rdi,%rax
   4e192:	48 39 ee             	cmp    %rbp,%rsi
   4e195:	0f 84 2a 03 00 00    	je     4e4c5 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0x8c5>
   4e19b:	48 ff ca             	dec    %rdx
   4e19e:	40 b6 3d             	mov    $0x3d,%sil
   4e1a1:	c4 e2 c8 f5 fa       	bzhi   %rsi,%rdx,%rdi
   4e1a6:	48 83 ff 03          	cmp    $0x3,%rdi
   4e1aa:	73 24                	jae    4e1d0 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0x5d0>
   4e1ac:	31 c9                	xor    %ecx,%ecx
   4e1ae:	48 8d bc 24 e0 00 00 	lea    0xe0(%rsp),%rdi
   4e1b5:	00 
   4e1b6:	49 b9 b9 e5 e4 1c 6d 	movabs $0xbf58476d1ce4e5b9,%r9
   4e1bd:	47 58 bf 
   4e1c0:	49 ba eb 11 31 13 bb 	movabs $0x94d049bb133111eb,%r10
   4e1c7:	49 d0 94 
   4e1ca:	e9 96 02 00 00       	jmp    4e465 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0x865>
   4e1cf:	90                   	nop
   4e1d0:	48 ff c9             	dec    %rcx
   4e1d3:	c4 e2 c8 f5 d1       	bzhi   %rsi,%rcx,%rdx
   4e1d8:	48 ff c2             	inc    %rdx
   4e1db:	48 8d 77 01          	lea    0x1(%rdi),%rsi
   4e1df:	48 8b 4c 24 78       	mov    0x78(%rsp),%rcx
   4e1e4:	48 01 e9             	add    %rbp,%rcx
   4e1e7:	62 f2 fd 28 7c c1    	vpbroadcastq %rcx,%ymm0
   4e1ed:	48 83 ff 0f          	cmp    $0xf,%rdi
   4e1f1:	73 07                	jae    4e1fa <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0x5fa>
   4e1f3:	31 c9                	xor    %ecx,%ecx
   4e1f5:	e9 9f 01 00 00       	jmp    4e399 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0x799>
   4e1fa:	48 89 d7             	mov    %rdx,%rdi
   4e1fd:	48 83 e7 f0          	and    $0xfffffffffffffff0,%rdi
   4e201:	48 89 f1             	mov    %rsi,%rcx
   4e204:	49 b8 f0 ff ff ff ff 	movabs $0x3ffffffffffffff0,%r8
   4e20b:	ff ff 3f 
   4e20e:	4c 21 c1             	and    %r8,%rcx
   4e211:	62 f1 fd 38 d4 0d 2d 	vpaddq -0x440d3(%rip){1to4},%ymm0,%ymm1        # a148 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x50>
   4e218:	bf fb ff 
   4e21b:	62 f1 fd 38 d4 15 5b 	vpaddq -0x441a5(%rip){1to4},%ymm0,%ymm2        # a080 <anon.25805f450824d4a1248fcaae526abf58.283.llvm.3576388159787090369+0x84>
   4e222:	be fb ff 
   4e225:	62 f1 fd 38 d4 1d 59 	vpaddq -0x441a7(%rip){1to4},%ymm0,%ymm3        # a088 <anon.25805f450824d4a1248fcaae526abf58.283.llvm.3576388159787090369+0x8c>
   4e22c:	be fb ff 
   4e22f:	45 31 c0             	xor    %r8d,%r8d
   4e232:	c5 fd 6f 25 26 c0 fb 	vmovdqa -0x43fda(%rip),%ymm4        # a260 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x168>
   4e239:	ff 
   4e23a:	c4 62 7d 59 2d c5 be 	vpbroadcastq -0x4413b(%rip),%ymm13        # a108 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x10>
   4e241:	fb ff 
   4e243:	c4 62 7d 59 35 7c be 	vpbroadcastq -0x44184(%rip),%ymm14        # a0c8 <anon.25805f450824d4a1248fcaae526abf58.283.llvm.3576388159787090369+0xcc>
   4e24a:	fb ff 
   4e24c:	c4 62 7d 59 3d 53 be 	vpbroadcastq -0x441ad(%rip),%ymm15        # a0a8 <anon.25805f450824d4a1248fcaae526abf58.283.llvm.3576388159787090369+0xac>
   4e253:	fb ff 
   4e255:	62 e2 fd 28 59 05 f1 	vpbroadcastq -0x4410f(%rip),%ymm16        # a150 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x58>
   4e25c:	be fb ff 
   4e25f:	62 e2 fd 28 59 0d ef 	vpbroadcastq -0x44111(%rip),%ymm17        # a158 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x60>
   4e266:	be fb ff 
   4e269:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
   4e270:	c5 fd d4 ec          	vpaddq %ymm4,%ymm0,%ymm5
   4e274:	c5 dd d4 f1          	vpaddq %ymm1,%ymm4,%ymm6
   4e278:	c5 dd d4 fa          	vpaddq %ymm2,%ymm4,%ymm7
   4e27c:	c5 5d d4 c3          	vpaddq %ymm3,%ymm4,%ymm8
   4e280:	62 d2 d5 28 40 ed    	vpmullq %ymm13,%ymm5,%ymm5
   4e286:	62 d2 cd 28 40 f5    	vpmullq %ymm13,%ymm6,%ymm6
   4e28c:	62 d2 c5 28 40 fd    	vpmullq %ymm13,%ymm7,%ymm7
   4e292:	62 52 bd 28 40 c5    	vpmullq %ymm13,%ymm8,%ymm8
   4e298:	c5 8d d4 ed          	vpaddq %ymm5,%ymm14,%ymm5
   4e29c:	c5 8d d4 f6          	vpaddq %ymm6,%ymm14,%ymm6
   4e2a0:	c5 8d d4 ff          	vpaddq %ymm7,%ymm14,%ymm7
   4e2a4:	c4 41 3d d4 c6       	vpaddq %ymm14,%ymm8,%ymm8
   4e2a9:	c5 b5 73 d5 1e       	vpsrlq $0x1e,%ymm5,%ymm9
   4e2ae:	c5 ad 73 d6 1e       	vpsrlq $0x1e,%ymm6,%ymm10
   4e2b3:	c5 a5 73 d7 1e       	vpsrlq $0x1e,%ymm7,%ymm11
   4e2b8:	c4 c1 1d 73 d0 1e    	vpsrlq $0x1e,%ymm8,%ymm12
   4e2be:	c5 b5 ef ed          	vpxor  %ymm5,%ymm9,%ymm5
   4e2c2:	c5 ad ef f6          	vpxor  %ymm6,%ymm10,%ymm6
   4e2c6:	c5 a5 ef ff          	vpxor  %ymm7,%ymm11,%ymm7
   4e2ca:	c4 41 1d ef c0       	vpxor  %ymm8,%ymm12,%ymm8
   4e2cf:	62 d2 d5 28 40 ef    	vpmullq %ymm15,%ymm5,%ymm5
   4e2d5:	62 d2 cd 28 40 f7    	vpmullq %ymm15,%ymm6,%ymm6
   4e2db:	62 d2 c5 28 40 ff    	vpmullq %ymm15,%ymm7,%ymm7
   4e2e1:	62 52 bd 28 40 c7    	vpmullq %ymm15,%ymm8,%ymm8
   4e2e7:	c5 b5 73 d5 1b       	vpsrlq $0x1b,%ymm5,%ymm9
   4e2ec:	c5 ad 73 d6 1b       	vpsrlq $0x1b,%ymm6,%ymm10
   4e2f1:	c5 a5 73 d7 1b       	vpsrlq $0x1b,%ymm7,%ymm11
   4e2f6:	c5 b5 ef ed          	vpxor  %ymm5,%ymm9,%ymm5
   4e2fa:	c5 ad ef f6          	vpxor  %ymm6,%ymm10,%ymm6
   4e2fe:	c5 a5 ef ff          	vpxor  %ymm7,%ymm11,%ymm7
   4e302:	62 b2 d5 28 40 e8    	vpmullq %ymm16,%ymm5,%ymm5
   4e308:	62 b2 cd 28 40 f0    	vpmullq %ymm16,%ymm6,%ymm6
   4e30e:	62 b2 c5 28 40 f8    	vpmullq %ymm16,%ymm7,%ymm7
   4e314:	c4 c1 35 73 d0 1b    	vpsrlq $0x1b,%ymm8,%ymm9
   4e31a:	c4 41 35 ef c0       	vpxor  %ymm8,%ymm9,%ymm8
   4e31f:	62 32 bd 28 40 c0    	vpmullq %ymm16,%ymm8,%ymm8
   4e325:	c5 b5 73 d5 1f       	vpsrlq $0x1f,%ymm5,%ymm9
   4e32a:	c5 ad 73 d6 1f       	vpsrlq $0x1f,%ymm6,%ymm10
   4e32f:	c5 a5 73 d7 1f       	vpsrlq $0x1f,%ymm7,%ymm11
   4e334:	c4 c1 1d 73 d0 1f    	vpsrlq $0x1f,%ymm8,%ymm12
   4e33a:	c5 b5 ef ed          	vpxor  %ymm5,%ymm9,%ymm5
   4e33e:	c5 ad ef f6          	vpxor  %ymm6,%ymm10,%ymm6
   4e342:	c5 a5 ef ff          	vpxor  %ymm7,%ymm11,%ymm7
   4e346:	c4 a1 7e 7f ac c4 e0 	vmovdqu %ymm5,0xe0(%rsp,%r8,8)
   4e34d:	00 00 00 
   4e350:	c4 a1 7e 7f b4 c4 00 	vmovdqu %ymm6,0x100(%rsp,%r8,8)
   4e357:	01 00 00 
   4e35a:	c4 a1 7e 7f bc c4 20 	vmovdqu %ymm7,0x120(%rsp,%r8,8)
   4e361:	01 00 00 
   4e364:	c4 c1 1d ef e8       	vpxor  %ymm8,%ymm12,%ymm5
   4e369:	c4 a1 7e 7f ac c4 40 	vmovdqu %ymm5,0x140(%rsp,%r8,8)
   4e370:	01 00 00 
   4e373:	49 83 c0 10          	add    $0x10,%r8
   4e377:	62 b1 dd 28 d4 e1    	vpaddq %ymm17,%ymm4,%ymm4
   4e37d:	4c 39 c7             	cmp    %r8,%rdi
   4e380:	0f 85 ea fe ff ff    	jne    4e270 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0x670>
   4e386:	48 39 ce             	cmp    %rcx,%rsi
   4e389:	0f 84 36 01 00 00    	je     4e4c5 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0x8c5>
   4e38f:	40 f6 c6 0c          	test   $0xc,%sil
   4e393:	0f 84 89 01 00 00    	je     4e522 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0x922>
   4e399:	49 89 c8             	mov    %rcx,%r8
   4e39c:	48 83 e2 fc          	and    $0xfffffffffffffffc,%rdx
   4e3a0:	48 b9 f0 ff ff ff ff 	movabs $0x3ffffffffffffff0,%rcx
   4e3a7:	ff ff 3f 
   4e3aa:	48 83 c1 0c          	add    $0xc,%rcx
   4e3ae:	48 21 f1             	and    %rsi,%rcx
   4e3b1:	48 8d bc cc e0 00 00 	lea    0xe0(%rsp,%rcx,8),%rdi
   4e3b8:	00 
   4e3b9:	62 d2 fd 28 7c c8    	vpbroadcastq %r8,%ymm1
   4e3bf:	c5 f5 eb 0d 99 be fb 	vpor   -0x44167(%rip),%ymm1,%ymm1        # a260 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x168>
   4e3c6:	ff 
   4e3c7:	c4 e2 7d 59 25 38 bd 	vpbroadcastq -0x442c8(%rip),%ymm4        # a108 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x10>
   4e3ce:	fb ff 
   4e3d0:	c4 e2 7d 59 2d ef bc 	vpbroadcastq -0x44311(%rip),%ymm5        # a0c8 <anon.25805f450824d4a1248fcaae526abf58.283.llvm.3576388159787090369+0xcc>
   4e3d7:	fb ff 
   4e3d9:	c4 e2 7d 59 35 c6 bc 	vpbroadcastq -0x4433a(%rip),%ymm6        # a0a8 <anon.25805f450824d4a1248fcaae526abf58.283.llvm.3576388159787090369+0xac>
   4e3e0:	fb ff 
   4e3e2:	c4 e2 7d 59 3d 65 bd 	vpbroadcastq -0x4429b(%rip),%ymm7        # a150 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x58>
   4e3e9:	fb ff 
   4e3eb:	c4 62 7d 59 05 54 bd 	vpbroadcastq -0x442ac(%rip),%ymm8        # a148 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x50>
   4e3f2:	fb ff 
   4e3f4:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
   4e3fb:	00 00 00 00 00 
   4e400:	c5 fd d4 d1          	vpaddq %ymm1,%ymm0,%ymm2
   4e404:	62 f2 ed 28 40 d4    	vpmullq %ymm4,%ymm2,%ymm2
   4e40a:	c5 ed d4 d5          	vpaddq %ymm5,%ymm2,%ymm2
   4e40e:	c5 e5 73 d2 1e       	vpsrlq $0x1e,%ymm2,%ymm3
   4e413:	c5 e5 ef d2          	vpxor  %ymm2,%ymm3,%ymm2
   4e417:	62 f2 ed 28 40 d6    	vpmullq %ymm6,%ymm2,%ymm2
   4e41d:	c5 e5 73 d2 1b       	vpsrlq $0x1b,%ymm2,%ymm3
   4e422:	c5 e5 ef d2          	vpxor  %ymm2,%ymm3,%ymm2
   4e426:	62 f2 ed 28 40 d7    	vpmullq %ymm7,%ymm2,%ymm2
   4e42c:	c5 e5 73 d2 1f       	vpsrlq $0x1f,%ymm2,%ymm3
   4e431:	c5 e5 ef d2          	vpxor  %ymm2,%ymm3,%ymm2
   4e435:	c4 a1 7e 7f 94 c4 e0 	vmovdqu %ymm2,0xe0(%rsp,%r8,8)
   4e43c:	00 00 00 
   4e43f:	49 83 c0 04          	add    $0x4,%r8
   4e443:	c5 bd d4 c9          	vpaddq %ymm1,%ymm8,%ymm1
   4e447:	4c 39 c2             	cmp    %r8,%rdx
   4e44a:	75 b4                	jne    4e400 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0x800>
   4e44c:	48 39 ce             	cmp    %rcx,%rsi
   4e44f:	49 b9 b9 e5 e4 1c 6d 	movabs $0xbf58476d1ce4e5b9,%r9
   4e456:	47 58 bf 
   4e459:	49 ba eb 11 31 13 bb 	movabs $0x94d049bb133111eb,%r10
   4e460:	49 d0 94 
   4e463:	74 60                	je     4e4c5 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0x8c5>
   4e465:	89 c2                	mov    %eax,%edx
   4e467:	48 8d 94 d4 e0 00 00 	lea    0xe0(%rsp,%rdx,8),%rdx
   4e46e:	00 
   4e46f:	4c 01 e1             	add    %r12,%rcx
   4e472:	48 be eb 83 b5 80 46 	movabs $0x61c8864680b583eb,%rsi
   4e479:	86 c8 61 
   4e47c:	48 0f af ce          	imul   %rsi,%rcx
   4e480:	48 be e8 84 ed 04 42 	movabs $0xc276e44204ed84e8,%rsi
   4e487:	e4 76 c2 
   4e48a:	48 29 ce             	sub    %rcx,%rsi
   4e48d:	0f 1f 00             	nopl   (%rax)
   4e490:	48 89 f1             	mov    %rsi,%rcx
   4e493:	48 c1 e9 1e          	shr    $0x1e,%rcx
   4e497:	48 31 f1             	xor    %rsi,%rcx
   4e49a:	49 0f af c9          	imul   %r9,%rcx
   4e49e:	49 89 c8             	mov    %rcx,%r8
   4e4a1:	49 c1 e8 1b          	shr    $0x1b,%r8
   4e4a5:	49 31 c8             	xor    %rcx,%r8
   4e4a8:	4d 0f af c2          	imul   %r10,%r8
   4e4ac:	4c 89 c1             	mov    %r8,%rcx
   4e4af:	48 c1 e9 1f          	shr    $0x1f,%rcx
   4e4b3:	4c 31 c1             	xor    %r8,%rcx
   4e4b6:	48 89 0f             	mov    %rcx,(%rdi)
   4e4b9:	48 83 c7 08          	add    $0x8,%rdi
   4e4bd:	4c 01 fe             	add    %r15,%rsi
   4e4c0:	48 39 d7             	cmp    %rdx,%rdi
   4e4c3:	75 cb                	jne    4e490 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0x890>
   4e4c5:	48 8b bc 24 d8 00 00 	mov    0xd8(%rsp),%rdi
   4e4cc:	00 
   4e4cd:	48 8b 8c 24 80 00 00 	mov    0x80(%rsp),%rcx
   4e4d4:	00 
   4e4d5:	48 89 ce             	mov    %rcx,%rsi
   4e4d8:	31 d2                	xor    %edx,%edx
   4e4da:	41 b8 01 00 00 00    	mov    $0x1,%r8d
   4e4e0:	41 b9 01 00 00 00    	mov    $0x1,%r9d
   4e4e6:	50                   	push   %rax
   4e4e7:	48 8d 84 24 e8 00 00 	lea    0xe8(%rsp),%rax
   4e4ee:	00 
   4e4ef:	50                   	push   %rax
   4e4f0:	c5 f8 77             	vzeroupper
   4e4f3:	e8 18 0d ff ff       	call   3f210 <<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>::insert_into>
   4e4f8:	48 83 c4 10          	add    $0x10,%rsp
   4e4fc:	48 81 c5 00 10 00 00 	add    $0x1000,%rbp
   4e503:	49 ff cd             	dec    %r13
   4e506:	49 ff c6             	inc    %r14
   4e509:	48 81 c3 00 f0 ff ff 	add    $0xfffffffffffff000,%rbx
   4e510:	49 81 c4 00 10 00 00 	add    $0x1000,%r12
   4e517:	4d 85 ed             	test   %r13,%r13
   4e51a:	0f 85 30 fc ff ff    	jne    4e150 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0x550>
   4e520:	eb 0d                	jmp    4e52f <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0x92f>
   4e522:	48 8d bc cc e0 00 00 	lea    0xe0(%rsp,%rcx,8),%rdi
   4e529:	00 
   4e52a:	e9 87 fc ff ff       	jmp    4e1b6 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0x5b6>
   4e52f:	48 8d bc 24 b8 00 00 	lea    0xb8(%rsp),%rdi
   4e536:	00 
   4e537:	ff 15 f3 61 05 00    	call   *0x561f3(%rip)        # a4730 <_DYNAMIC+0x830>
   4e53d:	49 89 c6             	mov    %rax,%r14
   4e540:	89 d5                	mov    %edx,%ebp
   4e542:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
   4e546:	c5 fe 7f 84 24 40 01 	vmovdqu %ymm0,0x140(%rsp)
   4e54d:	00 00 
   4e54f:	c5 fe 7f 84 24 20 01 	vmovdqu %ymm0,0x120(%rsp)
   4e556:	00 00 
   4e558:	c5 fe 7f 84 24 00 01 	vmovdqu %ymm0,0x100(%rsp)
   4e55f:	00 00 
   4e561:	48 8d 9c 24 a0 00 00 	lea    0xa0(%rsp),%rbx
   4e568:	00 
   4e569:	c5 fe 7f 84 24 e0 00 	vmovdqu %ymm0,0xe0(%rsp)
   4e570:	00 00 
   4e572:	4c 8b 84 24 c8 00 00 	mov    0xc8(%rsp),%r8
   4e579:	00 
   4e57a:	49 c1 e0 03          	shl    $0x3,%r8
   4e57e:	31 c0                	xor    %eax,%eax
   4e580:	b9 01 00 00 00       	mov    $0x1,%ecx
   4e585:	48 8b 7c 24 60       	mov    0x60(%rsp),%rdi
   4e58a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
   4e590:	48 8b 14 07          	mov    (%rdi,%rax,1),%rdx
   4e594:	48 81 fa 00 04 00 00 	cmp    $0x400,%rdx
   4e59b:	0f 83 16 02 00 00    	jae    4e7b7 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xbb7>
   4e5a1:	c4 e2 e9 f7 f1       	shlx   %rdx,%rcx,%rsi
   4e5a6:	48 c1 ea 06          	shr    $0x6,%rdx
   4e5aa:	48 09 b4 d4 e0 00 00 	or     %rsi,0xe0(%rsp,%rdx,8)
   4e5b1:	00 
   4e5b2:	48 83 c0 08          	add    $0x8,%rax
   4e5b6:	49 39 c0             	cmp    %rax,%r8
   4e5b9:	75 d5                	jne    4e590 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0x990>
   4e5bb:	48 8d 94 24 e0 00 00 	lea    0xe0(%rsp),%rdx
   4e5c2:	00 
   4e5c3:	be 80 00 00 00       	mov    $0x80,%esi
   4e5c8:	31 ff                	xor    %edi,%edi
   4e5ca:	c5 f8 77             	vzeroupper
   4e5cd:	ff 15 4d 61 05 00    	call   *0x5614d(%rip)        # a4720 <sched_setaffinity@GLIBC_2.3.4>
   4e5d3:	89 44 24 48          	mov    %eax,0x48(%rsp)
   4e5d7:	85 c0                	test   %eax,%eax
   4e5d9:	0f 85 e1 02 00 00    	jne    4e8c0 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xcc0>
   4e5df:	ff 15 43 61 05 00    	call   *0x56143(%rip)        # a4728 <_DYNAMIC+0x828>
   4e5e5:	48 89 44 24 48       	mov    %rax,0x48(%rsp)
   4e5ea:	89 54 24 50          	mov    %edx,0x50(%rsp)
   4e5ee:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
   4e5f3:	c5 fa 6f 40 08       	vmovdqu 0x8(%rax),%xmm0
   4e5f8:	c5 fa 7f 84 24 e0 00 	vmovdqu %xmm0,0xe0(%rsp)
   4e5ff:	00 00 
   4e601:	48 8d 84 24 e0 00 00 	lea    0xe0(%rsp),%rax
   4e608:	00 
   4e609:	48 8b b4 24 e0 00 00 	mov    0xe0(%rsp),%rsi
   4e610:	00 
   4e611:	48 8b 94 24 e8 00 00 	mov    0xe8(%rsp),%rdx
   4e618:	00 
   4e619:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
   4e61e:	48 8b 48 30          	mov    0x30(%rax),%rcx
   4e622:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
   4e627:	ff 15 ab 5f 05 00    	call   *0x55fab(%rip)        # a45d8 <_DYNAMIC+0x6d8>
   4e62d:	48 8d 7c 24 48       	lea    0x48(%rsp),%rdi
   4e632:	ff 15 f8 60 05 00    	call   *0x560f8(%rip)        # a4730 <_DYNAMIC+0x830>
   4e638:	49 89 c4             	mov    %rax,%r12
   4e63b:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
   4e640:	48 8b 00             	mov    (%rax),%rax
   4e643:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
   4e647:	c5 fe 7f 84 24 40 01 	vmovdqu %ymm0,0x140(%rsp)
   4e64e:	00 00 
   4e650:	c5 fe 7f 84 24 20 01 	vmovdqu %ymm0,0x120(%rsp)
   4e657:	00 00 
   4e659:	c5 fe 7f 84 24 00 01 	vmovdqu %ymm0,0x100(%rsp)
   4e660:	00 00 
   4e662:	c5 fe 7f 84 24 e0 00 	vmovdqu %ymm0,0xe0(%rsp)
   4e669:	00 00 
   4e66b:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
   4e671:	0f 87 40 01 00 00    	ja     4e7b7 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xbb7>
   4e677:	41 89 d5             	mov    %edx,%r13d
   4e67a:	b9 01 00 00 00       	mov    $0x1,%ecx
   4e67f:	c4 e2 f9 f7 c9       	shlx   %rax,%rcx,%rcx
   4e684:	48 c1 e8 06          	shr    $0x6,%rax
   4e688:	48 09 8c c4 e0 00 00 	or     %rcx,0xe0(%rsp,%rax,8)
   4e68f:	00 
   4e690:	48 8d 94 24 e0 00 00 	lea    0xe0(%rsp),%rdx
   4e697:	00 
   4e698:	be 80 00 00 00       	mov    $0x80,%esi
   4e69d:	31 ff                	xor    %edi,%edi
   4e69f:	c5 f8 77             	vzeroupper
   4e6a2:	ff 15 78 60 05 00    	call   *0x56078(%rip)        # a4720 <sched_setaffinity@GLIBC_2.3.4>
   4e6a8:	89 44 24 5c          	mov    %eax,0x5c(%rsp)
   4e6ac:	85 c0                	test   %eax,%eax
   4e6ae:	0f 85 34 02 00 00    	jne    4e8e8 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xce8>
   4e6b4:	b8 00 ca 9a 3b       	mov    $0x3b9aca00,%eax
   4e6b9:	4c 89 e2             	mov    %r12,%rdx
   4e6bc:	c4 62 fb f6 f8       	mulx   %rax,%rax,%r15
   4e6c1:	44 89 eb             	mov    %r13d,%ebx
   4e6c4:	48 01 c3             	add    %rax,%rbx
   4e6c7:	49 83 d7 00          	adc    $0x0,%r15
   4e6cb:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
   4e6d0:	4c 8b 60 10          	mov    0x10(%rax),%r12
   4e6d4:	4c 3b 20             	cmp    (%rax),%r12
   4e6d7:	75 0a                	jne    4e6e3 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xae3>
   4e6d9:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
   4e6de:	e8 ad 10 01 00       	call   5f790 <<alloc::raw_vec::RawVec<u128>>::grow_one>
   4e6e3:	4c 89 e0             	mov    %r12,%rax
   4e6e6:	48 c1 e0 04          	shl    $0x4,%rax
   4e6ea:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
   4e6ef:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
   4e6f3:	4c 89 7c 01 08       	mov    %r15,0x8(%rcx,%rax,1)
   4e6f8:	49 ff c4             	inc    %r12
   4e6fb:	48 89 1c 01          	mov    %rbx,(%rcx,%rax,1)
   4e6ff:	4c 89 62 10          	mov    %r12,0x10(%rdx)
   4e703:	48 83 7c 24 40 00    	cmpq   $0x0,0x40(%rsp)
   4e709:	74 27                	je     4e732 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xb32>
   4e70b:	b8 00 ca 9a 3b       	mov    $0x3b9aca00,%eax
   4e710:	4c 89 f2             	mov    %r14,%rdx
   4e713:	c4 62 fb f6 f0       	mulx   %rax,%rax,%r14
   4e718:	89 eb                	mov    %ebp,%ebx
   4e71a:	48 01 c3             	add    %rax,%rbx
   4e71d:	49 83 d6 00          	adc    $0x0,%r14
   4e721:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
   4e726:	4c 8b 78 40          	mov    0x40(%rax),%r15
   4e72a:	4c 3b 78 30          	cmp    0x30(%rax),%r15
   4e72e:	74 16                	je     4e746 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xb46>
   4e730:	eb 22                	jmp    4e754 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xb54>
   4e732:	31 db                	xor    %ebx,%ebx
   4e734:	45 31 f6             	xor    %r14d,%r14d
   4e737:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
   4e73c:	4c 8b 78 40          	mov    0x40(%rax),%r15
   4e740:	4c 3b 78 30          	cmp    0x30(%rax),%r15
   4e744:	75 0e                	jne    4e754 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xb54>
   4e746:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
   4e74b:	48 8d 78 30          	lea    0x30(%rax),%rdi
   4e74f:	e8 3c 10 01 00       	call   5f790 <<alloc::raw_vec::RawVec<u128>>::grow_one>
   4e754:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
   4e759:	48 8b 42 38          	mov    0x38(%rdx),%rax
   4e75d:	4c 89 f9             	mov    %r15,%rcx
   4e760:	48 c1 e1 04          	shl    $0x4,%rcx
   4e764:	4c 89 74 08 08       	mov    %r14,0x8(%rax,%rcx,1)
   4e769:	48 89 1c 08          	mov    %rbx,(%rax,%rcx,1)
   4e76d:	49 ff c7             	inc    %r15
   4e770:	4c 89 7a 40          	mov    %r15,0x40(%rdx)
   4e774:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
   4e779:	48 8b 74 24 38       	mov    0x38(%rsp),%rsi
   4e77e:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
   4e783:	48 8b 4c 24 68       	mov    0x68(%rsp),%rcx
   4e788:	4c 8b 44 24 70       	mov    0x70(%rsp),%r8
   4e78d:	e8 0e 54 00 00       	call   53ba0 <policy_confirmation::validate::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>>
   4e792:	48 83 7c 24 10 00    	cmpq   $0x0,0x10(%rsp)
   4e798:	74 0b                	je     4e7a5 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xba5>
   4e79a:	48 8b 7c 24 18       	mov    0x18(%rsp),%rdi
   4e79f:	ff 15 53 59 05 00    	call   *0x55953(%rip)        # a40f8 <free@GLIBC_2.2.5>
   4e7a5:	48 81 c4 e8 80 00 00 	add    $0x80e8,%rsp
   4e7ac:	5b                   	pop    %rbx
   4e7ad:	41 5c                	pop    %r12
   4e7af:	41 5d                	pop    %r13
   4e7b1:	41 5e                	pop    %r14
   4e7b3:	41 5f                	pop    %r15
   4e7b5:	5d                   	pop    %rbp
   4e7b6:	c3                   	ret
   4e7b7:	48 8d 3d 97 df fb ff 	lea    -0x42069(%rip),%rdi        # c755 <panic_unwind::imp::CANARY+0x5a9>
   4e7be:	48 8d 15 e3 37 05 00 	lea    0x537e3(%rip),%rdx        # a1fa8 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.1797.llvm.15448142832521594973+0xb80>
   4e7c5:	be 1c 00 00 00       	mov    $0x1c,%esi
   4e7ca:	c5 f8 77             	vzeroupper
   4e7cd:	ff 15 35 5b 05 00    	call   *0x55b35(%rip)        # a4308 <_DYNAMIC+0x408>
   4e7d3:	e9 b1 01 00 00       	jmp    4e989 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xd89>
   4e7d8:	48 8d 3d 76 df fb ff 	lea    -0x4208a(%rip),%rdi        # c755 <panic_unwind::imp::CANARY+0x5a9>
   4e7df:	48 8d 15 c2 37 05 00 	lea    0x537c2(%rip),%rdx        # a1fa8 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.1797.llvm.15448142832521594973+0xb80>
   4e7e6:	be 1c 00 00 00       	mov    $0x1c,%esi
   4e7eb:	c5 f8 77             	vzeroupper
   4e7ee:	ff 15 14 5b 05 00    	call   *0x55b14(%rip)        # a4308 <_DYNAMIC+0x408>
   4e7f4:	48 8d 05 c5 37 05 00 	lea    0x537c5(%rip),%rax        # a1fc0 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.1797.llvm.15448142832521594973+0xb98>
   4e7fb:	48 89 84 24 88 00 00 	mov    %rax,0x88(%rsp)
   4e802:	00 
   4e803:	48 c7 84 24 90 00 00 	movq   $0x1,0x90(%rsp)
   4e80a:	00 01 00 00 00 
   4e80f:	48 c7 84 24 98 00 00 	movq   $0x8,0x98(%rsp)
   4e816:	00 08 00 00 00 
   4e81b:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
   4e81f:	c5 fa 7f 84 24 a0 00 	vmovdqu %xmm0,0xa0(%rsp)
   4e826:	00 00 
   4e828:	48 8d 15 99 b7 fb ff 	lea    -0x44867(%rip),%rdx        # 9fc8 <anon.25805f450824d4a1248fcaae526abf58.318.llvm.3576388159787090369+0x6c>
   4e82f:	4c 8d 05 9a 37 05 00 	lea    0x5379a(%rip),%r8        # a1fd0 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.1797.llvm.15448142832521594973+0xba8>
   4e836:	48 8d 74 24 10       	lea    0x10(%rsp),%rsi
   4e83b:	48 8d 8c 24 88 00 00 	lea    0x88(%rsp),%rcx
   4e842:	00 
   4e843:	31 ff                	xor    %edi,%edi
   4e845:	ff 15 ed 5e 05 00    	call   *0x55eed(%rip)        # a4738 <_DYNAMIC+0x838>
   4e84b:	48 8d 3d 03 df fb ff 	lea    -0x420fd(%rip),%rdi        # c755 <panic_unwind::imp::CANARY+0x5a9>
   4e852:	48 8d 15 4f 37 05 00 	lea    0x5374f(%rip),%rdx        # a1fa8 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.1797.llvm.15448142832521594973+0xb80>
   4e859:	be 1c 00 00 00       	mov    $0x1c,%esi
   4e85e:	c5 f8 77             	vzeroupper
   4e861:	ff 15 a1 5a 05 00    	call   *0x55aa1(%rip)        # a4308 <_DYNAMIC+0x408>
   4e867:	48 8d 05 92 32 05 00 	lea    0x53292(%rip),%rax        # a1b00 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.1797.llvm.15448142832521594973+0x6d8>
   4e86e:	48 89 84 24 e0 00 00 	mov    %rax,0xe0(%rsp)
   4e875:	00 
   4e876:	48 c7 84 24 e8 00 00 	movq   $0x1,0xe8(%rsp)
   4e87d:	00 01 00 00 00 
   4e882:	48 c7 84 24 f0 00 00 	movq   $0x8,0xf0(%rsp)
   4e889:	00 08 00 00 00 
   4e88e:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
   4e892:	c5 fa 7f 84 24 f8 00 	vmovdqu %xmm0,0xf8(%rsp)
   4e899:	00 00 
   4e89b:	48 83 c3 38          	add    $0x38,%rbx
   4e89f:	48 8d 15 52 b8 fb ff 	lea    -0x447ae(%rip),%rdx        # a0f8 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973>
   4e8a6:	4c 8d 05 63 32 05 00 	lea    0x53263(%rip),%r8        # a1b10 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.1797.llvm.15448142832521594973+0x6e8>
   4e8ad:	48 8d 8c 24 e0 00 00 	lea    0xe0(%rsp),%rcx
   4e8b4:	00 
   4e8b5:	31 ff                	xor    %edi,%edi
   4e8b7:	48 89 de             	mov    %rbx,%rsi
   4e8ba:	ff 15 70 5a 05 00    	call   *0x55a70(%rip)        # a4330 <_DYNAMIC+0x430>
   4e8c0:	48 8d 74 24 48       	lea    0x48(%rsp),%rsi
   4e8c5:	eb 26                	jmp    4e8ed <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xced>
   4e8c7:	48 8d 3d 87 de fb ff 	lea    -0x42179(%rip),%rdi        # c755 <panic_unwind::imp::CANARY+0x5a9>
   4e8ce:	48 8d 15 d3 36 05 00 	lea    0x536d3(%rip),%rdx        # a1fa8 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.1797.llvm.15448142832521594973+0xb80>
   4e8d5:	be 1c 00 00 00       	mov    $0x1c,%esi
   4e8da:	c5 f8 77             	vzeroupper
   4e8dd:	ff 15 25 5a 05 00    	call   *0x55a25(%rip)        # a4308 <_DYNAMIC+0x408>
   4e8e3:	e9 a1 00 00 00       	jmp    4e989 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xd89>
   4e8e8:	48 8d 74 24 5c       	lea    0x5c(%rsp),%rsi
   4e8ed:	48 8d 8c 24 88 00 00 	lea    0x88(%rsp),%rcx
   4e8f4:	00 
   4e8f5:	48 8d 05 c4 36 05 00 	lea    0x536c4(%rip),%rax        # a1fc0 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.1797.llvm.15448142832521594973+0xb98>
   4e8fc:	48 89 01             	mov    %rax,(%rcx)
   4e8ff:	48 c7 41 08 01 00 00 	movq   $0x1,0x8(%rcx)
   4e906:	00 
   4e907:	48 c7 41 10 08 00 00 	movq   $0x8,0x10(%rcx)
   4e90e:	00 
   4e90f:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
   4e913:	c5 fa 7f 03          	vmovdqu %xmm0,(%rbx)
   4e917:	48 8d 15 aa b6 fb ff 	lea    -0x44956(%rip),%rdx        # 9fc8 <anon.25805f450824d4a1248fcaae526abf58.318.llvm.3576388159787090369+0x6c>
   4e91e:	4c 8d 05 ab 36 05 00 	lea    0x536ab(%rip),%r8        # a1fd0 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.1797.llvm.15448142832521594973+0xba8>
   4e925:	31 ff                	xor    %edi,%edi
   4e927:	ff 15 0b 5e 05 00    	call   *0x55e0b(%rip)        # a4738 <_DYNAMIC+0x838>
   4e92d:	eb 5a                	jmp    4e989 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xd89>
   4e92f:	48 8d 05 8a 36 05 00 	lea    0x5368a(%rip),%rax        # a1fc0 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.1797.llvm.15448142832521594973+0xb98>
   4e936:	48 89 84 24 88 00 00 	mov    %rax,0x88(%rsp)
   4e93d:	00 
   4e93e:	48 c7 84 24 90 00 00 	movq   $0x1,0x90(%rsp)
   4e945:	00 01 00 00 00 
   4e94a:	48 c7 84 24 98 00 00 	movq   $0x8,0x98(%rsp)
   4e951:	00 08 00 00 00 
   4e956:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
   4e95a:	c5 fa 7f 84 24 a0 00 	vmovdqu %xmm0,0xa0(%rsp)
   4e961:	00 00 
   4e963:	48 8d 15 5e b6 fb ff 	lea    -0x449a2(%rip),%rdx        # 9fc8 <anon.25805f450824d4a1248fcaae526abf58.318.llvm.3576388159787090369+0x6c>
   4e96a:	4c 8d 05 5f 36 05 00 	lea    0x5365f(%rip),%r8        # a1fd0 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.1797.llvm.15448142832521594973+0xba8>
   4e971:	48 8d b4 24 b8 00 00 	lea    0xb8(%rsp),%rsi
   4e978:	00 
   4e979:	48 8d 8c 24 88 00 00 	lea    0x88(%rsp),%rcx
   4e980:	00 
   4e981:	31 ff                	xor    %edi,%edi
   4e983:	ff 15 af 5d 05 00    	call   *0x55daf(%rip)        # a4738 <_DYNAMIC+0x838>
   4e989:	0f 0b                	ud2
   4e98b:	48 8d 15 56 31 05 00 	lea    0x53156(%rip),%rdx        # a1ae8 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.1797.llvm.15448142832521594973+0x6c0>
   4e992:	31 ff                	xor    %edi,%edi
   4e994:	31 f6                	xor    %esi,%esi
   4e996:	ff 15 b4 57 05 00    	call   *0x557b4(%rip)        # a4150 <_DYNAMIC+0x250>
   4e99c:	31 c0                	xor    %eax,%eax
   4e99e:	eb 02                	jmp    4e9a2 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xda2>
   4e9a0:	b0 01                	mov    $0x1,%al
   4e9a2:	88 84 24 e0 00 00 00 	mov    %al,0xe0(%rsp)
   4e9a9:	48 8d 3d d4 dd fb ff 	lea    -0x4222c(%rip),%rdi        # c784 <panic_unwind::imp::CANARY+0x5d8>
   4e9b0:	48 8d 0d 69 36 05 00 	lea    0x53669(%rip),%rcx        # a2020 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.1797.llvm.15448142832521594973+0xbf8>
   4e9b7:	4c 8d 05 8a 37 05 00 	lea    0x5378a(%rip),%r8        # a2148 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.1797.llvm.15448142832521594973+0xd20>
   4e9be:	48 8d 94 24 e0 00 00 	lea    0xe0(%rsp),%rdx
   4e9c5:	00 
   4e9c6:	be 2b 00 00 00       	mov    $0x2b,%esi
   4e9cb:	ff 15 c7 57 05 00    	call   *0x557c7(%rip)        # a4198 <_DYNAMIC+0x298>
   4e9d1:	bf 40 00 00 00       	mov    $0x40,%edi
   4e9d6:	4c 89 fe             	mov    %r15,%rsi
   4e9d9:	ff 15 61 57 05 00    	call   *0x55761(%rip)        # a4140 <_DYNAMIC+0x240>
   4e9df:	bf 40 00 00 00       	mov    $0x40,%edi
   4e9e4:	4c 89 f6             	mov    %r14,%rsi
   4e9e7:	ff 15 53 57 05 00    	call   *0x55753(%rip)        # a4140 <_DYNAMIC+0x240>
   4e9ed:	48 89 c3             	mov    %rax,%rbx
   4e9f0:	48 8b 84 24 80 00 00 	mov    0x80(%rsp),%rax
   4e9f7:	00 
   4e9f8:	eb 2c                	jmp    4ea26 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xe26>
   4e9fa:	48 89 c3             	mov    %rax,%rbx
   4e9fd:	48 83 7c 24 10 00    	cmpq   $0x0,0x10(%rsp)
   4ea03:	74 26                	je     4ea2b <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xe2b>
   4ea05:	48 8b 84 24 d0 00 00 	mov    0xd0(%rsp),%rax
   4ea0c:	00 
   4ea0d:	48 8b 38             	mov    (%rax),%rdi
   4ea10:	ff 15 e2 56 05 00    	call   *0x556e2(%rip)        # a40f8 <free@GLIBC_2.2.5>
   4ea16:	48 89 df             	mov    %rbx,%rdi
   4ea19:	e8 f2 fa 04 00       	call   9e510 <_Unwind_Resume@plt>
   4ea1e:	48 89 c3             	mov    %rax,%rbx
   4ea21:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
   4ea26:	48 85 c0             	test   %rax,%rax
   4ea29:	75 da                	jne    4ea05 <policy_confirmation::trial::<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>+0xe05>
   4ea2b:	48 89 df             	mov    %rbx,%rdi
   4ea2e:	e8 dd fa 04 00       	call   9e510 <_Unwind_Resume@plt>
   4ea33:	cc                   	int3
   4ea34:	cc                   	int3
   4ea35:	cc                   	int3
   4ea36:	cc                   	int3
   4ea37:	cc                   	int3
   4ea38:	cc                   	int3
   4ea39:	cc                   	int3
   4ea3a:	cc                   	int3
   4ea3b:	cc                   	int3
   4ea3c:	cc                   	int3
   4ea3d:	cc                   	int3
   4ea3e:	cc                   	int3
   4ea3f:	cc                   	int3

