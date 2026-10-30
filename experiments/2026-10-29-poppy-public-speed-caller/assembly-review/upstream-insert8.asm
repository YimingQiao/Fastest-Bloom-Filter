00000000000fefd0 <<poppy_filters::bloom::v2::BloomFilter>::insert_bytes::<[u8; 8]>>:
   fefd0:	push   %rbp
   fefd1:	push   %r15
   fefd3:	push   %r14
   fefd5:	push   %r13
   fefd7:	push   %r12
   fefd9:	push   %rbx
   fefda:	sub    $0x18,%rsp
   fefde:	movabs $0x8000000000000005,%r9
   fefe8:	mov    0x60(%rsi),%rcx
   fefec:	test   %rcx,%rcx
   fefef:	je     ff36a <<poppy_filters::bloom::v2::BloomFilter>::insert_bytes::<[u8; 8]>+0x39a>
   feff5:	mov    %rdx,%r11
   feff8:	mov    0x70(%rsi),%rbx
   feffc:	mov    %rdx,%rax
   fefff:	shl    $0xc,%rax
   ff003:	xor    %rdx,%rax
   ff006:	mov    %rax,%rdx
   ff009:	shr    $0x19,%rdx
   ff00d:	xor    %rax,%rdx
   ff010:	mov    %rdx,%rax
   ff013:	shl    $0x1b,%rax
   ff017:	xor    %rdx,%rax
   ff01a:	movabs $0x2545f4914f6cdd1d,%r15
   ff024:	imul   %rax,%r15
   ff028:	mov    0x28(%rsi),%r10
   ff02c:	popcnt %r10,%rax
   ff031:	cmp    $0x1,%eax
   ff034:	jne    ff046 <<poppy_filters::bloom::v2::BloomFilter>::insert_bytes::<[u8; 8]>+0x76>
   ff036:	dec    %r10
   ff039:	and    %r15,%r10
   ff03c:	test   %rbx,%rbx
   ff03f:	jne    ff063 <<poppy_filters::bloom::v2::BloomFilter>::insert_bytes::<[u8; 8]>+0x93>
   ff041:	jmp    ff32f <<poppy_filters::bloom::v2::BloomFilter>::insert_bytes::<[u8; 8]>+0x35f>
   ff046:	test   %r10,%r10
   ff049:	je     ff38f <<poppy_filters::bloom::v2::BloomFilter>::insert_bytes::<[u8; 8]>+0x3bf>
   ff04f:	mov    %r15,%rax
   ff052:	xor    %edx,%edx
   ff054:	div    %r10
   ff057:	mov    %rdx,%r10
   ff05a:	test   %rbx,%rbx
   ff05d:	je     ff32f <<poppy_filters::bloom::v2::BloomFilter>::insert_bytes::<[u8; 8]>+0x35f>
   ff063:	shl    $0xc,%r10
   ff067:	add    0x20(%rsi),%r10
   ff06b:	mov    0x78(%rsi),%r13
   ff06f:	cmp    %rcx,%r13
   ff072:	jne    ff134 <<poppy_filters::bloom::v2::BloomFilter>::insert_bytes::<[u8; 8]>+0x164>
   ff078:	mov    %r15,(%rsp)
   ff07c:	mov    %rdi,%r8
   ff07f:	movabs $0xe7037ed1a0b428db,%rax
   ff089:	xor    %r14d,%r14d
   ff08c:	movabs $0xd0196d1401ee596d,%r15
   ff096:	movabs $0xeb44accab455d16d,%r12
   ff0a0:	xor    %edx,%edx
   ff0a2:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   ff0b0:	test   %r14,%r14
   ff0b3:	je     ff0e0 <<poppy_filters::bloom::v2::BloomFilter>::insert_bytes::<[u8; 8]>+0x110>
   ff0b5:	cmp    $0x1,%r14
   ff0b9:	jne    ff0da <<poppy_filters::bloom::v2::BloomFilter>::insert_bytes::<[u8; 8]>+0x10a>
   ff0bb:	mov    %r11,%rcx
   ff0be:	bswap  %rcx
   ff0c1:	rorx   $0x20,%rcx,%rdx
   ff0c7:	xor    %rax,%rdx
   ff0ca:	mulx   %r15,%rcx,%rdx
   ff0cf:	xor    %rcx,%rdx
   ff0d2:	mulx   %r12,%rcx,%rdx
   ff0d7:	xor    %rcx,%rdx
   ff0da:	add    %rdx,%r11
   ff0dd:	add    %r14,%rdx
   ff0e0:	mov    %r11d,%edi
   ff0e3:	shr    $0x3,%edi
   ff0e6:	and    $0xfff,%edi
   ff0ec:	mov    %r11d,%ecx
   ff0ef:	and    $0x7,%cl
   ff0f2:	mov    $0x1,%bpl
   ff0f5:	shl    %cl,%bpl
   ff0f8:	movzbl (%r10,%rdi,1),%ecx
   ff0fd:	mov    %r11d,%r13d
   ff100:	and    $0x7,%r13d
   ff104:	bt     %r13d,%ecx
   ff108:	jae    ff170 <<poppy_filters::bloom::v2::BloomFilter>::insert_bytes::<[u8; 8]>+0x1a0>
   ff10a:	inc    %r14
   ff10d:	or     %cl,%bpl
   ff110:	mov    %bpl,(%r10,%rdi,1)
   ff114:	cmp    %r14,%rbx
   ff117:	jne    ff0b0 <<poppy_filters::bloom::v2::BloomFilter>::insert_bytes::<[u8; 8]>+0xe0>
   ff119:	xor    %edx,%edx
   ff11b:	mov    %r8,%rdi
   ff11e:	mov    (%rsp),%r15
   ff122:	mov    0x10(%rsi),%rcx
   ff126:	test   %rcx,%rcx
   ff129:	jne    ff33a <<poppy_filters::bloom::v2::BloomFilter>::insert_bytes::<[u8; 8]>+0x36a>
   ff12f:	jmp    ff363 <<poppy_filters::bloom::v2::BloomFilter>::insert_bytes::<[u8; 8]>+0x393>
   ff134:	cmp    $0x1,%rbx
   ff138:	jne    ff178 <<poppy_filters::bloom::v2::BloomFilter>::insert_bytes::<[u8; 8]>+0x1a8>
   ff13a:	xor    %r14d,%r14d
   ff13d:	xor    %r12d,%r12d
   ff140:	xor    %eax,%eax
   ff142:	test   $0x1,%bl
   ff145:	jne    ff2a8 <<poppy_filters::bloom::v2::BloomFilter>::insert_bytes::<[u8; 8]>+0x2d8>
   ff14b:	test   $0x1,%r14b
   ff14f:	je     ff32f <<poppy_filters::bloom::v2::BloomFilter>::insert_bytes::<[u8; 8]>+0x35f>
   ff155:	inc    %r13
   ff158:	mov    %r13,0x78(%rsi)
   ff15c:	mov    $0x1,%dl
   ff15e:	mov    0x10(%rsi),%rcx
   ff162:	test   %rcx,%rcx
   ff165:	jne    ff33a <<poppy_filters::bloom::v2::BloomFilter>::insert_bytes::<[u8; 8]>+0x36a>
   ff16b:	jmp    ff363 <<poppy_filters::bloom::v2::BloomFilter>::insert_bytes::<[u8; 8]>+0x393>
   ff170:	mov    %r8,%rdi
   ff173:	jmp    ff36a <<poppy_filters::bloom::v2::BloomFilter>::insert_bytes::<[u8; 8]>+0x39a>
   ff178:	mov    %r13,0x8(%rsp)
   ff17d:	mov    %r15,(%rsp)
   ff181:	mov    %rdi,0x10(%rsp)
   ff186:	mov    %rbx,%r13
   ff189:	and    $0xfffffffffffffffe,%r13
   ff18d:	xor    %r14d,%r14d
   ff190:	xor    %r15d,%r15d
   ff193:	xor    %edx,%edx
   ff195:	jmp    ff22d <<poppy_filters::bloom::v2::BloomFilter>::insert_bytes::<[u8; 8]>+0x25d>
   ff19a:	nopw   0x0(%rax,%rax,1)
   ff1a0:	mov    %r11,%rdx
   ff1a3:	bswap  %rdx
   ff1a6:	rorx   $0x20,%rdx,%rdx
   ff1ac:	movabs $0xe7037ed1a0b428db,%rax
   ff1b6:	xor    %rax,%rdx
   ff1b9:	movabs $0xd0196d1401ee596d,%rax
   ff1c3:	mulx   %rax,%rdi,%rdx
   ff1c8:	xor    %rdi,%rdx
   ff1cb:	movabs $0xeb44accab455d16d,%rax
   ff1d5:	mulx   %rax,%rdx,%rdi
   ff1da:	xor    %rdx,%rdi
   ff1dd:	test   %cl,%bpl
   ff1e0:	sete   %bpl
   ff1e4:	add    %rdi,%r11
   ff1e7:	lea    0x1(%rdi,%r12,1),%rdx
   ff1ec:	mov    %r11d,%r9d
   ff1ef:	shr    $0x3,%r9d
   ff1f3:	mov    %r11d,%ecx
   ff1f6:	and    $0x7,%cl
   ff1f9:	mov    $0x1,%al
   ff1fb:	shl    %cl,%al
   ff1fd:	and    $0xfff,%r9d
   ff204:	movzbl (%r10,%r9,1),%ecx
   ff209:	mov    %ecx,%r8d
   ff20c:	or     %al,%r8b
   ff20f:	mov    %r8b,(%r10,%r9,1)
   ff213:	mov    %r11d,%eax
   ff216:	and    $0x7,%eax
   ff219:	bt     %eax,%ecx
   ff21c:	setae  %al
   ff21f:	or     %al,%r14b
   ff222:	or     %bpl,%r14b
   ff225:	inc    %r15
   ff228:	cmp    %r13,%r15
   ff22b:	je     ff27e <<poppy_filters::bloom::v2::BloomFilter>::insert_bytes::<[u8; 8]>+0x2ae>
   ff22d:	mov    %r11,%rcx
   ff230:	mov    %r15,%r12
   ff233:	add    %rdx,%r11
   ff236:	test   %r15,%r15
   ff239:	cmove  %rcx,%r11
   ff23d:	mov    %r11d,%edi
   ff240:	shr    $0x3,%edi
   ff243:	and    $0xfff,%edi
   ff249:	mov    %r11d,%ecx
   ff24c:	and    $0x7,%cl
   ff24f:	mov    $0x1,%bpl
   ff252:	shl    %cl,%bpl
   ff255:	movzbl (%r10,%rdi,1),%ecx
   ff25a:	mov    %ebp,%r15d
   ff25d:	or     %cl,%r15b
   ff260:	mov    %r15b,(%r10,%rdi,1)
   ff264:	lea    0x1(%r12),%r15
   ff269:	cmp    $0x1,%r15
   ff26d:	je     ff1a0 <<poppy_filters::bloom::v2::BloomFilter>::insert_bytes::<[u8; 8]>+0x1d0>
   ff273:	add    %r12,%rdx
   ff276:	mov    %rdx,%rdi
   ff279:	jmp    ff1dd <<poppy_filters::bloom::v2::BloomFilter>::insert_bytes::<[u8; 8]>+0x20d>
   ff27e:	add    $0x2,%r12
   ff282:	lea    -0x1(%rdi,%r12,1),%rax
   ff287:	mov    0x10(%rsp),%rdi
   ff28c:	movabs $0x8000000000000005,%r9
   ff296:	mov    (%rsp),%r15
   ff29a:	mov    0x8(%rsp),%r13
   ff29f:	test   $0x1,%bl
   ff2a2:	je     ff14b <<poppy_filters::bloom::v2::BloomFilter>::insert_bytes::<[u8; 8]>+0x17b>
   ff2a8:	test   %r12,%r12
   ff2ab:	je     ff2f3 <<poppy_filters::bloom::v2::BloomFilter>::insert_bytes::<[u8; 8]>+0x323>
   ff2ad:	cmp    $0x1,%r12
   ff2b1:	jne    ff2f0 <<poppy_filters::bloom::v2::BloomFilter>::insert_bytes::<[u8; 8]>+0x320>
   ff2b3:	mov    %r11,%rax
   ff2b6:	bswap  %rax
   ff2b9:	rorx   $0x20,%rax,%rax
   ff2bf:	movabs $0xe7037ed1a0b428db,%rdx
   ff2c9:	xor    %rax,%rdx
   ff2cc:	movabs $0xd0196d1401ee596d,%rax
   ff2d6:	mulx   %rax,%rax,%rdx
   ff2db:	xor    %rax,%rdx
   ff2de:	movabs $0xeb44accab455d16d,%rax
   ff2e8:	mulx   %rax,%rcx,%rax
   ff2ed:	xor    %rcx,%rax
   ff2f0:	add    %rax,%r11
   ff2f3:	mov    %r11d,%eax
   ff2f6:	shr    $0x3,%eax
   ff2f9:	and    $0xfff,%eax
   ff2fe:	mov    %r11d,%ecx
   ff301:	and    $0x7,%cl
   ff304:	mov    $0x1,%dl
   ff306:	shl    %cl,%dl
   ff308:	movzbl (%r10,%rax,1),%ecx
   ff30d:	mov    %ecx,%r8d
   ff310:	or     %dl,%r8b
   ff313:	mov    %r8b,(%r10,%rax,1)
   ff317:	and    $0x7,%r11d
   ff31b:	bt     %r11d,%ecx
   ff31f:	setae  %al
   ff322:	or     %al,%r14b
   ff325:	test   $0x1,%r14b
   ff329:	jne    ff155 <<poppy_filters::bloom::v2::BloomFilter>::insert_bytes::<[u8; 8]>+0x185>
   ff32f:	xor    %edx,%edx
   ff331:	mov    0x10(%rsi),%rcx
   ff335:	test   %rcx,%rcx
   ff338:	je     ff363 <<poppy_filters::bloom::v2::BloomFilter>::insert_bytes::<[u8; 8]>+0x393>
   ff33a:	lea    -0x1(,%rcx,8),%rax
   ff342:	and    %r15,%rax
   ff345:	shr    $0x3,%rax
   ff349:	cmp    %rcx,%rax
   ff34c:	jae    ff37c <<poppy_filters::bloom::v2::BloomFilter>::insert_bytes::<[u8; 8]>+0x3ac>
   ff34e:	and    $0x7,%r15b
   ff352:	mov    $0x1,%r8b
   ff355:	mov    %r15d,%ecx
   ff358:	shl    %cl,%r8b
   ff35b:	mov    0x8(%rsi),%rcx
   ff35f:	or     %r8b,(%rcx,%rax,1)
   ff363:	mov    %dl,0x8(%rdi)
   ff366:	add    $0x2,%r9
   ff36a:	mov    %r9,(%rdi)
   ff36d:	add    $0x18,%rsp
   ff371:	pop    %rbx
   ff372:	pop    %r12
   ff374:	pop    %r13
   ff376:	pop    %r14
   ff378:	pop    %r15
   ff37a:	pop    %rbp
   ff37b:	ret
   ff37c:	lea    0xd2ab5(%rip),%rdx        # 1d1e38 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.52.llvm.3671060894988460240+0x1048>
   ff383:	mov    %rax,%rdi
   ff386:	mov    %rcx,%rsi
   ff389:	call   *0xd6cd1(%rip)        # 1d6060 <_DYNAMIC+0x260>
   ff38f:	lea    0xd2b32(%rip),%rdi        # 1d1ec8 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.52.llvm.3671060894988460240+0x10d8>
   ff396:	call   *0xd6df4(%rip)        # 1d6190 <_DYNAMIC+0x390>
   ff39c:	int3
   ff39d:	int3
   ff39e:	int3
   ff39f:	int3

