%% set_role.m
% This function allows configure one UUT to slave off another.
%
%%
function set_role(uut,role,sample_rate)
% Lower case "uut" so as not to clash with the GLOBAL variable.

    disp(uut)

    % Configure port and open
    ID = tcpip(uut,4220); % 4220 = System Controller
    ID.terminator = 10; % ASCII line feed
    ID.InputBufferSize = 100;
    ID.Timeout = 5;
    fopen(ID);
        
    if strcmpi(role,'master')
        % Set Master
        command = sprintf('set.sync_role MASTER %d', sample_rate);
    elseif strcmpi(role,'slave')
        % Set Slave
        command = sprintf('set.sync_role SLAVE %d', sample_rate);
    else
        disp('Invalid role entered! Please use either "master" or "slave"')
    end
    fprintf(ID,command);

    fclose(ID);
    delete(ID);
end