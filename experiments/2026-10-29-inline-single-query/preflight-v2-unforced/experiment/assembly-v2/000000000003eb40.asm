000000000003eb40 <void inline_single_kernel<false, bloom_filters::FastPatternBF, unsigned long>(bloom_filters::FastPatternBF const&, unsigned long, unsigned long const*, unsigned int*)>:
   3eb40:	test   %rsi,%rsi
   3eb43:	je     3ecc4 <void inline_single_kernel<false, bloom_filters::FastPatternBF, unsigned long>(bloom_filters::FastPatternBF const&, unsigned long, unsigned long const*, unsigned int*)+0x184>
   3eb49:	push   %rbp
   3eb4a:	push   %r14
   3eb4c:	push   %rbx
   3eb4d:	mov    %rcx,%rax
   3eb50:	cmp    $0x1,%rsi
   3eb54:	jne    3eb5e <void inline_single_kernel<false, bloom_filters::FastPatternBF, unsigned long>(bloom_filters::FastPatternBF const&, unsigned long, unsigned long const*, unsigned int*)+0x1e>
   3eb56:	xor    %r8d,%r8d
   3eb59:	jmp    3ec5f <void inline_single_kernel<false, bloom_filters::FastPatternBF, unsigned long>(bloom_filters::FastPatternBF const&, unsigned long, unsigned long const*, unsigned int*)+0x11f>
   3eb5e:	mov    %rsi,%r9
   3eb61:	and    $0xfffffffffffffffe,%r9
   3eb65:	xor    %r8d,%r8d
   3eb68:	nopl   0x0(%rax,%rax,1)
   3eb70:	mov    (%rdx,%r8,8),%r10
   3eb74:	mov    %r10,%r11
   3eb77:	shr    $0x20,%r11
   3eb7b:	and    0x8(%rdi),%r11d
   3eb7f:	mov    %r10d,%ecx
   3eb82:	and    $0x1f,%ecx
   3eb85:	mov    (%rdi),%r14
   3eb88:	mov    0x10(%rdi),%rbx
   3eb8c:	mov    (%r14,%rcx,4),%ebp
   3eb90:	mov    %r10d,%ecx
   3eb93:	shr    $0x5,%ecx
   3eb96:	rol    %cl,%ebp
   3eb98:	mov    %r10d,%ecx
   3eb9b:	shr    $0x8,%ecx
   3eb9e:	and    $0x7c,%ecx
   3eba1:	mov    (%r14,%rcx,1),%r14d
   3eba5:	mov    %r10d,%ecx
   3eba8:	shr    $0xf,%ecx
   3ebab:	rol    %cl,%r14d
   3ebae:	mov    (%rbx,%r11,4),%ecx
   3ebb2:	andn   %ebp,%ecx,%ecx
   3ebb7:	shr    $0x14,%r10d
   3ebbb:	and    $0x7,%r10d
   3ebbf:	or     $0x8,%r10d
   3ebc3:	xor    %r11d,%r10d
   3ebc6:	mov    (%rbx,%r10,4),%r10d
   3ebca:	andn   %r14d,%r10d,%r10d
   3ebcf:	xor    %r11d,%r11d
   3ebd2:	or     %ecx,%r10d
   3ebd5:	sete   %r11b
   3ebd9:	mov    %r11d,(%rax,%r8,4)
   3ebdd:	mov    0x8(%rdx,%r8,8),%r10
   3ebe2:	mov    %r10,%r11
   3ebe5:	shr    $0x20,%r11
   3ebe9:	and    0x8(%rdi),%r11d
   3ebed:	mov    %r10d,%ecx
   3ebf0:	and    $0x1f,%ecx
   3ebf3:	mov    (%rdi),%r14
   3ebf6:	mov    0x10(%rdi),%rbx
   3ebfa:	mov    (%r14,%rcx,4),%ebp
   3ebfe:	mov    %r10d,%ecx
   3ec01:	shr    $0x5,%ecx
   3ec04:	rol    %cl,%ebp
   3ec06:	mov    %r10d,%ecx
   3ec09:	shr    $0x8,%ecx
   3ec0c:	and    $0x7c,%ecx
   3ec0f:	mov    (%r14,%rcx,1),%r14d
   3ec13:	mov    %r10d,%ecx
   3ec16:	shr    $0xf,%ecx
   3ec19:	rol    %cl,%r14d
   3ec1c:	mov    (%rbx,%r11,4),%ecx
   3ec20:	andn   %ebp,%ecx,%ecx
   3ec25:	shr    $0x14,%r10d
   3ec29:	and    $0x7,%r10d
   3ec2d:	or     $0x8,%r10d
   3ec31:	xor    %r11d,%r10d
   3ec34:	mov    (%rbx,%r10,4),%r10d
   3ec38:	andn   %r14d,%r10d,%r10d
   3ec3d:	xor    %r11d,%r11d
   3ec40:	or     %ecx,%r10d
   3ec43:	sete   %r11b
   3ec47:	mov    %r11d,0x4(%rax,%r8,4)
   3ec4c:	add    $0x2,%r8
   3ec50:	cmp    %r8,%r9
   3ec53:	jne    3eb70 <void inline_single_kernel<false, bloom_filters::FastPatternBF, unsigned long>(bloom_filters::FastPatternBF const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   3ec59:	test   $0x1,%sil
   3ec5d:	je     3ecc0 <void inline_single_kernel<false, bloom_filters::FastPatternBF, unsigned long>(bloom_filters::FastPatternBF const&, unsigned long, unsigned long const*, unsigned int*)+0x180>
   3ec5f:	mov    (%rdx,%r8,8),%rdx
   3ec63:	mov    %rdx,%rsi
   3ec66:	shr    $0x20,%rsi
   3ec6a:	and    0x8(%rdi),%esi
   3ec6d:	mov    %edx,%ecx
   3ec6f:	and    $0x1f,%ecx
   3ec72:	mov    (%rdi),%r9
   3ec75:	mov    0x10(%rdi),%rdi
   3ec79:	mov    (%r9,%rcx,4),%r10d
   3ec7d:	mov    %edx,%ecx
   3ec7f:	shr    $0x5,%ecx
   3ec82:	rol    %cl,%r10d
   3ec85:	mov    %edx,%ecx
   3ec87:	shr    $0x8,%ecx
   3ec8a:	and    $0x7c,%ecx
   3ec8d:	mov    (%r9,%rcx,1),%r9d
   3ec91:	mov    %edx,%ecx
   3ec93:	shr    $0xf,%ecx
   3ec96:	rol    %cl,%r9d
   3ec99:	mov    (%rdi,%rsi,4),%ecx
   3ec9c:	andn   %r10d,%ecx,%ecx
   3eca1:	shr    $0x14,%edx
   3eca4:	and    $0x7,%edx
   3eca7:	or     $0x8,%edx
   3ecaa:	xor    %esi,%edx
   3ecac:	mov    (%rdi,%rdx,4),%edx
   3ecaf:	andn   %r9d,%edx,%edx
   3ecb4:	xor    %esi,%esi
   3ecb6:	or     %ecx,%edx
   3ecb8:	sete   %sil
   3ecbc:	mov    %esi,(%rax,%r8,4)
   3ecc0:	pop    %rbx
   3ecc1:	pop    %r14
   3ecc3:	pop    %rbp
   3ecc4:	ret
   3ecc5:	int3
   3ecc6:	int3
   3ecc7:	int3
   3ecc8:	int3
   3ecc9:	int3
   3ecca:	int3
   3eccb:	int3
   3eccc:	int3
   3eccd:	int3
   3ecce:	int3
   3eccf:	int3

