%% wavegen_go_424.m
% High level function to quickly call all the constituent functions to get
% AWG up and running. Further discussion of these constituent functions is
% given in their respective documentation pages.
function wavegen_go_424(site,nchan,loop,s_trig,CH_data)
    new_write_to_ALL_CH(CH_data);
    pause(0.5)
    wavegen_424(site,nchan,loop,s_trig);
    pause(0.5)
    if (s_trig); soft_trigger; end
end