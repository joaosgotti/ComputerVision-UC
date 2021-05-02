function [Pts] = HarrisCorner(img0,thresh,sigma_d,sigma_i,NMS_size)
    k = 0.04;
    
    Ksize_d = 2*ceil(3*sigma_d)+1;
    Ksize_i = 2*ceil(3*sigma_i)+1;
    kg = fspecial('gaussian',Ksize_d,sigma_d);
    kgi = fspecial('gaussian',Ksize_i,sigma_i);
    ksx = fspecial('sobel')';
    ksy = fspecial('sobel');
                 
    
    kernelgX = ImageFilter(kg,ksx);
    kernelgY = ImageFilter(kg,ksy);
    kernelgXY = ImageFilter(kernelgX,kernelgY);
    
    
    Igx = ImageFilter(img0,kernelgX);
    Igy = ImageFilter(img0,kernelgY);
    Igxy = ImageFilter(img0,kernelgXY);
    
    
    Igxg = ImageFilter(Igx.^2,kgi);
    Igyg = ImageFilter(Igy.^2,kgi);
    
    
    imgPts = Igxg.*Igyg - Igxy - k*(Igxg + Igyg).^2;
    
    [PtsRow,PtsCol] = find(NMS(imgPts,thresh,1,NMS_size) ~= 0);
    
    Pts(1,:) = PtsRow;
    Pts(2,:) = PtsCol;
    
    
    
end
    
                
        
        
