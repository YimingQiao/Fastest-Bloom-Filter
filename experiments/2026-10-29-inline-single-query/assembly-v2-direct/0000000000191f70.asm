0000000000191f70 <void inline_single_kernel<false, direct_split_experiment::SingleShortcut<direct_split_experiment::IndependentSplit32>, unsigned long>(direct_split_experiment::SingleShortcut<direct_split_experiment::IndependentSplit32> const&, unsigned long, unsigned long const*, unsigned int*)>:
  191f70:	test   %rsi,%rsi
  191f73:	je     192182 <void inline_single_kernel<false, direct_split_experiment::SingleShortcut<direct_split_experiment::IndependentSplit32>, unsigned long>(direct_split_experiment::SingleShortcut<direct_split_experiment::IndependentSplit32> const&, unsigned long, unsigned long const*, unsigned int*)+0x212>
  191f79:	mov    %esi,%eax
  191f7b:	and    $0x3,%eax
  191f7e:	cmp    $0x4,%rsi
  191f82:	jae    191f8c <void inline_single_kernel<false, direct_split_experiment::SingleShortcut<direct_split_experiment::IndependentSplit32>, unsigned long>(direct_split_experiment::SingleShortcut<direct_split_experiment::IndependentSplit32> const&, unsigned long, unsigned long const*, unsigned int*)+0x1c>
  191f84:	xor    %r8d,%r8d
  191f87:	jmp    1920fe <void inline_single_kernel<false, direct_split_experiment::SingleShortcut<direct_split_experiment::IndependentSplit32>, unsigned long>(direct_split_experiment::SingleShortcut<direct_split_experiment::IndependentSplit32> const&, unsigned long, unsigned long const*, unsigned int*)+0x18e>
  191f8c:	and    $0xfffffffffffffffc,%rsi
  191f90:	xor    %r8d,%r8d
  191f93:	vmovdqa -0x18d47b(%rip),%ymm0        # 4b20 <typeinfo name for main::$_60+0x350>
  191f9b:	vpbroadcastq -0x18eb94(%rip),%ymm1        # 3410 <_IO_stdin_used+0x15c>
  191fa4:	vpbroadcastd -0x18ed09(%rip),%ymm2        # 32a4 <__abi_tag+0x2fe0>
  191fad:	vpbroadcastd -0x18ed0e(%rip),%ymm3        # 32a8 <__abi_tag+0x2fe4>
  191fb6:	cs nopw 0x0(%rax,%rax,1)
  191fc0:	mov    (%rdx,%r8,8),%r9
  191fc4:	mov    %r9,%r10
  191fc7:	shr    $0x29,%r10
  191fcb:	and    0x18(%rdi),%r10d
  191fcf:	vpbroadcastq %r9,%ymm4
  191fd5:	mov    (%rdi),%r9
  191fd8:	shl    $0x5,%r10d
  191fdc:	vmovdqa (%r9,%r10,1),%ymm5
  191fe2:	vpsrlvq %ymm0,%ymm4,%ymm4
  191fe7:	vpshufd $0xa0,%ymm4,%ymm4
  191fec:	vpsrlvd %ymm1,%ymm4,%ymm4
  191ff1:	vpand  %ymm2,%ymm4,%ymm4
  191ff5:	vpsllvd %ymm4,%ymm3,%ymm4
  191ffa:	xor    %r9d,%r9d
  191ffd:	vptest %ymm4,%ymm5
  192002:	setb   %r9b
  192006:	mov    %r9d,(%rcx,%r8,4)
  19200a:	mov    0x8(%rdx,%r8,8),%r9
  19200f:	vpbroadcastq %r9,%ymm4
  192015:	shr    $0x29,%r9
  192019:	and    0x18(%rdi),%r9d
  19201d:	mov    (%rdi),%r10
  192020:	shl    $0x5,%r9d
  192024:	vmovdqa (%r10,%r9,1),%ymm5
  19202a:	vpsrlvq %ymm0,%ymm4,%ymm4
  19202f:	vpshufd $0xa0,%ymm4,%ymm4
  192034:	vpsrlvd %ymm1,%ymm4,%ymm4
  192039:	vpand  %ymm2,%ymm4,%ymm4
  19203d:	vpsllvd %ymm4,%ymm3,%ymm4
  192042:	xor    %r9d,%r9d
  192045:	vptest %ymm4,%ymm5
  19204a:	setb   %r9b
  19204e:	mov    %r9d,0x4(%rcx,%r8,4)
  192053:	mov    0x10(%rdx,%r8,8),%r9
  192058:	vpbroadcastq %r9,%ymm4
  19205e:	shr    $0x29,%r9
  192062:	and    0x18(%rdi),%r9d
  192066:	mov    (%rdi),%r10
  192069:	shl    $0x5,%r9d
  19206d:	vmovdqa (%r10,%r9,1),%ymm5
  192073:	vpsrlvq %ymm0,%ymm4,%ymm4
  192078:	vpshufd $0xa0,%ymm4,%ymm4
  19207d:	vpsrlvd %ymm1,%ymm4,%ymm4
  192082:	vpand  %ymm2,%ymm4,%ymm4
  192086:	vpsllvd %ymm4,%ymm3,%ymm4
  19208b:	xor    %r9d,%r9d
  19208e:	vptest %ymm4,%ymm5
  192093:	setb   %r9b
  192097:	mov    %r9d,0x8(%rcx,%r8,4)
  19209c:	mov    0x18(%rdx,%r8,8),%r9
  1920a1:	mov    %r9,%r10
  1920a4:	shr    $0x29,%r10
  1920a8:	and    0x18(%rdi),%r10d
  1920ac:	vpbroadcastq %r9,%ymm4
  1920b2:	mov    (%rdi),%r9
  1920b5:	shl    $0x5,%r10d
  1920b9:	vmovdqa (%r9,%r10,1),%ymm5
  1920bf:	vpsrlvq %ymm0,%ymm4,%ymm4
  1920c4:	vpshufd $0xa0,%ymm4,%ymm4
  1920c9:	vpsrlvd %ymm1,%ymm4,%ymm4
  1920ce:	vpand  %ymm2,%ymm4,%ymm4
  1920d2:	vpsllvd %ymm4,%ymm3,%ymm4
  1920d7:	xor    %r9d,%r9d
  1920da:	vptest %ymm4,%ymm5
  1920df:	setb   %r9b
  1920e3:	mov    %r9d,0xc(%rcx,%r8,4)
  1920e8:	add    $0x4,%r8
  1920ec:	cmp    %r8,%rsi
  1920ef:	jne    191fc0 <void inline_single_kernel<false, direct_split_experiment::SingleShortcut<direct_split_experiment::IndependentSplit32>, unsigned long>(direct_split_experiment::SingleShortcut<direct_split_experiment::IndependentSplit32> const&, unsigned long, unsigned long const*, unsigned int*)+0x50>
  1920f5:	test   %rax,%rax
  1920f8:	je     192182 <void inline_single_kernel<false, direct_split_experiment::SingleShortcut<direct_split_experiment::IndependentSplit32>, unsigned long>(direct_split_experiment::SingleShortcut<direct_split_experiment::IndependentSplit32> const&, unsigned long, unsigned long const*, unsigned int*)+0x212>
  1920fe:	lea    (%rcx,%r8,4),%rcx
  192102:	lea    (%rdx,%r8,8),%rdx
  192106:	xor    %esi,%esi
  192108:	vmovdqa -0x18d5f0(%rip),%ymm0        # 4b20 <typeinfo name for main::$_60+0x350>
  192110:	vpbroadcastq -0x18ed09(%rip),%ymm1        # 3410 <_IO_stdin_used+0x15c>
  192119:	vpbroadcastd -0x18ee7e(%rip),%ymm2        # 32a4 <__abi_tag+0x2fe0>
  192122:	vpbroadcastd -0x18ee83(%rip),%ymm3        # 32a8 <__abi_tag+0x2fe4>
  19212b:	nopl   0x0(%rax,%rax,1)
  192130:	mov    (%rdx,%rsi,8),%r8
  192134:	mov    %r8,%r9
  192137:	shr    $0x29,%r9
  19213b:	and    0x18(%rdi),%r9d
  19213f:	vpbroadcastq %r8,%ymm4
  192145:	mov    (%rdi),%r8
  192148:	shl    $0x5,%r9d
  19214c:	vmovdqa (%r8,%r9,1),%ymm5
  192152:	vpsrlvq %ymm0,%ymm4,%ymm4
  192157:	vpshufd $0xa0,%ymm4,%ymm4
  19215c:	vpsrlvd %ymm1,%ymm4,%ymm4
  192161:	vpand  %ymm2,%ymm4,%ymm4
  192165:	vpsllvd %ymm4,%ymm3,%ymm4
  19216a:	xor    %r8d,%r8d
  19216d:	vptest %ymm4,%ymm5
  192172:	setb   %r8b
  192176:	mov    %r8d,(%rcx,%rsi,4)
  19217a:	inc    %rsi
  19217d:	cmp    %rsi,%rax
  192180:	jne    192130 <void inline_single_kernel<false, direct_split_experiment::SingleShortcut<direct_split_experiment::IndependentSplit32>, unsigned long>(direct_split_experiment::SingleShortcut<direct_split_experiment::IndependentSplit32> const&, unsigned long, unsigned long const*, unsigned int*)+0x1c0>
  192182:	vzeroupper
  192185:	ret
  192186:	int3
  192187:	int3
  192188:	int3
  192189:	int3
  19218a:	int3
  19218b:	int3
  19218c:	int3
  19218d:	int3
  19218e:	int3
  19218f:	int3

