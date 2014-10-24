%% trans_cap32.m
% This function allows the user to grab a fixed length of 32-bit data from the UUT.
%
% A |soft_transient| command is sent to the System Controller (Port 4220). Once the value of
% shot_complete increments by one, data is ready to be pulled from Ports 53001:53032.
%
% Arguments to the function are number of samples, |num_samp| and number of channels, |num_ch|.
% The maximum number of samples which can be pulled is *100,000*.
function trans_cap32(num_samp,num_ch)
%tic
    global UUT %Make base workspace variable visible in function
    
    % Check that Carrier has completed boot
    done_url = sprintf('http://%s/d-tacq/rc-local-complete',UUT);
    [done_string,url_status] = urlread(done_url,'Timeout',2);
    if url_status == 0
        fprintf(2,'D-TACQ Carrrier is booting! Please wait a moment and try again...\n');
        return;
    end
    
    disp(UUT)
    vsf = 20/2^32; % Voltage Scaling Factor
    samp_rate = 48000; % Sample rate
    
    ID = tcpip(UUT,4220); % 4220 = System Controller
    ID.terminator = 10; % ASCII line feed
    ID.InputBufferSize = 100;
    ID.Timeout = 60;
    fopen(ID);
    
    command = 'shot_complete';
    fprintf(ID,command); % Queries the value of shot_complete on UUT
    pre = fscanf(ID); % Map response of query to 'pre'
    pre = str2double(pre);
    %disp(pre)
    
    command = sprintf('soft_transient %d',num_samp);
    disp(command)
    fprintf(ID,command); % Sets up soft_transient
    readback = fscanf(ID);
    fprintf('%s',readback);
    

    %% Poll shot_complete
    %  Map result to POST. When it increments, and POST is
    %  one greater than PRE loop breaks.
    command = 'shot_complete';
    fprintf('\n...Running Transient Capture ...\n');
    while true
        fprintf(ID,command);
        post = fscanf(ID);
        post = str2double(post);
        %disp(post)
        
        if (post > pre)
            fprintf('\n...Transient Capture Complete...\n\n');
            break
        end
    end

    fclose(ID);
    delete(ID);
    
    %% Pull transient data from channels 53001:53032
    %  Store results in array indexed 1:32  
    clear CHx
    fprintf('...Pulling Channel Data from D-TACQ ACQ...\n\n');
    for i=1:num_ch
        channel=53000+i;
        disp(i);
        CH = tcpip(UUT,channel);
        set(CH,'ByteOrder','littleEndian'); % Set link endianness
        CH.terminator = 10; % ASCII carriage returns
        CH.InputBufferSize = num_samp*32; % num_samp * 32 bits
        CH.Timeout = 60;
        fopen(CH);
        
        CHx{i} = fread(CH,num_samp,'int32');
                
        % If you wish you can save channel data to binary file for posterity
        %filename = sprintf('%s_%02d.bin',UUT,i);
        %f = fopen(filename,'w');
        %fwrite(f,CHx{i},'int32',0,'b');
        %fclose(f);
        
        fclose(CH);
        delete(CH);
    end
    
    whos CHx
    fprintf('\n...Data Transfer Complete...\n\n');
    save('CHx.mat','CHx') % Save MATLAB variable for retrieval in Base Workspace
    
    %% Plot all 32CH on a graph and enable plotting controls
    % "hold all" OR one plot command
    close all
    hold all
    
    for i=1:num_ch
    CHx{i} = CHx{i}.*vsf; % Scale to volts
    end
    
    index = 1:num_samp;
    %index = index./samp_rate; %Uncomment this line for seconds on x-axis
        
    fig1 = figure(1);
    for i=1:num_ch
        plot(index, CHx{i})
    end
    
    %title('Transient Capture') 
    xlabel('Samples');
    %xlabel('Seconds');
    ylabel('Volts');
    %legend('sig1','sig2')
    hold off
    set(fig1,'units','normalized','outerposition',[0 0 1 1]); % MATLABs best approximation of maximising figure window.
    shg
%toc
end