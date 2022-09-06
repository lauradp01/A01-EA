classdef DirectOrIterative < handle
    %UNTITLED11 Summary of this class goes here
    %   Detailed explanation goes here

    properties (Access = private)
        vL
        vR
        uR
        KG
        Fext
    end

    methods (Access = public)
        function obj = DirectOrIterative(cParams)
            obj.init(cParams) ;
        end

        function [uDirect, uIterative] = compute(obj)
            uDirect = obj.computeDirect() ;
            uIterative = obj.computeIterative() ;
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
            freeDOF = obj.vL ;
            prescribedDOF = obj.vR ;
            K.KLL = StiffMat(freeDOF,freeDOF) ;
            K.KLR = StiffMat(freeDOF,prescribedDOF) ;
            K.KRL = StiffMat(prescribedDOF,freeDOF) ;
            K.KRR = StiffMat(prescribedDOF,prescribedDOF) ;
        end

        function F = createFext(obj)
            freeDOF = obj.vL ;
            prescribedDOF = obj.vR ;
            F.Fext_L = Forces(freeDOF,1) ;
            F.Fext_R = Forces(prescribedDOF,1) ;
        end

        function uDirect = computeDirect(obj)
            freeDOF = obj.vL ;
            prescribedDOF = obj.vR ;
            prescribedDispl = obj.uR ;sii

            K = obj.splitStiffnessMatrix() ;
            F = obj.createFext() ;
            


            solverDirect = Solver.chooseMode("Direct"); 
            uLDirect = solverDirect.system((F.Fext_L-K.KLR*prescribedDispl),K.KLL) ;
            
            RR = K.KRR*prescribedDispl + K.KRL*uLDirect - F.Fext_R ;
            
            uDirect = zeros(size(prescribedDOF,1)+size(freeDOF,1),1) ; 
            R = zeros(size(prescribedDOF,1)+size(freeDOF,1),1) ; 
            
            uDirect(freeDOF,1) = uLDirect ;
            uDirect(prescribedDOF,1) = prescribedDispl ; 
            R(prescribedDOF,1) = RR ; 
        end

        function uIterative = computeIterative(obj)
            freeDOF = obj.vL ;
            prescribedDOF = obj.vR ;
            prescribedDispl = obj.uR ;
            StiffMat = obj.KG ;
            Forces = obj.Fext ;

            K = obj.splitStiffnessMatrix() ;
            F = obj.createFext() ;
            


            solverDirect = Solver.chooseMode("Iterative"); 
            uLIterative = solverDirect.system((Fext_L-KLR*prescribedDispl),KLL) ;
            
            RR = KRR*prescribedDispl + KRL*uLIterative - Fext_R ;
            
            uIterative = zeros(size(prescribedDOF,1)+size(freeDOF,1),1) ; 
            R = zeros(size(prescribedDOF,1)+size(freeDOF,1),1) ; 
            
            uIterative(freeDOF,1) = uLIterative ;
            uIterative(prescribedDOF,1) = prescribedDispl ; 
            R(prescribedDOF,1) = RR ; 

        end
    end

end