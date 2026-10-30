    dec0:	cmp    $0x4,%esi
    dec3:	jae    ded4 <void bloom_filters::K12ScalarOrControl::InsertVector<true>(unsigned int, unsigned long const*)+0x14>
    dec5:	xor    %r9d,%r9d
    dec8:	sub    %r9d,%esi
    decb:	lea    (%rdx,%r9,8),%rdx
    decf:	jmp    e4a0 <bloom_filters::K12ScalarOrControl::InsertScalar(unsigned int, unsigned long const*)>
    ded4:	push   %rbx
    ded5:	mov    %esi,%eax
    ded7:	xor    %ecx,%ecx
    ded9:	vmovdqa64 -0xbce3(%rip),%zmm0        # 2200 <_IO_stdin_used+0x164>
    dee3:	vmovdqa64 -0xbcad(%rip),%zmm1        # 2240 <_IO_stdin_used+0x1a4>
    deed:	vbroadcasti32x4 -0xac87(%rip),%zmm2        # 3270 <typeinfo name for main::$_2+0x24>
    def7:	vmovdqa64 -0xbc41(%rip),%zmm3        # 22c0 <_IO_stdin_used+0x224>
    df01:	vbroadcasti32x4 -0xacab(%rip),%zmm4        # 3260 <typeinfo name for main::$_2+0x14>
    df0b:	vbroadcasti32x4 -0xac95(%rip),%zmm5        # 3280 <typeinfo name for main::$_2+0x34>
    df15:	vmovdqa64 -0xbb9f(%rip),%zmm6        # 2380 <_IO_stdin_used+0x2e4>
    df1f:	vpbroadcastd -0xbe99(%rip),%zmm7        # 2090 <__abi_tag+0x1dcc>
    df29:	vbroadcasti32x4 -0xaca3(%rip),%zmm8        # 3290 <typeinfo name for main::$_2+0x44>
    df33:	movabs $0x3ffffffc0,%r8
    df3d:	jmp    e13e <void bloom_filters::K12ScalarOrControl::InsertVector<true>(unsigned int, unsigned long const*)+0x27e>
    df42:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
    df50:	vmovdqu (%rdx,%rcx,8),%ymm9
    df55:	vpxor  %xmm10,%xmm10,%xmm10
    df5a:	vpermd %zmm9,%zmm0,%zmm10
    df60:	vprorvd %zmm2,%zmm10,%zmm10
    df66:	vpxor  %xmm11,%xmm11,%xmm11
    df6b:	vpermd %zmm9,%zmm1,%zmm11
    df71:	vpxor  %xmm9,%xmm9,%xmm9
    df76:	vpermd %zmm3,%zmm10,%zmm9
    df7c:	vpsrld $0x4,%zmm10,%zmm10
    df83:	vprolvd %zmm10,%zmm9,%zmm9
    df89:	vpsrlvd %zmm4,%zmm11,%zmm10
    df8f:	vpandd %zmm5,%zmm10,%zmm12
    df95:	vpsrld $0x8,%zmm11,%zmm10
    df9c:	vpbroadcastd %r10d,%zmm13
    dfa2:	vpmuludq %zmm10,%zmm13,%zmm10
    dfa8:	vpsrlq $0x18,%zmm10,%zmm10
    dfaf:	vpsrlq $0x28,%zmm11,%zmm14
    dfb6:	vpmuludq %zmm14,%zmm13,%zmm13
    dfbc:	vpshufb %zmm6,%zmm13,%zmm13
    dfc2:	vpord  %zmm10,%zmm13,%zmm10
    dfc8:	vpslld $0x4,%zmm10,%zmm10
    dfcf:	vpternlogd $0xf8,%zmm7,%zmm11,%zmm10
    dfd6:	vpternlogd $0x1e,%zmm8,%zmm12,%zmm10
    dfdd:	vmovd  %xmm9,%r10d
    dfe2:	vmovd  %xmm10,%r11d
    dfe7:	or     %r10d,(%r9,%r11,4)
    dfeb:	vpextrd $0x1,%xmm9,%r9d
    dff1:	vpextrd $0x1,%xmm10,%r10d
    dff7:	mov    (%rdi),%r11
    dffa:	or     %r9d,(%r11,%r10,4)
    dffe:	vpextrd $0x2,%xmm9,%r9d
    e004:	vpextrd $0x2,%xmm10,%r10d
    e00a:	mov    (%rdi),%r11
    e00d:	or     %r9d,(%r11,%r10,4)
    e011:	vpextrd $0x3,%xmm9,%r9d
    e017:	vpextrd $0x3,%xmm10,%r10d
    e01d:	mov    (%rdi),%r11
    e020:	or     %r9d,(%r11,%r10,4)
    e024:	vextracti128 $0x1,%ymm9,%xmm11
    e02a:	vmovd  %xmm11,%r9d
    e02f:	vextracti128 $0x1,%ymm10,%xmm12
    e035:	vmovd  %xmm12,%r10d
    e03a:	mov    (%rdi),%r11
    e03d:	or     %r9d,(%r11,%r10,4)
    e041:	vpextrd $0x1,%xmm11,%r9d
    e047:	vpextrd $0x1,%xmm12,%r10d
    e04d:	mov    (%rdi),%r11
    e050:	or     %r9d,(%r11,%r10,4)
    e054:	vpextrd $0x2,%xmm11,%r9d
    e05a:	vpextrd $0x2,%xmm12,%r10d
    e060:	mov    (%rdi),%r11
    e063:	or     %r9d,(%r11,%r10,4)
    e067:	vpextrd $0x3,%xmm11,%r9d
    e06d:	vpextrd $0x3,%xmm12,%r10d
    e073:	mov    (%rdi),%r11
    e076:	or     %r9d,(%r11,%r10,4)
    e07a:	vextracti32x4 $0x2,%zmm9,%xmm11
    e081:	vmovd  %xmm11,%r9d
    e086:	vextracti32x4 $0x2,%zmm10,%xmm12
    e08d:	vmovd  %xmm12,%r10d
    e092:	mov    (%rdi),%r11
    e095:	or     %r9d,(%r11,%r10,4)
    e099:	vpextrd $0x1,%xmm11,%r9d
    e09f:	vpextrd $0x1,%xmm12,%r10d
    e0a5:	mov    (%rdi),%r11
    e0a8:	or     %r9d,(%r11,%r10,4)
    e0ac:	vpextrd $0x2,%xmm11,%r9d
    e0b2:	vpextrd $0x2,%xmm12,%r10d
    e0b8:	mov    (%rdi),%r11
    e0bb:	or     %r9d,(%r11,%r10,4)
    e0bf:	vpextrd $0x3,%xmm11,%r9d
    e0c5:	vpextrd $0x3,%xmm12,%r10d
    e0cb:	mov    (%rdi),%r11
    e0ce:	or     %r9d,(%r11,%r10,4)
    e0d2:	vextracti32x4 $0x3,%zmm9,%xmm9
    e0d9:	vmovd  %xmm9,%r9d
    e0de:	vextracti32x4 $0x3,%zmm10,%xmm10
    e0e5:	vmovd  %xmm10,%r10d
    e0ea:	mov    (%rdi),%r11
    e0ed:	or     %r9d,(%r11,%r10,4)
    e0f1:	vpextrd $0x1,%xmm9,%r9d
    e0f7:	vpextrd $0x1,%xmm10,%r10d
    e0fd:	mov    (%rdi),%r11
    e100:	or     %r9d,(%r11,%r10,4)
    e104:	vpextrd $0x2,%xmm9,%r9d
    e10a:	vpextrd $0x2,%xmm10,%r10d
    e110:	mov    (%rdi),%r11
    e113:	or     %r9d,(%r11,%r10,4)
    e117:	vpextrd $0x3,%xmm9,%r9d
    e11d:	vpextrd $0x3,%xmm10,%r10d
    e123:	mov    (%rdi),%r11
    e126:	or     %r9d,(%r11,%r10,4)
    e12a:	lea    0x4(%rcx),%r9
    e12e:	add    $0x8,%rcx
    e132:	cmp    %rax,%rcx
    e135:	mov    %r9,%rcx
    e138:	ja     e1fb <void bloom_filters::K12ScalarOrControl::InsertVector<true>(unsigned int, unsigned long const*)+0x33b>
    e13e:	lea    0x44(%rcx),%r11
    e142:	mov    0x18(%rdi),%r10d
    e146:	mov    (%rdi),%r9
    e149:	cmp    %rax,%r11
    e14c:	ja     df50 <void bloom_filters::K12ScalarOrControl::InsertVector<true>(unsigned int, unsigned long const*)+0x90>
    e152:	mov    0x200(%rdx,%rcx,8),%r11
    e15a:	mov    %r11,%rbx
    e15d:	shr    $0x20,%rbx
    e161:	shr    $0x28,%r11
    e165:	imul   %r10,%r11
    e169:	and    $0x3,%ebx
    e16c:	shr    $0x12,%r11
    e170:	and    %r8,%r11
    e173:	add    %r9,%r11
    e176:	prefetchw (%r11,%rbx,4)
    e17b:	mov    0x208(%rdx,%rcx,8),%r11
    e183:	mov    %r11,%rbx
    e186:	shr    $0x20,%rbx
    e18a:	shr    $0x28,%r11
    e18e:	imul   %r10,%r11
    e192:	and    $0x3,%ebx
    e195:	shr    $0x12,%r11
    e199:	and    %r8,%r11
    e19c:	add    %r9,%r11
    e19f:	prefetchw (%r11,%rbx,4)
    e1a4:	mov    0x210(%rdx,%rcx,8),%r11
    e1ac:	mov    %r11,%rbx
    e1af:	shr    $0x20,%rbx
    e1b3:	shr    $0x28,%r11
    e1b7:	imul   %r10,%r11
    e1bb:	and    $0x3,%ebx
    e1be:	shr    $0x12,%r11
    e1c2:	and    %r8,%r11
    e1c5:	add    %r9,%r11
    e1c8:	prefetchw (%r11,%rbx,4)
    e1cd:	mov    0x218(%rdx,%rcx,8),%r11
    e1d5:	mov    %r11,%rbx
    e1d8:	shr    $0x20,%rbx
    e1dc:	shr    $0x28,%r11
    e1e0:	imul   %r10,%r11
    e1e4:	and    $0x3,%ebx
    e1e7:	shr    $0x12,%r11
    e1eb:	and    %r8,%r11
    e1ee:	add    %r9,%r11
    e1f1:	prefetchw (%r11,%rbx,4)
    e1f6:	jmp    df50 <void bloom_filters::K12ScalarOrControl::InsertVector<true>(unsigned int, unsigned long const*)+0x90>
    e1fb:	pop    %rbx
    e1fc:	sub    %r9d,%esi
    e1ff:	lea    (%rdx,%r9,8),%rdx
    e203:	vzeroupper
    e206:	jmp    e4a0 <bloom_filters::K12ScalarOrControl::InsertScalar(unsigned int, unsigned long const*)>
