function [inpPathname, inpFilename, header, xRaw, dx, yRaw] = readTxtFile(inputDir, msg)
% Reads a txt file and returns the 1st two data columns as doubles

    narginchk(2,2)          % check # of input arguments

    % read txt file with or w/o header ...
    [inpFilename, inpPathname] = uigetfile('*.txt', msg, inputDir);
    if isequal(inpFilename, 0)                          % user cancelled operation
        error('Error: File open cancelled by user ... halting execution.')
    end

    [fileID,errmsg] = fopen(fullfile(inpPathname, inpFilename));
    if ~isempty(errmsg)
        error('Error: File open error ... halting execution.')
    end

    % check for header ...
    line = fgetl(fileID); headertest = sscanf(line, '%s');
    if (headertest(1) == '#')
        header = strtrim(line(2:end));  % remove '#' as well as leading and trailing white-space characters     
    else
        header = ' ';
    end
    data_in = readmatrix(fullfile(inpPathname, inpFilename), 'OutputType', 'double', 'FileType', 'text');
    fclose('all');

    xRaw = data_in(:,1);
    dx = ( max(xRaw) - min(xRaw) )/( length(xRaw) - 1 );    % x-spacing
    yRaw = data_in(:,2);
    
    % confirm that data is valid by comparing the number of non-zero values
    if isempty(xRaw) || length(xRaw) ~= length(yRaw) 
        error('Error: Missing or invalid input data ... halting execution.')
    end
    
end