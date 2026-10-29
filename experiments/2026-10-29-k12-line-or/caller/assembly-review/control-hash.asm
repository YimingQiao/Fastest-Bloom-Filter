    9df9:	call   16dd0 <std::chrono::_V2::steady_clock::now()@plt>
    9dfe:	mov    %rax,0x40(%rsp)
    9e03:	mov    0x18(%rsp),%rsi
    9e08:	lea    0x220(%rsp),%rdi
    9e10:	mov    %ebp,%edx
    9e12:	call   cc90 <bloom_filters::K12ScalarOrControl make_filter<bloom_filters::K12ScalarOrControl>(unsigned long, unsigned int)>
    9e17:	call   16dd0 <std::chrono::_V2::steady_clock::now()@plt>
    9e1c:	mov    %rax,0x78(%rsp)
    9e21:	mov    0x18(%rsp),%rax
    9e26:	test   %rax,%rax
    9e29:	mov    0x3a8(%rsp),%rcx
    9e31:	je     a220 <void run<bloom_filters::K12ScalarOrControl, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0x10b0>
    9e37:	mov    $0x60,%r12d
    9e3d:	mov    $0x10,%edx
    9e42:	mov    %rdx,0x10(%rsp)
    9e47:	xor    %ebp,%ebp
    9e49:	xor    %r15d,%r15d
    9e4c:	xor    %r13d,%r13d
    9e4f:	xor    %r14d,%r14d
    9e52:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
    9e60:	mov    %rax,%rsi
    9e63:	sub    %r14,%rsi
    9e66:	cmp    %rcx,%rsi
    9e69:	cmovae %rcx,%rsi
    9e6d:	mov    0x180(%rsp),%rdx
    9e75:	test   %rsi,%rsi
    9e78:	je     a023 <void run<bloom_filters::K12ScalarOrControl, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xeb3>
    9e7e:	mov    0x20(%rsp),%rcx
    9e83:	mov    (%rcx),%rcx
    9e86:	cmp    $0x4,%rsi
    9e8a:	jb     9ea8 <void run<bloom_filters::K12ScalarOrControl, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xd38>
    9e8c:	mov    0x30(%rsp),%rdi
    9e91:	imul   %r13,%rdi
    9e95:	add    %rdx,%rdi
    9e98:	sub    %rcx,%rdi
    9e9b:	cmp    $0x80,%rdi
    9ea2:	jae    a067 <void run<bloom_filters::K12ScalarOrControl, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xef7>
    9ea8:	xor    %edi,%edi
    9eaa:	mov    %r12,0x68(%rsp)
    9eaf:	mov    %rdi,%r8
    9eb2:	test   $0x3,%sil
    9eb6:	je     9f16 <void run<bloom_filters::K12ScalarOrControl, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xda6>
    9eb8:	lea    (%rcx,%rbp,1),%r9
    9ebc:	lea    (%rax,%r15,1),%r10
    9ec0:	mov    0x3a8(%rsp),%r8
    9ec8:	cmp    %r10,%r8
    9ecb:	cmovb  %r8,%r10
    9ecf:	and    $0x3,%r10d
    9ed3:	mov    %rdi,%r8
    9ed6:	cs nopw 0x0(%rax,%rax,1)
    9ee0:	mov    (%r9,%r8,8),%r12
    9ee4:	mov    %r12,%r11
    9ee7:	shr    $0x20,%r11
    9eeb:	xor    %r12,%r11
    9eee:	imul   %rbx,%r11
    9ef2:	mov    %r11,%r12
    9ef5:	shr    $0x20,%r12
    9ef9:	xor    %r11,%r12
    9efc:	imul   %rbx,%r12
    9f00:	mov    %r12,%r11
    9f03:	shr    $0x20,%r11
    9f07:	xor    %r12,%r11
    9f0a:	mov    %r11,(%rdx,%r8,8)
    9f0e:	inc    %r8
    9f11:	dec    %r10
    9f14:	jne    9ee0 <void run<bloom_filters::K12ScalarOrControl, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xd70>
    9f16:	sub    %rsi,%rdi
    9f19:	cmp    $0xfffffffffffffffc,%rdi
    9f1d:	mov    0x68(%rsp),%r12
    9f22:	ja     a01b <void run<bloom_filters::K12ScalarOrControl, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xeab>
    9f28:	add    %r15,%rax
    9f2b:	mov    0x3a8(%rsp),%rdi
    9f33:	cmp    %rax,%rdi
    9f36:	cmovb  %rdi,%rax
    9f3a:	sub    %r8,%rax
    9f3d:	lea    0x18(%rdx,%r8,8),%rdx
    9f42:	mov    0x10(%rsp),%rdi
    9f47:	lea    (%rdi,%r8,8),%rdi
    9f4b:	add    %rdi,%rcx
    9f4e:	xor    %edi,%edi
    9f50:	mov    -0x10(%rcx,%rdi,8),%r8
    9f55:	mov    %r8,%r9
    9f58:	shr    $0x20,%r9
    9f5c:	xor    %r8,%r9
    9f5f:	imul   %rbx,%r9
    9f63:	mov    %r9,%r8
    9f66:	shr    $0x20,%r8
    9f6a:	xor    %r9,%r8
    9f6d:	imul   %rbx,%r8
    9f71:	mov    %r8,%r9
    9f74:	shr    $0x20,%r9
    9f78:	xor    %r8,%r9
    9f7b:	mov    %r9,-0x18(%rdx,%rdi,8)
    9f80:	mov    -0x8(%rcx,%rdi,8),%r8
    9f85:	mov    %r8,%r9
    9f88:	shr    $0x20,%r9
    9f8c:	xor    %r8,%r9
    9f8f:	imul   %rbx,%r9
    9f93:	mov    %r9,%r8
    9f96:	shr    $0x20,%r8
    9f9a:	xor    %r9,%r8
    9f9d:	imul   %rbx,%r8
    9fa1:	mov    %r8,%r9
    9fa4:	shr    $0x20,%r9
    9fa8:	xor    %r8,%r9
    9fab:	mov    %r9,-0x10(%rdx,%rdi,8)
    9fb0:	mov    (%rcx,%rdi,8),%r8
    9fb4:	mov    %r8,%r9
    9fb7:	shr    $0x20,%r9
    9fbb:	xor    %r8,%r9
    9fbe:	imul   %rbx,%r9
    9fc2:	mov    %r9,%r8
    9fc5:	shr    $0x20,%r8
    9fc9:	xor    %r9,%r8
    9fcc:	imul   %rbx,%r8
    9fd0:	mov    %r8,%r9
    9fd3:	shr    $0x20,%r9
    9fd7:	xor    %r8,%r9
    9fda:	mov    %r9,-0x8(%rdx,%rdi,8)
    9fdf:	mov    0x8(%rcx,%rdi,8),%r8
    9fe4:	mov    %r8,%r9
    9fe7:	shr    $0x20,%r9
    9feb:	xor    %r8,%r9
    9fee:	imul   %rbx,%r9
    9ff2:	mov    %r9,%r8
    9ff5:	shr    $0x20,%r8
    9ff9:	xor    %r9,%r8
    9ffc:	imul   %rbx,%r8
    a000:	mov    %r8,%r9
    a003:	shr    $0x20,%r9
    a007:	xor    %r8,%r9
    a00a:	mov    %r9,(%rdx,%rdi,8)
    a00e:	add    $0x4,%rdi
    a012:	cmp    %rdi,%rax
    a015:	jne    9f50 <void run<bloom_filters::K12ScalarOrControl, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xde0>
    a01b:	mov    0x180(%rsp),%rdx
    a023:	lea    0x220(%rsp),%rdi
    a02b:	vzeroupper
    a02e:	call   cdd0 <void insert<bloom_filters::K12ScalarOrControl, unsigned long>(bloom_filters::K12ScalarOrControl&, unsigned long, unsigned long const*)>
    a033:	mov    0x3a8(%rsp),%rcx
    a03b:	add    %rcx,%r14
    a03e:	mov    0x18(%rsp),%rax
    a043:	inc    %r13
    a046:	sub    %rcx,%r15
    a049:	mov    0x48(%rsp),%rdx
    a04e:	add    %rdx,%r12
    a051:	add    %rdx,%rbp
    a054:	add    %rdx,0x10(%rsp)
    a059:	cmp    %rax,%r14
    a05c:	jb     9e60 <void run<bloom_filters::K12ScalarOrControl, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xcf0>
    a062:	jmp    a220 <void run<bloom_filters::K12ScalarOrControl, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0x10b0>
    a067:	cmp    $0x10,%rsi
    a06b:	jae    a074 <void run<bloom_filters::K12ScalarOrControl, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xf04>
    a06d:	xor    %edi,%edi
    a06f:	jmp    a1a2 <void run<bloom_filters::K12ScalarOrControl, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0x1032>
    a074:	mov    %rsi,%rdi
    a077:	and    $0xfffffffffffffff0,%rdi
    a07b:	lea    (%rax,%r15,1),%r8
    a07f:	mov    0x3a8(%rsp),%r9
    a087:	cmp    %r8,%r9
    a08a:	cmovb  %r9,%r8
    a08e:	and    $0xfffffffffffffff0,%r8
    a092:	lea    (%rcx,%r12,1),%r9
    a096:	xor    %r10d,%r10d
    a099:	vpbroadcastq -0x7f32(%rip),%ymm8        # 2170 <_IO_stdin_used+0xd4>
    a0a2:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
    a0b0:	vmovdqu -0x60(%r9,%r10,8),%ymm0
    a0b7:	vmovdqu -0x40(%r9,%r10,8),%ymm1
    a0be:	vmovdqu -0x20(%r9,%r10,8),%ymm2
    a0c5:	vmovdqu (%r9,%r10,8),%ymm3
    a0cb:	vpsrlq $0x20,%ymm0,%ymm4
    a0d0:	vpsrlq $0x20,%ymm1,%ymm5
    a0d5:	vpsrlq $0x20,%ymm2,%ymm6
    a0da:	vpsrlq $0x20,%ymm3,%ymm7
    a0df:	vpxor  %ymm0,%ymm4,%ymm0
    a0e3:	vpxor  %ymm1,%ymm5,%ymm1
    a0e7:	vpxor  %ymm2,%ymm6,%ymm2
    a0eb:	vpmullq %ymm8,%ymm0,%ymm0
    a0f1:	vpmullq %ymm8,%ymm1,%ymm1
    a0f7:	vpmullq %ymm8,%ymm2,%ymm2
    a0fd:	vpxor  %ymm3,%ymm7,%ymm3
    a101:	vpmullq %ymm8,%ymm3,%ymm3
    a107:	vpsrlq $0x20,%ymm0,%ymm4
    a10c:	vpsrlq $0x20,%ymm1,%ymm5
    a111:	vpsrlq $0x20,%ymm2,%ymm6
    a116:	vpsrlq $0x20,%ymm3,%ymm7
    a11b:	vpxor  %ymm0,%ymm4,%ymm0
    a11f:	vpxor  %ymm1,%ymm5,%ymm1
    a123:	vpxor  %ymm2,%ymm6,%ymm2
    a127:	vpxor  %ymm3,%ymm7,%ymm3
    a12b:	vpmullq %ymm8,%ymm0,%ymm0
    a131:	vpmullq %ymm8,%ymm1,%ymm1
    a137:	vpmullq %ymm8,%ymm2,%ymm2
    a13d:	vpmullq %ymm8,%ymm3,%ymm3
    a143:	vpsrlq $0x20,%ymm0,%ymm4
    a148:	vpsrlq $0x20,%ymm1,%ymm5
    a14d:	vpsrlq $0x20,%ymm2,%ymm6
    a152:	vpsrlq $0x20,%ymm3,%ymm7
    a157:	vpxor  %ymm0,%ymm4,%ymm0
    a15b:	vpxor  %ymm1,%ymm5,%ymm1
    a15f:	vpxor  %ymm2,%ymm6,%ymm2
    a163:	vpxor  %ymm3,%ymm7,%ymm3
    a167:	vmovdqu %ymm0,(%rdx,%r10,8)
    a16d:	vmovdqu %ymm1,0x20(%rdx,%r10,8)
    a174:	vmovdqu %ymm2,0x40(%rdx,%r10,8)
    a17b:	vmovdqu %ymm3,0x60(%rdx,%r10,8)
    a182:	add    $0x10,%r10
    a186:	cmp    %r10,%r8
    a189:	jne    a0b0 <void run<bloom_filters::K12ScalarOrControl, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xf40>
    a18f:	cmp    %rdi,%rsi
    a192:	je     a01b <void run<bloom_filters::K12ScalarOrControl, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xeab>
    a198:	test   $0xc,%sil
    a19c:	je     9eaa <void run<bloom_filters::K12ScalarOrControl, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xd3a>
    a1a2:	mov    %rdi,%r8
    a1a5:	mov    %rsi,%rdi
    a1a8:	and    $0xfffffffffffffffc,%rdi
    a1ac:	lea    (%rax,%r15,1),%r9
    a1b0:	mov    0x3a8(%rsp),%r10
    a1b8:	cmp    %r9,%r10
    a1bb:	cmovb  %r10,%r9
    a1bf:	and    $0xfffffffffffffffc,%r9
    a1c3:	lea    (%rcx,%rbp,1),%r10
    a1c7:	vpbroadcastq -0x8060(%rip),%ymm2        # 2170 <_IO_stdin_used+0xd4>
    a1d0:	vmovdqu (%r10,%r8,8),%ymm0
    a1d6:	vpsrlq $0x20,%ymm0,%ymm1
    a1db:	vpxor  %ymm0,%ymm1,%ymm0
    a1df:	vpmullq %ymm2,%ymm0,%ymm0
    a1e5:	vpsrlq $0x20,%ymm0,%ymm1
    a1ea:	vpxor  %ymm0,%ymm1,%ymm0
    a1ee:	vpmullq %ymm2,%ymm0,%ymm0
    a1f4:	vpsrlq $0x20,%ymm0,%ymm1
    a1f9:	vpxor  %ymm0,%ymm1,%ymm0
    a1fd:	vmovdqu %ymm0,(%rdx,%r8,8)
    a203:	add    $0x4,%r8
    a207:	cmp    %r8,%r9
    a20a:	jne    a1d0 <void run<bloom_filters::K12ScalarOrControl, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0x1060>
    a20c:	cmp    %rdi,%rsi
    a20f:	je     a01b <void run<bloom_filters::K12ScalarOrControl, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xeab>
    a215:	jmp    9eaa <void run<bloom_filters::K12ScalarOrControl, unsigned long>(char const*, std::vector<unsigned long, std::allocator<unsigned long> > const&, std::vector<unsigned long, std::allocator<unsigned long> > const&, unsigned int, unsigned int, unsigned long, unsigned int, unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)+0xd3a>
    a21a:	nopw   0x0(%rax,%rax,1)
    a220:	call   16dd0 <std::chrono::_V2::steady_clock::now()@plt>
