function testOutput(obj, filename)
    obj.output();
    obj.output(1);
    
    % create filename
    
    %open file
    fid = fopen(filename, 'w');
    if fid == -1
        error('Errore nell''apertura del file.');
    end
    
    obj.output(fid) %write
    fclose(fid); %close
end