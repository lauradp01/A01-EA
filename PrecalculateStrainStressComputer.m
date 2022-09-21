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

        
        
    end
end