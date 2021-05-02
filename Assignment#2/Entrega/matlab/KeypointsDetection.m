function [Pts] = KeypointsDetection(Img,Pts)
%Pts = [x,y,orientation,scale]

p = size(Pts,2);
G = fspecial('gaussian',13,2.0);
S = fspecial('sobel');

ImgG = ImageFilter(Img,G);
ImgSx = ImageFilter(ImgG,S');
ImgSy = ImageFilter(ImgG,S);

sig = zeros(p,1);

Pscale = zeros(p,1);

mImg = 0;
k = 1.3;
j = 2:7;

scalmax = max(2*ceil(3*(2.1.*k.^(j)))+1,[],'all');
Img = padarray(Img,[(2*ceil(3*scalmax/2)+1) (2*ceil(3*scalmax/2)+1)], 'both');

for i = 1:p
    for j = 2:7 %num of scales to check
        scal = 2.1*k^(j);
        L1 = scal^(2)*fspecial('log',2*ceil(3*scal)+1,scal);
        increment = floor(size(L1,1)/2);
        ImgL = sum(L1.*Img(Pts(1,i)+floor((2*ceil(3*scalmax)+1)/2)-increment:Pts(1,i)+floor((2*ceil(3*scalmax)+1)/2)+increment,Pts(2,i)+floor((2*ceil(3*scalmax)+1)/2)-increment:Pts(2,i)+floor((2*ceil(3*scalmax)+1)/2)+increment),'all');
        
        if (max(abs(max(ImgL,[],'all')),abs(min(ImgL,[],'all')))> mImg )
            Pscale(i) = scal;
        elseif(max(abs(max(ImgL,[],'all')),abs(min(ImgL,[],'all')))== mImg )
            Pscale(i) = 0;
        end
        
        mImg = max(abs(max(ImgL,[],'all')),abs(min(ImgL,[],'all')));
    end
    %find orientation
    sig(i) = atan2(ImgSy( Pts(1,i),Pts(2,i) ),ImgSx( Pts(1,i),Pts(2,i) ));
end

Pts = Pts';
[x,~] = find(Pscale);
Pts = [Pts(x,2),Pts(x,1),sig(x),Pscale(x)];

end
        