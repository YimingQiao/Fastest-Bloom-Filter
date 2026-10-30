0000000000141390 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<0, false>, unsigned long>(rocksdb_external::FastLocalBloom64<0, false> const&, unsigned long, unsigned long const*, unsigned int*)>:
  141390:	test   %rsi,%rsi
  141393:	je     1414a7 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<0, false>, unsigned long>(rocksdb_external::FastLocalBloom64<0, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x117>
  141399:	push   %r14
  14139b:	push   %rbx
  14139c:	movabs $0xd6e8feb86659fd93,%rax
  1413a6:	xor    %r8d,%r8d
  1413a9:	vmovdqa -0x13c8d1(%rip),%ymm0        # 4ae0 <typeinfo name for main::$_60+0x310>
  1413b1:	vmovdqa -0x13caf9(%rip),%ymm1        # 48c0 <typeinfo name for main::$_60+0xf0>
  1413b9:	vmovdqa -0x13ca41(%rip),%ymm2        # 4980 <typeinfo name for main::$_60+0x1b0>
  1413c1:	jmp    1413e0 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<0, false>, unsigned long>(rocksdb_external::FastLocalBloom64<0, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  1413c3:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  1413d0:	mov    %r11d,(%rcx,%r8,4)
  1413d4:	inc    %r8
  1413d7:	cmp    %rsi,%r8
  1413da:	je     1414a4 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<0, false>, unsigned long>(rocksdb_external::FastLocalBloom64<0, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x114>
  1413e0:	mov    (%rdx,%r8,8),%r9
  1413e4:	mov    %r9,%r10
  1413e7:	shr    $0x20,%r10
  1413eb:	xor    %r9,%r10
  1413ee:	imul   %rax,%r10
  1413f2:	mov    %r10,%r9
  1413f5:	shr    $0x20,%r9
  1413f9:	xor    %r10,%r9
  1413fc:	imul   %rax,%r9
  141400:	mov    %r9d,%r11d
  141403:	shr    $0x20,%r9
  141407:	mov    0x18(%rdi),%ebx
  14140a:	mov    0x1c(%rdi),%r10d
  14140e:	mov    (%rdi),%r14
  141411:	shr    $0x6,%ebx
  141414:	xor    %r9,%r11
  141417:	imul   %rbx,%r11
  14141b:	shr    $0x1a,%r11
  14141f:	and    $0xffffffc0,%r11d
  141423:	vmovdqu (%r14,%r11,1),%ymm3
  141429:	vmovdqu 0x20(%r14,%r11,1),%ymm4
  141430:	vpbroadcastd %r9d,%ymm5
  141436:	vpmulld %ymm0,%ymm5,%ymm6
  14143b:	vpsrld $0x1c,%ymm6,%ymm7
  141440:	vxorps %xmm8,%xmm8,%xmm8
  141445:	vpermd %ymm3,%ymm7,%ymm8
  14144a:	vpermd %ymm4,%ymm7,%ymm7
  14144f:	vpsrad $0x1f,%ymm6,%ymm6
  141454:	vpblendvb %ymm6,%ymm7,%ymm8,%ymm6
  14145a:	vpbroadcastd %r10d,%ymm7
  141460:	vpsubd %ymm7,%ymm1,%ymm7
  141464:	vpsrld $0x1f,%ymm7,%ymm7
  141469:	vpmulld %ymm2,%ymm5,%ymm5
  14146e:	vpsrld $0x1b,%ymm5,%ymm5
  141473:	vpsllvd %ymm5,%ymm7,%ymm5
  141478:	xor    %r11d,%r11d
  14147b:	vptest %ymm5,%ymm6
  141480:	setb   %r11b
  141484:	cmp    $0x9,%r10d
  141488:	jl     1413d0 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<0, false>, unsigned long>(rocksdb_external::FastLocalBloom64<0, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
  14148e:	test   %r11d,%r11d
  141491:	je     1413d0 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<0, false>, unsigned long>(rocksdb_external::FastLocalBloom64<0, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
  141497:	imul   $0xab25f4c1,%r9d,%r9d
  14149e:	add    $0xfffffff8,%r10d
  1414a2:	jmp    141430 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<0, false>, unsigned long>(rocksdb_external::FastLocalBloom64<0, false> const&, unsigned long, unsigned long const*, unsigned int*)+0xa0>
  1414a4:	pop    %rbx
  1414a5:	pop    %r14
  1414a7:	vzeroupper
  1414aa:	ret
  1414ab:	int3
  1414ac:	int3
  1414ad:	int3
  1414ae:	int3
  1414af:	int3

