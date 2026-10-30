00000000000c4150 <void inline_single_kernel<false, external_bloom::Page<8u, true>, unsigned long>(external_bloom::Page<8u, true> const&, unsigned long, unsigned long const*, unsigned int*)>:
   c4150:	test   %rsi,%rsi
   c4153:	je     c42d1 <void inline_single_kernel<false, external_bloom::Page<8u, true>, unsigned long>(external_bloom::Page<8u, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x181>
   c4159:	push   %rbp
   c415a:	push   %r15
   c415c:	push   %r14
   c415e:	push   %rbx
   c415f:	mov    %rdx,%rax
   c4162:	xor    %r8d,%r8d
   c4165:	movabs $0xdeadbeefdeadbeef,%r9
   c416f:	movabs $0xe6adbeefdeadbeef,%r10
   c4179:	mov    $0xffffffff,%r11d
   c417f:	vpbroadcastd -0xc0ee4(%rip),%ymm0        # 32a4 <__abi_tag+0x2fe0>
   c4188:	vpbroadcastd -0xc0ee9(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
   c4191:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   c41a0:	mov    (%rax,%r8,8),%rdx
   c41a4:	add    %r9,%rdx
   c41a7:	rorx   $0x31,%rdx,%rbx
   c41ad:	xor    %r10,%rdx
   c41b0:	add    %rbx,%rdx
   c41b3:	rorx   $0xc,%rdx,%r14
   c41b9:	add    %r14,%rdx
   c41bc:	rorx   $0x26,%rdx,%r15
   c41c2:	add    %r15,%rdx
   c41c5:	xor    %rdx,%rbx
   c41c8:	rorx   $0xd,%rdx,%rdx
   c41ce:	add    %rdx,%rbx
   c41d1:	xor    %rbx,%r14
   c41d4:	rorx   $0x24,%rbx,%rbx
   c41da:	add    %rbx,%r14
   c41dd:	xor    %r14,%r15
   c41e0:	rorx   $0x37,%r14,%r14
   c41e6:	add    %r14,%r15
   c41e9:	xor    %r15,%rdx
   c41ec:	rorx   $0x11,%r15,%r15
   c41f2:	add    %r15,%rdx
   c41f5:	xor    %rdx,%rbx
   c41f8:	rorx   $0xa,%rdx,%rdx
   c41fe:	add    %rdx,%rbx
   c4201:	xor    %rbx,%r14
   c4204:	rorx   $0x20,%rbx,%rbx
   c420a:	add    %r14,%rbx
   c420d:	xor    %rbx,%r15
   c4210:	rorx   $0x27,%rbx,%rbx
   c4216:	add    %r15,%rbx
   c4219:	xor    %rbx,%rdx
   c421c:	rorx   $0x1,%rbx,%rbx
   c4222:	add    %rbx,%rdx
   c4225:	rorx   $0x18,%ebx,%ebp
   c422b:	vmovq  %rbx,%xmm2
   c4230:	shr    $0x20,%rbx
   c4234:	rorx   $0x1c,%edx,%r14d
   c423a:	vmovq  %rdx,%xmm3
   c423f:	shr    $0x20,%rdx
   c4243:	rorx   $0x1a,%ebx,%ebx
   c4249:	xor    %ebp,%ebx
   c424b:	xor    %ebx,%r14d
   c424e:	rorx   $0x1e,%edx,%edx
   c4254:	xor    %r14d,%edx
   c4257:	mov    0x8(%rdi),%ebx
   c425a:	imul   0x10(%rdi),%rdx
   c425f:	mulx   %rbx,%rdx,%rdx
   c4264:	movzbl (%rdi),%ebx
   c4267:	shlx   %rbx,%rdx,%rdx
   c426c:	add    0x20(%rdi),%rdx
   c4270:	vpunpcklqdq %xmm3,%xmm2,%xmm2
   c4274:	add    $0x3,%bl
   c4277:	shlx   %ebx,%r11d,%ebx
   c427c:	vpbroadcastd %ebx,%ymm3
   c4282:	vpsrld $0x10,%xmm2,%xmm4
   c4287:	vinserti128 $0x1,%xmm4,%ymm2,%ymm2
   c428d:	vpandn %ymm2,%ymm3,%ymm2
   c4291:	vpsrld $0x5,%ymm2,%ymm3
   c4296:	vpcmpeqd %ymm4,%ymm4,%ymm4
   c429a:	vpxor  %xmm5,%xmm5,%xmm5
   c429e:	vpgatherdd %ymm4,(%rdx,%ymm3,4),%ymm5
   c42a4:	vpand  %ymm0,%ymm2,%ymm2
   c42a8:	vpsllvd %ymm2,%ymm1,%ymm2
   c42ad:	vpandn %ymm2,%ymm5,%ymm3
   c42b1:	xor    %edx,%edx
   c42b3:	vptest %ymm2,%ymm3
   c42b8:	sete   %dl
   c42bb:	mov    %edx,(%rcx,%r8,4)
   c42bf:	inc    %r8
   c42c2:	cmp    %r8,%rsi
   c42c5:	jne    c41a0 <void inline_single_kernel<false, external_bloom::Page<8u, true>, unsigned long>(external_bloom::Page<8u, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
   c42cb:	pop    %rbx
   c42cc:	pop    %r14
   c42ce:	pop    %r15
   c42d0:	pop    %rbp
   c42d1:	vzeroupper
   c42d4:	ret
   c42d5:	int3
   c42d6:	int3
   c42d7:	int3
   c42d8:	int3
   c42d9:	int3
   c42da:	int3
   c42db:	int3
   c42dc:	int3
   c42dd:	int3
   c42de:	int3
   c42df:	int3

