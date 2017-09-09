onerror {resume}
quietly WaveActivateNextPane {} 0
virtual type { IDLE WRITE INCADR WAIT DONE} wrctrlstatetype
virtual type { IDLE INCADR WRITE WAIT} rdctrlstatetype
quietly virtual function -install /dcfifo_de_top_vlg_vec_tst/i1/wrctrl_logic -env /dcfifo_de_top_vlg_vec_tst { (wrctrlstatetype) dcfifo_de_top_vlg_vec_tst.i1.wrctrl_logic.state} wrctrlstate
quietly virtual function -install /dcfifo_de_top_vlg_vec_tst/i1/rdctrl_logic -env /dcfifo_de_top_vlg_vec_tst { (rdctrlstatetype) dcfifo_de_top_vlg_vec_tst.i1.rdctrl_logic.state} rdctrlstate
add wave -noupdate -divider {Trasmitting Domain}
add wave -noupdate -format Logic -radix binary /dcfifo_de_top_vlg_vec_tst/reset
add wave -noupdate -format Logic -radix binary /dcfifo_de_top_vlg_vec_tst/trclk
add wave -noupdate -format Literal /dcfifo_de_top_vlg_vec_tst/i1/wrctrl_logic/wrctrlstate
add wave -noupdate -format Literal -radix hexadecimal /dcfifo_de_top_vlg_vec_tst/i1/rom_addr
add wave -noupdate -format Literal -radix hexadecimal /dcfifo_de_top_vlg_vec_tst/i1/rom_out
add wave -noupdate -format Logic -radix binary /dcfifo_de_top_vlg_vec_tst/i1/fifo_wrreq
add wave -noupdate -format Literal -radix hexadecimal /dcfifo_de_top_vlg_vec_tst/i1/fifo_in
add wave -noupdate -format Logic -radix binary /dcfifo_de_top_vlg_vec_tst/i1/fifo_wrfull
add wave -noupdate -divider {Receiving Domain}
add wave -noupdate -format Logic -radix binary /dcfifo_de_top_vlg_vec_tst/rvclk
add wave -noupdate -format Literal /dcfifo_de_top_vlg_vec_tst/i1/rdctrl_logic/rdctrlstate
add wave -noupdate -format Logic -radix binary /dcfifo_de_top_vlg_vec_tst/i1/fifo_rdempty
add wave -noupdate -format Logic -radix binary /dcfifo_de_top_vlg_vec_tst/i1/fifo_rdreq
add wave -noupdate -format Literal -radix hexadecimal /dcfifo_de_top_vlg_vec_tst/i1/fifo_out
add wave -noupdate -format Logic -radix binary /dcfifo_de_top_vlg_vec_tst/i1/ram_wren
add wave -noupdate -format Logic /dcfifo_de_top_vlg_vec_tst/i1/ram_rden
add wave -noupdate -format Literal -radix hexadecimal /dcfifo_de_top_vlg_vec_tst/i1/ram_addr
add wave -noupdate -format Literal -radix hexadecimal /dcfifo_de_top_vlg_vec_tst/i1/ram_in
add wave -noupdate -format Literal -radix unsigned /dcfifo_de_top_vlg_vec_tst/word_count
add wave -noupdate -format Literal -radix hexadecimal /dcfifo_de_top_vlg_vec_tst/q
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {19123 ps} 0}
configure wave -namecolwidth 328
configure wave -valuecolwidth 40
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
update
WaveRestoreZoom {0 ps} {33520 ps}
