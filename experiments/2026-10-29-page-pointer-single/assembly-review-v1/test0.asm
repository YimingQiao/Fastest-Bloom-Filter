
/home/yiming/projects/fastest-bf-lab/build/page-pointer-preflight-v1/native/worker/page_pointer_control:     file format elf64-x86-64


Disassembly of section .text:

00000000000127d0 <pbf::PageBloomFilter<4u>::test(unsigned char const*, unsigned int) const>:
   127d0:	push   %rbx
   127d1:	mov    %rdi,%rbx
   127d4:	mov    %rsi,%rdi
   127d7:	mov    %edx,%esi
   127d9:	test   %rdi,%rdi
   127dc:	je     128b8 <pbf::PageBloomFilter<4u>::test(unsigned char const*, unsigned int) const+0xe8>
   127e2:	call   bb60 <pbf::Hash(unsigned char const*, unsigned int)>
   127e7:	mov    %rax,%rdi
   127ea:	mov    %rdi,%r8
   127ed:	shr    $0x20,%r8
   127f1:	mov    %rdx,%rax
   127f4:	rorx   $0x1a,%r8d,%ecx
   127fa:	rorx   $0x18,%edi,%edx
   12800:	xor    %ecx,%edx
   12802:	rorx   $0x1c,%eax,%ecx
   12808:	shr    $0x20,%rax
   1280c:	xor    %ecx,%edx
   1280e:	rorx   $0x1e,%eax,%eax
   12814:	xor    %eax,%edx
   12816:	imul   0x10(%rbx),%rdx
   1281b:	mov    (%rbx),%esi
   1281d:	mov    0x8(%rbx),%ecx
   12820:	mov    %rdx,%rax
   12823:	mul    %rcx
   12826:	mov    $0x1,%r9d
   1282c:	lea    0x3(%rsi),%ecx
   1282f:	shlx   %ecx,%r9d,%ecx
   12834:	dec    %ecx
   12836:	mov    %ecx,%eax
   12838:	and    %edi,%eax
   1283a:	shlx   %rsi,%rdx,%rdx
   1283f:	mov    %eax,%esi
   12841:	shr    $0x3,%si
   12845:	and    $0x7,%eax
   12848:	movzwl %si,%esi
   1284b:	add    0x20(%rbx),%rdx
   1284f:	shlx   %eax,%r9d,%eax
   12854:	test   %al,(%rdx,%rsi,1)
   12857:	je     128d0 <pbf::PageBloomFilter<4u>::test(unsigned char const*, unsigned int) const+0x100>
   12859:	mov    %rdi,%rax
   1285c:	shr    $0x10,%rax
   12860:	and    %ecx,%eax
   12862:	mov    %eax,%esi
   12864:	shr    $0x3,%si
   12868:	and    $0x7,%eax
   1286b:	movzwl %si,%esi
   1286e:	shlx   %eax,%r9d,%eax
   12873:	test   %al,(%rdx,%rsi,1)
   12876:	je     128d0 <pbf::PageBloomFilter<4u>::test(unsigned char const*, unsigned int) const+0x100>
   12878:	and    %ecx,%r8d
   1287b:	mov    %r8d,%eax
   1287e:	shr    $0x3,%ax
   12882:	and    $0x7,%r8d
   12886:	movzwl %ax,%eax
   12889:	shlx   %r8d,%r9d,%r8d
   1288e:	test   %r8b,(%rdx,%rax,1)
   12892:	je     128d0 <pbf::PageBloomFilter<4u>::test(unsigned char const*, unsigned int) const+0x100>
   12894:	shr    $0x30,%rdi
   12898:	and    %edi,%ecx
   1289a:	mov    %ecx,%eax
   1289c:	shr    $0x3,%ax
   128a0:	movzwl %ax,%eax
   128a3:	and    $0x7,%ecx
   128a6:	shlx   %ecx,%r9d,%r9d
   128ab:	test   %r9b,(%rdx,%rax,1)
   128af:	setne  %al
   128b2:	pop    %rbx
   128b3:	ret
   128b4:	nopl   0x0(%rax)
   128b8:	xor    %eax,%eax
   128ba:	test   %edx,%edx
   128bc:	jne    128b2 <pbf::PageBloomFilter<4u>::test(unsigned char const*, unsigned int) const+0xe2>
   128be:	lea    -0xe8df(%rip),%rdi        # 3fe6 <pbf::PageBloomFilter<4u>::test(unsigned char const*, unsigned int) const::empty_key>
   128c5:	jmp    127e2 <pbf::PageBloomFilter<4u>::test(unsigned char const*, unsigned int) const+0x12>
   128ca:	nopw   0x0(%rax,%rax,1)
   128d0:	xor    %eax,%eax
   128d2:	pop    %rbx
   128d3:	ret
