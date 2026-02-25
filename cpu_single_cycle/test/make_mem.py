import os

# Tên file bin đầu vào
bin_file = "program.bin"
mem_file = "machine_code.mem"

if os.path.exists(bin_file):
    with open(bin_file, "rb") as f:
        data = f.read()
    
    with open(mem_file, "w") as f:
        for i in range(0, len(data), 4):
            word = data[i:i+4]
            if len(word) == 4:
                # Chuyển 4 byte thành số 32-bit (Little Endian)
                val = int.from_bytes(word, byteorder='little')
                f.write(f"{val:032b}\n")
    print(f"Thành công! Đã tạo {mem_file}")
else:
    print("Không tìm thấy file .bin")