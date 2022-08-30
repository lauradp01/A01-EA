%-------------------------------------------------------------------------%
% ASSIGNMENT 01
%-------------------------------------------------------------------------%
% Date: 28/02/2022
% Author/s: Laura Domínguez Pérez and Marc Garcia Poyos
%

clear;

close all;

%% INPUT DATA

F = 920 ; %N
Young = 75e9 ; %Pa
Area = 120e-6 ; %m^2
thermal_coeff = 23e-6 ;%1/K
Inertia = 1400e-12 ; %m^4

deltaT = 0 ; %K


%% PREPROCESS

% Nodal coordinates matrix creation
%  x(a,j) = coordinate of node a in the dimension j
x = [%  X       Y
0 0 ;
0.5 0.2 ;
1 0.4 ;
1.5 0.6 ;
0 0.5 ;
0.5 0.6 ;
1 0.7 ;
1.5 0.8
];

% Connectivities matrix ceation
%  Tn(e,a) = global nodal number associated to node a of element e
Tn = [%     a      b
1 2 ;
2 3 ;
3 4 ;
5 6 ;
6 7 ; 
7 8 ;
1 5 ;
1 6 ; 
2 5 ;
2 6 ; 
2 7 ;
3 6 ;
3 7 ;
3 8 ;
4 7 ;
4 8 ;
];

% External force matrix creation
%  Fdata(k,1) = node at which the force is applied
%  Fdata(k,2) = DOF (direction) at which the force is applied
%  Fdata(k,3) = force magnitude in the corresponding DOF
Fdata = [%   Node        DOF  Magnitude   
2 4 3*F ;
3 6 2*F ;
4 8 F ;
];

% Fix nodes matrix creation
%  fixNod(k,1) = node at which some DOF is prescribed
%  fixNod(k,2) = DOF prescribed
%  fixNod(k,3) = prescribed displacement in the corresponding DOF (0 for fixed)
fixNod = [% Node        DOF  Magnitude
1 1 0 ;
1 2 0 ;
5 9 0 ;
5 10 0 ;
];

% Material data
%  mat(m,1) = Young modulus of material m
%  mat(m,2) = Section area of material m
%  --more columns can be added for additional material properties--
mat = [% Young M.   Section A.   thermal_coeff   Inertia
         Young,   Area,      thermal_coeff,     Inertia;  % Material (1)
];

% Material connectivities
%  Tmat(e) = Row in mat corresponding to the material associated to element e 
Tmat = [% Mat. index
1 ; 1 ; 1 ; 1 ; 1 ; 1 ; 1 ; 1 ; 1 ; 1 ; 1 ; 1 ; 1 ; 1 ; 1 ; 1  
];

%% SOLVER

% Dimensions
n_d = size(x,2);              % Number of dimensions
n_i = n_d;                    % Number of DOFs for each node
n = size(x,1);                % Total number of nodes
n_dof = n_i*n;                % Total number of degrees of freedom
n_el = size(Tn,1);            % Total number of elements
n_nod = size(Tn,2);           % Number of nodes for each element
n_el_dof = n_i*n_nod;         % Number of DOFs for each element 

% Computation of the DOFs connectivities
s.n_el = n_el;
c = ConnectivitiesComputer(s);
Td = c.compute();

Td = connectDOFs(n_el,n_nod,n_i,Tn);

% Computation of element stiffness matrices
Kel = computeKelBar(n_d,n_el,x,Tn,mat,Tmat);

% Global matrix assembly
KG = assemblyKG(n_el,n_el_dof,n_dof,Td,Kel);

% Global force vector assembly
Fext = computeF(n_i,n_dof,Fdata);

% Apply conditions 
[vL,vR,uR] = applyCond(n_i,n_dof,fixNod);

% System resolution
[u,R] = solveSys(vL,vR,uR,KG,Fext);

% Compute strain and stresses
[eps,sig] = computeStrainStressBar(deltaT,n_el,u,Td,x,Tn,mat,Tmat);

%% POSTPROCESS

% Plot displacements
plotDisp(n_d,n,u,x,Tn,1);

% Plot strains
plotStrainStress(n_d,eps,x,Tn,{'Strain'});

% Plot stress
plotStrainStress(n_d,sig,x,Tn,{'Stress';'(Pa)'});

% Plot stress in defomed mesh
plotBarStressDef(x,Tn,u,sig,1)

u_node4 = (u(7)^2+u(8)^2)^0.5 *1e3 ; %mm
sig_cr = buckling(n_el,Td,x,Tn,mat)  ; %Pa

sig_comparison = [sig sig_cr] ;

%% SOLVER MODE
[uDirect,uIterative] = solverMode(vL,vR,uR,KG,Fext) ;

%% TESTS
results = runtests('tests.m') ;