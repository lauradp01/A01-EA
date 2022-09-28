classdef StressComputer < handle
    properties (Access = private)
        dimensions 
        preprocessData 
        iMat
        eps
        displacements
    end

    properties (Access = private)
        sigma
    end

    methods (Access = public)
        function obj = StressComputer(cParams)
            obj.init(cParams) ;
        end

        function sig = compute(obj)
            obj.computeStress() ;
            sig = obj.sigma ;
        end

        function plotSigma(obj)
            obj.plotStress() ;
            obj.plotDeformedStress() ;
        end
    end

    methods (Access = private)
        function init(obj,cParams)
            obj.dimensions = cParams.dimensions ;
            obj.preprocessData = cParams.preprocessData ;
            obj.iMat = cParams.iMat ;
            obj.eps = cParams.eps ;
            obj.displacements = cParams.displacements ;
        end

        function sig = computeStress(obj)
            nElement = obj.dimensions.n_el ;
            mat = obj.preprocessData.material ;
            iMaterial = obj.iMat ;
            epsilon = obj.eps ;
            sig = zeros(nElement,1) ;
            for iElem = 1:nElement
                    sig(iElem) = mat(iMaterial,1) * epsilon(iElem) ;
            end
            obj.sigma = sig ;
        end

        function plotStress(obj)       
            s.n_d = obj.dimensions.n_d ;
            s.a = obj.sigma ;
            s.x = obj.preprocessData.coord ;
            s.Tn = obj.preprocessData.connec ;
            s.title_name = 'Stress' ;
            c = StrainStressGraph(s) ;
            c.plot() ;
        end

        function plotDeformedStress(obj)            
            s.x = obj.preprocessData.coord ;
            s.Tn = obj.preprocessData.connec ;
            s.u = obj.displacements ;
            s.sig = obj.sigma ;
            s.scale = 10 ;
            c = StressDefGraph(s) ;
            c.plot() ;
        end         
    end
end