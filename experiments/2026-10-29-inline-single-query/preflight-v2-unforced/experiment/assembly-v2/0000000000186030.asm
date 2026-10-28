0000000000186030 <void inline_single_kernel<false, direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32>, unsigned long>(direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32> const&, unsigned long, unsigned long const*, unsigned int*)>:
  186030:	test   %rsi,%rsi
  186033:	je     1861f8 <void inline_single_kernel<false, direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32>, unsigned long>(direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32> const&, unsigned long, unsigned long const*, unsigned int*)+0x1c8>
  186039:	mov    %esi,%eax
  18603b:	and    $0x3,%eax
  18603e:	cmp    $0x4,%rsi
  186042:	jae    18604c <void inline_single_kernel<false, direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32>, unsigned long>(direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32> const&, unsigned long, unsigned long const*, unsigned int*)+0x1c>
  186044:	xor    %r8d,%r8d
  186047:	jmp    186188 <void inline_single_kernel<false, direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32>, unsigned long>(direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32> const&, unsigned long, unsigned long const*, unsigned int*)+0x158>
  18604c:	and    $0xfffffffffffffffc,%rsi
  186050:	xor    %r8d,%r8d
  186053:	vpbroadcastq -0x182d64(%rip),%xmm0        # 32f8 <_IO_stdin_used+0x44>
  18605c:	vpbroadcastd -0x182dbd(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
  186065:	data16 cs nopw 0x0(%rax,%rax,1)
  186070:	mov    (%rdx,%r8,8),%r9
  186074:	vpbroadcastq %r9,%xmm2
  18607a:	shr    $0x29,%r9
  18607e:	and    0x18(%rdi),%r9d
  186082:	mov    (%rdi),%r10
  186085:	shl    $0x5,%r9d
  186089:	vmovdqa (%r10,%r9,1),%ymm3
  18608f:	vpmultishiftqb %xmm2,%xmm0,%xmm2
  186095:	vpmovzxbd %xmm2,%ymm2
  18609a:	vprolvd %ymm2,%ymm1,%ymm2
  1860a0:	xor    %r9d,%r9d
  1860a3:	vptest %ymm2,%ymm3
  1860a8:	setb   %r9b
  1860ac:	mov    %r9d,(%rcx,%r8,4)
  1860b0:	mov    0x8(%rdx,%r8,8),%r9
  1860b5:	vpbroadcastq %r9,%xmm2
  1860bb:	shr    $0x29,%r9
  1860bf:	and    0x18(%rdi),%r9d
  1860c3:	mov    (%rdi),%r10
  1860c6:	shl    $0x5,%r9d
  1860ca:	vmovdqa (%r10,%r9,1),%ymm3
  1860d0:	vpmultishiftqb %xmm2,%xmm0,%xmm2
  1860d6:	vpmovzxbd %xmm2,%ymm2
  1860db:	vprolvd %ymm2,%ymm1,%ymm2
  1860e1:	xor    %r9d,%r9d
  1860e4:	vptest %ymm2,%ymm3
  1860e9:	setb   %r9b
  1860ed:	mov    %r9d,0x4(%rcx,%r8,4)
  1860f2:	mov    0x10(%rdx,%r8,8),%r9
  1860f7:	vpbroadcastq %r9,%xmm2
  1860fd:	shr    $0x29,%r9
  186101:	and    0x18(%rdi),%r9d
  186105:	mov    (%rdi),%r10
  186108:	shl    $0x5,%r9d
  18610c:	vmovdqa (%r10,%r9,1),%ymm3
  186112:	vpmultishiftqb %xmm2,%xmm0,%xmm2
  186118:	vpmovzxbd %xmm2,%ymm2
  18611d:	vprolvd %ymm2,%ymm1,%ymm2
  186123:	xor    %r9d,%r9d
  186126:	vptest %ymm2,%ymm3
  18612b:	setb   %r9b
  18612f:	mov    %r9d,0x8(%rcx,%r8,4)
  186134:	mov    0x18(%rdx,%r8,8),%r9
  186139:	vpbroadcastq %r9,%xmm2
  18613f:	shr    $0x29,%r9
  186143:	and    0x18(%rdi),%r9d
  186147:	mov    (%rdi),%r10
  18614a:	shl    $0x5,%r9d
  18614e:	vmovdqa (%r10,%r9,1),%ymm3
  186154:	vpmultishiftqb %xmm2,%xmm0,%xmm2
  18615a:	vpmovzxbd %xmm2,%ymm2
  18615f:	vprolvd %ymm2,%ymm1,%ymm2
  186165:	xor    %r9d,%r9d
  186168:	vptest %ymm2,%ymm3
  18616d:	setb   %r9b
  186171:	mov    %r9d,0xc(%rcx,%r8,4)
  186176:	add    $0x4,%r8
  18617a:	cmp    %r8,%rsi
  18617d:	jne    186070 <void inline_single_kernel<false, direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32>, unsigned long>(direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32> const&, unsigned long, unsigned long const*, unsigned int*)+0x40>
  186183:	test   %rax,%rax
  186186:	je     1861f8 <void inline_single_kernel<false, direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32>, unsigned long>(direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32> const&, unsigned long, unsigned long const*, unsigned int*)+0x1c8>
  186188:	lea    (%rcx,%r8,4),%rcx
  18618c:	lea    (%rdx,%r8,8),%rdx
  186190:	xor    %esi,%esi
  186192:	vpbroadcastq -0x182ea3(%rip),%xmm0        # 32f8 <_IO_stdin_used+0x44>
  18619b:	vpbroadcastd -0x182efc(%rip),%ymm1        # 32a8 <__abi_tag+0x2fe4>
  1861a4:	data16 data16 cs nopw 0x0(%rax,%rax,1)
  1861b0:	mov    (%rdx,%rsi,8),%r8
  1861b4:	vpbroadcastq %r8,%xmm2
  1861ba:	shr    $0x29,%r8
  1861be:	and    0x18(%rdi),%r8d
  1861c2:	mov    (%rdi),%r9
  1861c5:	shl    $0x5,%r8d
  1861c9:	vmovdqa (%r9,%r8,1),%ymm3
  1861cf:	vpmultishiftqb %xmm2,%xmm0,%xmm2
  1861d5:	vpmovzxbd %xmm2,%ymm2
  1861da:	vprolvd %ymm2,%ymm1,%ymm2
  1861e0:	xor    %r8d,%r8d
  1861e3:	vptest %ymm2,%ymm3
  1861e8:	setb   %r8b
  1861ec:	mov    %r8d,(%rcx,%rsi,4)
  1861f0:	inc    %rsi
  1861f3:	cmp    %rsi,%rax
  1861f6:	jne    1861b0 <void inline_single_kernel<false, direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32>, unsigned long>(direct_split_experiment::SingleShortcut<independent_vbmi_experiment::IndependentVbmi32> const&, unsigned long, unsigned long const*, unsigned int*)+0x180>
  1861f8:	vzeroupper
  1861fb:	ret
  1861fc:	int3
  1861fd:	int3
  1861fe:	int3
  1861ff:	int3

