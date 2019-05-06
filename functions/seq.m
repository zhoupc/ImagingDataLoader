function sequence = seq(boundary, interval)
% generate a sequence of values given edges and boundaries 
if ~exist('interval', 'var')
    interval = 1; 
end 

sequence = (boundary(1):interval:boundary(2)); 