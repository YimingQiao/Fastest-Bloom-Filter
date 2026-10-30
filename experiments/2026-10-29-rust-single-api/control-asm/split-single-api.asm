
/tmp/fastest-bf-rust-single-api/release/compare_benchmark:     file format elf64-x86-64


Disassembly of section .text:

000000000004bbc0 <compare_benchmark::lookup>:
   4bbc0:	48 83 ec 48          	sub    $0x48,%rsp
   4bbc4:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
   4bbc9:	4c 89 44 24 10       	mov    %r8,0x10(%rsp)
   4bbce:	4c 39 c2             	cmp    %r8,%rdx
   4bbd1:	0f 85 8c 00 00 00    	jne    4bc63 <compare_benchmark::lookup+0xa3>
   4bbd7:	48 83 fa 01          	cmp    $0x1,%rdx
   4bbdb:	75 79                	jne    4bc56 <compare_benchmark::lookup+0x96>
   4bbdd:	48 8b 16             	mov    (%rsi),%rdx
   4bbe0:	48 89 d0             	mov    %rdx,%rax
   4bbe3:	48 c1 e8 20          	shr    $0x20,%rax
   4bbe7:	23 47 18             	and    0x18(%rdi),%eax
   4bbea:	48 8b 77 10          	mov    0x10(%rdi),%rsi
   4bbee:	48 39 c6             	cmp    %rax,%rsi
   4bbf1:	0f 86 b2 00 00 00    	jbe    4bca9 <compare_benchmark::lookup+0xe9>
   4bbf7:	62 f2 fd 48 7c c2    	vpbroadcastq %rdx,%zmm0
   4bbfd:	62 f2 fd 48 40 05 79 	vpmullq -0x42b87(%rip),%zmm0,%zmm0        # 9080 <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x670>
   4bc04:	d4 fb ff 
   4bc07:	48 8b 57 08          	mov    0x8(%rdi),%rdx
   4bc0b:	62 f1 fd 48 73 d0 1a 	vpsrlq $0x1a,%zmm0,%zmm0
   4bc12:	62 f1 fd 58 db 05 ac 	vpandq -0x43954(%rip){1to8},%zmm0,%zmm0        # 82c8 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x38>
   4bc19:	c6 fb ff 
   4bc1c:	48 c1 e0 06          	shl    $0x6,%rax
   4bc20:	62 f2 fd 48 59 0d 36 	vpbroadcastq -0x439ca(%rip),%zmm1        # 8260 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x2b7>
   4bc27:	c6 fb ff 
   4bc2a:	62 f2 f5 48 47 c0    	vpsllvq %zmm0,%zmm1,%zmm0
   4bc30:	62 f1 fe 48 6f 0c 02 	vmovdqu64 (%rdx,%rax,1),%zmm1
   4bc37:	62 f1 f5 48 df c0    	vpandnq %zmm0,%zmm1,%zmm0
   4bc3d:	62 f2 7d 48 27 c0    	vptestmd %zmm0,%zmm0,%k0
   4bc43:	31 c0                	xor    %eax,%eax
   4bc45:	c5 f8 98 c0          	kortestw %k0,%k0
   4bc49:	0f 94 c0             	sete   %al
   4bc4c:	89 01                	mov    %eax,(%rcx)
   4bc4e:	48 83 c4 48          	add    $0x48,%rsp
   4bc52:	c5 f8 77             	vzeroupper
   4bc55:	c3                   	ret
   4bc56:	49 89 d0             	mov    %rdx,%r8
   4bc59:	48 83 c4 48          	add    $0x48,%rsp
   4bc5d:	ff 25 7d 25 05 00    	jmp    *0x5257d(%rip)        # 9e1e0 <_DYNAMIC+0x3c8>
   4bc63:	48 8d 05 0e eb 04 00 	lea    0x4eb0e(%rip),%rax        # 9a778 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0x178>
   4bc6a:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
   4bc6f:	48 c7 44 24 20 01 00 	movq   $0x1,0x20(%rsp)
   4bc76:	00 00 
   4bc78:	48 c7 44 24 28 08 00 	movq   $0x8,0x28(%rsp)
   4bc7f:	00 00 
   4bc81:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
   4bc85:	c5 f8 11 44 24 30    	vmovups %xmm0,0x30(%rsp)
   4bc8b:	4c 8d 05 de f5 04 00 	lea    0x4f5de(%rip),%r8        # 9b270 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0xc70>
   4bc92:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
   4bc97:	48 8d 54 24 10       	lea    0x10(%rsp),%rdx
   4bc9c:	48 8d 4c 24 18       	lea    0x18(%rsp),%rcx
   4bca1:	31 ff                	xor    %edi,%edi
   4bca3:	ff 15 1f 25 05 00    	call   *0x5251f(%rip)        # 9e1c8 <_DYNAMIC+0x3b0>
   4bca9:	48 8d 15 40 f3 04 00 	lea    0x4f340(%rip),%rdx        # 9aff0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0x9f0>
   4bcb0:	48 89 c7             	mov    %rax,%rdi
   4bcb3:	ff 15 bf 23 05 00    	call   *0x523bf(%rip)        # 9e078 <_DYNAMIC+0x260>
   4bcb9:	cc                   	int3
   4bcba:	cc                   	int3
   4bcbb:	cc                   	int3
   4bcbc:	cc                   	int3
   4bcbd:	cc                   	int3
   4bcbe:	cc                   	int3
   4bcbf:	cc                   	int3
