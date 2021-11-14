`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  RUAS
// Engineer: Dileep Nethrapalli
// 
// Create Date: 10/16/2020 02:26:08 PM
// Design Name: 
// Module Name: Audio_COE
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


module Audio_from_readmemeh(
         output reg AUD_PWM, 
         output AUD_SD, 
         input Clock_100MHz, Clear_n);
       
                
 // Generate Audio Shutdown(AUD_SD) signal
   // 0 = Audio Shutdown
   // 1 = Audio Enable 
     assign AUD_SD = Clear_n;

    
 //  Bitrate = bits per sample * samples per second
   // Bitrate = 16 * 44100 = 705600Hz = 706KHz = 1.42us  
   // Create a clock of 706KHz(1.42us)  
   // 1.42us clock = 0.71us ON + 0.71us OFF
   // 100MHz = 10ns = 1;  0.71us = x;  x = 71;
   // 70 = 100_0110b

    reg clock_706KHz;  
    reg [6:0] count_71;
                      
    always@(posedge Clock_100MHz, negedge Clear_n)
       if(!Clear_n)
          begin
            clock_706KHz <= 0;
            count_71 <= 0;
          end         
       else if(count_71 == 70)
          begin
            clock_706KHz <= ~clock_706KHz;
            count_71 <= 0;
          end 
       else
           count_71 <= count_71 + 1;
                    
         
  // Declare memory of size 16bit wide and 176400 Deep
    // initialize memory locations with  
    // data from .data file using system task $readmemh
    
  reg [15:0] rom [1:176400];  
    
         
  initial
   $readmemh("D:/Dileep/Audio/Audio_from_readmemh/DATA/arya_Ringa_Ringa_Left_Hex.data", rom, 1, 176400); 
      
      
  // Generate ROM Address 
     reg [3:0] Sample;
     reg [17:0] Address;  
           
     always@(negedge Clock_100MHz, negedge Clear_n) 
       if(!Clear_n)       
          Address <= 1;  
       else if((Address == 176400) && (Sample == 0) && 
               (!clock_706KHz) && (count_71 == 35))
          Address <= 1;              
       else if((Sample == 0) && (!clock_706KHz) && 
               (count_71 == 35))
          Address <= Address + 1;     
          
          
  // Read data from memory
     reg [15:0] Data;
  
     always@(posedge Clock_100MHz, negedge Clear_n)  
       if(!Clear_n)       
          Data <= 0; 
       else 
          Data <= rom[Address];          
 
      
 // Generate sample count
    
    always@(posedge clock_706KHz, negedge Clear_n)  
      if(!Clear_n)       
         Sample <= 15;
      else if(Sample == 0)    
         Sample <= 15; 
      else
         Sample <= Sample - 1;   
                    
             
  // Assign ROM data output to the PWM to get hear the sound
     always@(negedge clock_706KHz, negedge Clear_n)  
       if(!Clear_n)       
          AUD_PWM <= 0;  
       else
         case(Sample) 
           15 : AUD_PWM <= Data[15]; 
           14 : AUD_PWM <= Data[14]; 
           13 : AUD_PWM <= Data[13];
           12 : AUD_PWM <= Data[12];
           11 : AUD_PWM <= Data[11];
           10 : AUD_PWM <= Data[10];
           9  : AUD_PWM <= Data[9];
           8  : AUD_PWM <= Data[8]; 
           7  : AUD_PWM <= Data[7];
           6  : AUD_PWM <= Data[6];
           5  : AUD_PWM <= Data[5];
           4  : AUD_PWM <= Data[4]; 
           3  : AUD_PWM <= Data[3];
           2  : AUD_PWM <= Data[2];
           1  : AUD_PWM <= Data[1];
           0  : AUD_PWM <= Data[0];  
        endcase  
    
endmodule
