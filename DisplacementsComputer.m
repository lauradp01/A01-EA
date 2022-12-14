classdef DisplacementsComputer < handle
    properties (Access = private)
        vL
        vR
        uR
        KG
        Fext
        solverType
        uLdisp
        preprocessData
        dimensions
    end

    properties (Access = private)
        displacements
    end
    
    methods (Access = public)
        function obj = DisplacementsComputer(cParams)
            obj.init(cParams) ;
        end

        function u = compute(obj)
            obj.computeDisp() ;
            u = obj.displacements ;
        end

        function plotDisplacements(obj)
            obj.plotDisp() ;
        end
    end

    methods (Access = private)
        function init(obj,cParams)
            obj.vL = cParams.vL ;
            obj.vR = cParams.vR ;
            obj.uR = cParams.uR ;
            obj.KG = cParams.KG ;
            obj.Fext = cParams.Fext ;
            obj.solverType = cParams.solverType;
            obj.uLdisp = cParams.uLdisp ;
            obj.dimensions = cParams.dimensions ;
            obj.preprocessData = cParams.preprocessData ;
        end

        function computeDisp(obj)
            freeDOF = obj.vL ;
            prescribedDOF = obj.vR ;
            prescribedDispl = obj.uR ;
            u = zeros(size(prescribedDOF,1)+size(freeDOF,1),1) ;
            uL = obj.uLdisp ;
            u(freeDOF,1) = uL ;
            u(prescribedDOF,1) = prescribedDispl ;
            obj.displacements = u ;
        end

        function plotDisp(obj)
            s.dimensions = obj.dimensions ;
            s.u = obj.displacements ;
            s.preprocessData = obj.preprocessData ;
            s.fact = 1 ;
            c = DisplacementGraph(s) ;
            c.plot() ;
        end
    end

end