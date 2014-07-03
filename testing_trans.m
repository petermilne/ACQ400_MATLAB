clear CHx

CH = tcpip(UUT,channel);
CH.terminator = 10;
CH.InputBufferSize = num_samp*8;
set(CH,'ByteOrder','littleEndian'); % Set link endianness
CH.Timeout = 60;

fopen(CH);
CHx = fread(CH,0.5*num_samp,'int32');
fclose(CH);