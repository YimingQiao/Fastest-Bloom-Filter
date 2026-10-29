
/home/yiming/projects/fastest-bf-lab/build/vldb-nearby-raw32-v1/native/nearby_raw32:     file format elf64-x86-64


Disassembly of section .text:

00000000003879f0 <void vldb_stage2::Query<raw32_stage3::VisibleRawHash<nearby_raw32::K12Public, nearby_raw32::ExactNativePolicy<nearby_raw32::K12Public, true> > >(raw32_stage3::VisibleRawHash<nearby_raw32::K12Public, nearby_raw32::ExactNativePolicy<nearby_raw32::K12Public, true> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)>:
  3879f0:	push   %r15
  3879f2:	push   %r14
  3879f4:	push   %r13
  3879f6:	mov    %r8,%r13
  3879f9:	push   %r12
  3879fb:	push   %rbp
  3879fc:	mov    %rdx,%rbp
  3879ff:	push   %rbx
  387a00:	mov    %rdi,%rbx
  387a03:	sub    $0x18,%rsp
  387a07:	mov    %rcx,0x8(%rsp)
  387a0c:	test   %esi,%esi
  387a0e:	je     387a74 <void vldb_stage2::Query<raw32_stage3::VisibleRawHash<nearby_raw32::K12Public, nearby_raw32::ExactNativePolicy<nearby_raw32::K12Public, true> > >(raw32_stage3::VisibleRawHash<nearby_raw32::K12Public, nearby_raw32::ExactNativePolicy<nearby_raw32::K12Public, true> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x84>
  387a10:	cmp    $0x1,%esi
  387a13:	mov    $0x1000,%r14d
  387a19:	mov    $0x1,%eax
  387a1e:	cmove  %rax,%r14
  387a22:	test   %rdx,%rdx
  387a25:	je     387a65 <void vldb_stage2::Query<raw32_stage3::VisibleRawHash<nearby_raw32::K12Public, nearby_raw32::ExactNativePolicy<nearby_raw32::K12Public, true> > >(raw32_stage3::VisibleRawHash<nearby_raw32::K12Public, nearby_raw32::ExactNativePolicy<nearby_raw32::K12Public, true> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x75>
  387a27:	mov    %rdx,%r12
  387a2a:	xor    %r15d,%r15d
  387a2d:	nopl   (%rax)
  387a30:	mov    0x8(%rsp),%rax
  387a35:	lea    0x0(,%r15,4),%rdx
  387a3d:	lea    0x0(%r13,%rdx,1),%rcx
  387a42:	add    %rax,%rdx
  387a45:	cmp    %r14,%r12
  387a48:	mov    %r14,%rax
  387a4b:	cmovbe %r12,%rax
  387a4f:	mov    %rbx,%rdi
  387a52:	mov    %rax,%rsi
  387a55:	add    %r14,%r15
  387a58:	call   3879e0 <void vldb_stage2::DenseCall<raw32_stage3::VisibleRawHash<nearby_raw32::K12Public, nearby_raw32::ExactNativePolicy<nearby_raw32::K12Public, true> > >(raw32_stage3::VisibleRawHash<nearby_raw32::K12Public, nearby_raw32::ExactNativePolicy<nearby_raw32::K12Public, true> > const&, unsigned int, unsigned int const*, unsigned int*)>
  387a5d:	sub    %r14,%r12
  387a60:	cmp    %rbp,%r15
  387a63:	jb     387a30 <void vldb_stage2::Query<raw32_stage3::VisibleRawHash<nearby_raw32::K12Public, nearby_raw32::ExactNativePolicy<nearby_raw32::K12Public, true> > >(raw32_stage3::VisibleRawHash<nearby_raw32::K12Public, nearby_raw32::ExactNativePolicy<nearby_raw32::K12Public, true> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x40>
  387a65:	add    $0x18,%rsp
  387a69:	pop    %rbx
  387a6a:	pop    %rbp
  387a6b:	pop    %r12
  387a6d:	pop    %r13
  387a6f:	pop    %r14
  387a71:	pop    %r15
  387a73:	ret
  387a74:	xor    %edi,%edi
  387a76:	lea    -0x30e77d(%rip),%r10        # 79300 <nearby_k12::FourSectorRange12::patterns3>
  387a7d:	movabs $0xd6e8feb86659fd93,%r11
  387a87:	test   %rdx,%rdx
  387a8a:	je     387a65 <void vldb_stage2::Query<raw32_stage3::VisibleRawHash<nearby_raw32::K12Public, nearby_raw32::ExactNativePolicy<nearby_raw32::K12Public, true> > >(raw32_stage3::VisibleRawHash<nearby_raw32::K12Public, nearby_raw32::ExactNativePolicy<nearby_raw32::K12Public, true> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0x75>
  387a8c:	nopl   0x0(%rax)
  387a90:	mov    0x8(%rsp),%rax
  387a95:	mov    0x18(%rbx),%ecx
  387a98:	mov    (%rax,%rdi,4),%eax
  387a9b:	imul   %r11,%rax
  387a9f:	mov    %rax,%rdx
  387aa2:	shr    $0x20,%rdx
  387aa6:	xor    %rdx,%rax
  387aa9:	imul   %r11,%rax
  387aad:	mov    %rax,%rdx
  387ab0:	shr    $0x20,%rdx
  387ab4:	xor    %rdx,%rax
  387ab7:	mov    %rax,%rsi
  387aba:	shr    $0x28,%rsi
  387abe:	imul   %rcx,%rsi
  387ac2:	mov    %rax,%rdx
  387ac5:	shr    $0x20,%rdx
  387ac9:	shr    $0x18,%rsi
  387acd:	mov    %edx,%ecx
  387acf:	mov    %rax,%r8
  387ad2:	and    $0x3,%ecx
  387ad5:	shl    $0x4,%esi
  387ad8:	and    $0xf,%r8d
  387adc:	or     %ecx,%esi
  387ade:	mov    (%r10,%r8,4),%r8d
  387ae2:	mov    %eax,%ecx
  387ae4:	shr    $0x4,%ecx
  387ae7:	rol    %cl,%r8d
  387aea:	rorx   $0x8,%eax,%ecx
  387af0:	mov    %ecx,%r9d
  387af3:	and    $0xf,%r9d
  387af7:	mov    (%r10,%r9,4),%r14d
  387afb:	shr    $0x4,%ecx
  387afe:	rol    %cl,%r14d
  387b01:	rorx   $0x10,%eax,%ecx
  387b07:	mov    %ecx,%r9d
  387b0a:	and    $0xf,%r9d
  387b0e:	mov    (%r10,%r9,4),%r9d
  387b12:	shr    $0x4,%ecx
  387b15:	rol    %cl,%r9d
  387b18:	rorx   $0x18,%eax,%ecx
  387b1e:	mov    %ecx,%eax
  387b20:	and    $0xf,%eax
  387b23:	mov    %edx,%r15d
  387b26:	shr    $0x2,%r15d
  387b2a:	mov    (%r10,%rax,4),%eax
  387b2e:	shr    $0x4,%ecx
  387b31:	and    $0x3,%r15d
  387b35:	rol    %cl,%eax
  387b37:	xor    %esi,%r15d
  387b3a:	mov    (%rbx),%rcx
  387b3d:	or     $0x4,%r15d
  387b41:	mov    (%rcx,%r15,4),%r12d
  387b45:	and    %r14d,%r12d
  387b48:	cmp    %r14d,%r12d
  387b4b:	mov    %edx,%r14d
  387b4e:	sete   %r15b
  387b52:	shr    $0x4,%r14d
  387b56:	and    $0x3,%r14d
  387b5a:	xor    %esi,%r14d
  387b5d:	or     $0x8,%r14d
  387b61:	mov    (%rcx,%r14,4),%r12d
  387b65:	mov    %esi,%r14d
  387b68:	and    %r9d,%r12d
  387b6b:	cmp    %r9d,%r12d
  387b6e:	sete   %r9b
  387b72:	and    %r15d,%r9d
  387b75:	mov    (%rcx,%r14,4),%r15d
  387b79:	and    %r8d,%r15d
  387b7c:	cmp    %r8d,%r15d
  387b7f:	sete   %r8b
  387b83:	shr    $0x6,%edx
  387b86:	and    $0x3,%edx
  387b89:	xor    %esi,%edx
  387b8b:	or     $0xc,%edx
  387b8e:	mov    (%rcx,%rdx,4),%esi
  387b91:	and    %r9d,%r8d
  387b94:	and    %eax,%esi
  387b96:	cmp    %eax,%esi
  387b98:	sete   %al
  387b9b:	movzbl %al,%eax
  387b9e:	and    %r8d,%eax
  387ba1:	mov    %eax,0x0(%r13,%rdi,4)
  387ba6:	inc    %rdi
  387ba9:	cmp    %rdi,%rbp
  387bac:	jne    387a90 <void vldb_stage2::Query<raw32_stage3::VisibleRawHash<nearby_raw32::K12Public, nearby_raw32::ExactNativePolicy<nearby_raw32::K12Public, true> > >(raw32_stage3::VisibleRawHash<nearby_raw32::K12Public, nearby_raw32::ExactNativePolicy<nearby_raw32::K12Public, true> > const&, vldb_stage2::QueryMode, unsigned long, unsigned int const*, unsigned int*)+0xa0>
  387bb2:	add    $0x18,%rsp
  387bb6:	pop    %rbx
  387bb7:	pop    %rbp
  387bb8:	pop    %r12
  387bba:	pop    %r13
  387bbc:	pop    %r14
  387bbe:	pop    %r15
  387bc0:	ret
