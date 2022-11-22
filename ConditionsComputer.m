
classdef ConditionsComputer < handle
    properties (Access = private)
        necessaryData
        stiffnessMatrix
        externalForce
        solverType
    end
    properties (Access = private)
        displacements
        reactions
    end

    methods (Access = public)
        function obj = ConditionsComputer(cParams)
            obj.init(cParams) ;
        end

        function [u,R] = compute(obj)
            obj.computeSolverPreparation() ;
            u = obj.displacements ;
            R = obj.reactions ;
        end
    end

    methods (Access = private)
        function init(obj,cParams)
            obj.necessaryData = cParams.necessaryData ;
            obj.stiffnessMatrix = cParams.stiffnessMatrix ;
            obj.externalForce = cParams.externalForce;
            obj.solverType = cParams.solverType ;
        end
        function prescribed_dofs = computePrescribed_dofs(obj)
            fixedNodes = obj.necessaryData.preprocessData.fixNodes ;
            prescribed_dofs = size(fixedNodes,1) ;
        end
        function vL = computeFreeDOF(obj)
            nDim = obj.necessaryData.dimensions.n_dof ;
            fixedNodes = obj.necessaryData.preprocessData.fixNodes ;
            prescribed_dofs = obj.computePrescribed_dofs() ;
            vL = zeros(nDim-prescribed_dofs,1) ;
            a = 0 ;
            pos_vL = 1 ;
            for i = 1:nDim
                for j = 1:prescribed_dofs
                    if i == fixedNodes(j,2)
                        a = 1 ;
                    end
                end
                if a == 0
                    vL(pos_vL) = i ;
                    pos_vL = pos_vL + 1 ; 
                end
                a = 0 ;
            end
        end

        function vR = computePrescDOF(obj)
            nDim = obj.necessaryData.dimensions.n_dof ;
            fixedNodes = obj.necessaryData.preprocessData.fixNodes ;
            prescribed_dofs = obj.computePrescribed_dofs() ;
            vR = zeros(prescribed_dofs,1) ;
            for i = 1:nDim
                for j = 1:prescribed_dofs
                    if i == fixedNodes(j,2)

                        vR(j) = i ;
                    end
                end
            end
        end

        function uR = computePrescDispl(obj)
            nDim = obj.necessaryData.dimensions.n_dof ;
            fixedNodes = obj.necessaryData.preprocessData.fixNodes ;
            prescribed_dofs = obj.computePrescribed_dofs() ;
            uR = zeros(prescribed_dofs,1) ;
            for i = 1:nDim
                for j = 1:prescribed_dofs
                    if i == fixedNodes(j,2)
                        uR(j) = fixedNodes(j,3) ;
                    end
                end
            end
        end
        function computeSolverPreparation(obj)
            s.necessaryData = obj.necessaryData ;
            s.vL = obj.computeFreeDOF() ;
            s.vR = obj.computePrescDOF() ;
            s.uR = obj.computePrescDispl() ; 
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