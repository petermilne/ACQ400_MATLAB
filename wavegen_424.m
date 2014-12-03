%% wavegen_424.m    
% function initialises the ao424 awg using the "wavegen" command
% Inputs:
% site : 1..6
% nchan: 1..32
% loop : 0 = one-shot, 1 = forever
% soft_trigger : 0 = no-trigger, 1=trigger
%
% Assumes that channel data files have been uploaded previously using upload_ch
% Queues AWG data files to the AWG device
% device is ready to go on trigger
% optional trigger arg starts the process, but a more likely  scenario is
% to use the trigger on starting an adjacent ADC module
%

function wavegen_424(site,nchan,loop,s_trig)
    global UUT %Make base workspace variable visible in function
 
    if nargin < 1; site = 1; end;
    if nargin < 2; nchan = 32; end;
    if nargin < 3; loop = 0; end
    if nargin < 4; s_trig = 0; end;
    
    ID = tcpip(UUT,4220+site); % Assuming AO card in Site 1
    ID.terminator = 10; % ASCII line feed
    ID.InputBufferSize = 100;
    ID.Timeout = 60;
    fopen(ID);
    
    command = sprintf('wavegen --loop %d 1:%d=ch%%02d', loop, nchan);
    fprintf(ID,command);
    
    readback = fscanf(ID);
    disp(readback)

    fclose(ID);
    delete(ID);

    if (s_trig); soft_trigger; end
end
