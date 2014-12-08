%% transient_commands.m
% This function sets up the trigger source for a transient capture.
% Based on this the command to begin transient capture is created and sent
% to the acquisition card.
% Finally the transient capture is armed ready for trigger.
function transient_commands(site, trig, num_samp, pre)
    global UUT %Make base workspace variable visible in function
    
    ID = tcpip(UUT,4220); % 4220 = System Controller
    ID.terminator = 10; % ASCII line feed
    ID.InputBufferSize = 100;
    ID.Timeout = 60;
    fopen(ID);
    
    if strcmp(trig,'soft') == 1
        clear_event = sprintf('set.site %d event0=0,0,0',site); % Clear event config
        fprintf(ID,clear_event);
        trig_command = sprintf('set.site %d trg=1,1,1',site);
        transient_command = sprintf('soft_transient %d',num_samp);
        
    elseif strcmp(trig,'hard') == 1
        clear_event = sprintf('set.site %d event0=0,0,0',site); % Clear event config
        fprintf(ID,clear_event);
        trig_command = sprintf('set.site %d trg=1,0,1',site);
        transient_command = sprintf('soft_transient %d',num_samp);
        
    elseif strcmp(trig,'event') == 1
        trig_command = sprintf('set.site %d event0=1,0,1',site);
        transient_command = sprintf('transient PRE=%d POST=%d OSAM=1 SOFT_TRIGGER=1',pre,num_samp);
    end
    
    disp(trig_command)
    fprintf(ID,trig_command); % Send trigger config command to UUT.
    
    disp(transient_command)
    fprintf(ID,transient_command); % Sets up transient
    
    disp('set_arm')
    fprintf(ID,'set_arm'); % Arms transient, wait for trigger
    
    readback = fscanf(ID);
    fprintf('%s',readback);
    
    fclose(ID);
    delete(ID);
end