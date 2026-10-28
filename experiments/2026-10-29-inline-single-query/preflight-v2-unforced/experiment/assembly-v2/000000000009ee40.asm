000000000009ee40 <void inline_single_kernel<false, external_bloom::Classical<6, false, true>, unsigned long>(external_bloom::Classical<6, false, true> const&, unsigned long, unsigned long const*, unsigned int*)>:
   9ee40:	push   %rbp
   9ee41:	push   %r15
   9ee43:	push   %r14
   9ee45:	push   %r13
   9ee47:	push   %r12
   9ee49:	push   %rbx
   9ee4a:	mov    %rcx,-0x8(%rsp)
   9ee4f:	mov    %rdx,-0x10(%rsp)
   9ee54:	test   %rsi,%rsi
   9ee57:	je     9ef5d <void inline_single_kernel<false, external_bloom::Classical<6, false, true>, unsigned long>(external_bloom::Classical<6, false, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x11d>
   9ee5d:	xor    %r14d,%r14d
   9ee60:	jmp    9ee85 <void inline_single_kernel<false, external_bloom::Classical<6, false, true>, unsigned long>(external_bloom::Classical<6, false, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x45>
   9ee62:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   9ee70:	mov    -0x8(%rsp),%rax
   9ee75:	mov    %edx,(%rax,%r14,4)
   9ee79:	inc    %r14
   9ee7c:	cmp    %r14,%rsi
   9ee7f:	je     9ef5d <void inline_single_kernel<false, external_bloom::Classical<6, false, true>, unsigned long>(external_bloom::Classical<6, false, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x11d>
   9ee85:	mov    -0x10(%rsp),%rax
   9ee8a:	mov    (%rax,%r14,8),%r8
   9ee8e:	rorx   $0x20,%r8,%rax
   9ee94:	mov    (%rdi),%r12
   9ee97:	mov    0x10(%rdi),%rbx
   9ee9b:	mov    %rbx,%rdx
   9ee9e:	mulx   %rax,%rcx,%rcx
   9eea3:	mov    (%r12,%rcx,8),%rdx
   9eea7:	lea    (%rax,%r8,1),%rcx
   9eeab:	lea    (%rcx,%r8,1),%r11
   9eeaf:	lea    (%r11,%r8,1),%r10
   9eeb3:	lea    (%r10,%r8,1),%r9
   9eeb7:	add    %r9,%r8
   9eeba:	bt     %rax,%rdx
   9eebe:	mov    %r11,%rdx
   9eec1:	mulx   %rbx,%rax,%rax
   9eec6:	mov    %r10,%rdx
   9eec9:	mulx   %rbx,%r15,%r15
   9eece:	mov    %r9,%rdx
   9eed1:	mulx   %rbx,%rbp,%rbp
   9eed6:	mov    %r8,%rdx
   9eed9:	mulx   %rbx,%r13,%r13
   9eede:	mov    $0x0,%edx
   9eee3:	jae    9ee70 <void inline_single_kernel<false, external_bloom::Classical<6, false, true>, unsigned long>(external_bloom::Classical<6, false, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   9eee5:	mov    %rbx,%rdx
   9eee8:	mulx   %rcx,%rdx,%rdx
   9eeed:	mov    (%r12,%rdx,8),%rdx
   9eef1:	bt     %rcx,%rdx
   9eef5:	mov    $0x0,%edx
   9eefa:	jae    9ee70 <void inline_single_kernel<false, external_bloom::Classical<6, false, true>, unsigned long>(external_bloom::Classical<6, false, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   9ef00:	mov    $0x1,%ecx
   9ef05:	shlx   %r11,%rcx,%rcx
   9ef0a:	mov    $0x0,%edx
   9ef0f:	test   %rcx,(%r12,%rax,8)
   9ef13:	je     9ee70 <void inline_single_kernel<false, external_bloom::Classical<6, false, true>, unsigned long>(external_bloom::Classical<6, false, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   9ef19:	mov    $0x1,%eax
   9ef1e:	shlx   %r10,%rax,%rax
   9ef23:	mov    $0x0,%edx
   9ef28:	test   %rax,(%r12,%r15,8)
   9ef2c:	je     9ee70 <void inline_single_kernel<false, external_bloom::Classical<6, false, true>, unsigned long>(external_bloom::Classical<6, false, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   9ef32:	mov    $0x1,%eax
   9ef37:	shlx   %r9,%rax,%rax
   9ef3c:	mov    $0x0,%edx
   9ef41:	test   %rax,(%r12,%rbp,8)
   9ef45:	je     9ee70 <void inline_single_kernel<false, external_bloom::Classical<6, false, true>, unsigned long>(external_bloom::Classical<6, false, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   9ef4b:	and    $0x3f,%r8d
   9ef4f:	shrx   %r8,(%r12,%r13,8),%rdx
   9ef55:	and    $0x1,%edx
   9ef58:	jmp    9ee70 <void inline_single_kernel<false, external_bloom::Classical<6, false, true>, unsigned long>(external_bloom::Classical<6, false, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   9ef5d:	pop    %rbx
   9ef5e:	pop    %r12
   9ef60:	pop    %r13
   9ef62:	pop    %r14
   9ef64:	pop    %r15
   9ef66:	pop    %rbp
   9ef67:	ret
   9ef68:	int3
   9ef69:	int3
   9ef6a:	int3
   9ef6b:	int3
   9ef6c:	int3
   9ef6d:	int3
   9ef6e:	int3
   9ef6f:	int3

