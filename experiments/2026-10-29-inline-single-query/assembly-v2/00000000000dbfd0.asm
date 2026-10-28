00000000000dbfd0 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<7ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<7ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
   dbfd0:	test   %rsi,%rsi
   dbfd3:	je     dc140 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<7ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<7ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x170>
   dbfd9:	push   %r14
   dbfdb:	push   %rbx
   dbfdc:	mov    %rdx,%rax
   dbfdf:	movabs $0xf1357aea2e62a9c5,%r9
   dbfe9:	cmp    $0x1,%rsi
   dbfed:	jne    dbff7 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<7ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<7ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x27>
   dbfef:	xor    %r8d,%r8d
   dbff2:	jmp    dc0df <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<7ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<7ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x10f>
   dbff7:	mov    %rsi,%r10
   dbffa:	and    $0xfffffffffffffffe,%r10
   dbffe:	xor    %r8d,%r8d
   dc001:	vmovdqa -0xd74c9(%rip),%ymm0        # 4b40 <typeinfo name for main::$_60+0x370>
   dc009:	vmovdqa -0xd74b1(%rip),%ymm1        # 4b60 <typeinfo name for main::$_60+0x390>
   dc011:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   dc020:	mov    (%rax,%r8,8),%rdx
   dc024:	or     $0x1,%rdx
   dc028:	mov    0x20(%rdi),%r11
   dc02c:	mulx   0x10(%rdi),%rbx,%rbx
   dc032:	lea    (%rbx,%rbx,8),%r14
   dc036:	lea    (%r14,%r14,2),%r14
   dc03a:	add    %rbx,%r14
   dc03d:	prefetcht0 (%r11,%r14,1)
   dc042:	imul   %r9,%rdx
   dc046:	vmovdqu (%r11,%r14,1),%ymm2
   dc04c:	vpbroadcastq %rdx,%ymm3
   dc052:	vpsllvq %ymm0,%ymm3,%ymm3
   dc057:	vpsrld $0x1b,%ymm3,%ymm3
   dc05c:	vpsllvd %ymm3,%ymm1,%ymm3
   dc061:	xor    %edx,%edx
   dc063:	vptest %ymm3,%ymm2
   dc068:	prefetcht0 0x40(%r11,%r14,1)
   dc06e:	setb   %dl
   dc071:	mov    %edx,(%rcx,%r8,4)
   dc075:	mov    0x8(%rax,%r8,8),%rdx
   dc07a:	or     $0x1,%rdx
   dc07e:	mov    0x20(%rdi),%r11
   dc082:	mulx   0x10(%rdi),%rbx,%rbx
   dc088:	lea    (%rbx,%rbx,8),%r14
   dc08c:	lea    (%r14,%r14,2),%r14
   dc090:	add    %rbx,%r14
   dc093:	prefetcht0 (%r11,%r14,1)
   dc098:	prefetcht0 0x40(%r11,%r14,1)
   dc09e:	imul   %r9,%rdx
   dc0a2:	vmovdqu (%r11,%r14,1),%ymm2
   dc0a8:	vpbroadcastq %rdx,%ymm3
   dc0ae:	vpsllvq %ymm0,%ymm3,%ymm3
   dc0b3:	vpsrld $0x1b,%ymm3,%ymm3
   dc0b8:	vpsllvd %ymm3,%ymm1,%ymm3
   dc0bd:	xor    %edx,%edx
   dc0bf:	vptest %ymm3,%ymm2
   dc0c4:	setb   %dl
   dc0c7:	mov    %edx,0x4(%rcx,%r8,4)
   dc0cc:	add    $0x2,%r8
   dc0d0:	cmp    %r8,%r10
   dc0d3:	jne    dc020 <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<7ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<7ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
   dc0d9:	test   $0x1,%sil
   dc0dd:	je     dc13d <void inline_single_kernel<false, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<7ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<7ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x16d>
   dc0df:	mov    (%rax,%r8,8),%rdx
   dc0e3:	or     $0x1,%rdx
   dc0e7:	mov    0x20(%rdi),%rax
   dc0eb:	mulx   0x10(%rdi),%rsi,%rsi
   dc0f1:	lea    (%rsi,%rsi,8),%rdi
   dc0f5:	lea    (%rdi,%rdi,2),%rdi
   dc0f9:	add    %rsi,%rdi
   dc0fc:	prefetcht0 (%rax,%rdi,1)
   dc100:	prefetcht0 0x40(%rax,%rdi,1)
   dc105:	imul   %r9,%rdx
   dc109:	vmovdqu (%rax,%rdi,1),%ymm0
   dc10e:	vpbroadcastq %rdx,%ymm1
   dc114:	vpsllvq -0xd75dd(%rip),%ymm1,%ymm1        # 4b40 <typeinfo name for main::$_60+0x370>
   dc11d:	vpsrld $0x1b,%ymm1,%ymm1
   dc122:	vmovdqa -0xd75ca(%rip),%ymm2        # 4b60 <typeinfo name for main::$_60+0x390>
   dc12a:	vpsllvd %ymm1,%ymm2,%ymm1
   dc12f:	xor    %eax,%eax
   dc131:	vptest %ymm1,%ymm0
   dc136:	setb   %al
   dc139:	mov    %eax,(%rcx,%r8,4)
   dc13d:	pop    %rbx
   dc13e:	pop    %r14
   dc140:	vzeroupper
   dc143:	ret
   dc144:	int3
   dc145:	int3
   dc146:	int3
   dc147:	int3
   dc148:	int3
   dc149:	int3
   dc14a:	int3
   dc14b:	int3
   dc14c:	int3
   dc14d:	int3
   dc14e:	int3
   dc14f:	int3

