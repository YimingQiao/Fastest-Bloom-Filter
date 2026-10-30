0000000000034c20 <<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>::insert_hashes_parallel>:
   34c20:	55                   	push   %rbp
   34c21:	41 57                	push   %r15
   34c23:	41 56                	push   %r14
   34c25:	41 55                	push   %r13
   34c27:	41 54                	push   %r12
   34c29:	53                   	push   %rbx
   34c2a:	48 81 ec b8 04 00 00 	sub    $0x4b8,%rsp
   34c31:	48 89 d3             	mov    %rdx,%rbx
   34c34:	49 89 f6             	mov    %rsi,%r14
   34c37:	48 8b 07             	mov    (%rdi),%rax
   34c3a:	48 c1 e0 06          	shl    $0x6,%rax
   34c3e:	48 3d 01 00 04 00    	cmp    $0x40001,%rax
   34c44:	be 01 00 00 00       	mov    $0x1,%esi
   34c49:	48 0f 43 f1          	cmovae %rcx,%rsi
   34c4d:	48 81 fa 01 00 01 00 	cmp    $0x10001,%rdx
   34c54:	8b 47 18             	mov    0x18(%rdi),%eax
   34c57:	89 84 24 cc 00 00 00 	mov    %eax,0xcc(%rsp)
   34c5e:	0f b6 47 1c          	movzbl 0x1c(%rdi),%eax
   34c62:	0f b6 57 1d          	movzbl 0x1d(%rdi),%edx
   34c66:	88 44 24 36          	mov    %al,0x36(%rsp)
   34c6a:	88 54 24 37          	mov    %dl,0x37(%rsp)
   34c6e:	48 0f 43 f1          	cmovae %rcx,%rsi
   34c72:	4c 8b 6f 08          	mov    0x8(%rdi),%r13
   34c76:	4c 8b 7f 10          	mov    0x10(%rdi),%r15
   34c7a:	48 8d 84 24 cc 00 00 	lea    0xcc(%rsp),%rax
   34c81:	00 
   34c82:	48 89 84 24 28 04 00 	mov    %rax,0x428(%rsp)
   34c89:	00 
   34c8a:	48 8d 44 24 36       	lea    0x36(%rsp),%rax
   34c8f:	48 89 84 24 30 04 00 	mov    %rax,0x430(%rsp)
   34c96:	00 
   34c97:	48 8d 44 24 37       	lea    0x37(%rsp),%rax
   34c9c:	48 89 84 24 38 04 00 	mov    %rax,0x438(%rsp)
   34ca3:	00 
   34ca4:	48 89 df             	mov    %rbx,%rdi
   34ca7:	4c 89 fa             	mov    %r15,%rdx
   34caa:	ff 15 80 f8 06 00    	call   *0x6f880(%rip)        # a4530 <_DYNAMIC+0x630>
   34cb0:	48 89 44 24 78       	mov    %rax,0x78(%rsp)
   34cb5:	48 83 f8 01          	cmp    $0x1,%rax
   34cb9:	75 3b                	jne    34cf6 <<fastest_bloom_filter::split64_range::Split64RangeBloomFilter>::insert_hashes_parallel+0xd6>
   34cbb:	8b 8c 24 cc 00 00 00 	mov    0xcc(%rsp),%ecx

0000000000038d40 <<fastest_bloom_filter::split64::Split64BloomFilter>::insert_hashes_parallel>:
   38d40:	55                   	push   %rbp
   38d41:	41 57                	push   %r15
   38d43:	41 56                	push   %r14
   38d45:	41 55                	push   %r13
   38d47:	41 54                	push   %r12
   38d49:	53                   	push   %rbx
   38d4a:	48 81 ec b8 04 00 00 	sub    $0x4b8,%rsp
   38d51:	49 89 d6             	mov    %rdx,%r14
   38d54:	49 89 f5             	mov    %rsi,%r13
   38d57:	4c 8b 7f 10          	mov    0x10(%rdi),%r15
   38d5b:	49 81 ff 01 10 00 00 	cmp    $0x1001,%r15
   38d62:	be 01 00 00 00       	mov    $0x1,%esi
   38d67:	48 0f 43 f1          	cmovae %rcx,%rsi
   38d6b:	48 81 fa 01 00 01 00 	cmp    $0x10001,%rdx
   38d72:	48 0f 43 f1          	cmovae %rcx,%rsi
   38d76:	8b 47 18             	mov    0x18(%rdi),%eax
   38d79:	89 84 24 c4 00 00 00 	mov    %eax,0xc4(%rsp)
   38d80:	0f b6 47 1c          	movzbl 0x1c(%rdi),%eax
   38d84:	0f b6 4f 1d          	movzbl 0x1d(%rdi),%ecx
   38d88:	88 44 24 26          	mov    %al,0x26(%rsp)
   38d8c:	88 4c 24 27          	mov    %cl,0x27(%rsp)
   38d90:	48 8d 84 24 c4 00 00 	lea    0xc4(%rsp),%rax
   38d97:	00 
   38d98:	48 89 84 24 40 04 00 	mov    %rax,0x440(%rsp)
   38d9f:	00 
   38da0:	48 8d 4c 24 26       	lea    0x26(%rsp),%rcx
   38da5:	48 89 8c 24 48 04 00 	mov    %rcx,0x448(%rsp)
   38dac:	00 
   38dad:	4c 8b 67 08          	mov    0x8(%rdi),%r12
   38db1:	48 8d 4c 24 27       	lea    0x27(%rsp),%rcx
   38db6:	48 89 8c 24 50 04 00 	mov    %rcx,0x450(%rsp)
   38dbd:	00 
   38dbe:	48 89 84 24 c0 03 00 	mov    %rax,0x3c0(%rsp)
   38dc5:	00 
   38dc6:	48 89 d7             	mov    %rdx,%rdi
   38dc9:	4c 89 fa             	mov    %r15,%rdx
   38dcc:	ff 15 5e b7 06 00    	call   *0x6b75e(%rip)        # a4530 <_DYNAMIC+0x630>
   38dd2:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
   38dd7:	48 83 f8 01          	cmp    $0x1,%rax
   38ddb:	75 3e                	jne    38e1b <<fastest_bloom_filter::split64::Split64BloomFilter>::insert_hashes_parallel+0xdb>
   38ddd:	8b 8c 24 c4 00 00 00 	mov    0xc4(%rsp),%ecx
   38de4:	44 0f b6 44 24 26    	movzbl 0x26(%rsp),%r8d
   38dea:	44 0f b6 4c 24 27    	movzbl 0x27(%rsp),%r9d
   38df0:	4c 89 74 24 08       	mov    %r14,0x8(%rsp)
