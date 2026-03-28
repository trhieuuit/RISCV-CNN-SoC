vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xilinx_vip
vlib questa_lib/msim/xpm
vlib questa_lib/msim/axi_infrastructure_v1_1_0
vlib questa_lib/msim/axi_vip_v1_1_21
vlib questa_lib/msim/zynq_ultra_ps_e_vip_v1_0_21
vlib questa_lib/msim/xil_defaultlib
vlib questa_lib/msim/axi_bram_ctrl_v4_1_13
vlib questa_lib/msim/axi_lite_ipif_v3_0_4
vlib questa_lib/msim/interrupt_control_v3_1_5
vlib questa_lib/msim/axi_gpio_v2_0_37
vlib questa_lib/msim/blk_mem_gen_v8_4_11
vlib questa_lib/msim/xlconstant_v1_1_10
vlib questa_lib/msim/proc_sys_reset_v5_0_17
vlib questa_lib/msim/smartconnect_v1_0
vlib questa_lib/msim/axi_register_slice_v2_1_35

vmap xilinx_vip questa_lib/msim/xilinx_vip
vmap xpm questa_lib/msim/xpm
vmap axi_infrastructure_v1_1_0 questa_lib/msim/axi_infrastructure_v1_1_0
vmap axi_vip_v1_1_21 questa_lib/msim/axi_vip_v1_1_21
vmap zynq_ultra_ps_e_vip_v1_0_21 questa_lib/msim/zynq_ultra_ps_e_vip_v1_0_21
vmap xil_defaultlib questa_lib/msim/xil_defaultlib
vmap axi_bram_ctrl_v4_1_13 questa_lib/msim/axi_bram_ctrl_v4_1_13
vmap axi_lite_ipif_v3_0_4 questa_lib/msim/axi_lite_ipif_v3_0_4
vmap interrupt_control_v3_1_5 questa_lib/msim/interrupt_control_v3_1_5
vmap axi_gpio_v2_0_37 questa_lib/msim/axi_gpio_v2_0_37
vmap blk_mem_gen_v8_4_11 questa_lib/msim/blk_mem_gen_v8_4_11
vmap xlconstant_v1_1_10 questa_lib/msim/xlconstant_v1_1_10
vmap proc_sys_reset_v5_0_17 questa_lib/msim/proc_sys_reset_v5_0_17
vmap smartconnect_v1_0 questa_lib/msim/smartconnect_v1_0
vmap axi_register_slice_v2_1_35 questa_lib/msim/axi_register_slice_v2_1_35

vlog -work xilinx_vip  -incr -mfcu  -sv -L axi_vip_v1_1_21 -L smartconnect_v1_0 -L zynq_ultra_ps_e_vip_v1_0_21 -L xilinx_vip "+incdir+D:/Vivado/2025.1/Vivado/data/xilinx_vip/include" \
"D:/Vivado/2025.1/Vivado/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
"D:/Vivado/2025.1/Vivado/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
"D:/Vivado/2025.1/Vivado/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
"D:/Vivado/2025.1/Vivado/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
"D:/Vivado/2025.1/Vivado/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
"D:/Vivado/2025.1/Vivado/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
"D:/Vivado/2025.1/Vivado/data/xilinx_vip/hdl/axi_vip_if.sv" \
"D:/Vivado/2025.1/Vivado/data/xilinx_vip/hdl/clk_vip_if.sv" \
"D:/Vivado/2025.1/Vivado/data/xilinx_vip/hdl/rst_vip_if.sv" \

vlog -work xpm  -incr -mfcu  -sv -L axi_vip_v1_1_21 -L smartconnect_v1_0 -L zynq_ultra_ps_e_vip_v1_0_21 -L xilinx_vip "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/7711/hdl" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/a8e4/hdl/verilog" "+incdir+D:/Vivado/2025.1/Vivado/data/rsb/busdef" "+incdir+D:/Vivado/2025.1/Vivado/data/xilinx_vip/include" \
"D:/Vivado/2025.1/Vivado/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"D:/Vivado/2025.1/Vivado/data/ip/xpm/xpm_fifo/hdl/xpm_fifo.sv" \
"D:/Vivado/2025.1/Vivado/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm  -93  \
"D:/Vivado/2025.1/Vivado/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work axi_infrastructure_v1_1_0  -incr -mfcu  "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/7711/hdl" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/a8e4/hdl/verilog" "+incdir+D:/Vivado/2025.1/Vivado/data/rsb/busdef" "+incdir+D:/Vivado/2025.1/Vivado/data/xilinx_vip/include" \
"../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/ec67/hdl/axi_infrastructure_v1_1_vl_rfs.v" \

vlog -work axi_vip_v1_1_21  -incr -mfcu  -sv -L axi_vip_v1_1_21 -L smartconnect_v1_0 -L zynq_ultra_ps_e_vip_v1_0_21 -L xilinx_vip "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/7711/hdl" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/a8e4/hdl/verilog" "+incdir+D:/Vivado/2025.1/Vivado/data/rsb/busdef" "+incdir+D:/Vivado/2025.1/Vivado/data/xilinx_vip/include" \
"../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/f16f/hdl/axi_vip_v1_1_vl_rfs.sv" \

vlog -work zynq_ultra_ps_e_vip_v1_0_21  -incr -mfcu  -sv -L axi_vip_v1_1_21 -L smartconnect_v1_0 -L zynq_ultra_ps_e_vip_v1_0_21 -L xilinx_vip "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/7711/hdl" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/a8e4/hdl/verilog" "+incdir+D:/Vivado/2025.1/Vivado/data/rsb/busdef" "+incdir+D:/Vivado/2025.1/Vivado/data/xilinx_vip/include" \
"../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/7711/hdl/zynq_ultra_ps_e_vip_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -incr -mfcu  "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/7711/hdl" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/a8e4/hdl/verilog" "+incdir+D:/Vivado/2025.1/Vivado/data/rsb/busdef" "+incdir+D:/Vivado/2025.1/Vivado/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_zynq_ultra_ps_e_0_0/sim/design_1_zynq_ultra_ps_e_0_0_vip_wrapper.v" \

vcom -work axi_bram_ctrl_v4_1_13  -93  \
"../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/2f03/hdl/axi_bram_ctrl_v4_1_rfs.vhd" \

vcom -work xil_defaultlib  -93  \
"../../../bd/design_1/ip/design_1_axi_bram_ctrl_0_0/sim/design_1_axi_bram_ctrl_0_0.vhd" \

vcom -work axi_lite_ipif_v3_0_4  -93  \
"../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/66ea/hdl/axi_lite_ipif_v3_0_vh_rfs.vhd" \

vcom -work interrupt_control_v3_1_5  -93  \
"../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/d8cc/hdl/interrupt_control_v3_1_vh_rfs.vhd" \

vcom -work axi_gpio_v2_0_37  -93  \
"../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/0271/hdl/axi_gpio_v2_0_vh_rfs.vhd" \

vcom -work xil_defaultlib  -93  \
"../../../bd/design_1/ip/design_1_axi_gpio_0_0/sim/design_1_axi_gpio_0_0.vhd" \

vlog -work blk_mem_gen_v8_4_11  -incr -mfcu  "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/7711/hdl" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/a8e4/hdl/verilog" "+incdir+D:/Vivado/2025.1/Vivado/data/rsb/busdef" "+incdir+D:/Vivado/2025.1/Vivado/data/xilinx_vip/include" \
"../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/a32c/simulation/blk_mem_gen_v8_4.v" \

vlog -work xil_defaultlib  -incr -mfcu  "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/7711/hdl" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/a8e4/hdl/verilog" "+incdir+D:/Vivado/2025.1/Vivado/data/rsb/busdef" "+incdir+D:/Vivado/2025.1/Vivado/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_blk_mem_gen_0_0/sim/design_1_blk_mem_gen_0_0.v" \
"../../../bd/design_1/ip/design_1_blk_mem_gen_1_0/sim/design_1_blk_mem_gen_1_0.v" \
"../../../bd/design_1/ip/design_1_axi_smc_3/bd_0/sim/bd_ae83.v" \

vlog -work xlconstant_v1_1_10  -incr -mfcu  "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/7711/hdl" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/a8e4/hdl/verilog" "+incdir+D:/Vivado/2025.1/Vivado/data/rsb/busdef" "+incdir+D:/Vivado/2025.1/Vivado/data/xilinx_vip/include" \
"../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/a165/hdl/xlconstant_v1_1_vl_rfs.v" \

vlog -work xil_defaultlib  -incr -mfcu  "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/7711/hdl" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/a8e4/hdl/verilog" "+incdir+D:/Vivado/2025.1/Vivado/data/rsb/busdef" "+incdir+D:/Vivado/2025.1/Vivado/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_axi_smc_3/bd_0/ip/ip_0/sim/bd_ae83_one_0.v" \

vcom -work proc_sys_reset_v5_0_17  -93  \
"../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/9438/hdl/proc_sys_reset_v5_0_vh_rfs.vhd" \

vcom -work xil_defaultlib  -93  \
"../../../bd/design_1/ip/design_1_axi_smc_3/bd_0/ip/ip_1/sim/bd_ae83_psr_aclk_0.vhd" \

vlog -work smartconnect_v1_0  -incr -mfcu  -sv -L axi_vip_v1_1_21 -L smartconnect_v1_0 -L zynq_ultra_ps_e_vip_v1_0_21 -L xilinx_vip "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/7711/hdl" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/a8e4/hdl/verilog" "+incdir+D:/Vivado/2025.1/Vivado/data/rsb/busdef" "+incdir+D:/Vivado/2025.1/Vivado/data/xilinx_vip/include" \
"../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/sc_util_v1_0_vl_rfs.sv" \
"../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/3718/hdl/sc_switchboard_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -incr -mfcu  -sv -L axi_vip_v1_1_21 -L smartconnect_v1_0 -L zynq_ultra_ps_e_vip_v1_0_21 -L xilinx_vip "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/7711/hdl" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/a8e4/hdl/verilog" "+incdir+D:/Vivado/2025.1/Vivado/data/rsb/busdef" "+incdir+D:/Vivado/2025.1/Vivado/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_axi_smc_3/bd_0/ip/ip_2/sim/bd_ae83_arsw_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_3/bd_0/ip/ip_3/sim/bd_ae83_rsw_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_3/bd_0/ip/ip_4/sim/bd_ae83_awsw_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_3/bd_0/ip/ip_5/sim/bd_ae83_wsw_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_3/bd_0/ip/ip_6/sim/bd_ae83_bsw_0.sv" \

vlog -work smartconnect_v1_0  -incr -mfcu  -sv -L axi_vip_v1_1_21 -L smartconnect_v1_0 -L zynq_ultra_ps_e_vip_v1_0_21 -L xilinx_vip "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/7711/hdl" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/a8e4/hdl/verilog" "+incdir+D:/Vivado/2025.1/Vivado/data/rsb/busdef" "+incdir+D:/Vivado/2025.1/Vivado/data/xilinx_vip/include" \
"../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/d800/hdl/sc_mmu_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -incr -mfcu  -sv -L axi_vip_v1_1_21 -L smartconnect_v1_0 -L zynq_ultra_ps_e_vip_v1_0_21 -L xilinx_vip "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/7711/hdl" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/a8e4/hdl/verilog" "+incdir+D:/Vivado/2025.1/Vivado/data/rsb/busdef" "+incdir+D:/Vivado/2025.1/Vivado/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_axi_smc_3/bd_0/ip/ip_7/sim/bd_ae83_s00mmu_0.sv" \

vlog -work smartconnect_v1_0  -incr -mfcu  -sv -L axi_vip_v1_1_21 -L smartconnect_v1_0 -L zynq_ultra_ps_e_vip_v1_0_21 -L xilinx_vip "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/7711/hdl" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/a8e4/hdl/verilog" "+incdir+D:/Vivado/2025.1/Vivado/data/rsb/busdef" "+incdir+D:/Vivado/2025.1/Vivado/data/xilinx_vip/include" \
"../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/2da8/hdl/sc_transaction_regulator_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -incr -mfcu  -sv -L axi_vip_v1_1_21 -L smartconnect_v1_0 -L zynq_ultra_ps_e_vip_v1_0_21 -L xilinx_vip "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/7711/hdl" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/a8e4/hdl/verilog" "+incdir+D:/Vivado/2025.1/Vivado/data/rsb/busdef" "+incdir+D:/Vivado/2025.1/Vivado/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_axi_smc_3/bd_0/ip/ip_8/sim/bd_ae83_s00tr_0.sv" \

vlog -work smartconnect_v1_0  -incr -mfcu  -sv -L axi_vip_v1_1_21 -L smartconnect_v1_0 -L zynq_ultra_ps_e_vip_v1_0_21 -L xilinx_vip "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/7711/hdl" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/a8e4/hdl/verilog" "+incdir+D:/Vivado/2025.1/Vivado/data/rsb/busdef" "+incdir+D:/Vivado/2025.1/Vivado/data/xilinx_vip/include" \
"../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/dce3/hdl/sc_si_converter_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -incr -mfcu  -sv -L axi_vip_v1_1_21 -L smartconnect_v1_0 -L zynq_ultra_ps_e_vip_v1_0_21 -L xilinx_vip "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/7711/hdl" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/a8e4/hdl/verilog" "+incdir+D:/Vivado/2025.1/Vivado/data/rsb/busdef" "+incdir+D:/Vivado/2025.1/Vivado/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_axi_smc_3/bd_0/ip/ip_9/sim/bd_ae83_s00sic_0.sv" \

vlog -work smartconnect_v1_0  -incr -mfcu  -sv -L axi_vip_v1_1_21 -L smartconnect_v1_0 -L zynq_ultra_ps_e_vip_v1_0_21 -L xilinx_vip "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/7711/hdl" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/a8e4/hdl/verilog" "+incdir+D:/Vivado/2025.1/Vivado/data/rsb/busdef" "+incdir+D:/Vivado/2025.1/Vivado/data/xilinx_vip/include" \
"../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/cef3/hdl/sc_axi2sc_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -incr -mfcu  -sv -L axi_vip_v1_1_21 -L smartconnect_v1_0 -L zynq_ultra_ps_e_vip_v1_0_21 -L xilinx_vip "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/7711/hdl" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/a8e4/hdl/verilog" "+incdir+D:/Vivado/2025.1/Vivado/data/rsb/busdef" "+incdir+D:/Vivado/2025.1/Vivado/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_axi_smc_3/bd_0/ip/ip_10/sim/bd_ae83_s00a2s_0.sv" \

vlog -work smartconnect_v1_0  -incr -mfcu  -sv -L axi_vip_v1_1_21 -L smartconnect_v1_0 -L zynq_ultra_ps_e_vip_v1_0_21 -L xilinx_vip "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/7711/hdl" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/a8e4/hdl/verilog" "+incdir+D:/Vivado/2025.1/Vivado/data/rsb/busdef" "+incdir+D:/Vivado/2025.1/Vivado/data/xilinx_vip/include" \
"../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/a8e4/hdl/sc_node_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -incr -mfcu  -sv -L axi_vip_v1_1_21 -L smartconnect_v1_0 -L zynq_ultra_ps_e_vip_v1_0_21 -L xilinx_vip "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/7711/hdl" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/a8e4/hdl/verilog" "+incdir+D:/Vivado/2025.1/Vivado/data/rsb/busdef" "+incdir+D:/Vivado/2025.1/Vivado/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_axi_smc_3/bd_0/ip/ip_11/sim/bd_ae83_sarn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_3/bd_0/ip/ip_12/sim/bd_ae83_srn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_3/bd_0/ip/ip_13/sim/bd_ae83_sawn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_3/bd_0/ip/ip_14/sim/bd_ae83_swn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_3/bd_0/ip/ip_15/sim/bd_ae83_sbn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_3/bd_0/ip/ip_16/sim/bd_ae83_s01mmu_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_3/bd_0/ip/ip_17/sim/bd_ae83_s01tr_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_3/bd_0/ip/ip_18/sim/bd_ae83_s01sic_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_3/bd_0/ip/ip_19/sim/bd_ae83_s01a2s_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_3/bd_0/ip/ip_20/sim/bd_ae83_sarn_1.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_3/bd_0/ip/ip_21/sim/bd_ae83_srn_1.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_3/bd_0/ip/ip_22/sim/bd_ae83_sawn_1.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_3/bd_0/ip/ip_23/sim/bd_ae83_swn_1.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_3/bd_0/ip/ip_24/sim/bd_ae83_sbn_1.sv" \

vlog -work smartconnect_v1_0  -incr -mfcu  -sv -L axi_vip_v1_1_21 -L smartconnect_v1_0 -L zynq_ultra_ps_e_vip_v1_0_21 -L xilinx_vip "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/7711/hdl" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/a8e4/hdl/verilog" "+incdir+D:/Vivado/2025.1/Vivado/data/rsb/busdef" "+incdir+D:/Vivado/2025.1/Vivado/data/xilinx_vip/include" \
"../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/7f4f/hdl/sc_sc2axi_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -incr -mfcu  -sv -L axi_vip_v1_1_21 -L smartconnect_v1_0 -L zynq_ultra_ps_e_vip_v1_0_21 -L xilinx_vip "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/7711/hdl" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/a8e4/hdl/verilog" "+incdir+D:/Vivado/2025.1/Vivado/data/rsb/busdef" "+incdir+D:/Vivado/2025.1/Vivado/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_axi_smc_3/bd_0/ip/ip_25/sim/bd_ae83_m00s2a_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_3/bd_0/ip/ip_26/sim/bd_ae83_m00arn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_3/bd_0/ip/ip_27/sim/bd_ae83_m00rn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_3/bd_0/ip/ip_28/sim/bd_ae83_m00awn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_3/bd_0/ip/ip_29/sim/bd_ae83_m00wn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_3/bd_0/ip/ip_30/sim/bd_ae83_m00bn_0.sv" \

vlog -work smartconnect_v1_0  -incr -mfcu  -sv -L axi_vip_v1_1_21 -L smartconnect_v1_0 -L zynq_ultra_ps_e_vip_v1_0_21 -L xilinx_vip "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/7711/hdl" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/a8e4/hdl/verilog" "+incdir+D:/Vivado/2025.1/Vivado/data/rsb/busdef" "+incdir+D:/Vivado/2025.1/Vivado/data/xilinx_vip/include" \
"../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/0133/hdl/sc_exit_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -incr -mfcu  -sv -L axi_vip_v1_1_21 -L smartconnect_v1_0 -L zynq_ultra_ps_e_vip_v1_0_21 -L xilinx_vip "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/7711/hdl" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/a8e4/hdl/verilog" "+incdir+D:/Vivado/2025.1/Vivado/data/rsb/busdef" "+incdir+D:/Vivado/2025.1/Vivado/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_axi_smc_3/bd_0/ip/ip_31/sim/bd_ae83_m00e_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_3/bd_0/ip/ip_32/sim/bd_ae83_m01s2a_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_3/bd_0/ip/ip_33/sim/bd_ae83_m01arn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_3/bd_0/ip/ip_34/sim/bd_ae83_m01rn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_3/bd_0/ip/ip_35/sim/bd_ae83_m01awn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_3/bd_0/ip/ip_36/sim/bd_ae83_m01wn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_3/bd_0/ip/ip_37/sim/bd_ae83_m01bn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_3/bd_0/ip/ip_38/sim/bd_ae83_m01e_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_3/bd_0/ip/ip_39/sim/bd_ae83_m02s2a_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_3/bd_0/ip/ip_40/sim/bd_ae83_m02arn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_3/bd_0/ip/ip_41/sim/bd_ae83_m02rn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_3/bd_0/ip/ip_42/sim/bd_ae83_m02awn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_3/bd_0/ip/ip_43/sim/bd_ae83_m02wn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_3/bd_0/ip/ip_44/sim/bd_ae83_m02bn_0.sv" \
"../../../bd/design_1/ip/design_1_axi_smc_3/bd_0/ip/ip_45/sim/bd_ae83_m02e_0.sv" \

vlog -work axi_register_slice_v2_1_35  -incr -mfcu  "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/7711/hdl" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/a8e4/hdl/verilog" "+incdir+D:/Vivado/2025.1/Vivado/data/rsb/busdef" "+incdir+D:/Vivado/2025.1/Vivado/data/xilinx_vip/include" \
"../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/c5b7/hdl/axi_register_slice_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib  -incr -mfcu  -sv -L axi_vip_v1_1_21 -L smartconnect_v1_0 -L zynq_ultra_ps_e_vip_v1_0_21 -L xilinx_vip "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/7711/hdl" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/a8e4/hdl/verilog" "+incdir+D:/Vivado/2025.1/Vivado/data/rsb/busdef" "+incdir+D:/Vivado/2025.1/Vivado/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_axi_smc_3/sim/design_1_axi_smc_3.sv" \

vcom -work xil_defaultlib  -93  \
"../../../bd/design_1/ip/design_1_rst_ps8_0_99M_3/sim/design_1_rst_ps8_0_99M_3.vhd" \
"../../../bd/design_1/ip/design_1_axi_bram_ctrl_1_0/sim/design_1_axi_bram_ctrl_1_0.vhd" \

vlog -work xil_defaultlib  -incr -mfcu  "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/7711/hdl" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../Pipeline_RISCV.gen/sources_1/bd/design_1/ipshared/a8e4/hdl/verilog" "+incdir+D:/Vivado/2025.1/Vivado/data/rsb/busdef" "+incdir+D:/Vivado/2025.1/Vivado/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_riscv_wrapper_0_0/sim/design_1_riscv_wrapper_0_0.v" \
"../../../bd/design_1/sim/design_1.v" \

vlog -work xil_defaultlib \
"glbl.v"

