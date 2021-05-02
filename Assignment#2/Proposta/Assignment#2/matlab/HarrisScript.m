clear;

datadir     = '../datasets/bikes';    %the directory containing the images
resultsdir  = '../results'; %the directory for dumping results

%parameters
sigma_d  = 1;
sigma_i  = 2 ;  
Tresh_R = 5;
NMS_size = 10;
Patchsize  = 40;
Tresh_Metric = 10 ;       % Minimum distance metric error for matching35132
Tresh_Match = 5 ;         % Minimum pixel error for correct matching
Descriptor_type  = 'MOPS';
Metric_type = 'SSD';

Min_Query_features = 50;  % minimum number of 50 Harris points in Query image
%end of parameters

%----------------------------------------------------------------------------

% Read list of Files with Homography matrices
list = dir(sprintf('%s/*.txt',datadir));

% Read QUERY Image - IMAGE 1
imglist = dir(sprintf('%s/*.ppm', datadir));
[path1, imgname1, dummy1] = fileparts(imglist(1).name);
img1 = imread(sprintf('%s/%s', datadir, imglist(1).name));

if (ndims(img1) == 3)
        img1 = rgb2gray(img1);
    end
    
img1 = double(img1) / 255;
   
% Detect Harris Corners %  
Pts_1 = HarrisCorner(img1,Tresh_R,sigma_d,sigma_i,NMS_size); 
% Detect Keypoints 
Pts_N1 = KeypointsDetection(img1,Pts_1);
% Extract keypoints descriptors 
Dscrpt1 = FeatureDescriptor(img1,Pts_N_1,Descriptor_type,Patchsize);

%---------------------------------------------------------------
% PERFORM FEATURE MATCHING between QUERY and TEST images

% Check Minumum number of Query features

if size(Dscrpt1,1) > Min_Query_features

% Performs Feature Matching between MASTER image and a set of SLAVE images
    
  for i = 2:numel(imglist)
    
    % Read TEST images %
    [path2, imgname2, dummy2] = fileparts(imglist(i).name);
    img2 = imread(sprintf('%s/%s', datadir, imglist(2).name));
    
    if (ndims(img) == 3)
        img2 = rgb2gray(img2);
    end
    
    img2 = double(img2) / 255;
   
    %actual Harris Conners code function calls%  
    Pts_2 = HarrisCorner(img2,Tresh_R,sigma_d,sigma_i,NMS_size);   
    Pts_N2 = KeypointsDetection(img2,Pts_2);
    
    %actual feature descritor 
    
    [Dscrpt2] = FeatureDescriptor(img2,Pts_N2,Descriptor_type,Patchsize);
    
    %actual feature matching
    
    MatchList = FeatureMatching(Dscpt1,Dscpt2,Tresh_Metric,Metric_type);
    
    %Benchmark Evaluation
    H=load(strcat(list(i-1).folder,'/',list(i-1).name));
    [TP,FN,FP,TN]=Matching_accuracy(MatchList,H,Tresh_Match);
    
    Accuracy=(TP+TN)/(size(Dscpt1,1));
    
    sprintf("Matching Accuracy between images %s and %s is = %f \n",imgname1,imgname2,Accuracy);
    
  end
end
    
