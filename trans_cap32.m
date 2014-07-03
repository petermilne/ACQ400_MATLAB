function trans_cap32(num_samp,num_ch)
    global UUT %Make base workspace variable visible in function
    
    ID = tcpip(UUT,4220); % 4220 = System Controller
    ID.terminator = 10; % ASCII line feed
    ID.InputBufferSize = 100;
    ID.Timeout = 60;
    fopen(ID);
    
    command = sprintf('soft_transient %s',num_samp);
    fprintf(ID,command); % Sets up soft_transient
    readback = fscanf(ID);
    fprintf('%s',readback);
    
    command = 'shot_complete';
    %fprintf(ID,command); % Queries the value of shot_complete on UUT
    %pre = fscanf(ID); % Map response of query to 'pre'
    %disp(pre)

    %% Poll shot_complete
    %  Map result to POST. When it increments, and POST is
    %  one greater than PRE loop breaks.
%     while true
%         fprintf(ID,command);
%         post = fscanf(ID);
%         disp(post)
%         
%         if (post > pre)
%             printf('\n...Transient Capture Complete...\n');
%             break
%         end
%     end
    
    %% Pull transient data from channels 53001:53032
    %  Store results in array indexed 1:32
    
    pause(2)%temporary wait, this would normally be served by the WHILE above
    
    clear CHx
    disp('...Pulling Channel Data from D-TACQ ACQ...');
    for i=1:num_ch
        
        channel=53000+i;
        CH = tcpip(UUT,channel);
        set(CH,'ByteOrder','littleEndian'); % Set link endianness
        CH.terminator = 10; % ASCII carriage returns
        CH.InputBufferSize = num_samp*32; % num_samp * 32 bits
        CH.Timeout = 60;
        fopen(CH);
        
        CHx{i} = fread(CH,num_samp,'int16');
        
        % If you wish you can save data to binary file for posterity
        %filename = sprintf('%s_%02d.bin',UUT,i);
        %f = fopen(filename,'w');
        %fwrite(f,CHx{i},'int32',0,'b');
        %fclose(f);
        
        fclose(CH);
        
    end
    
    fclose(ID);
    
    fprintf('\n...Data Transfer Complete...\n\n');
    
    %% Plot all 32CH on a graph and enable plotting controls
    % "hold on" OR one plot command
    close all
    hold all
    
    fig1 = figure(1);
    for i=1:num_ch
        plot(CHx{i})
    end
    
    %title('Transient Capture') 
    %xlabel('# of Samples');
    %ylabel('Volts');
    %legend('sig1','sig2')
    hold off
    set(fig1,'units','normalized','outerposition',[0 0 1 1]); % MATLABs best approximation of maximising figure window.
    shg
end