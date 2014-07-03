%% write_to_ALL_CH.m
% Simple function that calls |write_to_CH| four times to write data to 4
% ports corresponding to 4CH of AWG.
function write_to_ALL_CH(data1,data2,data3,data4)
        
    data_arr = {data1, data2, data3, data4};
    
    for i=1:4
        write_to_CH(data_arr{i},i);
    end
end