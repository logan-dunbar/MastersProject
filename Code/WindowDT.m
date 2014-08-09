classdef WindowDT < handle
    %WINDOWDT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Video   %The windows video
        Mean    %The mean of the video
        Y       %The mean-subtracted vectorized video
        C       %The observation matrix containing principle component weights
        X       %The state of the DT containing dynamics information
        A       %The state transition matrix
        Q       %The covariance of the input noise
        B       %The input matrix B*B' = Q
        r       %The covariance (IID) of the sensor noise (I_m * r to get full covariance)
        mu      %The first state's mean of the DT
        S       %The first state's covariance
        n       %Number of principle components to keep (might make it adaptive)
        width
        height
        time
    end
    
    properties (Access = private)
        F           %The transformation matrix to go from one model space to another
        A_trans     %Transformed A
        Q_trans     %Transformed Q
        mu_trans    %Transformed mu
        S_trans     %Transformed S
        
        full_mu     %State's marginal distribution mean
        full_S      %State's marginal distribution covariance
        
        DefaultWidth = 300;
        XDist = 0   %Determines how X0 is initialized: 0 for X0, 1 for being drawn from Gaussian
    end
    
    properties (Dependent = true)
        Mean_img
    end
    
    methods
        function obj = WindowDT(video, n, varargin)
            obj.Video = double(video);
            obj.n = n;
            
            if (~isempty(varargin))
                obj.DefaultWidth = varargin{1};
            end
            
            obj.DownsizeVideo();
            
            obj.height = size(obj.Video, 1);
            obj.width = size(obj.Video, 2);
            obj.time = size(obj.Video, 3);
            
            obj.ReshapeVideo();
        end
        
        function CalculateDT(obj)
            obj.Mean = mean(obj.Video, 2);
            obj.Y = obj.Video - (obj.Mean*ones(1, obj.time));
            [u,~,~] = svd(obj.Y, 0);
            obj.C = u(:,1:obj.n);
            obj.X = obj.C'*obj.Y;
            obj.A = obj.X(:,2:end)*pinv(obj.X(:,1:end-1));
            V = obj.X(:,2:end) - obj.A*obj.X(:,1:end-1);
            [uv,sv,~] = svd(V, 0);
            obj.B = ((obj.time - 1)^(-0.5))*uv(:,1:obj.n)*sv(1:obj.n,1:obj.n)*uv(:,1:obj.n)';
            
            obj.Q = (1/(obj.time - 1))*(V*V');
            W = obj.Y - obj.C*obj.X;
            
            % Way to calc diag of big matrix multiply
            %http://stackoverflow.com/questions/2301046/compute-only-diagonals-in-matrix-product-in-octave
            obj.r = mean((1/obj.time)*sum(W.*W, 2));
            
            switch obj.XDist
                case 0
                    obj.mu = obj.X(:,1);
                case 1
                    [Ux,Sx,~]=svd(obj.X,0);
                    Bxhat=(obj.time^(-0.5))*Ux(:,1:obj.n)*Sx(1:obj.n,1:obj.n)*Ux(:,1:obj.n)';
                    obj.mu =Bxhat*randn(obj.n,1);
            end
            
            obj.S = obj.Q;
        end
        
        function D = KLDivStateSpace(win1, win2)
            win1.F = pinv(win2.C'*win2.C)*win2.C'*win1.C;
            win1.F = eye(win2.n);
            win1.TransformStateSpace();
            
            win1.PrecomputeMu();
            win1.PrecomputeS();
            
            first.part1 = (win1.mu_trans - win2.mu)'*inv(win2.S)*(win1.mu_trans - win2.mu);
            first.part2 = log(det(win2.S)/det(win1.S_trans));
            first.part3 = trace(win2.S\win1.S_trans);
            firstTot = (1/2*win1.time)*(first.part1 + first.part2 + first.part3);
            
            secondTot = -win1.n/2;
            
            third.sum = zeros(win1.n, win1.n);
            for i = 1:win1.time - 1
                third.sum = win1.full_S(:,:,i) + win1.full_mu(:,i)*win1.full_mu(:,i)';
            end
            A_bar = win1.A_trans - win2.A;
            thirdTot = 0.5*trace(A_bar'*inv(win2.Q)*A_bar*(1/win1.time)*third.sum);
            
            fourth.part1 = log(det(win2.Q)/det(win1.Q_trans));
            fourth.part2 = trace(win2.Q\win1.Q_trans);
            fourthTot = ((win1.time - 1)/(2*win1.time))*(fourth.part1 + fourth.part2);
            
            D = firstTot + secondTot + thirdTot + fourthTot;
        end
        
        function D = KLDivImageSpace(win1, win2)
            
        end
        
        function y = EstimateNextFrame()
            
        end
        
        function value = get.Mean_img(obj)
           value = reshape(obj.Mean, obj.width, obj.height); 
        end
    end
    
    methods (Access = private)
        function ReshapeVideo(obj)
            obj.Video = reshape(obj.Video, obj.width*obj.height, obj.time);
        end
        
        function TransformStateSpace(obj)
            obj.A_trans = (obj.F*obj.A*inv(obj.F));
            obj.Q_trans = obj.F*obj.Q*obj.F';
            obj.mu_trans = obj.F*obj.mu;
            obj.S_trans = obj.F*obj.S*obj.F';
        end
        
        function PrecomputeMu(obj)
            obj.full_mu = zeros(obj.n, obj.time-1);
            obj.full_mu(:,1) = obj.mu_trans;
            for i = 2:obj.time-1
                obj.full_mu(:,i) = obj.A_trans*obj.full_mu(:,i-1);
            end
        end
        
        function PrecomputeS(obj)
            obj.full_S = zeros(obj.n, obj.n, obj.time-1);
            obj.full_S(:,:,1) = obj.S_trans;
            for i = 2:obj.time-1
                obj.full_S(:,:,i) = obj.A_trans*obj.full_S(:,:,i-1)*obj.A_trans' + obj.Q_trans;
            end
        end
        
        function DownsizeVideo(obj)
            vidSz = size(obj.Video);
            if (vidSz(2) > obj.DefaultWidth)
                resize = obj.DefaultWidth/vidSz(2);
                tempVid = zeros(ceil(vidSz(1) * resize), obj.DefaultWidth, vidSz(3));
                for i=1:vidSz(3)
                    tempVid(:,:,i) = imresize(obj.Video(:,:,i), resize);
                end
                
                obj.Video = tempVid;
            end
        end
    end
    
end

