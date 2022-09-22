classdef StrainComputer < handle
    properties (Access = private)
        n_el 
        deltaT 
        material
        precalculateStrainStress
    end
    properties (Access = private)
        epsilon
    end

    methods (Access = public)
        function obj = StrainComputer(cParams)
            obj.init(cParams) ;
        end

        function eps = compute(obj)
            obj.computeStrain() ;
            eps = obj.epsilon ;
        end
    end

    methods (Access = private)
        function init(obj,cParams)
            obj.n_el = cParams.n_el ;
            obj.deltaT = cParams.deltaT ;
            obj.material = cParams.material ;
            obj.precalculateStrainStress = cParams.precalculateStrainStress ;
        end

        function eps = computeStrain(obj)
            nElem = obj.n_el ;
            incrementT = obj.deltaT ;
            mat = obj.material ;
            iMat = obj.precalculateStrainStress.iMat ;
            u_e_l = obj.precalculateStrainStress.localDisp ;
            eps = zeros(nElem,1) ;
            for iElem = 1:nElem
                l = obj.precalculateStrainStress.length ;
                eps(iElem) = [-1 0 1 0] * u_e_l(:,iElem) / l(iElem) + incrementT*mat(iMat,3);
            end
            obj.epsilon = eps ;
        end
    end
end