%% write_to_ALL_CH.m
% Simple function that calls |write_to_CH| four times to write data to 4
% ports corresponding to 4CH of AWG.
function new_write_to_ALL_CH(CH_data)
    
    for i=1:length(CH_data)
        write_to_CH(CH_data{i},i);
    end
end