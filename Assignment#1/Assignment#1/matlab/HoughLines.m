function [rhos, thetas] = HoughLines(H, nLines)
[~,~,v] = find(H);
m = mean(v);
in = NMS(H,m,1);
[~,i] = sort(in(:),'desc');
[rhos,thetas] = ind2sub(size(in),i(1:nLines));
end