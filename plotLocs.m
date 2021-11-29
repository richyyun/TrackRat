%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plotLocs
% Plots the locations of the rat 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load Grape2T_06_26_14_conv.mpg.mat
hold on
set(gca,'YDir','reverse');  % axes start on different corners
scatter(info.locs(:,1),info.locs(:,2))
scatter(info.noses(:,1),info.noses(:,2))
legend('Centroid','Nose')
axis([0 640 0 480]);
hold off;