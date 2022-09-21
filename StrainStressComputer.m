classdef StrainStressComputer < handle
   properties (Access = private)
        deltaT
        n_el
        u
        Td
        preprocessData
    end

    properties (Access = private)
        coordinates
        length
        precalculateStrainStress
    end

    methods (Access = public)
        function obj = StrainStressComputer(cParams)
            obj.init(cParams) ;
        end

        function [eps,sig] = compute(obj)
            eps = obj.computeEps() ;
            sig = obj.computeSig() ;
        end
    end

    methods (Access = private)
        function init(obj,cParams)
            obj.deltaT = cParams.deltaT ;
            obj.n_el = cParams.n_el ;
            obj.u = cParams.u ;
            obj.Td = cParams.Td ;
            obj.preprocessData = cParams.preprocessData ;
        end

        function computePrecalculation(obj)
            s.deltaT = obj.deltaT ;
            s.n_el = obj.n_el ;
            s.u = obj.u ;
            s.Td = obj.Td ;
            s.preprocessData = obj.preprocessData ;
            c = PrecalculateStrainStressComputer(s) ;
            obj.precalculateStrainStress = c.compute() ;
        end

        function R = computeRotationMatrix(obj,iElem)
            obj.computePrecalculation() ;
            x1 = obj.precalculateStrainStress.coordinates.x1(iElem);
            x2 = obj.precalculateStrainStress.coordinates.x2(iElem);
            y1 = obj.precalculateStrainStress.coordinates.y1(iElem);
            y2 = obj.precalculateStrainStress.coordinates.y2(iElem);
            l  = obj.precalculateStrainStress.length(iElem);
            s = (y2-y1)/l;
            c = (x2-x1)/l;
            R = [c s 0 0 ;
                -s c 0 0 ;
                0 0 c s ;
                0 0 -s c] ;
        end

        function u_e = computeGlobalDisp(obj,iElem,j)
            displacements = obj.u ;
            connecDOFs = obj.Td ;
            I = connecDOFs(iElem,j) ;
            u_e = displacements(I) ;
        end

        function u_e_l = computeLocalDisp(obj)
            nElem = obj.n_el ;
            connecDOFs = obj.Td ;
            n_el_dof = size(connecDOFs,2) ;
            u_e_l = zeros(n_el_dof,nElem) ;
            u_e = zeros(n_el_dof,1) ;
            for iElem = 1:nElem
                R = obj.computeRotationMatrix(iElem) ;
                for j = 1:n_el_dof
                    u_e(j,1) = obj.computeGlobalDisp(iElem,j) ;
                end
                u_e_l(:,iElem) = R*u_e ;
            end            
        end

        function eps = computeEps(obj)
            obj.computePrecalculation() ;
            nElem = obj.n_el ;
            incrementT = obj.deltaT ;
            material = obj.preprocessData.material ;
            iMat = obj.precalculateStrainStress.iMat ;
            u_e_l = obj.computeLocalDisp() ;
            eps = zeros(nElem,1) ;
            for iElem = 1:nElem
                l = obj.precalculateStrainStress.length ;
                eps(iElem) = [-1 0 1 0] * u_e_l(:,iElem) / l(iElem) + incrementT*material(iMat,3);
            end
        end

        function sig = computeSig(obj)
            obj.computePrecalculation() ;
            nElem = obj.n_el ;
            material = obj.preprocessData.material ;
            iMat = obj.precalculateStrainStress.iMat ; 
            eps = obj.computeEps() ;
            sig = zeros(nElem,1) ;
            for iElem = 1:nElem
                    sig(iElem) = material(iMat,1) * eps(iElem) ;
            end
        end
    end
end
