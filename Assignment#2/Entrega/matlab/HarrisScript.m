clc,clear;

datadir     = '../datasets/bikes';%the directory containing the images
resultsdir  = '../results/bikes/';%the directory for dumping results


sigma_d  = 1;
sigma_i  = 2 ;  
Tresh_R = 0.1;
NMS_size = 21;
Patchsize  = 41;
Tresh_Metric = 0.3;       
Tresh_Match = 0.01;         
Descriptor_type  = 'MOPS';
Metric_type = 'RATIO';

Min_Query_features = 40;
%end of parameters

%----------------------------------------------------------------------------

% Read list of Files with Homography matrices
list = dir(sprintf('%s/*.txt', datadir));

% Read QUERY Image - IMAGE 1
imglist = dir(sprintf('%s/*.ppm', datadir))
[path1, imgname1, dummy1] = fileparts(imglist(1).name);
img1 = imread(sprintf('%s/%s', datadir, imglist(1).name));

if (ndims(img1) == 3)
        img1C = img1;
        img1 = rgb2gray(img1);
    end
    
img1 = double(img1) / 255;
   
% Detect Harris Corners %  
Pts_1 = HarrisCorner(img1,Tresh_R,sigma_d,sigma_i,NMS_size); 
% Detect Keypoints 
Pts_N1 = KeypointsDetection(img1,Pts_1);
% Extract keypoints descriptors 
Dscrpt1 = FeatureDescriptor(img1,Pts_N1,Descriptor_type,Patchsize);


%---------------------------------------------------------------
% PERFORM FEATURE MATCHING between QUERY and TEST images

% Check Minumum number of Query features

if size(Dscrpt1.keyPoints,1) > Min_Query_features

% Performs Feature Matching between MASTER image and a set of SLAVE images
    
  for i = 2:numel(imglist)
    
    % Read TEST images %
    [path2, imgname2, dummy2] = fileparts(imglist(i).name);
    img2 = imread(sprintf('%s/%s', datadir, imglist(i).name));
    
    if (ndims(img2) == 3)
        img2C = img2;
        img2 = rgb2gray(img2);
    end
    
    img2 = double(img2) / 255;
   
    %actual Harris Conners code function calls%  
    Pts_2 = HarrisCorner(img2,Tresh_R,sigma_d,sigma_i,NMS_size);   
    Pts_N2 = KeypointsDetection(img2,Pts_2);
    
    %actual feature descritor 
    
    [Dscrpt2] = FeatureDescriptor(img2,Pts_N2,Descriptor_type,Patchsize);
    
    %actual feature matching
    
    

    MatchList = FeatureMatching(Dscrpt1,Dscrpt2,Tresh_Metric,Metric_type);
    dir = sprintf('%sComp_1To%d.png',resultsdir,i);
    outp = markMatch(MatchList,img1C,img2C,'horizontal',false);
    imwrite(outp,dir);
    
% %     %Benchmark Evaluation
%     %H=load(strcat(list.folder,'/',list.name))
%     [TP,FN,FP,TN]=Matching_accuracy(MatchList,Tresh_Match);
%     Accuracy=(TP+TN)/(size(Dscrpt1,1));
%     sprintf("Matching Accuracy between images %s and %s is = %f \n",imgname1,imgname2,Accuracy);
    
    
  end
end