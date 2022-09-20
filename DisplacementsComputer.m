classdef DisplacementsComputer < handle
    properties (Access = private)
        vL
        vR
        uR
        KG
        Fext
        solverType
        uLdisp
    end
    
    methods (Access = public)
        function obj = DisplacementsComputer(cParams)
            obj.init(cParams) ;
        end

        function u = compute(obj)
            u = obj.computeDisp() ;
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
        end

        function u = computeDisp(obj)
            freeDOF = obj.vL ;
            prescribedDOF = obj.vR ;
            prescribedDispl = obj.uR ;
            u = zeros(size(prescribedDOF,1)+size(freeDOF,1),1) ;
            uL = obj.uLdisp ;
            u(freeDOF,1) = uL ;
            u(prescribedDOF,1) = prescribedDispl ;
        end
    end

end