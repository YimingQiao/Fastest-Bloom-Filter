000000000012b100 <void inline_single_kernel<false, boost_baseline::Adapter<6ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<6ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)>:
  12b100:	test   %rsi,%rsi
  12b103:	je     12b141 <void inline_single_kernel<false, boost_baseline::Adapter<6ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<6ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x41>
  12b105:	push   %r15
  12b107:	push   %r14
  12b109:	push   %r13
  12b10b:	push   %r12
  12b10d:	push   %rbx
  12b10e:	mov    %rcx,%rbx
  12b111:	mov    %rdx,%r14
  12b114:	mov    %rsi,%r15
  12b117:	mov    %rdi,%r12
  12b11a:	xor    %r13d,%r13d
  12b11d:	nopl   (%rax)
  12b120:	mov    (%r14,%r13,8),%rsi
  12b124:	mov    %r12,%rdi
  12b127:	call   12cec0 <boost_baseline::Adapter<6ul, boost::bloom::block<unsigned char, 1ul>, 0ul>::ScalarContains(unsigned long) const>
  12b12c:	mov    %eax,(%rbx,%r13,4)
  12b130:	inc    %r13
  12b133:	cmp    %r13,%r15
  12b136:	jne    12b120 <void inline_single_kernel<false, boost_baseline::Adapter<6ul, boost::bloom::block<unsigned char, 1ul>, 0ul>, unsigned long>(boost_baseline::Adapter<6ul, boost::bloom::block<unsigned char, 1ul>, 0ul> const&, unsigned long, unsigned long const*, unsigned int*)+0x20>
  12b138:	pop    %rbx
  12b139:	pop    %r12
  12b13b:	pop    %r13
  12b13d:	pop    %r14
  12b13f:	pop    %r15
  12b141:	ret
  12b142:	int3
  12b143:	int3
  12b144:	int3
  12b145:	int3
  12b146:	int3
  12b147:	int3
  12b148:	int3
  12b149:	int3
  12b14a:	int3
  12b14b:	int3
  12b14c:	int3
  12b14d:	int3
  12b14e:	int3
  12b14f:	int3

