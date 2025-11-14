function outputTest(obj, filename)

    % FUNCTION: test output method of the object

    % INPUTS:
        % obj: object to test output method
        % filename: file name to write stuff

    obj.output();
    obj.output(1);
    
    %open file
    fid = fopen(filename, 'w');
    if fid == -1
        error('Error during file opening.');
    end
    
    obj.output(fid) %write
    fclose(fid); %close
end