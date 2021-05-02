function [Descriptors] = FeatureDescriptor(Img,Pts,Dscpt_type,Patch_size)

if mod(Patch_size,2) == 0
    Patch_size = Patch_size + 1;
    warning('Patch_size must be a odd value. Patch_size set to %g\n', Patch_size);
end

s = floor(Patch_size/2);
Descriptors.patch = zeros(length(Pts),Patch_size^2);
Descriptors.keyPoints = zeros(length(Pts),4);

ImgP = padarray(Img,[s s],'replicate','both');

switch Dscpt_type
    case 'SIMPLE'
        for n = 1:length(Pts)
            tempImg = ImgP(((Pts(n,2)-s):(Pts(n,2)+s))+s,((Pts(n,1)-s):(Pts(n,1)+s))+s);
            Descriptors.patch(n,:) = tempImg(:);
            Descriptors.keyPoints(n,:) = Pts(n,1:4);
        end
    case 'MOPS'
        N = 2*sqrt(2)*Pts(:,4);
        s = 2*floor(max(abs(N),[],'all')/2)+1;
        
        ImgP = padarray(Img,[s s],'replicate','both');
        Descriptors.patch = zeros(length(Pts),8^2);

        for n = 1:length(Pts)
            N = 2*sqrt(2)*Pts(n,4);
            s = floor(N/2);
            
            tempImg = ImgP(((Pts(n,2)-s):(Pts(n,2)+s))+s,((Pts(n,1)-s):(Pts(n,1)+s))+s);
            sigma = Pts(n,3);
            
            tMatrix = [cos(-sigma) -sin(-sigma) 0;
                       sin(-sigma) cos(-sigma) 0;
                        0 0 1];
            tMatrix = affine2d(tMatrix);
            tempImg = imwarp(tempImg,tMatrix);
            tempImg = imresize(tempImg,[8 8]);
            tempImg = (tempImg - mean(tempImg(:)))./std(tempImg(:));
            Descriptors.patch(n,:) = tempImg(:);
            Descriptors.keyPoints(n,:) = Pts(n,:);
        end
end

end