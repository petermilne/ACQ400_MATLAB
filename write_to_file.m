function write_to_file(filename,x)
    sin_open_ID = fopen(filename,'w')
    fwrite(sin_open_ID,x,'int16')
    fclose(sin_open_ID)
end