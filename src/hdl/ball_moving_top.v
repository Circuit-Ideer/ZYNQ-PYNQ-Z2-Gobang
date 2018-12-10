`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module ball_moving_top(
  input wire clk,reset,reset_ram,color_on,xiangpica_on,
  input wire we,//ʹ�ܣ��ɱʣ�
  input wire [9:0] ball_x,ball_y, 
                     ball_x_1,ball_y_1,
                      ball_x_2,ball_y_2,
                      ball_x_3,ball_y_3,
                      ball_x_4,ball_y_4,//��������
  output wire hsync,vsync,refr_tick,
  output wire [2:0]rgb
    );
    
  //�ź�����
    wire [9:0]pixel_x,pixel_y;
    wire video_on,pixel_tick;
    reg [2:0]rgb_reg;
    wire [2:0]rgb_next;
    wire p_tick;
   //���岿��
     //����VGAͬ����·
     vga_sync vsync_unit(.clk(clk),.reset(reset),.hsync(hsync),.vsync(vsync),
                          .video_on(video_on),.p_tick(p_tick),
                          .pixel_x(pixel_x),.pixel_y(pixel_y));
     //�������ز�����·
    ball_moving ball_moving_unit (.clk(clk),.reset(reset),.reset_ram(reset_ram),.video_on(video_on),.pix_x(pixel_x),.pix_y(pixel_y),
                       .we(we),
                        .graph_rgb(rgb_next),
                         .ball_x(ball_x),.ball_y(ball_y),
                         .ball_x_1(ball_x_1),.ball_y_1(ball_y_1),
                         .ball_x_2(ball_x_2),.ball_y_2(ball_y_2),
                         .ball_x_3(ball_x_3),.ball_y_3(ball_y_3),
                         .ball_x_4(ball_x_4),.ball_y_4(ball_y_4),
                         .refr_tick(refr_tick),.color_on(color_on),.xiangpica_on(xiangpica_on));
                         
      //rgb������
       always@(posedge clk,posedge reset)
         if(reset)
           rgb_reg<=0;
         else
         if(p_tick)
           rgb_reg<=rgb_next;
       //�߼����
        assign rgb=rgb_reg;
   endmodule
  

