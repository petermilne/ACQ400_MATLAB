function AO424_characterisation(num_boards)
    
    dc0(1:16384) = 0; dc0 = dc0';
    dc1(1:16384) = 6554; dc1 = dc1';
    dc2(1:16384) = 13107; dc2 = dc2';
    dc2_5(1:16384) = 16384; dc2_5 = dc2_5';
    dc3(1:16384) = 19660; dc3 = dc3';
    dc4(1:16384) = 26214; dc4 = dc4';
    dc5(1:16384) = 32768; dc5 = dc5';
    
    levels = { (dc5.*(-1)), (dc4.*(-1)), (dc3.*(-1)), (dc2.*(-1)), (dc1.*(-1)), dc0, dc1, dc2, dc3, dc4, dc5};
    
    for i=1:num_boards
        CH_array = make_CH_array(levels{i});
        new_wavegen_go(CH_array)
        pause(2);
        
        % Pull from TCP/IP port
        % hexdump redirect
        % Load
        
        % Index in 5k for all CH into array
        sample_array = shot_data(5000,1:32);
        % Scale to volts
        sample_array = sample_array.*(10/2^16);
        
        
        % Max - Min
        % Avg
        % Deviation from requested voltage
        % Noise
        
        % Append to file
        
    end
end