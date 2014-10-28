function trig_source(source)
    global UUT %Make base workspace variable visible in function
    
    ID = tcpip(UUT,4220); % 4220 = System Controller
    ID.terminator = 10; % ASCII line feed
    ID.InputBufferSize = 100;
    ID.Timeout = 60;
    fopen(ID);
    
    if strcmp(source,'soft') == 1
        command = 'set.site 1 event0=0,0,0';
        fprintf(ID,command);
        command = 'set.site 1 trg=1,1,1';
    elseif strcmp(source,'hard') == 1
        %command = 'set.site 1 trg=1,0,1';
        command = 'set.site 1 event0=0,0,0';
        fprintf(ID,command);
        command = 'set.site 1 trg=1,0,1';
    elseif strcmp(source,'event') == 1
        command = 'set.site 1 event0=1,0,1';
    end
    
    % Send soft_trigger command to UUT.
    fprintf(ID,command);
    
    fclose(ID);
    delete(ID);
end