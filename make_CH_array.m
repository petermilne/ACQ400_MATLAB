function ao424_data = make_CH_array(value,polarity)

    if nargin < 2
        polarity = 1;
    end
    
    % Create 1x32 Cell array composed of 32 instances of x by 1 channel data arrays
    if polarity == 1
        for i=1:32; ao424_data{i} = value; ao424_data_plot(1,:) = value; end;
    else
        value = value.*(-1);
        for i=1:32; ao424_data{i} = value; ao424_data_plot(1,:) = value; end;
    end
    
    % Save variables to base workspace
    assignin('base', 'ao424_data', ao424_data);
    assignin('base', 'ao424_data_plot', ao424_data_plot);
end