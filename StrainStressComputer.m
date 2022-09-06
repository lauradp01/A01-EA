
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
        end

        function [l,s,c] = computeData(obj) 
            nElem = obj.n_el ;
            co = obj.computeCoordinates() ;
            for i = 1:nElem
                l(i) = ((co.x2(i)-co.x1(i))^2+(co.y2(i)-co.y1(i))^2)^0.5 ;
                s(i) = (co.y2(i)-co.y1(i))/l(i) ;
                c(i) = (co.x2(i)-co.x1(i))/l(i) ;
            end
        end

%         function R = computeRotationMat(obj)
%             nElem = obj.n_el ;
%             [s,c] = obj.computeData() ;
%             for i = nElem
%                 R(:,:,i) = [c s 0 0 ;
%                     -s c 0 0 ;
%                     0 0 c s ;
%                     0 0 -s c
%                     ] ;
%             end
%         end


        function iMat = computeMaterial(obj)
            connecMaterial = obj.Tmat ;
            nElem = obj.n_el ;
            for i = 1:nElem
                iMat = connecMaterial(i) ; 
            end
        end

        function eps = computeEps(obj)
            nElem = obj.n_el ;
            incrementT = obj.deltaT ;
            material = obj.mat ;
            displacements = obj.u ;
            connecDOFs = obj.Td ;

            n_el_dof = size(connecDOFs,2) ;

            iMat = obj.computeMaterial() ;
            
            eps = zeros(nElem,1) ;
            u_e = zeros(n_el_dof,1) ;
            [l,s,c] = obj.computeData() ;

            for i = 1:nElem
                R = [c(i) s(i) 0 0 ;
                    -s(i) c(i) 0 0 ;
                    0 0 c(i) s(i) ;
                    0 0 -s(i) c(i)
                    ] ;
                for j = 1:n_el_dof
                    I = connecDOFs(i,j) ;
                    u_e(j,1) = displacements(I) ;
                end
                u_e_l = R*u_e ;
                eps(i) = [-1 0 1 0] * u_e_l / l(i) + incrementT*material(iMat,3);
            end
        end
        
        function sig = computeSig(obj)
            nElem = obj.n_el ;
            material = obj.mat ;
            iMat = obj.computeMaterial() ;
            eps = obj.computeEps() ;
            sig = zeros(nElem,1) ;
            for i = 1:nElem
                    sig(i) = material(iMat,1) * eps(i) ;
            end
        end

    end

end

   


