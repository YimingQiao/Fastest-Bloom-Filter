000000000014cbd0 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<8, false>, unsigned long>(rocksdb_external::FastLocalBloom64<8, false> const&, unsigned long, unsigned long const*, unsigned int*)>:
  14cbd0:	test   %rsi,%rsi
  14cbd3:	je     14cdea <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<8, false>, unsigned long>(rocksdb_external::FastLocalBloom64<8, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x21a>
  14cbd9:	push   %r14
  14cbdb:	push   %rbx
  14cbdc:	movabs $0xd6e8feb86659fd93,%r8
  14cbe6:	cmp    $0x1,%rsi
  14cbea:	jne    14cbf3 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<8, false>, unsigned long>(rocksdb_external::FastLocalBloom64<8, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x23>
  14cbec:	xor    %eax,%eax
  14cbee:	jmp    14cd51 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<8, false>, unsigned long>(rocksdb_external::FastLocalBloom64<8, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x181>
  14cbf3:	mov    %rsi,%r9
  14cbf6:	and    $0xfffffffffffffffe,%r9
  14cbfa:	xor    %eax,%eax
  14cbfc:	vmovdqa -0x148124(%rip),%ymm0        # 4ae0 <typeinfo name for main::$_60+0x310>
  14cc04:	vmovdqa -0x14828c(%rip),%ymm1        # 4980 <typeinfo name for main::$_60+0x1b0>
  14cc0c:	vpbroadcastd -0x14996d(%rip),%ymm2        # 32a8 <__abi_tag+0x2fe4>
  14cc15:	data16 cs nopw 0x0(%rax,%rax,1)
  14cc20:	mov    (%rdx,%rax,8),%r10
  14cc24:	mov    %r10,%r11
  14cc27:	shr    $0x20,%r11
  14cc2b:	xor    %r10,%r11
  14cc2e:	imul   %r8,%r11
  14cc32:	mov    %r11,%r10
  14cc35:	shr    $0x20,%r10
  14cc39:	xor    %r11,%r10
  14cc3c:	imul   %r8,%r10
  14cc40:	mov    %r10d,%r11d
  14cc43:	shr    $0x20,%r10
  14cc47:	mov    (%rdi),%rbx
  14cc4a:	xor    %r10,%r11
  14cc4d:	mov    0x18(%rdi),%r14d
  14cc51:	shr    $0x6,%r14d
  14cc55:	imul   %r11,%r14
  14cc59:	shr    $0x1a,%r14
  14cc5d:	and    $0xffffffc0,%r14d
  14cc61:	vpbroadcastd %r10d,%ymm3
  14cc67:	vpmulld %ymm0,%ymm3,%ymm4
  14cc6c:	vpsrld $0x1c,%ymm4,%ymm5
  14cc71:	vxorps %xmm6,%xmm6,%xmm6
  14cc75:	vpermd (%rbx,%r14,1),%ymm5,%ymm6
  14cc7b:	vpermd 0x20(%rbx,%r14,1),%ymm5,%ymm5
  14cc82:	vpsrad $0x1f,%ymm4,%ymm4
  14cc87:	vpblendvb %ymm4,%ymm5,%ymm6,%ymm4
  14cc8d:	vpmulld %ymm1,%ymm3,%ymm3
  14cc92:	vpsrld $0x1b,%ymm3,%ymm3
  14cc97:	vpsllvd %ymm3,%ymm2,%ymm3
  14cc9c:	xor    %r10d,%r10d
  14cc9f:	vptest %ymm3,%ymm4
  14cca4:	setb   %r10b
  14cca8:	mov    %r10d,(%rcx,%rax,4)
  14ccac:	mov    0x8(%rdx,%rax,8),%r10
  14ccb1:	mov    %r10,%r11
  14ccb4:	shr    $0x20,%r11
  14ccb8:	xor    %r10,%r11
  14ccbb:	imul   %r8,%r11
  14ccbf:	mov    %r11,%r10
  14ccc2:	shr    $0x20,%r10
  14ccc6:	xor    %r11,%r10
  14ccc9:	imul   %r8,%r10
  14cccd:	mov    %r10d,%r11d
  14ccd0:	shr    $0x20,%r10
  14ccd4:	mov    (%rdi),%rbx
  14ccd7:	xor    %r10,%r11
  14ccda:	mov    0x18(%rdi),%r14d
  14ccde:	shr    $0x6,%r14d
  14cce2:	imul   %r11,%r14
  14cce6:	shr    $0x1a,%r14
  14ccea:	vpbroadcastd %r10d,%ymm3
  14ccf0:	vpmulld %ymm0,%ymm3,%ymm4
  14ccf5:	and    $0xffffffc0,%r14d
  14ccf9:	vpsrld $0x1c,%ymm4,%ymm5
  14ccfe:	vxorps %xmm6,%xmm6,%xmm6
  14cd02:	vpermd (%rbx,%r14,1),%ymm5,%ymm6
  14cd08:	vpermd 0x20(%rbx,%r14,1),%ymm5,%ymm5
  14cd0f:	vpsrad $0x1f,%ymm4,%ymm4
  14cd14:	vpblendvb %ymm4,%ymm5,%ymm6,%ymm4
  14cd1a:	vpmulld %ymm1,%ymm3,%ymm3
  14cd1f:	vpsrld $0x1b,%ymm3,%ymm3
  14cd24:	vpsllvd %ymm3,%ymm2,%ymm3
  14cd29:	xor    %r10d,%r10d
  14cd2c:	vptest %ymm3,%ymm4
  14cd31:	setb   %r10b
  14cd35:	mov    %r10d,0x4(%rcx,%rax,4)
  14cd3a:	add    $0x2,%rax
  14cd3e:	cmp    %rax,%r9
  14cd41:	jne    14cc20 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<8, false>, unsigned long>(rocksdb_external::FastLocalBloom64<8, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  14cd47:	test   $0x1,%sil
  14cd4b:	je     14cde7 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<8, false>, unsigned long>(rocksdb_external::FastLocalBloom64<8, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x217>
  14cd51:	mov    (%rdx,%rax,8),%rdx
  14cd55:	mov    %rdx,%rsi
  14cd58:	shr    $0x20,%rsi
  14cd5c:	xor    %rdx,%rsi
  14cd5f:	imul   %r8,%rsi
  14cd63:	mov    %rsi,%rdx
  14cd66:	shr    $0x20,%rdx
  14cd6a:	xor    %rsi,%rdx
  14cd6d:	imul   %r8,%rdx
  14cd71:	mov    %edx,%esi
  14cd73:	shr    $0x20,%rdx
  14cd77:	mov    (%rdi),%r8
  14cd7a:	xor    %rdx,%rsi
  14cd7d:	mov    0x18(%rdi),%edi
  14cd80:	shr    $0x6,%edi
  14cd83:	imul   %rsi,%rdi
  14cd87:	shr    $0x1a,%rdi
  14cd8b:	and    $0xffffffc0,%edi
  14cd8e:	vpbroadcastd %edx,%ymm0
  14cd94:	vpmulld -0x1482bd(%rip),%ymm0,%ymm1        # 4ae0 <typeinfo name for main::$_60+0x310>
  14cd9d:	vpsrld $0x1c,%ymm1,%ymm2
  14cda2:	vxorps %xmm3,%xmm3,%xmm3
  14cda6:	vpermd (%r8,%rdi,1),%ymm2,%ymm3
  14cdac:	vpermd 0x20(%r8,%rdi,1),%ymm2,%ymm2
  14cdb3:	vpsrad $0x1f,%ymm1,%ymm1
  14cdb8:	vpblendvb %ymm1,%ymm2,%ymm3,%ymm1
  14cdbe:	vpmulld -0x148447(%rip),%ymm0,%ymm0        # 4980 <typeinfo name for main::$_60+0x1b0>
  14cdc7:	vpsrld $0x1b,%ymm0,%ymm0
  14cdcc:	vpbroadcastd -0x149b2d(%rip),%ymm2        # 32a8 <__abi_tag+0x2fe4>
  14cdd5:	vpsllvd %ymm0,%ymm2,%ymm0
  14cdda:	xor    %edx,%edx
  14cddc:	vptest %ymm0,%ymm1
  14cde1:	setb   %dl
  14cde4:	mov    %edx,(%rcx,%rax,4)
  14cde7:	pop    %rbx
  14cde8:	pop    %r14
  14cdea:	vzeroupper
  14cded:	ret
  14cdee:	int3
  14cdef:	int3

