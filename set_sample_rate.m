%% set_sample_rate.m
% Simple function that lets the user control the sample rate of acquisition
% in Hz.
function set_sample_rate(site,card,rate)
    global UUT %Make base workspace variable visible in function
    
    if strcmp(card,'acq480')
        site = 0;
    end
    
    ID = tcpip(UUT,4220+site); % 4220 = System Controller
    ID.terminator = 10; % ASCII line feed
    ID.InputBufferSize = 100;
    ID.Timeout = 5;
    fopen(ID);
    
    % Catch unsupported clock rates
    %if rate < 10000 || rate > 128000
        %fprintf(2,'Unsupported sample rate! Sample rate must be between 10,000 and 128,000 Hz...\n\n');
        %return;
    %end
    
    count = 0;
    while(1)
        count = count+1;
        % Send command to UUT.
        if strcmp(card,'acq435') || strcmp(card,'acq437')
            rate_str = 'ACQ43X_SAMPLE_RATE';
            rate_str_len = 19;
        elseif strcmp(card,'acq420') || strcmp(card,'acq425') || strcmp(card,'acq424')
            rate_str = 'ACQ42X_SAMPLE_RATE';
            rate_str_len = 19;
        elseif strcmp(card,'acq480')
            command = sprintf('SYS:CLK:FPMUX=ZCLK');
            fprintf(ID,command);
            readback = fscanf(ID); % Pop empty line
            rate_str = 'SIG:CLK_MB:SET';
            rate_str_len = 15;
        end

        command = sprintf('%s=%d',rate_str,rate);
        fprintf(ID,command);
        readback = fscanf(ID); % Pop empty line
    
        % Readback new value
        fprintf(ID,rate_str);
        readback = fscanf(ID);
        readback = str2double(readback(rate_str_len:end-1)); % Pop the string off the front of the number and new line off the end
        
        if strcmp(card,'acq435') || strcmp(card,'acq437')
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
        else
            break;
        end
    end
    readback = sprintf('\nNew sample rate = %.2E Hz\n',readback);
    disp(readback)
    
    fclose(ID);
    delete(ID);
end