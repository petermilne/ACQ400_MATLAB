%% soft_trigger.m
% Simple function that opens up a port to the System Controller and sends a
% "soft_trigger" command which kicks off the AWG.
function soft_trigger()
    global UUT %Make base workspace variable visible in function
    
    ID = tcpip(UUT,4220); % 4220 = System Controller
    ID.terminator = 10; % ASCII line feed
    ID.InputBufferSize = 100;
    ID.Timeout = 60;
    fopen(ID);
    
    % Send soft_trigger command to UUT.
    fprintf(ID,'soft_trigger'); % This kicks of queued AWG AO command.
    
    fclose(ID);
    delete(ID);
end