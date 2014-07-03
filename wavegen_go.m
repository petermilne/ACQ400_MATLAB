%% wavegen_go.m
% High level function to quickly call all the constituent functions to get
% AWG up and running. Further discussion of these constituent functions is
% given in their respective documentation pages.
function wavegen_go(data1,data2,data3,data4)
    write_to_ALL_CH(data1,data2,data3,data4);
    wavegen(1);
    soft_trigger
end