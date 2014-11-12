%% wavegen_424.m    REPLICA FOR 424 with 32 CH - HACK!!!!!!!
% This function creates and then sends the "wavegen" command to the AO
% card. This queues the AWG source files ready to be triggered by a soft
% trigger to the System Controller. Command structure is as follows :
%
% |wavegen [OPTIONS] 1=filename1 2=filename2 3=filename3 4=filename4|
%
%       --loop 1
%           will loop the source files continuously instead of a one-shot configuration.
%
% * If only the "loop" argument is provided the filenames will be set to
% the default. These are the names that are automatically given to data
% written over TCP/IP to these ports.
%
% <html>
% <table border=1><tr><td>Default Filename</td><td>Port</td></tr>
% <tr><td> /usr/local/awgdata/ch/ch01 </td><td> 54001 </td></tr>
% <tr><td> /usr/local/awgdata/ch/ch02 </td><td> 54002 </td></tr>
% <tr><td> /usr/local/awgdata/ch/ch03 </td><td> 54003 </td></tr>
% <tr><td> /usr/local/awgdata/ch/ch04 </td><td> 54004 </td></tr></table>
% </html>
%
% * This means that if you intend to transfer data over TCP/IP your
% |wavegen| command can be simplified :
%
%       "wavegen(0)"   :   One-shot
%       "wavegen(1)"   :   Loop
%
% * If you wish to specify a filename already on the UUT your call to
% |wavegen| would look like this :
%
%       wavegen(1,'sin.dat','pulse1.dat','pulse2.dat','pulse3.dat')

function wavegen(loop,file1,file2,file3,file4)
    global UUT %Make base workspace variable visible in function
    
    if nargin < 1; loop=1; end
    if nargin < 2
        file1='ch01';
        file2='ch02';
        file3='ch03';
        file4='ch04';
    else % Variables have been supplied. You can plot graph.
%         fig1 = figure(1);
%         subplot(2,2,1); plot(var1);
%         subplot(2,2,2); plot(var2);
%         subplot(2,2,3); plot(var3);
%         subplot(2,2,4); plot(var4);
%         scrn = get(0,'ScreenSize');
%         pos1 = [0.1*scrn(3),0.1*scrn(4),0.8*scrn(3),0.8*scrn(4)];
%         set(fig1,'OuterPosition',pos1);
%         shg
    end
    
    %ID = tcpip(UUT,4226); % Assuming AO card in Site 2
    ID = tcpip(UUT,4222); % Assuming AO card in Site 1
    ID.terminator = 10; % ASCII line feed
    ID.InputBufferSize = 400;
    ID.Timeout = 60;
    fopen(ID);
    
    command = 'wavegen --loop 1 ';
    for i=1:32
        channels = sprintf('%d=ch%02d ',i,i);
        command = horzcat(command,channels);
    end

    %disp(command)
    
    fprintf(ID,command);
    fprintf('\n')

    fclose(ID);
    delete(ID);
end