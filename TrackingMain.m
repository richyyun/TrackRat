%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TrackingMain
% Main function that prepares the initial set up and runs the tracking code 
% by using the other functions. Calls TrackRat which in turn calls 
% RatLocation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Initialization
% initialize video, background, frames, etc.
clear; clc; close all;
cd 'C:\Users\Richy\Desktop\Tracking';

workspace = 'C:\Users\Richy\Desktop\Tracking';
backVid = 'Chocolate1TB_07_14_14_conv.mpg';
mainVid = 'Chocolate1T_07_14_14_conv.mpg';

cd 'C:\Users\Richy\Desktop\Tracking';

background = VideoReader(backVid);
background = read(background,2);
background = rgb2gray(background);

video = VideoReader(mainVid);

vidFrame = read(video,1);

first = 500;            %first frame
last = 999; %get(video,'NumberOfFrames');    %last frame
splitFrames = 500;      %how to split it up (in case too many frames)
divisions = ceil((last-first+1)/splitFrames); %number of frames to split up by
saving = 1;             %whether or not to save the tracking video

locs = [];
perims = [];
noses = [];
noseInit = 0;
searchBox = 0;
tic

%% Main for Loop
for i=1:divisions
    saveVid = ['Chocolate1T_07_14_14_track' num2str(i)];
    startFrame = splitFrames.*(i-1)+first;
    if i==divisions
        endFrame = last;
    else
        endFrame = splitFrames*i+first-1;
    end
    incFrame = 1;
    extraPix = 10;
    if ~isempty(noses)
        noseInit = noses(end,:);
    end
    [locst,perimst,searchBox,noset] = TrackRat(background,video,startFrame,endFrame,incFrame,extraPix,saveVid,first,last,saving,noseInit,searchBox);
    locs(end+1:end+size(locst,1),:)=locst;
    perims(end+1:end+size(perimst,1),:)=perimst;
    noses(end+1:end+size(noset,1),:)=noset;
end

%% Save data
info.locs = locs;
info.perims = perims;
info.noses = noses;

file_name=[mainVid '.mat'];
save(file_name, 'info');
