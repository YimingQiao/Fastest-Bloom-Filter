00000000000c9e80 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
   c9e80:	test   %rsi,%rsi
   c9e83:	je     ca04d <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x1cd>
   c9e89:	push   %r14
   c9e8b:	push   %rbx
   c9e8c:	mov    %rdx,%rax
   c9e8f:	movabs $0xf1357aea2e62a9c5,%r9
   c9e99:	movabs $0xd6e8feb86659fd93,%r10
   c9ea3:	cmp    $0x1,%rsi
   c9ea7:	jne    c9eb1 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x31>
   c9ea9:	xor    %r8d,%r8d
   c9eac:	jmp    c9fcd <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x14d>
   c9eb1:	mov    %rsi,%r11
   c9eb4:	and    $0xfffffffffffffffe,%r11
   c9eb8:	xor    %r8d,%r8d
   c9ebb:	vmovdqa -0xc5383(%rip),%ymm0        # 4b40 <typeinfo name for main::$_60+0x370>
   c9ec3:	vpbroadcastd -0xc6c24(%rip),%xmm1        # 32a8 <__abi_tag+0x2fe4>
   c9ecc:	nopl   0x0(%rax)
   c9ed0:	mov    (%rax,%r8,8),%rdx
   c9ed4:	mov    %rdx,%rbx
   c9ed7:	shr    $0x20,%rbx
   c9edb:	xor    %rdx,%rbx
   c9ede:	imul   %r10,%rbx
   c9ee2:	mov    %rbx,%r14
   c9ee5:	shr    $0x20,%r14
   c9ee9:	xor    %rbx,%r14
   c9eec:	imul   %r10,%r14
   c9ef0:	mov    %r14,%rdx
   c9ef3:	shr    $0x20,%rdx
   c9ef7:	xor    %r14,%rdx
   c9efa:	or     $0x1,%rdx
   c9efe:	mov    0x20(%rdi),%rbx
   c9f02:	mulx   0x10(%rdi),%r14,%r14
   c9f08:	shl    $0x4,%r14
   c9f0c:	prefetcht0 (%rbx,%r14,1)
   c9f11:	imul   %r9,%rdx
   c9f15:	vmovdqu (%rbx,%r14,1),%ymm2
   c9f1b:	vpbroadcastq %rdx,%ymm3
   c9f21:	vpsllvq %ymm0,%ymm3,%ymm3
   c9f26:	vpsrld $0x1b,%ymm3,%ymm3
   c9f2b:	vpsllvd %ymm3,%ymm1,%ymm3
   c9f30:	xor    %edx,%edx
   c9f32:	vptest %ymm3,%ymm2
   c9f37:	prefetcht0 0x40(%rbx,%r14,1)
   c9f3d:	setb   %dl
   c9f40:	mov    %edx,(%rcx,%r8,4)
   c9f44:	mov    0x8(%rax,%r8,8),%rdx
   c9f49:	mov    %rdx,%rbx
   c9f4c:	shr    $0x20,%rbx
   c9f50:	xor    %rdx,%rbx
   c9f53:	imul   %r10,%rbx
   c9f57:	mov    %rbx,%r14
   c9f5a:	shr    $0x20,%r14
   c9f5e:	xor    %rbx,%r14
   c9f61:	imul   %r10,%r14
   c9f65:	mov    %r14,%rdx
   c9f68:	shr    $0x20,%rdx
   c9f6c:	xor    %r14,%rdx
   c9f6f:	or     $0x1,%rdx
   c9f73:	mov    0x20(%rdi),%rbx
   c9f77:	mulx   0x10(%rdi),%r14,%r14
   c9f7d:	shl    $0x4,%r14
   c9f81:	prefetcht0 (%rbx,%r14,1)
   c9f86:	prefetcht0 0x40(%rbx,%r14,1)
   c9f8c:	imul   %r9,%rdx
   c9f90:	vmovdqu (%rbx,%r14,1),%ymm2
   c9f96:	vpbroadcastq %rdx,%ymm3
   c9f9c:	vpsllvq %ymm0,%ymm3,%ymm3
   c9fa1:	vpsrld $0x1b,%ymm3,%ymm3
   c9fa6:	vpsllvd %ymm3,%ymm1,%ymm3
   c9fab:	xor    %edx,%edx
   c9fad:	vptest %ymm3,%ymm2
   c9fb2:	setb   %dl
   c9fb5:	mov    %edx,0x4(%rcx,%r8,4)
   c9fba:	add    $0x2,%r8
   c9fbe:	cmp    %r8,%r11
   c9fc1:	jne    c9ed0 <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
   c9fc7:	test   $0x1,%sil
   c9fcb:	je     ca04a <void inline_single_kernel<true, boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul>, unsigned long>(boost_baseline::Adapter<1ul, boost::bloom::fast_multiblock32<4ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x1ca>
   c9fcd:	mov    (%rax,%r8,8),%rax
   c9fd1:	mov    %rax,%rdx
   c9fd4:	shr    $0x20,%rdx
   c9fd8:	xor    %rax,%rdx
   c9fdb:	imul   %r10,%rdx
   c9fdf:	mov    %rdx,%rax
   c9fe2:	shr    $0x20,%rax
   c9fe6:	xor    %rdx,%rax
   c9fe9:	imul   %r10,%rax
   c9fed:	mov    %rax,%rdx
   c9ff0:	shr    $0x20,%rdx
   c9ff4:	xor    %rax,%rdx
   c9ff7:	or     $0x1,%rdx
   c9ffb:	mov    0x20(%rdi),%rax
   c9fff:	mulx   0x10(%rdi),%rsi,%rsi
   ca005:	shl    $0x4,%rsi
   ca009:	prefetcht0 (%rax,%rsi,1)
   ca00d:	prefetcht0 0x40(%rax,%rsi,1)
   ca012:	imul   %r9,%rdx
   ca016:	vmovdqu (%rax,%rsi,1),%ymm0
   ca01b:	vpbroadcastq %rdx,%ymm1
   ca021:	vpsllvq -0xc54ea(%rip),%ymm1,%ymm1        # 4b40 <typeinfo name for main::$_60+0x370>
   ca02a:	vpsrld $0x1b,%ymm1,%ymm1
   ca02f:	vmovdqa -0xc56d7(%rip),%ymm2        # 4960 <typeinfo name for main::$_60+0x190>
   ca037:	vpsllvd %ymm1,%ymm2,%ymm1
   ca03c:	xor    %eax,%eax
   ca03e:	vptest %ymm1,%ymm0
   ca043:	setb   %al
   ca046:	mov    %eax,(%rcx,%r8,4)
   ca04a:	pop    %rbx
   ca04b:	pop    %r14
   ca04d:	vzeroupper
   ca050:	ret
   ca051:	int3
   ca052:	int3
   ca053:	int3
   ca054:	int3
   ca055:	int3
   ca056:	int3
   ca057:	int3
   ca058:	int3
   ca059:	int3
   ca05a:	int3
   ca05b:	int3
   ca05c:	int3
   ca05d:	int3
   ca05e:	int3
   ca05f:	int3

