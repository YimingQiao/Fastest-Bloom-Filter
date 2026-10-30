
/home/yiming/projects/fastest-bf-lab/build/page-pointer-preflight-v1/native/worker/page_pointer_control:     file format elf64-x86-64


Disassembly of section .text:

0000000000022860 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > >(raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
   22860:	push   %r15
   22862:	push   %r14
   22864:	push   %r13
   22866:	mov    %rdi,%r13
   22869:	push   %r12
   2286b:	mov    %r8,%r12
   2286e:	push   %rbp
   2286f:	push   %rbx
   22870:	mov    %rdx,%rbx
   22873:	sub    $0x18,%rsp
   22877:	mov    %rcx,0x8(%rsp)
   2287c:	test   %esi,%esi
   2287e:	je     228e8 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > >(raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x88>
   22880:	cmp    $0x1,%esi
   22883:	mov    $0x1000,%r14d
   22889:	mov    $0x1,%eax
   2288e:	cmove  %rax,%r14
   22892:	test   %rdx,%rdx
   22895:	je     228d4 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > >(raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x74>
   22897:	mov    %rdx,%rbp
   2289a:	xor    %r15d,%r15d
   2289d:	nopl   (%rax)
   228a0:	mov    0x8(%rsp),%rax
   228a5:	lea    0x0(,%r15,4),%rdx
   228ad:	lea    (%r12,%rdx,1),%rcx
   228b1:	add    %rax,%rdx
   228b4:	cmp    %r14,%rbp
   228b7:	mov    %r14,%rax
   228ba:	cmovbe %rbp,%rax
   228be:	mov    %r13,%rdi
   228c1:	mov    %rax,%rsi
   228c4:	add    %r14,%r15
   228c7:	call   217c0 <void vldb_stage2::DenseCall<raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > >(raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > const&, unsigned int, unsigned int const*, unsigned int*)>
   228cc:	sub    %r14,%rbp
   228cf:	cmp    %rbx,%r15
   228d2:	jb     228a0 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > >(raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x40>
   228d4:	add    $0x18,%rsp
   228d8:	pop    %rbx
   228d9:	pop    %rbp
   228da:	pop    %r12
   228dc:	pop    %r13
   228de:	pop    %r14
   228e0:	pop    %r15
   228e2:	ret
   228e3:	nopl   0x0(%rax,%rax,1)
   228e8:	xor    %edx,%edx
   228ea:	movabs $0xd6e8feb86659fd93,%rsi
   228f4:	test   %rbx,%rbx
   228f7:	je     228d4 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > >(raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x74>
   228f9:	nopl   0x0(%rax)
   22900:	mov    0x8(%rsp),%rax
   22905:	mov    0x0(%r13),%r10
   22909:	mov    (%rax,%rdx,4),%eax
   2290c:	imul   %rsi,%rax
   22910:	mov    %rax,%rcx
   22913:	shr    $0x20,%rcx
   22917:	xor    %rcx,%rax
   2291a:	imul   %rsi,%rax
   2291e:	mov    %rax,%rcx
   22921:	shr    $0x20,%rcx
   22925:	xor    %rcx,%rax
   22928:	mov    %rax,%r8
   2292b:	and    $0x1f,%r8d
   2292f:	mov    (%r10,%r8,4),%r8d
   22933:	mov    %eax,%ecx
   22935:	shr    $0x5,%ecx
   22938:	rol    %cl,%r8d
   2293b:	mov    %eax,%ecx
   2293d:	shr    $0xa,%ecx
   22940:	mov    %ecx,%r9d
   22943:	and    $0x1f,%r9d
   22947:	mov    (%r10,%r9,4),%r9d
   2294b:	mov    %rax,%rdi
   2294e:	mov    %eax,%ecx
   22950:	shr    $0x14,%eax
   22953:	shr    $0xf,%ecx
   22956:	shr    $0x20,%rdi
   2295a:	and    $0x7,%eax
   2295d:	and    0x8(%r13),%edi
   22961:	rol    %cl,%r9d
   22964:	add    $0x8,%eax
   22967:	mov    0x10(%r13),%rcx
   2296b:	xor    %edi,%eax
   2296d:	mov    (%rcx,%rax,4),%r11d
   22971:	mov    (%rcx,%rdi,4),%eax
   22974:	and    %r9d,%r11d
   22977:	cmp    %r9d,%r11d
   2297a:	sete   %r9b
   2297e:	and    %r8d,%eax
   22981:	cmp    %r8d,%eax
   22984:	sete   %al
   22987:	movzbl %al,%eax
   2298a:	and    %r9d,%eax
   2298d:	mov    %eax,(%r12,%rdx,4)
   22991:	inc    %rdx
   22994:	cmp    %rdx,%rbx
   22997:	jne    22900 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > >(raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0xa0>
   2299d:	add    $0x18,%rsp
   229a1:	pop    %rbx
   229a2:	pop    %rbp
   229a3:	pop    %r12
   229a5:	pop    %r13
   229a7:	pop    %r14
   229a9:	pop    %r15
   229ab:	ret
