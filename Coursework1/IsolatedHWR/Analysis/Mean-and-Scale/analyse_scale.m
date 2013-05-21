% analyse_scale.m
%
% Loads in a file and plots a histograph based on it.
%
% Usage: matlab -r analyse_scale

% Will crash if the file does not exist, with nasty consequences!
load('.bHisto.dat','-ascii');

% Loading the file creates a 2D N-by-2 matrix, where the first row
% is the mean value, and the second row the number of times
% it occurs.
bKey = bHisto(1,:);
bVal = bHisto(2,:);

plot(bKey,bVal);
saveas(gcf, 'bHisto.png');

quit;
