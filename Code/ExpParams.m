classdef ExpParams
    %EXPPARAMS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        WinSz_x
        WinSz_y
        WinSz_t
        StepSz
        N
        Tau
    end
    
    methods
        function obj = ExpParams(winSz_x, winSz_y, winSz_t, stepSz, n, tau)
            if nargin > 0
                obj.WinSz_x = winSz_x;
                obj.WinSz_y = winSz_y;
                obj.WinSz_t = winSz_t;
                obj.StepSz = stepSz;
                obj.N = n;
                obj.Tau = tau;
            end
        end
    end
    
end

