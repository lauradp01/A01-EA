classdef SolverPreparationComputer < handle
    properties (Access = private)
        vL
        vR
        uR
        KG
        Fext
        solverType
        necessaryData
    end
    properties (Access = private)
        splittedK
        extF
        uLdisp
        displacements
        reactions
    end
    methods (Access = public)
        function obj = SolverPreparationComputer(cParams)
            obj.init(cParams) ;
        end
        function  [u,R] = compute(obj)
            obj.computeDisplacements() ;
            obj.computeReactions() ;
            u = obj.displacements ;
            R = obj.reactions ;
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
            obj.necessaryData = cParams.necessaryData ;
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
        function u = computeDisplacements(obj)
            obj.computeFreeDisp() ;
            s.dimensions = obj.necessaryData.dimensions ;
            s.preprocessData = obj.necessaryData.preprocessData ;
            s.vL = obj.vL ;
            s.vR = obj.vR ;
            s.uR = obj.uR ;
            s.KG = obj.KG ;
            s.Fext = obj.Fext ;
            s.solverType = obj.solverType;
            s.uLdisp = obj.uLdisp ;
            c = DisplacementsComputer(s) ;
            [u] = c.compute() ;
            c.plotDisplacements() ;
            obj.displacements = u ;
        end
        function R = computeReactions(obj)
            s.vL = obj.vL ;
            s.vR = obj.vR ;
            s.uR = obj.uR ;
            s.KG = obj.KG ;
            s.Fext = obj.Fext ;
            s.solverType = obj.solverType ;
            s.uLdisp = obj.uLdisp ;
            s.splittedK = obj.splittedK ;
            s.extF = obj.extF ;  
            c = ReactionsComputer(s) ;
            R = c.compute() ;
            obj.reactions = R ;
        end
    end
end