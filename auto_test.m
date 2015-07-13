% automated_test transient test
function auto_test(num_runs)

freq = 10000;
run_count=0;
num_samp = 100000;

for run_count=1:num_runs
%while(1)
    run_count = run_count+1;
    run_count
    
    CHx_old = evalin('base','CHx');
    
    trans_cap('acq424',0,num_samp,32,'soft',freq)
    % Pull in data from workspace
    CHx = evalin('base','CHx');
    
    %CHx_old = [1,2,3,4]
    %CHx     = [1,2,3,4]
    if isequal(CHx,CHx_old)
        disp('WARNING : Data has not updated')
        return;
    end
    
    for j=1:num_samp
        for i=1:32
            temp = CHx{i};
            temp2(i) = temp(j);
        end
        
        data_avg(1:32) = mean(temp2);
        plus_ten = data_avg(1)+abs((0.05*(data_avg(1))));
        minus_ten = data_avg(1)-abs((0.05*(data_avg(1))));
        
        if data_avg < minus_ten% || data_avg(1:32) > plus_ten
            disp('outlier found')
            return;
        end
    end
    %pause(1)
    %close all

end

close all