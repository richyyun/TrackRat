%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TrackRat
% Function that goes through each frame and finds the rat's location 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Returns centroid of rat, the perimeter of rat, and the searchbox to use 
function [locs,perims,searchBox,noses] = TrackRat(background,video,start,final,inc,extraPix,saveVid,first,last,saving,nose,searchBox)

%% INITIALIZATION
frames = start:inc:final;
numFrames = length(frames);
perims = zeros(numFrames,1);             
locs = zeros(numFrames,2);
noses = zeros(numFrames,2);
writer = VideoWriter(saveVid,'Motion JPEG AVI');
if saving
    open(writer);                           %asks user for ellipse mask if zero is sent to RatLocation. Not needed?
end

%% MAIN LOOP
for i=frames
    vidFrame = read(video,i);
    vidFrame = rgb2gray(vidFrame);
    %findes the locations, bounding box, search box, perimeters, and
    %determines a mask
    [loc,bbox,searchBox,perim,nose] = RatLocation(vidFrame,background,extraPix,searchBox,writer,nose,saving);
    locs(i-start+1,:) = loc;
    noses(i-start+1,:) = nose;
    perims(i-start+1) = perim;
    %display for how much more the program needs to run
    time = toc;
    percent = ((i-first+1)/(last-first+1))*100;
    fprintf('%6.2f%% done\t frame number: %i \t elapsed time: %.2f minutes \n',percent,i,time/60);
end
if saving
    close(writer);
end
close all;

end

