0000000000077ef0 <void inline_single_kernel<false, external_bloom::Classical<8, false, false>, unsigned long>(external_bloom::Classical<8, false, false> const&, unsigned long, unsigned long const*, unsigned int*)>:
   77ef0:	push   %rbp
   77ef1:	push   %r15
   77ef3:	push   %r14
   77ef5:	push   %r13
   77ef7:	push   %r12
   77ef9:	push   %rbx
   77efa:	mov    %rcx,-0x10(%rsp)
   77eff:	mov    %rdx,-0x18(%rsp)
   77f04:	mov    %rdi,-0x28(%rsp)
   77f09:	mov    %rsi,-0x20(%rsp)
   77f0e:	test   %rsi,%rsi
   77f11:	je     7807e <void inline_single_kernel<false, external_bloom::Classical<8, false, false>, unsigned long>(external_bloom::Classical<8, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x18e>
   77f17:	xor    %r12d,%r12d
   77f1a:	jmp    77f37 <void inline_single_kernel<false, external_bloom::Classical<8, false, false>, unsigned long>(external_bloom::Classical<8, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x47>
   77f1c:	nopl   0x0(%rax)
   77f20:	mov    -0x10(%rsp),%rax
   77f25:	mov    %edx,(%rax,%r12,4)
   77f29:	inc    %r12
   77f2c:	cmp    %r12,-0x20(%rsp)
   77f31:	je     7807e <void inline_single_kernel<false, external_bloom::Classical<8, false, false>, unsigned long>(external_bloom::Classical<8, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x18e>
   77f37:	mov    -0x18(%rsp),%rax
   77f3c:	mov    (%rax,%r12,8),%r8
   77f40:	rorx   $0x20,%r8,%rcx
   77f46:	mov    -0x28(%rsp),%rax
   77f4b:	mov    (%rax),%rbp
   77f4e:	mov    0x10(%rax),%r15
   77f52:	mov    %r15,%rdx
   77f55:	mulx   %rcx,%rax,%rax
   77f5a:	mov    0x0(%rbp,%rax,8),%rdx
   77f5f:	lea    (%rcx,%r8,1),%rax
   77f63:	lea    (%rax,%r8,1),%r14
   77f67:	lea    (%r14,%r8,1),%rbx
   77f6b:	lea    (%rbx,%r8,1),%r11
   77f6f:	lea    (%r11,%r8,1),%r10
   77f73:	lea    (%r10,%r8,1),%r9
   77f77:	add    %r9,%r8
   77f7a:	bt     %rcx,%rdx
   77f7e:	mov    %r14,%rdx
   77f81:	mulx   %r15,%rcx,%rcx
   77f86:	mov    %rbx,%rdx
   77f89:	mulx   %r15,%rsi,%rsi
   77f8e:	mov    %r11,%rdx
   77f91:	mulx   %r15,%r13,%r13
   77f96:	mov    %r10,%rdx
   77f99:	mulx   %r15,%rdi,%rdi
   77f9e:	mov    %r9,%rdx
   77fa1:	mulx   %r15,%rdx,%rdx
   77fa6:	mov    %rdx,-0x8(%rsp)
   77fab:	mov    %r8,%rdx
   77fae:	mulx   %r15,%rdx,%rdx
   77fb3:	mov    %rdx,-0x30(%rsp)
   77fb8:	mov    $0x0,%edx
   77fbd:	jae    77f20 <void inline_single_kernel<false, external_bloom::Classical<8, false, false>, unsigned long>(external_bloom::Classical<8, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   77fc3:	mov    %r15,%rdx
   77fc6:	mulx   %rax,%rdx,%rdx
   77fcb:	mov    0x0(%rbp,%rdx,8),%rdx
   77fd0:	bt     %rax,%rdx
   77fd4:	mov    $0x0,%edx
   77fd9:	jae    77f20 <void inline_single_kernel<false, external_bloom::Classical<8, false, false>, unsigned long>(external_bloom::Classical<8, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   77fdf:	mov    $0x1,%eax
   77fe4:	shlx   %r14,%rax,%rax
   77fe9:	mov    $0x0,%edx
   77fee:	test   %rax,0x0(%rbp,%rcx,8)
   77ff3:	je     77f20 <void inline_single_kernel<false, external_bloom::Classical<8, false, false>, unsigned long>(external_bloom::Classical<8, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   77ff9:	mov    $0x1,%eax
   77ffe:	shlx   %rbx,%rax,%rax
   78003:	mov    $0x0,%edx
   78008:	test   %rax,0x0(%rbp,%rsi,8)
   7800d:	je     77f20 <void inline_single_kernel<false, external_bloom::Classical<8, false, false>, unsigned long>(external_bloom::Classical<8, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   78013:	mov    $0x1,%eax
   78018:	shlx   %r11,%rax,%rax
   7801d:	mov    $0x0,%edx
   78022:	test   %rax,0x0(%rbp,%r13,8)
   78027:	je     77f20 <void inline_single_kernel<false, external_bloom::Classical<8, false, false>, unsigned long>(external_bloom::Classical<8, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   7802d:	mov    $0x1,%eax
   78032:	shlx   %r10,%rax,%rax
   78037:	mov    $0x0,%edx
   7803c:	test   %rax,0x0(%rbp,%rdi,8)
   78041:	je     77f20 <void inline_single_kernel<false, external_bloom::Classical<8, false, false>, unsigned long>(external_bloom::Classical<8, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   78047:	mov    $0x1,%eax
   7804c:	shlx   %r9,%rax,%rax
   78051:	mov    $0x0,%edx
   78056:	mov    -0x8(%rsp),%rcx
   7805b:	test   %rax,0x0(%rbp,%rcx,8)
   78060:	je     77f20 <void inline_single_kernel<false, external_bloom::Classical<8, false, false>, unsigned long>(external_bloom::Classical<8, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   78066:	and    $0x3f,%r8d
   7806a:	mov    -0x30(%rsp),%rax
   7806f:	shrx   %r8,0x0(%rbp,%rax,8),%rdx
   78076:	and    $0x1,%edx
   78079:	jmp    77f20 <void inline_single_kernel<false, external_bloom::Classical<8, false, false>, unsigned long>(external_bloom::Classical<8, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   7807e:	pop    %rbx
   7807f:	pop    %r12
   78081:	pop    %r13
   78083:	pop    %r14
   78085:	pop    %r15
   78087:	pop    %rbp
   78088:	ret
   78089:	int3
   7808a:	int3
   7808b:	int3
   7808c:	int3
   7808d:	int3
   7808e:	int3
   7808f:	int3

