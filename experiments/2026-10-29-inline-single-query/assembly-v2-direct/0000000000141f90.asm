0000000000141f90 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<0, false>, unsigned long>(rocksdb_external::FastLocalBloom64<0, false> const&, unsigned long, unsigned long const*, unsigned int*)>:
  141f90:	test   %rsi,%rsi
  141f93:	je     1420a7 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<0, false>, unsigned long>(rocksdb_external::FastLocalBloom64<0, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x117>
  141f99:	push   %r14
  141f9b:	push   %rbx
  141f9c:	movabs $0xd6e8feb86659fd93,%rax
  141fa6:	xor    %r8d,%r8d
  141fa9:	vmovdqa -0x13d4d1(%rip),%ymm0        # 4ae0 <typeinfo name for main::$_60+0x310>
  141fb1:	vmovdqa -0x13d6f9(%rip),%ymm1        # 48c0 <typeinfo name for main::$_60+0xf0>
  141fb9:	vmovdqa -0x13d641(%rip),%ymm2        # 4980 <typeinfo name for main::$_60+0x1b0>
  141fc1:	jmp    141fe0 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<0, false>, unsigned long>(rocksdb_external::FastLocalBloom64<0, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  141fc3:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  141fd0:	mov    %r11d,(%rcx,%r8,4)
  141fd4:	inc    %r8
  141fd7:	cmp    %rsi,%r8
  141fda:	je     1420a4 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<0, false>, unsigned long>(rocksdb_external::FastLocalBloom64<0, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x114>
  141fe0:	mov    (%rdx,%r8,8),%r9
  141fe4:	mov    %r9,%r10
  141fe7:	shr    $0x20,%r10
  141feb:	xor    %r9,%r10
  141fee:	imul   %rax,%r10
  141ff2:	mov    %r10,%r9
  141ff5:	shr    $0x20,%r9
  141ff9:	xor    %r10,%r9
  141ffc:	imul   %rax,%r9
  142000:	mov    %r9d,%r11d
  142003:	shr    $0x20,%r9
  142007:	mov    0x18(%rdi),%ebx
  14200a:	mov    0x1c(%rdi),%r10d
  14200e:	mov    (%rdi),%r14
  142011:	shr    $0x6,%ebx
  142014:	xor    %r9,%r11
  142017:	imul   %rbx,%r11
  14201b:	shr    $0x1a,%r11
  14201f:	and    $0xffffffc0,%r11d
  142023:	vmovdqu (%r14,%r11,1),%ymm3
  142029:	vmovdqu 0x20(%r14,%r11,1),%ymm4
  142030:	vpbroadcastd %r9d,%ymm5
  142036:	vpmulld %ymm0,%ymm5,%ymm6
  14203b:	vpsrld $0x1c,%ymm6,%ymm7
  142040:	vxorps %xmm8,%xmm8,%xmm8
  142045:	vpermd %ymm3,%ymm7,%ymm8
  14204a:	vpermd %ymm4,%ymm7,%ymm7
  14204f:	vpsrad $0x1f,%ymm6,%ymm6
  142054:	vpblendvb %ymm6,%ymm7,%ymm8,%ymm6
  14205a:	vpbroadcastd %r10d,%ymm7
  142060:	vpsubd %ymm7,%ymm1,%ymm7
  142064:	vpsrld $0x1f,%ymm7,%ymm7
  142069:	vpmulld %ymm2,%ymm5,%ymm5
  14206e:	vpsrld $0x1b,%ymm5,%ymm5
  142073:	vpsllvd %ymm5,%ymm7,%ymm5
  142078:	xor    %r11d,%r11d
  14207b:	vptest %ymm5,%ymm6
  142080:	setb   %r11b
  142084:	cmp    $0x9,%r10d
  142088:	jl     141fd0 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<0, false>, unsigned long>(rocksdb_external::FastLocalBloom64<0, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
  14208e:	test   %r11d,%r11d
  142091:	je     141fd0 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<0, false>, unsigned long>(rocksdb_external::FastLocalBloom64<0, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
  142097:	imul   $0xab25f4c1,%r9d,%r9d
  14209e:	add    $0xfffffff8,%r10d
  1420a2:	jmp    142030 <void inline_single_kernel<true, rocksdb_external::FastLocalBloom64<0, false>, unsigned long>(rocksdb_external::FastLocalBloom64<0, false> const&, unsigned long, unsigned long const*, unsigned int*)+0xa0>
  1420a4:	pop    %rbx
  1420a5:	pop    %r14
  1420a7:	vzeroupper
  1420aa:	ret
  1420ab:	int3
  1420ac:	int3
  1420ad:	int3
  1420ae:	int3
  1420af:	int3

