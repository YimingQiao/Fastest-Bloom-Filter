00000000000940a0 <void inline_single_kernel<true, external_bloom::Classical<11, true, false>, unsigned long>(external_bloom::Classical<11, true, false> const&, unsigned long, unsigned long const*, unsigned int*)>:
   940a0:	push   %rbp
   940a1:	push   %r15
   940a3:	push   %r14
   940a5:	push   %r13
   940a7:	push   %r12
   940a9:	push   %rbx
   940aa:	mov    %rcx,-0x20(%rsp)
   940af:	mov    %rdx,-0x28(%rsp)
   940b4:	mov    %rdi,-0x38(%rsp)
   940b9:	mov    %rsi,-0x30(%rsp)
   940be:	test   %rsi,%rsi
   940c1:	je     942bd <void inline_single_kernel<true, external_bloom::Classical<11, true, false>, unsigned long>(external_bloom::Classical<11, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x21d>
   940c7:	xor    %ebp,%ebp
   940c9:	jmp    940e6 <void inline_single_kernel<true, external_bloom::Classical<11, true, false>, unsigned long>(external_bloom::Classical<11, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x46>
   940cb:	nopl   0x0(%rax,%rax,1)
   940d0:	mov    -0x20(%rsp),%rax
   940d5:	mov    %edx,(%rax,%rbp,4)
   940d8:	inc    %rbp
   940db:	cmp    %rbp,-0x30(%rsp)
   940e0:	je     942bd <void inline_single_kernel<true, external_bloom::Classical<11, true, false>, unsigned long>(external_bloom::Classical<11, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x21d>
   940e6:	mov    -0x28(%rsp),%rax
   940eb:	mov    (%rax,%rbp,8),%rax
   940ef:	mov    %rax,%rcx
   940f2:	shr    $0x20,%rcx
   940f6:	xor    %rax,%rcx
   940f9:	movabs $0xd6e8feb86659fd93,%rdx
   94103:	imul   %rdx,%rcx
   94107:	mov    %rcx,%rax
   9410a:	shr    $0x20,%rax
   9410e:	xor    %rcx,%rax
   94111:	imul   %rdx,%rax
   94115:	mov    %rax,%r8
   94118:	shr    $0x20,%r8
   9411c:	xor    %rax,%r8
   9411f:	rorx   $0x20,%r8,%r11
   94125:	mov    -0x38(%rsp),%rcx
   9412a:	mov    (%rcx),%rax
   9412d:	mov    0x10(%rcx),%r14
   94131:	mov    %r14,%rdx
   94134:	mulx   %r11,%rcx,%rcx
   94139:	shrx   %r11,(%rax,%rcx,8),%rcx
   9413f:	add    %r8,%r11
   94142:	mulx   %r11,%rdx,%rdx
   94147:	shrx   %r11,(%rax,%rdx,8),%rsi
   9414d:	add    %r8,%r11
   94150:	mov    %r11,%rdx
   94153:	mulx   %r14,%rdx,%rdx
   94158:	shrx   %r11,(%rax,%rdx,8),%rdi
   9415e:	and    %ecx,%esi
   94160:	and    %esi,%edi
   94162:	add    %r8,%r11
   94165:	lea    (%r11,%r8,1),%r13
   94169:	lea    0x0(%r13,%r8,1),%r12
   9416e:	lea    (%r12,%r8,1),%r15
   94172:	lea    (%r15,%r8,1),%rbx
   94176:	lea    (%rbx,%r8,1),%r10
   9417a:	lea    (%r10,%r8,1),%r9
   9417e:	add    %r9,%r8
   94181:	mov    %r13,%rdx
   94184:	mulx   %r14,%rcx,%rcx
   94189:	mov    %r12,%rdx
   9418c:	mulx   %r14,%rsi,%rsi
   94191:	mov    %r15,%rdx
   94194:	mulx   %r14,%rdx,%rdx
   94199:	mov    %rdx,-0x8(%rsp)
   9419e:	mov    %rbx,%rdx
   941a1:	mulx   %r14,%rdx,%rdx
   941a6:	mov    %rdx,-0x10(%rsp)
   941ab:	mov    %r10,%rdx
   941ae:	mulx   %r14,%rdx,%rdx
   941b3:	mov    %rdx,-0x18(%rsp)
   941b8:	mov    %r9,%rdx
   941bb:	mulx   %r14,%rdx,%rdx
   941c0:	mov    %rdx,-0x40(%rsp)
   941c5:	mov    %r8,%rdx
   941c8:	mulx   %r14,%rdx,%rdx
   941cd:	mov    %rdx,-0x48(%rsp)
   941d2:	mov    $0x0,%edx
   941d7:	test   $0x1,%dil
   941db:	je     940d0 <void inline_single_kernel<true, external_bloom::Classical<11, true, false>, unsigned long>(external_bloom::Classical<11, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   941e1:	mov    %r11,%rdx
   941e4:	mulx   %r14,%rdx,%rdx
   941e9:	mov    (%rax,%rdx,8),%rdx
   941ed:	bt     %r11,%rdx
   941f1:	mov    $0x0,%edx
   941f6:	jae    940d0 <void inline_single_kernel<true, external_bloom::Classical<11, true, false>, unsigned long>(external_bloom::Classical<11, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   941fc:	mov    $0x1,%edx
   94201:	shlx   %r13,%rdx,%rdi
   94206:	mov    $0x0,%edx
   9420b:	test   %rdi,(%rax,%rcx,8)
   9420f:	je     940d0 <void inline_single_kernel<true, external_bloom::Classical<11, true, false>, unsigned long>(external_bloom::Classical<11, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   94215:	mov    $0x1,%ecx
   9421a:	shlx   %r12,%rcx,%rcx
   9421f:	mov    $0x0,%edx
   94224:	test   %rcx,(%rax,%rsi,8)
   94228:	je     940d0 <void inline_single_kernel<true, external_bloom::Classical<11, true, false>, unsigned long>(external_bloom::Classical<11, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   9422e:	mov    $0x1,%ecx
   94233:	shlx   %r15,%rcx,%rcx
   94238:	mov    $0x0,%edx
   9423d:	mov    -0x8(%rsp),%rsi
   94242:	test   %rcx,(%rax,%rsi,8)
   94246:	je     940d0 <void inline_single_kernel<true, external_bloom::Classical<11, true, false>, unsigned long>(external_bloom::Classical<11, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   9424c:	mov    $0x1,%ecx
   94251:	shlx   %rbx,%rcx,%rcx
   94256:	mov    $0x0,%edx
   9425b:	mov    -0x10(%rsp),%rsi
   94260:	test   %rcx,(%rax,%rsi,8)
   94264:	je     940d0 <void inline_single_kernel<true, external_bloom::Classical<11, true, false>, unsigned long>(external_bloom::Classical<11, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   9426a:	mov    $0x1,%ecx
   9426f:	shlx   %r10,%rcx,%rcx
   94274:	mov    $0x0,%edx
   94279:	mov    -0x18(%rsp),%rsi
   9427e:	test   %rcx,(%rax,%rsi,8)
   94282:	je     940d0 <void inline_single_kernel<true, external_bloom::Classical<11, true, false>, unsigned long>(external_bloom::Classical<11, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   94288:	mov    $0x1,%ecx
   9428d:	shlx   %r9,%rcx,%rcx
   94292:	mov    $0x0,%edx
   94297:	mov    -0x40(%rsp),%rsi
   9429c:	test   %rcx,(%rax,%rsi,8)
   942a0:	je     940d0 <void inline_single_kernel<true, external_bloom::Classical<11, true, false>, unsigned long>(external_bloom::Classical<11, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   942a6:	and    $0x3f,%r8d
   942aa:	mov    -0x48(%rsp),%rcx
   942af:	shrx   %r8,(%rax,%rcx,8),%rdx
   942b5:	and    $0x1,%edx
   942b8:	jmp    940d0 <void inline_single_kernel<true, external_bloom::Classical<11, true, false>, unsigned long>(external_bloom::Classical<11, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   942bd:	pop    %rbx
   942be:	pop    %r12
   942c0:	pop    %r13
   942c2:	pop    %r14
   942c4:	pop    %r15
   942c6:	pop    %rbp
   942c7:	ret
   942c8:	int3
   942c9:	int3
   942ca:	int3
   942cb:	int3
   942cc:	int3
   942cd:	int3
   942ce:	int3
   942cf:	int3

