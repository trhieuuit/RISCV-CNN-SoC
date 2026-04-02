// File: run_cpu.c
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <unistd.h>

#include "./FPGA_Driver.c" // call fpga driver


//  Address in Write Channel
#define IMEM_OFFSET         (0x00000000 >> 2) // IMEM (0xA000_0000)
#define DMEM_OFFSET         (0x00010000 >> 2) // DMEM (0xA001_0000)
#define START_BASE_PHYS     ((0x00100000 + 0x0000) >> 2) // GPIO Channel 1 

//  Address in Read Channel
#define Y_RESULT_OFFSET     ((0x00010000 + 0x0004) >> 2) // 0x04
#define DONE_BASE_PHYS      ((0x00100000 + 0x0008) >> 2) // GPIO Channel 2 
// =========================================================================

// Function supports loading firmware from .bin file to IMEM via UIO pointer
int load_firmware(const char* filename) {
    FILE* bin_file = fopen(filename, "rb");
    if (!bin_file) return 0;

    fseek(bin_file, 0, SEEK_END);
    long file_size = ftell(bin_file);
    rewind(bin_file);

    int num_instructions = file_size / 4;
    uint32_t* temp_buffer = (uint32_t*)malloc(file_size);
    fread(temp_buffer, 1, file_size, bin_file);
    fclose(bin_file);


    for (int i = 0; i < num_instructions; i++) {
        *(RV32I_info.pio_32_mmap + IMEM_OFFSET + i) = temp_buffer[i];
    }
    free(temp_buffer);
    return file_size;
}

int main() {
    if (fpga_open() != 1) {
        fprintf(stderr, "Failed to open FPGA device.\n");
        exit(EXIT_FAILURE);
    }

    if (load_firmware("firmware.bin") == 0) {
        fprintf(stderr, "Error: 'firmware.bin' not found.\n");
        exit(EXIT_FAILURE);
    }
    printf("Success\n");

    char input[32];

    // 3. Vòng lặp điều khiển
    while (1) {
        printf("\n=== RV32I Core Controller ===\n");
        printf("Enter 'q' to quit, 'r' to RUN Core.\n");
        printf("Your choice: ");
        fgets(input, sizeof(input), stdin);

        if (input[0] == 'q' || input[0] == 'Q') {
            printf("Exiting program.\n");
            break;
        } else if (input[0] == 'r' || input[0] == 'R') {

            *(RV32I_info.pio_32_mmap + Y_RESULT_OFFSET) = 0;

            *(RV32I_info.pio_32_mmap + START_BASE_PHYS) = 1;

            // Wait done signal
            while (1) {
                if (*(RV32I_info.pio_32_mmap + DONE_BASE_PHYS) == 1) {
                    printf("RV32I completed the calculation!\n");
                    break;
                }
            }

            uint32_t Y_fix = *(RV32I_info.pio_32_mmap + Y_RESULT_OFFSET);
            printf("Result from FPGA: %d (Hex = 0x%08X)\n", Y_fix, Y_fix);

            *(RV32I_info.pio_32_mmap + START_BASE_PHYS) = 0;
            usleep(1000);
        }
    }

    return 0;
}