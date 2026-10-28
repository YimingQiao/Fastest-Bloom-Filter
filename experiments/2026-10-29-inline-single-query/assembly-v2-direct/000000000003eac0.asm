000000000003eac0 <void inline_single_kernel<false, bloom_filters::FastPatternBF, unsigned long>(bloom_filters::FastPatternBF const&, unsigned long, unsigned long const*, unsigned int*)>:
   3eac0:	test   %rsi,%rsi
   3eac3:	je     3ec44 <void inline_single_kernel<false, bloom_filters::FastPatternBF, unsigned long>(bloom_filters::FastPatternBF const&, unsigned long, unsigned long const*, unsigned int*)+0x184>
   3eac9:	push   %rbp
   3eaca:	push   %r14
   3eacc:	push   %rbx
   3eacd:	mov    %rcx,%rax
   3ead0:	cmp    $0x1,%rsi
   3ead4:	jne    3eade <void inline_single_kernel<false, bloom_filters::FastPatternBF, unsigned long>(bloom_filters::FastPatternBF const&, unsigned long, unsigned long const*, unsigned int*)+0x1e>
   3ead6:	xor    %r8d,%r8d
   3ead9:	jmp    3ebdf <void inline_single_kernel<false, bloom_filters::FastPatternBF, unsigned long>(bloom_filters::FastPatternBF const&, unsigned long, unsigned long const*, unsigned int*)+0x11f>
   3eade:	mov    %rsi,%r9
   3eae1:	and    $0xfffffffffffffffe,%r9
   3eae5:	xor    %r8d,%r8d
   3eae8:	nopl   0x0(%rax,%rax,1)
   3eaf0:	mov    (%rdx,%r8,8),%r10
   3eaf4:	mov    %r10,%r11
   3eaf7:	shr    $0x20,%r11
   3eafb:	and    0x8(%rdi),%r11d
   3eaff:	mov    %r10d,%ecx
   3eb02:	and    $0x1f,%ecx
   3eb05:	mov    (%rdi),%r14
   3eb08:	mov    0x10(%rdi),%rbx
   3eb0c:	mov    (%r14,%rcx,4),%ebp
   3eb10:	mov    %r10d,%ecx
   3eb13:	shr    $0x5,%ecx
   3eb16:	rol    %cl,%ebp
   3eb18:	mov    %r10d,%ecx
   3eb1b:	shr    $0x8,%ecx
   3eb1e:	and    $0x7c,%ecx
   3eb21:	mov    (%r14,%rcx,1),%r14d
   3eb25:	mov    %r10d,%ecx
   3eb28:	shr    $0xf,%ecx
   3eb2b:	rol    %cl,%r14d
   3eb2e:	mov    (%rbx,%r11,4),%ecx
   3eb32:	andn   %ebp,%ecx,%ecx
   3eb37:	shr    $0x14,%r10d
   3eb3b:	and    $0x7,%r10d
   3eb3f:	or     $0x8,%r10d
   3eb43:	xor    %r11d,%r10d
   3eb46:	mov    (%rbx,%r10,4),%r10d
   3eb4a:	andn   %r14d,%r10d,%r10d
   3eb4f:	xor    %r11d,%r11d
   3eb52:	or     %ecx,%r10d
   3eb55:	sete   %r11b
   3eb59:	mov    %r11d,(%rax,%r8,4)
   3eb5d:	mov    0x8(%rdx,%r8,8),%r10
   3eb62:	mov    %r10,%r11
   3eb65:	shr    $0x20,%r11
   3eb69:	and    0x8(%rdi),%r11d
   3eb6d:	mov    %r10d,%ecx
   3eb70:	and    $0x1f,%ecx
   3eb73:	mov    (%rdi),%r14
   3eb76:	mov    0x10(%rdi),%rbx
   3eb7a:	mov    (%r14,%rcx,4),%ebp
   3eb7e:	mov    %r10d,%ecx
   3eb81:	shr    $0x5,%ecx
   3eb84:	rol    %cl,%ebp
   3eb86:	mov    %r10d,%ecx
   3eb89:	shr    $0x8,%ecx
   3eb8c:	and    $0x7c,%ecx
   3eb8f:	mov    (%r14,%rcx,1),%r14d
   3eb93:	mov    %r10d,%ecx
   3eb96:	shr    $0xf,%ecx
   3eb99:	rol    %cl,%r14d
   3eb9c:	mov    (%rbx,%r11,4),%ecx
   3eba0:	andn   %ebp,%ecx,%ecx
   3eba5:	shr    $0x14,%r10d
   3eba9:	and    $0x7,%r10d
   3ebad:	or     $0x8,%r10d
   3ebb1:	xor    %r11d,%r10d
   3ebb4:	mov    (%rbx,%r10,4),%r10d
   3ebb8:	andn   %r14d,%r10d,%r10d
   3ebbd:	xor    %r11d,%r11d
   3ebc0:	or     %ecx,%r10d
   3ebc3:	sete   %r11b
   3ebc7:	mov    %r11d,0x4(%rax,%r8,4)
   3ebcc:	add    $0x2,%r8
   3ebd0:	cmp    %r8,%r9
   3ebd3:	jne    3eaf0 <void inline_single_kernel<false, bloom_filters::FastPatternBF, unsigned long>(bloom_filters::FastPatternBF const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   3ebd9:	test   $0x1,%sil
   3ebdd:	je     3ec40 <void inline_single_kernel<false, bloom_filters::FastPatternBF, unsigned long>(bloom_filters::FastPatternBF const&, unsigned long, unsigned long const*, unsigned int*)+0x180>
   3ebdf:	mov    (%rdx,%r8,8),%rdx
   3ebe3:	mov    %rdx,%rsi
   3ebe6:	shr    $0x20,%rsi
   3ebea:	and    0x8(%rdi),%esi
   3ebed:	mov    %edx,%ecx
   3ebef:	and    $0x1f,%ecx
   3ebf2:	mov    (%rdi),%r9
   3ebf5:	mov    0x10(%rdi),%rdi
   3ebf9:	mov    (%r9,%rcx,4),%r10d
   3ebfd:	mov    %edx,%ecx
   3ebff:	shr    $0x5,%ecx
   3ec02:	rol    %cl,%r10d
   3ec05:	mov    %edx,%ecx
   3ec07:	shr    $0x8,%ecx
   3ec0a:	and    $0x7c,%ecx
   3ec0d:	mov    (%r9,%rcx,1),%r9d
   3ec11:	mov    %edx,%ecx
   3ec13:	shr    $0xf,%ecx
   3ec16:	rol    %cl,%r9d
   3ec19:	mov    (%rdi,%rsi,4),%ecx
   3ec1c:	andn   %r10d,%ecx,%ecx
   3ec21:	shr    $0x14,%edx
   3ec24:	and    $0x7,%edx
   3ec27:	or     $0x8,%edx
   3ec2a:	xor    %esi,%edx
   3ec2c:	mov    (%rdi,%rdx,4),%edx
   3ec2f:	andn   %r9d,%edx,%edx
   3ec34:	xor    %esi,%esi
   3ec36:	or     %ecx,%edx
   3ec38:	sete   %sil
   3ec3c:	mov    %esi,(%rax,%r8,4)
   3ec40:	pop    %rbx
   3ec41:	pop    %r14
   3ec43:	pop    %rbp
   3ec44:	ret
   3ec45:	int3
   3ec46:	int3
   3ec47:	int3
   3ec48:	int3
   3ec49:	int3
   3ec4a:	int3
   3ec4b:	int3
   3ec4c:	int3
   3ec4d:	int3
   3ec4e:	int3
   3ec4f:	int3

