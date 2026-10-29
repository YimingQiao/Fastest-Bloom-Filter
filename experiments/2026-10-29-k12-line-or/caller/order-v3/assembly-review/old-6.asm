   14260:	test   %esi,%esi
   14262:	je     1427c <void insert<bloom_filters::K12LineOrCandidate, unsigned long>(bloom_filters::K12LineOrCandidate&, unsigned long, unsigned long const*)+0x1c>
   14264:	mov    0x10(%rdi),%rax
   14268:	sub    (%rdi),%rax
   1426b:	cmp    $0x200001,%rax
   14271:	jae    14fd0 <void bloom_filters::K12LineOrCandidate::InsertVector<true>(unsigned int, unsigned long const*)>
   14277:	jmp    15370 <void bloom_filters::K12LineOrCandidate::InsertVector<false>(unsigned int, unsigned long const*)>
   1427c:	ret
