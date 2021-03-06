%% boot_complete
% This function tests if the D-TACQ carrier has completed its boot sequence
% by monitoring a file on the card via http.
%%
function result = boot_complete()
    global UUT %Make base workspace variable visible in function
    
    done_url = sprintf('http://%s/d-tacq/rc-local-complete',UUT);
    [done_string,url_status] = urlread(done_url,'Timeout',2);
    if url_status == 0
        fprintf(2,'D-TACQ Carrrier is booting! Please wait a moment and try again...\n');
        result = 0;
        %return;
    else
        result = 1;
    end
    
end
