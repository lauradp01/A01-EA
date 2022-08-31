classdef AssemblyComputer < handle
    

    properties (Access = private)
        n_el
        n_el_dof
        n_dof
        Td
        Kel
    end

    methods (Access = public)
        function obj = AssemblyComputer(cParams)
            obj.init(cParams) ;
        end

        function KG = compute(obj)
            nDim = obj.n_dof ;
            nElem = obj.n_el ;
            nDofElem = obj.n_el_dof ;
            ElemStiffness = obj.Kel ;
            DofConnec = obj.Td ;

            KG = zeros(nDim,nDim) ;
            for i = 1:nElem
                for j = 1:nDofElem
                    I = DofConnec(i,j) ;
                    for a = 1:nDofElem
                        J = DofConnec(i,a) ;
                        KG(I,J) = KG(I,J) + ElemStiffness(j,a,i) ;
                    end
                end
            end

            
        end
    end

    methods (Access = private)
        function init(obj,cParams)
            obj.n_el = cParams.n_el ;
            obj.n_el_dof = cParams.n_el_dof ;
            obj.n_dof = cParams.n_dof ;
            obj.Td = cParams.Td ;
            obj.Kel = cParams.Kel ;
        end
    end

end