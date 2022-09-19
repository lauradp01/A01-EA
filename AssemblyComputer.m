classdef AssemblyComputer < handle
    properties (Access = private)
        dimensions
        preprocessData
        Kel
        Td
    end

    methods (Access = public)
        function obj = AssemblyComputer(cParams)
            obj.init(cParams) ;
        end

        function KG = compute(obj)      
            KG = obj.computeKG() ;            
        end
    end

    methods (Access = private)
        function init(obj,cParams)
            obj.dimensions = cParams.dimensions ;
            obj.Kel = cParams.Kel ;
            obj.Td = cParams.Td ;
        end

        function [I, J] = computeSizeKG(obj)
            nElem = obj.dimensions.n_el ;
            nDofElem = obj.dimensions.n_el_dof ;
            connecDofs = obj.Td ;

            for i = 1:nElem
                for j = 1:nDofElem
                    I(i,j) = connecDofs(i,j) ;
                    for a = 1:nDofElem
                        J(i,a) = connecDofs(i,a) ;
                    end
                end
            end
        end

        function KG = computeKG(obj)
            nDim = obj.dimensions.n_dof ;
            nElem = obj.dimensions.n_el ;
            nDofElem = obj.dimensions.n_el_dof ;
            ElemStiffness = obj.Kel ;
            [I, J] = obj.computeSizeKG() ;
      
            KG = zeros(nDim,nDim) ;
            for i = 1:nElem
                for j = 1:nDofElem
                    for a = 1:nDofElem
                        KG(I(i,j),J(i,a)) = KG(I(i,j),J(i,a)) + ElemStiffness(j,a,i) ;
                    end
                end
            end
        end

    end

end