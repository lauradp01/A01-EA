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
        epsilon
    end

    methods (Access = public)
        function obj = StrainStressComputer(cParams)
            obj.init(cParams) ;
        end

        function [eps,sig] = compute(obj)
            obj.computeEps() ;
            eps = obj.epsilon ;
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

        function computeEps(obj)
            s.n_el = obj.n_el ;
            s.deltaT = obj.deltaT ;
            s.material = obj.preprocessData.material ;
            s.precalculateStrainStress = obj.precalculateStrainStress ;
            c = StrainComputer(s) ;
            obj.epsilon = c.compute() ;
        end

        function sig = computeSig(obj)
            obj.computeEps() ;
            nElem = obj.n_el ;
            material = obj.preprocessData.material ;
            iMat = obj.precalculateStrainStress.iMat ; 
            eps = obj.epsilon ;
            sig = zeros(nElem,1) ;
            for iElem = 1:nElem
                    sig(iElem) = material(iMat,1) * eps(iElem) ;
            end
        end
    end
end