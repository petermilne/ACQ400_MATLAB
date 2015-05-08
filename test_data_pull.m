function test_data_pull(num_runs)

for run_count=1:num_runs
        channel=53002;
        disp(i);
        resolution = 16;
        num_samp = 10000;
        CH = tcpip('acq2006_019',channel);
        set(CH,'ByteOrder','littleEndian'); % Set link endianness
        CH.terminator = 10; % ASCII carriage returns
        if resolution == 32
            CH.InputBufferSize = num_samp*32; % num_samp * 32 bits
        elseif resolution == 16
            CH.InputBufferSize = num_samp*16; % num_samp * 16 bits
        end
        CH.Timeout = 10;
        fopen(CH);
        
        if resolution == 32
            CH2 = fread(CH,num_samp,'int32');
        elseif resolution == 16
            CH2 = fread(CH,num_samp,'int16');
        end
        
        fclose(CH);
        delete(CH);
        whos CH2
end