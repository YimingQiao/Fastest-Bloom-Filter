
/home/yiming/projects/fastest-bf-lab/build/vldb-nearby-raw32-v1/native/nearby_raw32:     file format elf64-x86-64


Disassembly of section .text:

0000000000385a30 <void vldb_stage2::DenseCall<raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > >(raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > const&, unsigned int, unsigned int const*, unsigned int*)>:
  385a30:	mov    %esi,%esi
  385a32:	test   %rsi,%rsi
  385a35:	je     386112 <void vldb_stage2::DenseCall<raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > >(raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > const&, unsigned int, unsigned int const*, unsigned int*)+0x6e2>
  385a3b:	push   %rbp
  385a3c:	mov    %rdx,%r11
  385a3f:	mov    %rcx,%r8
  385a42:	mov    %rsp,%rbp
  385a45:	push   %r13
  385a47:	mov    %rsi,%r9
  385a4a:	xor    %edx,%edx
  385a4c:	push   %r12
  385a4e:	movabs $0xd6e8feb86659fd93,%rcx
  385a58:	push   %rbx
  385a59:	nopl   0x0(%rax)
  385a60:	mov    (%r11,%rdx,4),%eax
  385a64:	imul   %rcx,%rax
  385a68:	mov    %rax,%r10
  385a6b:	shr    $0x20,%r10
  385a6f:	xor    %r10,%rax
  385a72:	imul   %rcx,%rax
  385a76:	mov    0x128(%rdi),%r10
  385a7d:	mov    %rax,%rbx
  385a80:	shr    $0x20,%rbx
  385a84:	xor    %rbx,%rax
  385a87:	mov    %rax,(%r10,%rdx,8)
  385a8b:	inc    %rdx
  385a8e:	cmp    %rsi,%rdx
  385a91:	jne    385a60 <void vldb_stage2::DenseCall<raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > >(raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > const&, unsigned int, unsigned int const*, unsigned int*)+0x30>
  385a93:	mov    0x128(%rdi),%rdx
  385a9a:	cmp    $0x3,%r9d
  385a9e:	jbe    385f50 <void vldb_stage2::DenseCall<raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > >(raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > const&, unsigned int, unsigned int const*, unsigned int*)+0x520>
  385aa4:	mov    0x18(%rdi),%rax
  385aa8:	mov    (%rdi),%r9
  385aab:	sub    0x10(%rdi),%rax
  385aaf:	vmovdqu64 (%r9),%zmm3
  385ab5:	vmovdqu64 0x40(%r9),%zmm4
  385abc:	cmp    $0x200000,%rax
  385ac2:	jbe    385d00 <void vldb_stage2::DenseCall<raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > >(raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > const&, unsigned int, unsigned int const*, unsigned int*)+0x2d0>
  385ac8:	cmp    $0xf,%rsi
  385acc:	jbe    386113 <void vldb_stage2::DenseCall<raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > >(raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > const&, unsigned int, unsigned int const*, unsigned int*)+0x6e3>
  385ad2:	lea    -0x10(%rsi),%rbx
  385ad6:	mov    %rbx,%rcx
  385ad9:	and    $0xfffffffffffffff0,%rcx
  385add:	lea    0x60(%rcx),%r11
  385ae1:	mov    $0x7,%ecx
  385ae6:	vpbroadcastd %ecx,%zmm11
  385aec:	mov    $0x8,%ecx
  385af1:	vmovdqa32 -0x30c37b(%rip),%zmm8        # 79780 <bloom_filters::FastPatternBF::sparse_patterns_+0x320>
  385afb:	vmovdqa32 -0x30c345(%rip),%zmm7        # 797c0 <bloom_filters::FastPatternBF::sparse_patterns_+0x360>
  385b05:	mov    %rdx,%rax
  385b08:	mov    $0x50,%r10d
  385b0e:	vpbroadcastd %ecx,%zmm10
  385b14:	mov    $0x1,%r12d
  385b1a:	kxnorw %k2,%k2,%k2
  385b1e:	jmp    385bf5 <void vldb_stage2::DenseCall<raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > >(raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > const&, unsigned int, unsigned int const*, unsigned int*)+0x1c5>
  385b23:	nopl   0x0(%rax,%rax,1)
  385b28:	vmovdqu64 (%rax),%zmm1
  385b2e:	vmovdqu64 0x40(%rax),%zmm5
  385b35:	vmovdqa32 %zmm1,%zmm2
  385b3b:	vpermt2d %zmm5,%zmm7,%zmm2
  385b41:	vmovdqa32 %zmm1,%zmm0
  385b47:	vpbroadcastd %ecx,%zmm1
  385b4d:	vpermt2d %zmm5,%zmm8,%zmm0
  385b53:	vpandd %zmm1,%zmm2,%zmm1
  385b59:	vmovdqa32 %zmm3,%zmm2
  385b5f:	vpsrld $0x5,%zmm0,%zmm5
  385b66:	vpermt2d %zmm4,%zmm0,%zmm2
  385b6c:	vprolvd %zmm5,%zmm2,%zmm2
  385b72:	vpsrld $0x14,%zmm0,%zmm9
  385b79:	vpsrld $0xf,%zmm0,%zmm5
  385b80:	vpsrld $0xa,%zmm0,%zmm0
  385b87:	vpermi2d %zmm4,%zmm3,%zmm0
  385b8d:	vprolvd %zmm5,%zmm0,%zmm0
  385b93:	vmovdqa32 %zmm10,%zmm6
  385b99:	vpternlogd $0xf8,%zmm9,%zmm11,%zmm6
  385ba0:	kmovw  %k2,%k3
  385ba4:	vpgatherdd (%r9,%zmm1,4),%zmm5{%k3}
  385bab:	vpxord %zmm1,%zmm6,%zmm1
  385bb1:	kmovw  %k2,%k4
  385bb5:	vpgatherdd (%r9,%zmm1,4),%zmm6{%k4}
  385bbc:	vpandd %zmm2,%zmm5,%zmm1
  385bc2:	vpandd %zmm0,%zmm6,%zmm5
  385bc8:	vpcmpeqd %zmm0,%zmm5,%k1
  385bcf:	sub    $0xffffffffffffff80,%rax
  385bd3:	vpcmpeqd %zmm2,%zmm1,%k1{%k1}
  385bda:	vpbroadcastd %r12d,%zmm0{%k1}{z}
  385be0:	vmovdqu64 %zmm0,-0x140(%r8,%r10,4)
  385be8:	add    $0x10,%r10
  385bec:	cmp    %r11,%r10
  385bef:	je     385eb0 <void vldb_stage2::DenseCall<raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > >(raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > const&, unsigned int, unsigned int const*, unsigned int*)+0x480>
  385bf5:	mov    0x10(%rdi),%r9
  385bf9:	mov    0x8(%rdi),%ecx
  385bfc:	cmp    %r10,%rsi
  385bff:	jb     385b28 <void vldb_stage2::DenseCall<raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > >(raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > const&, unsigned int, unsigned int const*, unsigned int*)+0xf8>
  385c05:	mov    %ecx,%r13d
  385c08:	and    0x204(%rax),%r13d
  385c0f:	prefetcht0 (%r9,%r13,4)
  385c14:	mov    %ecx,%r13d
  385c17:	and    0x20c(%rax),%r13d
  385c1e:	prefetcht0 (%r9,%r13,4)
  385c23:	mov    %ecx,%r13d
  385c26:	and    0x214(%rax),%r13d
  385c2d:	prefetcht0 (%r9,%r13,4)
  385c32:	mov    %ecx,%r13d
  385c35:	and    0x21c(%rax),%r13d
  385c3c:	prefetcht0 (%r9,%r13,4)
  385c41:	mov    %ecx,%r13d
  385c44:	and    0x224(%rax),%r13d
  385c4b:	prefetcht0 (%r9,%r13,4)
  385c50:	mov    %ecx,%r13d
  385c53:	and    0x22c(%rax),%r13d
  385c5a:	prefetcht0 (%r9,%r13,4)
  385c5f:	mov    %ecx,%r13d
  385c62:	and    0x234(%rax),%r13d
  385c69:	prefetcht0 (%r9,%r13,4)
  385c6e:	mov    %ecx,%r13d
  385c71:	and    0x23c(%rax),%r13d
  385c78:	prefetcht0 (%r9,%r13,4)
  385c7d:	mov    %ecx,%r13d
  385c80:	and    0x244(%rax),%r13d
  385c87:	prefetcht0 (%r9,%r13,4)
  385c8c:	mov    %ecx,%r13d
  385c8f:	and    0x24c(%rax),%r13d
  385c96:	prefetcht0 (%r9,%r13,4)
  385c9b:	mov    %ecx,%r13d
  385c9e:	and    0x254(%rax),%r13d
  385ca5:	prefetcht0 (%r9,%r13,4)
  385caa:	mov    %ecx,%r13d
  385cad:	and    0x25c(%rax),%r13d
  385cb4:	prefetcht0 (%r9,%r13,4)
  385cb9:	mov    %ecx,%r13d
  385cbc:	and    0x264(%rax),%r13d
  385cc3:	prefetcht0 (%r9,%r13,4)
  385cc8:	mov    %ecx,%r13d
  385ccb:	and    0x26c(%rax),%r13d
  385cd2:	prefetcht0 (%r9,%r13,4)
  385cd7:	mov    %ecx,%r13d
  385cda:	and    0x274(%rax),%r13d
  385ce1:	prefetcht0 (%r9,%r13,4)
  385ce6:	mov    %ecx,%r13d
  385ce9:	and    0x27c(%rax),%r13d
  385cf0:	prefetcht0 (%r9,%r13,4)
  385cf5:	jmp    385b28 <void vldb_stage2::DenseCall<raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > >(raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > const&, unsigned int, unsigned int const*, unsigned int*)+0xf8>
  385cfa:	nopw   0x0(%rax,%rax,1)
  385d00:	cmp    $0xf,%rsi
  385d04:	jbe    38612d <void vldb_stage2::DenseCall<raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > >(raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > const&, unsigned int, unsigned int const*, unsigned int*)+0x6fd>
  385d0a:	mov    $0x7,%ecx
  385d0f:	vpbroadcastd %ecx,%zmm11
  385d15:	vmovdqa32 -0x30c59f(%rip),%zmm8        # 79780 <bloom_filters::FastPatternBF::sparse_patterns_+0x320>
  385d1f:	mov    $0x8,%ecx
  385d24:	vmovdqa32 -0x30c56e(%rip),%zmm7        # 797c0 <bloom_filters::FastPatternBF::sparse_patterns_+0x360>
  385d2e:	mov    $0x10,%eax
  385d33:	vpbroadcastd %ecx,%zmm10
  385d39:	mov    $0x1,%r9d
  385d3f:	kxnorw %k2,%k2,%k2
  385d43:	nopl   0x0(%rax,%rax,1)
  385d48:	vmovdqu64 -0x80(%rdx,%rax,8),%zmm1
  385d50:	vmovdqu64 -0x40(%rdx,%rax,8),%zmm2
  385d58:	vmovdqa32 %zmm1,%zmm0
  385d5e:	vpermt2d %zmm2,%zmm8,%zmm0
  385d64:	vpermt2d %zmm2,%zmm7,%zmm1
  385d6a:	vmovdqa32 %zmm3,%zmm2
  385d70:	vpsrld $0x5,%zmm0,%zmm5
  385d77:	vpermt2d %zmm4,%zmm0,%zmm2
  385d7d:	vprolvd %zmm5,%zmm2,%zmm2
  385d83:	vpsrld $0x14,%zmm0,%zmm9
  385d8a:	vpsrld $0xf,%zmm0,%zmm5
  385d91:	vpsrld $0xa,%zmm0,%zmm0
  385d98:	vpermi2d %zmm4,%zmm3,%zmm0
  385d9e:	vprolvd %zmm5,%zmm0,%zmm0
  385da4:	mov    0x10(%rdi),%rcx
  385da8:	vmovdqa32 %zmm10,%zmm6
  385dae:	vpandd 0x8(%rdi){1to16},%zmm1,%zmm1
  385db5:	vpternlogd $0xf8,%zmm9,%zmm11,%zmm6
  385dbc:	kmovw  %k2,%k5
  385dc0:	vpgatherdd (%rcx,%zmm1,4),%zmm5{%k5}
  385dc7:	vpxord %zmm1,%zmm6,%zmm1
  385dcd:	kmovw  %k2,%k6
  385dd1:	vpgatherdd (%rcx,%zmm1,4),%zmm6{%k6}
  385dd8:	vpandd %zmm2,%zmm5,%zmm1
  385dde:	vpandd %zmm0,%zmm6,%zmm5
  385de4:	vpcmpeqd %zmm0,%zmm5,%k1
  385deb:	vpcmpeqd %zmm2,%zmm1,%k1{%k1}
  385df2:	vpbroadcastd %r9d,%zmm0{%k1}{z}
  385df8:	vmovdqu64 %zmm0,-0x40(%r8,%rax,4)
  385e00:	add    $0x10,%rax
  385e04:	cmp    %rax,%rsi
  385e07:	jae    385d48 <void vldb_stage2::DenseCall<raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > >(raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > const&, unsigned int, unsigned int const*, unsigned int*)+0x318>
  385e0d:	lea    -0x10(%rsi),%rax
  385e11:	and    $0xfffffffffffffff0,%rax
  385e15:	lea    0x10(%rax),%r11
  385e19:	add    $0x18,%rax
  385e1d:	cmp    %rax,%rsi
  385e20:	jae    386078 <void vldb_stage2::DenseCall<raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > >(raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > const&, unsigned int, unsigned int const*, unsigned int*)+0x648>
  385e26:	cmp    %rsi,%r11
  385e29:	jae    385ea6 <void vldb_stage2::DenseCall<raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > >(raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > const&, unsigned int, unsigned int const*, unsigned int*)+0x476>
  385e2b:	nopl   0x0(%rax,%rax,1)
  385e30:	mov    (%rdi),%r9
  385e33:	mov    (%rdx,%r11,8),%rax
  385e37:	mov    %rax,%rbx
  385e3a:	and    $0x1f,%ebx
  385e3d:	mov    (%r9,%rbx,4),%ebx
  385e41:	mov    %eax,%ecx
  385e43:	shr    $0x5,%ecx
  385e46:	rol    %cl,%ebx
  385e48:	mov    %eax,%ecx
  385e4a:	shr    $0xa,%ecx
  385e4d:	mov    %ecx,%r12d
  385e50:	and    $0x1f,%r12d
  385e54:	mov    (%r9,%r12,4),%r9d
  385e58:	mov    %rax,%r10
  385e5b:	mov    %eax,%ecx
  385e5d:	shr    $0x14,%eax
  385e60:	shr    $0xf,%ecx
  385e63:	shr    $0x20,%r10
  385e67:	and    $0x7,%eax
  385e6a:	and    0x8(%rdi),%r10d
  385e6e:	rol    %cl,%r9d
  385e71:	add    $0x8,%eax
  385e74:	mov    0x10(%rdi),%rcx
  385e78:	xor    %r10d,%eax
  385e7b:	mov    (%rcx,%rax,4),%r13d
  385e7f:	mov    (%rcx,%r10,4),%eax
  385e83:	and    %r9d,%r13d
  385e86:	cmp    %r9d,%r13d
  385e89:	sete   %r9b
  385e8d:	and    %ebx,%eax
  385e8f:	cmp    %ebx,%eax
  385e91:	sete   %al
  385e94:	movzbl %al,%eax
  385e97:	and    %r9d,%eax
  385e9a:	mov    %eax,(%r8,%r11,4)
  385e9e:	inc    %r11
  385ea1:	cmp    %rsi,%r11
  385ea4:	jne    385e30 <void vldb_stage2::DenseCall<raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > >(raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > const&, unsigned int, unsigned int const*, unsigned int*)+0x400>
  385ea6:	vzeroupper
  385ea9:	pop    %rbx
  385eaa:	pop    %r12
  385eac:	pop    %r13
  385eae:	pop    %rbp
  385eaf:	ret
  385eb0:	and    $0xfffffffffffffff0,%rbx
  385eb4:	lea    0x10(%rbx),%r11
  385eb8:	add    $0x18,%rbx
  385ebc:	cmp    %rbx,%rsi
  385ebf:	jae    385fd8 <void vldb_stage2::DenseCall<raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > >(raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > const&, unsigned int, unsigned int const*, unsigned int*)+0x5a8>
  385ec5:	cmp    %rsi,%r11
  385ec8:	jae    385ea6 <void vldb_stage2::DenseCall<raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > >(raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > const&, unsigned int, unsigned int const*, unsigned int*)+0x476>
  385eca:	nopw   0x0(%rax,%rax,1)
  385ed0:	mov    (%rdi),%r9
  385ed3:	mov    (%rdx,%r11,8),%rax
  385ed7:	mov    %rax,%rbx
  385eda:	and    $0x1f,%ebx
  385edd:	mov    (%r9,%rbx,4),%ebx
  385ee1:	mov    %eax,%ecx
  385ee3:	shr    $0x5,%ecx
  385ee6:	rol    %cl,%ebx
  385ee8:	mov    %eax,%ecx
  385eea:	shr    $0xa,%ecx
  385eed:	mov    %ecx,%r12d
  385ef0:	and    $0x1f,%r12d
  385ef4:	mov    (%r9,%r12,4),%r9d
  385ef8:	mov    %rax,%r10
  385efb:	mov    %eax,%ecx
  385efd:	shr    $0x14,%eax
  385f00:	shr    $0xf,%ecx
  385f03:	shr    $0x20,%r10
  385f07:	and    $0x7,%eax
  385f0a:	and    0x8(%rdi),%r10d
  385f0e:	rol    %cl,%r9d
  385f11:	add    $0x8,%eax
  385f14:	mov    0x10(%rdi),%rcx
  385f18:	xor    %r10d,%eax
  385f1b:	mov    (%rcx,%rax,4),%r13d
  385f1f:	mov    (%rcx,%r10,4),%eax
  385f23:	and    %r9d,%r13d
  385f26:	cmp    %r9d,%r13d
  385f29:	sete   %r9b
  385f2d:	and    %ebx,%eax
  385f2f:	cmp    %ebx,%eax
  385f31:	sete   %al
  385f34:	movzbl %al,%eax
  385f37:	and    %r9d,%eax
  385f3a:	mov    %eax,(%r8,%r11,4)
  385f3e:	inc    %r11
  385f41:	cmp    %rsi,%r11
  385f44:	jne    385ed0 <void vldb_stage2::DenseCall<raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > >(raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > const&, unsigned int, unsigned int const*, unsigned int*)+0x4a0>
  385f46:	jmp    385ea6 <void vldb_stage2::DenseCall<raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > >(raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > const&, unsigned int, unsigned int const*, unsigned int*)+0x476>
  385f4b:	nopl   0x0(%rax,%rax,1)
  385f50:	xor    %r10d,%r10d
  385f53:	nopl   0x0(%rax,%rax,1)
  385f58:	mov    (%rdx,%r10,8),%rax
  385f5c:	mov    (%rdi),%r12
  385f5f:	mov    %rax,%r11
  385f62:	and    $0x1f,%r11d
  385f66:	mov    (%r12,%r11,4),%r11d
  385f6a:	mov    %eax,%ecx
  385f6c:	shr    $0x5,%ecx
  385f6f:	rol    %cl,%r11d
  385f72:	mov    %eax,%ecx
  385f74:	shr    $0xa,%ecx
  385f77:	mov    %ecx,%ebx
  385f79:	and    $0x1f,%ebx
  385f7c:	mov    (%r12,%rbx,4),%ebx
  385f80:	mov    %rax,%r9
  385f83:	mov    %eax,%ecx
  385f85:	shr    $0x14,%eax
  385f88:	shr    $0xf,%ecx
  385f8b:	shr    $0x20,%r9
  385f8f:	and    $0x7,%eax
  385f92:	and    0x8(%rdi),%r9d
  385f96:	rol    %cl,%ebx
  385f98:	add    $0x8,%eax
  385f9b:	mov    0x10(%rdi),%rcx
  385f9f:	xor    %r9d,%eax
  385fa2:	mov    (%rcx,%rax,4),%r13d
  385fa6:	mov    (%rcx,%r9,4),%eax
  385faa:	and    %ebx,%r13d
  385fad:	cmp    %ebx,%r13d
  385fb0:	sete   %bl
  385fb3:	and    %r11d,%eax
  385fb6:	cmp    %r11d,%eax
  385fb9:	sete   %al
  385fbc:	movzbl %al,%eax
  385fbf:	and    %ebx,%eax
  385fc1:	mov    %eax,(%r8,%r10,4)
  385fc5:	inc    %r10
  385fc8:	cmp    %rsi,%r10
  385fcb:	jne    385f58 <void vldb_stage2::DenseCall<raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > >(raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > const&, unsigned int, unsigned int const*, unsigned int*)+0x528>
  385fcd:	pop    %rbx
  385fce:	pop    %r12
  385fd0:	pop    %r13
  385fd2:	pop    %rbp
  385fd3:	ret
  385fd4:	nopl   0x0(%rax)
  385fd8:	mov    (%rdi),%r9
  385fdb:	vmovdqu64 (%rdx,%r11,8),%zmm0
  385fe2:	vmovdqu32 (%r9),%zmm7
  385fe8:	vpshufd $0xf5,%zmm0,%zmm1
  385fef:	vpsllq $0xc,%zmm0,%zmm3
  385ff6:	vpshufd $0xa0,%zmm0,%zmm0
  385ffd:	vpsrlvd -0x30c807(%rip),%zmm0,%zmm0        # 79800 <bloom_filters::FastPatternBF::sparse_patterns_+0x3a0>
  386007:	vpandd 0x8(%rdi){1to16},%zmm1,%zmm1
  38600e:	mov    0x10(%rdi),%rcx
  386012:	vpsrld $0x5,%zmm0,%zmm2
  386019:	vpermi2d 0x40(%r9),%zmm7,%zmm0
  386020:	vprolvd %zmm2,%zmm0,%zmm0
  386026:	vmovdqa32 -0x30c7b0(%rip),%zmm2        # 79880 <bloom_filters::FastPatternBF::sparse_patterns_+0x420>
  386030:	kxnorw %k7,%k7,%k7
  386034:	vpternlogd $0xf8,-0x30c7ff(%rip),%zmm3,%zmm2        # 79840 <bloom_filters::FastPatternBF::sparse_patterns_+0x3e0>
  38603f:	vpxord %zmm1,%zmm2,%zmm2
  386045:	vpgatherdd (%rcx,%zmm2,4),%zmm1{%k7}
  38604c:	vpandd %zmm0,%zmm1,%zmm1
  386052:	vpcmpeqq %zmm0,%zmm1,%k1
  386059:	mov    $0x1,%eax
  38605e:	vpbroadcastd %eax,%zmm0{%k1}{z}
  386064:	vmovdqu %ymm0,(%r8,%r11,4)
  38606a:	mov    %rbx,%r11
  38606d:	jmp    385ec5 <void vldb_stage2::DenseCall<raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > >(raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > const&, unsigned int, unsigned int const*, unsigned int*)+0x495>
  386072:	nopw   0x0(%rax,%rax,1)
  386078:	mov    (%rdi),%r9
  38607b:	vmovdqu64 (%rdx,%r11,8),%zmm0
  386082:	vmovdqu32 (%r9),%zmm7
  386088:	vpshufd $0xf5,%zmm0,%zmm1
  38608f:	vpsllq $0xc,%zmm0,%zmm3
  386096:	vpshufd $0xa0,%zmm0,%zmm0
  38609d:	vpsrlvd -0x30c8a7(%rip),%zmm0,%zmm0        # 79800 <bloom_filters::FastPatternBF::sparse_patterns_+0x3a0>
  3860a7:	vpandd 0x8(%rdi){1to16},%zmm1,%zmm1
  3860ae:	kxnorw %k7,%k7,%k7
  3860b2:	vpsrld $0x5,%zmm0,%zmm2
  3860b9:	vpermi2d 0x40(%r9),%zmm7,%zmm0
  3860c0:	vprolvd %zmm2,%zmm0,%zmm0
  3860c6:	vmovdqa32 -0x30c850(%rip),%zmm2        # 79880 <bloom_filters::FastPatternBF::sparse_patterns_+0x420>
  3860d0:	mov    0x10(%rdi),%r9
  3860d4:	vpternlogd $0xf8,-0x30c89f(%rip),%zmm3,%zmm2        # 79840 <bloom_filters::FastPatternBF::sparse_patterns_+0x3e0>
  3860df:	vpxord %zmm1,%zmm2,%zmm2
  3860e5:	vpgatherdd (%r9,%zmm2,4),%zmm1{%k7}
  3860ec:	vpandd %zmm0,%zmm1,%zmm1
  3860f2:	vpcmpeqq %zmm0,%zmm1,%k1
  3860f9:	mov    $0x1,%ecx
  3860fe:	vpbroadcastd %ecx,%zmm0{%k1}{z}
  386104:	vmovdqu %ymm0,(%r8,%r11,4)
  38610a:	mov    %rax,%r11
  38610d:	jmp    385e26 <void vldb_stage2::DenseCall<raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > >(raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > const&, unsigned int, unsigned int const*, unsigned int*)+0x3f6>
  386112:	ret
  386113:	xor    %r11d,%r11d
  386116:	cmp    $0x7,%rsi
  38611a:	jbe    385ed3 <void vldb_stage2::DenseCall<raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > >(raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > const&, unsigned int, unsigned int const*, unsigned int*)+0x4a3>
  386120:	mov    $0x8,%ebx
  386125:	xor    %r11d,%r11d
  386128:	jmp    385fdb <void vldb_stage2::DenseCall<raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > >(raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > const&, unsigned int, unsigned int const*, unsigned int*)+0x5ab>
  38612d:	xor    %r11d,%r11d
  386130:	cmp    $0x7,%rsi
  386134:	jbe    385e33 <void vldb_stage2::DenseCall<raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > >(raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > const&, unsigned int, unsigned int const*, unsigned int*)+0x403>
  38613a:	mov    $0x8,%eax
  38613f:	xor    %r11d,%r11d
  386142:	jmp    38607b <void vldb_stage2::DenseCall<raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > >(raw32_stage3::RawHash<bloom_filters::FastPatternBF, raw32_stage3::NativePolicy<bloom_filters::FastPatternBF, 0> > const&, unsigned int, unsigned int const*, unsigned int*)+0x64b>
