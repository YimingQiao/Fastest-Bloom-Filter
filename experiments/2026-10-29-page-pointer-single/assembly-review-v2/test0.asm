
/home/yiming/projects/fastest-bf-lab/build/page-pointer-preflight-v1/native/worker/page_pointer_control:     file format elf64-x86-64


Disassembly of section .text:

000000000000a0c0 <pbf::PageBloomFilter<4u>::test(unsigned char const*, unsigned int) const [clone .constprop.0]>:
    a0c0:	xor    %r11d,%r11d
    a0c3:	test   %rsi,%rsi
    a0c6:	je     a1b8 <pbf::PageBloomFilter<4u>::test(unsigned char const*, unsigned int) const [clone .constprop.0]+0xf8>
    a0cc:	mov    %rdi,%r8
    a0cf:	sub    $0x8,%rsp
    a0d3:	mov    %rsi,%rdi
    a0d6:	call   a020 <pbf::Hash(unsigned char const*, unsigned int) [clone .constprop.0]>
    a0db:	mov    %rax,%rdi
    a0de:	mov    %rdi,%r9
    a0e1:	shr    $0x20,%r9
    a0e5:	mov    %rdx,%rax
    a0e8:	rorx   $0x1a,%r9d,%ecx
    a0ee:	rorx   $0x18,%edi,%edx
    a0f4:	xor    %ecx,%edx
    a0f6:	rorx   $0x1c,%eax,%ecx
    a0fc:	shr    $0x20,%rax
    a100:	xor    %ecx,%edx
    a102:	rorx   $0x1e,%eax,%eax
    a108:	xor    %eax,%edx
    a10a:	imul   0x10(%r8),%rdx
    a10f:	mov    (%r8),%esi
    a112:	mov    0x8(%r8),%ecx
    a116:	mov    %rdx,%rax
    a119:	mul    %rcx
    a11c:	mov    $0x1,%r10d
    a122:	lea    0x3(%rsi),%ecx
    a125:	shlx   %ecx,%r10d,%ecx
    a12a:	dec    %ecx
    a12c:	mov    %ecx,%eax
    a12e:	and    %edi,%eax
    a130:	shlx   %rsi,%rdx,%rdx
    a135:	mov    %eax,%esi
    a137:	shr    $0x3,%si
    a13b:	and    $0x7,%eax
    a13e:	movzwl %si,%esi
    a141:	add    0x20(%r8),%rdx
    a145:	shlx   %eax,%r10d,%eax
    a14a:	test   %al,(%rdx,%rsi,1)
    a14d:	je     a1a9 <pbf::PageBloomFilter<4u>::test(unsigned char const*, unsigned int) const [clone .constprop.0]+0xe9>
    a14f:	mov    %rdi,%rax
    a152:	shr    $0x10,%rax
    a156:	and    %ecx,%eax
    a158:	mov    %eax,%esi
    a15a:	shr    $0x3,%si
    a15e:	and    $0x7,%eax
    a161:	movzwl %si,%esi
    a164:	shlx   %eax,%r10d,%eax
    a169:	test   %al,(%rdx,%rsi,1)
    a16c:	je     a1a9 <pbf::PageBloomFilter<4u>::test(unsigned char const*, unsigned int) const [clone .constprop.0]+0xe9>
    a16e:	and    %ecx,%r9d
    a171:	mov    %r9d,%eax
    a174:	shr    $0x3,%ax
    a178:	and    $0x7,%r9d
    a17c:	movzwl %ax,%eax
    a17f:	shlx   %r9d,%r10d,%r9d
    a184:	test   %r9b,(%rdx,%rax,1)
    a188:	je     a1a9 <pbf::PageBloomFilter<4u>::test(unsigned char const*, unsigned int) const [clone .constprop.0]+0xe9>
    a18a:	shr    $0x30,%rdi
    a18e:	and    %edi,%ecx
    a190:	mov    %ecx,%eax
    a192:	shr    $0x3,%ax
    a196:	and    $0x7,%ecx
    a199:	movzwl %ax,%eax
    a19c:	shlx   %ecx,%r10d,%r10d
    a1a1:	test   %r10b,(%rdx,%rax,1)
    a1a5:	setne  %r11b
    a1a9:	mov    %r11d,%eax
    a1ac:	add    $0x8,%rsp
    a1b0:	ret
    a1b1:	nopl   0x0(%rax)
    a1b8:	mov    %r11d,%eax
    a1bb:	ret
