0000000000141ab0 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<0, false>, unsigned long>(rocksdb_external::FastLocalBloom64<0, false> const&, unsigned long, unsigned long const*, unsigned int*)>:
  141ab0:	test   %rsi,%rsi
  141ab3:	je     141ba5 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<0, false>, unsigned long>(rocksdb_external::FastLocalBloom64<0, false> const&, unsigned long, unsigned long const*, unsigned int*)+0xf5>
  141ab9:	push   %rbx
  141aba:	xor    %eax,%eax
  141abc:	vmovdqa -0x13cfe4(%rip),%ymm0        # 4ae0 <typeinfo name for main::$_60+0x310>
  141ac4:	vmovdqa -0x13d20c(%rip),%ymm1        # 48c0 <typeinfo name for main::$_60+0xf0>
  141acc:	vmovdqa -0x13d154(%rip),%ymm2        # 4980 <typeinfo name for main::$_60+0x1b0>
  141ad4:	jmp    141af0 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<0, false>, unsigned long>(rocksdb_external::FastLocalBloom64<0, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
  141ad6:	cs nopw 0x0(%rax,%rax,1)
  141ae0:	mov    %r10d,(%rcx,%rax,4)
  141ae4:	inc    %rax
  141ae7:	cmp    %rsi,%rax
  141aea:	je     141ba4 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<0, false>, unsigned long>(rocksdb_external::FastLocalBloom64<0, false> const&, unsigned long, unsigned long const*, unsigned int*)+0xf4>
  141af0:	mov    (%rdx,%rax,8),%r8
  141af4:	mov    %r8d,%r10d
  141af7:	shr    $0x20,%r8
  141afb:	mov    0x18(%rdi),%r11d
  141aff:	mov    0x1c(%rdi),%r9d
  141b03:	mov    (%rdi),%rbx
  141b06:	shr    $0x6,%r11d
  141b0a:	imul   %r11,%r10
  141b0e:	shr    $0x1a,%r10
  141b12:	and    $0xffffffc0,%r10d
  141b16:	vmovdqu (%rbx,%r10,1),%ymm3
  141b1c:	vmovdqu 0x20(%rbx,%r10,1),%ymm4
  141b23:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  141b30:	vpbroadcastd %r8d,%ymm5
  141b36:	vpmulld %ymm0,%ymm5,%ymm6
  141b3b:	vpsrld $0x1c,%ymm6,%ymm7
  141b40:	vxorps %xmm8,%xmm8,%xmm8
  141b45:	vpermd %ymm3,%ymm7,%ymm8
  141b4a:	vpermd %ymm4,%ymm7,%ymm7
  141b4f:	vpsrad $0x1f,%ymm6,%ymm6
  141b54:	vpblendvb %ymm6,%ymm7,%ymm8,%ymm6
  141b5a:	vpbroadcastd %r9d,%ymm7
  141b60:	vpsubd %ymm7,%ymm1,%ymm7
  141b64:	vpsrld $0x1f,%ymm7,%ymm7
  141b69:	vpmulld %ymm2,%ymm5,%ymm5
  141b6e:	vpsrld $0x1b,%ymm5,%ymm5
  141b73:	vpsllvd %ymm5,%ymm7,%ymm5
  141b78:	xor    %r10d,%r10d
  141b7b:	vptest %ymm5,%ymm6
  141b80:	setb   %r10b
  141b84:	cmp    $0x9,%r9d
  141b88:	jl     141ae0 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<0, false>, unsigned long>(rocksdb_external::FastLocalBloom64<0, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
  141b8e:	test   %r10d,%r10d
  141b91:	je     141ae0 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<0, false>, unsigned long>(rocksdb_external::FastLocalBloom64<0, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
  141b97:	imul   $0xab25f4c1,%r8d,%r8d
  141b9e:	add    $0xfffffff8,%r9d
  141ba2:	jmp    141b30 <void inline_single_kernel<false, rocksdb_external::FastLocalBloom64<0, false>, unsigned long>(rocksdb_external::FastLocalBloom64<0, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x80>
  141ba4:	pop    %rbx
  141ba5:	vzeroupper
  141ba8:	ret
  141ba9:	int3
  141baa:	int3
  141bab:	int3
  141bac:	int3
  141bad:	int3
  141bae:	int3
  141baf:	int3

