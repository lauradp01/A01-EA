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
s.n_nod = n_nod ;
s.n_i = n_i ;
s.Tn = Tn ;

c = ConnectivitiesComputer(s);
Td = c.compute();


% Computation of element stiffness matrices
s.n_d = n_d ;
s.n_el = n_el ;
s.x = x ;
s.Tn = Tn ;
s.mat = mat ;
s.Tmat = Tmat ;

c = StiffnessComputer(s) ;
Kel = c.compute() ;


% Global matrix assembly
s.n_el = n_el ;
s.n_el_dof = n_el_dof ;
s.n_dof = n_dof ;
s.Td = Td ;
s.Kel = Kel ;

c = AssemblyComputer(s) ;
KG = c.compute() ;



% Global force vector assembly
s.n_dof = n_dof ;
s.Fdata = Fdata ;

c = ForceComputer(s) ;
Fext = c.compute() ;


% Apply conditions 
s.n_dof = n_dof ;
s.fixNod = fixNod ;

c = ConditionsComputer(s) ;
[vL,vR,uR] = c.compute() ;


% System resolution
s.vL = vL ;
s.vR = vR ;
s.uR = uR ;
s.KG = KG ;
s.Fext = Fext ;

c = SystemSolver(s) ;
[u,R] = c.compute() ;


% Compute strain and stresses
s.deltaT = deltaT ;
s.n_el = n_el ;
s.u = u ;
s.Td = Td ;
s.x = x ;
s.Tn = Tn ;
s.mat = mat ;
s.Tmat = Tmat ;

c = StrainStressComputer(s) ;
[eps, sig] = c.compute() ;

 
%% POSTPROCESS

% Plot displacements
s.n_d = n_d ;
s.n = n ;
s.u = u ;
s.x = x ;
s.Tn = Tn;
s.fact = 1 ;
c = DisplacementGraph(s) ;
c.plot() ; 



% Plot strain
s.n_d = n_d ;
s.a = eps ;
s.x = x ;
s.Tn = Tn ;
s.title_name = 'Strain' ;
c = StrainStressGraph(s) ;
c.plot() ;


% Plot stress
s.n_d = n_d ;
s.a = sig ;
s.x = x ;
s.Tn = Tn ;
s.title_name = 'Stress' ;
c = StrainStressGraph(s) ;
c.plot() ;


% Plot stress in defomed mesh
s.x = x ;
s.Tn = Tn ;
s.u = u ;
s.sig = sig ;
s.scale = 10 ;
c = StressDefGraph(s) ;
c.plot() ;

 
% Buckling
s.n_el = n_el ;
s.Td = Td ;
s.x = x ;
s.Tn = Tn ;
s.mat = mat ;
c = BucklingComputer(s) ;
sig_cr = c.compute() ;


%% SOLVER MODE
s.vL = vL ;
s.vR = vR ;
s.uR = uR ;
s.KG = KG ;
s.Fext = Fext ;

c = DirectOrIterative(s) ;
[uDirect,uIterative] = c.compute() ;

%% TESTS
results = runtests('tests.m') ;
