function [imgOUT] = NMS(imgIN,threshold,type,NMSsize)
%0 - gradient NMS
%1 - neighbors NMS - default

if nargin < 1
    error('Error. \nNot enough inputs.');
elseif nargin == 1
    warning('Calling this function without threshold can take a while.');
    threshold = 0.5;
    type = 1;
    NMSsize = 3;
elseif nargin == 2
    type = 1;
    NMSsize = 3;
elseif nargin == 3
    NMSsize = 3;
elseif (nargin == 4) && (mod(NMSsize,2) ~= 1)
    NMSsize = NMSsize + 1;
    warning('NMSsize must be an odd number. NMSsize was set to %d', NMSsize);
end


Case1 = @(angle) ((round(abs(angle)) == 0) || (round(abs(angle)) == 4))*1;
Case2 = @(angle) ((round(angle) == 1) || (round(angle) == -3))*2;
Case3 = @(angle) ((round(angle) == 2) || (round(angle) == -2))*3;
Case4 = @(angle) ((round(angle) == 3) || (round(angle) == -1))*4;
Cases = @(angle) Case1(angle) + Case2(angle) + Case3(angle) + Case4(angle);

[sizeI,sizeJ] = size(imgIN);

imgOUT = zeros(sizeI,sizeJ);
imgP = zeros(NMSsize,NMSsize);


centerIndex = ceil(NMSsize/2);

padIMG = padarray(imgIN, [centerIndex-1 centerIndex-1], 'replicate', 'both');

[Frow,Fcol] = find(imgIN >= threshold);
[sizeRow,~] = size(Frow);

for index = 1:sizeRow
    if NMSsize == 3
        imgP(1:3,1:3) = padIMG(Frow(index):Frow(index)+2,Fcol(index):Fcol(index)+2);
        if type == 0
            gX =  ImageFilter(imgP,[-1 0 1]);
            gY =  ImageFilter(imgP,[-1; 0; 1]);
            angle = Cases(atan2(-gY(2,2),gX(2,2))*180/(pi*45));%Define os angulos em apenas 8 partes.
        end
        
        factor = imgP(2,2);
        
        if(type == 0)
        switch angle
            case 1
                imgOUT(Frow(index),Fcol(index)) = ((imgP(2,1) < imgP(2,2)) && (imgP(2,3) < imgP(2,2)))*factor;
            case 2
                imgOUT(Frow(index),Fcol(index)) = ((imgP(1,3) < imgP(2,2)) && (imgP(3,1) < imgP(2,2)))*factor;
            case 3
                imgOUT(Frow(index),Fcol(index)) = ((imgP(1,2) < imgP(2,2)) && (imgP(3,2) < imgP(2,2)))*factor;
            case 4
                imgOUT(Frow(index),Fcol(index)) = ((imgP(1,1) < imgP(2,2)) && (imgP(3,3) < imgP(2,2)))*factor;
        end
        else
            temp = imgP;
            temp(2,2) = 0;
            if imgP(2,2) > max(temp)
                imgOUT(Frow(index),Fcol(index)) = factor;
            end
        end
    else
        imgP(1:NMSsize,1:NMSsize) = padIMG(Frow(index):Frow(index)+(NMSsize-1),Fcol(index):Fcol(index)+(NMSsize-1));
        temp = imgP;
        temp(centerIndex,centerIndex) = 0;
        if imgP(centerIndex,centerIndex) > max(temp)
            imgOUT(Frow(index),Fcol(index)) = 1;
        end
    end
    
    
    
end
end


