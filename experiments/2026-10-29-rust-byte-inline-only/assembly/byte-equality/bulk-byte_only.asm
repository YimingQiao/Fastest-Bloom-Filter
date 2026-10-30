
/tmp/fastest-bf-rust-byte-inline-only/release/compare_benchmark:     file format elf64-x86-64


Disassembly of section .text:

0000000000039a00 <<fastest_bloom_filter_byte_inline_only::byte_split::ByteSplitBloomFilter>::lookup_hashes>:
   39a00:	push   %rbp
   39a01:	push   %r15
   39a03:	push   %r14
   39a05:	push   %r13
   39a07:	push   %r12
   39a09:	push   %rbx
   39a0a:	sub    $0x48,%rsp
   39a0e:	mov    %rdx,0x8(%rsp)
   39a13:	mov    %r8,0x10(%rsp)
   39a18:	cmp    %r8,%rdx
   39a1b:	jne    39bae <<fastest_bloom_filter_byte_inline_only::byte_split::ByteSplitBloomFilter>::lookup_hashes+0x1ae>
   39a21:	mov    %rcx,%rbx
   39a24:	mov    %rdx,%r15
   39a27:	mov    %rsi,%r14
   39a2a:	mov    %rdi,%r12
   39a2d:	cmp    $0x1,%rdx
   39a31:	jne    39a85 <<fastest_bloom_filter_byte_inline_only::byte_split::ByteSplitBloomFilter>::lookup_hashes+0x85>
   39a33:	mov    (%r14),%rsi
   39a36:	cmpb   $0x0,0x1c(%r12)
   39a3c:	je     39b66 <<fastest_bloom_filter_byte_inline_only::byte_split::ByteSplitBloomFilter>::lookup_hashes+0x166>
   39a42:	mov    %rsi,%rax
   39a45:	shr    $0x20,%rax
   39a49:	and    0x18(%r12),%eax
   39a4e:	mov    0x8(%r12),%rcx
   39a53:	shl    $0x4,%rax
   39a57:	vmovdqa (%rcx,%rax,1),%xmm0
   39a5c:	vpbroadcastd %esi,%xmm1
   39a62:	vpmulhw -0x3196a(%rip),%xmm1,%xmm1        # 8100 <anon.35274091df3394f4211c680a8c77ed4a.34.llvm.9036914972901821666+0x100>
   39a6a:	vpbroadcastq -0x31dfb(%rip),%xmm2        # 7c78 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x224>
   39a73:	vpshufb %xmm1,%xmm2,%xmm1
   39a78:	vptest %xmm1,%xmm0
   39a7d:	setb   %al
   39a80:	jmp    39b6e <<fastest_bloom_filter_byte_inline_only::byte_split::ByteSplitBloomFilter>::lookup_hashes+0x16e>
   39a85:	cmpb   $0x0,0x1c(%r12)
   39a8b:	je     39b75 <<fastest_bloom_filter_byte_inline_only::byte_split::ByteSplitBloomFilter>::lookup_hashes+0x175>
   39a91:	test   %r15,%r15
   39a94:	je     39b9f <<fastest_bloom_filter_byte_inline_only::byte_split::ByteSplitBloomFilter>::lookup_hashes+0x19f>
   39a9a:	mov    0x18(%r12),%eax
   39a9f:	mov    0x8(%r12),%rcx
   39aa4:	mov    %r15,%rdx
   39aa7:	and    $0xfffffffffffffffe,%rdx
   39aab:	xor    %esi,%esi
   39aad:	vmovdqa -0x319b5(%rip),%xmm1        # 8100 <anon.35274091df3394f4211c680a8c77ed4a.34.llvm.9036914972901821666+0x100>
   39ab5:	vpbroadcastq -0x31e46(%rip),%xmm0        # 7c78 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x224>
   39abe:	xchg   %ax,%ax
   39ac0:	mov    (%r14,%rsi,8),%rdi
   39ac4:	vpbroadcastd %edi,%xmm2
   39aca:	shr    $0x20,%rdi
   39ace:	and    %eax,%edi
   39ad0:	shl    $0x4,%rdi
   39ad4:	vmovdqa (%rcx,%rdi,1),%xmm3
   39ad9:	vpmulhw %xmm1,%xmm2,%xmm2
   39add:	vpshufb %xmm2,%xmm0,%xmm2
   39ae2:	xor    %edi,%edi
   39ae4:	vptest %xmm2,%xmm3
   39ae9:	setb   %dil
   39aed:	mov    %edi,(%rbx,%rsi,4)
   39af0:	mov    0x8(%r14,%rsi,8),%rdi
   39af5:	vpbroadcastd %edi,%xmm2
   39afb:	shr    $0x20,%rdi
   39aff:	and    %eax,%edi
   39b01:	shl    $0x4,%rdi
   39b05:	vmovdqa (%rcx,%rdi,1),%xmm3
   39b0a:	vpmulhw %xmm1,%xmm2,%xmm2
   39b0e:	vpshufb %xmm2,%xmm0,%xmm2
   39b13:	xor    %edi,%edi
   39b15:	vptest %xmm2,%xmm3
   39b1a:	setb   %dil
   39b1e:	mov    %edi,0x4(%rbx,%rsi,4)
   39b22:	add    $0x2,%rsi
   39b26:	cmp    %rsi,%rdx
   39b29:	jne    39ac0 <<fastest_bloom_filter_byte_inline_only::byte_split::ByteSplitBloomFilter>::lookup_hashes+0xc0>
   39b2b:	test   $0x1,%r15b
   39b2f:	je     39b9f <<fastest_bloom_filter_byte_inline_only::byte_split::ByteSplitBloomFilter>::lookup_hashes+0x19f>
   39b31:	mov    (%r14,%rsi,8),%rdx
   39b35:	vpbroadcastd %edx,%xmm1
   39b3b:	shr    $0x20,%rdx
   39b3f:	and    %edx,%eax
   39b41:	shl    $0x4,%rax
   39b45:	vmovdqa (%rcx,%rax,1),%xmm2
   39b4a:	vpmulhw -0x31a52(%rip),%xmm1,%xmm1        # 8100 <anon.35274091df3394f4211c680a8c77ed4a.34.llvm.9036914972901821666+0x100>
   39b52:	vpshufb %xmm1,%xmm0,%xmm0
   39b57:	xor    %eax,%eax
   39b59:	vptest %xmm0,%xmm2
   39b5e:	setb   %al
   39b61:	mov    %eax,(%rbx,%rsi,4)
   39b64:	jmp    39b9f <<fastest_bloom_filter_byte_inline_only::byte_split::ByteSplitBloomFilter>::lookup_hashes+0x19f>
   39b66:	mov    %r12,%rdi
   39b69:	call   39c00 <<fastest_bloom_filter_byte_inline_only::byte_split::ByteSplitBloomFilter>::contains_scalar>
   39b6e:	movzbl %al,%eax
   39b71:	mov    %eax,(%rbx)
   39b73:	jmp    39b9f <<fastest_bloom_filter_byte_inline_only::byte_split::ByteSplitBloomFilter>::lookup_hashes+0x19f>
   39b75:	test   %r15,%r15
   39b78:	je     39b9f <<fastest_bloom_filter_byte_inline_only::byte_split::ByteSplitBloomFilter>::lookup_hashes+0x19f>
   39b7a:	xor    %r13d,%r13d
   39b7d:	nopl   (%rax)
   39b80:	lea    0x1(%r13),%rbp
   39b84:	mov    (%r14,%r13,8),%rsi
   39b88:	mov    %r12,%rdi
   39b8b:	call   39c00 <<fastest_bloom_filter_byte_inline_only::byte_split::ByteSplitBloomFilter>::contains_scalar>
   39b90:	movzbl %al,%eax
   39b93:	mov    %eax,(%rbx,%r13,4)
   39b97:	mov    %rbp,%r13
   39b9a:	cmp    %rbp,%r15
   39b9d:	jne    39b80 <<fastest_bloom_filter_byte_inline_only::byte_split::ByteSplitBloomFilter>::lookup_hashes+0x180>
   39b9f:	add    $0x48,%rsp
   39ba3:	pop    %rbx
   39ba4:	pop    %r12
   39ba6:	pop    %r13
   39ba8:	pop    %r14
   39baa:	pop    %r15
   39bac:	pop    %rbp
   39bad:	ret
   39bae:	lea    0x3f5fb(%rip),%rax        # 791b0 <anon.35274091df3394f4211c680a8c77ed4a.292.llvm.9036914972901821666+0x220>
   39bb5:	mov    %rax,0x18(%rsp)
   39bba:	movq   $0x1,0x20(%rsp)
   39bc3:	movq   $0x8,0x28(%rsp)
   39bcc:	vxorps %xmm0,%xmm0,%xmm0
   39bd0:	vmovups %xmm0,0x30(%rsp)
   39bd6:	lea    0x3f5e3(%rip),%r8        # 791c0 <anon.35274091df3394f4211c680a8c77ed4a.292.llvm.9036914972901821666+0x230>
   39bdd:	lea    0x8(%rsp),%rsi
   39be2:	lea    0x10(%rsp),%rdx
   39be7:	lea    0x18(%rsp),%rcx
   39bec:	xor    %edi,%edi
   39bee:	call   *0x41914(%rip)        # 7b508 <_DYNAMIC+0x2d8>
