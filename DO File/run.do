vlib work
vlog -f src_files.list +cover -covercells
vsim -voptargs=+acc work.FIFO_top -cover
add wave /FIFO_top/F_if/*
add wave -position insertpoint  \
sim:/FIFO_top/dut/mem \
sim:/FIFO_top/dut/wr_ptr \
sim:/FIFO_top/dut/rd_ptr \
sim:/FIFO_top/dut/count
coverage save top.ucdb -onexit
run -all