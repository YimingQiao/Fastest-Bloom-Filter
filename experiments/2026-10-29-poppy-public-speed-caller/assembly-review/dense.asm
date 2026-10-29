00000000000fdb50 <compare_benchmark::lookup::<compare_benchmark::PoppyPublic<0>>>:
   fdb50:	push   %rbp
   fdb51:	push   %r15
   fdb53:	push   %r14
   fdb55:	push   %r13
   fdb57:	push   %r12
   fdb59:	push   %rbx
   fdb5a:	sub    $0x48,%rsp
   fdb5e:	mov    %rdx,0x8(%rsp)
   fdb63:	mov    %r8,0x10(%rsp)
   fdb68:	cmp    %r8,%rdx
   fdb6b:	jne    fdbbe <compare_benchmark::lookup::<compare_benchmark::PoppyPublic<0>>+0x6e>
   fdb6d:	mov    %rdx,%r14
   fdb70:	test   %rdx,%rdx
   fdb73:	je     fdbaf <compare_benchmark::lookup::<compare_benchmark::PoppyPublic<0>>+0x5f>
   fdb75:	mov    %rcx,%rbx
   fdb78:	mov    %rsi,%r15
   fdb7b:	mov    %rdi,%r12
   fdb7e:	xor    %r13d,%r13d
   fdb81:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   fdb90:	lea    0x1(%r13),%rbp
   fdb94:	mov    (%r15,%r13,8),%rsi
   fdb98:	mov    %r12,%rdi
   fdb9b:	call   ff3a0 <<poppy_filters::bloom::v2::BloomFilter>::contains_bytes::<[u8; 8]>>
   fdba0:	movzbl %al,%eax
   fdba3:	mov    %eax,(%rbx,%r13,4)
   fdba7:	mov    %rbp,%r13
   fdbaa:	cmp    %rbp,%r14
   fdbad:	jne    fdb90 <compare_benchmark::lookup::<compare_benchmark::PoppyPublic<0>>+0x40>
   fdbaf:	add    $0x48,%rsp
   fdbb3:	pop    %rbx
   fdbb4:	pop    %r12
   fdbb6:	pop    %r13
   fdbb8:	pop    %r14
   fdbba:	pop    %r15
   fdbbc:	pop    %rbp
   fdbbd:	ret
   fdbbe:	movq   $0x0,0x18(%rsp)
   fdbc7:	lea    0xd525a(%rip),%r8        # 1d2e28 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.52.llvm.3671060894988460240+0x2038>
   fdbce:	lea    0x8(%rsp),%rsi
   fdbd3:	lea    0x10(%rsp),%rdx
   fdbd8:	lea    0x18(%rsp),%rcx
   fdbdd:	xor    %edi,%edi
   fdbdf:	call   *0xd8513(%rip)        # 1d60f8 <_DYNAMIC+0x2f8>
   fdbe5:	int3
   fdbe6:	int3
   fdbe7:	int3
   fdbe8:	int3
   fdbe9:	int3
   fdbea:	int3
   fdbeb:	int3
   fdbec:	int3
   fdbed:	int3
   fdbee:	int3
   fdbef:	int3

