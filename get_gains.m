function gain_values = get_gains()
    global UUT %Make base workspace variable visible in function
    
    ID = tcpip(UUT,4220);
    ID.terminator = 10; % ASCII line feed
    ID.InputBufferSize = 100;
    ID.Timeout = 60;
    fopen(ID);
    
    fprintf(ID,'NCHAN'); % Query number of channels
    num_ch = str2num(fscanf(ID));
    num_sites = num_ch/16; % Derive number of sites from num_ch
    gain_string_array = [];
    
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
            index = 1:16;
        case 4222
            index = 17:32;
        case 4223
            index = 33:48;
        case 4224
            index = 49:64;
        case 4225
            index = 65:80;
        case 4226
            index = 81:96;
        otherwise
            return;
        end
        
        % Index for gains settings on each card
        ch_index = 1:16;
        ch_index = horzcat(ch_index,ch_index,ch_index,ch_index,ch_index,ch_index);
        
        gain_string_array = []; % Clear
        
        for i = index
            printout = sprintf('CH%02d=% 3dV ',i,gain_read_array(ch_index(i)));
            gain_values(i) = gain_read_array(ch_index(i));
            gain_string_array = horzcat(gain_string_array,printout);
        end
        
        gain_printout{current_site - 4220,:} = gain_string_array; % Add into accumulating row of cell array

        fclose(ID);
        delete(ID);
        
    end
    
    gain_printout_final = sprintf('%s\n%s\n',gain_printout{1,:},gain_printout{2,:});
    fprintf(gain_printout_final)
    
end