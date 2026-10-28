
/tmp/fastest-bf-rust-byte-inline-only/release/compare_benchmark:     file format elf64-x86-64


Disassembly of section .text:

0000000000039160 <<fastest_bloom_filter::byte_split::ByteSplitBloomFilter>::lookup_hashes>:
   39160:	push   %rbp
   39161:	push   %r15
   39163:	push   %r14
   39165:	push   %r13
   39167:	push   %r12
   39169:	push   %rbx
   3916a:	sub    $0x48,%rsp
   3916e:	mov    %rdx,0x8(%rsp)
   39173:	mov    %r8,0x10(%rsp)
   39178:	cmp    %r8,%rdx
   3917b:	jne    3930e <<fastest_bloom_filter::byte_split::ByteSplitBloomFilter>::lookup_hashes+0x1ae>
   39181:	mov    %rcx,%rbx
   39184:	mov    %rdx,%r15
   39187:	mov    %rsi,%r14
   3918a:	mov    %rdi,%r12
   3918d:	cmp    $0x1,%rdx
   39191:	jne    391e5 <<fastest_bloom_filter::byte_split::ByteSplitBloomFilter>::lookup_hashes+0x85>
   39193:	mov    (%r14),%rsi
   39196:	cmpb   $0x0,0x1c(%r12)
   3919c:	je     392c6 <<fastest_bloom_filter::byte_split::ByteSplitBloomFilter>::lookup_hashes+0x166>
   391a2:	mov    %rsi,%rax
   391a5:	shr    $0x20,%rax
   391a9:	and    0x18(%r12),%eax
   391ae:	mov    0x8(%r12),%rcx
   391b3:	shl    $0x4,%rax
   391b7:	vmovdqa (%rcx,%rax,1),%xmm0
   391bc:	vpbroadcastd %esi,%xmm1
   391c2:	vpmulhw -0x310ca(%rip),%xmm1,%xmm1        # 8100 <anon.35274091df3394f4211c680a8c77ed4a.34.llvm.9036914972901821666+0x100>
   391ca:	vpbroadcastq -0x3155b(%rip),%xmm2        # 7c78 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x224>
   391d3:	vpshufb %xmm1,%xmm2,%xmm1
   391d8:	vptest %xmm1,%xmm0
   391dd:	setb   %al
   391e0:	jmp    392ce <<fastest_bloom_filter::byte_split::ByteSplitBloomFilter>::lookup_hashes+0x16e>
   391e5:	cmpb   $0x0,0x1c(%r12)
   391eb:	je     392d5 <<fastest_bloom_filter::byte_split::ByteSplitBloomFilter>::lookup_hashes+0x175>
   391f1:	test   %r15,%r15
   391f4:	je     392ff <<fastest_bloom_filter::byte_split::ByteSplitBloomFilter>::lookup_hashes+0x19f>
   391fa:	mov    0x18(%r12),%eax
   391ff:	mov    0x8(%r12),%rcx
   39204:	mov    %r15,%rdx
   39207:	and    $0xfffffffffffffffe,%rdx
   3920b:	xor    %esi,%esi
   3920d:	vmovdqa -0x31115(%rip),%xmm1        # 8100 <anon.35274091df3394f4211c680a8c77ed4a.34.llvm.9036914972901821666+0x100>
   39215:	vpbroadcastq -0x315a6(%rip),%xmm0        # 7c78 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x224>
   3921e:	xchg   %ax,%ax
   39220:	mov    (%r14,%rsi,8),%rdi
   39224:	vpbroadcastd %edi,%xmm2
   3922a:	shr    $0x20,%rdi
   3922e:	and    %eax,%edi
   39230:	shl    $0x4,%rdi
   39234:	vmovdqa (%rcx,%rdi,1),%xmm3
   39239:	vpmulhw %xmm1,%xmm2,%xmm2
   3923d:	vpshufb %xmm2,%xmm0,%xmm2
   39242:	xor    %edi,%edi
   39244:	vptest %xmm2,%xmm3
   39249:	setb   %dil
   3924d:	mov    %edi,(%rbx,%rsi,4)
   39250:	mov    0x8(%r14,%rsi,8),%rdi
   39255:	vpbroadcastd %edi,%xmm2
   3925b:	shr    $0x20,%rdi
   3925f:	and    %eax,%edi
   39261:	shl    $0x4,%rdi
   39265:	vmovdqa (%rcx,%rdi,1),%xmm3
   3926a:	vpmulhw %xmm1,%xmm2,%xmm2
   3926e:	vpshufb %xmm2,%xmm0,%xmm2
   39273:	xor    %edi,%edi
   39275:	vptest %xmm2,%xmm3
   3927a:	setb   %dil
   3927e:	mov    %edi,0x4(%rbx,%rsi,4)
   39282:	add    $0x2,%rsi
   39286:	cmp    %rsi,%rdx
   39289:	jne    39220 <<fastest_bloom_filter::byte_split::ByteSplitBloomFilter>::lookup_hashes+0xc0>
   3928b:	test   $0x1,%r15b
   3928f:	je     392ff <<fastest_bloom_filter::byte_split::ByteSplitBloomFilter>::lookup_hashes+0x19f>
   39291:	mov    (%r14,%rsi,8),%rdx
   39295:	vpbroadcastd %edx,%xmm1
   3929b:	shr    $0x20,%rdx
   3929f:	and    %edx,%eax
   392a1:	shl    $0x4,%rax
   392a5:	vmovdqa (%rcx,%rax,1),%xmm2
   392aa:	vpmulhw -0x311b2(%rip),%xmm1,%xmm1        # 8100 <anon.35274091df3394f4211c680a8c77ed4a.34.llvm.9036914972901821666+0x100>
   392b2:	vpshufb %xmm1,%xmm0,%xmm0
   392b7:	xor    %eax,%eax
   392b9:	vptest %xmm0,%xmm2
   392be:	setb   %al
   392c1:	mov    %eax,(%rbx,%rsi,4)
   392c4:	jmp    392ff <<fastest_bloom_filter::byte_split::ByteSplitBloomFilter>::lookup_hashes+0x19f>
   392c6:	mov    %r12,%rdi
   392c9:	call   39360 <<fastest_bloom_filter::byte_split::ByteSplitBloomFilter>::contains_scalar>
   392ce:	movzbl %al,%eax
   392d1:	mov    %eax,(%rbx)
   392d3:	jmp    392ff <<fastest_bloom_filter::byte_split::ByteSplitBloomFilter>::lookup_hashes+0x19f>
   392d5:	test   %r15,%r15
   392d8:	je     392ff <<fastest_bloom_filter::byte_split::ByteSplitBloomFilter>::lookup_hashes+0x19f>
   392da:	xor    %r13d,%r13d
   392dd:	nopl   (%rax)
   392e0:	lea    0x1(%r13),%rbp
   392e4:	mov    (%r14,%r13,8),%rsi
   392e8:	mov    %r12,%rdi
   392eb:	call   39360 <<fastest_bloom_filter::byte_split::ByteSplitBloomFilter>::contains_scalar>
   392f0:	movzbl %al,%eax
   392f3:	mov    %eax,(%rbx,%r13,4)
   392f7:	mov    %rbp,%r13
   392fa:	cmp    %rbp,%r15
   392fd:	jne    392e0 <<fastest_bloom_filter::byte_split::ByteSplitBloomFilter>::lookup_hashes+0x180>
   392ff:	add    $0x48,%rsp
   39303:	pop    %rbx
   39304:	pop    %r12
   39306:	pop    %r13
   39308:	pop    %r14
   3930a:	pop    %r15
   3930c:	pop    %rbp
   3930d:	ret
   3930e:	lea    0x3fe43(%rip),%rax        # 79158 <anon.35274091df3394f4211c680a8c77ed4a.292.llvm.9036914972901821666+0x1c8>
   39315:	mov    %rax,0x18(%rsp)
   3931a:	movq   $0x1,0x20(%rsp)
   39323:	movq   $0x8,0x28(%rsp)
   3932c:	vxorps %xmm0,%xmm0,%xmm0
   39330:	vmovups %xmm0,0x30(%rsp)
   39336:	lea    0x3fe2b(%rip),%r8        # 79168 <anon.35274091df3394f4211c680a8c77ed4a.292.llvm.9036914972901821666+0x1d8>
   3933d:	lea    0x8(%rsp),%rsi
   39342:	lea    0x10(%rsp),%rdx
   39347:	lea    0x18(%rsp),%rcx
   3934c:	xor    %edi,%edi
   3934e:	call   *0x421b4(%rip)        # 7b508 <_DYNAMIC+0x2d8>
