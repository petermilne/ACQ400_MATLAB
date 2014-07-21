function trig_source(source)
    global UUT %Make base workspace variable visible in function
    
    ID = tcpip(UUT,4220); % 4220 = System Controller
    ID.terminator = 10; % ASCII line feed
    ID.InputBufferSize = 100;
    ID.Timeout = 60;
    fopen(ID);
    
    if source == 'soft'
        command = 'set.site 1 trg=1,1,1';
    elseif source == 'hard'
        command = 'set.site 1 trg=1,0,1';
    end
    
    % Send soft_trigger command to UUT.
    fprintf(ID,command); % This kicks of queued AWG AO command.
    
    fclose(ID);
    delete(ID);
end