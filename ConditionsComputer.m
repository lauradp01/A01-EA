
classdef ConditionsComputer < handle
    properties (Access = private)
        n_dof
        fixNod
    end

    methods (Access = public)
        function obj = ConditionsComputer(cParams)
            obj.init(cParams) ;
        end

        function [vL,vR,uR] = compute(obj)
            vL = obj.computeFreeDOF();
            vR = obj.computePrescDOF() ;
            uR = obj.computePrescDispl() ;
            
        end
    end

    methods (Access = private)
        function init(obj,cParams)
            obj.n_dof = cParams.n_dof ;
            obj.fixNod = cParams.fixNod ;
        end

        function prescribed_dofs = computePrescribed_dofs(obj)
            fixedNodes = obj.fixNod ;
            prescribed_dofs = size(fixedNodes,1) ;
        end
        
        function vL = computeFreeDOF(obj)
            nDim = obj.n_dof ;
            fixedNodes = obj.fixNod ;
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
            nDim = obj.n_dof ;
            fixedNodes = obj.fixNod ;
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
            nDim = obj.n_dof ;
            fixedNodes = obj.fixNod ;
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

    end

end