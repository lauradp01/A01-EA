classdef SolverPreparationComputer < handle
    properties (Access = private)
        vL
        vR
        uR
        KG
        Fext
        solverType
    end
    properties (Access = private)
        splittedK
        extF
        uLdisp
    end

    methods (Access = public)
        function obj = SolverPreparationComputer(cParams)
            obj.init(cParams) ;
        end

        function [K,F,uL] = compute(obj)
            obj.splitStiffnessMatrix() ;
            obj.createFext() ;
            obj.computeFreeDisp() ;
            K = obj.splittedK ;
            F = obj.extF ;
            uL = obj.uLdisp ;
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
        end

        function splitStiffnessMatrix(obj)
            freeDOF = obj.vL ;
            prescribedDOF = obj.vR ;
            StiffMat = obj.KG;
            K.KLL = StiffMat(freeDOF,freeDOF) ;
            K.KLR = StiffMat(freeDOF,prescribedDOF) ;
            K.KRL = StiffMat(prescribedDOF,freeDOF) ;
            K.KRR = StiffMat(prescribedDOF,prescribedDOF) ;
            obj.splittedK = K ;
        end

        function createFext(obj)
            freeDOF = obj.vL ;
            prescribedDOF = obj.vR ;
            Forces = obj.Fext;
            F.Fext_L = Forces(freeDOF,1) ;
            F.Fext_R = Forces(prescribedDOF,1) ;
            obj.extF = F ;
        end

        function computeFreeDisp(obj)
            obj.splitStiffnessMatrix() ;
            obj.createFext() ;
            prescribedDispl = obj.uR ;
            K = obj.splittedK ;
            F = obj.extF ;
            solver = Solver.chooseMode(obj.solverType);
            uL = solver.system((F.Fext_L-K.KLR*prescribedDispl),K.KLL) ;
            obj.uLdisp = uL ;
        end
    end
end