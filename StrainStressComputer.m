
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
            incrementT = obj.deltaT ;
            nElem = obj.n_el ;
            displacements = obj.u ;
            connecDOFs = obj.Td ;
            coord = obj.x ;
            connec = obj.Tn ;
            material = obj.mat ;
            connecMaterial = obj.Tmat ;

            n_el_dof = size(connecDOFs,2) ;
            u_e = zeros(n_el_dof,1) ;
            
            eps = zeros(nElem,1) ;
            sig = zeros(nElem,1) ;
            
            for i = 1:nElem 
                x1 = coord(connec(i,1),1) ;
                y1 = coord(connec(i,1),2) ;
                x2 = coord(connec(i,2),1) ;
                y2 = coord(connec(i,2),2) ;
            
                l = ((x2-x1)^2+(y2-y1)^2)^0.5 ;
                s = (y2-y1)/l ;
                c = (x2-x1)/l ;
                R = [c s 0 0 ;
                    -s c 0 0 ;
                    0 0 c s ;
                    0 0 -s c
                    ] ;
                for j = 1:n_el_dof
                    I = connecDOFs(i,j) ;
                    u_e(j,1) = displacements(I) ;
                end
                u_e_l = R*u_e ;
                
                iMat = connecMaterial(i) ; 
                
                eps(i) = [-1 0 1 0] * u_e_l / l + incrementT*material(iMat,3);
                sig(i) = material(iMat,1) * eps(i) ;
            
            end
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


        
    end

end

   


