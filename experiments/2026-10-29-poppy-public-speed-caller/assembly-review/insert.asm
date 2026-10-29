00000000000fcbe0 <compare_benchmark::insert::<compare_benchmark::PoppyPublic<0>>>:
   fcbe0:	push   %rbp
   fcbe1:	push   %r15
   fcbe3:	push   %r14
   fcbe5:	push   %r13
   fcbe7:	push   %r12
   fcbe9:	push   %rbx
   fcbea:	sub    $0x38,%rsp
   fcbee:	test   %rdx,%rdx
   fcbf1:	je     fcc3f <compare_benchmark::insert::<compare_benchmark::PoppyPublic<0>>+0x5f>
   fcbf3:	mov    %rdx,%rbx
   fcbf6:	mov    %rsi,%r14
   fcbf9:	mov    %rdi,%r15
   fcbfc:	shl    $0x3,%rbx
   fcc00:	xor    %r13d,%r13d
   fcc03:	lea    0x20(%rsp),%r12
   fcc08:	movabs $0x8000000000000007,%rbp
   fcc12:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   fcc20:	mov    (%r14,%r13,1),%rdx
   fcc24:	mov    %r12,%rdi
   fcc27:	mov    %r15,%rsi
   fcc2a:	call   fefd0 <<poppy_filters::bloom::v2::BloomFilter>::insert_bytes::<[u8; 8]>>
   fcc2f:	cmp    %rbp,0x20(%rsp)
   fcc34:	jne    fcc4e <compare_benchmark::insert::<compare_benchmark::PoppyPublic<0>>+0x6e>
   fcc36:	add    $0x8,%r13
   fcc3a:	cmp    %r13,%rbx
   fcc3d:	jne    fcc20 <compare_benchmark::insert::<compare_benchmark::PoppyPublic<0>>+0x40>
   fcc3f:	add    $0x38,%rsp
   fcc43:	pop    %rbx
   fcc44:	pop    %r12
   fcc46:	pop    %r13
   fcc48:	pop    %r14
   fcc4a:	pop    %r15
   fcc4c:	pop    %rbp
   fcc4d:	ret
   fcc4e:	mov    0x30(%rsp),%rax
   fcc53:	mov    %rax,0x10(%rsp)
   fcc58:	vmovups 0x20(%rsp),%xmm0
   fcc5e:	vmovaps %xmm0,(%rsp)
   fcc63:	lea    -0xf118c(%rip),%rdi        # bade <anon.35274091df3394f4211c680a8c77ed4a.33.llvm.9036914972901821666+0x18ae>
   fcc6a:	lea    0xd501f(%rip),%rcx        # 1d1c90 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.52.llvm.3671060894988460240+0xea0>
   fcc71:	lea    0xd6198(%rip),%r8        # 1d2e10 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.52.llvm.3671060894988460240+0x2020>
   fcc78:	mov    %rsp,%rdx
   fcc7b:	mov    $0x25,%esi
   fcc80:	call   *0xd9422(%rip)        # 1d60a8 <_DYNAMIC+0x2a8>
   fcc86:	ud2
   fcc88:	mov    %rax,%rbx
   fcc8b:	mov    %rsp,%rdi
   fcc8e:	call   ff670 <core::ptr::drop_in_place::<poppy_filters::bloom::Error>>
   fcc93:	mov    %rbx,%rdi
   fcc96:	call   1cfd20 <_Unwind_Resume@plt>
   fcc9b:	call   *0xd94b7(%rip)        # 1d6158 <_DYNAMIC+0x358>
   fcca1:	int3
   fcca2:	int3
   fcca3:	int3
   fcca4:	int3
   fcca5:	int3
   fcca6:	int3
   fcca7:	int3
   fcca8:	int3
   fcca9:	int3
   fccaa:	int3
   fccab:	int3
   fccac:	int3
   fccad:	int3
   fccae:	int3
   fccaf:	int3

