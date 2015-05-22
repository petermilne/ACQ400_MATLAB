%% set_sample_rate.m
% Simple function that lets the user control the sample rate of acquisition
% in Hz.
function set_sample_rate(site,rate)
    global UUT %Make base workspace variable visible in function
    
    ID = tcpip(UUT,4220+site); % 4220 = System Controller
    ID.terminator = 10; % ASCII line feed
    ID.InputBufferSize = 100;
    ID.Timeout = 5;
    fopen(ID);
    
    % Catch unsupported clock rates
    if rate < 10000 || rate > 128000
        fprintf(2,'Unsupported sample rate! Sample rate must be between 10,000 and 128,000 Hz...\n\n');
        return;
    end
    
    count = 0;
    while(1)
        count = count+1;
        % Send command to UUT.
        command = sprintf('ACQ43X_SAMPLE_RATE=%d',rate);
        fprintf(ID,command);
    
        % Readback new value
        fprintf(ID,'ACQ43X_SAMPLE_RATE');
        readback = fscanf(ID); % Pop empty line
        readback = fscanf(ID);
        readback = str2double(readback(19:end-1)); % Pop the string off the front of the number and new line off the end
        
        fprintf(ID,'hi_res_mode');
        hi_res_mode = str2double(fscanf(ID));
        if rate == readback
            if (rate < 50000)
                if hi_res_mode == 1
                    break;
                else
                    fprintf(ID,'hi_res_mode 1');
                    break;
                end
            elseif (rate >= 50000)
                if hi_res_mode == 0
                    break;
                else
                    fprintf(ID,'hi_res_mode 0');
                    break;
                end
            end
        end
    end
    readback = sprintf('\nNew sample rate = %.2E Hz\n',readback);
    disp(readback)
    
    fclose(ID);
    delete(ID);
end