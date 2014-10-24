function vsf_array = calc_vsf()
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
        gain_read_array = gain_readback - '0'; % Convert from 0000 format to [0,0,0,0]
                
        % Translate from 0,1,2,3 to 1V,2V,5V,10V
        gain_read_array(gain_read_array == 0) = 10;
        gain_read_array(gain_read_array == 1) = 5;
        gain_read_array(gain_read_array == 2) = 2;
        gain_read_array(gain_read_array == 3) = 1;
        
        for i=1:length(gain_read_array)
            vsf_array(i) = ( gain_read_array(i)*2 )/2^32;
        end
        
        fclose(ID);
        delete(ID);
        
    end
end