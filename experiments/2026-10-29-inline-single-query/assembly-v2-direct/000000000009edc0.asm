000000000009edc0 <void inline_single_kernel<false, external_bloom::Classical<6, false, true>, unsigned long>(external_bloom::Classical<6, false, true> const&, unsigned long, unsigned long const*, unsigned int*)>:
   9edc0:	push   %rbp
   9edc1:	push   %r15
   9edc3:	push   %r14
   9edc5:	push   %r13
   9edc7:	push   %r12
   9edc9:	push   %rbx
   9edca:	mov    %rcx,-0x8(%rsp)
   9edcf:	mov    %rdx,-0x10(%rsp)
   9edd4:	test   %rsi,%rsi
   9edd7:	je     9eedd <void inline_single_kernel<false, external_bloom::Classical<6, false, true>, unsigned long>(external_bloom::Classical<6, false, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x11d>
   9eddd:	xor    %r14d,%r14d
   9ede0:	jmp    9ee05 <void inline_single_kernel<false, external_bloom::Classical<6, false, true>, unsigned long>(external_bloom::Classical<6, false, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x45>
   9ede2:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   9edf0:	mov    -0x8(%rsp),%rax
   9edf5:	mov    %edx,(%rax,%r14,4)
   9edf9:	inc    %r14
   9edfc:	cmp    %r14,%rsi
   9edff:	je     9eedd <void inline_single_kernel<false, external_bloom::Classical<6, false, true>, unsigned long>(external_bloom::Classical<6, false, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x11d>
   9ee05:	mov    -0x10(%rsp),%rax
   9ee0a:	mov    (%rax,%r14,8),%r8
   9ee0e:	rorx   $0x20,%r8,%rax
   9ee14:	mov    (%rdi),%r12
   9ee17:	mov    0x10(%rdi),%rbx
   9ee1b:	mov    %rbx,%rdx
   9ee1e:	mulx   %rax,%rcx,%rcx
   9ee23:	mov    (%r12,%rcx,8),%rdx
   9ee27:	lea    (%rax,%r8,1),%rcx
   9ee2b:	lea    (%rcx,%r8,1),%r11
   9ee2f:	lea    (%r11,%r8,1),%r10
   9ee33:	lea    (%r10,%r8,1),%r9
   9ee37:	add    %r9,%r8
   9ee3a:	bt     %rax,%rdx
   9ee3e:	mov    %r11,%rdx
   9ee41:	mulx   %rbx,%rax,%rax
   9ee46:	mov    %r10,%rdx
   9ee49:	mulx   %rbx,%r15,%r15
   9ee4e:	mov    %r9,%rdx
   9ee51:	mulx   %rbx,%rbp,%rbp
   9ee56:	mov    %r8,%rdx
   9ee59:	mulx   %rbx,%r13,%r13
   9ee5e:	mov    $0x0,%edx
   9ee63:	jae    9edf0 <void inline_single_kernel<false, external_bloom::Classical<6, false, true>, unsigned long>(external_bloom::Classical<6, false, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   9ee65:	mov    %rbx,%rdx
   9ee68:	mulx   %rcx,%rdx,%rdx
   9ee6d:	mov    (%r12,%rdx,8),%rdx
   9ee71:	bt     %rcx,%rdx
   9ee75:	mov    $0x0,%edx
   9ee7a:	jae    9edf0 <void inline_single_kernel<false, external_bloom::Classical<6, false, true>, unsigned long>(external_bloom::Classical<6, false, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   9ee80:	mov    $0x1,%ecx
   9ee85:	shlx   %r11,%rcx,%rcx
   9ee8a:	mov    $0x0,%edx
   9ee8f:	test   %rcx,(%r12,%rax,8)
   9ee93:	je     9edf0 <void inline_single_kernel<false, external_bloom::Classical<6, false, true>, unsigned long>(external_bloom::Classical<6, false, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   9ee99:	mov    $0x1,%eax
   9ee9e:	shlx   %r10,%rax,%rax
   9eea3:	mov    $0x0,%edx
   9eea8:	test   %rax,(%r12,%r15,8)
   9eeac:	je     9edf0 <void inline_single_kernel<false, external_bloom::Classical<6, false, true>, unsigned long>(external_bloom::Classical<6, false, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   9eeb2:	mov    $0x1,%eax
   9eeb7:	shlx   %r9,%rax,%rax
   9eebc:	mov    $0x0,%edx
   9eec1:	test   %rax,(%r12,%rbp,8)
   9eec5:	je     9edf0 <void inline_single_kernel<false, external_bloom::Classical<6, false, true>, unsigned long>(external_bloom::Classical<6, false, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   9eecb:	and    $0x3f,%r8d
   9eecf:	shrx   %r8,(%r12,%r13,8),%rdx
   9eed5:	and    $0x1,%edx
   9eed8:	jmp    9edf0 <void inline_single_kernel<false, external_bloom::Classical<6, false, true>, unsigned long>(external_bloom::Classical<6, false, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   9eedd:	pop    %rbx
   9eede:	pop    %r12
   9eee0:	pop    %r13
   9eee2:	pop    %r14
   9eee4:	pop    %r15
   9eee6:	pop    %rbp
   9eee7:	ret
   9eee8:	int3
   9eee9:	int3
   9eeea:	int3
   9eeeb:	int3
   9eeec:	int3
   9eeed:	int3
   9eeee:	int3
   9eeef:	int3

