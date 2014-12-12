%% calc_vsf.m
% Function that calculates the various voltage scaling factors that should be
% applied to each channel. Returns an array containing relevant factors for
% all channels in the current system.
%
% <html>
% <table border=1><tr>
%     <td>     Argument        </td><td>      Description                                                                                    </td></tr><tr>
%     <td><b>  resolution      </b></td><td>  Selects 16 or 32-bit word length. This has already been set by a call to get_res.m             </td></tr><tr>
%     <td><b>  variable_gain   </b></td><td>  Selects whether current system has fixed or variable gains. Also set by call to get_res.m      </td></tr><tr></table>
% </html>

%%
function vsf_array = calc_vsf(resolution, variable_gain)
    global UUT %Make base workspace variable visible in function
    
    %% Load value of |gains_modified| from Base workspace, if not defined, intialise
    if not(evalin('base','exist(''gains_modified'',''var'')'))
        assignin('base', 'gains_modified', 1);
    end
    
    gains_modified = evalin('base','gains_modified');
    
    %% If card supports variable gains
    if (variable_gain)
    
        %% If |UUT| has been modified since last run set gain_modified flag to 1 
        if (evalin('base','exist(''UUT_prev'',''var'')')) % If exists
            UUT_prev = evalin('base','UUT_prev'); % Load previous value from Base workspace
            if not(strcmp(UUT,UUT_prev)) % Compare
                gains_modified = 1; % If modified, set flag HIGH
            end
        end
    
        %% If gains have been modified, read them from card, convert to vsf and save to vsf_array
        if gains_modified || not(evalin('base','exist(''vsf_array'',''var'')')) % If gains have been altered or are uninitialised
            gain_read_array = get_gains(); % Call to get_gains. Queries current gain values in system.
    
            for i=1:length(gain_read_array)
                vsf_array(i) = ( gain_read_array(i)*2 )/2^resolution; % Converts gains levels into voltage scaling factors
            end
    
            assignin('base', 'vsf_array', vsf_array); % Save variable to Base Workspace for reuse
    
        else
            %load vsf_array from Base workspace
            vsf_array = evalin('base','vsf_array');
        end
        
    %% Otherwise query number of channels and use static voltage scaling factor    
    else
        ID = tcpip(UUT,4220);
        ID.terminator = 10; % ASCII line feed
        ID.InputBufferSize = 100;
        ID.Timeout = 60;
        fopen(ID);
    
        fprintf(ID,'NCHAN'); % Query number of channels
        num_ch = str2num(fscanf(ID));
        
        fclose(ID);
        delete(ID);
        
        vsf_array(1:num_ch) = 20/2^resolution;
    end


    %% Save |UUT| as |UUT_prev| for comparison on next run
    assignin('base', 'UUT_prev', UUT); % Save variable to Base Workspace for reuse
    
end