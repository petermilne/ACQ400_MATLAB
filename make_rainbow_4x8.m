offset = -29082;
for i=1:32
    rainbow_int = 3686*sin(2*pi*(1/(16384/32))*t)+offset; offset = offset+8309;
    if i==8 || i==16 || i==24
        offset = -29082;
    end
    rainbow_CH_data{i} = rainbow_int';
    rainbow_plot(:,i) = rainbow_int;
end