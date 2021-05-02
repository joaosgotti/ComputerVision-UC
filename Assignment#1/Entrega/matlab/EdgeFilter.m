function [img1] = EdgeFilter(img0, sigma)

% smoothed image
hSize = 2*ceil(3*sigma)+1; %kernel size
smoothedImg = ImageFilter(img0,fspecial('gaussian',hSize,sigma));


% image gradients
hy = ImageFilter(smoothedImg, fspecial('sobel'));
hx = ImageFilter(smoothedImg,-(fspecial('sobel'))');
mag = sqrt(hx.^2 + hy.^2);

angulo= rad2deg(atan2(hy,hx));
angulo_padded = padarray(angulo,[1 1],'replicate','both');
mag_padded = padarray(mag,[1 1],'replicate','both');

[nLin, nCol] = size(angulo);
[nLin_padded, nCol_padded] = size(angulo_padded);

mag_aux = zeros(size(angulo_padded));

zona = angulo_padded; 
%classificação entre zonas (1,2,3,4)
for i=1:nLin_padded 
    for j = 2:nCol_padded
       if (zona(i,j) < 0)
           zona(i,j)= zona(i,j)+180; 
       end
       zona(i,j)=round(zona(i,j)/45)+1;
       if(zona(i,j)==5)
           zona(i,j)=1; 
       end
    end
end 

for i=2:nLin_padded-1
    for j = 2:nCol_padded-1
        %compara com os vizinhos horizontais e zera a magnitude se não for o maior local
        if(zona(i,j)==1)
            if((mag_padded(i,j)>mag_padded(i,j+1)) && (mag_padded(i,j)>mag_padded(i,j-1)))
                mag_aux(i-1,j-1) = mag_padded(i,j);
            end
        %compara com os vizinhos diagonais 1 e zera a magnitude se não for o maior local    
        elseif(zona(i,j)==2)
            if((mag_padded(i,j)>mag_padded(i-1,j+1)) && (mag_padded(i,j)>mag_padded(i+1,j-1)))
                mag_aux(i-1,j-1) = mag_padded(i,j);
            end
        %compara com os vizinhos verticais e zera a magnitude se não for o maior local   
        elseif(zona(i,j)==3)
             if((mag_padded(i,j)>mag_padded(i-1,j)) && (mag_padded(i,j)>mag_padded(i+1,j)))
                mag_aux(i-1,j-1) = mag_padded(i,j);
             end
        %compara com os vizinhos diagonais 2 e zera a magnitude se não for o maior local    
        elseif(zona(i,j)==4)
            if((mag_padded(i,j)>mag_padded(i-1,j-1)) && (mag_padded(i,j)>mag_padded(i+1,j+1)))
               mag_aux(i-1,j-1) = mag_padded(i,j);
             end
        end
    end
end

%eliminar ruido
mag = mag_aux>0.1;

img1 = mag;
end
                
        
        
