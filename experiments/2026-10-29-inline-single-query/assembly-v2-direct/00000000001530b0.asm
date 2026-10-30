00000000001530b0 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<9, false>, unsigned long>(rocksdb_external::FastLocalBloom64<9, false> const&, unsigned long, unsigned long const*, unsigned int*)>:
  1530b0:	test   %rsi,%rsi
  1530b3:	je     1531e5 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<9, false>, unsigned long>(rocksdb_external::FastLocalBloom64<9, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x135>
  1530b9:	push   %rbx
  1530ba:	movabs $0xd6e8feb86659fd93,%rax
  1530c4:	xor    %r8d,%r8d
  1530c7:	vmovdqa -0x14e5ef(%rip),%ymm0        # 4ae0 <typeinfo name for main::$_60+0x310>
  1530cf:	vmovdqa -0x14e757(%rip),%ymm1        # 4980 <typeinfo name for main::$_60+0x1b0>
  1530d7:	vpbroadcastd -0x14fe38(%rip),%ymm2        # 32a8 <__abi_tag+0x2fe4>
  1530e0:	vmovd  -0x14fe40(%rip),%xmm3        # 32a8 <__abi_tag+0x2fe4>
  1530e8:	jmp    153100 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<9, false>, unsigned long>(rocksdb_external::FastLocalBloom64<9, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  1530ea:	nopw   0x0(%rax,%rax,1)
  1530f0:	mov    %r10d,(%rcx,%r8,4)
  1530f4:	inc    %r8
  1530f7:	cmp    %r8,%rsi
  1530fa:	je     1531e4 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<9, false>, unsigned long>(rocksdb_external::FastLocalBloom64<9, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x134>
  153100:	mov    (%rdx,%r8,8),%r9
  153104:	mov    %r9,%r10
  153107:	shr    $0x20,%r10
  15310b:	xor    %r9,%r10
  15310e:	imul   %rax,%r10
  153112:	mov    %r10,%r9
  153115:	shr    $0x20,%r9
  153119:	xor    %r10,%r9
  15311c:	imul   %rax,%r9
  153120:	mov    %r9d,%r10d
  153123:	shr    $0x20,%r9
  153127:	mov    0x18(%rdi),%r11d
  15312b:	mov    (%rdi),%rbx
  15312e:	shr    $0x6,%r11d
  153132:	xor    %r9,%r10
  153135:	imul   %r11,%r10
  153139:	shr    $0x1a,%r10
  15313d:	and    $0xffffffc0,%r10d
  153141:	vmovdqu (%rbx,%r10,1),%ymm4
  153147:	vmovdqu 0x20(%rbx,%r10,1),%ymm5
  15314e:	vpbroadcastd %r9d,%ymm6
  153154:	vpmulld %ymm0,%ymm6,%ymm7
  153159:	vpsrld $0x1c,%ymm7,%ymm8
  15315e:	vxorps %xmm9,%xmm9,%xmm9
  153163:	vpermd %ymm4,%ymm8,%ymm9
  153168:	vpermd %ymm5,%ymm8,%ymm8
  15316d:	vpsrad $0x1f,%ymm7,%ymm7
  153172:	vpblendvb %ymm7,%ymm8,%ymm9,%ymm7
  153178:	vpmulld %ymm1,%ymm6,%ymm6
  15317d:	vpsrld $0x1b,%ymm6,%ymm6
  153182:	vpsllvd %ymm6,%ymm2,%ymm6
  153187:	vptest %ymm6,%ymm7
  15318c:	mov    $0x0,%r10d
  153192:	jae    1530f0 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<9, false>, unsigned long>(rocksdb_external::FastLocalBloom64<9, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
  153198:	imul   $0xab25f4c1,%r9d,%r9d
  15319f:	vpbroadcastd %r9d,%ymm6
  1531a5:	vpmulld %ymm0,%ymm6,%ymm7
  1531aa:	vpsrld $0x1c,%ymm7,%ymm8
  1531af:	vpermd %ymm4,%ymm8,%ymm4
  1531b4:	vpermd %ymm5,%ymm8,%ymm5
  1531b9:	vpsrad $0x1f,%ymm7,%ymm7
  1531be:	vpblendvb %ymm7,%ymm5,%ymm4,%ymm4
  1531c4:	vpmulld %ymm1,%ymm6,%ymm5
  1531c9:	vpsrld $0x1b,%ymm5,%ymm5
  1531ce:	vpsllvd %ymm5,%ymm3,%ymm5
  1531d3:	xor    %r10d,%r10d
  1531d6:	vptest %ymm5,%ymm4
  1531db:	setb   %r10b
  1531df:	jmp    1530f0 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<9, false>, unsigned long>(rocksdb_external::FastLocalBloom64<9, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
  1531e4:	pop    %rbx
  1531e5:	vzeroupper
  1531e8:	ret
  1531e9:	int3
  1531ea:	int3
  1531eb:	int3
  1531ec:	int3
  1531ed:	int3
  1531ee:	int3
  1531ef:	int3

