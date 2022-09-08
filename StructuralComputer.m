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

        connecDofs

        elemStiffnessMat

        stiffnessMatrix

        externalForce

        displacements
        reactions

        epsilon
        sigma
        sigma_cr
    end

    methods (Access = public)
        function obj = StructuralComputer(cParams)
            obj.solverType = cParams.solverType;
        end

        function [u,R,KG,Fext,eps,sig,sig_cr] = compute(obj)
            close all ;
            obj.createData();
            obj.computePreprocess();
            obj.createDimensions() ;
            obj.computeDisplacementsAndReactions() ;
            obj.computeCriticalStress() ;
            obj.computePlots() ;

            u = obj.displacements ;
            R = obj.reactions ;
            KG = obj.stiffnessMatrix ;
            Fext = obj.externalForce ;
            eps = obj.epsilon ;
            sig = obj.sigma ;
            sig_cr = obj.sigma_cr ;

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
            dim.n_i = dim.n_d ;                % Number of DOFs for each node
            dim.n = size(x,1) ;                % Total number of nodes
            dim.n_dof = dim.n_i*dim.n ;        % Total number of degrees of freedom
            dim.n_el = size(Tn,1) ;            % Total number of elements
            dim.n_nod = size(Tn,2) ;           % Number of nodes for each element
            dim.n_el_dof = dim.n_i*dim.n_nod ; % Number of DOFs for each element
            obj.dimensions = dim ;

        end

        function computeDofConnectivities(obj)
            % Computation of the DOFs connectivities
            s.n_el = obj.dimensions.n_el ;
            s.n_nod = obj.dimensions.n_nod ;
            s.n_i = obj.dimensions.n_i ;
            s.Tn = obj.connec ;

            c = ConnectivitiesComputer(s);
            Td = c.compute();
            obj.connecDofs = Td ;
        end

        function computeStiffnessMatrix(obj)
            obj.computeDofConnectivities() ;
            s.connecDofs = obj.connecDofs ;
            s.dimensions = obj.dimensions ;
            s.coord = obj.coord ;
            s.connec = obj.connec ;
            s.material = obj.material ;
            s.connecMaterial = obj.connecMaterial ;
            c = StiffnessMatrixComputer(s) ;
            KG = c.compute() ;
            obj.stiffnessMatrix = KG ;
             
        end

        function computeForceVectorAssembly(obj)
            % Global force vector assembly
            s.n_dof = obj.dimensions.n_dof ;
            s.Fdata = obj.dataForce ;

            c = ForceComputer(s) ;
            Fext = c.compute() ;
            obj.externalForce =  Fext ;

        end

        function computeDisplacementsAndReactions(obj)
            obj.computeStiffnessMatrix() ;
            obj.computeForceVectorAssembly() ;

            s.dimensions = obj.dimensions ;
            s.fixNodes = obj.fixNodes ;
            s.stiffnessMatrix = obj.stiffnessMatrix ;
            s.externalForce = obj.externalForce ;
            s.solverType = obj.solverType ;

            c = SystemSolverComputer(s) ;
            [u,R] = c.compute() ;
            obj.displacements = u ;
            obj.reactions = R ;
        end

        function computeCriticalStress(obj)
            obj.computeDofConnectivities ;
            s.displacements = obj.displacements ;
            s.incrementT = obj.incrementT ;
            s.dimensions = obj.dimensions ;
            s.connecDofs = obj.connecDofs ;
            s.coord = obj.coord ;
            s.connec = obj.connec ;
            s.material = obj.material ;
            s.connecMaterial = obj.connecMaterial ;

            c = CriticalStressComputer(s) ;
            [eps,sig,sig_cr] = c.compute() ;

            obj.epsilon = eps ;
            obj.sigma = sig ;
            obj.sigma_cr = sig_cr ;
        end

        function computePlots(obj)
            s.dimensions = obj.dimensions ;
            s.displacements = obj.displacements ;
            s.coord = obj.coord ;
            s.connec = obj.connec ;
            s.epsilon = obj.epsilon ;
            s.sigma = obj.sigma ;

            c = PlotComputer(s) ;
            c.plot() ;
        end

    end
end