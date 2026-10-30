0000000000093b40 <void inline_single_kernel<false, external_bloom::Classical<11, true, false>, unsigned long>(external_bloom::Classical<11, true, false> const&, unsigned long, unsigned long const*, unsigned int*)>:
   93b40:	push   %rbp
   93b41:	push   %r15
   93b43:	push   %r14
   93b45:	push   %r13
   93b47:	push   %r12
   93b49:	push   %rbx
   93b4a:	mov    %rcx,-0x20(%rsp)
   93b4f:	mov    %rdx,-0x28(%rsp)
   93b54:	mov    %rdi,-0x38(%rsp)
   93b59:	mov    %rsi,-0x30(%rsp)
   93b5e:	test   %rsi,%rsi
   93b61:	je     93d2c <void inline_single_kernel<false, external_bloom::Classical<11, true, false>, unsigned long>(external_bloom::Classical<11, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x1ec>
   93b67:	xor    %ebp,%ebp
   93b69:	jmp    93b86 <void inline_single_kernel<false, external_bloom::Classical<11, true, false>, unsigned long>(external_bloom::Classical<11, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x46>
   93b6b:	nopl   0x0(%rax,%rax,1)
   93b70:	mov    -0x20(%rsp),%rax
   93b75:	mov    %edx,(%rax,%rbp,4)
   93b78:	inc    %rbp
   93b7b:	cmp    %rbp,-0x30(%rsp)
   93b80:	je     93d2c <void inline_single_kernel<false, external_bloom::Classical<11, true, false>, unsigned long>(external_bloom::Classical<11, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x1ec>
   93b86:	mov    -0x28(%rsp),%rax
   93b8b:	mov    (%rax,%rbp,8),%r8
   93b8f:	rorx   $0x20,%r8,%r11
   93b95:	mov    -0x38(%rsp),%rcx
   93b9a:	mov    (%rcx),%rax
   93b9d:	mov    0x10(%rcx),%r14
   93ba1:	mov    %r14,%rdx
   93ba4:	mulx   %r11,%rcx,%rcx
   93ba9:	shrx   %r11,(%rax,%rcx,8),%rsi
   93baf:	add    %r8,%r11
   93bb2:	mulx   %r11,%rcx,%rcx
   93bb7:	shrx   %r11,(%rax,%rcx,8),%rdi
   93bbd:	add    %r8,%r11
   93bc0:	mov    %r11,%rdx
   93bc3:	mulx   %r14,%rcx,%rcx
   93bc8:	shrx   %r11,(%rax,%rcx,8),%rcx
   93bce:	and    %esi,%edi
   93bd0:	and    %edi,%ecx
   93bd2:	add    %r8,%r11
   93bd5:	lea    (%r11,%r8,1),%r13
   93bd9:	lea    0x0(%r13,%r8,1),%r12
   93bde:	lea    (%r12,%r8,1),%r15
   93be2:	lea    (%r15,%r8,1),%rbx
   93be6:	lea    (%rbx,%r8,1),%r10
   93bea:	lea    (%r10,%r8,1),%r9
   93bee:	add    %r9,%r8
   93bf1:	mov    %r13,%rdx
   93bf4:	mulx   %r14,%rdi,%rdi
   93bf9:	mov    %r12,%rdx
   93bfc:	mulx   %r14,%rsi,%rsi
   93c01:	mov    %r15,%rdx
   93c04:	mulx   %r14,%rdx,%rdx
   93c09:	mov    %rdx,-0x8(%rsp)
   93c0e:	mov    %rbx,%rdx
   93c11:	mulx   %r14,%rdx,%rdx
   93c16:	mov    %rdx,-0x10(%rsp)
   93c1b:	mov    %r10,%rdx
   93c1e:	mulx   %r14,%rdx,%rdx
   93c23:	mov    %rdx,-0x18(%rsp)
   93c28:	mov    %r9,%rdx
   93c2b:	mulx   %r14,%rdx,%rdx
   93c30:	mov    %rdx,-0x40(%rsp)
   93c35:	mov    %r8,%rdx
   93c38:	mulx   %r14,%rdx,%rdx
   93c3d:	mov    %rdx,-0x48(%rsp)
   93c42:	mov    $0x0,%edx
   93c47:	test   $0x1,%cl
   93c4a:	je     93b70 <void inline_single_kernel<false, external_bloom::Classical<11, true, false>, unsigned long>(external_bloom::Classical<11, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   93c50:	mov    %r11,%rdx
   93c53:	mulx   %r14,%rcx,%rcx
   93c58:	mov    (%rax,%rcx,8),%rcx
   93c5c:	bt     %r11,%rcx
   93c60:	mov    $0x0,%edx
   93c65:	jae    93b70 <void inline_single_kernel<false, external_bloom::Classical<11, true, false>, unsigned long>(external_bloom::Classical<11, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   93c6b:	mov    $0x1,%ecx
   93c70:	shlx   %r13,%rcx,%rcx
   93c75:	mov    $0x0,%edx
   93c7a:	test   %rcx,(%rax,%rdi,8)
   93c7e:	je     93b70 <void inline_single_kernel<false, external_bloom::Classical<11, true, false>, unsigned long>(external_bloom::Classical<11, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   93c84:	mov    $0x1,%ecx
   93c89:	shlx   %r12,%rcx,%rcx
   93c8e:	mov    $0x0,%edx
   93c93:	test   %rcx,(%rax,%rsi,8)
   93c97:	je     93b70 <void inline_single_kernel<false, external_bloom::Classical<11, true, false>, unsigned long>(external_bloom::Classical<11, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   93c9d:	mov    $0x1,%ecx
   93ca2:	shlx   %r15,%rcx,%rcx
   93ca7:	mov    $0x0,%edx
   93cac:	mov    -0x8(%rsp),%rsi
   93cb1:	test   %rcx,(%rax,%rsi,8)
   93cb5:	je     93b70 <void inline_single_kernel<false, external_bloom::Classical<11, true, false>, unsigned long>(external_bloom::Classical<11, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   93cbb:	mov    $0x1,%ecx
   93cc0:	shlx   %rbx,%rcx,%rcx
   93cc5:	mov    $0x0,%edx
   93cca:	mov    -0x10(%rsp),%rsi
   93ccf:	test   %rcx,(%rax,%rsi,8)
   93cd3:	je     93b70 <void inline_single_kernel<false, external_bloom::Classical<11, true, false>, unsigned long>(external_bloom::Classical<11, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   93cd9:	mov    $0x1,%ecx
   93cde:	shlx   %r10,%rcx,%rcx
   93ce3:	mov    $0x0,%edx
   93ce8:	mov    -0x18(%rsp),%rsi
   93ced:	test   %rcx,(%rax,%rsi,8)
   93cf1:	je     93b70 <void inline_single_kernel<false, external_bloom::Classical<11, true, false>, unsigned long>(external_bloom::Classical<11, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   93cf7:	mov    $0x1,%ecx
   93cfc:	shlx   %r9,%rcx,%rcx
   93d01:	mov    $0x0,%edx
   93d06:	mov    -0x40(%rsp),%rsi
   93d0b:	test   %rcx,(%rax,%rsi,8)
   93d0f:	je     93b70 <void inline_single_kernel<false, external_bloom::Classical<11, true, false>, unsigned long>(external_bloom::Classical<11, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   93d15:	and    $0x3f,%r8d
   93d19:	mov    -0x48(%rsp),%rcx
   93d1e:	shrx   %r8,(%rax,%rcx,8),%rdx
   93d24:	and    $0x1,%edx
   93d27:	jmp    93b70 <void inline_single_kernel<false, external_bloom::Classical<11, true, false>, unsigned long>(external_bloom::Classical<11, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   93d2c:	pop    %rbx
   93d2d:	pop    %r12
   93d2f:	pop    %r13
   93d31:	pop    %r14
   93d33:	pop    %r15
   93d35:	pop    %rbp
   93d36:	ret
   93d37:	int3
   93d38:	int3
   93d39:	int3
   93d3a:	int3
   93d3b:	int3
   93d3c:	int3
   93d3d:	int3
   93d3e:	int3
   93d3f:	int3

