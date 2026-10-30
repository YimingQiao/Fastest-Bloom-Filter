   1e946:	add    $0x8,%r8
   1e94a:	cmp    %r8,%r9
   1e94d:	jne    1e940 <_Z3RunIN14external_bloom7Fixed16EEvRK5PointRK4CaseRK5Input+0x1a40>
   1e94f:	cmp    %r9,%rdi
   1e952:	je     1e96f <_Z3RunIN14external_bloom7Fixed16EEvRK5PointRK4CaseRK5Input+0x1a6f>
   1e954:	lea    0x40(%rcx,%rax,4),%rax
   1e959:	nopl   0x0(%rax)
   1e960:	movl   $0x2,(%rsi)
   1e966:	add    $0x4,%rsi
   1e96a:	cmp    %rax,%rsi
   1e96d:	jne    1e960 <_Z3RunIN14external_bloom7Fixed16EEvRK5PointRK4CaseRK5Input+0x1a60>
   1e96f:	vzeroupper
   1e972:	call   2eab0 <_ZNSt6chrono3_V212steady_clock3nowEv@plt>
   1e977:	mov    %rax,0x88(%rsp)
   1e97f:	mov    %rbx,%rbp
   1e982:	cmp    $0x3,%ebx
   1e985:	ja     1edb0 <_Z3RunIN14external_bloom7Fixed16EEvRK5PointRK4CaseRK5Input+0x1eb0>
   1e98b:	mov    %ebp,%eax
   1e98d:	lea    -0x1ce24(%rip),%rcx        # 1b70 <_IO_stdin_used+0x490>
   1e994:	movslq (%rcx,%rax,4),%rax
   1e998:	add    %rcx,%rax
   1e99b:	jmp    *%rax
   1e99d:	mov    0x68(%rsp),%rax
   1e9a2:	cmp    %rax,0x70(%rsp)
   1e9a7:	mov    0x8(%rsp),%r15
   1e9ac:	je     1edb0 <_Z3RunIN14external_bloom7Fixed16EEvRK5PointRK4CaseRK5Input+0x1eb0>
   1e9b2:	mov    0x60(%rsp),%rax
   1e9b7:	mov    0xc(%rax),%eax
   1e9ba:	xor    %ebx,%ebx
   1e9bc:	nopl   0x0(%rax)
   1e9c0:	mov    %eax,%eax
   1e9c2:	mov    %r15,%rsi
   1e9c5:	sub    %rbx,%rsi
   1e9c8:	cmp    %rax,%rsi
   1e9cb:	cmovae %rax,%rsi
   1e9cf:	lea    0x0(,%rbx,8),%rdx
   1e9d7:	mov    (%rsp),%rax
   1e9db:	add    0x48(%rax),%rdx
   1e9df:	mov    0x40(%rsp),%rax
   1e9e4:	lea    0x40(%rax,%rbx,4),%rcx
   1e9e9:	mov    %r12,%rdi
   1e9ec:	call   2cab0 <_Z13lookup_kernelIN14external_bloom7Fixed16EmEvRT_mPKT0_Pj>
   1e9f1:	mov    0x60(%rsp),%rax
   1e9f6:	mov    0xc(%rax),%eax
   1e9f9:	add    %rax,%rbx
   1e9fc:	cmp    %r15,%rbx
   1e9ff:	jb     1e9c0 <_Z3RunIN14external_bloom7Fixed16EEvRK5PointRK4CaseRK5Input+0x1ac0>
   1ea01:	jmp    1edb0 <_Z3RunIN14external_bloom7Fixed16EEvRK5PointRK4CaseRK5Input+0x1eb0>
   1ea06:	mov    (%rsp),%rax
   1ea0a:	mov    0x48(%rax),%rdx
   1ea0e:	mov    0x40(%rsp),%rcx
   1ea13:	add    $0x40,%rcx
   1ea17:	mov    %r12,%rdi
   1ea1a:	mov    0x8(%rsp),%rsi
   1ea1f:	call   2cbd0 <_Z20inline_single_kernelILb0EN14external_bloom7Fixed16EmEvRKT0_mPKmPj>
   1ea24:	jmp    1edb0 <_Z3RunIN14external_bloom7Fixed16EEvRK5PointRK4CaseRK5Input+0x1eb0>
   1ea29:	mov    (%rsp),%rax
   1ea2d:	mov    0x18(%rax),%rdx
   1ea31:	mov    0x40(%rsp),%rcx
   1ea36:	add    $0x40,%rcx
   1ea3a:	mov    %r12,%rdi
   1ea3d:	mov    0x8(%rsp),%rsi
   1ea42:	call   2cce0 <_Z20inline_single_kernelILb1EN14external_bloom7Fixed16EmEvRKT0_mPKmPj>
   1ea47:	jmp    1edb0 <_Z3RunIN14external_bloom7Fixed16EEvRK5PointRK4CaseRK5Input+0x1eb0>
   1ea4c:	mov    0x68(%rsp),%rax
   1ea51:	cmp    %rax,0x70(%rsp)
   1ea56:	mov    0x8(%rsp),%rsi
   1ea5b:	je     1edb0 <_Z3RunIN14external_bloom7Fixed16EEvRK5PointRK4CaseRK5Input+0x1eb0>
   1ea61:	mov    0x60(%rsp),%rax
   1ea66:	mov    0xc(%rax),%eax
   1ea69:	xor    %r15d,%r15d
   1ea6c:	nopl   0x0(%rax)
   1ea70:	mov    %eax,%eax
   1ea72:	sub    %r15,%rsi
   1ea75:	cmp    %rax,%rsi
   1ea78:	cmovae %rax,%rsi
   1ea7c:	test   %rsi,%rsi
   1ea7f:	je     1ebdb <_Z3RunIN14external_bloom7Fixed16EEvRK5PointRK4CaseRK5Input+0x1cdb>
   1ea85:	mov    (%rsp),%rax
   1ea89:	mov    0x18(%rax),%rax
   1ea8d:	lea    (%rax,%r15,8),%rcx
   1ea91:	cmp    $0x4,%rsi
   1ea95:	jb     1eaaa <_Z3RunIN14external_bloom7Fixed16EEvRK5PointRK4CaseRK5Input+0x1baa>
   1ea97:	mov    %r14,%rdx
   1ea9a:	sub    %rcx,%rdx
   1ea9d:	cmp    $0x80,%rdx
   1eaa4:	jae    1ec11 <_Z3RunIN14external_bloom7Fixed16EEvRK5PointRK4CaseRK5Input+0x1d11>
   1eaaa:	xor    %edx,%edx
   1eaac:	mov    %rsi,%r8
   1eaaf:	mov    %rdx,%rdi
   1eab2:	and    $0x3,%r8
   1eab6:	je     1eaf6 <_Z3RunIN14external_bloom7Fixed16EEvRK5PointRK4CaseRK5Input+0x1bf6>
   1eab8:	mov    %rdx,%rdi
   1eabb:	nopl   0x0(%rax,%rax,1)
   1eac0:	mov    (%rcx,%rdi,8),%r9
   1eac4:	mov    %r9,%r10
   1eac7:	shr    $0x20,%r10
   1eacb:	xor    %r9,%r10
   1eace:	imul   %r13,%r10
   1ead2:	mov    %r10,%r9
   1ead5:	shr    $0x20,%r9
   1ead9:	xor    %r10,%r9
   1eadc:	imul   %r13,%r9
   1eae0:	mov    %r9,%r10
   1eae3:	shr    $0x20,%r10
   1eae7:	xor    %r9,%r10
   1eaea:	mov    %r10,(%r14,%rdi,8)
   1eaee:	inc    %rdi
   1eaf1:	dec    %r8
   1eaf4:	jne    1eac0 <_Z3RunIN14external_bloom7Fixed16EEvRK5PointRK4CaseRK5Input+0x1bc0>
   1eaf6:	sub    %rsi,%rdx
   1eaf9:	cmp    $0xfffffffffffffffc,%rdx
   1eafd:	ja     1ebdb <_Z3RunIN14external_bloom7Fixed16EEvRK5PointRK4CaseRK5Input+0x1cdb>
   1eb03:	lea    0x18(%rax,%r15,8),%rax
   1eb08:	nopl   0x0(%rax,%rax,1)
   1eb10:	mov    -0x18(%rax,%rdi,8),%rcx
   1eb15:	mov    %rcx,%rdx
   1eb18:	shr    $0x20,%rdx
   1eb1c:	xor    %rcx,%rdx
   1eb1f:	imul   %r13,%rdx
   1eb23:	mov    %rdx,%rcx
   1eb26:	shr    $0x20,%rcx
   1eb2a:	xor    %rdx,%rcx
   1eb2d:	imul   %r13,%rcx
   1eb31:	mov    %rcx,%rdx
   1eb34:	shr    $0x20,%rdx
   1eb38:	xor    %rcx,%rdx
   1eb3b:	mov    %rdx,(%r14,%rdi,8)
   1eb3f:	mov    -0x10(%rax,%rdi,8),%rcx
   1eb44:	mov    %rcx,%rdx
   1eb47:	shr    $0x20,%rdx
   1eb4b:	xor    %rcx,%rdx
   1eb4e:	imul   %r13,%rdx
   1eb52:	mov    %rdx,%rcx
   1eb55:	shr    $0x20,%rcx
   1eb59:	xor    %rdx,%rcx
   1eb5c:	imul   %r13,%rcx
   1eb60:	mov    %rcx,%rdx
   1eb63:	shr    $0x20,%rdx
   1eb67:	xor    %rcx,%rdx
   1eb6a:	mov    %rdx,0x8(%r14,%rdi,8)
   1eb6f:	mov    -0x8(%rax,%rdi,8),%rcx
   1eb74:	mov    %rcx,%rdx
   1eb77:	shr    $0x20,%rdx
   1eb7b:	xor    %rcx,%rdx
   1eb7e:	imul   %r13,%rdx
   1eb82:	mov    %rdx,%rcx
   1eb85:	shr    $0x20,%rcx
   1eb89:	xor    %rdx,%rcx
   1eb8c:	imul   %r13,%rcx
   1eb90:	mov    %rcx,%rdx
   1eb93:	shr    $0x20,%rdx
   1eb97:	xor    %rcx,%rdx
   1eb9a:	mov    %rdx,0x10(%r14,%rdi,8)
   1eb9f:	mov    (%rax,%rdi,8),%rcx
   1eba3:	mov    %rcx,%rdx
   1eba6:	shr    $0x20,%rdx
   1ebaa:	xor    %rcx,%rdx
   1ebad:	imul   %r13,%rdx
   1ebb1:	mov    %rdx,%rcx
   1ebb4:	shr    $0x20,%rcx
   1ebb8:	xor    %rdx,%rcx
   1ebbb:	imul   %r13,%rcx
   1ebbf:	mov    %rcx,%rdx
   1ebc2:	shr    $0x20,%rdx
   1ebc6:	xor    %rcx,%rdx
   1ebc9:	mov    %rdx,0x18(%r14,%rdi,8)
   1ebce:	add    $0x4,%rdi
   1ebd2:	cmp    %rdi,%rsi
   1ebd5:	jne    1eb10 <_Z3RunIN14external_bloom7Fixed16EEvRK5PointRK4CaseRK5Input+0x1c10>
   1ebdb:	mov    0x40(%rsp),%rax
   1ebe0:	lea    0x40(%rax,%r15,4),%rcx
   1ebe5:	mov    %r12,%rdi
   1ebe8:	mov    %r14,%rdx
   1ebeb:	vzeroupper
   1ebee:	call   2cab0 <_Z13lookup_kernelIN14external_bloom7Fixed16EmEvRT_mPKT0_Pj>
   1ebf3:	mov    0x60(%rsp),%rax
   1ebf8:	mov    0xc(%rax),%eax
   1ebfb:	add    %rax,%r15
   1ebfe:	mov    0x8(%rsp),%rsi
   1ec03:	cmp    %rsi,%r15
   1ec06:	jb     1ea70 <_Z3RunIN14external_bloom7Fixed16EEvRK5PointRK4CaseRK5Input+0x1b70>
   1ec0c:	jmp    1edb0 <_Z3RunIN14external_bloom7Fixed16EEvRK5PointRK4CaseRK5Input+0x1eb0>
   1ec11:	cmp    $0x10,%rsi
   1ec15:	jae    1ec1e <_Z3RunIN14external_bloom7Fixed16EEvRK5PointRK4CaseRK5Input+0x1d1e>
   1ec17:	xor    %edx,%edx
   1ec19:	jmp    1ed42 <_Z3RunIN14external_bloom7Fixed16EEvRK5PointRK4CaseRK5Input+0x1e42>
   1ec1e:	lea    0x0(,%r15,8),%r8
   1ec26:	mov    %esi,%edx
   1ec28:	and    $0xfffffff0,%edx
   1ec2b:	lea    0x0(,%rsi,8),%rdi
   1ec33:	and    $0xffffffffffffff80,%rdi
   1ec37:	lea    0x60(%rax,%r8,1),%r8
   1ec3c:	xor    %r9d,%r9d
   1ec3f:	vpbroadcastq -0x1d278(%rip),%ymm8        # 19d0 <_IO_stdin_used+0x2f0>
   1ec48:	nopl   0x0(%rax,%rax,1)
   1ec50:	vmovdqu -0x60(%r8,%r9,1),%ymm0
   1ec57:	vmovdqu -0x40(%r8,%r9,1),%ymm1
   1ec5e:	vmovdqu -0x20(%r8,%r9,1),%ymm2
   1ec65:	vmovdqu (%r8,%r9,1),%ymm3
   1ec6b:	vpsrlq $0x20,%ymm0,%ymm4
   1ec70:	vpsrlq $0x20,%ymm1,%ymm5
   1ec75:	vpsrlq $0x20,%ymm2,%ymm6
   1ec7a:	vpsrlq $0x20,%ymm3,%ymm7
   1ec7f:	vpxor  %ymm0,%ymm4,%ymm0
   1ec83:	vpxor  %ymm1,%ymm5,%ymm1
   1ec87:	vpxor  %ymm2,%ymm6,%ymm2
   1ec8b:	vpmullq %ymm8,%ymm0,%ymm0
   1ec91:	vpmullq %ymm8,%ymm1,%ymm1
   1ec97:	vpmullq %ymm8,%ymm2,%ymm2
   1ec9d:	vpxor  %ymm3,%ymm7,%ymm3
   1eca1:	vpmullq %ymm8,%ymm3,%ymm3
   1eca7:	vpsrlq $0x20,%ymm0,%ymm4
   1ecac:	vpsrlq $0x20,%ymm1,%ymm5
   1ecb1:	vpsrlq $0x20,%ymm2,%ymm6
   1ecb6:	vpsrlq $0x20,%ymm3,%ymm7
   1ecbb:	vpxor  %ymm0,%ymm4,%ymm0
   1ecbf:	vpxor  %ymm1,%ymm5,%ymm1
   1ecc3:	vpxor  %ymm2,%ymm6,%ymm2
   1ecc7:	vpxor  %ymm3,%ymm7,%ymm3
   1eccb:	vpmullq %ymm8,%ymm0,%ymm0
   1ecd1:	vpmullq %ymm8,%ymm1,%ymm1
   1ecd7:	vpmullq %ymm8,%ymm2,%ymm2
   1ecdd:	vpmullq %ymm8,%ymm3,%ymm3
   1ece3:	vpsrlq $0x20,%ymm0,%ymm4
   1ece8:	vpsrlq $0x20,%ymm1,%ymm5
   1eced:	vpsrlq $0x20,%ymm2,%ymm6
   1ecf2:	vpsrlq $0x20,%ymm3,%ymm7
   1ecf7:	vpxor  %ymm0,%ymm4,%ymm0
   1ecfb:	vpxor  %ymm1,%ymm5,%ymm1
   1ecff:	vpxor  %ymm2,%ymm6,%ymm2
   1ed03:	vpxor  %ymm3,%ymm7,%ymm3
   1ed07:	vmovdqu %ymm0,(%r14,%r9,1)
   1ed0d:	vmovdqu %ymm1,0x20(%r14,%r9,1)
   1ed14:	vmovdqu %ymm2,0x40(%r14,%r9,1)
   1ed1b:	vmovdqu %ymm3,0x60(%r14,%r9,1)
   1ed22:	sub    $0xffffffffffffff80,%r9
   1ed26:	cmp    %r9,%rdi
   1ed29:	jne    1ec50 <_Z3RunIN14external_bloom7Fixed16EEvRK5PointRK4CaseRK5Input+0x1d50>
   1ed2f:	cmp    %rdx,%rsi
   1ed32:	je     1ebdb <_Z3RunIN14external_bloom7Fixed16EEvRK5PointRK4CaseRK5Input+0x1cdb>
   1ed38:	test   $0xc,%sil
   1ed3c:	je     1eaac <_Z3RunIN14external_bloom7Fixed16EEvRK5PointRK4CaseRK5Input+0x1bac>
   1ed42:	mov    %rdx,%rdi
   1ed45:	mov    %esi,%edx
   1ed47:	and    $0xfffffffc,%edx
   1ed4a:	vpbroadcastq -0x1d383(%rip),%ymm2        # 19d0 <_IO_stdin_used+0x2f0>
   1ed53:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   1ed60:	vmovdqu (%rcx,%rdi,8),%ymm0
   1ed65:	vpsrlq $0x20,%ymm0,%ymm1
   1ed6a:	vpxor  %ymm0,%ymm1,%ymm0
   1ed6e:	vpmullq %ymm2,%ymm0,%ymm0
   1ed74:	vpsrlq $0x20,%ymm0,%ymm1
   1ed79:	vpxor  %ymm0,%ymm1,%ymm0
   1ed7d:	vpmullq %ymm2,%ymm0,%ymm0
   1ed83:	vpsrlq $0x20,%ymm0,%ymm1
   1ed88:	vpxor  %ymm0,%ymm1,%ymm0
   1ed8c:	vmovdqu %ymm0,(%r14,%rdi,8)
   1ed92:	add    $0x4,%rdi
   1ed96:	cmp    %rdi,%rdx
   1ed99:	jne    1ed60 <_Z3RunIN14external_bloom7Fixed16EEvRK5PointRK4CaseRK5Input+0x1e60>
   1ed9b:	cmp    %rdx,%rsi
   1ed9e:	je     1ebdb <_Z3RunIN14external_bloom7Fixed16EEvRK5PointRK4CaseRK5Input+0x1cdb>
   1eda4:	jmp    1eaac <_Z3RunIN14external_bloom7Fixed16EEvRK5PointRK4CaseRK5Input+0x1bac>
   1eda9:	nopl   0x0(%rax)
   1edb0:	call   2eab0 <_ZNSt6chrono3_V212steady_clock3nowEv@plt>
   1edb5:	sub    0x88(%rsp),%rax
   1edbd:	vcvtsi2sd %rax,%xmm15,%xmm0
   1edc2:	vdivsd 0x128(%rsp),%xmm0,%xmm0
   1edcb:	vmovq  %xmm0,%rax
   1edd0:	mov    $0x3f,%cl
   1edd2:	bzhi   %rcx,%rax,%rcx
   1edd7:	movabs $0xfff0000000000000,%rdx
   1ede1:	add    %rdx,%rcx
   1ede4:	shr    $0x35,%rcx
   1ede8:	cmp    $0x3ff,%ecx
   1edee:	setb   %cl
   1edf1:	test   %rax,%rax
   1edf4:	setns  %dl
   1edf7:	and    %cl,%dl
   1edf9:	dec    %rax
   1edfc:	movabs $0xfffffffffffff,%rcx
   1ee06:	cmp    %rcx,%rax
   1ee09:	setb   %al
   1ee0c:	or     %dl,%al
   1ee0e:	je     1fba7 <_Z3RunIN14external_bloom7Fixed16EEvRK5PointRK4CaseRK5Input+0x2ca7>
   1ee14:	lea    0x0(%rbp,%rbp,2),%rax
   1ee19:	lea    0x140(%rsp,%rax,8),%rcx
   1ee21:	mov    0x148(%rsp,%rax,8),%rbp
   1ee29:	cmp    0x150(%rsp,%rax,8),%rbp
   1ee31:	je     1ee50 <_Z3RunIN14external_bloom7Fixed16EEvRK5PointRK4CaseRK5Input+0x1f50>
   1ee33:	vmovsd %xmm0,0x0(%rbp)
   1ee38:	add    $0x8,%rbp
   1ee3c:	mov    %rbp,0x8(%rcx)
   1ee40:	jmp    1ef07 <_Z3RunIN14external_bloom7Fixed16EEvRK5PointRK4CaseRK5Input+0x2007>
   1ee45:	data16 cs nopw 0x0(%rax,%rax,1)
   1ee50:	mov    (%rcx),%rbx
   1ee53:	sub    %rbx,%rbp
   1ee56:	movabs $0x7ffffffffffffff8,%rax
   1ee60:	cmp    %rax,%rbp
   1ee63:	je     1fbed <_Z3RunIN14external_bloom7Fixed16EEvRK5PointRK4CaseRK5Input+0x2ced>
   1ee69:	mov    %rcx,0x118(%rsp)
   1ee71:	vmovsd %xmm0,0x88(%rsp)
   1ee7a:	mov    %rbp,%rax
   1ee7d:	sar    $0x3,%rax
   1ee81:	cmp    $0x1,%rax
   1ee85:	mov    %rax,%rcx
   1ee88:	adc    $0x0,%rcx
   1ee8c:	lea    (%rcx,%rax,1),%r15
   1ee90:	movabs $0xfffffffffffffff,%rdx
   1ee9a:	cmp    %rdx,%r15
   1ee9d:	cmovae %rdx,%r15
   1eea1:	add    %rax,%rcx
   1eea4:	cmovb  %rdx,%r15
   1eea8:	lea    0x0(,%r15,8),%rdi
   1eeb0:	call   2ea50 <_Znwm@plt>
   1eeb5:	mov    %rax,%r12
   1eeb8:	vmovsd 0x88(%rsp),%xmm0
   1eec1:	vmovsd %xmm0,(%rax,%rbp,1)
   1eec6:	test   %rbp,%rbp
   1eec9:	jle    1eed9 <_Z3RunIN14external_bloom7Fixed16EEvRK5PointRK4CaseRK5Input+0x1fd9>
   1eecb:	mov    %r12,%rdi
   1eece:	mov    %rbx,%rsi
   1eed1:	mov    %rbp,%rdx
   1eed4:	call   2ea70 <memmove@plt>
   1eed9:	test   %rbx,%rbx
   1eedc:	je     1eee9 <_Z3RunIN14external_bloom7Fixed16EEvRK5PointRK4CaseRK5Input+0x1fe9>
   1eede:	mov    %rbx,%rdi
   1eee1:	mov    %rbp,%rsi
   1eee4:	call   2ea60 <_ZdlPvm@plt>
   1eee9:	add    %r12,%rbp
   1eeec:	mov    0x118(%rsp),%rcx
   1eef4:	mov    %r12,(%rcx)
   1eef7:	add    $0x8,%rbp
   1eefb:	mov    %rbp,0x8(%rcx)
   1eeff:	lea    (%r12,%r15,8),%rax
   1ef03:	mov    %rax,0x10(%rcx)
   1ef07:	lea    0x40(%rsp),%rdi
   1ef0c:	lea    0x90(%rsp),%rsi
   1ef14:	call   26830 <_ZN6Output5CheckERKSt6vectorIjSaIjEE>
   1ef19:	mov    0x10(%rsp),%r15
   1ef1e:	add    $0x4,%r15
