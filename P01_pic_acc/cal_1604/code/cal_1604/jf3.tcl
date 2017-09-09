	
set_global_assignment -name FAMILY "Cyclone IV E"
set_global_assignment -name DEVICE EP4CE10F17C8
set_global_assignment -name MIN_CORE_JUNCTION_TEMP 0
set_global_assignment -name MAX_CORE_JUNCTION_TEMP 85
set_global_assignment -name STRATIX_DEVICE_IO_STANDARD "3.3-V LVTTL"
set_global_assignment -name EDA_SIMULATION_TOOL "ModelSim-Altera (Verilog)"
set_global_assignment -name EDA_OUTPUT_DATA_FORMAT "VERILOG HDL" -section_id eda_simulation

#clk
set_location_assignment PIN_E1    -to    clk 	
	
# UART
set_location_assignment PIN_K5    -to    rs232_rx        
set_location_assignment PIN_K2    -to    rs232_tx 
	
# LED
set_location_assignment PIN_T12   -to   LED[0]          
set_location_assignment PIN_P8    -to   LED[1]         
set_location_assignment PIN_M8    -to   LED[2]          
set_location_assignment PIN_M10   -to   LED[3]         
	
# PS2
set_location_assignment PIN_N8    -to    ps2_sclk          
set_location_assignment PIN_L8    -to    ps2_sda 	
	                              
#BEEP ·äÃùÆ÷                      
set_location_assignment PIN_P9    -to    beep  
	
# 256É«VGA 
set_location_assignment PIN_A7    -to  vga_vs
set_location_assignment PIN_A6    -to  vga_hs
set_location_assignment PIN_C6    -to  vga_b[1]
set_location_assignment PIN_B5    -to  vga_b[0]
set_location_assignment PIN_E5    -to  vga_g[2]
set_location_assignment PIN_A4    -to  vga_g[1] 
set_location_assignment PIN_D4    -to  vga_g[0]
set_location_assignment PIN_C3    -to  vga_r[2]
set_location_assignment PIN_B1    -to  vga_r[1] 
set_location_assignment PIN_E8    -to  vga_r[0]          
        
# KEY Çá´¥°´¼ü
set_location_assignment PIN_L3    -to   key[0]          
set_location_assignment PIN_L1    -to   key[1]          
set_location_assignment PIN_J6    -to   key[2]          
set_location_assignment PIN_N1    -to   key[3]            
         
# EEPROM
set_location_assignment PIN_L2    -to   eeprom_scl          
set_location_assignment PIN_L4    -to   eeprom_sda    
         
# SEG7 x 8 Æß¶ÎÊýÂë¹Ü
set_location_assignment PIN_L6    -to   sel[2]
set_location_assignment PIN_N6    -to   sel[1]
set_location_assignment PIN_M7    -to   sel[0] 
set_location_assignment PIN_T11   -to   seg[0]     
set_location_assignment PIN_T10   -to   seg[1]    
set_location_assignment PIN_T9    -to   seg[2]     
set_location_assignment PIN_T8    -to   seg[3]     
set_location_assignment PIN_T7    -to   seg[4]     
set_location_assignment PIN_T6    -to   seg[5]     
set_location_assignment PIN_T5    -to   seg[6]     
set_location_assignment PIN_T4    -to   seg[7] 
   
# SDRAM
set_location_assignment PIN_J15   -to a[0]
set_location_assignment PIN_N14   -to a[1]
set_location_assignment PIN_P14   -to a[2]
set_location_assignment PIN_N13   -to a[3]
set_location_assignment PIN_T14   -to a[4]
set_location_assignment PIN_L13   -to a[5]
set_location_assignment PIN_L12   -to a[6]
set_location_assignment PIN_L14   -to a[7]
set_location_assignment PIN_K12   -to a[8]
set_location_assignment PIN_J13   -to a[9]
set_location_assignment PIN_J16   -to a[10]
set_location_assignment PIN_J12   -to a[11]
set_location_assignment PIN_G15   -to ba[0]
set_location_assignment PIN_J14   -to ba[1]
set_location_assignment PIN_F9    -to dom[1]
set_location_assignment PIN_C15   -to dom[0]
set_location_assignment PIN_K11   -to scke
set_location_assignment PIN_J11   -to sclk
set_location_assignment PIN_D16   -to nwe
set_location_assignment PIN_F16   -to nscas
set_location_assignment PIN_F15   -to ncras
set_location_assignment PIN_G16   -to nscs
set_location_assignment PIN_A12   -to dq[0]
set_location_assignment PIN_B12   -to dq[1]
set_location_assignment PIN_A13   -to dq[2]
set_location_assignment PIN_A14   -to dq[3]
set_location_assignment PIN_B14   -to dq[4]
set_location_assignment PIN_A15   -to dq[5]
set_location_assignment PIN_B16   -to dq[6]
set_location_assignment PIN_C16   -to dq[7]
set_location_assignment PIN_F10   -to dq[8]
set_location_assignment PIN_F14   -to dq[9]
set_location_assignment PIN_G11   -to dq[10]
set_location_assignment PIN_F13   -to dq[11]
set_location_assignment PIN_D14   -to dq[12]
set_location_assignment PIN_C14   -to dq[13]
set_location_assignment PIN_F11   -to dq[14]
set_location_assignment PIN_D12   -to dq[15]   

# CY7C68013A     
set_location_assignment PIN_A5    -to u_ifclk 
set_location_assignment PIN_J2    -to usb_address[1] 
set_location_assignment PIN_P2    -to usb_address[0] 
set_location_assignment PIN_R10   -to usb_data[15] 
set_location_assignment PIN_R11   -to usb_data[14] 
set_location_assignment PIN_R12   -to usb_data[13] 
set_location_assignment PIN_L7    -to usb_data[12] 
set_location_assignment PIN_P6    -to usb_data[11] 
set_location_assignment PIN_M6    -to usb_data[10] 
set_location_assignment PIN_R3    -to usb_data[9] 
set_location_assignment PIN_T2    -to usb_data[8] 
set_location_assignment PIN_D3    -to usb_data[7] 
set_location_assignment PIN_A3    -to usb_data[6] 
set_location_assignment PIN_B3    -to usb_data[5] 
set_location_assignment PIN_B4    -to usb_data[4] 
set_location_assignment PIN_R4    -to usb_data[3] 
set_location_assignment PIN_R5    -to usb_data[2] 
set_location_assignment PIN_R6    -to usb_data[1] 
set_location_assignment PIN_R7    -to usb_data[0] 
set_location_assignment PIN_N2    -to usb_flagb
set_location_assignment PIN_N3    -to usb_flagc
set_location_assignment PIN_P3    -to usb_sloe_n
set_location_assignment PIN_R9    -to usb_slrd_n
set_location_assignment PIN_R8    -to usb_slwr_n

# KEY_BORD
set_location_assignment PIN_L15   -to col[0] 
set_location_assignment PIN_N15   -to col[1] 
set_location_assignment PIN_P15   -to col[2] 
set_location_assignment PIN_T15   -to col[3] 
set_location_assignment PIN_R14   -to row[0]  
set_location_assignment PIN_R16   -to row[1]
set_location_assignment PIN_P16   -to row[2]
set_location_assignment PIN_N16   -to row[3]

# LCD1602
set_location_assignment PIN_R14   -to d[7] 
set_location_assignment PIN_T15   -to d[6] 
set_location_assignment PIN_R16   -to d[5] 
set_location_assignment PIN_P15   -to d[4] 
set_location_assignment PIN_P16   -to d[3] 
set_location_assignment PIN_N15   -to d[2] 
set_location_assignment PIN_N16   -to d[1] 
set_location_assignment PIN_L15   -to d[0] 
set_location_assignment PIN_L16   -to e 
set_location_assignment PIN_K16   -to r_s 
set_location_assignment PIN_K15   -to r_w 

# LCD12864
set_location_assignment PIN_R1    -to po_res 
set_location_assignment PIN_T3    -to po_cs 
set_location_assignment PIN_J1    -to po_rs
set_location_assignment PIN_P1    -to po_scl 
set_location_assignment PIN_K6    -to po_sda

# DM9000A
set_location_assignment PIN_C9    -to sd[0]
set_location_assignment PIN_B9    -to sd[1]
set_location_assignment PIN_E10   -to sd[2]
set_location_assignment PIN_A10   -to sd[3]
set_location_assignment PIN_B10   -to sd[4]
set_location_assignment PIN_E11   -to sd[5]
set_location_assignment PIN_B11   -to sd[6]
set_location_assignment PIN_D11   -to sd[7]
set_location_assignment PIN_B7    -to sd[8]
set_location_assignment PIN_E6    -to sd[9]
set_location_assignment PIN_A8    -to sd[10]
set_location_assignment PIN_D8    -to sd[11]
set_location_assignment PIN_B8    -to sd[12]
set_location_assignment PIN_E9    -to sd[13]
set_location_assignment PIN_D9    -to sd[14]
set_location_assignment PIN_A9    -to sd[15]
set_location_assignment PIN_C8    -to cmd
set_location_assignment PIN_B6    -to ior
set_location_assignment PIN_D6    -to iow
set_location_assignment PIN_D5    -to cs
set_location_assignment PIN_A11   -to rst
set_location_assignment PIN_C11   -to int
