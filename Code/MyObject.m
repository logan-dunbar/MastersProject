classdef MyObject < handle
    %OBJECT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Mask
        CheckedMask
        Seed
        SeedTrajectory
        
        % Populated after instantiation
        MeanTrajectoryIndices
    end
    
    properties (Access = private)
        Coher
        FrameSize
        M
        NeighbourOffsets
        SeedTrajectoryIndex
    end
    
    properties (Dependent = true)
        MeanTrajectoryIndex
    end
    
    methods
        function value = get.MeanTrajectoryIndex(obj)
           value = mean(obj.MeanTrajectoryIndices, 1);
        end
        
        function obj = MyObject(coherObj, seed)
            obj.Coher = coherObj;
            obj.Seed = seed;
            
            obj.SeedTrajectory = coherObj.Windows(seed).MaxStopCountTrajectory;
            obj.SeedTrajectoryIndex = obj.SeedTrajectory.StartPoint(1:2);
            obj.MeanTrajectoryIndices = obj.SeedTrajectoryIndex;
            
            width = coherObj.VideoSz(2) - (coherObj.WindowSize - 1);
            height = coherObj.VideoSz(1) - (coherObj.WindowSize - 1);
            obj.FrameSize = [height, width];
            
            obj.Mask = false(obj.FrameSize);
            obj.CheckedMask = false(obj.FrameSize);
            
            % 1 pix left is -1 column length (neighbour indexing)
            obj.M = obj.FrameSize(1);
            obj.NeighbourOffsets = [-1, obj.M, 1, -obj.M];
            
            obj.ComputeMask();
        end
    end
    
    methods (Access = private)
        function ComputeMask(obj)
            active_inds = [obj.Seed];
            active_checked_inds = [obj.Seed];
            
            while ~isempty(active_inds)
                % Set the active pixels to 1.
                obj.Mask(active_inds) = true;
                obj.CheckedMask(active_checked_inds) = true;
                
                % TODO padding around the edges for neighbourhood indexing
                
                % The new active pixels list is the set of neighbors of the current list.
                neighbourOffsets = obj.NeighbourOffsets;
                for ind = active_inds;
                    if (mod(ind-1, obj.M) == 0)
                        neighbourOffsets(neighbourOffsets == -1) = [];
                    end
                    if (ind > (obj.FrameSize(1) * obj.FrameSize(2)) - obj.M)
                        neighbourOffsets(neighbourOffsets == obj.M) = [];
                    end
                    if (mod(ind, obj.M) == 0)
                        neighbourOffsets(neighbourOffsets == 1) = [];
                    end
                    if (ind <= obj.M)
                        neighbourOffsets(neighbourOffsets == -obj.M) = [];
                    end
                end
                
                active_checked_inds = bsxfun(@plus, active_inds', neighbourOffsets);
                active_checked_inds = active_checked_inds(:);
                
                % Remove already checked inds
                active_checked_inds(obj.CheckedMask(active_checked_inds)) = [];
                
                loop_inds = active_checked_inds';
                
                active_inds = [];
                % Remove invalid inds
                for ind=loop_inds
                    neighbour_window = obj.Coher.Windows(ind);
                    neighbour_seed_traj = neighbour_window.Trajectories(obj.SeedTrajectoryIndex(1), obj.SeedTrajectoryIndex(2));
                    
                    %magic numbers (should be based on window size or something
                    if (neighbour_seed_traj.Error < 500)
                        active_inds = [active_inds ind];
                    end
                end
                
                active_inds = unique(active_inds);
            end
            
        end
    end
    
end

