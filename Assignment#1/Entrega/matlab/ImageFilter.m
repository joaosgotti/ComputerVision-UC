function [img1] = ImageFilter(img, h)
    
    h = double(h); %kernel       
    [u,s,v] = svd(h); %single values decomposition
    s = diag(s); %vetor das diagonais
    
    if dot(s,s) ~= s(1,1)^2 %verificando a sepabilidade do kernel
        error('Erro! Este Kernel não é separavel!');
        
    else
        h_vertical   = u(:,1)  * sqrt(s(1)); %kernel horizontal
        h_horizontal = v(:,1)' * sqrt(s(1)); %kernel vertical
    end
    
    % incrementar padding na imagem
    [Xh,Yh] = size(h); %tamanho do kernel
    %tamanho incremental do padding 
    Xpad = (Xh-1)/2; Ypad = (Yh-1)/2;
    
    padded_img = padarray(img,[Xpad, Ypad],'replicate','both'); %incrementação
    
    [Xpadded, Ypadded] = size(padded_img);
    [Ximg, Yimg] = size(img);
    img1 = zeros([Ximg, Yimg]); %"alocando" espaço para a imagem convoluida
    
    %transitar através das linhas usando o kernel vertical
    h_ext1 = repmat(h_vertical,[1,Ypadded]);
    for i= 1+Xpad : Xpadded-Xpad
        X_val = padded_img(i-Xpad:i+Xpad,:); 
        intermed_X = X_val.*h_ext1;
        novaLinha = sum(intermed_X);
        vConvImg(i-Xpad,:) = novaLinha;
    end
    %transitar através das linhas usando o kernel horizontal
    
    h_ext2 = repmat(h_horizontal,[Ximg,1]);

    for j= 1+Ypad : Ypadded-Ypad
        Y_val = vConvImg(:,j-Ypad:j+Ypad);
        novaColuna = sum(h_ext2.*Y_val,2)';
        img1(:,j-Ypad) = novaColuna;
    end    
    
end    
        
