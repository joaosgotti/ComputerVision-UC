function [Match] = FeatureMatching(Dscpt1,Dscpt2,Tresh,Metric_TYPE)
%[Match] = FeatureMatching(Dscpt1,Dscpt2,Tresh,Metric_TYPE)
    sizeDsc1 = size(Dscpt1.keyPoints);
    sizeDsc2 = size(Dscpt2.keyPoints);
    distances = zeros(length(Dscpt1(1,:)));
    Match = [];
    index = 1;
    switch Metric_TYPE
        case 'SSD'
            for i = 1:sizeDsc1(1)
                for j = 1:sizeDsc2(1)
                    distances(j) = sum((Dscpt1.patch(i,:)-Dscpt2.patch(j,:)).^2);
                end
                MinValue = min(distances);
                if MinValue < Tresh
                    idx = distances == MinValue;
                    %idx
                    Match.keyPoints1(index,:) = Dscpt1.keyPoints(i,:);
                    Match.keyPoints2(index,:) = Dscpt2.keyPoints(idx,:);
                    Match.distance(index) = MinValue;
                    index = index + 1;
                end
            end
        case 'RATIO'
            for i = 1:sizeDsc1(1)
                for j = 1:sizeDsc2(1)
                    distances(j) = sum((Dscpt1.patch(i,:)-Dscpt2.patch(j,:)).^2);
                end
                BestVal = min(distances);
                I = distances ~= BestVal;
                SecondVal = min(distances(I));
                Ratio = BestVal/SecondVal;
                if Ratio < Tresh
                    id1 = distances == BestVal;
                    Match.keyPoints1(index,:) = Dscpt1.keyPoints(i,:);
                    Match.keyPoints2(index,:) = Dscpt2.keyPoints(id1,:);
                    Match.distance(index) = Ratio;
                    index = index + 1;
                end
            end
    end
end
        
        