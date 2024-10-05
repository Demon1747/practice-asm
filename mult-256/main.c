#include <stdlib.h>

#define mul256(res, mul1, mul2) c_mul256(res, mul1, mul2)

uint64_t etalon_a[] = { 0xDEADBEEF, 0x1234567890ABCDEF };
uint64_t etalon_b[] = { 0x1234567890ABCDEF, 0x1};
uint64_t etalon_res[] = {};

void arm64_mul256(uint64_t* res, uint64_t* mul1, uint64_t* mul2);

void c_mul256(uint64_t* res, uint64_t* mul1, uint64_t* mul2) {
  
}

int main() {
  uint64_t mul_a[2];
  uint64_t mul_b[2];
  uint64_t mul_res[4];
  int result = 0;

  // etalon test
  mul256(mul_res, etalon_a, etalon_b);

  result = memcmp(mul_res, etalon_res, sizeof(etalon_res) * sizeof(uint64_t));
  if (result != 0) {
    return -1;
  }

  // init PRSG
  srand(2024);

  printf("%x", RAND_MAX);
  
  for (size_t i = 0; i < 10000; ++i) {
    mul_a[0] = rand();
    mul_a[1] = rand();

    mul_b[0] = rand();
    mul_b[1] = rand();

    mul256(mul_res, mul_a, mul_b);
  }
    
  return 0;
}

