00000000000af110 <void inline_single_kernel<true, external_bloom::Page<4u, false>, unsigned long>(external_bloom::Page<4u, false> const&, unsigned long, unsigned long const*, unsigned int*)>:
   af110:	test   %rsi,%rsi
   af113:	je     af2e1 <void inline_single_kernel<true, external_bloom::Page<4u, false>, unsigned long>(external_bloom::Page<4u, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x1d1>
   af119:	push   %rbp
   af11a:	push   %r15
   af11c:	push   %r14
   af11e:	push   %r13
   af120:	push   %r12
   af122:	push   %rbx
   af123:	mov    %rdx,%rax
   af126:	xor    %r8d,%r8d
   af129:	movabs $0xdeadbeefdeadbeef,%r9
   af133:	movabs $0xe6adbeefdeadbeef,%r10
   af13d:	mov    $0xffffffff,%r11d
   af143:	mov    $0x1,%ebx
   af148:	jmp    af160 <void inline_single_kernel<true, external_bloom::Page<4u, false>, unsigned long>(external_bloom::Page<4u, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
   af14a:	nopw   0x0(%rax,%rax,1)
   af150:	mov    %ebp,(%rcx,%r8,4)
   af154:	inc    %r8
   af157:	cmp    %r8,%rsi
   af15a:	je     af2d7 <void inline_single_kernel<true, external_bloom::Page<4u, false>, unsigned long>(external_bloom::Page<4u, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x1c7>
   af160:	mov    (%rax,%r8,8),%rdx
   af164:	add    %r9,%rdx
   af167:	rorx   $0x31,%rdx,%r14
   af16d:	xor    %r10,%rdx
   af170:	add    %r14,%rdx
   af173:	rorx   $0xc,%rdx,%r15
   af179:	add    %r15,%rdx
   af17c:	rorx   $0x26,%rdx,%r12
   af182:	add    %r12,%rdx
   af185:	xor    %rdx,%r14
   af188:	rorx   $0xd,%rdx,%rdx
   af18e:	add    %rdx,%r14
   af191:	xor    %r14,%r15
   af194:	rorx   $0x24,%r14,%r14
   af19a:	add    %r14,%r15
   af19d:	xor    %r15,%r12
   af1a0:	rorx   $0x37,%r15,%r15
   af1a6:	add    %r15,%r12
   af1a9:	xor    %r12,%rdx
   af1ac:	rorx   $0x11,%r12,%r12
   af1b2:	add    %r12,%rdx
   af1b5:	xor    %rdx,%r14
   af1b8:	rorx   $0xa,%rdx,%rdx
   af1be:	add    %rdx,%r14
   af1c1:	xor    %r14,%r15
   af1c4:	rorx   $0x20,%r14,%r14
   af1ca:	add    %r15,%r14
   af1cd:	xor    %r14,%r12
   af1d0:	rorx   $0x27,%r14,%r14
   af1d6:	add    %r12,%r14
   af1d9:	xor    %r14,%rdx
   af1dc:	rorx   $0x1,%r14,%r14
   af1e2:	add    %r14,%rdx
   af1e5:	mov    %r14,%r12
   af1e8:	shr    $0x20,%r12
   af1ec:	mov    %edx,%ebp
   af1ee:	shr    $0x20,%rdx
   af1f2:	rorx   $0x18,%r14d,%r15d
   af1f8:	rorx   $0x1a,%r12d,%r13d
   af1fe:	xor    %r15d,%r13d
   af201:	rorx   $0x1c,%ebp,%ebp
   af207:	xor    %r13d,%ebp
   af20a:	rorx   $0x1e,%edx,%edx
   af210:	xor    %ebp,%edx
   af212:	mov    0x8(%rdi),%r15d
   af216:	imul   0x10(%rdi),%rdx
   af21b:	mulx   %r15,%rdx,%rdx
   af220:	movzbl (%rdi),%r15d
   af224:	shlx   %r15,%rdx,%rdx
   af229:	add    0x20(%rdi),%rdx
   af22d:	add    $0x3,%r15b
   af231:	bzhi   %r15d,%r14d,%ebp
   af236:	movzwl %bp,%r13d
   af23a:	shr    $0x3,%r13d
   af23e:	movzbl 0x0(%r13,%rdx,1),%r13d
   af244:	and    $0x7,%ebp
   af247:	bt     %ebp,%r13d
   af24b:	mov    $0x0,%ebp
   af250:	jae    af150 <void inline_single_kernel<true, external_bloom::Page<4u, false>, unsigned long>(external_bloom::Page<4u, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
   af256:	shlx   %r15d,%r11d,%ebp
   af25b:	mov    %r14d,%r13d
   af25e:	shr    $0x10,%r13d
   af262:	andn   %r13d,%ebp,%ebp
   af267:	mov    %ebp,%r13d
   af26a:	shr    $0x3,%r13d
   af26e:	movzbl (%rdx,%r13,1),%r13d
   af273:	and    $0x7,%ebp
   af276:	bt     %ebp,%r13d
   af27a:	mov    $0x0,%ebp
   af27f:	jae    af150 <void inline_single_kernel<true, external_bloom::Page<4u, false>, unsigned long>(external_bloom::Page<4u, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
   af285:	bzhi   %r15d,%r12d,%ebp
   af28a:	movzwl %bp,%r12d
   af28e:	and    $0x7,%bpl
   af292:	shr    $0x3,%r12d
   af296:	shlx   %ebp,%ebx,%ebp
   af29b:	movzbl (%rdx,%r12,1),%r12d
   af2a0:	movzwl %bp,%r13d
   af2a4:	mov    $0x0,%ebp
   af2a9:	test   %r12d,%r13d
   af2ac:	je     af150 <void inline_single_kernel<true, external_bloom::Page<4u, false>, unsigned long>(external_bloom::Page<4u, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
   af2b2:	shr    $0x30,%r14
   af2b6:	bzhi   %r15d,%r14d,%r14d
   af2bb:	mov    %r14d,%ebp
   af2be:	and    $0x7,%ebp
   af2c1:	shr    $0x3,%r14d
   af2c5:	movzbl (%rdx,%r14,1),%edx
   af2ca:	shrx   %ebp,%edx,%ebp
   af2cf:	and    $0x1,%ebp
   af2d2:	jmp    af150 <void inline_single_kernel<true, external_bloom::Page<4u, false>, unsigned long>(external_bloom::Page<4u, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
   af2d7:	pop    %rbx
   af2d8:	pop    %r12
   af2da:	pop    %r13
   af2dc:	pop    %r14
   af2de:	pop    %r15
   af2e0:	pop    %rbp
   af2e1:	ret
   af2e2:	int3
   af2e3:	int3
   af2e4:	int3
   af2e5:	int3
   af2e6:	int3
   af2e7:	int3
   af2e8:	int3
   af2e9:	int3
   af2ea:	int3
   af2eb:	int3
   af2ec:	int3
   af2ed:	int3
   af2ee:	int3
   af2ef:	int3

