function [H, rhoScaleV, thetaScaleV] = HoughTransform(Im, threshold, rhoRes, thetaRes)
tamanho = size(Im);
maxRho = sqrt(tamanho(1)^2+tamanho(2)^2);

rhoScaleV = -maxRho:rhoRes:maxRho;
thetaScaleV = -pi/2:thetaRes:pi/2;

[~, Nrho] = size(rhoScaleV);
[~, Ntheta] = size(thetaScaleV);

H = zeros(Nrho,Ntheta);

co = cos(thetaScaleV);
si = sin(thetaScaleV);


%distance = @(x,y,itheta) (x*co(itheta) + y*si(itheta));
[imgy, imgx] = find(Im >= threshold);

tamanhox = size(imgx);

for i = 1:tamanhox(1)
    for j = 1:Ntheta
        valor = round((distance(imgx(i),imgy(i),j))/rhoRes,0);
        if(valor <= 0)
            H(round(maxRho/rhoRes,0)-abs(valor),j) = H(round(maxRho/rhoRes,0)-abs(valor),j) + Im(imgy(i),imgx(i));
        else
            H(valor+round(maxRho/rhoRes,0),j) = H(valor+round(maxRho/rhoRes,0),j) + Im(imgy(i),imgx(i));
        end
    end
end
end

function d = distance(x,y,itheta)
    d = (x*co(itheta) + y*si(itheta));
end
