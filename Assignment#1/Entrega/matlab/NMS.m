function [imgOUT] = NMS(imgIN, limiar,type)
%0 - gradient
%1 - neighbors
Case1 = @(angle) ((round(abs(angle)) == 0) || (round(abs(angle)) == 4))*1;
Case2 = @(angle) ((round(angle) == 1) || (round(angle) == -3))*2;
Case3 = @(angle) ((round(angle) == 2) || (round(angle) == -2))*3;
Case4 = @(angle) ((round(angle) == 3) || (round(angle) == -1))*4;
Cases = @(angle) Case1(angle) + Case2(angle) + Case3(angle) + Case4(angle);

[i,j] = size(imgIN);

imgOUT = zeros(i,j);
imgP = zeros(3,3);

padIMG = padarray(imgIN, [1 1], 'replicate', 'both');

[Frow,Fcol] = find(imgIN >= limiar);
[sizeRow,~] = size(Frow);

for index = 1:sizeRow
    imgP(1:3,1:3) = padIMG(Frow(index):Frow(index)+2,Fcol(index):Fcol(index)+2);
    
    gX =  conv2(imgP,[-1 0 1]);
    gY =  conv2(imgP,[-1; 0; 1]);
    angle = Cases(atan2(-gY(2,2),gX(2,2))*180/(pi*45));%Define os angulos em apenas 8 partes.
    
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
end
end


