0000000000072970 <void inline_single_kernel<true, external_bloom::Classical<6, false, false>, unsigned long>(external_bloom::Classical<6, false, false> const&, unsigned long, unsigned long const*, unsigned int*)>:
   72970:	push   %rbp
   72971:	push   %r15
   72973:	push   %r14
   72975:	push   %r13
   72977:	push   %r12
   72979:	push   %rbx
   7297a:	mov    %rcx,-0x8(%rsp)
   7297f:	mov    %rdx,-0x10(%rsp)
   72984:	test   %rsi,%rsi
   72987:	je     72ac7 <void inline_single_kernel<true, external_bloom::Classical<6, false, false>, unsigned long>(external_bloom::Classical<6, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x157>
   7298d:	xor    %r15d,%r15d
   72990:	jmp    729b5 <void inline_single_kernel<true, external_bloom::Classical<6, false, false>, unsigned long>(external_bloom::Classical<6, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x45>
   72992:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   729a0:	mov    -0x8(%rsp),%rax
   729a5:	mov    %edx,(%rax,%r15,4)
   729a9:	inc    %r15
   729ac:	cmp    %r15,%rsi
   729af:	je     72ac7 <void inline_single_kernel<true, external_bloom::Classical<6, false, false>, unsigned long>(external_bloom::Classical<6, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x157>
   729b5:	mov    -0x10(%rsp),%rax
   729ba:	mov    (%rax,%r15,8),%rax
   729be:	mov    %rax,%rcx
   729c1:	shr    $0x20,%rcx
   729c5:	xor    %rax,%rcx
   729c8:	movabs $0xd6e8feb86659fd93,%rdx
   729d2:	imul   %rdx,%rcx
   729d6:	mov    %rcx,%rax
   729d9:	shr    $0x20,%rax
   729dd:	xor    %rcx,%rax
   729e0:	imul   %rdx,%rax
   729e4:	mov    %rax,%r8
   729e7:	shr    $0x20,%r8
   729eb:	xor    %rax,%r8
   729ee:	rorx   $0x20,%r8,%rax
   729f4:	mov    (%rdi),%r13
   729f7:	mov    0x10(%rdi),%rbx
   729fb:	mov    %rbx,%rdx
   729fe:	mulx   %rax,%rcx,%rcx
   72a03:	mov    0x0(%r13,%rcx,8),%rcx
   72a08:	lea    (%rax,%r8,1),%r14
   72a0c:	lea    (%r14,%r8,1),%r11
   72a10:	lea    (%r11,%r8,1),%r10
   72a14:	lea    (%r10,%r8,1),%r9
   72a18:	add    %r9,%r8
   72a1b:	bt     %rax,%rcx
   72a1f:	mov    %r11,%rdx
   72a22:	mulx   %rbx,%rcx,%rcx
   72a27:	mov    %r10,%rdx
   72a2a:	mulx   %rbx,%rax,%rax
   72a2f:	mov    %r9,%rdx
   72a32:	mulx   %rbx,%r12,%r12
   72a37:	mov    %r8,%rdx
   72a3a:	mulx   %rbx,%rbp,%rbp
   72a3f:	mov    $0x0,%edx
   72a44:	jae    729a0 <void inline_single_kernel<true, external_bloom::Classical<6, false, false>, unsigned long>(external_bloom::Classical<6, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   72a4a:	mov    %rbx,%rdx
   72a4d:	mulx   %r14,%rdx,%rdx
   72a52:	mov    0x0(%r13,%rdx,8),%rdx
   72a57:	bt     %r14,%rdx
   72a5b:	mov    $0x0,%edx
   72a60:	jae    729a0 <void inline_single_kernel<true, external_bloom::Classical<6, false, false>, unsigned long>(external_bloom::Classical<6, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   72a66:	mov    $0x1,%edx
   72a6b:	shlx   %r11,%rdx,%r11
   72a70:	mov    $0x0,%edx
   72a75:	test   %r11,0x0(%r13,%rcx,8)
   72a7a:	je     729a0 <void inline_single_kernel<true, external_bloom::Classical<6, false, false>, unsigned long>(external_bloom::Classical<6, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   72a80:	mov    $0x1,%ecx
   72a85:	shlx   %r10,%rcx,%rcx
   72a8a:	mov    $0x0,%edx
   72a8f:	test   %rcx,0x0(%r13,%rax,8)
   72a94:	je     729a0 <void inline_single_kernel<true, external_bloom::Classical<6, false, false>, unsigned long>(external_bloom::Classical<6, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   72a9a:	mov    $0x1,%eax
   72a9f:	shlx   %r9,%rax,%rax
   72aa4:	mov    $0x0,%edx
   72aa9:	test   %rax,0x0(%r13,%r12,8)
   72aae:	je     729a0 <void inline_single_kernel<true, external_bloom::Classical<6, false, false>, unsigned long>(external_bloom::Classical<6, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   72ab4:	and    $0x3f,%r8d
   72ab8:	shrx   %r8,0x0(%r13,%rbp,8),%rdx
   72abf:	and    $0x1,%edx
   72ac2:	jmp    729a0 <void inline_single_kernel<true, external_bloom::Classical<6, false, false>, unsigned long>(external_bloom::Classical<6, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   72ac7:	pop    %rbx
   72ac8:	pop    %r12
   72aca:	pop    %r13
   72acc:	pop    %r14
   72ace:	pop    %r15
   72ad0:	pop    %rbp
   72ad1:	ret
   72ad2:	int3
   72ad3:	int3
   72ad4:	int3
   72ad5:	int3
   72ad6:	int3
   72ad7:	int3
   72ad8:	int3
   72ad9:	int3
   72ada:	int3
   72adb:	int3
   72adc:	int3
   72add:	int3
   72ade:	int3
   72adf:	int3

