function carrier_ready()
    global UUT %Make base workspace variable visible in function
    tic
    while(1)
        % Check that Carrier has completed boot
        done_url = sprintf('http://%s/d-tacq/rc-local-complete',UUT);
        [done_string,url_status] = urlread(done_url,'Timeout',5);
        if url_status == 0
            fprintf(2,'D-TACQ Carrrier is booting! Please wait a moment and try again...\n');
            pause(2);
        else
            fprintf('\nD-TACQ Carrrier is READY!\n');
            toc
            return;
        end
    end
end