0000000000083130 <void inline_single_kernel<false, external_bloom::Classical<16, false, false>, unsigned long>(external_bloom::Classical<16, false, false> const&, unsigned long, unsigned long const*, unsigned int*)>:
   83130:	test   %rsi,%rsi
   83133:	je     83193 <void inline_single_kernel<false, external_bloom::Classical<16, false, false>, unsigned long>(external_bloom::Classical<16, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x63>
   83135:	push   %rbp
   83136:	push   %r15
   83138:	push   %r14
   8313a:	push   %r13
   8313c:	push   %r12
   8313e:	push   %rbx
   8313f:	push   %rax
   83140:	mov    %rcx,%rbx
   83143:	mov    %rdx,%r14
   83146:	mov    %rsi,%r15
   83149:	mov    %rdi,%r12
   8314c:	xor    %ebp,%ebp
   8314e:	mov    %rsp,%r13
   83151:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   83160:	mov    (%r14,%rbp,8),%rax
   83164:	mov    %rax,(%rsp)
   83168:	mov    %r12,%rdi
   8316b:	mov    %r13,%rsi
   8316e:	call   838d0 <bloomfilter::BloomFilter<unsigned long, 8ul, false, external_bloom::IdentityHash, 16>::Contain(unsigned long const&) const>
   83173:	xor    %ecx,%ecx
   83175:	test   %eax,%eax
   83177:	sete   %cl
   8317a:	mov    %ecx,(%rbx,%rbp,4)
   8317d:	inc    %rbp
   83180:	cmp    %rbp,%r15
   83183:	jne    83160 <void inline_single_kernel<false, external_bloom::Classical<16, false, false>, unsigned long>(external_bloom::Classical<16, false, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   83185:	add    $0x8,%rsp
   83189:	pop    %rbx
   8318a:	pop    %r12
   8318c:	pop    %r13
   8318e:	pop    %r14
   83190:	pop    %r15
   83192:	pop    %rbp
   83193:	ret
   83194:	int3
   83195:	int3
   83196:	int3
   83197:	int3
   83198:	int3
   83199:	int3
   8319a:	int3
   8319b:	int3
   8319c:	int3
   8319d:	int3
   8319e:	int3
   8319f:	int3

