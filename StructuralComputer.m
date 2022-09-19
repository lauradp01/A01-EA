classdef StructuralComputer < handle

    properties (Access = private)
        solverType
    end

    properties (Access = private)
%         force 
%         elasticModule
%         superf 
%         alpha 
%         inercia 
%         incrementT 
        barProperties

%         coord
%         connec
%         dataForce
%         fixNodes
%         material
%         connecMaterial
        preprocessData

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
            prop.F = 920 ; %N
            prop.Young = 75e9 ; %Pa
            prop.Area = 120e-6 ; %m^2
            prop.thermal_coeff = 23e-6 ;%1/K
            prop.Inertia = 1400e-12 ; %m^4
            prop.deltaT = 0 ; %K
            obj.barProperties = prop ;
%             obj.force = F ;
%             obj.elasticModule = Young ;
%             obj.superf = Area ;
%             obj.alpha = thermal_coeff ;
%             obj.inercia = Inertia ;
%             obj.incrementT = deltaT ;

        end

        function computePreprocess(obj)
            % PREPROCESS
            s = obj.barProperties ;
%             s.F = obj.barProperties.F ;
%             s.Young = obj.barProperties.Young ;
%             s.Area = obj.barProperties.Area ;
%             s.thermal_coeff = obj.barProperties.thermal_coeff ;
%             s.Inertia = obj.barProperties.Inertia ;
            c = PreprocessComputer(s) ;
            [x,Tn,Fdata,fixNod,mat,Tmat] = c.compute() ;
            prepComp.coord = x ;
            prepComp.connec = Tn ;
            prepComp.dataForce = Fdata ;
            prepComp.fixNodes = fixNod ;
            prepComp.material = mat ;
            prepComp.connecMaterial = Tmat ;
            obj.preprocessData = prepComp ;

        end

        function createDimensions(obj)
            x = obj.preprocessData.coord ;
            Tn = obj.preprocessData.connec ;
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
            s.Tn = obj.preprocessData.connec ;

            c = ConnectivitiesComputer(s);
            Td = c.compute();
            obj.connecDofs = Td ;
        end

        function computeStiffnessMatrix(obj)
            obj.computeDofConnectivities() ;
            s.connecDofs = obj.connecDofs ;
            s.dimensions = obj.dimensions ;
            s.coord = obj.preprocessData.coord ;
            s.connec = obj.preprocessData.connec ;
            s.material = obj.preprocessData.material ;
            s.connecMaterial = obj.preprocessData.connecMaterial ;
            c = StiffnessMatrixComputer(s) ;
            KG = c.compute() ;
            obj.stiffnessMatrix = KG ;
             
        end

        function computeForceVectorAssembly(obj)
            % Global force vector assembly
            s.n_dof = obj.dimensions.n_dof ;
            s.Fdata = obj.preprocessData.dataForce ;

            c = ForceComputer(s) ;
            Fext = c.compute() ;
            obj.externalForce =  Fext ;

        end

        function computeDisplacementsAndReactions(obj)
            obj.computeStiffnessMatrix() ;
            obj.computeForceVectorAssembly() ;

            s.dimensions = obj.dimensions ;
            s.fixNodes = obj.preprocessData.fixNodes ;
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
            s.incrementT = obj.barProperties.deltaT;
            s.dimensions = obj.dimensions ;
            s.connecDofs = obj.connecDofs ;
            s.coord = obj.preprocessData.coord ;
            s.connec = obj.preprocessData.connec ;
            s.material = obj.preprocessData.material ;
            s.connecMaterial = obj.preprocessData.connecMaterial ;

            c = CriticalStressComputer(s) ;
            [eps,sig,sig_cr] = c.compute() ;

            obj.epsilon = eps ;
            obj.sigma = sig ;
            obj.sigma_cr = sig_cr ;
        end

        function computePlots(obj)
            s.dimensions = obj.dimensions ;
            s.displacements = obj.displacements ;
            s.coord = obj.preprocessData.coord ;
            s.connec = obj.preprocessData.connec ;
            s.epsilon = obj.epsilon ;
            s.sigma = obj.sigma ;

            c = PlotComputer(s) ;
            c.plot() ;
        end

    end
end