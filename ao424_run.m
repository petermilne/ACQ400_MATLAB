%% ao424_run.m
% Turnkey AO424 wavegen implementation
% Edit with trigger option
function ao424_run(site,hz,data,s_trig)
    
    wavegen_424_setInternalClockTrg(site, hz, s_trig)
    
    % Upload 32 channels of data
    for ch=1:32; upload_ch(data, ch); end
    
    % Load and go ..
    wavegen_424(site, 32, 1, s_trig)
     
end