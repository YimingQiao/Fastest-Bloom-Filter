    d0d0:	test   %esi,%esi
    d0d2:	je     d0ec <void insert<bloom_filters::K12ScalarOrControl, unsigned long>(bloom_filters::K12ScalarOrControl&, unsigned long, unsigned long const*)+0x1c>
    d0d4:	mov    0x10(%rdi),%rax
    d0d8:	sub    (%rdi),%rax
    d0db:	cmp    $0x200001,%rax
    d0e1:	jae    e1c0 <void bloom_filters::K12ScalarOrControl::InsertVector<true>(unsigned int, unsigned long const*)>
    d0e7:	jmp    e510 <void bloom_filters::K12ScalarOrControl::InsertVector<false>(unsigned int, unsigned long const*)>
    d0ec:	ret
