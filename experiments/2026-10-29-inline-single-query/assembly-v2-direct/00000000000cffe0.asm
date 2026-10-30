00000000000cffe0 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<5ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<5ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
   cffe0:	test   %rsi,%rsi
   cffe3:	je     d01ad <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<5ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<5ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x1cd>
   cffe9:	push   %r14
   cffeb:	push   %rbx
   cffec:	mov    %rdx,%rax
   cffef:	movabs $0xf1357aea2e62a9c5,%r9
   cfff9:	movabs $0xd6e8feb86659fd93,%r10
   d0003:	cmp    $0x1,%rsi
   d0007:	jne    d0011 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<5ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<5ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x31>
   d0009:	xor    %r8d,%r8d
   d000c:	jmp    d012d <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<5ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<5ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x14d>
   d0011:	mov    %rsi,%r11
   d0014:	and    $0xfffffffffffffffe,%r11
   d0018:	xor    %r8d,%r8d
   d001b:	vmovdqa -0xcb4e3(%rip),%ymm0        # 4b40 <typeinfo name for main::$_60+0x370>
   d0023:	vmovdqa -0xcb60b(%rip),%ymm1        # 4a20 <typeinfo name for main::$_60+0x250>
   d002b:	nopl   0x0(%rax,%rax,1)
   d0030:	mov    (%rax,%r8,8),%rdx
   d0034:	mov    %rdx,%rbx
   d0037:	shr    $0x20,%rbx
   d003b:	xor    %rdx,%rbx
   d003e:	imul   %r10,%rbx
   d0042:	mov    %rbx,%r14
   d0045:	shr    $0x20,%r14
   d0049:	xor    %rbx,%r14
   d004c:	imul   %r10,%r14
   d0050:	mov    %r14,%rdx
   d0053:	shr    $0x20,%rdx
   d0057:	xor    %r14,%rdx
   d005a:	or     $0x1,%rdx
   d005e:	mov    0x20(%rdi),%rbx
   d0062:	mulx   0x10(%rdi),%r14,%r14
   d0068:	lea    (%r14,%r14,4),%r14
   d006c:	prefetcht0 (%rbx,%r14,4)
   d0071:	imul   %r9,%rdx
   d0075:	vmovdqu (%rbx,%r14,4),%ymm2
   d007b:	vpbroadcastq %rdx,%ymm3
   d0081:	vpsllvq %ymm0,%ymm3,%ymm3
   d0086:	vpsrld $0x1b,%ymm3,%ymm3
   d008b:	vpsllvd %ymm3,%ymm1,%ymm3
   d0090:	xor    %edx,%edx
   d0092:	vptest %ymm3,%ymm2
   d0097:	prefetcht0 0x40(%rbx,%r14,4)
   d009d:	setb   %dl
   d00a0:	mov    %edx,(%rcx,%r8,4)
   d00a4:	mov    0x8(%rax,%r8,8),%rdx
   d00a9:	mov    %rdx,%rbx
   d00ac:	shr    $0x20,%rbx
   d00b0:	xor    %rdx,%rbx
   d00b3:	imul   %r10,%rbx
   d00b7:	mov    %rbx,%r14
   d00ba:	shr    $0x20,%r14
   d00be:	xor    %rbx,%r14
   d00c1:	imul   %r10,%r14
   d00c5:	mov    %r14,%rdx
   d00c8:	shr    $0x20,%rdx
   d00cc:	xor    %r14,%rdx
   d00cf:	or     $0x1,%rdx
   d00d3:	mov    0x20(%rdi),%rbx
   d00d7:	mulx   0x10(%rdi),%r14,%r14
   d00dd:	lea    (%r14,%r14,4),%r14
   d00e1:	prefetcht0 (%rbx,%r14,4)
   d00e6:	prefetcht0 0x40(%rbx,%r14,4)
   d00ec:	imul   %r9,%rdx
   d00f0:	vmovdqu (%rbx,%r14,4),%ymm2
   d00f6:	vpbroadcastq %rdx,%ymm3
   d00fc:	vpsllvq %ymm0,%ymm3,%ymm3
   d0101:	vpsrld $0x1b,%ymm3,%ymm3
   d0106:	vpsllvd %ymm3,%ymm1,%ymm3
   d010b:	xor    %edx,%edx
   d010d:	vptest %ymm3,%ymm2
   d0112:	setb   %dl
   d0115:	mov    %edx,0x4(%rcx,%r8,4)
   d011a:	add    $0x2,%r8
   d011e:	cmp    %r8,%r11
   d0121:	jne    d0030 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<5ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<5ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
   d0127:	test   $0x1,%sil
   d012b:	je     d01aa <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<5ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<5ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x1ca>
   d012d:	mov    (%rax,%r8,8),%rax
   d0131:	mov    %rax,%rdx
   d0134:	shr    $0x20,%rdx
   d0138:	xor    %rax,%rdx
   d013b:	imul   %r10,%rdx
   d013f:	mov    %rdx,%rax
   d0142:	shr    $0x20,%rax
   d0146:	xor    %rdx,%rax
   d0149:	imul   %r10,%rax
   d014d:	mov    %rax,%rdx
   d0150:	shr    $0x20,%rdx
   d0154:	xor    %rax,%rdx
   d0157:	or     $0x1,%rdx
   d015b:	mov    0x20(%rdi),%rax
   d015f:	mulx   0x10(%rdi),%rsi,%rsi
   d0165:	lea    (%rsi,%rsi,4),%rsi
   d0169:	prefetcht0 (%rax,%rsi,4)
   d016d:	prefetcht0 0x40(%rax,%rsi,4)
   d0172:	imul   %r9,%rdx
   d0176:	vmovdqu (%rax,%rsi,4),%ymm0
   d017b:	vpbroadcastq %rdx,%ymm1
   d0181:	vpsllvq -0xcb64a(%rip),%ymm1,%ymm1        # 4b40 <typeinfo name for main::$_60+0x370>
   d018a:	vpsrld $0x1b,%ymm1,%ymm1
   d018f:	vmovdqa -0xcb777(%rip),%ymm2        # 4a20 <typeinfo name for main::$_60+0x250>
   d0197:	vpsllvd %ymm1,%ymm2,%ymm1
   d019c:	xor    %eax,%eax
   d019e:	vptest %ymm1,%ymm0
   d01a3:	setb   %al
   d01a6:	mov    %eax,(%rcx,%r8,4)
   d01aa:	pop    %rbx
   d01ab:	pop    %r14
   d01ad:	vzeroupper
   d01b0:	ret
   d01b1:	int3
   d01b2:	int3
   d01b3:	int3
   d01b4:	int3
   d01b5:	int3
   d01b6:	int3
   d01b7:	int3
   d01b8:	int3
   d01b9:	int3
   d01ba:	int3
   d01bb:	int3
   d01bc:	int3
   d01bd:	int3
   d01be:	int3
   d01bf:	int3

