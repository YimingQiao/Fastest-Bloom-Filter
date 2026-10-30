000000000015de30 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<8, true>, unsigned long>(rocksdb_external::FastLocalBloom64<8, true> const&, unsigned long, unsigned long const*, unsigned int*)>:
  15de30:	test   %rsi,%rsi
  15de33:	je     15dffc <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<8, true>, unsigned long>(rocksdb_external::FastLocalBloom64<8, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x1cc>
  15de39:	push   %rbx
  15de3a:	cmp    $0x1,%rsi
  15de3e:	jne    15de47 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<8, true>, unsigned long>(rocksdb_external::FastLocalBloom64<8, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x17>
  15de40:	xor    %eax,%eax
  15de42:	jmp    15df77 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<8, true>, unsigned long>(rocksdb_external::FastLocalBloom64<8, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x147>
  15de47:	mov    %rsi,%r8
  15de4a:	and    $0xfffffffffffffffe,%r8
  15de4e:	xor    %eax,%eax
  15de50:	vmovdqa -0x159378(%rip),%ymm0        # 4ae0 <typeinfo name for main::$_60+0x310>
  15de58:	vmovdqa -0x1594e0(%rip),%ymm1        # 4980 <typeinfo name for main::$_60+0x1b0>
  15de60:	vpbroadcastd -0x15abc1(%rip),%ymm2        # 32a8 <__abi_tag+0x2fe4>
  15de69:	nopl   0x0(%rax)
  15de70:	mov    (%rdx,%rax,8),%r9
  15de74:	mov    0x18(%rdi),%r10d
  15de78:	mov    (%rdi),%r11
  15de7b:	shr    $0x6,%r10d
  15de7f:	mov    %r9d,%ebx
  15de82:	imul   %r10,%rbx
  15de86:	shr    $0x1a,%rbx
  15de8a:	and    $0xffffffc0,%ebx
  15de8d:	shr    $0x20,%r9
  15de91:	prefetcht2 (%r11,%rbx,1)
  15de96:	vpbroadcastd %r9d,%ymm3
  15de9c:	vpmulld %ymm0,%ymm3,%ymm4
  15dea1:	vpsrld $0x1c,%ymm4,%ymm5
  15dea6:	vxorps %xmm6,%xmm6,%xmm6
  15deaa:	vpermd (%r11,%rbx,1),%ymm5,%ymm6
  15deb0:	vpermd 0x20(%r11,%rbx,1),%ymm5,%ymm5
  15deb7:	vpsrad $0x1f,%ymm4,%ymm4
  15debc:	vpblendvb %ymm4,%ymm5,%ymm6,%ymm4
  15dec2:	prefetcht2 0x3f(%r11,%rbx,1)
  15dec8:	vpmulld %ymm1,%ymm3,%ymm3
  15decd:	vpsrld $0x1b,%ymm3,%ymm3
  15ded2:	vpsllvd %ymm3,%ymm2,%ymm3
  15ded7:	xor    %r9d,%r9d
  15deda:	vptest %ymm3,%ymm4
  15dedf:	setb   %r9b
  15dee3:	mov    %r9d,(%rcx,%rax,4)
  15dee7:	mov    0x8(%rdx,%rax,8),%r9
  15deec:	mov    0x18(%rdi),%r10d
  15def0:	mov    (%rdi),%r11
  15def3:	shr    $0x6,%r10d
  15def7:	mov    %r9d,%ebx
  15defa:	imul   %r10,%rbx
  15defe:	shr    $0x1a,%rbx
  15df02:	and    $0xffffffc0,%ebx
  15df05:	shr    $0x20,%r9
  15df09:	vpbroadcastd %r9d,%ymm3
  15df0f:	vpmulld %ymm0,%ymm3,%ymm4
  15df14:	prefetcht2 (%r11,%rbx,1)
  15df19:	vpsrld $0x1c,%ymm4,%ymm5
  15df1e:	vxorps %xmm6,%xmm6,%xmm6
  15df22:	vpermd (%r11,%rbx,1),%ymm5,%ymm6
  15df28:	vpermd 0x20(%r11,%rbx,1),%ymm5,%ymm5
  15df2f:	vpsrad $0x1f,%ymm4,%ymm4
  15df34:	vpblendvb %ymm4,%ymm5,%ymm6,%ymm4
  15df3a:	vpmulld %ymm1,%ymm3,%ymm3
  15df3f:	prefetcht2 0x3f(%r11,%rbx,1)
  15df45:	vpsrld $0x1b,%ymm3,%ymm3
  15df4a:	vpsllvd %ymm3,%ymm2,%ymm3
  15df4f:	xor    %r9d,%r9d
  15df52:	vptest %ymm3,%ymm4
  15df57:	setb   %r9b
  15df5b:	mov    %r9d,0x4(%rcx,%rax,4)
  15df60:	add    $0x2,%rax
  15df64:	cmp    %rax,%r8
  15df67:	jne    15de70 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<8, true>, unsigned long>(rocksdb_external::FastLocalBloom64<8, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
  15df6d:	test   $0x1,%sil
  15df71:	je     15dffb <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<8, true>, unsigned long>(rocksdb_external::FastLocalBloom64<8, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x1cb>
  15df77:	mov    (%rdx,%rax,8),%rdx
  15df7b:	mov    0x18(%rdi),%esi
  15df7e:	mov    (%rdi),%rdi
  15df81:	shr    $0x6,%esi
  15df84:	mov    %edx,%r8d
  15df87:	imul   %rsi,%r8
  15df8b:	shr    $0x1a,%r8
  15df8f:	and    $0xffffffc0,%r8d
  15df93:	shr    $0x20,%rdx
  15df97:	vpbroadcastd %edx,%ymm0
  15df9d:	vpmulld -0x1594c6(%rip),%ymm0,%ymm1        # 4ae0 <typeinfo name for main::$_60+0x310>
  15dfa6:	vpsrld $0x1c,%ymm1,%ymm2
  15dfab:	vxorps %xmm3,%xmm3,%xmm3
  15dfaf:	vpermd (%rdi,%r8,1),%ymm2,%ymm3
  15dfb5:	vpermd 0x20(%rdi,%r8,1),%ymm2,%ymm2
  15dfbc:	vpsrad $0x1f,%ymm1,%ymm1
  15dfc1:	vpblendvb %ymm1,%ymm2,%ymm3,%ymm1
  15dfc7:	vpmulld -0x159650(%rip),%ymm0,%ymm0        # 4980 <typeinfo name for main::$_60+0x1b0>
  15dfd0:	prefetcht2 (%rdi,%r8,1)
  15dfd5:	prefetcht2 0x3f(%rdi,%r8,1)
  15dfdb:	vpsrld $0x1b,%ymm0,%ymm0
  15dfe0:	vpbroadcastd -0x15ad41(%rip),%ymm2        # 32a8 <__abi_tag+0x2fe4>
  15dfe9:	vpsllvd %ymm0,%ymm2,%ymm0
  15dfee:	xor    %edx,%edx
  15dff0:	vptest %ymm0,%ymm1
  15dff5:	setb   %dl
  15dff8:	mov    %edx,(%rcx,%rax,4)
  15dffb:	pop    %rbx
  15dffc:	vzeroupper
  15dfff:	ret

