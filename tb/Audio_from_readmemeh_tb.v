`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  RUAS
// Engineer: Dileep Nethrapalli
// 
// Create Date: 10/30/2020 11:23:17 AM
// Design Name: 
// Module Name: Audio_readmemeh_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Audio_from_readmemeh_tb( );

  wire AUD_PWM, AUD_SD; 
  reg  Clock_100MHz, Clear_n;
  
  wire clock_706KHz;
  wire [6:0]  Count_71;
  wire [17:0] Address; 
  wire [15:0] Data;
  wire [3:0]  Sample;
 
  
   Audio_from_readmemeh audio_DUT(
        .AUD_PWM(AUD_PWM), .AUD_SD(AUD_SD),
        .Clock_100MHz(Clock_100MHz), 
        .Clear_n(Clear_n));
                                
                        
     assign Count_71 = audio_DUT.count_71;   
     assign Address = audio_DUT.Address;
     assign Data = audio_DUT.Data;                  
     assign Sample = audio_DUT.Sample;  
     assign clock_706KHz = audio_DUT.clock_706KHz;                    
 
     initial   Clock_100MHz = 0;
     always #5 Clock_100MHz = ~Clock_100MHz;
                                  
     initial
       begin
              Clear_n = 0;
         #100 Clear_n = 1;                 
       end 
       
     always@(Address)
       if(Address == 176400)      
          $finish;                        
  
endmodule
