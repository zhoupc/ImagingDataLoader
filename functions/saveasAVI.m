function saveasAVI(Y,avi_nm)
% export a 3D matrix data to movie
%avi_nm: string, file name

T = size(Y, ndims(Y));
if ~exist('avi_nm', 'var') || isempty(avi_nm)
    avi_nm = 'a_movie_with_no_name.avi';
end

Y = uint8(Y/max(Y(:))*255);
% [d1, d2, T] = size(Y);
% Y = reshape(Y, [d1, d2, 1, T]);

avi_file = VideoWriter(avi_nm, 'Grayscale AVI'); 
avi_file.open();
for m=1:T
    avi_file.writeVideo(squeeze(Y(:, :,  m)));
end
avi_file.close();
