
classdef DisplacementsComputer < handle

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
        end

%         function K = splitStiffnessMatrix(obj)
%             freeDOF = obj.vL ;
%             prescribedDOF = obj.vR ;
%             StiffMat = obj.KG;
%             K.KLL = StiffMat(freeDOF,freeDOF) ;
%             K.KLR = StiffMat(freeDOF,prescribedDOF) ;
%             K.KRL = StiffMat(prescribedDOF,freeDOF) ;
%             K.KRR = StiffMat(prescribedDOF,prescribedDOF) ;
%         end
% 
%         function F = createFext(obj)
%             freeDOF = obj.vL ;
%             prescribedDOF = obj.vR ;
%             Forces = obj.Fext;
%             F.Fext_L = Forces(freeDOF,1) ;
%             F.Fext_R = Forces(prescribedDOF,1) ;
%         end
% 
%         function uL = computeFreeDisp(obj)
%             prescribedDispl = obj.uR ;
%             K = obj.splitStiffnessMatrix() ;
%             F = obj.createFext() ;
%             solver = Solver.chooseMode(obj.solverType);
%             uL = solver.system((F.Fext_L-K.KLR*prescribedDispl),K.KLL) ;
%         end

        function computeSolverPreparation(obj)
            s.vL = obj.vL ;
            s.vR = obj.vR ;
            s.uR = obj.uR ;
            s.KG = obj.KG ;
            s.Fext = obj.Fext ;
            s.solverType = obj.solverType;
            c = SolverPreparationComputer(s) ;
            [K,F,uL] = c.compute() ;
            obj.splittedK = K ;
            obj.extF = F ;
            obj.uLdisp = uL ;
        end

        function u = computeDisp(obj)
            obj.computeSolverPreparation() ;
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