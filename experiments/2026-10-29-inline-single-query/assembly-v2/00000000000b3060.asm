00000000000b3060 <void inline_single_kernel<false, external_bloom::Page<6u, false>, unsigned long>(external_bloom::Page<6u, false> const&, unsigned long, unsigned long const*, unsigned int*)>:
   b3060:	test   %rsi,%rsi
   b3063:	je     b31e1 <void inline_single_kernel<false, external_bloom::Page<6u, false>, unsigned long>(external_bloom::Page<6u, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x181>
   b3069:	push   %rbp
   b306a:	push   %r15
   b306c:	push   %r14
   b306e:	push   %rbx
   b306f:	mov    %rdx,%rax
   b3072:	xor    %r8d,%r8d
   b3075:	movabs $0xdeadbeefdeadbeef,%r9
   b307f:	movabs $0xe6adbeefdeadbeef,%r10
   b3089:	mov    $0xffffffff,%r11d
   b308f:	vbroadcasti128 -0xae4a8(%rip),%ymm0        # 4bf0 <typeinfo name for main::$_60+0x420>
   b3098:	vpbroadcastd -0xafdfd(%rip),%ymm1        # 32a4 <__abi_tag+0x2fe0>
   b30a1:	vpbroadcastd -0xafe02(%rip),%ymm2        # 32a8 <__abi_tag+0x2fe4>
   b30aa:	nopw   0x0(%rax,%rax,1)
   b30b0:	mov    (%rax,%r8,8),%rdx
   b30b4:	add    %r9,%rdx
   b30b7:	rorx   $0x31,%rdx,%rbx
   b30bd:	xor    %r10,%rdx
   b30c0:	add    %rbx,%rdx
   b30c3:	rorx   $0xc,%rdx,%r14
   b30c9:	add    %r14,%rdx
   b30cc:	rorx   $0x26,%rdx,%r15
   b30d2:	add    %r15,%rdx
   b30d5:	xor    %rdx,%rbx
   b30d8:	rorx   $0xd,%rdx,%rdx
   b30de:	add    %rdx,%rbx
   b30e1:	xor    %rbx,%r14
   b30e4:	rorx   $0x24,%rbx,%rbx
   b30ea:	add    %rbx,%r14
   b30ed:	xor    %r14,%r15
   b30f0:	rorx   $0x37,%r14,%r14
   b30f6:	add    %r14,%r15
   b30f9:	xor    %r15,%rdx
   b30fc:	rorx   $0x11,%r15,%r15
   b3102:	add    %r15,%rdx
   b3105:	xor    %rdx,%rbx
   b3108:	rorx   $0xa,%rdx,%rdx
   b310e:	add    %rdx,%rbx
   b3111:	xor    %rbx,%r14
   b3114:	rorx   $0x20,%rbx,%rbx
   b311a:	add    %r14,%rbx
   b311d:	xor    %rbx,%r15
   b3120:	rorx   $0x27,%rbx,%rbx
   b3126:	add    %r15,%rbx
   b3129:	xor    %rbx,%rdx
   b312c:	rorx   $0x1,%rbx,%rbx
   b3132:	add    %rbx,%rdx
   b3135:	rorx   $0x18,%ebx,%ebp
   b313b:	vmovq  %rbx,%xmm3
   b3140:	shr    $0x20,%rbx
   b3144:	rorx   $0x1c,%edx,%r14d
   b314a:	vmovq  %rdx,%xmm4
   b314f:	shr    $0x20,%rdx
   b3153:	rorx   $0x1a,%ebx,%ebx
   b3159:	xor    %ebp,%ebx
   b315b:	xor    %ebx,%r14d
   b315e:	rorx   $0x1e,%edx,%edx
   b3164:	xor    %r14d,%edx
   b3167:	mov    0x8(%rdi),%ebx
   b316a:	imul   0x10(%rdi),%rdx
   b316f:	mulx   %rbx,%rdx,%rdx
   b3174:	movzbl (%rdi),%ebx
   b3177:	shlx   %rbx,%rdx,%rdx
   b317c:	add    0x20(%rdi),%rdx
   b3180:	vpunpcklqdq %xmm4,%xmm3,%xmm3
   b3184:	add    $0x3,%bl
   b3187:	shlx   %ebx,%r11d,%ebx
   b318c:	vpbroadcastd %ebx,%ymm4
   b3192:	vpsrld $0x10,%xmm3,%xmm5
   b3197:	vinserti128 $0x1,%xmm5,%ymm3,%ymm3
   b319d:	vpandn %ymm3,%ymm4,%ymm3
   b31a1:	vpsrld $0x5,%ymm3,%ymm4
   b31a6:	vmovdqa %ymm0,%ymm5
   b31aa:	vpcmpeqd %ymm6,%ymm6,%ymm6
   b31ae:	vpgatherdd %ymm5,(%rdx,%ymm4,4),%ymm6
   b31b4:	vpand  %ymm1,%ymm3,%ymm3
   b31b8:	vpsllvd %ymm3,%ymm2,%ymm3
   b31bd:	vpandn %ymm3,%ymm6,%ymm4
   b31c1:	xor    %edx,%edx
   b31c3:	vptest %ymm3,%ymm4
   b31c8:	sete   %dl
   b31cb:	mov    %edx,(%rcx,%r8,4)
   b31cf:	inc    %r8
   b31d2:	cmp    %r8,%rsi
   b31d5:	jne    b30b0 <void inline_single_kernel<false, external_bloom::Page<6u, false>, unsigned long>(external_bloom::Page<6u, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
   b31db:	pop    %rbx
   b31dc:	pop    %r14
   b31de:	pop    %r15
   b31e0:	pop    %rbp
   b31e1:	vzeroupper
   b31e4:	ret
   b31e5:	int3
   b31e6:	int3
   b31e7:	int3
   b31e8:	int3
   b31e9:	int3
   b31ea:	int3
   b31eb:	int3
   b31ec:	int3
   b31ed:	int3
   b31ee:	int3
   b31ef:	int3

