%% write_to_CH.m
% Based on provided channel number and data opens the relevant TCP/IP port
% and writes the data across. Set output buffer to 8 bits * number of
% samples.
function write_to_CH(data,CH)
    global UUT %Make base workspace variable visible in function
    
    channel=54000+CH; % 54001:54004 = CH1 thru CH4 data for AO
    ID = tcpip(UUT,channel);
    set(ID,'ByteOrder','littleEndian'); % Set link endianness
    ID.terminator = 10; % ASCII line feed
    s=size(data);
    ID.OutputBufferSize = 8*(s(1)); % Set output buffer to data size
    ID.Timeout = 60;
    fopen(ID);
    
    fwrite(ID,data,'int16'); % Write data to UUT
    
    fclose(ID);
end