%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% findNose
% Determines the location of the nose. Only take into account the points
% from the ConvexHull that are within a certain distance of the last
% position of the nose, and find the point furthest from the centroid from
% those points. If no such point exists, then use the previous point
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [nose] = findNose(loc, ConvexHull, nose, distance)
    %make a matrix, first column is index, second column is how far away it
    %is from centroid, third is if it is within the allocated distance 
    %from the previous nose. Sort according to the second column, find the 
    %first "true" in the third column, and use the corresponding index from
    %the first column to find out which point in the convex hull should be
    %the nose
    %firstIndex = find(a==0,1);

    distCent = sqrt((ConvexHull(:,1)-loc(1)).^2+(ConvexHull(:,2)-loc(2)).^2);
    inRadius = sqrt((ConvexHull(:,1)-nose(1)).^2+(ConvexHull(:,2)-nose(2)).^2) < distance;
    sortMat = [(1:length(ConvexHull))' distCent inRadius];
    sortMat = sortrows(sortMat,2);
    sortMat = flipdim(sortMat,1);
    Tempnose = ConvexHull(sortMat(find(sortMat(:,3)==1,1),1),:);
    if ~isempty(Tempnose)
        nose = Tempnose;
    end
        
end