00000000000d0060 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<5ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<5ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
   d0060:	test   %rsi,%rsi
   d0063:	je     d022d <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<5ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<5ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x1cd>
   d0069:	push   %r14
   d006b:	push   %rbx
   d006c:	mov    %rdx,%rax
   d006f:	movabs $0xf1357aea2e62a9c5,%r9
   d0079:	movabs $0xd6e8feb86659fd93,%r10
   d0083:	cmp    $0x1,%rsi
   d0087:	jne    d0091 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<5ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<5ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x31>
   d0089:	xor    %r8d,%r8d
   d008c:	jmp    d01ad <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<5ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<5ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x14d>
   d0091:	mov    %rsi,%r11
   d0094:	and    $0xfffffffffffffffe,%r11
   d0098:	xor    %r8d,%r8d
   d009b:	vmovdqa -0xcb563(%rip),%ymm0        # 4b40 <typeinfo name for main::$_60+0x370>
   d00a3:	vmovdqa -0xcb68b(%rip),%ymm1        # 4a20 <typeinfo name for main::$_60+0x250>
   d00ab:	nopl   0x0(%rax,%rax,1)
   d00b0:	mov    (%rax,%r8,8),%rdx
   d00b4:	mov    %rdx,%rbx
   d00b7:	shr    $0x20,%rbx
   d00bb:	xor    %rdx,%rbx
   d00be:	imul   %r10,%rbx
   d00c2:	mov    %rbx,%r14
   d00c5:	shr    $0x20,%r14
   d00c9:	xor    %rbx,%r14
   d00cc:	imul   %r10,%r14
   d00d0:	mov    %r14,%rdx
   d00d3:	shr    $0x20,%rdx
   d00d7:	xor    %r14,%rdx
   d00da:	or     $0x1,%rdx
   d00de:	mov    0x20(%rdi),%rbx
   d00e2:	mulx   0x10(%rdi),%r14,%r14
   d00e8:	lea    (%r14,%r14,4),%r14
   d00ec:	prefetcht0 (%rbx,%r14,4)
   d00f1:	imul   %r9,%rdx
   d00f5:	vmovdqu (%rbx,%r14,4),%ymm2
   d00fb:	vpbroadcastq %rdx,%ymm3
   d0101:	vpsllvq %ymm0,%ymm3,%ymm3
   d0106:	vpsrld $0x1b,%ymm3,%ymm3
   d010b:	vpsllvd %ymm3,%ymm1,%ymm3
   d0110:	xor    %edx,%edx
   d0112:	vptest %ymm3,%ymm2
   d0117:	prefetcht0 0x40(%rbx,%r14,4)
   d011d:	setb   %dl
   d0120:	mov    %edx,(%rcx,%r8,4)
   d0124:	mov    0x8(%rax,%r8,8),%rdx
   d0129:	mov    %rdx,%rbx
   d012c:	shr    $0x20,%rbx
   d0130:	xor    %rdx,%rbx
   d0133:	imul   %r10,%rbx
   d0137:	mov    %rbx,%r14
   d013a:	shr    $0x20,%r14
   d013e:	xor    %rbx,%r14
   d0141:	imul   %r10,%r14
   d0145:	mov    %r14,%rdx
   d0148:	shr    $0x20,%rdx
   d014c:	xor    %r14,%rdx
   d014f:	or     $0x1,%rdx
   d0153:	mov    0x20(%rdi),%rbx
   d0157:	mulx   0x10(%rdi),%r14,%r14
   d015d:	lea    (%r14,%r14,4),%r14
   d0161:	prefetcht0 (%rbx,%r14,4)
   d0166:	prefetcht0 0x40(%rbx,%r14,4)
   d016c:	imul   %r9,%rdx
   d0170:	vmovdqu (%rbx,%r14,4),%ymm2
   d0176:	vpbroadcastq %rdx,%ymm3
   d017c:	vpsllvq %ymm0,%ymm3,%ymm3
   d0181:	vpsrld $0x1b,%ymm3,%ymm3
   d0186:	vpsllvd %ymm3,%ymm1,%ymm3
   d018b:	xor    %edx,%edx
   d018d:	vptest %ymm3,%ymm2
   d0192:	setb   %dl
   d0195:	mov    %edx,0x4(%rcx,%r8,4)
   d019a:	add    $0x2,%r8
   d019e:	cmp    %r8,%r11
   d01a1:	jne    d00b0 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<5ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<5ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
   d01a7:	test   $0x1,%sil
   d01ab:	je     d022a <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<5ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<5ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x1ca>
   d01ad:	mov    (%rax,%r8,8),%rax
   d01b1:	mov    %rax,%rdx
   d01b4:	shr    $0x20,%rdx
   d01b8:	xor    %rax,%rdx
   d01bb:	imul   %r10,%rdx
   d01bf:	mov    %rdx,%rax
   d01c2:	shr    $0x20,%rax
   d01c6:	xor    %rdx,%rax
   d01c9:	imul   %r10,%rax
   d01cd:	mov    %rax,%rdx
   d01d0:	shr    $0x20,%rdx
   d01d4:	xor    %rax,%rdx
   d01d7:	or     $0x1,%rdx
   d01db:	mov    0x20(%rdi),%rax
   d01df:	mulx   0x10(%rdi),%rsi,%rsi
   d01e5:	lea    (%rsi,%rsi,4),%rsi
   d01e9:	prefetcht0 (%rax,%rsi,4)
   d01ed:	prefetcht0 0x40(%rax,%rsi,4)
   d01f2:	imul   %r9,%rdx
   d01f6:	vmovdqu (%rax,%rsi,4),%ymm0
   d01fb:	vpbroadcastq %rdx,%ymm1
   d0201:	vpsllvq -0xcb6ca(%rip),%ymm1,%ymm1        # 4b40 <typeinfo name for main::$_60+0x370>
   d020a:	vpsrld $0x1b,%ymm1,%ymm1
   d020f:	vmovdqa -0xcb7f7(%rip),%ymm2        # 4a20 <typeinfo name for main::$_60+0x250>
   d0217:	vpsllvd %ymm1,%ymm2,%ymm1
   d021c:	xor    %eax,%eax
   d021e:	vptest %ymm1,%ymm0
   d0223:	setb   %al
   d0226:	mov    %eax,(%rcx,%r8,4)
   d022a:	pop    %rbx
   d022b:	pop    %r14
   d022d:	vzeroupper
   d0230:	ret
   d0231:	int3
   d0232:	int3
   d0233:	int3
   d0234:	int3
   d0235:	int3
   d0236:	int3
   d0237:	int3
   d0238:	int3
   d0239:	int3
   d023a:	int3
   d023b:	int3
   d023c:	int3
   d023d:	int3
   d023e:	int3
   d023f:	int3

