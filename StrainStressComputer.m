classdef StrainStressComputer < handle
   properties (Access = private)
        deltaT
        dimensions
        u
        Td
        preprocessData
        precalculateStrainStress
    end

    properties (Access = private)
        epsilon
        sigma
    end

    methods (Access = public)
        function obj = StrainStressComputer(cParams)
            obj.init(cParams) ;
        end

        function [eps,sig] = compute(obj)
            obj.computeEps() ;
            obj.computeSig() ;
            eps = obj.epsilon ;
            sig = obj.sigma ;
        end
    end

    methods (Access = private)
        function init(obj,cParams)
            obj.deltaT = cParams.deltaT ;
            obj.dimensions = cParams.dimensions ;
            obj.u = cParams.u ;
            obj.Td = cParams.Td ;
            obj.preprocessData = cParams.preprocessData ;
            obj.precalculateStrainStress = cParams.precalculateStrainStress ;
        end

        function computeEps(obj)
            s.dimensions = obj.dimensions ;
            s.deltaT = obj.deltaT ;
            s.preprocessData = obj.preprocessData ;
            s.precalculateStrainStress = obj.precalculateStrainStress ;
            c = StrainComputer(s) ;
            obj.epsilon = c.compute() ;
            c.plotEpsilon() ;
        end

        function computeSig(obj)
            s.dimensions = obj.dimensions ;
            s.preprocessData = obj.preprocessData ;
            s.iMat = obj.precalculateStrainStress.iMat ; 
            s.eps = obj.epsilon ;
            c = StressComputer(s) ;
            obj.sigma = c.compute() ;
            c.plotSigma() ;
        end
    end
end