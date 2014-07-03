%% run3 - control 3 x ACQ196, simultaneous capture

set(handles.error,'Visible','off'); % Turns off errors from previous run

% Set number of samples (max 4000000) - Fetches from GUI
num_samp = str2double(get(handles.num_samp,'String'));
if (isnan(num_samp)) % Error catching
    set(handles.error,'Visible','on');set(handles.error,'String','"Number of Samples" is Not a Number (NaN)!!!');
    return
end
        
% Set clk in kHz (0 => use external clock) - Fetches from GUI
clk = str2double(get(handles.clk,'String'));
if (isnan(clk)) % Error catching
    set(handles.error,'Visible','on');set(handles.error,'String','"Clock" is Not a Number (NaN)!!!');
    return
end

% Set number of acq boards in setup 
num_boards = 3;

% General variable instantiation
colour_index = 1;
p = 1/1000000;

% Set list of hostnames or ip-addresses if no DNS - Fetches from GUI
UUTS{1} = get(handles.masterIP,'String'); assignin('base', 'UUTS1', UUTS{1});
UUTS{2} = get(handles.slave1_IP,'String'); assignin('base', 'UUTS2', UUTS{2});
UUTS{3} = get(handles.slave2_IP,'String'); assignin('base', 'UUTS3', UUTS{3});

% Save variables to workspace. Used to populate GUI on subsequent calls
assignin('base', 'num_samp', num_samp);
assignin('base', 'clk', clk);

axes(handles.axes1) % Set current axes to the GUI plot area

% Initiate TCP/IP connections; check : print hostname from each UUT
for x = 1:num_boards
    cmd_s{x} = tcpip(UUTS{x},53000);
    fopen(cmd_s{x});
    fprintf(cmd_s{x},'hostname');
    fscanf(cmd_s{x})
end

colourise;colourise; % COLOURISE used throughout to update card indicators

%% Configure the UUTs
role = 'MASTER';

fprintf(cmd_s{1},'set.sync_trig_mas none'); % Disable trigger

for x=1:num_boards 
    command = sprintf('set.acq196.role %s %d',role,clk); % Set role : MASTER/SLAVE/SOLO
    fprintf(cmd_s{x},command);
    fgets(cmd_s{x});
    command = sprintf('acqcmd setMode SOFT_TRANSIENT %d',num_samp); % One-shot capture
    fprintf(cmd_s{x},command);
    fgets(cmd_s{x});
    role = 'SLAVE';
end

for x=1:num_boards
    fprintf(cmd_s{x},'acqcmd setArm'); % ARM all boards
end

colourise;colourise;colourise;

%% Enable the trigger manually. Then set the External Trigger
% Works with a free-running trigger

set(handles.trigger,'Visible','on'); % Dislays the TRIGGER GUI button
waitfor(handles.trigger,'Visible'); % Pauses execution til trigger clicked and button disappears

fprintf(cmd_s{1},'set.sync_trig_mas DO4 falling'); % Enable trigger
fscanf(cmd_s{1});

colourise;
% Progress bar on
set(handles.progress,'Visible','on');set(handles.text11,'Visible','on');
progress = 0;

%% Poll for completion
busy = 1;
plot_flag = 0;
while (busy==1)
    update_progress;
    colourise;
    fprintf(cmd_s{1},'acqcmd getState');
    state = fgets(cmd_s{1});
    
    plotx = (~isempty(strfind(state,'POST')) > 0) && (plot_flag == 0);
    busy = (isempty(strfind(state,'STOP')) > 0); % break line
    colourise;
    
    if (plotx == 1) % Used to update plot before entire FTP transfer
        set(handles.text12,'Visible','on');pause(p);
        cla;
        CHx = read_acq_chan(UUTS{1},1,num_samp);
        plot(CHx);
        set(handles.text12,'Visible','off');pause(p);
        plot_flag = 1;
    end
end

colourise;pause(0.1);colourise;

%% After FTP complete, read-in all channels from file
% Pre-allocate
CHx1 = cell(1,96);CHx2 = cell(1,96);CHx3 = cell(1,96);
for i=1:96
    update_progress;
    filename = sprintf('C:\\acq_ftp\\data\\acq196_492\\w492_%02d',i);
    f = fopen(filename,'r');
    CHx1{i} = fread(f,num_samp,'int16');
    fclose(f);
end

for i=1:96
    update_progress;
    filename = sprintf('C:\\acq_ftp\\data\\acq196_493\\w493_%02d',i);
    f = fopen(filename,'r');
    CHx2{i} = fread(f,num_samp,'int16');
    fclose(f);
end

for i=1:96
    update_progress;
    filename = sprintf('C:\\acq_ftp\\data\\acq196_494\\w494_%02d',i);
    f = fopen(filename,'r');
    CHx3{i} = fread(f,num_samp,'int16');
    fclose(f);
end
update_progress;
% Progress bar off
set(handles.progress,'Visible','off');set(handles.text11,'Visible','off');

%% Save data to the Workspace
assignin('base', 'CHx1', CHx1);
assignin('base', 'CHx2', CHx2);
assignin('base', 'CHx3', CHx3);

%% Plot data in GUI
cla;
colour_vect = {'y','m','g','b','r','c','k'};
hold on;
set(handles.text13,'Visible','on');pause(p);
for i=1:32
    plot(CHx1{i},colour_vect{colour_index});
    plot(CHx2{i},colour_vect{colour_index});
    plot(CHx3{i},colour_vect{colour_index});
    if colour_index == 7
        colour_index = 1;
    else
        colour_index=colour_index+1;
    end
end
set(handles.text13,'Visible','off');
hold off;


%% Close off TCP/IP connections
for x=1:num_boards
     fclose(cmd_s{x});
end