.global arm64_mul128

.text

// args: x0 - res ptr, x1 - mul1 ptr, x2 - mul2 ptr
arm64_mul128:
	ldp	x3, x4, [x1]		// local factor 1
	ldp	x5, x6, [x2]		// local factor 2

	mul	x7, x3, x5		// res[0] = 0 * 0 (0:63) -- final res[0]
	umulh	x8, x3, x5		// res[1] = 0 * 0 (64:127)

	mul	x1, x4, x5		// 1 * 0 (0:63)
	adds	x8, x8, x1		// res[1] += 1 * 0 (0:63)
	umulh	x9, x4, x5		// res[2] = 1 * 0 (64:127)

	mul	x2, x4, x6		// 1 * 1 (0:63)
	adcs	x9, x9, x2		// res[2] += 1 * 1 (0:63) + carry flag
	umulh	x10, x4, x6		// res[3] = 1 * 1 (64:127)
	adc	x10, x10, xzr		// res[3] += carry flag

	mul	x1, x3, x6		// 0 * 1 (0:63)
	adds	x8, x8, x1		// res[1] += 0 * 1 (0:63) -- final res[1]
	umulh	x2, x3, x6		// 0 * 1 (64:127)
	stp	x7, x8, [x0], #16

	adcs	x9, x9, x2		// res[2] += 0 * 1 (64:127) + carry flag -- final res[2]
	adc	x10, x10, xzr		// res[3] += carry flag
	stp	x9, x10, [x0]
	ret

