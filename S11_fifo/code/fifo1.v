module fifo1(rdata, wfull, rempty, wdata, winc, wclk, wrst_n,rinc, rclk, rrst_n);
      parameter DSIZE = 8;
      parameter ASIZE = 4;
      output [DSIZE-1:0] rdata;
      output wfull;
      output rempty;
      input [DSIZE-1:0] wdata;
      input winc, wclk, wrst_n;
      input rinc, rclk, rrst_n;

  reg wfull,rempty;
  reg [ASIZE:0] wptr, rptr, wq2_rptr, rq2_wptr, wq1_rptr,rq1_wptr;
  reg [ASIZE:0] rbin, wbin;
  reg [DSIZE-1:0] mem[0:(1<<ASIZE)-1];
  wire [ASIZE-1:0] waddr, raddr;
  wire [ASIZE:0]  rgraynext, rbinnext,wgraynext,wbinnext;
  wire  rempty_val,wfull_val;
//-----------------双口RAM存储器--------------------
   assign rdata=mem[raddr];
   always@(posedge wclk)
     if (winc && !wfull) mem[waddr] <= wdata;
//-------------同步rptr 指针-------------------------
   always @(posedge wclk or negedge wrst_n)
          if (!wrst_n) {wq2_rptr,wq1_rptr} <= 0;
          else {wq2_rptr,wq1_rptr} <= {wq1_rptr,rptr};
//-------------同步wptr指针---------------------------
    always @(posedge rclk or negedge rrst_n)
        if (!rrst_n) {rq2_wptr,rq1_wptr} <= 0;
        else {rq2_wptr,rq1_wptr} <= {rq1_wptr,wptr};
//-------------rempty产生与raddr产生-------------------
//-------------------
// GRAYSTYLE2 pointer
//-------------------
   always @(posedge rclk or negedge rrst_n)
   begin
       if (!rrst_n) {rbin, rptr} <= 0;
       else {rbin, rptr} <= {rbinnext, rgraynext};
   end
// Memory read-address pointer (okay to use binary to address memory)
  assign raddr = rbin[ASIZE-1:0];
  assign rbinnext = rbin + (rinc & ~rempty);
  assign rgraynext = (rbinnext>>1) ^ rbinnext;
//---------------------------------------------------------------
// FIFO empty when the next rptr == synchronized wptr or on reset
//---------------------------------------------------------------
  assign rempty_val = (rgraynext == rq2_wptr);
  always @(posedge rclk or negedge rrst_n)
    begin
      if (!rrst_n) rempty <= 1'b1;
      else rempty <= rempty_val;
    end
//---------------wfull产生与waddr产生------------------------------
// GRAYSTYLE2 pointer

 always @(posedge wclk or negedge wrst_n)
   if (!wrst_n) {wbin, wptr} <= 0;
   else {wbin, wptr} <= {wbinnext, wgraynext};
// Memory write-address pointer (okay to use binary to address memory)
   assign waddr = wbin[ASIZE-1:0];
   assign wbinnext = wbin + (winc & ~wfull);
   assign wgraynext = (wbinnext>>1) ^ wbinnext;
//------------------------------------------------------------------
// Simplified version of the three necessary full-tests:
// assign wfull_val=((wgnext[ADDRSIZE] !=wq2_rptr[ADDRSIZE] ) &&
// (wgnext[ADDRSIZE-1] !=wq2_rptr[ADDRSIZE-1]) &&
// (wgnext[ADDRSIZE-2:0]==wq2_rptr[ADDRSIZE-2:0]));
//------------------------------------------------------------------
   assign wfull_val = (wgraynext=={~wq2_rptr[ASIZE:ASIZE-1],
                       wq2_rptr[ASIZE-2:0]});

 always @(posedge wclk or negedge wrst_n)
     if (!wrst_n) wfull <= 1'b0;
     else wfull <= wfull_val;
endmodule