.section .text
.global _start

_start:
    # Khởi tạo Stack Pointer trỏ vào cuối RAM (giả sử RAM bạn có 128 byte)
    li sp, 128          
    jal main            # Nhảy vào hàm main của C
1:  j 1b                # Vòng lặp vô tận nếu main chạy xong