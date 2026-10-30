    cdd0:	test   %esi,%esi
    cdd2:	je     cdec <void insert<bloom_filters::K12ScalarOrControl, unsigned long>(bloom_filters::K12ScalarOrControl&, unsigned long, unsigned long const*)+0x1c>
    cdd4:	mov    0x10(%rdi),%rax
    cdd8:	sub    (%rdi),%rax
    cddb:	cmp    $0x200001,%rax
    cde1:	jae    dec0 <void bloom_filters::K12ScalarOrControl::InsertVector<true>(unsigned int, unsigned long const*)>
    cde7:	jmp    e210 <void bloom_filters::K12ScalarOrControl::InsertVector<false>(unsigned int, unsigned long const*)>
    cdec:	ret
