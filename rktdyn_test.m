%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Test of rkydyn ode45 function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;clc;close all

global delvec dt

tf = 20;
dt = 0.05;
tvec = 0:dt:tf;
delvec = zeros(1,length(tvec));

odeOpt = odeset('RelTol', 1e-6, 'AbsTol', 1e-6);
h0 = 0;
v0 = 0;
z0 = 0;
m0 = 10;
x0 = [h0, v0, z0, m0]';

cnsts.tbo   = 5;        % Time of burnout
cnsts.a     = 0;        % Thrust curve coefficient
cnsts.b     = -10;      % Thrust curve coefficient
cnsts.c     = 700;      % Thrust curve coefficient
cnsts.A     = 5;        % DC motor gain
cnsts.tao   = .25;      % DC motor time constant
cnsts.xcp   = 0.001;    % c.p. of airbrake from LE
cnsts.rho   = 1.225;    % Air density
cnsts.Ab    = 0.005;    % Area of airbrake
cnsts.Ar    = 0.05;     % Cross sectional area of rocket body
cnsts.n     = 4;        % Number of airbrakes
cnsts.th    = 0;        % Rocket angle to vertical
cnsts.ue    = 3000;     % Exhaust gas velicity
cnsts.g     = 9.81;     % Gravity
cnsts.Cdb   = 0.5;      % Airbrake drag coefficient
cnsts.Cdr   = 0.5;      % Rocket drag coefficient
cnsts.delmax= pi/4;     % Max airbrake deflection

% Run with applying 1 volt to actuator
u = 1;
[tout, yout] = ode45(@(t, x) rktdyn(t, x, u, cnsts),[0 15], x0, odeOpt);
figure
plot(tout,yout(:,1));
hold on
plot(tout,yout(:,2));

% Now with no control. Plot wth --
u = 0;
[tout, yout] = ode45(@(t, x) rktdyn(t, x, u, cnsts),[0 15], x0, odeOpt);
ax = gca;
ax.ColorOrderIndex = 1;
plot(tout,yout(:,1),'--');
hold on
plot(tout,yout(:,2),'--');


figure
plot(tvec,delvec);
max(yout(:,1))