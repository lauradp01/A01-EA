classdef BucklingComputer < handle
    properties (Access = private)
        n_el
        Td
        preprocessData
        precalculateStrainStress
    end

    methods (Access = public)
        function obj = BucklingComputer(cParams)
            obj.init(cParams) ;
        end

        function sig_cr = compute(obj)
            sig_cr = obj.computeSig_cr() ;
        end
    end

    methods (Access = private)
        function init(obj,cParams)
            obj.n_el = cParams.n_el ;
            obj.Td = cParams.Td ;
            obj.preprocessData = cParams.preprocessData ;
            obj.precalculateStrainStress = cParams.precalculateStrainStress ;
        end

        function sig_cr = computeSig_cr(obj)
            material = obj.preprocessData.material ;
            nElem = obj.n_el ;
            l = obj.precalculateStrainStress.length ;
            sig_cr = zeros(nElem,1) ;

            for i = 1:nElem
                sig_cr(i) = pi^2 * material(1) * material(4) / (l(i)^2 * material(2)) ;
            end
        end
    end

end