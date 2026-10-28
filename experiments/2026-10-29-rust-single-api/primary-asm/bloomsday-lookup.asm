
/tmp/fastest-bf-rust-byte-external/release/compare_benchmark:     file format elf64-x86-64


Disassembly of section .text:

0000000000039fa0 <compare_benchmark::lookup>:
   39fa0:	48 83 ec 48          	sub    $0x48,%rsp
   39fa4:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
   39fa9:	4c 89 44 24 10       	mov    %r8,0x10(%rsp)
   39fae:	4c 39 c2             	cmp    %r8,%rdx
   39fb1:	0f 85 7f 00 00 00    	jne    3a036 <compare_benchmark::lookup+0x96>
   39fb7:	48 85 d2             	test   %rdx,%rdx
   39fba:	74 72                	je     3a02e <compare_benchmark::lookup+0x8e>
   39fbc:	44 8b 47 20          	mov    0x20(%rdi),%r8d
   39fc0:	4c 8b 4f 08          	mov    0x8(%rdi),%r9
   39fc4:	48 8b 47 10          	mov    0x10(%rdi),%rax
   39fc8:	45 31 d2             	xor    %r10d,%r10d
   39fcb:	c5 fd 6f 05 0d e0 fc 	vmovdqa -0x31ff3(%rip),%ymm0        # 7fe0 <anon.16f56ecd2c7bffacf69562dbd0b44b6b.863.llvm.15448142832521594973+0x110>
   39fd2:	ff 
   39fd3:	c4 e2 7d 58 0d 88 dd 	vpbroadcastd -0x32278(%rip),%ymm1        # 7d64 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.19.llvm.3671060894988460240+0x172>
   39fda:	fc ff 
   39fdc:	0f 1f 40 00          	nopl   0x0(%rax)
   39fe0:	4e 8b 1c d6          	mov    (%rsi,%r10,8),%r11
   39fe4:	4c 89 df             	mov    %r11,%rdi
   39fe7:	48 c1 ef 20          	shr    $0x20,%rdi
   39feb:	49 0f af f8          	imul   %r8,%rdi
   39fef:	48 c1 ef 20          	shr    $0x20,%rdi
   39ff3:	48 39 c7             	cmp    %rax,%rdi
   39ff6:	73 65                	jae    3a05d <compare_benchmark::lookup+0xbd>
   39ff8:	48 c1 e7 05          	shl    $0x5,%rdi
   39ffc:	62 d2 7d 28 7c d3    	vpbroadcastd %r11d,%ymm2
   3a002:	c4 e2 6d 40 d0       	vpmulld %ymm0,%ymm2,%ymm2
   3a007:	c4 c1 7e 6f 1c 39    	vmovdqu (%r9,%rdi,1),%ymm3
   3a00d:	c5 ed 72 d2 1b       	vpsrld $0x1b,%ymm2,%ymm2
   3a012:	c4 e2 75 47 d2       	vpsllvd %ymm2,%ymm1,%ymm2
   3a017:	31 ff                	xor    %edi,%edi
   3a019:	c4 e2 7d 17 da       	vptest %ymm2,%ymm3
   3a01e:	40 0f 92 c7          	setb   %dil
   3a022:	42 89 3c 91          	mov    %edi,(%rcx,%r10,4)
   3a026:	49 ff c2             	inc    %r10
   3a029:	4c 39 d2             	cmp    %r10,%rdx
   3a02c:	75 b2                	jne    39fe0 <compare_benchmark::lookup+0x40>
   3a02e:	48 83 c4 48          	add    $0x48,%rsp
   3a032:	c5 f8 77             	vzeroupper
   3a035:	c3                   	ret
   3a036:	48 c7 44 24 18 00 00 	movq   $0x0,0x18(%rsp)
   3a03d:	00 00 
   3a03f:	4c 8d 05 da fd 04 00 	lea    0x4fdda(%rip),%r8        # 89e20 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0xab0>
   3a046:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
   3a04b:	48 8d 54 24 10       	lea    0x10(%rsp),%rdx
   3a050:	48 8d 4c 24 18       	lea    0x18(%rsp),%rcx
   3a055:	31 ff                	xor    %edi,%edi
   3a057:	ff 15 a3 2c 05 00    	call   *0x52ca3(%rip)        # 8cd00 <_DYNAMIC+0x398>
   3a05d:	48 8d 15 4c fe 04 00 	lea    0x4fe4c(%rip),%rdx        # 89eb0 <anon.8b8f2e7a3508a3fdcfe9dcf6f9603a73.20.llvm.3671060894988460240+0xb40>
   3a064:	48 89 c6             	mov    %rax,%rsi
   3a067:	c5 f8 77             	vzeroupper
   3a06a:	ff 15 58 2b 05 00    	call   *0x52b58(%rip)        # 8cbc8 <_DYNAMIC+0x260>
