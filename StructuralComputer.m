classdef StructuralComputer < handle

    properties (Access = private)
        solverType
    end

    properties (Access = private)
        barProperties
        preprocessData
        dimensions
        connecDofs
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
            c = DataComputer() ;
            obj.barProperties = c.compute() ;
        end

        function computePreprocess(obj)
            s.barProperties = obj.barProperties ;
            c = PreprocessComputer(s) ;
            obj.preprocessData = c.compute() ;
        end

        function createDimensions(obj)
            s.preprocessData = obj.preprocessData ;
            c = DimensionsComputer(s) ;
            obj.dimensions = c.compute() ;
        end

        function computeDofConnectivities(obj)
            % Computation of the DOFs connectivities
            s.dimensions = obj.dimensions;
            s.connec = obj.preprocessData.connec ;
            c = ConnectivitiesComputer(s);
            Td = c.compute();
            obj.connecDofs = Td ;
        end

        function computeStiffnessMatrix(obj)
            obj.computeDofConnectivities() ;
            s.connecDofs = obj.connecDofs ;
            s.dimensions = obj.dimensions ;
            s.preprocessData = obj.preprocessData ;
            c = StiffnessMatrixComputer(s) ;
            KG = c.compute() ;
            obj.stiffnessMatrix = KG ;
             
        end

        function computeForceVectorAssembly(obj)
            s.nDof = obj.dimensions.n_dof ;
            s.dataForce = obj.preprocessData.dataForce ;
            c = ForceComputer(s) ;
            Fext = c.compute() ;
            obj.externalForce =  Fext ;

        end

        function computeDisplacementsAndReactions(obj)
            obj.computeStiffnessMatrix() ;
            obj.computeForceVectorAssembly() ;
            s.dimensions = obj.dimensions ;
            s.preprocessData = obj.preprocessData ;
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
            obj.computeDisplacementsAndReactions() ;
            s.displacements = obj.displacements ;
            s.incrementT = obj.barProperties.deltaT;
            s.dimensions = obj.dimensions ;
            s.connecDofs = obj.connecDofs ;
            s.preprocessData = obj.preprocessData ;
            c = CriticalStressComputer(s) ;
            [eps,sig,sig_cr] = c.compute() ;
            obj.epsilon = eps ;
            obj.sigma = sig ;
            obj.sigma_cr = sig_cr ;
        end
    end
end