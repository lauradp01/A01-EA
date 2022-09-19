
classdef ConnectivitiesComputer < handle

    properties (Access = private)
        dimensions
        preprocessData
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
            obj.dimensions.n_el = cParams.n_el;
            obj.dimensions.n_nod = cParams.n_nod ;
            obj.dimensions.n_i = cParams.n_i ;
            obj.preprocessData.Tn = cParams.Tn ;
        end

        function dof = computeDof(obj,i,j)
            connec = obj.preprocessData.Tn;
            nDim   = obj.dimensions.n_i;
            dof = nDim * connec(i,j);
        end

        function Td = computeTd(obj)
            nElem = obj.dimensions.n_el;
            nNod = obj.dimensions.n_nod;
            nDim = obj.dimensions.n_i;

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