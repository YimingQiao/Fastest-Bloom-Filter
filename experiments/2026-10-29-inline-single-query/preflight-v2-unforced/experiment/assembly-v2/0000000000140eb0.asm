0000000000140eb0 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<0, false>, unsigned long>(rocksdb_external::FastLocalBloom64<0, false> const&, unsigned long, unsigned long const*, unsigned int*)>:
  140eb0:	test   %rsi,%rsi
  140eb3:	je     140fa5 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<0, false>, unsigned long>(rocksdb_external::FastLocalBloom64<0, false> const&, unsigned long, unsigned long const*, unsigned int*)+0xf5>
  140eb9:	push   %rbx
  140eba:	xor    %eax,%eax
  140ebc:	vmovdqa -0x13c3e4(%rip),%ymm0        # 4ae0 <typeinfo name for main::$_60+0x310>
  140ec4:	vmovdqa -0x13c60c(%rip),%ymm1        # 48c0 <typeinfo name for main::$_60+0xf0>
  140ecc:	vmovdqa -0x13c554(%rip),%ymm2        # 4980 <typeinfo name for main::$_60+0x1b0>
  140ed4:	jmp    140ef0 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<0, false>, unsigned long>(rocksdb_external::FastLocalBloom64<0, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
  140ed6:	cs nopw 0x0(%rax,%rax,1)
  140ee0:	mov    %r10d,(%rcx,%rax,4)
  140ee4:	inc    %rax
  140ee7:	cmp    %rsi,%rax
  140eea:	je     140fa4 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<0, false>, unsigned long>(rocksdb_external::FastLocalBloom64<0, false> const&, unsigned long, unsigned long const*, unsigned int*)+0xf4>
  140ef0:	mov    (%rdx,%rax,8),%r8
  140ef4:	mov    %r8d,%r10d
  140ef7:	shr    $0x20,%r8
  140efb:	mov    0x18(%rdi),%r11d
  140eff:	mov    0x1c(%rdi),%r9d
  140f03:	mov    (%rdi),%rbx
  140f06:	shr    $0x6,%r11d
  140f0a:	imul   %r11,%r10
  140f0e:	shr    $0x1a,%r10
  140f12:	and    $0xffffffc0,%r10d
  140f16:	vmovdqu (%rbx,%r10,1),%ymm3
  140f1c:	vmovdqu 0x20(%rbx,%r10,1),%ymm4
  140f23:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  140f30:	vpbroadcastd %r8d,%ymm5
  140f36:	vpmulld %ymm0,%ymm5,%ymm6
  140f3b:	vpsrld $0x1c,%ymm6,%ymm7
  140f40:	vxorps %xmm8,%xmm8,%xmm8
  140f45:	vpermd %ymm3,%ymm7,%ymm8
  140f4a:	vpermd %ymm4,%ymm7,%ymm7
  140f4f:	vpsrad $0x1f,%ymm6,%ymm6
  140f54:	vpblendvb %ymm6,%ymm7,%ymm8,%ymm6
  140f5a:	vpbroadcastd %r9d,%ymm7
  140f60:	vpsubd %ymm7,%ymm1,%ymm7
  140f64:	vpsrld $0x1f,%ymm7,%ymm7
  140f69:	vpmulld %ymm2,%ymm5,%ymm5
  140f6e:	vpsrld $0x1b,%ymm5,%ymm5
  140f73:	vpsllvd %ymm5,%ymm7,%ymm5
  140f78:	xor    %r10d,%r10d
  140f7b:	vptest %ymm5,%ymm6
  140f80:	setb   %r10b
  140f84:	cmp    $0x9,%r9d
  140f88:	jl     140ee0 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<0, false>, unsigned long>(rocksdb_external::FastLocalBloom64<0, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
  140f8e:	test   %r10d,%r10d
  140f91:	je     140ee0 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<0, false>, unsigned long>(rocksdb_external::FastLocalBloom64<0, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
  140f97:	imul   $0xab25f4c1,%r8d,%r8d
  140f9e:	add    $0xfffffff8,%r9d
  140fa2:	jmp    140f30 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<0, false>, unsigned long>(rocksdb_external::FastLocalBloom64<0, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x80>
  140fa4:	pop    %rbx
  140fa5:	vzeroupper
  140fa8:	ret
  140fa9:	int3
  140faa:	int3
  140fab:	int3
  140fac:	int3
  140fad:	int3
  140fae:	int3
  140faf:	int3

