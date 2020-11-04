function dY = LaunchPadFreeDyn(t, Y, settings, Q0)
% ODE-Function of the 6DOF Rigid Rocket Model
% State = ( x y z | u v w | p q r | q0 q1 q2 q3 | m | Ixx Iyy Izz )
%
% (x y z): NED Earth's Surface Centered Frame ("Inertial") coordinates
% (u v w): body frame velocities
% (p q r): body frame angular rates
% m : total mass
% (Ixx Iyy Izz): Inertias
% (q0 q1 q2 q3): attitude unit quaternion
%
%
% NOTE: To get the NED velocities the body-frame must be multiplied for the
% conjugated of the current attitude quaternion
% E.G.
%
%
% quatrotate(quatconj(Y(:,10:13)),Y(:,4:6))

% Author: Ruben Di Battista
% Skyward Experimental Rocketry | CRD Dept | crd@skywarder.eu
% email: ruben.dibattista@skywarder.eu
% Website: http://www.skywarder.eu
% April 2014; Last revision: 31.XII.2014
% License:  2-clause BSD

% Author: Francesco Colombi
% Skyward Experimental Rocketry | CRD Dept | crd@skywarder.eu
% email: francesco.colombi@skywarder.eu
% Release date: 16/04/2016

% x = Y(1);
% y = Y(2);
% z = Y(3);
  u = Y(4);
  m = Y(5);

%% QUATERION ATTITUDE
Q_conj = [Q0(1) -Q0(2:4)'];

% Body to Inertial velocities
Vels = quatrotate(Q_conj, [u 0 0]);

%% ATMOSPHERE DATA

[~, a, ~, rho] = atmosisa(settings.z0);
M = u/a;

%% CONSTANTS

S = settings.S;              % [m^2] cross surface
CoeffsE = settings.CoeffsE;  % Empty Rocket Coefficients
CoeffsF = settings.CoeffsF;  % Full Rocket Coefficients
g = 9.80655;                 % [N/kg] module of gravitational field at zero
tb = settings.tb;            % [s]     Burning Time
mfr = settings.mfr;          % [kg/s]  Mass Flow Rate

OMEGA = settings.OMEGA;   
T = interp1(settings.motor.exp_time, settings.motor.exp_thrust, t);

alpha = 0; beta = 0;

%% DATCOM COEFFICIENTS

A_datcom = settings.Alphas*pi/180;
B_datcom = settings.Betas*pi/180;
H_datcom = settings.Altitudes;
M_datcom = settings.Machs;

%% Axial Coefficient
CAf = Interp4(A_datcom, M_datcom, B_datcom, H_datcom, CoeffsF.CA, alpha, M, beta, 0);
CAe = Interp4(A_datcom, M_datcom, B_datcom, H_datcom, CoeffsE.CA, alpha, M, beta, 0);

CA = t/tb*(CAe-CAf)+CAf;
    
%% Dynamics
Fg = m*g*sin(OMEGA);                % [N] force due to the gravity
X = 0.5*rho*u^2*S*CA;
du = (-Fg +T -X)/m;

if T < Fg                           % No velocity untill T = Fg
    du = 0;
end

%% FINAL DERIVATIVE STATE ASSEMBLING
dY(1:3) = Vels;
dY(4) = du;
dY(5) = -mfr;
dY = dY';


