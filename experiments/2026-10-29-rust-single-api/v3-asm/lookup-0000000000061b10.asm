0000000000061b10 <compare_benchmark::lookup>:
   61b10:	41 56                	push   %r14
   61b12:	53                   	push   %rbx
   61b13:	48 83 ec 48          	sub    $0x48,%rsp
   61b17:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
   61b1c:	4c 89 44 24 10       	mov    %r8,0x10(%rsp)
   61b21:	4c 39 c2             	cmp    %r8,%rdx
   61b24:	0f 85 c2 00 00 00    	jne    61bec <compare_benchmark::lookup+0xdc>
   61b2a:	48 83 fa 01          	cmp    $0x1,%rdx
   61b2e:	0f 85 90 00 00 00    	jne    61bc4 <compare_benchmark::lookup+0xb4>
   61b34:	48 8b 06             	mov    (%rsi),%rax
   61b37:	48 8b 77 08          	mov    0x8(%rdi),%rsi
   61b3b:	49 89 f0             	mov    %rsi,%r8
   61b3e:	49 c1 e0 06          	shl    $0x6,%r8
   61b42:	4c 89 c2             	mov    %r8,%rdx
   61b45:	c4 e2 eb f6 d0       	mulx   %rax,%rdx,%rdx
   61b4a:	49 89 d1             	mov    %rdx,%r9
   61b4d:	49 c1 e9 06          	shr    $0x6,%r9
   61b51:	49 39 f1             	cmp    %rsi,%r9
   61b54:	0f 83 e5 00 00 00    	jae    61c3f <compare_benchmark::lookup+0x12f>
   61b5a:	4c 8b 17             	mov    (%rdi),%r10
   61b5d:	4f 8b 0c ca          	mov    (%r10,%r9,8),%r9
   61b61:	49 0f a3 d1          	bt     %rdx,%r9
   61b65:	73 6c                	jae    61bd3 <compare_benchmark::lookup+0xc3>
   61b67:	49 bb 95 0a 22 27 b7 	movabs $0x517cc1b727220a95,%r11
   61b6e:	c1 7c 51 
   61b71:	4c 0f af d8          	imul   %rax,%r11
   61b75:	44 8b 4f 58          	mov    0x58(%rdi),%r9d
   61b79:	45 89 ce             	mov    %r9d,%r14d
   61b7c:	41 f7 de             	neg    %r14d
   61b7f:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
   61b84:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
   61b8b:	00 00 00 00 00 
   61b90:	41 8d 14 1e          	lea    (%r14,%rbx,1),%edx
   61b94:	83 fa ff             	cmp    $0xffffffff,%edx
   61b97:	74 3e                	je     61bd7 <compare_benchmark::lookup+0xc7>
   61b99:	c4 e3 fb f0 c0 3b    	rorx   $0x3b,%rax,%rax
   61b9f:	4c 01 d8             	add    %r11,%rax
   61ba2:	48 89 c2             	mov    %rax,%rdx
   61ba5:	c4 c2 eb f6 d0       	mulx   %r8,%rdx,%rdx
   61baa:	48 89 d7             	mov    %rdx,%rdi
   61bad:	48 c1 ef 06          	shr    $0x6,%rdi
   61bb1:	48 39 f7             	cmp    %rsi,%rdi
   61bb4:	73 7c                	jae    61c32 <compare_benchmark::lookup+0x122>
   61bb6:	49 8b 3c fa          	mov    (%r10,%rdi,8),%rdi
   61bba:	ff c3                	inc    %ebx
   61bbc:	48 0f a3 d7          	bt     %rdx,%rdi
   61bc0:	72 ce                	jb     61b90 <compare_benchmark::lookup+0x80>
   61bc2:	eb 16                	jmp    61bda <compare_benchmark::lookup+0xca>
   61bc4:	49 89 d0             	mov    %rdx,%r8
   61bc7:	48 83 c4 48          	add    $0x48,%rsp
   61bcb:	5b                   	pop    %rbx
   61bcc:	41 5e                	pop    %r14
   61bce:	e9 bd 45 00 00       	jmp    66190 <<compare_benchmark::Fastbloom017 as compare_benchmark::Filter>::lookup_hashes>
   61bd3:	31 c0                	xor    %eax,%eax
   61bd5:	eb 0b                	jmp    61be2 <compare_benchmark::lookup+0xd2>
   61bd7:	44 89 cb             	mov    %r9d,%ebx
   61bda:	31 c0                	xor    %eax,%eax
   61bdc:	44 39 cb             	cmp    %r9d,%ebx
   61bdf:	0f 93 c0             	setae  %al
   61be2:	89 01                	mov    %eax,(%rcx)
   61be4:	48 83 c4 48          	add    $0x48,%rsp
   61be8:	5b                   	pop    %rbx
   61be9:	41 5e                	pop    %r14
   61beb:	c3                   	ret
   61bec:	48 8d 05 cd 2d 05 00 	lea    0x52dcd(%rip),%rax        # b49c0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0x1f0>
   61bf3:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
   61bf8:	48 c7 44 24 20 01 00 	movq   $0x1,0x20(%rsp)
   61bff:	00 00 
   61c01:	48 c7 44 24 28 08 00 	movq   $0x8,0x28(%rsp)
   61c08:	00 00 
   61c0a:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
   61c0e:	c5 f8 11 44 24 30    	vmovups %xmm0,0x30(%rsp)
   61c14:	4c 8d 05 35 3a 05 00 	lea    0x53a35(%rip),%r8        # b5650 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0xe80>
   61c1b:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
   61c20:	48 8d 54 24 10       	lea    0x10(%rsp),%rdx
   61c25:	48 8d 4c 24 18       	lea    0x18(%rsp),%rcx
   61c2a:	31 ff                	xor    %edi,%edi
   61c2c:	ff 15 be 6b 05 00    	call   *0x56bbe(%rip)        # b87f0 <_DYNAMIC+0x3d8>
   61c32:	48 8d 15 bf 3a 05 00 	lea    0x53abf(%rip),%rdx        # b56f8 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0xf28>
   61c39:	ff 15 39 6a 05 00    	call   *0x56a39(%rip)        # b8678 <_DYNAMIC+0x260>
   61c3f:	48 8d 15 b2 3a 05 00 	lea    0x53ab2(%rip),%rdx        # b56f8 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0xf28>
   61c46:	4c 89 cf             	mov    %r9,%rdi
   61c49:	ff 15 29 6a 05 00    	call   *0x56a29(%rip)        # b8678 <_DYNAMIC+0x260>
   61c4f:	cc                   	int3

