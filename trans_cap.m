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
%     <td><b>  num_samp  </b></td><td>  Number of samples                                                                                                        </td></tr><tr>
%     <td><b>  pre       </b></td><td>  For use with pre/post EVENT mode. Number of samples to record prior to trigger. Should be zero if not in EVENT mode.     </td></tr><tr>
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
% The maximum number of samples which can be pulled is *100,000*.
%%
function trans_cap(card,num_samp,pre,ch_mask,trig,rate)
%tic
    global UUT %Make base workspace variable visible in function
    
    % Check that Carrier has completed boot
    boot_complete();
    
    disp(UUT)
    set_sample_rate(1,rate); % Set up sampling rate
    resolution = get_res(card);
    vsf = calc_vsf(); % Voltage Scaling Factor
    
    %% Special option for contiguous 1:ch_mask channels
    if length(ch_mask) == 1
        ch_mask = [1:ch_mask];
    end
    
    
    %% Configure port and open
    ID = tcpip(UUT,4220); % 4220 = System Controller
    ID.terminator = 10; % ASCII line feed
    ID.InputBufferSize = 100;
    ID.Timeout = 60;
    fopen(ID);
    
    
    %% Query the value of shot_complete on UUT
    command = 'shot_complete';
    fprintf(ID,command);
    shotc_before = fscanf(ID); % Map response of query to 'shotc_before'
    shotc_before = str2double(shotc_before);
    %disp(shotc_before)
    
    
    %% Set up trigger source, request transient and arm
    transient_commands(1,trig,num_samp,pre);
    

    %% Poll shot_complete
    %  Map result to shotc_after. When it increments, and shotc_after is
    %  one greater than shotc_before loop breaks.
    command = 'shot_complete';
    fprintf('...Running Transient Capture ...\n');
    while true
        fprintf(ID,command);
        shotc_after = fscanf(ID);
        shotc_after = str2double(shotc_after);
        %disp(shotc_after)
        
        if (shotc_after > shotc_before)
            fprintf('\n...Transient Capture Complete...\n\n');
            break
        end
    end

    fclose(ID);
    delete(ID);
    
    
    %% Pull transient data from channels 53001:530XX
    %  Store results in cell array indexed 1:XX  
    clear CHx
    fprintf('...Pulling Channel Data from D-TACQ ACQ...\n\n');
    for i=ch_mask
        channel=53000+i;
        disp(i);
        CH = tcpip(UUT,channel);
        set(CH,'ByteOrder','littleEndian'); % Set link endianness
        CH.terminator = 10; % ASCII carriage returns
        if resolution == 32
            CH.InputBufferSize = num_samp*32; % num_samp * 32 bits
        elseif resolution == 16
            CH.InputBufferSize = num_samp*16; % num_samp * 16 bits
        end
        CH.Timeout = 60;
        fopen(CH);
        
        if resolution == 32
            CHx{i} = fread(CH,num_samp,'int32');
        elseif resolution == 16
            CHx{i} = fread(CH,num_samp,'int16');
        end
                
        % If you wish you can save channel data to binary file for posterity
        %filename = sprintf('%s_%02d.bin',UUT,i);
        %f = fopen(filename,'w');
        %if resolution == 32
        %    fwrite(f,CHx{i},'int32',0,'b');
        %elseif resolution == 16
        %    fwrite(f,CHx{i},'int16',0,'b');
        %end
        %fclose(f);
        
        fclose(CH);
        delete(CH);
    end
    
    whos CHx
    fprintf('\n...Data Transfer Complete...\n\n');
    save('CHx.mat','CHx') % Save MATLAB variable for retrieval in Base Workspace
    assignin('base', 'CHx', CHx); % Save variable to Base Workspace
    
    %% Plot in a figure and enable plotting controls
    % "hold all" OR one plot command
    close all; hold all
        
    for i=ch_mask
        CHx{i} = CHx{i}.*vsf(i); % Scale to volts
    end
    
    index = 1:num_samp;
    %index = index./samp_rate; %Uncomment this line for seconds on x-axis
        
    fig1 = figure(1);
    
    for i=ch_mask
        plot(index, CHx{i}) % Plot channel
        label_array{i} = sprintf('CH%02d',i); % Record labels for figure legend
    end
    
    label_array = label_array(~cellfun('isempty',label_array)); % Remove empty elements from cell array
    
    %title('Transient Capture') 
    xlabel('Samples');
    %xlabel('Seconds');
    ylabel('Volts');
    legend(label_array);
    hold off
    set(fig1,'units','normalized','outerposition',[0 0 1 1]); % MATLABs best approximation of maximising figure window.
    shg
%toc
end