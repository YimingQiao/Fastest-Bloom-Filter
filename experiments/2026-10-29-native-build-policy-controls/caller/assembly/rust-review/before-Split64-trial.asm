000000000004ea40 <policy_confirmation::trial::<fastest_bloom_filter::split64::Split64BloomFilter>>:
   4ea40:	55                   	push   %rbp
   4ea41:	41 57                	push   %r15
   4ea43:	41 56                	push   %r14
   4ea45:	41 55                	push   %r13
   4ea47:	41 54                	push   %r12
   4ea49:	53                   	push   %rbx
   4ea4a:	49 89 e3             	mov    %rsp,%r11
   4ea4d:	49 81 eb 00 80 00 00 	sub    $0x8000,%r11
   4ea54:	48 81 ec 00 10 00 00 	sub    $0x1000,%rsp
   4ea5b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
   4ea62:	00 
   4ea63:	4c 39 dc             	cmp    %r11,%rsp
   4ea66:	75 ec                	jne    4ea54 <policy_confirmation::trial::<fastest_bloom_filter::split64::Split64BloomFilter>+0x14>
   4ea68:	48 81 ec e8 00 00 00 	sub    $0xe8,%rsp
   4ea6f:	48 89 74 24 30       	mov    %rsi,0x30(%rsp)
   4ea74:	4c 8b 77 10          	mov    0x10(%rdi),%r14
   4ea78:	4d 85 f6             	test   %r14,%r14
   4ea7b:	0f 84 4d 0e 00 00    	je     4f8ce <policy_confirmation::trial::<fastest_bloom_filter::split64::Split64BloomFilter>+0xe8e>
   4ea81:	49 89 fd             	mov    %rdi,%r13
   4ea84:	48 8b 5f 08          	mov    0x8(%rdi),%rbx
   4ea88:	48 8b 03             	mov    (%rbx),%rax
   4ea8b:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
   4ea8f:	c5 fe 7f 84 24 40 01 	vmovdqu %ymm0,0x140(%rsp)
   4ea96:	00 00 
   4ea98:	c5 fe 7f 84 24 20 01 	vmovdqu %ymm0,0x120(%rsp)
   4ea9f:	00 00 
   4eaa1:	c5 fe 7f 84 24 00 01 	vmovdqu %ymm0,0x100(%rsp)
   4eaa8:	00 00 
   4eaaa:	c5 fe 7f 84 24 e0 00 	vmovdqu %ymm0,0xe0(%rsp)
   4eab1:	00 00 
   4eab3:	48 3d 00 04 00 00    	cmp    $0x400,%rax
   4eab9:	0f 83 96 0c 00 00    	jae    4f755 <policy_confirmation::trial::<fastest_bloom_filter::split64::Split64BloomFilter>+0xd15>
   4eabf:	4d 89 cc             	mov    %r9,%r12
   4eac2:	44 89 c5             	mov    %r8d,%ebp
   4eac5:	48 89 54 24 68       	mov    %rdx,0x68(%rsp)
   4eaca:	48 89 4c 24 70       	mov    %rcx,0x70(%rsp)
   4eacf:	b9 01 00 00 00       	mov    $0x1,%ecx
   4ead4:	c4 e2 f9 f7 c9       	shlx   %rax,%rcx,%rcx
   4ead9:	48 c1 e8 06          	shr    $0x6,%rax
   4eadd:	48 09 8c c4 e0 00 00 	or     %rcx,0xe0(%rsp,%rax,8)
   4eae4:	00 
   4eae5:	48 8d 94 24 e0 00 00 	lea    0xe0(%rsp),%rdx
   4eaec:	00 
   4eaed:	be 80 00 00 00       	mov    $0x80,%esi
   4eaf2:	31 ff                	xor    %edi,%edi
   4eaf4:	c5 f8 77             	vzeroupper
   4eaf7:	ff 15 23 5c 05 00    	call   *0x55c23(%rip)        # a4720 <sched_setaffinity@GLIBC_2.3.4>
   4eafd:	89 44 24 10          	mov    %eax,0x10(%rsp)
   4eb01:	85 c0                	test   %eax,%eax
   4eb03:	0f 85 f5 0b 00 00    	jne    4f6fe <policy_confirmation::trial::<fastest_bloom_filter::split64::Split64BloomFilter>+0xcbe>
   4eb09:	48 8d 44 24 18       	lea    0x18(%rsp),%rax
   4eb0e:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
   4eb15:	00 
   4eb16:	40 84 ed             	test   %bpl,%bpl
   4eb19:	0f 84 31 01 00 00    	je     4ec50 <policy_confirmation::trial::<fastest_bloom_filter::split64::Split64BloomFilter>+0x210>
   4eb1f:	49 83 7d 38 00       	cmpq   $0x0,0x38(%r13)
   4eb24:	0f 85 78 0c 00 00    	jne    4f7a2 <policy_confirmation::trial::<fastest_bloom_filter::split64::Split64BloomFilter>+0xd62>
   4eb2a:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
   4eb2e:	c5 fe 7f 84 24 40 01 	vmovdqu %ymm0,0x140(%rsp)
   4eb35:	00 00 
   4eb37:	c5 fe 7f 84 24 20 01 	vmovdqu %ymm0,0x120(%rsp)
   4eb3e:	00 00 
   4eb40:	c5 fe 7f 84 24 00 01 	vmovdqu %ymm0,0x100(%rsp)
   4eb47:	00 00 
   4eb49:	c5 fe 7f 84 24 e0 00 	vmovdqu %ymm0,0xe0(%rsp)
   4eb50:	00 00 
   4eb52:	49 c1 e6 03          	shl    $0x3,%r14
   4eb56:	31 c0                	xor    %eax,%eax
   4eb58:	b9 01 00 00 00       	mov    $0x1,%ecx
   4eb5d:	0f 1f 00             	nopl   (%rax)
   4eb60:	48 8b 14 03          	mov    (%rbx,%rax,1),%rdx
   4eb64:	48 81 fa 00 04 00 00 	cmp    $0x400,%rdx
   4eb6b:	0f 83 50 0b 00 00    	jae    4f6c1 <policy_confirmation::trial::<fastest_bloom_filter::split64::Split64BloomFilter>+0xc81>
   4eb71:	c4 e2 e9 f7 f1       	shlx   %rdx,%rcx,%rsi
   4eb76:	48 c1 ea 06          	shr    $0x6,%rdx
   4eb7a:	48 09 b4 d4 e0 00 00 	or     %rsi,0xe0(%rsp,%rdx,8)
   4eb81:	00 
   4eb82:	48 83 c0 08          	add    $0x8,%rax
   4eb86:	49 39 c6             	cmp    %rax,%r14
   4eb89:	75 d5                	jne    4eb60 <policy_confirmation::trial::<fastest_bloom_filter::split64::Split64BloomFilter>+0x120>
   4eb8b:	48 8d 94 24 e0 00 00 	lea    0xe0(%rsp),%rdx
   4eb92:	00 
   4eb93:	be 80 00 00 00       	mov    $0x80,%esi
   4eb98:	31 ff                	xor    %edi,%edi
   4eb9a:	c5 f8 77             	vzeroupper
   4eb9d:	ff 15 7d 5b 05 00    	call   *0x55b7d(%rip)        # a4720 <sched_setaffinity@GLIBC_2.3.4>
   4eba3:	89 44 24 10          	mov    %eax,0x10(%rsp)
   4eba7:	85 c0                	test   %eax,%eax
   4eba9:	0f 85 4f 0b 00 00    	jne    4f6fe <policy_confirmation::trial::<fastest_bloom_filter::split64::Split64BloomFilter>+0xcbe>
   4ebaf:	49 be f0 ff ff ff ff 	movabs $0x3ffffffffffffff0,%r14
   4ebb6:	ff ff 3f 
   4ebb9:	ff 15 69 5b 05 00    	call   *0x55b69(%rip)        # a4728 <_DYNAMIC+0x828>
   4ebbf:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
   4ebc4:	89 54 24 58          	mov    %edx,0x58(%rsp)
   4ebc8:	49 8b 45 20          	mov    0x20(%r13),%rax
   4ebcc:	49 8d 4e 0f          	lea    0xf(%r14),%rcx
   4ebd0:	48 39 c8             	cmp    %rcx,%rax
   4ebd3:	0f 87 98 0b 00 00    	ja     4f771 <policy_confirmation::trial::<fastest_bloom_filter::split64::Split64BloomFilter>+0xd31>
   4ebd9:	48 89 5c 24 40       	mov    %rbx,0x40(%rsp)
   4ebde:	48 3d ff ff ff 1f    	cmp    $0x1fffffff,%rax
   4ebe4:	0f 87 f5 0c 00 00    	ja     4f8df <policy_confirmation::trial::<fastest_bloom_filter::split64::Split64BloomFilter>+0xe9f>
   4ebea:	c1 e0 02             	shl    $0x2,%eax
   4ebed:	25 f8 ff ff 7f       	and    $0x7ffffff8,%eax
   4ebf2:	48 3d 01 02 00 00    	cmp    $0x201,%rax
   4ebf8:	b9 00 02 00 00       	mov    $0x200,%ecx
   4ebfd:	48 0f 43 c8          	cmovae %rax,%rcx
   4ec01:	c1 e9 05             	shr    $0x5,%ecx
   4ec04:	b8 20 00 00 00       	mov    $0x20,%eax
   4ec09:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
   4ec10:	48 89 c3             	mov    %rax,%rbx
   4ec13:	48 01 c0             	add    %rax,%rax
   4ec16:	48 39 cb             	cmp    %rcx,%rbx
   4ec19:	76 f5                	jbe    4ec10 <policy_confirmation::trial::<fastest_bloom_filter::split64::Split64BloomFilter>+0x1d0>
   4ec1b:	4c 39 f3             	cmp    %r14,%rbx
   4ec1e:	0f 97 c0             	seta   %al
   4ec21:	4c 8d 34 9d 00 00 00 	lea    0x0(,%rbx,4),%r14
   4ec28:	00 
   4ec29:	48 b9 c0 ff ff ff ff 	movabs $0x7fffffffffffffc0,%rcx
   4ec30:	ff ff 7f 
   4ec33:	49 39 ce             	cmp    %rcx,%r14
   4ec36:	0f 97 c1             	seta   %cl
   4ec39:	08 c1                	or     %al,%cl
   4ec3b:	0f 84 e5 07 00 00    	je     4f426 <policy_confirmation::trial::<fastest_bloom_filter::split64::Split64BloomFilter>+0x9e6>
   4ec41:	45 31 ff             	xor    %r15d,%r15d
   4ec44:	4c 89 ff             	mov    %r15,%rdi
   4ec47:	4c 89 f6             	mov    %r14,%rsi
   4ec4a:	ff 15 f0 54 05 00    	call   *0x554f0(%rip)        # a4140 <_DYNAMIC+0x240>
   4ec50:	48 be f0 ff ff ff ff 	movabs $0x3ffffffffffffff0,%rsi
   4ec57:	ff ff 3f 
   4ec5a:	49 8b 45 20          	mov    0x20(%r13),%rax
   4ec5e:	48 8d 4e 0f          	lea    0xf(%rsi),%rcx
   4ec62:	48 39 c8             	cmp    %rcx,%rax
   4ec65:	0f 87 06 0b 00 00    	ja     4f771 <policy_confirmation::trial::<fastest_bloom_filter::split64::Split64BloomFilter>+0xd31>
   4ec6b:	48 3d ff ff ff 1f    	cmp    $0x1fffffff,%rax
   4ec71:	0f 87 68 0c 00 00    	ja     4f8df <policy_confirmation::trial::<fastest_bloom_filter::split64::Split64BloomFilter>+0xe9f>
   4ec77:	4c 89 b4 24 c8 00 00 	mov    %r14,0xc8(%rsp)
   4ec7e:	00 
   4ec7f:	48 8d 94 24 98 00 00 	lea    0x98(%rsp),%rdx
   4ec86:	00 
   4ec87:	c1 e0 02             	shl    $0x2,%eax
   4ec8a:	25 f8 ff ff 7f       	and    $0x7ffffff8,%eax
   4ec8f:	48 3d 01 02 00 00    	cmp    $0x201,%rax
   4ec95:	b9 00 02 00 00       	mov    $0x200,%ecx
   4ec9a:	48 0f 43 c8          	cmovae %rax,%rcx
   4ec9e:	c1 e9 05             	shr    $0x5,%ecx
   4eca1:	b8 20 00 00 00       	mov    $0x20,%eax
   4eca6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
   4ecad:	00 00 00 
   4ecb0:	48 89 c5             	mov    %rax,%rbp
   4ecb3:	48 01 c0             	add    %rax,%rax
   4ecb6:	48 39 cd             	cmp    %rcx,%rbp
   4ecb9:	76 f5                	jbe    4ecb0 <policy_confirmation::trial::<fastest_bloom_filter::split64::Split64BloomFilter>+0x270>
   4ecbb:	48 39 f5             	cmp    %rsi,%rbp
   4ecbe:	0f 97 c0             	seta   %al
   4ecc1:	4c 8d 3c ad 00 00 00 	lea    0x0(,%rbp,4),%r15
   4ecc8:	00 
   4ecc9:	48 b9 c0 ff ff ff ff 	movabs $0x7fffffffffffffc0,%rcx
   4ecd0:	ff ff 7f 
   4ecd3:	49 39 cf             	cmp    %rcx,%r15
   4ecd6:	0f 97 c1             	seta   %cl
   4ecd9:	08 c1                	or     %al,%cl
   4ecdb:	74 0f                	je     4ecec <policy_confirmation::trial::<fastest_bloom_filter::split64::Split64BloomFilter>+0x2ac>
   4ecdd:	45 31 e4             	xor    %r12d,%r12d
   4ece0:	4c 89 e7             	mov    %r12,%rdi
   4ece3:	4c 89 fe             	mov    %r15,%rsi
   4ece6:	ff 15 54 54 05 00    	call   *0x55454(%rip)        # a4140 <_DYNAMIC+0x240>
   4ecec:	48 89 94 24 c0 00 00 	mov    %rdx,0xc0(%rsp)
   4ecf3:	00 
   4ecf4:	4c 89 64 24 08       	mov    %r12,0x8(%rsp)
   4ecf9:	48 c7 84 24 e0 00 00 	movq   $0x0,0xe0(%rsp)
   4ed00:	00 00 00 00 00 
   4ed05:	48 8d bc 24 e0 00 00 	lea    0xe0(%rsp),%rdi
   4ed0c:	00 
   4ed0d:	41 bc 40 00 00 00    	mov    $0x40,%r12d
   4ed13:	be 40 00 00 00       	mov    $0x40,%esi
   4ed18:	4c 89 fa             	mov    %r15,%rdx
   4ed1b:	ff 15 cf 53 05 00    	call   *0x553cf(%rip)        # a40f0 <posix_memalign@GLIBC_2.2.5>
   4ed21:	85 c0                	test   %eax,%eax
   4ed23:	75 bb                	jne    4ece0 <policy_confirmation::trial::<fastest_bloom_filter::split64::Split64BloomFilter>+0x2a0>
   4ed25:	4c 8b b4 24 e0 00 00 	mov    0xe0(%rsp),%r14
   4ed2c:	00 
   4ed2d:	4d 85 f6             	test   %r14,%r14
   4ed30:	74 ae                	je     4ece0 <policy_confirmation::trial::<fastest_bloom_filter::split64::Split64BloomFilter>+0x2a0>
   4ed32:	48 c1 ed 04          	shr    $0x4,%rbp
   4ed36:	49 8d 57 c0          	lea    -0x40(%r15),%rdx
   4ed3a:	4c 89 f7             	mov    %r14,%rdi
   4ed3d:	31 f6                	xor    %esi,%esi
   4ed3f:	ff 15 d3 53 05 00    	call   *0x553d3(%rip)        # a4118 <memset@GLIBC_2.2.5>
   4ed45:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
   4ed49:	c4 81 7d 7f 44 37 c0 	vmovdqa %ymm0,-0x40(%r15,%r14,1)
   4ed50:	c4 81 7d 7f 44 37 e0 	vmovdqa %ymm0,-0x20(%r15,%r14,1)
   4ed57:	8d 45 ff             	lea    -0x1(%rbp),%eax
   4ed5a:	48 89 6c 24 10       	mov    %rbp,0x10(%rsp)
   4ed5f:	4c 89 b4 24 d8 00 00 	mov    %r14,0xd8(%rsp)
   4ed66:	00 
   4ed67:	4c 89 74 24 18       	mov    %r14,0x18(%rsp)
   4ed6c:	48 89 6c 24 20       	mov    %rbp,0x20(%rsp)
   4ed71:	89 44 24 60          	mov    %eax,0x60(%rsp)
   4ed75:	89 44 24 28          	mov    %eax,0x28(%rsp)
   4ed79:	66 c7 44 24 2c 01 01 	movw   $0x101,0x2c(%rsp)
   4ed80:	48 8d bc 24 e0 00 00 	lea    0xe0(%rsp),%rdi
   4ed87:	00 
   4ed88:	48 89 ee             	mov    %rbp,%rsi
   4ed8b:	4c 89 6c 24 38       	mov    %r13,0x38(%rsp)
   4ed90:	4c 89 ea             	mov    %r13,%rdx
   4ed93:	c5 f8 77             	vzeroupper
   4ed96:	e8 05 2e 00 00       	call   51ba0 <policy_confirmation::observe::<fastest_bloom_filter::split64::Split64BloomFilter>>
   4ed9b:	48 8b 84 24 f0 00 00 	mov    0xf0(%rsp),%rax
   4eda2:	00 
   4eda3:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
   4eda8:	48 89 41 70          	mov    %rax,0x70(%rcx)
   4edac:	c5 fa 6f 84 24 e0 00 	vmovdqu 0xe0(%rsp),%xmm0
   4edb3:	00 00 
   4edb5:	c5 fa 7f 41 60       	vmovdqu %xmm0,0x60(%rcx)
   4edba:	ff 15 68 59 05 00    	call   *0x55968(%rip)        # a4728 <_DYNAMIC+0x828>
   4edc0:	48 89 5c 24 40       	mov    %rbx,0x40(%rsp)
   4edc5:	48 89 84 24 b0 00 00 	mov    %rax,0xb0(%rsp)
   4edcc:	00 
   4edcd:	89 94 24 b8 00 00 00 	mov    %edx,0xb8(%rsp)
   4edd4:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
   4edd9:	48 8b 58 38          	mov    0x38(%rax),%rbx
   4eddd:	48 8b 40 48          	mov    0x48(%rax),%rax
   4ede1:	48 89 44 24 78       	mov    %rax,0x78(%rsp)
   4ede6:	48 8d bc 24 e0 00 00 	lea    0xe0(%rsp),%rdi
   4eded:	00 
   4edee:	ba 00 80 00 00       	mov    $0x8000,%edx
   4edf3:	31 f6                	xor    %esi,%esi
   4edf5:	ff 15 1d 53 05 00    	call   *0x5531d(%rip)        # a4118 <memset@GLIBC_2.2.5>
   4edfb:	48 89 5c 24 48       	mov    %rbx,0x48(%rsp)
   4ee00:	48 85 db             	test   %rbx,%rbx
   4ee03:	0f 84 22 04 00 00    	je     4f22b <policy_confirmation::trial::<fastest_bloom_filter::split64::Split64BloomFilter>+0x7eb>
   4ee09:	48 8b 5c 24 48       	mov    0x48(%rsp),%rbx
   4ee0e:	49 89 dc             	mov    %rbx,%r12
   4ee11:	49 c1 ec 0c          	shr    $0xc,%r12
   4ee15:	89 d8                	mov    %ebx,%eax
   4ee17:	25 ff 0f 00 00       	and    $0xfff,%eax
   4ee1c:	48 83 f8 01          	cmp    $0x1,%rax
   4ee20:	49 83 dc ff          	sbb    $0xffffffffffffffff,%r12
   4ee24:	45 31 f6             	xor    %r14d,%r14d
   4ee27:	4c 8b 7c 24 78       	mov    0x78(%rsp),%r15
   4ee2c:	45 31 ed             	xor    %r13d,%r13d
   4ee2f:	90                   	nop
   4ee30:	48 81 fb 00 10 00 00 	cmp    $0x1000,%rbx
   4ee37:	b9 00 10 00 00       	mov    $0x1000,%ecx
   4ee3c:	48 0f 42 cb          	cmovb  %rbx,%rcx
   4ee40:	4c 89 f0             	mov    %r14,%rax
   4ee43:	48 c1 e0 0c          	shl    $0xc,%rax
   4ee47:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
   4ee4c:	48 89 f2             	mov    %rsi,%rdx
   4ee4f:	48 29 c2             	sub    %rax,%rdx
   4ee52:	48 81 fa 00 10 00 00 	cmp    $0x1000,%rdx
   4ee59:	bf 00 10 00 00       	mov    $0x1000,%edi
   4ee5e:	48 0f 43 d7          	cmovae %rdi,%rdx
   4ee62:	48 89 f0             	mov    %rsi,%rax
   4ee65:	4c 29 e8             	sub    %r13,%rax
   4ee68:	48 3d 00 10 00 00    	cmp    $0x1000,%rax
   4ee6e:	48 0f 43 c7          	cmovae %rdi,%rax
   4ee72:	4c 39 ee             	cmp    %r13,%rsi
   4ee75:	0f 84 4a 03 00 00    	je     4f1c5 <policy_confirmation::trial::<fastest_bloom_filter::split64::Split64BloomFilter>+0x785>
   4ee7b:	48 ff ca             	dec    %rdx
   4ee7e:	40 b6 3d             	mov    $0x3d,%sil
   4ee81:	c4 e2 c8 f5 fa       	bzhi   %rsi,%rdx,%rdi
   4ee86:	48 83 ff 03          	cmp    $0x3,%rdi
   4ee8a:	73 34                	jae    4eec0 <policy_confirmation::trial::<fastest_bloom_filter::split64::Split64BloomFilter>+0x480>
   4ee8c:	31 c9                	xor    %ecx,%ecx
   4ee8e:	48 8d bc 24 e0 00 00 	lea    0xe0(%rsp),%rdi
   4ee95:	00 
   4ee96:	49 b9 b9 e5 e4 1c 6d 	movabs $0xbf58476d1ce4e5b9,%r9
   4ee9d:	47 58 bf 
   4eea0:	49 ba eb 11 31 13 bb 	movabs $0x94d049bb133111eb,%r10
   4eea7:	49 d0 94 
   4eeaa:	49 bb 15 7c 4a 7f b9 	movabs $0x9e3779b97f4a7c15,%r11
   4eeb1:	79 37 9e 
   4eeb4:	e9 a6 02 00 00       	jmp    4f15f <policy_confirmation::trial::<fastest_bloom_filter::split64::Split64BloomFilter>+0x71f>
   4eeb9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
   4eec0:	48 ff c9             	dec    %rcx
   4eec3:	c4 e2 c8 f5 d1       	bzhi   %rsi,%rcx,%rdx
   4eec8:	48 ff c2             	inc    %rdx
   4eecb:	48 8d 77 01          	lea    0x1(%rdi),%rsi
   4eecf:	48 8b 4c 24 78       	mov    0x78(%rsp),%rcx
   4eed4:	4c 01 e9             	add    %r13,%rcx
   4eed7:	62 f2 fd 28 7c c1    	vpbroadcastq %rcx,%ymm0
   4eedd:	48 83 ff 0f          	cmp    $0xf,%rdi
   4eee1:	73 07                	jae    4eeea <policy_confirmation::trial::<fastest_bloom_filter::split64::Split64BloomFilter>+0x4aa>
   4eee3:	31 c9                	xor    %ecx,%ecx
   4eee5:	e9 9f 01 00 00       	jmp    4f089 <policy_confirmation::trial::<fastest_bloom_filter::split64::Split64BloomFilter>+0x649>
   4eeea:	48 89 d7             	mov    %rdx,%rdi
   4eeed:	48 83 e7 f0          	and    $0xfffffffffffffff0,%rdi
   4eef1:	48 89 f1             	mov    %rsi,%rcx
   4eef4:	49 b8 f0 ff ff ff ff 	movabs $0x3ffffffffffffff0,%r8
   4eefb:	ff ff 3f 
   4eefe:	4c 21 c1             	and    %r8,%rcx
   4ef01:	62 f1 fd 38 d4 0d 3d 	vpaddq -0x44dc3(%rip){1to4},%ymm0,%ymm1        # a148 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x50>
   4ef08:	b2 fb ff 
   4ef0b:	62 f1 fd 38 d4 15 6b 	vpaddq -0x44e95(%rip){1to4},%ymm0,%ymm2        # a080 <anon.25805f450824d4a1248fcaae526abf58.283.llvm.3576388159787090369+0x84>
   4ef12:	b1 fb ff 
   4ef15:	62 f1 fd 38 d4 1d 69 	vpaddq -0x44e97(%rip){1to4},%ymm0,%ymm3        # a088 <anon.25805f450824d4a1248fcaae526abf58.283.llvm.3576388159787090369+0x8c>
   4ef1c:	b1 fb ff 
   4ef1f:	45 31 c0             	xor    %r8d,%r8d
   4ef22:	c5 fd 6f 25 36 b3 fb 	vmovdqa -0x44cca(%rip),%ymm4        # a260 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x168>
   4ef29:	ff 
   4ef2a:	c4 62 7d 59 2d d5 b1 	vpbroadcastq -0x44e2b(%rip),%ymm13        # a108 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x10>
   4ef31:	fb ff 
   4ef33:	c4 62 7d 59 35 8c b1 	vpbroadcastq -0x44e74(%rip),%ymm14        # a0c8 <anon.25805f450824d4a1248fcaae526abf58.283.llvm.3576388159787090369+0xcc>
   4ef3a:	fb ff 
   4ef3c:	c4 62 7d 59 3d 63 b1 	vpbroadcastq -0x44e9d(%rip),%ymm15        # a0a8 <anon.25805f450824d4a1248fcaae526abf58.283.llvm.3576388159787090369+0xac>
   4ef43:	fb ff 
   4ef45:	62 e2 fd 28 59 05 01 	vpbroadcastq -0x44dff(%rip),%ymm16        # a150 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x58>
   4ef4c:	b2 fb ff 
   4ef4f:	62 e2 fd 28 59 0d ff 	vpbroadcastq -0x44e01(%rip),%ymm17        # a158 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x60>
   4ef56:	b1 fb ff 
   4ef59:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
   4ef60:	c5 fd d4 ec          	vpaddq %ymm4,%ymm0,%ymm5
   4ef64:	c5 dd d4 f1          	vpaddq %ymm1,%ymm4,%ymm6
   4ef68:	c5 dd d4 fa          	vpaddq %ymm2,%ymm4,%ymm7
   4ef6c:	c5 5d d4 c3          	vpaddq %ymm3,%ymm4,%ymm8
   4ef70:	62 d2 d5 28 40 ed    	vpmullq %ymm13,%ymm5,%ymm5
   4ef76:	62 d2 cd 28 40 f5    	vpmullq %ymm13,%ymm6,%ymm6
   4ef7c:	62 d2 c5 28 40 fd    	vpmullq %ymm13,%ymm7,%ymm7
   4ef82:	62 52 bd 28 40 c5    	vpmullq %ymm13,%ymm8,%ymm8
   4ef88:	c5 8d d4 ed          	vpaddq %ymm5,%ymm14,%ymm5
   4ef8c:	c5 8d d4 f6          	vpaddq %ymm6,%ymm14,%ymm6
   4ef90:	c5 8d d4 ff          	vpaddq %ymm7,%ymm14,%ymm7
   4ef94:	c4 41 3d d4 c6       	vpaddq %ymm14,%ymm8,%ymm8
   4ef99:	c5 b5 73 d5 1e       	vpsrlq $0x1e,%ymm5,%ymm9
   4ef9e:	c5 ad 73 d6 1e       	vpsrlq $0x1e,%ymm6,%ymm10
   4efa3:	c5 a5 73 d7 1e       	vpsrlq $0x1e,%ymm7,%ymm11
   4efa8:	c4 c1 1d 73 d0 1e    	vpsrlq $0x1e,%ymm8,%ymm12
   4efae:	c5 b5 ef ed          	vpxor  %ymm5,%ymm9,%ymm5
   4efb2:	c5 ad ef f6          	vpxor  %ymm6,%ymm10,%ymm6
   4efb6:	c5 a5 ef ff          	vpxor  %ymm7,%ymm11,%ymm7
   4efba:	c4 41 1d ef c0       	vpxor  %ymm8,%ymm12,%ymm8
   4efbf:	62 d2 d5 28 40 ef    	vpmullq %ymm15,%ymm5,%ymm5
   4efc5:	62 d2 cd 28 40 f7    	vpmullq %ymm15,%ymm6,%ymm6
   4efcb:	62 d2 c5 28 40 ff    	vpmullq %ymm15,%ymm7,%ymm7
   4efd1:	62 52 bd 28 40 c7    	vpmullq %ymm15,%ymm8,%ymm8
   4efd7:	c5 b5 73 d5 1b       	vpsrlq $0x1b,%ymm5,%ymm9
   4efdc:	c5 ad 73 d6 1b       	vpsrlq $0x1b,%ymm6,%ymm10
   4efe1:	c5 a5 73 d7 1b       	vpsrlq $0x1b,%ymm7,%ymm11
   4efe6:	c5 b5 ef ed          	vpxor  %ymm5,%ymm9,%ymm5
   4efea:	c5 ad ef f6          	vpxor  %ymm6,%ymm10,%ymm6
   4efee:	c5 a5 ef ff          	vpxor  %ymm7,%ymm11,%ymm7
   4eff2:	62 b2 d5 28 40 e8    	vpmullq %ymm16,%ymm5,%ymm5
   4eff8:	62 b2 cd 28 40 f0    	vpmullq %ymm16,%ymm6,%ymm6
   4effe:	62 b2 c5 28 40 f8    	vpmullq %ymm16,%ymm7,%ymm7
   4f004:	c4 c1 35 73 d0 1b    	vpsrlq $0x1b,%ymm8,%ymm9
   4f00a:	c4 41 35 ef c0       	vpxor  %ymm8,%ymm9,%ymm8
   4f00f:	62 32 bd 28 40 c0    	vpmullq %ymm16,%ymm8,%ymm8
   4f015:	c5 b5 73 d5 1f       	vpsrlq $0x1f,%ymm5,%ymm9
   4f01a:	c5 ad 73 d6 1f       	vpsrlq $0x1f,%ymm6,%ymm10
   4f01f:	c5 a5 73 d7 1f       	vpsrlq $0x1f,%ymm7,%ymm11
   4f024:	c4 c1 1d 73 d0 1f    	vpsrlq $0x1f,%ymm8,%ymm12
   4f02a:	c5 b5 ef ed          	vpxor  %ymm5,%ymm9,%ymm5
   4f02e:	c5 ad ef f6          	vpxor  %ymm6,%ymm10,%ymm6
   4f032:	c5 a5 ef ff          	vpxor  %ymm7,%ymm11,%ymm7
   4f036:	c4 a1 7e 7f ac c4 e0 	vmovdqu %ymm5,0xe0(%rsp,%r8,8)
   4f03d:	00 00 00 
   4f040:	c4 a1 7e 7f b4 c4 00 	vmovdqu %ymm6,0x100(%rsp,%r8,8)
   4f047:	01 00 00 
   4f04a:	c4 a1 7e 7f bc c4 20 	vmovdqu %ymm7,0x120(%rsp,%r8,8)
   4f051:	01 00 00 
   4f054:	c4 c1 1d ef e8       	vpxor  %ymm8,%ymm12,%ymm5
   4f059:	c4 a1 7e 7f ac c4 40 	vmovdqu %ymm5,0x140(%rsp,%r8,8)
   4f060:	01 00 00 
   4f063:	49 83 c0 10          	add    $0x10,%r8
   4f067:	62 b1 dd 28 d4 e1    	vpaddq %ymm17,%ymm4,%ymm4
   4f06d:	4c 39 c7             	cmp    %r8,%rdi
   4f070:	0f 85 ea fe ff ff    	jne    4ef60 <policy_confirmation::trial::<fastest_bloom_filter::split64::Split64BloomFilter>+0x520>
   4f076:	48 39 ce             	cmp    %rcx,%rsi
   4f079:	0f 84 46 01 00 00    	je     4f1c5 <policy_confirmation::trial::<fastest_bloom_filter::split64::Split64BloomFilter>+0x785>
   4f07f:	40 f6 c6 0c          	test   $0xc,%sil
   4f083:	0f 84 95 01 00 00    	je     4f21e <policy_confirmation::trial::<fastest_bloom_filter::split64::Split64BloomFilter>+0x7de>
   4f089:	49 89 c8             	mov    %rcx,%r8
   4f08c:	48 83 e2 fc          	and    $0xfffffffffffffffc,%rdx
   4f090:	48 b9 f0 ff ff ff ff 	movabs $0x3ffffffffffffff0,%rcx
   4f097:	ff ff 3f 
   4f09a:	48 83 c1 0c          	add    $0xc,%rcx
   4f09e:	48 21 f1             	and    %rsi,%rcx
   4f0a1:	48 8d bc cc e0 00 00 	lea    0xe0(%rsp,%rcx,8),%rdi
   4f0a8:	00 
   4f0a9:	62 d2 fd 28 7c c8    	vpbroadcastq %r8,%ymm1
   4f0af:	c5 f5 eb 0d a9 b1 fb 	vpor   -0x44e57(%rip),%ymm1,%ymm1        # a260 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x168>
   4f0b6:	ff 
   4f0b7:	c4 e2 7d 59 25 48 b0 	vpbroadcastq -0x44fb8(%rip),%ymm4        # a108 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x10>
   4f0be:	fb ff 
   4f0c0:	c4 e2 7d 59 2d ff af 	vpbroadcastq -0x45001(%rip),%ymm5        # a0c8 <anon.25805f450824d4a1248fcaae526abf58.283.llvm.3576388159787090369+0xcc>
   4f0c7:	fb ff 
   4f0c9:	c4 e2 7d 59 35 d6 af 	vpbroadcastq -0x4502a(%rip),%ymm6        # a0a8 <anon.25805f450824d4a1248fcaae526abf58.283.llvm.3576388159787090369+0xac>
   4f0d0:	fb ff 
   4f0d2:	c4 e2 7d 59 3d 75 b0 	vpbroadcastq -0x44f8b(%rip),%ymm7        # a150 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x58>
   4f0d9:	fb ff 
   4f0db:	c4 62 7d 59 05 64 b0 	vpbroadcastq -0x44f9c(%rip),%ymm8        # a148 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x50>
   4f0e2:	fb ff 
   4f0e4:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
   4f0eb:	00 00 00 00 00 
   4f0f0:	c5 fd d4 d1          	vpaddq %ymm1,%ymm0,%ymm2
   4f0f4:	62 f2 ed 28 40 d4    	vpmullq %ymm4,%ymm2,%ymm2
   4f0fa:	c5 ed d4 d5          	vpaddq %ymm5,%ymm2,%ymm2
   4f0fe:	c5 e5 73 d2 1e       	vpsrlq $0x1e,%ymm2,%ymm3
   4f103:	c5 e5 ef d2          	vpxor  %ymm2,%ymm3,%ymm2
   4f107:	62 f2 ed 28 40 d6    	vpmullq %ymm6,%ymm2,%ymm2
   4f10d:	c5 e5 73 d2 1b       	vpsrlq $0x1b,%ymm2,%ymm3
   4f112:	c5 e5 ef d2          	vpxor  %ymm2,%ymm3,%ymm2
   4f116:	62 f2 ed 28 40 d7    	vpmullq %ymm7,%ymm2,%ymm2
   4f11c:	c5 e5 73 d2 1f       	vpsrlq $0x1f,%ymm2,%ymm3
   4f121:	c5 e5 ef d2          	vpxor  %ymm2,%ymm3,%ymm2
   4f125:	c4 a1 7e 7f 94 c4 e0 	vmovdqu %ymm2,0xe0(%rsp,%r8,8)
   4f12c:	00 00 00 
   4f12f:	49 83 c0 04          	add    $0x4,%r8
   4f133:	c5 bd d4 c9          	vpaddq %ymm1,%ymm8,%ymm1
   4f137:	4c 39 c2             	cmp    %r8,%rdx
   4f13a:	75 b4                	jne    4f0f0 <policy_confirmation::trial::<fastest_bloom_filter::split64::Split64BloomFilter>+0x6b0>
   4f13c:	48 39 ce             	cmp    %rcx,%rsi
   4f13f:	49 b9 b9 e5 e4 1c 6d 	movabs $0xbf58476d1ce4e5b9,%r9
   4f146:	47 58 bf 
   4f149:	49 ba eb 11 31 13 bb 	movabs $0x94d049bb133111eb,%r10
   4f150:	49 d0 94 
   4f153:	49 bb 15 7c 4a 7f b9 	movabs $0x9e3779b97f4a7c15,%r11
   4f15a:	79 37 9e 
   4f15d:	74 66                	je     4f1c5 <policy_confirmation::trial::<fastest_bloom_filter::split64::Split64BloomFilter>+0x785>
   4f15f:	89 c2                	mov    %eax,%edx
   4f161:	48 8d 94 d4 e0 00 00 	lea    0xe0(%rsp,%rdx,8),%rdx
   4f168:	00 
   4f169:	4c 01 f9             	add    %r15,%rcx
   4f16c:	48 be eb 83 b5 80 46 	movabs $0x61c8864680b583eb,%rsi
   4f173:	86 c8 61 
   4f176:	48 0f af ce          	imul   %rsi,%rcx
   4f17a:	48 be e8 84 ed 04 42 	movabs $0xc276e44204ed84e8,%rsi
   4f181:	e4 76 c2 
   4f184:	48 29 ce             	sub    %rcx,%rsi
   4f187:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
   4f18e:	00 00 
   4f190:	48 89 f1             	mov    %rsi,%rcx
   4f193:	48 c1 e9 1e          	shr    $0x1e,%rcx
   4f197:	48 31 f1             	xor    %rsi,%rcx
   4f19a:	49 0f af c9          	imul   %r9,%rcx
   4f19e:	49 89 c8             	mov    %rcx,%r8
   4f1a1:	49 c1 e8 1b          	shr    $0x1b,%r8
   4f1a5:	49 31 c8             	xor    %rcx,%r8
   4f1a8:	4d 0f af c2          	imul   %r10,%r8
   4f1ac:	4c 89 c1             	mov    %r8,%rcx
   4f1af:	48 c1 e9 1f          	shr    $0x1f,%rcx
   4f1b3:	4c 31 c1             	xor    %r8,%rcx
   4f1b6:	48 89 0f             	mov    %rcx,(%rdi)
   4f1b9:	48 83 c7 08          	add    $0x8,%rdi
   4f1bd:	4c 01 de             	add    %r11,%rsi
   4f1c0:	48 39 d7             	cmp    %rdx,%rdi
   4f1c3:	75 cb                	jne    4f190 <policy_confirmation::trial::<fastest_bloom_filter::split64::Split64BloomFilter>+0x750>
   4f1c5:	48 8b bc 24 d8 00 00 	mov    0xd8(%rsp),%rdi
   4f1cc:	00 
   4f1cd:	48 89 ee             	mov    %rbp,%rsi
   4f1d0:	31 d2                	xor    %edx,%edx
   4f1d2:	8b 4c 24 60          	mov    0x60(%rsp),%ecx
   4f1d6:	41 b8 01 00 00 00    	mov    $0x1,%r8d
   4f1dc:	41 b9 01 00 00 00    	mov    $0x1,%r9d
   4f1e2:	50                   	push   %rax
   4f1e3:	48 8d 84 24 e8 00 00 	lea    0xe8(%rsp),%rax
   4f1ea:	00 
   4f1eb:	50                   	push   %rax
   4f1ec:	c5 f8 77             	vzeroupper
   4f1ef:	e8 dc 42 ff ff       	call   434d0 <<fastest_bloom_filter::split64::Split64BloomFilter>::insert_into>
   4f1f4:	48 83 c4 10          	add    $0x10,%rsp
   4f1f8:	49 81 c5 00 10 00 00 	add    $0x1000,%r13
   4f1ff:	49 ff cc             	dec    %r12
   4f202:	49 ff c6             	inc    %r14
   4f205:	48 81 c3 00 f0 ff ff 	add    $0xfffffffffffff000,%rbx
   4f20c:	49 81 c7 00 10 00 00 	add    $0x1000,%r15
   4f213:	4d 85 e4             	test   %r12,%r12
   4f216:	0f 85 14 fc ff ff    	jne    4ee30 <policy_confirmation::trial::<fastest_bloom_filter::split64::Split64BloomFilter>+0x3f0>
   4f21c:	eb 0d                	jmp    4f22b <policy_confirmation::trial::<fastest_bloom_filter::split64::Split64BloomFilter>+0x7eb>
   4f21e:	48 8d bc cc e0 00 00 	lea    0xe0(%rsp,%rcx,8),%rdi
   4f225:	00 
   4f226:	e9 6b fc ff ff       	jmp    4ee96 <policy_confirmation::trial::<fastest_bloom_filter::split64::Split64BloomFilter>+0x456>
   4f22b:	48 8d bc 24 b0 00 00 	lea    0xb0(%rsp),%rdi
   4f232:	00 
   4f233:	ff 15 f7 54 05 00    	call   *0x554f7(%rip)        # a4730 <_DYNAMIC+0x830>
   4f239:	48 8b 5c 24 40       	mov    0x40(%rsp),%rbx
   4f23e:	49 89 c6             	mov    %rax,%r14
   4f241:	89 d5                	mov    %edx,%ebp
   4f243:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
   4f247:	c5 fe 7f 84 24 40 01 	vmovdqu %ymm0,0x140(%rsp)
   4f24e:	00 00 
   4f250:	c5 fe 7f 84 24 20 01 	vmovdqu %ymm0,0x120(%rsp)
   4f257:	00 00 
   4f259:	c5 fe 7f 84 24 00 01 	vmovdqu %ymm0,0x100(%rsp)
   4f260:	00 00 
   4f262:	c5 fe 7f 84 24 e0 00 	vmovdqu %ymm0,0xe0(%rsp)
   4f269:	00 00 
   4f26b:	48 8b bc 24 c8 00 00 	mov    0xc8(%rsp),%rdi
   4f272:	00 
   4f273:	48 c1 e7 03          	shl    $0x3,%rdi
   4f277:	31 c0                	xor    %eax,%eax
   4f279:	b9 01 00 00 00       	mov    $0x1,%ecx
   4f27e:	66 90                	xchg   %ax,%ax
   4f280:	48 8b 14 03          	mov    (%rbx,%rax,1),%rdx
   4f284:	48 81 fa 00 04 00 00 	cmp    $0x400,%rdx
   4f28b:	0f 83 4c 04 00 00    	jae    4f6dd <policy_confirmation::trial::<fastest_bloom_filter::split64::Split64BloomFilter>+0xc9d>
   4f291:	c4 e2 e9 f7 f1       	shlx   %rdx,%rcx,%rsi
   4f296:	48 c1 ea 06          	shr    $0x6,%rdx
   4f29a:	48 09 b4 d4 e0 00 00 	or     %rsi,0xe0(%rsp,%rdx,8)
   4f2a1:	00 
   4f2a2:	48 83 c0 08          	add    $0x8,%rax
   4f2a6:	48 39 c7             	cmp    %rax,%rdi
   4f2a9:	75 d5                	jne    4f280 <policy_confirmation::trial::<fastest_bloom_filter::split64::Split64BloomFilter>+0x840>
   4f2ab:	48 8d 94 24 e0 00 00 	lea    0xe0(%rsp),%rdx
   4f2b2:	00 
   4f2b3:	be 80 00 00 00       	mov    $0x80,%esi
   4f2b8:	31 ff                	xor    %edi,%edi
   4f2ba:	c5 f8 77             	vzeroupper
   4f2bd:	ff 15 5d 54 05 00    	call   *0x5545d(%rip)        # a4720 <sched_setaffinity@GLIBC_2.3.4>
   4f2c3:	89 44 24 50          	mov    %eax,0x50(%rsp)
   4f2c7:	85 c0                	test   %eax,%eax
   4f2c9:	0f 85 2c 05 00 00    	jne    4f7fb <policy_confirmation::trial::<fastest_bloom_filter::split64::Split64BloomFilter>+0xdbb>
   4f2cf:	ff 15 53 54 05 00    	call   *0x55453(%rip)        # a4728 <_DYNAMIC+0x828>
   4f2d5:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
   4f2da:	89 54 24 58          	mov    %edx,0x58(%rsp)
   4f2de:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
   4f2e3:	c5 fa 6f 40 08       	vmovdqu 0x8(%rax),%xmm0
   4f2e8:	c5 fa 7f 84 24 e0 00 	vmovdqu %xmm0,0xe0(%rsp)
   4f2ef:	00 00 
   4f2f1:	48 8d 84 24 e0 00 00 	lea    0xe0(%rsp),%rax
   4f2f8:	00 
   4f2f9:	48 8b b4 24 e0 00 00 	mov    0xe0(%rsp),%rsi
   4f300:	00 
   4f301:	48 8b 94 24 e8 00 00 	mov    0xe8(%rsp),%rdx
   4f308:	00 
   4f309:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
   4f30e:	48 8b 48 30          	mov    0x30(%rax),%rcx
   4f312:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
   4f317:	ff 15 d3 52 05 00    	call   *0x552d3(%rip)        # a45f0 <_DYNAMIC+0x6f0>
   4f31d:	48 8d 7c 24 50       	lea    0x50(%rsp),%rdi
   4f322:	ff 15 08 54 05 00    	call   *0x55408(%rip)        # a4730 <_DYNAMIC+0x830>
   4f328:	49 89 c5             	mov    %rax,%r13
   4f32b:	48 8b 03             	mov    (%rbx),%rax
   4f32e:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
   4f332:	c5 fe 7f 84 24 40 01 	vmovdqu %ymm0,0x140(%rsp)
   4f339:	00 00 
   4f33b:	c5 fe 7f 84 24 20 01 	vmovdqu %ymm0,0x120(%rsp)
   4f342:	00 00 
   4f344:	c5 fe 7f 84 24 00 01 	vmovdqu %ymm0,0x100(%rsp)
   4f34b:	00 00 
   4f34d:	c5 fe 7f 84 24 e0 00 	vmovdqu %ymm0,0xe0(%rsp)
   4f354:	00 00 
   4f356:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
   4f35c:	0f 87 7b 03 00 00    	ja     4f6dd <policy_confirmation::trial::<fastest_bloom_filter::split64::Split64BloomFilter>+0xc9d>
   4f362:	41 89 d4             	mov    %edx,%r12d
   4f365:	b9 01 00 00 00       	mov    $0x1,%ecx
   4f36a:	c4 e2 f9 f7 c9       	shlx   %rax,%rcx,%rcx
   4f36f:	48 c1 e8 06          	shr    $0x6,%rax
   4f373:	48 09 8c c4 e0 00 00 	or     %rcx,0xe0(%rsp,%rax,8)
   4f37a:	00 
   4f37b:	48 8d 94 24 e0 00 00 	lea    0xe0(%rsp),%rdx
   4f382:	00 
   4f383:	be 80 00 00 00       	mov    $0x80,%esi
   4f388:	31 ff                	xor    %edi,%edi
   4f38a:	c5 f8 77             	vzeroupper
   4f38d:	ff 15 8d 53 05 00    	call   *0x5538d(%rip)        # a4720 <sched_setaffinity@GLIBC_2.3.4>
   4f393:	89 44 24 64          	mov    %eax,0x64(%rsp)
   4f397:	85 c0                	test   %eax,%eax
   4f399:	0f 85 84 04 00 00    	jne    4f823 <policy_confirmation::trial::<fastest_bloom_filter::split64::Split64BloomFilter>+0xde3>
   4f39f:	b8 00 ca 9a 3b       	mov    $0x3b9aca00,%eax
   4f3a4:	4c 89 ea             	mov    %r13,%rdx
   4f3a7:	c4 62 fb f6 f8       	mulx   %rax,%rax,%r15
   4f3ac:	44 89 e3             	mov    %r12d,%ebx
   4f3af:	48 01 c3             	add    %rax,%rbx
   4f3b2:	49 83 d7 00          	adc    $0x0,%r15
   4f3b6:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
   4f3bb:	4c 8b 60 10          	mov    0x10(%rax),%r12
   4f3bf:	4c 3b 20             	cmp    (%rax),%r12
   4f3c2:	75 0a                	jne    4f3ce <policy_confirmation::trial::<fastest_bloom_filter::split64::Split64BloomFilter>+0x98e>
   4f3c4:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
   4f3c9:	e8 c2 03 01 00       	call   5f790 <<alloc::raw_vec::RawVec<u128>>::grow_one>
   4f3ce:	4c 89 e0             	mov    %r12,%rax
   4f3d1:	48 c1 e0 04          	shl    $0x4,%rax
   4f3d5:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
   4f3da:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
   4f3de:	4c 89 7c 01 08       	mov    %r15,0x8(%rcx,%rax,1)
   4f3e3:	49 ff c4             	inc    %r12
   4f3e6:	48 89 1c 01          	mov    %rbx,(%rcx,%rax,1)
   4f3ea:	4c 89 62 10          	mov    %r12,0x10(%rdx)
   4f3ee:	48 89 d1             	mov    %rdx,%rcx
   4f3f1:	48 83 7c 24 48 00    	cmpq   $0x0,0x48(%rsp)
   4f3f7:	0f 84 44 02 00 00    	je     4f641 <policy_confirmation::trial::<fastest_bloom_filter::split64::Split64BloomFilter>+0xc01>
   4f3fd:	b8 00 ca 9a 3b       	mov    $0x3b9aca00,%eax
   4f402:	4c 89 f2             	mov    %r14,%rdx
   4f405:	c4 62 fb f6 f0       	mulx   %rax,%rax,%r14
   4f40a:	89 eb                	mov    %ebp,%ebx
   4f40c:	48 01 c3             	add    %rax,%rbx
   4f40f:	49 83 d6 00          	adc    $0x0,%r14
   4f413:	4c 8b 79 40          	mov    0x40(%rcx),%r15
   4f417:	4c 3b 79 30          	cmp    0x30(%rcx),%r15
   4f41b:	0f 84 2f 02 00 00    	je     4f650 <policy_confirmation::trial::<fastest_bloom_filter::split64::Split64BloomFilter>+0xc10>
   4f421:	e9 38 02 00 00       	jmp    4f65e <policy_confirmation::trial::<fastest_bloom_filter::split64::Split64BloomFilter>+0xc1e>
   4f426:	4c 89 e5             	mov    %r12,%rbp
   4f429:	48 c7 84 24 e0 00 00 	movq   $0x0,0xe0(%rsp)
   4f430:	00 00 00 00 00 
   4f435:	48 8d bc 24 e0 00 00 	lea    0xe0(%rsp),%rdi
   4f43c:	00 
   4f43d:	41 bf 40 00 00 00    	mov    $0x40,%r15d
   4f443:	be 40 00 00 00       	mov    $0x40,%esi
   4f448:	4c 89 f2             	mov    %r14,%rdx
   4f44b:	ff 15 9f 4c 05 00    	call   *0x54c9f(%rip)        # a40f0 <posix_memalign@GLIBC_2.2.5>
   4f451:	85 c0                	test   %eax,%eax
   4f453:	0f 85 eb f7 ff ff    	jne    4ec44 <policy_confirmation::trial::<fastest_bloom_filter::split64::Split64BloomFilter>+0x204>
   4f459:	4c 8b a4 24 e0 00 00 	mov    0xe0(%rsp),%r12
   4f460:	00 
   4f461:	4d 85 e4             	test   %r12,%r12
   4f464:	0f 84 da f7 ff ff    	je     4ec44 <policy_confirmation::trial::<fastest_bloom_filter::split64::Split64BloomFilter>+0x204>
   4f46a:	48 c1 eb 04          	shr    $0x4,%rbx
   4f46e:	49 8d 56 c0          	lea    -0x40(%r14),%rdx
   4f472:	4c 89 e7             	mov    %r12,%rdi
   4f475:	31 f6                	xor    %esi,%esi
   4f477:	ff 15 9b 4c 05 00    	call   *0x54c9b(%rip)        # a4118 <memset@GLIBC_2.2.5>
   4f47d:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
   4f481:	c4 81 7d 7f 44 26 c0 	vmovdqa %ymm0,-0x40(%r14,%r12,1)
   4f488:	c4 81 7d 7f 44 26 e0 	vmovdqa %ymm0,-0x20(%r14,%r12,1)
   4f48f:	8d 43 ff             	lea    -0x1(%rbx),%eax
   4f492:	48 89 5c 24 10       	mov    %rbx,0x10(%rsp)
   4f497:	4c 89 64 24 18       	mov    %r12,0x18(%rsp)
   4f49c:	48 89 5c 24 20       	mov    %rbx,0x20(%rsp)
   4f4a1:	89 44 24 28          	mov    %eax,0x28(%rsp)
   4f4a5:	66 c7 44 24 2c 01 01 	movw   $0x101,0x2c(%rsp)
   4f4ac:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
   4f4b1:	c5 fa 6f 40 08       	vmovdqu 0x8(%rax),%xmm0
   4f4b6:	c5 fa 7f 84 24 e0 00 	vmovdqu %xmm0,0xe0(%rsp)
   4f4bd:	00 00 
   4f4bf:	48 8d 84 24 e0 00 00 	lea    0xe0(%rsp),%rax
   4f4c6:	00 
   4f4c7:	48 8b b4 24 e0 00 00 	mov    0xe0(%rsp),%rsi
   4f4ce:	00 
   4f4cf:	48 8b 94 24 e8 00 00 	mov    0xe8(%rsp),%rdx
   4f4d6:	00 
   4f4d7:	49 8b 4d 30          	mov    0x30(%r13),%rcx
   4f4db:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
   4f4e0:	c5 f8 77             	vzeroupper
   4f4e3:	ff 15 07 51 05 00    	call   *0x55107(%rip)        # a45f0 <_DYNAMIC+0x6f0>
   4f4e9:	49 89 ec             	mov    %rbp,%r12
   4f4ec:	48 8d 7c 24 50       	lea    0x50(%rsp),%rdi
   4f4f1:	ff 15 39 52 05 00    	call   *0x55239(%rip)        # a4730 <_DYNAMIC+0x830>
   4f4f7:	49 89 c6             	mov    %rax,%r14
   4f4fa:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
   4f4ff:	48 8b 00             	mov    (%rax),%rax
   4f502:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
   4f506:	c5 fe 7f 84 24 40 01 	vmovdqu %ymm0,0x140(%rsp)
   4f50d:	00 00 
   4f50f:	c5 fe 7f 84 24 20 01 	vmovdqu %ymm0,0x120(%rsp)
   4f516:	00 00 
   4f518:	c5 fe 7f 84 24 00 01 	vmovdqu %ymm0,0x100(%rsp)
   4f51f:	00 00 
   4f521:	c5 fe 7f 84 24 e0 00 	vmovdqu %ymm0,0xe0(%rsp)
   4f528:	00 00 
   4f52a:	48 3d 00 04 00 00    	cmp    $0x400,%rax
   4f530:	0f 83 cc 02 00 00    	jae    4f802 <policy_confirmation::trial::<fastest_bloom_filter::split64::Split64BloomFilter>+0xdc2>
   4f536:	89 d5                	mov    %edx,%ebp
   4f538:	b9 01 00 00 00       	mov    $0x1,%ecx
   4f53d:	c4 e2 f9 f7 c9       	shlx   %rax,%rcx,%rcx
   4f542:	48 c1 e8 06          	shr    $0x6,%rax
   4f546:	48 09 8c c4 e0 00 00 	or     %rcx,0xe0(%rsp,%rax,8)
   4f54d:	00 
   4f54e:	48 8d 94 24 e0 00 00 	lea    0xe0(%rsp),%rdx
   4f555:	00 
   4f556:	be 80 00 00 00       	mov    $0x80,%esi
   4f55b:	31 ff                	xor    %edi,%edi
   4f55d:	c5 f8 77             	vzeroupper
   4f560:	ff 15 ba 51 05 00    	call   *0x551ba(%rip)        # a4720 <sched_setaffinity@GLIBC_2.3.4>
   4f566:	89 84 24 b0 00 00 00 	mov    %eax,0xb0(%rsp)
   4f56d:	85 c0                	test   %eax,%eax
   4f56f:	0f 85 fd 02 00 00    	jne    4f872 <policy_confirmation::trial::<fastest_bloom_filter::split64::Split64BloomFilter>+0xe32>
   4f575:	b8 00 ca 9a 3b       	mov    $0x3b9aca00,%eax
   4f57a:	4c 89 f2             	mov    %r14,%rdx
   4f57d:	c4 62 fb f6 f0       	mulx   %rax,%rax,%r14
   4f582:	89 eb                	mov    %ebp,%ebx
   4f584:	48 01 c3             	add    %rax,%rbx
   4f587:	49 83 d6 00          	adc    $0x0,%r14
   4f58b:	4d 8b 7c 24 28       	mov    0x28(%r12),%r15
   4f590:	4d 3b 7c 24 18       	cmp    0x18(%r12),%r15
   4f595:	75 0a                	jne    4f5a1 <policy_confirmation::trial::<fastest_bloom_filter::split64::Split64BloomFilter>+0xb61>
   4f597:	49 8d 7c 24 18       	lea    0x18(%r12),%rdi
   4f59c:	e8 ef 01 01 00       	call   5f790 <<alloc::raw_vec::RawVec<u128>>::grow_one>
   4f5a1:	49 8b 44 24 20       	mov    0x20(%r12),%rax
   4f5a6:	4c 89 f9             	mov    %r15,%rcx
   4f5a9:	48 c1 e1 04          	shl    $0x4,%rcx
   4f5ad:	4c 89 74 08 08       	mov    %r14,0x8(%rax,%rcx,1)
   4f5b2:	48 89 1c 08          	mov    %rbx,(%rax,%rcx,1)
   4f5b6:	49 ff c7             	inc    %r15
   4f5b9:	4d 89 7c 24 28       	mov    %r15,0x28(%r12)
   4f5be:	49 8b 5c 24 58       	mov    0x58(%r12),%rbx
   4f5c3:	49 3b 5c 24 48       	cmp    0x48(%r12),%rbx
   4f5c8:	75 0a                	jne    4f5d4 <policy_confirmation::trial::<fastest_bloom_filter::split64::Split64BloomFilter>+0xb94>
   4f5ca:	49 8d 7c 24 48       	lea    0x48(%r12),%rdi
   4f5cf:	e8 bc 01 01 00       	call   5f790 <<alloc::raw_vec::RawVec<u128>>::grow_one>
   4f5d4:	49 8b 44 24 50       	mov    0x50(%r12),%rax
   4f5d9:	48 89 d9             	mov    %rbx,%rcx
   4f5dc:	48 c1 e1 04          	shl    $0x4,%rcx
   4f5e0:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
   4f5e4:	c5 f9 7f 04 08       	vmovdqa %xmm0,(%rax,%rcx,1)
   4f5e9:	48 ff c3             	inc    %rbx
   4f5ec:	49 89 5c 24 58       	mov    %rbx,0x58(%r12)
   4f5f1:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
   4f5f6:	48 8d bc 24 e0 00 00 	lea    0xe0(%rsp),%rdi
   4f5fd:	00 
   4f5fe:	4c 89 ea             	mov    %r13,%rdx
   4f601:	e8 9a 25 00 00       	call   51ba0 <policy_confirmation::observe::<fastest_bloom_filter::split64::Split64BloomFilter>>
   4f606:	48 8b 84 24 f0 00 00 	mov    0xf0(%rsp),%rax
   4f60d:	00 
   4f60e:	49 89 44 24 70       	mov    %rax,0x70(%r12)
   4f613:	c5 fa 6f 84 24 e0 00 	vmovdqu 0xe0(%rsp),%xmm0
   4f61a:	00 00 
   4f61c:	c4 c1 7a 7f 44 24 60 	vmovdqu %xmm0,0x60(%r12)
   4f623:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
   4f628:	4c 89 ee             	mov    %r13,%rsi
   4f62b:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
   4f630:	48 8b 4c 24 68       	mov    0x68(%rsp),%rcx
   4f635:	4c 8b 44 24 70       	mov    0x70(%rsp),%r8
   4f63a:	e8 a1 52 00 00       	call   548e0 <policy_confirmation::validate::<fastest_bloom_filter::split64::Split64BloomFilter>>
   4f63f:	eb 5b                	jmp    4f69c <policy_confirmation::trial::<fastest_bloom_filter::split64::Split64BloomFilter>+0xc5c>
   4f641:	31 db                	xor    %ebx,%ebx
   4f643:	45 31 f6             	xor    %r14d,%r14d
   4f646:	4c 8b 79 40          	mov    0x40(%rcx),%r15
   4f64a:	4c 3b 79 30          	cmp    0x30(%rcx),%r15
   4f64e:	75 0e                	jne    4f65e <policy_confirmation::trial::<fastest_bloom_filter::split64::Split64BloomFilter>+0xc1e>
   4f650:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
   4f655:	48 8d 78 30          	lea    0x30(%rax),%rdi
   4f659:	e8 32 01 01 00       	call   5f790 <<alloc::raw_vec::RawVec<u128>>::grow_one>
   4f65e:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
   4f663:	48 8b 42 38          	mov    0x38(%rdx),%rax
   4f667:	4c 89 f9             	mov    %r15,%rcx
   4f66a:	48 c1 e1 04          	shl    $0x4,%rcx
   4f66e:	4c 89 74 08 08       	mov    %r14,0x8(%rax,%rcx,1)
   4f673:	48 89 1c 08          	mov    %rbx,(%rax,%rcx,1)
   4f677:	49 ff c7             	inc    %r15
   4f67a:	4c 89 7a 40          	mov    %r15,0x40(%rdx)
   4f67e:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
   4f683:	48 8b 74 24 38       	mov    0x38(%rsp),%rsi
   4f688:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
   4f68d:	48 8b 4c 24 68       	mov    0x68(%rsp),%rcx
   4f692:	4c 8b 44 24 70       	mov    0x70(%rsp),%r8
   4f697:	e8 44 52 00 00       	call   548e0 <policy_confirmation::validate::<fastest_bloom_filter::split64::Split64BloomFilter>>
   4f69c:	48 83 7c 24 10 00    	cmpq   $0x0,0x10(%rsp)
   4f6a2:	74 0b                	je     4f6af <policy_confirmation::trial::<fastest_bloom_filter::split64::Split64BloomFilter>+0xc6f>
   4f6a4:	48 8b 7c 24 18       	mov    0x18(%rsp),%rdi
   4f6a9:	ff 15 49 4a 05 00    	call   *0x54a49(%rip)        # a40f8 <free@GLIBC_2.2.5>
   4f6af:	48 81 c4 e8 80 00 00 	add    $0x80e8,%rsp
   4f6b6:	5b                   	pop    %rbx
   4f6b7:	41 5c                	pop    %r12
   4f6b9:	41 5d                	pop    %r13
   4f6bb:	41 5e                	pop    %r14
   4f6bd:	41 5f                	pop    %r15
   4f6bf:	5d                   	pop    %rbp
   4f6c0:	c3                   	ret
   4f6c1:	48 8d 3d 8d d0 fb ff 	lea    -0x42f73(%rip),%rdi        # c755 <panic_unwind::imp::CANARY+0x5a9>
   4f6c8:	48 8d 15 d9 28 05 00 	lea    0x528d9(%rip),%rdx        # a1fa8 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.1797.llvm.15448142832521594973+0xb80>
   4f6cf:	be 1c 00 00 00       	mov    $0x1c,%esi
   4f6d4:	c5 f8 77             	vzeroupper
   4f6d7:	ff 15 2b 4c 05 00    	call   *0x54c2b(%rip)        # a4308 <_DYNAMIC+0x408>
   4f6dd:	48 8d 3d 71 d0 fb ff 	lea    -0x42f8f(%rip),%rdi        # c755 <panic_unwind::imp::CANARY+0x5a9>
   4f6e4:	48 8d 15 bd 28 05 00 	lea    0x528bd(%rip),%rdx        # a1fa8 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.1797.llvm.15448142832521594973+0xb80>
   4f6eb:	be 1c 00 00 00       	mov    $0x1c,%esi
   4f6f0:	c5 f8 77             	vzeroupper
   4f6f3:	ff 15 0f 4c 05 00    	call   *0x54c0f(%rip)        # a4308 <_DYNAMIC+0x408>
   4f6f9:	e9 ce 01 00 00       	jmp    4f8cc <policy_confirmation::trial::<fastest_bloom_filter::split64::Split64BloomFilter>+0xe8c>
   4f6fe:	48 8d 05 bb 28 05 00 	lea    0x528bb(%rip),%rax        # a1fc0 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.1797.llvm.15448142832521594973+0xb98>
   4f705:	48 89 84 24 80 00 00 	mov    %rax,0x80(%rsp)
   4f70c:	00 
   4f70d:	48 c7 84 24 88 00 00 	movq   $0x1,0x88(%rsp)
   4f714:	00 01 00 00 00 
   4f719:	48 c7 84 24 90 00 00 	movq   $0x8,0x90(%rsp)
   4f720:	00 08 00 00 00 
   4f725:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
   4f729:	c5 fa 7f 84 24 98 00 	vmovdqu %xmm0,0x98(%rsp)
   4f730:	00 00 
   4f732:	48 8d 15 8f a8 fb ff 	lea    -0x45771(%rip),%rdx        # 9fc8 <anon.25805f450824d4a1248fcaae526abf58.318.llvm.3576388159787090369+0x6c>
   4f739:	4c 8d 05 90 28 05 00 	lea    0x52890(%rip),%r8        # a1fd0 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.1797.llvm.15448142832521594973+0xba8>
   4f740:	48 8d 74 24 10       	lea    0x10(%rsp),%rsi
   4f745:	48 8d 8c 24 80 00 00 	lea    0x80(%rsp),%rcx
   4f74c:	00 
   4f74d:	31 ff                	xor    %edi,%edi
   4f74f:	ff 15 e3 4f 05 00    	call   *0x54fe3(%rip)        # a4738 <_DYNAMIC+0x838>
   4f755:	48 8d 3d f9 cf fb ff 	lea    -0x43007(%rip),%rdi        # c755 <panic_unwind::imp::CANARY+0x5a9>
   4f75c:	48 8d 15 45 28 05 00 	lea    0x52845(%rip),%rdx        # a1fa8 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.1797.llvm.15448142832521594973+0xb80>
   4f763:	be 1c 00 00 00       	mov    $0x1c,%esi
   4f768:	c5 f8 77             	vzeroupper
   4f76b:	ff 15 97 4b 05 00    	call   *0x54b97(%rip)        # a4308 <_DYNAMIC+0x408>
   4f771:	31 c0                	xor    %eax,%eax
   4f773:	88 84 24 e0 00 00 00 	mov    %al,0xe0(%rsp)
   4f77a:	48 8d 3d 03 d0 fb ff 	lea    -0x42ffd(%rip),%rdi        # c784 <panic_unwind::imp::CANARY+0x5d8>
   4f781:	48 8d 0d 98 28 05 00 	lea    0x52898(%rip),%rcx        # a2020 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.1797.llvm.15448142832521594973+0xbf8>
   4f788:	4c 8d 05 41 29 05 00 	lea    0x52941(%rip),%r8        # a20d0 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.1797.llvm.15448142832521594973+0xca8>
   4f78f:	48 8d 94 24 e0 00 00 	lea    0xe0(%rsp),%rdx
   4f796:	00 
   4f797:	be 2b 00 00 00       	mov    $0x2b,%esi
   4f79c:	ff 15 f6 49 05 00    	call   *0x549f6(%rip)        # a4198 <_DYNAMIC+0x298>
   4f7a2:	48 8d 05 57 23 05 00 	lea    0x52357(%rip),%rax        # a1b00 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.1797.llvm.15448142832521594973+0x6d8>
   4f7a9:	48 89 84 24 e0 00 00 	mov    %rax,0xe0(%rsp)
   4f7b0:	00 
   4f7b1:	48 c7 84 24 e8 00 00 	movq   $0x1,0xe8(%rsp)
   4f7b8:	00 01 00 00 00 
   4f7bd:	48 c7 84 24 f0 00 00 	movq   $0x8,0xf0(%rsp)
   4f7c4:	00 08 00 00 00 
   4f7c9:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
   4f7cd:	c5 fa 7f 84 24 f8 00 	vmovdqu %xmm0,0xf8(%rsp)
   4f7d4:	00 00 
   4f7d6:	49 83 c5 38          	add    $0x38,%r13
   4f7da:	48 8d 15 17 a9 fb ff 	lea    -0x456e9(%rip),%rdx        # a0f8 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973>
   4f7e1:	4c 8d 05 28 23 05 00 	lea    0x52328(%rip),%r8        # a1b10 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.1797.llvm.15448142832521594973+0x6e8>
   4f7e8:	48 8d 8c 24 e0 00 00 	lea    0xe0(%rsp),%rcx
   4f7ef:	00 
   4f7f0:	31 ff                	xor    %edi,%edi
   4f7f2:	4c 89 ee             	mov    %r13,%rsi
   4f7f5:	ff 15 35 4b 05 00    	call   *0x54b35(%rip)        # a4330 <_DYNAMIC+0x430>
   4f7fb:	48 8d 74 24 50       	lea    0x50(%rsp),%rsi
   4f800:	eb 26                	jmp    4f828 <policy_confirmation::trial::<fastest_bloom_filter::split64::Split64BloomFilter>+0xde8>
   4f802:	48 8d 3d 4c cf fb ff 	lea    -0x430b4(%rip),%rdi        # c755 <panic_unwind::imp::CANARY+0x5a9>
   4f809:	48 8d 15 98 27 05 00 	lea    0x52798(%rip),%rdx        # a1fa8 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.1797.llvm.15448142832521594973+0xb80>
   4f810:	be 1c 00 00 00       	mov    $0x1c,%esi
   4f815:	c5 f8 77             	vzeroupper
   4f818:	ff 15 ea 4a 05 00    	call   *0x54aea(%rip)        # a4308 <_DYNAMIC+0x408>
   4f81e:	e9 a9 00 00 00       	jmp    4f8cc <policy_confirmation::trial::<fastest_bloom_filter::split64::Split64BloomFilter>+0xe8c>
   4f823:	48 8d 74 24 64       	lea    0x64(%rsp),%rsi
   4f828:	48 8d 8c 24 80 00 00 	lea    0x80(%rsp),%rcx
   4f82f:	00 
   4f830:	48 8d 05 89 27 05 00 	lea    0x52789(%rip),%rax        # a1fc0 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.1797.llvm.15448142832521594973+0xb98>
   4f837:	48 89 01             	mov    %rax,(%rcx)
   4f83a:	48 c7 41 08 01 00 00 	movq   $0x1,0x8(%rcx)
   4f841:	00 
   4f842:	48 c7 41 10 08 00 00 	movq   $0x8,0x10(%rcx)
   4f849:	00 
   4f84a:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
   4f84e:	48 8b 84 24 c0 00 00 	mov    0xc0(%rsp),%rax
   4f855:	00 
   4f856:	c5 fa 7f 00          	vmovdqu %xmm0,(%rax)
   4f85a:	48 8d 15 67 a7 fb ff 	lea    -0x45899(%rip),%rdx        # 9fc8 <anon.25805f450824d4a1248fcaae526abf58.318.llvm.3576388159787090369+0x6c>
   4f861:	4c 8d 05 68 27 05 00 	lea    0x52768(%rip),%r8        # a1fd0 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.1797.llvm.15448142832521594973+0xba8>
   4f868:	31 ff                	xor    %edi,%edi
   4f86a:	ff 15 c8 4e 05 00    	call   *0x54ec8(%rip)        # a4738 <_DYNAMIC+0x838>
   4f870:	eb 5a                	jmp    4f8cc <policy_confirmation::trial::<fastest_bloom_filter::split64::Split64BloomFilter>+0xe8c>
   4f872:	48 8d 05 47 27 05 00 	lea    0x52747(%rip),%rax        # a1fc0 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.1797.llvm.15448142832521594973+0xb98>
   4f879:	48 89 84 24 80 00 00 	mov    %rax,0x80(%rsp)
   4f880:	00 
   4f881:	48 c7 84 24 88 00 00 	movq   $0x1,0x88(%rsp)
   4f888:	00 01 00 00 00 
   4f88d:	48 c7 84 24 90 00 00 	movq   $0x8,0x90(%rsp)
   4f894:	00 08 00 00 00 
   4f899:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
   4f89d:	c5 fa 7f 84 24 98 00 	vmovdqu %xmm0,0x98(%rsp)
   4f8a4:	00 00 
   4f8a6:	48 8d 15 1b a7 fb ff 	lea    -0x458e5(%rip),%rdx        # 9fc8 <anon.25805f450824d4a1248fcaae526abf58.318.llvm.3576388159787090369+0x6c>
   4f8ad:	4c 8d 05 1c 27 05 00 	lea    0x5271c(%rip),%r8        # a1fd0 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.1797.llvm.15448142832521594973+0xba8>
   4f8b4:	48 8d b4 24 b0 00 00 	lea    0xb0(%rsp),%rsi
   4f8bb:	00 
   4f8bc:	48 8d 8c 24 80 00 00 	lea    0x80(%rsp),%rcx
   4f8c3:	00 
   4f8c4:	31 ff                	xor    %edi,%edi
   4f8c6:	ff 15 6c 4e 05 00    	call   *0x54e6c(%rip)        # a4738 <_DYNAMIC+0x838>
   4f8cc:	0f 0b                	ud2
   4f8ce:	48 8d 15 13 22 05 00 	lea    0x52213(%rip),%rdx        # a1ae8 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.1797.llvm.15448142832521594973+0x6c0>
   4f8d5:	31 ff                	xor    %edi,%edi
   4f8d7:	31 f6                	xor    %esi,%esi
   4f8d9:	ff 15 71 48 05 00    	call   *0x54871(%rip)        # a4150 <_DYNAMIC+0x250>
   4f8df:	b0 01                	mov    $0x1,%al
   4f8e1:	e9 8d fe ff ff       	jmp    4f773 <policy_confirmation::trial::<fastest_bloom_filter::split64::Split64BloomFilter>+0xd33>
   4f8e6:	48 89 c3             	mov    %rax,%rbx
   4f8e9:	eb 0d                	jmp    4f8f8 <policy_confirmation::trial::<fastest_bloom_filter::split64::Split64BloomFilter>+0xeb8>
   4f8eb:	eb 00                	jmp    4f8ed <policy_confirmation::trial::<fastest_bloom_filter::split64::Split64BloomFilter>+0xead>
   4f8ed:	48 89 c3             	mov    %rax,%rbx
   4f8f0:	48 83 7c 24 10 00    	cmpq   $0x0,0x10(%rsp)
   4f8f6:	74 11                	je     4f909 <policy_confirmation::trial::<fastest_bloom_filter::split64::Split64BloomFilter>+0xec9>
   4f8f8:	48 8b 84 24 d0 00 00 	mov    0xd0(%rsp),%rax
   4f8ff:	00 
   4f900:	48 8b 38             	mov    (%rax),%rdi
   4f903:	ff 15 ef 47 05 00    	call   *0x547ef(%rip)        # a40f8 <free@GLIBC_2.2.5>
   4f909:	48 89 df             	mov    %rbx,%rdi
   4f90c:	e8 ff eb 04 00       	call   9e510 <_Unwind_Resume@plt>
   4f911:	cc                   	int3
   4f912:	cc                   	int3
   4f913:	cc                   	int3
   4f914:	cc                   	int3
   4f915:	cc                   	int3
   4f916:	cc                   	int3
   4f917:	cc                   	int3
   4f918:	cc                   	int3
   4f919:	cc                   	int3
   4f91a:	cc                   	int3
   4f91b:	cc                   	int3
   4f91c:	cc                   	int3
   4f91d:	cc                   	int3
   4f91e:	cc                   	int3
   4f91f:	cc                   	int3

