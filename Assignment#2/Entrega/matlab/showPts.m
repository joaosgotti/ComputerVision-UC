function imgOut = showPts(img,Pts,size)
    s = ceil(size/2);
    imgOut = img;
    for i = 1:length(Pts(1,:))
        
        imgOut = insertShape(imgOut, 'Line',[Pts(2,i)-s Pts(1,i) Pts(2,i)+s Pts(1,i)],'LineWidth',1,'Color','red');
        imgOut = insertShape(imgOut, 'Line',[Pts(2,i) Pts(1,i)-s Pts(2,i) Pts(1,i)+s],'LineWidth',1,'Color','red');
        
    end
end

