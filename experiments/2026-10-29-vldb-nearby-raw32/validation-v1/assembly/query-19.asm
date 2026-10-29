
/home/yiming/projects/fastest-bf-lab/build/vldb-nearby-raw32-v1/native/nearby_raw32:     file format elf64-x86-64


Disassembly of section .text:

00000000003862c0 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::FourSectorBloomFilter, raw32_stage3::NativePolicy<bloom_filters::FourSectorBloomFilter, 8> > >(raw32_stage3::RawHash<bloom_filters::FourSectorBloomFilter, raw32_stage3::NativePolicy<bloom_filters::FourSectorBloomFilter, 8> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
  3862c0:	push   %r15
  3862c2:	push   %r14
  3862c4:	push   %r13
  3862c6:	mov    %r8,%r13
  3862c9:	push   %r12
  3862cb:	push   %rbp
  3862cc:	mov    %rdx,%rbp
  3862cf:	push   %rbx
  3862d0:	mov    %rdi,%rbx
  3862d3:	sub    $0x18,%rsp
  3862d7:	mov    %rcx,0x8(%rsp)
  3862dc:	test   %esi,%esi
  3862de:	je     386344 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::FourSectorBloomFilter, raw32_stage3::NativePolicy<bloom_filters::FourSectorBloomFilter, 8> > >(raw32_stage3::RawHash<bloom_filters::FourSectorBloomFilter, raw32_stage3::NativePolicy<bloom_filters::FourSectorBloomFilter, 8> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x84>
  3862e0:	cmp    $0x1,%esi
  3862e3:	mov    $0x1000,%r14d
  3862e9:	mov    $0x1,%eax
  3862ee:	cmove  %rax,%r14
  3862f2:	test   %rdx,%rdx
  3862f5:	je     386335 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::FourSectorBloomFilter, raw32_stage3::NativePolicy<bloom_filters::FourSectorBloomFilter, 8> > >(raw32_stage3::RawHash<bloom_filters::FourSectorBloomFilter, raw32_stage3::NativePolicy<bloom_filters::FourSectorBloomFilter, 8> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x75>
  3862f7:	mov    %rdx,%r12
  3862fa:	xor    %r15d,%r15d
  3862fd:	nopl   (%rax)
  386300:	mov    0x8(%rsp),%rax
  386305:	lea    0x0(,%r15,4),%rdx
  38630d:	lea    0x0(%r13,%rdx,1),%rcx
  386312:	add    %rax,%rdx
  386315:	cmp    %r14,%r12
  386318:	mov    %r14,%rax
  38631b:	cmovbe %r12,%rax
  38631f:	mov    %rbx,%rdi
  386322:	mov    %rax,%rsi
  386325:	add    %r14,%r15
  386328:	call   3862b0 <void vldb_stage2::DenseCall<raw32_stage3::RawHash<bloom_filters::FourSectorBloomFilter, raw32_stage3::NativePolicy<bloom_filters::FourSectorBloomFilter, 8> > >(raw32_stage3::RawHash<bloom_filters::FourSectorBloomFilter, raw32_stage3::NativePolicy<bloom_filters::FourSectorBloomFilter, 8> > const&, unsigned int, unsigned int const*, unsigned int*)>
  38632d:	sub    %r14,%r12
  386330:	cmp    %rbp,%r15
  386333:	jb     386300 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::FourSectorBloomFilter, raw32_stage3::NativePolicy<bloom_filters::FourSectorBloomFilter, 8> > >(raw32_stage3::RawHash<bloom_filters::FourSectorBloomFilter, raw32_stage3::NativePolicy<bloom_filters::FourSectorBloomFilter, 8> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x40>
  386335:	add    $0x18,%rsp
  386339:	pop    %rbx
  38633a:	pop    %rbp
  38633b:	pop    %r12
  38633d:	pop    %r13
  38633f:	pop    %r14
  386341:	pop    %r15
  386343:	ret
  386344:	xor    %esi,%esi
  386346:	lea    -0x30cfad(%rip),%r8        # 793a0 <bloom_filters::FourSectorBloomFilter::patterns2>
  38634d:	movabs $0xd6e8feb86659fd93,%r9
  386357:	test   %rdx,%rdx
  38635a:	je     386335 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::FourSectorBloomFilter, raw32_stage3::NativePolicy<bloom_filters::FourSectorBloomFilter, 8> > >(raw32_stage3::RawHash<bloom_filters::FourSectorBloomFilter, raw32_stage3::NativePolicy<bloom_filters::FourSectorBloomFilter, 8> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x75>
  38635c:	nopl   0x0(%rax)
  386360:	mov    0x8(%rsp),%rax
  386365:	mov    0x18(%rbx),%r10d
  386369:	mov    (%rax,%rsi,4),%eax
  38636c:	imul   %r9,%rax
  386370:	mov    %rax,%rdx
  386373:	shr    $0x20,%rdx
  386377:	xor    %rdx,%rax
  38637a:	imul   %r9,%rax
  38637e:	mov    %rax,%rdx
  386381:	shr    $0x20,%rdx
  386385:	xor    %rdx,%rax
  386388:	mov    %rax,%rdi
  38638b:	and    $0xf,%edi
  38638e:	mov    (%r8,%rdi,4),%r14d
  386392:	mov    %eax,%ecx
  386394:	shr    $0x4,%ecx
  386397:	rol    %cl,%r14d
  38639a:	rorx   $0x8,%eax,%ecx
  3863a0:	mov    %ecx,%edi
  3863a2:	and    $0xf,%edi
  3863a5:	mov    (%r8,%rdi,4),%r11d
  3863a9:	shr    $0x4,%ecx
  3863ac:	rol    %cl,%r11d
  3863af:	rorx   $0x10,%eax,%ecx
  3863b5:	mov    %ecx,%edi
  3863b7:	and    $0xf,%edi
  3863ba:	mov    (%r8,%rdi,4),%edi
  3863be:	shr    $0x4,%ecx
  3863c1:	rol    %cl,%edi
  3863c3:	mov    %rax,%rdx
  3863c6:	rorx   $0x18,%eax,%ecx
  3863cc:	mov    %ecx,%eax
  3863ce:	shr    $0x20,%rdx
  3863d2:	and    $0xf,%eax
  3863d5:	mov    (%r8,%rax,4),%r15d
  3863d9:	mov    %edx,%eax
  3863db:	and    %edx,%r10d
  3863de:	shr    $0x4,%ecx
  3863e1:	shr    $0x1e,%eax
  3863e4:	rol    %cl,%r15d
  3863e7:	xor    %r10d,%eax
  3863ea:	mov    (%rbx),%rcx
  3863ed:	xor    $0xc,%eax
  3863f0:	mov    (%rcx,%rax,4),%r12d
  3863f4:	and    %r15d,%r12d
  3863f7:	cmp    %r15d,%r12d
  3863fa:	mov    %r10d,%r15d
  3863fd:	mov    (%rcx,%r15,4),%r12d
  386401:	sete   %al
  386404:	and    %r14d,%r12d
  386407:	cmp    %r14d,%r12d
  38640a:	sete   %r14b
  38640e:	and    %r14d,%eax
  386411:	mov    %edx,%r14d
  386414:	shr    $0x1a,%r14d
  386418:	and    $0x3,%r14d
  38641c:	xor    %r10d,%r14d
  38641f:	xor    $0x4,%r14d
  386423:	mov    (%rcx,%r14,4),%r15d
  386427:	and    %r11d,%r15d
  38642a:	cmp    %r11d,%r15d
  38642d:	sete   %r11b
  386431:	shr    $0x1c,%edx
  386434:	and    $0x3,%edx
  386437:	xor    %r10d,%edx
  38643a:	xor    $0x8,%edx
  38643d:	and    %r11d,%eax
  386440:	mov    (%rcx,%rdx,4),%r11d
  386444:	and    %edi,%r11d
  386447:	cmp    %edi,%r11d
  38644a:	sete   %dl
  38644d:	movzbl %dl,%edx
  386450:	and    %edx,%eax
  386452:	mov    %eax,0x0(%r13,%rsi,4)
  386457:	inc    %rsi
  38645a:	cmp    %rsi,%rbp
  38645d:	jne    386360 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::FourSectorBloomFilter, raw32_stage3::NativePolicy<bloom_filters::FourSectorBloomFilter, 8> > >(raw32_stage3::RawHash<bloom_filters::FourSectorBloomFilter, raw32_stage3::NativePolicy<bloom_filters::FourSectorBloomFilter, 8> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0xa0>
  386463:	add    $0x18,%rsp
  386467:	pop    %rbx
  386468:	pop    %rbp
  386469:	pop    %r12
  38646b:	pop    %r13
  38646d:	pop    %r14
  38646f:	pop    %r15
  386471:	ret
