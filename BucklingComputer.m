classdef BucklingComputer < handle
    properties (Access = private)
        n_el
        Td
        x
        Tn
        mat
    end

    methods (Access = public)
        function obj = BucklingComputer(cParams)
            obj.init(cParams) ;
        end

        function sig_cr = compute(obj)
            sig_cr = obj.computeSig_cr() ;
        end
    end

    methods (Access = private)
        function init(obj,cParams)
            obj.n_el = cParams.n_el ;
            obj.Td = cParams.Td ;
            obj.x = cParams.x ;
            obj.Tn = cParams.Tn ;
            obj.mat = cParams.mat ;
        end

        function co = createCoordinates(obj) 
            nElem = obj.n_el ;
            connec = obj.Tn ;
            coord = obj.x ;
            for i = 1:nElem 
                co.x1(i) = coord(connec(i,1),1) ;
                co.y1(i) = coord(connec(i,1),2) ;
                co.x2(i) = coord(connec(i,2),1) ;
                co.y2(i) = coord(connec(i,2),2) ;
            end
        end

        function l = calcLength(obj)
            nElem = obj.n_el ;
            co = obj.createCoordinates() ;
            for i = 1:nElem
                l(i) = ((co.x2(i)-co.x1(i))^2+(co.y2(i)-co.y1(i))^2)^0.5 ;
            end
        end

        function sig_cr = computeSig_cr(obj)
            material = obj.mat ;
            nElem = obj.n_el ;
            l = obj.calcLength() ;
            sig_cr = zeros(nElem,1) ;

            for i = 1:nElem
                sig_cr(i) = pi^2 * material(1) * material(4) / (l(i)^2 * material(2)) ;
            end
        end
    end

end