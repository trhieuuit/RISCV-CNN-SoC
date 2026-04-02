void main() {
    int n = 10;
    int sum = 0;

    for (int i = 1; i <= n; i++) {
        sum += i;
    }


    volatile int* result_addr = (int*)0x0004;
    *result_addr = sum; // Result is 55 (Hex: 0x37)
}