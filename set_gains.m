function set_gains(gain_array)
    global UUT %Make base workspace variable visible in function
    
    %% Error checking
    if length(gain_array) ~= 16 % This can be extended for 96 channels
        fprintf(2,'Array is not 16 channels long!\n');
        return;
    end
    
    for j = gain_array
        if (j ~= 1) || (j ~= 2) || (j ~= 5) || (j ~= 10)
            fprintf(2,'Check your array! Unsupported range specified\n');
            return;
        end
    end
    
    %%
    % Translate from 1V,2V,5V,10V to 0,1,2,3
    gain_array(gain_array == 1) = 0;
    gain_array(gain_array == 2) = 1;
    gain_array(gain_array == 5) = 2;
    gain_array(gain_array == 10) = 3;
    
    % Index for gains settings on each card
    ch_index = 1:16;
    ch_index = horzcat(ch_index,ch_index,ch_index,ch_index,ch_index,ch_index);
    
    %% Write commands to card
    %for site  = [4221,4222,4223,4224,4225,4226] % For the full 96 channel system
    for site  = [4221]
    
        ID = tcpip(UUT,site);
        ID.terminator = 10; % ASCII line feed
        ID.InputBufferSize = 100;
        ID.Timeout = 60;
        fopen(ID);

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
        
        for i=index
            command = sprintf('gain%i=%d',ch_index(i),gain_array(i));
            disp(command)
            fprintf(ID,command); % This sends the command to the card
            fscanf(ID); % Remove new lines printed by gain commands from buffer
            pause(0.15);
        end

        fclose(ID);
        delete(ID);
        
    end
end