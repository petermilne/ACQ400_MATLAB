%% transient_commands.m
% This function sets up the trigger source for a transient capture.
% Based on this, the command to begin transient capture is created and sent
% to the acquisition card.
% Finally the transient capture is armed ready for trigger.
%
% <html>
% <table border=1><tr>
%     <td>     Argument      </td><td>  Description                                                                                                              </td></tr><tr>
%     <td><b>  site      </b></td><td>  Site to send commands to.                                                                                                </td></tr><tr>
%     <td><b>  trig      </b></td><td>  Trigger source. Select from 'soft', 'hard' or 'event'.                                                                   </td></tr><tr>
%     <td>     -             </td><td>  soft - Internal software trigger                                                                                         </td></tr><tr>
%     <td>     -             </td><td>  hard - External hardware trigger                                                                                         </td></tr><tr>
%     <td>     -             </td><td>  event - External hardware trigger with support for pre/post capture                                                      </td></tr><tr>
%     <td><b>  post      </b></td><td>  Number of samples after trigger for EVENT mode. For other modes this is effectively total number of samples.             </td></tr><tr>
%     <td><b>  pre       </b></td><td>  For use with pre/post EVENT mode. Number of samples to record prior to trigger. Should be zero if not in EVENT mode.     </td></tr><tr></table>
% </html>

function transient_commands(site, trig, post, pre)
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
        transient_command = sprintf('transient PRE=0 POST=%d OSAM=1 SOFT_TRIGGER=1',post);
        
    elseif strcmp(trig,'hard') == 1
        clear_event = sprintf('set.site %d event0=0,0,0',site); % Clear event config
        fprintf(ID,clear_event);
        trig_command = sprintf('set.site %d trg=1,0,1',site);
        transient_command = sprintf('transient PRE=0 POST=%d OSAM=1 SOFT_TRIGGER=0',post);
        
    elseif strcmp(trig,'event') == 1
        set_trig = sprintf('set.site %d trg=1,1,1',site); % Set soft trigger
        fprintf(ID,set_trig);
        trig_command = sprintf('set.site %d event0=1,0,1',site);
        transient_command = sprintf('transient PRE=%d POST=%d OSAM=1 SOFT_TRIGGER=1',pre,post);
    end
    
    disp(trig_command)
    fprintf(ID,trig_command); % Send trigger config command to UUT.
    fscanf(ID);
    
    disp(transient_command)
    fprintf(ID,transient_command); % Sets up transient
    fscanf(ID);
    
    disp('set_arm')
    fprintf(ID,'set_arm'); % Arms transient, wait for trigger
    fscanf(ID);
    
    fclose(ID);
    delete(ID);
end