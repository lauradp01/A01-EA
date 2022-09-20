
classdef ReactionsComputer < handle
  
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
        function obj = ReactionsComputer(cParams)
            obj.init(cParams) ;
        end 

        function R = compute(obj)
            R = obj.computeReactions() ;    
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

        function RR = computeRR(obj)
            obj.computeSolverPreparation() ;
            prescribedDispl = obj.uR ;
            uL = obj.uLdisp ;
            K = obj.splittedK ;
            F = obj.extF ;
            RR = K.KRR*prescribedDispl + K.KRL*uL - F.Fext_R ;
        end

        function R = computeReactions(obj)
            freeDOF = obj.vL ;
            prescribedDOF = obj.vR ;
            RR = obj.computeRR() ;
            R = zeros(size(prescribedDOF,1)+size(freeDOF,1),1) ; 
            R(prescribedDOF,1) = RR ;
        end
    end
end