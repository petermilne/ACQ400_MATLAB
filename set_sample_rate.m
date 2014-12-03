%% set_sample_rate.m
% Simple function that lets the user control the sample rate of acquisition
% in Hz.
function set_sample_rate(site,rate)
    global UUT %Make base workspace variable visible in function
    
    ID = tcpip(UUT,4220+site); % 4220 = System Controller
    ID.terminator = 10; % ASCII line feed
    ID.InputBufferSize = 100;
    ID.Timeout = 60;
    fopen(ID);
    
    % Something to catch unsupported clock rates
    
    % Send command to UUT.
    command = sprintf('ACQ43X_SAMPLE_RATE=%d',rate);
    fprintf(ID,command);
    
    fclose(ID);
    delete(ID);
end