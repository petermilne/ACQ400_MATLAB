%% upload_ch.m
% Inputs: 
% data : array of values for channel (shorts)
% CH   : channel number 1..32
% Based on provided channel number and data opens the relevant TCP/IP port
% and uploads the data . 
function upload_ch(data,CH)
    global UUT %Make base workspace variable visible in function
    
    channel=54000+CH; % 54001:54032 = CH1 thru CH32 data for AO
    ID = tcpip(UUT,channel);
    set(ID,'ByteOrder','littleEndian'); % Set link endianness
    ID.terminator = 10; % ASCII line feed
    s=size(data);
    ID.OutputBufferSize = 8*(s(1)); % Set output buffer to data size
    ID.Timeout = 60;
    fopen(ID);
    
    fwrite(ID,data,'int16'); % Write data to UUT
    
    fclose(ID);
    delete(ID);
end
