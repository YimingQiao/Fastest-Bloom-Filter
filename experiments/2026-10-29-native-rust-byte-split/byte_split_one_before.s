	.file	"assembly.f006f78af719f5bf-cgu.0"
	.section	.rodata.cst32,"aM",@progbits,32
	.p2align	5, 0x0
.LCPI0_0:
	.short	23659
	.short	0
	.short	40700
	.short	0
	.short	11761
	.short	0
	.short	28755
	.short	0
	.short	41655
	.short	0
	.short	34851
	.short	0
	.short	17559
	.short	0
	.short	18357
	.short	0
.LCPI0_5:
	.short	0
	.short	1
	.short	2
	.short	3
	.short	4
	.short	5
	.short	6
	.short	7
	.short	8
	.short	1
	.short	10
	.short	3
	.short	12
	.short	5
	.short	14
	.short	3
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
.LCPI0_1:
	.long	7
	.long	7
	.long	6
	.long	6
	.long	5
	.long	5
	.long	4
	.long	4
	.long	3
	.long	3
	.long	2
	.long	2
	.long	1
	.long	1
	.long	0
	.long	0
.LCPI0_2:
	.long	16
	.long	24
	.long	16
	.long	24
	.long	16
	.long	24
	.long	16
	.long	24
	.long	16
	.long	24
	.long	16
	.long	24
	.long	16
	.long	24
	.long	16
	.long	24
	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4, 0x0
.LCPI0_3:
	.zero	16,7
.LCPI0_4:
	.byte	128
	.byte	64
	.byte	32
	.byte	16
	.byte	8
	.byte	4
	.byte	2
	.byte	1
	.zero	1
	.zero	1
	.zero	1
	.zero	1
	.zero	1
	.zero	1
	.zero	1
	.zero	1
.LCPI0_6:
	.short	18357
	.short	17559
	.short	34851
	.short	41655
	.short	28755
	.short	11761
	.short	40700
	.short	23659
.LCPI0_7:
	.byte	128
	.byte	64
	.byte	32
	.byte	16
	.byte	8
	.byte	4
	.byte	2
	.byte	1
	.byte	128
	.byte	64
	.byte	32
	.byte	16
	.byte	8
	.byte	4
	.byte	2
	.byte	1
.LCPI0_10:
	.byte	128
	.byte	64
	.byte	32
	.byte	16
	.byte	8
	.byte	4
	.byte	2
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3, 0x0
.LCPI0_8:
	.byte	128
	.byte	64
	.byte	32
	.byte	16
	.byte	8
	.byte	4
	.byte	2
	.byte	1
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
.LCPI0_9:
	.zero	4,7
	.section	.text.byte_split_one,"ax",@progbits
	.globl	byte_split_one
	.p2align	4
	.type	byte_split_one,@function
byte_split_one:
	.cfi_startproc
	movq	%rdi, %rax
	movq	%rsi, %rdx
	shrq	$32, %rdx
	cmpb	$0, 28(%rdi)
	je	.LBB0_1
	andl	24(%rax), %edx
	movl	%edx, %ecx
	shrl	$2, %ecx
	shlq	$6, %rcx
	addq	8(%rax), %rcx
	shll	$4, %edx
	andl	$48, %edx
	vmovdqa	(%rdx,%rcx), %xmm0
	vpbroadcastd	%esi, %xmm1
	vpmulhw	.LCPI0_6(%rip), %xmm1, %xmm1
	vpbroadcastq	.LCPI0_8(%rip), %xmm2
	vpshufb	%xmm1, %xmm2, %xmm1
	vptest	%xmm1, %xmm0
	setb	%al
	retq
.LBB0_1:
	andl	24(%rax), %edx
	movl	%edx, %edi
	shrl	$2, %edi
	movq	16(%rax), %rcx
	cmpq	%rcx, %rdi
	jae	.LBB0_5
	shlq	$6, %rdi
	addq	8(%rax), %rdi
	shll	$4, %edx
	vmovd	%esi, %xmm0
	shll	$16, %esi
	vpinsrd	$1, %esi, %xmm0, %xmm0
	andl	$48, %edx
	vpsrad	$16, %xmm0, %xmm0
	vpbroadcastq	%xmm0, %ymm1
	vmovd	%xmm0, %ecx
	vpextrd	$1, %xmm0, %eax
	testl	%eax, %eax
	setg	%al
	sets	%sil
	testl	%ecx, %ecx
	sets	%r8b
	vpmaddwd	.LCPI0_0(%rip), %ymm1, %ymm0
	vmovdqa64	.LCPI0_1(%rip), %zmm1
	vpermd	%zmm0, %zmm1, %zmm0
	vpsrlvd	.LCPI0_2(%rip), %zmm0, %zmm0
	vpmovdb	%zmm0, %xmm0
	setg	%cl
	vpandd	.LCPI0_9(%rip){1to4}, %xmm0, %xmm1
	vmovq	.LCPI0_10(%rip), %xmm2
	vpxor	%xmm3, %xmm3, %xmm3
	movw	$-3, %r9w
	kmovd	%r9d, %k1
	vpcmpgtb	%xmm0, %xmm3, %k0 {%k1}
	kmovd	%esi, %k1
	kshiftlw	$15, %k1, %k1
	kshiftrw	$14, %k1, %k1
	korw	%k1, %k0, %k0
	movw	$-9, %si
	kmovd	%esi, %k1
	kandw	%k1, %k0, %k0
	kmovd	%r8d, %k1
	kshiftlw	$15, %k1, %k1
	kshiftrw	$12, %k1, %k1
	korw	%k1, %k0, %k0
	movw	$-33, %si
	kmovd	%esi, %k1
	kandw	%k1, %k0, %k0
	kmovd	%eax, %k1
	kshiftlw	$15, %k1, %k1
	kshiftrw	$10, %k1, %k1
	korw	%k1, %k0, %k0
	movw	$-129, %ax
	kmovd	%eax, %k1
	kandw	%k1, %k0, %k0
	kmovd	%ecx, %k1
	kshiftlw	$15, %k1, %k1
	kshiftrw	$8, %k1, %k1
	korw	%k1, %k0, %k0
	vpmovm2w	%k0, %ymm0
	vmovdqa	.LCPI0_5(%rip), %ymm3
	vpermw	%ymm0, %ymm3, %ymm0
	vpmovw2m	%ymm0, %k0
	knotw	%k0, %k1
	vpshufb	%xmm1, %xmm2, %xmm0 {%k1} {z}
	vmovdqu	(%rdx,%rdi), %xmm1
	vptest	%xmm0, %xmm1
	setb	%al
	vzeroupper
	retq
.LBB0_5:
	pushq	%rax
	.cfi_def_cfa_offset 16
	leaq	.Lanon.552f932ca4f7316e56b85f7b4f65cd43.1(%rip), %rdx
	movq	%rcx, %rsi
	callq	*_ZN4core9panicking18panic_bounds_check17h91fb439f93b2e326E@GOTPCREL(%rip)
.Lfunc_end0:
	.size	byte_split_one, .Lfunc_end0-byte_split_one
	.cfi_endproc

	.type	.Lanon.552f932ca4f7316e56b85f7b4f65cd43.0,@object
	.section	.rodata.str1.1,"aMS",@progbits,1
.Lanon.552f932ca4f7316e56b85f7b4f65cd43.0:
	.asciz	"/home/yiming/projects/fastest-bf-lab/rust/src/byte_split.rs"
	.size	.Lanon.552f932ca4f7316e56b85f7b4f65cd43.0, 60

	.type	.Lanon.552f932ca4f7316e56b85f7b4f65cd43.1,@object
	.section	.data.rel.ro..Lanon.552f932ca4f7316e56b85f7b4f65cd43.1,"aw",@progbits
	.p2align	3, 0x0
.Lanon.552f932ca4f7316e56b85f7b4f65cd43.1:
	.quad	.Lanon.552f932ca4f7316e56b85f7b4f65cd43.0
	.asciz	";\000\000\000\000\000\000\000d\000\000\000\037\000\000"
	.size	.Lanon.552f932ca4f7316e56b85f7b4f65cd43.1, 24

	.ident	"rustc version 1.92.0 (ded5c06cf 2025-12-08)"
	.section	".note.GNU-stack","",@progbits
