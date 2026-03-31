// File: main.c
// Tính tổng từ 1 đến 10 và ghi vào DMEM để ARM lấy

void main() {
    // Khai báo cục bộ -> GCC sẽ nhét biến vào Stack (DMEM)
    int n = 10;
    int sum = 0;

    // Thuật toán
    for (int i = 1; i <= n; i++) {
        sum += i;
    }

    // GHI KẾT QUẢ VÀO DMEM 
    // ARM đang chờ đọc ở địa chỉ DMEM + offset (ví dụ 0xA0010004 -> offset là 4)
    // Với góc nhìn của RISC-V, địa chỉ đó chính là 0x0004
    volatile int* result_addr = (int*)0x0004;
    *result_addr = sum; // Kết quả phải là 55 (Hex: 0x37)
}