%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% zbuffer_cdata
% Convert figure handle into a frame in order to write the video
% Obtained from : http://stackoverflow.com/questions/13719138/in-matlab-writing-images-to-avi-without-displaying-using-videowriter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function cdata = zbuffer_cdata(hfig)
    % Get CDATA from hardcopy using zbuffer
    % Need to have PaperPositionMode be auto 
    orig_mode = get(hfig, 'PaperPositionMode');
    set(hfig, 'PaperPositionMode', 'auto');
    cdata = hardcopy(hfig, '-Dzbuffer', '-r0');
    % Restore figure to original state
    set(hfig, 'PaperPositionMode', orig_mode); % end
end