#include <memory.h>
#include <stdint.h>
#include <stdlib.h>

#define LOW_32_MASK 0xFFFFFFFF
#define HIGH_32_MASK 0xFFFFFFFF00000000

#define mul128(res, mul1, mul2) c_mul128(res, mul1, mul2)
//#define mul128(res, mul1, mul2) x64_mul128(res, mul1, mul2)
//#define mul128(res, mul1, mul2) arn64_mul128(res, mul1, mul2)

// constants for etalon test
uint64_t etalon_a[] = {0xCAFEB0BADEADBEEF, 0x1234567890ABCDEF};
uint64_t etalon_b[] = {0x0D15EA5EB00000BA, 0xBAAAAAADDEADC0DE};
uint64_t etalon_res[] = {0x57116CCC1A3CB9A6, 0x2E81A234FF775817,
                         0xDDAFA27AA7E3A362, 0x0D4629B823CD2354};

// prototypes for different assembly functions
void x64_mul128(uint64_t* res, uint64_t* mul1, uint64_t* mul2);
void arm64_mul128(uint64_t* res, uint64_t* mul1, uint64_t* mul2);

void c_mul64(uint64_t* res, uint64_t mul1, uint64_t mul2) {
  uint64_t lo_a = mul1 & LOW_32_MASK;
  uint64_t hi_a = mul1 >> 0x20;
  uint64_t lo_b = mul2 & LOW_32_MASK;
  uint64_t hi_b = mul2 >> 0x20;
  uint64_t res_32_96;

  uint64_t tmp_0_1 = lo_a * hi_b;              // 0 * 1
  uint64_t tmp_32_96 = tmp_0_1 + hi_a * lo_b;  // 1 * 0
  uint64_t carry = tmp_32_96 < tmp_0_1 ? 1 : 0;

  res[0] = lo_a * lo_b;  // 0 * 0
  res[1] = hi_a * hi_b;  // 1 * 1

  res_32_96 = (res[1] << 0x20) | (res[0] >> 0x20);
  res_32_96 += tmp_32_96;
  if (res_32_96 < tmp_32_96) {
    ++carry;
  }

  res[0] = (res_32_96 << 0x20) | (res[0] & LOW_32_MASK);
  res[1] =
      ((res[1] & HIGH_32_MASK) + (carry << 0x20)) | (res_32_96 >> 0x20);
}

void c_mul128(uint64_t* res, uint64_t* mul1, uint64_t* mul2) {
  uint64_t tmp_64_192[2];
  uint64_t res_64_192[2];
  uint64_t carry = 0;

  // 0 * 0
  c_mul64(res, mul1[0], mul2[0]);

  // 1 * 1
  c_mul64((res + 2), mul1[1], mul2[1]);

  // 0 * 1
  c_mul64(tmp_64_192, mul1[0], mul2[1]);

  // 1 * 0
  c_mul64(res_64_192, mul1[1], mul2[0]);

  res_64_192[0] += tmp_64_192[0];
  if (res_64_192[0] < tmp_64_192[0]) {
    ++carry;
  }

  res[1] += res_64_192[0];
  if (res[1] < res_64_192[0]) {
    ++carry;
  }

  res_64_192[1] += carry;
  carry = res_64_192[1] < carry ? 1 : 0;

  res_64_192[1] += tmp_64_192[1];
  if (res_64_192[1] < tmp_64_192[1]) {
    ++carry;
  }

  res[2] += res_64_192[1];
  if (res[2] < res_64_192[1]) {
    ++carry;
  }

  res[3] += carry;
}

int main() {
  uint64_t mul_a[2];
  uint64_t mul_b[2];
  uint64_t mul_res[4];
  int result = 0;

  // etalon test
  mul128(mul_res, etalon_a, etalon_b);

  result = memcmp(mul_res, etalon_res, sizeof(etalon_res));
  if (result != 0) {
    return -1;
  }

  // init PRSG
  srand(2024);

  // performance test
  for (size_t i = 0; i < 10000000; ++i) {
    mul_a[0] = ((uint64_t)rand() << 0x20) | rand();
    mul_a[1] = ((uint64_t)rand() << 0x20) | rand();
    mul_b[0] = ((uint64_t)rand() << 0x20) | rand();
    mul_b[1] = ((uint64_t)rand() << 0x20) | rand();
    
    mul128(mul_res, mul_a, mul_b);
  }

  return 0;
}

