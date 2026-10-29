
/home/yiming/projects/fastest-bf-lab/build/vldb-raw32-stage3-v1/native/legacy:     file format elf64-x86-64


Disassembly of section .text:

000000000049abe0 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::FourSectorBloomFilter, raw32_stage3::NativePolicy<bloom_filters::FourSectorBloomFilter, 8> > >(raw32_stage3::RawHash<bloom_filters::FourSectorBloomFilter, raw32_stage3::NativePolicy<bloom_filters::FourSectorBloomFilter, 8> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
  49abe0:	push   %r15
  49abe2:	push   %r14
  49abe4:	push   %r13
  49abe6:	mov    %r8,%r13
  49abe9:	push   %r12
  49abeb:	push   %rbp
  49abec:	mov    %rdx,%rbp
  49abef:	push   %rbx
  49abf0:	mov    %rdi,%rbx
  49abf3:	sub    $0x18,%rsp
  49abf7:	mov    %rcx,0x8(%rsp)
  49abfc:	test   %esi,%esi
  49abfe:	je     49ac64 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::FourSectorBloomFilter, raw32_stage3::NativePolicy<bloom_filters::FourSectorBloomFilter, 8> > >(raw32_stage3::RawHash<bloom_filters::FourSectorBloomFilter, raw32_stage3::NativePolicy<bloom_filters::FourSectorBloomFilter, 8> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x84>
  49ac00:	cmp    $0x1,%esi
  49ac03:	mov    $0x1000,%r14d
  49ac09:	mov    $0x1,%eax
  49ac0e:	cmove  %rax,%r14
  49ac12:	test   %rdx,%rdx
  49ac15:	je     49ac55 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::FourSectorBloomFilter, raw32_stage3::NativePolicy<bloom_filters::FourSectorBloomFilter, 8> > >(raw32_stage3::RawHash<bloom_filters::FourSectorBloomFilter, raw32_stage3::NativePolicy<bloom_filters::FourSectorBloomFilter, 8> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x75>
  49ac17:	mov    %rdx,%r12
  49ac1a:	xor    %r15d,%r15d
  49ac1d:	nopl   (%rax)
  49ac20:	mov    0x8(%rsp),%rax
  49ac25:	lea    0x0(,%r15,4),%rdx
  49ac2d:	lea    0x0(%r13,%rdx,1),%rcx
  49ac32:	add    %rax,%rdx
  49ac35:	cmp    %r14,%r12
  49ac38:	mov    %r14,%rax
  49ac3b:	cmovbe %r12,%rax
  49ac3f:	mov    %rbx,%rdi
  49ac42:	mov    %rax,%rsi
  49ac45:	add    %r14,%r15
  49ac48:	call   49abd0 <void vldb_stage2::DenseCall<raw32_stage3::RawHash<bloom_filters::FourSectorBloomFilter, raw32_stage3::NativePolicy<bloom_filters::FourSectorBloomFilter, 8> > >(raw32_stage3::RawHash<bloom_filters::FourSectorBloomFilter, raw32_stage3::NativePolicy<bloom_filters::FourSectorBloomFilter, 8> > const&, unsigned int, unsigned int const*, unsigned int*)>
  49ac4d:	sub    %r14,%r12
  49ac50:	cmp    %rbp,%r15
  49ac53:	jb     49ac20 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::FourSectorBloomFilter, raw32_stage3::NativePolicy<bloom_filters::FourSectorBloomFilter, 8> > >(raw32_stage3::RawHash<bloom_filters::FourSectorBloomFilter, raw32_stage3::NativePolicy<bloom_filters::FourSectorBloomFilter, 8> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x40>
  49ac55:	add    $0x18,%rsp
  49ac59:	pop    %rbx
  49ac5a:	pop    %rbp
  49ac5b:	pop    %r12
  49ac5d:	pop    %r13
  49ac5f:	pop    %r14
  49ac61:	pop    %r15
  49ac63:	ret
  49ac64:	xor    %esi,%esi
  49ac66:	lea    -0x29f7ad(%rip),%r8        # 1fb4c0 <bloom_filters::FourSectorBloomFilter::patterns2>
  49ac6d:	movabs $0xd6e8feb86659fd93,%r9
  49ac77:	test   %rdx,%rdx
  49ac7a:	je     49ac55 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::FourSectorBloomFilter, raw32_stage3::NativePolicy<bloom_filters::FourSectorBloomFilter, 8> > >(raw32_stage3::RawHash<bloom_filters::FourSectorBloomFilter, raw32_stage3::NativePolicy<bloom_filters::FourSectorBloomFilter, 8> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x75>
  49ac7c:	nopl   0x0(%rax)
  49ac80:	mov    0x8(%rsp),%rax
  49ac85:	mov    0x18(%rbx),%r10d
  49ac89:	mov    (%rax,%rsi,4),%eax
  49ac8c:	imul   %r9,%rax
  49ac90:	mov    %rax,%rdx
  49ac93:	shr    $0x20,%rdx
  49ac97:	xor    %rdx,%rax
  49ac9a:	imul   %r9,%rax
  49ac9e:	mov    %rax,%rdx
  49aca1:	shr    $0x20,%rdx
  49aca5:	xor    %rdx,%rax
  49aca8:	mov    %rax,%rdi
  49acab:	and    $0xf,%edi
  49acae:	mov    (%r8,%rdi,4),%r14d
  49acb2:	mov    %eax,%ecx
  49acb4:	shr    $0x4,%ecx
  49acb7:	rol    %cl,%r14d
  49acba:	rorx   $0x8,%eax,%ecx
  49acc0:	mov    %ecx,%edi
  49acc2:	and    $0xf,%edi
  49acc5:	mov    (%r8,%rdi,4),%r11d
  49acc9:	shr    $0x4,%ecx
  49accc:	rol    %cl,%r11d
  49accf:	rorx   $0x10,%eax,%ecx
  49acd5:	mov    %ecx,%edi
  49acd7:	and    $0xf,%edi
  49acda:	mov    (%r8,%rdi,4),%edi
  49acde:	shr    $0x4,%ecx
  49ace1:	rol    %cl,%edi
  49ace3:	mov    %rax,%rdx
  49ace6:	rorx   $0x18,%eax,%ecx
  49acec:	mov    %ecx,%eax
  49acee:	shr    $0x20,%rdx
  49acf2:	and    $0xf,%eax
  49acf5:	mov    (%r8,%rax,4),%r15d
  49acf9:	mov    %edx,%eax
  49acfb:	and    %edx,%r10d
  49acfe:	shr    $0x4,%ecx
  49ad01:	shr    $0x1e,%eax
  49ad04:	rol    %cl,%r15d
  49ad07:	xor    %r10d,%eax
  49ad0a:	mov    (%rbx),%rcx
  49ad0d:	xor    $0xc,%eax
  49ad10:	mov    (%rcx,%rax,4),%r12d
  49ad14:	and    %r15d,%r12d
  49ad17:	cmp    %r15d,%r12d
  49ad1a:	mov    %r10d,%r15d
  49ad1d:	mov    (%rcx,%r15,4),%r12d
  49ad21:	sete   %al
  49ad24:	and    %r14d,%r12d
  49ad27:	cmp    %r14d,%r12d
  49ad2a:	sete   %r14b
  49ad2e:	and    %r14d,%eax
  49ad31:	mov    %edx,%r14d
  49ad34:	shr    $0x1a,%r14d
  49ad38:	and    $0x3,%r14d
  49ad3c:	xor    %r10d,%r14d
  49ad3f:	xor    $0x4,%r14d
  49ad43:	mov    (%rcx,%r14,4),%r15d
  49ad47:	and    %r11d,%r15d
  49ad4a:	cmp    %r11d,%r15d
  49ad4d:	sete   %r11b
  49ad51:	shr    $0x1c,%edx
  49ad54:	and    $0x3,%edx
  49ad57:	xor    %r10d,%edx
  49ad5a:	xor    $0x8,%edx
  49ad5d:	and    %r11d,%eax
  49ad60:	mov    (%rcx,%rdx,4),%r11d
  49ad64:	and    %edi,%r11d
  49ad67:	cmp    %edi,%r11d
  49ad6a:	sete   %dl
  49ad6d:	movzbl %dl,%edx
  49ad70:	and    %edx,%eax
  49ad72:	mov    %eax,0x0(%r13,%rsi,4)
  49ad77:	inc    %rsi
  49ad7a:	cmp    %rsi,%rbp
  49ad7d:	jne    49ac80 <void vldb_stage2::Query<raw32_stage3::RawHash<bloom_filters::FourSectorBloomFilter, raw32_stage3::NativePolicy<bloom_filters::FourSectorBloomFilter, 8> > >(raw32_stage3::RawHash<bloom_filters::FourSectorBloomFilter, raw32_stage3::NativePolicy<bloom_filters::FourSectorBloomFilter, 8> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0xa0>
  49ad83:	add    $0x18,%rsp
  49ad87:	pop    %rbx
  49ad88:	pop    %rbp
  49ad89:	pop    %r12
  49ad8b:	pop    %r13
  49ad8d:	pop    %r14
  49ad8f:	pop    %r15
  49ad91:	ret
