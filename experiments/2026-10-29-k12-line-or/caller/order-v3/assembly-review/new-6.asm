   14560:	test   %esi,%esi
   14562:	je     1457c <void insert<bloom_filters::K12LineOrCandidate, unsigned long>(bloom_filters::K12LineOrCandidate&, unsigned long, unsigned long const*)+0x1c>
   14564:	mov    0x10(%rdi),%rax
   14568:	sub    (%rdi),%rax
   1456b:	cmp    $0x200001,%rax
   14571:	jae    152d0 <void bloom_filters::K12LineOrCandidate::InsertVector<true>(unsigned int, unsigned long const*)>
   14577:	jmp    15670 <void bloom_filters::K12LineOrCandidate::InsertVector<false>(unsigned int, unsigned long const*)>
   1457c:	ret
