0000000000175a40 <void inline_single_kernel<true, bloom_filters::Split64BloomFilter, unsigned long>(bloom_filters::Split64BloomFilter const&, unsigned long, unsigned long const*, unsigned int*)>:
  175a40:	test   %rsi,%rsi
  175a43:	je     175be0 <void inline_single_kernel<true, bloom_filters::Split64BloomFilter, unsigned long>(bloom_filters::Split64BloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x1a0>
  175a49:	push   %rbx
  175a4a:	movabs $0xd6e8feb86659fd93,%r8
  175a54:	cmp    $0x1,%rsi
  175a58:	jne    175a61 <void inline_single_kernel<true, bloom_filters::Split64BloomFilter, unsigned long>(bloom_filters::Split64BloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x21>
  175a5a:	xor    %eax,%eax
  175a5c:	jmp    175b6f <void inline_single_kernel<true, bloom_filters::Split64BloomFilter, unsigned long>(bloom_filters::Split64BloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x12f>
  175a61:	mov    %rsi,%r9
  175a64:	and    $0xfffffffffffffffe,%r9
  175a68:	xor    %eax,%eax
  175a6a:	vmovdqa -0x171152(%rip),%ymm0        # 4920 <typeinfo name for main::$_60+0x150>
  175a72:	vpbroadcastq -0x172724(%rip),%zmm1        # 3358 <_IO_stdin_used+0xa4>
  175a7c:	nopl   0x0(%rax)
  175a80:	mov    (%rdx,%rax,8),%r10
  175a84:	mov    %r10,%r11
  175a87:	shr    $0x20,%r11
  175a8b:	xor    %r10,%r11
  175a8e:	imul   %r8,%r11
  175a92:	mov    %r11,%r10
  175a95:	shr    $0x20,%r10
  175a99:	xor    %r11,%r10
  175a9c:	imul   %r8,%r10
  175aa0:	mov    %r10,%r11
  175aa3:	shr    $0x20,%r11
  175aa7:	xor    %r11d,%r10d
  175aaa:	and    0x18(%rdi),%r11d
  175aae:	mov    (%rdi),%rbx
  175ab1:	shl    $0x6,%r11
  175ab5:	vmovdqa64 (%rbx,%r11,1),%zmm2
  175abc:	vpbroadcastd %r10d,%ymm3
  175ac2:	vpmulld %ymm0,%ymm3,%ymm3
  175ac7:	vpsrld $0x1a,%ymm3,%ymm3
  175acc:	vpmovzxdq %ymm3,%zmm3
  175ad2:	vpsrlvq %zmm3,%zmm2,%zmm2
  175ad8:	vptestnmq %zmm1,%zmm2,%k0
  175ade:	xor    %r10d,%r10d
  175ae1:	kortestb %k0,%k0
  175ae5:	sete   %r10b
  175ae9:	mov    %r10d,(%rcx,%rax,4)
  175aed:	mov    0x8(%rdx,%rax,8),%r10
  175af2:	mov    %r10,%r11
  175af5:	shr    $0x20,%r11
  175af9:	xor    %r10,%r11
  175afc:	imul   %r8,%r11
  175b00:	mov    %r11,%r10
  175b03:	shr    $0x20,%r10
  175b07:	xor    %r11,%r10
  175b0a:	imul   %r8,%r10
  175b0e:	mov    %r10,%r11
  175b11:	shr    $0x20,%r11
  175b15:	xor    %r11d,%r10d
  175b18:	and    0x18(%rdi),%r11d
  175b1c:	mov    (%rdi),%rbx
  175b1f:	shl    $0x6,%r11
  175b23:	vmovdqa64 (%rbx,%r11,1),%zmm2
  175b2a:	vpbroadcastd %r10d,%ymm3
  175b30:	vpmulld %ymm0,%ymm3,%ymm3
  175b35:	vpsrld $0x1a,%ymm3,%ymm3
  175b3a:	vpmovzxdq %ymm3,%zmm3
  175b40:	vpsrlvq %zmm3,%zmm2,%zmm2
  175b46:	vptestnmq %zmm1,%zmm2,%k0
  175b4c:	xor    %r10d,%r10d
  175b4f:	kortestb %k0,%k0
  175b53:	sete   %r10b
  175b57:	mov    %r10d,0x4(%rcx,%rax,4)
  175b5c:	add    $0x2,%rax
  175b60:	cmp    %rax,%r9
  175b63:	jne    175a80 <void inline_single_kernel<true, bloom_filters::Split64BloomFilter, unsigned long>(bloom_filters::Split64BloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
  175b69:	test   $0x1,%sil
  175b6d:	je     175bdf <void inline_single_kernel<true, bloom_filters::Split64BloomFilter, unsigned long>(bloom_filters::Split64BloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x19f>
  175b6f:	mov    (%rdx,%rax,8),%rdx
  175b73:	mov    %rdx,%rsi
  175b76:	shr    $0x20,%rsi
  175b7a:	xor    %rdx,%rsi
  175b7d:	imul   %r8,%rsi
  175b81:	mov    %rsi,%rdx
  175b84:	shr    $0x20,%rdx
  175b88:	xor    %rsi,%rdx
  175b8b:	imul   %r8,%rdx
  175b8f:	mov    %rdx,%rsi
  175b92:	shr    $0x20,%rsi
  175b96:	xor    %esi,%edx
  175b98:	and    0x18(%rdi),%esi
  175b9b:	mov    (%rdi),%rdi
  175b9e:	shl    $0x6,%rsi
  175ba2:	vpbroadcastd %edx,%ymm0
  175ba8:	vpmulld -0x171291(%rip),%ymm0,%ymm0        # 4920 <typeinfo name for main::$_60+0x150>
  175bb1:	vmovdqa64 (%rdi,%rsi,1),%zmm1
  175bb8:	vpsrld $0x1a,%ymm0,%ymm0
  175bbd:	vpmovzxdq %ymm0,%zmm0
  175bc3:	vpsrlvq %zmm0,%zmm1,%zmm0
  175bc9:	vptestnmq -0x17287b(%rip){1to8},%zmm0,%k0        # 3358 <_IO_stdin_used+0xa4>
  175bd3:	xor    %edx,%edx
  175bd5:	kortestb %k0,%k0
  175bd9:	sete   %dl
  175bdc:	mov    %edx,(%rcx,%rax,4)
  175bdf:	pop    %rbx
  175be0:	vzeroupper
  175be3:	ret
  175be4:	int3
  175be5:	int3
  175be6:	int3
  175be7:	int3
  175be8:	int3
  175be9:	int3
  175bea:	int3
  175beb:	int3
  175bec:	int3
  175bed:	int3
  175bee:	int3
  175bef:	int3

