classdef StructuralComputer < handle

    properties (Access = private)
        solverType
    end

    properties (Access = private)
        necessaryData
        stiffnessMatrix
        externalForce
        displacements
        reactions
        criticalStressData
    end

    methods (Access = public)
        function obj = StructuralComputer(cParams)
            obj.solverType = cParams.solverType;
        end

        function [u,R,KG,Fext,eps,sig,sig_cr] = compute(obj)
            close all ;
            obj.createData();
            obj.computeDisplacementsAndReactions() ;
            obj.computeCriticalStress() ;
            u = obj.displacements ;
            R = obj.reactions ;
            KG = obj.stiffnessMatrix ;
            Fext = obj.externalForce ;
            eps = obj.criticalStressData.epsilon ;
            sig = obj.criticalStressData.sigma ;
            sig_cr = obj.criticalStressData.sigma_cr ;
        end
    end

    methods (Access = private)
        function createData(obj)
            c = DataComputer() ;
            obj.necessaryData = c.compute() ;
        end

        function computeStiffnessMatrix(obj)
            obj.createData() ;
            s.connecDofs = obj.necessaryData.connecDofs ;
            s.dimensions = obj.necessaryData.dimensions ;
            s.preprocessData = obj.necessaryData.preprocessData ;
            c = StiffnessMatrixComputer(s) ;
            KG = c.compute() ;
            obj.stiffnessMatrix = KG ;
        end

        function computeForceVectorAssembly(obj)
            s.nDof = obj.necessaryData.dimensions.n_dof ;
            s.dataForce = obj.necessaryData.preprocessData.dataForce ;
            c = ForceComputer(s) ;
            Fext = c.compute() ;
            obj.externalForce =  Fext ;
        end

        function computeDisplacementsAndReactions(obj)
            obj.computeStiffnessMatrix() ;
            obj.computeForceVectorAssembly() ;
            s.dimensions = obj.necessaryData.dimensions ;
            s.preprocessData = obj.necessaryData.preprocessData ;
            s.stiffnessMatrix = obj.stiffnessMatrix ;
            s.externalForce = obj.externalForce ;
            s.solverType = obj.solverType ;
            c = SystemSolverComputer(s) ;
            [u,R] = c.compute() ;
            obj.displacements = u ;
            obj.reactions = R ;
        end

        function computeCriticalStress(obj)
            obj.createData() ;
%             obj.computeDisplacementsAndReactions() ;
            s.displacements = obj.displacements ;
            s.incrementT = obj.necessaryData.barProperties.deltaT;
            s.dimensions = obj.necessaryData.dimensions ;
            s.connecDofs = obj.necessaryData.connecDofs ;
            s.preprocessData = obj.necessaryData.preprocessData ;
            c = CriticalStressComputer(s) ;
            obj.criticalStressData = c.compute() ;
        end
    end
end