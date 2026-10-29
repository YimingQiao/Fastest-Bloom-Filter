
/home/yiming/projects/fastest-bf-lab/build/vldb-raw32-stage3-v1/native/legacy:     file format elf64-x86-64


Disassembly of section .text:

00000000004bb100 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 1u, 2u, (dtl::block_addressing)1> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 1u, 2u, (dtl::block_addressing)1> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
  4bb100:	push   %r15
  4bb102:	push   %r14
  4bb104:	mov    %rcx,%r14
  4bb107:	push   %r13
  4bb109:	mov    %rdx,%r13
  4bb10c:	push   %r12
  4bb10e:	push   %rbp
  4bb10f:	push   %rbx
  4bb110:	mov    %rdi,%rbx
  4bb113:	sub    $0x18,%rsp
  4bb117:	mov    %r8,0x8(%rsp)
  4bb11c:	test   %esi,%esi
  4bb11e:	je     4bb190 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 1u, 2u, (dtl::block_addressing)1> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 1u, 2u, (dtl::block_addressing)1> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x90>
  4bb120:	cmp    $0x1,%esi
  4bb123:	mov    $0x1000,%ebp
  4bb128:	mov    $0x1,%eax
  4bb12d:	cmove  %rax,%rbp
  4bb131:	test   %rdx,%rdx
  4bb134:	je     4bb181 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 1u, 2u, (dtl::block_addressing)1> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 1u, 2u, (dtl::block_addressing)1> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x81>
  4bb136:	mov    %rdi,(%rsp)
  4bb13a:	mov    %rbp,%rbx
  4bb13d:	mov    0x8(%rsp),%rbp
  4bb142:	mov    %rdx,%r15
  4bb145:	xor    %r12d,%r12d
  4bb148:	nopl   0x0(%rax,%rax,1)
  4bb150:	lea    0x0(,%r12,4),%rdx
  4bb158:	lea    0x0(%rbp,%rdx,1),%rcx
  4bb15d:	mov    %rbx,%rax
  4bb160:	add    %r14,%rdx
  4bb163:	cmp    %rbx,%r15
  4bb166:	cmovbe %r15,%rax
  4bb16a:	mov    (%rsp),%rdi
  4bb16e:	mov    %rax,%rsi
  4bb171:	add    %rbx,%r12
  4bb174:	call   4ba920 <void vldb_stage2::DenseCall<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 1u, 2u, (dtl::block_addressing)1> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 1u, 2u, (dtl::block_addressing)1> const&, unsigned int, unsigned int const*, unsigned int*)>
  4bb179:	sub    %rbx,%r15
  4bb17c:	cmp    %r13,%r12
  4bb17f:	jb     4bb150 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 1u, 2u, (dtl::block_addressing)1> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 1u, 2u, (dtl::block_addressing)1> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x50>
  4bb181:	add    $0x18,%rsp
  4bb185:	pop    %rbx
  4bb186:	pop    %rbp
  4bb187:	pop    %r12
  4bb189:	pop    %r13
  4bb18b:	pop    %r14
  4bb18d:	pop    %r15
  4bb18f:	ret
  4bb190:	xor    %edi,%edi
  4bb192:	mov    $0x1,%esi
  4bb197:	test   %rdx,%rdx
  4bb19a:	je     4bb181 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 1u, 2u, (dtl::block_addressing)1> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 1u, 2u, (dtl::block_addressing)1> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x81>
  4bb19c:	nopl   0x0(%rax)
  4bb1a0:	mov    (%r14,%rdi,4),%eax
  4bb1a4:	mov    0xc(%rbx),%edx
  4bb1a7:	imul   $0x238ef8e3,%eax,%r8d
  4bb1ae:	imul   %r8,%rdx
  4bb1b2:	mov    %r8,%rcx
  4bb1b5:	mov    0x10(%rbx),%r8d
  4bb1b9:	shr    $0x20,%rdx
  4bb1bd:	shrx   %r8d,%edx,%edx
  4bb1c2:	imul   0x14(%rbx),%edx
  4bb1c6:	sub    %edx,%ecx
  4bb1c8:	mov    0x18(%rbx),%rdx
  4bb1cc:	lea    0x0(,%rcx,8),%ecx
  4bb1d3:	lea    (%rdx,%rcx,4),%rcx
  4bb1d7:	imul   $0x16118b03,%eax,%edx
  4bb1dd:	imul   $0x9e3779b9,%eax,%eax
  4bb1e3:	mov    (%rcx),%r15d
  4bb1e6:	mov    %edx,%r12d
  4bb1e9:	shr    $0x1b,%r12d
  4bb1ed:	shlx   %r12d,%esi,%r12d
  4bb1f2:	mov    %edx,%ebp
  4bb1f4:	and    %r12d,%r15d
  4bb1f7:	mov    %edx,%r11d
  4bb1fa:	mov    %edx,%r10d
  4bb1fd:	mov    %edx,%r9d
  4bb200:	mov    %eax,%r8d
  4bb203:	shr    $0x16,%ebp
  4bb206:	shr    $0x11,%r11d
  4bb20a:	shr    $0xc,%r10d
  4bb20e:	shr    $0x7,%r9d
  4bb212:	shr    $0x2,%edx
  4bb215:	shr    $0x1b,%r8d
  4bb219:	shr    $0x16,%eax
  4bb21c:	cmp    %r12d,%r15d
  4bb21f:	mov    0x4(%rcx),%r12d
  4bb223:	sete   %r15b
  4bb227:	shlx   %ebp,%esi,%ebp
  4bb22c:	and    %ebp,%r12d
  4bb22f:	cmp    %ebp,%r12d
  4bb232:	mov    0x8(%rcx),%r12d
  4bb236:	sete   %bpl
  4bb23a:	shlx   %r11d,%esi,%r11d
  4bb23f:	and    %r11d,%r12d
  4bb242:	and    %r15d,%ebp
  4bb245:	cmp    %r11d,%r12d
  4bb248:	sete   %r11b
  4bb24c:	and    %ebp,%r11d
  4bb24f:	mov    0xc(%rcx),%ebp
  4bb252:	shlx   %r10d,%esi,%r10d
  4bb257:	and    %r10d,%ebp
  4bb25a:	cmp    %r10d,%ebp
  4bb25d:	sete   %r10b
  4bb261:	and    %r11d,%r10d
  4bb264:	mov    0x10(%rcx),%r11d
  4bb268:	shlx   %r9d,%esi,%r9d
  4bb26d:	and    %r9d,%r11d
  4bb270:	cmp    %r9d,%r11d
  4bb273:	sete   %r9b
  4bb277:	and    %r10d,%r9d
  4bb27a:	mov    0x14(%rcx),%r10d
  4bb27e:	shlx   %edx,%esi,%edx
  4bb283:	and    %edx,%r10d
  4bb286:	cmp    %edx,%r10d
  4bb289:	sete   %dl
  4bb28c:	and    %r9d,%edx
  4bb28f:	mov    0x18(%rcx),%r9d
  4bb293:	mov    0x1c(%rcx),%r15d
  4bb297:	shlx   %r8d,%esi,%r8d
  4bb29c:	and    %r8d,%r9d
  4bb29f:	cmp    %r8d,%r9d
  4bb2a2:	sete   %r8b
  4bb2a6:	shlx   %eax,%esi,%eax
  4bb2ab:	and    %eax,%r15d
  4bb2ae:	and    %r8d,%edx
  4bb2b1:	cmp    %eax,%r15d
  4bb2b4:	sete   %al
  4bb2b7:	mov    0x8(%rsp),%rcx
  4bb2bc:	movzbl %al,%eax
  4bb2bf:	and    %edx,%eax
  4bb2c1:	mov    %eax,(%rcx,%rdi,4)
  4bb2c4:	inc    %rdi
  4bb2c7:	cmp    %rdi,%r13
  4bb2ca:	jne    4bb1a0 <void vldb_stage2::Query<raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 1u, 2u, (dtl::block_addressing)1> >(raw32_stage3::RawOriginal<unsigned int, 8u, 8u, 1u, 2u, (dtl::block_addressing)1> const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0xa0>
  4bb2d0:	add    $0x18,%rsp
  4bb2d4:	pop    %rbx
  4bb2d5:	pop    %rbp
  4bb2d6:	pop    %r12
  4bb2d8:	pop    %r13
  4bb2da:	pop    %r14
  4bb2dc:	pop    %r15
  4bb2de:	ret
