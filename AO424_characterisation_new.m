function AO424_characterisation(num_levels)
    
    dc0(1:16384) = 0; dc0 = dc0';
    dc1(1:16384) = 6554; dc1 = dc1';
    dc2(1:16384) = 13107; dc2 = dc2';
    dc2_5(1:16384) = 16384; dc2_5 = dc2_5';
    dc3(1:16384) = 19660; dc3 = dc3';
    dc4(1:16384) = 26214; dc4 = dc4';
    dc5(1:16384) = 32768; dc5 = dc5';
    
    values = [-32768,-19660,-16384,-13107,-6554,0,6554,13107,16384,19660,32768];
    val_volts = values.*(10/2^16);
    levels = { (dc5.*(-1)), (dc4.*(-1)), (dc3.*(-1)), (dc2.*(-1)), (dc1.*(-1)), dc0, dc1, dc2, dc3, dc4, dc5};
    
    disp('blah')
    header = 'echo "Requested Voltage, Max, Min, Delta, Avg, Deviation of Avg from Request" > ao_report.txt';
    command = header;
    [status,command] = system(command);
    
    for i=1:num_levels
	   disp(i)
        %CH_array = make_CH_array(levels{i});
        CH_array = make_CH_array(levels{i});
        new_wavegen_go(CH_array)
        pause(5);
        
        % Pull from TCP/IP port
        % hexdump redirect
	   command = sprintf('D:\cygwin64\bin\bash --login -c nc acq2006_014 4210 | dd bs=13200000 iflag=fullblock count=1 > shot_data');
		[status,command] = system(command);
		
		command = sprintf('D:\cygwin64\bin\bash --login -c hexdump -e ''32/4 ''%%10d," 2/2 "%u," "\n"'' ./shot_data > shot_data_csv')
		%[status,command] = system(command);
        [status,command] = system(command);
        % Load
	   load 'D:\cygwin64\home\scott\shot_data'
        
        % Index in 5k for all CH into array
        sample_array = shot_data_csv(5000,1:32);
        % Scale to volts
        sample_array = sample_array.*(20/2^32);
        
        
	   % Requested Voltage
	   
	   
        % Max - Min
	   max_volts = max(sample_array);
	   min_volts = min(sample_array);
	   delta = max_volts - min_volts;
	   
        % Avg
	   avg = mean(sample_array);
	   
        % Deviation from requested voltage
	   deviation = abs(val_volts(i) - avg);
	   
        % Noise
        
        % Append to file
	   report = sprintf("%d, %d, %d, %d, %d, %d\n",val_volts(i),max_volts,min_volts,delta,avg,deviation);
	   disp(report)
	   command = sprintf("echo '%s' >> ao_report.txt",report);
	   [status,command] = system(command);        
    end
end