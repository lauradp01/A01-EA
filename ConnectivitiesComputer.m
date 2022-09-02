
classdef ConnectivitiesComputer < handle

    properties (Access = private)
        n_el
        n_nod
        n_i
        Tn
    end

    methods (Access = public)

        function obj = ConnectivitiesComputer(cParams)
           obj.init(cParams);
        end

        function Td = compute(obj)
            Td = obj.computeTd() ;
        end

    end
    

    methods (Access = private)

        function init(obj,cParams)
            obj.n_el = cParams.n_el;
            obj.n_nod = cParams.n_nod ;
            obj.n_i = cParams.n_i ;
            obj.Tn = cParams.Tn ;
        end

        function dof = computeDof(obj,i,j)
            connec = obj.Tn;
            nDim   = obj.n_i;
            dof = nDim * connec(i,j);
        end

        function Td = computeTd(obj)
            nElem = obj.n_el;
            nNod = obj.n_nod;
            nDim = obj.n_i;

            Td = zeros(nElem,nNod*nDim) ;
            for i = 1:nElem
                for j = 1:nNod
                    column = j*nDim ;
                    dof = obj.computeDof(i,j);
                    for a = 1:nDim
                        Td(i,column) = dof ;
                        column = column-1 ;
                        dof = dof-1 ;
                    end
                end
            end

        end

    end

end