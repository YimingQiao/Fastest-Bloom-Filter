
/home/yiming/projects/fastest-bf-lab/build/vldb-nearby-raw32-v1/native/nearby_raw32:     file format elf64-x86-64


Disassembly of section .text:

0000000000386150 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > >(raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
  386150:	push   %r15
  386152:	push   %r14
  386154:	push   %r13
  386156:	mov    %rdi,%r13
  386159:	push   %r12
  38615b:	mov    %r8,%r12
  38615e:	push   %rbp
  38615f:	push   %rbx
  386160:	mov    %rdx,%rbx
  386163:	sub    $0x18,%rsp
  386167:	mov    %rcx,0x8(%rsp)
  38616c:	test   %esi,%esi
  38616e:	je     3861d8 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > >(raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x88>
  386170:	cmp    $0x1,%esi
  386173:	mov    $0x1000,%r14d
  386179:	mov    $0x1,%eax
  38617e:	cmove  %rax,%r14
  386182:	test   %rdx,%rdx
  386185:	je     3861c4 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > >(raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x74>
  386187:	mov    %rdx,%rbp
  38618a:	xor    %r15d,%r15d
  38618d:	nopl   (%rax)
  386190:	mov    0x8(%rsp),%rax
  386195:	lea    0x0(,%r15,4),%rdx
  38619d:	lea    (%r12,%rdx,1),%rcx
  3861a1:	add    %rax,%rdx
  3861a4:	cmp    %r14,%rbp
  3861a7:	mov    %r14,%rax
  3861aa:	cmovbe %rbp,%rax
  3861ae:	mov    %r13,%rdi
  3861b1:	mov    %rax,%rsi
  3861b4:	add    %r14,%r15
  3861b7:	call   385a30 <void vldb_stage2::DenseCall<raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > >(raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > const&, unsigned int, unsigned int const*, unsigned int*)>
  3861bc:	sub    %r14,%rbp
  3861bf:	cmp    %rbx,%r15
  3861c2:	jb     386190 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > >(raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x40>
  3861c4:	add    $0x18,%rsp
  3861c8:	pop    %rbx
  3861c9:	pop    %rbp
  3861ca:	pop    %r12
  3861cc:	pop    %r13
  3861ce:	pop    %r14
  3861d0:	pop    %r15
  3861d2:	ret
  3861d3:	nopl   0x0(%rax,%rax,1)
  3861d8:	xor    %edx,%edx
  3861da:	movabs $0xd6e8feb86659fd93,%rsi
  3861e4:	test   %rbx,%rbx
  3861e7:	je     3861c4 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > >(raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x74>
  3861e9:	nopl   0x0(%rax)
  3861f0:	mov    0x8(%rsp),%rax
  3861f5:	mov    0x0(%r13),%r10
  3861f9:	mov    (%rax,%rdx,4),%eax
  3861fc:	imul   %rsi,%rax
  386200:	mov    %rax,%rcx
  386203:	shr    $0x20,%rcx
  386207:	xor    %rcx,%rax
  38620a:	imul   %rsi,%rax
  38620e:	mov    %rax,%rcx
  386211:	shr    $0x20,%rcx
  386215:	xor    %rcx,%rax
  386218:	mov    %rax,%r8
  38621b:	and    $0x1f,%r8d
  38621f:	mov    (%r10,%r8,4),%r8d
  386223:	mov    %eax,%ecx
  386225:	shr    $0x5,%ecx
  386228:	rol    %cl,%r8d
  38622b:	mov    %eax,%ecx
  38622d:	shr    $0xa,%ecx
  386230:	mov    %ecx,%r9d
  386233:	and    $0x1f,%r9d
  386237:	mov    (%r10,%r9,4),%r9d
  38623b:	mov    %rax,%rdi
  38623e:	mov    %eax,%ecx
  386240:	shr    $0x14,%eax
  386243:	shr    $0xf,%ecx
  386246:	shr    $0x20,%rdi
  38624a:	and    $0x7,%eax
  38624d:	and    0x8(%r13),%edi
  386251:	rol    %cl,%r9d
  386254:	add    $0x8,%eax
  386257:	mov    0x10(%r13),%rcx
  38625b:	xor    %edi,%eax
  38625d:	mov    (%rcx,%rax,4),%r11d
  386261:	mov    (%rcx,%rdi,4),%eax
  386264:	and    %r9d,%r11d
  386267:	cmp    %r9d,%r11d
  38626a:	sete   %r9b
  38626e:	and    %r8d,%eax
  386271:	cmp    %r8d,%eax
  386274:	sete   %al
  386277:	movzbl %al,%eax
  38627a:	and    %r9d,%eax
  38627d:	mov    %eax,(%r12,%rdx,4)
  386281:	inc    %rdx
  386284:	cmp    %rdx,%rbx
  386287:	jne    3861f0 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > >(raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0xa0>
  38628d:	add    $0x18,%rsp
  386291:	pop    %rbx
  386292:	pop    %rbp
  386293:	pop    %r12
  386295:	pop    %r13
  386297:	pop    %r14
  386299:	pop    %r15
  38629b:	ret
