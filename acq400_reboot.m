%% reboot.m
% Simple function that opens up a port to the System Controller and sends a
% "reboot" command to power-cycle the box.
function acq400_reboot()
    global UUT %Make base workspace variable visible in function
    
    ID = tcpip(UUT,4220); % 4220 = System Controller
    ID.terminator = 10; % ASCII line feed
    ID.InputBufferSize = 100;
    ID.Timeout = 60;
    fopen(ID);
    
    % Send reboot command to UUT.
    fprintf(ID,'acq400_reboot'); % This power cycles the D-TACQ Carrier.
    
    fclose(ID);
    delete(ID);
end