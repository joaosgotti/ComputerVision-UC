function [img1] = ImageFilter(img0, h)
%Aplica o filtro h na imagem img0.
%   img1 = ImageFilter(img0,h)
    h = double(h);
    [rh,ch] = size(h);

    increment = max(floor(ch/2),floor(rh/2));

    paddedImg = im2double(padarray(img0, [increment increment],'replicate','both'));

    [r,c] = size(paddedImg);
    imgtemp = zeros(size(paddedImg));

    if(rh>1 && ch>1)
            for i = 1+increment:r-increment
                for j = 1+increment:c-increment
                   imgtemp(i,j) = (1/ch)*sum(h.*paddedImg(i-increment:i+increment,j-increment:j+increment),'all');
                end
            end
    elseif(rh==1)
        hconv1 = repmat(h,[ceil(r/rh) 1]);
        for j = 1+increment:1:c-increment
            imgtemp(:,j) =(1/rh)*sum(hconv1(1:r,:)'.*paddedImg(:,j-increment:j+increment)')';
        end
    elseif(ch==1)
        hconv2 = repmat(h,[1 ceil(c/ch)]); 
        for i = 1+increment:1:r-increment
            imgtemp(i,:) = (1/ch)*sum(hconv2(:,1:c).*paddedImg(i-increment:i+increment,:));
        end
    else
        error('Kernel must be a vector or a rank 1 square matrix!');
    end
    img1 = imgtemp(1+increment:end-increment,1+increment:end-increment);
    img1 = img1./max(img1(:));
end