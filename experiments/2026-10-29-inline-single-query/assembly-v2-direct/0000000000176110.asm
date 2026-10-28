0000000000176110 <void inline_single_kernel<false, bloom_filters::Split64BloomFilter, unsigned long>(bloom_filters::Split64BloomFilter const&, unsigned long, unsigned long const*, unsigned int*)>:
  176110:	test   %rsi,%rsi
  176113:	je     176250 <void inline_single_kernel<false, bloom_filters::Split64BloomFilter, unsigned long>(bloom_filters::Split64BloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x140>
  176119:	cmp    $0x1,%rsi
  17611d:	jne    176126 <void inline_single_kernel<false, bloom_filters::Split64BloomFilter, unsigned long>(bloom_filters::Split64BloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x16>
  17611f:	xor    %eax,%eax
  176121:	jmp    1761fe <void inline_single_kernel<false, bloom_filters::Split64BloomFilter, unsigned long>(bloom_filters::Split64BloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0xee>
  176126:	mov    %rsi,%r8
  176129:	and    $0xfffffffffffffffe,%r8
  17612d:	xor    %eax,%eax
  17612f:	vmovdqa -0x171817(%rip),%ymm0        # 4920 <typeinfo name for main::$_60+0x150>
  176137:	vpbroadcastq -0x172de9(%rip),%zmm1        # 3358 <_IO_stdin_used+0xa4>
  176141:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  176150:	mov    (%rdx,%rax,8),%r9
  176154:	vpbroadcastd %r9d,%ymm2
  17615a:	shr    $0x20,%r9
  17615e:	and    0x18(%rdi),%r9d
  176162:	mov    (%rdi),%r10
  176165:	shl    $0x6,%r9
  176169:	vmovdqa64 (%r10,%r9,1),%zmm3
  176170:	vpmulld %ymm0,%ymm2,%ymm2
  176175:	vpsrld $0x1a,%ymm2,%ymm2
  17617a:	vpmovzxdq %ymm2,%zmm2
  176180:	vpsrlvq %zmm2,%zmm3,%zmm2
  176186:	vptestnmq %zmm1,%zmm2,%k0
  17618c:	xor    %r9d,%r9d
  17618f:	kortestb %k0,%k0
  176193:	sete   %r9b
  176197:	mov    %r9d,(%rcx,%rax,4)
  17619b:	mov    0x8(%rdx,%rax,8),%r9
  1761a0:	mov    %r9,%r10
  1761a3:	shr    $0x20,%r10
  1761a7:	and    0x18(%rdi),%r10d
  1761ab:	vpbroadcastd %r9d,%ymm2
  1761b1:	mov    (%rdi),%r9
  1761b4:	shl    $0x6,%r10
  1761b8:	vmovdqa64 (%r9,%r10,1),%zmm3
  1761bf:	vpmulld %ymm0,%ymm2,%ymm2
  1761c4:	vpsrld $0x1a,%ymm2,%ymm2
  1761c9:	vpmovzxdq %ymm2,%zmm2
  1761cf:	vpsrlvq %zmm2,%zmm3,%zmm2
  1761d5:	vptestnmq %zmm1,%zmm2,%k0
  1761db:	xor    %r9d,%r9d
  1761de:	kortestb %k0,%k0
  1761e2:	sete   %r9b
  1761e6:	mov    %r9d,0x4(%rcx,%rax,4)
  1761eb:	add    $0x2,%rax
  1761ef:	cmp    %rax,%r8
  1761f2:	jne    176150 <void inline_single_kernel<false, bloom_filters::Split64BloomFilter, unsigned long>(bloom_filters::Split64BloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
  1761f8:	test   $0x1,%sil
  1761fc:	je     176250 <void inline_single_kernel<false, bloom_filters::Split64BloomFilter, unsigned long>(bloom_filters::Split64BloomFilter const&, unsigned long, unsigned long const*, unsigned int*)+0x140>
  1761fe:	mov    (%rdx,%rax,8),%rdx
  176202:	mov    %rdx,%rsi
  176205:	shr    $0x20,%rsi
  176209:	and    0x18(%rdi),%esi
  17620c:	vpbroadcastd %edx,%ymm0
  176212:	mov    (%rdi),%rdx
  176215:	shl    $0x6,%rsi
  176219:	vpmulld -0x171902(%rip),%ymm0,%ymm0        # 4920 <typeinfo name for main::$_60+0x150>
  176222:	vmovdqa64 (%rdx,%rsi,1),%zmm1
  176229:	vpsrld $0x1a,%ymm0,%ymm0
  17622e:	vpmovzxdq %ymm0,%zmm0
  176234:	vpsrlvq %zmm0,%zmm1,%zmm0
  17623a:	vptestnmq -0x172eec(%rip){1to8},%zmm0,%k0        # 3358 <_IO_stdin_used+0xa4>
  176244:	xor    %edx,%edx
  176246:	kortestb %k0,%k0
  17624a:	sete   %dl
  17624d:	mov    %edx,(%rcx,%rax,4)
  176250:	vzeroupper
  176253:	ret
  176254:	int3
  176255:	int3
  176256:	int3
  176257:	int3
  176258:	int3
  176259:	int3
  17625a:	int3
  17625b:	int3
  17625c:	int3
  17625d:	int3
  17625e:	int3
  17625f:	int3

