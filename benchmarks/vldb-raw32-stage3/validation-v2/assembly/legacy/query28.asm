
/home/yiming/projects/fastest-bf-lab/build/vldb-raw32-stage3-v1/native/legacy:     file format elf64-x86-64


Disassembly of section .text:

000000000049aa70 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > >(raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
  49aa70:	push   %r15
  49aa72:	push   %r14
  49aa74:	push   %r13
  49aa76:	mov    %rdi,%r13
  49aa79:	push   %r12
  49aa7b:	mov    %r8,%r12
  49aa7e:	push   %rbp
  49aa7f:	push   %rbx
  49aa80:	mov    %rdx,%rbx
  49aa83:	sub    $0x18,%rsp
  49aa87:	mov    %rcx,0x8(%rsp)
  49aa8c:	test   %esi,%esi
  49aa8e:	je     49aaf8 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > >(raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x88>
  49aa90:	cmp    $0x1,%esi
  49aa93:	mov    $0x1000,%r14d
  49aa99:	mov    $0x1,%eax
  49aa9e:	cmove  %rax,%r14
  49aaa2:	test   %rdx,%rdx
  49aaa5:	je     49aae4 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > >(raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x74>
  49aaa7:	mov    %rdx,%rbp
  49aaaa:	xor    %r15d,%r15d
  49aaad:	nopl   (%rax)
  49aab0:	mov    0x8(%rsp),%rax
  49aab5:	lea    0x0(,%r15,4),%rdx
  49aabd:	lea    (%r12,%rdx,1),%rcx
  49aac1:	add    %rax,%rdx
  49aac4:	cmp    %r14,%rbp
  49aac7:	mov    %r14,%rax
  49aaca:	cmovbe %rbp,%rax
  49aace:	mov    %r13,%rdi
  49aad1:	mov    %rax,%rsi
  49aad4:	add    %r14,%r15
  49aad7:	call   49a350 <void vldb_stage2::DenseCall<raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > >(raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > const&, unsigned int, unsigned int const*, unsigned int*)>
  49aadc:	sub    %r14,%rbp
  49aadf:	cmp    %rbx,%r15
  49aae2:	jb     49aab0 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > >(raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x40>
  49aae4:	add    $0x18,%rsp
  49aae8:	pop    %rbx
  49aae9:	pop    %rbp
  49aaea:	pop    %r12
  49aaec:	pop    %r13
  49aaee:	pop    %r14
  49aaf0:	pop    %r15
  49aaf2:	ret
  49aaf3:	nopl   0x0(%rax,%rax,1)
  49aaf8:	xor    %edx,%edx
  49aafa:	movabs $0xd6e8feb86659fd93,%rsi
  49ab04:	test   %rbx,%rbx
  49ab07:	je     49aae4 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > >(raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x74>
  49ab09:	nopl   0x0(%rax)
  49ab10:	mov    0x8(%rsp),%rax
  49ab15:	mov    0x0(%r13),%r10
  49ab19:	mov    (%rax,%rdx,4),%eax
  49ab1c:	imul   %rsi,%rax
  49ab20:	mov    %rax,%rcx
  49ab23:	shr    $0x20,%rcx
  49ab27:	xor    %rcx,%rax
  49ab2a:	imul   %rsi,%rax
  49ab2e:	mov    %rax,%rcx
  49ab31:	shr    $0x20,%rcx
  49ab35:	xor    %rcx,%rax
  49ab38:	mov    %rax,%r8
  49ab3b:	and    $0x1f,%r8d
  49ab3f:	mov    (%r10,%r8,4),%r8d
  49ab43:	mov    %eax,%ecx
  49ab45:	shr    $0x5,%ecx
  49ab48:	rol    %cl,%r8d
  49ab4b:	mov    %eax,%ecx
  49ab4d:	shr    $0xa,%ecx
  49ab50:	mov    %ecx,%r9d
  49ab53:	and    $0x1f,%r9d
  49ab57:	mov    (%r10,%r9,4),%r9d
  49ab5b:	mov    %rax,%rdi
  49ab5e:	mov    %eax,%ecx
  49ab60:	shr    $0x14,%eax
  49ab63:	shr    $0xf,%ecx
  49ab66:	shr    $0x20,%rdi
  49ab6a:	and    $0x7,%eax
  49ab6d:	and    0x8(%r13),%edi
  49ab71:	rol    %cl,%r9d
  49ab74:	add    $0x8,%eax
  49ab77:	mov    0x10(%r13),%rcx
  49ab7b:	xor    %edi,%eax
  49ab7d:	mov    (%rcx,%rax,4),%r11d
  49ab81:	mov    (%rcx,%rdi,4),%eax
  49ab84:	and    %r9d,%r11d
  49ab87:	cmp    %r9d,%r11d
  49ab8a:	sete   %r9b
  49ab8e:	and    %r8d,%eax
  49ab91:	cmp    %r8d,%eax
  49ab94:	sete   %al
  49ab97:	movzbl %al,%eax
  49ab9a:	and    %r9d,%eax
  49ab9d:	mov    %eax,(%r12,%rdx,4)
  49aba1:	inc    %rdx
  49aba4:	cmp    %rdx,%rbx
  49aba7:	jne    49ab10 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > >(raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0xa0>
  49abad:	add    $0x18,%rsp
  49abb1:	pop    %rbx
  49abb2:	pop    %rbp
  49abb3:	pop    %r12
  49abb5:	pop    %r13
  49abb7:	pop    %r14
  49abb9:	pop    %r15
  49abbb:	ret
