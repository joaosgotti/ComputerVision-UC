function imgOut = showKeyPts(img,keyPts)
    imgOut = img;
    colorN = 1;
    for i = 1:length(keyPts(:,1))
        Theta = keyPts(i,3);
        s = ceil(keyPts(i,4))*2;
        if mod(s,2) == 1
            s = s - 1;
        end
        Rot = [cos(Theta) -sin(Theta) keyPts(i,1);
               sin(Theta) cos(Theta)  keyPts(i,2);
               0                0     1];

        PiL = Rot*[0 0 1]';
        PfL = Rot*[s 0 1]';
        PR1 = Rot*[-s;s;1];                       %1----2
        PR2 = Rot*[s;s;1];                        %|    |
        PR3 = Rot*[s;-s;1];                       %4----3
        PR4 = Rot*[-s;-s;1];
        switch colorN
            case 1
                color = 'red';
            case 2
                color = 'blue';
            case 3
                color = 'yellow';
            case 4
                color = 'green';
            case 5
                color = 'cyan';
            case 6
                color = 'magenta';
            case 7
                color = 'black';
            case 8
                color = 'white';
        end
        imgOut = insertShape(imgOut, 'Line',[PiL(1) PiL(2) PfL(1) PfL(2)],'LineWidth',1,'Color',color);
        imgOut = insertShape(imgOut, 'Line',[PR1(1) PR1(2) PR2(1) PR2(2)],'LineWidth',1,'Color',color);
        imgOut = insertShape(imgOut, 'Line',[PR2(1) PR2(2) PR3(1) PR3(2)],'LineWidth',1,'Color',color);
        imgOut = insertShape(imgOut, 'Line',[PR3(1) PR3(2) PR4(1) PR4(2)],'LineWidth',1,'Color',color);
        imgOut = insertShape(imgOut, 'Line',[PR4(1) PR4(2) PR1(1) PR1(2)],'LineWidth',1,'Color',color);
        
        colorN = colorN + 1;
        if colorN > 8
            colorN = 1;
        end
    end
end

