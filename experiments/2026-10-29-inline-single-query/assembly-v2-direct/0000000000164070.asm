0000000000164070 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<9, true>, unsigned long>(rocksdb_external::FastLocalBloom64<9, true> const&, unsigned long, unsigned long const*, unsigned int*)>:
  164070:	test   %rsi,%rsi
  164073:	je     1641b0 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<9, true>, unsigned long>(rocksdb_external::FastLocalBloom64<9, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x140>
  164079:	push   %rbx
  16407a:	movabs $0xd6e8feb86659fd93,%rax
  164084:	xor    %r8d,%r8d
  164087:	vmovdqa -0x15f5af(%rip),%ymm0        # 4ae0 <typeinfo name for main::$_60+0x310>
  16408f:	vmovdqa -0x15f717(%rip),%ymm1        # 4980 <typeinfo name for main::$_60+0x1b0>
  164097:	vpbroadcastd -0x160df8(%rip),%ymm2        # 32a8 <__abi_tag+0x2fe4>
  1640a0:	vmovd  -0x160e00(%rip),%xmm3        # 32a8 <__abi_tag+0x2fe4>
  1640a8:	jmp    1640c0 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<9, true>, unsigned long>(rocksdb_external::FastLocalBloom64<9, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  1640aa:	nopw   0x0(%rax,%rax,1)
  1640b0:	mov    %r10d,(%rcx,%r8,4)
  1640b4:	inc    %r8
  1640b7:	cmp    %r8,%rsi
  1640ba:	je     1641af <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<9, true>, unsigned long>(rocksdb_external::FastLocalBloom64<9, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x13f>
  1640c0:	mov    (%rdx,%r8,8),%r9
  1640c4:	mov    %r9,%r10
  1640c7:	shr    $0x20,%r10
  1640cb:	xor    %r9,%r10
  1640ce:	imul   %rax,%r10
  1640d2:	mov    %r10,%r9
  1640d5:	shr    $0x20,%r9
  1640d9:	xor    %r10,%r9
  1640dc:	imul   %rax,%r9
  1640e0:	mov    %r9d,%r10d
  1640e3:	shr    $0x20,%r9
  1640e7:	mov    0x18(%rdi),%r11d
  1640eb:	mov    (%rdi),%rbx
  1640ee:	shr    $0x6,%r11d
  1640f2:	xor    %r9,%r10
  1640f5:	imul   %r11,%r10
  1640f9:	shr    $0x1a,%r10
  1640fd:	and    $0xffffffc0,%r10d
  164101:	prefetcht2 (%rbx,%r10,1)
  164106:	vmovdqu (%rbx,%r10,1),%ymm4
  16410c:	vmovdqu 0x20(%rbx,%r10,1),%ymm5
  164113:	vpbroadcastd %r9d,%ymm6
  164119:	vpmulld %ymm0,%ymm6,%ymm7
  16411e:	vpsrld $0x1c,%ymm7,%ymm8
  164123:	vxorps %xmm9,%xmm9,%xmm9
  164128:	vpermd %ymm4,%ymm8,%ymm9
  16412d:	vpermd %ymm5,%ymm8,%ymm8
  164132:	vpsrad $0x1f,%ymm7,%ymm7
  164137:	vpblendvb %ymm7,%ymm8,%ymm9,%ymm7
  16413d:	vpmulld %ymm1,%ymm6,%ymm6
  164142:	prefetcht2 0x3f(%rbx,%r10,1)
  164148:	vpsrld $0x1b,%ymm6,%ymm6
  16414d:	vpsllvd %ymm6,%ymm2,%ymm6
  164152:	vptest %ymm6,%ymm7
  164157:	mov    $0x0,%r10d
  16415d:	jae    1640b0 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<9, true>, unsigned long>(rocksdb_external::FastLocalBloom64<9, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
  164163:	imul   $0xab25f4c1,%r9d,%r9d
  16416a:	vpbroadcastd %r9d,%ymm6
  164170:	vpmulld %ymm0,%ymm6,%ymm7
  164175:	vpsrld $0x1c,%ymm7,%ymm8
  16417a:	vpermd %ymm4,%ymm8,%ymm4
  16417f:	vpermd %ymm5,%ymm8,%ymm5
  164184:	vpsrad $0x1f,%ymm7,%ymm7
  164189:	vpblendvb %ymm7,%ymm5,%ymm4,%ymm4
  16418f:	vpmulld %ymm1,%ymm6,%ymm5
  164194:	vpsrld $0x1b,%ymm5,%ymm5
  164199:	vpsllvd %ymm5,%ymm3,%ymm5
  16419e:	xor    %r10d,%r10d
  1641a1:	vptest %ymm5,%ymm4
  1641a6:	setb   %r10b
  1641aa:	jmp    1640b0 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<9, true>, unsigned long>(rocksdb_external::FastLocalBloom64<9, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
  1641af:	pop    %rbx
  1641b0:	vzeroupper
  1641b3:	ret
  1641b4:	int3
  1641b5:	int3
  1641b6:	int3
  1641b7:	int3
  1641b8:	int3
  1641b9:	int3
  1641ba:	int3
  1641bb:	int3
  1641bc:	int3
  1641bd:	int3
  1641be:	int3
  1641bf:	int3

