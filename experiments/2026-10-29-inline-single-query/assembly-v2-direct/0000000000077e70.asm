0000000000077e70 <void inline_single_kernel<false, external_bloom::Classical<8, false, false>, unsigned long>(external_bloom::Classical<8, false, false> const&, unsigned long, unsigned long const*, unsigned int*)>:
   77e70:	push   %rbp
   77e71:	push   %r15
   77e73:	push   %r14
   77e75:	push   %r13
   77e77:	push   %r12
   77e79:	push   %rbx
   77e7a:	mov    %rcx,-0x10(%rsp)
   77e7f:	mov    %rdx,-0x18(%rsp)
   77e84:	mov    %rdi,-0x28(%rsp)
   77e89:	mov    %rsi,-0x20(%rsp)
   77e8e:	test   %rsi,%rsi
   77e91:	je     77ffe <void inline_single_kernel<false, external_bloom::Classical<8, false, false>, unsigned long>(external_bloom::Classical<8, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x18e>
   77e97:	xor    %r12d,%r12d
   77e9a:	jmp    77eb7 <void inline_single_kernel<false, external_bloom::Classical<8, false, false>, unsigned long>(external_bloom::Classical<8, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x47>
   77e9c:	nopl   0x0(%rax)
   77ea0:	mov    -0x10(%rsp),%rax
   77ea5:	mov    %edx,(%rax,%r12,4)
   77ea9:	inc    %r12
   77eac:	cmp    %r12,-0x20(%rsp)
   77eb1:	je     77ffe <void inline_single_kernel<false, external_bloom::Classical<8, false, false>, unsigned long>(external_bloom::Classical<8, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x18e>
   77eb7:	mov    -0x18(%rsp),%rax
   77ebc:	mov    (%rax,%r12,8),%r8
   77ec0:	rorx   $0x20,%r8,%rcx
   77ec6:	mov    -0x28(%rsp),%rax
   77ecb:	mov    (%rax),%rbp
   77ece:	mov    0x10(%rax),%r15
   77ed2:	mov    %r15,%rdx
   77ed5:	mulx   %rcx,%rax,%rax
   77eda:	mov    0x0(%rbp,%rax,8),%rdx
   77edf:	lea    (%rcx,%r8,1),%rax
   77ee3:	lea    (%rax,%r8,1),%r14
   77ee7:	lea    (%r14,%r8,1),%rbx
   77eeb:	lea    (%rbx,%r8,1),%r11
   77eef:	lea    (%r11,%r8,1),%r10
   77ef3:	lea    (%r10,%r8,1),%r9
   77ef7:	add    %r9,%r8
   77efa:	bt     %rcx,%rdx
   77efe:	mov    %r14,%rdx
   77f01:	mulx   %r15,%rcx,%rcx
   77f06:	mov    %rbx,%rdx
   77f09:	mulx   %r15,%rsi,%rsi
   77f0e:	mov    %r11,%rdx
   77f11:	mulx   %r15,%r13,%r13
   77f16:	mov    %r10,%rdx
   77f19:	mulx   %r15,%rdi,%rdi
   77f1e:	mov    %r9,%rdx
   77f21:	mulx   %r15,%rdx,%rdx
   77f26:	mov    %rdx,-0x8(%rsp)
   77f2b:	mov    %r8,%rdx
   77f2e:	mulx   %r15,%rdx,%rdx
   77f33:	mov    %rdx,-0x30(%rsp)
   77f38:	mov    $0x0,%edx
   77f3d:	jae    77ea0 <void inline_single_kernel<false, external_bloom::Classical<8, false, false>, unsigned long>(external_bloom::Classical<8, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   77f43:	mov    %r15,%rdx
   77f46:	mulx   %rax,%rdx,%rdx
   77f4b:	mov    0x0(%rbp,%rdx,8),%rdx
   77f50:	bt     %rax,%rdx
   77f54:	mov    $0x0,%edx
   77f59:	jae    77ea0 <void inline_single_kernel<false, external_bloom::Classical<8, false, false>, unsigned long>(external_bloom::Classical<8, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   77f5f:	mov    $0x1,%eax
   77f64:	shlx   %r14,%rax,%rax
   77f69:	mov    $0x0,%edx
   77f6e:	test   %rax,0x0(%rbp,%rcx,8)
   77f73:	je     77ea0 <void inline_single_kernel<false, external_bloom::Classical<8, false, false>, unsigned long>(external_bloom::Classical<8, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   77f79:	mov    $0x1,%eax
   77f7e:	shlx   %rbx,%rax,%rax
   77f83:	mov    $0x0,%edx
   77f88:	test   %rax,0x0(%rbp,%rsi,8)
   77f8d:	je     77ea0 <void inline_single_kernel<false, external_bloom::Classical<8, false, false>, unsigned long>(external_bloom::Classical<8, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   77f93:	mov    $0x1,%eax
   77f98:	shlx   %r11,%rax,%rax
   77f9d:	mov    $0x0,%edx
   77fa2:	test   %rax,0x0(%rbp,%r13,8)
   77fa7:	je     77ea0 <void inline_single_kernel<false, external_bloom::Classical<8, false, false>, unsigned long>(external_bloom::Classical<8, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   77fad:	mov    $0x1,%eax
   77fb2:	shlx   %r10,%rax,%rax
   77fb7:	mov    $0x0,%edx
   77fbc:	test   %rax,0x0(%rbp,%rdi,8)
   77fc1:	je     77ea0 <void inline_single_kernel<false, external_bloom::Classical<8, false, false>, unsigned long>(external_bloom::Classical<8, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   77fc7:	mov    $0x1,%eax
   77fcc:	shlx   %r9,%rax,%rax
   77fd1:	mov    $0x0,%edx
   77fd6:	mov    -0x8(%rsp),%rcx
   77fdb:	test   %rax,0x0(%rbp,%rcx,8)
   77fe0:	je     77ea0 <void inline_single_kernel<false, external_bloom::Classical<8, false, false>, unsigned long>(external_bloom::Classical<8, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   77fe6:	and    $0x3f,%r8d
   77fea:	mov    -0x30(%rsp),%rax
   77fef:	shrx   %r8,0x0(%rbp,%rax,8),%rdx
   77ff6:	and    $0x1,%edx
   77ff9:	jmp    77ea0 <void inline_single_kernel<false, external_bloom::Classical<8, false, false>, unsigned long>(external_bloom::Classical<8, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   77ffe:	pop    %rbx
   77fff:	pop    %r12
   78001:	pop    %r13
   78003:	pop    %r14
   78005:	pop    %r15
   78007:	pop    %rbp
   78008:	ret
   78009:	int3
   7800a:	int3
   7800b:	int3
   7800c:	int3
   7800d:	int3
   7800e:	int3
   7800f:	int3

