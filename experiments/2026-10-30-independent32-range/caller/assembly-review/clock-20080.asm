   21ac6:	add    $0x8,%r8
   21aca:	cmp    %r8,%r9
   21acd:	jne    21ac0 <_Z3RunIN14external_bloom16SingleShortcutV1INS0_7Fixed16EEEEvRK5PointRK4CaseRK5Input+0x1a40>
   21acf:	cmp    %r9,%rdi
   21ad2:	je     21aef <_Z3RunIN14external_bloom16SingleShortcutV1INS0_7Fixed16EEEEvRK5PointRK4CaseRK5Input+0x1a6f>
   21ad4:	lea    0x40(%rcx,%rax,4),%rax
   21ad9:	nopl   0x0(%rax)
   21ae0:	movl   $0x2,(%rsi)
   21ae6:	add    $0x4,%rsi
   21aea:	cmp    %rax,%rsi
   21aed:	jne    21ae0 <_Z3RunIN14external_bloom16SingleShortcutV1INS0_7Fixed16EEEEvRK5PointRK4CaseRK5Input+0x1a60>
   21aef:	vzeroupper
   21af2:	call   2eab0 <_ZNSt6chrono3_V212steady_clock3nowEv@plt>
   21af7:	mov    %rax,0x88(%rsp)
   21aff:	mov    %rbx,%rbp
   21b02:	cmp    $0x3,%ebx
   21b05:	ja     21f30 <_Z3RunIN14external_bloom16SingleShortcutV1INS0_7Fixed16EEEEvRK5PointRK4CaseRK5Input+0x1eb0>
   21b0b:	mov    %ebp,%eax
   21b0d:	lea    -0x1ff94(%rip),%rcx        # 1b80 <_IO_stdin_used+0x4a0>
   21b14:	movslq (%rcx,%rax,4),%rax
   21b18:	add    %rcx,%rax
   21b1b:	jmp    *%rax
   21b1d:	mov    0x68(%rsp),%rax
   21b22:	cmp    %rax,0x70(%rsp)
   21b27:	mov    0x8(%rsp),%r15
   21b2c:	je     21f30 <_Z3RunIN14external_bloom16SingleShortcutV1INS0_7Fixed16EEEEvRK5PointRK4CaseRK5Input+0x1eb0>
   21b32:	mov    0x60(%rsp),%rax
   21b37:	mov    0xc(%rax),%eax
   21b3a:	xor    %ebx,%ebx
   21b3c:	nopl   0x0(%rax)
   21b40:	mov    %eax,%eax
   21b42:	mov    %r15,%rsi
   21b45:	sub    %rbx,%rsi
   21b48:	cmp    %rax,%rsi
   21b4b:	cmovae %rax,%rsi
   21b4f:	lea    0x0(,%rbx,8),%rdx
   21b57:	mov    (%rsp),%rax
   21b5b:	add    0x48(%rax),%rdx
   21b5f:	mov    0x40(%rsp),%rax
   21b64:	lea    0x40(%rax,%rbx,4),%rcx
   21b69:	mov    %r12,%rdi
   21b6c:	call   2d2d0 <_Z13lookup_kernelIN14external_bloom16SingleShortcutV1INS0_7Fixed16EEEmEvRT_mPKT0_Pj>
   21b71:	mov    0x60(%rsp),%rax
   21b76:	mov    0xc(%rax),%eax
   21b79:	add    %rax,%rbx
   21b7c:	cmp    %r15,%rbx
   21b7f:	jb     21b40 <_Z3RunIN14external_bloom16SingleShortcutV1INS0_7Fixed16EEEEvRK5PointRK4CaseRK5Input+0x1ac0>
   21b81:	jmp    21f30 <_Z3RunIN14external_bloom16SingleShortcutV1INS0_7Fixed16EEEEvRK5PointRK4CaseRK5Input+0x1eb0>
   21b86:	mov    (%rsp),%rax
   21b8a:	mov    0x48(%rax),%rdx
   21b8e:	mov    0x40(%rsp),%rcx
   21b93:	add    $0x40,%rcx
   21b97:	mov    %r12,%rdi
   21b9a:	mov    0x8(%rsp),%rsi
   21b9f:	call   2d430 <_Z20inline_single_kernelILb0EN14external_bloom16SingleShortcutV1INS0_7Fixed16EEEmEvRKT0_mPKmPj>
   21ba4:	jmp    21f30 <_Z3RunIN14external_bloom16SingleShortcutV1INS0_7Fixed16EEEEvRK5PointRK4CaseRK5Input+0x1eb0>
   21ba9:	mov    (%rsp),%rax
   21bad:	mov    0x18(%rax),%rdx
   21bb1:	mov    0x40(%rsp),%rcx
   21bb6:	add    $0x40,%rcx
   21bba:	mov    %r12,%rdi
   21bbd:	mov    0x8(%rsp),%rsi
   21bc2:	call   2d540 <_Z20inline_single_kernelILb1EN14external_bloom16SingleShortcutV1INS0_7Fixed16EEEmEvRKT0_mPKmPj>
   21bc7:	jmp    21f30 <_Z3RunIN14external_bloom16SingleShortcutV1INS0_7Fixed16EEEEvRK5PointRK4CaseRK5Input+0x1eb0>
   21bcc:	mov    0x68(%rsp),%rax
   21bd1:	cmp    %rax,0x70(%rsp)
   21bd6:	mov    0x8(%rsp),%rsi
   21bdb:	je     21f30 <_Z3RunIN14external_bloom16SingleShortcutV1INS0_7Fixed16EEEEvRK5PointRK4CaseRK5Input+0x1eb0>
   21be1:	mov    0x60(%rsp),%rax
   21be6:	mov    0xc(%rax),%eax
   21be9:	xor    %r15d,%r15d
   21bec:	nopl   0x0(%rax)
   21bf0:	mov    %eax,%eax
   21bf2:	sub    %r15,%rsi
   21bf5:	cmp    %rax,%rsi
   21bf8:	cmovae %rax,%rsi
   21bfc:	test   %rsi,%rsi
   21bff:	je     21d5b <_Z3RunIN14external_bloom16SingleShortcutV1INS0_7Fixed16EEEEvRK5PointRK4CaseRK5Input+0x1cdb>
   21c05:	mov    (%rsp),%rax
   21c09:	mov    0x18(%rax),%rax
   21c0d:	lea    (%rax,%r15,8),%rcx
   21c11:	cmp    $0x4,%rsi
   21c15:	jb     21c2a <_Z3RunIN14external_bloom16SingleShortcutV1INS0_7Fixed16EEEEvRK5PointRK4CaseRK5Input+0x1baa>
   21c17:	mov    %r14,%rdx
   21c1a:	sub    %rcx,%rdx
   21c1d:	cmp    $0x80,%rdx
   21c24:	jae    21d91 <_Z3RunIN14external_bloom16SingleShortcutV1INS0_7Fixed16EEEEvRK5PointRK4CaseRK5Input+0x1d11>
   21c2a:	xor    %edx,%edx
   21c2c:	mov    %rsi,%r8
   21c2f:	mov    %rdx,%rdi
   21c32:	and    $0x3,%r8
   21c36:	je     21c76 <_Z3RunIN14external_bloom16SingleShortcutV1INS0_7Fixed16EEEEvRK5PointRK4CaseRK5Input+0x1bf6>
   21c38:	mov    %rdx,%rdi
   21c3b:	nopl   0x0(%rax,%rax,1)
   21c40:	mov    (%rcx,%rdi,8),%r9
   21c44:	mov    %r9,%r10
   21c47:	shr    $0x20,%r10
   21c4b:	xor    %r9,%r10
   21c4e:	imul   %r13,%r10
   21c52:	mov    %r10,%r9
   21c55:	shr    $0x20,%r9
   21c59:	xor    %r10,%r9
   21c5c:	imul   %r13,%r9
   21c60:	mov    %r9,%r10
   21c63:	shr    $0x20,%r10
   21c67:	xor    %r9,%r10
   21c6a:	mov    %r10,(%r14,%rdi,8)
   21c6e:	inc    %rdi
   21c71:	dec    %r8
   21c74:	jne    21c40 <_Z3RunIN14external_bloom16SingleShortcutV1INS0_7Fixed16EEEEvRK5PointRK4CaseRK5Input+0x1bc0>
   21c76:	sub    %rsi,%rdx
   21c79:	cmp    $0xfffffffffffffffc,%rdx
   21c7d:	ja     21d5b <_Z3RunIN14external_bloom16SingleShortcutV1INS0_7Fixed16EEEEvRK5PointRK4CaseRK5Input+0x1cdb>
   21c83:	lea    0x18(%rax,%r15,8),%rax
   21c88:	nopl   0x0(%rax,%rax,1)
   21c90:	mov    -0x18(%rax,%rdi,8),%rcx
   21c95:	mov    %rcx,%rdx
   21c98:	shr    $0x20,%rdx
   21c9c:	xor    %rcx,%rdx
   21c9f:	imul   %r13,%rdx
   21ca3:	mov    %rdx,%rcx
   21ca6:	shr    $0x20,%rcx
   21caa:	xor    %rdx,%rcx
   21cad:	imul   %r13,%rcx
   21cb1:	mov    %rcx,%rdx
   21cb4:	shr    $0x20,%rdx
   21cb8:	xor    %rcx,%rdx
   21cbb:	mov    %rdx,(%r14,%rdi,8)
   21cbf:	mov    -0x10(%rax,%rdi,8),%rcx
   21cc4:	mov    %rcx,%rdx
   21cc7:	shr    $0x20,%rdx
   21ccb:	xor    %rcx,%rdx
   21cce:	imul   %r13,%rdx
   21cd2:	mov    %rdx,%rcx
   21cd5:	shr    $0x20,%rcx
   21cd9:	xor    %rdx,%rcx
   21cdc:	imul   %r13,%rcx
   21ce0:	mov    %rcx,%rdx
   21ce3:	shr    $0x20,%rdx
   21ce7:	xor    %rcx,%rdx
   21cea:	mov    %rdx,0x8(%r14,%rdi,8)
   21cef:	mov    -0x8(%rax,%rdi,8),%rcx
   21cf4:	mov    %rcx,%rdx
   21cf7:	shr    $0x20,%rdx
   21cfb:	xor    %rcx,%rdx
   21cfe:	imul   %r13,%rdx
   21d02:	mov    %rdx,%rcx
   21d05:	shr    $0x20,%rcx
   21d09:	xor    %rdx,%rcx
   21d0c:	imul   %r13,%rcx
   21d10:	mov    %rcx,%rdx
   21d13:	shr    $0x20,%rdx
   21d17:	xor    %rcx,%rdx
   21d1a:	mov    %rdx,0x10(%r14,%rdi,8)
   21d1f:	mov    (%rax,%rdi,8),%rcx
   21d23:	mov    %rcx,%rdx
   21d26:	shr    $0x20,%rdx
   21d2a:	xor    %rcx,%rdx
   21d2d:	imul   %r13,%rdx
   21d31:	mov    %rdx,%rcx
   21d34:	shr    $0x20,%rcx
   21d38:	xor    %rdx,%rcx
   21d3b:	imul   %r13,%rcx
   21d3f:	mov    %rcx,%rdx
   21d42:	shr    $0x20,%rdx
   21d46:	xor    %rcx,%rdx
   21d49:	mov    %rdx,0x18(%r14,%rdi,8)
   21d4e:	add    $0x4,%rdi
   21d52:	cmp    %rdi,%rsi
   21d55:	jne    21c90 <_Z3RunIN14external_bloom16SingleShortcutV1INS0_7Fixed16EEEEvRK5PointRK4CaseRK5Input+0x1c10>
   21d5b:	mov    0x40(%rsp),%rax
   21d60:	lea    0x40(%rax,%r15,4),%rcx
   21d65:	mov    %r12,%rdi
   21d68:	mov    %r14,%rdx
   21d6b:	vzeroupper
   21d6e:	call   2d2d0 <_Z13lookup_kernelIN14external_bloom16SingleShortcutV1INS0_7Fixed16EEEmEvRT_mPKT0_Pj>
   21d73:	mov    0x60(%rsp),%rax
   21d78:	mov    0xc(%rax),%eax
   21d7b:	add    %rax,%r15
   21d7e:	mov    0x8(%rsp),%rsi
   21d83:	cmp    %rsi,%r15
   21d86:	jb     21bf0 <_Z3RunIN14external_bloom16SingleShortcutV1INS0_7Fixed16EEEEvRK5PointRK4CaseRK5Input+0x1b70>
   21d8c:	jmp    21f30 <_Z3RunIN14external_bloom16SingleShortcutV1INS0_7Fixed16EEEEvRK5PointRK4CaseRK5Input+0x1eb0>
   21d91:	cmp    $0x10,%rsi
   21d95:	jae    21d9e <_Z3RunIN14external_bloom16SingleShortcutV1INS0_7Fixed16EEEEvRK5PointRK4CaseRK5Input+0x1d1e>
   21d97:	xor    %edx,%edx
   21d99:	jmp    21ec2 <_Z3RunIN14external_bloom16SingleShortcutV1INS0_7Fixed16EEEEvRK5PointRK4CaseRK5Input+0x1e42>
   21d9e:	lea    0x0(,%r15,8),%r8
   21da6:	mov    %esi,%edx
   21da8:	and    $0xfffffff0,%edx
   21dab:	lea    0x0(,%rsi,8),%rdi
   21db3:	and    $0xffffffffffffff80,%rdi
   21db7:	lea    0x60(%rax,%r8,1),%r8
   21dbc:	xor    %r9d,%r9d
   21dbf:	vpbroadcastq -0x203f8(%rip),%ymm8        # 19d0 <_IO_stdin_used+0x2f0>
   21dc8:	nopl   0x0(%rax,%rax,1)
   21dd0:	vmovdqu -0x60(%r8,%r9,1),%ymm0
   21dd7:	vmovdqu -0x40(%r8,%r9,1),%ymm1
   21dde:	vmovdqu -0x20(%r8,%r9,1),%ymm2
   21de5:	vmovdqu (%r8,%r9,1),%ymm3
   21deb:	vpsrlq $0x20,%ymm0,%ymm4
   21df0:	vpsrlq $0x20,%ymm1,%ymm5
   21df5:	vpsrlq $0x20,%ymm2,%ymm6
   21dfa:	vpsrlq $0x20,%ymm3,%ymm7
   21dff:	vpxor  %ymm0,%ymm4,%ymm0
   21e03:	vpxor  %ymm1,%ymm5,%ymm1
   21e07:	vpxor  %ymm2,%ymm6,%ymm2
   21e0b:	vpmullq %ymm8,%ymm0,%ymm0
   21e11:	vpmullq %ymm8,%ymm1,%ymm1
   21e17:	vpmullq %ymm8,%ymm2,%ymm2
   21e1d:	vpxor  %ymm3,%ymm7,%ymm3
   21e21:	vpmullq %ymm8,%ymm3,%ymm3
   21e27:	vpsrlq $0x20,%ymm0,%ymm4
   21e2c:	vpsrlq $0x20,%ymm1,%ymm5
   21e31:	vpsrlq $0x20,%ymm2,%ymm6
   21e36:	vpsrlq $0x20,%ymm3,%ymm7
   21e3b:	vpxor  %ymm0,%ymm4,%ymm0
   21e3f:	vpxor  %ymm1,%ymm5,%ymm1
   21e43:	vpxor  %ymm2,%ymm6,%ymm2
   21e47:	vpxor  %ymm3,%ymm7,%ymm3
   21e4b:	vpmullq %ymm8,%ymm0,%ymm0
   21e51:	vpmullq %ymm8,%ymm1,%ymm1
   21e57:	vpmullq %ymm8,%ymm2,%ymm2
   21e5d:	vpmullq %ymm8,%ymm3,%ymm3
   21e63:	vpsrlq $0x20,%ymm0,%ymm4
   21e68:	vpsrlq $0x20,%ymm1,%ymm5
   21e6d:	vpsrlq $0x20,%ymm2,%ymm6
   21e72:	vpsrlq $0x20,%ymm3,%ymm7
   21e77:	vpxor  %ymm0,%ymm4,%ymm0
   21e7b:	vpxor  %ymm1,%ymm5,%ymm1
   21e7f:	vpxor  %ymm2,%ymm6,%ymm2
   21e83:	vpxor  %ymm3,%ymm7,%ymm3
   21e87:	vmovdqu %ymm0,(%r14,%r9,1)
   21e8d:	vmovdqu %ymm1,0x20(%r14,%r9,1)
   21e94:	vmovdqu %ymm2,0x40(%r14,%r9,1)
   21e9b:	vmovdqu %ymm3,0x60(%r14,%r9,1)
   21ea2:	sub    $0xffffffffffffff80,%r9
   21ea6:	cmp    %r9,%rdi
   21ea9:	jne    21dd0 <_Z3RunIN14external_bloom16SingleShortcutV1INS0_7Fixed16EEEEvRK5PointRK4CaseRK5Input+0x1d50>
   21eaf:	cmp    %rdx,%rsi
   21eb2:	je     21d5b <_Z3RunIN14external_bloom16SingleShortcutV1INS0_7Fixed16EEEEvRK5PointRK4CaseRK5Input+0x1cdb>
   21eb8:	test   $0xc,%sil
   21ebc:	je     21c2c <_Z3RunIN14external_bloom16SingleShortcutV1INS0_7Fixed16EEEEvRK5PointRK4CaseRK5Input+0x1bac>
   21ec2:	mov    %rdx,%rdi
   21ec5:	mov    %esi,%edx
   21ec7:	and    $0xfffffffc,%edx
   21eca:	vpbroadcastq -0x20503(%rip),%ymm2        # 19d0 <_IO_stdin_used+0x2f0>
   21ed3:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   21ee0:	vmovdqu (%rcx,%rdi,8),%ymm0
   21ee5:	vpsrlq $0x20,%ymm0,%ymm1
   21eea:	vpxor  %ymm0,%ymm1,%ymm0
   21eee:	vpmullq %ymm2,%ymm0,%ymm0
   21ef4:	vpsrlq $0x20,%ymm0,%ymm1
   21ef9:	vpxor  %ymm0,%ymm1,%ymm0
   21efd:	vpmullq %ymm2,%ymm0,%ymm0
   21f03:	vpsrlq $0x20,%ymm0,%ymm1
   21f08:	vpxor  %ymm0,%ymm1,%ymm0
   21f0c:	vmovdqu %ymm0,(%r14,%rdi,8)
   21f12:	add    $0x4,%rdi
   21f16:	cmp    %rdi,%rdx
   21f19:	jne    21ee0 <_Z3RunIN14external_bloom16SingleShortcutV1INS0_7Fixed16EEEEvRK5PointRK4CaseRK5Input+0x1e60>
   21f1b:	cmp    %rdx,%rsi
   21f1e:	je     21d5b <_Z3RunIN14external_bloom16SingleShortcutV1INS0_7Fixed16EEEEvRK5PointRK4CaseRK5Input+0x1cdb>
   21f24:	jmp    21c2c <_Z3RunIN14external_bloom16SingleShortcutV1INS0_7Fixed16EEEEvRK5PointRK4CaseRK5Input+0x1bac>
   21f29:	nopl   0x0(%rax)
   21f30:	call   2eab0 <_ZNSt6chrono3_V212steady_clock3nowEv@plt>
   21f35:	sub    0x88(%rsp),%rax
   21f3d:	vcvtsi2sd %rax,%xmm15,%xmm0
   21f42:	vdivsd 0x128(%rsp),%xmm0,%xmm0
   21f4b:	vmovq  %xmm0,%rax
   21f50:	mov    $0x3f,%cl
   21f52:	bzhi   %rcx,%rax,%rcx
   21f57:	movabs $0xfff0000000000000,%rdx
   21f61:	add    %rdx,%rcx
   21f64:	shr    $0x35,%rcx
   21f68:	cmp    $0x3ff,%ecx
   21f6e:	setb   %cl
   21f71:	test   %rax,%rax
   21f74:	setns  %dl
   21f77:	and    %cl,%dl
   21f79:	dec    %rax
   21f7c:	movabs $0xfffffffffffff,%rcx
   21f86:	cmp    %rcx,%rax
   21f89:	setb   %al
   21f8c:	or     %dl,%al
   21f8e:	je     22d27 <_Z3RunIN14external_bloom16SingleShortcutV1INS0_7Fixed16EEEEvRK5PointRK4CaseRK5Input+0x2ca7>
   21f94:	lea    0x0(%rbp,%rbp,2),%rax
   21f99:	lea    0x140(%rsp,%rax,8),%rcx
   21fa1:	mov    0x148(%rsp,%rax,8),%rbp
   21fa9:	cmp    0x150(%rsp,%rax,8),%rbp
   21fb1:	je     21fd0 <_Z3RunIN14external_bloom16SingleShortcutV1INS0_7Fixed16EEEEvRK5PointRK4CaseRK5Input+0x1f50>
   21fb3:	vmovsd %xmm0,0x0(%rbp)
   21fb8:	add    $0x8,%rbp
   21fbc:	mov    %rbp,0x8(%rcx)
   21fc0:	jmp    22087 <_Z3RunIN14external_bloom16SingleShortcutV1INS0_7Fixed16EEEEvRK5PointRK4CaseRK5Input+0x2007>
   21fc5:	data16 cs nopw 0x0(%rax,%rax,1)
   21fd0:	mov    (%rcx),%rbx
   21fd3:	sub    %rbx,%rbp
   21fd6:	movabs $0x7ffffffffffffff8,%rax
   21fe0:	cmp    %rax,%rbp
   21fe3:	je     22d6d <_Z3RunIN14external_bloom16SingleShortcutV1INS0_7Fixed16EEEEvRK5PointRK4CaseRK5Input+0x2ced>
   21fe9:	mov    %rcx,0x118(%rsp)
   21ff1:	vmovsd %xmm0,0x88(%rsp)
   21ffa:	mov    %rbp,%rax
   21ffd:	sar    $0x3,%rax
   22001:	cmp    $0x1,%rax
   22005:	mov    %rax,%rcx
   22008:	adc    $0x0,%rcx
   2200c:	lea    (%rcx,%rax,1),%r15
   22010:	movabs $0xfffffffffffffff,%rdx
   2201a:	cmp    %rdx,%r15
   2201d:	cmovae %rdx,%r15
   22021:	add    %rax,%rcx
   22024:	cmovb  %rdx,%r15
   22028:	lea    0x0(,%r15,8),%rdi
   22030:	call   2ea50 <_Znwm@plt>
   22035:	mov    %rax,%r12
   22038:	vmovsd 0x88(%rsp),%xmm0
   22041:	vmovsd %xmm0,(%rax,%rbp,1)
   22046:	test   %rbp,%rbp
   22049:	jle    22059 <_Z3RunIN14external_bloom16SingleShortcutV1INS0_7Fixed16EEEEvRK5PointRK4CaseRK5Input+0x1fd9>
   2204b:	mov    %r12,%rdi
   2204e:	mov    %rbx,%rsi
   22051:	mov    %rbp,%rdx
   22054:	call   2ea70 <memmove@plt>
   22059:	test   %rbx,%rbx
   2205c:	je     22069 <_Z3RunIN14external_bloom16SingleShortcutV1INS0_7Fixed16EEEEvRK5PointRK4CaseRK5Input+0x1fe9>
   2205e:	mov    %rbx,%rdi
   22061:	mov    %rbp,%rsi
   22064:	call   2ea60 <_ZdlPvm@plt>
   22069:	add    %r12,%rbp
   2206c:	mov    0x118(%rsp),%rcx
   22074:	mov    %r12,(%rcx)
   22077:	add    $0x8,%rbp
   2207b:	mov    %rbp,0x8(%rcx)
   2207f:	lea    (%r12,%r15,8),%rax
   22083:	mov    %rax,0x10(%rcx)
   22087:	lea    0x40(%rsp),%rdi
   2208c:	lea    0x90(%rsp),%rsi
   22094:	call   26830 <_ZN6Output5CheckERKSt6vectorIjSaIjEE>
   22099:	mov    0x10(%rsp),%r15
   2209e:	add    $0x4,%r15
