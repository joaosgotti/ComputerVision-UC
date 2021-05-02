function MatchImg = markMatch(Match, img1, img2, orientation, debug)
    varver = 0;
    varhor = 0;
    if size(img1,1)>size(img2,1) || size(img1,2)>size(img2,2)
        varver = (size(img1,1) - size(img2,1))/2;
        varhor = (size(img1,2) - size(img2,2))/2;
        
        img2 = padarray(img2,[varver varhor]);
    elseif size(img1,1)<size(img2,1) || size(img1,2)<size(img2,2)  
        varver = (size(img2,1)-size(img1,1))/2;
        varhor = (size(img2,2)-size(img1,2))/2;
        
        img1 = padarray(img1,[varver varhor]);
    end
    size1 = size(img1);
    switch orientation
        case 'vertical'
            MatchImg = [img1; img2];
            sizH = varhor;
            sizV = size1(1) + varver;
        case 'horizontal'
            MatchImg = [img1 img2];
            sizH = size1(2) + varhor;
            sizV = varver;
    end

    colorN = 1;
    if debug
        IMG = MatchImg;
        figure('units','normalized','outerposition',[0 0 1 1]);
    end
    for i = 1:length(Match.keyPoints1(:,1))
        Theta = Match.keyPoints1(i,3);
        Theta2 = Match.keyPoints2(i,3);
        s = ceil(Match.keyPoints1(i,4))*2;
        s2 = ceil(Match.keyPoints2(i,4))*2;
        if mod(s,2) == 1
            s = s - 1;
        end
        if mod(s2,2) == 1
            s2 = s2 - 1;
        end
        Rot = [cos(Theta) -sin(Theta) Match.keyPoints1(i,1);
               sin(Theta) cos(Theta)  Match.keyPoints1(i,2);
               0                0     1];
           
        Rot2 = [cos(Theta2) -sin(Theta2) (Match.keyPoints2(i,1)+sizH);
               sin(Theta2) cos(Theta2)  (Match.keyPoints2(i,2)+sizV);
               0                0     1];

        PiL = Rot*[0 0 1]';
        PfL = Rot*[s 0 1]';
        PR1 = Rot*[-s;s;1];                       %1----2
        PR2 = Rot*[s;s;1];                        %|    |
        PR3 = Rot*[s;-s;1];                       %4----3
        PR4 = Rot*[-s;-s;1];
        
        PiL2 = Rot2*[0 0 1]';
        PfL2 = Rot2*[s 0 1]';
        PR12 = Rot2*[-s;s;1];                       %1----2
        PR22 = Rot2*[s;s;1];                        %|    |
        PR32 = Rot2*[s;-s;1];                       %4----3
        PR42 = Rot2*[-s;-s;1];

        connectLineI = PiL;
        connectLineF = PiL2;
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
                color = 'white';
        end
        
        if debug
            tempImg = insertShape(IMG, 'Line',[PiL(1) PiL(2) PfL(1) PfL(2)],'LineWidth',1,'Color',color);
            tempImg = insertShape(tempImg, 'Line',[PR1(1) PR1(2) PR2(1) PR2(2)],'LineWidth',1,'Color',color);
            tempImg = insertShape(tempImg, 'Line',[PR2(1) PR2(2) PR3(1) PR3(2)],'LineWidth',1,'Color',color);
            tempImg = insertShape(tempImg, 'Line',[PR3(1) PR3(2) PR4(1) PR4(2)],'LineWidth',1,'Color',color);
            tempImg = insertShape(tempImg, 'Line',[PR4(1) PR4(2) PR1(1) PR1(2)],'LineWidth',1,'Color',color);

            tempImg = insertShape(tempImg, 'Line',[PiL2(1) PiL2(2) PfL2(1) PfL2(2)],'LineWidth',1,'Color',color);
            tempImg = insertShape(tempImg, 'Line',[PR12(1) PR12(2) PR22(1) PR22(2)],'LineWidth',1,'Color',color);
            tempImg = insertShape(tempImg, 'Line',[PR22(1) PR22(2) PR32(1) PR32(2)],'LineWidth',1,'Color',color);
            tempImg = insertShape(tempImg, 'Line',[PR32(1) PR32(2) PR42(1) PR42(2)],'LineWidth',1,'Color',color);
            tempImg = insertShape(tempImg, 'Line',[PR42(1) PR42(2) PR12(1) PR12(2)],'LineWidth',1,'Color',color);
            tempImg = insertShape(tempImg, 'Line',[connectLineI(1) connectLineI(2) connectLineF(1) connectLineF(2)],'LineWidth',1,'Color',color);
            imshow(tempImg,[]);
            pause();
        end
        
        
        
        MatchImg = insertShape(MatchImg, 'Line',[PiL(1) PiL(2) PfL(1) PfL(2)],'LineWidth',1,'Color',color);
        MatchImg = insertShape(MatchImg, 'Line',[PR1(1) PR1(2) PR2(1) PR2(2)],'LineWidth',1,'Color',color);
        MatchImg = insertShape(MatchImg, 'Line',[PR2(1) PR2(2) PR3(1) PR3(2)],'LineWidth',1,'Color',color);
        MatchImg = insertShape(MatchImg, 'Line',[PR3(1) PR3(2) PR4(1) PR4(2)],'LineWidth',1,'Color',color);
        MatchImg = insertShape(MatchImg, 'Line',[PR4(1) PR4(2) PR1(1) PR1(2)],'LineWidth',1,'Color',color);
        
        MatchImg = insertShape(MatchImg, 'Line',[PiL2(1) PiL2(2) PfL2(1) PfL2(2)],'LineWidth',1,'Color',color);
        MatchImg = insertShape(MatchImg, 'Line',[PR12(1) PR12(2) PR22(1) PR22(2)],'LineWidth',1,'Color',color);
        MatchImg = insertShape(MatchImg, 'Line',[PR22(1) PR22(2) PR32(1) PR32(2)],'LineWidth',1,'Color',color);
        MatchImg = insertShape(MatchImg, 'Line',[PR32(1) PR32(2) PR42(1) PR42(2)],'LineWidth',1,'Color',color);
        MatchImg = insertShape(MatchImg, 'Line',[PR42(1) PR42(2) PR12(1) PR12(2)],'LineWidth',1,'Color',color);
        
        MatchImg = insertShape(MatchImg, 'Line',[connectLineI(1) connectLineI(2) connectLineF(1) connectLineF(2)],'LineWidth',1,'Color',color);
        
        colorN = colorN + 1;
        if colorN > 7
            colorN = 1;
        end
    end

end

