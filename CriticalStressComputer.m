
classdef CriticalStressComputer < handle
    properties (Access = private)
        displacements
        incrementT
        dimensions
        connecDofs
        preprocessData
    end

    properties (Access = private)
        epsilon
        sigma
        sigma_cr
    end

    methods
        function obj = CriticalStressComputer(cParams)
            obj.init(cParams) ;
        end

        function [eps,sig,sig_cr] = compute(obj)
            obj.computeStrainStress ;
            obj.computeBuckling ;

            eps = obj.epsilon ;
            sig = obj.sigma ;
            sig_cr = obj.sigma_cr ;            
        end

    end

    methods (Access = private)
        function init(obj,cParams)
            obj.displacements = cParams.displacements ;
            obj.incrementT = cParams.incrementT ;
            obj.dimensions = cParams.dimensions ;
            obj.connecDofs = cParams.connecDofs ;
            obj.preprocessData.coord = cParams.preprocessData.coord ;
            obj.preprocessData.connec = cParams.preprocessData.connec ;
            obj.preprocessData.material = cParams.preprocessData.material ;
            obj.preprocessData.connecMaterial = cParams.preprocessData.connecMaterial ;
        end

        function [eps,sig] = computeStrainStress(obj)
            % Compute strain and stresses
            s.deltaT = obj.incrementT ;
            s.n_el = obj.dimensions.n_el ;
            s.u = obj.displacements ;
            s.Td = obj.connecDofs ;
            s.x = obj.preprocessData.coord ;
            s.Tn = obj.preprocessData.connec ;
            s.mat = obj.preprocessData.material ;
            s.Tmat = obj.preprocessData.connecMaterial ;

            c = StrainStressComputer(s) ;
            [eps,sig] = c.compute() ;
            obj.epsilon = eps ;
            obj.sigma = sig ;
        end

        function sig_cr = computeBuckling(obj)
            % Buckling
            s.n_el = obj.dimensions.n_el ;
            s.Td = obj.connecDofs ;
            s.x = obj.preprocessData.coord ;
            s.Tn = obj.preprocessData.connec ;
            s.mat = obj.preprocessData.material ;
            c = BucklingComputer(s) ;
            sig_cr = c.compute() ;
            obj.sigma_cr = sig_cr ;
        end

    end

end