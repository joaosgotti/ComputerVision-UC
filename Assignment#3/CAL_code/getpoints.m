function [xy XYZ] = getpoints(img)
img='images/image001.jpg'
imagem=imread(img);
figure;imshow(imagem)
hold on
% Initially, the list of points is empty.
xy = [];
XYZ = [];
n = 0;
% Loop, picking up the points.
disp('Left mouse button picks points.')
disp('Right mouse button picks last point.')
but = 1;
zoom on;
while but == 1
    %keyboard;
    [xi, yi, but] = ginput(1);
    hold on;
    plot(xi, yi, 'ro')
    hold off;
    n = n+1;
    xy(:, n) = [xi; yi]; % add a new column with the current values
    input = inputdlg('[X Y Z]'); % show input dialog
    XYZi = str2num(input{1}); % convert to number
    XYZ(:, n) = XYZi; % add a new column with the current values
end
dlmwrite (' xy.txt ',xy);
dlmwrite('XYZ.txt',XYZ);


end