classdef StructuralComputer

    properties (Access = private)
        solverType
    end

    methods (Access = public)
        function obj = StructuralComputer(cParams)
            obj.solverType = cParams.solverType;
        end

        function [u,KG,Fext,eps,sig,sig_cr] = compute(obj)
            %-------------------------------------------------------------------------%
            % ASSIGNMENT 01
            %-------------------------------------------------------------------------%
            % Date: 28/02/2022
            % Author/s: Laura Domínguez Pérez and Marc Garcia Poyos
            %

            

            close all;

            %% INPUT DATA

            F = 920 ; %N
            Young = 75e9 ; %Pa
            Area = 120e-6 ; %m^2
            thermal_coeff = 23e-6 ;%1/K
            Inertia = 1400e-12 ; %m^4

            deltaT = 0 ; %K


            %% PREPROCESS

            s.F = F ;
            s.Young = Young ;
            s.Area = Area ;
            s.thermal_coeff = thermal_coeff ;
            s.Inertia = Inertia ;
            c = PreprocessComputer(s) ;
            [x,Tn,Fdata,fixNod,mat,Tmat] = c.compute() ;

            %% SOLVER

            % Dimensions
            n_d = size(x,2);              % Number of dimensions
            n_i = n_d;                    % Number of DOFs for each node
            n = size(x,1);                % Total number of nodes
            n_dof = n_i*n;                % Total number of degrees of freedom
            n_el = size(Tn,1);            % Total number of elements
            n_nod = size(Tn,2);           % Number of nodes for each element
            n_el_dof = n_i*n_nod;         % Number of DOFs for each element

            % % Computation of the DOFs connectivities
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

            % % Plot displacements
            % s.n_d = n_d ;
            % s.n = n ;
            % s.u = u ;
            % s.x = x ;
            % s.Tn = Tn;
            % s.fact = 1 ;
            % c = DisplacementGraph(s) ;
            % c.plot() ;

            % % Plot strain
            % s.n_d = n_d ;
            % s.a = eps ;
            % s.x = x ;
            % s.Tn = Tn ;
            % s.title_name = 'Strain' ;
            % c = StrainStressGraph(s) ;
            % c.plot() ;
            %
            % % Plot stress
            % s.n_d = n_d ;
            % s.a = sig ;
            % s.x = x ;
            % s.Tn = Tn ;
            % s.title_name = 'Stress' ;
            % c = StrainStressGraph(s) ;
            % c.plot() ;
            %
            % % Plot stress in defomed mesh
            % s.x = x ;
            % s.Tn = Tn ;
            % s.u = u ;
            % s.sig = sig ;
            % s.scale = 10 ;
            % c = StressDefGraph(s) ;
            % c.plot() ;
            %
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
            s.solverType = obj.solverType;

            c = DisplacementsComputer(s) ;
            [u] = c.compute() ;
        end
    end
end