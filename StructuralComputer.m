classdef StructuralComputer < handle

    properties (Access = private)
        solverType
    end

    properties (Access = private)
        force 
        elasticModule
        superf 
        alpha 
        inercia 
        incrementT 

        coord
        connec
        dataForce
        fixNodes
        material
        connecMaterial

        dimensions
    end

    methods (Access = public)
        function obj = StructuralComputer(cParams)
            obj.solverType = cParams.solverType;
        end

        function [u,R,KG,Fext,eps,sig] = compute(obj)
            close all ;
            obj.createData();
            obj.computePreprocess();
            obj.createDimensions() ;

            u = obj.computeDisplacements() ;
            R = obj.computeReactions() ;
            KG = obj.computeMatrixAssembly ;
            Fext = obj.computeForceVectorAssembly ;
            [eps,sig] = obj.computeStrainStress() ;
           % obj.plotDisplacements();

%             %% INPUT DATA
% 
%             F = 920 ; %N
%             Young = 75e9 ; %Pa
%             Area = 120e-6 ; %m^2
%             thermal_coeff = 23e-6 ;%1/K
%             Inertia = 1400e-12 ; %m^4
% 
%             deltaT = 0 ; %K


%             %% PREPROCESS
% 
%             s.F = F ;
%             s.Young = Young ;
%             s.Area = Area ;
%             s.thermal_coeff = thermal_coeff ;
%             s.Inertia = Inertia ;
%             c = PreprocessComputer(s) ;
%             [x,Tn,Fdata,fixNod,mat,Tmat] = c.compute() ;

            % SOLVER
            
%             % Dimensions
%             n_d = size(x,2);              % Number of dimensions
%             n_i = n_d;                    % Number of DOFs for each node
%             n = size(x,1);                % Total number of nodes
%             n_dof = n_i*n;                % Total number of degrees of freedom
%             n_el = size(Tn,1);            % Total number of elements
%             n_nod = size(Tn,2);           % Number of nodes for each element
%             n_el_dof = n_i*n_nod;         % Number of DOFs for each element

%             % Computation of the DOFs connectivities
%             s.n_el = n_el;
%             s.n_nod = n_nod ;
%             s.n_i = n_i ;
%             s.Tn = Tn ;
% 
%             c = ConnectivitiesComputer(s);
%             Td = c.compute();


%             % Computation of element stiffness matrices
%             s.n_d = n_d ;
%             s.n_el = n_el ;
%             s.x = x ;
%             s.Tn = Tn ;
%             s.mat = obj.material ;
%             s.Tmat = obj.connecMaterial ;
% 
%             c = StiffnessComputer(s) ;
%             Kel = c.compute() ;


%             % Global matrix assembly
%             s.n_el = n_el ;
%             s.n_el_dof = n_el_dof ;
%             s.n_dof = n_dof ;
%             s.Td = Td ;
%             s.Kel = Kel ;
% 
%             c = AssemblyComputer(s) ;
%             KG = c.compute() ;



%             % Global force vector assembly
%             s.n_dof = n_dof ;
%             s.Fdata = Fdata ;
% 
%             c = ForceComputer(s) ;
%             Fext = c.compute() ;


%             % Apply conditions
%             s.n_dof = n_dof ;
%             s.fixNod = fixNod ;
% 
%             c = ConditionsComputer(s) ;
%             [vL,vR,uR] = c.compute() ;

%             % Displacements
%             s.vL = vL ;
%             s.vR = vR ;
%             s.uR = uR ;
%             s.KG = KG ;
%             s.Fext = Fext ;
%             s.solverType = obj.solverType;
% 
%             c = DisplacementsComputer(s) ;
%             [u] = c.compute() ;


%             % Reactions
%             s.vL = vL ;
%             s.vR = vR ;
%             s.uR = uR ;
%             s.KG = KG ;
%             s.Fext = Fext ;
% 
%             c = SystemSolver(s) ;
%             R = c.compute() ;


%             % Compute strain and stresses
%             s.deltaT = deltaT ;
%             s.n_el = n_el ;
%             s.u = u ;
%             s.Td = Td ;
%             s.x = x ;
%             s.Tn = Tn ;
%             s.mat = mat ;
%             s.Tmat = Tmat ;
% 
%             c = StrainStressComputer(s) ;
%             [eps,sig] = c.compute() ;

%             %% POSTPROCESS
% 
%             % Plot displacements
%             s.n_d = n_d ;
%             s.n = n ;
%             s.u = u ;
%             s.x = x ;
%             s.Tn = Tn;
%             s.fact = 1 ;
%             c = DisplacementGraph(s) ;
%             c.plot() ;
% 
%             % Plot strain
%             s.n_d = n_d ;
%             s.a = eps ;
%             s.x = x ;
%             s.Tn = Tn ;
%             s.title_name = 'Strain' ;
%             c = StrainStressGraph(s) ;
%             c.plot() ;
%             
%             % Plot stress
%             s.n_d = n_d ;
%             s.a = sig ;
%             s.x = x ;
%             s.Tn = Tn ;
%             s.title_name = 'Stress' ;
%             c = StrainStressGraph(s) ;
%             c.plot() ;
%             
%             % Plot stress in defomed mesh
%             s.x = x ;
%             s.Tn = Tn ;
%             s.u = u ;
%             s.sig = sig ;
%             s.scale = 10 ;
%             c = StressDefGraph(s) ;
%             c.plot() ;
%             
%             % Buckling
%             s.n_el = n_el ;
%             s.Td = Td ;
%             s.x = x ;
%             s.Tn = Tn ;
%             s.mat = mat ;
%             c = BucklingComputer(s) ;
%             sig_cr = c.compute() ;

           
        end
    end

    methods (Access = private)

        function createData(obj)
            % INPUT DATA
            F = 920 ; %N
            Young = 75e9 ; %Pa
            Area = 120e-6 ; %m^2
            thermal_coeff = 23e-6 ;%1/K
            Inertia = 1400e-12 ; %m^4
            deltaT = 0 ; %K

            obj.force = F ;
            obj.elasticModule = Young ;
            obj.superf = Area ;
            obj.alpha = thermal_coeff ;
            obj.inercia = Inertia ;
            obj.incrementT = deltaT ;

        end

        function computePreprocess(obj)
            % PREPROCESS
            s.F = obj.force ;
            s.Young = obj.elasticModule ;
            s.Area = obj.superf ;
            s.thermal_coeff = obj.alpha ;
            s.Inertia = obj.inercia ;
            c = PreprocessComputer(s) ;
            [x,Tn,Fdata,fixNod,mat,Tmat] = c.compute() ;
            obj.coord = x ;
            obj.connec = Tn ;
            obj.dataForce = Fdata ;
            obj.fixNodes = fixNod ;
            obj.material = mat ;
            obj.connecMaterial = Tmat ;

        end

        function dim = createDimensions(obj)
            x = obj.coord ;
            Tn = obj.connec ;
            % Dimensions
            dim.n_d = size(x,2) ;              % Number of dimensions
            dim.n_i = dim.n_d ;                    % Number of DOFs for each node
            dim.n = size(x,1) ;                % Total number of nodes
            dim.n_dof = dim.n_i*dim.n ;                % Total number of degrees of freedom
            dim.n_el = size(Tn,1) ;            % Total number of elements
            dim.n_nod = size(Tn,2) ;           % Number of nodes for each element
            dim.n_el_dof = dim.n_i*dim.n_nod ;         % Number of DOFs for each element
            obj.dimensions = dim ;

        end

        function Td = computeDofConnectivities(obj)
            % Computation of the DOFs connectivities
            s.n_el = obj.dimensions.n_el ;
            s.n_nod = obj.dimensions.n_nod ;
            s.n_i = obj.dimensions.n_i ;
            s.Tn = obj.connec ;

            c = ConnectivitiesComputer(s);
            Td = c.compute();
        end

        function Kel = computeElementStiffnessMatrix(obj)
            % Computation of element stiffness matrices
            s.n_d = obj.dimensions.n_d ;
            s.n_el = obj.dimensions.n_el ;
            s.x = obj.coord ;
            s.Tn = obj.connec ;
            s.mat = obj.material ;
            s.Tmat = obj.connecMaterial ;

            c = StiffnessComputer(s) ;
            Kel = c.compute() ;
        end

        function KG = computeMatrixAssembly(obj)
            Td = obj.computeDofConnectivities() ;
            Kel = obj.computeElementStiffnessMatrix() ;
            % Global matrix assembly
            s.n_el = obj.dimensions.n_el ;
            s.n_el_dof = obj.dimensions.n_el_dof ;
            s.n_dof = obj.dimensions.n_dof ;
            s.Td = Td ;
            s.Kel = Kel ;

            c = AssemblyComputer(s) ;
            KG = c.compute() ;
        end

        function Fext = computeForceVectorAssembly(obj)
            % Global force vector assembly
            s.n_dof = obj.dimensions.n_dof ;
            s.Fdata = obj.dataForce ;

            c = ForceComputer(s) ;
            Fext = c.compute() ;

        end

        function [vL,vR,uR] = computeConditions(obj)
            % Apply conditions
            s.n_dof = obj.dimensions.n_dof ;
            s.fixNod = obj.fixNodes ;

            c = ConditionsComputer(s) ;
            [vL,vR,uR] = c.compute() ;
        end
        
        function u = computeDisplacements(obj)
            [vL,vR,uR] = obj.computeConditions() ;
            KG = obj.computeMatrixAssembly() ;
            Fext = obj.computeForceVectorAssembly() ;
            % Displacements
            s.vL = vL ;
            s.vR = vR ;
            s.uR = uR ;
            s.KG = KG ;
            s.Fext = Fext ;
            s.solverType = obj.solverType;

            c = DisplacementsComputer(s) ;
            [u] = c.compute() ;
        end

        function R = computeReactions(obj)
            [vL,vR,uR] = obj.computeConditions() ;
            KG = obj.computeMatrixAssembly() ;
            Fext = obj.computeForceVectorAssembly() ;
            % Reactions
            s.vL = vL ;
            s.vR = vR ;
            s.uR = uR ;
            s.KG = KG ;
            s.Fext = Fext ;

            c = SystemSolver(s) ;
            R = c.compute() ;
        end

        function [eps,sig] = computeStrainStress(obj)
            obj.createDimensions() ;
            Td = obj.computeDofConnectivities ;
            u = obj.computeDisplacements() ;
            % Compute strain and stresses
            s.deltaT = obj.incrementT ;
            s.n_el = obj.dimensions.n_el ;
            s.u = u ;
            s.Td = Td ;
            s.x = obj.coord ;
            s.Tn = obj.connec ;
            s.mat = obj.material ;
            s.Tmat = obj.connecMaterial ;

            c = StrainStressComputer(s) ;
            [eps,sig] = c.compute() ;
        end

    end
end