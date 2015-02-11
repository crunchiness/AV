function [ output_args ] = condensation_tracking( N_BALLS, N_FRAMES )
%CONDENSATION_TRACKING Summary of this function goes here
%   Detailed explanation goes here

    % Kalman filter static initializations
    R = [[0.2845,0.0045]; [0.0045,0.0455]];
    H = [[1,0]',[0,1]',[0,0]',[0,0]'];
    Q = 0.01*eye(4);
    dt = 1;
    A1 = [[1,0,dt,0]; [0,1,0,0]; [0,0,1,0]; [0,0,0,0]];  % on table, no vertical velocity
    A2 = [[1,0,dt,0]; [0,1,0,dt]; [0,0,1,0]; [0,0,0,1]]; % bounce
    A3 = [[1,0,dt,0]; [0,1,0,dt]; [0,0,1,0]; [0,0,0,1]]; % normal motion
    A4 = [[1,0,dt,0]; [0,1,0,dt]; [0,0,1,0]; [0,0,0,1]]; % collision
    A5 = [[1,0,dt,0]; [0,1,0,dt]; [0,0,1,0]; [0,0,0,1]]; % invisible
    g = 3.71;           % gravity = pixel / time step^2
    Bu1 = [0,0,0,0]';   % on table, no gravity
    Bu2 = [0,0,0,g]';   % bounce
    Bu3 = [0,0,0,g]';   % normal motion
    Bu4 = [0,0,0,g]';   % normal motion
    Bu5 = [0,0,0,g]';   % normal motion
    loss=0.7;

    N_HYP = 1000;                          % number of condensation samples
    p_stop = 0.05;      % probability of stopping vertical motion
    p_collision = 0.02; % probability of collision
    p_bounce = 0.2;    % probability of bouncing at current state (overestimated)
    p_invisible = 0.1;
    xs_current = cell(N_BALLS,1);
    TP = cell(N_BALLS,1);
    weights = cell(N_BALLS,1);
    trackstate = cell(N_BALLS,1);
    P = cell(N_BALLS,1);
    x = cell(N_BALLS,1);
    for i = 1:N_BALLS
        xs_current{i} = zeros(4,10);
        TP{i} = zeros(4,4); % predicted covariances
        weights{i} = zeros(N_HYP,N_FRAMES);     % est. probability of state
        trackstate{i} = zeros(N_HYP,N_FRAMES);  % state=1,2,3;
        P{i} = zeros(N_HYP,N_FRAMES,4,4);       % est. covariance of state vec.
        x{i} = zeros(N_HYP,N_FRAMES,4);         % state vectors
        for j = 1 : N_HYP                       % initialize estimated covariance
            for k = 1 : N_FRAMES
                P{i}(j,k,1,1) = 100;
                P{i}(j,k,2,2) = 100;
                P{i}(j,k,3,3) = 100;
                P{i}(j,k,4,4) = 100;
            end
        end
    end
% centers_prev = [];
% radii_prev = [];





        for k = 1 : N_HYP
            if i==1 % make a random vector
                xs_current{m} = [floor(img_width*rand(1)),floor(img_height*rand(1)),0,0]';
            else
                %TODO something
                
                k = probability_box(weights{m}(:,i-1));
                xs_current{m}(1) = x{m}(k,i-1,1);  % get its state vector
                xs_current{m}(2) = x{m}(k,i-1,2);
                xs_current{m}(3) = x{m}(k,i-1,3);
                xs_current{m}(4) = x{m}(k,i-1,4);

                dist_weights = get_dist_probs(centers_prev, radii_prev, xs_current{m});
                % sample about this vector from the distribution (assume no covariance)
                for n = 1 : 4
                    xs_current{m}(n) = xs_current(n) + 5*sqrt(P{m}(k,i-1,n,n))*randn(1);
                end
            end

            % hypothesize if it is going into a bounce or tabletop state
            if i == 1    % initial time - assume falling
                xp = xs_current{m};   % no process at start
                A = A3;
                Bu = Bu3;
                trackstate{m}(k,i)=3;
            else
                if trackstate{m}(k,i-1) == 1  % if already stopped bouncing
                    A = A1;
                    Bu = Bu1;
                    xs_current{m}(4) = 0;
                    trackstate{m}(k,i) = 1;     % stay stopped bouncing
                else
                    r=rand(1);   % random number for state selection
    % p_stop = 0.05;
    % p_collision = 0.02;
    % pbounce = 0.30;
                    if r < p_stop
                        A = A1;
                        Bu = Bu1;
                        xs_current{m}(4) = 0;
                        trackstate{m}(k,i)=1;
                    elseif r < (p_bounce + p_stop)
                        A = A2;
                        Bu = Bu2;
                        % add some random vertical motion due to imprecision
                        % about time of bounce
                        xs_current{m}(2) = xs_current{m}(2) + 3*abs(xs_current{m}(4))*(rand(1)-0.5);
                        xs_current{m}(4) = -xs_current{m}(4)*loss;  % invert vertical velocity (lossy)
                        trackstate{m}(k,i)=2;  % set into bounce state
                    elseif r < (p_bounce + p_stop + p_collision)
                        A = A4;
                        Bu = Bu4;
    %                     x_current(3) = -loss*x_current(3);
    %                     x_current(4) = -loss*x_current(4);
                        trackstate{m}(k,i) = 4;
                    elseif r < (p_bounce + p_stop + p_collision + p_invisible)
                        A = A5;
                        Bu = Bu5;
                        trackstate{m}(k,i) = 5;
                    else % normal motion
                        A = A3;
                        Bu = Bu3;
                        trackstate{m}(k,i) = 3;
                    end
                end
                xp = A*xs_current{m} + Bu;      % predict next state vector
            end

            % update & evaluate new hypotheses via Kalman filter
            % predictions
            for u = 1 : 4 % extract old P()
                for v = 1 : 4
                    TP{m}(u,v)=P{m}(k,i-1,u,v);
                end
            end
            PP = A*TP{m}*A' + Q;    % predicted error
            % corrections
            K = PP*H'*inv(H*PP*H'+R);      % gain
            x{m}(k,i,:) = (xp + K*([cc(i),cr(i)]' - H*xp))';    % corrected state
            P{m}(k,i,:,:) = (eye(4)-K*H)*PP;                    % corrected error

            % weight hypothesis by distance from observed data
            dvec = [cc(i),cr(i)] - [x{m}(k,i,1),x{m}(k,i,2)];
            weights{m}(k,i) = 1/(dvec*dvec');

        end
    
    % rescale new hypothesis weights
    totalw=sum(weights{m}(:,i)');
    weights{m}(:,i)=weights{m}(:,i)/totalw;
    
    % select top hypothesis to draw
    subset=weights{m}(:,i);
    top = find(subset == max(subset));
    trackstate{m}(top,i);

end