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
                   
            
            uDirect = computeDirect(obj) ;
            uIterative = computeIterative(obj) ;
            
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

        function uDirect = computeDirect(obj)
            freeDOF = obj.vL ;
            prescribedDOF = obj.vR ;
            prescribedDispl = obj.uR ;
            StiffMat = obj.KG ;
            Forces = obj.Fext ;

            KLL = StiffMat(freeDOF,freeDOF) ;
            KLR = StiffMat(freeDOF,prescribedDOF) ;
            KRL = StiffMat(prescribedDOF,freeDOF) ;
            KRR = StiffMat(prescribedDOF,prescribedDOF) ;
            Fext_L = Forces(freeDOF,1) ;
            Fext_R = Forces(prescribedDOF,1) ;


            solverDirect = Solver.chooseMode("Direct"); 
            uLDirect = solverDirect.system((Fext_L-KLR*prescribedDispl),KLL) ;
            
            RR = KRR*prescribedDispl + KRL*uLDirect - Fext_R ;
            
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

            
            KLL = StiffMat(freeDOF,freeDOF) ;
            KLR = StiffMat(freeDOF,prescribedDOF) ;
            KRL = StiffMat(prescribedDOF,freeDOF) ;
            KRR = StiffMat(prescribedDOF,prescribedDOF) ;
            Fext_L = Forces(freeDOF,1) ;
            Fext_R = Forces(prescribedDOF,1) ;


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