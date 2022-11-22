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
            s.necessaryData = obj.necessaryData ;
            s.stiffnessMatrix = obj.stiffnessMatrix ;
            s.externalForce = obj.externalForce ;
            s.solverType = obj.solverType ;
            c = ConditionsComputer(s) ;
            [u,R] = c.compute() ;
            obj.displacements = u ;
            obj.reactions = R ;
        end
    end
end