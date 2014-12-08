function vsf_array = calc_vsf(fixed_gain)
    global UUT %Make base workspace variable visible in function
    
    gain_read_array = get_gains();
    
    for i=1:length(gain_read_array)
        vsf_array(i) = ( gain_read_array(i)*2 )/2^32;
    end

end