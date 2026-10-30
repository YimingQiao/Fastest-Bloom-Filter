   156b0:	test   %esi,%esi
   156b2:	je     156cc <void insert<bloom_filters::K12PrefetchLineOrCandidate, unsigned long>(bloom_filters::K12PrefetchLineOrCandidate&, unsigned long, unsigned long const*)+0x1c>
   156b4:	mov    0x10(%rdi),%rax
   156b8:	sub    (%rdi),%rax
   156bb:	cmp    $0x200001,%rax
   156c1:	jae    16420 <void bloom_filters::K12PrefetchLineOrCandidate::InsertVector<true>(unsigned int, unsigned long const*)>
   156c7:	jmp    167c0 <void bloom_filters::K12PrefetchLineOrCandidate::InsertVector<false>(unsigned int, unsigned long const*)>
   156cc:	ret
