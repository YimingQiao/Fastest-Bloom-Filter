0000000000094120 <void inline_single_kernel<true, external_bloom::Classical<11, true, false>, unsigned long>(external_bloom::Classical<11, true, false> const&, unsigned long, unsigned long const*, unsigned int*)>:
   94120:	push   %rbp
   94121:	push   %r15
   94123:	push   %r14
   94125:	push   %r13
   94127:	push   %r12
   94129:	push   %rbx
   9412a:	mov    %rcx,-0x20(%rsp)
   9412f:	mov    %rdx,-0x28(%rsp)
   94134:	mov    %rdi,-0x38(%rsp)
   94139:	mov    %rsi,-0x30(%rsp)
   9413e:	test   %rsi,%rsi
   94141:	je     9433d <void inline_single_kernel<true, external_bloom::Classical<11, true, false>, unsigned long>(external_bloom::Classical<11, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x21d>
   94147:	xor    %ebp,%ebp
   94149:	jmp    94166 <void inline_single_kernel<true, external_bloom::Classical<11, true, false>, unsigned long>(external_bloom::Classical<11, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x46>
   9414b:	nopl   0x0(%rax,%rax,1)
   94150:	mov    -0x20(%rsp),%rax
   94155:	mov    %edx,(%rax,%rbp,4)
   94158:	inc    %rbp
   9415b:	cmp    %rbp,-0x30(%rsp)
   94160:	je     9433d <void inline_single_kernel<true, external_bloom::Classical<11, true, false>, unsigned long>(external_bloom::Classical<11, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x21d>
   94166:	mov    -0x28(%rsp),%rax
   9416b:	mov    (%rax,%rbp,8),%rax
   9416f:	mov    %rax,%rcx
   94172:	shr    $0x20,%rcx
   94176:	xor    %rax,%rcx
   94179:	movabs $0xd6e8feb86659fd93,%rdx
   94183:	imul   %rdx,%rcx
   94187:	mov    %rcx,%rax
   9418a:	shr    $0x20,%rax
   9418e:	xor    %rcx,%rax
   94191:	imul   %rdx,%rax
   94195:	mov    %rax,%r8
   94198:	shr    $0x20,%r8
   9419c:	xor    %rax,%r8
   9419f:	rorx   $0x20,%r8,%r11
   941a5:	mov    -0x38(%rsp),%rcx
   941aa:	mov    (%rcx),%rax
   941ad:	mov    0x10(%rcx),%r14
   941b1:	mov    %r14,%rdx
   941b4:	mulx   %r11,%rcx,%rcx
   941b9:	shrx   %r11,(%rax,%rcx,8),%rcx
   941bf:	add    %r8,%r11
   941c2:	mulx   %r11,%rdx,%rdx
   941c7:	shrx   %r11,(%rax,%rdx,8),%rsi
   941cd:	add    %r8,%r11
   941d0:	mov    %r11,%rdx
   941d3:	mulx   %r14,%rdx,%rdx
   941d8:	shrx   %r11,(%rax,%rdx,8),%rdi
   941de:	and    %ecx,%esi
   941e0:	and    %esi,%edi
   941e2:	add    %r8,%r11
   941e5:	lea    (%r11,%r8,1),%r13
   941e9:	lea    0x0(%r13,%r8,1),%r12
   941ee:	lea    (%r12,%r8,1),%r15
   941f2:	lea    (%r15,%r8,1),%rbx
   941f6:	lea    (%rbx,%r8,1),%r10
   941fa:	lea    (%r10,%r8,1),%r9
   941fe:	add    %r9,%r8
   94201:	mov    %r13,%rdx
   94204:	mulx   %r14,%rcx,%rcx
   94209:	mov    %r12,%rdx
   9420c:	mulx   %r14,%rsi,%rsi
   94211:	mov    %r15,%rdx
   94214:	mulx   %r14,%rdx,%rdx
   94219:	mov    %rdx,-0x8(%rsp)
   9421e:	mov    %rbx,%rdx
   94221:	mulx   %r14,%rdx,%rdx
   94226:	mov    %rdx,-0x10(%rsp)
   9422b:	mov    %r10,%rdx
   9422e:	mulx   %r14,%rdx,%rdx
   94233:	mov    %rdx,-0x18(%rsp)
   94238:	mov    %r9,%rdx
   9423b:	mulx   %r14,%rdx,%rdx
   94240:	mov    %rdx,-0x40(%rsp)
   94245:	mov    %r8,%rdx
   94248:	mulx   %r14,%rdx,%rdx
   9424d:	mov    %rdx,-0x48(%rsp)
   94252:	mov    $0x0,%edx
   94257:	test   $0x1,%dil
   9425b:	je     94150 <void inline_single_kernel<true, external_bloom::Classical<11, true, false>, unsigned long>(external_bloom::Classical<11, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   94261:	mov    %r11,%rdx
   94264:	mulx   %r14,%rdx,%rdx
   94269:	mov    (%rax,%rdx,8),%rdx
   9426d:	bt     %r11,%rdx
   94271:	mov    $0x0,%edx
   94276:	jae    94150 <void inline_single_kernel<true, external_bloom::Classical<11, true, false>, unsigned long>(external_bloom::Classical<11, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   9427c:	mov    $0x1,%edx
   94281:	shlx   %r13,%rdx,%rdi
   94286:	mov    $0x0,%edx
   9428b:	test   %rdi,(%rax,%rcx,8)
   9428f:	je     94150 <void inline_single_kernel<true, external_bloom::Classical<11, true, false>, unsigned long>(external_bloom::Classical<11, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   94295:	mov    $0x1,%ecx
   9429a:	shlx   %r12,%rcx,%rcx
   9429f:	mov    $0x0,%edx
   942a4:	test   %rcx,(%rax,%rsi,8)
   942a8:	je     94150 <void inline_single_kernel<true, external_bloom::Classical<11, true, false>, unsigned long>(external_bloom::Classical<11, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   942ae:	mov    $0x1,%ecx
   942b3:	shlx   %r15,%rcx,%rcx
   942b8:	mov    $0x0,%edx
   942bd:	mov    -0x8(%rsp),%rsi
   942c2:	test   %rcx,(%rax,%rsi,8)
   942c6:	je     94150 <void inline_single_kernel<true, external_bloom::Classical<11, true, false>, unsigned long>(external_bloom::Classical<11, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   942cc:	mov    $0x1,%ecx
   942d1:	shlx   %rbx,%rcx,%rcx
   942d6:	mov    $0x0,%edx
   942db:	mov    -0x10(%rsp),%rsi
   942e0:	test   %rcx,(%rax,%rsi,8)
   942e4:	je     94150 <void inline_single_kernel<true, external_bloom::Classical<11, true, false>, unsigned long>(external_bloom::Classical<11, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   942ea:	mov    $0x1,%ecx
   942ef:	shlx   %r10,%rcx,%rcx
   942f4:	mov    $0x0,%edx
   942f9:	mov    -0x18(%rsp),%rsi
   942fe:	test   %rcx,(%rax,%rsi,8)
   94302:	je     94150 <void inline_single_kernel<true, external_bloom::Classical<11, true, false>, unsigned long>(external_bloom::Classical<11, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   94308:	mov    $0x1,%ecx
   9430d:	shlx   %r9,%rcx,%rcx
   94312:	mov    $0x0,%edx
   94317:	mov    -0x40(%rsp),%rsi
   9431c:	test   %rcx,(%rax,%rsi,8)
   94320:	je     94150 <void inline_single_kernel<true, external_bloom::Classical<11, true, false>, unsigned long>(external_bloom::Classical<11, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   94326:	and    $0x3f,%r8d
   9432a:	mov    -0x48(%rsp),%rcx
   9432f:	shrx   %r8,(%rax,%rcx,8),%rdx
   94335:	and    $0x1,%edx
   94338:	jmp    94150 <void inline_single_kernel<true, external_bloom::Classical<11, true, false>, unsigned long>(external_bloom::Classical<11, true, false> const&, unsigned long, unsigned long const*, unsigned int*)+0x30>
   9433d:	pop    %rbx
   9433e:	pop    %r12
   94340:	pop    %r13
   94342:	pop    %r14
   94344:	pop    %r15
   94346:	pop    %rbp
   94347:	ret
   94348:	int3
   94349:	int3
   9434a:	int3
   9434b:	int3
   9434c:	int3
   9434d:	int3
   9434e:	int3
   9434f:	int3

