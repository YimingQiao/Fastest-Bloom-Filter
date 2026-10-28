00000000000b2fe0 <void inline_single_kernel<false, external_bloom::Page<6u, false>, unsigned long>(external_bloom::Page<6u, false> const&, unsigned long, unsigned long const*, unsigned int*)>:
   b2fe0:	test   %rsi,%rsi
   b2fe3:	je     b3161 <void inline_single_kernel<false, external_bloom::Page<6u, false>, unsigned long>(external_bloom::Page<6u, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x181>
   b2fe9:	push   %rbp
   b2fea:	push   %r15
   b2fec:	push   %r14
   b2fee:	push   %rbx
   b2fef:	mov    %rdx,%rax
   b2ff2:	xor    %r8d,%r8d
   b2ff5:	movabs $0xdeadbeefdeadbeef,%r9
   b2fff:	movabs $0xe6adbeefdeadbeef,%r10
   b3009:	mov    $0xffffffff,%r11d
   b300f:	vbroadcasti128 -0xae428(%rip),%ymm0        # 4bf0 <typeinfo name for main::$_60+0x420>
   b3018:	vpbroadcastd -0xafd7d(%rip),%ymm1        # 32a4 <__abi_tag+0x2fe0>
   b3021:	vpbroadcastd -0xafd82(%rip),%ymm2        # 32a8 <__abi_tag+0x2fe4>
   b302a:	nopw   0x0(%rax,%rax,1)
   b3030:	mov    (%rax,%r8,8),%rdx
   b3034:	add    %r9,%rdx
   b3037:	rorx   $0x31,%rdx,%rbx
   b303d:	xor    %r10,%rdx
   b3040:	add    %rbx,%rdx
   b3043:	rorx   $0xc,%rdx,%r14
   b3049:	add    %r14,%rdx
   b304c:	rorx   $0x26,%rdx,%r15
   b3052:	add    %r15,%rdx
   b3055:	xor    %rdx,%rbx
   b3058:	rorx   $0xd,%rdx,%rdx
   b305e:	add    %rdx,%rbx
   b3061:	xor    %rbx,%r14
   b3064:	rorx   $0x24,%rbx,%rbx
   b306a:	add    %rbx,%r14
   b306d:	xor    %r14,%r15
   b3070:	rorx   $0x37,%r14,%r14
   b3076:	add    %r14,%r15
   b3079:	xor    %r15,%rdx
   b307c:	rorx   $0x11,%r15,%r15
   b3082:	add    %r15,%rdx
   b3085:	xor    %rdx,%rbx
   b3088:	rorx   $0xa,%rdx,%rdx
   b308e:	add    %rdx,%rbx
   b3091:	xor    %rbx,%r14
   b3094:	rorx   $0x20,%rbx,%rbx
   b309a:	add    %r14,%rbx
   b309d:	xor    %rbx,%r15
   b30a0:	rorx   $0x27,%rbx,%rbx
   b30a6:	add    %r15,%rbx
   b30a9:	xor    %rbx,%rdx
   b30ac:	rorx   $0x1,%rbx,%rbx
   b30b2:	add    %rbx,%rdx
   b30b5:	rorx   $0x18,%ebx,%ebp
   b30bb:	vmovq  %rbx,%xmm3
   b30c0:	shr    $0x20,%rbx
   b30c4:	rorx   $0x1c,%edx,%r14d
   b30ca:	vmovq  %rdx,%xmm4
   b30cf:	shr    $0x20,%rdx
   b30d3:	rorx   $0x1a,%ebx,%ebx
   b30d9:	xor    %ebp,%ebx
   b30db:	xor    %ebx,%r14d
   b30de:	rorx   $0x1e,%edx,%edx
   b30e4:	xor    %r14d,%edx
   b30e7:	mov    0x8(%rdi),%ebx
   b30ea:	imul   0x10(%rdi),%rdx
   b30ef:	mulx   %rbx,%rdx,%rdx
   b30f4:	movzbl (%rdi),%ebx
   b30f7:	shlx   %rbx,%rdx,%rdx
   b30fc:	add    0x20(%rdi),%rdx
   b3100:	vpunpcklqdq %xmm4,%xmm3,%xmm3
   b3104:	add    $0x3,%bl
   b3107:	shlx   %ebx,%r11d,%ebx
   b310c:	vpbroadcastd %ebx,%ymm4
   b3112:	vpsrld $0x10,%xmm3,%xmm5
   b3117:	vinserti128 $0x1,%xmm5,%ymm3,%ymm3
   b311d:	vpandn %ymm3,%ymm4,%ymm3
   b3121:	vpsrld $0x5,%ymm3,%ymm4
   b3126:	vmovdqa %ymm0,%ymm5
   b312a:	vpcmpeqd %ymm6,%ymm6,%ymm6
   b312e:	vpgatherdd %ymm5,(%rdx,%ymm4,4),%ymm6
   b3134:	vpand  %ymm1,%ymm3,%ymm3
   b3138:	vpsllvd %ymm3,%ymm2,%ymm3
   b313d:	vpandn %ymm3,%ymm6,%ymm4
   b3141:	xor    %edx,%edx
   b3143:	vptest %ymm3,%ymm4
   b3148:	sete   %dl
   b314b:	mov    %edx,(%rcx,%r8,4)
   b314f:	inc    %r8
   b3152:	cmp    %r8,%rsi
   b3155:	jne    b3030 <void inline_single_kernel<false, external_bloom::Page<6u, false>, unsigned long>(external_bloom::Page<6u, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
   b315b:	pop    %rbx
   b315c:	pop    %r14
   b315e:	pop    %r15
   b3160:	pop    %rbp
   b3161:	vzeroupper
   b3164:	ret
   b3165:	int3
   b3166:	int3
   b3167:	int3
   b3168:	int3
   b3169:	int3
   b316a:	int3
   b316b:	int3
   b316c:	int3
   b316d:	int3
   b316e:	int3
   b316f:	int3

