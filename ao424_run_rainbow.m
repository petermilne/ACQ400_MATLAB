%% ao424_run_rainbow.m
% Turnkey AO424 wavegen implementation
%
function ao424_run_rainbow(site,hz)
    
    wavegen_424_setInternalClockTrg(site, hz)
    
    % Create rainbow and upload
    offset = -30082; t=1:16384;
    for ch=1:32
        rainbow_int = 1024*sin(2*pi*(1/(16384/8))*t)+offset; offset = offset+1941;
        data = rainbow_int';
        upload_ch(data, ch);
    end
    
    % Load and go ..
    wavegen_424(site, 32, 1, 1)
     
end