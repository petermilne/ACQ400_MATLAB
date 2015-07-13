%% trans_cap.m
% This function allows the user to grab a fixed length of data from the UUT.
%
% A transient command is sent to the System Controller (Port 4220). Once the value of
% shot_complete increments by one, data is ready to be pulled from Ports 53001:530XX.
%
% Arguments to the function are as follows :
%
% <html>
% <table border=1><tr>
%     <td>     Argument      </td><td>  Description                                                                                                              </td></tr><tr>
%     <td><b>  card      </b></td><td>  Type of D-TACQ acquistition card in system. 'acq435', 'acq437', 'acq420', 'acq425'                                       </td></tr><tr>
%     <td><b>  pre       </b></td><td>  For use with pre/post EVENT mode. Number of samples to record prior to trigger. Should be zero if not in EVENT mode.     </td></tr><tr>
%     <td><b>  post      </b></td><td>  Number of samples after trigger for EVENT mode. For other modes this is effectively total number of samples.             </td></tr><tr>
%     <td><b>  ch_mask   </b></td><td>  Channel mask. This can be a scalar or vector.                                                                            </td></tr><tr>
%     <td>     -             </td><td>  SCALAR : capture will record channels corresponding to 1:ch_mask                                                         </td></tr><tr>
%     <td>     -             </td><td>  VECTOR : capture will record channels specified in mask, e.g. [1,2,5,10] will record channels CH01,CH02,CH05 &amp; CH10  </td></tr><tr>
%     <td><b>  trig      </b></td><td>  Trigger source. Select from 'soft', 'hard' or 'event'.                                                                   </td></tr><tr>
%     <td>     -             </td><td>  soft - Internal software trigger                                                                                         </td></tr><tr>
%     <td>     -             </td><td>  hard - External hardware trigger                                                                                         </td></tr><tr>
%     <td>     -             </td><td>  event - External hardware trigger with support for pre/post capture                                                      </td></tr><tr>
%     <td><b>  rate      </b></td><td>  Sampling rate in Hz. The program will warn the user if this is outside supported clock limits                            </td></tr></table>
% </html>
%
% The maximum number of samples which can be pulled is *1,000,000*.
% Maximum number of PRE samples is : *4096* for a 64CH system, *2730* for a 96CH system.
%
%%
function trans_cap(card,pre,post,ch_mask,trig,rate)
%tic
    global UUT %Make base workspace variable visible in function
    done = 0;
    
    % Check that Carrier has completed boot
    result = boot_complete();
    if result == 0; return; end;
    
    disp(UUT)
    if strfind(card,'acq43')
        set_sample_rate(1,rate); % Set up sampling rate
    end
    [resolution,variable_gain] = get_res(card);
    vsf = calc_vsf(resolution,variable_gain); % Voltage Scaling Factor
    
    % Catch errors
    if strcmp(trig,'event') == 0
        if pre > 0; fprintf(2,'PRE is greater than ZERO. This is only valid in EVENT mode!\n'); pre=0; end
        if post > 1000000; fprintf(2,'POST is greater than 1,000,000! Please reduce number of samples and try again...\n'); return; end
    else
        if (pre + post) > 40000; fprintf(2,'In EVENT mode PRE + POST must be < 40000. Too many samples requested!\n'); return; end
        if pre > 2730; fprintf(2,'PRE is greater than 2730! This is the maximum for a 96CH system...\n'); end
        if pre > 4096; fprintf(2,'PRE is greater than 4096! This is the maximum for a 64CH system...\n'); end
    end
    num_samp = pre + post;
    
    % Special option for contiguous 1:ch_mask channels
    if length(ch_mask) == 1
        ch_mask = [1:ch_mask];
    end
    
    
    % Configure port and open
    ID = tcpip(UUT,4220); % 4220 = System Controller
    ID.terminator = 10; % ASCII line feed
    ID.InputBufferSize = 100;
    ID.Timeout = 5;
    fopen(ID);
    
    
    % Query the value of shot_complete on UUT
    command = 'shot_complete';
    fprintf(ID,command);
    shotc_before = fscanf(ID); % Map response of query to 'shotc_before'
    shotc_before = str2double(shotc_before);
    %disp(shotc_before)
    
    
    % Set up trigger source, request transient and arm
    transient_commands(1,trig,post,pre);
    
    % Monitor log port for TRIGGER and POST/STOP
    monitor_log;

    % Poll shot_complete
    %  Map result to shotc_after. When it increments, and shotc_after is
    %  one greater than shotc_before loop breaks.
    command = 'shot_complete';
    while true
        fprintf(ID,command);
        shotc_after = fscanf(ID);
        shotc_after = str2double(shotc_after);
        
        if (shotc_after > shotc_before)
            fprintf('\n...Transient Capture Complete...\n\n');
            break
        end
    end

    fclose(ID);
    delete(ID);
    
    
    % Pull transient data from channels 53001:530XX
    %  Store results in cell array indexed 1:XX  
    fetch_data(ch_mask,resolution,num_samp);
    % Catch data timeout
    if findstr('Unsuccessful read',lastwarn)
        lastwarn('');
        fetch_data(ch_mask,resolution,num_samp);
    end
    
    % Plot in a figure and enable plotting controls
    plot_data(ch_mask,vsf,num_samp);
%toc
end