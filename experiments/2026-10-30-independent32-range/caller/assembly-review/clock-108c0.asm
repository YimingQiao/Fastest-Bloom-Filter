   12256:	add    $0x8,%r8
   1225a:	cmp    %r8,%r9
   1225d:	jne    12250 <_Z3RunIN13bloom_filters13FastPatternBFEEvRK5PointRK4CaseRK5Input+0x1990>
   1225f:	cmp    %r9,%rdi
   12262:	je     1227f <_Z3RunIN13bloom_filters13FastPatternBFEEvRK5PointRK4CaseRK5Input+0x19bf>
   12264:	lea    0x40(%rcx,%rax,4),%rax
   12269:	nopl   0x0(%rax)
   12270:	movl   $0x2,(%rsi)
   12276:	add    $0x4,%rsi
   1227a:	cmp    %rax,%rsi
   1227d:	jne    12270 <_Z3RunIN13bloom_filters13FastPatternBFEEvRK5PointRK4CaseRK5Input+0x19b0>
   1227f:	vzeroupper
   12282:	call   2eab0 <_ZNSt6chrono3_V212steady_clock3nowEv@plt>
   12287:	mov    %rax,0x68(%rsp)
   1228c:	mov    %r12,%r15
   1228f:	cmp    $0x3,%r12d
   12293:	ja     126c0 <_Z3RunIN13bloom_filters13FastPatternBFEEvRK5PointRK4CaseRK5Input+0x1e00>
   12299:	mov    %r15d,%eax
   1229c:	lea    -0x10773(%rip),%rcx        # 1b30 <_IO_stdin_used+0x450>
   122a3:	movslq (%rcx,%rax,4),%rax
   122a7:	add    %rcx,%rax
   122aa:	jmp    *%rax
   122ac:	mov    0x20(%rsp),%rax
   122b1:	cmp    %rax,0x28(%rsp)
   122b6:	mov    0x8(%rsp),%rbp
   122bb:	je     126c0 <_Z3RunIN13bloom_filters13FastPatternBFEEvRK5PointRK4CaseRK5Input+0x1e00>
   122c1:	mov    (%rsp),%rax
   122c5:	mov    0xc(%rax),%eax
   122c8:	xor    %r12d,%r12d
   122cb:	nopl   0x0(%rax,%rax,1)
   122d0:	mov    %eax,%eax
   122d2:	mov    %rbp,%rsi
   122d5:	sub    %r12,%rsi
   122d8:	cmp    %rax,%rsi
   122db:	cmovae %rax,%rsi
   122df:	lea    0x0(,%r12,8),%rdx
   122e7:	mov    0x38(%rsp),%rax
   122ec:	add    0x48(%rax),%rdx
   122f0:	mov    0x40(%rsp),%rax
   122f5:	lea    0x40(%rax,%r12,4),%rcx
   122fa:	mov    %rbx,%rdi
   122fd:	call   27ff0 <_Z13lookup_kernelIN13bloom_filters13FastPatternBFEmEvRT_mPKT0_Pj>
   12302:	mov    (%rsp),%rax
   12306:	mov    0xc(%rax),%eax
   12309:	add    %rax,%r12
   1230c:	cmp    %rbp,%r12
   1230f:	jb     122d0 <_Z3RunIN13bloom_filters13FastPatternBFEEvRK5PointRK4CaseRK5Input+0x1a10>
   12311:	jmp    126c0 <_Z3RunIN13bloom_filters13FastPatternBFEEvRK5PointRK4CaseRK5Input+0x1e00>
   12316:	mov    0x38(%rsp),%rax
   1231b:	mov    0x48(%rax),%rdx
   1231f:	mov    0x40(%rsp),%rcx
   12324:	add    $0x40,%rcx
   12328:	mov    %rbx,%rdi
   1232b:	mov    0x8(%rsp),%rsi
   12330:	call   28000 <_Z20inline_single_kernelILb0EN13bloom_filters13FastPatternBFEmEvRKT0_mPKmPj>
   12335:	jmp    126c0 <_Z3RunIN13bloom_filters13FastPatternBFEEvRK5PointRK4CaseRK5Input+0x1e00>
   1233a:	mov    0x38(%rsp),%rax
   1233f:	mov    0x18(%rax),%rdx
   12343:	mov    0x40(%rsp),%rcx
   12348:	add    $0x40,%rcx
   1234c:	mov    %rbx,%rdi
   1234f:	mov    0x8(%rsp),%rsi
   12354:	call   28190 <_Z20inline_single_kernelILb1EN13bloom_filters13FastPatternBFEmEvRKT0_mPKmPj>
   12359:	jmp    126c0 <_Z3RunIN13bloom_filters13FastPatternBFEEvRK5PointRK4CaseRK5Input+0x1e00>
   1235e:	mov    0x20(%rsp),%rax
   12363:	cmp    %rax,0x28(%rsp)
   12368:	mov    0x8(%rsp),%rsi
   1236d:	je     126c0 <_Z3RunIN13bloom_filters13FastPatternBFEEvRK5PointRK4CaseRK5Input+0x1e00>
   12373:	mov    (%rsp),%rax
   12377:	mov    0xc(%rax),%eax
   1237a:	xor    %ebp,%ebp
   1237c:	nopl   0x0(%rax)
   12380:	mov    %eax,%eax
   12382:	sub    %rbp,%rsi
   12385:	cmp    %rax,%rsi
   12388:	cmovae %rax,%rsi
   1238c:	test   %rsi,%rsi
   1238f:	je     124eb <_Z3RunIN13bloom_filters13FastPatternBFEEvRK5PointRK4CaseRK5Input+0x1c2b>
   12395:	mov    0x38(%rsp),%rax
   1239a:	mov    0x18(%rax),%rax
   1239e:	lea    (%rax,%rbp,8),%rcx
   123a2:	cmp    $0x4,%rsi
   123a6:	jb     123bb <_Z3RunIN13bloom_filters13FastPatternBFEEvRK5PointRK4CaseRK5Input+0x1afb>
   123a8:	mov    %r14,%rdx
   123ab:	sub    %rcx,%rdx
   123ae:	cmp    $0x80,%rdx
   123b5:	jae    12520 <_Z3RunIN13bloom_filters13FastPatternBFEEvRK5PointRK4CaseRK5Input+0x1c60>
   123bb:	xor    %edx,%edx
   123bd:	mov    %rsi,%r8
   123c0:	mov    %rdx,%rdi
   123c3:	and    $0x3,%r8
   123c7:	je     12406 <_Z3RunIN13bloom_filters13FastPatternBFEEvRK5PointRK4CaseRK5Input+0x1b46>
   123c9:	mov    %rdx,%rdi
   123cc:	nopl   0x0(%rax)
   123d0:	mov    (%rcx,%rdi,8),%r9
   123d4:	mov    %r9,%r10
   123d7:	shr    $0x20,%r10
   123db:	xor    %r9,%r10
   123de:	imul   %r13,%r10
   123e2:	mov    %r10,%r9
   123e5:	shr    $0x20,%r9
   123e9:	xor    %r10,%r9
   123ec:	imul   %r13,%r9
   123f0:	mov    %r9,%r10
   123f3:	shr    $0x20,%r10
   123f7:	xor    %r9,%r10
   123fa:	mov    %r10,(%r14,%rdi,8)
   123fe:	inc    %rdi
   12401:	dec    %r8
   12404:	jne    123d0 <_Z3RunIN13bloom_filters13FastPatternBFEEvRK5PointRK4CaseRK5Input+0x1b10>
   12406:	sub    %rsi,%rdx
   12409:	cmp    $0xfffffffffffffffc,%rdx
   1240d:	ja     124eb <_Z3RunIN13bloom_filters13FastPatternBFEEvRK5PointRK4CaseRK5Input+0x1c2b>
   12413:	lea    0x18(%rax,%rbp,8),%rax
   12418:	nopl   0x0(%rax,%rax,1)
   12420:	mov    -0x18(%rax,%rdi,8),%rcx
   12425:	mov    %rcx,%rdx
   12428:	shr    $0x20,%rdx
   1242c:	xor    %rcx,%rdx
   1242f:	imul   %r13,%rdx
   12433:	mov    %rdx,%rcx
   12436:	shr    $0x20,%rcx
   1243a:	xor    %rdx,%rcx
   1243d:	imul   %r13,%rcx
   12441:	mov    %rcx,%rdx
   12444:	shr    $0x20,%rdx
   12448:	xor    %rcx,%rdx
   1244b:	mov    %rdx,(%r14,%rdi,8)
   1244f:	mov    -0x10(%rax,%rdi,8),%rcx
   12454:	mov    %rcx,%rdx
   12457:	shr    $0x20,%rdx
   1245b:	xor    %rcx,%rdx
   1245e:	imul   %r13,%rdx
   12462:	mov    %rdx,%rcx
   12465:	shr    $0x20,%rcx
   12469:	xor    %rdx,%rcx
   1246c:	imul   %r13,%rcx
   12470:	mov    %rcx,%rdx
   12473:	shr    $0x20,%rdx
   12477:	xor    %rcx,%rdx
   1247a:	mov    %rdx,0x8(%r14,%rdi,8)
   1247f:	mov    -0x8(%rax,%rdi,8),%rcx
   12484:	mov    %rcx,%rdx
   12487:	shr    $0x20,%rdx
   1248b:	xor    %rcx,%rdx
   1248e:	imul   %r13,%rdx
   12492:	mov    %rdx,%rcx
   12495:	shr    $0x20,%rcx
   12499:	xor    %rdx,%rcx
   1249c:	imul   %r13,%rcx
   124a0:	mov    %rcx,%rdx
   124a3:	shr    $0x20,%rdx
   124a7:	xor    %rcx,%rdx
   124aa:	mov    %rdx,0x10(%r14,%rdi,8)
   124af:	mov    (%rax,%rdi,8),%rcx
   124b3:	mov    %rcx,%rdx
   124b6:	shr    $0x20,%rdx
   124ba:	xor    %rcx,%rdx
   124bd:	imul   %r13,%rdx
   124c1:	mov    %rdx,%rcx
   124c4:	shr    $0x20,%rcx
   124c8:	xor    %rdx,%rcx
   124cb:	imul   %r13,%rcx
   124cf:	mov    %rcx,%rdx
   124d2:	shr    $0x20,%rdx
   124d6:	xor    %rcx,%rdx
   124d9:	mov    %rdx,0x18(%r14,%rdi,8)
   124de:	add    $0x4,%rdi
   124e2:	cmp    %rdi,%rsi
   124e5:	jne    12420 <_Z3RunIN13bloom_filters13FastPatternBFEEvRK5PointRK4CaseRK5Input+0x1b60>
   124eb:	mov    0x40(%rsp),%rax
   124f0:	lea    0x40(%rax,%rbp,4),%rcx
   124f5:	mov    %rbx,%rdi
   124f8:	mov    %r14,%rdx
   124fb:	vzeroupper
   124fe:	call   27ff0 <_Z13lookup_kernelIN13bloom_filters13FastPatternBFEmEvRT_mPKT0_Pj>
   12503:	mov    (%rsp),%rax
   12507:	mov    0xc(%rax),%eax
   1250a:	add    %rax,%rbp
   1250d:	mov    0x8(%rsp),%rsi
   12512:	cmp    %rsi,%rbp
   12515:	jb     12380 <_Z3RunIN13bloom_filters13FastPatternBFEEvRK5PointRK4CaseRK5Input+0x1ac0>
   1251b:	jmp    126c0 <_Z3RunIN13bloom_filters13FastPatternBFEEvRK5PointRK4CaseRK5Input+0x1e00>
   12520:	cmp    $0x10,%rsi
   12524:	jae    1252d <_Z3RunIN13bloom_filters13FastPatternBFEEvRK5PointRK4CaseRK5Input+0x1c6d>
   12526:	xor    %edx,%edx
   12528:	jmp    12652 <_Z3RunIN13bloom_filters13FastPatternBFEEvRK5PointRK4CaseRK5Input+0x1d92>
   1252d:	lea    0x0(,%rbp,8),%r8
   12535:	mov    %esi,%edx
   12537:	and    $0xfffffff0,%edx
   1253a:	lea    0x0(,%rsi,8),%rdi
   12542:	and    $0xffffffffffffff80,%rdi
   12546:	lea    0x60(%rax,%r8,1),%r8
   1254b:	xor    %r9d,%r9d
   1254e:	vpbroadcastq -0x10b87(%rip),%ymm8        # 19d0 <_IO_stdin_used+0x2f0>
   12557:	nopw   0x0(%rax,%rax,1)
   12560:	vmovdqu -0x60(%r8,%r9,1),%ymm0
   12567:	vmovdqu -0x40(%r8,%r9,1),%ymm1
   1256e:	vmovdqu -0x20(%r8,%r9,1),%ymm2
   12575:	vmovdqu (%r8,%r9,1),%ymm3
   1257b:	vpsrlq $0x20,%ymm0,%ymm4
   12580:	vpsrlq $0x20,%ymm1,%ymm5
   12585:	vpsrlq $0x20,%ymm2,%ymm6
   1258a:	vpsrlq $0x20,%ymm3,%ymm7
   1258f:	vpxor  %ymm0,%ymm4,%ymm0
   12593:	vpxor  %ymm1,%ymm5,%ymm1
   12597:	vpxor  %ymm2,%ymm6,%ymm2
   1259b:	vpmullq %ymm8,%ymm0,%ymm0
   125a1:	vpmullq %ymm8,%ymm1,%ymm1
   125a7:	vpmullq %ymm8,%ymm2,%ymm2
   125ad:	vpxor  %ymm3,%ymm7,%ymm3
   125b1:	vpmullq %ymm8,%ymm3,%ymm3
   125b7:	vpsrlq $0x20,%ymm0,%ymm4
   125bc:	vpsrlq $0x20,%ymm1,%ymm5
   125c1:	vpsrlq $0x20,%ymm2,%ymm6
   125c6:	vpsrlq $0x20,%ymm3,%ymm7
   125cb:	vpxor  %ymm0,%ymm4,%ymm0
   125cf:	vpxor  %ymm1,%ymm5,%ymm1
   125d3:	vpxor  %ymm2,%ymm6,%ymm2
   125d7:	vpxor  %ymm3,%ymm7,%ymm3
   125db:	vpmullq %ymm8,%ymm0,%ymm0
   125e1:	vpmullq %ymm8,%ymm1,%ymm1
   125e7:	vpmullq %ymm8,%ymm2,%ymm2
   125ed:	vpmullq %ymm8,%ymm3,%ymm3
   125f3:	vpsrlq $0x20,%ymm0,%ymm4
   125f8:	vpsrlq $0x20,%ymm1,%ymm5
   125fd:	vpsrlq $0x20,%ymm2,%ymm6
   12602:	vpsrlq $0x20,%ymm3,%ymm7
   12607:	vpxor  %ymm0,%ymm4,%ymm0
   1260b:	vpxor  %ymm1,%ymm5,%ymm1
   1260f:	vpxor  %ymm2,%ymm6,%ymm2
   12613:	vpxor  %ymm3,%ymm7,%ymm3
   12617:	vmovdqu %ymm0,(%r14,%r9,1)
   1261d:	vmovdqu %ymm1,0x20(%r14,%r9,1)
   12624:	vmovdqu %ymm2,0x40(%r14,%r9,1)
   1262b:	vmovdqu %ymm3,0x60(%r14,%r9,1)
   12632:	sub    $0xffffffffffffff80,%r9
   12636:	cmp    %r9,%rdi
   12639:	jne    12560 <_Z3RunIN13bloom_filters13FastPatternBFEEvRK5PointRK4CaseRK5Input+0x1ca0>
   1263f:	cmp    %rdx,%rsi
   12642:	je     124eb <_Z3RunIN13bloom_filters13FastPatternBFEEvRK5PointRK4CaseRK5Input+0x1c2b>
   12648:	test   $0xc,%sil
   1264c:	je     123bd <_Z3RunIN13bloom_filters13FastPatternBFEEvRK5PointRK4CaseRK5Input+0x1afd>
   12652:	mov    %rdx,%rdi
   12655:	mov    %esi,%edx
   12657:	and    $0xfffffffc,%edx
   1265a:	vpbroadcastq -0x10c93(%rip),%ymm2        # 19d0 <_IO_stdin_used+0x2f0>
   12663:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   12670:	vmovdqu (%rcx,%rdi,8),%ymm0
   12675:	vpsrlq $0x20,%ymm0,%ymm1
   1267a:	vpxor  %ymm0,%ymm1,%ymm0
   1267e:	vpmullq %ymm2,%ymm0,%ymm0
   12684:	vpsrlq $0x20,%ymm0,%ymm1
   12689:	vpxor  %ymm0,%ymm1,%ymm0
   1268d:	vpmullq %ymm2,%ymm0,%ymm0
   12693:	vpsrlq $0x20,%ymm0,%ymm1
   12698:	vpxor  %ymm0,%ymm1,%ymm0
   1269c:	vmovdqu %ymm0,(%r14,%rdi,8)
   126a2:	add    $0x4,%rdi
   126a6:	cmp    %rdi,%rdx
   126a9:	jne    12670 <_Z3RunIN13bloom_filters13FastPatternBFEEvRK5PointRK4CaseRK5Input+0x1db0>
   126ab:	cmp    %rdx,%rsi
   126ae:	je     124eb <_Z3RunIN13bloom_filters13FastPatternBFEEvRK5PointRK4CaseRK5Input+0x1c2b>
   126b4:	jmp    123bd <_Z3RunIN13bloom_filters13FastPatternBFEEvRK5PointRK4CaseRK5Input+0x1afd>
   126b9:	nopl   0x0(%rax)
   126c0:	call   2eab0 <_ZNSt6chrono3_V212steady_clock3nowEv@plt>
   126c5:	sub    0x68(%rsp),%rax
   126ca:	vcvtsi2sd %rax,%xmm15,%xmm0
   126cf:	vdivsd 0x150(%rsp),%xmm0,%xmm0
   126d8:	vmovq  %xmm0,%rax
   126dd:	mov    $0x3f,%cl
   126df:	bzhi   %rcx,%rax,%rcx
   126e4:	movabs $0xfff0000000000000,%rdx
   126ee:	add    %rdx,%rcx
   126f1:	shr    $0x35,%rcx
   126f5:	cmp    $0x3ff,%ecx
   126fb:	setb   %cl
   126fe:	test   %rax,%rax
   12701:	setns  %dl
   12704:	and    %cl,%dl
   12706:	dec    %rax
   12709:	movabs $0xfffffffffffff,%rcx
   12713:	cmp    %rcx,%rax
   12716:	setb   %al
   12719:	or     %dl,%al
   1271b:	je     134c2 <_Z3RunIN13bloom_filters13FastPatternBFEEvRK5PointRK4CaseRK5Input+0x2c02>
   12721:	lea    (%r15,%r15,2),%rax
   12725:	lea    0x160(%rsp,%rax,8),%rcx
   1272d:	mov    0x168(%rsp,%rax,8),%r15
   12735:	cmp    0x170(%rsp,%rax,8),%r15
   1273d:	je     12760 <_Z3RunIN13bloom_filters13FastPatternBFEEvRK5PointRK4CaseRK5Input+0x1ea0>
   1273f:	vmovsd %xmm0,(%r15)
   12744:	add    $0x8,%r15
   12748:	mov    %r15,0x8(%rcx)
   1274c:	jmp    12812 <_Z3RunIN13bloom_filters13FastPatternBFEEvRK5PointRK4CaseRK5Input+0x1f52>
   12751:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   12760:	mov    (%rcx),%r12
   12763:	sub    %r12,%r15
   12766:	movabs $0x7ffffffffffffff8,%rax
   12770:	cmp    %rax,%r15
   12773:	je     13508 <_Z3RunIN13bloom_filters13FastPatternBFEEvRK5PointRK4CaseRK5Input+0x2c48>
   12779:	mov    %rcx,0x140(%rsp)
   12781:	vmovsd %xmm0,0x68(%rsp)
   12787:	mov    %r15,%rax
   1278a:	sar    $0x3,%rax
   1278e:	cmp    $0x1,%rax
   12792:	mov    %rax,%rcx
   12795:	adc    $0x0,%rcx
   12799:	lea    (%rcx,%rax,1),%rbp
   1279d:	movabs $0xfffffffffffffff,%rdx
   127a7:	cmp    %rdx,%rbp
   127aa:	cmovae %rdx,%rbp
   127ae:	add    %rax,%rcx
   127b1:	cmovb  %rdx,%rbp
   127b5:	lea    0x0(,%rbp,8),%rdi
   127bd:	call   2ea50 <_Znwm@plt>
   127c2:	mov    %rax,%rbx
   127c5:	vmovsd 0x68(%rsp),%xmm0
   127cb:	vmovsd %xmm0,(%rax,%r15,1)
   127d1:	test   %r15,%r15
   127d4:	jle    127e4 <_Z3RunIN13bloom_filters13FastPatternBFEEvRK5PointRK4CaseRK5Input+0x1f24>
   127d6:	mov    %rbx,%rdi
   127d9:	mov    %r12,%rsi
   127dc:	mov    %r15,%rdx
   127df:	call   2ea70 <memmove@plt>
   127e4:	test   %r12,%r12
   127e7:	je     127f4 <_Z3RunIN13bloom_filters13FastPatternBFEEvRK5PointRK4CaseRK5Input+0x1f34>
   127e9:	mov    %r12,%rdi
   127ec:	mov    %r15,%rsi
   127ef:	call   2ea60 <_ZdlPvm@plt>
   127f4:	add    %rbx,%r15
   127f7:	mov    0x140(%rsp),%rcx
   127ff:	mov    %rbx,(%rcx)
   12802:	add    $0x8,%r15
   12806:	mov    %r15,0x8(%rcx)
   1280a:	lea    (%rbx,%rbp,8),%rax
   1280e:	mov    %rax,0x10(%rcx)
   12812:	lea    0x40(%rsp),%rdi
   12817:	lea    0xb0(%rsp),%rsi
   1281f:	call   26830 <_ZN6Output5CheckERKSt6vectorIjSaIjEE>
   12824:	mov    0xa8(%rsp),%rbp
   1282c:	add    $0x4,%rbp
   12830:	mov    0x100(%rsp),%r10
