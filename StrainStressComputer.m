classdef StrainStressComputer < handle
   properties (Access = private)
        deltaT
        n_el
        u
        Td
        preprocessData
        precalculateStrainStress
    end

    properties (Access = private)
        coordinates
        length
    end

    methods (Access = public)
        function obj = StrainStressComputer(cParams)
            obj.init(cParams) ;
        end

        function [eps,sig] = compute(obj)
            eps = obj.computeEps() ;
            sig = obj.computeSig() ;
        end
    end

    methods (Access = private)
        function init(obj,cParams)
            obj.deltaT = cParams.deltaT ;
            obj.n_el = cParams.n_el ;
            obj.u = cParams.u ;
            obj.Td = cParams.Td ;
            obj.preprocessData = cParams.preprocessData ;
            obj.precalculateStrainStress = cParams.precalculateStrainStress ;
        end

%         function computePrecalculation(obj)
%             s.deltaT = obj.deltaT ;
%             s.n_el = obj.n_el ;
%             s.u = obj.u ;
%             s.Td = obj.Td ;
%             s.preprocessData = obj.preprocessData ;
%             c = PrecalculateStrainStressComputer(s) ;
%             obj.precalculateStrainStress = c.compute() ;
%         end

        function eps = computeEps(obj)
%             obj.computePrecalculation() ;
            nElem = obj.n_el ;
            incrementT = obj.deltaT ;
            material = obj.preprocessData.material ;
            iMat = obj.precalculateStrainStress.iMat ;
            u_e_l = obj.precalculateStrainStress.localDisp ;
            eps = zeros(nElem,1) ;
            for iElem = 1:nElem
                l = obj.precalculateStrainStress.length ;
                eps(iElem) = [-1 0 1 0] * u_e_l(:,iElem) / l(iElem) + incrementT*material(iMat,3);
            end
        end

        function sig = computeSig(obj)
%             obj.computePrecalculation() ;
            nElem = obj.n_el ;
            material = obj.preprocessData.material ;
            iMat = obj.precalculateStrainStress.iMat ; 
            eps = obj.computeEps() ;
            sig = zeros(nElem,1) ;
            for iElem = 1:nElem
                    sig(iElem) = material(iMat,1) * eps(iElem) ;
            end
        end
    end
end