%% wavegen_424_setInternalClockTrg
% function sets up the ao424 awg for internal clock and soft trigger
% Inputs:
% site : 1..6
% freq : sample rate in Hz
%
% Assumes that channel data files have been uploaded previously using upload_ch
% Queues AWG data files to the AWG device
% device is ready to go on trigger
% optional trigger arg starts the process, but a more likely  scenario is
% to use the trigger on starting an adjacent ADC module
%

function wavegen_424_setInternalClockTrg(site,hz)
    global UUT %Make base workspace variable visible in function
 
    if nargin < 2; hz = 100000; end;
    if nargin < 1; site = 1; end;
   
    if hz < 1000; hz = 1000; end;
    if hz > 500000; hz = 500000; end;
 
    ID = tcpip(UUT,4220+site); % Assuming AO card in Site 1
    ID.terminator = 10; % ASCII line feed
    ID.InputBufferSize = 100;
    ID.Timeout = 60;
    fopen(ID);
    
    % soft trigger
    fprintf(ID, 'set.trig 1,1,1\n');
    readback = fscanf(ID);
    disp(readback)
   
    % internal clock 
    fprintf(ID, 'set.clk 0,0,0\n');
    readback = fscanf(ID);
    disp(readback)
   
    % rate N = 66MHz/Hz
    fprintf(ID, 'clkdiv=%d\n', floor(66000000/hz));
    readback = fscanf(ID);
    disp(readback)

    fclose(ID);
    delete(ID);

    if (_soft_trigger); soft_trigger(); end
end
