    e220:	test   %esi,%esi
    e222:	je     e23c <void insert<bloom_filters::K12ScalarOrControl, unsigned long>(bloom_filters::K12ScalarOrControl&, unsigned long, unsigned long const*)+0x1c>
    e224:	mov    0x10(%rdi),%rax
    e228:	sub    (%rdi),%rax
    e22b:	cmp    $0x200001,%rax
    e231:	jae    f310 <void bloom_filters::K12ScalarOrControl::InsertVector<true>(unsigned int, unsigned long const*)>
    e237:	jmp    f660 <void bloom_filters::K12ScalarOrControl::InsertVector<false>(unsigned int, unsigned long const*)>
    e23c:	ret
