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
            
            nDim = obj.n_dof ;
            fixedNodes = obj.fixNod ;

            prescribed_dofs = size(fixedNodes,1) ;

            vL = zeros(nDim-prescribed_dofs,1) ;
            vR = zeros(prescribed_dofs,1) ;
            uR = zeros(prescribed_dofs,1) ;
            
            a = 0 ;
            pos_vL = 1 ;
            
            for i = 1:nDim
                for j = 1:prescribed_dofs
                    if i == fixedNodes(j,2)
                        a = 1 ;
                        vR(j) = i ;
                        uR(j) = fixedNodes(j,3) ;
                    end
                end
                if a == 0
                    vL(pos_vL) = i ;
                    pos_vL = pos_vL + 1 ; 
                end
                a = 0 ;
            end
        end
    end

    methods (Access = private)
        function init(obj,cParams)
            obj.n_dof = cParams.n_dof ;
            obj.fixNod = cParams.fixNod ;
        end
    end
end