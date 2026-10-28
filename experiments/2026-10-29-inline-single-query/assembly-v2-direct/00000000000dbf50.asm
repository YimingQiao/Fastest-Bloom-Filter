00000000000dbf50 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<7ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<7ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
   dbf50:	test   %rsi,%rsi
   dbf53:	je     dc0c0 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<7ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<7ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x170>
   dbf59:	push   %r14
   dbf5b:	push   %rbx
   dbf5c:	mov    %rdx,%rax
   dbf5f:	movabs $0xf1357aea2e62a9c5,%r9
   dbf69:	cmp    $0x1,%rsi
   dbf6d:	jne    dbf77 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<7ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<7ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x27>
   dbf6f:	xor    %r8d,%r8d
   dbf72:	jmp    dc05f <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<7ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<7ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x10f>
   dbf77:	mov    %rsi,%r10
   dbf7a:	and    $0xfffffffffffffffe,%r10
   dbf7e:	xor    %r8d,%r8d
   dbf81:	vmovdqa -0xd7449(%rip),%ymm0        # 4b40 <typeinfo name for main::$_60+0x370>
   dbf89:	vmovdqa -0xd7431(%rip),%ymm1        # 4b60 <typeinfo name for main::$_60+0x390>
   dbf91:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   dbfa0:	mov    (%rax,%r8,8),%rdx
   dbfa4:	or     $0x1,%rdx
   dbfa8:	mov    0x20(%rdi),%r11
   dbfac:	mulx   0x10(%rdi),%rbx,%rbx
   dbfb2:	lea    (%rbx,%rbx,8),%r14
   dbfb6:	lea    (%r14,%r14,2),%r14
   dbfba:	add    %rbx,%r14
   dbfbd:	prefetcht0 (%r11,%r14,1)
   dbfc2:	imul   %r9,%rdx
   dbfc6:	vmovdqu (%r11,%r14,1),%ymm2
   dbfcc:	vpbroadcastq %rdx,%ymm3
   dbfd2:	vpsllvq %ymm0,%ymm3,%ymm3
   dbfd7:	vpsrld $0x1b,%ymm3,%ymm3
   dbfdc:	vpsllvd %ymm3,%ymm1,%ymm3
   dbfe1:	xor    %edx,%edx
   dbfe3:	vptest %ymm3,%ymm2
   dbfe8:	prefetcht0 0x40(%r11,%r14,1)
   dbfee:	setb   %dl
   dbff1:	mov    %edx,(%rcx,%r8,4)
   dbff5:	mov    0x8(%rax,%r8,8),%rdx
   dbffa:	or     $0x1,%rdx
   dbffe:	mov    0x20(%rdi),%r11
   dc002:	mulx   0x10(%rdi),%rbx,%rbx
   dc008:	lea    (%rbx,%rbx,8),%r14
   dc00c:	lea    (%r14,%r14,2),%r14
   dc010:	add    %rbx,%r14
   dc013:	prefetcht0 (%r11,%r14,1)
   dc018:	prefetcht0 0x40(%r11,%r14,1)
   dc01e:	imul   %r9,%rdx
   dc022:	vmovdqu (%r11,%r14,1),%ymm2
   dc028:	vpbroadcastq %rdx,%ymm3
   dc02e:	vpsllvq %ymm0,%ymm3,%ymm3
   dc033:	vpsrld $0x1b,%ymm3,%ymm3
   dc038:	vpsllvd %ymm3,%ymm1,%ymm3
   dc03d:	xor    %edx,%edx
   dc03f:	vptest %ymm3,%ymm2
   dc044:	setb   %dl
   dc047:	mov    %edx,0x4(%rcx,%r8,4)
   dc04c:	add    $0x2,%r8
   dc050:	cmp    %r8,%r10
   dc053:	jne    dbfa0 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<7ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<7ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
   dc059:	test   $0x1,%sil
   dc05d:	je     dc0bd <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<7ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<7ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x16d>
   dc05f:	mov    (%rax,%r8,8),%rdx
   dc063:	or     $0x1,%rdx
   dc067:	mov    0x20(%rdi),%rax
   dc06b:	mulx   0x10(%rdi),%rsi,%rsi
   dc071:	lea    (%rsi,%rsi,8),%rdi
   dc075:	lea    (%rdi,%rdi,2),%rdi
   dc079:	add    %rsi,%rdi
   dc07c:	prefetcht0 (%rax,%rdi,1)
   dc080:	prefetcht0 0x40(%rax,%rdi,1)
   dc085:	imul   %r9,%rdx
   dc089:	vmovdqu (%rax,%rdi,1),%ymm0
   dc08e:	vpbroadcastq %rdx,%ymm1
   dc094:	vpsllvq -0xd755d(%rip),%ymm1,%ymm1        # 4b40 <typeinfo name for main::$_60+0x370>
   dc09d:	vpsrld $0x1b,%ymm1,%ymm1
   dc0a2:	vmovdqa -0xd754a(%rip),%ymm2        # 4b60 <typeinfo name for main::$_60+0x390>
   dc0aa:	vpsllvd %ymm1,%ymm2,%ymm1
   dc0af:	xor    %eax,%eax
   dc0b1:	vptest %ymm1,%ymm0
   dc0b6:	setb   %al
   dc0b9:	mov    %eax,(%rcx,%r8,4)
   dc0bd:	pop    %rbx
   dc0be:	pop    %r14
   dc0c0:	vzeroupper
   dc0c3:	ret
   dc0c4:	int3
   dc0c5:	int3
   dc0c6:	int3
   dc0c7:	int3
   dc0c8:	int3
   dc0c9:	int3
   dc0ca:	int3
   dc0cb:	int3
   dc0cc:	int3
   dc0cd:	int3
   dc0ce:	int3
   dc0cf:	int3

