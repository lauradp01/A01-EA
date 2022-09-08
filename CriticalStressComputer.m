classdef CriticalStressComputer < handle
    properties (Access = private)
        displacements
        incrementT
        dimensions
        connecDofs
        coord
        connec
        material
        connecMaterial
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
            obj.coord = cParams.coord ;
            obj.connec = cParams.connec ;
            obj.material = cParams.material ;
            obj.connecMaterial = cParams.connecMaterial ;
        end

        function [eps,sig] = computeStrainStress(obj)
            % Compute strain and stresses
            s.deltaT = obj.incrementT ;
            s.n_el = obj.dimensions.n_el ;
            s.u = obj.displacements ;
            s.Td = obj.connecDofs ;
            s.x = obj.coord ;
            s.Tn = obj.connec ;
            s.mat = obj.material ;
            s.Tmat = obj.connecMaterial ;

            c = StrainStressComputer(s) ;
            [eps,sig] = c.compute() ;
            obj.epsilon = eps ;
            obj.sigma = sig ;
        end

        function sig_cr = computeBuckling(obj)
            % Buckling
            s.n_el = obj.dimensions.n_el ;
            s.Td = obj.connecDofs ;
            s.x = obj.coord ;
            s.Tn = obj.connec ;
            s.mat = obj.material ;
            c = BucklingComputer(s) ;
            sig_cr = c.compute() ;
            obj.sigma_cr = sig_cr ;
        end

    end
end