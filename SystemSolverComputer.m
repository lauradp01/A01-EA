classdef SystemSolverComputer < handle    
    properties (Access = private)
        stiffnessMatrix
        externalForce
        solverType
        necessaryData
    end

    properties (Access = private)
        freeDof
        prescribedDof
        prescribedDispl
        displacements
        reactions
        splittedK
        extF
        uLdisp
    end

    methods (Access = public)
        function obj = SystemSolverComputer(cParams)
            obj.init(cParams) ;
        end

        function [u,R] = compute(obj)
            obj.computeConditions() ;
            obj.computeSolverPreparation() ;
            u = obj.displacements ;
            R = obj.reactions ;
        end
    end
    methods (Access = private)

        function init(obj,cParams)
            obj.necessaryData = cParams.necessaryData ;
            obj.stiffnessMatrix = cParams.stiffnessMatrix ;
            obj.externalForce = cParams.externalForce ;
            obj.solverType = cParams.solverType ;
        end

        function computeConditions(obj)
            s.n_dof = obj.necessaryData.dimensions.n_dof ;
            s.fixNod = obj.necessaryData.preprocessData.fixNodes ;
            c = ConditionsComputer(s) ;
            [vL,vR,uR] = c.compute() ;
            obj.freeDof = vL ;
            obj.prescribedDof = vR ;
            obj.prescribedDispl = uR ;
        end

        function computeSolverPreparation(obj)
            s.necessaryData = obj.necessaryData ;
            s.vL = obj.freeDof ;
            s.vR = obj.prescribedDof ;
            s.uR = obj.prescribedDispl ;
            s.KG = obj.stiffnessMatrix ;
            s.Fext = obj.externalForce ;
            s.solverType = obj.solverType;
            c = SolverPreparationComputer(s) ;
            [u,R] = c.compute() ;
            obj.displacements = u ;
            obj.reactions = R ;
        end
    end
end