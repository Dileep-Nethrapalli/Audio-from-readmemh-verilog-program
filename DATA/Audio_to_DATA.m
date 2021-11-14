
% Read .wav Audio file 
  [y, Fs] = audioread('arya_Ringa_Ringa.wav', 'native');
  
% Extract 4 seconds Audio (4*44100 = 176400) 
  ROWS_REQUIRED = 176400; 
  Stereo = y(1:ROWS_REQUIRED, :);
 
% Separate Left and Right audio Channels
  Left_channel_int  = Stereo(:, 1);   
  Right_channel_int = Stereo(:, 2);  
 
% Extract Left Channel audio 
  Left_channel = zeros(ROWS_REQUIRED, 1, 'double');
 
  for i = 1:1:ROWS_REQUIRED
     if(Left_channel_int(i) >= 0) 
        Left_channel(i) = double(Left_channel_int(i));
     else 
        Left_channel(i) = double(0);
     end   
  end    
  
  Left_channel_sound = Left_channel ./ 32767; 
  sound(Left_channel_sound, Fs, 16);
  pause((ROWS_REQUIRED/Fs) + 3); 
 
% Extract Right Channel audio 
  Right_channel = zeros(ROWS_REQUIRED, 1, 'double');
  
  for j = 1:1:ROWS_REQUIRED
     if(Right_channel_int(j) >= 0) 
        Right_channel(j) = double(Right_channel_int(j));
     else 
        Right_channel(j) = double(0);
     end   
  end 
  
  Right_channel_sound = Right_channel ./ 32767;
  sound(Right_channel_sound, Fs, 16);
 
 % Write out DATA files    
   fid_Left_channel  = fopen('./arya_Ringa_Ringa_Left_Hex.data',  'wt');   
   fid_Right_channel = fopen('./arya_Ringa_Ringa_Right_Hex.data', 'wt');   
     
   row_counter = 1; 
 
 for k = 1:1:ROWS_REQUIRED      
   fprintf(fid_Left_channel, '%c',  dec2hex(Left_channel(k), 4));
   fprintf(fid_Left_channel, '\n'); 
   
   fprintf(fid_Right_channel, '%c', dec2hex(Right_channel(k), 4));
   fprintf(fid_Right_channel, '\n');    
     
   row_counter = row_counter+1; 
  
 end 

 fclose(fid_Left_channel);  
 fclose(fid_Right_channel);
 
 
% Plot original Audio 
  time = (1:ROWS_REQUIRED)/Fs;
  
  Left_channel_original = plot(time, Left_channel_int);
  title('Left channel original');
  xlabel('seconds');
  ylabel('Amplitude');
  saveas(Left_channel_original, 'Left_channel_original.jpg');

  Right_channel_original = plot(time, Right_channel_int);
  title('Right channel original');
  xlabel('seconds');
  ylabel('Amplitude');
  saveas(Right_channel_original, 'Right_channel_original.jpg');    
  
 % Plot extracted Audio      
  Left_channel_extracted = plot(time, Left_channel);
  title('Left channel extracted');
  xlabel('seconds');
  ylabel('Amplitude');
  saveas(Left_channel_extracted, 'Left_channel_extracted.jpg');
   
  Right_channel_extracted = plot(time, Right_channel);
  title('Right channel extracted');
  xlabel('seconds');
  ylabel('Amplitude');
  saveas(Right_channel_extracted, 'Right_channel_extracted.jpg');
  