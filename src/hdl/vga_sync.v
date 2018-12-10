`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module vga_sync(
 input clk,reset,
 output hsync,
        vsync,
        video_on,
        p_tick,   //??��?��??���ꡧ?�̨�3?��?����?
  output wire [9:0] pixel_x,pixel_y     // ��?����
    );
    
  //3�꨺y?����?
  //VGA640*480��?2?2?��y
   localparam HD=640;  //??????��???����
   localparam HF=48;   //????����?��������???
   localparam HB=16;   //????����?��������???
   localparam HR=96;   //??????????
   //------------------------------
   localparam VD=480;  //��1?��??��???����
   localparam VF=10;   //��1?������?��?��2?��???
   localparam VB=33;   //��1?������?���̡�2?��???
   localparam VR=2;    //��1?��??????
   
   //?��4??��y?��
   reg [1:0]mod4_reg;
   wire [1:0]mod4_next; 
   //��?2???��y?��
   reg [9:0] h_count_reg;
   wire [9:0] h_count_next;
   reg [9:0] v_count_reg;
   wire [9:0] v_count_next;
   //��?3??o3??��
   reg v_sync_reg,h_sync_reg;
   wire v_sync_next,h_sync_next;
   //���䨬?D?o?
   wire h_end,v_end;
   
  always@(posedge clk,posedge reset)
   if(reset)
    begin
     mod4_reg<=0;
     h_count_reg<=0;
     v_count_reg<=0;
     v_sync_reg<=0;
     h_sync_reg<=0;
    end
   else
    begin
     mod4_reg<=mod4_next;
     h_count_reg<=h_count_next;
     v_count_reg<=v_count_next;
     v_sync_reg<=v_sync_next;
     h_sync_reg<=h_sync_next;
    end
    
   //?��4??��y?��2������25MHz����?����1?��D?o?
   assign mod4_next=(mod4_reg==1)?0:mod4_reg+1;
   //?��??assign mod4_next=mod4_reg+1;
   assign p_tick=(mod4_reg==0)?1:0;
   
   //���䨬?D?o?
   //????����?��??��y?��?����?D?o?�ꡧ799��?
   assign h_end=(h_count_reg==(HD+HF+HB+HR-1));
   //��1?������?��??��y?��?����?D?o?�ꡧ524��?
   assign v_end=(v_count_reg==(VD+VF+VB+VR-1));
   
   //????��?2?����?��?��800??��y?��??��????-���䨬?
  // always@*
  //  if(p_tick)        //25MHZ??3?
   //  begin
   //   if(h_end)
   //      h_count_next=0;
   //   else
   //      h_count_next=h_count_reg+1;
   //   end
   //  else
   //     h_count_next=h_count_reg;
   assign h_count_next=(p_tick)?((h_end)?0:h_count_reg+1):h_count_reg;
        
    //��1?����?2?����?��?��525??��y?��??��????-���䨬?
   // always@*
   //  if(p_tick&&h_end)       
   //   begin
    //   if(v_end)
    //      v_count_next=0;
    //   else
    //      v_count_next=v_count_reg+1;
    //   end
   //   else
    //     v_count_next=v_count_reg;
   assign v_count_next=(p_tick&&h_end)?((v_end)?0:v_count_reg+1):v_count_reg;
         
   //��?2??o3??��
   //h_sync_nextD?o??��??��y?��??��y?��?a656o��751����?3?��
   assign h_sync_next=(!(h_count_reg>=(HD+HB)&&h_count_reg<=(HD+HB+HR-1)));
   
   //v_sync_nextD?o??��??��y?��??��y?��?a490o��491����?3?��
   assign v_sync_next=(!(v_count_reg>=(VD+VF+31)&&v_count_reg<=(VD+VF+VR+31-1)));
   
   //2������video_onD?o?
   assign video_on=(h_count_reg<HD)&&(v_count_reg<HD);
   
   //��?3?
   assign hsync=h_sync_reg;
   assign vsync=v_sync_reg;
   assign pixel_x=h_count_reg;
   assign pixel_y=v_count_reg;       
endmodule
