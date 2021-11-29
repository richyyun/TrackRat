%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RatLocation
% Determines the location, perimeter, bounding box, and search box of the
% rat. Most of the logic for tracking happens here. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [loc,bbox,searchBox,perim,nose] = RatLocation(vidFrame,background,extra,searchBox,writer,nose,saving)

%% SUBTRACT BACKGROUND
%Convert the frame into black and white and subtract the background 
diff = imabsdiff(vidFrame,background);
thresh = graythresh(diff);
thresh = thresh*1.5;
binImg = im2bw(diff,thresh);

%% Initial nose search / Limit to search box
%if there is no defined searchbox, ask user to find a mask
if nose == 0
    colormap gray; axis off; axis image;
    imagesc(binImg);
    dlgquest1=['Click on the rats nose'];
    title(dlgquest1,'fontweight','b');
    nose = ginput(1);
    close;
else
    %limits search to the searchbox
    binImg = binImg(searchBox(2):searchBox(2)+searchBox(4), searchBox(1):searchBox(1)+searchBox(3));
end

f = figure('visible','off'); %real time tracking. comment out to turn on.

%% FIND RAT 
%find the "blobs" in the frame and the corresponding properties. Then find
%the biggest blob and denote it as the rat.
blobs = regionprops(binImg, 'Area', 'BoundingBox', 'Centroid', 'Perimeter', 'Orientation', 'MajorAxisLength', 'MinorAxisLength','ConvexHull');
areas=[blobs.Area];

% if the rat body is cut in half by the cable
if length(find(areas>200)) > 1
    center1 = blobs(areas == max(areas)).Centroid;
    areas(areas == max(areas)) = 0;
    center2 = blobs(areas == max(areas)).Centroid;
    binImg = connectBlobs(binImg,center1,center2);   
    blobs = regionprops(binImg, 'Area', 'BoundingBox', 'Centroid', 'Perimeter', 'Orientation', 'MajorAxisLength', 'MinorAxisLength','ConvexHull');
    areas=[blobs.Area];
end

rat = blobs(areas == max(areas)); 
perim = rat.Perimeter;
loc = rat.Centroid;

%% BOUNDING BOX / SEARCH BOX
dimensions = size(background);
bbox = rat.BoundingBox;
if searchBox~=0
    bbox(1) = searchBox(1)+bbox(1)-1;
    bbox(2) = searchBox(2)+bbox(2)-1;
    loc(1) = loc(1)+searchBox(1)-1;
    loc(2) = loc(2)+searchBox(2)-1;
end
tempBox = searchBox;
searchBox = new_bbox(bbox, dimensions, extra);

%% Finding the Nose
if tempBox ~= 0
    ConvexHull(:,1) = rat.ConvexHull(:,1) + tempBox(1);
    ConvexHull(:,2) = rat.ConvexHull(:,2) + tempBox(2);
else
    ConvexHull = rat.ConvexHull;
end
nose = findNose(loc, ConvexHull,nose, rat.MajorAxisLength/5);


%% SAVING THE VIDEO
%make a figure, plot the centroid, bbox, and searchbox

if saving
    center = 1;     %plot centroid
    boxes = 1;      %plot bbox and searchBox
    ellipse = 1;    %plot ellipse
    MAxis = 1;       %plot major axis
    hull = 1;       %plot ConvexHull
    noseCirc = 1;   %plot circle around nose

    
    [rows, columns] = size(vidFrame);
    posX = 100; posY = 100;
    im = im2bw(diff,thresh);
    imagesc(vidFrame); 
    %imagesc(im);
    hold on; 
    if center
        scatter(loc(1),loc(2),75,'r','filled');
    end
    colormap('gray');
    set(gcf,'Position',[posX posY columns rows]);
    set(gca,'units','pixels');
    set(gca,'units','normalized','position',[0 0 1 1]);
    axis off;
    axis tight;
    
    if boxes
        plot_bbox(bbox,'r');
        plot_bbox(searchBox,'y');
    end
    
    if ellipse
        %plot the ellipse
        phi = linspace(0,2*pi,50);
        cosphi = cos(phi);
        sinphi = sin(phi);
        xbar = rat.Centroid(1);
        ybar = rat.Centroid(2);
        a = rat.MajorAxisLength/2;
        b = rat.MinorAxisLength/2;
        theta = pi*rat.Orientation/180;
        R = [cos(theta) sin(theta)
            -sin(theta) cos(theta)];
        xy = [a*cosphi; b*sinphi];
        xy = R*xy;
        x = xy(1,:) + loc(1);
        y = xy(2,:) + loc(2);
        plot(x,y,'b','LineWidth',2);
    end
    
    if MAxis
        %plot major axis
        x = linspace(-rat.MajorAxisLength/2,rat.MajorAxisLength/2,50);
        x = x+loc(1);
        slope = -tand(rat.Orientation);
        intercept = loc(2)-loc(1).*slope;
        y = slope.*x+intercept;
        plot(x,y,'b','LineWidth',2);
    end

    if hull
        %plot convexhull
        scatter(ConvexHull(:,1),ConvexHull(:,2),'g','.');
    end
    
    if noseCirc
        %plot circle around nose
        r = rat.MajorAxisLength/5;
        ang=linspace(0,2*pi,50);
        xp=r*cos(ang);
        yp=r*sin(ang);
        plot(nose(1)+xp,nose(2)+yp,'g','LineWidth',2);
    end
    
    axis off;
    hold off;

    %save the figure as a frame
    F = im2frame(zbuffer_cdata(gcf));
    writeVideo(writer,F);
end
end
