   18b59:	call   1d5f0 <std::chrono::_V2::steady_clock::now()@plt>
   18b5e:	mov    %rax,0x40(%rsp)
   18b63:	mov    0x18(%rsp),%rsi
   18b68:	lea    0x220(%rsp),%rdi
   18b70:	mov    %ebp,%edx
   18b72:	call   1b9f0 <bloom_filters::Split64RangeBloomFilter make_filter<bloom_filters::Split64RangeBloomFilter>(unsigned long, unsigned int)>
   18b77:	call   1d5f0 <std::chrono::_V2::steady_clock::now()@plt>
   18b7c:	mov    %rax,0x78(%rsp)
   18b81:	mov    0x18(%rsp),%rax
   18b86:	test   %rax,%rax
   18b89:	mov    0x3a8(%rsp),%rcx
   18b91:	je     18f80 <void run<bloom_filters::Split64RangeBloomFilter, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0x10b0>
   18b97:	mov    $0x60,%r12d
   18b9d:	mov    $0x10,%edx
   18ba2:	mov    %rdx,0x10(%rsp)
   18ba7:	xor    %ebp,%ebp
   18ba9:	xor    %r15d,%r15d
   18bac:	xor    %r13d,%r13d
   18baf:	xor    %r14d,%r14d
   18bb2:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   18bc0:	mov    %rax,%rsi
   18bc3:	sub    %r14,%rsi
   18bc6:	cmp    %rcx,%rsi
   18bc9:	cmovae %rcx,%rsi
   18bcd:	mov    0x180(%rsp),%rdx
   18bd5:	test   %rsi,%rsi
   18bd8:	je     18d83 <void run<bloom_filters::Split64RangeBloomFilter, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xeb3>
   18bde:	mov    0x20(%rsp),%rcx
   18be3:	mov    (%rcx),%rcx
   18be6:	cmp    $0x4,%rsi
   18bea:	jb     18c08 <void run<bloom_filters::Split64RangeBloomFilter, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xd38>
   18bec:	mov    0x30(%rsp),%rdi
   18bf1:	imul   %r13,%rdi
   18bf5:	add    %rdx,%rdi
   18bf8:	sub    %rcx,%rdi
   18bfb:	cmp    $0x80,%rdi
   18c02:	jae    18dc7 <void run<bloom_filters::Split64RangeBloomFilter, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xef7>
   18c08:	xor    %edi,%edi
   18c0a:	mov    %r12,0x68(%rsp)
   18c0f:	mov    %rdi,%r8
   18c12:	test   $0x3,%sil
   18c16:	je     18c76 <void run<bloom_filters::Split64RangeBloomFilter, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xda6>
   18c18:	lea    (%rcx,%rbp,1),%r9
   18c1c:	lea    (%rax,%r15,1),%r10
   18c20:	mov    0x3a8(%rsp),%r8
   18c28:	cmp    %r10,%r8
   18c2b:	cmovb  %r8,%r10
   18c2f:	and    $0x3,%r10d
   18c33:	mov    %rdi,%r8
   18c36:	cs nopw 0x0(%rax,%rax,1)
   18c40:	mov    (%r9,%r8,8),%r12
   18c44:	mov    %r12,%r11
   18c47:	shr    $0x20,%r11
   18c4b:	xor    %r12,%r11
   18c4e:	imul   %rbx,%r11
   18c52:	mov    %r11,%r12
   18c55:	shr    $0x20,%r12
   18c59:	xor    %r11,%r12
   18c5c:	imul   %rbx,%r12
   18c60:	mov    %r12,%r11
   18c63:	shr    $0x20,%r11
   18c67:	xor    %r12,%r11
   18c6a:	mov    %r11,(%rdx,%r8,8)
   18c6e:	inc    %r8
   18c71:	dec    %r10
   18c74:	jne    18c40 <void run<bloom_filters::Split64RangeBloomFilter, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xd70>
   18c76:	sub    %rsi,%rdi
   18c79:	cmp    $0xfffffffffffffffc,%rdi
   18c7d:	mov    0x68(%rsp),%r12
   18c82:	ja     18d7b <void run<bloom_filters::Split64RangeBloomFilter, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xeab>
   18c88:	add    %r15,%rax
   18c8b:	mov    0x3a8(%rsp),%rdi
   18c93:	cmp    %rax,%rdi
   18c96:	cmovb  %rdi,%rax
   18c9a:	sub    %r8,%rax
   18c9d:	lea    0x18(%rdx,%r8,8),%rdx
   18ca2:	mov    0x10(%rsp),%rdi
   18ca7:	lea    (%rdi,%r8,8),%rdi
   18cab:	add    %rdi,%rcx
   18cae:	xor    %edi,%edi
   18cb0:	mov    -0x10(%rcx,%rdi,8),%r8
   18cb5:	mov    %r8,%r9
   18cb8:	shr    $0x20,%r9
   18cbc:	xor    %r8,%r9
   18cbf:	imul   %rbx,%r9
   18cc3:	mov    %r9,%r8
   18cc6:	shr    $0x20,%r8
   18cca:	xor    %r9,%r8
   18ccd:	imul   %rbx,%r8
   18cd1:	mov    %r8,%r9
   18cd4:	shr    $0x20,%r9
   18cd8:	xor    %r8,%r9
   18cdb:	mov    %r9,-0x18(%rdx,%rdi,8)
   18ce0:	mov    -0x8(%rcx,%rdi,8),%r8
   18ce5:	mov    %r8,%r9
   18ce8:	shr    $0x20,%r9
   18cec:	xor    %r8,%r9
   18cef:	imul   %rbx,%r9
   18cf3:	mov    %r9,%r8
   18cf6:	shr    $0x20,%r8
   18cfa:	xor    %r9,%r8
   18cfd:	imul   %rbx,%r8
   18d01:	mov    %r8,%r9
   18d04:	shr    $0x20,%r9
   18d08:	xor    %r8,%r9
   18d0b:	mov    %r9,-0x10(%rdx,%rdi,8)
   18d10:	mov    (%rcx,%rdi,8),%r8
   18d14:	mov    %r8,%r9
   18d17:	shr    $0x20,%r9
   18d1b:	xor    %r8,%r9
   18d1e:	imul   %rbx,%r9
   18d22:	mov    %r9,%r8
   18d25:	shr    $0x20,%r8
   18d29:	xor    %r9,%r8
   18d2c:	imul   %rbx,%r8
   18d30:	mov    %r8,%r9
   18d33:	shr    $0x20,%r9
   18d37:	xor    %r8,%r9
   18d3a:	mov    %r9,-0x8(%rdx,%rdi,8)
   18d3f:	mov    0x8(%rcx,%rdi,8),%r8
   18d44:	mov    %r8,%r9
   18d47:	shr    $0x20,%r9
   18d4b:	xor    %r8,%r9
   18d4e:	imul   %rbx,%r9
   18d52:	mov    %r9,%r8
   18d55:	shr    $0x20,%r8
   18d59:	xor    %r9,%r8
   18d5c:	imul   %rbx,%r8
   18d60:	mov    %r8,%r9
   18d63:	shr    $0x20,%r9
   18d67:	xor    %r8,%r9
   18d6a:	mov    %r9,(%rdx,%rdi,8)
   18d6e:	add    $0x4,%rdi
   18d72:	cmp    %rdi,%rax
   18d75:	jne    18cb0 <void run<bloom_filters::Split64RangeBloomFilter, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xde0>
   18d7b:	mov    0x180(%rsp),%rdx
   18d83:	lea    0x220(%rsp),%rdi
   18d8b:	vzeroupper
   18d8e:	call   1bb30 <void insert<bloom_filters::Split64RangeBloomFilter, unsigned long>(bloom_filters::Split64RangeBloomFilter&, unsigned long, unsigned long const*)>
   18d93:	mov    0x3a8(%rsp),%rcx
   18d9b:	add    %rcx,%r14
   18d9e:	mov    0x18(%rsp),%rax
   18da3:	inc    %r13
   18da6:	sub    %rcx,%r15
   18da9:	mov    0x48(%rsp),%rdx
   18dae:	add    %rdx,%r12
   18db1:	add    %rdx,%rbp
   18db4:	add    %rdx,0x10(%rsp)
   18db9:	cmp    %rax,%r14
   18dbc:	jb     18bc0 <void run<bloom_filters::Split64RangeBloomFilter, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xcf0>
   18dc2:	jmp    18f80 <void run<bloom_filters::Split64RangeBloomFilter, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0x10b0>
   18dc7:	cmp    $0x10,%rsi
   18dcb:	jae    18dd4 <void run<bloom_filters::Split64RangeBloomFilter, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xf04>
   18dcd:	xor    %edi,%edi
   18dcf:	jmp    18f02 <void run<bloom_filters::Split64RangeBloomFilter, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0x1032>
   18dd4:	mov    %rsi,%rdi
   18dd7:	and    $0xfffffffffffffff0,%rdi
   18ddb:	lea    (%rax,%r15,1),%r8
   18ddf:	mov    0x3a8(%rsp),%r9
   18de7:	cmp    %r8,%r9
   18dea:	cmovb  %r9,%r8
   18dee:	and    $0xfffffffffffffff0,%r8
   18df2:	lea    (%rcx,%r12,1),%r9
   18df6:	xor    %r10d,%r10d
   18df9:	vpbroadcastq -0x16c32(%rip),%ymm8        # 21d0 <_IO_stdin_used+0xf4>
   18e02:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   18e10:	vmovdqu -0x60(%r9,%r10,8),%ymm0
   18e17:	vmovdqu -0x40(%r9,%r10,8),%ymm1
   18e1e:	vmovdqu -0x20(%r9,%r10,8),%ymm2
   18e25:	vmovdqu (%r9,%r10,8),%ymm3
   18e2b:	vpsrlq $0x20,%ymm0,%ymm4
   18e30:	vpsrlq $0x20,%ymm1,%ymm5
   18e35:	vpsrlq $0x20,%ymm2,%ymm6
   18e3a:	vpsrlq $0x20,%ymm3,%ymm7
   18e3f:	vpxor  %ymm0,%ymm4,%ymm0
   18e43:	vpxor  %ymm1,%ymm5,%ymm1
   18e47:	vpxor  %ymm2,%ymm6,%ymm2
   18e4b:	vpmullq %ymm8,%ymm0,%ymm0
   18e51:	vpmullq %ymm8,%ymm1,%ymm1
   18e57:	vpmullq %ymm8,%ymm2,%ymm2
   18e5d:	vpxor  %ymm3,%ymm7,%ymm3
   18e61:	vpmullq %ymm8,%ymm3,%ymm3
   18e67:	vpsrlq $0x20,%ymm0,%ymm4
   18e6c:	vpsrlq $0x20,%ymm1,%ymm5
   18e71:	vpsrlq $0x20,%ymm2,%ymm6
   18e76:	vpsrlq $0x20,%ymm3,%ymm7
   18e7b:	vpxor  %ymm0,%ymm4,%ymm0
   18e7f:	vpxor  %ymm1,%ymm5,%ymm1
   18e83:	vpxor  %ymm2,%ymm6,%ymm2
   18e87:	vpxor  %ymm3,%ymm7,%ymm3
   18e8b:	vpmullq %ymm8,%ymm0,%ymm0
   18e91:	vpmullq %ymm8,%ymm1,%ymm1
   18e97:	vpmullq %ymm8,%ymm2,%ymm2
   18e9d:	vpmullq %ymm8,%ymm3,%ymm3
   18ea3:	vpsrlq $0x20,%ymm0,%ymm4
   18ea8:	vpsrlq $0x20,%ymm1,%ymm5
   18ead:	vpsrlq $0x20,%ymm2,%ymm6
   18eb2:	vpsrlq $0x20,%ymm3,%ymm7
   18eb7:	vpxor  %ymm0,%ymm4,%ymm0
   18ebb:	vpxor  %ymm1,%ymm5,%ymm1
   18ebf:	vpxor  %ymm2,%ymm6,%ymm2
   18ec3:	vpxor  %ymm3,%ymm7,%ymm3
   18ec7:	vmovdqu %ymm0,(%rdx,%r10,8)
   18ecd:	vmovdqu %ymm1,0x20(%rdx,%r10,8)
   18ed4:	vmovdqu %ymm2,0x40(%rdx,%r10,8)
   18edb:	vmovdqu %ymm3,0x60(%rdx,%r10,8)
   18ee2:	add    $0x10,%r10
   18ee6:	cmp    %r10,%r8
   18ee9:	jne    18e10 <void run<bloom_filters::Split64RangeBloomFilter, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xf40>
   18eef:	cmp    %rdi,%rsi
   18ef2:	je     18d7b <void run<bloom_filters::Split64RangeBloomFilter, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xeab>
   18ef8:	test   $0xc,%sil
   18efc:	je     18c0a <void run<bloom_filters::Split64RangeBloomFilter, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xd3a>
   18f02:	mov    %rdi,%r8
   18f05:	mov    %rsi,%rdi
   18f08:	and    $0xfffffffffffffffc,%rdi
   18f0c:	lea    (%rax,%r15,1),%r9
   18f10:	mov    0x3a8(%rsp),%r10
   18f18:	cmp    %r9,%r10
   18f1b:	cmovb  %r10,%r9
   18f1f:	and    $0xfffffffffffffffc,%r9
   18f23:	lea    (%rcx,%rbp,1),%r10
   18f27:	vpbroadcastq -0x16d60(%rip),%ymm2        # 21d0 <_IO_stdin_used+0xf4>
   18f30:	vmovdqu (%r10,%r8,8),%ymm0
   18f36:	vpsrlq $0x20,%ymm0,%ymm1
   18f3b:	vpxor  %ymm0,%ymm1,%ymm0
   18f3f:	vpmullq %ymm2,%ymm0,%ymm0
   18f45:	vpsrlq $0x20,%ymm0,%ymm1
   18f4a:	vpxor  %ymm0,%ymm1,%ymm0
   18f4e:	vpmullq %ymm2,%ymm0,%ymm0
   18f54:	vpsrlq $0x20,%ymm0,%ymm1
   18f59:	vpxor  %ymm0,%ymm1,%ymm0
   18f5d:	vmovdqu %ymm0,(%rdx,%r8,8)
   18f63:	add    $0x4,%r8
   18f67:	cmp    %r8,%r9
   18f6a:	jne    18f30 <void run<bloom_filters::Split64RangeBloomFilter, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0x1060>
   18f6c:	cmp    %rdi,%rsi
   18f6f:	je     18d7b <void run<bloom_filters::Split64RangeBloomFilter, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xeab>
   18f75:	jmp    18c0a <void run<bloom_filters::Split64RangeBloomFilter, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xd3a>
   18f7a:	nopw   0x0(%rax,%rax,1)
   18f80:	call   1d5f0 <std::chrono::_V2::steady_clock::now()@plt>
