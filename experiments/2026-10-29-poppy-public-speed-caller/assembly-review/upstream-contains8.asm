00000000000ff3a0 <<poppy_filters::bloom::v2::BloomFilter>::contains_bytes::<[u8; 8]>>:
   ff3a0:	push   %rbp
   ff3a1:	push   %rbx
   ff3a2:	push   %rax
   ff3a3:	cmpq   $0x0,0x60(%rdi)
   ff3a8:	je     ff424 <<poppy_filters::bloom::v2::BloomFilter>::contains_bytes::<[u8; 8]>+0x84>
   ff3aa:	mov    0x70(%rdi),%r9
   ff3ae:	mov    %rsi,%rax
   ff3b1:	shl    $0xc,%rax
   ff3b5:	xor    %rsi,%rax
   ff3b8:	mov    %rax,%rcx
   ff3bb:	shr    $0x19,%rcx
   ff3bf:	xor    %rax,%rcx
   ff3c2:	mov    %rcx,%rdx
   ff3c5:	shl    $0x1b,%rdx
   ff3c9:	xor    %rcx,%rdx
   ff3cc:	movabs $0x2545f4914f6cdd1d,%rax
   ff3d6:	imul   %rdx,%rax
   ff3da:	mov    0x10(%rdi),%rcx
   ff3de:	test   %rcx,%rcx
   ff3e1:	je     ff40e <<poppy_filters::bloom::v2::BloomFilter>::contains_bytes::<[u8; 8]>+0x6e>
   ff3e3:	lea    -0x1(,%rcx,8),%r8
   ff3eb:	and    %rax,%r8
   ff3ee:	shr    $0x3,%r8
   ff3f2:	cmp    %rcx,%r8
   ff3f5:	jae    ff4c6 <<poppy_filters::bloom::v2::BloomFilter>::contains_bytes::<[u8; 8]>+0x126>
   ff3fb:	mov    0x8(%rdi),%rcx
   ff3ff:	movzbl (%rcx,%r8,1),%ecx
   ff404:	mov    %eax,%edx
   ff406:	and    $0x7,%edx
   ff409:	bt     %edx,%ecx
   ff40c:	jae    ff424 <<poppy_filters::bloom::v2::BloomFilter>::contains_bytes::<[u8; 8]>+0x84>
   ff40e:	mov    0x28(%rdi),%rcx
   ff412:	popcnt %rcx,%rdx
   ff417:	cmp    $0x1,%edx
   ff41a:	jne    ff42d <<poppy_filters::bloom::v2::BloomFilter>::contains_bytes::<[u8; 8]>+0x8d>
   ff41c:	dec    %rcx
   ff41f:	and    %rax,%rcx
   ff422:	jmp    ff43e <<poppy_filters::bloom::v2::BloomFilter>::contains_bytes::<[u8; 8]>+0x9e>
   ff424:	xor    %eax,%eax
   ff426:	add    $0x8,%rsp
   ff42a:	pop    %rbx
   ff42b:	pop    %rbp
   ff42c:	ret
   ff42d:	test   %rcx,%rcx
   ff430:	je     ff4d9 <<poppy_filters::bloom::v2::BloomFilter>::contains_bytes::<[u8; 8]>+0x139>
   ff436:	xor    %edx,%edx
   ff438:	div    %rcx
   ff43b:	mov    %rdx,%rcx
   ff43e:	shl    $0xc,%rcx
   ff442:	add    0x20(%rdi),%rcx
   ff446:	xor    %edi,%edi
   ff448:	movabs $0xe7037ed1a0b428db,%r8
   ff452:	movabs $0xd0196d1401ee596d,%r10
   ff45c:	movabs $0xeb44accab455d16d,%r11
   ff466:	xor    %edx,%edx
   ff468:	jmp    ff492 <<poppy_filters::bloom::v2::BloomFilter>::contains_bytes::<[u8; 8]>+0xf2>
   ff46a:	nopw   0x0(%rax,%rax,1)
   ff470:	add    %rdx,%rsi
   ff473:	add    %rdi,%rdx
   ff476:	inc    %rdi
   ff479:	mov    %esi,%ebx
   ff47b:	shr    $0x3,%ebx
   ff47e:	and    $0xfff,%ebx
   ff484:	movzbl (%rcx,%rbx,1),%ebx
   ff488:	mov    %esi,%ebp
   ff48a:	and    $0x7,%ebp
   ff48d:	bt     %ebp,%ebx
   ff490:	jae    ff426 <<poppy_filters::bloom::v2::BloomFilter>::contains_bytes::<[u8; 8]>+0x86>
   ff492:	cmp    %rdi,%r9
   ff495:	sete   %al
   ff498:	je     ff426 <<poppy_filters::bloom::v2::BloomFilter>::contains_bytes::<[u8; 8]>+0x86>
   ff49a:	test   %rdi,%rdi
   ff49d:	je     ff476 <<poppy_filters::bloom::v2::BloomFilter>::contains_bytes::<[u8; 8]>+0xd6>
   ff49f:	cmp    $0x1,%rdi
   ff4a3:	jne    ff470 <<poppy_filters::bloom::v2::BloomFilter>::contains_bytes::<[u8; 8]>+0xd0>
   ff4a5:	mov    %rsi,%rdx
   ff4a8:	bswap  %rdx
   ff4ab:	rorx   $0x20,%rdx,%rdx
   ff4b1:	xor    %r8,%rdx
   ff4b4:	mulx   %r10,%rbx,%rdx
   ff4b9:	xor    %rbx,%rdx
   ff4bc:	mulx   %r11,%rbx,%rdx
   ff4c1:	xor    %rbx,%rdx
   ff4c4:	jmp    ff470 <<poppy_filters::bloom::v2::BloomFilter>::contains_bytes::<[u8; 8]>+0xd0>
   ff4c6:	lea    0xd2a13(%rip),%rdx        # 1d1ee0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.52.llvm.3671060894988460240+0x10f0>
   ff4cd:	mov    %r8,%rdi
   ff4d0:	mov    %rcx,%rsi
   ff4d3:	call   *0xd6b87(%rip)        # 1d6060 <_DYNAMIC+0x260>
   ff4d9:	lea    0xd2a18(%rip),%rdi        # 1d1ef8 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.52.llvm.3671060894988460240+0x1108>
   ff4e0:	call   *0xd6caa(%rip)        # 1d6190 <_DYNAMIC+0x390>
   ff4e6:	int3
   ff4e7:	int3
   ff4e8:	int3
   ff4e9:	int3
   ff4ea:	int3
   ff4eb:	int3
   ff4ec:	int3
   ff4ed:	int3
   ff4ee:	int3
   ff4ef:	int3

