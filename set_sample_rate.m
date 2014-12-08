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
    
    % Catch unsupported clock rates
    if rate < 10 || rate > 128000
        fprintf(2,'Unsupported sample rate! Sample rate must be between X and Y...\n\n');
        return;
    end
    
    % Send command to UUT.
    command = sprintf('ACQ43X_SAMPLE_RATE=%d',rate);
    fprintf(ID,command);
    
    % Readback new value
    fprintf(ID,'ACQ43X_SAMPLE_RATE');
    readback = fscanf(ID); % Pop empty line
    readback = fscanf(ID);
    readback(length(readback)) = ''; % Pop the new line off the end of string
    readback = sprintf('\nNew sample rate = %s Hz\n',readback);
    disp(readback)
    
    fclose(ID);
    delete(ID);
end