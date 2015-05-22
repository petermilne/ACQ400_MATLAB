%% fetch_data.m
% Simple function to pull data from D-TACQ system.
function fetch_data(ch_mask,resolution,num_samp)
    global UUT %Make base workspace variable visible in function
    
    clear CHx
    lastwarn('');
    fprintf('...Pulling Channel Data from D-TACQ ACQ...\n\n');
    for i=ch_mask
        channel=53000+i;
        disp(i);
        CH = tcpip(UUT,channel);
        set(CH,'ByteOrder','littleEndian'); % Set link endianness
        CH.terminator = 10; % ASCII carriage returns
        if resolution == 32
            CH.InputBufferSize = num_samp*32; % num_samp * 32 bits
        elseif resolution == 16
            CH.InputBufferSize = num_samp*16; % num_samp * 16 bits
        end
        CH.Timeout = 2;
        fopen(CH);
        
        if resolution == 32
            CHx{i} = fread(CH,num_samp,'int32');
        elseif resolution == 16
            CHx{i} = fread(CH,num_samp,'int16');
        end
                
        % If you wish you can save channel data to binary file for posterity
        %filename = sprintf('%s_%02d.bin',UUT,i);
        %f = fopen(filename,'w');
        %if resolution == 32
        %    fwrite(f,CHx{i},'int32',0,'b');
        %elseif resolution == 16
        %    fwrite(f,CHx{i},'int16',0,'b');
        %end
        %fclose(f);
        
        fclose(CH);
        delete(CH);
    end
    
    whos CHx
    fprintf('\n...Data Transfer Complete...\n\n');
    save('CHx.mat','CHx') % Save MATLAB variable for retrieval in Base Workspace
    assignin('base', 'CHx', CHx); % Save variable to Base Workspace
end