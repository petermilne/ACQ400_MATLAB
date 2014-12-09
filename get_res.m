%% get_res.m
% Simple function to set the resolution of captured data based on D-TACQ
% acquisition card in system.
function resolution = get_res(card)
    if strcmp(card,'acq435') || strcmp(card,'acq437')
        resolution = 32;
    elseif strcmp(card,'acq420') || strcmp(card,'acq425')
        resolution = 16;
    end
end