
/home/yiming/projects/fastest-bf-lab/build/vldb-raw32-stage3-v1/native/legacy:     file format elf64-x86-64


Disassembly of section .text:

000000000067f020 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 2u, 2u, (dtl::block_addressing)1> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 2u, 2u, (dtl::block_addressing)1> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
  67f020:	push   %r15
  67f022:	push   %r14
  67f024:	mov    %rcx,%r14
  67f027:	push   %r13
  67f029:	mov    %rdx,%r13
  67f02c:	push   %r12
  67f02e:	push   %rbp
  67f02f:	push   %rbx
  67f030:	mov    %rdi,%rbx
  67f033:	sub    $0x18,%rsp
  67f037:	mov    %r8,0x8(%rsp)
  67f03c:	test   %esi,%esi
  67f03e:	je     67f0b0 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 2u, 2u, (dtl::block_addressing)1> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 2u, 2u, (dtl::block_addressing)1> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x90>
  67f040:	cmp    $0x1,%esi
  67f043:	mov    $0x1000,%ebp
  67f048:	mov    $0x1,%eax
  67f04d:	cmove  %rax,%rbp
  67f051:	test   %rdx,%rdx
  67f054:	je     67f0a1 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 2u, 2u, (dtl::block_addressing)1> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 2u, 2u, (dtl::block_addressing)1> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x81>
  67f056:	mov    %rdi,(%rsp)
  67f05a:	mov    %rbp,%rbx
  67f05d:	mov    0x8(%rsp),%rbp
  67f062:	mov    %rdx,%r15
  67f065:	xor    %r12d,%r12d
  67f068:	nopl   0x0(%rax,%rax,1)
  67f070:	lea    0x0(,%r12,4),%rdx
  67f078:	lea    0x0(%rbp,%rdx,1),%rcx
  67f07d:	mov    %rbx,%rax
  67f080:	add    %r14,%rdx
  67f083:	cmp    %rbx,%r15
  67f086:	cmovbe %r15,%rax
  67f08a:	mov    (%rsp),%rdi
  67f08e:	mov    %rax,%rsi
  67f091:	add    %rbx,%r12
  67f094:	call   67e940 <void vldb_stage2::DenseCall<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 2u, 2u, (dtl::block_addressing)1> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 2u, 2u, (dtl::block_addressing)1> const&, unsigned int, unsigned int const*, unsigned int*)>
  67f099:	sub    %rbx,%r15
  67f09c:	cmp    %r13,%r12
  67f09f:	jb     67f070 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 2u, 2u, (dtl::block_addressing)1> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 2u, 2u, (dtl::block_addressing)1> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x50>
  67f0a1:	add    $0x18,%rsp
  67f0a5:	pop    %rbx
  67f0a6:	pop    %rbp
  67f0a7:	pop    %r12
  67f0a9:	pop    %r13
  67f0ab:	pop    %r14
  67f0ad:	pop    %r15
  67f0af:	ret
  67f0b0:	xor    %edi,%edi
  67f0b2:	mov    $0x1,%esi
  67f0b7:	test   %rdx,%rdx
  67f0ba:	je     67f0a1 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 2u, 2u, (dtl::block_addressing)1> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 2u, 2u, (dtl::block_addressing)1> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x81>
  67f0bc:	nopl   0x0(%rax)
  67f0c0:	mov    (%r14,%rdi,4),%eax
  67f0c4:	mov    0xc(%rbx),%edx
  67f0c7:	imul   $0x238ef8e3,%eax,%r8d
  67f0ce:	imul   %r8,%rdx
  67f0d2:	mov    %r8,%rcx
  67f0d5:	mov    0x10(%rbx),%r8d
  67f0d9:	shr    $0x20,%rdx
  67f0dd:	shrx   %r8d,%edx,%edx
  67f0e2:	imul   0x14(%rbx),%edx
  67f0e6:	sub    %edx,%ecx
  67f0e8:	mov    0x18(%rbx),%rdx
  67f0ec:	lea    0x0(,%rcx,8),%ecx
  67f0f3:	lea    (%rdx,%rcx,8),%rcx
  67f0f7:	imul   $0x16118b03,%eax,%edx
  67f0fd:	imul   $0x9e3779b9,%eax,%eax
  67f103:	mov    (%rcx),%r15
  67f106:	mov    %edx,%r12d
  67f109:	shr    $0x1a,%r12d
  67f10d:	shlx   %r12,%rsi,%r12
  67f112:	mov    %edx,%ebp
  67f114:	and    %r12,%r15
  67f117:	mov    %edx,%r11d
  67f11a:	mov    %edx,%r10d
  67f11d:	mov    %eax,%r9d
  67f120:	mov    %eax,%r8d
  67f123:	shr    $0x14,%ebp
  67f126:	shr    $0xe,%r11d
  67f12a:	shr    $0x8,%r10d
  67f12e:	shr    $0x2,%edx
  67f131:	shr    $0x1a,%r9d
  67f135:	shr    $0x14,%r8d
  67f139:	shr    $0xe,%eax
  67f13c:	cmp    %r12,%r15
  67f13f:	mov    0x8(%rcx),%r12
  67f143:	sete   %r15b
  67f147:	shlx   %rbp,%rsi,%rbp
  67f14c:	and    %rbp,%r12
  67f14f:	cmp    %rbp,%r12
  67f152:	mov    0x10(%rcx),%r12
  67f156:	sete   %bpl
  67f15a:	shlx   %r11,%rsi,%r11
  67f15f:	and    %r11,%r12
  67f162:	and    %r15d,%ebp
  67f165:	cmp    %r11,%r12
  67f168:	sete   %r11b
  67f16c:	and    %ebp,%r11d
  67f16f:	mov    0x18(%rcx),%rbp
  67f173:	shlx   %r10,%rsi,%r10
  67f178:	and    %r10,%rbp
  67f17b:	cmp    %r10,%rbp
  67f17e:	sete   %r10b
  67f182:	and    %r11d,%r10d
  67f185:	mov    0x20(%rcx),%r11
  67f189:	shlx   %rdx,%rsi,%rdx
  67f18e:	and    %rdx,%r11
  67f191:	cmp    %rdx,%r11
  67f194:	sete   %dl
  67f197:	and    %r10d,%edx
  67f19a:	mov    0x28(%rcx),%r10
  67f19e:	shlx   %r9,%rsi,%r9
  67f1a3:	and    %r9,%r10
  67f1a6:	cmp    %r9,%r10
  67f1a9:	sete   %r9b
  67f1ad:	and    %r9d,%edx
  67f1b0:	mov    0x30(%rcx),%r9
  67f1b4:	mov    0x38(%rcx),%r15
  67f1b8:	shlx   %r8,%rsi,%r8
  67f1bd:	and    %r8,%r9
  67f1c0:	cmp    %r8,%r9
  67f1c3:	sete   %r8b
  67f1c7:	shlx   %rax,%rsi,%rax
  67f1cc:	and    %rax,%r15
  67f1cf:	and    %r8d,%edx
  67f1d2:	cmp    %rax,%r15
  67f1d5:	sete   %al
  67f1d8:	mov    0x8(%rsp),%rcx
  67f1dd:	movzbl %al,%eax
  67f1e0:	and    %edx,%eax
  67f1e2:	mov    %eax,(%rcx,%rdi,4)
  67f1e5:	inc    %rdi
  67f1e8:	cmp    %rdi,%r13
  67f1eb:	jne    67f0c0 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 2u, 2u, (dtl::block_addressing)1> >(raw32_stage3::RawOriginal<unsigned long, 8u, 8u, 2u, 2u, (dtl::block_addressing)1> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0xa0>
  67f1f1:	add    $0x18,%rsp
  67f1f5:	pop    %rbx
  67f1f6:	pop    %rbp
  67f1f7:	pop    %r12
  67f1f9:	pop    %r13
  67f1fb:	pop    %r14
  67f1fd:	pop    %r15
  67f1ff:	ret
