% automated_test transient test
function auto_test(num_runs)

freq = 10000;
run_count=0;

%for run_count=1:num_runs
while(1)
    run_count = run_count+1;
    run_count
    
    CHx_old = evalin('base','CHx');
    
    trans_cap('acq437',0,10000,16,'hard',freq)
    % Pull in data from workspace
    CHx = evalin('base','CHx');
    
    %CHx_old = [1,2,3,4]
    %CHx     = [1,2,3,4]
    if isequal(CHx,CHx_old)
        disp('WARNING : Data has not updated')
        return;
    end
    
    pulse_count = nnz(diff(CHx{1} > 1) > 0);
    
    % 10 Hz input
    % Should see 10 pulses at 10 kHZ
    % Should see 1 pulse at 100 kHz
    
    if freq == 10000
        if pulse_count ~= 10
            message = sprintf('Failed at run number %d, %d pulses present, should be 10!',run_count,pulse_count);
            disp(message)
            %close all
            return;
        end
        freq = 100000;
    else
        if pulse_count ~= 1
            message = sprintf('Failed at run number %d, %d pulses present, should be 1!',run_count,pulse_count);
            disp(message)
            %close all
            return;
        end
        freq = 10000;
    end
    
    %pause(1)
    %close all

end

close all