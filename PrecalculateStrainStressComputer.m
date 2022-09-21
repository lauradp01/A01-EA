classdef PrecalculateStrainStressComputer < handle
    properties (Access = private)
        deltaT
        n_el
        u
        Td
        preprocessData
    end
    properties (Access = private)
        precalculateStrainStress
    end

    methods (Access = public)
        function obj = PrecalculateStrainStressComputer(cParams)
            obj.init(cParams) ;
        end

        function precalculateStrainStress = compute(obj)
            obj.computeCoordinates() ;
            obj.computeLength() ;
            obj.computeMaterial() ;
            obj.computeLocalDisp() ;
            precalculateStrainStress = obj.precalculateStrainStress ;
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

         function co = computeCoordinates(obj)
            nElem = obj.n_el ;
            coord = obj.preprocessData.coord ;
            connec = obj.preprocessData.connec ;

             for i = 1:nElem
                co.x1(i) = coord(connec(i,1),1) ;
                co.y1(i) = coord(connec(i,1),2) ;
                co.x2(i) = coord(connec(i,2),1) ;
                co.y2(i) = coord(connec(i,2),2) ;
             end
             obj.precalculateStrainStress.coordinates = co;
        end

        function computeLength(obj) 
            nElem = obj.n_el ;
            co = obj.precalculateStrainStress.coordinates;
            l = zeros(nElem,1) ;
            for i = 1:nElem
                l(i) = ((co.x2(i)-co.x1(i))^2+(co.y2(i)-co.y1(i))^2)^0.5 ;
            end
            obj.precalculateStrainStress.length = l;
        end

       function iMaterial = computeMaterial(obj)
            connecMaterial = obj.preprocessData.connecMaterial ;
            nElem = obj.n_el ;
            for i = 1:nElem
                iMaterial = connecMaterial(i) ; 
            end
            obj.precalculateStrainStress.iMat = iMaterial ;
       end
       function R = computeRotationMatrix(obj,iElem)
            obj.computeCoordinates() ;
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
            obj.precalculateStrainStress.localDisp = u_e_l ;
        end
    end
end