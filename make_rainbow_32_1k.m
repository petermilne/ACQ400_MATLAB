offset = -30082;
for i=1:32
    rainbow_int = 1024*sin(2*pi*(1/(16384/128))*t)+offset; offset = offset+1941;
    rainbow_CH_data{i} = rainbow_int';
    rainbow_plot(:,i) = rainbow_int;
end