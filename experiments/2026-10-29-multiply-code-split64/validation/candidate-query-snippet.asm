    6b37:	48 0f af f9          	imul   %rcx,%rdi
    6b3b:	48 c1 ef 1a          	shr    $0x1a,%rdi
    6b3f:	48 83 e7 c0          	and    $0xffffffffffffffc0,%rdi
    6b43:	0f 18 0c 38          	prefetcht0 (%rax,%rdi,1)
    6b47:	48 8b bc f4 78 40 00 	mov    0x4078(%rsp,%rsi,8),%rdi
    6b4e:	00 
    6b4f:	41 89 f8             	mov    %edi,%r8d
    6b52:	48 c1 ef 20          	shr    $0x20,%rdi
    6b56:	48 0f af f9          	imul   %rcx,%rdi
    6b5a:	48 c1 ef 1a          	shr    $0x1a,%rdi
    6b5e:	48 83 e7 c0          	and    $0xffffffffffffffc0,%rdi
    6b62:	4d 0f af c2          	imul   %r10,%r8
    6b66:	62 d2 fd 48 7c c0    	vpbroadcastq %r8,%zmm0
    6b6c:	62 f2 fd 48 45 c2    	vpsrlvq %zmm2,%zmm0,%zmm0
    6b72:	62 f2 f5 48 15 c0    	vprolvq %zmm0,%zmm1,%zmm0
    6b78:	62 f2 fe 48 27 04 38 	vptestnmq (%rax,%rdi,1),%zmm0,%k0
    6b7f:	31 ff                	xor    %edi,%edi
    6b81:	c5 f9 98 c0          	kortestb %k0,%k0
    6b85:	40 0f 94 c7          	sete   %dil
    6b89:	89 7c b4 74          	mov    %edi,0x74(%rsp,%rsi,4)
    6b8d:	8b bc f4 84 41 00 00 	mov    0x4184(%rsp,%rsi,8),%edi
    6b94:	48 0f af f9          	imul   %rcx,%rdi
    6b98:	48 c1 ef 1a          	shr    $0x1a,%rdi
    6b9c:	48 83 e7 c0          	and    $0xffffffffffffffc0,%rdi
    6ba0:	0f 18 0c 38          	prefetcht0 (%rax,%rdi,1)
    6ba4:	48 8b bc f4 80 40 00 	mov    0x4080(%rsp,%rsi,8),%rdi
    6bab:	00 
    6bac:	41 89 f8             	mov    %edi,%r8d
    6baf:	48 c1 ef 20          	shr    $0x20,%rdi
    6bb3:	48 0f af f9          	imul   %rcx,%rdi
    6bb7:	48 c1 ef 1a          	shr    $0x1a,%rdi
    6bbb:	48 83 e7 c0          	and    $0xffffffffffffffc0,%rdi
    6bbf:	4d 0f af c2          	imul   %r10,%r8
    6bc3:	62 d2 fd 48 7c c0    	vpbroadcastq %r8,%zmm0
    6bc9:	62 f2 fd 48 45 c2    	vpsrlvq %zmm2,%zmm0,%zmm0
    6bcf:	62 f2 f5 48 15 c0    	vprolvq %zmm0,%zmm1,%zmm0
    6bd5:	62 f2 fe 48 27 04 38 	vptestnmq (%rax,%rdi,1),%zmm0,%k0
    6bdc:	31 ff                	xor    %edi,%edi
    6bde:	c5 f9 98 c0          	kortestb %k0,%k0
    6be2:	40 0f 94 c7          	sete   %dil
    6be6:	89 7c b4 78          	mov    %edi,0x78(%rsp,%rsi,4)
    6bea:	48 83 c6 02          	add    $0x2,%rsi
    6bee:	48 81 fe e0 0f 00 00 	cmp    $0xfe0,%rsi
    6bf5:	0f 85 35 ff ff ff    	jne    6b30 <main+0x4590>
    6bfb:	be e2 0f 00 00       	mov    $0xfe2,%esi
