classdef StrainComputer < handle
    properties (Access = private)
        dimensions 
        deltaT 
        precalculateStrainStress
        preprocessData
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

        function plotEpsilon(obj)
            obj.plotStrain() ;
        end
    end

    methods (Access = private)
        function init(obj,cParams)
            obj.dimensions = cParams.dimensions ;
            obj.deltaT = cParams.deltaT ;
            obj.precalculateStrainStress = cParams.precalculateStrainStress ;
            obj.preprocessData = cParams.preprocessData ;
        end

        function eps = computeStrain(obj)
            nElem = obj.dimensions.n_el ;
            incrementT = obj.deltaT ;
            mat = obj.preprocessData.material ;
            iMat = obj.precalculateStrainStress.iMat ;
            u_e_l = obj.precalculateStrainStress.localDisp ;
            eps = zeros(nElem,1) ;
            for iElem = 1:nElem
                l = obj.precalculateStrainStress.length ;
                eps(iElem) = [-1 0 1 0] * u_e_l(:,iElem) / l(iElem) + incrementT*mat(iMat,3);
            end
            obj.epsilon = eps ;
        end

        function plotStrain(obj)       
            s.n_d = obj.dimensions.n_d ;
            s.a = obj.epsilon ;
            s.x = obj.preprocessData.coord ;
            s.Tn = obj.preprocessData.connec ;
            s.title_name = 'Strain' ;
            c = StrainStressGraph(s) ;
            c.plot() ;
        end
    end
end