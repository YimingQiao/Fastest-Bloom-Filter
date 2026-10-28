000000000010ce00 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 6ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 6ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
  10ce00:	test   %rsi,%rsi
  10ce03:	je     10cef5 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 6ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 6ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0xf5>
  10ce09:	push   %r15
  10ce0b:	push   %r14
  10ce0d:	push   %rbx
  10ce0e:	mov    %rdx,%rax
  10ce11:	movabs $0xd6e8feb86659fd93,%r8
  10ce1b:	xor    %r9d,%r9d
  10ce1e:	movabs $0xf1357aea2e62a9c5,%r10
  10ce28:	vmovdqa -0x108610(%rip),%ymm0        # 4820 <typeinfo name for main::$_60+0x50>
  10ce30:	vpbroadcastq -0x109a99(%rip),%ymm1        # 33a0 <_IO_stdin_used+0xec>
  10ce39:	vpbroadcastq -0x109aea(%rip),%ymm2        # 3358 <_IO_stdin_used+0xa4>
  10ce42:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  10ce50:	mov    (%rax,%r9,8),%rdx
  10ce54:	mov    %rdx,%r11
  10ce57:	shr    $0x20,%r11
  10ce5b:	xor    %rdx,%r11
  10ce5e:	imul   %r8,%r11
  10ce62:	mov    %r11,%rbx
  10ce65:	shr    $0x20,%rbx
  10ce69:	xor    %r11,%rbx
  10ce6c:	imul   %r8,%rbx
  10ce70:	mov    %rbx,%rdx
  10ce73:	shr    $0x20,%rdx
  10ce77:	xor    %rbx,%rdx
  10ce7a:	or     $0x1,%rdx
  10ce7e:	mov    0x20(%rdi),%r11
  10ce82:	mulx   0x10(%rdi),%rbx,%rbx
  10ce88:	imul   %r10,%rdx
  10ce8c:	prefetcht0 (%r11,%rbx,8)
  10ce91:	vpbroadcastq %rdx,%ymm3
  10ce97:	vpsrlvq %ymm0,%ymm3,%ymm3
  10ce9c:	vpand  %ymm1,%ymm3,%ymm3
  10cea0:	vpsllvq %ymm3,%ymm2,%ymm3
  10cea5:	mov    %rdx,%r14
  10cea8:	shr    $0x1e,%r14
  10ceac:	shr    $0x24,%rdx
  10ceb0:	vextracti128 $0x1,%ymm3,%xmm4
  10ceb6:	vpor   %xmm4,%xmm3,%xmm3
  10ceba:	vpshufd $0xee,%xmm3,%xmm4
  10cebf:	vpor   %xmm4,%xmm3,%xmm3
  10cec3:	vmovq  %xmm3,%r15
  10cec8:	bts    %r14,%r15
  10cecc:	bts    %rdx,%r15
  10ced0:	mov    (%r11,%rbx,8),%rdx
  10ced4:	xor    %r11d,%r11d
  10ced7:	andn   %r15,%rdx,%rdx
  10cedc:	sete   %r11b
  10cee0:	mov    %r11d,(%rcx,%r9,4)
  10cee4:	inc    %r9
  10cee7:	cmp    %r9,%rsi
  10ceea:	jne    10ce50 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 6ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::block<unsigned long, 6ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  10cef0:	pop    %rbx
  10cef1:	pop    %r14
  10cef3:	pop    %r15
  10cef5:	vzeroupper
  10cef8:	ret
  10cef9:	int3
  10cefa:	int3
  10cefb:	int3
  10cefc:	int3
  10cefd:	int3
  10cefe:	int3
  10ceff:	int3

