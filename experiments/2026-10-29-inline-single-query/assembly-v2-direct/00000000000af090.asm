00000000000af090 <void inline_single_kernel<true, external_bloom::Page<4u, false>, unsigned long>(external_bloom::Page<4u, false> const&, unsigned long, unsigned long const*, unsigned int*)>:
   af090:	test   %rsi,%rsi
   af093:	je     af261 <void inline_single_kernel<true, external_bloom::Page<4u, false>, unsigned long>(external_bloom::Page<4u, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x1d1>
   af099:	push   %rbp
   af09a:	push   %r15
   af09c:	push   %r14
   af09e:	push   %r13
   af0a0:	push   %r12
   af0a2:	push   %rbx
   af0a3:	mov    %rdx,%rax
   af0a6:	xor    %r8d,%r8d
   af0a9:	movabs $0xdeadbeefdeadbeef,%r9
   af0b3:	movabs $0xe6adbeefdeadbeef,%r10
   af0bd:	mov    $0xffffffff,%r11d
   af0c3:	mov    $0x1,%ebx
   af0c8:	jmp    af0e0 <void inline_single_kernel<true, external_bloom::Page<4u, false>, unsigned long>(external_bloom::Page<4u, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
   af0ca:	nopw   0x0(%rax,%rax,1)
   af0d0:	mov    %ebp,(%rcx,%r8,4)
   af0d4:	inc    %r8
   af0d7:	cmp    %r8,%rsi
   af0da:	je     af257 <void inline_single_kernel<true, external_bloom::Page<4u, false>, unsigned long>(external_bloom::Page<4u, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x1c7>
   af0e0:	mov    (%rax,%r8,8),%rdx
   af0e4:	add    %r9,%rdx
   af0e7:	rorx   $0x31,%rdx,%r14
   af0ed:	xor    %r10,%rdx
   af0f0:	add    %r14,%rdx
   af0f3:	rorx   $0xc,%rdx,%r15
   af0f9:	add    %r15,%rdx
   af0fc:	rorx   $0x26,%rdx,%r12
   af102:	add    %r12,%rdx
   af105:	xor    %rdx,%r14
   af108:	rorx   $0xd,%rdx,%rdx
   af10e:	add    %rdx,%r14
   af111:	xor    %r14,%r15
   af114:	rorx   $0x24,%r14,%r14
   af11a:	add    %r14,%r15
   af11d:	xor    %r15,%r12
   af120:	rorx   $0x37,%r15,%r15
   af126:	add    %r15,%r12
   af129:	xor    %r12,%rdx
   af12c:	rorx   $0x11,%r12,%r12
   af132:	add    %r12,%rdx
   af135:	xor    %rdx,%r14
   af138:	rorx   $0xa,%rdx,%rdx
   af13e:	add    %rdx,%r14
   af141:	xor    %r14,%r15
   af144:	rorx   $0x20,%r14,%r14
   af14a:	add    %r15,%r14
   af14d:	xor    %r14,%r12
   af150:	rorx   $0x27,%r14,%r14
   af156:	add    %r12,%r14
   af159:	xor    %r14,%rdx
   af15c:	rorx   $0x1,%r14,%r14
   af162:	add    %r14,%rdx
   af165:	mov    %r14,%r12
   af168:	shr    $0x20,%r12
   af16c:	mov    %edx,%ebp
   af16e:	shr    $0x20,%rdx
   af172:	rorx   $0x18,%r14d,%r15d
   af178:	rorx   $0x1a,%r12d,%r13d
   af17e:	xor    %r15d,%r13d
   af181:	rorx   $0x1c,%ebp,%ebp
   af187:	xor    %r13d,%ebp
   af18a:	rorx   $0x1e,%edx,%edx
   af190:	xor    %ebp,%edx
   af192:	mov    0x8(%rdi),%r15d
   af196:	imul   0x10(%rdi),%rdx
   af19b:	mulx   %r15,%rdx,%rdx
   af1a0:	movzbl (%rdi),%r15d
   af1a4:	shlx   %r15,%rdx,%rdx
   af1a9:	add    0x20(%rdi),%rdx
   af1ad:	add    $0x3,%r15b
   af1b1:	bzhi   %r15d,%r14d,%ebp
   af1b6:	movzwl %bp,%r13d
   af1ba:	shr    $0x3,%r13d
   af1be:	movzbl 0x0(%r13,%rdx,1),%r13d
   af1c4:	and    $0x7,%ebp
   af1c7:	bt     %ebp,%r13d
   af1cb:	mov    $0x0,%ebp
   af1d0:	jae    af0d0 <void inline_single_kernel<true, external_bloom::Page<4u, false>, unsigned long>(external_bloom::Page<4u, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
   af1d6:	shlx   %r15d,%r11d,%ebp
   af1db:	mov    %r14d,%r13d
   af1de:	shr    $0x10,%r13d
   af1e2:	andn   %r13d,%ebp,%ebp
   af1e7:	mov    %ebp,%r13d
   af1ea:	shr    $0x3,%r13d
   af1ee:	movzbl (%rdx,%r13,1),%r13d
   af1f3:	and    $0x7,%ebp
   af1f6:	bt     %ebp,%r13d
   af1fa:	mov    $0x0,%ebp
   af1ff:	jae    af0d0 <void inline_single_kernel<true, external_bloom::Page<4u, false>, unsigned long>(external_bloom::Page<4u, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
   af205:	bzhi   %r15d,%r12d,%ebp
   af20a:	movzwl %bp,%r12d
   af20e:	and    $0x7,%bpl
   af212:	shr    $0x3,%r12d
   af216:	shlx   %ebp,%ebx,%ebp
   af21b:	movzbl (%rdx,%r12,1),%r12d
   af220:	movzwl %bp,%r13d
   af224:	mov    $0x0,%ebp
   af229:	test   %r12d,%r13d
   af22c:	je     af0d0 <void inline_single_kernel<true, external_bloom::Page<4u, false>, unsigned long>(external_bloom::Page<4u, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
   af232:	shr    $0x30,%r14
   af236:	bzhi   %r15d,%r14d,%r14d
   af23b:	mov    %r14d,%ebp
   af23e:	and    $0x7,%ebp
   af241:	shr    $0x3,%r14d
   af245:	movzbl (%rdx,%r14,1),%edx
   af24a:	shrx   %ebp,%edx,%ebp
   af24f:	and    $0x1,%ebp
   af252:	jmp    af0d0 <void inline_single_kernel<true, external_bloom::Page<4u, false>, unsigned long>(external_bloom::Page<4u, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
   af257:	pop    %rbx
   af258:	pop    %r12
   af25a:	pop    %r13
   af25c:	pop    %r14
   af25e:	pop    %r15
   af260:	pop    %rbp
   af261:	ret
   af262:	int3
   af263:	int3
   af264:	int3
   af265:	int3
   af266:	int3
   af267:	int3
   af268:	int3
   af269:	int3
   af26a:	int3
   af26b:	int3
   af26c:	int3
   af26d:	int3
   af26e:	int3
   af26f:	int3

