% Numerical Integration utilizing the Trapezoidal Rule 
% https://www.mathworks.com/help/matlab/ref/trapz.html

%% default parameters
lowerLim = 903.5;
upperLim = 919.5;
dirData = strcat(pwd, '\test data');    % start in current folder, add subfolder

%% read data, display details 
msg = 'Input Data File ...';
[inpPathname, inpFilename, header, xRaw, dx, yRaw] = readTxtFile(dirData, msg);
xMin = min(xRaw); xMax = max(xRaw);
Npt = length(xRaw);
fprintf('\tData: %s\n\tHeader: %s\n\t# data points: %d\n\tx range: %.2f - %.2f, with spacing %0.2f\n', ...
    fullfile(inpPathname, inpFilename), header, Npt, xMin, xMax, dx);
fprintf('\n');

%% specify integration limits
dummy = input(sprintf('Enter the lower integration limit (default %0.2f): ', lowerLim));
if ~isempty(dummy) 
    if ( dummy >= xMin ) && ( dummy < xMax ) 
        lowerLim = dummy;
    elseif ( lowerLim >= xMin ) && ( lowerLim < xMax ) 
        fprintf('\tUsing default value\n');
    else
        lowerLim = xMin;
        fprintf('\tOut of range - using minimum value\n');
    end
else
    if ( lowerLim >= xMin ) && ( lowerLim < xMax ) 
        fprintf('\tUsing default value\n');
    else
        lowerLim = xMin;
        fprintf('\tOut of range - using minimum value\n');
    end
end

dummy = input(sprintf('Enter the upper integration limit (default %0.2f): ', upperLim));
if ~isempty(dummy)
    if ( dummy > lowerLim ) && ( dummy <= xMax ) 
        upperLim = dummy;
    elseif ( upperLim > lowerLim ) && ( upperLim <= xMax )
        fprintf('\tUsing default value\n');
    else
        upperLim = xMax;
        fprintf('\tOut of range - using maximum value\n');
    end
else
    if ( upperLim > lowerLim ) && ( upperLim <= xMax )
        fprintf('\tUsing default value\n');
    else
        upperLim = xMax;
        fprintf('\tOut of range - using maximum value\n');
    end
end

%% truncate data
xInt = x(x >= lowerLim & x <= upperLim);
yInt = y(x >= lowerLim & x <= upperLim);

%% calculate
mySum = dx*sum(yInt);
corr = ( yInt(1) + yInt(end) )/2;
myTrap = dx*( sum(yInt) - corr );

%% print results
fprintf('\n')
fprintf('Integrate from %0.2f - %0.2f:\n', min(xInt), max(xInt))
fprintf('\tSum = %f\n', mySum)
fprintf('\tTrapezoidal Rule = %f\n', myTrap)
fprintf('\t(correction term = %f)\n', corr)
fprintf('\tTrapz(x) = %f\n', trapz(xInt, yInt))   % MATLAB function, corrects for non-unit spacing

%% plot results
figure(399); clf; set(399,'Name','Numerical Integration');
ax = gca;
plot(x,y)
ylim auto
hold on
hh = plot([lowerLim,lowerLim],[ax.YLim(1),ax.YLim(2)],[upperLim,upperLim],[ax.YLim(1),ax.YLim(2)]); 
hh(1).LineStyle = '--';  hh(1).LineWidth = 1.0;  hh(1).Color = 'r';
hh(2).LineStyle = '--';  hh(2).LineWidth = 1.0;  hh(2).Color = 'r';
title(sprintf('limits: %0.2f - %0.2f, dx = %0.2f, Sum*dx = %.6G, Trapz = %.6G', min(xInt), max(xInt), dx, mySum, myTrap))
plotbrowser 'on'

%% function(s)

function [inpPathname, inpFilename, header, xRaw, dx, yRaw] = readTxtFile(inputDir, msg)
% Reads a txt file and returns the 1st two data columns as doubles

    % read txt file with or w/o header ...
    [inpFilename, inpPathname] = uigetfile('*.txt', msg, inputDir);
    if isequal(inpFilename, 0)                          % user cancelled operation
        error('Error: File open cancelled by user ... halting execution.');
    end

    [fileID,errmsg] = fopen(fullfile(inpPathname, inpFilename));
    if ~isempty(errmsg)
        error('Error: File open error ... halting execution.');
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
        error('Error: Missing or invalid input data ... halting execution.');
    end
    
end
