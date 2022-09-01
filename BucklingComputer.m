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
            nElm = obj.n_el ;
            connecDOF = obj.Td ;
            coord = obj.x ;
            connec = obj.Tn ;
            material = obj.mat ;

                     
            
            sig_cr = zeros(nElm,1) ;
            
            for i = 1:nElm 
                x1 = coord(connec(i,1),1) ;
                y1 = coord(connec(i,1),2) ;
                x2 = coord(connec(i,2),1) ;
                y2 = coord(connec(i,2),2) ;
            
                l = ((x2-x1)^2+(y2-y1)^2)^0.5 ;
                sig_cr(i) = pi^2 * material(1) * material(4) / (l^2 * material(2)) ;
            
            end
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
    end
end