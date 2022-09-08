classdef PlotComputer < handle
    
    properties (Access = private)
        dimensions
        displacements
        coord
        connec
        epsilon
        sigma
    end

    methods (Access = public)
        function obj = PlotComputer(cParams)
            obj.init(cParams) ;
        end

        function plot(obj)
            obj.plotDisplacements() ;
            obj.plotStrain() ;
            obj.plotStress() ;
            obj.plotDeformedStress ;
        end
    end

    methods (Access = private)
        function init(obj,cParams)
            obj.dimensions = cParams.dimensions ;
            obj.displacements = cParams.displacements ;
            obj.coord = cParams.coord ;
            obj.connec = cParams.connec ;
            obj.epsilon = cParams.epsilon ;
            obj.sigma = cParams.sigma ;
        end
        
        function plotDisplacements(obj)
            s.n_d = obj.dimensions.n_d ;
            s.n = obj.dimensions.n ;
            s.u = obj.displacements ;
            s.x = obj.coord ;
            s.Tn = obj.connec;
            s.fact = 1 ;
            c = DisplacementGraph(s) ;
            c.plot() ;
        end

        function plotStrain(obj)
            % Plot strain
            s.n_d = obj.dimensions.n_d ;
            s.a = obj.epsilon ;
            s.x = obj.coord ;
            s.Tn = obj.connec ;
            s.title_name = 'Strain' ;
            c = StrainStressGraph(s) ;
            c.plot() ;
        end

        function plotStress(obj)            
            % Plot stress
            s.n_d = obj.dimensions.n_d ;
            s.a = obj.sigma ;
            s.x = obj.coord ;
            s.Tn = obj.connec ;
            s.title_name = 'Stress' ;
            c = StrainStressGraph(s) ;
            c.plot() ;
        end

        function plotDeformedStress(obj)            
            % Plot stress in defomed mesh
            s.x = obj.coord ;
            s.Tn = obj.connec ;
            s.u = obj.displacements ;
            s.sig = obj.sigma ;
            s.scale = 10 ;
            c = StressDefGraph(s) ;
            c.plot() ;
        end

    end
end