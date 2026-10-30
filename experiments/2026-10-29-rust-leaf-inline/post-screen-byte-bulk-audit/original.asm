
/tmp/fastest-bf-rust-leaf-inline/release/compare_benchmark:     file format elf64-x86-64


Disassembly of section .text:

00000000000629d0 <<fastest_bloom_filter::byte_split::ByteSplitBloomFilter>::lookup_hashes>:
   629d0:	push   %rbp
   629d1:	push   %r15
   629d3:	push   %r14
   629d5:	push   %r13
   629d7:	push   %r12
   629d9:	push   %rbx
   629da:	sub    $0x48,%rsp
   629de:	mov    %rdx,0x8(%rsp)
   629e3:	mov    %r8,0x10(%rsp)
   629e8:	cmp    %r8,%rdx
   629eb:	jne    62b7e <<fastest_bloom_filter::byte_split::ByteSplitBloomFilter>::lookup_hashes+0x1ae>
   629f1:	mov    %rcx,%rbx
   629f4:	mov    %rdx,%r15
   629f7:	mov    %rsi,%r14
   629fa:	mov    %rdi,%r12
   629fd:	cmp    $0x1,%rdx
   62a01:	jne    62a55 <<fastest_bloom_filter::byte_split::ByteSplitBloomFilter>::lookup_hashes+0x85>
   62a03:	mov    (%r14),%rsi
   62a06:	cmpb   $0x0,0x1c(%r12)
   62a0c:	je     62b36 <<fastest_bloom_filter::byte_split::ByteSplitBloomFilter>::lookup_hashes+0x166>
   62a12:	mov    %rsi,%rax
   62a15:	shr    $0x20,%rax
   62a19:	and    0x18(%r12),%eax
   62a1e:	mov    0x8(%r12),%rcx
   62a23:	shl    $0x4,%rax
   62a27:	vmovdqa (%rcx,%rax,1),%xmm0
   62a2c:	vpbroadcastd %esi,%xmm1
   62a32:	vpmulhw -0x59c8a(%rip),%xmm1,%xmm1        # 8db0 <anon.35274091df3394f4211c680a8c77ed4a.34.llvm.9036914972901821666+0x160>
   62a3a:	vpbroadcastq -0x5a33b(%rip),%xmm2        # 8708 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x249>
   62a43:	vpshufb %xmm1,%xmm2,%xmm1
   62a48:	vptest %xmm1,%xmm0
   62a4d:	setb   %al
   62a50:	jmp    62b3e <<fastest_bloom_filter::byte_split::ByteSplitBloomFilter>::lookup_hashes+0x16e>
   62a55:	cmpb   $0x0,0x1c(%r12)
   62a5b:	je     62b45 <<fastest_bloom_filter::byte_split::ByteSplitBloomFilter>::lookup_hashes+0x175>
   62a61:	test   %r15,%r15
   62a64:	je     62b6f <<fastest_bloom_filter::byte_split::ByteSplitBloomFilter>::lookup_hashes+0x19f>
   62a6a:	mov    0x18(%r12),%eax
   62a6f:	mov    0x8(%r12),%rcx
   62a74:	mov    %r15,%rdx
   62a77:	and    $0xfffffffffffffffe,%rdx
   62a7b:	xor    %esi,%esi
   62a7d:	vmovdqa -0x59cd5(%rip),%xmm1        # 8db0 <anon.35274091df3394f4211c680a8c77ed4a.34.llvm.9036914972901821666+0x160>
   62a85:	vpbroadcastq -0x5a386(%rip),%xmm0        # 8708 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x249>
   62a8e:	xchg   %ax,%ax
   62a90:	mov    (%r14,%rsi,8),%rdi
   62a94:	vpbroadcastd %edi,%xmm2
   62a9a:	shr    $0x20,%rdi
   62a9e:	and    %eax,%edi
   62aa0:	shl    $0x4,%rdi
   62aa4:	vmovdqa (%rcx,%rdi,1),%xmm3
   62aa9:	vpmulhw %xmm1,%xmm2,%xmm2
   62aad:	vpshufb %xmm2,%xmm0,%xmm2
   62ab2:	xor    %edi,%edi
   62ab4:	vptest %xmm2,%xmm3
   62ab9:	setb   %dil
   62abd:	mov    %edi,(%rbx,%rsi,4)
   62ac0:	mov    0x8(%r14,%rsi,8),%rdi
   62ac5:	vpbroadcastd %edi,%xmm2
   62acb:	shr    $0x20,%rdi
   62acf:	and    %eax,%edi
   62ad1:	shl    $0x4,%rdi
   62ad5:	vmovdqa (%rcx,%rdi,1),%xmm3
   62ada:	vpmulhw %xmm1,%xmm2,%xmm2
   62ade:	vpshufb %xmm2,%xmm0,%xmm2
   62ae3:	xor    %edi,%edi
   62ae5:	vptest %xmm2,%xmm3
   62aea:	setb   %dil
   62aee:	mov    %edi,0x4(%rbx,%rsi,4)
   62af2:	add    $0x2,%rsi
   62af6:	cmp    %rsi,%rdx
   62af9:	jne    62a90 <<fastest_bloom_filter::byte_split::ByteSplitBloomFilter>::lookup_hashes+0xc0>
   62afb:	test   $0x1,%r15b
   62aff:	je     62b6f <<fastest_bloom_filter::byte_split::ByteSplitBloomFilter>::lookup_hashes+0x19f>
   62b01:	mov    (%r14,%rsi,8),%rdx
   62b05:	vpbroadcastd %edx,%xmm1
   62b0b:	shr    $0x20,%rdx
   62b0f:	and    %edx,%eax
   62b11:	shl    $0x4,%rax
   62b15:	vmovdqa (%rcx,%rax,1),%xmm2
   62b1a:	vpmulhw -0x59d72(%rip),%xmm1,%xmm1        # 8db0 <anon.35274091df3394f4211c680a8c77ed4a.34.llvm.9036914972901821666+0x160>
   62b22:	vpshufb %xmm1,%xmm0,%xmm0
   62b27:	xor    %eax,%eax
   62b29:	vptest %xmm0,%xmm2
   62b2e:	setb   %al
   62b31:	mov    %eax,(%rbx,%rsi,4)
   62b34:	jmp    62b6f <<fastest_bloom_filter::byte_split::ByteSplitBloomFilter>::lookup_hashes+0x19f>
   62b36:	mov    %r12,%rdi
   62b39:	call   62bd0 <<fastest_bloom_filter::byte_split::ByteSplitBloomFilter>::contains_scalar>
   62b3e:	movzbl %al,%eax
   62b41:	mov    %eax,(%rbx)
   62b43:	jmp    62b6f <<fastest_bloom_filter::byte_split::ByteSplitBloomFilter>::lookup_hashes+0x19f>
   62b45:	test   %r15,%r15
   62b48:	je     62b6f <<fastest_bloom_filter::byte_split::ByteSplitBloomFilter>::lookup_hashes+0x19f>
   62b4a:	xor    %r13d,%r13d
   62b4d:	nopl   (%rax)
   62b50:	lea    0x1(%r13),%rbp
   62b54:	mov    (%r14,%r13,8),%rsi
   62b58:	mov    %r12,%rdi
   62b5b:	call   62bd0 <<fastest_bloom_filter::byte_split::ByteSplitBloomFilter>::contains_scalar>
   62b60:	movzbl %al,%eax
   62b63:	mov    %eax,(%rbx,%r13,4)
   62b67:	mov    %rbp,%r13
   62b6a:	cmp    %rbp,%r15
   62b6d:	jne    62b50 <<fastest_bloom_filter::byte_split::ByteSplitBloomFilter>::lookup_hashes+0x180>
   62b6f:	add    $0x48,%rsp
   62b73:	pop    %rbx
   62b74:	pop    %r12
   62b76:	pop    %r13
   62b78:	pop    %r14
   62b7a:	pop    %r15
   62b7c:	pop    %rbp
   62b7d:	ret
   62b7e:	lea    0x44e4b(%rip),%rax        # a79d0 <anon.663c38bb301f18615f4d3110a8e62152.2.llvm.1231715614483663210+0xc0>
   62b85:	mov    %rax,0x18(%rsp)
   62b8a:	movq   $0x1,0x20(%rsp)
   62b93:	movq   $0x8,0x28(%rsp)
   62b9c:	vxorps %xmm0,%xmm0,%xmm0
   62ba0:	vmovups %xmm0,0x30(%rsp)
   62ba6:	lea    0x44eab(%rip),%r8        # a7a58 <anon.663c38bb301f18615f4d3110a8e62152.2.llvm.1231715614483663210+0x148>
   62bad:	lea    0x8(%rsp),%rsi
   62bb2:	lea    0x10(%rsp),%rdx
   62bb7:	lea    0x18(%rsp),%rcx
   62bbc:	xor    %edi,%edi
   62bbe:	call   *0x4743c(%rip)        # aa000 <_DYNAMIC+0x2f8>
