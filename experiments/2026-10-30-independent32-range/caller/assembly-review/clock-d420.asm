    ef86:	add    $0x8,%r8
    ef8a:	cmp    %r8,%r9
    ef8d:	jne    ef80 <_Z3RunIN13bloom_filters24Independent32BloomFilterEEvRK5PointRK4CaseRK5Input+0x1b60>
    ef8f:	cmp    %r9,%rdi
    ef92:	je     efaf <_Z3RunIN13bloom_filters24Independent32BloomFilterEEvRK5PointRK4CaseRK5Input+0x1b8f>
    ef94:	lea    0x40(%rcx,%rax,4),%rax
    ef99:	nopl   0x0(%rax)
    efa0:	movl   $0x2,(%rsi)
    efa6:	add    $0x4,%rsi
    efaa:	cmp    %rax,%rsi
    efad:	jne    efa0 <_Z3RunIN13bloom_filters24Independent32BloomFilterEEvRK5PointRK4CaseRK5Input+0x1b80>
    efaf:	vzeroupper
    efb2:	call   2eab0 <_ZNSt6chrono3_V212steady_clock3nowEv@plt>
    efb7:	mov    %rax,0x98(%rsp)
    efbf:	mov    %r15,%rbx
    efc2:	cmp    $0x3,%r15d
    efc6:	ja     f3f0 <_Z3RunIN13bloom_filters24Independent32BloomFilterEEvRK5PointRK4CaseRK5Input+0x1fd0>
    efcc:	mov    %ebx,%eax
    efce:	lea    -0xd4b5(%rip),%rcx        # 1b20 <_IO_stdin_used+0x440>
    efd5:	movslq (%rcx,%rax,4),%rax
    efd9:	add    %rcx,%rax
    efdc:	jmp    *%rax
    efde:	mov    0x58(%rsp),%rax
    efe3:	cmp    %rax,0x60(%rsp)
    efe8:	mov    0x28(%rsp),%r12
    efed:	je     f3f0 <_Z3RunIN13bloom_filters24Independent32BloomFilterEEvRK5PointRK4CaseRK5Input+0x1fd0>
    eff3:	mov    0x10(%rsp),%rax
    eff8:	mov    0xc(%rax),%eax
    effb:	xor    %r15d,%r15d
    effe:	xchg   %ax,%ax
    f000:	mov    %eax,%eax
    f002:	mov    %r12,%rsi
    f005:	sub    %r15,%rsi
    f008:	cmp    %rax,%rsi
    f00b:	cmovae %rax,%rsi
    f00f:	lea    0x0(,%r15,8),%rdx
    f017:	mov    0x8(%rsp),%rax
    f01c:	add    0x48(%rax),%rdx
    f020:	mov    0x30(%rsp),%rax
    f025:	lea    0x40(%rax,%r15,4),%rcx
    f02a:	mov    %rbp,%rdi
    f02d:	call   27400 <_Z13lookup_kernelIN13bloom_filters24Independent32BloomFilterEmEvRT_mPKT0_Pj>
    f032:	mov    0x10(%rsp),%rax
    f037:	mov    0xc(%rax),%eax
    f03a:	add    %rax,%r15
    f03d:	cmp    %r12,%r15
    f040:	jb     f000 <_Z3RunIN13bloom_filters24Independent32BloomFilterEEvRK5PointRK4CaseRK5Input+0x1be0>
    f042:	jmp    f3f0 <_Z3RunIN13bloom_filters24Independent32BloomFilterEEvRK5PointRK4CaseRK5Input+0x1fd0>
    f047:	mov    0x8(%rsp),%rax
    f04c:	mov    0x48(%rax),%rdx
    f050:	mov    0x30(%rsp),%rcx
    f055:	add    $0x40,%rcx
    f059:	mov    %rbp,%rdi
    f05c:	mov    0x28(%rsp),%rsi
    f061:	call   275d0 <_Z20inline_single_kernelILb0EN13bloom_filters24Independent32BloomFilterEmEvRKT0_mPKmPj>
    f066:	jmp    f3f0 <_Z3RunIN13bloom_filters24Independent32BloomFilterEEvRK5PointRK4CaseRK5Input+0x1fd0>
    f06b:	mov    0x8(%rsp),%rax
    f070:	mov    0x18(%rax),%rdx
    f074:	mov    0x30(%rsp),%rcx
    f079:	add    $0x40,%rcx
    f07d:	mov    %rbp,%rdi
    f080:	mov    0x28(%rsp),%rsi
    f085:	call   277a0 <_Z20inline_single_kernelILb1EN13bloom_filters24Independent32BloomFilterEmEvRKT0_mPKmPj>
    f08a:	jmp    f3f0 <_Z3RunIN13bloom_filters24Independent32BloomFilterEEvRK5PointRK4CaseRK5Input+0x1fd0>
    f08f:	mov    0x58(%rsp),%rax
    f094:	cmp    %rax,0x60(%rsp)
    f099:	mov    0x28(%rsp),%rsi
    f09e:	je     f3f0 <_Z3RunIN13bloom_filters24Independent32BloomFilterEEvRK5PointRK4CaseRK5Input+0x1fd0>
    f0a4:	mov    0x10(%rsp),%rax
    f0a9:	mov    0xc(%rax),%eax
    f0ac:	xor    %r12d,%r12d
    f0af:	nop
    f0b0:	mov    %eax,%eax
    f0b2:	sub    %r12,%rsi
    f0b5:	cmp    %rax,%rsi
    f0b8:	cmovae %rax,%rsi
    f0bc:	test   %rsi,%rsi
    f0bf:	je     f21b <_Z3RunIN13bloom_filters24Independent32BloomFilterEEvRK5PointRK4CaseRK5Input+0x1dfb>
    f0c5:	mov    0x8(%rsp),%rax
    f0ca:	mov    0x18(%rax),%rax
    f0ce:	lea    (%rax,%r12,8),%rcx
    f0d2:	cmp    $0x4,%rsi
    f0d6:	jb     f0eb <_Z3RunIN13bloom_filters24Independent32BloomFilterEEvRK5PointRK4CaseRK5Input+0x1ccb>
    f0d8:	mov    %r14,%rdx
    f0db:	sub    %rcx,%rdx
    f0de:	cmp    $0x80,%rdx
    f0e5:	jae    f251 <_Z3RunIN13bloom_filters24Independent32BloomFilterEEvRK5PointRK4CaseRK5Input+0x1e31>
    f0eb:	xor    %edx,%edx
    f0ed:	mov    %rsi,%r8
    f0f0:	mov    %rdx,%rdi
    f0f3:	and    $0x3,%r8
    f0f7:	je     f136 <_Z3RunIN13bloom_filters24Independent32BloomFilterEEvRK5PointRK4CaseRK5Input+0x1d16>
    f0f9:	mov    %rdx,%rdi
    f0fc:	nopl   0x0(%rax)
    f100:	mov    (%rcx,%rdi,8),%r9
    f104:	mov    %r9,%r10
    f107:	shr    $0x20,%r10
    f10b:	xor    %r9,%r10
    f10e:	imul   %r13,%r10
    f112:	mov    %r10,%r9
    f115:	shr    $0x20,%r9
    f119:	xor    %r10,%r9
    f11c:	imul   %r13,%r9
    f120:	mov    %r9,%r10
    f123:	shr    $0x20,%r10
    f127:	xor    %r9,%r10
    f12a:	mov    %r10,(%r14,%rdi,8)
    f12e:	inc    %rdi
    f131:	dec    %r8
    f134:	jne    f100 <_Z3RunIN13bloom_filters24Independent32BloomFilterEEvRK5PointRK4CaseRK5Input+0x1ce0>
    f136:	sub    %rsi,%rdx
    f139:	cmp    $0xfffffffffffffffc,%rdx
    f13d:	ja     f21b <_Z3RunIN13bloom_filters24Independent32BloomFilterEEvRK5PointRK4CaseRK5Input+0x1dfb>
    f143:	lea    0x18(%rax,%r12,8),%rax
    f148:	nopl   0x0(%rax,%rax,1)
    f150:	mov    -0x18(%rax,%rdi,8),%rcx
    f155:	mov    %rcx,%rdx
    f158:	shr    $0x20,%rdx
    f15c:	xor    %rcx,%rdx
    f15f:	imul   %r13,%rdx
    f163:	mov    %rdx,%rcx
    f166:	shr    $0x20,%rcx
    f16a:	xor    %rdx,%rcx
    f16d:	imul   %r13,%rcx
    f171:	mov    %rcx,%rdx
    f174:	shr    $0x20,%rdx
    f178:	xor    %rcx,%rdx
    f17b:	mov    %rdx,(%r14,%rdi,8)
    f17f:	mov    -0x10(%rax,%rdi,8),%rcx
    f184:	mov    %rcx,%rdx
    f187:	shr    $0x20,%rdx
    f18b:	xor    %rcx,%rdx
    f18e:	imul   %r13,%rdx
    f192:	mov    %rdx,%rcx
    f195:	shr    $0x20,%rcx
    f199:	xor    %rdx,%rcx
    f19c:	imul   %r13,%rcx
    f1a0:	mov    %rcx,%rdx
    f1a3:	shr    $0x20,%rdx
    f1a7:	xor    %rcx,%rdx
    f1aa:	mov    %rdx,0x8(%r14,%rdi,8)
    f1af:	mov    -0x8(%rax,%rdi,8),%rcx
    f1b4:	mov    %rcx,%rdx
    f1b7:	shr    $0x20,%rdx
    f1bb:	xor    %rcx,%rdx
    f1be:	imul   %r13,%rdx
    f1c2:	mov    %rdx,%rcx
    f1c5:	shr    $0x20,%rcx
    f1c9:	xor    %rdx,%rcx
    f1cc:	imul   %r13,%rcx
    f1d0:	mov    %rcx,%rdx
    f1d3:	shr    $0x20,%rdx
    f1d7:	xor    %rcx,%rdx
    f1da:	mov    %rdx,0x10(%r14,%rdi,8)
    f1df:	mov    (%rax,%rdi,8),%rcx
    f1e3:	mov    %rcx,%rdx
    f1e6:	shr    $0x20,%rdx
    f1ea:	xor    %rcx,%rdx
    f1ed:	imul   %r13,%rdx
    f1f1:	mov    %rdx,%rcx
    f1f4:	shr    $0x20,%rcx
    f1f8:	xor    %rdx,%rcx
    f1fb:	imul   %r13,%rcx
    f1ff:	mov    %rcx,%rdx
    f202:	shr    $0x20,%rdx
    f206:	xor    %rcx,%rdx
    f209:	mov    %rdx,0x18(%r14,%rdi,8)
    f20e:	add    $0x4,%rdi
    f212:	cmp    %rdi,%rsi
    f215:	jne    f150 <_Z3RunIN13bloom_filters24Independent32BloomFilterEEvRK5PointRK4CaseRK5Input+0x1d30>
    f21b:	mov    0x30(%rsp),%rax
    f220:	lea    0x40(%rax,%r12,4),%rcx
    f225:	mov    %rbp,%rdi
    f228:	mov    %r14,%rdx
    f22b:	vzeroupper
    f22e:	call   27400 <_Z13lookup_kernelIN13bloom_filters24Independent32BloomFilterEmEvRT_mPKT0_Pj>
    f233:	mov    0x10(%rsp),%rax
    f238:	mov    0xc(%rax),%eax
    f23b:	add    %rax,%r12
    f23e:	mov    0x28(%rsp),%rsi
    f243:	cmp    %rsi,%r12
    f246:	jb     f0b0 <_Z3RunIN13bloom_filters24Independent32BloomFilterEEvRK5PointRK4CaseRK5Input+0x1c90>
    f24c:	jmp    f3f0 <_Z3RunIN13bloom_filters24Independent32BloomFilterEEvRK5PointRK4CaseRK5Input+0x1fd0>
    f251:	cmp    $0x10,%rsi
    f255:	jae    f25e <_Z3RunIN13bloom_filters24Independent32BloomFilterEEvRK5PointRK4CaseRK5Input+0x1e3e>
    f257:	xor    %edx,%edx
    f259:	jmp    f382 <_Z3RunIN13bloom_filters24Independent32BloomFilterEEvRK5PointRK4CaseRK5Input+0x1f62>
    f25e:	lea    0x0(,%r12,8),%r8
    f266:	mov    %esi,%edx
    f268:	and    $0xfffffff0,%edx
    f26b:	lea    0x0(,%rsi,8),%rdi
    f273:	and    $0xffffffffffffff80,%rdi
    f277:	lea    0x60(%rax,%r8,1),%r8
    f27c:	xor    %r9d,%r9d
    f27f:	vpbroadcastq -0xd8b8(%rip),%ymm8        # 19d0 <_IO_stdin_used+0x2f0>
    f288:	nopl   0x0(%rax,%rax,1)
    f290:	vmovdqu -0x60(%r8,%r9,1),%ymm0
    f297:	vmovdqu -0x40(%r8,%r9,1),%ymm1
    f29e:	vmovdqu -0x20(%r8,%r9,1),%ymm2
    f2a5:	vmovdqu (%r8,%r9,1),%ymm3
    f2ab:	vpsrlq $0x20,%ymm0,%ymm4
    f2b0:	vpsrlq $0x20,%ymm1,%ymm5
    f2b5:	vpsrlq $0x20,%ymm2,%ymm6
    f2ba:	vpsrlq $0x20,%ymm3,%ymm7
    f2bf:	vpxor  %ymm0,%ymm4,%ymm0
    f2c3:	vpxor  %ymm1,%ymm5,%ymm1
    f2c7:	vpxor  %ymm2,%ymm6,%ymm2
    f2cb:	vpmullq %ymm8,%ymm0,%ymm0
    f2d1:	vpmullq %ymm8,%ymm1,%ymm1
    f2d7:	vpmullq %ymm8,%ymm2,%ymm2
    f2dd:	vpxor  %ymm3,%ymm7,%ymm3
    f2e1:	vpmullq %ymm8,%ymm3,%ymm3
    f2e7:	vpsrlq $0x20,%ymm0,%ymm4
    f2ec:	vpsrlq $0x20,%ymm1,%ymm5
    f2f1:	vpsrlq $0x20,%ymm2,%ymm6
    f2f6:	vpsrlq $0x20,%ymm3,%ymm7
    f2fb:	vpxor  %ymm0,%ymm4,%ymm0
    f2ff:	vpxor  %ymm1,%ymm5,%ymm1
    f303:	vpxor  %ymm2,%ymm6,%ymm2
    f307:	vpxor  %ymm3,%ymm7,%ymm3
    f30b:	vpmullq %ymm8,%ymm0,%ymm0
    f311:	vpmullq %ymm8,%ymm1,%ymm1
    f317:	vpmullq %ymm8,%ymm2,%ymm2
    f31d:	vpmullq %ymm8,%ymm3,%ymm3
    f323:	vpsrlq $0x20,%ymm0,%ymm4
    f328:	vpsrlq $0x20,%ymm1,%ymm5
    f32d:	vpsrlq $0x20,%ymm2,%ymm6
    f332:	vpsrlq $0x20,%ymm3,%ymm7
    f337:	vpxor  %ymm0,%ymm4,%ymm0
    f33b:	vpxor  %ymm1,%ymm5,%ymm1
    f33f:	vpxor  %ymm2,%ymm6,%ymm2
    f343:	vpxor  %ymm3,%ymm7,%ymm3
    f347:	vmovdqu %ymm0,(%r14,%r9,1)
    f34d:	vmovdqu %ymm1,0x20(%r14,%r9,1)
    f354:	vmovdqu %ymm2,0x40(%r14,%r9,1)
    f35b:	vmovdqu %ymm3,0x60(%r14,%r9,1)
    f362:	sub    $0xffffffffffffff80,%r9
    f366:	cmp    %r9,%rdi
    f369:	jne    f290 <_Z3RunIN13bloom_filters24Independent32BloomFilterEEvRK5PointRK4CaseRK5Input+0x1e70>
    f36f:	cmp    %rdx,%rsi
    f372:	je     f21b <_Z3RunIN13bloom_filters24Independent32BloomFilterEEvRK5PointRK4CaseRK5Input+0x1dfb>
    f378:	test   $0xc,%sil
    f37c:	je     f0ed <_Z3RunIN13bloom_filters24Independent32BloomFilterEEvRK5PointRK4CaseRK5Input+0x1ccd>
    f382:	mov    %rdx,%rdi
    f385:	mov    %esi,%edx
    f387:	and    $0xfffffffc,%edx
    f38a:	vpbroadcastq -0xd9c3(%rip),%ymm2        # 19d0 <_IO_stdin_used+0x2f0>
    f393:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
    f3a0:	vmovdqu (%rcx,%rdi,8),%ymm0
    f3a5:	vpsrlq $0x20,%ymm0,%ymm1
    f3aa:	vpxor  %ymm0,%ymm1,%ymm0
    f3ae:	vpmullq %ymm2,%ymm0,%ymm0
    f3b4:	vpsrlq $0x20,%ymm0,%ymm1
    f3b9:	vpxor  %ymm0,%ymm1,%ymm0
    f3bd:	vpmullq %ymm2,%ymm0,%ymm0
    f3c3:	vpsrlq $0x20,%ymm0,%ymm1
    f3c8:	vpxor  %ymm0,%ymm1,%ymm0
    f3cc:	vmovdqu %ymm0,(%r14,%rdi,8)
    f3d2:	add    $0x4,%rdi
    f3d6:	cmp    %rdi,%rdx
    f3d9:	jne    f3a0 <_Z3RunIN13bloom_filters24Independent32BloomFilterEEvRK5PointRK4CaseRK5Input+0x1f80>
    f3db:	cmp    %rdx,%rsi
    f3de:	je     f21b <_Z3RunIN13bloom_filters24Independent32BloomFilterEEvRK5PointRK4CaseRK5Input+0x1dfb>
    f3e4:	jmp    f0ed <_Z3RunIN13bloom_filters24Independent32BloomFilterEEvRK5PointRK4CaseRK5Input+0x1ccd>
    f3e9:	nopl   0x0(%rax)
    f3f0:	call   2eab0 <_ZNSt6chrono3_V212steady_clock3nowEv@plt>
    f3f5:	sub    0x98(%rsp),%rax
    f3fd:	vcvtsi2sd %rax,%xmm15,%xmm0
    f402:	vdivsd 0x148(%rsp),%xmm0,%xmm0
    f40b:	vmovq  %xmm0,%rax
    f410:	mov    $0x3f,%cl
    f412:	bzhi   %rcx,%rax,%rcx
    f417:	movabs $0xfff0000000000000,%rdx
    f421:	add    %rdx,%rcx
    f424:	shr    $0x35,%rcx
    f428:	cmp    $0x3ff,%ecx
    f42e:	setb   %cl
    f431:	test   %rax,%rax
    f434:	setns  %dl
    f437:	and    %cl,%dl
    f439:	dec    %rax
    f43c:	movabs $0xfffffffffffff,%rcx
    f446:	cmp    %rcx,%rax
    f449:	setb   %al
    f44c:	or     %dl,%al
    f44e:	je     1037f <_Z3RunIN13bloom_filters24Independent32BloomFilterEEvRK5PointRK4CaseRK5Input+0x2f5f>
    f454:	lea    (%rbx,%rbx,2),%rax
    f458:	lea    0x160(%rsp,%rax,8),%rcx
    f460:	mov    0x168(%rsp,%rax,8),%rbx
    f468:	cmp    0x170(%rsp,%rax,8),%rbx
    f470:	je     f490 <_Z3RunIN13bloom_filters24Independent32BloomFilterEEvRK5PointRK4CaseRK5Input+0x2070>
    f472:	vmovsd %xmm0,(%rbx)
    f476:	add    $0x8,%rbx
    f47a:	mov    %rbx,0x8(%rcx)
    f47e:	jmp    f548 <_Z3RunIN13bloom_filters24Independent32BloomFilterEEvRK5PointRK4CaseRK5Input+0x2128>
    f483:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
    f490:	mov    (%rcx),%r15
    f493:	sub    %r15,%rbx
    f496:	movabs $0x7ffffffffffffff8,%rax
    f4a0:	cmp    %rax,%rbx
    f4a3:	je     103c0 <_Z3RunIN13bloom_filters24Independent32BloomFilterEEvRK5PointRK4CaseRK5Input+0x2fa0>
    f4a9:	mov    %rcx,0x138(%rsp)
    f4b1:	vmovsd %xmm0,0x98(%rsp)
    f4ba:	mov    %rbx,%rax
    f4bd:	sar    $0x3,%rax
    f4c1:	cmp    $0x1,%rax
    f4c5:	mov    %rax,%rcx
    f4c8:	adc    $0x0,%rcx
    f4cc:	lea    (%rcx,%rax,1),%r12
    f4d0:	movabs $0xfffffffffffffff,%rdx
    f4da:	cmp    %rdx,%r12
    f4dd:	cmovae %rdx,%r12
    f4e1:	add    %rax,%rcx
    f4e4:	cmovb  %rdx,%r12
    f4e8:	lea    0x0(,%r12,8),%rdi
    f4f0:	call   2ea50 <_Znwm@plt>
    f4f5:	mov    %rax,%rbp
    f4f8:	vmovsd 0x98(%rsp),%xmm0
    f501:	vmovsd %xmm0,(%rax,%rbx,1)
    f506:	test   %rbx,%rbx
    f509:	jle    f519 <_Z3RunIN13bloom_filters24Independent32BloomFilterEEvRK5PointRK4CaseRK5Input+0x20f9>
    f50b:	mov    %rbp,%rdi
    f50e:	mov    %r15,%rsi
    f511:	mov    %rbx,%rdx
    f514:	call   2ea70 <memmove@plt>
    f519:	test   %r15,%r15
    f51c:	je     f529 <_Z3RunIN13bloom_filters24Independent32BloomFilterEEvRK5PointRK4CaseRK5Input+0x2109>
    f51e:	mov    %r15,%rdi
    f521:	mov    %rbx,%rsi
    f524:	call   2ea60 <_ZdlPvm@plt>
    f529:	add    %rbp,%rbx
    f52c:	mov    0x138(%rsp),%rcx
    f534:	mov    %rbp,(%rcx)
    f537:	add    $0x8,%rbx
    f53b:	mov    %rbx,0x8(%rcx)
    f53f:	lea    0x0(%rbp,%r12,8),%rax
    f544:	mov    %rax,0x10(%rcx)
    f548:	lea    0x30(%rsp),%rdi
    f54d:	lea    0xa0(%rsp),%rsi
    f555:	call   26830 <_ZN6Output5CheckERKSt6vectorIjSaIjEE>
    f55a:	mov    0xd0(%rsp),%r12
