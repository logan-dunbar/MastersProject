function [objects] = FindObjects(video, windowSize)
%FindObjects Computes temporally coherent objects from a given video and
%windowSize

objects = [];

if (any(~mod(windowSize,2)))
    disp('Even dimension for window is not allowed');
    return;
end

traj = TrajectoryWindow(windowSize);

% reshape the video patch/cube and use
% cube(traj.Indices(i, :)');
% to index all the values out for that specific trajectory

objects = traj.Indices;
end

