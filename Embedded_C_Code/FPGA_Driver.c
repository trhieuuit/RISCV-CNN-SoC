// Created by: Hieu
// Created on: 2026-03-31
// Description: FPGA Driver for Custom RV32I Core using Linux UIO Subsystem

#include <sys/types.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <errno.h>\

#ifndef _GNU_SOURCE
#define _GNU_SOURCE
#endif
#include <dirent.h>

#ifndef alphasort
#define alphasort(x, y) strcoll((*(struct dirent **)x)->d_name, (*(struct dirent **)y)->d_name)
#endif


#define REG_MMAP_SIZE     0x00200000LL 

#define UIO_TARGET_NAME   "MY_IP\n"

typedef uint64_t U64;
typedef uint32_t U32;

// Global FPGA info structure
volatile struct {
    U32* pio_32_mmap;    // Mapped virtual address to access registers
} RV32I_info;

// Helper: Bỏ qua các file ẩn (bắt đầu bằng '.')
static int filter(const struct dirent* dir) {
    return dir->d_name[0] == '.' ? 0 : 1;
}

// Helper: Xóa ký tự xuống dòng
static void trim(char* d_name) {
    char* p = strchr(d_name, '\n');
    if (p != NULL) *p = '\0';
}

// Helper: Đọc file 'name' trong sysfs để xem có đúng thiết bị RV32I không
static int is_target_dev(char* d_name, const char* target) {
    char path[128], name[64];
    FILE* fp;

    snprintf(path, sizeof(path), "/sys/class/uio/%s/name", d_name);
    fp = fopen(path, "r");
    if (fp == NULL) return 0;

    if (fgets(name, sizeof(name), fp) == NULL) {
        fclose(fp);
        return 0;
    }

    fclose(fp);
    return strcmp(name, target) == 0;
}

// Open FPGA device and memory map register space
int fpga_open() {
    struct dirent** namelist;
    int num_dirs;
    char path[128];
    int fd_reg = -1;

    // Quét toàn bộ các thiết bị UIO đang có trên Linux
    num_dirs = scandir("/sys/class/uio", &namelist, filter, alphasort);
    if (num_dirs == -1) {
        perror(" LỖI: Không thể đọc thư mục /sys/class/uio.");
        return -1;
    }

    for (int dir = 0; dir < num_dirs; ++dir) {
        trim(namelist[dir]->d_name);

        // Nếu đúng tên UIO_TARGET_NAME
        if (is_target_dev(namelist[dir]->d_name, UIO_TARGET_NAME)) {
            snprintf(path, sizeof(path), "/dev/%s", namelist[dir]->d_name);
            free(namelist[dir]);

            fd_reg = open(path, O_RDWR | O_SYNC);
            if (fd_reg == -1) {
                perror("LỖI: Mở thiết bị UIO thất bại");
                free(namelist);
                return -1;
            }

            printf("[Driver] Đã tìm thấy thiết bị: %s (%s", path, UIO_TARGET_NAME);
            printf("[Driver] Đang ánh xạ bộ nhớ (mmap)...\n");


            RV32I_info.pio_32_mmap = (U32*)mmap(NULL, REG_MMAP_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, fd_reg, 0);

            if (RV32I_info.pio_32_mmap == MAP_FAILED) {
                perror("LỖI: mmap UIO thất bại");
                close(fd_reg);
                free(namelist);
                return -1;
            }

            close(fd_reg); // Safe to close after mmap
            break;// Found the device, break the loop 
        }
        free(namelist[dir]);
    }

    free(namelist);

    if (fd_reg == -1) {
        fprintf(stderr, "LỖI: Không tìm thấy thiết bị có tên '%s' trong hệ thống UIO!\n", UIO_TARGET_NAME);
        return -1;
    }

    return 1;
}