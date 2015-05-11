%% monitor_log.m
% Simple function to provide user feedback for long transients.
function monitor_log()
    global UUT %Make base workspace variable visible in function
    
    ID = tcpip(UUT,2235); % 2235 = Transient Log
    ID.terminator = 10; % ASCII line feed
    ID.InputBufferSize = 200;
    ID.Timeout = 60;
    fopen(ID);
    
    sample_count ='0';
    lastwarn('');
    
    while(1)
        readback = fscanf(ID);
        if findstr('Unsuccessful read',lastwarn)
            disp('I caught a timeout')
            lastwarn('');
            readback = fscanf(ID);
        end
        
        if strcmp(readback(1),'3') == 1 % When we move out of arm we know trigger has been received.
            fprintf('\n...Trigger received...\n\n');
            fprintf('...Running Transient Capture ...\n');
            break;
        end
    end
    
    
    while(1)
        readback = fscanf(ID);
        if findstr('Unsuccessful read',lastwarn)
            disp('I caught a timeout')
            lastwarn('');
            readback = fscanf(ID);
        end
                 
        if (strcmp(readback(1),'1') == 1 || strcmp(readback(1),'2') == 1 || strcmp(readback(1),'3') == 1) % If transient is ongoing printout number of samples captured so far.
            readback = textscan(readback,'%f');
            readback = readback{1}';
            
            if strcmp(sample_count,readback(3)) == 0 % Only printout when sample number has updated.
                readout = sprintf('   Samples captured = %i\n',readback(3));
                fprintf(readout);
                sample_count = readback(3);
            end
            
        elseif (strcmp(readback(1),'0') == 1 || strcmp(readback(1),'4') == 1) % Transient complete. Set done flag and escape.
            fclose(ID);
            delete(ID);
            done = 1;
            fprintf('\n...Post-processing...\n');
            return;
        end        
    end
end    