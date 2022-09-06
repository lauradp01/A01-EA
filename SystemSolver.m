
classdef SystemSolver < handle
  
    properties (Access = private)
        vL
        vR
        uR
        KG
        Fext
    end

    methods (Access = public)
        function obj = SystemSolver(cParams)
            obj.init(cParams) ;
        end 

        function [u,R] = compute(obj)
            u = obj.computeDisplacements() ;
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
        end

        function K = splitStiffnessMatrix(obj) 
            stiffnessMat = obj.KG ;
            freeDOF = obj.vL ;
            prescribedDOF = obj.vR ;
            K.KLL = stiffnessMat(freeDOF,freeDOF) ;
            K.KLR = stiffnessMat(freeDOF,prescribedDOF) ;
            K.KRL = stiffnessMat(prescribedDOF,freeDOF) ;
            K.KRR = stiffnessMat(prescribedDOF,prescribedDOF) ;
        end

        function F = createFext(obj) 
            extForce = obj.Fext ;
            freeDOF = obj.vL ;
            prescribedDOF = obj.vR ;
            F.Fext_L = extForce(freeDOF,1) ;
            F.Fext_R = extForce(prescribedDOF,1) ;
        end
       
        function uL = computeuL(obj)
            prescribedDispl = obj.uR ;
            K = obj.splitStiffnessMatrix() ;
            F = obj.createFext() ;
            uL = K.KLL\(F.Fext_L-K.KLR*prescribedDispl) ;
        end

        function RR = computeRR(obj)
            prescribedDispl = obj.uR ;
            uL = obj.computeuL() ;
            K = obj.splitStiffnessMatrix() ;
            F = obj.createFext() ;
            RR = K.KRR*prescribedDispl + K.KRL*uL - F.Fext_R ;
        end

        function u = computeDisplacements(obj)
            freeDOF = obj.vL ;
            prescribedDOF = obj.vR ;
            prescribedDispl = obj.uR ;
            uL = obj.computeuL() ;
            u = zeros(size(prescribedDOF,1)+size(freeDOF,1),1) ; 
            u(freeDOF,1) = uL ;
            u(prescribedDOF,1) = prescribedDispl ; 
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