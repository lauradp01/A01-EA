classdef StrainStressComputer < handle
   
    properties (Access = private)
        deltaT
        n_el
        u
        Td
        x
        Tn
        mat
        Tmat
    end

    properties (Access = private)
        coordinates
        length
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
            obj.x = cParams.x ;
            obj.Tn = cParams.Tn ;
            obj.mat = cParams.mat ;
            obj.Tmat = cParams.Tmat ;
        end

        function co = computeCoordinates(obj)
            nElem = obj.n_el ;
            coord = obj.x ;
            connec = obj.Tn ;

             for i = 1:nElem
                co.x1(i) = coord(connec(i,1),1) ;
                co.y1(i) = coord(connec(i,1),2) ;
                co.x2(i) = coord(connec(i,2),1) ;
                co.y2(i) = coord(connec(i,2),2) ;
             end
             obj.coordinates = co;
        end

        function computeLength(obj) 
            nElem = obj.n_el ;
            co = obj.coordinates;
            l = zeros(nElem,1) ;
            for i = 1:nElem
                l(i) = ((co.x2(i)-co.x1(i))^2+(co.y2(i)-co.y1(i))^2)^0.5 ;
            end
            obj.length = l;
        end

        function R = computeRotationMatrix(obj,iElem)
            obj.computeCoordinates() ;
            obj.computeLength() ;
            x1 = obj.coordinates.x1(iElem);
            x2 = obj.coordinates.x2(iElem);
            y1 = obj.coordinates.y1(iElem);
            y2 = obj.coordinates.y2(iElem);
            l  = obj.length(iElem);
            s = (y2-y1)/l;
            c = (x2-x1)/l;
            R = [c s 0 0 ;
                -s c 0 0 ;
                0 0 c s ;
                0 0 -s c] ;
        end


        function iMat = computeMaterial(obj)
            connecMaterial = obj.Tmat ;
            nElem = obj.n_el ;
            for i = 1:nElem
                iMat = connecMaterial(i) ; 
            end
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
            nElem = obj.n_el ;
            incrementT = obj.deltaT ;
            material = obj.mat ;
            

            iMat = obj.computeMaterial() ;
            u_e_l = obj.computeLocalDisp() ;

            eps = zeros(nElem,1) ;
            for iElem = 1:nElem
                l = obj.length ;
                eps(iElem) = [-1 0 1 0] * u_e_l(:,iElem) / l(iElem) + incrementT*material(iMat,3);
            end
        end

        function sig = computeSig(obj)
            nElem = obj.n_el ;
            material = obj.mat ;
            iMat = obj.computeMaterial() ;
            eps = obj.computeEps() ;
            sig = zeros(nElem,1) ;
            for iElem = 1:nElem
                    sig(iElem) = material(iMat,1) * eps(iElem) ;
            end
        end

    end


end

   


