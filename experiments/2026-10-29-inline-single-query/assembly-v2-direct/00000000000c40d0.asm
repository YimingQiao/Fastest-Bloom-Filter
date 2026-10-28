00000000000c40d0 <void inline_single_kernel<false, external_bloom::Page<8u, true>, unsigned long>(external_bloom::Page<8u, true> const&, unsigned long, unsigned long const*, unsigned int*)>:
   c40d0:	test   %rsi,%rsi
   c40d3:	je     c4251 <void inline_single_kernel<false, external_bloom::Page<8u, true>, unsigned long>(external_bloom::Page<8u, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x181>
   c40d9:	push   %rbp
   c40da:	push   %r15
   c40dc:	push   %r14
   c40de:	push   %rbx
   c40df:	mov    %rdx,%rax
   c40e2:	xor    %r8d,%r8d
   c40e5:	movabs $0xdeadbeefdeadbeef,%r9
   c40ef:	movabs $0xe6adbeefdeadbeef,%r10
   c40f9:	mov    $0xffffffff,%r11d
   c40ff:	vpbroadcastd -0xc0e64(%rip),%ymm0        # 32a4 <__abi_tag+0x2fe0>
   c4108:	vpbroadcastd -0xc0e69(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
   c4111:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   c4120:	mov    (%rax,%r8,8),%rdx
   c4124:	add    %r9,%rdx
   c4127:	rorx   $0x31,%rdx,%rbx
   c412d:	xor    %r10,%rdx
   c4130:	add    %rbx,%rdx
   c4133:	rorx   $0xc,%rdx,%r14
   c4139:	add    %r14,%rdx
   c413c:	rorx   $0x26,%rdx,%r15
   c4142:	add    %r15,%rdx
   c4145:	xor    %rdx,%rbx
   c4148:	rorx   $0xd,%rdx,%rdx
   c414e:	add    %rdx,%rbx
   c4151:	xor    %rbx,%r14
   c4154:	rorx   $0x24,%rbx,%rbx
   c415a:	add    %rbx,%r14
   c415d:	xor    %r14,%r15
   c4160:	rorx   $0x37,%r14,%r14
   c4166:	add    %r14,%r15
   c4169:	xor    %r15,%rdx
   c416c:	rorx   $0x11,%r15,%r15
   c4172:	add    %r15,%rdx
   c4175:	xor    %rdx,%rbx
   c4178:	rorx   $0xa,%rdx,%rdx
   c417e:	add    %rdx,%rbx
   c4181:	xor    %rbx,%r14
   c4184:	rorx   $0x20,%rbx,%rbx
   c418a:	add    %r14,%rbx
   c418d:	xor    %rbx,%r15
   c4190:	rorx   $0x27,%rbx,%rbx
   c4196:	add    %r15,%rbx
   c4199:	xor    %rbx,%rdx
   c419c:	rorx   $0x1,%rbx,%rbx
   c41a2:	add    %rbx,%rdx
   c41a5:	rorx   $0x18,%ebx,%ebp
   c41ab:	vmovq  %rbx,%xmm2
   c41b0:	shr    $0x20,%rbx
   c41b4:	rorx   $0x1c,%edx,%r14d
   c41ba:	vmovq  %rdx,%xmm3
   c41bf:	shr    $0x20,%rdx
   c41c3:	rorx   $0x1a,%ebx,%ebx
   c41c9:	xor    %ebp,%ebx
   c41cb:	xor    %ebx,%r14d
   c41ce:	rorx   $0x1e,%edx,%edx
   c41d4:	xor    %r14d,%edx
   c41d7:	mov    0x8(%rdi),%ebx
   c41da:	imul   0x10(%rdi),%rdx
   c41df:	mulx   %rbx,%rdx,%rdx
   c41e4:	movzbl (%rdi),%ebx
   c41e7:	shlx   %rbx,%rdx,%rdx
   c41ec:	add    0x20(%rdi),%rdx
   c41f0:	vpunpcklqdq %xmm3,%xmm2,%xmm2
   c41f4:	add    $0x3,%bl
   c41f7:	shlx   %ebx,%r11d,%ebx
   c41fc:	vpbroadcastd %ebx,%ymm3
   c4202:	vpsrld $0x10,%xmm2,%xmm4
   c4207:	vinserti128 $0x1,%xmm4,%ymm2,%ymm2
   c420d:	vpandn %ymm2,%ymm3,%ymm2
   c4211:	vpsrld $0x5,%ymm2,%ymm3
   c4216:	vpcmpeqd %ymm4,%ymm4,%ymm4
   c421a:	vpxor  %xmm5,%xmm5,%xmm5
   c421e:	vpgatherdd %ymm4,(%rdx,%ymm3,4),%ymm5
   c4224:	vpand  %ymm0,%ymm2,%ymm2
   c4228:	vpsllvd %ymm2,%ymm1,%ymm2
   c422d:	vpandn %ymm2,%ymm5,%ymm3
   c4231:	xor    %edx,%edx
   c4233:	vptest %ymm2,%ymm3
   c4238:	sete   %dl
   c423b:	mov    %edx,(%rcx,%r8,4)
   c423f:	inc    %r8
   c4242:	cmp    %r8,%rsi
   c4245:	jne    c4120 <void inline_single_kernel<false, external_bloom::Page<8u, true>, unsigned long>(external_bloom::Page<8u, true> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
   c424b:	pop    %rbx
   c424c:	pop    %r14
   c424e:	pop    %r15
   c4250:	pop    %rbp
   c4251:	vzeroupper
   c4254:	ret
   c4255:	int3
   c4256:	int3
   c4257:	int3
   c4258:	int3
   c4259:	int3
   c425a:	int3
   c425b:	int3
   c425c:	int3
   c425d:	int3
   c425e:	int3
   c425f:	int3

