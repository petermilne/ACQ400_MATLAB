function wide_array = make_CH_array(value,polarity)

if nargin < 2
    polarity = 1;
end


    if polarity == 1
        for i=1:32; wide_array{i} = value; wide_array_plot(1,:) = value; end;
    else
        value = value.*(-1);
        for i=1:32; wide_array{i} = value; wide_array_plot(1,:) = value; end;
    end
        
    assignin('base', 'wide_array', wide_array);
    assignin('base', 'wide_array_plot', wide_array_plot);
end