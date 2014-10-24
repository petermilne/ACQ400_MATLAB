function get_gains()
    global UUT %Make base workspace variable visible in function
    
    %for site  = [4221,4222,4223,4224,4225,4226] % For the full 96 channel system
    for site  = [4221]
    
        ID = tcpip(UUT,site);
        ID.terminator = 10; % ASCII line feed
        ID.InputBufferSize = 100;
        ID.Timeout = 60;
        fopen(ID);

        % Read back gains from the card to verify
        command = 'gains';
        fprintf(ID,command);
        gain_readback = fscanf(ID);
        
        gain_readback(length(gain_readback)) = ''; % Pop the new line off the end of string
        gain_read_array = gain_readback - '0'; % Conver from 0000 format to [0,0,0,0]
                
        % Translate from 0,1,2,3 to 1V,2V,5V,10V
        gain_read_array(gain_read_array == 3) = 10;
        gain_read_array(gain_read_array == 2) = 5;
        gain_read_array(gain_read_array == 1) = 2;
        gain_read_array(gain_read_array == 0) = 1;
        
        switch site
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
        
        new_gain_readback = '';
        for i = index
            j = sprintf('CH%02d=%dV ',i,gain_read_array(i));
            new_gain_readback = horzcat(new_gain_readback,j);
        end
        
        fprintf('\n');
        disp(new_gain_readback); % Print out gains to console
        fprintf('\n');
        
        fclose(ID);
        delete(ID);
        
    end
end