%% get_res.m
% Simple function to set the resolution of captured data based on D-TACQ
% acquisition card in system.
function [resolution,variable_gain] = get_res(card)
    if strcmp(card,'acq435') || strcmp(card,'acq437')
        resolution = 32;
    elseif strcmp(card,'acq420') || strcmp(card,'acq425')
        resolution = 16;
    end
    
    if strcmp(card,'acq425') || strcmp(card,'acq437')
        variable_gain = 1;
    else
        variable_gain = 0;
    end
end