000000000010ce80 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 6ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 6ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
  10ce80:	test   %rsi,%rsi
  10ce83:	je     10cf75 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 6ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 6ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0xf5>
  10ce89:	push   %r15
  10ce8b:	push   %r14
  10ce8d:	push   %rbx
  10ce8e:	mov    %rdx,%rax
  10ce91:	movabs $0xd6e8feb86659fd93,%r8
  10ce9b:	xor    %r9d,%r9d
  10ce9e:	movabs $0xf1357aea2e62a9c5,%r10
  10cea8:	vmovdqa -0x108690(%rip),%ymm0        # 4820 <typeinfo name for main::$_60+0x50>
  10ceb0:	vpbroadcastq -0x109b19(%rip),%ymm1        # 33a0 <_IO_stdin_used+0xec>
  10ceb9:	vpbroadcastq -0x109b6a(%rip),%ymm2        # 3358 <_IO_stdin_used+0xa4>
  10cec2:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  10ced0:	mov    (%rax,%r9,8),%rdx
  10ced4:	mov    %rdx,%r11
  10ced7:	shr    $0x20,%r11
  10cedb:	xor    %rdx,%r11
  10cede:	imul   %r8,%r11
  10cee2:	mov    %r11,%rbx
  10cee5:	shr    $0x20,%rbx
  10cee9:	xor    %r11,%rbx
  10ceec:	imul   %r8,%rbx
  10cef0:	mov    %rbx,%rdx
  10cef3:	shr    $0x20,%rdx
  10cef7:	xor    %rbx,%rdx
  10cefa:	or     $0x1,%rdx
  10cefe:	mov    0x20(%rdi),%r11
  10cf02:	mulx   0x10(%rdi),%rbx,%rbx
  10cf08:	prefetcht0 (%r11,%rbx,8)
  10cf0d:	imul   %r10,%rdx
  10cf11:	vpbroadcastq %rdx,%ymm3
  10cf17:	vpsrlvq %ymm0,%ymm3,%ymm3
  10cf1c:	vpand  %ymm1,%ymm3,%ymm3
  10cf20:	vpsllvq %ymm3,%ymm2,%ymm3
  10cf25:	mov    %rdx,%r14
  10cf28:	shr    $0x1e,%r14
  10cf2c:	shr    $0x24,%rdx
  10cf30:	vextracti128 $0x1,%ymm3,%xmm4
  10cf36:	vpor   %xmm4,%xmm3,%xmm3
  10cf3a:	vpshufd $0xee,%xmm3,%xmm4
  10cf3f:	vpor   %xmm4,%xmm3,%xmm3
  10cf43:	vmovq  %xmm3,%r15
  10cf48:	bts    %r14,%r15
  10cf4c:	bts    %rdx,%r15
  10cf50:	mov    (%r11,%rbx,8),%rdx
  10cf54:	xor    %r11d,%r11d
  10cf57:	andn   %r15,%rdx,%rdx
  10cf5c:	sete   %r11b
  10cf60:	mov    %r11d,(%rcx,%r9,4)
  10cf64:	inc    %r9
  10cf67:	cmp    %r9,%rsi
  10cf6a:	jne    10ced0 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 6ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 6ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  10cf70:	pop    %rbx
  10cf71:	pop    %r14
  10cf73:	pop    %r15
  10cf75:	vzeroupper
  10cf78:	ret
  10cf79:	int3
  10cf7a:	int3
  10cf7b:	int3
  10cf7c:	int3
  10cf7d:	int3
  10cf7e:	int3
  10cf7f:	int3

