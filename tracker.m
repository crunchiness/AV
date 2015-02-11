classdef tracker < handle
    %TRACKER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        R = [[0.2845,0.0045]; [0.0045,0.0455]];
        H = [[1,0]',[0,1]',[0,0]',[0,0]'];
        Q = 0.01*eye(4);
        g = 3.71;  % gravity = pixel / time step^2
        A1 = [[1,0,1,0]; [0,1,0,0]; [0,0,1,0]; [0,0,0,0]];  % on table, no vertical velocity
        A2 = [[1,0,1,0]; [0,1,0,1]; [0,0,1,0]; [0,0,0,1]]; % bounce
        A3 = [[1,0,1,0]; [0,1,0,1]; [0,0,1,0]; [0,0,0,1]]; % normal motion
        A4 = [[1,0,1,0]; [0,1,0,1]; [0,0,1,0]; [0,0,0,1]]; % collision
        A5 = [[1,0,1,0]; [0,1,0,1]; [0,0,1,0]; [0,0,0,1]]; % invisible
        Bu1 = [0,0,0,0]';  % on table, no gravity
        Bu2 = [0,0,0,3.71]';  % bounce
        Bu3 = [0,0,0,3.71]';  % normal motion
        Bu4 = [0,0,0,3.71]';  % collision
        Bu5 = [0,0,0,3.71]';  % invisible
        loss = 0.7;
        p_stop = 0.05;      % probability of stopping vertical motion
        p_collision = 0.02; % probability of collision
        p_bounce = 0.2;     % probability of bouncing at current state (overestimated)
        p_invisible = 0.1;
        
        
        N_HYP;
        N_FRAMES;
        weights;
        trackstate;
        top_hyps;
        P;
        x;
    end
    
    methods
        function self = tracker(n_hyp, n_frames)
            self.N_HYP = n_hyp;
            self.N_FRAMES = n_frames;
            
            self.top_hyps = zeros(n_frames);
            self.weights = zeros(n_hyp,n_frames);     % est. probability of state
            self.trackstate = zeros(n_hyp,n_frames);  % state = 1,2,3,4,5;
            self.x = zeros(n_hyp,n_frames,4);         % state vectors
            
            self.P = zeros(n_hyp,n_frames,4,4);       % est. covariance of state vec.
            for j = 1 : n_hyp                         % initialize estimated covariance
                for k = 1 : n_frames
                    self.P(j,k,1,1) = 100;
                    self.P(j,k,2,2) = 100;
                    self.P(j,k,3,3) = 100;
                    self.P(j,k,4,4) = 100;
                end
            end
        end
        function something = process_frame(self, frame_number, x_coord, y_coord)
            
            i = frame_number;
            for k = 1 : self.N_HYP
                if i == 1  % make a random vector
                    x_current = [floor(img_width*rand(1)),floor(img_height*rand(1)),0,0]';
                else
                    j = probability_box(self.weights(:,i-1));
                    x_current = zeros(4,1);
                    x_current(1) = self.x(j,i-1,1);  % get its state vector
                    x_current(2) = self.x(j,i-1,2);
                    x_current(3) = self.x(j,i-1,3);
                    x_current(4) = self.x(j,i-1,4);
                    % sample about this vector from the distribution (assume no covariance)
                    for n = 1 : 4
                        x_current(n) = x_current(n) + 5*sqrt(self.P(k,i-1,n,n))*randn(1);
                    end
                end

                % hypothesize if it is going into a bounce or tabletop state
                if i == 1    % initial time - assume falling
                    xp = x_current;   % no process at start
                    A = self.A3;
                    Bu = self.Bu3;
                    self.trackstate(k,i)=3;
                else
                    if self.trackstate(k,i-1) == 1  % if already stopped bouncing
                        A = self.A1;
                        Bu = self.Bu1;
                        x_current(4) = 0;
                        self.trackstate(k,i) = 1;  % stay stopped bouncing
                    else
                        r = rand(1);   % random number for state selection
                        if r < self.p_stop
                            A = self.A1;
                            Bu = self.Bu1;
                            x_current(4) = 0;
                            self.trackstate(k,i) = 1;
                        elseif r < (self.p_bounce + self.p_stop)
                            A = self.A2;
                            Bu = self.Bu2;
                            % add some random vertical motion due to imprecision
                            % about time of bounce
                            x_current(2) = x_current(2) + 3*abs(x_current(4))*(rand(1)-0.5);
                            x_current(4) = -x_current(4)*self.loss;  % invert vertical velocity (lossy)
                            self.trackstate(k,i) = 2;  % set into bounce state
                        elseif r < (self.p_bounce + self.p_stop + self.p_collision)
                            A = self.A4;
                            Bu = self.Bu4;
%                             x_current(3) = -loss*x_current(3);
%                             x_current(4) = -loss*x_current(4);
                            self.trackstate(k,i) = 4;
                        elseif r < (self.p_bounce + self.p_stop + self.p_collision + self.p_invisible)
                            A = self.A5;
                            Bu = self.Bu5;
                            self.trackstate(k,i) = 5;
                        else  % normal motion
                            A = self.A3;
                            Bu = self.Bu3;
                            self.trackstate(k,i) = 3;
                        end
                    end
                end
                xp = A*x_current + Bu;  % predict next state vector
                % update & evaluate new hypotheses via Kalman filter
                % predictions
                TP = zeros(4,4);  % predicted covariances
                for u = 1 : 4 % extract old P()
                    for v = 1 : 4
                        TP(u,v) = self.P(k,i-1,u,v);
                    end
                end
                PP = A*TP*A' + self.Q;  % predicted error
                % corrections
                K = PP*self.H'*inv(self.H*PP*self.H'+self.R);  % gain
                self.x(k,i,:) = (xp + K*([x_coord,y_coord]' - self.H*xp))';  % corrected state
                self.P(k,i,:,:) = (eye(4)-K*self.H)*PP;  % corrected error

                % weight hypothesis by distance from observed data
                dvec = [x_coord,y_coord] - [self.x(k,i,1),self.x(k,i,2)];
                self.weights(k,i) = 1/(dvec*dvec');
            end
            % rescale new hypothesis weights
            totalw = sum(self.weights(:,i)');
            self.weights(:,i) = self.weights(:,i)/totalw;

            % select top hypothesis to draw
            subset = self.weights(:,i);
            top = find(subset == max(subset));
            
            self.top_hyps(i) = top;
            something = self.x(top,i,:);
        end
    end
end

