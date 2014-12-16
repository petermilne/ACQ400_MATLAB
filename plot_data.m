%% plot_data.m
% Simple function to plot data from D-TACQ system.
function plot_data(ch_mask,vsf,num_samp)
    % "hold all" OR one plot command
    close all; hold all
    CHx = evalin('base','CHx');
        
    for i=ch_mask
        CHx{i} = CHx{i}.*vsf(i); % Scale to volts
    end
    
    index = 1:num_samp;
    %index = index./samp_rate; %Uncomment this line for seconds on x-axis
        
    fig1 = figure(1);
    
    for i=ch_mask
        plot(index, CHx{i}) % Plot channel
        label_array{i} = sprintf('CH%02d',i); % Record labels for figure legend
    end
    
    label_array = label_array(~cellfun('isempty',label_array)); % Remove empty elements from cell array
    
    %title('Transient Capture') 
    xlabel('Samples');
    %xlabel('Seconds');
    ylabel('Volts');
    legend(label_array);
    hold off
    set(fig1,'units','normalized','outerposition',[0 0 1 1]); % MATLABs best approximation of maximising figure window.
    shg
end