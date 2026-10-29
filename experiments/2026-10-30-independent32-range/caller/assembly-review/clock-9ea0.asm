    bb16:	add    $0x8,%r8
    bb1a:	cmp    %r8,%r9
    bb1d:	jne    bb10 <_Z3RunIN13bloom_filters29Independent32RangeBloomFilterEEvRK5PointRK4CaseRK5Input+0x1c70>
    bb1f:	cmp    %r9,%rdi
    bb22:	je     bb3f <_Z3RunIN13bloom_filters29Independent32RangeBloomFilterEEvRK5PointRK4CaseRK5Input+0x1c9f>
    bb24:	lea    0x40(%rcx,%rax,4),%rax
    bb29:	nopl   0x0(%rax)
    bb30:	movl   $0x2,(%rsi)
    bb36:	add    $0x4,%rsi
    bb3a:	cmp    %rax,%rsi
    bb3d:	jne    bb30 <_Z3RunIN13bloom_filters29Independent32RangeBloomFilterEEvRK5PointRK4CaseRK5Input+0x1c90>
    bb3f:	vzeroupper
    bb42:	call   2eab0 <_ZNSt6chrono3_V212steady_clock3nowEv@plt>
    bb47:	mov    %rax,0x98(%rsp)
    bb4f:	mov    %rbp,%rbx
    bb52:	cmp    $0x3,%ebp
    bb55:	ja     bf80 <_Z3RunIN13bloom_filters29Independent32RangeBloomFilterEEvRK5PointRK4CaseRK5Input+0x20e0>
    bb5b:	mov    %ebx,%eax
    bb5d:	lea    -0xa054(%rip),%rcx        # 1b10 <_IO_stdin_used+0x430>
    bb64:	movslq (%rcx,%rax,4),%rax
    bb68:	add    %rcx,%rax
    bb6b:	jmp    *%rax
    bb6d:	mov    0x78(%rsp),%rax
    bb72:	cmp    %rax,0x28(%rsp)
    bb77:	mov    (%rsp),%rbp
    bb7b:	je     bf80 <_Z3RunIN13bloom_filters29Independent32RangeBloomFilterEEvRK5PointRK4CaseRK5Input+0x20e0>
    bb81:	mov    0x10(%rsp),%rax
    bb86:	mov    0xc(%rax),%eax
    bb89:	xor    %r15d,%r15d
    bb8c:	nopl   0x0(%rax)
    bb90:	mov    %eax,%eax
    bb92:	mov    %rbp,%rsi
    bb95:	sub    %r15,%rsi
    bb98:	cmp    %rax,%rsi
    bb9b:	cmovae %rax,%rsi
    bb9f:	lea    0x0(,%r15,8),%rdx
    bba7:	mov    0x8(%rsp),%rax
    bbac:	add    0x48(%rax),%rdx
    bbb0:	mov    0x50(%rsp),%rax
    bbb5:	lea    0x40(%rax,%r15,4),%rcx
    bbba:	mov    %r12,%rdi
    bbbd:	call   26630 <_Z13lookup_kernelIN13bloom_filters29Independent32RangeBloomFilterEmEvRT_mPKT0_Pj>
    bbc2:	mov    0x10(%rsp),%rax
    bbc7:	mov    0xc(%rax),%eax
    bbca:	add    %rax,%r15
    bbcd:	cmp    %rbp,%r15
    bbd0:	jb     bb90 <_Z3RunIN13bloom_filters29Independent32RangeBloomFilterEEvRK5PointRK4CaseRK5Input+0x1cf0>
    bbd2:	jmp    bf80 <_Z3RunIN13bloom_filters29Independent32RangeBloomFilterEEvRK5PointRK4CaseRK5Input+0x20e0>
    bbd7:	mov    0x8(%rsp),%rax
    bbdc:	mov    0x48(%rax),%rdx
    bbe0:	mov    0x50(%rsp),%rcx
    bbe5:	add    $0x40,%rcx
    bbe9:	mov    %r12,%rdi
    bbec:	mov    (%rsp),%rsi
    bbf0:	call   26b70 <_Z20inline_single_kernelILb0EN13bloom_filters29Independent32RangeBloomFilterEmEvRKT0_mPKmPj>
    bbf5:	jmp    bf80 <_Z3RunIN13bloom_filters29Independent32RangeBloomFilterEEvRK5PointRK4CaseRK5Input+0x20e0>
    bbfa:	mov    0x8(%rsp),%rax
    bbff:	mov    0x18(%rax),%rdx
    bc03:	mov    0x50(%rsp),%rcx
    bc08:	add    $0x40,%rcx
    bc0c:	mov    %r12,%rdi
    bc0f:	mov    (%rsp),%rsi
    bc13:	call   26cb0 <_Z20inline_single_kernelILb1EN13bloom_filters29Independent32RangeBloomFilterEmEvRKT0_mPKmPj>
    bc18:	jmp    bf80 <_Z3RunIN13bloom_filters29Independent32RangeBloomFilterEEvRK5PointRK4CaseRK5Input+0x20e0>
    bc1d:	mov    0x78(%rsp),%rax
    bc22:	cmp    %rax,0x28(%rsp)
    bc27:	mov    (%rsp),%rsi
    bc2b:	je     bf80 <_Z3RunIN13bloom_filters29Independent32RangeBloomFilterEEvRK5PointRK4CaseRK5Input+0x20e0>
    bc31:	mov    0x10(%rsp),%rax
    bc36:	mov    0xc(%rax),%eax
    bc39:	xor    %ebp,%ebp
    bc3b:	nopl   0x0(%rax,%rax,1)
    bc40:	mov    %eax,%eax
    bc42:	sub    %rbp,%rsi
    bc45:	cmp    %rax,%rsi
    bc48:	cmovae %rax,%rsi
    bc4c:	test   %rsi,%rsi
    bc4f:	je     bdab <_Z3RunIN13bloom_filters29Independent32RangeBloomFilterEEvRK5PointRK4CaseRK5Input+0x1f0b>
    bc55:	mov    0x8(%rsp),%rax
    bc5a:	mov    0x18(%rax),%rax
    bc5e:	lea    (%rax,%rbp,8),%rcx
    bc62:	cmp    $0x4,%rsi
    bc66:	jb     bc7b <_Z3RunIN13bloom_filters29Independent32RangeBloomFilterEEvRK5PointRK4CaseRK5Input+0x1ddb>
    bc68:	mov    %r14,%rdx
    bc6b:	sub    %rcx,%rdx
    bc6e:	cmp    $0x80,%rdx
    bc75:	jae    bde0 <_Z3RunIN13bloom_filters29Independent32RangeBloomFilterEEvRK5PointRK4CaseRK5Input+0x1f40>
    bc7b:	xor    %edx,%edx
    bc7d:	mov    %rsi,%r8
    bc80:	mov    %rdx,%rdi
    bc83:	and    $0x3,%r8
    bc87:	je     bcc6 <_Z3RunIN13bloom_filters29Independent32RangeBloomFilterEEvRK5PointRK4CaseRK5Input+0x1e26>
    bc89:	mov    %rdx,%rdi
    bc8c:	nopl   0x0(%rax)
    bc90:	mov    (%rcx,%rdi,8),%r9
    bc94:	mov    %r9,%r10
    bc97:	shr    $0x20,%r10
    bc9b:	xor    %r9,%r10
    bc9e:	imul   %r13,%r10
    bca2:	mov    %r10,%r9
    bca5:	shr    $0x20,%r9
    bca9:	xor    %r10,%r9
    bcac:	imul   %r13,%r9
    bcb0:	mov    %r9,%r10
    bcb3:	shr    $0x20,%r10
    bcb7:	xor    %r9,%r10
    bcba:	mov    %r10,(%r14,%rdi,8)
    bcbe:	inc    %rdi
    bcc1:	dec    %r8
    bcc4:	jne    bc90 <_Z3RunIN13bloom_filters29Independent32RangeBloomFilterEEvRK5PointRK4CaseRK5Input+0x1df0>
    bcc6:	sub    %rsi,%rdx
    bcc9:	cmp    $0xfffffffffffffffc,%rdx
    bccd:	ja     bdab <_Z3RunIN13bloom_filters29Independent32RangeBloomFilterEEvRK5PointRK4CaseRK5Input+0x1f0b>
    bcd3:	lea    0x18(%rax,%rbp,8),%rax
    bcd8:	nopl   0x0(%rax,%rax,1)
    bce0:	mov    -0x18(%rax,%rdi,8),%rcx
    bce5:	mov    %rcx,%rdx
    bce8:	shr    $0x20,%rdx
    bcec:	xor    %rcx,%rdx
    bcef:	imul   %r13,%rdx
    bcf3:	mov    %rdx,%rcx
    bcf6:	shr    $0x20,%rcx
    bcfa:	xor    %rdx,%rcx
    bcfd:	imul   %r13,%rcx
    bd01:	mov    %rcx,%rdx
    bd04:	shr    $0x20,%rdx
    bd08:	xor    %rcx,%rdx
    bd0b:	mov    %rdx,(%r14,%rdi,8)
    bd0f:	mov    -0x10(%rax,%rdi,8),%rcx
    bd14:	mov    %rcx,%rdx
    bd17:	shr    $0x20,%rdx
    bd1b:	xor    %rcx,%rdx
    bd1e:	imul   %r13,%rdx
    bd22:	mov    %rdx,%rcx
    bd25:	shr    $0x20,%rcx
    bd29:	xor    %rdx,%rcx
    bd2c:	imul   %r13,%rcx
    bd30:	mov    %rcx,%rdx
    bd33:	shr    $0x20,%rdx
    bd37:	xor    %rcx,%rdx
    bd3a:	mov    %rdx,0x8(%r14,%rdi,8)
    bd3f:	mov    -0x8(%rax,%rdi,8),%rcx
    bd44:	mov    %rcx,%rdx
    bd47:	shr    $0x20,%rdx
    bd4b:	xor    %rcx,%rdx
    bd4e:	imul   %r13,%rdx
    bd52:	mov    %rdx,%rcx
    bd55:	shr    $0x20,%rcx
    bd59:	xor    %rdx,%rcx
    bd5c:	imul   %r13,%rcx
    bd60:	mov    %rcx,%rdx
    bd63:	shr    $0x20,%rdx
    bd67:	xor    %rcx,%rdx
    bd6a:	mov    %rdx,0x10(%r14,%rdi,8)
    bd6f:	mov    (%rax,%rdi,8),%rcx
    bd73:	mov    %rcx,%rdx
    bd76:	shr    $0x20,%rdx
    bd7a:	xor    %rcx,%rdx
    bd7d:	imul   %r13,%rdx
    bd81:	mov    %rdx,%rcx
    bd84:	shr    $0x20,%rcx
    bd88:	xor    %rdx,%rcx
    bd8b:	imul   %r13,%rcx
    bd8f:	mov    %rcx,%rdx
    bd92:	shr    $0x20,%rdx
    bd96:	xor    %rcx,%rdx
    bd99:	mov    %rdx,0x18(%r14,%rdi,8)
    bd9e:	add    $0x4,%rdi
    bda2:	cmp    %rdi,%rsi
    bda5:	jne    bce0 <_Z3RunIN13bloom_filters29Independent32RangeBloomFilterEEvRK5PointRK4CaseRK5Input+0x1e40>
    bdab:	mov    0x50(%rsp),%rax
    bdb0:	lea    0x40(%rax,%rbp,4),%rcx
    bdb5:	mov    %r12,%rdi
    bdb8:	mov    %r14,%rdx
    bdbb:	vzeroupper
    bdbe:	call   26630 <_Z13lookup_kernelIN13bloom_filters29Independent32RangeBloomFilterEmEvRT_mPKT0_Pj>
    bdc3:	mov    0x10(%rsp),%rax
    bdc8:	mov    0xc(%rax),%eax
    bdcb:	add    %rax,%rbp
    bdce:	mov    (%rsp),%rsi
    bdd2:	cmp    %rsi,%rbp
    bdd5:	jb     bc40 <_Z3RunIN13bloom_filters29Independent32RangeBloomFilterEEvRK5PointRK4CaseRK5Input+0x1da0>
    bddb:	jmp    bf80 <_Z3RunIN13bloom_filters29Independent32RangeBloomFilterEEvRK5PointRK4CaseRK5Input+0x20e0>
    bde0:	cmp    $0x10,%rsi
    bde4:	jae    bded <_Z3RunIN13bloom_filters29Independent32RangeBloomFilterEEvRK5PointRK4CaseRK5Input+0x1f4d>
    bde6:	xor    %edx,%edx
    bde8:	jmp    bf12 <_Z3RunIN13bloom_filters29Independent32RangeBloomFilterEEvRK5PointRK4CaseRK5Input+0x2072>
    bded:	lea    0x0(,%rbp,8),%r8
    bdf5:	mov    %esi,%edx
    bdf7:	and    $0xfffffff0,%edx
    bdfa:	lea    0x0(,%rsi,8),%rdi
    be02:	and    $0xffffffffffffff80,%rdi
    be06:	lea    0x60(%rax,%r8,1),%r8
    be0b:	xor    %r9d,%r9d
    be0e:	vpbroadcastq -0xa447(%rip),%ymm8        # 19d0 <_IO_stdin_used+0x2f0>
    be17:	nopw   0x0(%rax,%rax,1)
    be20:	vmovdqu -0x60(%r8,%r9,1),%ymm0
    be27:	vmovdqu -0x40(%r8,%r9,1),%ymm1
    be2e:	vmovdqu -0x20(%r8,%r9,1),%ymm2
    be35:	vmovdqu (%r8,%r9,1),%ymm3
    be3b:	vpsrlq $0x20,%ymm0,%ymm4
    be40:	vpsrlq $0x20,%ymm1,%ymm5
    be45:	vpsrlq $0x20,%ymm2,%ymm6
    be4a:	vpsrlq $0x20,%ymm3,%ymm7
    be4f:	vpxor  %ymm0,%ymm4,%ymm0
    be53:	vpxor  %ymm1,%ymm5,%ymm1
    be57:	vpxor  %ymm2,%ymm6,%ymm2
    be5b:	vpmullq %ymm8,%ymm0,%ymm0
    be61:	vpmullq %ymm8,%ymm1,%ymm1
    be67:	vpmullq %ymm8,%ymm2,%ymm2
    be6d:	vpxor  %ymm3,%ymm7,%ymm3
    be71:	vpmullq %ymm8,%ymm3,%ymm3
    be77:	vpsrlq $0x20,%ymm0,%ymm4
    be7c:	vpsrlq $0x20,%ymm1,%ymm5
    be81:	vpsrlq $0x20,%ymm2,%ymm6
    be86:	vpsrlq $0x20,%ymm3,%ymm7
    be8b:	vpxor  %ymm0,%ymm4,%ymm0
    be8f:	vpxor  %ymm1,%ymm5,%ymm1
    be93:	vpxor  %ymm2,%ymm6,%ymm2
    be97:	vpxor  %ymm3,%ymm7,%ymm3
    be9b:	vpmullq %ymm8,%ymm0,%ymm0
    bea1:	vpmullq %ymm8,%ymm1,%ymm1
    bea7:	vpmullq %ymm8,%ymm2,%ymm2
    bead:	vpmullq %ymm8,%ymm3,%ymm3
    beb3:	vpsrlq $0x20,%ymm0,%ymm4
    beb8:	vpsrlq $0x20,%ymm1,%ymm5
    bebd:	vpsrlq $0x20,%ymm2,%ymm6
    bec2:	vpsrlq $0x20,%ymm3,%ymm7
    bec7:	vpxor  %ymm0,%ymm4,%ymm0
    becb:	vpxor  %ymm1,%ymm5,%ymm1
    becf:	vpxor  %ymm2,%ymm6,%ymm2
    bed3:	vpxor  %ymm3,%ymm7,%ymm3
    bed7:	vmovdqu %ymm0,(%r14,%r9,1)
    bedd:	vmovdqu %ymm1,0x20(%r14,%r9,1)
    bee4:	vmovdqu %ymm2,0x40(%r14,%r9,1)
    beeb:	vmovdqu %ymm3,0x60(%r14,%r9,1)
    bef2:	sub    $0xffffffffffffff80,%r9
    bef6:	cmp    %r9,%rdi
    bef9:	jne    be20 <_Z3RunIN13bloom_filters29Independent32RangeBloomFilterEEvRK5PointRK4CaseRK5Input+0x1f80>
    beff:	cmp    %rdx,%rsi
    bf02:	je     bdab <_Z3RunIN13bloom_filters29Independent32RangeBloomFilterEEvRK5PointRK4CaseRK5Input+0x1f0b>
    bf08:	test   $0xc,%sil
    bf0c:	je     bc7d <_Z3RunIN13bloom_filters29Independent32RangeBloomFilterEEvRK5PointRK4CaseRK5Input+0x1ddd>
    bf12:	mov    %rdx,%rdi
    bf15:	mov    %esi,%edx
    bf17:	and    $0xfffffffc,%edx
    bf1a:	vpbroadcastq -0xa553(%rip),%ymm2        # 19d0 <_IO_stdin_used+0x2f0>
    bf23:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
    bf30:	vmovdqu (%rcx,%rdi,8),%ymm0
    bf35:	vpsrlq $0x20,%ymm0,%ymm1
    bf3a:	vpxor  %ymm0,%ymm1,%ymm0
    bf3e:	vpmullq %ymm2,%ymm0,%ymm0
    bf44:	vpsrlq $0x20,%ymm0,%ymm1
    bf49:	vpxor  %ymm0,%ymm1,%ymm0
    bf4d:	vpmullq %ymm2,%ymm0,%ymm0
    bf53:	vpsrlq $0x20,%ymm0,%ymm1
    bf58:	vpxor  %ymm0,%ymm1,%ymm0
    bf5c:	vmovdqu %ymm0,(%r14,%rdi,8)
    bf62:	add    $0x4,%rdi
    bf66:	cmp    %rdi,%rdx
    bf69:	jne    bf30 <_Z3RunIN13bloom_filters29Independent32RangeBloomFilterEEvRK5PointRK4CaseRK5Input+0x2090>
    bf6b:	cmp    %rdx,%rsi
    bf6e:	je     bdab <_Z3RunIN13bloom_filters29Independent32RangeBloomFilterEEvRK5PointRK4CaseRK5Input+0x1f0b>
    bf74:	jmp    bc7d <_Z3RunIN13bloom_filters29Independent32RangeBloomFilterEEvRK5PointRK4CaseRK5Input+0x1ddd>
    bf79:	nopl   0x0(%rax)
    bf80:	call   2eab0 <_ZNSt6chrono3_V212steady_clock3nowEv@plt>
    bf85:	sub    0x98(%rsp),%rax
    bf8d:	vcvtsi2sd %rax,%xmm15,%xmm0
    bf92:	vdivsd 0x148(%rsp),%xmm0,%xmm0
    bf9b:	vmovq  %xmm0,%rax
    bfa0:	mov    $0x3f,%cl
    bfa2:	bzhi   %rcx,%rax,%rcx
    bfa7:	movabs $0xfff0000000000000,%rdx
    bfb1:	add    %rdx,%rcx
    bfb4:	shr    $0x35,%rcx
    bfb8:	cmp    $0x3ff,%ecx
    bfbe:	setb   %cl
    bfc1:	test   %rax,%rax
    bfc4:	setns  %dl
    bfc7:	and    %cl,%dl
    bfc9:	dec    %rax
    bfcc:	movabs $0xfffffffffffff,%rcx
    bfd6:	cmp    %rcx,%rax
    bfd9:	setb   %al
    bfdc:	or     %dl,%al
    bfde:	je     ceef <_Z3RunIN13bloom_filters29Independent32RangeBloomFilterEEvRK5PointRK4CaseRK5Input+0x304f>
    bfe4:	lea    (%rbx,%rbx,2),%rax
    bfe8:	lea    0x160(%rsp,%rax,8),%rcx
    bff0:	mov    0x168(%rsp,%rax,8),%rbx
    bff8:	cmp    0x170(%rsp,%rax,8),%rbx
    c000:	je     c020 <_Z3RunIN13bloom_filters29Independent32RangeBloomFilterEEvRK5PointRK4CaseRK5Input+0x2180>
    c002:	vmovsd %xmm0,(%rbx)
    c006:	add    $0x8,%rbx
    c00a:	mov    %rbx,0x8(%rcx)
    c00e:	jmp    c0d7 <_Z3RunIN13bloom_filters29Independent32RangeBloomFilterEEvRK5PointRK4CaseRK5Input+0x2237>
    c013:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
    c020:	mov    (%rcx),%r15
    c023:	sub    %r15,%rbx
    c026:	movabs $0x7ffffffffffffff8,%rax
    c030:	cmp    %rax,%rbx
    c033:	je     cf30 <_Z3RunIN13bloom_filters29Independent32RangeBloomFilterEEvRK5PointRK4CaseRK5Input+0x3090>
    c039:	mov    %rcx,0x138(%rsp)
    c041:	vmovsd %xmm0,0x98(%rsp)
    c04a:	mov    %rbx,%rax
    c04d:	sar    $0x3,%rax
    c051:	cmp    $0x1,%rax
    c055:	mov    %rax,%rcx
    c058:	adc    $0x0,%rcx
    c05c:	lea    (%rcx,%rax,1),%rbp
    c060:	movabs $0xfffffffffffffff,%rdx
    c06a:	cmp    %rdx,%rbp
    c06d:	cmovae %rdx,%rbp
    c071:	add    %rax,%rcx
    c074:	cmovb  %rdx,%rbp
    c078:	lea    0x0(,%rbp,8),%rdi
    c080:	call   2ea50 <_Znwm@plt>
    c085:	mov    %rax,%r12
    c088:	vmovsd 0x98(%rsp),%xmm0
    c091:	vmovsd %xmm0,(%rax,%rbx,1)
    c096:	test   %rbx,%rbx
    c099:	jle    c0a9 <_Z3RunIN13bloom_filters29Independent32RangeBloomFilterEEvRK5PointRK4CaseRK5Input+0x2209>
    c09b:	mov    %r12,%rdi
    c09e:	mov    %r15,%rsi
    c0a1:	mov    %rbx,%rdx
    c0a4:	call   2ea70 <memmove@plt>
    c0a9:	test   %r15,%r15
    c0ac:	je     c0b9 <_Z3RunIN13bloom_filters29Independent32RangeBloomFilterEEvRK5PointRK4CaseRK5Input+0x2219>
    c0ae:	mov    %r15,%rdi
    c0b1:	mov    %rbx,%rsi
    c0b4:	call   2ea60 <_ZdlPvm@plt>
    c0b9:	add    %r12,%rbx
    c0bc:	mov    0x138(%rsp),%rcx
    c0c4:	mov    %r12,(%rcx)
    c0c7:	add    $0x8,%rbx
    c0cb:	mov    %rbx,0x8(%rcx)
    c0cf:	lea    (%r12,%rbp,8),%rax
    c0d3:	mov    %rax,0x10(%rcx)
    c0d7:	lea    0x50(%rsp),%rdi
    c0dc:	lea    0xa0(%rsp),%rsi
    c0e4:	call   26830 <_ZN6Output5CheckERKSt6vectorIjSaIjEE>
    c0e9:	mov    0xd8(%rsp),%r15
