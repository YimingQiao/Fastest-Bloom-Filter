0000000000093ac0 <void inline_single_kernel<false, external_bloom::Classical<11, true, false>, unsigned long>(external_bloom::Classical<11, true, false> const&, unsigned long, unsigned long const*, unsigned int*)>:
   93ac0:	push   %rbp
   93ac1:	push   %r15
   93ac3:	push   %r14
   93ac5:	push   %r13
   93ac7:	push   %r12
   93ac9:	push   %rbx
   93aca:	mov    %rcx,-0x20(%rsp)
   93acf:	mov    %rdx,-0x28(%rsp)
   93ad4:	mov    %rdi,-0x38(%rsp)
   93ad9:	mov    %rsi,-0x30(%rsp)
   93ade:	test   %rsi,%rsi
   93ae1:	je     93cac <void inline_single_kernel<false, external_bloom::Classical<11, true, false>, unsigned long>(external_bloom::Classical<11, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x1ec>
   93ae7:	xor    %ebp,%ebp
   93ae9:	jmp    93b06 <void inline_single_kernel<false, external_bloom::Classical<11, true, false>, unsigned long>(external_bloom::Classical<11, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x46>
   93aeb:	nopl   0x0(%rax,%rax,1)
   93af0:	mov    -0x20(%rsp),%rax
   93af5:	mov    %edx,(%rax,%rbp,4)
   93af8:	inc    %rbp
   93afb:	cmp    %rbp,-0x30(%rsp)
   93b00:	je     93cac <void inline_single_kernel<false, external_bloom::Classical<11, true, false>, unsigned long>(external_bloom::Classical<11, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x1ec>
   93b06:	mov    -0x28(%rsp),%rax
   93b0b:	mov    (%rax,%rbp,8),%r8
   93b0f:	rorx   $0x20,%r8,%r11
   93b15:	mov    -0x38(%rsp),%rcx
   93b1a:	mov    (%rcx),%rax
   93b1d:	mov    0x10(%rcx),%r14
   93b21:	mov    %r14,%rdx
   93b24:	mulx   %r11,%rcx,%rcx
   93b29:	shrx   %r11,(%rax,%rcx,8),%rsi
   93b2f:	add    %r8,%r11
   93b32:	mulx   %r11,%rcx,%rcx
   93b37:	shrx   %r11,(%rax,%rcx,8),%rdi
   93b3d:	add    %r8,%r11
   93b40:	mov    %r11,%rdx
   93b43:	mulx   %r14,%rcx,%rcx
   93b48:	shrx   %r11,(%rax,%rcx,8),%rcx
   93b4e:	and    %esi,%edi
   93b50:	and    %edi,%ecx
   93b52:	add    %r8,%r11
   93b55:	lea    (%r11,%r8,1),%r13
   93b59:	lea    0x0(%r13,%r8,1),%r12
   93b5e:	lea    (%r12,%r8,1),%r15
   93b62:	lea    (%r15,%r8,1),%rbx
   93b66:	lea    (%rbx,%r8,1),%r10
   93b6a:	lea    (%r10,%r8,1),%r9
   93b6e:	add    %r9,%r8
   93b71:	mov    %r13,%rdx
   93b74:	mulx   %r14,%rdi,%rdi
   93b79:	mov    %r12,%rdx
   93b7c:	mulx   %r14,%rsi,%rsi
   93b81:	mov    %r15,%rdx
   93b84:	mulx   %r14,%rdx,%rdx
   93b89:	mov    %rdx,-0x8(%rsp)
   93b8e:	mov    %rbx,%rdx
   93b91:	mulx   %r14,%rdx,%rdx
   93b96:	mov    %rdx,-0x10(%rsp)
   93b9b:	mov    %r10,%rdx
   93b9e:	mulx   %r14,%rdx,%rdx
   93ba3:	mov    %rdx,-0x18(%rsp)
   93ba8:	mov    %r9,%rdx
   93bab:	mulx   %r14,%rdx,%rdx
   93bb0:	mov    %rdx,-0x40(%rsp)
   93bb5:	mov    %r8,%rdx
   93bb8:	mulx   %r14,%rdx,%rdx
   93bbd:	mov    %rdx,-0x48(%rsp)
   93bc2:	mov    $0x0,%edx
   93bc7:	test   $0x1,%cl
   93bca:	je     93af0 <void inline_single_kernel<false, external_bloom::Classical<11, true, false>, unsigned long>(external_bloom::Classical<11, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   93bd0:	mov    %r11,%rdx
   93bd3:	mulx   %r14,%rcx,%rcx
   93bd8:	mov    (%rax,%rcx,8),%rcx
   93bdc:	bt     %r11,%rcx
   93be0:	mov    $0x0,%edx
   93be5:	jae    93af0 <void inline_single_kernel<false, external_bloom::Classical<11, true, false>, unsigned long>(external_bloom::Classical<11, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   93beb:	mov    $0x1,%ecx
   93bf0:	shlx   %r13,%rcx,%rcx
   93bf5:	mov    $0x0,%edx
   93bfa:	test   %rcx,(%rax,%rdi,8)
   93bfe:	je     93af0 <void inline_single_kernel<false, external_bloom::Classical<11, true, false>, unsigned long>(external_bloom::Classical<11, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   93c04:	mov    $0x1,%ecx
   93c09:	shlx   %r12,%rcx,%rcx
   93c0e:	mov    $0x0,%edx
   93c13:	test   %rcx,(%rax,%rsi,8)
   93c17:	je     93af0 <void inline_single_kernel<false, external_bloom::Classical<11, true, false>, unsigned long>(external_bloom::Classical<11, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   93c1d:	mov    $0x1,%ecx
   93c22:	shlx   %r15,%rcx,%rcx
   93c27:	mov    $0x0,%edx
   93c2c:	mov    -0x8(%rsp),%rsi
   93c31:	test   %rcx,(%rax,%rsi,8)
   93c35:	je     93af0 <void inline_single_kernel<false, external_bloom::Classical<11, true, false>, unsigned long>(external_bloom::Classical<11, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   93c3b:	mov    $0x1,%ecx
   93c40:	shlx   %rbx,%rcx,%rcx
   93c45:	mov    $0x0,%edx
   93c4a:	mov    -0x10(%rsp),%rsi
   93c4f:	test   %rcx,(%rax,%rsi,8)
   93c53:	je     93af0 <void inline_single_kernel<false, external_bloom::Classical<11, true, false>, unsigned long>(external_bloom::Classical<11, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   93c59:	mov    $0x1,%ecx
   93c5e:	shlx   %r10,%rcx,%rcx
   93c63:	mov    $0x0,%edx
   93c68:	mov    -0x18(%rsp),%rsi
   93c6d:	test   %rcx,(%rax,%rsi,8)
   93c71:	je     93af0 <void inline_single_kernel<false, external_bloom::Classical<11, true, false>, unsigned long>(external_bloom::Classical<11, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   93c77:	mov    $0x1,%ecx
   93c7c:	shlx   %r9,%rcx,%rcx
   93c81:	mov    $0x0,%edx
   93c86:	mov    -0x40(%rsp),%rsi
   93c8b:	test   %rcx,(%rax,%rsi,8)
   93c8f:	je     93af0 <void inline_single_kernel<false, external_bloom::Classical<11, true, false>, unsigned long>(external_bloom::Classical<11, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   93c95:	and    $0x3f,%r8d
   93c99:	mov    -0x48(%rsp),%rcx
   93c9e:	shrx   %r8,(%rax,%rcx,8),%rdx
   93ca4:	and    $0x1,%edx
   93ca7:	jmp    93af0 <void inline_single_kernel<false, external_bloom::Classical<11, true, false>, unsigned long>(external_bloom::Classical<11, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   93cac:	pop    %rbx
   93cad:	pop    %r12
   93caf:	pop    %r13
   93cb1:	pop    %r14
   93cb3:	pop    %r15
   93cb5:	pop    %rbp
   93cb6:	ret
   93cb7:	int3
   93cb8:	int3
   93cb9:	int3
   93cba:	int3
   93cbb:	int3
   93cbc:	int3
   93cbd:	int3
   93cbe:	int3
   93cbf:	int3

