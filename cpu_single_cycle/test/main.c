int main() {
    int n = 5;
    int res = 1;

    // Vòng lặp giai thừa thay cho đệ quy để tiết kiệm Stack
    for (int i = 1; i <= n; i++) {
        // Tự viết logic nhân trực tiếp để tránh gọi hàm tốn kém
        int a = res;
        int b = i;
        int temp_res = 0;
        while (b > 0) {
            if (b & 1) temp_res += a;
            a <<= 1;
            b >>= 1;
        }
        res = temp_res;
    }

    volatile int* output = (int*)20;
    *output = res; // Ghi kết quả 120 (0x78) vào RAM[5]
    return 0;
}