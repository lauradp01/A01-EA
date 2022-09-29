
classdef CriticalStressComputer < handle
    properties (Access = private)
        displacements
        incrementT
        dimensions
        connecDofs
        preprocessData
    end

    properties (Access = private)
        precalculateStrainStress
        criticalStressData
    end

    methods
        function obj = CriticalStressComputer(cParams)
            obj.init(cParams) ;
        end

        function criticalStressData = compute(obj)
            obj.computeStrainStress ;
            obj.computeBuckling ;
            criticalStressData = obj.criticalStressData ;
        end

    end

    methods (Access = private)
        function init(obj,cParams)
            obj.displacements = cParams.displacements ;
            obj.incrementT = cParams.incrementT ;
            obj.dimensions = cParams.dimensions ;
            obj.connecDofs = cParams.connecDofs ;
            obj.preprocessData = cParams.preprocessData ;
        end

        function computePrecalculation(obj)
            s.deltaT = obj.incrementT ;
            s.dimensions = obj.dimensions ;
            s.u = obj.displacements ;
            s.Td = obj.connecDofs ;
            s.preprocessData = obj.preprocessData ;
            c = PrecalculateStrainStressComputer(s) ;
            obj.precalculateStrainStress = c.compute() ;
        end

        function [eps,sig] = computeStrainStress(obj)
            obj.computePrecalculation() ; 
            s.deltaT = obj.incrementT ;
            s.dimensions = obj.dimensions ;
            s.u = obj.displacements ;
            s.Td = obj.connecDofs ;
            s.preprocessData = obj.preprocessData ;
            s.precalculateStrainStress = obj.precalculateStrainStress ;
            c = StrainStressComputer(s) ;
            [eps,sig] = c.compute() ;
            obj.criticalStressData.epsilon = eps ;
            obj.criticalStressData.sigma = sig ;
        end

        function sig_cr = computeBuckling(obj)
            obj.computePrecalculation() ;
            s.n_el = obj.dimensions.n_el ;
            s.Td = obj.connecDofs ;
            s.preprocessData = obj.preprocessData ;
            s.precalculateStrainStress = obj.precalculateStrainStress ;
            c = BucklingComputer(s) ;
            sig_cr = c.compute() ;
            obj.criticalStressData.sigma_cr = sig_cr ;
        end
    end

end