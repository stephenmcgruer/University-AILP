% analyse_mean.m
%
% Loads in two files and plots two graphs
% based on the data in them.
%
% Usage: matlab -r analyse_mean


% Will crash if the file does not exist, with nasty consequences!
load('.xHisto.dat','-ascii');
load('.yHisto.dat','-ascii');

% Each file creates a 2D N-by-2 matrix, where the first row
% is the mean value, and the second row the number of times
% it occurs.
xKey = xHisto(1,:);
xVal = xHisto(2,:);
yKey = yHisto(1,:);
yVal = yHisto(2,:);


plot(xKey,xVal);
saveas(gcf, 'xHisto.png');

% For some reason, this line is necessary or the output
% of the second plot will be distorted. I do not know
% enough matlab to have *ANY* idea why this might be.
% Note that the 'Visible' parameter is ALREADY "On" when
% this code runs.
figure('Visible','On')

plot(yKey,yVal);
saveas(gcf, 'yHisto.png');

quit;
