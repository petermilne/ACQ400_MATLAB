%% ao424_run.m
% Turnkey AO424 wavegen implementation
%
function ao424_run(site,hz,data)
    
    wavegen_424_setInternalClockTrg(site, hz)
    
    % Upload 32 channels of data
    for ch=1:32; upload_ch(data, ch); end
    
    % Load and go ..
    wavegen_424(site, 32, 1, 1)
     
end