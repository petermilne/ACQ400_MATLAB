function CHx =  read_acq_chan2(UUT,CH,n_samp)
    t = tcpip(UUT,53000+CH);
    t.terminator = '';
    t.InputBufferSize = 2*n_samp;
    t.Timeout = 60;
    fopen(t);
    CHx = fread(t,n_samp,'int16');
    fclose(t);
    
    filename = sprintf('%s_%02d.bin',UUT,CH);
    f = fopen(filename,'w');
    fwrite(f,CHx,'int16',0,'b');
    fclose(f);
    
    f = fopen(filename,'r');
    CHx = fread(f,n_samp,'int16');
    fclose(f);
end