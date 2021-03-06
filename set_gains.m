%% set_gains.m
% Function that writes gain settings for each channel to system. This is
% based on an array provided by the operator of format
% gain_array(1:num_ch).
%
% <html>
% <table border=1><tr>
%     <td>     Card      </td><td>      Gain Levels                                                                                                              </td></tr><tr>
%     <td><b>  acq437    </b></td><td>  (+/-) </td><td> 1V </td><td> 2V </td><td> 5V </td><td> 10V </td></tr><tr></table>
% </html>
%
%%
function set_gains(gain_array)
    global UUT %Make base workspace variable visible in function
    gains_modified = evalin('base','gains_modified');
    gains_modified = 1;
    ch_per_site = 16;
    
    ID = tcpip(UUT,4220);
    ID.terminator = 10; % ASCII line feed
    ID.InputBufferSize = 100;
    ID.Timeout = 60;
    fopen(ID);
    
    fprintf(ID,'NCHAN'); % Query number of channels
    num_ch = str2num(fscanf(ID));
    num_sites = num_ch/ch_per_site; % Derive number of sites from num_ch
    
    sites = [4221,4222,4223,4224,4225,4226]; % For the full 96 channel system
    active_sites = sites(1:num_sites); % Select how many sites are active
    
    %% Error checking
    if length(gain_array) ~= num_ch
        err_msg = sprintf('Array is not %d channels long!\n',num_ch);
        fprintf(2,err_msg);
        return;
    end
    
    for j = gain_array
        if not( (j == 1) || (j == 2) || (j == 5) || (j == 10) )
            fprintf(2,'Check your array! Unsupported range specified\n');
            return;
        end
    end
    
    %%
    % Translate from 1V,2V,5V,10V to 0,1,2,3
    gain_array(gain_array == 1) = 3;
    gain_array(gain_array == 2) = 2;
    gain_array(gain_array == 5) = 1;
    gain_array(gain_array == 10) = 0;
    
    % Index for gains settings on each card
    ch_index = 1:ch_per_site;
    ch_index = horzcat(ch_index,ch_index,ch_index,ch_index,ch_index,ch_index);
    
    %% Write commands to card
    fprintf('\nProgramming gains...\n')
    for current_site = active_sites
    
        ID = tcpip(UUT,current_site);
        ID.terminator = 10; % ASCII line feed
        ID.InputBufferSize = 100;
        ID.Timeout = 60;
        fopen(ID);

        switch current_site
        case 4221
            index = 1:ch_per_site;
        case 4222
            index = ch_per_site+1:2*ch_per_site;
        case 4223
            index = 2*ch_per_site+1:3*ch_per_site;
        case 4224
            index = 3*ch_per_site+1:4*ch_per_site;
        case 4225
            index = 4*ch_per_site+1:5*ch_per_site;
        case 4226
            index = 5*ch_per_site+1:6*ch_per_site;
        otherwise
            return;
        end
        
        
        for i=index
            command = sprintf('gain%i=%d',ch_index(i),gain_array(i));
            %disp(command)
            fprintf(ID,command); % This sends the command to the card
            fscanf(ID); % Remove new lines printed by gain commands from buffer
        end
        
%         command = ('gx=');
%         for i=index
%             command = strcat(command,num2str(gain_array(i)));
%             %command = sprintf('gain%i=%d',ch_index(i),gain_array(i));
%         end
%         
%         disp(command)
%         fprintf(ID,command); % This sends the command to the card
%         fscanf(ID); % Remove new lines printed by gain commands from buffer
%         
%         fprintf('\n')
%         fclose(ID);
%         delete(ID);
        
    end
    
    fprintf('\nProgramming gains completed...\n\n')
    assignin('base', 'gains_modified', gains_modified);
    
end