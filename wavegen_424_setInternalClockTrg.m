%% wavegen_424_setInternalClockTrg
% function sets up the ao424 awg for internal clock and soft trigger
% Inputs:
% site : 1..6
% freq : sample rate in Hz
%
% Edit with trigger option
function wavegen_424_setInternalClockTrg(site,hz,s_trig)
    global UUT %Make base workspace variable visible in function
 
    if nargin < 1; site = 1; end;
    if nargin < 2; hz = 100000; end;
   
    if hz < 1000; hz = 1000; end;
    if hz > 500000; hz = 500000; end;
 
    ID = tcpip(UUT,4220+site); % Assuming AO card in Site 1
    ID.terminator = 10; % ASCII line feed
    ID.InputBufferSize = 100;
    ID.Timeout = 60;
    fopen(ID);
    
    if (s_trig)
        % soft trigger
        fprintf(ID, 'trg=1,1,1');
    else
        % hardware trigger
        fprintf(ID, 'trg=1,0,1');
    end
   
    % internal clock 
    fprintf(ID, 'clk=0,0,0');
   
    % rate N = 66MHz/Hz
    command = sprintf('clkdiv=%d', floor(66000000/hz));
    fprintf(ID, command);

    fclose(ID);
    delete(ID);

end
