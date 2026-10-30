00000000000f4ae0 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<16ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<16ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
   f4ae0:	test   %rsi,%rsi
   f4ae3:	je     f4be1 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<16ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<16ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x101>
   f4ae9:	push   %rbp
   f4aea:	push   %r15
   f4aec:	push   %r14
   f4aee:	push   %rbx
   f4aef:	mov    %rdx,%rax
   f4af2:	movabs $0xd6e8feb86659fd93,%r8
   f4afc:	xor    %r9d,%r9d
   f4aff:	movabs $0xf1357aea2e62a9c5,%r10
   f4b09:	vmovdqa -0xeffd1(%rip),%ymm0        # 4b40 <typeinfo name for main::$_60+0x370>
   f4b11:	vpbroadcastd -0xf1872(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
   f4b1a:	movabs $0x9e3779b97f4a7c15,%r11
   f4b24:	data16 data16 cs nopw 0x0(%rax,%rax,1)
   f4b30:	mov    (%rax,%r9,8),%rdx
   f4b34:	mov    %rdx,%rbx
   f4b37:	shr    $0x20,%rbx
   f4b3b:	xor    %rdx,%rbx
   f4b3e:	imul   %r8,%rbx
   f4b42:	mov    %rbx,%r14
   f4b45:	shr    $0x20,%r14
   f4b49:	xor    %rbx,%r14
   f4b4c:	imul   %r8,%r14
   f4b50:	mov    %r14,%rdx
   f4b53:	shr    $0x20,%rdx
   f4b57:	xor    %r14,%rdx
   f4b5a:	or     $0x1,%rdx
   f4b5e:	mov    0x20(%rdi),%rbx
   f4b62:	mulx   0x10(%rdi),%r14,%r14
   f4b68:	imul   %r10,%rdx
   f4b6c:	shl    $0x6,%r14
   f4b70:	vpbroadcastq %rdx,%ymm2
   f4b76:	vpsllvq %ymm0,%ymm2,%ymm2
   f4b7b:	vpsrld $0x1b,%ymm2,%ymm2
   f4b80:	vpsllvd %ymm2,%ymm1,%ymm2
   f4b85:	vmovdqa (%rbx,%r14,1),%ymm3
   f4b8b:	vptest %ymm2,%ymm3
   f4b90:	setb   %bpl
   f4b94:	mulx   %r11,%rdx,%r15
   f4b99:	xor    %rdx,%r15
   f4b9c:	vpbroadcastq %r15,%ymm2
   f4ba2:	vmovdqa 0x20(%rbx,%r14,1),%ymm3
   f4ba9:	vpsllvq %ymm0,%ymm2,%ymm2
   f4bae:	vpsrld $0x1b,%ymm2,%ymm2
   f4bb3:	vpsllvd %ymm2,%ymm1,%ymm2
   f4bb8:	vptest %ymm2,%ymm3
   f4bbd:	setb   %dl
   f4bc0:	prefetcht0 (%rbx,%r14,1)
   f4bc5:	and    %bpl,%dl
   f4bc8:	movzbl %dl,%edx
   f4bcb:	mov    %edx,(%rcx,%r9,4)
   f4bcf:	inc    %r9
   f4bd2:	cmp    %r9,%rsi
   f4bd5:	jne    f4b30 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<16ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<16ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
   f4bdb:	pop    %rbx
   f4bdc:	pop    %r14
   f4bde:	pop    %r15
   f4be0:	pop    %rbp
   f4be1:	vzeroupper
   f4be4:	ret
   f4be5:	int3
   f4be6:	int3
   f4be7:	int3
   f4be8:	int3
   f4be9:	int3
   f4bea:	int3
   f4beb:	int3
   f4bec:	int3
   f4bed:	int3
   f4bee:	int3
   f4bef:	int3

