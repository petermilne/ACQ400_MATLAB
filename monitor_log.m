%% monitor_log.m
% Simple function to provide user feedback for long transients.
function done = monitor_log(monitor)
    global UUT %Make base workspace variable visible in function
    
    ID = tcpip(UUT,2235); % 4220 = System Controller
    ID.terminator = 10; % ASCII line feed
    ID.InputBufferSize = 100;
    ID.Timeout = 60;
    fopen(ID);
    
    sample_count ='0';
    
    if strcmp(monitor,'trigger') == 1
    
        while(1)
            readback = fscanf(ID);
            
            if strcmp(readback(1),'3') == 1
                fprintf('\n...Trigger received...\n\n');
                break;
            end
        end
        
    elseif strcmp(monitor,'samples_captured') == 1
        
        while(1)
            readback = fscanf(ID);
                     
            if (strcmp(readback(1),'1') == 1 || strcmp(readback(1),'2') == 1 || strcmp(readback(1),'3') == 1)
                readback = textscan(readback,'%f');
                readback = readback{1}';
                
                if strcmp(sample_count,readback(3)) == 0
                    readout = sprintf('   Samples captured = %f\n',readback(3));
                    fprintf(readout);
                    sample_count = readback(3);
                end
                
            elseif (strcmp(readback(1),'0') == 1 || strcmp(readback(1),'4') == 1)
                fclose(ID);
                delete(ID);
                done = 1;
                return;
            end
            
        end
        
    end
    
    fclose(ID);
    delete(ID);
end