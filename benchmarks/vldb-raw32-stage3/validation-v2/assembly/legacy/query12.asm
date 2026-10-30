
/home/yiming/projects/fastest-bf-lab/build/vldb-raw32-stage3-v1/native/legacy:     file format elf64-x86-64


Disassembly of section .text:

00000000006911d0 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 1u, 1u, 0u, 0u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned long, 1u, 1u, 0u, 0u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
  6911d0:	push   %r15
  6911d2:	push   %r14
  6911d4:	push   %r13
  6911d6:	push   %r12
  6911d8:	mov    %rcx,%r12
  6911db:	push   %rbp
  6911dc:	mov    %rdi,%rbp
  6911df:	push   %rbx
  6911e0:	mov    %rdx,%rbx
  6911e3:	sub    $0x18,%rsp
  6911e7:	mov    %r8,0x8(%rsp)
  6911ec:	test   %esi,%esi
  6911ee:	je     691258 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 1u, 1u, 0u, 0u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned long, 1u, 1u, 0u, 0u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x88>
  6911f0:	cmp    $0x1,%esi
  6911f3:	mov    $0x1000,%r14d
  6911f9:	mov    $0x1,%eax
  6911fe:	cmove  %rax,%r14
  691202:	test   %rdx,%rdx
  691205:	je     691244 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 1u, 1u, 0u, 0u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned long, 1u, 1u, 0u, 0u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x74>
  691207:	mov    %rdx,%r13
  69120a:	xor    %r15d,%r15d
  69120d:	nopl   (%rax)
  691210:	mov    0x8(%rsp),%rax
  691215:	lea    0x0(,%r15,4),%rdx
  69121d:	lea    (%rax,%rdx,1),%rcx
  691221:	add    %r12,%rdx
  691224:	mov    %r14,%rax
  691227:	cmp    %r14,%r13
  69122a:	cmovbe %r13,%rax
  69122e:	mov    %rbp,%rdi
  691231:	mov    %rax,%rsi
  691234:	add    %r14,%r15
  691237:	call   691150 <void vldb_stage2::DenseCall<raw32_stage3::RawOriginal<unsigned long, 1u, 1u, 0u, 0u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned long, 1u, 1u, 0u, 0u, (dtl::block_addressing)2> const&, unsigned int, unsigned int const*, unsigned int*)>
  69123c:	sub    %r14,%r13
  69123f:	cmp    %rbx,%r15
  691242:	jb     691210 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 1u, 1u, 0u, 0u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned long, 1u, 1u, 0u, 0u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x40>
  691244:	add    $0x18,%rsp
  691248:	pop    %rbx
  691249:	pop    %rbp
  69124a:	pop    %r12
  69124c:	pop    %r13
  69124e:	pop    %r14
  691250:	pop    %r15
  691252:	ret
  691253:	nopl   0x0(%rax,%rax,1)
  691258:	lea    0x8(%rdi),%r15
  69125c:	xor    %r14d,%r14d
  69125f:	test   %rdx,%rdx
  691262:	je     691244 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 1u, 1u, 0u, 0u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned long, 1u, 1u, 0u, 0u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x74>
  691264:	nopl   0x0(%rax)
  691268:	mov    (%r12,%r14,4),%edx
  69126c:	mov    0x18(%rbp),%rsi
  691270:	mov    %r15,%rdi
  691273:	call   69c930 <dtl::bbf_64::contains(unsigned long const*, unsigned int) const>
  691278:	mov    0x8(%rsp),%rdi
  69127d:	movzbl %al,%eax
  691280:	mov    %eax,(%rdi,%r14,4)
  691284:	inc    %r14
  691287:	cmp    %r14,%rbx
  69128a:	jne    691268 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned long, 1u, 1u, 0u, 0u, (dtl::block_addressing)2> >(raw32_stage3::RawOriginal<unsigned long, 1u, 1u, 0u, 0u, (dtl::block_addressing)2> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x98>
  69128c:	add    $0x18,%rsp
  691290:	pop    %rbx
  691291:	pop    %rbp
  691292:	pop    %r12
  691294:	pop    %r13
  691296:	pop    %r14
  691298:	pop    %r15
  69129a:	ret
