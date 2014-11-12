%% write_to_ALL_CH.m
% Simple function that calls |write_to_CH| four times to write data to 4
% ports corresponding to 4CH of AWG.
function write_to_ALL_CH(d1,d2,d3,d4)
        
    data_arr = {d1,d2,d3,d4};
    
    for i=1:4
        write_to_CH(data_arr{i},i);
    end
end