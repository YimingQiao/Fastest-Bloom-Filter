
/home/yiming/projects/fastest-bf-lab/build/vldb-nearby-raw32-v1/native/nearby_raw32:     file format elf64-x86-64


Disassembly of section .text:

000000000037ecf0 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)>:
  37ecf0:	lea    0x8(%rsp),%r10
  37ecf5:	and    $0xffffffffffffffe0,%rsp
  37ecf9:	push   -0x8(%r10)
  37ecfd:	push   %rbp
  37ecfe:	mov    %rsp,%rbp
  37ed01:	push   %r15
  37ed03:	push   %r14
  37ed05:	push   %r13
  37ed07:	push   %r12
  37ed09:	push   %r10
  37ed0b:	push   %rbx
  37ed0c:	mov    %rdi,%rbx
  37ed0f:	lea    -0x2b0(%rbp),%rdi
  37ed16:	sub    $0x620,%rsp
  37ed1d:	mov    %rsi,-0x4f0(%rbp)
  37ed24:	mov    (%rdx),%rsi
  37ed27:	mov    %rdi,-0x608(%rbp)
  37ed2e:	mov    %rdx,-0x4c0(%rbp)
  37ed35:	call   *0x10(%rdx)
  37ed38:	mov    -0x2a8(%rbp),%rax
  37ed3f:	xor    %edi,%edi
  37ed41:	test   %rax,%rax
  37ed44:	je     37ed53 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x63>
  37ed46:	cmp    %rax,-0x2b0(%rbp)
  37ed4d:	jae    37f67c <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x98c>
  37ed53:	lea    -0x30736a(%rip),%rsi        # 779f0 <_IO_stdin_used+0x39c>
  37ed5a:	call   378740 <raw32_stage3::Need(bool, char const*)>
  37ed5f:	lea    -0x1b0(%rbp),%r15
  37ed66:	lea    -0x470(%rbp),%rax
  37ed6d:	mov    %rbx,%rsi
  37ed70:	mov    %r15,%rdi
  37ed73:	movq   $0x0,-0x470(%rbp)
  37ed7e:	movq   $0x0,-0x468(%rbp)
  37ed89:	movq   $0x0,-0x460(%rbp)
  37ed94:	mov    %r15,-0x4e0(%rbp)
  37ed9b:	mov    %rax,-0x530(%rbp)
  37eda2:	call   370f30 <std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::basic_string<std::allocator<char> >(char const*, std::allocator<char> const&) [clone .constprop.0]>
  37eda7:	lea    -0x306907(%rip),%rax        # 784a7 <_IO_stdin_used+0xe53>
  37edae:	mov    %rax,-0x320(%rbp)
  37edb5:	lea    -0x320(%rbp),%rbx
  37edbc:	lea    -0x470(%rbp),%rax
  37edc3:	mov    %r15,%rdx
  37edc6:	mov    %rbx,%rsi
  37edc9:	mov    %rax,%rdi
  37edcc:	mov    %rax,-0x530(%rbp)
  37edd3:	call   3712f0 <std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >& std::vector<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >, std::allocator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > > >::emplace_back<char const*&, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&>(char const*&, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&) [clone .isra.0]>
  37edd8:	mov    -0x1b0(%rbp),%rdi
  37eddf:	lea    -0x1a0(%rbp),%rax
  37ede6:	mov    %rax,-0x538(%rbp)
  37eded:	cmp    %rax,%rdi
  37edf0:	je     37ee02 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x112>
  37edf2:	mov    -0x1a0(%rbp),%rax
  37edf9:	lea    0x1(%rax),%rsi
  37edfd:	call   1906920 <operator delete(void*, unsigned long)@plt>
  37ee02:	lea    -0x306351(%rip),%rax        # 78ab8 <_IO_stdin_used+0x1464>
  37ee09:	mov    %rax,-0x1b0(%rbp)
  37ee10:	mov    -0x4e0(%rbp),%r14
  37ee17:	mov    -0x4f0(%rbp),%rax
  37ee1e:	mov    -0x530(%rbp),%r15
  37ee25:	lea    0x20(%rax),%rdx
  37ee29:	mov    %r14,%rsi
  37ee2c:	mov    %r15,%rdi
  37ee2f:	call   3712f0 <std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >& std::vector<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >, std::allocator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > > >::emplace_back<char const*&, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&>(char const*&, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&) [clone .isra.0]>
  37ee34:	lea    -0x3067d8(%rip),%rax        # 78663 <_IO_stdin_used+0x100f>
  37ee3b:	mov    %rax,-0x370(%rbp)
  37ee42:	lea    -0x370(%rbp),%rax
  37ee49:	lea    -0x1f8(%rbp),%rdx
  37ee50:	mov    %rax,%rsi
  37ee53:	mov    %r15,%rdi
  37ee56:	mov    %rax,-0x5b8(%rbp)
  37ee5d:	call   3712f0 <std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >& std::vector<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >, std::allocator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > > >::emplace_back<char const*&, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&>(char const*&, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&) [clone .isra.0]>
  37ee62:	lea    -0x305e66(%rip),%rax        # 79003 <_IO_stdin_used+0x19af>
  37ee69:	mov    %rax,-0x390(%rbp)
  37ee70:	lea    -0x390(%rbp),%rax
  37ee77:	lea    -0x218(%rbp),%rdx
  37ee7e:	mov    %rax,%rsi
  37ee81:	mov    %r15,%rdi
  37ee84:	mov    %rax,-0x588(%rbp)
  37ee8b:	call   3712f0 <std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >& std::vector<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >, std::allocator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > > >::emplace_back<char const*&, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&>(char const*&, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&) [clone .isra.0]>
  37ee90:	lea    -0x30668a(%rip),%rsi        # 7880d <_IO_stdin_used+0x11b9>
  37ee97:	mov    %r14,%rdi
  37ee9a:	call   370f30 <std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::basic_string<std::allocator<char> >(char const*, std::allocator<char> const&) [clone .constprop.0]>
  37ee9f:	lea    -0x305f7a(%rip),%rax        # 78f2c <_IO_stdin_used+0x18d8>
  37eea6:	mov    %rax,-0x3b0(%rbp)
  37eead:	lea    -0x3b0(%rbp),%rax
  37eeb4:	mov    %r14,%rdx
  37eeb7:	mov    %rax,%rsi
  37eeba:	mov    %r15,%rdi
  37eebd:	mov    %rax,-0x5c0(%rbp)
  37eec4:	call   3712f0 <std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >& std::vector<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >, std::allocator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > > >::emplace_back<char const*&, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&>(char const*&, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&) [clone .isra.0]>
  37eec9:	mov    -0x1b0(%rbp),%rdi
  37eed0:	mov    -0x538(%rbp),%rax
  37eed7:	cmp    %rax,%rdi
  37eeda:	je     37eeec <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1fc>
  37eedc:	mov    -0x1a0(%rbp),%rax
  37eee3:	lea    0x1(%rax),%rsi
  37eee7:	call   1906920 <operator delete(void*, unsigned long)@plt>
  37eeec:	mov    -0x4f0(%rbp),%r14
  37eef3:	mov    -0x530(%rbp),%r15
  37eefa:	mov    0x40(%r14),%eax
  37eefe:	mov    $0x1,%edx
  37ef03:	lea    -0x30689f(%rip),%rsi        # 7866b <_IO_stdin_used+0x1017>
  37ef0a:	mov    %r15,%rdi
  37ef0d:	shlx   %rax,%rdx,%rdx
  37ef12:	call   37e5a0 <void raw32_stage3::Add<unsigned long>(std::vector<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >, std::allocator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > > >&, char const*, unsigned long)>
  37ef17:	mov    0x44(%r14),%edx
  37ef1b:	lea    -0x3067d7(%rip),%rsi        # 7874b <_IO_stdin_used+0x10f7>
  37ef22:	mov    %r15,%rdi
  37ef25:	call   37e3e0 <void raw32_stage3::Add<unsigned int>(std::vector<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >, std::allocator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > > >&, char const*, unsigned int)>
  37ef2a:	mov    -0x2b0(%rbp),%rdx
  37ef31:	lea    -0x3061b2(%rip),%rsi        # 78d86 <_IO_stdin_used+0x1732>
  37ef38:	mov    %r15,%rdi
  37ef3b:	call   37e5a0 <void raw32_stage3::Add<unsigned long>(std::vector<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >, std::allocator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > > >&, char const*, unsigned long)>
  37ef40:	mov    -0x2a8(%rbp),%rdx
  37ef47:	lea    -0x305eb4(%rip),%rsi        # 7909a <_IO_stdin_used+0x1a46>
  37ef4e:	mov    %r15,%rdi
  37ef51:	call   37e5a0 <void raw32_stage3::Add<unsigned long>(std::vector<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >, std::allocator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > > >&, char const*, unsigned long)>
  37ef56:	mov    -0x2a0(%rbp),%rdx
  37ef5d:	lea    -0x3068f4(%rip),%rsi        # 78670 <_IO_stdin_used+0x101c>
  37ef64:	mov    %r15,%rdi
  37ef67:	call   37e5a0 <void raw32_stage3::Add<unsigned long>(std::vector<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >, std::allocator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > > >&, char const*, unsigned long)>
  37ef6c:	mov    -0x298(%rbp),%rdx
  37ef73:	lea    -0x306a1d(%rip),%rsi        # 7855d <_IO_stdin_used+0xf09>
  37ef7a:	mov    %r15,%rdi
  37ef7d:	call   37e5a0 <void raw32_stage3::Add<unsigned long>(std::vector<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >, std::allocator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > > >&, char const*, unsigned long)>
  37ef82:	mov    -0x290(%rbp),%rdx
  37ef89:	lea    -0x306a87(%rip),%rsi        # 78509 <_IO_stdin_used+0xeb5>
  37ef90:	mov    %r15,%rdi
  37ef93:	call   37e5a0 <void raw32_stage3::Add<unsigned long>(std::vector<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >, std::allocator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > > >&, char const*, unsigned long)>
  37ef98:	mov    -0x288(%rbp),%rdx
  37ef9f:	lea    -0x306499(%rip),%rsi        # 78b0d <_IO_stdin_used+0x14b9>
  37efa6:	mov    %r15,%rdi
  37efa9:	call   37e5a0 <void raw32_stage3::Add<unsigned long>(std::vector<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >, std::allocator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > > >&, char const*, unsigned long)>
  37efae:	mov    -0x280(%rbp),%edx
  37efb4:	lea    -0x306084(%rip),%rsi        # 78f37 <_IO_stdin_used+0x18e3>
  37efbb:	mov    %r15,%rdi
  37efbe:	call   37e0b0 <void raw32_stage3::Add<int>(std::vector<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >, std::allocator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > > >&, char const*, int)>
  37efc3:	lea    -0x3063b0(%rip),%rax        # 78c1a <_IO_stdin_used+0x15c6>
  37efca:	mov    %rax,-0x3d0(%rbp)
  37efd1:	lea    -0x3d0(%rbp),%rax
  37efd8:	lea    -0x258(%rbp),%rdx
  37efdf:	mov    %rax,%rsi
  37efe2:	mov    %r15,%rdi
  37efe5:	mov    %rax,-0x620(%rbp)
  37efec:	call   3712f0 <std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >& std::vector<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >, std::allocator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > > >::emplace_back<char const*&, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&>(char const*&, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&) [clone .isra.0]>
  37eff1:	lea    -0x3067e3(%rip),%rax        # 78815 <_IO_stdin_used+0x11c1>
  37eff8:	mov    %rax,-0x3f0(%rbp)
  37efff:	lea    -0x3f0(%rbp),%rax
  37f006:	lea    -0x278(%rbp),%rdx
  37f00d:	mov    %rax,%rsi
  37f010:	mov    %r15,%rdi
  37f013:	mov    %rax,-0x5d0(%rbp)
  37f01a:	call   3712f0 <std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >& std::vector<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >, std::allocator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > > >::emplace_back<char const*&, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&>(char const*&, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&) [clone .isra.0]>
  37f01f:	lea    -0x305f7f(%rip),%rax        # 790a7 <_IO_stdin_used+0x1a53>
  37f026:	mov    %rax,-0x410(%rbp)
  37f02d:	lea    -0x410(%rbp),%rax
  37f034:	lea    -0x238(%rbp),%rdx
  37f03b:	mov    %rax,%rsi
  37f03e:	mov    %r15,%rdi
  37f041:	mov    %rax,-0x5d8(%rbp)
  37f048:	call   3712f0 <std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >& std::vector<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >, std::allocator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > > >::emplace_back<char const*&, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&>(char const*&, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&) [clone .isra.0]>
  37f04d:	lea    -0x306a2c(%rip),%rax        # 78628 <_IO_stdin_used+0xfd4>
  37f054:	mov    %rax,-0x430(%rbp)
  37f05b:	lea    -0x430(%rbp),%rax
  37f062:	lea    -0x1d8(%rbp),%rdx
  37f069:	mov    %rax,%rsi
  37f06c:	mov    %r15,%rdi
  37f06f:	mov    %rax,-0x618(%rbp)
  37f076:	call   3712f0 <std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >& std::vector<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >, std::allocator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > > >::emplace_back<char const*&, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&>(char const*&, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&) [clone .isra.0]>
  37f07b:	lea    -0x3068e2(%rip),%rsi        # 787a0 <_IO_stdin_used+0x114c>
  37f082:	mov    %r14,%rdi
  37f085:	call   1906aa0 <std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::compare(char const*) const@plt>
  37f08a:	test   %eax,%eax
  37f08c:	je     382117 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3427>
  37f092:	mov    -0x4f0(%rbp),%rdi
  37f099:	mov    $0x1,%eax
  37f09e:	mov    0x54(%rdi),%ecx
  37f0a1:	mov    0x40(%rdi),%esi
  37f0a4:	shlx   %rcx,%rax,%rdx
  37f0a9:	test   %ecx,%ecx
  37f0ab:	mov    $0x0,%ecx
  37f0b0:	cmovne %rdx,%rcx
  37f0b4:	mov    0x50(%rdi),%r9d
  37f0b8:	mov    0x48(%rdi),%edx
  37f0bb:	mov    0x4c(%rdi),%r8d
  37f0bf:	mov    %rbx,%rdi
  37f0c2:	shlx   %rdx,%rax,%rdx
  37f0c7:	shlx   %rsi,%rax,%rsi
  37f0cc:	call   37b430 <vldb_external::Raw32Workload::Raw32Workload(unsigned long, unsigned long, unsigned long, unsigned int, unsigned int)>
  37f0d1:	mov    -0x318(%rbp),%rbx
  37f0d8:	mov    -0x320(%rbp),%rdi
  37f0df:	mov    %rbx,-0x628(%rbp)
  37f0e6:	sub    %rdi,%rbx
  37f0e9:	mov    %rbx,%r8
  37f0ec:	sar    $0x2,%r8
  37f0f0:	movabs $0xcbf29ce484222325,%rax
  37f0fa:	mov    %rdi,-0x5e0(%rbp)
  37f101:	mov    %r8,-0x550(%rbp)
  37f108:	mov    %rax,-0x5e8(%rbp)
  37f10f:	test   %rbx,%rbx
  37f112:	je     37f168 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x478>
  37f114:	xor    %esi,%esi
  37f116:	movabs $0x100000001b3,%rcx
  37f120:	mov    (%rdi,%rsi,4),%r9d
  37f124:	inc    %rsi
  37f127:	movzbl %r9b,%edx
  37f12b:	xor    %rax,%rdx
  37f12e:	imul   %rcx,%rdx
  37f132:	mov    %r9d,%eax
  37f135:	movzbl %ah,%eax
  37f138:	mov    %eax,%eax
  37f13a:	xor    %rax,%rdx
  37f13d:	imul   %rcx,%rdx
  37f141:	mov    %r9d,%eax
  37f144:	shr    $0x10,%eax
  37f147:	movzbl %al,%eax
  37f14a:	xor    %rdx,%rax
  37f14d:	imul   %rcx,%rax
  37f151:	shr    $0x18,%r9d
  37f155:	xor    %r9,%rax
  37f158:	imul   %rcx,%rax
  37f15c:	cmp    %r8,%rsi
  37f15f:	jb     37f120 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x430>
  37f161:	mov    %rax,-0x5e8(%rbp)
  37f168:	mov    -0x308(%rbp),%r15
  37f16f:	mov    -0x300(%rbp),%rdi
  37f176:	movabs $0xcbf29ce484222325,%rax
  37f180:	sub    %r15,%rdi
  37f183:	mov    %rdi,-0x528(%rbp)
  37f18a:	mov    %rdi,%rcx
  37f18d:	sar    $0x2,%rdi
  37f191:	mov    %rdi,-0x4c8(%rbp)
  37f198:	mov    %rax,-0x520(%rbp)
  37f19f:	test   %rcx,%rcx
  37f1a2:	je     37f1f8 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x508>
  37f1a4:	xor    %esi,%esi
  37f1a6:	movabs $0x100000001b3,%rcx
  37f1b0:	mov    (%r15,%rsi,4),%r8d
  37f1b4:	inc    %rsi
  37f1b7:	movzbl %r8b,%edx
  37f1bb:	xor    %rax,%rdx
  37f1be:	imul   %rcx,%rdx
  37f1c2:	mov    %r8d,%eax
  37f1c5:	movzbl %ah,%eax
  37f1c8:	mov    %eax,%eax
  37f1ca:	xor    %rax,%rdx
  37f1cd:	imul   %rcx,%rdx
  37f1d1:	mov    %r8d,%eax
  37f1d4:	shr    $0x10,%eax
  37f1d7:	movzbl %al,%eax
  37f1da:	xor    %rdx,%rax
  37f1dd:	imul   %rcx,%rax
  37f1e1:	shr    $0x18,%r8d
  37f1e5:	xor    %r8,%rax
  37f1e8:	imul   %rcx,%rax
  37f1ec:	cmp    %rdi,%rsi
  37f1ef:	jb     37f1b0 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x4c0>
  37f1f1:	mov    %rax,-0x520(%rbp)
  37f1f8:	mov    -0x2e8(%rbp),%rcx
  37f1ff:	mov    -0x2f0(%rbp),%rdi
  37f206:	mov    %rcx,-0x638(%rbp)
  37f20d:	sub    %rdi,%rcx
  37f210:	mov    %rcx,%r8
  37f213:	sar    $0x2,%r8
  37f217:	movabs $0xcbf29ce484222325,%rax
  37f221:	mov    %rdi,-0x600(%rbp)
  37f228:	mov    %rcx,-0x630(%rbp)
  37f22f:	mov    %r8,-0x5f0(%rbp)
  37f236:	mov    %rax,-0x5f8(%rbp)
  37f23d:	test   %rcx,%rcx
  37f240:	je     37f298 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x5a8>
  37f242:	xor    %esi,%esi
  37f244:	movabs $0x100000001b3,%rcx
  37f24e:	xchg   %ax,%ax
  37f250:	mov    (%rdi,%rsi,4),%r9d
  37f254:	inc    %rsi
  37f257:	movzbl %r9b,%edx
  37f25b:	xor    %rax,%rdx
  37f25e:	imul   %rcx,%rdx
  37f262:	mov    %r9d,%eax
  37f265:	movzbl %ah,%eax
  37f268:	mov    %eax,%eax
  37f26a:	xor    %rax,%rdx
  37f26d:	imul   %rcx,%rdx
  37f271:	mov    %r9d,%eax
  37f274:	shr    $0x10,%eax
  37f277:	movzbl %al,%eax
  37f27a:	xor    %rdx,%rax
  37f27d:	imul   %rcx,%rax
  37f281:	shr    $0x18,%r9d
  37f285:	xor    %r9,%rax
  37f288:	imul   %rcx,%rax
  37f28c:	cmp    %r8,%rsi
  37f28f:	jb     37f250 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x560>
  37f291:	mov    %rax,-0x5f8(%rbp)
  37f298:	mov    -0x4c0(%rbp),%rax
  37f29f:	mov    -0x5e0(%rbp),%r12
  37f2a6:	mov    -0x550(%rbp),%r14
  37f2ad:	mov    (%rax),%rdi
  37f2b0:	mov    %r12,%rdx
  37f2b3:	mov    %r14d,%esi
  37f2b6:	call   *0x18(%rax)
  37f2b9:	movabs $0xcbf29ce484222325,%rax
  37f2c3:	test   %rbx,%rbx
  37f2c6:	je     37f321 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x631>
  37f2c8:	xor    %esi,%esi
  37f2ca:	movabs $0x100000001b3,%rcx
  37f2d4:	mov    %r12,%rdi
  37f2d7:	mov    %r14,%r8
  37f2da:	nopw   0x0(%rax,%rax,1)
  37f2e0:	mov    (%rdi,%rsi,4),%r9d
  37f2e4:	inc    %rsi
  37f2e7:	movzbl %r9b,%edx
  37f2eb:	xor    %rax,%rdx
  37f2ee:	imul   %rcx,%rdx
  37f2f2:	mov    %r9d,%eax
  37f2f5:	movzbl %ah,%eax
  37f2f8:	mov    %eax,%eax
  37f2fa:	xor    %rax,%rdx
  37f2fd:	imul   %rcx,%rdx
  37f301:	mov    %r9d,%eax
  37f304:	shr    $0x10,%eax
  37f307:	movzbl %al,%eax
  37f30a:	xor    %rdx,%rax
  37f30d:	imul   %rcx,%rax
  37f311:	shr    $0x18,%r9d
  37f315:	xor    %r9,%rax
  37f318:	imul   %rcx,%rax
  37f31c:	cmp    %r8,%rsi
  37f31f:	jb     37f2e0 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x5f0>
  37f321:	cmp    %rax,-0x5e8(%rbp)
  37f328:	sete   %dil
  37f32c:	lea    -0x306811(%rip),%rsi        # 78b22 <_IO_stdin_used+0x14ce>
  37f333:	movzbl %dil,%edi
  37f337:	call   378740 <raw32_stage3::Need(bool, char const*)>
  37f33c:	mov    -0x4c0(%rbp),%rax
  37f343:	mov    $0x2,%esi
  37f348:	mov    (%rax),%rdi
  37f34b:	call   *0x20(%rax)
  37f34e:	mov    $0x4000,%edi
  37f353:	call   1906a00 <operator new(unsigned long)@plt>
  37f358:	mov    %rax,-0x590(%rbp)
  37f35f:	mov    $0x1,%edx
  37f364:	lea    0x4000(%rax),%rcx
  37f36b:	vpbroadcastd %edx,%ymm0
  37f371:	nopl   0x0(%rax)
  37f378:	vmovdqu %ymm0,(%rax)
  37f37c:	add    $0x20,%rax
  37f380:	cmp    %rcx,%rax
  37f383:	jne    37f378 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x688>
  37f385:	mov    -0x5e0(%rbp),%rax
  37f38c:	mov    -0x550(%rbp),%r12
  37f393:	mov    %rax,-0x4b0(%rbp)
  37f39a:	test   %rbx,%rbx
  37f39d:	je     37f68e <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x99e>
  37f3a3:	vzeroupper
  37f3a6:	cs nopw 0x0(%rax,%rax,1)
  37f3b0:	movq   $0x0,-0x1a8(%rbp)
  37f3bb:	movq   $0x0,-0x1a0(%rbp)
  37f3c6:	cmp    $0xfff,%r12
  37f3cd:	jbe    37f66c <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x97c>
  37f3d3:	mov    $0x4080,%r14d
  37f3d9:	mov    $0x1000,%r13d
  37f3df:	mov    %r14,%rdi
  37f3e2:	call   1906a00 <operator new(unsigned long)@plt>
  37f3e7:	lea    -0x4(%r14),%rcx
  37f3eb:	shr    $0x2,%rcx
  37f3ef:	lea    0x1(%rcx),%rsi
  37f3f3:	lea    (%rax,%r14,1),%rdi
  37f3f7:	mov    %rsi,%rdx
  37f3fa:	shr    $0x3,%rdx
  37f3fe:	mov    %rax,-0x1b0(%rbp)
  37f405:	mov    %rdi,-0x1a0(%rbp)
  37f40c:	shl    $0x5,%rdx
  37f410:	mov    $0xdeadbeef,%r9d
  37f416:	mov    %rax,%rbx
  37f419:	add    %rax,%rdx
  37f41c:	vpbroadcastd %r9d,%ymm0
  37f422:	nopw   0x0(%rax,%rax,1)
  37f428:	vmovdqu %ymm0,(%rax)
  37f42c:	add    $0x20,%rax
  37f430:	cmp    %rax,%rdx
  37f433:	jne    37f428 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x738>
  37f435:	mov    %rsi,%rax
  37f438:	and    $0xfffffffffffffff8,%rax
  37f43c:	lea    (%rbx,%rax,4),%r8
  37f440:	test   $0x7,%sil
  37f444:	je     37f49a <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x7aa>
  37f446:	mov    %rcx,%r10
  37f449:	sub    %rax,%r10
  37f44c:	lea    0x1(%r10),%rdx
  37f450:	cmp    $0x2,%r10
  37f454:	jbe    37f471 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x781>
  37f456:	vpbroadcastd %r9d,%xmm0
  37f45c:	vmovdqu %xmm0,(%rbx,%rax,4)
  37f461:	mov    %rdx,%rax
  37f464:	and    $0xfffffffffffffffc,%rax
  37f468:	and    $0x3,%edx
  37f46b:	lea    (%r8,%rax,4),%r8
  37f46f:	je     37f49a <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x7aa>
  37f471:	lea    0x4(%r8),%rax
  37f475:	movl   $0xdeadbeef,(%r8)
  37f47c:	cmp    %rax,%rdi
  37f47f:	je     37f49a <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x7aa>
  37f481:	lea    0x8(%r8),%rax
  37f485:	movl   $0xdeadbeef,0x4(%r8)
  37f48d:	cmp    %rax,%rdi
  37f490:	je     37f49a <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x7aa>
  37f492:	movl   $0xdeadbeef,0x8(%r8)
  37f49a:	mov    %rsi,%rdx
  37f49d:	shr    $0x3,%rdx
  37f4a1:	mov    %rdi,-0x1a8(%rbp)
  37f4a8:	mov    %r13,-0x198(%rbp)
  37f4af:	shl    $0x5,%rdx
  37f4b3:	mov    $0xdeadbeef,%r8d
  37f4b9:	mov    %rbx,%rax
  37f4bc:	add    %rbx,%rdx
  37f4bf:	vpbroadcastd %r8d,%ymm0
  37f4c5:	nopl   (%rax)
  37f4c8:	vmovdqu %ymm0,(%rax)
  37f4cc:	add    $0x20,%rax
  37f4d0:	cmp    %rdx,%rax
  37f4d3:	jne    37f4c8 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x7d8>
  37f4d5:	mov    %rsi,%rax
  37f4d8:	and    $0xfffffffffffffff8,%rax
  37f4dc:	and    $0x7,%esi
  37f4df:	lea    (%rbx,%rax,4),%r9
  37f4e3:	je     37f536 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x846>
  37f4e5:	sub    %rax,%rcx
  37f4e8:	lea    0x1(%rcx),%rdx
  37f4ec:	cmp    $0x2,%rcx
  37f4f0:	jbe    37f50d <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x81d>
  37f4f2:	vpbroadcastd %r8d,%xmm0
  37f4f8:	vmovdqu %xmm0,(%rbx,%rax,4)
  37f4fd:	mov    %rdx,%rax
  37f500:	and    $0xfffffffffffffffc,%rax
  37f504:	and    $0x3,%edx
  37f507:	lea    (%r9,%rax,4),%r9
  37f50b:	je     37f536 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x846>
  37f50d:	lea    0x4(%r9),%rax
  37f511:	movl   $0xdeadbeef,(%r9)
  37f518:	cmp    %rax,%rdi
  37f51b:	je     37f536 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x846>
  37f51d:	lea    0x8(%r9),%rax
  37f521:	movl   $0xdeadbeef,0x4(%r9)
  37f529:	cmp    %rax,%rdi
  37f52c:	je     37f536 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x846>
  37f52e:	movl   $0xdeadbeef,0x8(%r9)
  37f536:	lea    0x0(,%r13,4),%rax
  37f53e:	lea    0x40(%rbx),%rsi
  37f542:	lea    0x40(%rbx,%rax,1),%rdi
  37f547:	cmp    %rdi,%rsi
  37f54a:	je     37f5fe <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x90e>
  37f550:	sub    $0x4,%rax
  37f554:	mov    %rax,%r8
  37f557:	shr    $0x2,%r8
  37f55b:	lea    0x1(%r8),%r9
  37f55f:	cmp    $0x18,%rax
  37f563:	jbe    380b71 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1e81>
  37f569:	mov    %r9,%rdx
  37f56c:	shr    $0x3,%rdx
  37f570:	shl    $0x5,%rdx
  37f574:	mov    $0xfeedface,%ecx
  37f579:	mov    %rbx,%rax
  37f57c:	add    %rbx,%rdx
  37f57f:	vpbroadcastd %ecx,%ymm0
  37f585:	nopl   (%rax)
  37f588:	vmovdqu %ymm0,0x40(%rax)
  37f58d:	add    $0x20,%rax
  37f591:	cmp    %rdx,%rax
  37f594:	jne    37f588 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x898>
  37f596:	mov    %r9,%rdx
  37f599:	and    $0xfffffffffffffff8,%rdx
  37f59d:	and    $0x7,%r9d
  37f5a1:	lea    (%rsi,%rdx,4),%r10
  37f5a5:	je     37f5fe <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x90e>
  37f5a7:	sub    %rdx,%r8
  37f5aa:	lea    0x1(%r8),%rcx
  37f5ae:	cmp    $0x2,%r8
  37f5b2:	jbe    37f5d5 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x8e5>
  37f5b4:	mov    $0xfeedface,%eax
  37f5b9:	vpbroadcastd %eax,%xmm0
  37f5bf:	mov    %rcx,%rax
  37f5c2:	and    $0xfffffffffffffffc,%rax
  37f5c6:	and    $0x3,%ecx
  37f5c9:	vmovdqu %xmm0,0x40(%rbx,%rdx,4)
  37f5cf:	lea    (%r10,%rax,4),%r10
  37f5d3:	je     37f5fe <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x90e>
  37f5d5:	lea    0x4(%r10),%rax
  37f5d9:	movl   $0xfeedface,(%r10)
  37f5e0:	cmp    %rax,%rdi
  37f5e3:	je     37f5fe <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x90e>
  37f5e5:	lea    0x8(%r10),%rax
  37f5e9:	movl   $0xfeedface,0x4(%r10)
  37f5f1:	cmp    %rax,%rdi
  37f5f4:	je     37f5fe <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x90e>
  37f5f6:	movl   $0xfeedface,0x8(%r10)
  37f5fe:	mov    -0x4c0(%rbp),%rax
  37f605:	mov    -0x4b0(%rbp),%rdx
  37f60c:	mov    (%rax),%rdi
  37f60f:	mov    %rsi,%rcx
  37f612:	mov    %r13d,%esi
  37f615:	vzeroupper
  37f618:	call   *0x30(%rax)
  37f61b:	mov    -0x590(%rbp),%rsi
  37f622:	mov    -0x4e0(%rbp),%rdi
  37f629:	call   3797f0 <raw32_stage3::GuardedOutput::Check(unsigned int const*) const>
  37f62e:	mov    %rbx,%rdi
  37f631:	mov    %r14,%rsi
  37f634:	call   1906920 <operator delete(void*, unsigned long)@plt>
  37f639:	mov    -0x550(%rbp),%rdi
  37f640:	addq   $0x4000,-0x4b0(%rbp)
  37f64b:	mov    %rdi,%rax
  37f64e:	sub    %r12,%rax
  37f651:	add    $0x1000,%rax
  37f657:	lea    -0x1000(%r12),%rdx
  37f65f:	cmp    %rdi,%rax
  37f662:	jae    37f691 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x9a1>
  37f664:	mov    %rdx,%r12
  37f667:	jmp    37f3b0 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x6c0>
  37f66c:	lea    0x80(,%r12,4),%r14
  37f674:	mov    %r12,%r13
  37f677:	jmp    37f3df <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x6ef>
  37f67c:	xor    %edi,%edi
  37f67e:	cmp    -0x2a0(%rbp),%rax
  37f685:	setae  %dil
  37f689:	jmp    37ed53 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x63>
  37f68e:	vzeroupper
  37f691:	mov    -0x4c0(%rbp),%rax
  37f698:	xor    %esi,%esi
  37f69a:	mov    (%rax),%rdi
  37f69d:	call   *0x20(%rax)
  37f6a0:	mov    -0x4c8(%rbp),%r14
  37f6a7:	test   %r14,%r14
  37f6aa:	je     3820fa <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x340a>
  37f6b0:	mov    -0x528(%rbp),%rbx
  37f6b7:	mov    %rbx,%rdi
  37f6ba:	call   1906a00 <operator new(unsigned long)@plt>
  37f6bf:	lea    (%rax,%rbx,1),%rdi
  37f6c3:	mov    %rbx,%rcx
  37f6c6:	mov    %rax,-0x4b8(%rbp)
  37f6cd:	mov    %rdi,-0x610(%rbp)
  37f6d4:	movl   $0x0,(%rax)
  37f6da:	lea    0x4(%rax),%rbx
  37f6de:	cmp    $0x1,%r14
  37f6e2:	je     37f6fd <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0xa0d>
  37f6e4:	mov    %rdi,%r14
  37f6e7:	cmp    %rbx,%rdi
  37f6ea:	je     37f6fd <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0xa0d>
  37f6ec:	mov    %rbx,%rdi
  37f6ef:	lea    -0x4(%rcx),%rdx
  37f6f3:	xor    %esi,%esi
  37f6f5:	call   1906a10 <memset@plt>
  37f6fa:	mov    %r14,%rbx
  37f6fd:	mov    -0x4c0(%rbp),%rax
  37f704:	mov    -0x4b8(%rbp),%r14
  37f70b:	mov    (%rax),%rdi
  37f70e:	mov    -0x4c8(%rbp),%rdx
  37f715:	mov    %r14,%r8
  37f718:	mov    %r15,%rcx
  37f71b:	xor    %esi,%esi
  37f71d:	call   *0x38(%rax)
  37f720:	mov    %rbx,%rax
  37f723:	sub    %r14,%rax
  37f726:	mov    %rax,-0x4b0(%rbp)
  37f72d:	sar    $0x2,%rax
  37f731:	mov    %rax,%r12
  37f734:	cmp    %r14,%rbx
  37f737:	je     382419 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3729>
  37f73d:	movq   $0x0,-0x5c8(%rbp)
  37f748:	mov    -0x2d8(%rbp),%r13
  37f74f:	xor    %ebx,%ebx
  37f751:	lea    -0x306c99(%rip),%r14        # 78abf <_IO_stdin_used+0x146b>
  37f758:	jmp    37f769 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0xa79>
  37f75a:	inc    %rbx
  37f75d:	add    %rdi,-0x5c8(%rbp)
  37f764:	cmp    %r12,%rbx
  37f767:	jae    37f794 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0xaa4>
  37f769:	mov    -0x4b8(%rbp),%rax
  37f770:	mov    (%rax,%rbx,4),%edi
  37f773:	cmp    $0x1,%edi
  37f776:	ja     382d24 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x4034>
  37f77c:	cmpb   $0x0,0x0(%r13,%rbx,1)
  37f782:	je     37f75a <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0xa6a>
  37f784:	mov    %r14,%rsi
  37f787:	call   378740 <raw32_stage3::Need(bool, char const*)>
  37f78c:	inc    %rbx
  37f78f:	cmp    %r12,%rbx
  37f792:	jb     37f769 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0xa79>
  37f794:	movabs $0xcbf29ce484222325,%rdx
  37f79e:	mov    %rdx,-0x4e8(%rbp)
  37f7a5:	test   %r12,%r12
  37f7a8:	je     37f813 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0xb23>
  37f7aa:	mov    -0x4b8(%rbp),%rax
  37f7b1:	mov    -0x4b0(%rbp),%rdi
  37f7b8:	mov    %rax,%rsi
  37f7bb:	add    %rax,%rdi
  37f7be:	movabs $0x100000001b3,%rcx
  37f7c8:	nopl   0x0(%rax,%rax,1)
  37f7d0:	mov    (%rsi),%ebx
  37f7d2:	add    $0x4,%rsi
  37f7d6:	movzbl %bl,%eax
  37f7d9:	xor    %rdx,%rax
  37f7dc:	imul   %rcx,%rax
  37f7e0:	movzbl %bh,%edx
  37f7e3:	mov    %edx,%edx
  37f7e5:	xor    %rdx,%rax
  37f7e8:	imul   %rcx,%rax
  37f7ec:	mov    %ebx,%edx
  37f7ee:	shr    $0x10,%edx
  37f7f1:	movzbl %dl,%edx
  37f7f4:	xor    %rdx,%rax
  37f7f7:	imul   %rcx,%rax
  37f7fb:	shr    $0x18,%ebx
  37f7fe:	mov    %ebx,%edx
  37f800:	xor    %rax,%rdx
  37f803:	imul   %rcx,%rdx
  37f807:	cmp    %rsi,%rdi
  37f80a:	jne    37f7d0 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0xae0>
  37f80c:	mov    %rdx,-0x4e8(%rbp)
  37f813:	mov    -0x4c8(%rbp),%rsi
  37f81a:	mov    -0x5d8(%rbp),%rdi
  37f821:	call   3794e0 <raw32_stage3::GuardedOutput::GuardedOutput(unsigned long)>
  37f826:	mov    -0x410(%rbp),%rbx
  37f82d:	xor    %r12d,%r12d
  37f830:	mov    $0xdeadbeef,%r13d
  37f836:	mov    -0x4c0(%rbp),%rax
  37f83d:	mov    %r12d,%esi
  37f840:	mov    (%rax),%rdi
  37f843:	call   *0x20(%rax)
  37f846:	mov    -0x408(%rbp),%r14
  37f84d:	cmp    %rbx,%r14
  37f850:	je     37f8fe <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0xc0e>
  37f856:	lea    -0x4(%r14),%rdx
  37f85a:	sub    %rbx,%rdx
  37f85d:	mov    %rdx,%rcx
  37f860:	shr    $0x2,%rcx
  37f864:	mov    %rbx,%rax
  37f867:	lea    0x1(%rcx),%rdi
  37f86b:	cmp    $0x18,%rdx
  37f86f:	jbe    3823c7 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x36d7>
  37f875:	mov    %rdi,%rdx
  37f878:	shr    $0x3,%rdx
  37f87c:	shl    $0x5,%rdx
  37f880:	add    %rbx,%rdx
  37f883:	vpbroadcastd %r13d,%ymm0
  37f889:	nopl   0x0(%rax)
  37f890:	vmovdqu %ymm0,(%rax)
  37f894:	add    $0x20,%rax
  37f898:	cmp    %rax,%rdx
  37f89b:	jne    37f890 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0xba0>
  37f89d:	mov    %rdi,%rsi
  37f8a0:	and    $0xfffffffffffffff8,%rsi
  37f8a4:	and    $0x7,%edi
  37f8a7:	lea    (%rbx,%rsi,4),%rax
  37f8ab:	je     37f8fe <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0xc0e>
  37f8ad:	sub    %rsi,%rcx
  37f8b0:	mov    %rcx,%rdx
  37f8b3:	lea    0x1(%rcx),%rcx
  37f8b7:	cmp    $0x2,%rdx
  37f8bb:	jbe    37f8d8 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0xbe8>
  37f8bd:	mov    %rcx,%rdx
  37f8c0:	and    $0xfffffffffffffffc,%rdx
  37f8c4:	vpbroadcastd %r13d,%xmm0
  37f8ca:	and    $0x3,%ecx
  37f8cd:	vmovdqu %xmm0,(%rbx,%rsi,4)
  37f8d2:	lea    (%rax,%rdx,4),%rax
  37f8d6:	je     37f8fe <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0xc0e>
  37f8d8:	lea    0x4(%rax),%rdx
  37f8dc:	movl   $0xdeadbeef,(%rax)
  37f8e2:	cmp    %rdx,%r14
  37f8e5:	je     37f8fe <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0xc0e>
  37f8e7:	lea    0x8(%rax),%rdx
  37f8eb:	movl   $0xdeadbeef,0x4(%rax)
  37f8f2:	cmp    %rdx,%r14
  37f8f5:	je     37f8fe <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0xc0e>
  37f8f7:	movl   $0xdeadbeef,0x8(%rax)
  37f8fe:	mov    -0x3f8(%rbp),%rax
  37f905:	lea    0x40(%rbx),%rdi
  37f909:	mov    %rax,-0x4f8(%rbp)
  37f910:	shl    $0x2,%rax
  37f914:	lea    0x40(%rbx,%rax,1),%rcx
  37f919:	mov    %rdi,-0x4b0(%rbp)
  37f920:	mov    %rcx,-0x510(%rbp)
  37f927:	cmp    %rcx,%rdi
  37f92a:	je     37f9eb <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0xcfb>
  37f930:	sub    $0x4,%rax
  37f934:	mov    %rax,%rsi
  37f937:	shr    $0x2,%rsi
  37f93b:	lea    0x1(%rsi),%rdi
  37f93f:	cmp    $0x18,%rax
  37f943:	jbe    3823ce <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x36de>
  37f949:	mov    %rdi,%rdx
  37f94c:	shr    $0x3,%rdx
  37f950:	shl    $0x5,%rdx
  37f954:	mov    $0xfeedface,%ecx
  37f959:	mov    %rbx,%rax
  37f95c:	add    %rbx,%rdx
  37f95f:	vpbroadcastd %ecx,%ymm0
  37f965:	nopl   (%rax)
  37f968:	vmovdqu %ymm0,0x40(%rax)
  37f96d:	add    $0x20,%rax
  37f971:	cmp    %rax,%rdx
  37f974:	jne    37f968 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0xc78>
  37f976:	mov    %rdi,%rcx
  37f979:	mov    -0x4b0(%rbp),%rax
  37f980:	and    $0xfffffffffffffff8,%rcx
  37f984:	and    $0x7,%edi
  37f987:	lea    (%rax,%rcx,4),%rax
  37f98b:	je     37f9eb <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0xcfb>
  37f98d:	sub    %rcx,%rsi
  37f990:	mov    %rsi,%rdx
  37f993:	lea    0x1(%rsi),%rsi
  37f997:	cmp    $0x2,%rdx
  37f99b:	jbe    37f9be <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0xcce>
  37f99d:	mov    $0xfeedface,%edx
  37f9a2:	vpbroadcastd %edx,%xmm0
  37f9a8:	mov    %rsi,%rdx
  37f9ab:	and    $0xfffffffffffffffc,%rdx
  37f9af:	and    $0x3,%esi
  37f9b2:	vmovdqu %xmm0,0x40(%rbx,%rcx,4)
  37f9b8:	lea    (%rax,%rdx,4),%rax
  37f9bc:	je     37f9eb <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0xcfb>
  37f9be:	mov    -0x510(%rbp),%rdi
  37f9c5:	lea    0x4(%rax),%rdx
  37f9c9:	movl   $0xfeedface,(%rax)
  37f9cf:	cmp    %rdx,%rdi
  37f9d2:	je     37f9eb <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0xcfb>
  37f9d4:	lea    0x8(%rax),%rdx
  37f9d8:	movl   $0xfeedface,0x4(%rax)
  37f9df:	cmp    %rdx,%rdi
  37f9e2:	je     37f9eb <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0xcfb>
  37f9e4:	movl   $0xfeedface,0x8(%rax)
  37f9eb:	mov    -0x4c0(%rbp),%rax
  37f9f2:	mov    -0x4b0(%rbp),%r8
  37f9f9:	mov    (%rax),%rdi
  37f9fc:	mov    -0x4c8(%rbp),%rdx
  37fa03:	mov    %r15,%rcx
  37fa06:	mov    %r12d,%esi
  37fa09:	vzeroupper
  37fa0c:	call   *0x38(%rax)
  37fa0f:	mov    -0x4b8(%rbp),%rsi
  37fa16:	mov    -0x5d8(%rbp),%rdi
  37fa1d:	call   3797f0 <raw32_stage3::GuardedOutput::Check(unsigned int const*) const>
  37fa22:	inc    %r12d
  37fa25:	cmp    $0x3,%r12d
  37fa29:	jne    37f836 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0xb46>
  37fa2f:	mov    -0x4f0(%rbp),%rdi
  37fa36:	lea    -0x306b79(%rip),%rsi        # 78ec4 <_IO_stdin_used+0x1870>
  37fa3d:	call   1906aa0 <std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::compare(char const*) const@plt>
  37fa42:	test   %eax,%eax
  37fa44:	je     3800f8 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1408>
  37fa4a:	mov    -0x4c0(%rbp),%rax
  37fa51:	mov    $0x2,%esi
  37fa56:	mov    (%rax),%rdi
  37fa59:	call   *0x20(%rax)
  37fa5c:	mov    -0x4b8(%rbp),%rax
  37fa63:	movq   $0x0,-0x558(%rbp)
  37fa6e:	mov    %rax,-0x568(%rbp)
  37fa75:	mov    %rax,-0x548(%rbp)
  37fa7c:	movq   $0x7c,-0x4d8(%rbp)
  37fa87:	mov    -0x558(%rbp),%rax
  37fa8e:	mov    %r15,-0x560(%rbp)
  37fa95:	add    %r15,%rax
  37fa98:	movq   $0x0,-0x500(%rbp)
  37faa3:	mov    %rax,-0x540(%rbp)
  37faaa:	mov    -0x4d8(%rbp),%rax
  37fab1:	nopl   0x0(%rax)
  37fab8:	lea    0x4(%rax),%r13
  37fabc:	mov    %r13,%rdi
  37fabf:	mov    %r13,-0x518(%rbp)
  37fac6:	call   1906a00 <operator new(unsigned long)@plt>
  37facb:	mov    -0x4d8(%rbp),%rdi
  37fad2:	mov    $0xdeadbeef,%esi
  37fad7:	shr    $0x2,%rdi
  37fadb:	lea    0x1(%rdi),%r8
  37fadf:	mov    %r8,%rcx
  37fae2:	shr    $0x3,%rcx
  37fae6:	shl    $0x5,%rcx
  37faea:	mov    %rax,%r12
  37faed:	add    %rax,%r13
  37faf0:	add    %rax,%rcx
  37faf3:	mov    %rax,%rdx
  37faf6:	vpbroadcastd %esi,%ymm0
  37fafc:	vmovdqu %ymm0,(%rdx)
  37fb00:	add    $0x20,%rdx
  37fb04:	cmp    %rdx,%rcx
  37fb07:	jne    37fafc <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0xe0c>
  37fb09:	mov    %r8,%r9
  37fb0c:	and    $0xfffffffffffffff8,%r9
  37fb10:	lea    (%r12,%r9,4),%rsi
  37fb14:	test   $0x7,%r8b
  37fb18:	je     37fb74 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0xe84>
  37fb1a:	mov    %rdi,%rdx
  37fb1d:	sub    %r9,%rdx
  37fb20:	lea    0x1(%rdx),%r10
  37fb24:	cmp    $0x2,%rdx
  37fb28:	jbe    3820cd <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x33dd>
  37fb2e:	mov    $0xdeadbeef,%edx
  37fb33:	vpbroadcastd %edx,%xmm0
  37fb39:	mov    %r10,%rdx
  37fb3c:	and    $0xfffffffffffffffc,%rdx
  37fb40:	and    $0x3,%r10d
  37fb44:	vmovdqu %xmm0,(%rsi)
  37fb48:	lea    (%rsi,%rdx,4),%rdx
  37fb4c:	je     37fb74 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0xe84>
  37fb4e:	lea    0x4(%rdx),%r10
  37fb52:	movl   $0xdeadbeef,(%rdx)
  37fb58:	cmp    %r10,%r13
  37fb5b:	je     37fb74 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0xe84>
  37fb5d:	lea    0x8(%rdx),%r10
  37fb61:	movl   $0xdeadbeef,0x4(%rdx)
  37fb68:	cmp    %r10,%r13
  37fb6b:	je     37fb74 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0xe84>
  37fb6d:	movl   $0xdeadbeef,0x8(%rdx)
  37fb74:	mov    $0xdeadbeef,%r11d
  37fb7a:	mov    %r12,%rdx
  37fb7d:	vpbroadcastd %r11d,%ymm0
  37fb83:	nopl   0x0(%rax,%rax,1)
  37fb88:	vmovdqu %ymm0,(%rdx)
  37fb8c:	add    $0x20,%rdx
  37fb90:	cmp    %rdx,%rcx
  37fb93:	jne    37fb88 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0xe98>
  37fb95:	and    $0x7,%r8d
  37fb99:	je     37fbef <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0xeff>
  37fb9b:	sub    %r9,%rdi
  37fb9e:	lea    0x1(%rdi),%rcx
  37fba2:	cmp    $0x2,%rdi
  37fba6:	jbe    37fbc9 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0xed9>
  37fba8:	mov    %rcx,%rdx
  37fbab:	mov    $0xdeadbeef,%edi
  37fbb0:	and    $0xfffffffffffffffc,%rdx
  37fbb4:	vpbroadcastd %edi,%xmm0
  37fbba:	and    $0x3,%ecx
  37fbbd:	vmovdqu %xmm0,(%r12,%r9,4)
  37fbc3:	lea    (%rsi,%rdx,4),%rsi
  37fbc7:	je     37fbef <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0xeff>
  37fbc9:	lea    0x4(%rsi),%rdx
  37fbcd:	movl   $0xdeadbeef,(%rsi)
  37fbd3:	cmp    %rdx,%r13
  37fbd6:	je     37fbef <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0xeff>
  37fbd8:	lea    0x8(%rsi),%rdx
  37fbdc:	movl   $0xdeadbeef,0x4(%rsi)
  37fbe3:	cmp    %rdx,%r13
  37fbe6:	je     37fbef <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0xeff>
  37fbe8:	movl   $0xdeadbeef,0x8(%rsi)
  37fbef:	mov    -0x4d8(%rbp),%rdi
  37fbf6:	lea    0x40(%r12),%rcx
  37fbfb:	lea    -0x3c(%r12,%rdi,1),%rdi
  37fc00:	mov    %rcx,-0x508(%rbp)
  37fc07:	mov    %rdi,-0x4d0(%rbp)
  37fc0e:	cmp    %rdi,%rcx
  37fc11:	je     37fcd7 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0xfe7>
  37fc17:	mov    -0x4d8(%rbp),%rdx
  37fc1e:	add    $0xffffffffffffff80,%rdx
  37fc22:	mov    %rdx,%rsi
  37fc25:	shr    $0x2,%rsi
  37fc29:	lea    0x1(%rsi),%rdi
  37fc2d:	cmp    $0x18,%rdx
  37fc31:	jbe    380b7b <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1e8b>
  37fc37:	mov    %rdi,%rdx
  37fc3a:	shr    $0x3,%rdx
  37fc3e:	shl    $0x5,%rdx
  37fc42:	mov    $0xfeedface,%ecx
  37fc47:	add    %r12,%rdx
  37fc4a:	vpbroadcastd %ecx,%ymm0
  37fc50:	vmovdqu %ymm0,0x40(%rax)
  37fc55:	add    $0x20,%rax
  37fc59:	cmp    %rdx,%rax
  37fc5c:	jne    37fc50 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0xf60>
  37fc5e:	mov    %rdi,%rdx
  37fc61:	mov    -0x508(%rbp),%rax
  37fc68:	and    $0xfffffffffffffff8,%rdx
  37fc6c:	and    $0x7,%edi
  37fc6f:	lea    (%rax,%rdx,4),%r8
  37fc73:	je     37fcd7 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0xfe7>
  37fc75:	mov    %rsi,%rax
  37fc78:	sub    %rdx,%rax
  37fc7b:	lea    0x1(%rax),%rcx
  37fc7f:	cmp    $0x2,%rax
  37fc83:	jbe    37fca7 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0xfb7>
  37fc85:	mov    $0xfeedface,%eax
  37fc8a:	vpbroadcastd %eax,%xmm0
  37fc90:	mov    %rcx,%rax
  37fc93:	and    $0xfffffffffffffffc,%rax
  37fc97:	and    $0x3,%ecx
  37fc9a:	vmovdqu %xmm0,0x40(%r12,%rdx,4)
  37fca1:	lea    (%r8,%rax,4),%r8
  37fca5:	je     37fcd7 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0xfe7>
  37fca7:	mov    -0x4d0(%rbp),%rcx
  37fcae:	lea    0x4(%r8),%rax
  37fcb2:	movl   $0xfeedface,(%r8)
  37fcb9:	cmp    %rax,%rcx
  37fcbc:	je     37fcd7 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0xfe7>
  37fcbe:	lea    0x8(%r8),%rax
  37fcc2:	movl   $0xfeedface,0x4(%r8)
  37fcca:	cmp    %rax,%rcx
  37fccd:	je     37fcd7 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0xfe7>
  37fccf:	movl   $0xfeedface,0x8(%r8)
  37fcd7:	mov    -0x4c0(%rbp),%rax
  37fcde:	mov    -0x508(%rbp),%rcx
  37fce5:	mov    (%rax),%rdi
  37fce8:	mov    -0x540(%rbp),%rdx
  37fcef:	mov    -0x500(%rbp),%esi
  37fcf5:	vzeroupper
  37fcf8:	call   *0x30(%rax)
  37fcfb:	cmpl   $0xdeadbeef,(%r12)
  37fd03:	jne    3823e7 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x36f7>
  37fd09:	cmpl   $0xdeadbeef,0x4(%r12)
  37fd12:	jne    37fff0 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1300>
  37fd18:	cmpl   $0xdeadbeef,0x8(%r12)
  37fd21:	jne    380b08 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1e18>
  37fd27:	cmpl   $0xdeadbeef,0xc(%r12)
  37fd30:	jne    380b28 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1e38>
  37fd36:	cmpl   $0xdeadbeef,0x10(%r12)
  37fd3f:	lea    0x10(%r12),%rax
  37fd44:	jne    37fff7 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1307>
  37fd4a:	cmpl   $0xdeadbeef,0x14(%r12)
  37fd53:	jne    37fff3 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1303>
  37fd59:	cmpl   $0xdeadbeef,0x18(%r12)
  37fd62:	jne    380b0b <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1e1b>
  37fd68:	cmpl   $0xdeadbeef,0x1c(%r12)
  37fd71:	jne    380b2b <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1e3b>
  37fd77:	cmpl   $0xdeadbeef,0x20(%r12)
  37fd80:	lea    0x20(%r12),%rax
  37fd85:	jne    37fff7 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1307>
  37fd8b:	cmpl   $0xdeadbeef,0x24(%r12)
  37fd94:	jne    37fff3 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1303>
  37fd9a:	cmpl   $0xdeadbeef,0x28(%r12)
  37fda3:	jne    380b0b <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1e1b>
  37fda9:	cmpl   $0xdeadbeef,0x2c(%r12)
  37fdb2:	jne    380b2b <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1e3b>
  37fdb8:	cmpl   $0xdeadbeef,0x30(%r12)
  37fdc1:	lea    0x30(%r12),%rax
  37fdc6:	jne    37fff7 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1307>
  37fdcc:	cmpl   $0xdeadbeef,0x34(%r12)
  37fdd5:	jne    37fff3 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1303>
  37fddb:	cmpl   $0xdeadbeef,0x38(%r12)
  37fde4:	jne    380b0b <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1e1b>
  37fdea:	cmpl   $0xdeadbeef,0x3c(%r12)
  37fdf3:	jne    380b2b <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1e3b>
  37fdf9:	mov    -0x4d0(%rbp),%rax
  37fe00:	cmpl   $0xdeadbeef,(%rax)
  37fe06:	jne    37ffb0 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x12c0>
  37fe0c:	cmpl   $0xdeadbeef,0x4(%rax)
  37fe13:	jne    37ffa8 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x12b8>
  37fe19:	cmpl   $0xdeadbeef,0x8(%rax)
  37fe20:	jne    380ae8 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1df8>
  37fe26:	cmpl   $0xdeadbeef,0xc(%rax)
  37fe2d:	jne    380ac7 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1dd7>
  37fe33:	lea    -0x30(%r13),%rax
  37fe37:	cmpl   $0xdeadbeef,-0x30(%r13)
  37fe3f:	mov    %rax,-0x4d0(%rbp)
  37fe46:	jne    37ffb0 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x12c0>
  37fe4c:	cmpl   $0xdeadbeef,-0x2c(%r13)
  37fe54:	jne    37ffa8 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x12b8>
  37fe5a:	cmpl   $0xdeadbeef,-0x28(%r13)
  37fe62:	jne    380ae8 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1df8>
  37fe68:	cmpl   $0xdeadbeef,-0x24(%r13)
  37fe70:	jne    380ac7 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1dd7>
  37fe76:	lea    -0x20(%r13),%rax
  37fe7a:	cmpl   $0xdeadbeef,-0x20(%r13)
  37fe82:	mov    %rax,-0x4d0(%rbp)
  37fe89:	jne    37ffb0 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x12c0>
  37fe8f:	cmpl   $0xdeadbeef,-0x1c(%r13)
  37fe97:	jne    37ffa8 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x12b8>
  37fe9d:	cmpl   $0xdeadbeef,-0x18(%r13)
  37fea5:	jne    380ae8 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1df8>
  37feab:	cmpl   $0xdeadbeef,-0x14(%r13)
  37feb3:	jne    380ac7 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1dd7>
  37feb9:	lea    -0x10(%r13),%rax
  37febd:	cmpl   $0xdeadbeef,-0x10(%r13)
  37fec5:	mov    %rax,-0x4d0(%rbp)
  37fecc:	jne    37ffb0 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x12c0>
  37fed2:	cmpl   $0xdeadbeef,-0xc(%r13)
  37feda:	jne    37ffa8 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x12b8>
  37fee0:	cmpl   $0xdeadbeef,-0x8(%r13)
  37fee8:	jne    380ae8 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1df8>
  37feee:	cmpl   $0xdeadbeef,-0x4(%r13)
  37fef6:	jne    380ac7 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1dd7>
  37fefc:	xor    %r13d,%r13d
  37feff:	cmpq   $0x0,-0x500(%rbp)
  37ff07:	je     380b52 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1e62>
  37ff0d:	mov    -0x500(%rbp),%rdx
  37ff14:	mov    -0x548(%rbp),%rcx
  37ff1b:	nopl   0x0(%rax,%rax,1)
  37ff20:	mov    0x40(%r12,%r13,4),%eax
  37ff25:	cmp    $0x1,%eax
  37ff28:	jbe    37ff60 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1270>
  37ff2a:	mov    $0x10,%edi
  37ff2f:	call   1906930 <__cxa_allocate_exception@plt>
  37ff34:	mov    %rax,%rdi
  37ff37:	lea    -0x307797(%rip),%rsi        # 787a7 <_IO_stdin_used+0x1153>
  37ff3e:	mov    %rax,%rbx
  37ff41:	call   19069d0 <std::runtime_error::runtime_error(char const*)@plt>
  37ff46:	mov    0x15aebdb(%rip),%rdx        # 192eb28 <std::runtime_error::~runtime_error()@GLIBCXX_3.4>
  37ff4d:	lea    0x15aec8c(%rip),%rsi        # 192ebe0 <typeinfo for std::runtime_error@GLIBCXX_3.4>
  37ff54:	mov    %rbx,%rdi
  37ff57:	call   1906940 <__cxa_throw@plt>
  37ff5c:	nopl   0x0(%rax)
  37ff60:	cmp    (%rcx,%r13,4),%eax
  37ff64:	jne    37ff2a <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x123a>
  37ff66:	inc    %r13
  37ff69:	cmp    %rdx,%r13
  37ff6c:	jne    37ff20 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1230>
  37ff6e:	mov    -0x518(%rbp),%rsi
  37ff75:	mov    %r12,%rdi
  37ff78:	call   1906920 <operator delete(void*, unsigned long)@plt>
  37ff7d:	lea    0x1(%r13),%rax
  37ff81:	mov    %rax,-0x500(%rbp)
  37ff88:	cmp    $0x83,%r13
  37ff8f:	je     380040 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1350>
  37ff95:	mov    -0x518(%rbp),%rax
  37ff9c:	mov    %rax,-0x4d8(%rbp)
  37ffa3:	jmp    37fab8 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0xdc8>
  37ffa8:	addq   $0x4,-0x4d0(%rbp)
  37ffb0:	cmp    %r13,-0x4d0(%rbp)
  37ffb7:	je     37fefc <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x120c>
  37ffbd:	mov    $0x10,%edi
  37ffc2:	call   1906930 <__cxa_allocate_exception@plt>
  37ffc7:	mov    %rax,%rdi
  37ffca:	lea    -0x307b4b(%rip),%rsi        # 78486 <_IO_stdin_used+0xe32>
  37ffd1:	mov    %rax,%r13
  37ffd4:	call   19069d0 <std::runtime_error::runtime_error(char const*)@plt>
  37ffd9:	mov    0x15aeb48(%rip),%rdx        # 192eb28 <std::runtime_error::~runtime_error()@GLIBCXX_3.4>
  37ffe0:	lea    0x15aebf9(%rip),%rsi        # 192ebe0 <typeinfo for std::runtime_error@GLIBCXX_3.4>
  37ffe7:	mov    %r13,%rdi
  37ffea:	call   1906940 <__cxa_throw@plt>
  37ffef:	nop
  37fff0:	mov    %r12,%rax
  37fff3:	add    $0x4,%rax
  37fff7:	mov    -0x508(%rbp),%rcx
  37fffe:	cmp    %rcx,%rax
  380001:	je     37fdf9 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1109>
  380007:	mov    $0x10,%edi
  38000c:	call   1906930 <__cxa_allocate_exception@plt>
  380011:	mov    %rax,%rdi
  380014:	lea    -0x307520(%rip),%rsi        # 78afb <_IO_stdin_used+0x14a7>
  38001b:	mov    %rax,%r13
  38001e:	call   19069d0 <std::runtime_error::runtime_error(char const*)@plt>
  380023:	mov    0x15aeafe(%rip),%rdx        # 192eb28 <std::runtime_error::~runtime_error()@GLIBCXX_3.4>
  38002a:	lea    0x15aebaf(%rip),%rsi        # 192ebe0 <typeinfo for std::runtime_error@GLIBCXX_3.4>
  380031:	mov    %r13,%rdi
  380034:	call   1906940 <__cxa_throw@plt>
  380039:	nopl   0x0(%rax)
  380040:	addq   $0x4,-0x558(%rbp)
  380048:	addq   $0x4,-0x548(%rbp)
  380050:	mov    -0x558(%rbp),%rax
  380057:	cmp    $0x10,%rax
  38005b:	jne    37fa7c <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0xd8c>
  380061:	lea    -0x360(%rbp),%rax
  380068:	movq   $0x0,-0x4d8(%rbp)
  380073:	mov    %rax,-0x508(%rbp)
  38007a:	mov    -0x5b8(%rbp),%rax
  380081:	vmovdqa -0x3053e9(%rip),%xmm4        # 7aca0 <bloom_filters::FastPatternBF::sparse_patterns_+0x1840>
  380089:	mov    %rax,-0x4d0(%rbp)
  380090:	vmovdqa %xmm4,-0x370(%rbp)
  380098:	mov    -0x4d0(%rbp),%rax
  38009f:	movslq (%rax),%r13
  3800a2:	mov    -0x4d8(%rbp),%rax
  3800a9:	add    %r13,%rax
  3800ac:	cmp    %rax,-0x4c8(%rbp)
  3800b3:	jae    382480 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3790>
  3800b9:	addq   $0x4,-0x4d0(%rbp)
  3800c1:	mov    -0x508(%rbp),%rcx
  3800c8:	mov    -0x4d0(%rbp),%rax
  3800cf:	cmp    %rcx,%rax
  3800d2:	jne    380098 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x13a8>
  3800d4:	incq   -0x4d8(%rbp)
  3800db:	addq   $0x4,-0x568(%rbp)
  3800e3:	addq   $0x4,-0x560(%rbp)
  3800eb:	mov    -0x4d8(%rbp),%rax
  3800f2:	cmp    $0x4,%rax
  3800f6:	jne    38007a <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x138a>
  3800f8:	lea    -0x3e0(%rbp),%rax
  3800ff:	mov    %rax,-0x518(%rbp)
  380106:	mov    %rax,-0x3f0(%rbp)
  38010d:	mov    -0x4f0(%rbp),%rax
  380114:	vpxor  %xmm0,%xmm0,%xmm0
  380118:	mov    0x58(%rax),%edx
  38011b:	vmovdqa %xmm0,-0x370(%rbp)
  380123:	vmovdqa %xmm0,-0x360(%rbp)
  38012b:	vmovdqa %xmm0,-0x350(%rbp)
  380133:	vpxor  %xmm0,%xmm0,%xmm0
  380137:	movq   $0x0,-0x340(%rbp)
  380142:	movq   $0x0,-0x338(%rbp)
  38014d:	movq   $0x0,-0x330(%rbp)
  380158:	movq   $0x0,-0x440(%rbp)
  380163:	movq   $0x0,-0x3e8(%rbp)
  38016e:	movb   $0x0,-0x3e0(%rbp)
  380175:	vmovdqa %xmm0,-0x450(%rbp)
  38017d:	test   %edx,%edx
  38017f:	je     380b85 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1e95>
  380185:	lea    -0x4(%r14),%rax
  380189:	sub    %rbx,%rax
  38018c:	mov    %rax,-0x540(%rbp)
  380193:	shr    $0x2,%rax
  380197:	lea    0x1(%rax),%rcx
  38019b:	mov    %rax,-0x568(%rbp)
  3801a2:	mov    %rcx,%rax
  3801a5:	shr    $0x3,%rax
  3801a9:	shl    $0x5,%rax
  3801ad:	add    %rbx,%rax
  3801b0:	mov    %rcx,-0x570(%rbp)
  3801b7:	and    $0xfffffffffffffff8,%rcx
  3801bb:	mov    %rax,-0x560(%rbp)
  3801c2:	lea    (%rbx,%rcx,4),%rax
  3801c6:	mov    %rcx,-0x5a0(%rbp)
  3801cd:	mov    %rax,-0x598(%rbp)
  3801d4:	mov    -0x4b0(%rbp),%rcx
  3801db:	mov    -0x510(%rbp),%rax
  3801e2:	movl   $0x0,-0x500(%rbp)
  3801ec:	sub    %rcx,%rax
  3801ef:	sub    $0x4,%rax
  3801f3:	mov    %rax,-0x548(%rbp)
  3801fa:	shr    $0x2,%rax
  3801fe:	lea    0x1(%rax),%rdi
  380202:	mov    %rax,-0x578(%rbp)
  380209:	mov    %rdi,%rax
  38020c:	shr    $0x3,%rax
  380210:	shl    $0x5,%rax
  380214:	add    %rcx,%rax
  380217:	mov    %rdi,-0x580(%rbp)
  38021e:	and    $0xfffffffffffffff8,%rdi
  380222:	mov    %rax,-0x558(%rbp)
  380229:	lea    (%rcx,%rdi,4),%rax
  38022d:	mov    %rdi,-0x5b0(%rbp)
  380234:	mov    %rax,-0x5a8(%rbp)
  38023b:	movq   $0x0,-0x4d8(%rbp)
  380246:	mov    -0x518(%rbp),%rsi
  38024d:	movl   $0x0,-0x4d0(%rbp)
  380257:	mov    -0x4f0(%rbp),%rax
  38025e:	mov    $0xaaaaaaab,%edi
  380263:	mov    0x50(%rax),%edx
  380266:	mov    -0x4d0(%rbp),%ecx
  38026c:	mov    %rdx,%rax
  38026f:	imul   %rdi,%rdx
  380273:	shr    $0x22,%rdx
  380277:	lea    (%rdx,%rdx,2),%edx
  38027a:	add    %edx,%edx
  38027c:	sub    %edx,%eax
  38027e:	mov    -0x500(%rbp),%edx
  380284:	add    %eax,%edx
  380286:	mov    %rdx,%rax
  380289:	imul   %rdi,%rdx
  38028d:	lea    -0x306f54(%rip),%rdi        # 79340 <vldb_stage2::Phase(unsigned int, unsigned int, unsigned int)::orders>
  380294:	shr    $0x22,%rdx
  380298:	lea    (%rdx,%rdx,2),%edx
  38029b:	add    %edx,%edx
  38029d:	sub    %edx,%eax
  38029f:	lea    (%rax,%rax,2),%rax
  3802a3:	add    %rcx,%rax
  3802a6:	mov    (%rdi,%rax,4),%r12d
  3802aa:	lea    0x30(%r12),%eax
  3802af:	mov    %al,-0x508(%rbp)
  3802b5:	mov    -0x4d8(%rbp),%rax
  3802bc:	lea    0x1(%rax),%r13
  3802c0:	mov    -0x518(%rbp),%rax
  3802c7:	cmp    %rax,%rsi
  3802ca:	je     380a58 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1d68>
  3802d0:	mov    -0x3e0(%rbp),%rax
  3802d7:	cmp    %r13,%rax
  3802da:	jb     3809c2 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1cd2>
  3802e0:	mov    -0x4d8(%rbp),%rax
  3802e7:	movzbl -0x508(%rbp),%edi
  3802ee:	mov    %dil,(%rsi,%rax,1)
  3802f2:	mov    %r13,-0x3e8(%rbp)
  3802f9:	mov    %r12d,%esi
  3802fc:	mov    -0x3f0(%rbp),%rax
  380303:	movb   $0x0,(%rax,%r13,1)
  380308:	mov    -0x4c0(%rbp),%r13
  38030f:	mov    0x0(%r13),%rdi
  380313:	call   *0x20(%r13)
  380317:	mov    0x0(%r13),%rdi
  38031b:	call   *0x40(%r13)
  38031f:	mov    %r12d,%r13d
  380322:	mov    %rax,-0x450(%rbp,%r13,8)
  38032a:	cmp    %rbx,%r14
  38032d:	je     3803de <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x16ee>
  380333:	cmpq   $0x18,-0x540(%rbp)
  38033b:	mov    %rbx,%rax
  38033e:	jbe    380ac0 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1dd0>
  380344:	mov    $0xdeadbeef,%edx
  380349:	vpbroadcastd %edx,%ymm0
  38034f:	mov    -0x560(%rbp),%rdx
  380356:	cs nopw 0x0(%rax,%rax,1)
  380360:	vmovdqu %ymm0,(%rax)
  380364:	add    $0x20,%rax
  380368:	cmp    %rdx,%rax
  38036b:	jne    380360 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1670>
  38036d:	testb  $0x7,-0x570(%rbp)
  380374:	je     3803de <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x16ee>
  380376:	mov    -0x5a0(%rbp),%rsi
  38037d:	mov    -0x598(%rbp),%rax
  380384:	mov    -0x568(%rbp),%rdx
  38038b:	sub    %rsi,%rdx
  38038e:	lea    0x1(%rdx),%rcx
  380392:	cmp    $0x2,%rdx
  380396:	jbe    3803b8 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x16c8>
  380398:	mov    $0xdeadbeef,%edx
  38039d:	vpbroadcastd %edx,%xmm0
  3803a3:	mov    %rcx,%rdx
  3803a6:	and    $0xfffffffffffffffc,%rdx
  3803aa:	and    $0x3,%ecx
  3803ad:	vmovdqu %xmm0,(%rbx,%rsi,4)
  3803b2:	lea    (%rax,%rdx,4),%rax
  3803b6:	je     3803de <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x16ee>
  3803b8:	lea    0x4(%rax),%rdx
  3803bc:	movl   $0xdeadbeef,(%rax)
  3803c2:	cmp    %rdx,%r14
  3803c5:	je     3803de <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x16ee>
  3803c7:	lea    0x8(%rax),%rdx
  3803cb:	movl   $0xdeadbeef,0x4(%rax)
  3803d2:	cmp    %rdx,%r14
  3803d5:	je     3803de <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x16ee>
  3803d7:	movl   $0xdeadbeef,0x8(%rax)
  3803de:	mov    -0x510(%rbp),%rdi
  3803e5:	cmp    %rdi,-0x4b0(%rbp)
  3803ec:	je     3804ac <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x17bc>
  3803f2:	cmpq   $0x18,-0x548(%rbp)
  3803fa:	mov    -0x4b0(%rbp),%rax
  380401:	jbe    380ab9 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1dc9>
  380407:	mov    $0xfeedface,%edx
  38040c:	vpbroadcastd %edx,%ymm0
  380412:	mov    -0x558(%rbp),%rdx
  380419:	nopl   0x0(%rax)
  380420:	vmovdqu %ymm0,(%rax)
  380424:	add    $0x20,%rax
  380428:	cmp    %rax,%rdx
  38042b:	jne    380420 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1730>
  38042d:	testb  $0x7,-0x580(%rbp)
  380434:	je     3804ac <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x17bc>
  380436:	mov    -0x5b0(%rbp),%rsi
  38043d:	mov    -0x5a8(%rbp),%rax
  380444:	mov    -0x578(%rbp),%rdx
  38044b:	sub    %rsi,%rdx
  38044e:	lea    0x1(%rdx),%rcx
  380452:	cmp    $0x2,%rdx
  380456:	jbe    38047f <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x178f>
  380458:	mov    $0xfeedface,%edx
  38045d:	vpbroadcastd %edx,%xmm0
  380463:	mov    -0x4b0(%rbp),%rdi
  38046a:	mov    %rcx,%rdx
  38046d:	and    $0xfffffffffffffffc,%rdx
  380471:	and    $0x3,%ecx
  380474:	vmovdqu %xmm0,(%rdi,%rsi,4)
  380479:	lea    (%rax,%rdx,4),%rax
  38047d:	je     3804ac <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x17bc>
  38047f:	mov    -0x510(%rbp),%rdi
  380486:	lea    0x4(%rax),%rdx
  38048a:	movl   $0xfeedface,(%rax)
  380490:	cmp    %rdx,%rdi
  380493:	je     3804ac <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x17bc>
  380495:	lea    0x8(%rax),%rdx
  380499:	movl   $0xfeedface,0x4(%rax)
  3804a0:	cmp    %rdx,%rdi
  3804a3:	je     3804ac <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x17bc>
  3804a5:	movl   $0xfeedface,0x8(%rax)
  3804ac:	vzeroupper
  3804af:	call   1906c60 <std::chrono::_V2::steady_clock::now()@plt>
  3804b4:	mov    %rax,-0x4d8(%rbp)
  3804bb:	mov    -0x4c0(%rbp),%rax
  3804c2:	mov    -0x4b0(%rbp),%r8
  3804c9:	mov    (%rax),%rdi
  3804cc:	mov    -0x4c8(%rbp),%rdx
  3804d3:	mov    %r15,%rcx
  3804d6:	mov    %r12d,%esi
  3804d9:	call   *0x38(%rax)
  3804dc:	call   1906c60 <std::chrono::_V2::steady_clock::now()@plt>
  3804e1:	mov    -0x4d8(%rbp),%rcx
  3804e8:	vxorpd %xmm5,%xmm5,%xmm5
  3804ec:	sub    %rcx,%rax
  3804ef:	vcvtsi2sd %rax,%xmm5,%xmm0
  3804f4:	vcvtsi2sdq -0x4c8(%rbp),%xmm5,%xmm1
  3804fd:	lea    0x0(%r13,%r13,2),%rax
  380502:	shl    $0x3,%rax
  380506:	mov    -0x368(%rbp,%rax,1),%rsi
  38050e:	vdivsd %xmm1,%xmm0,%xmm0
  380512:	vmovsd %xmm0,-0x1b0(%rbp)
  38051a:	cmp    -0x360(%rbp,%rax,1),%rsi
  380522:	je     380a62 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1d72>
  380528:	vmovsd %xmm0,(%rsi)
  38052c:	add    $0x8,%rsi
  380530:	cmpl   $0xdeadbeef,(%rbx)
  380536:	mov    %rsi,-0x368(%rbp,%rax,1)
  38053e:	jne    380a85 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1d95>
  380544:	cmpl   $0xdeadbeef,0x4(%rbx)
  38054b:	jne    3808f0 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1c00>
  380551:	cmpl   $0xdeadbeef,0x8(%rbx)
  380558:	jne    380a00 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1d10>
  38055e:	cmpl   $0xdeadbeef,0xc(%rbx)
  380565:	jne    380a20 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1d30>
  38056b:	cmpl   $0xdeadbeef,0x10(%rbx)
  380572:	lea    0x10(%rbx),%rax
  380576:	jne    3808f7 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1c07>
  38057c:	cmpl   $0xdeadbeef,0x14(%rbx)
  380583:	jne    3808f3 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1c03>
  380589:	cmpl   $0xdeadbeef,0x18(%rbx)
  380590:	jne    380a03 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1d13>
  380596:	cmpl   $0xdeadbeef,0x1c(%rbx)
  38059d:	jne    380a23 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1d33>
  3805a3:	cmpl   $0xdeadbeef,0x20(%rbx)
  3805aa:	lea    0x20(%rbx),%rax
  3805ae:	jne    3808f7 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1c07>
  3805b4:	cmpl   $0xdeadbeef,0x24(%rbx)
  3805bb:	jne    3808f3 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1c03>
  3805c1:	cmpl   $0xdeadbeef,0x28(%rbx)
  3805c8:	jne    380a03 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1d13>
  3805ce:	cmpl   $0xdeadbeef,0x2c(%rbx)
  3805d5:	jne    380a23 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1d33>
  3805db:	cmpl   $0xdeadbeef,0x30(%rbx)
  3805e2:	lea    0x30(%rbx),%rax
  3805e6:	jne    3808f7 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1c07>
  3805ec:	cmpl   $0xdeadbeef,0x34(%rbx)
  3805f3:	jne    3808f3 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1c03>
  3805f9:	cmpl   $0xdeadbeef,0x38(%rbx)
  380600:	jne    380a03 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1d13>
  380606:	cmpl   $0xdeadbeef,0x3c(%rbx)
  38060d:	jne    380a23 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1d33>
  380613:	cmpl   $0xdeadbeef,-0x40(%r14)
  38061b:	lea    -0x40(%r14),%rax
  38061f:	jne    3808b4 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1bc4>
  380625:	cmpl   $0xdeadbeef,-0x3c(%r14)
  38062d:	jne    3808b0 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1bc0>
  380633:	cmpl   $0xdeadbeef,-0x38(%r14)
  38063b:	jne    3809eb <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1cfb>
  380641:	cmpl   $0xdeadbeef,-0x34(%r14)
  380649:	jne    380a40 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1d50>
  38064f:	cmpl   $0xdeadbeef,-0x30(%r14)
  380657:	lea    -0x30(%r14),%rax
  38065b:	jne    3808b4 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1bc4>
  380661:	cmpl   $0xdeadbeef,-0x2c(%r14)
  380669:	jne    3808b0 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1bc0>
  38066f:	cmpl   $0xdeadbeef,-0x28(%r14)
  380677:	jne    3809eb <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1cfb>
  38067d:	cmpl   $0xdeadbeef,-0x24(%r14)
  380685:	jne    380a40 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1d50>
  38068b:	cmpl   $0xdeadbeef,-0x20(%r14)
  380693:	lea    -0x20(%r14),%rax
  380697:	jne    3808b4 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1bc4>
  38069d:	cmpl   $0xdeadbeef,-0x1c(%r14)
  3806a5:	jne    3808b0 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1bc0>
  3806ab:	cmpl   $0xdeadbeef,-0x18(%r14)
  3806b3:	jne    3809eb <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1cfb>
  3806b9:	cmpl   $0xdeadbeef,-0x14(%r14)
  3806c1:	jne    380a40 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1d50>
  3806c7:	cmpl   $0xdeadbeef,-0x10(%r14)
  3806cf:	lea    -0x10(%r14),%rax
  3806d3:	jne    3808b4 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1bc4>
  3806d9:	cmpl   $0xdeadbeef,-0xc(%r14)
  3806e1:	jne    3808b0 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1bc0>
  3806e7:	cmpl   $0xdeadbeef,-0x8(%r14)
  3806ef:	jne    3809eb <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1cfb>
  3806f5:	cmpl   $0xdeadbeef,-0x4(%r14)
  3806fd:	jne    380a40 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1d50>
  380703:	xor    %eax,%eax
  380705:	cmpq   $0x0,-0x4f8(%rbp)
  38070d:	mov    -0x4f8(%rbp),%rcx
  380714:	je     380774 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1a84>
  380716:	cs nopw 0x0(%rax,%rax,1)
  380720:	mov    0x40(%rbx,%rax,4),%edx
  380724:	cmp    $0x1,%edx
  380727:	jbe    380760 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1a70>
  380729:	mov    $0x10,%edi
  38072e:	call   1906930 <__cxa_allocate_exception@plt>
  380733:	mov    %rax,%rdi
  380736:	lea    -0x307f96(%rip),%rsi        # 787a7 <_IO_stdin_used+0x1153>
  38073d:	mov    %rax,%rbx
  380740:	call   19069d0 <std::runtime_error::runtime_error(char const*)@plt>
  380745:	mov    0x15ae3dc(%rip),%rdx        # 192eb28 <std::runtime_error::~runtime_error()@GLIBCXX_3.4>
  38074c:	lea    0x15ae48d(%rip),%rsi        # 192ebe0 <typeinfo for std::runtime_error@GLIBCXX_3.4>
  380753:	mov    %rbx,%rdi
  380756:	call   1906940 <__cxa_throw@plt>
  38075b:	nopl   0x0(%rax,%rax,1)
  380760:	mov    -0x4b8(%rbp),%rdi
  380767:	cmp    (%rdi,%rax,4),%edx
  38076a:	jne    380729 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1a39>
  38076c:	inc    %rax
  38076f:	cmp    %rax,%rcx
  380772:	jne    380720 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1a30>
  380774:	cmpq   $0x0,-0x528(%rbp)
  38077c:	movabs $0xcbf29ce484222325,%rax
  380786:	je     380aa0 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1db0>
  38078c:	mov    -0x4c8(%rbp),%rdi
  380793:	xor    %esi,%esi
  380795:	movabs $0x100000001b3,%rcx
  38079f:	nop
  3807a0:	mov    0x40(%rbx,%rsi,4),%r8d
  3807a5:	inc    %rsi
  3807a8:	movzbl %r8b,%edx
  3807ac:	xor    %rax,%rdx
  3807af:	imul   %rcx,%rdx
  3807b3:	mov    %r8d,%eax
  3807b6:	movzbl %ah,%eax
  3807b9:	mov    %eax,%eax
  3807bb:	xor    %rax,%rdx
  3807be:	imul   %rcx,%rdx
  3807c2:	mov    %r8d,%eax
  3807c5:	shr    $0x10,%eax
  3807c8:	movzbl %al,%eax
  3807cb:	xor    %rdx,%rax
  3807ce:	imul   %rcx,%rax
  3807d2:	shr    $0x18,%r8d
  3807d6:	xor    %r8,%rax
  3807d9:	imul   %rcx,%rax
  3807dd:	cmp    %rdi,%rsi
  3807e0:	jb     3807a0 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1ab0>
  3807e2:	cmp    %rax,-0x4e8(%rbp)
  3807e9:	jne    382a60 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3d70>
  3807ef:	movabs $0xcbf29ce484222325,%rax
  3807f9:	mov    -0x4c8(%rbp),%rdi
  380800:	xor    %ecx,%ecx
  380802:	movabs $0x100000001b3,%rdx
  38080c:	mov    %rax,%rsi
  38080f:	mov    %rbx,%r11
  380812:	nopw   0x0(%rax,%rax,1)
  380818:	mov    (%r15,%rcx,4),%r8d
  38081c:	inc    %rcx
  38081f:	movzbl %r8b,%eax
  380823:	xor    %rsi,%rax
  380826:	mov    %r8d,%ebx
  380829:	imul   %rdx,%rax
  38082d:	movzbl %bh,%esi
  380830:	mov    %esi,%esi
  380832:	xor    %rsi,%rax
  380835:	imul   %rdx,%rax
  380839:	mov    %r8d,%esi
  38083c:	shr    $0x10,%esi
  38083f:	movzbl %sil,%esi
  380843:	xor    %rsi,%rax
  380846:	imul   %rdx,%rax
  38084a:	shr    $0x18,%r8d
  38084e:	mov    %r8d,%esi
  380851:	xor    %rax,%rsi
  380854:	imul   %rdx,%rsi
  380858:	cmp    %rdi,%rcx
  38085b:	jb     380818 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1b28>
  38085d:	mov    %rsi,%rax
  380860:	mov    %r11,%rbx
  380863:	mov    -0x520(%rbp),%rcx
  38086a:	cmp    %rcx,%rax
  38086d:	jne    382a1e <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3d2e>
  380873:	incl   -0x4d0(%rbp)
  380879:	mov    -0x4e8(%rbp),%rax
  380880:	mov    %rax,0x15afc81(%rip)        # 1930508 <raw32_stage3::sink>
  380887:	mov    -0x4d0(%rbp),%eax
  38088d:	cmp    $0x3,%eax
  380890:	je     380940 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1c50>
  380896:	mov    -0x3e8(%rbp),%rax
  38089d:	mov    -0x3f0(%rbp),%rsi
  3808a4:	mov    %rax,-0x4d8(%rbp)
  3808ab:	jmp    380257 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1567>
  3808b0:	add    $0x4,%rax
  3808b4:	cmp    %r14,%rax
  3808b7:	je     380703 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1a13>
  3808bd:	mov    $0x10,%edi
  3808c2:	call   1906930 <__cxa_allocate_exception@plt>
  3808c7:	mov    %rax,%rdi
  3808ca:	lea    -0x30844b(%rip),%rsi        # 78486 <_IO_stdin_used+0xe32>
  3808d1:	mov    %rax,%r12
  3808d4:	call   19069d0 <std::runtime_error::runtime_error(char const*)@plt>
  3808d9:	mov    0x15ae248(%rip),%rdx        # 192eb28 <std::runtime_error::~runtime_error()@GLIBCXX_3.4>
  3808e0:	lea    0x15ae2f9(%rip),%rsi        # 192ebe0 <typeinfo for std::runtime_error@GLIBCXX_3.4>
  3808e7:	mov    %r12,%rdi
  3808ea:	call   1906940 <__cxa_throw@plt>
  3808ef:	nop
  3808f0:	mov    %rbx,%rax
  3808f3:	add    $0x4,%rax
  3808f7:	cmp    %rax,-0x4b0(%rbp)
  3808fe:	je     380613 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1923>
  380904:	mov    $0x10,%edi
  380909:	call   1906930 <__cxa_allocate_exception@plt>
  38090e:	mov    %rax,%rdi
  380911:	lea    -0x307e1d(%rip),%rsi        # 78afb <_IO_stdin_used+0x14a7>
  380918:	mov    %rax,%r12
  38091b:	call   19069d0 <std::runtime_error::runtime_error(char const*)@plt>
  380920:	mov    0x15ae201(%rip),%rdx        # 192eb28 <std::runtime_error::~runtime_error()@GLIBCXX_3.4>
  380927:	lea    0x15ae2b2(%rip),%rsi        # 192ebe0 <typeinfo for std::runtime_error@GLIBCXX_3.4>
  38092e:	mov    %r12,%rdi
  380931:	call   1906940 <__cxa_throw@plt>
  380936:	cs nopw 0x0(%rax,%rax,1)
  380940:	incl   -0x500(%rbp)
  380946:	mov    -0x4f0(%rbp),%rdi
  38094d:	mov    -0x500(%rbp),%eax
  380953:	cmp    0x58(%rdi),%eax
  380956:	jae    380b85 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1e95>
  38095c:	mov    -0x3f0(%rbp),%rax
  380963:	mov    -0x518(%rbp),%rdi
  38096a:	mov    -0x3e0(%rbp),%rdx
  380971:	cmp    %rdi,%rax
  380974:	je     380b48 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1e58>
  38097a:	mov    -0x3e8(%rbp),%r12
  380981:	lea    0x1(%r12),%r13
  380986:	cmp    %r13,%rdx
  380989:	jb     3820d5 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x33e5>
  38098f:	movb   $0x7c,(%rax,%r12,1)
  380994:	mov    %r13,-0x3e8(%rbp)
  38099b:	mov    -0x3f0(%rbp),%rax
  3809a2:	movb   $0x0,0x1(%rax,%r12,1)
  3809a8:	mov    -0x3e8(%rbp),%rax
  3809af:	mov    -0x3f0(%rbp),%rsi
  3809b6:	mov    %rax,-0x4d8(%rbp)
  3809bd:	jmp    38024d <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x155d>
  3809c2:	mov    -0x4d8(%rbp),%rsi
  3809c9:	mov    -0x5d0(%rbp),%rdi
  3809d0:	mov    $0x1,%r8d
  3809d6:	xor    %ecx,%ecx
  3809d8:	xor    %edx,%edx
  3809da:	call   1906ad0 <std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::_M_mutate(unsigned long, unsigned long, char const*, unsigned long)@plt>
  3809df:	mov    -0x3f0(%rbp),%rsi
  3809e6:	jmp    3802e0 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x15f0>
  3809eb:	add    $0x8,%rax
  3809ef:	cmp    %r14,%rax
  3809f2:	je     380703 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1a13>
  3809f8:	jmp    3808bd <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1bcd>
  3809fd:	nopl   (%rax)
  380a00:	mov    %rbx,%rax
  380a03:	add    $0x8,%rax
  380a07:	cmp    %rax,-0x4b0(%rbp)
  380a0e:	je     380613 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1923>
  380a14:	jmp    380904 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1c14>
  380a19:	nopl   0x0(%rax)
  380a20:	mov    %rbx,%rax
  380a23:	add    $0xc,%rax
  380a27:	cmp    %rax,-0x4b0(%rbp)
  380a2e:	je     380613 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1923>
  380a34:	jmp    380904 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1c14>
  380a39:	nopl   0x0(%rax)
  380a40:	add    $0xc,%rax
  380a44:	cmp    %r14,%rax
  380a47:	je     380703 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1a13>
  380a4d:	jmp    3808bd <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1bcd>
  380a52:	nopw   0x0(%rax,%rax,1)
  380a58:	mov    $0xf,%eax
  380a5d:	jmp    3802d7 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x15e7>
  380a62:	mov    -0x5b8(%rbp),%rcx
  380a69:	mov    -0x4e0(%rbp),%rdx
  380a70:	lea    (%rcx,%rax,1),%rdi
  380a74:	call   37c550 <void std::vector<double, std::allocator<double> >::_M_realloc_insert<double>(__gnu_cxx::__normal_iterator<double*, std::vector<double, std::allocator<double> > >, double&&)>
  380a79:	cmpl   $0xdeadbeef,(%rbx)
  380a7f:	je     380544 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1854>
  380a85:	mov    %rbx,%rax
  380a88:	cmp    %rax,-0x4b0(%rbp)
  380a8f:	je     380613 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1923>
  380a95:	jmp    380904 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1c14>
  380a9a:	nopw   0x0(%rax,%rax,1)
  380aa0:	cmp    %rax,-0x4e8(%rbp)
  380aa7:	jne    382a60 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3d70>
  380aad:	mov    -0x4e8(%rbp),%rax
  380ab4:	jmp    380863 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1b73>
  380ab9:	xor    %esi,%esi
  380abb:	jmp    380444 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1754>
  380ac0:	xor    %esi,%esi
  380ac2:	jmp    380384 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1694>
  380ac7:	addq   $0xc,-0x4d0(%rbp)
  380acf:	cmp    %r13,-0x4d0(%rbp)
  380ad6:	je     37fefc <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x120c>
  380adc:	jmp    37ffbd <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x12cd>
  380ae1:	nopl   0x0(%rax)
  380ae8:	addq   $0x8,-0x4d0(%rbp)
  380af0:	cmp    %r13,-0x4d0(%rbp)
  380af7:	je     37fefc <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x120c>
  380afd:	jmp    37ffbd <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x12cd>
  380b02:	nopw   0x0(%rax,%rax,1)
  380b08:	mov    %r12,%rax
  380b0b:	mov    -0x508(%rbp),%rcx
  380b12:	add    $0x8,%rax
  380b16:	cmp    %rcx,%rax
  380b19:	je     37fdf9 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1109>
  380b1f:	jmp    380007 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1317>
  380b24:	nopl   0x0(%rax)
  380b28:	mov    %r12,%rax
  380b2b:	mov    -0x508(%rbp),%rcx
  380b32:	add    $0xc,%rax
  380b36:	cmp    %rcx,%rax
  380b39:	je     37fdf9 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1109>
  380b3f:	jmp    380007 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1317>
  380b44:	nopl   0x0(%rax)
  380b48:	mov    $0xf,%edx
  380b4d:	jmp    38097a <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1c8a>
  380b52:	mov    -0x518(%rbp),%rsi
  380b59:	mov    %r12,%rdi
  380b5c:	call   1906920 <operator delete(void*, unsigned long)@plt>
  380b61:	movq   $0x1,-0x500(%rbp)
  380b6c:	jmp    37ff95 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x12a5>
  380b71:	mov    %rsi,%r10
  380b74:	xor    %edx,%edx
  380b76:	jmp    37f5a7 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x8b7>
  380b7b:	mov    %rcx,%r8
  380b7e:	xor    %edx,%edx
  380b80:	jmp    37fc75 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0xf85>
  380b85:	mov    -0x4f0(%rbp),%rdi
  380b8c:	lea    -0x307a8c(%rip),%rsi        # 79107 <_IO_stdin_used+0x1ab3>
  380b93:	call   1906aa0 <std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::compare(char const*) const@plt>
  380b98:	test   %eax,%eax
  380b9a:	je     382155 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3465>
  380ba0:	mov    -0x4c0(%rbp),%rax
  380ba7:	mov    $0x2,%esi
  380bac:	mov    (%rax),%rdi
  380baf:	call   *0x20(%rax)
  380bb2:	cmpq   $0x0,-0x630(%rbp)
  380bba:	je     38274c <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3a5c>
  380bc0:	mov    -0x600(%rbp),%rax
  380bc7:	movq   $0x0,-0x4f8(%rbp)
  380bd2:	mov    %rax,-0x4d0(%rbp)
  380bd9:	mov    -0x5f0(%rbp),%rax
  380be0:	movq   $0x0,-0x500(%rbp)
  380beb:	mov    %rax,-0x510(%rbp)
  380bf2:	cmpq   $0xfff,-0x510(%rbp)
  380bfd:	movq   $0x4080,-0x4d8(%rbp)
  380c08:	movq   $0x1000,-0x4b0(%rbp)
  380c13:	ja     380c32 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1f42>
  380c15:	mov    -0x510(%rbp),%rax
  380c1c:	lea    0x80(,%rax,4),%rcx
  380c24:	mov    %rcx,-0x4d8(%rbp)
  380c2b:	mov    %rax,-0x4b0(%rbp)
  380c32:	mov    -0x4d8(%rbp),%r12
  380c39:	mov    %r12,%rdi
  380c3c:	call   1906a00 <operator new(unsigned long)@plt>
  380c41:	mov    %rax,%r14
  380c44:	mov    %r12,%rax
  380c47:	lea    -0x4(%rax),%rcx
  380c4b:	shr    $0x2,%rcx
  380c4f:	lea    0x1(%rcx),%rsi
  380c53:	mov    %rsi,%rdx
  380c56:	shr    $0x3,%rdx
  380c5a:	shl    $0x5,%rdx
  380c5e:	mov    $0xdeadbeef,%edi
  380c63:	lea    (%r14,%r12,1),%r12
  380c67:	mov    %r14,%rax
  380c6a:	add    %r14,%rdx
  380c6d:	vpbroadcastd %edi,%ymm0
  380c73:	vmovdqu %ymm0,(%rax)
  380c77:	add    $0x20,%rax
  380c7b:	cmp    %rax,%rdx
  380c7e:	jne    380c73 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1f83>
  380c80:	mov    %rsi,%r8
  380c83:	and    $0xfffffffffffffff8,%r8
  380c87:	lea    (%r14,%r8,4),%rax
  380c8b:	test   $0x7,%sil
  380c8f:	je     380ce3 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1ff3>
  380c91:	mov    %rcx,%r9
  380c94:	sub    %r8,%r9
  380c97:	lea    0x1(%r9),%rdx
  380c9b:	cmp    $0x2,%r9
  380c9f:	jbe    380cbd <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1fcd>
  380ca1:	vpbroadcastd %edi,%xmm0
  380ca7:	mov    %rdx,%rdi
  380caa:	and    $0xfffffffffffffffc,%rdi
  380cae:	and    $0x3,%edx
  380cb1:	vmovdqu %xmm0,(%r14,%r8,4)
  380cb7:	lea    (%rax,%rdi,4),%rax
  380cbb:	je     380ce3 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1ff3>
  380cbd:	lea    0x4(%rax),%rdx
  380cc1:	movl   $0xdeadbeef,(%rax)
  380cc7:	cmp    %rdx,%r12
  380cca:	je     380ce3 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1ff3>
  380ccc:	lea    0x8(%rax),%rdx
  380cd0:	movl   $0xdeadbeef,0x4(%rax)
  380cd7:	cmp    %rdx,%r12
  380cda:	je     380ce3 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1ff3>
  380cdc:	movl   $0xdeadbeef,0x8(%rax)
  380ce3:	mov    %rsi,%rdx
  380ce6:	shr    $0x3,%rdx
  380cea:	shl    $0x5,%rdx
  380cee:	mov    $0xdeadbeef,%edi
  380cf3:	mov    %r14,%rax
  380cf6:	add    %r14,%rdx
  380cf9:	vpbroadcastd %edi,%ymm0
  380cff:	nop
  380d00:	vmovdqu %ymm0,(%rax)
  380d04:	add    $0x20,%rax
  380d08:	cmp    %rax,%rdx
  380d0b:	jne    380d00 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x2010>
  380d0d:	mov    %rsi,%rdx
  380d10:	and    $0xfffffffffffffff8,%rdx
  380d14:	and    $0x7,%esi
  380d17:	lea    (%r14,%rdx,4),%rax
  380d1b:	je     380d6c <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x207c>
  380d1d:	sub    %rdx,%rcx
  380d20:	lea    0x1(%rcx),%rsi
  380d24:	cmp    $0x2,%rcx
  380d28:	jbe    380d46 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x2056>
  380d2a:	vpbroadcastd %edi,%xmm0
  380d30:	vmovdqu %xmm0,(%r14,%rdx,4)
  380d36:	mov    %rsi,%rdx
  380d39:	and    $0xfffffffffffffffc,%rdx
  380d3d:	and    $0x3,%esi
  380d40:	lea    (%rax,%rdx,4),%rax
  380d44:	je     380d6c <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x207c>
  380d46:	lea    0x4(%rax),%rdx
  380d4a:	movl   $0xdeadbeef,(%rax)
  380d50:	cmp    %rdx,%r12
  380d53:	je     380d6c <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x207c>
  380d55:	lea    0x8(%rax),%rdx
  380d59:	movl   $0xdeadbeef,0x4(%rax)
  380d60:	cmp    %rdx,%r12
  380d63:	je     380d6c <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x207c>
  380d65:	movl   $0xdeadbeef,0x8(%rax)
  380d6c:	mov    -0x4b0(%rbp),%rax
  380d73:	lea    0x40(%r14),%r13
  380d77:	shl    $0x2,%rax
  380d7b:	lea    0x40(%r14,%rax,1),%rdi
  380d80:	mov    %rax,-0x508(%rbp)
  380d87:	cmp    %rdi,%r13
  380d8a:	je     380e3d <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x214d>
  380d90:	sub    $0x4,%rax
  380d94:	mov    %rax,%rsi
  380d97:	shr    $0x2,%rsi
  380d9b:	lea    0x1(%rsi),%r8
  380d9f:	cmp    $0x18,%rax
  380da3:	jbe    3823dc <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x36ec>
  380da9:	mov    %r8,%rdx
  380dac:	shr    $0x3,%rdx
  380db0:	shl    $0x5,%rdx
  380db4:	mov    $0xfeedface,%ecx
  380db9:	mov    %r14,%rax
  380dbc:	add    %r14,%rdx
  380dbf:	vpbroadcastd %ecx,%ymm0
  380dc5:	nopl   (%rax)
  380dc8:	vmovdqu %ymm0,0x40(%rax)
  380dcd:	add    $0x20,%rax
  380dd1:	cmp    %rax,%rdx
  380dd4:	jne    380dc8 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x20d8>
  380dd6:	mov    %r8,%r9
  380dd9:	and    $0xfffffffffffffff8,%r9
  380ddd:	and    $0x7,%r8d
  380de1:	lea    0x0(%r13,%r9,4),%rax
  380de6:	je     380e3d <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x214d>
  380de8:	sub    %r9,%rsi
  380deb:	lea    0x1(%rsi),%rcx
  380def:	cmp    $0x2,%rsi
  380df3:	jbe    380e17 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x2127>
  380df5:	mov    $0xfeedface,%edx
  380dfa:	vpbroadcastd %edx,%xmm0
  380e00:	mov    %rcx,%rdx
  380e03:	and    $0xfffffffffffffffc,%rdx
  380e07:	and    $0x3,%ecx
  380e0a:	vmovdqu %xmm0,0x40(%r14,%r9,4)
  380e11:	lea    (%rax,%rdx,4),%rax
  380e15:	je     380e3d <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x214d>
  380e17:	lea    0x4(%rax),%rdx
  380e1b:	movl   $0xfeedface,(%rax)
  380e21:	cmp    %rdx,%rdi
  380e24:	je     380e3d <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x214d>
  380e26:	lea    0x8(%rax),%rdx
  380e2a:	movl   $0xfeedface,0x4(%rax)
  380e31:	cmp    %rdx,%rdi
  380e34:	je     380e3d <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x214d>
  380e36:	movl   $0xfeedface,0x8(%rax)
  380e3d:	mov    -0x4c0(%rbp),%rax
  380e44:	mov    -0x4d0(%rbp),%rdx
  380e4b:	mov    (%rax),%rdi
  380e4e:	mov    -0x4b0(%rbp),%esi
  380e54:	mov    %r13,%rcx
  380e57:	vzeroupper
  380e5a:	call   *0x30(%rax)
  380e5d:	cmpl   $0xdeadbeef,(%r14)
  380e64:	jne    38275c <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3a6c>
  380e6a:	cmpl   $0xdeadbeef,0x4(%r14)
  380e72:	jne    3822ac <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x35bc>
  380e78:	cmpl   $0xdeadbeef,0x8(%r14)
  380e80:	jne    382305 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3615>
  380e86:	cmpl   $0xdeadbeef,0xc(%r14)
  380e8e:	jne    3821c8 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x34d8>
  380e94:	cmpl   $0xdeadbeef,0x10(%r14)
  380e9c:	lea    0x10(%r14),%rax
  380ea0:	jne    3821cf <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x34df>
  380ea6:	cmpl   $0xdeadbeef,0x14(%r14)
  380eae:	jne    3822af <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x35bf>
  380eb4:	cmpl   $0xdeadbeef,0x18(%r14)
  380ebc:	jne    382308 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3618>
  380ec2:	cmpl   $0xdeadbeef,0x1c(%r14)
  380eca:	jne    3821cb <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x34db>
  380ed0:	cmpl   $0xdeadbeef,0x20(%r14)
  380ed8:	lea    0x20(%r14),%rax
  380edc:	jne    3821cf <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x34df>
  380ee2:	cmpl   $0xdeadbeef,0x24(%r14)
  380eea:	jne    3822af <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x35bf>
  380ef0:	cmpl   $0xdeadbeef,0x28(%r14)
  380ef8:	jne    382308 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3618>
  380efe:	cmpl   $0xdeadbeef,0x2c(%r14)
  380f06:	jne    3821cb <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x34db>
  380f0c:	cmpl   $0xdeadbeef,0x30(%r14)
  380f14:	lea    0x30(%r14),%rax
  380f18:	jne    3821cf <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x34df>
  380f1e:	cmpl   $0xdeadbeef,0x34(%r14)
  380f26:	jne    3822af <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x35bf>
  380f2c:	cmpl   $0xdeadbeef,0x38(%r14)
  380f34:	jne    382308 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3618>
  380f3a:	cmpl   $0xdeadbeef,0x3c(%r14)
  380f42:	mov    $0x1,%edi
  380f47:	jne    3821cb <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x34db>
  380f4d:	lea    -0x308459(%rip),%rsi        # 78afb <_IO_stdin_used+0x14a7>
  380f54:	call   378740 <raw32_stage3::Need(bool, char const*)>
  380f59:	cmpl   $0xdeadbeef,-0x40(%r12)
  380f62:	lea    -0x40(%r12),%rax
  380f67:	jne    3822f7 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3607>
  380f6d:	cmpl   $0xdeadbeef,-0x3c(%r12)
  380f76:	jne    3822e5 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x35f5>
  380f7c:	cmpl   $0xdeadbeef,-0x38(%r12)
  380f85:	jne    3822d3 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x35e3>
  380f8b:	cmpl   $0xdeadbeef,-0x34(%r12)
  380f94:	jne    3822c1 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x35d1>
  380f9a:	cmpl   $0xdeadbeef,-0x30(%r12)
  380fa3:	lea    -0x30(%r12),%rax
  380fa8:	jne    3822f7 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3607>
  380fae:	cmpl   $0xdeadbeef,-0x2c(%r12)
  380fb7:	jne    3822e5 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x35f5>
  380fbd:	cmpl   $0xdeadbeef,-0x28(%r12)
  380fc6:	jne    3822d3 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x35e3>
  380fcc:	cmpl   $0xdeadbeef,-0x24(%r12)
  380fd5:	jne    3822c1 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x35d1>
  380fdb:	cmpl   $0xdeadbeef,-0x20(%r12)
  380fe4:	lea    -0x20(%r12),%rax
  380fe9:	jne    3822f7 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3607>
  380fef:	cmpl   $0xdeadbeef,-0x1c(%r12)
  380ff8:	jne    3822e5 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x35f5>
  380ffe:	cmpl   $0xdeadbeef,-0x18(%r12)
  381007:	jne    3822d3 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x35e3>
  38100d:	cmpl   $0xdeadbeef,-0x14(%r12)
  381016:	jne    3822c1 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x35d1>
  38101c:	cmpl   $0xdeadbeef,-0x10(%r12)
  381025:	lea    -0x10(%r12),%rax
  38102a:	jne    3822f7 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3607>
  381030:	cmpl   $0xdeadbeef,-0xc(%r12)
  381039:	jne    3822e5 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x35f5>
  38103f:	cmpl   $0xdeadbeef,-0x8(%r12)
  381048:	jne    3822d3 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x35e3>
  38104e:	cmpl   $0xdeadbeef,-0x4(%r12)
  381057:	mov    $0x1,%edi
  38105c:	jne    3822c1 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x35d1>
  381062:	lea    -0x308be3(%rip),%rsi        # 78486 <_IO_stdin_used+0xe32>
  381069:	call   378740 <raw32_stage3::Need(bool, char const*)>
  38106e:	mov    -0x508(%rbp),%rax
  381075:	mov    -0x500(%rbp),%rcx
  38107c:	lea    0x40(%r14,%rax,1),%rdx
  381081:	nopl   0x0(%rax)
  381088:	mov    0x0(%r13),%eax
  38108c:	cmp    $0x1,%eax
  38108f:	ja     382dbe <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x40ce>
  381095:	add    $0x4,%r13
  381099:	add    %rax,%rcx
  38109c:	cmp    %rdx,%r13
  38109f:	jne    381088 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x2398>
  3810a1:	mov    -0x4f0(%rbp),%rdi
  3810a8:	lea    -0x3081eb(%rip),%rsi        # 78ec4 <_IO_stdin_used+0x1870>
  3810af:	mov    %rcx,-0x500(%rbp)
  3810b6:	call   1906aa0 <std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::compare(char const*) const@plt>
  3810bb:	test   %eax,%eax
  3810bd:	jne    382202 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3512>
  3810c3:	mov    -0x4d8(%rbp),%rsi
  3810ca:	mov    %r14,%rdi
  3810cd:	call   1906920 <operator delete(void*, unsigned long)@plt>
  3810d2:	addq   $0x1000,-0x4f8(%rbp)
  3810dd:	mov    -0x5f0(%rbp),%rcx
  3810e4:	subq   $0x1000,-0x510(%rbp)
  3810ef:	addq   $0x4000,-0x4d0(%rbp)
  3810fa:	mov    -0x4f8(%rbp),%rax
  381101:	cmp    %rcx,%rax
  381104:	jb     380bf2 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1f02>
  38110a:	mov    -0x600(%rbp),%rdi
  381111:	mov    -0x638(%rbp),%rcx
  381118:	movabs $0xcbf29ce484222325,%rax
  381122:	cmp    %rcx,%rdi
  381125:	je     38117e <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x248e>
  381127:	mov    -0x5f0(%rbp),%r8
  38112e:	xor    %esi,%esi
  381130:	movabs $0x100000001b3,%rcx
  38113a:	mov    (%rdi,%rsi,4),%r9d
  38113e:	inc    %rsi
  381141:	movzbl %r9b,%edx
  381145:	xor    %rax,%rdx
  381148:	imul   %rcx,%rdx
  38114c:	mov    %r9d,%eax
  38114f:	movzbl %ah,%eax
  381152:	mov    %eax,%eax
  381154:	xor    %rax,%rdx
  381157:	imul   %rcx,%rdx
  38115b:	mov    %r9d,%eax
  38115e:	shr    $0x10,%eax
  381161:	movzbl %al,%eax
  381164:	xor    %rdx,%rax
  381167:	imul   %rcx,%rax
  38116b:	shr    $0x18,%r9d
  38116f:	mov    %r9d,%edx
  381172:	xor    %rdx,%rax
  381175:	imul   %rcx,%rax
  381179:	cmp    %r8,%rsi
  38117c:	jb     38113a <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x244a>
  38117e:	mov    -0x5f8(%rbp),%rdi
  381185:	lea    -0x308944(%rip),%rsi        # 78848 <_IO_stdin_used+0x11f4>
  38118c:	cmp    %rdi,%rax
  38118f:	sete   %dil
  381193:	movzbl %dil,%edi
  381197:	call   378740 <raw32_stage3::Need(bool, char const*)>
  38119c:	cmpq   $0x0,-0x528(%rbp)
  3811a4:	movabs $0xcbf29ce484222325,%rax
  3811ae:	je     381207 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x2517>
  3811b0:	mov    -0x4c8(%rbp),%rdi
  3811b7:	xor    %esi,%esi
  3811b9:	movabs $0x100000001b3,%rcx
  3811c3:	mov    (%r15,%rsi,4),%r8d
  3811c7:	inc    %rsi
  3811ca:	movzbl %r8b,%edx
  3811ce:	xor    %rax,%rdx
  3811d1:	imul   %rcx,%rdx
  3811d5:	mov    %r8d,%eax
  3811d8:	movzbl %ah,%eax
  3811db:	mov    %eax,%eax
  3811dd:	xor    %rax,%rdx
  3811e0:	imul   %rcx,%rdx
  3811e4:	mov    %r8d,%eax
  3811e7:	shr    $0x10,%eax
  3811ea:	movzbl %al,%eax
  3811ed:	xor    %rdx,%rax
  3811f0:	imul   %rcx,%rax
  3811f4:	shr    $0x18,%r8d
  3811f8:	mov    %r8d,%edx
  3811fb:	xor    %rdx,%rax
  3811fe:	imul   %rcx,%rax
  381202:	cmp    %rdi,%rsi
  381205:	jb     3811c3 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x24d3>
  381207:	cmp    %rax,-0x520(%rbp)
  38120e:	sete   %dil
  381212:	lea    -0x3092e9(%rip),%rsi        # 77f30 <_IO_stdin_used+0x8dc>
  381219:	movzbl %dil,%edi
  38121d:	call   378740 <raw32_stage3::Need(bool, char const*)>
  381222:	mov    -0x5e0(%rbp),%rdi
  381229:	mov    -0x628(%rbp),%rcx
  381230:	movabs $0xcbf29ce484222325,%rax
  38123a:	cmp    %rcx,%rdi
  38123d:	je     381296 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x25a6>
  38123f:	mov    -0x550(%rbp),%r8
  381246:	xor    %esi,%esi
  381248:	movabs $0x100000001b3,%rcx
  381252:	mov    (%rdi,%rsi,4),%r9d
  381256:	inc    %rsi
  381259:	movzbl %r9b,%edx
  38125d:	xor    %rax,%rdx
  381260:	imul   %rcx,%rdx
  381264:	mov    %r9d,%eax
  381267:	movzbl %ah,%eax
  38126a:	mov    %eax,%eax
  38126c:	xor    %rax,%rdx
  38126f:	imul   %rcx,%rdx
  381273:	mov    %r9d,%eax
  381276:	shr    $0x10,%eax
  381279:	movzbl %al,%eax
  38127c:	xor    %rdx,%rax
  38127f:	imul   %rcx,%rax
  381283:	shr    $0x18,%r9d
  381287:	mov    %r9d,%edx
  38128a:	xor    %rdx,%rax
  38128d:	imul   %rcx,%rax
  381291:	cmp    %r8,%rsi
  381294:	jb     381252 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x2562>
  381296:	mov    -0x5e8(%rbp),%rdi
  38129d:	lea    -0x309894(%rip),%rsi        # 77a10 <_IO_stdin_used+0x3bc>
  3812a4:	cmp    %rdi,%rax
  3812a7:	sete   %dil
  3812ab:	movzbl %dil,%edi
  3812af:	call   378740 <raw32_stage3::Need(bool, char const*)>
  3812b4:	xor    %r12d,%r12d
  3812b7:	mov    -0x4c0(%rbp),%r14
  3812be:	mov    %r12d,%esi
  3812c1:	mov    (%r14),%rdi
  3812c4:	call   *0x20(%r14)
  3812c8:	mov    (%r14),%rdi
  3812cb:	call   *0x40(%r14)
  3812cf:	lea    -0x450(%rbp),%rcx
  3812d6:	mov    %rax,(%rcx,%r12,8)
  3812da:	inc    %r12
  3812dd:	mov    %rcx,-0x540(%rbp)
  3812e4:	cmp    $0x3,%r12
  3812e8:	jne    3812b7 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x25c7>
  3812ea:	mov    -0x530(%rbp),%r14
  3812f1:	mov    -0x4c8(%rbp),%rdx
  3812f8:	lea    -0x308e39(%rip),%rsi        # 784c6 <_IO_stdin_used+0xe72>
  3812ff:	mov    %r14,%rdi
  381302:	call   37e5a0 <void raw32_stage3::Add<unsigned long>(std::vector<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >, std::allocator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > > >&, char const*, unsigned long)>
  381307:	mov    -0x4f0(%rbp),%r12
  38130e:	lea    -0x308841(%rip),%rsi        # 78ad4 <_IO_stdin_used+0x1480>
  381315:	mov    0x50(%r12),%edx
  38131a:	mov    %r14,%rdi
  38131d:	call   37e3e0 <void raw32_stage3::Add<unsigned int>(std::vector<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >, std::allocator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > > >&, char const*, unsigned int)>
  381322:	mov    0x4c(%r12),%edx
  381327:	lea    -0x3084a4(%rip),%rsi        # 78e8a <_IO_stdin_used+0x1836>
  38132e:	mov    %r14,%rdi
  381331:	call   37e3e0 <void raw32_stage3::Add<unsigned int>(std::vector<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >, std::allocator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > > >&, char const*, unsigned int)>
  381336:	mov    -0x2b8(%rbp),%rdx
  38133d:	lea    -0x308b88(%rip),%rsi        # 787bc <_IO_stdin_used+0x1168>
  381344:	mov    %r14,%rdi
  381347:	call   37e5a0 <void raw32_stage3::Add<unsigned long>(std::vector<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >, std::allocator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > > >&, char const*, unsigned long)>
  38134c:	mov    -0x2c0(%rbp),%rdx
  381353:	lea    -0x3089ec(%rip),%rsi        # 7896e <_IO_stdin_used+0x131a>
  38135a:	mov    %r14,%rdi
  38135d:	call   37e5a0 <void raw32_stage3::Add<unsigned long>(std::vector<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >, std::allocator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > > >&, char const*, unsigned long)>
  381362:	mov    -0x5f0(%rbp),%rdx
  381369:	lea    -0x3083df(%rip),%rsi        # 78f91 <_IO_stdin_used+0x193d>
  381370:	mov    %r14,%rdi
  381373:	call   37e5a0 <void raw32_stage3::Add<unsigned long>(std::vector<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >, std::allocator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > > >&, char const*, unsigned long)>
  381378:	mov    -0x500(%rbp),%rdx
  38137f:	lea    -0x3083da(%rip),%rsi        # 78fac <_IO_stdin_used+0x1958>
  381386:	mov    %r14,%rdi
  381389:	call   37e5a0 <void raw32_stage3::Add<unsigned long>(std::vector<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >, std::allocator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > > >&, char const*, unsigned long)>
  38138e:	mov    -0x5c8(%rbp),%rdx
  381395:	lea    -0x308b6e(%rip),%rsi        # 7882e <_IO_stdin_used+0x11da>
  38139c:	mov    %r14,%rdi
  38139f:	call   37e5a0 <void raw32_stage3::Add<unsigned long>(std::vector<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >, std::allocator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > > >&, char const*, unsigned long)>
  3813a4:	mov    -0x4e8(%rbp),%rdx
  3813ab:	lea    -0x308a35(%rip),%rsi        # 7897d <_IO_stdin_used+0x1329>
  3813b2:	mov    %r14,%rdi
  3813b5:	call   37e5a0 <void raw32_stage3::Add<unsigned long>(std::vector<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >, std::allocator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > > >&, char const*, unsigned long)>
  3813ba:	mov    -0x5e8(%rbp),%rdx
  3813c1:	lea    -0x3089ea(%rip),%rsi        # 789de <_IO_stdin_used+0x138a>
  3813c8:	mov    %r14,%rdi
  3813cb:	call   37e5a0 <void raw32_stage3::Add<unsigned long>(std::vector<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >, std::allocator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > > >&, char const*, unsigned long)>
  3813d0:	mov    -0x520(%rbp),%rdx
  3813d7:	lea    -0x30872b(%rip),%rsi        # 78cb3 <_IO_stdin_used+0x165f>
  3813de:	mov    %r14,%rdi
  3813e1:	call   37e5a0 <void raw32_stage3::Add<unsigned long>(std::vector<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >, std::allocator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > > >&, char const*, unsigned long)>
  3813e6:	mov    -0x5f8(%rbp),%rdx
  3813ed:	lea    -0x308d76(%rip),%rsi        # 7867e <_IO_stdin_used+0x102a>
  3813f4:	mov    %r14,%rdi
  3813f7:	call   37e5a0 <void raw32_stage3::Add<unsigned long>(std::vector<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >, std::allocator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > > >&, char const*, unsigned long)>
  3813fc:	mov    0x58(%r12),%edx
  381401:	lea    -0x308b34(%rip),%rsi        # 788d4 <_IO_stdin_used+0x1280>
  381408:	mov    %r14,%rdi
  38140b:	call   37e3e0 <void raw32_stage3::Add<unsigned int>(std::vector<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >, std::allocator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > > >&, char const*, unsigned int)>
  381410:	mov    -0x3e8(%rbp),%rax
  381417:	test   %rax,%rax
  38141a:	jne    3823ef <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x36ff>
  381420:	mov    -0x4e0(%rbp),%rdi
  381427:	lea    -0x30886c(%rip),%rsi        # 78bc2 <_IO_stdin_used+0x156e>
  38142e:	call   370f30 <std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::basic_string<std::allocator<char> >(char const*, std::allocator<char> const&) [clone .constprop.0]>
  381433:	lea    -0x308b5e(%rip),%rax        # 788dc <_IO_stdin_used+0x1288>
  38143a:	mov    %rax,-0x390(%rbp)
  381441:	mov    -0x4e0(%rbp),%rdx
  381448:	mov    -0x588(%rbp),%rsi
  38144f:	mov    -0x530(%rbp),%rdi
  381456:	call   3712f0 <std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >& std::vector<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >, std::allocator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > > >::emplace_back<char const*&, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&>(char const*&, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&) [clone .isra.0]>
  38145b:	mov    -0x1b0(%rbp),%rdi
  381462:	mov    -0x538(%rbp),%rax
  381469:	cmp    %rax,%rdi
  38146c:	je     38147e <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x278e>
  38146e:	mov    -0x1a0(%rbp),%rax
  381475:	lea    0x1(%rax),%rsi
  381479:	call   1906920 <operator delete(void*, unsigned long)@plt>
  38147e:	lea    -0x3083b8(%rip),%rcx        # 790cd <_IO_stdin_used+0x1a79>
  381485:	lea    -0x308c69(%rip),%rax        # 78823 <_IO_stdin_used+0x11cf>
  38148c:	vmovq  %rcx,%xmm0
  381491:	vpinsrq $0x1,%rax,%xmm0,%xmm0
  381497:	lea    -0x3085d0(%rip),%rax        # 78ece <_IO_stdin_used+0x187a>
  38149e:	mov    %rax,-0x420(%rbp)
  3814a5:	mov    -0x5b8(%rbp),%rax
  3814ac:	movq   $0x0,-0x4f8(%rbp)
  3814b7:	mov    %rax,-0x520(%rbp)
  3814be:	vmovdqa %xmm0,-0x430(%rbp)
  3814c6:	mov    -0x4f8(%rbp),%rdi
  3814cd:	mov    -0x618(%rbp),%rax
  3814d4:	mov    (%rax,%rdi,1),%rsi
  3814d8:	mov    -0x620(%rbp),%rdi
  3814df:	call   370f30 <std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::basic_string<std::allocator<char> >(char const*, std::allocator<char> const&) [clone .constprop.0]>
  3814e4:	mov    -0x520(%rbp),%rdi
  3814eb:	mov    0x8(%rdi),%rax
  3814ef:	mov    (%rdi),%rcx
  3814f2:	mov    %rax,-0x4d8(%rbp)
  3814f9:	sub    %rcx,%rax
  3814fc:	mov    %rcx,-0x508(%rbp)
  381503:	mov    %rax,%r13
  381506:	je     3823b3 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x36c3>
  38150c:	movabs $0x7ffffffffffffff8,%rax
  381516:	cmp    %r13,%rax
  381519:	jb     382469 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3779>
  38151f:	mov    %r13,%rdi
  381522:	call   1906a00 <operator new(unsigned long)@plt>
  381527:	mov    %rax,%r12
  38152a:	mov    -0x508(%rbp),%rax
  381531:	cmp    %rax,-0x4d8(%rbp)
  381538:	je     381548 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x2858>
  38153a:	mov    %r13,%rdx
  38153d:	mov    %rax,%rsi
  381540:	mov    %r12,%rdi
  381543:	call   1906970 <memmove@plt>
  381548:	lea    (%r12,%r13,1),%r14
  38154c:	cmp    %r12,%r14
  38154f:	je     38245c <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x376c>
  381555:	mov    %r13,%rax
  381558:	sar    $0x3,%rax
  38155c:	mov    $0x3f,%edx
  381561:	mov    %rax,-0x4b0(%rbp)
  381568:	lzcnt  %rax,%rax
  38156d:	sub    %eax,%edx
  38156f:	movslq %edx,%rdx
  381572:	add    %rdx,%rdx
  381575:	mov    %r14,%rsi
  381578:	mov    %r12,%rdi
  38157b:	call   3723e0 <void std::__introsort_loop<__gnu_cxx::__normal_iterator<double*, std::vector<double, std::allocator<double> > >, long, __gnu_cxx::__ops::_Iter_less_iter>(__gnu_cxx::__normal_iterator<double*, std::vector<double, std::allocator<double> > >, __gnu_cxx::__normal_iterator<double*, std::vector<double, std::allocator<double> > >, long, __gnu_cxx::__ops::_Iter_less_iter) [clone .isra.0]>
  381580:	cmp    $0x80,%r13
  381587:	jle    382444 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3754>
  38158d:	lea    0x80(%r12),%rcx
  381595:	mov    %rcx,%rsi
  381598:	mov    %r12,%rdi
  38159b:	mov    %rcx,-0x4c8(%rbp)
  3815a2:	call   372310 <void std::__insertion_sort<__gnu_cxx::__normal_iterator<double*, std::vector<double, std::allocator<double> > >, __gnu_cxx::__ops::_Iter_less_iter>(__gnu_cxx::__normal_iterator<double*, std::vector<double, std::allocator<double> > >, __gnu_cxx::__normal_iterator<double*, std::vector<double, std::allocator<double> > >, __gnu_cxx::__ops::_Iter_less_iter) [clone .isra.0]>
  3815a7:	mov    -0x4c8(%rbp),%rcx
  3815ae:	cmp    %rcx,%r14
  3815b1:	je     3815f4 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x2904>
  3815b3:	vmovsd (%rcx),%xmm1
  3815b7:	vmovsd -0x8(%rcx),%xmm0
  3815bc:	lea    -0x8(%rcx),%rax
  3815c0:	vcomisd %xmm1,%xmm0
  3815c4:	jbe    382454 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3764>
  3815ca:	nopw   0x0(%rax,%rax,1)
  3815d0:	vmovsd %xmm0,0x8(%rax)
  3815d5:	mov    %rax,%rdx
  3815d8:	vmovsd -0x8(%rax),%xmm0
  3815dd:	sub    $0x8,%rax
  3815e1:	vcomisd %xmm1,%xmm0
  3815e5:	ja     3815d0 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x28e0>
  3815e7:	add    $0x8,%rcx
  3815eb:	vmovsd %xmm1,(%rdx)
  3815ef:	cmp    %rcx,%r14
  3815f2:	jne    3815b3 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x28c3>
  3815f4:	mov    -0x4b0(%rbp),%rdi
  3815fb:	mov    %rdi,%rax
  3815fe:	shr    %rax
  381601:	and    $0x1,%edi
  381604:	vmovsd (%r12,%rax,8),%xmm0
  38160a:	jne    38161b <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x292b>
  38160c:	vaddsd -0x8(%r12,%rax,8),%xmm0,%xmm0
  381613:	vmulsd -0x306273(%rip),%xmm0,%xmm0        # 7b3a8 <bloom_filters::FastPatternBF::sparse_patterns_+0x1f48>
  38161b:	mov    -0x4e0(%rbp),%rdi
  381622:	call   37a450 <raw32_stage3::Number[abi:cxx11](double)>
  381627:	lea    -0x380(%rbp),%rax
  38162e:	mov    -0x3d0(%rbp),%rsi
  381635:	mov    -0x3c8(%rbp),%rdx
  38163c:	mov    %rax,-0x390(%rbp)
  381643:	mov    -0x588(%rbp),%rdi
  38164a:	add    %rsi,%rdx
  38164d:	mov    %rax,-0x4b0(%rbp)
  381654:	call   370c50 <void std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::_M_construct<char*>(char*, char*, std::forward_iterator_tag) [clone .isra.0]>
  381659:	movabs $0x3fffffffffffffff,%rax
  381663:	sub    -0x388(%rbp),%rax
  38166a:	cmp    $0x2,%rax
  38166e:	jbe    382799 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3aa9>
  381674:	mov    -0x588(%rbp),%rdi
  38167b:	mov    $0x3,%edx
  381680:	lea    -0x3088f4(%rip),%rsi        # 78d93 <_IO_stdin_used+0x173f>
  381687:	call   1906a40 <std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::_M_append(char const*, unsigned long)@plt>
  38168c:	mov    -0x390(%rbp),%rax
  381693:	mov    -0x4e0(%rbp),%rdx
  38169a:	mov    -0x530(%rbp),%rdi
  3816a1:	lea    -0x490(%rbp),%rsi
  3816a8:	mov    %rax,-0x490(%rbp)
  3816af:	call   3712f0 <std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >& std::vector<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >, std::allocator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > > >::emplace_back<char const*&, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&>(char const*&, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&) [clone .isra.0]>
  3816b4:	mov    -0x390(%rbp),%rdi
  3816bb:	mov    -0x4b0(%rbp),%rax
  3816c2:	cmp    %rax,%rdi
  3816c5:	je     3816d7 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x29e7>
  3816c7:	mov    -0x380(%rbp),%rax
  3816ce:	lea    0x1(%rax),%rsi
  3816d2:	call   1906920 <operator delete(void*, unsigned long)@plt>
  3816d7:	mov    -0x1b0(%rbp),%rdi
  3816de:	mov    -0x538(%rbp),%rax
  3816e5:	cmp    %rax,%rdi
  3816e8:	je     3816fa <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x2a0a>
  3816ea:	mov    -0x1a0(%rbp),%rax
  3816f1:	lea    0x1(%rax),%rsi
  3816f5:	call   1906920 <operator delete(void*, unsigned long)@plt>
  3816fa:	test   %r12,%r12
  3816fd:	je     38170a <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x2a1a>
  3816ff:	mov    %r13,%rsi
  381702:	mov    %r12,%rdi
  381705:	call   1906920 <operator delete(void*, unsigned long)@plt>
  38170a:	mov    -0x508(%rbp),%rdi
  381711:	cmp    %rdi,-0x4d8(%rbp)
  381718:	je     382429 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3739>
  38171e:	lea    -0x3a0(%rbp),%rax
  381725:	mov    %rax,-0x510(%rbp)
  38172c:	mov    %rax,-0x3b0(%rbp)
  381733:	movq   $0x0,-0x3a8(%rbp)
  38173e:	movb   $0x0,-0x3a0(%rbp)
  381745:	mov    0x15ad63c(%rip),%r14        # 192ed88 <VTT for std::__cxx11::basic_ostringstream<char, std::char_traits<char>, std::allocator<char> >+0x8>
  38174c:	mov    %rdi,%r13
  38174f:	xor    %r12d,%r12d
  381752:	jmp    38177c <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x2a8c>
  381754:	mov    -0x380(%rbp),%rax
  38175b:	add    $0x8,%r13
  38175f:	lea    0x1(%rax),%rsi
  381763:	call   1906920 <operator delete(void*, unsigned long)@plt>
  381768:	cmp    %r13,-0x4d8(%rbp)
  38176f:	je     381aae <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x2dbe>
  381775:	mov    -0x3a8(%rbp),%r12
  38177c:	vmovsd 0x0(%r13),%xmm6
  381782:	vmovsd %xmm6,-0x4c8(%rbp)
  38178a:	test   %r12,%r12
  38178d:	je     3817e7 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x2af7>
  38178f:	lea    0x1(%r12),%rax
  381794:	mov    %rax,-0x4d0(%rbp)
  38179b:	mov    -0x510(%rbp),%rcx
  3817a2:	mov    -0x3b0(%rbp),%rax
  3817a9:	cmp    %rcx,%rax
  3817ac:	je     38231a <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x362a>
  3817b2:	mov    -0x3a0(%rbp),%rdx
  3817b9:	mov    -0x4d0(%rbp),%rdi
  3817c0:	cmp    %rdi,%rdx
  3817c3:	jb     3821dd <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x34ed>
  3817c9:	movb   $0x7c,(%rax,%r12,1)
  3817ce:	mov    -0x4d0(%rbp),%rdi
  3817d5:	mov    -0x3b0(%rbp),%rax
  3817dc:	mov    %rdi,-0x3a8(%rbp)
  3817e3:	movb   $0x0,(%rax,%rdi,1)
  3817e7:	vmovsd -0x4c8(%rbp),%xmm7
  3817ef:	vucomisd %xmm7,%xmm7
  3817f3:	jp     382278 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3588>
  3817f9:	lea    -0x140(%rbp),%rax
  381800:	mov    %rax,%rdi
  381803:	mov    %rax,-0x4d0(%rbp)
  38180a:	lea    0x15ad59f(%rip),%r12        # 192edb0 <vtable for std::basic_ios<char, std::char_traits<char> >+0x10>
  381811:	call   1906b30 <std::ios_base::ios_base()@plt>
  381816:	xor    %eax,%eax
  381818:	mov    %r14,-0x1b0(%rbp)
  38181f:	mov    %r12,-0x140(%rbp)
  381826:	movq   $0x0,-0x68(%rbp)
  38182e:	mov    %ax,-0x60(%rbp)
  381832:	vpxor  %xmm0,%xmm0,%xmm0
  381836:	vmovdqu %ymm0,-0x58(%rbp)
  38183b:	mov    -0x18(%r14),%rax
  38183f:	mov    0x15ad54a(%rip),%rcx        # 192ed90 <VTT for std::__cxx11::basic_ostringstream<char, std::char_traits<char>, std::allocator<char> >+0x10>
  381846:	xor    %esi,%esi
  381848:	mov    %rcx,-0x1b0(%rbp,%rax,1)
  381850:	mov    -0x4e0(%rbp),%rcx
  381857:	mov    -0x1b0(%rbp),%rax
  38185e:	add    -0x18(%rax),%rcx
  381862:	mov    %rcx,%rdi
  381865:	vzeroupper
  381868:	call   1906b40 <std::basic_ios<char, std::char_traits<char> >::init(std::basic_streambuf<char, std::char_traits<char> >*)@plt>
  38186d:	vmovq  0x158691b(%rip),%xmm2        # 1908190 <vtable for std::__cxx11::basic_ostringstream<char, std::char_traits<char>, std::allocator<char> >@GLIBCXX_3.4.21-0x26ba0>
  381875:	lea    0x15ad4f4(%rip),%rcx        # 192ed70 <vtable for std::__cxx11::basic_ostringstream<char, std::char_traits<char>, std::allocator<char> >+0x40>
  38187c:	mov    %rcx,-0x140(%rbp)
  381883:	lea    0x15ad436(%rip),%rcx        # 192ecc0 <vtable for std::basic_streambuf<char, std::char_traits<char> >+0x10>
  38188a:	vpinsrq $0x1,%rcx,%xmm2,%xmm0
  381890:	lea    -0x170(%rbp),%rcx
  381897:	mov    %rcx,-0x4e8(%rbp)
  38189e:	movq   $0x0,-0x180(%rbp)
  3818a9:	movq   $0x0,-0x178(%rbp)
  3818b4:	vmovdqa %xmm0,-0x1b0(%rbp)
  3818bc:	vpxor  %xmm0,%xmm0,%xmm0
  3818c0:	mov    %rcx,%rdi
  3818c3:	vmovdqu %ymm0,-0x1a0(%rbp)
  3818cb:	vzeroupper
  3818ce:	call   1906b50 <std::locale::locale()@plt>
  3818d3:	lea    0x15ad366(%rip),%rcx        # 192ec40 <vtable for std::__cxx11::basic_stringbuf<char, std::char_traits<char>, std::allocator<char> >+0x10>
  3818da:	mov    %rcx,-0x1a8(%rbp)
  3818e1:	lea    -0x150(%rbp),%rcx
  3818e8:	mov    %rcx,-0x160(%rbp)
  3818ef:	movl   $0x10,-0x168(%rbp)
  3818f9:	movq   $0x0,-0x158(%rbp)
  381904:	movb   $0x0,-0x150(%rbp)
  38190b:	mov    %rcx,-0x4f0(%rbp)
  381912:	mov    -0x4d0(%rbp),%rdi
  381919:	lea    -0x1a8(%rbp),%rcx
  381920:	mov    %rcx,%rsi
  381923:	mov    %rcx,-0x500(%rbp)
  38192a:	call   1906b40 <std::basic_ios<char, std::char_traits<char> >::init(std::basic_streambuf<char, std::char_traits<char> >*)@plt>
  38192f:	mov    -0x1b0(%rbp),%rax
  381936:	vmovsd -0x4c8(%rbp),%xmm0
  38193e:	mov    -0x18(%rax),%rax
  381942:	mov    -0x4e0(%rbp),%rdi
  381949:	movq   $0x11,-0x1a8(%rbp,%rax,1)
  381955:	call   1906b60 <std::ostream& std::ostream::_M_insert<double>(double)@plt>
  38195a:	mov    -0x4b0(%rbp),%rax
  381961:	movq   $0x0,-0x388(%rbp)
  38196c:	mov    %rax,-0x390(%rbp)
  381973:	mov    -0x180(%rbp),%rax
  38197a:	movb   $0x0,-0x380(%rbp)
  381981:	test   %rax,%rax
  381984:	je     3821b0 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x34c0>
  38198a:	mov    -0x190(%rbp),%r8
  381991:	test   %r8,%r8
  381994:	je     3821a8 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x34b8>
  38199a:	cmp    %rax,%r8
  38199d:	jb     3821a8 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x34b8>
  3819a3:	mov    -0x188(%rbp),%rcx
  3819aa:	mov    -0x588(%rbp),%rdi
  3819b1:	sub    %rcx,%r8
  3819b4:	xor    %edx,%edx
  3819b6:	xor    %esi,%esi
  3819b8:	call   1906990 <std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::_M_replace(unsigned long, unsigned long, char const*, unsigned long)@plt>
  3819bd:	lea    0x15ad3ac(%rip),%rax        # 192ed70 <vtable for std::__cxx11::basic_ostringstream<char, std::char_traits<char>, std::allocator<char> >+0x40>
  3819c4:	vmovq  0x15867c4(%rip),%xmm3        # 1908190 <vtable for std::__cxx11::basic_ostringstream<char, std::char_traits<char>, std::allocator<char> >@GLIBCXX_3.4.21-0x26ba0>
  3819cc:	mov    %rax,-0x140(%rbp)
  3819d3:	lea    0x15ad266(%rip),%rax        # 192ec40 <vtable for std::__cxx11::basic_stringbuf<char, std::char_traits<char>, std::allocator<char> >+0x10>
  3819da:	vpinsrq $0x1,%rax,%xmm3,%xmm0
  3819e0:	mov    -0x160(%rbp),%rdi
  3819e7:	mov    -0x4f0(%rbp),%rax
  3819ee:	vmovdqa %xmm0,-0x1b0(%rbp)
  3819f6:	cmp    %rax,%rdi
  3819f9:	je     381a0b <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x2d1b>
  3819fb:	mov    -0x150(%rbp),%rax
  381a02:	lea    0x1(%rax),%rsi
  381a06:	call   1906920 <operator delete(void*, unsigned long)@plt>
  381a0b:	lea    0x15ad2ae(%rip),%rax        # 192ecc0 <vtable for std::basic_streambuf<char, std::char_traits<char> >+0x10>
  381a12:	mov    %rax,-0x1a8(%rbp)
  381a19:	mov    -0x4e8(%rbp),%rdi
  381a20:	call   1906b20 <std::locale::~locale()@plt>
  381a25:	mov    %r14,-0x1b0(%rbp)
  381a2c:	mov    0x15ad35d(%rip),%rdi        # 192ed90 <VTT for std::__cxx11::basic_ostringstream<char, std::char_traits<char>, std::allocator<char> >+0x10>
  381a33:	mov    -0x18(%r14),%rax
  381a37:	mov    %rdi,-0x1b0(%rbp,%rax,1)
  381a3f:	mov    %r12,-0x140(%rbp)
  381a46:	mov    -0x4d0(%rbp),%rdi
  381a4d:	call   1906b70 <std::ios_base::~ios_base()@plt>
  381a52:	movabs $0x3fffffffffffffff,%rax
  381a5c:	mov    -0x388(%rbp),%rdx
  381a63:	sub    -0x3a8(%rbp),%rax
  381a6a:	mov    -0x390(%rbp),%rsi
  381a71:	cmp    %rdx,%rax
  381a74:	jb     3827a5 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3ab5>
  381a7a:	mov    -0x5c0(%rbp),%rdi
  381a81:	call   1906a40 <std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::_M_append(char const*, unsigned long)@plt>
  381a86:	mov    -0x390(%rbp),%rdi
  381a8d:	mov    -0x4b0(%rbp),%rax
  381a94:	cmp    %rax,%rdi
  381a97:	jne    381754 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x2a64>
  381a9d:	add    $0x8,%r13
  381aa1:	cmp    %r13,-0x4d8(%rbp)
  381aa8:	jne    381775 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x2a85>
  381aae:	mov    -0x4e0(%rbp),%rdi
  381ab5:	mov    -0x5c0(%rbp),%rsi
  381abc:	call   1906bf0 <std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::basic_string(std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >&&)@plt>
  381ac1:	mov    -0x3b0(%rbp),%rdi
  381ac8:	mov    -0x510(%rbp),%rax
  381acf:	cmp    %rax,%rdi
  381ad2:	je     381ae4 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x2df4>
  381ad4:	mov    -0x3a0(%rbp),%rax
  381adb:	lea    0x1(%rax),%rsi
  381adf:	call   1906920 <operator delete(void*, unsigned long)@plt>
  381ae4:	mov    -0x4b0(%rbp),%rax
  381aeb:	mov    -0x3d0(%rbp),%rsi
  381af2:	mov    -0x3c8(%rbp),%rdx
  381af9:	mov    %rax,-0x390(%rbp)
  381b00:	mov    -0x588(%rbp),%rdi
  381b07:	add    %rsi,%rdx
  381b0a:	call   370c50 <void std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::_M_construct<char*>(char*, char*, std::forward_iterator_tag) [clone .isra.0]>
  381b0f:	movabs $0x3fffffffffffffff,%rax
  381b19:	sub    -0x388(%rbp),%rax
  381b20:	cmp    $0x9,%rax
  381b24:	jbe    3827d5 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3ae5>
  381b2a:	mov    -0x588(%rbp),%rdi
  381b31:	mov    $0xa,%edx
  381b36:	lea    -0x3095d5(%rip),%rsi        # 78568 <_IO_stdin_used+0xf14>
  381b3d:	call   1906a40 <std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::_M_append(char const*, unsigned long)@plt>
  381b42:	mov    -0x390(%rbp),%rax
  381b49:	mov    -0x4e0(%rbp),%rdx
  381b50:	mov    -0x530(%rbp),%rdi
  381b57:	lea    -0x488(%rbp),%rsi
  381b5e:	mov    %rax,-0x488(%rbp)
  381b65:	call   3712f0 <std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >& std::vector<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >, std::allocator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > > >::emplace_back<char const*&, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&>(char const*&, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&) [clone .isra.0]>
  381b6a:	mov    -0x390(%rbp),%rdi
  381b71:	mov    -0x4b0(%rbp),%rax
  381b78:	cmp    %rax,%rdi
  381b7b:	je     381b8d <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x2e9d>
  381b7d:	mov    -0x380(%rbp),%rax
  381b84:	lea    0x1(%rax),%rsi
  381b88:	call   1906920 <operator delete(void*, unsigned long)@plt>
  381b8d:	mov    -0x1b0(%rbp),%rdi
  381b94:	mov    -0x538(%rbp),%rax
  381b9b:	cmp    %rax,%rdi
  381b9e:	je     381bb0 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x2ec0>
  381ba0:	mov    -0x1a0(%rbp),%rax
  381ba7:	lea    0x1(%rax),%rsi
  381bab:	call   1906920 <operator delete(void*, unsigned long)@plt>
  381bb0:	mov    -0x4d8(%rbp),%rdi
  381bb7:	mov    -0x508(%rbp),%rcx
  381bbe:	vmovsd -0x3067e6(%rip),%xmm0        # 7b3e0 <bloom_filters::FastPatternBF::sparse_patterns_+0x1f80>
  381bc6:	cmp    %rcx,%rdi
  381bc9:	jne    382389 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3699>
  381bcf:	mov    -0x4e0(%rbp),%rdi
  381bd6:	call   37a450 <raw32_stage3::Number[abi:cxx11](double)>
  381bdb:	mov    -0x4b0(%rbp),%rax
  381be2:	mov    -0x3d0(%rbp),%rsi
  381be9:	mov    -0x3c8(%rbp),%rdx
  381bf0:	mov    %rax,-0x390(%rbp)
  381bf7:	mov    -0x588(%rbp),%rdi
  381bfe:	add    %rsi,%rdx
  381c01:	call   370c50 <void std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::_M_construct<char*>(char*, char*, std::forward_iterator_tag) [clone .isra.0]>
  381c06:	movabs $0x3fffffffffffffff,%rax
  381c10:	sub    -0x388(%rbp),%rax
  381c17:	cmp    $0x6,%rax
  381c1b:	jbe    3827c9 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3ad9>
  381c21:	mov    -0x588(%rbp),%rdi
  381c28:	mov    $0x7,%edx
  381c2d:	lea    -0x308b1a(%rip),%rsi        # 7911a <_IO_stdin_used+0x1ac6>
  381c34:	call   1906a40 <std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::_M_append(char const*, unsigned long)@plt>
  381c39:	mov    -0x390(%rbp),%rax
  381c40:	mov    -0x4e0(%rbp),%rdx
  381c47:	mov    -0x530(%rbp),%rdi
  381c4e:	lea    -0x480(%rbp),%rsi
  381c55:	mov    %rax,-0x480(%rbp)
  381c5c:	call   3712f0 <std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >& std::vector<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >, std::allocator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > > >::emplace_back<char const*&, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&>(char const*&, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&) [clone .isra.0]>
  381c61:	mov    -0x390(%rbp),%rdi
  381c68:	mov    -0x4b0(%rbp),%rax
  381c6f:	cmp    %rax,%rdi
  381c72:	je     381c84 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x2f94>
  381c74:	mov    -0x380(%rbp),%rax
  381c7b:	lea    0x1(%rax),%rsi
  381c7f:	call   1906920 <operator delete(void*, unsigned long)@plt>
  381c84:	mov    -0x1b0(%rbp),%rdi
  381c8b:	mov    -0x538(%rbp),%rax
  381c92:	cmp    %rax,%rdi
  381c95:	je     381ca7 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x2fb7>
  381c97:	mov    -0x1a0(%rbp),%rax
  381c9e:	lea    0x1(%rax),%rsi
  381ca2:	call   1906920 <operator delete(void*, unsigned long)@plt>
  381ca7:	mov    -0x4d8(%rbp),%rdi
  381cae:	mov    -0x508(%rbp),%rcx
  381cb5:	vmovsd -0x3068dd(%rip),%xmm0        # 7b3e0 <bloom_filters::FastPatternBF::sparse_patterns_+0x1f80>
  381cbd:	cmp    %rcx,%rdi
  381cc0:	jne    38235f <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x366f>
  381cc6:	mov    -0x4e0(%rbp),%rdi
  381ccd:	call   37a450 <raw32_stage3::Number[abi:cxx11](double)>
  381cd2:	mov    -0x4b0(%rbp),%rax
  381cd9:	mov    -0x3d0(%rbp),%rsi
  381ce0:	mov    -0x3c8(%rbp),%rdx
  381ce7:	mov    %rax,-0x390(%rbp)
  381cee:	mov    -0x588(%rbp),%rdi
  381cf5:	add    %rsi,%rdx
  381cf8:	call   370c50 <void std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::_M_construct<char*>(char*, char*, std::forward_iterator_tag) [clone .isra.0]>
  381cfd:	movabs $0x3fffffffffffffff,%rax
  381d07:	sub    -0x388(%rbp),%rax
  381d0e:	cmp    $0x6,%rax
  381d12:	jbe    3827bd <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3acd>
  381d18:	mov    -0x588(%rbp),%rdi
  381d1f:	mov    $0x7,%edx
  381d24:	lea    -0x3094ed(%rip),%rsi        # 7883e <_IO_stdin_used+0x11ea>
  381d2b:	call   1906a40 <std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::_M_append(char const*, unsigned long)@plt>
  381d30:	mov    -0x390(%rbp),%rax
  381d37:	mov    -0x4e0(%rbp),%rdx
  381d3e:	mov    -0x530(%rbp),%rdi
  381d45:	lea    -0x478(%rbp),%rsi
  381d4c:	mov    %rax,-0x478(%rbp)
  381d53:	call   3712f0 <std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >& std::vector<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >, std::allocator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > > >::emplace_back<char const*&, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&>(char const*&, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&) [clone .isra.0]>
  381d58:	mov    -0x390(%rbp),%rdi
  381d5f:	mov    -0x4b0(%rbp),%rax
  381d66:	cmp    %rax,%rdi
  381d69:	je     381d7b <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x308b>
  381d6b:	mov    -0x380(%rbp),%rax
  381d72:	lea    0x1(%rax),%rsi
  381d76:	call   1906920 <operator delete(void*, unsigned long)@plt>
  381d7b:	mov    -0x1b0(%rbp),%rdi
  381d82:	mov    -0x538(%rbp),%rax
  381d89:	cmp    %rax,%rdi
  381d8c:	je     381d9e <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x30ae>
  381d8e:	mov    -0x1a0(%rbp),%rax
  381d95:	lea    0x1(%rax),%rsi
  381d99:	call   1906920 <operator delete(void*, unsigned long)@plt>
  381d9e:	mov    -0x540(%rbp),%rax
  381da5:	mov    -0x4f8(%rbp),%rdi
  381dac:	mov    -0x3d0(%rbp),%rsi
  381db3:	mov    (%rax,%rdi,1),%r12
  381db7:	mov    -0x538(%rbp),%rax
  381dbe:	mov    -0x3c8(%rbp),%rdx
  381dc5:	mov    %rax,-0x1b0(%rbp)
  381dcc:	mov    -0x4e0(%rbp),%rdi
  381dd3:	add    %rsi,%rdx
  381dd6:	call   370c50 <void std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::_M_construct<char*>(char*, char*, std::forward_iterator_tag) [clone .isra.0]>
  381ddb:	movabs $0x3fffffffffffffff,%rax
  381de5:	sub    -0x1a8(%rbp),%rax
  381dec:	cmp    $0xd,%rax
  381df0:	jbe    3827b1 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3ac1>
  381df6:	mov    -0x4e0(%rbp),%rdi
  381dfd:	mov    $0xe,%edx
  381e02:	lea    -0x3092b4(%rip),%rsi        # 78b55 <_IO_stdin_used+0x1501>
  381e09:	call   1906a40 <std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::_M_append(char const*, unsigned long)@plt>
  381e0e:	mov    -0x1b0(%rbp),%rsi
  381e15:	mov    -0x530(%rbp),%rdi
  381e1c:	mov    %r12,%rdx
  381e1f:	call   37e5a0 <void raw32_stage3::Add<unsigned long>(std::vector<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >, std::allocator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > > >&, char const*, unsigned long)>
  381e24:	mov    -0x1b0(%rbp),%rdi
  381e2b:	mov    -0x538(%rbp),%rax
  381e32:	cmp    %rax,%rdi
  381e35:	je     381e47 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3157>
  381e37:	mov    -0x1a0(%rbp),%rax
  381e3e:	lea    0x1(%rax),%rsi
  381e42:	call   1906920 <operator delete(void*, unsigned long)@plt>
  381e47:	mov    -0x3d0(%rbp),%rdi
  381e4e:	lea    -0x3c0(%rbp),%rax
  381e55:	cmp    %rax,%rdi
  381e58:	je     382339 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3649>
  381e5e:	mov    -0x3c0(%rbp),%rax
  381e65:	lea    0x1(%rax),%rsi
  381e69:	call   1906920 <operator delete(void*, unsigned long)@plt>
  381e6e:	addq   $0x8,-0x4f8(%rbp)
  381e76:	addq   $0x18,-0x520(%rbp)
  381e7e:	mov    -0x4f8(%rbp),%rax
  381e85:	cmp    $0x18,%rax
  381e89:	jne    3814c6 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x27d6>
  381e8f:	lea    -0x309621(%rip),%rcx        # 78875 <_IO_stdin_used+0x1221>
  381e96:	lea    -0x30916a(%rip),%rax        # 78d33 <_IO_stdin_used+0x16df>
  381e9d:	vmovq  %rcx,%xmm0
  381ea2:	lea    -0x309444(%rip),%rdi        # 78a65 <_IO_stdin_used+0x1411>
  381ea9:	vpinsrq $0x1,%rax,%xmm0,%xmm0
  381eaf:	vmovq  %rdi,%xmm1
  381eb4:	lea    -0x309659(%rip),%rax        # 78862 <_IO_stdin_used+0x120e>
  381ebb:	vpinsrq $0x1,%rax,%xmm1,%xmm1
  381ec1:	vinserti128 $0x1,%xmm0,%ymm1,%ymm4
  381ec7:	mov    -0x530(%rbp),%rdi
  381ece:	vmovdqa %ymm4,-0x4b0(%rbp)
  381ed6:	xor    %edx,%edx
  381ed8:	lea    -0x30996c(%rip),%rsi        # 78573 <_IO_stdin_used+0xf1f>
  381edf:	vzeroupper
  381ee2:	call   37e0b0 <void raw32_stage3::Add<int>(std::vector<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >, std::allocator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > > >&, char const*, int)>
  381ee7:	vmovdqa -0x4b0(%rbp),%ymm4
  381eef:	mov    -0x588(%rbp),%r13
  381ef6:	vmovdqa %ymm4,-0x390(%rbp)
  381efe:	lea    -0x308f89(%rip),%r12        # 78f7c <_IO_stdin_used+0x1928>
  381f05:	vzeroupper
  381f08:	mov    -0x4e0(%rbp),%rdi
  381f0f:	mov    %r12,%rsi
  381f12:	mov    0x0(%r13),%r14
  381f16:	call   370f30 <std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::basic_string<std::allocator<char> >(char const*, std::allocator<char> const&) [clone .constprop.0]>
  381f1b:	mov    %r14,-0x3b0(%rbp)
  381f22:	mov    -0x4e0(%rbp),%rdx
  381f29:	mov    -0x5c0(%rbp),%rsi
  381f30:	mov    -0x530(%rbp),%rdi
  381f37:	call   3712f0 <std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >& std::vector<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >, std::allocator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > > >::emplace_back<char const*&, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&>(char const*&, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&) [clone .isra.0]>
  381f3c:	mov    -0x1b0(%rbp),%rdi
  381f43:	mov    -0x538(%rbp),%rax
  381f4a:	cmp    %rax,%rdi
  381f4d:	je     382293 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x35a3>
  381f53:	mov    -0x1a0(%rbp),%rax
  381f5a:	add    $0x8,%r13
  381f5e:	lea    0x1(%rax),%rsi
  381f62:	call   1906920 <operator delete(void*, unsigned long)@plt>
  381f67:	cmp    %r13,-0x5b8(%rbp)
  381f6e:	jne    381f08 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3218>
  381f70:	mov    -0x4c0(%rbp),%r14
  381f77:	mov    (%r14),%rdi
  381f7a:	call   *0x48(%r14)
  381f7e:	mov    -0x530(%rbp),%r12
  381f85:	mov    %rax,%rdx
  381f88:	lea    -0x308f76(%rip),%rsi        # 79019 <_IO_stdin_used+0x19c5>
  381f8f:	mov    %r12,%rdi
  381f92:	call   37e5a0 <void raw32_stage3::Add<unsigned long>(std::vector<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >, std::allocator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > > >&, char const*, unsigned long)>
  381f97:	mov    (%r14),%rdi
  381f9a:	call   *0x50(%r14)
  381f9e:	mov    %rax,%rdx
  381fa1:	lea    -0x309211(%rip),%rsi        # 78d97 <_IO_stdin_used+0x1743>
  381fa8:	mov    %r12,%rdi
  381fab:	call   37e5a0 <void raw32_stage3::Add<unsigned long>(std::vector<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >, std::allocator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > > >&, char const*, unsigned long)>
  381fb0:	mov    0x8(%r14),%rdx
  381fb4:	lea    -0x309209(%rip),%rsi        # 78db2 <_IO_stdin_used+0x175e>
  381fbb:	mov    %r12,%rdi
  381fbe:	call   37e5a0 <void raw32_stage3::Add<unsigned long>(std::vector<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >, std::allocator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > > >&, char const*, unsigned long)>
  381fc3:	mov    %r12,%rdi
  381fc6:	call   378e70 <raw32_stage3::Print(std::vector<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >, std::allocator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > > > const&)>
  381fcb:	mov    -0x3f0(%rbp),%rdi
  381fd2:	mov    -0x518(%rbp),%rax
  381fd9:	cmp    %rax,%rdi
  381fdc:	je     381fee <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x32fe>
  381fde:	mov    -0x3e0(%rbp),%rax
  381fe5:	lea    0x1(%rax),%rsi
  381fe9:	call   1906920 <operator delete(void*, unsigned long)@plt>
  381fee:	lea    -0x328(%rbp),%r12
  381ff5:	mov    -0x18(%r12),%rdi
  381ffa:	sub    $0x18,%r12
  381ffe:	test   %rdi,%rdi
  382001:	je     382324 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3634>
  382007:	mov    0x10(%r12),%rsi
  38200c:	sub    %rdi,%rsi
  38200f:	call   1906920 <operator delete(void*, unsigned long)@plt>
  382014:	mov    -0x5b8(%rbp),%rax
  38201b:	cmp    %rax,%r12
  38201e:	jne    381ff5 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3305>
  382020:	test   %rbx,%rbx
  382023:	je     382037 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3347>
  382025:	mov    -0x400(%rbp),%rsi
  38202c:	mov    %rbx,%rdi
  38202f:	sub    %rbx,%rsi
  382032:	call   1906920 <operator delete(void*, unsigned long)@plt>
  382037:	mov    -0x4b8(%rbp),%rax
  38203e:	test   %rax,%rax
  382041:	je     382052 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3362>
  382043:	mov    -0x528(%rbp),%rsi
  38204a:	mov    %rax,%rdi
  38204d:	call   1906920 <operator delete(void*, unsigned long)@plt>
  382052:	mov    -0x590(%rbp),%rdi
  382059:	mov    $0x4000,%esi
  38205e:	call   1906920 <operator delete(void*, unsigned long)@plt>
  382063:	mov    -0x2d8(%rbp),%rdi
  38206a:	test   %rdi,%rdi
  38206d:	je     38207e <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x338e>
  38206f:	mov    -0x2c8(%rbp),%rsi
  382076:	sub    %rdi,%rsi
  382079:	call   1906920 <operator delete(void*, unsigned long)@plt>
  38207e:	mov    -0x600(%rbp),%rdi
  382085:	test   %rdi,%rdi
  382088:	je     382099 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x33a9>
  38208a:	mov    -0x2e0(%rbp),%rsi
  382091:	sub    %rdi,%rsi
  382094:	call   1906920 <operator delete(void*, unsigned long)@plt>
  382099:	test   %r15,%r15
  38209c:	je     3820b0 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x33c0>
  38209e:	mov    -0x2f8(%rbp),%rsi
  3820a5:	mov    %r15,%rdi
  3820a8:	sub    %r15,%rsi
  3820ab:	call   1906920 <operator delete(void*, unsigned long)@plt>
  3820b0:	mov    -0x5e0(%rbp),%rdi
  3820b7:	test   %rdi,%rdi
  3820ba:	je     382123 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3433>
  3820bc:	mov    -0x310(%rbp),%rsi
  3820c3:	sub    %rdi,%rsi
  3820c6:	call   1906920 <operator delete(void*, unsigned long)@plt>
  3820cb:	jmp    382123 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3433>
  3820cd:	mov    %rsi,%rdx
  3820d0:	jmp    37fb4e <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0xe5e>
  3820d5:	mov    -0x5d0(%rbp),%rdi
  3820dc:	mov    $0x1,%r8d
  3820e2:	xor    %ecx,%ecx
  3820e4:	xor    %edx,%edx
  3820e6:	mov    %r12,%rsi
  3820e9:	call   1906ad0 <std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::_M_mutate(unsigned long, unsigned long, char const*, unsigned long)@plt>
  3820ee:	mov    -0x3f0(%rbp),%rax
  3820f5:	jmp    38098f <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1c9f>
  3820fa:	movq   $0x0,-0x610(%rbp)
  382105:	movq   $0x0,-0x4b8(%rbp)
  382110:	xor    %ebx,%ebx
  382112:	jmp    37f6fd <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0xa0d>
  382117:	mov    -0x530(%rbp),%rdi
  38211e:	call   378e70 <raw32_stage3::Print(std::vector<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >, std::allocator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > > > const&)>
  382123:	mov    -0x530(%rbp),%rdi
  38212a:	call   37a7d0 <std::vector<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >, std::allocator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > > >::~vector()>
  38212f:	mov    -0x608(%rbp),%rdi
  382136:	call   379b00 <raw32_stage3::Geometry::~Geometry()>
  38213b:	add    $0x620,%rsp
  382142:	pop    %rbx
  382143:	pop    %r10
  382145:	pop    %r12
  382147:	pop    %r13
  382149:	pop    %r14
  38214b:	pop    %r15
  38214d:	xor    %eax,%eax
  38214f:	pop    %rbp
  382150:	lea    -0x8(%r10),%rsp
  382154:	ret
  382155:	movl   $0x2,0x40(%rbx)
  38215c:	mov    -0x4b8(%rbp),%rsi
  382163:	mov    -0x5d8(%rbp),%rdi
  38216a:	call   3797f0 <raw32_stage3::GuardedOutput::Check(unsigned int const*) const>
  38216f:	mov    $0x10,%edi
  382174:	call   1906930 <__cxa_allocate_exception@plt>
  382179:	mov    %rax,%rdi
  38217c:	lea    -0x30a58b(%rip),%rsi        # 77bf8 <_IO_stdin_used+0x5a4>
  382183:	mov    %rax,%r12
  382186:	call   19069d0 <std::runtime_error::runtime_error(char const*)@plt>
  38218b:	mov    0x15ac996(%rip),%rdx        # 192eb28 <std::runtime_error::~runtime_error()@GLIBCXX_3.4>
  382192:	lea    0x15aca47(%rip),%rsi        # 192ebe0 <typeinfo for std::runtime_error@GLIBCXX_3.4>
  382199:	mov    %r12,%rdi
  38219c:	call   1906940 <__cxa_throw@plt>
  3821a1:	nopl   0x0(%rax)
  3821a8:	mov    %rax,%r8
  3821ab:	jmp    3819a3 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x2cb3>
  3821b0:	mov    -0x588(%rbp),%rdi
  3821b7:	lea    -0x160(%rbp),%rsi
  3821be:	call   1906b80 <std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::_M_assign(std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&)@plt>
  3821c3:	jmp    3819bd <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x2ccd>
  3821c8:	mov    %r14,%rax
  3821cb:	add    $0xc,%rax
  3821cf:	xor    %edi,%edi
  3821d1:	cmp    %rax,%r13
  3821d4:	sete   %dil
  3821d8:	jmp    380f4d <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x225d>
  3821dd:	mov    -0x5c0(%rbp),%rdi
  3821e4:	mov    $0x1,%r8d
  3821ea:	xor    %ecx,%ecx
  3821ec:	xor    %edx,%edx
  3821ee:	mov    %r12,%rsi
  3821f1:	call   1906ad0 <std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::_M_mutate(unsigned long, unsigned long, char const*, unsigned long)@plt>
  3821f6:	mov    -0x3b0(%rbp),%rax
  3821fd:	jmp    3817c9 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x2ad9>
  382202:	xor    %r12d,%r12d
  382205:	jmp    38221a <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x352a>
  382207:	mov    -0x4b0(%rbp),%rax
  38220e:	inc    %r12
  382211:	cmp    %rax,%r12
  382214:	je     3810c3 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x23d3>
  38221a:	mov    -0x4d0(%rbp),%rax
  382221:	mov    0x40(%r14,%r12,4),%r13d
  382226:	mov    (%rax,%r12,4),%esi
  38222a:	mov    -0x4c0(%rbp),%rax
  382231:	mov    (%rax),%rdi
  382234:	call   *0x28(%rax)
  382237:	movzbl %al,%eax
  38223a:	cmp    %eax,%r13d
  38223d:	je     382207 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3517>
  38223f:	mov    $0x10,%edi
  382244:	call   1906930 <__cxa_allocate_exception@plt>
  382249:	mov    %rax,%rdi
  38224c:	lea    -0x3093e6(%rip),%rsi        # 78e6d <_IO_stdin_used+0x1819>
  382253:	mov    %rax,%r12
  382256:	call   19069d0 <std::runtime_error::runtime_error(char const*)@plt>
  38225b:	mov    0x15ac8c6(%rip),%rdx        # 192eb28 <std::runtime_error::~runtime_error()@GLIBCXX_3.4>
  382262:	lea    0x15ac977(%rip),%rsi        # 192ebe0 <typeinfo for std::runtime_error@GLIBCXX_3.4>
  382269:	mov    %r12,%rdi
  38226c:	call   1906940 <__cxa_throw@plt>
  382271:	nopl   0x0(%rax)
  382278:	lea    -0x309303(%rip),%r12        # 78f7c <_IO_stdin_used+0x1928>
  38227f:	mov    -0x588(%rbp),%rdi
  382286:	mov    %r12,%rsi
  382289:	call   370f30 <std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::basic_string<std::allocator<char> >(char const*, std::allocator<char> const&) [clone .constprop.0]>
  38228e:	jmp    381a52 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x2d62>
  382293:	mov    -0x5b8(%rbp),%rax
  38229a:	add    $0x8,%r13
  38229e:	cmp    %rax,%r13
  3822a1:	jne    381f08 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3218>
  3822a7:	jmp    381f70 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3280>
  3822ac:	mov    %r14,%rax
  3822af:	add    $0x4,%rax
  3822b3:	xor    %edi,%edi
  3822b5:	cmp    %rax,%r13
  3822b8:	sete   %dil
  3822bc:	jmp    380f4d <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x225d>
  3822c1:	add    $0xc,%rax
  3822c5:	xor    %edi,%edi
  3822c7:	cmp    %rax,%r12
  3822ca:	sete   %dil
  3822ce:	jmp    381062 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x2372>
  3822d3:	add    $0x8,%rax
  3822d7:	xor    %edi,%edi
  3822d9:	cmp    %rax,%r12
  3822dc:	sete   %dil
  3822e0:	jmp    381062 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x2372>
  3822e5:	add    $0x4,%rax
  3822e9:	xor    %edi,%edi
  3822eb:	cmp    %rax,%r12
  3822ee:	sete   %dil
  3822f2:	jmp    381062 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x2372>
  3822f7:	xor    %edi,%edi
  3822f9:	cmp    %r12,%rax
  3822fc:	sete   %dil
  382300:	jmp    381062 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x2372>
  382305:	mov    %r14,%rax
  382308:	add    $0x8,%rax
  38230c:	xor    %edi,%edi
  38230e:	cmp    %rax,%r13
  382311:	sete   %dil
  382315:	jmp    380f4d <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x225d>
  38231a:	mov    $0xf,%edx
  38231f:	jmp    3817b9 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x2ac9>
  382324:	mov    -0x5b8(%rbp),%rax
  38232b:	cmp    %rax,%r12
  38232e:	jne    381ff5 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3305>
  382334:	jmp    382020 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3330>
  382339:	addq   $0x8,-0x4f8(%rbp)
  382341:	mov    -0x4f8(%rbp),%rax
  382348:	cmp    $0x18,%rax
  38234c:	je     381e8f <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x319f>
  382352:	addq   $0x18,-0x520(%rbp)
  38235a:	jmp    3814c6 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x27d6>
  38235f:	lea    0x8(%rcx),%rax
  382363:	vmovsd (%rcx),%xmm0
  382367:	cmp    %rax,%rdi
  38236a:	je     381cc6 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x2fd6>
  382370:	mov    %rdi,%rdx
  382373:	vmovsd (%rax),%xmm1
  382377:	add    $0x8,%rax
  38237b:	vmaxsd %xmm0,%xmm1,%xmm0
  38237f:	cmp    %rax,%rdx
  382382:	jne    382373 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3683>
  382384:	jmp    381cc6 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x2fd6>
  382389:	lea    0x8(%rcx),%rax
  38238d:	vmovsd (%rcx),%xmm0
  382391:	cmp    %rdi,%rax
  382394:	je     381bcf <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x2edf>
  38239a:	mov    %rdi,%rdx
  38239d:	vmovsd (%rax),%xmm1
  3823a1:	add    $0x8,%rax
  3823a5:	vminsd %xmm0,%xmm1,%xmm0
  3823a9:	cmp    %rdx,%rax
  3823ac:	jne    38239d <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x36ad>
  3823ae:	jmp    381bcf <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x2edf>
  3823b3:	mov    -0x306fda(%rip),%rax        # 7b3e0 <bloom_filters::FastPatternBF::sparse_patterns_+0x1f80>
  3823ba:	xor    %r12d,%r12d
  3823bd:	vmovq  %rax,%xmm0
  3823c2:	jmp    38161b <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x292b>
  3823c7:	xor    %esi,%esi
  3823c9:	jmp    37f8ad <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0xbbd>
  3823ce:	mov    -0x4b0(%rbp),%rax
  3823d5:	xor    %ecx,%ecx
  3823d7:	jmp    37f98d <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0xc9d>
  3823dc:	mov    %r13,%rax
  3823df:	xor    %r9d,%r9d
  3823e2:	jmp    380de8 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x20f8>
  3823e7:	mov    %r12,%rax
  3823ea:	jmp    37fff7 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x1307>
  3823ef:	mov    -0x538(%rbp),%rdi
  3823f6:	mov    -0x3f0(%rbp),%rsi
  3823fd:	mov    %rdi,-0x1b0(%rbp)
  382404:	mov    -0x4e0(%rbp),%rdi
  38240b:	lea    (%rsi,%rax,1),%rdx
  38240f:	call   370c50 <void std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::_M_construct<char*>(char*, char*, std::forward_iterator_tag) [clone .isra.0]>
  382414:	jmp    381433 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x2743>
  382419:	movq   $0x0,-0x5c8(%rbp)
  382424:	jmp    37f794 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0xaa4>
  382429:	lea    -0x3094b4(%rip),%r12        # 78f7c <_IO_stdin_used+0x1928>
  382430:	mov    -0x4e0(%rbp),%rdi
  382437:	mov    %r12,%rsi
  38243a:	call   370f30 <std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::basic_string<std::allocator<char> >(char const*, std::allocator<char> const&) [clone .constprop.0]>
  38243f:	jmp    381ae4 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x2df4>
  382444:	mov    %r14,%rsi
  382447:	mov    %r12,%rdi
  38244a:	call   372310 <void std::__insertion_sort<__gnu_cxx::__normal_iterator<double*, std::vector<double, std::allocator<double> > >, __gnu_cxx::__ops::_Iter_less_iter>(__gnu_cxx::__normal_iterator<double*, std::vector<double, std::allocator<double> > >, __gnu_cxx::__normal_iterator<double*, std::vector<double, std::allocator<double> > >, __gnu_cxx::__ops::_Iter_less_iter) [clone .isra.0]>
  38244f:	jmp    3815f4 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x2904>
  382454:	mov    %rcx,%rdx
  382457:	jmp    3815e7 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x28f7>
  38245c:	vmovsd -0x307084(%rip),%xmm0        # 7b3e0 <bloom_filters::FastPatternBF::sparse_patterns_+0x1f80>
  382464:	jmp    38161b <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x292b>
  382469:	test   %r13,%r13
  38246c:	jns    382764 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3a74>
  382472:	call   1906c70 <std::__throw_bad_array_new_length()@plt>
  382477:	nopw   0x0(%rax,%rax,1)
  382480:	movq   $0x0,-0x1a8(%rbp)
  38248b:	movq   $0x0,-0x1a0(%rbp)
  382496:	lea    0x80(,%r13,4),%rax
  38249e:	mov    %rax,%rdi
  3824a1:	mov    %rax,-0x500(%rbp)
  3824a8:	call   1906a00 <operator new(unsigned long)@plt>
  3824ad:	mov    %rax,%r12
  3824b0:	mov    %rax,-0x1b0(%rbp)
  3824b7:	mov    -0x500(%rbp),%rax
  3824be:	lea    (%r12,%rax,1),%rdx
  3824c2:	mov    %rdx,-0x1a0(%rbp)
  3824c9:	cmp    %rdx,%r12
  3824cc:	je     382786 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3a96>
  3824d2:	lea    -0x4(%rax),%r8
  3824d6:	mov    %r8,%rsi
  3824d9:	shr    $0x2,%rsi
  3824dd:	lea    0x1(%rsi),%rdi
  3824e1:	cmp    $0x18,%r8
  3824e5:	jbe    38277c <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3a8c>
  3824eb:	mov    %rdi,%rax
  3824ee:	shr    $0x3,%rax
  3824f2:	shl    $0x5,%rax
  3824f6:	mov    $0xdeadbeef,%r9d
  3824fc:	mov    %r12,%rcx
  3824ff:	add    %r12,%rax
  382502:	vpbroadcastd %r9d,%ymm0
  382508:	vmovdqu %ymm0,(%rcx)
  38250c:	add    $0x20,%rcx
  382510:	cmp    %rcx,%rax
  382513:	jne    382508 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3818>
  382515:	mov    %rdi,%rcx
  382518:	and    $0xfffffffffffffff8,%rcx
  38251c:	lea    (%r12,%rcx,4),%rax
  382520:	test   $0x7,%dil
  382524:	je     382769 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3a79>
  38252a:	mov    %rsi,%r9
  38252d:	sub    %rcx,%r9
  382530:	lea    0x1(%r9),%r10
  382534:	cmp    $0x2,%r9
  382538:	jbe    38255d <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x386d>
  38253a:	mov    $0xdeadbeef,%r9d
  382540:	vpbroadcastd %r9d,%xmm0
  382546:	vmovdqu %xmm0,(%r12,%rcx,4)
  38254c:	mov    %r10,%rcx
  38254f:	and    $0xfffffffffffffffc,%rcx
  382553:	and    $0x3,%r10d
  382557:	lea    (%rax,%rcx,4),%rax
  38255b:	je     382583 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3893>
  38255d:	lea    0x4(%rax),%rcx
  382561:	movl   $0xdeadbeef,(%rax)
  382567:	cmp    %rcx,%rdx
  38256a:	je     382583 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3893>
  38256c:	lea    0x8(%rax),%rcx
  382570:	movl   $0xdeadbeef,0x4(%rax)
  382577:	cmp    %rcx,%rdx
  38257a:	je     382583 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3893>
  38257c:	movl   $0xdeadbeef,0x8(%rax)
  382583:	mov    %rdx,-0x1a8(%rbp)
  38258a:	mov    %r13,-0x198(%rbp)
  382591:	cmp    $0x18,%r8
  382595:	jbe    382742 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3a52>
  38259b:	mov    %rdi,%rcx
  38259e:	shr    $0x3,%rcx
  3825a2:	shl    $0x5,%rcx
  3825a6:	mov    $0xdeadbeef,%r8d
  3825ac:	mov    %r12,%rax
  3825af:	add    %r12,%rcx
  3825b2:	vpbroadcastd %r8d,%ymm0
  3825b8:	vmovdqu %ymm0,(%rax)
  3825bc:	add    $0x20,%rax
  3825c0:	cmp    %rcx,%rax
  3825c3:	jne    3825b8 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x38c8>
  3825c5:	mov    %rdi,%rcx
  3825c8:	and    $0xfffffffffffffff8,%rcx
  3825cc:	and    $0x7,%edi
  3825cf:	lea    (%r12,%rcx,4),%rax
  3825d3:	je     382629 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3939>
  3825d5:	sub    %rcx,%rsi
  3825d8:	lea    0x1(%rsi),%rdi
  3825dc:	cmp    $0x2,%rsi
  3825e0:	jbe    382603 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3913>
  3825e2:	mov    $0xdeadbeef,%esi
  3825e7:	vpbroadcastd %esi,%xmm0
  3825ed:	vmovdqu %xmm0,(%r12,%rcx,4)
  3825f3:	mov    %rdi,%rcx
  3825f6:	and    $0xfffffffffffffffc,%rcx
  3825fa:	and    $0x3,%edi
  3825fd:	lea    (%rax,%rcx,4),%rax
  382601:	je     382629 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3939>
  382603:	lea    0x4(%rax),%rcx
  382607:	movl   $0xdeadbeef,(%rax)
  38260d:	cmp    %rcx,%rdx
  382610:	je     382629 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3939>
  382612:	lea    0x8(%rax),%rcx
  382616:	movl   $0xdeadbeef,0x4(%rax)
  38261d:	cmp    %rcx,%rdx
  382620:	je     382629 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3939>
  382622:	movl   $0xdeadbeef,0x8(%rax)
  382629:	mov    -0x500(%rbp),%rax
  382630:	lea    0x40(%r12),%r8
  382635:	lea    -0x40(%r12,%rax,1),%rsi
  38263a:	cmp    %rsi,%r8
  38263d:	je     3826f1 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3a01>
  382643:	sub    $0x84,%rax
  382649:	mov    %rax,%rcx
  38264c:	shr    $0x2,%rcx
  382650:	lea    0x1(%rcx),%rdi
  382654:	cmp    $0x18,%rax
  382658:	jbe    382737 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3a47>
  38265e:	mov    %rdi,%rdx
  382661:	shr    $0x3,%rdx
  382665:	shl    $0x5,%rdx
  382669:	mov    $0xfeedface,%r11d
  38266f:	mov    %r12,%rax
  382672:	add    %r12,%rdx
  382675:	vpbroadcastd %r11d,%ymm0
  38267b:	vmovdqu %ymm0,0x40(%rax)
  382680:	add    $0x20,%rax
  382684:	cmp    %rdx,%rax
  382687:	jne    38267b <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x398b>
  382689:	mov    %rdi,%r9
  38268c:	and    $0xfffffffffffffff8,%r9
  382690:	and    $0x7,%edi
  382693:	lea    (%r8,%r9,4),%rax
  382697:	je     3826f1 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3a01>
  382699:	sub    %r9,%rcx
  38269c:	mov    %rcx,%rdx
  38269f:	lea    0x1(%rcx),%rcx
  3826a3:	cmp    $0x2,%rdx
  3826a7:	jbe    3826cb <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x39db>
  3826a9:	mov    %rcx,%rdx
  3826ac:	mov    $0xfeedface,%edi
  3826b1:	and    $0xfffffffffffffffc,%rdx
  3826b5:	vpbroadcastd %edi,%xmm0
  3826bb:	and    $0x3,%ecx
  3826be:	vmovdqu %xmm0,0x40(%r12,%r9,4)
  3826c5:	lea    (%rax,%rdx,4),%rax
  3826c9:	je     3826f1 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3a01>
  3826cb:	lea    0x4(%rax),%rdx
  3826cf:	movl   $0xfeedface,(%rax)
  3826d5:	cmp    %rdx,%rsi
  3826d8:	je     3826f1 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3a01>
  3826da:	lea    0x8(%rax),%rdx
  3826de:	movl   $0xfeedface,0x4(%rax)
  3826e5:	cmp    %rdx,%rsi
  3826e8:	je     3826f1 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3a01>
  3826ea:	movl   $0xfeedface,0x8(%rax)
  3826f1:	mov    -0x4c0(%rbp),%rax
  3826f8:	mov    -0x560(%rbp),%rcx
  3826ff:	mov    (%rax),%rdi
  382702:	mov    %r13,%rdx
  382705:	mov    $0x2,%esi
  38270a:	vzeroupper
  38270d:	call   *0x38(%rax)
  382710:	mov    -0x568(%rbp),%rsi
  382717:	mov    -0x4e0(%rbp),%rdi
  38271e:	call   3797f0 <raw32_stage3::GuardedOutput::Check(unsigned int const*) const>
  382723:	mov    -0x500(%rbp),%rsi
  38272a:	mov    %r12,%rdi
  38272d:	call   1906920 <operator delete(void*, unsigned long)@plt>
  382732:	jmp    3800b9 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x13c9>
  382737:	mov    %r8,%rax
  38273a:	xor    %r9d,%r9d
  38273d:	jmp    382699 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x39a9>
  382742:	mov    %r12,%rax
  382745:	xor    %ecx,%ecx
  382747:	jmp    3825d5 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x38e5>
  38274c:	movq   $0x0,-0x500(%rbp)
  382757:	jmp    38110a <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x241a>
  38275c:	mov    %r14,%rax
  38275f:	jmp    3821cf <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x34df>
  382764:	call   1906c80 <std::__throw_bad_alloc()@plt>
  382769:	mov    %rdx,-0x1a8(%rbp)
  382770:	mov    %r13,-0x198(%rbp)
  382777:	jmp    38259b <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x38ab>
  38277c:	mov    %r12,%rax
  38277f:	xor    %ecx,%ecx
  382781:	jmp    38252a <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x383a>
  382786:	mov    %r12,-0x1a8(%rbp)
  38278d:	mov    %r13,-0x198(%rbp)
  382794:	jmp    382629 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3939>
  382799:	lea    -0x309a2f(%rip),%rdi        # 78d71 <_IO_stdin_used+0x171d>
  3827a0:	call   1906a30 <std::__throw_length_error(char const*)@plt>
  3827a5:	lea    -0x309a3b(%rip),%rdi        # 78d71 <_IO_stdin_used+0x171d>
  3827ac:	call   1906a30 <std::__throw_length_error(char const*)@plt>
  3827b1:	lea    -0x309a47(%rip),%rdi        # 78d71 <_IO_stdin_used+0x171d>
  3827b8:	call   1906a30 <std::__throw_length_error(char const*)@plt>
  3827bd:	lea    -0x309a53(%rip),%rdi        # 78d71 <_IO_stdin_used+0x171d>
  3827c4:	call   1906a30 <std::__throw_length_error(char const*)@plt>
  3827c9:	lea    -0x309a5f(%rip),%rdi        # 78d71 <_IO_stdin_used+0x171d>
  3827d0:	call   1906a30 <std::__throw_length_error(char const*)@plt>
  3827d5:	lea    -0x309a6b(%rip),%rdi        # 78d71 <_IO_stdin_used+0x171d>
  3827dc:	call   1906a30 <std::__throw_length_error(char const*)@plt>
  3827e1:	mov    %rax,%rbx
  3827e4:	jmp    3827ed <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3afd>
  3827e6:	mov    %rax,%rbx
  3827e9:	jmp    382813 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3b23>
  3827eb:	jmp    3827e1 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3af1>
  3827ed:	mov    -0x390(%rbp),%rdi
  3827f4:	mov    -0x4b0(%rbp),%rax
  3827fb:	cmp    %rax,%rdi
  3827fe:	je     382813 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3b23>
  382800:	mov    -0x380(%rbp),%rax
  382807:	lea    0x1(%rax),%rsi
  38280b:	vzeroupper
  38280e:	call   1906920 <operator delete(void*, unsigned long)@plt>
  382813:	mov    -0x1b0(%rbp),%rdi
  38281a:	mov    -0x538(%rbp),%rax
  382821:	cmp    %rax,%rdi
  382824:	je     382839 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3b49>
  382826:	mov    -0x1a0(%rbp),%rax
  38282d:	lea    0x1(%rax),%rsi
  382831:	vzeroupper
  382834:	call   1906920 <operator delete(void*, unsigned long)@plt>
  382839:	mov    -0x3d0(%rbp),%rdi
  382840:	lea    -0x3c0(%rbp),%rax
  382847:	cmp    %rax,%rdi
  38284a:	je     38285f <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3b6f>
  38284c:	mov    -0x3c0(%rbp),%rax
  382853:	lea    0x1(%rax),%rsi
  382857:	vzeroupper
  38285a:	call   1906920 <operator delete(void*, unsigned long)@plt>
  38285f:	mov    -0x3f0(%rbp),%rdi
  382866:	mov    -0x518(%rbp),%rax
  38286d:	cmp    %rax,%rdi
  382870:	je     382885 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3b95>
  382872:	mov    -0x3e0(%rbp),%rax
  382879:	lea    0x1(%rax),%rsi
  38287d:	vzeroupper
  382880:	call   1906920 <operator delete(void*, unsigned long)@plt>
  382885:	lea    -0x328(%rbp),%r12
  38288c:	mov    -0x18(%r12),%rdi
  382891:	mov    -0x8(%r12),%rsi
  382896:	sub    $0x18,%r12
  38289a:	sub    %rdi,%rsi
  38289d:	test   %rdi,%rdi
  3828a0:	je     3828aa <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3bba>
  3828a2:	vzeroupper
  3828a5:	call   1906920 <operator delete(void*, unsigned long)@plt>
  3828aa:	mov    -0x5b8(%rbp),%rax
  3828b1:	cmp    %rax,%r12
  3828b4:	je     38291b <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3c2b>
  3828b6:	jmp    38288c <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3b9c>
  3828b8:	mov    %rax,%rbx
  3828bb:	jmp    3828c2 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3bd2>
  3828bd:	mov    %rax,%rbx
  3828c0:	jmp    3828cf <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3bdf>
  3828c2:	mov    %r12,%rdi
  3828c5:	vzeroupper
  3828c8:	call   19069e0 <__cxa_free_exception@plt>
  3828cd:	jmp    38285f <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3b6f>
  3828cf:	mov    %r12,%rdi
  3828d2:	vzeroupper
  3828d5:	call   19069e0 <__cxa_free_exception@plt>
  3828da:	mov    -0x4d8(%rbp),%rsi
  3828e1:	mov    %r14,%rdi
  3828e4:	vzeroupper
  3828e7:	call   1906920 <operator delete(void*, unsigned long)@plt>
  3828ec:	jmp    38285f <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3b6f>
  3828f1:	mov    %rax,%rbx
  3828f4:	jmp    382909 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3c19>
  3828f6:	mov    %rax,%r12
  3828f9:	jmp    3829f3 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3d03>
  3828fe:	mov    %r13,%rdi
  382901:	vzeroupper
  382904:	call   19069e0 <__cxa_free_exception@plt>
  382909:	mov    -0x518(%rbp),%rsi
  382910:	mov    %r12,%rdi
  382913:	vzeroupper
  382916:	call   1906920 <operator delete(void*, unsigned long)@plt>
  38291b:	mov    -0x410(%rbp),%rdi
  382922:	mov    -0x400(%rbp),%rsi
  382929:	sub    %rdi,%rsi
  38292c:	test   %rdi,%rdi
  38292f:	je     382939 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3c49>
  382931:	vzeroupper
  382934:	call   1906920 <operator delete(void*, unsigned long)@plt>
  382939:	mov    -0x610(%rbp),%rsi
  382940:	mov    -0x4b8(%rbp),%rax
  382947:	sub    %rax,%rsi
  38294a:	test   %rax,%rax
  38294d:	je     38295e <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3c6e>
  38294f:	mov    -0x4b8(%rbp),%rdi
  382956:	vzeroupper
  382959:	call   1906920 <operator delete(void*, unsigned long)@plt>
  38295e:	mov    -0x590(%rbp),%rdi
  382965:	mov    $0x4000,%esi
  38296a:	vzeroupper
  38296d:	call   1906920 <operator delete(void*, unsigned long)@plt>
  382972:	mov    -0x2d8(%rbp),%rdi
  382979:	mov    -0x2c8(%rbp),%rsi
  382980:	sub    %rdi,%rsi
  382983:	test   %rdi,%rdi
  382986:	je     382990 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3ca0>
  382988:	vzeroupper
  38298b:	call   1906920 <operator delete(void*, unsigned long)@plt>
  382990:	mov    -0x2f0(%rbp),%rdi
  382997:	mov    -0x2e0(%rbp),%rsi
  38299e:	sub    %rdi,%rsi
  3829a1:	test   %rdi,%rdi
  3829a4:	je     3829ae <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3cbe>
  3829a6:	vzeroupper
  3829a9:	call   1906920 <operator delete(void*, unsigned long)@plt>
  3829ae:	mov    -0x308(%rbp),%rdi
  3829b5:	mov    -0x2f8(%rbp),%rsi
  3829bc:	sub    %rdi,%rsi
  3829bf:	test   %rdi,%rdi
  3829c2:	je     3829cc <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3cdc>
  3829c4:	vzeroupper
  3829c7:	call   1906920 <operator delete(void*, unsigned long)@plt>
  3829cc:	mov    -0x320(%rbp),%rdi
  3829d3:	mov    -0x310(%rbp),%rsi
  3829da:	sub    %rdi,%rsi
  3829dd:	test   %rdi,%rdi
  3829e0:	je     382ab8 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3dc8>
  3829e6:	vzeroupper
  3829e9:	call   1906920 <operator delete(void*, unsigned long)@plt>
  3829ee:	jmp    382ab8 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3dc8>
  3829f3:	mov    %rbx,%rdi
  3829f6:	mov    %r14,%rsi
  3829f9:	vzeroupper
  3829fc:	mov    %r12,%rbx
  3829ff:	call   1906920 <operator delete(void*, unsigned long)@plt>
  382a04:	jmp    38295e <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3c6e>
  382a09:	mov    %rax,%rbx
  382a0c:	jmp    382ac7 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3dd7>
  382a11:	mov    %rax,%rbx
  382a14:	jmp    382ab8 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3dc8>
  382a19:	mov    %rax,%rbx
  382a1c:	jmp    382a92 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3da2>
  382a1e:	mov    $0x10,%edi
  382a23:	call   1906930 <__cxa_allocate_exception@plt>
  382a28:	mov    %rax,%rdi
  382a2b:	lea    -0x30a172(%rip),%rsi        # 788c0 <_IO_stdin_used+0x126c>
  382a32:	mov    %rax,%r12
  382a35:	call   19069d0 <std::runtime_error::runtime_error(char const*)@plt>
  382a3a:	mov    0x15ac0e7(%rip),%rdx        # 192eb28 <std::runtime_error::~runtime_error()@GLIBCXX_3.4>
  382a41:	lea    0x15ac198(%rip),%rsi        # 192ebe0 <typeinfo for std::runtime_error@GLIBCXX_3.4>
  382a48:	mov    %r12,%rdi
  382a4b:	call   1906940 <__cxa_throw@plt>
  382a50:	mov    %rax,%rbx
  382a53:	jmp    38295e <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3c6e>
  382a58:	mov    %rax,%rbx
  382a5b:	jmp    382939 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3c49>
  382a60:	mov    $0x10,%edi
  382a65:	call   1906930 <__cxa_allocate_exception@plt>
  382a6a:	mov    %rax,%rdi
  382a6d:	lea    -0x30a5c6(%rip),%rsi        # 784ae <_IO_stdin_used+0xe5a>
  382a74:	mov    %rax,%r12
  382a77:	call   19069d0 <std::runtime_error::runtime_error(char const*)@plt>
  382a7c:	mov    0x15ac0a5(%rip),%rdx        # 192eb28 <std::runtime_error::~runtime_error()@GLIBCXX_3.4>
  382a83:	lea    0x15ac156(%rip),%rsi        # 192ebe0 <typeinfo for std::runtime_error@GLIBCXX_3.4>
  382a8a:	mov    %r12,%rdi
  382a8d:	call   1906940 <__cxa_throw@plt>
  382a92:	mov    -0x1b0(%rbp),%rdi
  382a99:	mov    -0x538(%rbp),%rax
  382aa0:	cmp    %rax,%rdi
  382aa3:	je     382ab8 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3dc8>
  382aa5:	mov    -0x1a0(%rbp),%rax
  382aac:	lea    0x1(%rax),%rsi
  382ab0:	vzeroupper
  382ab3:	call   1906920 <operator delete(void*, unsigned long)@plt>
  382ab8:	mov    -0x530(%rbp),%rdi
  382abf:	vzeroupper
  382ac2:	call   37a7d0 <std::vector<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > >, std::allocator<std::pair<std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > > > >::~vector()>
  382ac7:	mov    -0x608(%rbp),%rdi
  382ace:	vzeroupper
  382ad1:	call   379b00 <raw32_stage3::Geometry::~Geometry()>
  382ad6:	mov    %rbx,%rdi
  382ad9:	call   19069b0 <_Unwind_Resume@plt>
  382ade:	jmp    3828b8 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3bc8>
  382ae3:	jmp    3828b8 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3bc8>
  382ae8:	mov    %rax,%rbx
  382aeb:	jmp    382af2 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3e02>
  382aed:	jmp    3828b8 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3bc8>
  382af2:	mov    -0x1b0(%rbp),%rdi
  382af9:	lea    -0x1a0(%rbp),%rax
  382b00:	cmp    %rax,%rdi
  382b03:	jne    382aa5 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3db5>
  382b05:	jmp    382ab8 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3dc8>
  382b07:	mov    %rax,%rbx
  382b0a:	jmp    382972 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3c82>
  382b0f:	mov    %rax,%r13
  382b12:	jmp    382b19 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3e29>
  382b14:	jmp    3828b8 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3bc8>
  382b19:	mov    %rbx,%rdi
  382b1c:	vzeroupper
  382b1f:	mov    %r13,%rbx
  382b22:	call   19069e0 <__cxa_free_exception@plt>
  382b27:	jmp    382909 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3c19>
  382b2c:	mov    %rax,%rbx
  382b2f:	jmp    382b5c <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3e6c>
  382b31:	mov    %rax,%rbx
  382b34:	jmp    382b9a <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3eaa>
  382b36:	mov    -0x390(%rbp),%rdi
  382b3d:	mov    -0x4b0(%rbp),%rax
  382b44:	cmp    %rax,%rdi
  382b47:	je     382b5c <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3e6c>
  382b49:	mov    -0x380(%rbp),%rax
  382b50:	lea    0x1(%rax),%rsi
  382b54:	vzeroupper
  382b57:	call   1906920 <operator delete(void*, unsigned long)@plt>
  382b5c:	mov    -0x4e0(%rbp),%rdi
  382b63:	vzeroupper
  382b66:	call   1906b90 <std::__cxx11::basic_ostringstream<char, std::char_traits<char>, std::allocator<char> >::~basic_ostringstream()@plt>
  382b6b:	mov    -0x3b0(%rbp),%rdi
  382b72:	mov    -0x510(%rbp),%rax
  382b79:	cmp    %rax,%rdi
  382b7c:	je     382839 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3b49>
  382b82:	mov    -0x3a0(%rbp),%rax
  382b89:	lea    0x1(%rax),%rsi
  382b8d:	vzeroupper
  382b90:	call   1906920 <operator delete(void*, unsigned long)@plt>
  382b95:	jmp    382839 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3b49>
  382b9a:	mov    -0x500(%rbp),%rdi
  382ba1:	vzeroupper
  382ba4:	call   37a3c0 <std::__cxx11::basic_stringbuf<char, std::char_traits<char>, std::allocator<char> >::~basic_stringbuf()>
  382ba9:	mov    %r14,-0x1b0(%rbp)
  382bb0:	mov    0x15ac1d9(%rip),%rcx        # 192ed90 <VTT for std::__cxx11::basic_ostringstream<char, std::char_traits<char>, std::allocator<char> >+0x10>
  382bb7:	mov    -0x18(%r14),%rax
  382bbb:	mov    %rcx,-0x1b0(%rbp,%rax,1)
  382bc3:	mov    %r12,-0x140(%rbp)
  382bca:	mov    -0x4d0(%rbp),%rdi
  382bd1:	vzeroupper
  382bd4:	call   1906b70 <std::ios_base::~ios_base()@plt>
  382bd9:	jmp    382b6b <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3e7b>
  382bdb:	mov    %rax,%rbx
  382bde:	jmp    382bc3 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3ed3>
  382be0:	mov    %rax,%rbx
  382be3:	jmp    382c2d <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3f3d>
  382be5:	jmp    3827e1 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3af1>
  382bea:	jmp    3827e6 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3af6>
  382bef:	jmp    3827e1 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3af1>
  382bf4:	jmp    3827e1 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3af1>
  382bf9:	jmp    3827e6 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3af6>
  382bfe:	mov    %rax,%rbx
  382c01:	jmp    382b6b <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3e7b>
  382c06:	mov    %rax,%rbx
  382c09:	jmp    382c95 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3fa5>
  382c0e:	jmp    3827e6 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3af6>
  382c13:	jmp    3827e6 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3af6>
  382c18:	mov    %rax,%rbx
  382c1b:	jmp    382b36 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3e46>
  382c20:	mov    %rax,%rbx
  382c23:	jmp    382cc4 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3fd4>
  382c28:	jmp    3827e1 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3af1>
  382c2d:	mov    -0x390(%rbp),%rdi
  382c34:	mov    -0x4b0(%rbp),%rax
  382c3b:	cmp    %rax,%rdi
  382c3e:	je     382c53 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3f63>
  382c40:	mov    -0x380(%rbp),%rax
  382c47:	lea    0x1(%rax),%rsi
  382c4b:	vzeroupper
  382c4e:	call   1906920 <operator delete(void*, unsigned long)@plt>
  382c53:	mov    -0x1b0(%rbp),%rdi
  382c5a:	mov    -0x538(%rbp),%rax
  382c61:	cmp    %rax,%rdi
  382c64:	je     382c79 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3f89>
  382c66:	mov    -0x1a0(%rbp),%rax
  382c6d:	lea    0x1(%rax),%rsi
  382c71:	vzeroupper
  382c74:	call   1906920 <operator delete(void*, unsigned long)@plt>
  382c79:	test   %r12,%r12
  382c7c:	je     382839 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3b49>
  382c82:	mov    %r13,%rsi
  382c85:	mov    %r12,%rdi
  382c88:	vzeroupper
  382c8b:	call   1906920 <operator delete(void*, unsigned long)@plt>
  382c90:	jmp    382839 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3b49>
  382c95:	mov    -0x1b0(%rbp),%rdi
  382c9c:	mov    -0x538(%rbp),%rax
  382ca3:	cmp    %rax,%rdi
  382ca6:	je     38285f <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3b6f>
  382cac:	mov    -0x1a0(%rbp),%rax
  382cb3:	lea    0x1(%rax),%rsi
  382cb7:	vzeroupper
  382cba:	call   1906920 <operator delete(void*, unsigned long)@plt>
  382cbf:	jmp    38285f <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3b6f>
  382cc4:	mov    -0x390(%rbp),%rdi
  382ccb:	mov    -0x4b0(%rbp),%rax
  382cd2:	cmp    %rax,%rdi
  382cd5:	je     382b6b <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3e7b>
  382cdb:	mov    -0x380(%rbp),%rax
  382ce2:	lea    0x1(%rax),%rsi
  382ce6:	vzeroupper
  382ce9:	call   1906920 <operator delete(void*, unsigned long)@plt>
  382cee:	jmp    382b6b <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3e7b>
  382cf3:	mov    %rax,%rbx
  382cf6:	mov    -0x500(%rbp),%rsi
  382cfd:	mov    %r12,%rdi
  382d00:	vzeroupper
  382d03:	call   1906920 <operator delete(void*, unsigned long)@plt>
  382d08:	jmp    38291b <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3c2b>
  382d0d:	mov    %rax,%rbx
  382d10:	jmp    3828fe <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3c0e>
  382d15:	mov    %rax,%rbx
  382d18:	jmp    38285f <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3b6f>
  382d1d:	jmp    382d0d <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x401d>
  382d1f:	mov    %rax,%r12
  382d22:	jmp    382d56 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x4066>
  382d24:	mov    $0x10,%edi
  382d29:	call   1906930 <__cxa_allocate_exception@plt>
  382d2e:	mov    %rax,%rdi
  382d31:	lea    -0x30a1ff(%rip),%rsi        # 78b39 <_IO_stdin_used+0x14e5>
  382d38:	mov    %rax,%r12
  382d3b:	call   19069d0 <std::runtime_error::runtime_error(char const*)@plt>
  382d40:	mov    0x15abde1(%rip),%rdx        # 192eb28 <std::runtime_error::~runtime_error()@GLIBCXX_3.4>
  382d47:	lea    0x15abe92(%rip),%rsi        # 192ebe0 <typeinfo for std::runtime_error@GLIBCXX_3.4>
  382d4e:	mov    %r12,%rdi
  382d51:	call   1906940 <__cxa_throw@plt>
  382d56:	mov    %rbx,%rdi
  382d59:	vzeroupper
  382d5c:	mov    %r12,%rbx
  382d5f:	call   19069e0 <__cxa_free_exception@plt>
  382d64:	jmp    38285f <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3b6f>
  382d69:	mov    %rax,%rbx
  382d6c:	jmp    382d7b <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x408b>
  382d6e:	mov    %rax,%rbx
  382d71:	jmp    382d86 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x4096>
  382d73:	mov    %rax,%rbx
  382d76:	jmp    38291b <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3c2b>
  382d7b:	mov    %r12,%rdi
  382d7e:	vzeroupper
  382d81:	call   19069e0 <__cxa_free_exception@plt>
  382d86:	mov    -0x610(%rbp),%rsi
  382d8d:	mov    -0x4b8(%rbp),%rax
  382d94:	sub    %rax,%rsi
  382d97:	jmp    38294f <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3c5f>
  382d9c:	jmp    382a11 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3d21>
  382da1:	jmp    382be0 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3ef0>
  382da6:	mov    %rax,%rbx
  382da9:	jmp    382c53 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3f63>
  382dae:	mov    %rax,%rbx
  382db1:	jmp    382c79 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3f89>
  382db6:	mov    %rax,%rbx
  382db9:	jmp    3828da <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3bea>
  382dbe:	mov    $0x10,%edi
  382dc3:	call   1906930 <__cxa_allocate_exception@plt>
  382dc8:	mov    %rax,%rdi
  382dcb:	lea    -0x309d23(%rip),%rsi        # 790af <_IO_stdin_used+0x1a5b>
  382dd2:	mov    %rax,%r12
  382dd5:	call   19069d0 <std::runtime_error::runtime_error(char const*)@plt>
  382dda:	mov    0x15abd47(%rip),%rdx        # 192eb28 <std::runtime_error::~runtime_error()@GLIBCXX_3.4>
  382de1:	lea    0x15abdf8(%rip),%rsi        # 192ebe0 <typeinfo for std::runtime_error@GLIBCXX_3.4>
  382de8:	mov    %r12,%rdi
  382deb:	call   1906940 <__cxa_throw@plt>
  382df0:	mov    %rax,%rbx
  382df3:	jmp    382839 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3b49>
  382df8:	jmp    382c06 <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3f16>
  382dfd:	jmp    3828bd <raw32_stage3::RunObject(char const*, raw32_stage3::Args const&, raw32_stage3::AnyFilter const&)+0x3bcd>
