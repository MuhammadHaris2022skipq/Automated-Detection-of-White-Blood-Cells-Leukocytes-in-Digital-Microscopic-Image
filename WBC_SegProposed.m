function out_mask = WBC_SegProposed(input_image, show_images)


a1=imread(input_image);     %if the image is not already converted into an array by imread()

if show_images == 1, figure;imshow(a1);title('(A)'); end
%%convert to gray scale image

%%imshow(blue);
a=rgb2cmyk(a1);
a = a(:,:,1);

if show_images == 1, figure;imshow(a);title('(B)'); end
%% Adjust image intensity values with a linear contrast stretching 
L=imadjust(a);
if show_images == 1, figure;imshow(L);title('(C)'); end

%% Enhance contrast using histogram equalization 
H = adapthisteq(a);
if show_images == 1, figure;imshow(H);title('(D)'); end

%% Remove almost all the other blood components while retaining the nucleus with minimum affect of distortion on the nucleus part of the white blood cell.
R3=2*L+H;
if show_images == 1, figure;imshow(R3);title('(G)'); end


%% Minimum filtering

for i=1:7
    R3=ordfilt2(R3,1,ones(2,2));
end
figure;imshow(R3);title('(H)');


%=====================================================

%% Global threshold using Otsu’s method 

level=graythresh(R3);
bw=im2bw(R3,level);
%Complement image

if show_images == 1, figure;imshow(bw);title('(I)'); end
bw = imcomplement(bw);
% =====================================================


%% Use morphological opening to remove small pixel objects

d= strel('disk',9);
bw=imopen(bw,d);
bw = imcomplement(bw);
if show_images == 1, figure;imshow(bw);title('(I)'); end
bw = imcomplement(bw);
%=================================================

%% Use morphological closing 

dd= strel('disk',12);
bw=imclose(bw,dd);
bw = imcomplement(bw);
if show_images == 1, figure;imshow(bw);title('(J)'); end
bw = imcomplement(bw);
%=================================================


%% Remove objects that is not WBCs "check by area"
%Compute Area of Each Cell
%count objects in the image
cells = bwconncomp(bw) ;                    %returns an object that contains the number of connected objects and 
no_of_WBCs = cells.NumObjects;
cellsdata = regionprops(cells, 'basic');   %data includes area, centroid and bounding box
%Compute Area-based Statistics
cells_areas = [cellsdata.Area];
%check the areas area of each segment, must be > 0.5 RBC avarage size (10000)

for k=1:no_of_WBCs
    if (cells_areas(k)<5000) %|| (cells_areas(k)>30000) %(ratio < 0.6)  %     35% is the size ratio of the smallest WBC to the largest one
        bw(cells.PixelIdxList{k}) = 0; % zero the puixels of kth element of list if the area is less than desired
    end;
end
if show_images == 1, figure;imshow(imcomplement(bw));title('(K)'); end
%=================================================
%% Show resulting images
out_mask = bw;
if show_images == 1
    %Re-count objects in the image
    cells = bwconncomp(bw);
    no_of_WBCs=cells.NumObjects;    
    a2 = a1;
    for j=1:no_of_WBCs
        %return the coordinates for the pixels in object j
        [r, c] = find(bwlabel(bw)==j);
        rc = [r c];
        %marking the location of the nuclei of white blood cells by a white
        %colour
        for i=1:max(size(rc))
            a2(rc(i,1),rc(i,2),:)=uint8(a1(rc(i,1),rc(i,2),:)*1.5);
        end
    end
    h = figure;
    set(h, 'Name', 'WBC segmentation results','NumberTitle','off', 'OuterPosition',[1 1 1600 600])
    subplot(1,3,1);imshow(a1);
    [~, name ext] = fileparts(input_image);
     title(['The original image [' name ext ']']);

    subplot(1,3,2);imshow(a2);
    title('The original image with the white spot(s) over the WBC nucleus(ei)');
    %show the final segmented image
    bw1 = imcomplement(bw);
    amask = a;
    amask(bw1) = 255;
    subplot(1,3,3);imshow(amask);
    title('The final segmented image');


end
