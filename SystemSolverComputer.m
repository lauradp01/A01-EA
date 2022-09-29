classdef SystemSolverComputer < handle    
    properties (Access = private)
        dimensions
        stiffnessMatrix
        externalForce
        solverType
        preprocessData
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
            obj.computeDisplacements() ;
            obj.computeReactions() ;
            u = obj.displacements ;
            R = obj.reactions ;
        end
    end
    methods (Access = private)

        function init(obj,cParams)
            obj.dimensions = cParams.dimensions ;
            obj.preprocessData = cParams.preprocessData ;
            obj.stiffnessMatrix = cParams.stiffnessMatrix ;
            obj.externalForce = cParams.externalForce ;
            obj.solverType = cParams.solverType ;
        end

        function computeConditions(obj)
            s.n_dof = obj.dimensions.n_dof ;
            s.fixNod = obj.preprocessData.fixNodes ;
            c = ConditionsComputer(s) ;
            [vL,vR,uR] = c.compute() ;
            obj.freeDof = vL ;
            obj.prescribedDof = vR ;
            obj.prescribedDispl = uR ;
        end

        function computeSolverPreparation(obj)
            s.vL = obj.freeDof ;
            s.vR = obj.prescribedDof ;
            s.uR = obj.prescribedDispl ;
            s.KG = obj.stiffnessMatrix ;
            s.Fext = obj.externalForce ;
            s.dimensions = obj.dimensions ;
            s.preprocessData = obj.preprocessData ;
            s.solverType = obj.solverType;
            c = SolverPreparationComputer(s) ;
            [K,F,uL] = c.compute() ;
            obj.splittedK = K ;
            obj.extF = F ;
            obj.uLdisp = uL ;
        end

        function u = computeDisplacements(obj)
            obj.computeSolverPreparation() ;
            s.dimensions = obj.dimensions ;
            s.preprocessData = obj.preprocessData ;
            s.vL = obj.freeDof ;
            s.vR = obj.prescribedDof ;
            s.uR = obj.prescribedDispl ;
            s.KG = obj.stiffnessMatrix ;
            s.Fext = obj.externalForce ;
            s.solverType = obj.solverType;
            s.uLdisp = obj.uLdisp ;
            c = DisplacementsComputer(s) ;
            [u] = c.compute() ;
            c.plotDisplacements() ;
            obj.displacements = u ;
        end

        function R = computeReactions(obj)
            obj.computeSolverPreparation() ;
            s.vL = obj.freeDof ;
            s.vR = obj.prescribedDof ;
            s.uR = obj.prescribedDispl ;
            s.KG = obj.stiffnessMatrix ;
            s.Fext = obj.externalForce ;
            s.solverType = obj.solverType ;
            s.uLdisp = obj.uLdisp ;
            s.splittedK = obj.splittedK ;
            s.extF = obj.extF ;  
            c = ReactionsComputer(s) ;
            R = c.compute() ;
            obj.reactions = R ;
        end
    end
end