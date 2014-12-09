%% calc_vsf.m
% Function that calculates the various voltage scaling that should be
% applied to each channel. Returns an array containing relevant factors for
% all channels in the current system.
function vsf_array = calc_vsf(card)
    global UUT %Make base workspace variable visible in function
    
    gain_read_array = get_gains(); % Call to get_gains. Queries current gain values in system.
    
    for i=1:length(gain_read_array)
        vsf_array(i) = ( gain_read_array(i)*2 )/2^32; % Converts gains levels into voltage scaling factors
    end

end