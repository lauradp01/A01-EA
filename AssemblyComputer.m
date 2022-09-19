classdef AssemblyComputer < handle
    

    properties (Access = private)
        dimensions
        preprocessData
        Kel
    end
    properties (Access = private)
        connecDofs
    end

    methods (Access = public)
        function obj = AssemblyComputer(cParams)
            obj.init(cParams) ;
        end

        function KG = compute(obj)      
            obj.computeDofConnectivities() ;
            KG = obj.computeKG() ;            
        end
    end

    methods (Access = private)
        function init(obj,cParams)
            obj.dimensions.n_el = cParams.n_el ;
            obj.dimensions.n_el_dof = cParams.n_el_dof ;
            obj.dimensions.n_dof = cParams.n_dof ;
            obj.dimensions.n_nod = cParams.n_nod ;
            obj.Kel = cParams.Kel ;
        end

        function computeDofConnectivities(obj)
            % Computation of the DOFs connectivities
            s.n_el = obj.dimensions.n_el ;
            s.n_nod = obj.dimensions.n_nod ;
            s.n_i = obj.dimensions.n_i ;
            s.Tn = obj.preprocessData.connec ;
            c = ConnectivitiesComputer(s);
            Td = c.compute();
            obj.connecDofs = Td ;
            
        end

        function [I, J] = computeSizeKG(obj)
            nElem = obj.dimensions.n_el ;
            nDofElem = obj.dimensions.n_el_dof ;
            Td = obj.connecDofs ;

            for i = 1:nElem
                for j = 1:nDofElem
                    I(i,j) = Td(i,j) ;
                    for a = 1:nDofElem
                        J(i,a) = Td(i,a) ;
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