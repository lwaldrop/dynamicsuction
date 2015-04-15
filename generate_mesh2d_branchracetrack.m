Test case, will not work.

L = 1;                              % length of computational domain (m)
N = 512;                            % number of Cartesian grid meshwidths at the finest level of the AMR grid
dx = L/N;                           % Cartesian mesh width (m)
ds = L/(2*N);                       % space between boundary points in straight tube

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Parameters for the racetrack

Let = 0.4;                          % Length of elastic tube (m)
Nend = 10;                           % Number of rigid points on each end of elastic section
Lt = Let+2*Nend*ds;                 % Length of straight section with three rigid points on each end

diameter = 0.1;                     % diameter of the tube
R2 = 0.1;                           % radius of inner wall
R1 = R2+diameter;                   % radius of outer wall

Nstraight = 2*ceil(Lt/ds);          % number of points along each straight section
Ncurve = 2*ceil(pi*R1/ds);          % number of points along each curved section
Nrace = Nstraight+2*Ncurve;         % number of points making up the racetrack part
dtheta = pi/(Ncurve/2);             % angle increment for drawing curved edges

mesh_name = 'heart_';               % structure name

centery = 0;                        % y-position of center of curved sections
centerx1 = -0.5*Lt;                 % x-position of center of left curved section
centerx2 = 0.5*Lt;                  % x-position of center of right curved section

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters for the pericardium
Dp = 2*diameter;                    %diameter of the pericardium
Nperi = 2*ceil((Dp-diameter)/ds);  % number of boundary points along the sides of the pericardium
Nperitot = Nperi + Nstraight;       % total number of pericardium points

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters for the actuator
La = 0.04;                          % length of the actuator section
NLa = ceil(La/ds);                  % number of points along each actuator
Ca = 0.25*Lt;                       % center of the actuator section
NCa = ceil(ceil(Nstraight/2)*Ca/Lt); % index of the center point
Na1 = NCa - ceil(NLa/2);            % index of the starting point with respect to the elastic section
Na2 = Na1+NLa-1;                    % index of the ending point with respect to the elastic section

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% material parameters
kappa_spring = 2.0e0;               % spring constant (Newton)
kappa_beam = 5.0e-1;                 % beam stiffness constant (Newton m^2)
kappa_target = kappa_spring;        % target point penalty spring constant (Newton)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Make the elastic section of the tube
% Write out the vertex information

vertex_fid = fopen([mesh_name 'tube_' num2str(N) '.vertex'], 'w');
fprintf(vertex_fid, '%d\n', Nstraight);

%top part
for i=1:ceil(Nstraight/2),
    ytop = centery-R2;
    xtop = -Lt/2+(i-1)*ds;
    fprintf(vertex_fid, '%1.16e %1.16e\n', xtop, ytop);
end

%bottom part
for i=ceil(Nstraight/2)+1:Nstraight,
    ybot = centery-R1;
    xbot = -Lt/2+(i-ceil(Nstraight/2)-1)*ds;
    fprintf(vertex_fid, '%1.16e %1.16e\n', xbot, ybot);
end
fclose(vertex_fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% actuator part
% Write out the vertex information

%top part
vertex_fid = fopen(['actuator_top_' num2str(N) '.vertex'], 'w');
fprintf(vertex_fid, '%d\n', NLa);

for i=Na1:Na2,
    ytop = centery-R2;
    xtop = -Lt/2+i*ds;
    fprintf(vertex_fid, '%1.16e %1.16e\n', xtop, ytop);
end
fclose(vertex_fid);

%bottom part
vertex_fid = fopen(['actuator_bot_' num2str(N) '.vertex'], 'w');
fprintf(vertex_fid, '%d\n', NLa);

for i=Na1:Na2,
    ybot = centery-R1;
    xbot = -Lt/2+i*ds;
    fprintf(vertex_fid, '%1.16e %1.16e\n', xbot, ybot);
end
fclose(vertex_fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% race track part
% Write out the vertex information

vertex_fid = fopen([mesh_name 'race_' num2str(N) '.vertex'], 'w');
fprintf(vertex_fid, '%d\n', Nrace);

%right curved part of racetrack
for i=1:ceil(Ncurve/2),
    theta = (i-1)*dtheta-pi/2;
    yin = centery+R2*sin(theta);
    xin = Lt/2+R2*cos(theta);
    fprintf(vertex_fid, '%1.16e %1.16e\n', xin, yin);
end

for i=ceil(Ncurve/2)+1:Ncurve,
    theta=(i-Ncurve/2-1)*dtheta-pi/2;
    yout = centery+R1*sin(theta);
    xout = Lt/2+R1*cos(theta);
    fprintf(vertex_fid, '%1.16e %1.16e\n', xout, yout);
end

%straight section on the top
for i = Ncurve+1:Ncurve+ceil(Nstraight/2),
    yin = centery+R2;
    xin = centerx2-(i-Ncurve-1)*ds;
    fprintf(vertex_fid, '%1.16e %1.16e\n', xin, yin);
end

for i = Ncurve+ceil(Nstraight/2)+1:Ncurve+Nstraight,
    yout = centery+R1;
    xout = centerx2-(i-Ncurve-ceil(Nstraight/2)-1)*ds;
    fprintf(vertex_fid, '%1.16e %1.16e\n', xout, yout);
end

%left curved part of racetrack
for i = Ncurve+Nstraight+1:Ncurve+Nstraight+ceil(Ncurve/2),
    theta = pi/2+(i-Ncurve-Nstraight-1)*dtheta;
    yin = centery+R2*sin(theta);
    xin = centerx1+R2*cos(theta);
    fprintf(vertex_fid, '%1.16e %1.16e\n', xin, yin);
end

for i = Ncurve+Nstraight+ceil(Ncurve/2)+1:2*Ncurve+Nstraight,
    theta = pi/2+(i-Ncurve-Nstraight-ceil(Ncurve/2)-1)*dtheta;
    yout = centery+R1*sin(theta);
    xout = centerx1+R1*cos(theta);
    fprintf(vertex_fid, '%1.16e %1.16e\n', xout, yout);
end
fclose(vertex_fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Pericardium
% Write out the vertex information

vertex_fid = fopen([mesh_name 'peri_' num2str(N) '.vertex'], 'w');
fprintf(vertex_fid, '%d\n', Nperitot);

% make the top and bottom of the pericardium
for i=1:ceil(Nstraight/2),
    ytop = centery-(R2-(Dp-diameter)/2);
    xtop = -Lt/2+(i-1)*ds;
    fprintf(vertex_fid, '%1.16e %1.16e\n', xtop, ytop);
end

for i=ceil(Nstraight/2)+1:Nstraight,
    ybot = centery-R1-(Dp-diameter)/2;
    xbot = -Lt/2+(i-ceil(Nstraight/2)-1)*ds;
    fprintf(vertex_fid, '%1.16e %1.16e\n', xbot, ybot);
end

% make the four side pieces
for i=Nstraight+1:Nstraight+ceil(Nperi/4),
    y = centery-(R1+(Dp-diameter)/2)+(i-Nstraight-1)*ds;
    x = -Lt/2;
    fprintf(vertex_fid, '%1.16e %1.16e\n', x, y);
end

for i=Nstraight+ceil(Nperi/4)+1:Nstraight+ceil(Nperi/2),
    y = centery-R2+(i-Nstraight-ceil(Nperi/4)-1)*ds;
    x = -Lt/2;
    fprintf(vertex_fid, '%1.16e %1.16e\n', x, y);
end

for i=Nstraight+ceil(Nperi/2)+1:Nstraight+ceil(3*Nperi/4),
    y = centery-(R1+(Dp-diameter)/2)+(i-Nstraight-ceil(Nperi/2)-1)*ds;
    x = Lt/2;
    fprintf(vertex_fid, '%1.16e %1.16e\n', x, y);
end

for i=Nstraight+ceil(3*Nperi/4)+1:Nperitot,
    y = centery-R2+(i-Nstraight-ceil(3*Nperi/4)-1)*ds;
    x = Lt/2;
    fprintf(vertex_fid, '%1.16e %1.16e\n', x, y);
end
fclose(vertex_fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Write out the spring information for the elastic section

spring_fid = fopen([mesh_name 'tube_' num2str(N) '.spring'], 'w');
fprintf(spring_fid, '%d\n', Nstraight-2);

%elastic part of tube
for i = 0:ceil(Nstraight/2)-2,
    fprintf(spring_fid, '%d %d %1.16e %1.16e\n', i, i+1, kappa_spring*ds/(ds^2), ds);
end

for i = ceil(Nstraight/2):Nstraight-2,
    fprintf(spring_fid, '%d %d %1.16e %1.16e\n', i, i+1, kappa_spring*ds/(ds^2), ds);
end

fclose(spring_fid);
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % Write out the beam information for the elastic section

beam_fid = fopen([mesh_name 'tube_' num2str(N) '.beam'], 'w');
fprintf(beam_fid, '%d\n', Nstraight-4);

%elastic part of tube
for i = 0:ceil(Nstraight/2)-3,
    fprintf(beam_fid, '%d %d %d %1.16e\n', i, i+1, i+2, kappa_beam*ds/(ds^4));
end

for i = ceil(Nstraight/2):Nstraight-3,
    fprintf(beam_fid, '%d %d %d %1.16e\n', i, i+1, i+2, kappa_beam*ds/(ds^4));
end
fclose(beam_fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Write out the target point information for the ends of the elastic tube
target_fid = fopen([mesh_name 'tube_' num2str(N) '.target'], 'w');

fprintf(target_fid, '%d\n', 4*Nend);

for i = 0:Nend-1,
    fprintf(target_fid, '%d %1.16e\n', i, kappa_target*ds/(ds^2));
end

for i = ceil(Nstraight/2)-Nend:ceil(Nstraight/2)-1,
    fprintf(target_fid, '%d %1.16e\n', i, kappa_target*ds/(ds^2));
end

for i = ceil(Nstraight/2):ceil(Nstraight/2)+Nend-1,
    fprintf(target_fid, '%d %1.16e\n', i, kappa_target*ds/(ds^2));
end

for i = Nstraight-Nend:Nstraight-1,
    fprintf(target_fid, '%d %1.16e\n', i, kappa_target*ds/(ds^2));
end

fclose(target_fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Write out the target point information for the actuator

%top actuator
target_fid = fopen(['actuator_top_' num2str(N) '.target'], 'w');
fprintf(target_fid, '%d\n', NLa);

for i = 0:NLa-1,
    fprintf(target_fid, '%d %1.16e\n', i, kappa_target*ds/(ds^2));
end

fclose(target_fid);

%bottom actuator
target_fid = fopen(['actuator_bot_' num2str(N) '.target'], 'w');
fprintf(target_fid, '%d\n', NLa);

for i = 0:NLa-1,
    fprintf(target_fid, '%d %1.16e\n', i, kappa_target*ds/(ds^2));
end

fclose(target_fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Write out the target point information for the racetrack
target_fid = fopen([mesh_name 'race_' num2str(N) '.target'], 'w');

fprintf(target_fid, '%d\n', Nrace);

for i = 0:Nrace-1,
    fprintf(target_fid, '%d %1.16e\n', i, kappa_target*ds/(ds^2));
end

fclose(target_fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Write out the target point information for the pericardium
target_fid = fopen([mesh_name 'peri_' num2str(N) '.target'], 'w');

fprintf(target_fid, '%d\n', Nperitot);

for i = 0:Nperitot-1,
    fprintf(target_fid, '%d %1.16e\n', i, kappa_target*ds/(ds^2));
end

fclose(target_fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%