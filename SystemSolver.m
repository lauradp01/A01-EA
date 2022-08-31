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
            freeDOF = obj.vL ;
            prescribedDOF = obj.vR ;
            prescribedDispl = obj.uR ;
            
            [uL, RR] = computeVectors(obj) ;
           
            u = zeros(size(prescribedDOF,1)+size(freeDOF,1),1) ; 
            R = zeros(size(prescribedDOF,1)+size(freeDOF,1),1) ; 
            
            u(freeDOF,1) = uL ;
            u(prescribedDOF,1) = prescribedDispl ; 
            R(prescribedDOF,1) = RR ; 
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

       
        function [uL, RR] = computeVectors(obj)
            freeDOF = obj.vL ;
            prescribedDispl = obj.uR ;
            prescribedDOF = obj.vR ;
            stiffnessMat = obj.KG ;
            extForce = obj.Fext ;

            KLL = stiffnessMat(freeDOF,freeDOF) ;
            KLR = stiffnessMat(freeDOF,prescribedDOF) ;
            KRL = stiffnessMat(prescribedDOF,freeDOF) ;
            KRR = stiffnessMat(prescribedDOF,prescribedDOF) ;
            Fext_L = extForce(freeDOF,1) ;
            Fext_R = extForce(prescribedDOF,1) ;

            uL = KLL\(Fext_L-KLR*prescribedDispl) ;
            RR = KRR*prescribedDispl + KRL*uL - Fext_R ;
        end
    end
end