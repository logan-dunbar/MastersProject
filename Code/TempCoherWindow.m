classdef TempCoherWindow < handle
    %TEMPCOHERWINDOW Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = private)
        Trajectories
        WinSz
        Video
    end
    
    properties (Dependent = true)
    end
    
    methods
        % coord running down y first and across x (to allow for reshape)
        function obj = TempCoherWindow(video)
            %change this to allow winSz_x,  winSz_y, winSz_t
            obj.WinSz = size(video, 1);
            obj.Video = video;
            obj.PopulateTrajectories();
            obj.CalculateCoherence();
        end
    end
    
    methods (Access = private)
        function PopulateTrajectories(obj)
            %create a trajectory for every pixel in window
            obj.Trajectories = TempCoherTrajectory.empty;
            midPoint = repmat(ceil(obj.WinSz/2), 1, 3);
            for y = 1:obj.WinSz
                for x = 1:obj.WinSz
                    obj.Trajectories(y, x) = TempCoherTrajectory([y x 1], midPoint);
                end
            end
        end
        
        function CalculateCoherence(obj)
            for y = 1:obj.WinSz
                for x = 1:obj.WinSz
                    trajectory = obj.Trajectories(y, x);
                    midPointValue = obj.Video(trajectory.MidPoint(1), trajectory.MidPoint(2), trajectory.MidPoint(3));
                    
                    % to prevent -infinity when log-ing to view
                    trajectory.Error = 1;
                    for j = 1:trajectory.IndicesCount
                        indices = trajectory.Indices(j, :);
                        value = obj.Video(indices(1), indices(2), indices(3));
                        trajectory.Error = trajectory.Error + (midPointValue - value)^2;
                    end
                end
            end
        end
    end
    
end

