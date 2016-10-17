% Test script for numerical integration

options = odeset('RelTol', 1e-012, 'AbsTol', 1e-010, 'events', @eventfunction);

global mu e ep h_l h_u theta_l theta_u simtime req sma maxt distscale f stabnumberb

%% INITIALISE VARIABLES

mu = 3.226e-006; % mass ratio, check this
ep = 0.0934; % try and grab this from ephemeris too
distscale = 229.4e+006; % S-Mars distance
req = 3397; % Mars equatorial radius
sma = 1.523688;
f = pi/2; % Initial true anomaly
maxt = 50000;
h_l = 250;
h_u = 250000;
theta_l = 0;
theta_u = 2*pi;
simtime = [0 5000];
e = 0.096;
stabarray = [];
ballisticescape = [];
stabarrayb = [];
ballisticescapeb = []

%% Initialise computation matrixes

for i = 1:1:10;
    for j = 1:1:10;
        y=[];
        y=zeros(8, 1);
        h_i = h_l + (i-1)*(h_u-h_l)/(10-1);
        theta_j = theta_l + (j-1)*(theta_u - theta_l)/(10-1);
        r_i  = (req+h_i)/(distscale);
        y(3) = r_i; % r2
        y(7) = theta_j; % theta2
        y(4) = -1*r_i*ep*sin(f)/(1+ep*cos(f)); %r2'
        y(8) = (((mu)*(1+e))/(r_i^3*(1+ep*cos(f))))^0.5-1; % theta2'
        y(1) = (r_i^2+2*r_i*cos(theta_j)+1)^0.5; % r1
        y(5) = atan((r_i*sin(theta_j))/((1+r_i*cos(theta_j)))); %theta1
        y(2) = y(4)*cos(theta_j-y(5))-y(3)*y(8)*sin(theta_j-y(5)); %dr1
        y(6) = y(4)/y(1)*sin(theta_j - y(5))+y(3)*y(8)/y(1)*cos(theta_j-y(5)); %theta1
        y_init = y(1:8);
        [t, y, te, ye, ie] = ode45(@statvec, [0 1], y_init, options);
        [x, y1] = pol2cart( y(3), y(8));
        thetaout=y(:,8);
        rout=y(:,3);
%         for i = 1:1:10
%             B = ie < i;
%             C = ie(B);
%             stabnumber = size(C);
%             if stabnumber == 1
%                 stabarray = [stabarray; y(1, :)];
%             end
        index1 = find(ie==4);
        B = index1 < 6;
        C = ie(B);
        stabnumber = size(C);
        stabarray = [stabarray; y(1:8)];
        index = find(ie==3);
        if index == 1
            ballisticescape = [ballisticescape; y(1:8)];
        end
        
    end
end
%%
for i = 1:1:10;
    for j = 1:1:10;
        y=[];
        y=zeros(8, 1);
        h_i = h_l + (i-1)*(h_u-h_l)/(10-1);
        theta_j = theta_l + (j-1)*(theta_u - theta_l)/(10-1);
        r_i  = (req+h_i)/(distscale);
        y(3) = r_i; % r2
        y(7) = theta_j; % theta2
        y(4) = r_i*ep*sin(f)/(1+ep*cos(f)); %r2'
        y(8) = -1*(((mu)*(1+e))/(r_i^3*(1+ep*cos(f))))^0.5-1; % theta2'
        y(1) = (r_i^2+2*r_i*cos(theta_j)+1)^0.5; % r1
        y(5) = atan((r_i*sin(theta_j))/((1+r_i*cos(theta_j)))); %theta1
        y(2) = -1*y(4)*cos(theta_j-y(5))-y(3)*y(8)*sin(theta_j-y(5)); %dr1
        y(6) = -1*y(4)/y(1)*sin(theta_j - y(5))+y(3)*y(8)/y(1)*cos(theta_j-y(5)); %theta1
        y_init = y(1:8);
        [t, y, te, ye, ie] = ode45(@statvec, [1 0], y_init, options);
        [x, y1] = pol2cart( y(3), y(8));
        index1 = find(ie==4);
        Bb = index1 < 1;
        Cb = ie(Bb);
        stabnumberb = size(Cb);
        stabarrayb = [stabarrayb; y(1:8)];
        indexb = find(ie==3);
        if indexb == 1
            ballisticescapeb = [ballisticescapeb; y(1:8)];
        end
    end
end
