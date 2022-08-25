function out_mask = WBC_SegProposed(input_image, show_images)
%This function is built to segment the nuclei of white blood cells
% the input is an image and an option to show the resluts on screen or not (1 or 0)
%and the number of white blood cells
% For more information abou the algorithm please refere to: 
% "An Efficient Technique for White Blood Cells Nuclei Automatic Segmentation", 
% IEEE SMC conference 2012
%  The algorithm in this function is an implementation if the paper:
% H. T. Madhloom, S. A. Kareem, H. Ariffin, A. A. Zaidan, H. O. Alanazi and 
% B. B. Zaidan, "An Automated White Blood Cell Nucleus Localization and 
% Segmentation using Image Arithmetic and Automatic Threshold," Journal of 
% Applied Sciences, vol. 10, no. 11, pp. 959-966, 2010. 

a1=imread(input_image);     %if the image is not already converted into an array by imread()




%%imshow(blue);
a=rgb2cmyk(a1);
a = a(:,:,1);

%% Adjust image intensity values with a linear contrast stretching 
L=imadjust(a);

%% Enhance contrast using histogram equalization 
H = adapthisteq(a);

%% Brighten most of the details in the image except the nucleus
R1=imadd(L,H);

%% Highlight all the objects and its borders in the image including the cell nucleus
R2 = imsubtract(R1,H);

%% Remove almost all the other blood components while retaining the nucleus with minimum affect of distortion on the nucleus part of the white blood cell.
R3=R1+R2;

%check histogram
% figure;
% hi=imhist(R3);
% hi1=hi(1:2:256);
% horz=1:2:256;
% bar(horz,hi1);
% % %axis([0 255 0 1400]);
% % %set(gca, 'xtick', 0:50:255);
% % %set(gca, 'ytick', 0:2000:15000);
%  xlabel('Gray level' );
% ylabel('No of pixels' );
% title('Histogram before opening the image');

% 'Time elapsed to calculate image preparations (algorithm)' 
% toc(programStart)
filterStart=tic;
%=====================
%implements a 3-by-3 minimum filter
%reduce noise, preserve edges and increase the darkness of the nuclei
for i=1:6
    R3=ordfilt2(R3,1,ones(2,2));
end
%minium filter(decrease the noise)
% 'Time elapsed to calculate 3-by-3 minimum filter' 
% toc(filterStart)
%figure; imshow(R3);
%check histogram afteraplying the minimum filter
% figure;
% hi=imhist(R3);
% hi1=hi(1:2:256);
% horz=1:2:256;
% bar(horz,hi1);
% % %axis([0 255 0 10000]);
% % %set(gca, 'xtick', 0:50:255);
% % %set(gca, 'ytick', 0:2000:15000);
%  xlabel('Gray level' );
% ylabel('No of pixels' );
% title('Histogram before opening the image');
%=====================================================
%% Global threshold using Otsu’s method 

level=graythresh(R3);
bw=im2bw(R3,level);
%Complement image
bw = imcomplement(bw);


% =====================================================
%================New parts============================
%=====================================================
%% Use morphological opening to remove small pixel objects
d= strel('disk',9);
bw=imopen(bw,d);


%=================================================
%% Use morphological closing to remove small pixel objects
d= strel('disk',10);
bw=imclose(bw,d);


%=================================================
%% Remove objects that is not WBCs "check by area"
%Compute Area of Each Cell
%count objects in the image
cells = bwconncomp(bw)  ;                   %returns an object that contains the number of connected objects and 
no_of_WBCs = cells.NumObjects;
cellsdata = regionprops(cells, 'basic') ;  %data includes area, centroid and bounding box
%Compute Area-based Statistics
cells_areas = [cellsdata.Area];
%check the areas area of each segment, must be > 0.5 RBC avarage size (10000)

for k=1:no_of_WBCs
    if (cells_areas(k)<5000) %|| (cells_areas(k)>30000) %(ratio < 0.6)  %     35% is the size ratio of the smallest WBC to the largest one
        bw(cells.PixelIdxList{k}) = 0; % zero the puixels of kth element of list if the area is less than desired
    end;
end

%=================================================
%% Show resulting images
bw = imcomplement(bw);
out_mask = bw;

    
end
