%% get_gains.m
% Function that queries system for various gain setting present
% on each channel. Returns an array containing gain settings for
% all channels in the current system. This information is also printed
% to the console to aid the user.
%%
function gain_values = get_gains()

    global UUT %Make base workspace variable visible in function
    gains_modified = evalin('base','gains_modified');
    gains_modified = 0;
    ch_per_site = 16;
    
    fprintf('...Fetching Gains...\n\n')
    
    ID = tcpip(UUT,4220);
    ID.terminator = 10; % ASCII line feed
    ID.InputBufferSize = 100;
    ID.Timeout = 60;
    fopen(ID);
    
    fprintf(ID,'NCHAN'); % Query number of channels
    num_ch = str2num(fscanf(ID));
    num_sites = num_ch/ch_per_site; % Derive number of sites from num_ch
    gain_string_array = []; % Clear
    gain_printout_final = []; % Clear
    
    sites = [4221,4222,4223,4224,4225,4226]; % For the full 96 channel system
    active_sites = sites(1:num_sites); % Select how many sites are active
    
    for current_site = active_sites
        
        ID = tcpip(UUT,current_site);
        ID.terminator = 10; % ASCII line feed
        ID.InputBufferSize = 100;
        ID.Timeout = 60;
        fopen(ID);

        % Read back gains from the card to verify
        command = 'gains';
        fprintf(ID,command);
        gain_readback = fscanf(ID);
        
        gain_readback(length(gain_readback)) = ''; % Pop the new line off the end of string
        gain_read_array = gain_readback - '0'; % Convert from 0000 format to [0,0,0,0]
                
        % Translate from 0,1,2,3 to 1V,2V,5V,10V
        gain_read_array(gain_read_array == 0) = 10;
        gain_read_array(gain_read_array == 1) = 5;
        gain_read_array(gain_read_array == 2) = 2;
        gain_read_array(gain_read_array == 3) = 1;
        
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
        
        % Index for gains settings on each card
        ch_index = 1:ch_per_site;
        ch_index = horzcat(ch_index,ch_index,ch_index,ch_index,ch_index,ch_index);
        
        gain_string_array = []; % Clear
        
        for i = index
            printout = sprintf('CH%02d=% 3dV ',i,gain_read_array(ch_index(i)));
            gain_values(i) = gain_read_array(ch_index(i));
            gain_string_array = horzcat(gain_string_array,printout);
        end
        
        current_site_natural = current_site - 4220; % Reduce sites to natural 1 to 6 range
        
        gain_printout{current_site_natural,:} = gain_string_array; % Add into accumulating row of cell array
        gain_printout_final = strcat(gain_printout_final,gain_printout{current_site_natural,:},'\n'); % Concatenate onto final string for user feedback

        fclose(ID);
        delete(ID);
        
    end
    
    fprintf('Gains :\n')
    fprintf(gain_printout_final)
    fprintf('\n')
    assignin('base', 'gains_modified', gains_modified);

end