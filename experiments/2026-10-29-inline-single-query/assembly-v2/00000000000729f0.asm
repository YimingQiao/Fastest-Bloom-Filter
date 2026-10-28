00000000000729f0 <void inline_single_kernel<true, external_bloom::Classical<6, false, false>, unsigned long>(external_bloom::Classical<6, false, false> const&, unsigned long, unsigned long const*, unsigned int*)>:
   729f0:	push   %rbp
   729f1:	push   %r15
   729f3:	push   %r14
   729f5:	push   %r13
   729f7:	push   %r12
   729f9:	push   %rbx
   729fa:	mov    %rcx,-0x8(%rsp)
   729ff:	mov    %rdx,-0x10(%rsp)
   72a04:	test   %rsi,%rsi
   72a07:	je     72b47 <void inline_single_kernel<true, external_bloom::Classical<6, false, false>, unsigned long>(external_bloom::Classical<6, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x157>
   72a0d:	xor    %r15d,%r15d
   72a10:	jmp    72a35 <void inline_single_kernel<true, external_bloom::Classical<6, false, false>, unsigned long>(external_bloom::Classical<6, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x45>
   72a12:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   72a20:	mov    -0x8(%rsp),%rax
   72a25:	mov    %edx,(%rax,%r15,4)
   72a29:	inc    %r15
   72a2c:	cmp    %r15,%rsi
   72a2f:	je     72b47 <void inline_single_kernel<true, external_bloom::Classical<6, false, false>, unsigned long>(external_bloom::Classical<6, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x157>
   72a35:	mov    -0x10(%rsp),%rax
   72a3a:	mov    (%rax,%r15,8),%rax
   72a3e:	mov    %rax,%rcx
   72a41:	shr    $0x20,%rcx
   72a45:	xor    %rax,%rcx
   72a48:	movabs $0xd6e8feb86659fd93,%rdx
   72a52:	imul   %rdx,%rcx
   72a56:	mov    %rcx,%rax
   72a59:	shr    $0x20,%rax
   72a5d:	xor    %rcx,%rax
   72a60:	imul   %rdx,%rax
   72a64:	mov    %rax,%r8
   72a67:	shr    $0x20,%r8
   72a6b:	xor    %rax,%r8
   72a6e:	rorx   $0x20,%r8,%rax
   72a74:	mov    (%rdi),%r13
   72a77:	mov    0x10(%rdi),%rbx
   72a7b:	mov    %rbx,%rdx
   72a7e:	mulx   %rax,%rcx,%rcx
   72a83:	mov    0x0(%r13,%rcx,8),%rcx
   72a88:	lea    (%rax,%r8,1),%r14
   72a8c:	lea    (%r14,%r8,1),%r11
   72a90:	lea    (%r11,%r8,1),%r10
   72a94:	lea    (%r10,%r8,1),%r9
   72a98:	add    %r9,%r8
   72a9b:	bt     %rax,%rcx
   72a9f:	mov    %r11,%rdx
   72aa2:	mulx   %rbx,%rcx,%rcx
   72aa7:	mov    %r10,%rdx
   72aaa:	mulx   %rbx,%rax,%rax
   72aaf:	mov    %r9,%rdx
   72ab2:	mulx   %rbx,%r12,%r12
   72ab7:	mov    %r8,%rdx
   72aba:	mulx   %rbx,%rbp,%rbp
   72abf:	mov    $0x0,%edx
   72ac4:	jae    72a20 <void inline_single_kernel<true, external_bloom::Classical<6, false, false>, unsigned long>(external_bloom::Classical<6, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   72aca:	mov    %rbx,%rdx
   72acd:	mulx   %r14,%rdx,%rdx
   72ad2:	mov    0x0(%r13,%rdx,8),%rdx
   72ad7:	bt     %r14,%rdx
   72adb:	mov    $0x0,%edx
   72ae0:	jae    72a20 <void inline_single_kernel<true, external_bloom::Classical<6, false, false>, unsigned long>(external_bloom::Classical<6, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   72ae6:	mov    $0x1,%edx
   72aeb:	shlx   %r11,%rdx,%r11
   72af0:	mov    $0x0,%edx
   72af5:	test   %r11,0x0(%r13,%rcx,8)
   72afa:	je     72a20 <void inline_single_kernel<true, external_bloom::Classical<6, false, false>, unsigned long>(external_bloom::Classical<6, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   72b00:	mov    $0x1,%ecx
   72b05:	shlx   %r10,%rcx,%rcx
   72b0a:	mov    $0x0,%edx
   72b0f:	test   %rcx,0x0(%r13,%rax,8)
   72b14:	je     72a20 <void inline_single_kernel<true, external_bloom::Classical<6, false, false>, unsigned long>(external_bloom::Classical<6, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   72b1a:	mov    $0x1,%eax
   72b1f:	shlx   %r9,%rax,%rax
   72b24:	mov    $0x0,%edx
   72b29:	test   %rax,0x0(%r13,%r12,8)
   72b2e:	je     72a20 <void inline_single_kernel<true, external_bloom::Classical<6, false, false>, unsigned long>(external_bloom::Classical<6, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   72b34:	and    $0x3f,%r8d
   72b38:	shrx   %r8,0x0(%r13,%rbp,8),%rdx
   72b3f:	and    $0x1,%edx
   72b42:	jmp    72a20 <void inline_single_kernel<true, external_bloom::Classical<6, false, false>, unsigned long>(external_bloom::Classical<6, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   72b47:	pop    %rbx
   72b48:	pop    %r12
   72b4a:	pop    %r13
   72b4c:	pop    %r14
   72b4e:	pop    %r15
   72b50:	pop    %rbp
   72b51:	ret
   72b52:	int3
   72b53:	int3
   72b54:	int3
   72b55:	int3
   72b56:	int3
   72b57:	int3
   72b58:	int3
   72b59:	int3
   72b5a:	int3
   72b5b:	int3
   72b5c:	int3
   72b5d:	int3
   72b5e:	int3
   72b5f:	int3

