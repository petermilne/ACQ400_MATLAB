%% new_wavegen_go.m
% High level function to quickly call all the constituent functions to get
% AWG up and running. Further discussion of these constituent functions is
% given in their respective documentation pages.
function wavegen_go(CH_data)
    new_write_to_ALL_CH(CH_data);
    pause(0.5)
    wavegen_424(1);
    pause(0.5)
    soft_trigger
end